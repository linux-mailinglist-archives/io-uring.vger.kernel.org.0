Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD7F2A3CB2
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 07:16:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgKCGQO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Nov 2020 01:16:14 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:51730 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727308AbgKCGQO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Nov 2020 01:16:14 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R571e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UE3fUMv_1604384161;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UE3fUMv_1604384161)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 03 Nov 2020 14:16:01 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com
Subject: [PATCH v2 1/2] io_uring: refactor io_sq_thread() handling
Date:   Tue,  3 Nov 2020 14:15:59 +0800
Message-Id: <20201103061600.11053-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20201103061600.11053-1-xiaoguang.wang@linux.alibaba.com>
References: <20201103061600.11053-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are some issues about current io_sq_thread() implementation:
  1. The prepare_to_wait() usage in __io_sq_thread() is weird. If
multiple ctxs share one same poll thread, one ctx will put poll thread
in TASK_INTERRUPTIBLE, but if other ctxs have work to do, we don't
need to change task's stat at all. I think only if all ctxs don't have
work to do, we can do it.
  2. We use round-robin strategy to make multiple ctxs share one same
poll thread, but there are various condition in __io_sq_thread(), which
seems complicated and may affect round-robin strategy.

To improve above issues, I take below actions:
  1. If multiple ctxs share one same poll thread, only if all all ctxs
don't have work to do, we can call prepare_to_wait() and schedule() to
make poll thread enter sleep state.
  2. To make round-robin strategy more straight, I simplify
__io_sq_thread() a bit, it just does io poll and sqes submit work once,
does not check various condition.
  3. For multiple ctxs share one same poll thread, we choose the biggest
sq_thread_idle among these ctxs as timeout condition, and will update
it when ctx is in or out.
  4. Not need to check EBUSY especially, if io_submit_sqes() returns
