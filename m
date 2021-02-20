Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81C1320504
	for <lists+io-uring@lfdr.de>; Sat, 20 Feb 2021 12:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhBTLHn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 20 Feb 2021 06:07:43 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:34025 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229811AbhBTLHd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 20 Feb 2021 06:07:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0UP1O7pq_1613819209;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UP1O7pq_1613819209)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 20 Feb 2021 19:06:49 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com, axboe@kernel.dk
Cc:     hch@lst.de, ming.lei@redhat.com, linux-block@vger.kernel.org,
        dm-devel@redhat.com, io-uring@vger.kernel.org,
        joseph.qi@linux.alibaba.com, caspar@linux.alibaba.com
Subject: [PATCH v4 11/12] block: sub-fastpath for bio-based polling
Date:   Sat, 20 Feb 2021 19:06:36 +0800
Message-Id: <20210220110637.50305-12-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
References: <20210220110637.50305-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Offer one sub-fastpath for bio-based polling when bio submitted to dm
device gets split and enqueued into multiple hw queues, while the IO
submission process has not been migrated to another CPU.

In this case, the IO submission routine will return the CPU number on
which the IO submission happened as the returned cookie, while the
polling routine will only iterate and poll on hw queues that this CPU
number maps, instead of iterating *all* hw queues.

This optimization can dramatically reduce cache ping-pong and thus
improve the polling performance, when multiple hw queues in polling mode
per device could be reserved when there are multiple polling processes.

It will fall back to iterating all hw queues in polling mode, once the
process has ever been migrated to another CPU during the IO submission
phase.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-core.c          | 24 ++++++++++++++--
 include/linux/blk_types.h | 60 +++++++++++++++++++++++++++++++++++++--
 2 files changed, 79 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 82349e3c2a24..e13219908ef8 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -959,7 +959,10 @@ static blk_qc_t __submit_bio(struct bio *bio)
  *
  * Return:
  *   - BLK_QC_T_NONE, no need for IO polling.
- *   - BLK_QC_T_BIO_POLL_ALL, @bio gets split and enqueued into multi hw queues.
+ *   - When @bio gets split and enqueued into multi hw queues, return the
+ *     corresponding CPU number with BLK_QC_T_BIO_POLL_CPU flag set when the
+ *     current process has not been migrated to another CPU,
+ *     BLK_QC_T_BIO_POLL_ALL otherwise.
  *   - Otherwise, @bio is not split, returning the pointer to the corresponding
  *     hw queue that the bio enqueued into as the returned cookie.
  */
@@ -968,13 +971,17 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 	struct bio_list bio_list_on_stack[2];
 	blk_qc_t ret = BLK_QC_T_NONE;
 	struct request_queue *top_q = bio->bi_disk->queue;
-	bool poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags);
+	bool orig_poll_on, poll_on;
+	u64 old_nr_migrations;
 
 	BUG_ON(bio->bi_next);
 
 	bio_list_init(&bio_list_on_stack[0]);
 	current->bio_list = bio_list_on_stack;
 
+	orig_poll_on = poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags);
+	old_nr_migrations = READ_ONCE(current->se.nr_migrations);
+
 	do {
 		blk_qc_t cookie;
 		struct request_queue *q = bio->bi_disk->queue;
@@ -1002,7 +1009,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 				ret = cookie;
 			} else if (ret != cookie) {
 				/* bio gets split and enqueued to multi hctxs */
-				ret = BLK_QC_T_BIO_POLL_ALL;
+				ret = blk_qc_t_get();
 				poll_on = false;
 			}
 		}
@@ -1029,6 +1036,17 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 
 	current->bio_list = NULL;
 
+	/*
+	 * For cases when bio gets split and enqueued into multi hctxs, return
+	 * the corresponding CPU number when current process has not been
+	 * migrated to another CPU. Return BLK_QC_T_BIO_POLL_ALL otherwise,
+	 * falling back to iterating and polling on all hw queues, since split
+	 * bios are submitted to different CPUs in this case.
+	 */
+	if (orig_poll_on != poll_on &&
+	    old_nr_migrations != READ_ONCE(current->se.nr_migrations))
+		ret = BLK_QC_T_BIO_POLL_ALL;
+
 	return ret;
 }
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 6f27446ebada..f8d34f02378d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -557,12 +557,68 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
 	return (cookie & BLK_QC_T_INTERNAL) != 0;
 }
 
-/* Macros for blk_qc_t used for bio-based polling */
+/*
+ * Macros for blk_qc_t used for bio-based polling.
+ *
+ * 1. When @bio is not split, the returned cookie is actually the pointer to the
+ *    corresponding hw queue that the bio is enqueued into, thus the low two
+ *    bits could be reused as other flags.
+ *    +-----------------------------------------+
+ *    |        struct blk_mq_hw_ctx*        |0|0|
+ *    +-----------------------------------------+
+ *
+ * 2. When @bio gets split and enqueued into multi hw queues, and current
+ *    process has not been migrated to another CPU, the returned cookie actually
+ *    stores the corresponding CPU number on which the IO submission happened,
+ *    Also with BLK_QC_T_BIO_POLL_CPU flag set.
+ *    In this case, bio-based polling could only iterate and poll on hw queues
+ *    that this CPU number maps.
+ *    +-----------------------------------------+
+ *    |         CPU         |               |1| |
+ *    +-----------------------------------------+
+ *                                           ^
+ *                                           BLK_QC_T_BIO_POLL_CPU
+ *
+ * 3. When @bio gets split and enqueued into multi hw queues, and current
+ *    process has ever been migrated to another CPU, the returned cookie is just
+ *    BLK_QC_T_BIO_POLL_ALL flag.
+ *    In this case, bio-based polling should iterate and poll on all hw queues
+ *    in polling mode.
+ *    +-----------------------------------------+
+ *    |                                     | |1|
+ *    +-----------------------------------------+
+ *                                             ^
+ *                                             BLK_QC_T_BIO_POLL_ALL
+ *
+ * 4. Otherwise, return BLK_QC_T_NONE as the cookie.
+ *    No need for IO polling in this case.
+ *    +-----------------------------------------+
+ *    |               BLK_QC_T_NONE             |
+ *    +-----------------------------------------+
+ */
+
+/* The low two bits of cookie for bio-based polling are reused for flags. */
 #define BLK_QC_T_BIO_POLL_ALL	1U
+#define BLK_QC_T_BIO_POLL_CPU	2U
 
 static inline bool blk_qc_t_is_poll_multi(blk_qc_t cookie)
 {
-	return cookie & BLK_QC_T_BIO_POLL_ALL;
+	return cookie & (BLK_QC_T_BIO_POLL_ALL | BLK_QC_T_BIO_POLL_CPU);
+}
+
+static inline bool blk_qc_t_is_poll_cpu(blk_qc_t cookie)
+{
+	return cookie & BLK_QC_T_BIO_POLL_CPU;
+}
+
+static inline blk_qc_t blk_qc_t_get(void)
+{
+	return (raw_smp_processor_id() << BLK_QC_T_SHIFT) | BLK_QC_T_BIO_POLL_CPU;
+}
+
+static inline int blk_qc_t_to_cpu(blk_qc_t cookie)
+{
+	return cookie >> BLK_QC_T_SHIFT;
 }
 
 struct blk_rq_stat {
-- 
2.27.0

