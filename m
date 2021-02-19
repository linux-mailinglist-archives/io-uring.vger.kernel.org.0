Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBC231FDA4
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhBSRLI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhBSRLC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:11:02 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D9EBC06178C
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:22 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id e2so5094615ilu.0
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=w9MVsmqznQdznWQZg/8FUWywhdOpKtORjnKXHW7sAkc=;
        b=PT0VyAx5RHvWh7/Cke5yJARrChmEnox0lEaV7/G1RZdyV2iM2Acwt5ySeqDYGUQeGM
         FXJA4MY/Mt7cPo/CHV54sUY5KA7mBiWx5bQA6hEfA+Byxby2hXa6MKpk7WWG5jVFTdZS
         Lbn+aDMAt86K884NAjtNTT1ESolLc5nC0M2x1zqU4HAbetZ3TNmaJ7+PgrlWEwK8cvP2
         A8CwO+8+mKgXJOBmUD1vGLFJr73N6dW2OZ0yAXwqks1UZJUW8nmET2QciVq8/hVYtcCe
         Nu1vvBfMd2QnQ6TaVzi0yAhsYpixfWo3TeJXNWhGFsPfLgBC/dieDpCPmktMcFW5Hj0E
         R4IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=w9MVsmqznQdznWQZg/8FUWywhdOpKtORjnKXHW7sAkc=;
        b=nxUR+HGjsjL+baDd+DxZ+Hdjif5WI2IGWUn2IOlUnf+bP/SgjiBOyLG1su+JZXZqMA
         /acuJrqkOenopZ22N198TjHJBrsNzFgAF0Eo1ffgcWD8ZEz4/TfRhbqjAMaYuaoTILDR
         g/DW2vritZOa6/TYZzhCGHHwrBCgU/vtm+h3z6RweYnshxgfPwqRxGK3lWlmt+WOCS88
         vfmSPiKP6e+KVry/Fj9lCuAPfj3+kxaehCLYM4GdhEKdlYnYCkExsyl8iU6FHESjdByi
         dtlT/LsJ8WX7tEf1NI3cG88PeZUBqcmCk7Yi0BSEFiF6RTJKzeAFC/EWhyWyUXSRIGBz
         w3uQ==
X-Gm-Message-State: AOAM533cnRbpjBM4dSvGhIrI6lDpHlef/4R/Xvfeilagt0yJqdWz+ZyP
        seAcZZ9vTff+rQvoRr1gaO0ikHyiqMHBbSgx
X-Google-Smtp-Source: ABdhPJx5/GrSqv0S3zE335BmruRSpj8zvL0ZEkzBgGjdx540fTHMIqVZxl/hGwUakQ0QXyW9m5u+ZQ==
X-Received: by 2002:a05:6e02:60b:: with SMTP id t11mr4552700ils.166.1613754621738;
        Fri, 19 Feb 2021 09:10:21 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:21 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/18] io_uring: tie async worker side to the task context
Date:   Fri, 19 Feb 2021 10:09:57 -0700
Message-Id: <20210219171010.281878-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move it outside of the io_ring_ctx, and tie it to the io_uring task
context.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c            | 84 ++++++++++++++++------------------------
 include/linux/io_uring.h |  1 +
 2 files changed, 35 insertions(+), 50 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0eeb2a1596c2..6ad3e1df6504 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -365,9 +365,6 @@ struct io_ring_ctx {
 
 	struct io_rings	*rings;
 
-	/* IO offload */
-	struct io_wq		*io_wq;
-
 	/*
 	 * For SQPOLL usage - we hold a reference to the parent task, so we
 	 * have access to the ->files
@@ -1619,10 +1616,11 @@ static struct io_kiocb *__io_queue_async_work(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *link = io_prep_linked_timeout(req);
+	struct io_uring_task *tctx = req->task->io_uring;
 
 	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
 					&req->work, req->flags);
-	io_wq_enqueue(ctx->io_wq, &req->work);
+	io_wq_enqueue(tctx->io_wq, &req->work);
 	return link;
 }
 
@@ -5969,12 +5967,15 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
 	return req->user_data == (unsigned long) data;
 }
 
-static int io_async_cancel_one(struct io_ring_ctx *ctx, void *sqe_addr)
+static int io_async_cancel_one(struct io_uring_task *tctx, void *sqe_addr)
 {
 	enum io_wq_cancel cancel_ret;
 	int ret = 0;
 
-	cancel_ret = io_wq_cancel_cb(ctx->io_wq, io_cancel_cb, sqe_addr, false);
+	if (!tctx->io_wq)
+		return -ENOENT;
+
+	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, sqe_addr, false);
 	switch (cancel_ret) {
 	case IO_WQ_CANCEL_OK:
 		ret = 0;
@@ -5997,7 +5998,8 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	unsigned long flags;
 	int ret;
 
-	ret = io_async_cancel_one(ctx, (void *) (unsigned long) sqe_addr);
+	ret = io_async_cancel_one(req->task->io_uring,
+					(void *) (unsigned long) sqe_addr);
 	if (ret != -ENOENT) {
 		spin_lock_irqsave(&ctx->completion_lock, flags);
 		goto done;
@@ -7562,16 +7564,6 @@ static void io_sq_thread_stop(struct io_ring_ctx *ctx)
 	}
 }
 
-static void io_finish_async(struct io_ring_ctx *ctx)
-{
-	io_sq_thread_stop(ctx);
-
-	if (ctx->io_wq) {
-		io_wq_destroy(ctx->io_wq);
-		ctx->io_wq = NULL;
-	}
-}
-
 #if defined(CONFIG_UNIX)
 /*
  * Ensure the UNIX gc is aware of our file set, so we are certain that
@@ -8130,11 +8122,10 @@ static struct io_wq_work *io_free_work(struct io_wq_work *work)
 	return req ? &req->work : NULL;
 }
 
-static int io_init_wq_offload(struct io_ring_ctx *ctx)
+static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx)
 {
 	struct io_wq_data data;
 	unsigned int concurrency;
-	int ret = 0;
 
 	data.user = ctx->user;
 	data.free_work = io_free_work;
@@ -8143,16 +8134,11 @@ static int io_init_wq_offload(struct io_ring_ctx *ctx)
 	/* Do QD, or 4 * CPUS, whatever is smallest */
 	concurrency = min(ctx->sq_entries, 4 * num_online_cpus());
 
-	ctx->io_wq = io_wq_create(concurrency, &data);
-	if (IS_ERR(ctx->io_wq)) {
-		ret = PTR_ERR(ctx->io_wq);
-		ctx->io_wq = NULL;
-	}
-
-	return ret;
+	return io_wq_create(concurrency, &data);
 }
 
