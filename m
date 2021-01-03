Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA532E8D33
	for <lists+io-uring@lfdr.de>; Sun,  3 Jan 2021 17:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727340AbhACQdo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 11:33:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbhACQdn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jan 2021 11:33:43 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57B27C061573
        for <io-uring@vger.kernel.org>; Sun,  3 Jan 2021 08:33:03 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id q75so15647242wme.2
        for <io-uring@vger.kernel.org>; Sun, 03 Jan 2021 08:33:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=naVrAwrJ0OyXRc0qIRgy5F0QzewHLNqd1zC/cd6KklY=;
        b=Eyu7ekUwJWHaHuqWuJbKTIzqg/1tmI2zawdNsBV2yu8k/hdZI2C04xIV2dUA2onhwJ
         4GAYlP5cCnK7SjDokZQxHYtXm6p9BhQTeb48yg/gXTLYCgc4dd0aVDoLWcgxhV+gGMMb
         Br4w9w/RY5gJ0gnHc7RCEeoX4GsV5LrnDoK4VzRxyHNwXFwpVkgDAA9XadVgKEhVR3mI
         ZnDzpM3acxp+sUPsR8Ga2YqImr0nfkjVW0aB9JQy9Sb2/vW66tmkwaZeG+L5Bc3oPWE1
         HxJJYvQk7sP90zcXNp/gROJQ14mRd4u5bM8/JdmPi9l3tGl6O16qMooqgArN7WJAwQRE
         NVPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=naVrAwrJ0OyXRc0qIRgy5F0QzewHLNqd1zC/cd6KklY=;
        b=CiK9vk+ql3/dx2Y6VNK6epZlrCQNVY/Fs8jCa/epCyzx8+MiUs1qEucv4I59XDiLSg
         tfpdsttDuLszMJAzoz0wM9tpx940Nko2gi26/zrUagknnHzvCyjY/5zBQpzeK2EXX9Cj
         RANYdKckB+P/vIh+pXDNwlMh8s4f8Z7LQysKgpyDan+AHxF9Tt83IWH3L0BY/+41+Dm0
         1f5bsRo8aTq7MKiIwaIArxFtBLgb1APZ4LYjFGSg4Ki/sGTidgOorfMnz0bMuwjHEeb5
         BA/DiHUd1/qSxYJirleT6W9R5bHU093eQP8V8p21KVbB6IjdMUfI29mHgF9WP3laPI7V
         GF8g==
X-Gm-Message-State: AOAM533CRvIJTtwtYCIhLfOJsz0ICNwv1dzjGavV7ElTegd2IvQ4xi0Y
        +EJRSH9FBpdy40MUcc8vUsnWnPuKG6GLfg==
X-Google-Smtp-Source: ABdhPJzMd1NE7pCuDYp+D2ms9vLq6o9PuX0f59KeVh+vKkNBdL6liq9Pad5jBvo32r0PNV79FSFXOg==
X-Received: by 2002:a1c:b788:: with SMTP id h130mr23279707wmf.94.1609691581785;
        Sun, 03 Jan 2021 08:33:01 -0800 (PST)
Received: from [192.168.8.179] ([85.255.236.66])
        by smtp.gmail.com with ESMTPSA id b14sm84242051wrx.77.2021.01.03.08.33.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Jan 2021 08:33:01 -0800 (PST)
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <cover.1609600704.git.asml.silence@gmail.com>
 <716bb8006495b33f11cb2f252ed5506d86f9f85c.1609600704.git.asml.silence@gmail.com>
 <ce841f93-8692-892c-15ce-94c0de5d74e5@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 2/4] io_uring: patch up IOPOLL overflow_flush sync
Message-ID: <0c1a302a-eec0-6de1-2b6e-c06739d4c70a@gmail.com>
Date:   Sun, 3 Jan 2021 16:29:32 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <ce841f93-8692-892c-15ce-94c0de5d74e5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 03/01/2021 15:12, Jens Axboe wrote:
> On 1/2/21 9:06 AM, Pavel Begunkov wrote:
>> IOPOLL skips completion locking but keeps it under uring_lock, thus
>> io_cqring_overflow_flush() and so io_cqring_events() need extra care.
>> Add extra conditional locking around them.
> 
> This one is pretty ugly. Would be greatly preferable to grab the lock
> higher up instead of passing down the need to do so, imho.
I can't disagree with that, the whole iopoll locking is a mess, but
still don't want to penalise SQPOLL|IOPOLL.

Splitting flushing from cqring_events might be a good idea. How
about the one below (not tested)? Killing this noflush looks even
cleaner than before.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 00dd85acd039..099f50de4aa5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1712,9 +1712,9 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 }
 
 /* Returns true if there are no backlogged entries after the flush */
-static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
-				     struct task_struct *tsk,
-				     struct files_struct *files)
+static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
+				       struct task_struct *tsk,
+				       struct files_struct *files)
 {
 	struct io_rings *rings = ctx->rings;
 	struct io_kiocb *req, *tmp;
@@ -1767,6 +1767,27 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	return all_flushed;
 }
 
