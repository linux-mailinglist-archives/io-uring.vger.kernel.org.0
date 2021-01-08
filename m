Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A482EF9D8
	for <lists+io-uring@lfdr.de>; Fri,  8 Jan 2021 22:05:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729175AbhAHVBu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Jan 2021 16:01:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbhAHVBt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Jan 2021 16:01:49 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F254C061796
        for <io-uring@vger.kernel.org>; Fri,  8 Jan 2021 13:01:09 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id m5so10220230wrx.9
        for <io-uring@vger.kernel.org>; Fri, 08 Jan 2021 13:01:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=xm5qO6P9Z6ZhJRyqnAlClJA9X/Ox03XvfaW9rrJrmyI=;
        b=Lk/BBV0t+X2u1K5J8Idtmn2ImD6vv2eoT//FWk6SlO25DAuV2JLX0sxS7ZPMBW+17w
         7Wjjw4wd3LYGumlfvrloSRpAqgJQA7IdlVAGvs73BzZ5lKGFFCPt9LIjqrPSSXTc1Nqa
         Mtq1kbRWCq6VfOetwzkDUSBJ7WrXA5ajgY/UUFh/pa/J9/7xPi04S9S8taqfkNQZg2Vt
         rrX7K+UT0gpyYhxnBP5mTcK9qPFEkOk4c4fZDc/N+4+lVp7659NR3U26IVj4F90pAUm3
         fq2Kfo66UaEl4uNxACyu1P1pZHflj6mHKRtxw3sWIUPtxjYGYv16GGctA/3RK5ymLnJJ
         nGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xm5qO6P9Z6ZhJRyqnAlClJA9X/Ox03XvfaW9rrJrmyI=;
        b=YNk0WZGBOYS0+KO9YtEeNRaRJBDnmP6UGpYpPgqOX5SqPEycRg4723dHAPtyKViE+C
         eXPER8c9OrFWhFEN2mJl+LGfQ5J+6KO7Ozd/mkSendBBn0A7ZbkQBheeHz/tjmvsAw6l
         /kNKIQd3ldPm7Zkummi7CB0UtIOGdd3hyAdI8B1wuclQ+8wAd8jf67RBGacVKaHlHovK
         dZr7n1zC/Gkg0on/s06WxYtxUfqREPEzev4LBidWaxsAMGiz8F6YjKCUiQ8kD1sVnN4R
         88glFhUnw4ul2Ah6seR7y12T1/MlUadsSC7hE9g/Wg/6JgJMpgMTgAglW47nxeqw+JPR
         97GA==
X-Gm-Message-State: AOAM530s6qHBaiDUDcECSe0Z17vc/CqB0K/A4P7hEmJ1O6JqAj3+LkOs
        0/Rcnw9JLqE7ejgacQfy8e4=
X-Google-Smtp-Source: ABdhPJyyJs0lfYh9IxeGOChv29sNrVlKcJOpnou5KHgv7EVaBr+Fqrmn6iMbLmXIYIIVjHjsK5xPzQ==
X-Received: by 2002:a5d:6a05:: with SMTP id m5mr5303435wru.96.1610139668004;
        Fri, 08 Jan 2021 13:01:08 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id r2sm14919211wrn.83.2021.01.08.13.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jan 2021 13:01:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: stop SQPOLL submit on creator's death
Date:   Fri,  8 Jan 2021 20:57:25 +0000
Message-Id: <28efa06f10d9b524eeb8e5cbad5c5f9acbad7b52.1610139268.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1610139268.git.asml.silence@gmail.com>
References: <cover.1610139268.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When the creator of SQPOLL io_uring dies (i.e. sqo_task), we don't want
its internals like ->files and ->mm to be poked by the SQPOLL task, it
have never been nice and recently got racy. That can happen when the
owner undergoes destruction and SQPOLL tasks tries to submit new
requests in parallel, and so calls io_sq_thread_acquire*().

That patch halts SQPOLL submissions when sqo_task dies by introducing
sqo_dead flag. Once set, the SQPOLL task must not do any submission,
which is synchronised by uring_lock as well as the new flag.

The tricky part is to make sure that disabling always happens, that
means either the ring is discovered by creator's do_exit() -> cancel,
or if the final close() happens before it's done by the creator. The
last is guaranteed by the fact that for SQPOLL the creator task and only
it holds exactly one file note, so either it pins up to do_exit() or
removed by the creator on the final put in flush. (see comments in
uring_flush() around file->f_count == 2).

One more place that can trigger io_sq_thread_acquire_*() is
__io_req_task_submit(). Shoot off requests on sqo_dead there, even
though actually we don't need to. That's because cancellation of
sqo_task should wait for the request before going any further.

note 1: io_disable_sqo_submit() does io_ring_set_wakeup_flag() so the
caller would enter the ring to get an error, but it still doesn't
guarantee that the flag won't be cleared.

note 2: if final __userspace__ close happens not from the creator
task, the file note will pin the ring until the task dies.