EBUSY, IORING_SQ_CQ_OVERFLOW should be set, helper in liburing should
be aware of cq overflow and enters kernel to flush work.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 169 ++++++++++++++++++++------------------------------
 1 file changed, 67 insertions(+), 102 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index badd8e70a10e..e9cde444b34d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -244,6 +244,8 @@ struct io_sq_data {
 
 	struct task_struct	*thread;
 	struct wait_queue_head	wait;
+
+	unsigned		sq_thread_idle;
 };
 
 struct io_ring_ctx {
@@ -309,7 +311,6 @@ struct io_ring_ctx {
 	struct io_sq_data	*sq_data;	/* if using sq thread polling */
 
 	struct wait_queue_head	sqo_sq_wait;
-	struct wait_queue_entry	sqo_wait_entry;
 	struct list_head	sqd_list;
 
 	/*
@@ -6828,111 +6829,49 @@ static inline void io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
 	spin_unlock_irq(&ctx->completion_lock);
 }
 
-static int io_sq_wake_function(struct wait_queue_entry *wqe, unsigned mode,
-			       int sync, void *key)
-{
-	struct io_ring_ctx *ctx = container_of(wqe, struct io_ring_ctx, sqo_wait_entry);
-	int ret;
-
-	ret = autoremove_wake_function(wqe, mode, sync, key);
-	if (ret) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&ctx->completion_lock, flags);
-		ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
-		spin_unlock_irqrestore(&ctx->completion_lock, flags);
-	}
-	return ret;
-}
-
-enum sq_ret {
-	SQT_IDLE	= 1,
-	SQT_SPIN	= 2,
-	SQT_DID_WORK	= 4,
-};
-
-static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
-				  unsigned long start_jiffies, bool cap_entries)
+static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 {
-	unsigned long timeout = start_jiffies + ctx->sq_thread_idle;
-	struct io_sq_data *sqd = ctx->sq_data;
 	unsigned int to_submit;
 	int ret = 0;
 
-again:
 	if (!list_empty(&ctx->iopoll_list)) {
 		unsigned nr_events = 0;
 
 		mutex_lock(&ctx->uring_lock);
-		if (!list_empty(&ctx->iopoll_list) && !need_resched())
+		if (!list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, &nr_events, 0);
 		mutex_unlock(&ctx->uring_lock);
 	}
 
 	to_submit = io_sqring_entries(ctx);
-
-	/*
-	 * If submit got -EBUSY, flag us as needing the application
-	 * to enter the kernel to reap and flush events.
-	 */
-	if (!to_submit || ret == -EBUSY || need_resched()) {
-		/*
-		 * Drop cur_mm before scheduling, we can't hold it for
-		 * long periods (or over schedule()). Do this before
-		 * adding ourselves to the waitqueue, as the unuse/drop
-		 * may sleep.
-		 */
-		io_sq_thread_drop_mm_files();
-
-		/*
-		 * We're polling. If we're within the defined idle
-		 * period, then let us spin without work before going
-		 * to sleep. The exception is if we got EBUSY doing
-		 * more IO, we should wait for the application to
-		 * reap events and wake us up.
-		 */
-		if (!list_empty(&ctx->iopoll_list) || need_resched() ||
-		    (!time_after(jiffies, timeout) && ret != -EBUSY &&
-		    !percpu_ref_is_dying(&ctx->refs)))
-			return SQT_SPIN;
-
-		prepare_to_wait(&sqd->wait, &ctx->sqo_wait_entry,
-					TASK_INTERRUPTIBLE);
-
-		/*
-		 * While doing polled IO, before going to sleep, we need
-		 * to check if there are new reqs added to iopoll_list,
-		 * it is because reqs may have been punted to io worker
-		 * and will be added to iopoll_list later, hence check
-		 * the iopoll_list again.
-		 */
-		if ((ctx->flags & IORING_SETUP_IOPOLL) &&
-		    !list_empty_careful(&ctx->iopoll_list)) {
-			finish_wait(&sqd->wait, &ctx->sqo_wait_entry);
-			goto again;
-		}
-
-		to_submit = io_sqring_entries(ctx);
-		if (!to_submit || ret == -EBUSY)
-			return SQT_IDLE;
-	}
-
-	finish_wait(&sqd->wait, &ctx->sqo_wait_entry);
-	io_ring_clear_wakeup_flag(ctx);
-
 	/* if we're handling multiple rings, cap submit size for fairness */
 	if (cap_entries && to_submit > 8)
 		to_submit = 8;
 
-	mutex_lock(&ctx->uring_lock);
-	if (likely(!percpu_ref_is_dying(&ctx->refs)))
-		ret = io_submit_sqes(ctx, to_submit);
-	mutex_unlock(&ctx->uring_lock);
+	if (to_submit) {
+		mutex_lock(&ctx->uring_lock);
+		if (likely(!percpu_ref_is_dying(&ctx->refs)))
+			ret = io_submit_sqes(ctx, to_submit);
+		mutex_unlock(&ctx->uring_lock);
+	}
 
 	if (!io_sqring_full(ctx) && wq_has_sleeper(&ctx->sqo_sq_wait))
 		wake_up(&ctx->sqo_sq_wait);
 
-	return SQT_DID_WORK;
+	return ret;
+}
+
+static void io_sqd_update_thread_idle(struct io_sq_data *sqd)
+{
+	struct io_ring_ctx *ctx;
+	unsigned sq_thread_idle = 0;
+
+	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+		if (sq_thread_idle < ctx->sq_thread_idle)
+			sq_thread_idle = ctx->sq_thread_idle;
+	}
+
+	sqd->sq_thread_idle = sq_thread_idle;
 }
 
 static void io_sqd_init_new(struct io_sq_data *sqd)
