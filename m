Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70BE62E1BE4
	for <lists+io-uring@lfdr.de>; Wed, 23 Dec 2020 12:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgLWL1L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 06:27:11 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:38159 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728455AbgLWL1L (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 06:27:11 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UJXS7XL_1608722785;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UJXS7XL_1608722785)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 23 Dec 2020 19:26:25 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        io-uring@vger.kernel.org
Subject: [PATCH RFC 3/7] block: add iopoll method for non-mq device
Date:   Wed, 23 Dec 2020 19:26:20 +0800
Message-Id: <20201223112624.78955-4-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
References: <20201223112624.78955-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->poll_fn is introduced in commit ea435e1b9392 ("block: add a poll_fn
callback to struct request_queue") for supporting non-mq queues such as
nvme multipath, but removed in commit 529262d56dbe ("block: remove
->poll_fn").

To add support of IO polling for non-mq device, this method need to be
back. Since commit c62b37d96b6e ("block: move ->make_request_fn to
struct block_device_operations") has moved all callbacks into struct
block_device_operations in gendisk, we also add the new method named
->iopoll in block_device_operations.

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
---
 block/blk-core.c       | 79 ++++++++++++++++++++++++++++++++++++++++++
 block/blk-mq.c         | 70 +++++--------------------------------
 include/linux/blk-mq.h |  3 ++
 include/linux/blkdev.h |  1 +
 4 files changed, 92 insertions(+), 61 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 96e5fcd7f071..2f5c51ce32e3 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1131,6 +1131,85 @@ blk_qc_t submit_bio(struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio);
 
+static bool blk_poll_hybrid(struct request_queue *q, blk_qc_t cookie)
+{
+	struct blk_mq_hw_ctx *hctx;
+
+	/* TODO: bio-based device doesn't support hybrid poll. */
+	if (!queue_is_mq(q))
+		return false;
+
+	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
+	if (blk_mq_poll_hybrid(q, hctx, cookie))
+		return true;
+
+	hctx->poll_considered++;
+	return false;
+}
+
+/**
+ * blk_poll - poll for IO completions
+ * @q:  the queue
+ * @cookie: cookie passed back at IO submission time
+ * @spin: whether to spin for completions
+ *
+ * Description:
+ *    Poll for completions on the passed in queue. Returns number of
+ *    completed entries found. If @spin is true, then blk_poll will continue
+ *    looping until at least one completion is found, unless the task is
+ *    otherwise marked running (or we need to reschedule).
+ */
+int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
+{
+	long state;
+
+	if (!blk_qc_t_valid(cookie) ||
+	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+		return 0;
+
+	if (current->plug)
+		blk_flush_plug_list(current->plug, false);
+
+	/*
+	 * If we sleep, have the caller restart the poll loop to reset
+	 * the state. Like for the other success return cases, the
+	 * caller is responsible for checking if the IO completed. If
+	 * the IO isn't complete, we'll get called again and will go
+	 * straight to the busy poll loop. If specified not to spin,
+	 * we also should not sleep.
+	 */
+	if (spin && blk_poll_hybrid(q, cookie))
+		return 1;
+
+	state = current->state;
+	do {
+		int ret;
+		struct gendisk *disk = queue_to_disk(q);
+
+		if (disk->fops->iopoll)
+			ret = disk->fops->iopoll(q, cookie);
+		else
+			ret = blk_mq_poll(q, cookie);
+		if (ret > 0) {
+			__set_current_state(TASK_RUNNING);
+			return ret;
+		}
+
+		if (signal_pending_state(state, current))
+			__set_current_state(TASK_RUNNING);
+
+		if (current->state == TASK_RUNNING)
+			return 1;
+		if (ret < 0 || !spin)
+			break;
+		cpu_relax();
+	} while (!need_resched());
+
+	__set_current_state(TASK_RUNNING);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(blk_poll);
+
 /**
  * blk_cloned_rq_check_limits - Helper function to check a cloned request
  *                              for the new queue limits
diff --git a/block/blk-mq.c b/block/blk-mq.c
index b09ce00cc6af..85258958e9f1 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3818,8 +3818,8 @@ static bool blk_mq_poll_hybrid_sleep(struct request_queue *q,
 	return true;
 }
 
-static bool blk_mq_poll_hybrid(struct request_queue *q,
-			       struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
+bool blk_mq_poll_hybrid(struct request_queue *q,
+			struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
 {
 	struct request *rq;
 
@@ -3843,72 +3843,20 @@ static bool blk_mq_poll_hybrid(struct request_queue *q,
 	return blk_mq_poll_hybrid_sleep(q, rq);
 }
 
-/**
- * blk_poll - poll for IO completions
- * @q:  the queue
- * @cookie: cookie passed back at IO submission time
- * @spin: whether to spin for completions
- *
- * Description:
- *    Poll for completions on the passed in queue. Returns number of
- *    completed entries found. If @spin is true, then blk_poll will continue
- *    looping until at least one completion is found, unless the task is
- *    otherwise marked running (or we need to reschedule).
- */
-int blk_poll(struct request_queue *q, blk_qc_t cookie, bool spin)
+int blk_mq_poll(struct request_queue *q, blk_qc_t cookie)
 {
+	int ret;
 	struct blk_mq_hw_ctx *hctx;
-	long state;
-
-	if (!blk_qc_t_valid(cookie) ||
-	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
-		return 0;
-
-	if (current->plug)
-		blk_flush_plug_list(current->plug, false);
 
 	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
 
-	/*
-	 * If we sleep, have the caller restart the poll loop to reset
-	 * the state. Like for the other success return cases, the
-	 * caller is responsible for checking if the IO completed. If
-	 * the IO isn't complete, we'll get called again and will go
-	 * straight to the busy poll loop. If specified not to spin,
-	 * we also should not sleep.
-	 */
-	if (spin && blk_mq_poll_hybrid(q, hctx, cookie))
-		return 1;
-
-	hctx->poll_considered++;
+	hctx->poll_invoked++;
+	ret = q->mq_ops->poll(hctx);
+	if (ret > 0)
+		hctx->poll_success++;
 
-	state = current->state;
-	do {
-		int ret;
-
-		hctx->poll_invoked++;
-
-		ret = q->mq_ops->poll(hctx);
-		if (ret > 0) {
-			hctx->poll_success++;
-			__set_current_state(TASK_RUNNING);
-			return ret;
-		}
-
-		if (signal_pending_state(state, current))
-			__set_current_state(TASK_RUNNING);
-
-		if (current->state == TASK_RUNNING)
-			return 1;
-		if (ret < 0 || !spin)
-			break;
-		cpu_relax();
-	} while (!need_resched());
-
-	__set_current_state(TASK_RUNNING);
-	return 0;
+	return ret;
 }
-EXPORT_SYMBOL_GPL(blk_poll);
 
 unsigned int blk_mq_rq_cpu(struct request *rq)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 47b021952ac7..032e08ecd42e 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -607,6 +607,9 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 }
 
 blk_qc_t blk_mq_submit_bio(struct bio *bio);
+int blk_mq_poll(struct request_queue *q, blk_qc_t cookie);
+bool blk_mq_poll_hybrid(struct request_queue *q,
+		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie);
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
 		struct lock_class_key *key);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2303d06a5a82..e8965879eb90 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1845,6 +1845,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
 
 struct block_device_operations {
 	blk_qc_t (*submit_bio) (struct bio *bio);
+	int (*iopoll)(struct request_queue *q, blk_qc_t cookie);
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
 	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
-- 
2.27.0