-static int io_uring_alloc_task_context(struct task_struct *task)
+static int io_uring_alloc_task_context(struct task_struct *task,
+				       struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx;
 	int ret;
@@ -8167,6 +8153,14 @@ static int io_uring_alloc_task_context(struct task_struct *task)
 		return ret;
 	}
 
+	tctx->io_wq = io_init_wq_offload(ctx);
+	if (IS_ERR(tctx->io_wq)) {
+		ret = PTR_ERR(tctx->io_wq);
+		percpu_counter_destroy(&tctx->inflight);
+		kfree(tctx);
+		return ret;
+	}
+
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
 	tctx->last = NULL;
@@ -8239,7 +8233,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			ctx->sq_thread_idle = HZ;
 
 		if (sqd->thread)
-			goto done;
+			return 0;
 
 		if (p->flags & IORING_SETUP_SQ_AFF) {
 			int cpu = p->sq_thread_cpu;
@@ -8261,7 +8255,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 			sqd->thread = NULL;
 			goto err;
 		}
-		ret = io_uring_alloc_task_context(sqd->thread);
+		ret = io_uring_alloc_task_context(sqd->thread, ctx);
 		if (ret)
 			goto err;
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
@@ -8270,14 +8264,9 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		goto err;
 	}
 
-done:
-	ret = io_init_wq_offload(ctx);
-	if (ret)
-		goto err;
-
 	return 0;
 err:
-	io_finish_async(ctx);
+	io_sq_thread_stop(ctx);
 	return ret;
 }
 
@@ -8752,7 +8741,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	mutex_lock(&ctx->uring_lock);
 	mutex_unlock(&ctx->uring_lock);
 
-	io_finish_async(ctx);
+	io_sq_thread_stop(ctx);
 	io_sqe_buffers_unregister(ctx);
 
 	if (ctx->sqo_task) {
@@ -8872,13 +8861,6 @@ static void io_ring_exit_work(struct work_struct *work)
 	io_ring_ctx_free(ctx);
 }
 
-static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-
-	return req->ctx == data;
-}
-
 static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
@@ -8897,9 +8879,6 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	io_kill_timeouts(ctx, NULL, NULL);
 	io_poll_remove_all(ctx, NULL, NULL);
 
-	if (ctx->io_wq)
-		io_wq_cancel_cb(ctx->io_wq, io_cancel_ctx_cb, ctx, true);
-
 	/* if we failed setting up the ctx, we might not have any rings */
 	io_iopoll_try_reap_events(ctx);
 
@@ -8978,13 +8957,14 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct files_struct *files)
 {
 	struct io_task_cancel cancel = { .task = task, .files = files, };
+	struct io_uring_task *tctx = current->io_uring;
 
 	while (1) {
 		enum io_wq_cancel cret;
 		bool ret = false;
 
-		if (ctx->io_wq) {
-			cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb,
+		if (tctx && tctx->io_wq) {
+			cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_task_cb,
 					       &cancel, true);
 			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
 		}
@@ -9096,7 +9076,7 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 	int ret;
 
 	if (unlikely(!tctx)) {
-		ret = io_uring_alloc_task_context(current);
+		ret = io_uring_alloc_task_context(current, ctx);
 		if (unlikely(ret))
 			return ret;
 		tctx = current->io_uring;
@@ -9166,8 +9146,12 @@ void __io_uring_files_cancel(struct files_struct *files)
 		io_uring_cancel_task_requests(file->private_data, files);
 	atomic_dec(&tctx->in_idle);
 
-	if (files)
+	if (files) {
 		io_uring_remove_task_files(tctx);
+	} else if (tctx->io_wq && current->flags & PF_EXITING) {
+		io_wq_destroy(tctx->io_wq);
+		tctx->io_wq = NULL;
+	}
 }
 
 static s64 tctx_inflight(struct io_uring_task *tctx)
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 2eb6d19de336..0e95398998b6 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -36,6 +36,7 @@ struct io_uring_task {
 	struct xarray		xa;
 	struct wait_queue_head	wait;
 	struct file		*last;
+	void			*io_wq;
 	struct percpu_counter	inflight;
 	struct io_identity	__identity;
 	struct io_identity	*identity;
-- 
2.30.0

