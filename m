Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192FF2DE331
	for <lists+io-uring@lfdr.de>; Fri, 18 Dec 2020 14:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgLRNRW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 18 Dec 2020 08:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbgLRNRV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 18 Dec 2020 08:17:21 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31467C061248
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:07 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id g185so2517325wmf.3
        for <io-uring@vger.kernel.org>; Fri, 18 Dec 2020 05:16:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=7KvH11eCgjbAuPmRn/6GAVbXsD/rdwuQdebZEAB4z5A=;
        b=uhpnyBwsqDB7T4JWp3Oz10maVyJOL8jJHQnZEzZtGidIzv0V0rvjdKQEU84dw3qDz1
         NiEkMdAaVLFWRayIg3pfZVDeHM6Mj+gt7sC+pBRcOD1W+b+rs/Oerb+KQXNfl0YfkZeZ
         enFs5LbbzfJHRQvvq7g9A4Jcw7M5U449TQM/CnC0fbJOKGTsOZbx5Dey4pnHfipX2tLx
         b3byXHhh6JS9fvtDHIXj+lk8p0+SAE2GA7gl1SGoB9HzP3Wdt4lruBQP7X9XYQ6q246f
         lryXjW4jlGB5QI/tLbevMDyM21yh3R1XgEXIEKWdrGFTcJQhc5gNB02fFGMJOlMvqf7f
         WvoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7KvH11eCgjbAuPmRn/6GAVbXsD/rdwuQdebZEAB4z5A=;
        b=d/lW+eUyF9JX2C/5KNdu0/M1G2RKySGEEjy7HMDnxRP+ZOimNmETMzR1CGiH7LlRlq
         hDHCisljz8HxeSlm4zpFODbvVN5zYQvuk3bI4Da8k0juV56ypWcn2iupJw3HwZUhpsZt
         cu4HEE972mjw6LGOD5c/HTJ1PuFcANYaCbqlhlRNYehGDWtYugITGFwwmpNuVNeKQIQc
         sRjUebUBvWYmqSjhG4EtXMmQ+EIp2MBcHSJNBJt+kouWKve87uXfu9VrHqXYpe9tvmET
         GsaXKFiagAR9JkrZgSnkWX0HhKfyeiY8t96l1yUwuCurOI5YVp0tiD03WWA7YizXYVtW
         jjsQ==
X-Gm-Message-State: AOAM5317vujvsazJ/bizAVSDQuolRUrcrSdsrevOCRlBd6s6LjT0X0yc
        kbK9Ozg7qbg2hzgQn/u7jtI=
X-Google-Smtp-Source: ABdhPJyYU/Tr1B1Ur0lCxq1DZOgjoB1TMDw0+ZpLiNpxAefyJ4z8cH+mfhMUzQ771u8O1TbYBIjk9w==
X-Received: by 2002:a1c:5fd4:: with SMTP id t203mr4092844wmb.15.1608297365267;
        Fri, 18 Dec 2020 05:16:05 -0800 (PST)
Received: from localhost.localdomain ([85.255.234.120])
        by smtp.gmail.com with ESMTPSA id b9sm12778595wmd.32.2020.12.18.05.16.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Dec 2020 05:16:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/8] io_uring: remove old files cancel mechanism
Date:   Fri, 18 Dec 2020 13:12:26 +0000
Message-Id: <0cf6c5d55ae30a75d877f3dd3b53e162eeb6a950.1608296656.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1608296656.git.asml.silence@gmail.com>
References: <cover.1608296656.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

files cancellation is now based on counters, remove the old way we were
doing that with keeping a list of such requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 65 +++++++--------------------------------------------
 1 file changed, 9 insertions(+), 56 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d20a2a96c3f8..4bf709d9db32 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -379,7 +379,6 @@ struct io_ring_ctx {
 		bool			poll_multi_file;
 
 		spinlock_t		inflight_lock;
-		struct list_head	inflight_list;
 	} ____cacheline_aligned_in_smp;
 
 	struct delayed_work		file_put_work;
