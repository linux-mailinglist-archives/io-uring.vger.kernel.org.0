Return-Path: <io-uring+bounces-2839-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EB7F29578A8
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 01:30:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1E7928463A
	for <lists+io-uring@lfdr.de>; Mon, 19 Aug 2024 23:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A8C51DF67B;
	Mon, 19 Aug 2024 23:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2wt59RQP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DA011DF69F
	for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 23:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724110255; cv=none; b=CELa5LUsGrLzgW+GuXJruMpdfSL323xN+H1A4bpCwtq+bQzSoch6FNw4L0Xtag8BjTUa94I4Ix/aN5CCurcvQomxCA9IgERQYenJ5rFko6ENVva3hN6C4jKvV1zPUS/uSdIakYWDQevQaUqnie7jKJNVXEN+OUC4UigFhBMH3HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724110255; c=relaxed/simple;
	bh=Lb7j/kLMs8jWsEG+Y7Us0Q/dAQ4cqFm/VRlrOvHmKgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIyZYu/tW9J6Ky0XP/TumAEoa9BnT1Gsx9X6WhcSSNKyy6V+8ouhH6Z1Sy1BXfNURDQIvz5Q9TBb+7Srq2QhxzZXpuq8YNFvUCP0Fa/y80o14ORpHA90Swnnel3dX/9o6lM1YdLgxRWO+RPTmrCUsBb7KV8EVXMLI/CoJWTrpKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2wt59RQP; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-78f86e56b4cso429687a12.3
        for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 16:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724110252; x=1724715052; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xjVRvH7/wAQ3u0PxEu9L4on+dtOhqN39XwqqSWu2Nic=;
        b=2wt59RQPTSv4WX5K1eOUZURsqe3KL7Nokkkj2b0TF4NQqoyTMgcHuqsBqxM+j0i/j/
         KyK2CmK88GOd+U5tjQrGOW0h17HELMZvK3VvLiFtQ+30ikLWtlok8bk3zYiylqd8K9cB
         Ka6Hbec8aJMtGUPlUnRuKiytmZSB4b4tFeZPrL2b+hnerzO82querinQ/Sg2fKiYhpwI
         K10UDALSlo3mCCbU3woody5SXJhwfal3/EudCFHBf7O/Me0mOpWoCohuG9BOrL5mON6Z
         nE6fLNCxAsrQnIzqPPS9xCeVt6Szxq4PIO3jeXSxcxou4aKQDffUKRdVNwynLnwdWiWV
         3nJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724110252; x=1724715052;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xjVRvH7/wAQ3u0PxEu9L4on+dtOhqN39XwqqSWu2Nic=;
        b=BFu2FoB8qwWu50GSMaO6l8DRyJQtU2t9DtIoCG2SG6AimEo6u9e1KN88uUmqVat0Au
         b6bNOcQ1p44mFZgZBQnO/ZLZibkJLvanKL9PepEacj3sExXVUBxUt7/jNT032dWGXHNt
         D6mWhg/M08G+vhJCf6sGu4uKJbM8WS7lsqfhEITj8+wN/r7aaTx0iC4Ey/xbDJxHT4jD
         WE7XaT4IyIKgOnTSuzGjeT/L0To2ayuNLYibwEjJZlMwsedLFjsOwvtdd19/LUIURz2h
         fwSzUnLGnUAUCjOYCsv+FicL+hZZeIYM9Vq6PGNLOziKZzVblZwDQaNU6h5MS3gt0BpW
         sObQ==
X-Gm-Message-State: AOJu0Yx3dW0mqRHJZ/ErwkGDqvqzBLtDVR0ikD4rQ/GGmIwnrr3kfOvD
	CXH8BfIVlB1/mm3NBjvHrQOXwW4qFEQ3MAdIDnHzxwsrjCerwJkTL+PuUDWBFtyPNi1y3Ve4vj8
	V
X-Google-Smtp-Source: AGHT+IGfyfEuDt7zvo3cFrCcaO0WBJONcuQnL3ZmZbdb/rAHyRAC5sYqECoijY8BJKWlgQcwynfgsg==
X-Received: by 2002:a05:6a21:9982:b0:1c4:e645:559b with SMTP id adf61e73a8af0-1c9050929f0mr10679507637.8.1724110251920;
        Mon, 19 Aug 2024 16:30:51 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61dc929sm8219838a12.40.2024.08.19.16.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 16:30:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: add support for batch wait timeout
Date: Mon, 19 Aug 2024 17:28:52 -0600
Message-ID: <20240819233042.230956-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240819233042.230956-1-axboe@kernel.dk>
References: <20240819233042.230956-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Waiting for events with io_uring has two knobs that can be set:

1) The number of events to wake for
2) The timeout associated with the event

Waiting will abort when either of those conditions are met, as expected.

This adds support for a third event, which is associated with the number
of events to wait for. Applications generally like to handle batches of
completions, and right now they'd set a number of events to wait for and
the timeout for that. If no events have been received but the timeout
triggers, control is returned to the application and it can wait again.
However, if the application doesn't have anything to do until events are
reaped, then it's possible to make this waiting more efficient.

For example, the application may have a latency time of 50 usecs and
wanting to handle a batch of 8 requests at the time. If it uses 50 usecs
as the timeout, then it'll be doing 20K context switches per second even
if nothing is happening.

This introduces the notion of min batch wait time. If the min batch wait
time expires, then we'll return to userspace if we have any events at all.
If none are available, the general wait time is applied. Any request
arriving after the min batch wait time will cause waiting to stop and
return control to the application.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 75 +++++++++++++++++++++++++++++++++++++++------
 io_uring/io_uring.h |  2 ++
 2 files changed, 67 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ddfbe04c61ed..d09a7c2e1096 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2363,13 +2363,62 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
