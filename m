Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3A53327F0A
	for <lists+io-uring@lfdr.de>; Mon,  1 Mar 2021 14:10:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235363AbhCANIS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Mar 2021 08:08:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235413AbhCANHN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Mar 2021 08:07:13 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FA0C061356
        for <io-uring@vger.kernel.org>; Mon,  1 Mar 2021 05:06:16 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id o7-20020a05600c4fc7b029010a0247d5f0so2973495wmq.1
        for <io-uring@vger.kernel.org>; Mon, 01 Mar 2021 05:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xxqcHyisP1GImoGM8hEjU50hzjhJ26ZTKKwXvtui6Ko=;
        b=hcex4GqtZMkzfXtT27GMZzYrdE7ljECJsWv2QSCYCPRIo1tpGzC5QUwZ4GkZSGg4sq
         jTFPtgQwZFqBrrg4r5JV6fLvKcIcNEqmKJ6l1iNfytD51y/Mp6kbqklwKD60WBUPWxrb
         lvDJt/gzZ1TO4FJHIAT+jpLe8Kq++Sx2Y5v26qVdnRwtjBF8wGbtDOg8JV6F0a7YL+4r
         BejcgOmAjwgDmzmn2GOWlJ08ig1kfdgbIR+nzfJbVW+1UYrkRZfpPZTQVSLbRH0lraHh
         CiwWjX/F+Rb/yxFY09FRrYIpup0KXyUaLY5ujEpwg/642EeGdszJTqObuSIjFtKJwhAe
         b59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xxqcHyisP1GImoGM8hEjU50hzjhJ26ZTKKwXvtui6Ko=;
        b=BzsV+7rnLT5trdvLcNh9MUSAtBqma4NfRMYLWnybEcALvMsnQtNKm+qtjv3DajNZj/
         +tinI1wcQspHljv65F93n6ZvRLl7TzR8hY3zVch1Xfbb1RPCd1QrfdyVClQOrIkYGx5K
         nowpcOhOm8FY9twEXMet43ucgyhMbmD6NsbBVPSfwyVzZ46ECSxbKcfOetTDUAkktFX0
         62/bREX2IEVDt4RtyTZHX0GP8I9hUXo/jRPWTh++Od/lC39l7ojH+UOGqTl2rpd6Obxn
         YLM3FL512JBoHexpQfK+x1WtBvD1GuJ+G38uAOtTA7t7FlbA67X4eBzTmDMQuvdCst6V
         hZhw==
X-Gm-Message-State: AOAM530W+1sM2whRFyKYbE6EVsxRiGPe2sPFUCLzk9WCUcO7bBOu5opQ
        4QiowT3DMv507aV0fMyuSxk=
X-Google-Smtp-Source: ABdhPJwFWtl28jjeZkffuj8NpKlUFWReWYYmdqNsb9ll/jO2rRbU1VEHYBknDEkrqURNeBNcj6ySVQ==
X-Received: by 2002:a7b:cb81:: with SMTP id m1mr15867488wmi.117.1614603975279;
        Mon, 01 Mar 2021 05:06:15 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id j16sm1898903wmi.2.2021.03.01.05.06.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 05:06:14 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: kill sqo_dead and sqo submission halting
