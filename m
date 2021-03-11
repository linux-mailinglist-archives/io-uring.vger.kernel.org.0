Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4CDD338184
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 00:34:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230118AbhCKXeT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 18:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229606AbhCKXdp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 18:33:45 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52920C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 15:33:45 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id d139-20020a1c1d910000b029010b895cb6f2so14128727wmd.5
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 15:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XJmC4gFFny5o7FP+cT/3V+hRiH9ID2A1wqCws3qZ4do=;
        b=EQ07nJCsOrko6OIepQ+yV+Sm+00dFwSyqnDFNSWdV8bAB68trYuQ7Gn8B3y86Atcda
         BVq+YxXjN8rzTKuUnM6gwafEYxNziIrVjFtyLsye1E166BSqdFCKnoiPIC5ijyT2qM6J
         BIm3ieH7Vg6TSdCUI8/OPVuUcvVHA2Gtzy9UVZDYSlxU/DR9J1NSBK689f/4vvvlY2wS
         vUj6yipuFKR//W3sBlmEXnjWbMZbu9SfJmX1ySIx/SkSOMk/Qnb4o3QGVOjpzhrAnCg+
         /jtJA1m+7lwP0oLF78ofTCZQSwLC8YcZR8pVtsZf3PxpoSy7eSbYROxYcwI2b+H7qK0U
         KlLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XJmC4gFFny5o7FP+cT/3V+hRiH9ID2A1wqCws3qZ4do=;
        b=YG8+sDPiUS9DimejbfLKGSCEUU5qvdOfnAvuzCVEAAl3AljuhJro0Y4Pgxi+E28PlC
         lOBNWi7U8bPOLxhMFROLwE1NFwliIKej8fThTn8k3f8rX2Dl+IxHI7NJnzLatV4t2IQ8
         v74Sdewxk3Si3Gf2XOAzX+uXedi0bP19eLuutjLIP4COapCr3g4/OIbp6OaisNjS0X8H
         7GWA0M2UhjZwvLWZwCxYPPreJTDdcZfmM5mUmWAuU5bvMrriKG+enW4/rv3eai2mQm0A
         nZIIi2oDUFGG3thZKQ0kp1xjkhuDAAzQROZZpVXlh8D4k9St+ZMipL7N3A6oachRkU+H
         FRPw==
X-Gm-Message-State: AOAM532EU9CrPVBvzrbWPjkeYJBZLZFEajeExw45VH0v4r1NPjdkgXfH
        Qjl6iPSfjnkDJBKqHB8gmes=
X-Google-Smtp-Source: ABdhPJxjeNGQ/FKPNSkUon/fLIIIWYHQRb+fAJWiadT/tpBPngdPpNUdtgsEmFduMhrPZ9DmSQ8cAQ==
X-Received: by 2002:a1c:4986:: with SMTP id w128mr10307941wma.37.1615505624043;
        Thu, 11 Mar 2021 15:33:44 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.148])
        by smtp.gmail.com with ESMTPSA id m11sm5828062wrz.40.2021.03.11.15.33.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 15:33:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: cancel sqpoll via task_work
Date:   Thu, 11 Mar 2021 23:29:38 +0000
Message-Id: <6501248c79d9c73e0424cb59b74c03d72b30be62.1615504663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615504663.git.asml.silence@gmail.com>
References: <cover.1615504663.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

1) The first problem is io_uring_cancel_sqpoll() ->
io_uring_cancel_task_requests() basically doing park(); park(); and so
hanging.

2) Another one is more subtle, when the master task is doing cancellations,
but SQPOLL task submits in-between the end of the cancellation but
before finish() requests taking a ref to the ctx, and so eternally
locking it up.

3) Yet another is a dying SQPOLL task doing io_uring_cancel_sqpoll() and
same io_uring_cancel_sqpoll() from the owner task, they race for
tctx->wait events. And there probably more of them.

Instead do SQPOLL cancellations from within SQPOLL task context via
task_work, see io_sqpoll_cancel_sync(). With that we don't need temporal
park()/unpark() during cancellation, which is ugly, subtle and anyway
doesn't allow to do io_run_task_work() properly.

io_uring_cancel_sqpoll() is called only from SQPOLL task context and
under sqd locking, so all parking is removed from there. And so,
io_sq_thread_[un]park() and io_sq_thread_stop() are not used now by
SQPOLL task, and that spare us from some headache.

