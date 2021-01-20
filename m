Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD172FC8A9
	for <lists+io-uring@lfdr.de>; Wed, 20 Jan 2021 04:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727013AbhATDVv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Jan 2021 22:21:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732047AbhATCg6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Jan 2021 21:36:58 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07B35C0613D3
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 18:36:13 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id c12so3077530wrc.7
        for <io-uring@vger.kernel.org>; Tue, 19 Jan 2021 18:36:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=AiABA+9r/A5YLdYNGu/JJz0pZuHRSE2yf5vZByxBhTI=;
        b=M4lUDnb8O7oufB9vGTDwQD7JZmc6dFfBe3todZR9/JSNxPkpKQQlumzTVcUi7igAFx
         HtgkssKhW3k6Yk98AZ8iMf6ip3jWI+tqdnrqv1ck3BTV1/vudKlgNoUPcYjFeoq+lPuy
         IFnAGWC6jzXcoecFOYTUuvQBX7xe9mYDf0We5c32Ju6IhIK8/pw/tIU0YIbNv4D3YaQp
         MW9HwgeFjV0tJqeDIvshaq0y+i2j+bzLLWuUsYRRyuOLnLzGhFZpZv25ZA9tKOai6LgP
         8Jln7TFWpj15+2i/CHbOHOVQISi+GBf2k+PVLrKldJni7RD29VFDGONiheR566KNAvZB
         NwXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=AiABA+9r/A5YLdYNGu/JJz0pZuHRSE2yf5vZByxBhTI=;
        b=gtjrZMVqDBURkekJOXfvJHHouzLuPGdiNv8FVb4BQ2QDOBtbC1k7tf08D7FtIJbOJw
         ZpleQNEwkfyKx1ffNjYc6FsqKGG+poUvnRI1ldwd4DzuHpgYT2RFuqljDzXEkBa/HM32
         HfSyubD8tox9oiv7t1FvZ+IRpws5E8J5PpBOeXygpXLtk2MO3PEN0OhjpO1DqpNbvfxe
         yTEK4JOkMnCTjOJP5dIq8rrWwDsXRQRSJWSOwH8CAq9DJ4sjbGJ/Oihvpz4YIw4tIR6T
         YutbREjJxcsOyvkPZC7egWESo+VAc7lQPsBW5z2zfFSNXsuI/qMDEJTQqgCXdDSB12YH
         RB2g==
X-Gm-Message-State: AOAM5322Hccb1wUQ79UjQsc12Z+xb+1+BOaSYJ17v2irQHg5/NAhxKqM
        GzjEJcUwPXMfyAw0MGp/fcE=
X-Google-Smtp-Source: ABdhPJzgDF6JZdw5DD7IAVQi0kClWG52Q+DPLnS+agNe4VtGVFnnXZJWc6WwOwaOhQrXzylaU1061w==
X-Received: by 2002:adf:ec11:: with SMTP id x17mr4406915wrn.4.1611110171813;
        Tue, 19 Jan 2021 18:36:11 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.152])
        by smtp.gmail.com with ESMTPSA id v20sm1082767wra.19.2021.01.19.18.36.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jan 2021 18:36:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: don't pass files for cancellation
Date:   Wed, 20 Jan 2021 02:32:25 +0000
Message-Id: <65f4f72eb2bf1b6b6f7e9f35745fc95d64396acd.1611109718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1611109718.git.asml.silence@gmail.com>
References: <cover.1611109718.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove files from io_uring_cancel_task_requests() and propagate it down,
we don't need as only task is used for it.

One trickier change is removing NULL'ing identity->files in
io_uring_cancel_task_requests(), which is possible because the SQPOLL
task is guaranteed now to be drained and submission-disabled before
cancellation ends, so it's equivalent.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 83 +++++++++++++++++----------------------------------
 1 file changed, 28 insertions(+), 55 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8d181ef44398..91e54d936dd4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1072,24 +1072,9 @@ static inline void io_set_resource_node(struct io_kiocb *req)
 	}
 }
 
-static bool io_match_task(struct io_kiocb *head,
-			  struct task_struct *task,
-			  struct files_struct *files)
+static inline bool io_match_task(struct io_kiocb *req, struct task_struct *task)
 {
-	struct io_kiocb *req;
-
-	if (task && head->task != task)
-		return false;
-	if (!files)
-		return true;
-
-	io_for_each_link(req, head) {
-		if ((req->flags & REQ_F_WORK_INITIALIZED) &&
-		    (req->work.flags & IO_WQ_WORK_FILES) &&
-		    req->work.identity->files == files)
-			return true;
-	}
-	return false;
+	return !task || req->task == task;
 }
 
 static void io_sq_thread_drop_mm_files(void)
@@ -1591,15 +1576,14 @@ static void io_kill_timeout(struct io_kiocb *req)
 /*
  * Returns true if we found and killed one or more timeouts
  */
