Return-Path: <io-uring+bounces-2803-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1293A9551F7
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 22:44:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 377151C20957
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:44:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 15E2A1C3787;
	Fri, 16 Aug 2024 20:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="HPJr1DcA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AF901C37A3
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 20:44:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723841058; cv=none; b=U3c5QXzNr1NUcSachAl6RqvLmdpu5xiN7JS0EzbP9mSikvD2pogx4OQvpDIOy2NE/NUsvk4HTofybtziuKTK+JzVVBptSKs1UoBFGotz7pNS5g3n3Ql7OAojShMClJZ5UbZpL5d2NsRvaqycBrWMYBFUyOpBDkUmXY/N6iBKhs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723841058; c=relaxed/simple;
	bh=g+eKojpK3LrgiX9mBSou2jCzZVKXiXdSwKUfLaxw4II=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0Lr6QgKvtSxW7vGJTkaljBwAjLIrM1VywCnsGl+6Z8E8QE41pn9m4ehTQP4nzoCZA5OJWTL2BI3x6pVpm54z+WoUiMnk/oU4jAiVG5A7p/9rFDwT5KHgUM5p1HVRecsNbtxPzvT48cp/9+rIF6/misTs7D0tnkmMPgVS3aVn1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=HPJr1DcA; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2d3cc6170eeso374984a91.1
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 13:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723841055; x=1724445855; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hMoYgyUrcy2s4+MjNukg1zvbc8INT9NVMGfeBKKfeGA=;
        b=HPJr1DcA8Cr+A4jHo+Dl9B3wp8nIdU0zX6bipntI5FLB/yYZUbtvmCCImL8O5W17wL
         MMY51SGkFtAqI9HfZT7qs0itMld8TYEebjAs/oexBAFvUj1yRkcLc5SGxQd6J9Jdl6Vx
         cKK+j2efr+x1rSZdBbG9j5Hwe+BkqMG2ARq7nsOz8x9jaAwISLNwmUqDhSWU+tRN6jND
         XIIYH08SpTqWL9t0oyalaOWvHaYrAf89tKiL5P3ez0fkSdk5wrUj12WUx2QOt9RcLfPC
         4Xrdy4YctASKm3ZAFtABF8S9rdVGIkQYR4JZTV66V1tPwqjksh71vrfKdy5oNTdJbu2J
         tQuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723841055; x=1724445855;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hMoYgyUrcy2s4+MjNukg1zvbc8INT9NVMGfeBKKfeGA=;
        b=mn1yMVYHxWqlTkLyzma3jWRrInFjN38NvaJnJUFE0ZJeb3vA6PmHdlTv8stOqsPjHo
         Ec4h9L+M9+SCFi/Tx/LOU0mTMz5SpaP4HgDS1kbiZBefzBVVQpfRqGCVtVseUf6S1lEY
         POpzCAeIJExrUIcvDaYVvVsKUs5mWH2KXXqlRmoNRDEaaT6CqJmKEOR0OK3IGjWjiute
         /6zhimHu9oHWBHPsOioP7GroRBPL7poV5q8m5jePPyYgezpHBwKiTm0q2w0+M8XHRQ+6
         GrrVKEvZ/sNrAmX+vIhZxDJj7ofoashICSSqfOAPjMkdgKiT//ov5hIHJFlvU6uv901G
         32Rg==
X-Gm-Message-State: AOJu0YxYvkXXaZFU1CT4QP9cfX95yNLATTkYFhWk2/Uz5+AQZlF7aQpu
	3+yvaPDKvXofm2cv2/f8n638n9LAlht1FZYFYwsHUqEmKr73hXjZzXZw4QcWSq+ShFnFDxGBTgk
	P
X-Google-Smtp-Source: AGHT+IHgeITjFbuuz6sGs8eVAYs0EK3eng4Nwto6Qn5V9BiGYHqDpdCDjZM2TJJKekEiSQsZtNpDbQ==
X-Received: by 2002:a17:902:ecd1:b0:1f7:1a37:d0b5 with SMTP id d9443c01a7336-20203e8f79emr27208975ad.4.1723841055016;
        Fri, 16 Aug 2024 13:44:15 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f038a3d7sm29190995ad.186.2024.08.16.13.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 13:44:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: add support for batch wait timeout
Date: Fri, 16 Aug 2024 14:38:15 -0600
Message-ID: <20240816204302.85938-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240816204302.85938-2-axboe@kernel.dk>
References: <20240816204302.85938-2-axboe@kernel.dk>
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
index 6e53ebd58aab..27d949ff84a3 100644
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
 	if (!iowq->no_iowait && current_pending_io())
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
@@ -2453,9 +2505,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	INIT_LIST_HEAD(&iowq.wq.entry);
 	iowq.ctx = ctx;
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
+	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
+	iowq.min_timeout = 0;
 	iowq.timeout = KTIME_MAX;
 	iowq.no_iowait = flags & IORING_ENTER_NO_IOWAIT;
+	start_time = io_get_time(ctx);
 
 	if (ext_arg->ts) {
 		struct timespec64 ts;
@@ -2465,7 +2520,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 		iowq.timeout = timespec64_to_ktime(ts);
 		if (!(flags & IORING_ENTER_ABS_TIMER))
-			iowq.timeout = ktime_add(iowq.timeout, io_get_time(ctx));
+			iowq.timeout = ktime_add(iowq.timeout, start_time);
 	}
 
 	if (ext_arg->sig) {
@@ -2496,7 +2551,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 							TASK_INTERRUPTIBLE);
 		}
 
-		ret = io_cqring_wait_schedule(ctx, &iowq);
+		ret = io_cqring_wait_schedule(ctx, &iowq, start_time);
 		__set_current_state(TASK_RUNNING);
 		atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index bac830a2d6ec..24ecd31c81e9 100644
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
 #ifdef CONFIG_NET_RX_BUSY_POLL
-- 
2.43.0