+/*
+ * Doing min_timeout portion. If we saw any timeouts, events, or have work,
+ * wake up. If not, and we have a normal timeout, switch to that and keep
+ * sleeping.
+ */
+static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
+{
+	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
+	struct io_ring_ctx *ctx = iowq->ctx;
+
+	/* no general timeout, or shorter, we are done */
+	if (iowq->timeout == KTIME_MAX ||
+	    ktime_after(iowq->min_timeout, iowq->timeout))
+		goto out_wake;
+	/* work we may need to run, wake function will see if we need to wake */
+	if (io_has_work(ctx))
+		goto out_wake;
+	/* got events since we started waiting, min timeout is done */
+	if (iowq->cq_min_tail != READ_ONCE(ctx->rings->cq.tail))
+		goto out_wake;
+	/* if we have any events and min timeout expired, we're done */
+	if (io_cqring_events(ctx))
+		goto out_wake;
+
+	/*
+	 * If using deferred task_work running and application is waiting on
+	 * more than one request, ensure we reset it now where we are switching
+	 * to normal sleeps. Any request completion post min_wait should wake
+	 * the task and return.
+	 */
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+		atomic_set(&ctx->cq_wait_nr, 1);
+
+	iowq->t.function = io_cqring_timer_wakeup;
+	hrtimer_set_expires(timer, iowq->timeout);
+	return HRTIMER_RESTART;
+out_wake:
+	return io_cqring_timer_wakeup(timer);
+}
+
 static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
-				      clockid_t clock_id)
+				      clockid_t clock_id, ktime_t start_time)
 {
+	ktime_t timeout;
+
 	iowq->hit_timeout = 0;
 	hrtimer_init_on_stack(&iowq->t, clock_id, HRTIMER_MODE_ABS);
-	iowq->t.function = io_cqring_timer_wakeup;
-	hrtimer_set_expires_range_ns(&iowq->t, iowq->timeout, 0);
+	if (iowq->min_timeout) {
+		timeout = ktime_add_ns(iowq->min_timeout, start_time);
+		iowq->t.function = io_cqring_min_timer_wakeup;
+	} else {
+		timeout = iowq->timeout;
+		iowq->t.function = io_cqring_timer_wakeup;
+	}
+
+	hrtimer_set_expires_range_ns(&iowq->t, timeout, 0);
 	hrtimer_start_expires(&iowq->t, HRTIMER_MODE_ABS);
 
 	if (!READ_ONCE(iowq->hit_timeout))
@@ -2383,7 +2432,8 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
 }
 
 static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-				     struct io_wait_queue *iowq)
+				     struct io_wait_queue *iowq,
+				     ktime_t start_time)
 {
 	int ret = 0;
 
@@ -2394,8 +2444,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 */
 	if (current_pending_io())
 		current->in_iowait = 1;
-	if (iowq->timeout != KTIME_MAX)
-		ret = io_cqring_schedule_timeout(iowq, ctx->clockid);
+	if (iowq->timeout != KTIME_MAX || iowq->min_timeout != KTIME_MAX)
+		ret = io_cqring_schedule_timeout(iowq, ctx->clockid, start_time);
 	else
 		schedule();
 	current->in_iowait = 0;
@@ -2404,7 +2454,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 
 /* If this returns > 0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-					  struct io_wait_queue *iowq)
+					  struct io_wait_queue *iowq,
+					  ktime_t start_time)
 {
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
@@ -2417,7 +2468,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	if (unlikely(io_should_wake(iowq)))
 		return 0;
 
-	return __io_cqring_wait_schedule(ctx, iowq);
+	return __io_cqring_wait_schedule(ctx, iowq, start_time);
 }
 
 struct ext_arg {
@@ -2435,6 +2486,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 {
 	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
+	ktime_t start_time;
 	int ret;
 
 	if (!io_allowed_run_tw(ctx))
@@ -2453,8 +2505,11 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	INIT_LIST_HEAD(&iowq.wq.entry);
 	iowq.ctx = ctx;
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
+	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
+	iowq.min_timeout = 0;
 	iowq.timeout = KTIME_MAX;
+	start_time = io_get_time(ctx);
 
 	if (ext_arg->ts) {
 		struct timespec64 ts;
@@ -2464,7 +2519,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 		iowq.timeout = timespec64_to_ktime(ts);
 		if (!(flags & IORING_ENTER_ABS_TIMER))
-			iowq.timeout = ktime_add(iowq.timeout, io_get_time(ctx));
+			iowq.timeout = ktime_add(iowq.timeout, start_time);
 	}
 
 	if (ext_arg->sig) {
@@ -2495,7 +2550,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 							TASK_INTERRUPTIBLE);
 		}
 
-		ret = io_cqring_wait_schedule(ctx, &iowq);
+		ret = io_cqring_wait_schedule(ctx, &iowq, start_time);
 		__set_current_state(TASK_RUNNING);
 		atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index f95c1b080f4b..65078e641390 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -39,8 +39,10 @@ struct io_wait_queue {
 	struct wait_queue_entry wq;
 	struct io_ring_ctx *ctx;
 	unsigned cq_tail;
+	unsigned cq_min_tail;
 	unsigned nr_timeouts;
 	int hit_timeout;
+	ktime_t min_timeout;
 	ktime_t timeout;
 	struct hrtimer t;
 
-- 
2.43.0


