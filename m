Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76682A50DD
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 21:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgKCU2h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Nov 2020 15:28:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727688AbgKCU2g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Nov 2020 15:28:36 -0500
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E77C0613D1
        for <io-uring@vger.kernel.org>; Tue,  3 Nov 2020 12:28:36 -0800 (PST)
Received: by mail-il1-x143.google.com with SMTP id k1so17307493ilc.10
        for <io-uring@vger.kernel.org>; Tue, 03 Nov 2020 12:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N6iKcJ35otkmc/XZyz45ZMriqRwEYn8eTRWMnPS6gro=;
        b=hWzD7I57MwhuUVrIuKzTGzJdHh0p+5frjjsQZ+kW5wh6+Xy1tKru9+y9bnMPxOf5Ms
         PrK1pPSy0YzfC0r1Ko+cpm0Wi2NqjTITl26vmqPbE8/hCvJYa2zsEsmjJgMl+Jw1S7De
         ajjfWnGVPNf0DqUZDHXT8bmlH6KrUyCs0/SF37/9BiATus54oBlmt2Ld9TwJm8vnI5bX
         9/T6LYg5MVcxKvBETsriC+SWUA3MuQQD3FPYFDyI+3ivU+qPBo7WVksUjwexarb+5ZUI
         qUlGiTNMnYViA9E07Tus4/3gl87cdE1GRhDDpE2xOG8bzu8SI+aRPMOcC/7Df1hSLdGf
         kzag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N6iKcJ35otkmc/XZyz45ZMriqRwEYn8eTRWMnPS6gro=;
        b=Y4v1eDTlLRNX4oWBujsu6FNeaYU7cE7ppY+PYQ2BZBiLtGY9CobHj6WnImD7+dtCx7
         yn4jeFpc9qv2xoCEb7xtvK8DUwBkyOd2K1mgvODW3xj7ahDumlk/C5W1QdJKTPu2XBWU
         PutLi32KRuXj5z+nhK2VjGVJSEmHPRmQSf4tKSFxGgyJ0XWAy5aO5p91rfxBWqUoCRBE
         MxRVgPKfYEleyRtiMIWp2QuPvkQH8gLjzurhh1WkfkVk40anddQ+UWh8kvuK79wc6jlK
         G7qDUb0kg8oVtc1gtZtsAoURSvaMBN2BY2Whe9EKrUyBkgu1lYF1C+jqFlcsNye/enAS
         2D8w==
X-Gm-Message-State: AOAM530mbIvYs1Nr1cKNBZvfzAZ3JPINPrMJBPx+k+CeOT56MLWzvnJ8
        OPGy5P595Yjac5oFq8rdqq+7hMRrbMMqCg==
X-Google-Smtp-Source: ABdhPJyKckv2u5r2peRQtJ/Rwa3rg6tMFfEAG5McL7ps+YevycRcwpg3Ho5oHkoXq+EvEDJ4skhzlQ==
X-Received: by 2002:a05:6e02:112:: with SMTP id t18mr16139120ilm.299.1604435315923;
        Tue, 03 Nov 2020 12:28:35 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d6sm13472902ilf.19.2020.11.03.12.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 12:28:34 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: properly handle SQPOLL request cancelations
Date:   Tue,  3 Nov 2020 13:28:30 -0700
Message-Id: <20201103202832.923305-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103202832.923305-1-axboe@kernel.dk>
References: <20201103202832.923305-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Track if a given task io_uring context contains SQPOLL instances, so we
can iterate those for cancelation (and request counts). This ensures that
we properly wait on SQPOLL contexts, and find everything that needs
canceling.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c            | 77 +++++++++++++++++++++++++++++++++-------
 include/linux/io_uring.h |  3 +-
 2 files changed, 67 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2f6af230e86e..e6e7cec301b3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1668,7 +1668,8 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 		WRITE_ONCE(cqe->user_data, req->user_data);
 		WRITE_ONCE(cqe->res, res);
 		WRITE_ONCE(cqe->flags, cflags);
-	} else if (ctx->cq_overflow_flushed || req->task->io_uring->in_idle) {
+	} else if (ctx->cq_overflow_flushed ||
+		   atomic_read(&req->task->io_uring->in_idle)) {
 		/*
 		 * If we're in ring overflow flush mode, or in task cancel mode,
 		 * then we cannot store the request for later flushing, we need
@@ -1838,7 +1839,7 @@ static void __io_free_req(struct io_kiocb *req)
 	io_dismantle_req(req);
 
 	percpu_counter_dec(&tctx->inflight);
-	if (tctx->in_idle)
+	if (atomic_read(&tctx->in_idle))
 		wake_up(&tctx->wait);
 	put_task_struct(req->task);
 
@@ -7694,7 +7695,8 @@ static int io_uring_alloc_task_context(struct task_struct *task)
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
 	tctx->last = NULL;
-	tctx->in_idle = 0;
+	atomic_set(&tctx->in_idle, 0);
+	tctx->sqpoll = false;
 	io_init_identity(&tctx->__identity);
 	tctx->identity = &tctx->__identity;
 	task->io_uring = tctx;
@@ -8597,8 +8599,11 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 {
 	struct task_struct *task = current;
 
-	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data)
+	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		task = ctx->sq_data->thread;
+		atomic_inc(&task->io_uring->in_idle);
+		io_sq_thread_park(ctx->sq_data);
+	}
 
 	io_cqring_overflow_flush(ctx, true, task, files);
 
@@ -8606,12 +8611,23 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 		io_run_task_work();
 		cond_resched();
 	}
+
+	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
+		atomic_dec(&task->io_uring->in_idle);
+		/*
+		 * If the files that are going away are the ones in the thread
+		 * identity, clear them out.
+		 */
+		if (task->io_uring->identity->files == files)
+			task->io_uring->identity->files = NULL;
+		io_sq_thread_unpark(ctx->sq_data);
+	}
 }
 
 /*
  * Note that this task has used io_uring. We use it for cancelation purposes.
  */
