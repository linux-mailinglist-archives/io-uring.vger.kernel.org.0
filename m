Return-Path: <io-uring+bounces-609-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D1EED85693F
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 17:15:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 89713286DF7
	for <lists+io-uring@lfdr.de>; Thu, 15 Feb 2024 16:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B80DF133417;
	Thu, 15 Feb 2024 16:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tNU9qCdQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8D713A25B
	for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 16:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708013412; cv=none; b=tEyOxhJv+n5XOEVEWUyG8vwHLD2TWClK/OcAP8MhQg+zoDY7BEMa89kXnajSkkpi086+oIcEtyBqsGcExHPWLz1BRWj+mADaB9qe5VdPIVB/FCktv1oTmQw3e6z3zrwPwBZKpFWfZLBgqTcM3nt1581BcNl5puc5d6t/UEqJZLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708013412; c=relaxed/simple;
	bh=J3Ud47rfdIGk4jBd05Wc+uUJyjx4SrgqJaDmEybi4W4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hstr8yBMAjjtRFq62SOZNr1pfkBC0fuqaTvuKYrauvlJrJ6HIcHLHMtm/4mK5THQkIwo1UTKuI3Y8W8cdr5E8dqXyh3HmS0OYKJLTdUISQZGdupIZYqVqyiT8W6ugrgiX8wdPDyQIwADsusmwshuW5/wbzfVTAhByZXNSpzWDws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tNU9qCdQ; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-363e7d542f4so417715ab.0
        for <io-uring@vger.kernel.org>; Thu, 15 Feb 2024 08:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708013409; x=1708618209; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QKp+xF2jAsd8VIFw0Ca+T76+SiSx2nSK3CsAVAuuGTo=;
        b=tNU9qCdQiBXBvmhJtLkltusmh7rvVponFCGHQkhXm6BiT+UNE0m3PQXAr91lCKW01c
         IypqwwAiqT+P+mIwiUMW1qMc7kcgI7IpNDzQwUvASO2+5ls49HzfV0YubZRcURgsm873
         nWtx3UP9MsdeS6Z2rg4xFINXfnpWA4q/XrRR+NQiczzsadJdZk5/6a/FrhKvyaiJfXjX
         tushxOsVCFxr+PeGaTomuX/ElrU0y16Q0qwOS7an3+mXj81fVNKI1qYQdeqQxtA/5S6m
         DFFaeFjTDTRUEaewQFoVKza+FwSNef+BoRTGg21MlwLpXWiWUrpfVcRjj1aKlDgD1Gwu
         oObw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708013409; x=1708618209;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QKp+xF2jAsd8VIFw0Ca+T76+SiSx2nSK3CsAVAuuGTo=;
        b=TmTgDOA8nKRb0lOu2wsU5HiMZOqyR/Ubi+mgkMkpV/KmlwkZJYoKeVQIhQ5CcYc6Jb
         63uN38IKYALwUz+bCBqkw6GpdGX6WKPxUBXwfhemVFHPjyXZeufCpTxI89Rve7Azs+Df
         tZkYyDO7kv/64zjJtE/oE7lVxp2HHXTk1ktkYW0v9abq36DIBQNPoqj9bsYZdXCiKc/9
         P6rcrWXZ1igr2xOX1xFs9i0gyvLuuc+sCdOficrRtnbBUf2jn2sYt2iZkPmKQMJGuoA6
         u1e1u5Ogmr0+nDOYcOTaoUQ9HhD59QxW7HSsPVb/C1n1jQAnxkuhXVXL6BZza4hFGgRa
         3/Ag==
X-Gm-Message-State: AOJu0YyPoy1klX8yzsHsRakJZW3wzvEqNajJKcAF1w9kELvUqXxeuSoE
	B0y9BLKOUjpOyJD1ZI700LnGL7P93slmFw8o5AmalmhA45VKgvRT8qkhUDkOIAyLcojd6arTIqC
	r
X-Google-Smtp-Source: AGHT+IGCKKngCo+MwZXEaSRdd0M3ktWd6kQrWsKTusFqAusWbZbxURU8PPicMGC+cQV+DzbJAsKjuA==
X-Received: by 2002:a05:6e02:1d0a:b0:363:b545:3a97 with SMTP id i10-20020a056e021d0a00b00363b5453a97mr2235247ila.0.1708013409094;
        Thu, 15 Feb 2024 08:10:09 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id x4-20020a056e02074400b0036275404ab3sm458524ils.85.2024.02.15.08.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Feb 2024 08:10:07 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: add support for batch wait timeout
Date: Thu, 15 Feb 2024 09:06:58 -0700
Message-ID: <20240215161002.3044270-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240215161002.3044270-1-axboe@kernel.dk>
References: <20240215161002.3044270-1-axboe@kernel.dk>
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
 io_uring/io_uring.c | 79 +++++++++++++++++++++++++++++++++++++++------
 io_uring/io_uring.h |  2 ++
 2 files changed, 71 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ebc646ad6acf..e72261f280a7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2529,12 +2529,65 @@ static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-static int io_cqring_schedule_timeout(struct io_wait_queue *iowq)
+/*
+ * Doing min_timeout portion. If we saw any timeouts, events, or have work,
+ * wake up. If not, and we have a normal timeout, switch to that and keep
+ * sleeping.
+ */
+static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
 {
+	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
+	struct io_ring_ctx *ctx = iowq->ctx;
+	ktime_t timeout;
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
+	timeout = ktime_sub_ns(iowq->timeout, iowq->min_timeout);
+	iowq->t.function = io_cqring_timer_wakeup;
+	hrtimer_set_expires(timer, ktime_add_ns(timeout, ktime_get_ns()));
+	return HRTIMER_RESTART;
+out_wake:
+	return io_cqring_timer_wakeup(timer);
+}
+
+static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
+				      ktime_t start_time)
+{
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
@@ -2548,7 +2601,8 @@ static int io_cqring_schedule_timeout(struct io_wait_queue *iowq)
 }
 
 static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-				     struct io_wait_queue *iowq)
+				     struct io_wait_queue *iowq,
+				     ktime_t start_time)
 {
 	int io_wait, ret = 0;
 
@@ -2560,8 +2614,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
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
@@ -2570,7 +2624,8 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 
 /* when returns >0, the caller should retry */
 static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-					  struct io_wait_queue *iowq)
+					  struct io_wait_queue *iowq,
+					  ktime_t start_time)
 {
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
@@ -2583,7 +2638,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	if (unlikely(io_should_wake(iowq)))
 		return 0;
 
-	return __io_cqring_wait_schedule(ctx, iowq);
+	return __io_cqring_wait_schedule(ctx, iowq, start_time);
 }
 
 /*
@@ -2596,6 +2651,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 {
 	struct io_wait_queue iowq;
 	struct io_rings *rings = ctx->rings;
+	ktime_t start_time;
 	int ret;
 
 	if (!io_allowed_run_tw(ctx))
@@ -2626,8 +2682,11 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
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
@@ -2635,7 +2694,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
 
-		iowq.timeout = ktime_add_ns(timespec64_to_ktime(ts), ktime_get_ns());
+		iowq.timeout = timespec64_to_ktime(ts);
 		io_napi_adjust_timeout(ctx, &iowq, &ts);
 	}
 
@@ -2654,7 +2713,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 							TASK_INTERRUPTIBLE);
 		}
 
-		ret = io_cqring_wait_schedule(ctx, &iowq);
+		ret = io_cqring_wait_schedule(ctx, &iowq, start_time);
 		__set_current_state(TASK_RUNNING);
 		atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9d1045bdc505..f385c7e36cb7 100644
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