+static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
+				     struct task_struct *tsk,
+				     struct files_struct *files)
+{
+	if (test_bit(0, &ctx->cq_check_overflow)) {
+		bool ret, iopoll = ctx->flags & IORING_SETUP_IOPOLL;
+
+		/*
+		 * iopoll doesn't care about ctx->completion_lock but uses
+		 * ctx->uring_lock
+		 */
+		if (iopoll)
+			mutex_lock(&ctx->uring_lock);
+		ret = __io_cqring_overflow_flush(ctx, force, tsk, files);
+		if (iopoll)
+			mutex_unlock(&ctx->uring_lock);
+		return ret;
+	}
+	return true;
+}
+
 static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -2312,20 +2333,8 @@ static void io_double_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static unsigned io_cqring_events(struct io_ring_ctx *ctx, bool noflush)
+static unsigned io_cqring_events(struct io_ring_ctx *ctx)
 {
-	if (test_bit(0, &ctx->cq_check_overflow)) {
-		/*
-		 * noflush == true is from the waitqueue handler, just ensure
-		 * we wake up the task, and the next invocation will flush the
-		 * entries. We cannot safely to it from here.
-		 */
-		if (noflush)
-			return -1U;
-
-		io_cqring_overflow_flush(ctx, false, NULL, NULL);
-	}
-
 	/* See comment at the top of this file */
 	smp_rmb();
 	return __io_cqring_events(ctx);
@@ -2550,7 +2559,8 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		 * If we do, we can potentially be spinning for commands that
 		 * already triggered a CQE (eg in error).
 		 */
-		if (io_cqring_events(ctx, false))
+		__io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		if (io_cqring_events(ctx))
 			break;
 
 		/*
@@ -6825,7 +6835,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
-		if (!io_cqring_overflow_flush(ctx, false, NULL, NULL))
+		if (!__io_cqring_overflow_flush(ctx, false, NULL, NULL))
 			return -EBUSY;
 	}
 
@@ -7088,7 +7098,7 @@ struct io_wait_queue {
 	unsigned nr_timeouts;
 };
 
-static inline bool io_should_wake(struct io_wait_queue *iowq, bool noflush)
+static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx = iowq->ctx;
 
@@ -7097,7 +7107,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq, bool noflush)
 	 * started waiting. For timeouts, we always want to return to userspace,
 	 * regardless of event count.
 	 */
-	return io_cqring_events(ctx, noflush) >= iowq->to_wait ||
+	return io_cqring_events(ctx) >= iowq->to_wait ||
 			atomic_read(&ctx->cq_timeouts) != iowq->nr_timeouts;
 }
 
@@ -7107,10 +7117,14 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 	struct io_wait_queue *iowq = container_of(curr, struct io_wait_queue,
 							wq);
 
-	/* use noflush == true, as we can't safely rely on locking context */
-	if (!io_should_wake(iowq, true))
+	/*
+	 * just ensure we wake up the task, and the next invocation will
+	 * flush the entries. We cannot safely to it from here.
+	 */
+	if (test_bit(0, &ctx->cq_check_overflow))
+		return -1;
+	if (!io_should_wake(iowq))
 		return -1;
-
 	return autoremove_wake_function(curr, mode, wake_flags, key);
 }
 
@@ -7148,7 +7162,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	int ret = 0;
 
 	do {
-		if (io_cqring_events(ctx, false) >= min_events)
+		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		if (io_cqring_events(ctx) >= min_events)
 			return 0;
 		if (!io_run_task_work())
 			break;
@@ -7184,8 +7199,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			continue;
 		else if (ret < 0)
 			break;
-		if (io_should_wake(&iowq, false))
+
+		/* iopoll ignores completion_lock, so not safe to flush */
+		if (io_should_wake(&iowq))
 			break;
+		if (test_bit(0, &ctx->cq_check_overflow)) {
+			finish_wait(&ctx->wait, &iowq.wq);
+			io_cqring_overflow_flush(ctx, false, NULL, NULL);
+			continue;
+		}
+
 		if (uts) {
 			timeout = schedule_timeout(timeout);
 			if (timeout == 0) {
@@ -8623,7 +8646,8 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	smp_rmb();
 	if (!io_sqring_full(ctx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
-	if (io_cqring_events(ctx, false))
+	io_cqring_overflow_flush(ctx, false, NULL, NULL);
+	if (io_cqring_events(ctx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	return mask;
@@ -8681,7 +8705,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/* if force is set, the ring is going away. always drop after that */
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
-		io_cqring_overflow_flush(ctx, true, NULL, NULL);
+		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
 	io_kill_timeouts(ctx, NULL, NULL);
@@ -8855,9 +8879,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	}
 
 	io_cancel_defer_files(ctx, task, files);
-	io_ring_submit_lock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 	io_cqring_overflow_flush(ctx, true, task, files);
-	io_ring_submit_unlock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 
 	if (!files)
 		__io_uring_cancel_task_requests(ctx, task);
@@ -9193,13 +9215,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	 */
 	ret = 0;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		if (!list_empty_careful(&ctx->cq_overflow_list)) {
-			bool needs_lock = ctx->flags & IORING_SETUP_IOPOLL;
+		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 
-			io_ring_submit_lock(ctx, needs_lock);
-			io_cqring_overflow_flush(ctx, false, NULL, NULL);
-			io_ring_submit_unlock(ctx, needs_lock);
-		}
 		if (flags & IORING_ENTER_SQ_WAKEUP)
 			wake_up(&ctx->sq_data->wait);
 		if (flags & IORING_ENTER_SQ_WAIT)
-- 
2.24.0
