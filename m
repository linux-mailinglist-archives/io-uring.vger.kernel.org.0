Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBCB0320502
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 12:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbhBTLHn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 06:07:43 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:51489 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229812AbhBTLHe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 06:07:34 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UP1XFyk_1613819210;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UP1XFyk_1613819210)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 19:06:50 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     hch@lst.de, ming.lei@redhat.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com
Subject: [PATCH v4 12/12] dm: support IO polling for bio-based dm device
Date:   Sat, 20 Feb 2021 19:06:37 +0800
Message-Id: <20210220110637.50305-13-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IO polling is enabled when all underlying target devices are capable
of IO polling. The sanity check supports the stacked device model, in
which one dm device may be build upon another dm device. In this case,
the mapped device will check if the underlying dm target device
supports IO polling.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/md/dm-table.c         | 26 ++++++++++++
 drivers/md/dm.c               | 78 +++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  1 +
 3 files changed, 105 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 2bc256d61550..0210ec7a3dee 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1768,6 +1768,19 @@ static int device_requires_stable_pages(struct dm_target *ti,
 	return blk_queue_stable_writes(q);
 }
 
+static int device_not_poll_capable(struct dm_target *ti, struct dm_dev *dev,
+				   sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return !test_bit(QUEUE_FLAG_POLL, &q->queue_flags);
+}
+
+int dm_table_supports_poll(struct dm_table *t)
+{
+	return !dm_table_any_dev_attr(t, device_not_poll_capable, NULL);
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
@@ -1864,6 +1877,19 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 #endif
 
 	blk_queue_update_readahead(q);
+
+	/*
+	 * Check for request-based device is remained to
+	 * dm_mq_init_request_queue()->blk_mq_init_allocated_queue().
+	 * For bio-based device, only set QUEUE_FLAG_POLL when all underlying
+	 * devices supporting polling.
+	 */
+	if (__table_type_bio_based(t->type)) {
+		if (dm_table_supports_poll(t))
+			blk_queue_flag_set(QUEUE_FLAG_POLL, q);
+		else
+			blk_queue_flag_clear(QUEUE_FLAG_POLL, q);
+	}
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index c2945c90745e..5f358efda50f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1657,6 +1657,82 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 	return BLK_QC_T_NONE;
 }
 
+struct dm_poll_data {
+	blk_qc_t cookie;
+	int count;
+};
+
+static void dm_poll_one_md(struct mapped_device *md, struct dm_poll_data *pdata);
+
+static int dm_poll_one_dev(struct dm_target *ti, struct dm_dev *dev,
+				sector_t start, sector_t len, void *data)
+{
+	struct dm_poll_data *pdata = data;
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+	struct blk_mq_hw_ctx *hctx;
+	int i, cpu;
+
+	if (queue_is_mq(q)) {
+		if (!percpu_ref_tryget(&q->q_usage_counter))
+			return 0;
+
+		if (blk_qc_t_is_poll_cpu(pdata->cookie)) {
+			cpu = blk_qc_t_to_cpu(pdata->cookie);
+			hctx = blk_mq_get_hctx(q, cpu, REQ_HIPRI);
+			pdata->count += blk_mq_poll_hctx(q, hctx);
+		} else {
+			queue_for_each_poll_hw_ctx(q, hctx, i)
+				pdata->count += blk_mq_poll_hctx(q, hctx);
+		}
+
+		percpu_ref_put(&q->q_usage_counter);
+	} else
+		dm_poll_one_md(dev->bdev->bd_disk->private_data, pdata);
+
+	return 0;
+}
+
+static void dm_poll_one_md(struct mapped_device *md, struct dm_poll_data *pdata)
+{
+	int i, srcu_idx;
+	struct dm_table *t;
+	struct dm_target *ti;
+
+	t = dm_get_live_table(md, &srcu_idx);
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+		ti->type->iterate_devices(ti, dm_poll_one_dev, pdata);
+	}
+
+	dm_put_live_table(md, srcu_idx);
+}
+
+static int dm_bio_poll(struct request_queue *q, blk_qc_t cookie)
+{
+	struct gendisk *disk = queue_to_disk(q);
+	struct mapped_device *md = disk->private_data;
+	struct dm_poll_data pdata = {
+		.cookie = cookie,
+	};
+
+	dm_poll_one_md(md, &pdata);
+	return pdata.count;
+}
+
+static bool dm_bio_poll_capable(struct gendisk *disk)
+{
+	int ret, srcu_idx;
+	struct mapped_device *md = disk->private_data;
+	struct dm_table *t;
+
+	t = dm_get_live_table(md, &srcu_idx);
+	ret = dm_table_supports_poll(t);
+	dm_put_live_table(md, srcu_idx);
+
+	return ret;
+}
+
 /*-----------------------------------------------------------------
  * An IDR is used to keep track of allocated minor numbers.
  *---------------------------------------------------------------*/
@@ -3049,6 +3125,8 @@ static const struct pr_ops dm_pr_ops = {
 };
 
 static const struct block_device_operations dm_blk_dops = {
+	.poll = dm_bio_poll,
+	.poll_capable = dm_bio_poll_capable,
 	.submit_bio = dm_submit_bio,
 	.open = dm_blk_open,
 	.release = dm_blk_close,
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 61a66fb8ebb3..6a9de3fd0087 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -515,6 +515,7 @@ unsigned int dm_table_get_num_targets(struct dm_table *t);
 fmode_t dm_table_get_mode(struct dm_table *t);
 struct mapped_device *dm_table_get_md(struct dm_table *t);
 const char *dm_table_device_name(struct dm_table *t);
+int dm_table_supports_poll(struct dm_table *t);
 
 /*
  * Trigger an event.
-- 
2.27.0