-static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
-			     struct files_struct *files)
+static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk)
 {
 	struct io_kiocb *req, *tmp;
 	int canceled = 0;
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
-		if (io_match_task(req, tsk, files)) {
+		if (io_match_task(req, tsk)) {
 			io_kill_timeout(req);
 			canceled++;
 		}
@@ -1752,8 +1736,7 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 
 /* Returns true if there are no backlogged entries after the flush */
 static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
-				       struct task_struct *tsk,
-				       struct files_struct *files)
+				       struct task_struct *tsk)
 {
 	struct io_rings *rings = ctx->rings;
 	struct io_kiocb *req, *tmp;
@@ -1767,7 +1750,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 	list_for_each_entry_safe(req, tmp, &ctx->cq_overflow_list, compl.list) {
-		if (!io_match_task(req, tsk, files))
+		if (!io_match_task(req, tsk))
 			continue;
 
 		cqe = io_get_cqring(ctx);
@@ -1807,14 +1790,13 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 }
 
 static void io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
-				     struct task_struct *tsk,
-				     struct files_struct *files)
+				     struct task_struct *tsk)
 {
 	if (test_bit(0, &ctx->cq_check_overflow)) {
 		/* iopoll syncs against uring_lock, not completion_lock */
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_lock(&ctx->uring_lock);
-		__io_cqring_overflow_flush(ctx, force, tsk, files);
+		__io_cqring_overflow_flush(ctx, force, tsk);
 		if (ctx->flags & IORING_SETUP_IOPOLL)
 			mutex_unlock(&ctx->uring_lock);
 	}
@@ -2597,7 +2579,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		 * already triggered a CQE (eg in error).
 		 */
 		if (test_bit(0, &ctx->cq_check_overflow))
-			__io_cqring_overflow_flush(ctx, false, NULL, NULL);
+			__io_cqring_overflow_flush(ctx, false, NULL);
 		if (io_cqring_events(ctx))
 			break;
 
@@ -5518,8 +5500,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 /*
  * Returns true if we found and killed one or more poll requests
  */
-static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
-			       struct files_struct *files)
+static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk)
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
@@ -5531,7 +5512,7 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
-			if (io_match_task(req, tsk, files))
+			if (io_match_task(req, tsk))
 				posted += io_poll_remove_one(req);
 		}
 	}
@@ -6872,7 +6853,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
-		if (!__io_cqring_overflow_flush(ctx, false, NULL, NULL))
+		if (!__io_cqring_overflow_flush(ctx, false, NULL))
 			return -EBUSY;
 	}
 
@@ -7200,7 +7181,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	int ret = 0;
 
 	do {
-		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		io_cqring_overflow_flush(ctx, false, NULL);
 		if (io_cqring_events(ctx) >= min_events)
 			return 0;
 		if (!io_run_task_work())
@@ -7229,7 +7210,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
-		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		io_cqring_overflow_flush(ctx, false, NULL);
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		/* make sure we run task_work before checking for signals */
@@ -8747,7 +8728,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	smp_rmb();
 	if (!io_sqring_full(ctx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
-	io_cqring_overflow_flush(ctx, false, NULL, NULL);
+	io_cqring_overflow_flush(ctx, false, NULL);
 	if (io_cqring_events(ctx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
@@ -8810,12 +8791,12 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/* if force is set, the ring is going away. always drop after that */
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
-		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
+		__io_cqring_overflow_flush(ctx, true, NULL);
 	idr_for_each(&ctx->personality_idr, io_remove_personalities, ctx);
 	mutex_unlock(&ctx->uring_lock);
 
-	io_kill_timeouts(ctx, NULL, NULL);
-	io_poll_remove_all(ctx, NULL, NULL);
+	io_kill_timeouts(ctx, NULL);
+	io_poll_remove_all(ctx, NULL);
 
 	if (ctx->io_wq)
 		io_wq_cancel_cb(ctx->io_wq, io_cancel_ctx_cb, ctx, true);
@@ -8855,19 +8836,18 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct task_struct *tsk = data;
 
-	return io_match_task(req, tsk, NULL);
+	return io_match_task(req, tsk);
 }
 
 static void io_cancel_defer_files(struct io_ring_ctx *ctx,
-				  struct task_struct *task,
-				  struct files_struct *files)
+				  struct task_struct *task)
 {
 	struct io_defer_entry *de = NULL;
 	LIST_HEAD(list);
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
-		if (io_match_task(de->req, task, files)) {
+		if (io_match_task(de->req, task)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
@@ -8905,8 +8885,8 @@ static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 			}
 		}
 
-		ret |= io_poll_remove_all(ctx, task, NULL);
-		ret |= io_kill_timeouts(ctx, task, NULL);
+		ret |= io_poll_remove_all(ctx, task);
+		ret |= io_kill_timeouts(ctx, task);
 		ret |= io_run_task_work();
 		if (!ret)
 			break;
@@ -8930,8 +8910,7 @@ static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
  * hard links. These persist even for failure of cancelations, hence keep
  * looping until none are found.
  */
-static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					  struct files_struct *files)
+static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx)
 {
 	struct task_struct *task = current;
 
@@ -8944,18 +8923,12 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 		io_sq_thread_park(ctx->sq_data);
 	}
 
-	io_cancel_defer_files(ctx, task, files);
-	io_cqring_overflow_flush(ctx, true, task, files);
+	io_cancel_defer_files(ctx, task);
+	io_cqring_overflow_flush(ctx, true, task);
 	__io_uring_cancel_task_requests(ctx, task);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);
-		/*
-		 * If the files that are going away are the ones in the thread
-		 * identity, clear them out.
-		 */
-		if (task->io_uring->identity->files == files)
-			task->io_uring->identity->files = NULL;
 		io_sq_thread_unpark(ctx->sq_data);
 	}
 }
@@ -9032,7 +9005,7 @@ static void __io_uring_files_cancel(void)
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
 	xa_for_each(&tctx->xa, index, file)
-		io_uring_cancel_task_requests(file->private_data, NULL);
+		io_uring_cancel_task_requests(file->private_data);
 	atomic_dec(&tctx->in_idle);
 }
 
@@ -9306,7 +9279,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		io_cqring_overflow_flush(ctx, false, NULL);
 
 		ret = -EOWNERDEAD;
 		if (unlikely(ctx->sqo_dead))
-- 
2.24.0