Fixed: b1b6b5a30dce8 ("kernel/io_uring: cancel io_uring before task works")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 62 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 53 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f39671a0d84f..2f305c097bd5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -262,6 +262,7 @@ struct io_ring_ctx {
 		unsigned int		drain_next: 1;
 		unsigned int		eventfd_async: 1;
 		unsigned int		restricted: 1;
+		unsigned int		sqo_dead: 1;
 
 		/*
 		 * Ring buffer of indices into array of io_uring_sqe, which is
@@ -2160,12 +2161,11 @@ static void io_req_task_cancel(struct callback_head *cb)
 static void __io_req_task_submit(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	bool fail;
 
-	fail = __io_sq_thread_acquire_mm(ctx) ||
-		__io_sq_thread_acquire_files(ctx);
 	mutex_lock(&ctx->uring_lock);
-	if (!fail)
+	if (!ctx->sqo_dead &&
+	    !__io_sq_thread_acquire_mm(ctx) &&
+	    !__io_sq_thread_acquire_files(ctx))
 		__io_queue_sqe(req, NULL);
 	else
 		__io_req_task_cancel(req, -EFAULT);
@@ -6954,7 +6954,8 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		if (!list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, &nr_events, 0);
 
-		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)))
+		if (to_submit && !ctx->sqo_dead &&
+		    likely(!percpu_ref_is_dying(&ctx->refs)))
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
 	}
@@ -8712,6 +8713,10 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
 	percpu_ref_kill(&ctx->refs);
+
+	if (WARN_ON_ONCE((ctx->flags & IORING_SETUP_SQPOLL) && !ctx->sqo_dead))
+		ctx->sqo_dead = 1;
+
 	/* if force is set, the ring is going away. always drop after that */
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
@@ -8874,6 +8879,18 @@ static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	}
 }
 
+static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
+{
+	WARN_ON_ONCE(ctx->sqo_task != current);
+
+	mutex_lock(&ctx->uring_lock);
+	ctx->sqo_dead = 1;
+	mutex_unlock(&ctx->uring_lock);
+
+	/* make sure callers enter the ring to get error */
+	io_ring_set_wakeup_flag(ctx);
+}
+
 /*
  * We need to iteratively cancel requests, in case a request has dependent
  * hard links. These persist even for failure of cancelations, hence keep
@@ -8885,6 +8902,8 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	struct task_struct *task = current;
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
+		/* for SQPOLL only sqo_task has task notes */
+		io_disable_sqo_submit(ctx);
 		task = ctx->sq_data->thread;
 		atomic_inc(&task->io_uring->in_idle);
 		io_sq_thread_park(ctx->sq_data);
@@ -9056,6 +9075,7 @@ void __io_uring_task_cancel(void)
 static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	struct io_ring_ctx *ctx = file->private_data;
 
 	if (!tctx)
 		return 0;
@@ -9071,7 +9091,16 @@ static int io_uring_flush(struct file *file, void *data)
 	if (atomic_long_read(&file->f_count) != 2)
 		return 0;
 
-	io_uring_del_task_file(file);
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		/* there is only one file note, which is owned by sqo_task */
+		WARN_ON_ONCE((ctx->sqo_task == current) ==
+			     !xa_load(&tctx->xa, (unsigned long)file));
+
+		io_disable_sqo_submit(ctx);
+	}
+
+	if (!(ctx->flags & IORING_SETUP_SQPOLL) || ctx->sqo_task == current)
+		io_uring_del_task_file(file);
 	return 0;
 }
 
@@ -9145,8 +9174,9 @@ static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
 
 #endif /* !CONFIG_MMU */
 
-static void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
+static int io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 {
+	int ret = 0;
 	DEFINE_WAIT(wait);
 
 	do {
@@ -9155,6 +9185,11 @@ static void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 
 		prepare_to_wait(&ctx->sqo_sq_wait, &wait, TASK_INTERRUPTIBLE);
 
+		if (unlikely(ctx->sqo_dead)) {
+			ret = -EOWNERDEAD;
+			goto out;
+		}
+
 		if (!io_sqring_full(ctx))
 			break;
 
@@ -9162,6 +9197,8 @@ static void io_sqpoll_wait_sq(struct io_ring_ctx *ctx)
 	} while (!signal_pending(current));
 
 	finish_wait(&ctx->sqo_sq_wait, &wait);
+out:
+	return ret;
 }
 
 static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz,
@@ -9235,10 +9272,16 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 
+		ret = -EOWNERDEAD;
+		if (unlikely(ctx->sqo_dead))
+			goto out;
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
-		if (flags & IORING_ENTER_SQ_WAIT)
-			io_sqpoll_wait_sq(ctx);
+		if (flags & IORING_ENTER_SQ_WAIT) {
+			ret = io_sqpoll_wait_sq(ctx);
+			if (ret)
+				goto out;
+		}
 		submitted = to_submit;
 	} else if (to_submit) {
 		ret = io_uring_add_task_file(ctx, f.file);
@@ -9665,6 +9708,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p,
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
 err:
+	io_disable_sqo_submit(ctx);
 	io_ring_ctx_wait_and_kill(ctx);
 	return ret;
 }
-- 
2.24.0

