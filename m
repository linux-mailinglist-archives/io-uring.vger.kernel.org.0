Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61719312C8C
	for <lists+io-uring@lfdr.de>; Mon,  8 Feb 2021 09:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230101AbhBHI4Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Feb 2021 03:56:25 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:35915 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230362AbhBHIxi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Feb 2021 03:53:38 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UO9soA7_1612774373;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UO9soA7_1612774373)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Feb 2021 16:52:53 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com, hch@lst.de,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: [PATCH v3 09/11] dm: support IO polling for bio-based dm device
Date:   Mon,  8 Feb 2021 16:52:41 +0800
Message-Id: <20210208085243.82367-10-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

DM will iterate and poll all polling hardware queues of all target mq
devices when polling IO for dm device. To mitigate the race introduced
by iterating all target hw queues, a per-hw-queue flag is maintained
to indicate whether this polling hw queue currently being polled on or
not. Every polling hw queue is exclusive to one polling instance, i.e.,
the polling instance will skip this polling hw queue if this hw queue
currently is being polled by another polling instance, and start
polling on the next hw queue.

IO polling is enabled when all underlying target devices are capable
of IO polling. The sanity check supports the stacked device model, in
which one dm device may be build upon another dm device. In this case,
the mapped device will check if the underlying dm target device
supports IO polling.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/md/dm-table.c         | 26 ++++++++++++++
 drivers/md/dm.c               | 64 +++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h |  1 +
 3 files changed, 91 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index aa37f3e82238..b090b4c9692d 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1764,6 +1764,19 @@ static int device_requires_stable_pages(struct dm_target *ti,
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
+	return dm_table_all_devs_attr(t, device_not_poll_capable, NULL);
+}
+
 /*
  * type->iterate_devices() should be called when the sanity check needs to
  * iterate and check all underlying data devices. iterate_devices() will
@@ -1875,6 +1888,19 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
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
index c2945c90745e..8423f1347bb8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1657,6 +1657,68 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 	return BLK_QC_T_NONE;
 }
 
+static int dm_poll_one_md(struct mapped_device *md);
+
+static int dm_poll_one_dev(struct dm_target *ti, struct dm_dev *dev,
+				sector_t start, sector_t len, void *data)
+{
+	int i, *count = data;
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+	struct blk_mq_hw_ctx *hctx;
+
+	if (queue_is_mq(q)) {
+		if (!percpu_ref_tryget(&q->q_usage_counter))
+			return 0;
+
+		queue_for_each_poll_hw_ctx(q, hctx, i)
+			*count += blk_mq_poll_hctx(q, hctx);
+
+		percpu_ref_put(&q->q_usage_counter);
+	} else
+		*count += dm_poll_one_md(dev->bdev->bd_disk->private_data);
+
+	return 0;
+}
+
+static int dm_poll_one_md(struct mapped_device *md)
+{
+	int i, srcu_idx, ret = 0;
+	struct dm_table *t;
+	struct dm_target *ti;
+
+	t = dm_get_live_table(md, &srcu_idx);
+
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+		ti->type->iterate_devices(ti, dm_poll_one_dev, &ret);
+	}
+
+	dm_put_live_table(md, srcu_idx);
+
+	return ret;
+}
+
+static int dm_bio_poll(struct request_queue *q, blk_qc_t cookie)
+{
+	struct gendisk *disk = queue_to_disk(q);
+	struct mapped_device *md = disk->private_data;
+
+	return dm_poll_one_md(md);
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
@@ -3049,6 +3111,8 @@ static const struct pr_ops dm_pr_ops = {
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