Date:   Mon,  1 Mar 2021 13:02:15 +0000
Message-Id: <7c5c98128324970ea148f47653333b96d0a04117.1614603610.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614603610.git.asml.silence@gmail.com>
References: <cover.1614603610.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As SQPOLL task doesn't poke into ->sqo_task anymore, there is no need to
kill the sqo when the master task exits. Before it was necessary to
avoid races accessing sqo_task->files with removing them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 40 +++-------------------------------------
 1 file changed, 3 insertions(+), 37 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 54e6c4db9620..6529761b77eb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -338,7 +338,6 @@ struct io_ring_ctx {
 		unsigned int		drain_next: 1;
 		unsigned int		eventfd_async: 1;
 		unsigned int		restricted: 1;
-		unsigned int		sqo_dead: 1;
 		unsigned int		sqo_exec: 1;
 
 		/*
@@ -1972,7 +1971,7 @@ static void __io_req_task_submit(struct io_kiocb *req)
 
 	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
 	mutex_lock(&ctx->uring_lock);
-	if (!ctx->sqo_dead && !(current->flags & PF_EXITING) && !current->in_execve)
+	if (!(current->flags & PF_EXITING) && !current->in_execve)
 		__io_queue_sqe(req);
 	else
 		__io_req_task_cancel(req, -EFAULT);
@@ -6583,8 +6582,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		if (!list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, &nr_events, 0);
 
-		if (to_submit && !ctx->sqo_dead &&
-		    likely(!percpu_ref_is_dying(&ctx->refs)))
+		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)))
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 	}
@@ -7823,7 +7821,7 @@ static int io_sq_thread_fork(struct io_sq_data *sqd, struct io_ring_ctx *ctx)
 
 	clear_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 	reinit_completion(&sqd->completion);
-	ctx->sqo_dead = ctx->sqo_exec = 0;
+	ctx->sqo_exec = 0;
 	sqd->task_pid = current->pid;
 	current->flags |= PF_IO_WORKER;
 	ret = io_wq_fork_thread(io_sq_thread, sqd);
@@ -8534,10 +8532,6 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
-
-	if (WARN_ON_ONCE((ctx->flags & IORING_SETUP_SQPOLL) && !ctx->sqo_dead))
-		ctx->sqo_dead = 1;
-
 	/* if force is set, the ring is going away. always drop after that */
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
@@ -8697,19 +8691,6 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 	}
 }
 
-static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
-{
-	mutex_lock(&ctx->uring_lock);
-	ctx->sqo_dead = 1;
-	if (ctx->flags & IORING_SETUP_R_DISABLED)
-		io_sq_offload_start(ctx);
-	mutex_unlock(&ctx->uring_lock);
-
-	/* make sure callers enter the ring to get error */
-	if (ctx->rings)
-		io_ring_set_wakeup_flag(ctx);
-}
-
 /*
  * We need to iteratively cancel requests, in case a request has dependent
  * hard links. These persist even for failure of cancelations, hence keep
@@ -8722,7 +8703,6 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	bool did_park = false;
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
-		io_disable_sqo_submit(ctx);
 		did_park = io_sq_thread_park(ctx->sq_data);
 		if (did_park) {
 			task = ctx->sq_data->thread;
@@ -8843,7 +8823,6 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 
 	if (!sqd)
 		return;
-	io_disable_sqo_submit(ctx);
 	if (!io_sq_thread_park(sqd))
 		return;
 	tctx = ctx->sq_data->thread->io_uring;
@@ -8888,7 +8867,6 @@ void __io_uring_task_cancel(void)
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
 
-	/* trigger io_disable_sqo_submit() */
 	if (tctx->sqpoll) {
 		struct file *file;
 		unsigned long index;
@@ -9019,22 +8997,14 @@ static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 	do {
 		if (!io_sqring_full(ctx))
 			break;
-
 		prepare_to_wait(&ctx->sqo_sq_wait, &wait, TASK_INTERRUPTIBLE);
 
-		if (unlikely(ctx->sqo_dead)) {
-			ret = -EOWNERDEAD;
-			goto out;
-		}
-
 		if (!io_sqring_full(ctx))
 			break;
-
 		schedule();
 	} while (!signal_pending(current));
 
 	finish_wait(&ctx->sqo_sq_wait, &wait);
-out:
 	return ret;
 }
 
@@ -9120,8 +9090,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 				goto out;
 		}
 		ret = -EOWNERDEAD;
-		if (unlikely(ctx->sqo_dead))
-			goto out;
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT) {
@@ -9493,7 +9461,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	 */
 	ret = io_uring_install_fd(ctx, file);
 	if (ret < 0) {
-		io_disable_sqo_submit(ctx);
 		/* fput will clean it up */
 		fput(file);
 		return ret;
@@ -9502,7 +9469,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
 err:
-	io_disable_sqo_submit(ctx);
 	io_ring_ctx_wait_and_kill(ctx);
 	return ret;
 }
-- 
2.24.0

