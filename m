Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3BC2E8F59
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 03:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727709AbhADCET (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 21:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727816AbhADCET (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jan 2021 21:04:19 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FD4C06179A
        for <io-uring@vger.kernel.org>; Sun,  3 Jan 2021 18:03:03 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id g185so17929280wmf.3
        for <io-uring@vger.kernel.org>; Sun, 03 Jan 2021 18:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=/QJ6ssAFxh8KdtYwhin35uun4D2mJlpWSz/QJsjP/nE=;
        b=Oa5Qx3S1A3jh7ZJ0Gknxm9sBp2yYdWFRsuCyGM4qRn/uc/CoZq3SkWZ4z4Uo+ybevb
         L21Ku06l6UcWM836UAuflSSfbP51eNwdnGBP6R2MsGAI2W+U/T9yKtYQu77jHJ+tkGFv
         SAJGoZKW+Yod2RKdRmoUIx+7di4OiLl+2B+OOKZ/qrjLdg0ctCstRkOqKdrTBxAjgxsr
         uZTpQPbPqzpqvWZxNjFPnDqJjcY3uQMHM5GP3Q9NoYBjijPYY1jCW7BJiGEplQ1QFvI+
         aoX/lubLaE1BfkBZmRWtg+l0ZcPXM1W/nYkYWmAsgMwJRjvF2YubtCCarhwswcrZZ5qq
         2xKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/QJ6ssAFxh8KdtYwhin35uun4D2mJlpWSz/QJsjP/nE=;
        b=O0cnYWSHEzSuUyUt0Sqt7LqsR139b01B1Fa/u1Ot9xTlG8ZNCkBbLet0zR1mhYaB3L
         KuOR5ujofDWDjcgTJYfEDkHFlSl29Yjy+PDtmOO1dyuwipa2RLbvDOd2Li8TEp+BTqsK
         geBw0O0PAqjJ+hMAoLb45i7366cxprzdV1Vi7j5kW/Ne2uSu8TREOsOOfQde/0sFBLHH
         2N7BQ0dFMADj927DNcPjmMzQ8m+lUuAeTCf+rMH/mr2pyNsWha1aZgraqC2x5edSix3M
         RxlDY5dQVlIWnqOdF8V9UtWJLrGeRQybUEDuXsNdbzucVoZcU3Nux9sPyaRVcrIgOu+V
         NhGw==
X-Gm-Message-State: AOAM532tkDSHoBRZMdG+puEq0+aAQG+le3mmCqd2hgbttgLBO2pTrckM
        wEyMYLTxb11LuvGWTdd3fWU=
X-Google-Smtp-Source: ABdhPJzd4JvLR0gvs6j67q7dENhUY3+AxVsB40Nw0fY/1/znyrTDLKnXHDpHyiEeQWIIBxkffiPpQQ==
X-Received: by 2002:a1c:1c1:: with SMTP id 184mr24619642wmb.112.1609725782052;
        Sun, 03 Jan 2021 18:03:02 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id c4sm96632893wrw.72.2021.01.03.18.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 18:03:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 6/6] io_uring: patch up IOPOLL overflow_flush sync
Date:   Mon,  4 Jan 2021 01:59:19 +0000
Message-Id: <b4f984d25c2bd06ae794698bb77ef2013ad9e2ea.1609725418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609725418.git.asml.silence@gmail.com>
References: <cover.1609725418.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IOPOLL skips completion locking but keeps it under uring_lock, thus
io_cqring_overflow_flush() and so io_cqring_events() need additional
locking with uring_lock in some cases for IOPOLL.

Remove __io_cqring_overflow_flush() from io_cqring_events(), introduce a
wrapper around flush doing needed synchronisation and call it by hand.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 78 +++++++++++++++++++++++++++------------------------
 1 file changed, 41 insertions(+), 37 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1c32d4700caf..ed13642b56bc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1729,9 +1729,9 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
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
@@ -1784,6 +1784,20 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
 	return all_flushed;
 }
 
+static void io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force,
+				     struct task_struct *tsk,
+				     struct files_struct *files)
+{
+	if (test_bit(0, &ctx->cq_check_overflow)) {
+		/* iopoll syncs against uring_lock, not completion_lock */
+		if (ctx->flags & IORING_SETUP_IOPOLL)
+			mutex_lock(&ctx->uring_lock);
+		__io_cqring_overflow_flush(ctx, force, tsk, files);
+		if (ctx->flags & IORING_SETUP_IOPOLL)
+			mutex_unlock(&ctx->uring_lock);
+	}
+}
+
 static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -2329,20 +2343,8 @@ static void io_double_put_req(struct io_kiocb *req)
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
@@ -2566,7 +2568,8 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 		 * If we do, we can potentially be spinning for commands that
 		 * already triggered a CQE (eg in error).
 		 */
