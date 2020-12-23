Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE5772E1BE7
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 12:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728365AbgLWL1N (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 06:27:13 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:58222 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728529AbgLWL1M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 06:27:12 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UJXmaAa_1608722787;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UJXmaAa_1608722787)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Dec 2020 19:26:27 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: [PATCH RFC 7/7] dm: add support for IO polling
Date:   Wed, 23 Dec 2020 19:26:24 +0800
Message-Id: <20201223112624.78955-8-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Enable iopoll when all underlying target devices supports iopoll.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 drivers/md/dm-table.c | 28 ++++++++++++++++++++++++++++
 drivers/md/dm.c       |  1 +
 2 files changed, 29 insertions(+)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 188f41287f18..b0cd5bf58c3c 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1791,6 +1791,31 @@ static bool dm_table_requires_stable_pages(struct dm_table *t)
 	return false;
 }
 
+static int device_supports_poll(struct dm_target *ti, struct dm_dev *dev,
+				sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && test_bit(QUEUE_FLAG_POLL, &q->queue_flags);
+}
+
+static bool dm_table_supports_poll(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned int i;
+
+	/* Ensure that all targets support iopoll. */
+	for (i = 0; i < dm_table_get_num_targets(t); i++) {
+		ti = dm_table_get_target(t, i);
+
+		if (!ti->type->iterate_devices ||
+		    !ti->type->iterate_devices(ti, device_supports_poll, NULL))
+			return false;
+	}
+
+	return true;
+}
+
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 			       struct queue_limits *limits)
 {
@@ -1883,6 +1908,9 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 #endif
 
 	blk_queue_update_readahead(q);
+
+	if (dm_table_supports_poll(t))
+		blk_queue_flag_set(QUEUE_FLAG_POLL, q);
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 03c2b867acaa..ffd2c5ead256 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3049,6 +3049,7 @@ static const struct pr_ops dm_pr_ops = {
 };
 
 static const struct block_device_operations dm_blk_dops = {
+	.iopoll = blk_bio_poll,
 	.submit_bio = dm_submit_bio,
 	.open = dm_blk_open,
 	.release = dm_blk_close,
-- 
2.27.0

