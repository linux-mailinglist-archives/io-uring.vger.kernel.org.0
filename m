Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0138E304A39
	for <lists+io-uring@lfdr.de>; Tue, 26 Jan 2021 21:37:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbhAZFK1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 Jan 2021 00:10:27 -0500
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:36779 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727877AbhAYMTz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jan 2021 07:19:55 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=jefflexu@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0UMqjSks_1611576822;
Received: from localhost(mailfrom:jefflexu@linux.alibaba.com fp:SMTPD_---0UMqjSks_1611576822)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Jan 2021 20:13:42 +0800
From:   Jeffle Xu <jefflexu@linux.alibaba.com>
To:     snitzer@redhat.com
Cc:     joseph.qi@linux.alibaba.com, dm-devel@redhat.com,
        linux-block@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH v2 3/6] block: add iopoll method to support bio-based IO polling
Date:   Mon, 25 Jan 2021 20:13:37 +0800
Message-Id: <20210125121340.70459-4-jefflexu@linux.alibaba.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
References: <20210125121340.70459-1-jefflexu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->poll_fn was introduced in commit ea435e1b9392 ("block: add a poll_fn
callback to struct request_queue") to support bio-based queues such as
nvme multipath, but was later removed in commit 529262d56dbe ("block:
remove ->poll_fn").

Given commit c62b37d96b6e ("block: move ->make_request_fn to struct
block_device_operations") restore the possibility of bio-based IO
polling support by adding an ->iopoll method to gendisk->fops.
Elevate bulk of blk_mq_poll() implementation to blk_poll() and reduce
blk_mq_poll() to blk-mq specific code that is called from blk_poll().

Signed-off-by: Jeffle Xu <jefflexu@linux.alibaba.com>
Suggested-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c       | 70 +++++++++++++++++++++++++++++++++++++++
 block/blk-mq.c         | 74 ++++++------------------------------------
 include/linux/blk-mq.h |  3 ++
 include/linux/blkdev.h |  1 +
 4 files changed, 84 insertions(+), 64 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 7663a9b94b80..3d93aaa9a49b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1132,6 +1132,76 @@ blk_qc_t submit_bio(struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio);
 
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
+	struct blk_mq_hw_ctx *hctx = NULL;
+	struct gendisk *disk = NULL;
+
+	if (!blk_qc_t_valid(cookie) ||
+	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
+		return 0;
+
+	if (current->plug)
+		blk_flush_plug_list(current->plug, false);
+
+	if (queue_is_mq(q)) {
+		/*
+		 * If we sleep, have the caller restart the poll loop to reset
+		 * the state. Like for the other success return cases, the
+		 * caller is responsible for checking if the IO completed. If
+		 * the IO isn't complete, we'll get called again and will go
+		 * straight to the busy poll loop. If specified not to spin,
+		 * we also should not sleep.
+		 */
+		hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
+		if (spin && blk_mq_poll_hybrid(q, hctx, cookie))
+			return 1;
+		hctx->poll_considered++;
+	} else
+		disk = queue_to_disk(q);
+
+	state = current->state;
+	do {
+		int ret;
+
+		if (hctx)
+			ret = blk_mq_poll(q, hctx);
+		else if (disk->fops->iopoll)
+			ret = disk->fops->iopoll(q, cookie);
+
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
index f285a9123a8b..d058b9cbdf76 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -3801,8 +3801,8 @@ static bool blk_mq_poll_hybrid_sleep(struct request_queue *q,
 	return true;
 }
 
-static bool blk_mq_poll_hybrid(struct request_queue *q,
-			       struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
+bool blk_mq_poll_hybrid(struct request_queue *q,
+			struct blk_mq_hw_ctx *hctx, blk_qc_t cookie)
 {
 	struct request *rq;
 
@@ -3826,72 +3826,18 @@ static bool blk_mq_poll_hybrid(struct request_queue *q,
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
+int blk_mq_poll(struct request_queue *q, struct blk_mq_hw_ctx *hctx)
 {
-	struct blk_mq_hw_ctx *hctx;
-	long state;
-
-	if (!blk_qc_t_valid(cookie) ||
-	    !test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
-		return 0;
-
-	if (current->plug)
-		blk_flush_plug_list(current->plug, false);
-
-	hctx = q->queue_hw_ctx[blk_qc_t_to_queue_num(cookie)];
-
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
-
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
+	int ret;
 
-		if (current->state == TASK_RUNNING)
-			return 1;
-		if (ret < 0 || !spin)
-			break;
-		cpu_relax();
-	} while (!need_resched());
+	hctx->poll_invoked++;
+	ret = q->mq_ops->poll(hctx);
+	if (ret > 0)
+		hctx->poll_success++;
 
-	__set_current_state(TASK_RUNNING);
-	return 0;
+	return ret;
 }
-EXPORT_SYMBOL_GPL(blk_poll);
+EXPORT_SYMBOL(blk_mq_poll);
 
 unsigned int blk_mq_rq_cpu(struct request *rq)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index d705b174d346..8062a2d046a9 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -607,6 +607,9 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 }
 
 blk_qc_t blk_mq_submit_bio(struct bio *bio);
+int blk_mq_poll(struct request_queue *q, struct blk_mq_hw_ctx *hctx);
+bool blk_mq_poll_hybrid(struct request_queue *q,
+		struct blk_mq_hw_ctx *hctx, blk_qc_t cookie);
 void blk_mq_hctx_set_fq_lock_class(struct blk_mq_hw_ctx *hctx,
 		struct lock_class_key *key);
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2a802e011a95..bc540df197cb 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1853,6 +1853,7 @@ static inline void blk_ksm_unregister(struct request_queue *q) { }
 
 struct block_device_operations {
 	blk_qc_t (*submit_bio) (struct bio *bio);
+	int (*iopoll)(struct request_queue *q, blk_qc_t cookie);
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
 	int (*rw_page)(struct block_device *, sector_t, struct page *, unsigned int);
-- 
2.27.0