-		if (io_cqring_events(ctx, false))
+		__io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		if (io_cqring_events(ctx))
 			break;
 
 		/*
@@ -6841,7 +6844,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 
 	/* if we have a backlog and couldn't flush it all, return BUSY */
 	if (test_bit(0, &ctx->sq_check_overflow)) {
-		if (!io_cqring_overflow_flush(ctx, false, NULL, NULL))
+		if (!__io_cqring_overflow_flush(ctx, false, NULL, NULL))
 			return -EBUSY;
 	}
 
@@ -7104,7 +7107,7 @@ struct io_wait_queue {
 	unsigned nr_timeouts;
 };
 
-static inline bool io_should_wake(struct io_wait_queue *iowq, bool noflush)
+static inline bool io_should_wake(struct io_wait_queue *iowq)
 {
 	struct io_ring_ctx *ctx = iowq->ctx;
 
@@ -7113,7 +7116,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq, bool noflush)
 	 * started waiting. For timeouts, we always want to return to userspace,
 	 * regardless of event count.
 	 */
-	return io_cqring_events(ctx, noflush) >= iowq->to_wait ||
+	return io_cqring_events(ctx) >= iowq->to_wait ||
 			atomic_read(&ctx->cq_timeouts) != iowq->nr_timeouts;
 }
 
@@ -7123,11 +7126,13 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 	struct io_wait_queue *iowq = container_of(curr, struct io_wait_queue,
 							wq);
 
-	/* use noflush == true, as we can't safely rely on locking context */
-	if (!io_should_wake(iowq, true))
-		return -1;
-
-	return autoremove_wake_function(curr, mode, wake_flags, key);
+	/*
+	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
+	 * the task, and the next invocation will do it.
+	 */
+	if (io_should_wake(iowq) || test_bit(0, &iowq->ctx->cq_check_overflow))
+		return autoremove_wake_function(curr, mode, wake_flags, key);
+	return -1;
 }
 
 static int io_run_task_work_sig(void)
@@ -7164,7 +7169,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	int ret = 0;
 
 	do {
-		if (io_cqring_events(ctx, false) >= min_events)
+		io_cqring_overflow_flush(ctx, false, NULL, NULL);
+		if (io_cqring_events(ctx) >= min_events)
 			return 0;
 		if (!io_run_task_work())
 			break;
@@ -7192,6 +7198,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	trace_io_uring_cqring_wait(ctx, min_events);
 	do {
+		io_cqring_overflow_flush(ctx, false, NULL, NULL);
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		/* make sure we run task_work before checking for signals */
@@ -7200,8 +7207,11 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 			continue;
 		else if (ret < 0)
 			break;
-		if (io_should_wake(&iowq, false))
+		if (io_should_wake(&iowq))
 			break;
+		if (test_bit(0, &ctx->cq_check_overflow))
+			continue;
+
 		if (uts) {
 			timeout = schedule_timeout(timeout);
 			if (timeout == 0) {
@@ -8639,7 +8649,8 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	smp_rmb();
 	if (!io_sqring_full(ctx))
 		mask |= EPOLLOUT | EPOLLWRNORM;
-	if (io_cqring_events(ctx, false))
+	io_cqring_overflow_flush(ctx, false, NULL, NULL);
+	if (io_cqring_events(ctx))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	return mask;
@@ -8697,7 +8708,7 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	/* if force is set, the ring is going away. always drop after that */
 	ctx->cq_overflow_flushed = 1;
 	if (ctx->rings)
-		io_cqring_overflow_flush(ctx, true, NULL, NULL);
+		__io_cqring_overflow_flush(ctx, true, NULL, NULL);
 	mutex_unlock(&ctx->uring_lock);
 
 	io_kill_timeouts(ctx, NULL, NULL);
@@ -8873,9 +8884,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	}
 
 	io_cancel_defer_files(ctx, task, files);
-	io_ring_submit_lock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 	io_cqring_overflow_flush(ctx, true, task, files);
-	io_ring_submit_unlock(ctx, (ctx->flags & IORING_SETUP_IOPOLL));
 
 	if (!files)
 		__io_uring_cancel_task_requests(ctx, task);
@@ -9218,13 +9227,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
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

