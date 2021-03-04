Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C60432C992
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:18:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240710AbhCDBKL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 20:10:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376580AbhCDAex (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 19:34:53 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E32DDC0610D4
        for <io-uring@vger.kernel.org>; Wed,  3 Mar 2021 16:27:34 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id j12so17510419pfj.12
        for <io-uring@vger.kernel.org>; Wed, 03 Mar 2021 16:27:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qcQQd44guJLGN0E55hIgEst24Wu+o+7Nj1hqwI4uXB4=;
        b=cD997VsnqyVJe0AUkTsd/nEqrWiPfG5Hk+Sz4IYVvv62bSJYt8L6tUxWq/UVqLX/Af
         WCGBCUG48dI3aQg9oKLHT/AXMEHs8dtCVCJLIqCfptZYEqAOYTes+G4GAOZpadR3yty+
         uBP6IHUNYdvc6HA6GSaeExt1eNBQ7AHVIxAPoWBUuu1xYxQKxpbeanY1aP22/4zQkOWv
         j8JaoZxIlRXQ6X2CBPoG420RviXXxgHF7Gk43t7u60D7KJSbRG00HXwGL1fXivSO8AlZ
         Pk1wSELXcU81GnFOjeSO8p8H8JaS6EFWIDis0hC1nzAnWQhk3ra0xVSNxq6l7WbAxgY6
         Ozrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qcQQd44guJLGN0E55hIgEst24Wu+o+7Nj1hqwI4uXB4=;
        b=Mrktjc7WaIg9045Q6AkQh8vmMuH7AgcEKYYs8bucVGcBFA7BeL0/E4JIVM4Pn/0Fpd
         e4OPOOSjd9rRLP2R4K6x2dbBTIGEB3ey09rD2EdCm3jvsk4M42W10S8wanamnGhLsilJ
         aR6ei8llzOhrLNuDxYMjIujkF9QIMHknpYgO4S221ulKv0bBpx6960kxv8ek48+V0QLy
         Xnk6A1fbEGgBtGwVLAkYhMlmuo8/p53aQndTobZ4FEoFEXlYjhsfgAJLTo32P1RiAnFu
         rzFGwYJqbUaeX44y/vf5Aw+/GLalA3KV65WKBUs1hH9r1OA1Wk63rc05Fk67+AUaa0aO
         YkrA==
X-Gm-Message-State: AOAM530Qj5JV0XxaIA4ifswLj338uPd+D/Y1ExgvRV1GaoPcvZeQ2WXi
        8bIEaL6J6vUKLnVzsfXFXvXBL0FILdTH8Yga
X-Google-Smtp-Source: ABdhPJwMEqBHlqed37Qsf69iIQ6WmRYmUzMEtD5VedkwKxGRUJYjU60XxM8+F+gv5tzBAVc+B5CZWw==
X-Received: by 2002:a05:6a00:1502:b029:1d2:72e7:a9db with SMTP id q2-20020a056a001502b02901d272e7a9dbmr1286976pfu.42.1614817654163;
        Wed, 03 Mar 2021 16:27:34 -0800 (PST)
Received: from localhost.localdomain ([2600:380:7540:52b5:3f01:150c:3b2:bf47])
        by smtp.gmail.com with ESMTPSA id b6sm23456983pgt.69.2021.03.03.16.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 16:27:33 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 24/33] io_uring: kill sqo_dead and sqo submission halting
Date:   Wed,  3 Mar 2021 17:26:51 -0700
Message-Id: <20210304002700.374417-25-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210304002700.374417-1-axboe@kernel.dk>
References: <20210304002700.374417-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

As SQPOLL task doesn't poke into ->sqo_task anymore, there is no need to
kill the sqo when the master task exits. Before it was necessary to
avoid races accessing sqo_task->files with removing them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
[axboe: don't forget to enable SQPOLL before exit, if started disabled]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 45 ++++++++-------------------------------------
 1 file changed, 8 insertions(+), 37 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bdaeda5eefd5..da90d877afd4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -338,7 +338,6 @@ struct io_ring_ctx {
 		unsigned int		drain_next: 1;
 		unsigned int		eventfd_async: 1;
 		unsigned int		restricted: 1;
-		unsigned int		sqo_dead: 1;
 		unsigned int		sqo_exec: 1;
 
 		/*
@@ -1967,7 +1966,7 @@ static void __io_req_task_submit(struct io_kiocb *req)
 
 	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
 	mutex_lock(&ctx->uring_lock);
-	if (!ctx->sqo_dead && !(current->flags & PF_EXITING) && !current->in_execve)
+	if (!(current->flags & PF_EXITING) && !current->in_execve)
 		__io_queue_sqe(req);
 	else
 		__io_req_task_cancel(req, -EFAULT);
@@ -6578,8 +6577,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		if (!list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, &nr_events, 0);
 
-		if (to_submit && !ctx->sqo_dead &&
-		    likely(!percpu_ref_is_dying(&ctx->refs)))
+		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)))
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 	}
@@ -7818,7 +7816,7 @@ static int io_sq_thread_fork(struct io_sq_data *sqd, struct io_ring_ctx *ctx)
 
 	clear_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 	reinit_completion(&sqd->completion);
-	ctx->sqo_dead = ctx->sqo_exec = 0;
+	ctx->sqo_exec = 0;
 	sqd->task_pid = current->pid;
 	current->flags |= PF_IO_WORKER;
 	ret = io_wq_fork_thread(io_sq_thread, sqd);
@@ -8529,10 +8527,6 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
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
@@ -8692,19 +8686,6 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
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
@@ -8717,7 +8698,11 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	bool did_park = false;
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
-		io_disable_sqo_submit(ctx);
+		/* never started, nothing to cancel */
+		if (ctx->flags & IORING_SETUP_R_DISABLED) {
+			io_sq_offload_start(ctx);
+			return;
+		}
 		did_park = io_sq_thread_park(ctx->sq_data);
 		if (did_park) {
 			task = ctx->sq_data->thread;
@@ -8838,7 +8823,6 @@ static void io_uring_cancel_sqpoll(struct io_ring_ctx *ctx)
 
 	if (!sqd)
 		return;
-	io_disable_sqo_submit(ctx);
 	if (!io_sq_thread_park(sqd))
 		return;
 	tctx = ctx->sq_data->thread->io_uring;
@@ -8883,7 +8867,6 @@ void __io_uring_task_cancel(void)
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
 
-	/* trigger io_disable_sqo_submit() */
 	if (tctx->sqpoll) {
 		struct file *file;
 		unsigned long index;
@@ -9014,22 +8997,14 @@ static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
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
 
@@ -9115,8 +9090,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 				goto out;
 		}
 		ret = -EOWNERDEAD;
-		if (unlikely(ctx->sqo_dead))
-			goto out;
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT) {
@@ -9488,7 +9461,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	 */
 	ret = io_uring_install_fd(ctx, file);
 	if (ret < 0) {
-		io_disable_sqo_submit(ctx);
 		/* fput will clean it up */
 		fput(file);
 		return ret;
@@ -9497,7 +9469,6 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
 err:
-	io_disable_sqo_submit(ctx);
 	io_ring_ctx_wait_and_kill(ctx);
 	return ret;
 }
-- 
2.30.1