@@ -719,10 +718,7 @@ struct io_kiocb {
 	struct io_kiocb			*link;
 	struct percpu_ref		*fixed_file_refs;
 
-	/*
-	 * 1. used with ctx->iopoll_list with reads/writes
-	 * 2. to track reqs with ->files (see io_op_def::file_table)
-	 */
+	/* ctx->iopoll_list, tracks rw requests for iopoll_list */
 	struct list_head		inflight_entry;
 	struct callback_head		task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
@@ -1308,7 +1304,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	spin_lock_init(&ctx->inflight_lock);
-	INIT_LIST_HEAD(&ctx->inflight_list);
 	INIT_DELAYED_WORK(&ctx->file_put_work, io_file_put_work);
 	init_llist_head(&ctx->file_put_llist);
 	return ctx;
@@ -1498,7 +1493,6 @@ static bool io_grab_identity(struct io_kiocb *req)
 
 		spin_lock_irq(&ctx->inflight_lock);
 		atomic_inc(&current->io_uring->inflight_files);
-		list_add(&req->inflight_entry, &ctx->inflight_list);
 		spin_unlock_irq(&ctx->inflight_lock);
 		req->work.flags |= IO_WQ_WORK_FILES;
 	}
@@ -6101,7 +6095,6 @@ static void io_req_drop_files(struct io_kiocb *req)
 	put_files_struct(req->work.identity->files);
 	put_nsproxy(req->work.identity->nsproxy);
 	spin_lock_irqsave(&ctx->inflight_lock, flags);
-	list_del(&req->inflight_entry);
 	atomic_dec(&tctx->inflight_files);
 	spin_unlock_irqrestore(&ctx->inflight_lock, flags);
 	req->flags &= ~REQ_F_INFLIGHT;
@@ -8739,48 +8732,12 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 	}
 }
 
-static void io_uring_cancel_files(struct io_ring_ctx *ctx,
-				  struct task_struct *task,
-				  struct files_struct *files)
-{
-	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_task_cancel cancel = { .task = task, .files = files };
-		struct io_kiocb *req;
-		DEFINE_WAIT(wait);
-		bool found = false;
-
-		spin_lock_irq(&ctx->inflight_lock);
-		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
-			if (req->task != task ||
-			    req->work.identity->files != files)
-				continue;
-			found = true;
-			break;
-		}
-		if (found)
-			prepare_to_wait(&task->io_uring->wait, &wait,
-					TASK_UNINTERRUPTIBLE);
-		spin_unlock_irq(&ctx->inflight_lock);
-
-		/* We need to keep going until we don't find a matching req */
-		if (!found)
-			break;
-
-		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
-		io_poll_remove_all(ctx, task, files);
-		io_kill_timeouts(ctx, task, files);
-		/* cancellations _may_ trigger task work */
-		io_run_task_work();
-		schedule();
-		finish_wait(&task->io_uring->wait, &wait);
-	}
-}
-
 static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					    struct task_struct *task)
+					    struct task_struct *task,
+					    struct files_struct *files)
 {
 	while (1) {
-		struct io_task_cancel cancel = { .task = task, .files = NULL, };
+		struct io_task_cancel cancel = { .task = task, .files = files };
 		enum io_wq_cancel cret;
 		bool ret = false;
 
@@ -8789,18 +8746,18 @@ static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 			ret = true;
 
 		/* SQPOLL thread does its own polling */
-		if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
+		if (!(ctx->flags & IORING_SETUP_SQPOLL) && !files) {
 			while (!list_empty_careful(&ctx->iopoll_list)) {
 				io_iopoll_try_reap_events(ctx);
 				ret = true;
 			}
 		}
 
-		ret |= io_poll_remove_all(ctx, task, NULL);
-		ret |= io_kill_timeouts(ctx, task, NULL);
+		ret |= io_poll_remove_all(ctx, task, files);
+		ret |= io_kill_timeouts(ctx, task, files);
+		io_run_task_work();
 		if (!ret)
 			break;
-		io_run_task_work();
 		cond_resched();
 	}
 }
@@ -8825,11 +8782,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	io_ring_submit_lock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 	io_cqring_overflow_flush(ctx, true, task, files);
 	io_ring_submit_unlock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
-
-	if (!files)
-		__io_uring_cancel_task_requests(ctx, task);
-	else
-		io_uring_cancel_files(ctx, task, files);
+	__io_uring_cancel_task_requests(ctx, task, files);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);
-- 
2.24.0

