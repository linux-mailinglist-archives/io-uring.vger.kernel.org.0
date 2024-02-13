Return-Path: <io-uring+bounces-600-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F22853A9F
	for <lists+io-uring@lfdr.de>; Tue, 13 Feb 2024 20:14:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D16452863C2
	for <lists+io-uring@lfdr.de>; Tue, 13 Feb 2024 19:14:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CC496086E;
	Tue, 13 Feb 2024 19:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qyVyQQ4l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B1F6171A5
	for <io-uring@vger.kernel.org>; Tue, 13 Feb 2024 19:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707851643; cv=none; b=rgCCBomH3CiG5JVRhMHbGnhIY7F5U7nmL2dclCujIcDQVr4mXEGC2PFzm0AqEO8TQkWof+7o1XLRkenMQZ8h2ZACELgYy9zxk+EY+jL5w1blC2wlgdiCM1mNzbjngS2uraxJYobx7TMRLZicq4xW0UAPJs7xWLMxTSLtarWWh7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707851643; c=relaxed/simple;
	bh=dMt1NlBWsrqJtie6PeTOysB0V/wSdi5EkfC+Wy3ckK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wob/3v5v9smlUwrg5n2OLt4R9d5S33dTY1X3VjhELxAplAAJT2iON+EQqhtVg5fvvUX4edZMKk0oVO6rf0c/R3rYvgw6xld/KA8HnbdFpByO3jwoe6KUJylZ+hn1X4ZJyrPLcY3yiUCNtMF1F1bR15ZQ2a1e9Wj6RaCjmgeQFmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qyVyQQ4l; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso44105539f.0
        for <io-uring@vger.kernel.org>; Tue, 13 Feb 2024 11:14:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707851640; x=1708456440; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vf38SdiaDrxbabZ3coOW8KMn6A6Vh6WqJb747/gIVcY=;
        b=qyVyQQ4lPq8DR8Rd0IoRf+hdNRgdW4thGbNdSzCDe0KDveU0Fmi62cRKx7hFAH8z+8
         fPxsupJ71+UUdlLO2PR4yUDY5vyTa8VXJS1OgoWBMndOXWW3pWde14G32ysETZswxwqG
         72EsK0Q8eMKJZiQGX0DJWVerv//P/2wpuqgJOP1Yp8DxZb9gIIhuQ0rsfp2y1Pa9PsYa
         Yd4zZr52HtMhY/A+d9hHf0LI7kiL7Crvl7xHGNwOIPLhnwzwyy7G+drFNRczZUP0bEM5
         mhe4SUFGpkSlxvNsKqCc19SQU5wGRe+kUfLXSqj+BncPQQbZxowzQ+n0vRZQDza7c8hO
         OscQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707851640; x=1708456440;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Vf38SdiaDrxbabZ3coOW8KMn6A6Vh6WqJb747/gIVcY=;
        b=ugtZopqb2He2/8lavLcj8G7bvuM9PPhPapeV2jiU7oQsbyLBBPP+pa3cncEmWOk6Za
         0svT2bdcn5YY+JmIOLbrXRPRPgGGXyrpywoqjoMRWdEOn9hQLNjqnT1GrONg+vrn7C4P
         TQLg/I8dswTSveudfajW+Abj58pNs00111JQkPKdfz+pMMpMSB82LW0R1U+D7X5HQiIj
         0nuTCBJYcyd/SRBtvc4f1RERS/6q1/kW2InAWZvT/6tcwAH74GVRTLxCaxq5BgkvXg+P
         iQOGzQUYr3YE3Khqa9KbooW0+aTViBxSeA0VjCXl75zHZ/LXUJiYRblzCxRh+nqQLfwn
         khvg==
X-Gm-Message-State: AOJu0YzFgKXjYGSQYSdTyP47xsZ0B0oWURTCiqUX/VrAX9B+PBIWzcz5
	crtpgSYBGTjz98g3wjWsmIO6+qOlnd8mwM79ne80vDz4rDI61RSVm+grMTGlKSxCaKK0ONP6aBQ
	g
X-Google-Smtp-Source: AGHT+IHkG8ZvGBVyBld/j83TerdDA6VBCm2Fyq/cGxU0l84RRkma4Pojf5TzbviF6IiPz4f1i2p/0A==
X-Received: by 2002:a6b:dd0d:0:b0:7c4:5898:11d0 with SMTP id f13-20020a6bdd0d000000b007c4589811d0mr703282ioc.1.1707851639697;
        Tue, 13 Feb 2024 11:13:59 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cz17-20020a0566384a1100b004713ef05d60sm2032176jab.96.2024.02.13.11.13.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 11:13:58 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: add support for batch wait timeout
