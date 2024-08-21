Return-Path: <io-uring+bounces-2871-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 709FF959F8F
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 16:19:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E4B951F22EC6
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 14:19:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B71F1B1D56;
	Wed, 21 Aug 2024 14:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="YUps2iKv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063B21B1D5F
	for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 14:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724249960; cv=none; b=r7Nin9ktw3bJn2Y+G6YlA1YMcSwI1wOQtyZkM9jlDqRlrlodBPqqAA6xSaZPCzKxFZQK57IAjw70voGfIVUeZt29isVwfzP9962Vp6Fo/kwmx9+jYnt5K1ziguK9f1njgzyX02FJRyB37DAt8sV8AZmQUaRjYRh0C7U2quH4MrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724249960; c=relaxed/simple;
	bh=FV5pFO389XJGDJ5i0cxK0zGiAf3BDSjeGN6E/Mv6/AY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtSyLrFzVI03KSySvL03sP8/IPs7svGjLR5hQgx0ahClXeZ/26yLJv+FdUqvUaxkVVxVcZD1CpZPQvgemSkzJEXtexuVozYVJPiyRcKF2scDsnnch7pwk7Tjnb+Q0oda0PMxIEcnG3aMZr510/cy6OCN3iKT2Rlhwp0USKk9ZFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=YUps2iKv; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-39d2cea1239so18273725ab.3
        for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 07:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724249956; x=1724854756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+39bVTxzdD0lU+3+/bddoRvGEsUHfz1Wtam711ub4Co=;
        b=YUps2iKv6sILW2sz8tI4ggzdqBRGViuSja04MYWbGfBuzKob+gFBQjR60rgJl670E/
         jSkKe5E1UjprLpFj/hyzVjm7P7qllRitSbh/70Yaf0yfCkaRH+J2Rcsl5XpUJuPntdY/
         EmtJ3Y7t7QYdd4zCMzDW1zECta2yJsEVKQldPf+dwZN0VfwPoCBXAzSHQC3+QfufZUYZ
         7uCAg5Cs1iSD1n5u0XP4ULQqboNBxCVI6OIXsJTmNxLA5yXLT4TOMj40rXgOfsPOAWk4
         xuQtb/UbWbNXEKzGbV8zy7V3XNzTMIFhyx9FjnlhHuwVJ96cSlw8s/5AbjQFAo0oalAh
         Zd9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724249956; x=1724854756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+39bVTxzdD0lU+3+/bddoRvGEsUHfz1Wtam711ub4Co=;
        b=SbGGxiO3Rz+hIYpP7HUuySQWJH70O6JkwRptyA0KyFZAoiA0IAAv18a17s0QNf9fp7
         P++d0yFsK2WJbFtkHpeI6jRriD8vlzo7Vjtm60DLZ7BSUs5Eu5JLuqPVXUutBLr1f1Am
         O2ZCBG5Sq3Yb0KbV0unJY4rY8JiMEHN615OSoRdpZpl2fgsW9+l5exS/wGf9ZjJXmAbn
         owQuRKu6q5CdIQib5s2H/fZJCGD/bVVWdYq8w6NJh8F6uP5akdkdE0Zo0qbG/saTfbo5
         HfqkFsT1GUHv1sOxdJcTcDq+xoet+OnnQ9tZaaxv7QEdH0n9yJJ+D7fBPl8cu8PtPZEt
         S7sQ==
X-Gm-Message-State: AOJu0YyK2dULXZ4+dJD4tdJ8SPqBlq36bgBHJUrGCzwGmpwNnSfF/qjy
	Hi4xohr8o5hHV6vQwOWASr72J3MfI9gwrdj5cFtPXP6uyKxubLoJBAjlNxYrOhjcT92tpmCe0NK
	3
X-Google-Smtp-Source: AGHT+IEQcnOYHBB3ZrljEzfnHkIHL4Xf24i2ml2oMr0nJ2H34VrY5cGvIPl9pYz/El0eVw6JbfKBkw==
X-Received: by 2002:a05:6e02:1e06:b0:39d:47cf:2c7f with SMTP id e9e14a558f8ab-39d6c3c9d31mr27055595ab.24.1724249956550;
        Wed, 21 Aug 2024 07:19:16 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39d1eb0bc93sm50967285ab.19.2024.08.21.07.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:19:16 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: add support for batch wait timeout
Date: Wed, 21 Aug 2024 08:16:25 -0600
Message-ID: <20240821141910.204660-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240821141910.204660-1-axboe@kernel.dk>
References: <20240821141910.204660-1-axboe@kernel.dk>
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
 io_uring/io_uring.c | 88 ++++++++++++++++++++++++++++++++++++++-------
 io_uring/io_uring.h |  2 ++
 2 files changed, 77 insertions(+), 13 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ba5292137c3..87e7cf6551d7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2322,7 +2322,8 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
 	 * the task, and the next invocation will do it.
 	 */
-	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
+	if (io_should_wake(iowq) || io_has_work(iowq->ctx) ||
+	    READ_ONCE(iowq->hit_timeout))
 		return autoremove_wake_function(curr, mode, wake_flags, key);
 	return -1;
 }
@@ -2359,13 +2360,66 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
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
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		atomic_set(&ctx->cq_wait_nr, 1);
+		smp_mb();
+		if (!llist_empty(&ctx->work_llist))
+			goto out_wake;
+	}
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
-	iowq->hit_timeout = 0;
+	ktime_t timeout;
+
+	WRITE_ONCE(iowq->hit_timeout, 0);
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
@@ -2379,7 +2433,8 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
 }
 
 static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-				     struct io_wait_queue *iowq)
+				     struct io_wait_queue *iowq,
+				     ktime_t start_time)
 {
 	int ret = 0;
 
@@ -2390,8 +2445,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
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
@@ -2400,7 +2455,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 
 /* If this returns > 0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-					  struct io_wait_queue *iowq)
+					  struct io_wait_queue *iowq,
+					  ktime_t start_time)
 {
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
@@ -2413,7 +2469,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	if (unlikely(io_should_wake(iowq)))
 		return 0;
 
-	return __io_cqring_wait_schedule(ctx, iowq);
+	return __io_cqring_wait_schedule(ctx, iowq, start_time);
 }
 
 struct ext_arg {
@@ -2431,6 +2487,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 {
 	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
+	ktime_t start_time;
 	int ret;
 
 	if (!io_allowed_run_tw(ctx))
@@ -2449,8 +2506,11 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
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
@@ -2460,7 +2520,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 		iowq.timeout = timespec64_to_ktime(ts);
 		if (!(flags & IORING_ENTER_ABS_TIMER))
-			iowq.timeout = ktime_add(iowq.timeout, io_get_time(ctx));
+			iowq.timeout = ktime_add(iowq.timeout, start_time);
 	}
 
 	if (ext_arg->sig) {
@@ -2484,14 +2544,16 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 		unsigned long check_cq;
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-			atomic_set(&ctx->cq_wait_nr, nr_wait);
+			/* if min timeout has been hit, don't reset wait count */
+			if (!READ_ONCE(iowq.hit_timeout))
+				atomic_set(&ctx->cq_wait_nr, nr_wait);
 			set_current_state(TASK_INTERRUPTIBLE);
 		} else {
 			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
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