@@ -6941,11 +6880,11 @@ static void io_sqd_init_new(struct io_sq_data *sqd)
 
 	while (!list_empty(&sqd->ctx_new_list)) {
 		ctx = list_first_entry(&sqd->ctx_new_list, struct io_ring_ctx, sqd_list);
-		init_wait(&ctx->sqo_wait_entry);
-		ctx->sqo_wait_entry.func = io_sq_wake_function;
 		list_move_tail(&ctx->sqd_list, &sqd->ctx_list);
 		complete(&ctx->sq_thread_comp);
 	}
+
+	io_sqd_update_thread_idle(sqd);
 }
 
 static int io_sq_thread(void *data)
@@ -6957,7 +6896,8 @@ static int io_sq_thread(void *data)
 	const struct cred *old_cred = NULL;
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
-	unsigned long start_jiffies;
+	unsigned long timeout;
+	DEFINE_WAIT(wait);
 
 	task_lock(current);
 	current->files = NULL;
@@ -6965,10 +6905,9 @@ static int io_sq_thread(void *data)
 	current->thread_pid = NULL;
 	task_unlock(current);
 
-	start_jiffies = jiffies;
 	while (!kthread_should_stop()) {
-		enum sq_ret ret = 0;
-		bool cap_entries;
+		int ret;
+		bool cap_entries, sqt_spin, needs_sched;
 
 		/*
 		 * Any changes to the sqd lists are synchronized through the
@@ -6978,11 +6917,13 @@ static int io_sq_thread(void *data)
 		if (kthread_should_park())
 			kthread_parkme();
 
-		if (unlikely(!list_empty(&sqd->ctx_new_list)))
+		if (unlikely(!list_empty(&sqd->ctx_new_list))) {
 			io_sqd_init_new(sqd);
+			timeout = jiffies + sqd->sq_thread_idle;
+		}
 
+		sqt_spin = false;
 		cap_entries = !list_is_singular(&sqd->ctx_list);
-
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			if (current->cred != ctx->creds) {
 				if (old_cred)
@@ -6995,24 +6936,49 @@ static int io_sq_thread(void *data)
 			current->sessionid = ctx->sessionid;
 #endif
 
-			ret |= __io_sq_thread(ctx, start_jiffies, cap_entries);
+			ret = __io_sq_thread(ctx, cap_entries);
+			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
+				sqt_spin = true;
 
 			io_sq_thread_drop_mm_files();
 		}
 
-		if (ret & SQT_SPIN) {
+		if (sqt_spin || !time_after(jiffies, timeout)) {
 			io_run_task_work();
 			cond_resched();
-		} else if (ret == SQT_IDLE) {
-			if (kthread_should_park())
-				continue;
+			if (sqt_spin)
+				timeout = jiffies + sqd->sq_thread_idle;
+			continue;
+		}
+
+		if (kthread_should_park())
+			continue;
+
+		needs_sched = true;
+		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
+			    !list_empty_careful(&ctx->iopoll_list)) {
+				needs_sched = false;
+				break;
+			}
+			if (io_sqring_entries(ctx)) {
+				needs_sched = false;
+				break;
+			}
+		}
+
+		if (needs_sched) {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_set_wakeup_flag(ctx);
+
 			schedule();
-			start_jiffies = jiffies;
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_clear_wakeup_flag(ctx);
 		}
+
+		finish_wait(&sqd->wait, &wait);
+		timeout = jiffies + sqd->sq_thread_idle;
 	}
 
 	io_run_task_work();
@@ -7310,12 +7276,11 @@ static void io_sq_thread_stop(struct io_ring_ctx *ctx)
 
 		mutex_lock(&sqd->ctx_lock);
 		list_del(&ctx->sqd_list);
+		io_sqd_update_thread_idle(sqd);
 		mutex_unlock(&sqd->ctx_lock);
 
-		if (sqd->thread) {
-			finish_wait(&sqd->wait, &ctx->sqo_wait_entry);
+		if (sqd->thread)
 			io_sq_thread_unpark(sqd);
-		}
 
 		io_put_sq_data(sqd);
 		ctx->sq_data = NULL;
-- 
2.17.2

