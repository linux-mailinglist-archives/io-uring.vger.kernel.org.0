Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D18CA312C94
	for <lists+io-uring@lfdr.de>; Mon,  8 Feb 2021 09:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230126AbhBHI4o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 8 Feb 2021 03:56:44 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:41110 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230408AbhBHIxp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 8 Feb 2021 03:53:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R271e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UOAeIP5_1612774375;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UOAeIP5_1612774375)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 08 Feb 2021 16:52:56 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com, hch@lst.de,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: [PATCH v3 11/11] dm: fastpath of bio-based polling
Date:   Mon,  8 Feb 2021 16:52:43 +0800
Message-Id: <20210208085243.82367-12-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Offer one fastpath of bio-based polling when bio submitted to dm device
is not split.

In this case, there will be only one bio submitted to only one polling
hw queue of one underlying mq device, and thus we don't need to track
all split bios or iterate through all polling hw queues. The pointer to
the polling hw queue the bio submitted to is returned here as the
returned cookie. In this case, the polling routine will call
mq_ops->poll() directly with the hw queue converted from the input
cookie.

If the original bio submitted to dm device is split to multiple bios and
thus submitted to multiple polling hw queues, the bio submission routine
will return BLK_QC_T_BIO_MULTI, while the polling routine will fall
back to iterating all hw queues (in polling mode) of all underlying mq
devices.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-core.c          | 33 +++++++++++++++++++++++++++++++--
 include/linux/blk_types.h |  8 ++++++++
 include/linux/types.h     |  2 +-
 3 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 37aa513da5f2..cb24b33a4870 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -956,11 +956,19 @@ static blk_qc_t __submit_bio(struct bio *bio)
  * bio_list_on_stack[0] contains bios submitted by the current ->submit_bio.
  * bio_list_on_stack[1] contains bios that were submitted before the current
  *	->submit_bio_bio, but that haven't been processed yet.
+ *
+ * Return:
+ *   - BLK_QC_T_NONE, no need for IO polling.
+ *   - BLK_QC_T_BIO_MULTI, @bio gets split and enqueued into multi hw queues.
+ *   - Otherwise, @bio is not split, returning the pointer to the corresponding
+ *     hw queue that the bio enqueued into as the returned cookie.
  */
 static blk_qc_t __submit_bio_noacct(struct bio *bio)
 {
 	struct bio_list bio_list_on_stack[2];
 	blk_qc_t ret = BLK_QC_T_NONE;
+	struct request_queue *top_q = bio->bi_disk->queue;
+	bool poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags);
 
 	BUG_ON(bio->bi_next);
 
@@ -968,6 +976,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 	current->bio_list = bio_list_on_stack;
 
 	do {
+		blk_qc_t cookie;
 		struct request_queue *q = bio->bi_disk->queue;
 		struct bio_list lower, same;
 
@@ -980,7 +989,20 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 		bio_list_on_stack[1] = bio_list_on_stack[0];
 		bio_list_init(&bio_list_on_stack[0]);
 
-		ret = __submit_bio(bio);
+		cookie = __submit_bio(bio);
+
+		if (poll_on &&
+		    blk_qc_t_bio_valid(ret) && blk_qc_t_valid(cookie)) {
+			unsigned int queue_num = blk_qc_t_to_queue_num(cookie);
+			struct blk_mq_hw_ctx *hctx = q->queue_hw_ctx[queue_num];
+
+			cookie = (blk_qc_t)hctx;
+
+			if (!blk_qc_t_valid(ret)) /* set initial value */
+				ret = cookie;
+			else if (ret != cookie)   /* bio got split */
+				ret = BLK_QC_T_BIO_MULTI;
+		}
 
 		/*
 		 * Sort new bios into those for a lower level and those for the
@@ -1003,6 +1025,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 	} while ((bio = bio_list_pop(&bio_list_on_stack[0])));
 
 	current->bio_list = NULL;
+
 	return ret;
 }
 
@@ -1142,7 +1165,13 @@ static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	do {
 		int ret;
 
-		ret = disk->fops->poll(q, cookie);
+		if (blk_qc_t_bio_valid(cookie)) {
+			struct blk_mq_hw_ctx *hctx = (struct blk_mq_hw_ctx *)cookie;
+			struct request_queue *target_q = hctx->queue;
+
+			ret = blk_mq_poll_hctx(target_q, hctx);
+		} else
+			ret = disk->fops->poll(q, cookie);
 		if (ret > 0) {
 			__set_current_state(TASK_RUNNING);
 			return ret;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 2e05244fc16d..4173754532c0 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -557,6 +557,14 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
 	return (cookie & BLK_QC_T_INTERNAL) != 0;
 }
 
+/* Macros for blk_qc_t used for bio-based polling */
+#define BLK_QC_T_BIO_MULTI	-2U
+
+static inline bool blk_qc_t_bio_valid(blk_qc_t cookie)
+{
+	return cookie != BLK_QC_T_BIO_MULTI;
+}
+
 struct blk_rq_stat {
 	u64 mean;
 	u64 min;
diff --git a/include/linux/types.h b/include/linux/types.h
index da5ca7e1bea9..f6301014a459 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -126,7 +126,7 @@ typedef u64 sector_t;
 typedef u64 blkcnt_t;
 
 /* cookie used for IO polling */
-typedef unsigned int blk_qc_t;
+typedef uintptr_t blk_qc_t;
 
 /*
  * The type of an index into the pagecache.
-- 
2.27.0