Date: Tue, 13 Feb 2024 12:03:40 -0700
Message-ID: <20240213191352.2452160-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240213191352.2452160-1-axboe@kernel.dk>
References: <20240213191352.2452160-1-axboe@kernel.dk>
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
of events to wait for. Applications will generally like to handle batches
of completions, and right now they'd set a number of events to wait for
and the timeout for that. If no events have been received but the timeout
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
 io_uring/io_uring.c | 78 +++++++++++++++++++++++++++++++++++++++------
 io_uring/io_uring.h |  2 ++
 2 files changed, 70 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f2d3f39d6106..34f7884be932 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2536,12 +2536,64 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static int io_cqring_schedule_timeout(struct io_wait_queue *iowq)
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
+	iowq->timeout = ktime_add_ns(ktime_sub_ns(iowq->timeout, iowq->min_timeout), ktime_get_ns());
+	iowq->t.function = io_cqring_timer_wakeup;
+	hrtimer_set_expires(timer, iowq->timeout);
+	return HRTIMER_RESTART;
+out_wake:
+	return io_cqring_timer_wakeup(timer);
+}
+
+static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
+				      ktime_t start_time)
 {
+	ktime_t timeout;
+
 	iowq->hit_timeout = 0;
 	hrtimer_init_on_stack(&iowq->t, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
-	iowq->t.function = io_cqring_timer_wakeup;
-	hrtimer_set_expires_range_ns(&iowq->t, iowq->timeout, 0);
+
+	if (iowq->min_timeout != KTIME_MAX) {
+		timeout = ktime_add_ns(iowq->min_timeout, start_time);
+		iowq->t.function = io_cqring_min_timer_wakeup;
+	} else {
+		timeout = ktime_add_ns(iowq->timeout, start_time);
+		iowq->t.function = io_cqring_timer_wakeup;
+	}
+
+	hrtimer_set_expires_range_ns(&iowq->t, timeout, 0);
 	hrtimer_start_expires(&iowq->t, HRTIMER_MODE_ABS);
 
 	if (!READ_ONCE(iowq->hit_timeout))
@@ -2555,7 +2607,8 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq)
 }
 
 static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-				     struct io_wait_queue *iowq)
+				     struct io_wait_queue *iowq,
+				     ktime_t start_time)
 {
 	int io_wait, ret = 0;
 
@@ -2567,8 +2620,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	io_wait = current->in_iowait;
 	if (current_pending_io())
 		current->in_iowait = 1;
-	if (iowq->timeout != KTIME_MAX)
-		ret = io_cqring_schedule_timeout(iowq);
+	if (iowq->timeout != KTIME_MAX || iowq->min_timeout != KTIME_MAX)
+		ret = io_cqring_schedule_timeout(iowq, start_time);
 	else
 		schedule();
 	current->in_iowait = io_wait;
@@ -2577,7 +2630,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-					  struct io_wait_queue *iowq)
+					  struct io_wait_queue *iowq,
+					  ktime_t start_time)
 {
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
@@ -2590,7 +2644,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	if (unlikely(io_should_wake(iowq)))
 		return 0;
 
-	return __io_cqring_wait_schedule(ctx, iowq);
+	return __io_cqring_wait_schedule(ctx, iowq, start_time);
 }
 
 /*
@@ -2603,6 +2657,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 {
 	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
+	ktime_t start_time;
 	int ret;
 
 	if (!io_allowed_run_tw(ctx))
@@ -2633,8 +2688,11 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	INIT_LIST_HEAD(&iowq.wq.entry);
 	iowq.ctx = ctx;
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
+	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
+	iowq.min_timeout = KTIME_MAX;
 	iowq.timeout = KTIME_MAX;
+	start_time = ktime_get_ns();
 
 	if (uts) {
 		struct timespec64 ts;
@@ -2642,7 +2700,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
 
-		iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
+		iowq.timeout = timespec64_to_ktime(ts);
 		io_napi_adjust_timeout(ctx, &iowq, &ts);
 	}
 
@@ -2661,7 +2719,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 							TASK_INTERRUPTIBLE);
 		}
 
-		ret = io_cqring_wait_schedule(ctx, &iowq);
+		ret = io_cqring_wait_schedule(ctx, &iowq, start_time);
 		__set_current_state(TASK_RUNNING);
 		atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d7295ae2c8a6..56b1672dbeb7 100644
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


