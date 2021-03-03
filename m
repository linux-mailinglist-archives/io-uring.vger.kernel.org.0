Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9B732C5BC
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382495AbhCDAYL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:11 -0500
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:50429 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1442252AbhCCL6m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 06:58:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=8;SR=0;TI=SMTPD_---0UQGHkCe_1614772672;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UQGHkCe_1614772672)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 03 Mar 2021 19:57:52 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     msnitzer@redhat.com, axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, dm-devel@redhat.com,
        linux-block@vger.kernel.org, mpatocka@redhat.com,
        caspar@linux.alibaba.com, joseph.qi@linux.alibaba.com
Subject: [PATCH v5 11/12] block: sub-fastpath for bio-based polling
Date:   Wed,  3 Mar 2021 19:57:39 +0800
Message-Id: <20210303115740.127001-12-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
References: <20210303115740.127001-1-jefflexu@linux.alibaba.com>
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
 block/blk-core.c          | 18 ++++++++++++++++--
 include/linux/blk_types.h | 38 ++++++++++++++++++++++++++++++++++----
 2 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index e5cd4ff08f5c..5479fd74d3be 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -948,7 +948,8 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 	struct bio_list bio_list_on_stack[2];
 	blk_qc_t ret = BLK_QC_T_NONE;
 	struct request_queue *top_q;
-	bool poll_on;
+	bool orig_poll_on, poll_on;
+	u64 old_nr_migrations;
 
 	BUG_ON(bio->bi_next);
 
@@ -958,6 +959,8 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 	top_q = bio->bi_bdev->bd_disk->queue;
 	poll_on = test_bit(QUEUE_FLAG_POLL, &top_q->queue_flags) &&
 		  (bio->bi_opf & REQ_HIPRI);
+	orig_poll_on = poll_on;
+	old_nr_migrations = READ_ONCE(current->se.nr_migrations);
 
 	do {
 		blk_qc_t cookie;
@@ -987,7 +990,7 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 				ret = cookie;
 			} else if (ret != cookie) {
 				/* bio gets split and enqueued to multi hctxs */
-				ret = BLK_QC_T_BIO_POLL_ALL;
+				ret = blk_qc_t_get_by_cpu();
 				poll_on = false;
 			}
 		}
@@ -1014,6 +1017,17 @@ static blk_qc_t __submit_bio_noacct(struct bio *bio)
 
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
index 8f970e026be9..32de4fb79eff 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -555,8 +555,21 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
  *                         ^
  *                         reserved for compatibility with mq
  *
- * 2. When @bio gets split and enqueued into multi hw queues, the returned
- *    cookie is just BLK_QC_T_BIO_POLL_ALL flag.
+ * 2. When @bio gets split and enqueued into multi hw queues, and current
+ *    process has *not* been migrated to another CPU, the returned cookie
+ *    actually stores the corresponding CPU number on which the IO submission
+ *    happened. Also with BLK_QC_T_BIO_POLL_CPU flag set.
+ *
+ * 63                    31                         0 (bit)
+ * +----------------------+-----------------------+-+
+ * |          cpu         |                       |1|
+ * +----------------------+-----------------------+-+
+ *                                                 ^
+ *                                                 BLK_QC_T_BIO_POLL_CPU
+ *
+ * 3. When @bio gets split and enqueued into multi hw queues, and current
+ *    process has ever been migrated to another CPU, the returned cookie is just
+ *    BLK_QC_T_BIO_POLL_ALL flag.
  *
  * 63                                              0 (bit)
  * +----------------------------------------------+-+
@@ -565,7 +578,7 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
  *                                                 ^
  *                                                 BLK_QC_T_BIO_POLL_ALL
  *
- * 3. Otherwise, return BLK_QC_T_NONE as the cookie.
+ * 4. Otherwise, return BLK_QC_T_NONE as the cookie.
  *
  * 63                                              0 (bit)
  * +-----------------------------------------------+
@@ -574,12 +587,18 @@ static inline bool blk_qc_t_is_internal(blk_qc_t cookie)
  */
 #define BLK_QC_T_HIGH_SHIFT	32
 #define BLK_QC_T_BIO_POLL_ALL	1U
+#define BLK_QC_T_BIO_POLL_CPU	2U
 
 static inline unsigned int blk_qc_t_to_devt(blk_qc_t cookie)
 {
 	return cookie >> BLK_QC_T_HIGH_SHIFT;
 }
 
+static inline unsigned int blk_qc_t_to_cpu(blk_qc_t cookie)
+{
+	return cookie >> BLK_QC_T_HIGH_SHIFT;
+}
+
 static inline blk_qc_t blk_qc_t_get_by_devt(unsigned int dev,
 					    unsigned int queue_num)
 {
@@ -587,9 +606,20 @@ static inline blk_qc_t blk_qc_t_get_by_devt(unsigned int dev,
 	       (queue_num << BLK_QC_T_SHIFT);
 }
 
+static inline blk_qc_t blk_qc_t_get_by_cpu(void)
+{
+	return ((blk_qc_t)raw_smp_processor_id() << BLK_QC_T_HIGH_SHIFT) |
+	       BLK_QC_T_BIO_POLL_CPU;
+}
+
 static inline bool blk_qc_t_is_poll_multi(blk_qc_t cookie)
 {
-	return cookie & BLK_QC_T_BIO_POLL_ALL;
+	return cookie & (BLK_QC_T_BIO_POLL_ALL | BLK_QC_T_BIO_POLL_CPU);
+}
+
+static inline bool blk_qc_t_is_poll_cpu(blk_qc_t cookie)
+{
+	return cookie & BLK_QC_T_BIO_POLL_CPU;
 }
 
 struct blk_rq_stat {
-- 
2.27.0