Also remove ctx->sqd_list early to avoid 2). And kill tctx->sqpoll,
which is not used anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 151 ++++++++++++++++++++++++--------------------------
 1 file changed, 71 insertions(+), 80 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cdec59510433..70286b393c0e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6665,6 +6665,7 @@ static int io_sq_thread(void *data)
 			up_read(&sqd->rw_lock);
 			cond_resched();
 			down_read(&sqd->rw_lock);
+			io_run_task_work();
 			timeout = jiffies + sqd->sq_thread_idle;
 			continue;
 		}
@@ -6720,18 +6721,22 @@ static int io_sq_thread(void *data)
 		finish_wait(&sqd->wait, &wait);
 		timeout = jiffies + sqd->sq_thread_idle;
 	}
-
-	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-		io_uring_cancel_sqpoll(ctx);
 	up_read(&sqd->rw_lock);
-
+	down_write(&sqd->rw_lock);
+	/*
+	 * someone may have parked and added a cancellation task_work, run
+	 * it first because we don't want it in io_uring_cancel_sqpoll()
+	 */
 	io_run_task_work();
 
-	down_write(&sqd->rw_lock);
+	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+		io_uring_cancel_sqpoll(ctx);
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		io_ring_set_wakeup_flag(ctx);
 	up_write(&sqd->rw_lock);
+
+	io_run_task_work();
 	complete(&sqd->exited);
 	do_exit(0);
 }
@@ -7033,8 +7038,8 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 static void io_sq_thread_unpark(struct io_sq_data *sqd)
 	__releases(&sqd->rw_lock)
 {
-	if (sqd->thread == current)
-		return;
+	WARN_ON_ONCE(sqd->thread == current);
+
 	clear_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
 	up_write(&sqd->rw_lock);
 }
@@ -7042,8 +7047,8 @@ static void io_sq_thread_unpark(struct io_sq_data *sqd)
 static void io_sq_thread_park(struct io_sq_data *sqd)
 	__acquires(&sqd->rw_lock)
 {
-	if (sqd->thread == current)
-		return;
+	WARN_ON_ONCE(sqd->thread == current);
+
 	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
 	down_write(&sqd->rw_lock);
 	/* set again for consistency, in case concurrent parks are happening */
@@ -7054,8 +7059,8 @@ static void io_sq_thread_park(struct io_sq_data *sqd)
 
 static void io_sq_thread_stop(struct io_sq_data *sqd)
 {
-	if (test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state))
-		return;
+	WARN_ON_ONCE(sqd->thread == current);
+
 	down_write(&sqd->rw_lock);
 	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 	if (sqd->thread)
@@ -7078,7 +7083,7 @@ static void io_sq_thread_finish(struct io_ring_ctx *ctx)
 
 	if (sqd) {
 		io_sq_thread_park(sqd);
-		list_del(&ctx->sqd_list);
+		list_del_init(&ctx->sqd_list);
 		io_sqd_update_thread_idle(sqd);
 		io_sq_thread_unpark(sqd);
 
@@ -7760,7 +7765,6 @@ static int io_uring_alloc_task_context(struct task_struct *task,
 	init_waitqueue_head(&tctx->wait);
 	tctx->last = NULL;
 	atomic_set(&tctx->in_idle, 0);
-	tctx->sqpoll = false;
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
@@ -8719,43 +8723,12 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 
 		io_uring_try_cancel_requests(ctx, task, files);
 
-		if (ctx->sq_data)
-			io_sq_thread_unpark(ctx->sq_data);
 		prepare_to_wait(&task->io_uring->wait, &wait,
 				TASK_UNINTERRUPTIBLE);
 		if (inflight == io_uring_count_inflight(ctx, task, files))
 			schedule();
 		finish_wait(&task->io_uring->wait, &wait);
-		if (ctx->sq_data)
-			io_sq_thread_park(ctx->sq_data);
-	}
-}
-
-/*
- * We need to iteratively cancel requests, in case a request has dependent
- * hard links. These persist even for failure of cancelations, hence keep
- * looping until none are found.
- */
-static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					  struct files_struct *files)
-{
-	struct task_struct *task = current;
-
-	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
-		io_sq_thread_park(ctx->sq_data);
-		task = ctx->sq_data->thread;
-		if (task)
-			atomic_inc(&task->io_uring->in_idle);
 	}