-static int io_uring_add_task_file(struct file *file)
+static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 {
 	struct io_uring_task *tctx = current->io_uring;
 
@@ -8633,6 +8649,14 @@ static int io_uring_add_task_file(struct file *file)
 		tctx->last = file;
 	}
 
+	/*
+	 * This is race safe in that the task itself is doing this, hence it
+	 * cannot be going through the exit/cancel paths at the same time.
+	 * This cannot be modified while exit/cancel is running.
+	 */
+	if (!tctx->sqpoll && (ctx->flags & IORING_SETUP_SQPOLL))
+		tctx->sqpoll = true;
+
 	return 0;
 }
 
@@ -8674,7 +8698,7 @@ void __io_uring_files_cancel(struct files_struct *files)
 	unsigned long index;
 
 	/* make sure overflow events are dropped */
-	tctx->in_idle = true;
+	atomic_inc(&tctx->in_idle);
 
 	xa_for_each(&tctx->xa, index, file) {
 		struct io_ring_ctx *ctx = file->private_data;
@@ -8683,6 +8707,35 @@ void __io_uring_files_cancel(struct files_struct *files)
 		if (files)
 			io_uring_del_task_file(file);
 	}
+
+	atomic_dec(&tctx->in_idle);
+}
+
+static s64 tctx_inflight(struct io_uring_task *tctx)
+{
+	unsigned long index;
+	struct file *file;
+	s64 inflight;
+
+	inflight = percpu_counter_sum(&tctx->inflight);
+	if (!tctx->sqpoll)
+		return inflight;
+
+	/*
+	 * If we have SQPOLL rings, then we need to iterate and find them, and
+	 * add the pending count for those.
+	 */
+	xa_for_each(&tctx->xa, index, file) {
+		struct io_ring_ctx *ctx = file->private_data;
+
+		if (ctx->flags & IORING_SETUP_SQPOLL) {
+			struct io_uring_task *__tctx = ctx->sqo_task->io_uring;
+
+			inflight += percpu_counter_sum(&__tctx->inflight);
+		}
+	}
+
+	return inflight;
 }
 
 /*
@@ -8696,11 +8749,11 @@ void __io_uring_task_cancel(void)
 	s64 inflight;
 
 	/* make sure overflow events are dropped */
-	tctx->in_idle = true;
+	atomic_inc(&tctx->in_idle);
 
 	do {
 		/* read completions before cancelations */
-		inflight = percpu_counter_sum(&tctx->inflight);
+		inflight = tctx_inflight(tctx);
 		if (!inflight)
 			break;
 		__io_uring_files_cancel(NULL);
@@ -8711,13 +8764,13 @@ void __io_uring_task_cancel(void)
 		 * If we've seen completions, retry. This avoids a race where
 		 * a completion comes in before we did prepare_to_wait().
 		 */
-		if (inflight != percpu_counter_sum(&tctx->inflight))
+		if (inflight != tctx_inflight(tctx))
 			continue;
 		schedule();
 	} while (1);
 
 	finish_wait(&tctx->wait, &wait);
-	tctx->in_idle = false;
+	atomic_dec(&tctx->in_idle);
 }
 
 static int io_uring_flush(struct file *file, void *data)
@@ -8862,7 +8915,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			io_sqpoll_wait_sq(ctx);
 		submitted = to_submit;
 	} else if (to_submit) {
-		ret = io_uring_add_task_file(f.file);
+		ret = io_uring_add_task_file(ctx, f.file);
 		if (unlikely(ret))
 			goto out;
 		mutex_lock(&ctx->uring_lock);
@@ -9091,7 +9144,7 @@ static int io_uring_get_fd(struct io_ring_ctx *ctx)
 #if defined(CONFIG_UNIX)
 	ctx->ring_sock->file = file;
 #endif
-	if (unlikely(io_uring_add_task_file(file))) {
+	if (unlikely(io_uring_add_task_file(ctx, file))) {
 		file = ERR_PTR(-ENOMEM);
 		goto err_fd;
 	}
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 868364cea3b7..35b2d845704d 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -30,7 +30,8 @@ struct io_uring_task {
 	struct percpu_counter	inflight;
 	struct io_identity	__identity;
 	struct io_identity	*identity;
-	bool			in_idle;
+	atomic_t		in_idle;
+	bool			sqpoll;
 };
 
 #if defined(CONFIG_IO_URING)
-- 
2.29.2

