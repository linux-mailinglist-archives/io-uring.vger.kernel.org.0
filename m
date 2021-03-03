Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C86C32C5BE
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382454AbhCDAYL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:11 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:52924 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1442240AbhCCL6j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 06:58:39 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UQG29rb_1614772671;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQG29rb_1614772671)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Mar 2021 19:57:51 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     msnitzer@redhat.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, mpatocka@redhat.com,
        caspar@linux.alibaba.com, joseph.qi@linux.alibaba.com
Subject: [PATCH v5 10/12] block: fastpath for bio-based polling
Date:   Wed,  3 Mar 2021 19:57:38 +0800
Message-Id: <20210303115740.127001-11-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Offer one fastpath for bio-based polling when bio submitted to dm
device is not split.

In this case, there will be only one bio submitted to only one polling
hw queue of one underlying mq device, and thus we don't need to track
all split bios or iterate through all polling hw queues. The pointer to
the polling hw queue the bio submitted to is returned here as the
returned cookie. In this case, the polling routine will call
mq_ops->poll() directly with the hw queue converted from the input
cookie.

If the original bio submitted to dm device is split to multiple bios and
thus submitted to multiple polling hw queues, the polling routine will
fall back to iterating all hw queues (in polling mode) of all underlying
mq devices.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-core.c          | 73 +++++++++++++++++++++++++++++++++++++--
 include/linux/blk_types.h | 66 +++++++++++++++++++++++++++++++++--
 include/linux/types.h     |  2 +-
 3 files changed, 135 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 6d7d53030d7c..e5cd4ff08f5c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -947,14 +947,22 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 {
 	struct bio_list bio_list_on_stack[2];
 	blk_qc_t ret = BLK_QC_T_NONE;
+	struct request_queue *top_q;
+	bool poll_on;
 
 	BUG_ON(bio->bi_next);
 
 	bio_list_init(&bio_list_on_stack[0]);
 	current->bio_list = bio_list_on_stack;
 
+	top_q = bio->bi_bdev->bd_disk->queue;
+	poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags) &&
+		  (bio->bi_opf & REQ_HIPRI);
+
 	do {
-		struct request_queue *q = bio->bi_bdev->bd_disk->queue;
+		blk_qc_t cookie;
+		struct block_device *bdev = bio->bi_bdev;
+		struct request_queue *q = bdev->bd_disk->queue;
 		struct bio_list lower, same;
 
 		if (unlikely(bio_queue_enter(bio) != 0))
@@ -966,7 +974,23 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 		bio_list_on_stack[1] = bio_list_on_stack[0];
 		bio_list_init(&bio_list_on_stack[0]);
 
-		ret = __submit_bio(bio);
+		cookie = __submit_bio(bio);
+
+		if (poll_on && blk_qc_t_valid(cookie)) {
+			unsigned int queue_num = blk_qc_t_to_queue_num(cookie);
+			unsigned int devt = bdev_whole(bdev)->bd_dev;
+
+			cookie = blk_qc_t_get_by_devt(devt, queue_num);
+
+			if (!blk_qc_t_valid(ret)) {
+				/* set initial value */
+				ret = cookie;
+			} else if (ret != cookie) {
+				/* bio gets split and enqueued to multi hctxs */
+				ret = BLK_QC_T_BIO_POLL_ALL;
+				poll_on = false;
+			}
+		}
 
 		/*
 		 * Sort new bios into those for a lower level and those for the
@@ -989,6 +1013,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 	} while ((bio = bio_list_pop(&bio_list_on_stack[0])));
 
 	current->bio_list = NULL;
+
 	return ret;
 }
 
@@ -1119,6 +1144,44 @@ blk_qc_t submit_bio(struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio);
 
+static int blk_poll_bio(blk_qc_t cookie)
+{
+	unsigned int devt = blk_qc_t_to_devt(cookie);
+	unsigned int queue_num = blk_qc_t_to_queue_num(cookie);
+	struct block_device *bdev;
+	struct request_queue *q;
+	struct blk_mq_hw_ctx *hctx;
+	int ret;
+
+	bdev = blkdev_get_no_open(devt);
+
+	/*
+	 * One such case is that dm device has reloaded table and the original
+	 * underlying device the bio submitted to has been detached. When
+	 * reloading table, dm will ensure that previously submitted IOs have
+	 * all completed, thus return directly here.
+	 */
+	if (!bdev)
+		return 1;
+
+	q = bdev->bd_disk->queue;
+	hctx = q->queue_hw_ctx[queue_num];
+
+	/*
+	 * Similar to the case described in the above comment, that dm device
+	 * has reloaded table and the original underlying device the bio
+	 * submitted to has been detached. Thus the dev_t stored in cookie may
+	 * be reused by another blkdev, and if that's the case, return directly
+	 * here.
+	 */
+	if (hctx->type != HCTX_TYPE_POLL)
+		return 1;
+
+	ret = blk_mq_poll_hctx(q, hctx);
+
+	blkdev_put_no_open(bdev);
+	return ret;
+}
 
 static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 {
@@ -1129,7 +1192,11 @@ static int blk_bio_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
 	do {
 		int ret;
 
-		ret = disk->fops->poll(q, cookie);
+		if (unlikely(blk_qc_t_is_poll_multi(cookie)))
+			ret = disk->fops->poll(q, cookie);
+		else
+			ret = blk_poll_bio(cookie);
+
 		if (ret > 0) {
 			__set_current_state(TASK_RUNNING);
 			return ret;
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index fb429daaa909..8f970e026be9 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -505,10 +505,19 @@ static inline int op_stat_group(unsigned int op)
 	return op_is_write(op);
 }
 
-/* Macros for blk_qc_t */
+/*
+ * blk_qc_t for request-based mq devices.
+ * 63                    31 30          15          0 (bit)
+ * +----------------------+-+-----------+-----------+
+ * |      reserved        | | queue_num |    tag    |
+ * +----------------------+-+-----------+-----------+
+ *                         ^
+ *                         BLK_QC_T_INTERNAL
+ */
 #define BLK_QC_T_NONE		-1U
 #define BLK_QC_T_SHIFT		16
 #define BLK_QC_T_INTERNAL	(1U << 31)
+#define BLK_QC_T_QUEUE_NUM_SIZE	15
 
 static inline bool blk_qc_t_valid(blk_qc_t cookie)
 {
@@ -517,7 +526,8 @@ static inline bool blk_qc_t_valid(blk_qc_t cookie)
 
 static inline unsigned int blk_qc_t_to_queue_num(blk_qc_t cookie)
 {
-	return (cookie & ~BLK_QC_T_INTERNAL) >> BLK_QC_T_SHIFT;
+	return (cookie >> BLK_QC_T_SHIFT) &
+	       ((1u << BLK_QC_T_QUEUE_NUM_SIZE) - 1);
 }
 
 static inline unsigned int blk_qc_t_to_tag(blk_qc_t cookie)
@@ -530,6 +540,58 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
 	return (cookie & BLK_QC_T_INTERNAL) != 0;
 }
 
+/*
+ * blk_qc_t for bio-based devices.
+ *
+ * 1. When @bio is not split, the returned cookie has following format.
+ *    @dev_t specifies the dev_t number of the underlying device the bio
+ *    submitted to, while @queue_num specifies the hw queue the bio submitted
+ *    to.
+ *
+ * 63                    31 30          15          0 (bit)
+ * +----------------------+-+-----------+-----------+
+ * |        dev_t         | | queue_num |  reserved |
+ * +----------------------+-+-----------+-----------+
+ *                         ^
+ *                         reserved for compatibility with mq
+ *
+ * 2. When @bio gets split and enqueued into multi hw queues, the returned
+ *    cookie is just BLK_QC_T_BIO_POLL_ALL flag.
+ *
+ * 63                                              0 (bit)
+ * +----------------------------------------------+-+
+ * |                                              |1|
+ * +----------------------------------------------+-+
+ *                                                 ^
+ *                                                 BLK_QC_T_BIO_POLL_ALL
+ *
+ * 3. Otherwise, return BLK_QC_T_NONE as the cookie.
+ *
+ * 63                                              0 (bit)
+ * +-----------------------------------------------+
+ * |                  BLK_QC_T_NONE                |
+ * +-----------------------------------------------+
+ */
+#define BLK_QC_T_HIGH_SHIFT	32
+#define BLK_QC_T_BIO_POLL_ALL	1U
+
+static inline unsigned int blk_qc_t_to_devt(blk_qc_t cookie)
+{
+	return cookie >> BLK_QC_T_HIGH_SHIFT;
+}
+
+static inline blk_qc_t blk_qc_t_get_by_devt(unsigned int dev,
+					    unsigned int queue_num)
+{
+	return ((blk_qc_t)dev << BLK_QC_T_HIGH_SHIFT) |
+	       (queue_num << BLK_QC_T_SHIFT);
+}
+
+static inline bool blk_qc_t_is_poll_multi(blk_qc_t cookie)
+{
+	return cookie & BLK_QC_T_BIO_POLL_ALL;
+}
+
 struct blk_rq_stat {
 	u64 mean;
 	u64 min;
diff --git a/include/linux/types.h b/include/linux/types.h
index 52a54ed6ffac..7ff4bb96e0ea 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -126,7 +126,7 @@ typedef u64 sector_t;
 typedef u64 blkcnt_t;
 
 /* cookie used for IO polling */
-typedef unsigned int blk_qc_t;
+typedef u64 blk_qc_t;
 
 /*
  * The type of an index into the pagecache.
-- 
2.27.0