-
-	io_uring_cancel_files(ctx, task, files);
-	if (!files)
-		io_uring_try_cancel_requests(ctx, task, NULL);
-
-	if (task)
-		atomic_dec(&task->io_uring->in_idle);
-	if (ctx->sq_data)
-		io_sq_thread_unpark(ctx->sq_data);
 }
 
 /*
@@ -8796,15 +8769,6 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx)
 		}
 		tctx->last = ctx;
 	}
-
-	/*
-	 * This is race safe in that the task itself is doing this, hence it
-	 * cannot be going through the exit/cancel paths at the same time.
-	 * This cannot be modified while exit/cancel is running.
-	 */
-	if (!tctx->sqpoll && (ctx->flags & IORING_SETUP_SQPOLL))
-		tctx->sqpoll = true;
-
 	return 0;
 }
 
@@ -8847,6 +8811,44 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 	}
 }
 
+static s64 tctx_inflight(struct io_uring_task *tctx)
+{
+	return percpu_counter_sum(&tctx->inflight);
+}
+
+static void io_sqpoll_cancel_cb(struct callback_head *cb)
+{
+	struct io_tctx_exit *work = container_of(cb, struct io_tctx_exit, task_work);
+	struct io_ring_ctx *ctx = work->ctx;
+	struct io_sq_data *sqd = ctx->sq_data;
+
+	if (sqd->thread)
+		io_uring_cancel_sqpoll(ctx);
+	complete(&work->completion);
+}
+
+static void io_sqpoll_cancel_sync(struct io_ring_ctx *ctx)
+{
+	struct io_sq_data *sqd = ctx->sq_data;
+	struct io_tctx_exit work = { .ctx = ctx, };
+	struct task_struct *task;
+
+	io_sq_thread_park(sqd);
+	list_del_init(&ctx->sqd_list);
+	io_sqd_update_thread_idle(sqd);
+	task = sqd->thread;
+	if (task) {
+		init_completion(&work.completion);
+		init_task_work(&work.task_work, io_sqpoll_cancel_cb);
+		WARN_ON_ONCE(task_work_add(task, &work.task_work, TWA_SIGNAL));
+		wake_up_process(task);
+	}
+	io_sq_thread_unpark(sqd);
+
+	if (task)
+		wait_for_completion(&work.completion);
+}
+
 void __io_uring_files_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
@@ -8855,41 +8857,40 @@ void __io_uring_files_cancel(struct files_struct *files)
 
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
-	xa_for_each(&tctx->xa, index, node)
-		io_uring_cancel_task_requests(node->ctx, files);
+	xa_for_each(&tctx->xa, index, node) {
+		struct io_ring_ctx *ctx = node->ctx;
+
+		if (ctx->sq_data) {
+			io_sqpoll_cancel_sync(ctx);
+			continue;
+		}
+		io_uring_cancel_files(ctx, current, files);
+		if (!files)
+			io_uring_try_cancel_requests(ctx, current, NULL);
+	}
 	atomic_dec(&tctx->in_idle);
 
 	if (files)
 		io_uring_clean_tctx(tctx);
 }
 
-static s64 tctx_inflight(struct io_uring_task *tctx)
-{
-	return percpu_counter_sum(&tctx->inflight);
-}
-
+/* should only be called by SQPOLL task */
 static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 {
 	struct io_sq_data *sqd = ctx->sq_data;
-	struct io_uring_task *tctx;
+	struct io_uring_task *tctx = current->io_uring;
 	s64 inflight;
 	DEFINE_WAIT(wait);
 
-	if (!sqd)
-		return;
-	io_sq_thread_park(sqd);
-	if (!sqd->thread || !sqd->thread->io_uring) {
-		io_sq_thread_unpark(sqd);
-		return;
-	}
-	tctx = ctx->sq_data->thread->io_uring;
+	WARN_ON_ONCE(!sqd || ctx->sq_data->thread != current);
+
 	atomic_inc(&tctx->in_idle);
 	do {
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx);
 		if (!inflight)
 			break;
-		io_uring_cancel_task_requests(ctx, NULL);
+		io_uring_try_cancel_requests(ctx, current, NULL);
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 		/*
@@ -8902,7 +8903,6 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
 	atomic_dec(&tctx->in_idle);
-	io_sq_thread_unpark(sqd);
 }
 
 /*
@@ -8917,15 +8917,6 @@ void __io_uring_task_cancel(void)
 
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
-
-	if (tctx->sqpoll) {
-		struct io_tctx_node *node;
-		unsigned long index;
-
-		xa_for_each(&tctx->xa, index, node)
-			io_uring_cancel_sqpoll(node->ctx);
-	}
-
 	do {
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx);
-- 
2.24.0

