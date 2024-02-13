Return-Path: <io-uring+bounces-599-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E220853A9C
	for <lists+io-uring@lfdr.de>; Tue, 13 Feb 2024 20:14:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8EBBEB23DA8
	for <lists+io-uring@lfdr.de>; Tue, 13 Feb 2024 19:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECE651E49E;
	Tue, 13 Feb 2024 19:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="gP46mGjq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACCF1CF9C
	for <io-uring@vger.kernel.org>; Tue, 13 Feb 2024 19:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707851641; cv=none; b=FvBPwF+PwLGKFt68Qngr4calaK84moKnpJeWMcjPbHRgni2qqaavSwW8zar6As0lQhjK3cDcEYX6VkTY/UO+s4TY34q8jz6tXtRLFcrrOvVb4eFmvGvvIPJ9T/ZA89JOHA4loWT26zMT8Jh8G3ET4rMRqGjznrQpfXpDFqavBZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707851641; c=relaxed/simple;
	bh=KaYvlteVmBmUOKR/d66kbUHxMrfMW0kblL3f6aVkDlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCkEj3zp5981UzI4k4hCzvEXD/fKfuyGspFrzx1nWCJkHz3pZwOv0d8ui0Zm0NhLsq+DJlGqMiVyq9oFRbdpKuI144bBrr1uJgoMtNe4/bZYXCivrJSAr6SnaAxloC55znkgZ6QI09zIEcmXM4+GXHTVP4leDtKHt4kY/uwM/Ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=gP46mGjq; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7bff2f6080aso22262939f.1
        for <io-uring@vger.kernel.org>; Tue, 13 Feb 2024 11:13:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707851638; x=1708456438; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c/Kmq+35dnA+ebSFVKAZ8uNkETqLpSzTuSZvxvGR39E=;
        b=gP46mGjqU1nXCdr3r6XSkXlSiGnDgZ4caIOdRKJrkwgvyqnell+GJg4ejs44duvps2
         Rt/vSUarOVAyATJ5D1ey6/Cl2RJ+NwkYtKm8Ynpf1FNzL/w3AlILWOpRviFFdz+f8nIG
         fT8/OtMRXJW58iMqQdGUwDaIcbQYctwIKbTeFjWf7QWICaSJnLkLAU0mn3NspWAm/CF/
         bz6FTK4H6bjzrFrN9dlowB1+/bdUUjf/WLK8K0yD08xg+y2HFlAbPM2QMjaTs4nOmwhg
         /4LlSmB3T/oCMre5KtdJhu1QmUeop9ev6bUNruet0ddu5IBgi0n5VEChsz8csdVEj7NW
         Z5sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707851638; x=1708456438;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c/Kmq+35dnA+ebSFVKAZ8uNkETqLpSzTuSZvxvGR39E=;
        b=bIIblMM9uQBro0PYUHRNw5eNskPcfPOVlNls2Tcv4UH8HYYP/1n0O6SdWkR4Hf+c36
         r3qQdw5NhoiidZ8j4SK0wRUCmsKT38Wn/gaLqnVTnTuCa23JXZD6h9uP/RJY9BcpOQ0d
         /pQeBI4/WqrhC6gB4CKV95cTzO2YX5C8TYm/4HkVn6uoB2aFNgmEWoA2WPExAcvS2iAO
         ahkONQrSK+1l0pFcgLS8IogOUYtcL1H6+ibuPv4t6/GjGv2WvODIFTC+4JFBZ57fFm9d
         B7QP3isxFJXAbemGig9udew8Gn820HTkA5GBhnKF6C1RWjJkFKk0D0oUnyWvZ89BaUfI
         SJ3A==
X-Gm-Message-State: AOJu0YwbM3q4r7j6+WZ0LnOKx8t706n3QXsDtqR+rxMlDKLr/eHsegsJ
	IdITqPLasttci5sB5NsPhvLM5C+arIBP8lZU6LRBx5Srpn7LWQgGuiNa8mplzEz2ywvdbAM6EHt
	i
X-Google-Smtp-Source: AGHT+IGmAMG+eElwuhB4rpspvB3Es1nbrYaPHfz04brf18YxHNaKbqR6oVZ/ss6QOEZwAD/7N9WaPQ==
X-Received: by 2002:a5e:9411:0:b0:7c4:4f32:8311 with SMTP id q17-20020a5e9411000000b007c44f328311mr647932ioj.2.1707851638331;
        Tue, 13 Feb 2024 11:13:58 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id cz17-20020a0566384a1100b004713ef05d60sm2032176jab.96.2024.02.13.11.13.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 11:13:57 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: implement our own schedule timeout handling
Date: Tue, 13 Feb 2024 12:03:39 -0700
Message-ID: <20240213191352.2452160-3-axboe@kernel.dk>
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

In preparation for having two distinct timeouts and avoid waking the
task if we don't need to.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 39 +++++++++++++++++++++++++++++++++++----
 io_uring/io_uring.h |  2 ++
 2 files changed, 37 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 67cc7003b5bd..f2d3f39d6106 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2495,7 +2495,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
 	 * the task, and the next invocation will do it.
 	 */
-	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
+	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
 		return autoremove_wake_function(curr, mode, wake_flags, key);
 	return -1;
 }
@@ -2523,6 +2523,37 @@ static bool current_pending_io(void)
 	return percpu_counter_read_positive(&tctx->inflight);
 }
 
+static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
+{
+	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
+	struct io_ring_ctx *ctx = iowq->ctx;
+
+	WRITE_ONCE(iowq->hit_timeout, 1);
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+		wake_up_process(ctx->submitter_task);
+	else
+		io_cqring_wake(ctx);
+	return HRTIMER_NORESTART;
+}
+
+static int io_cqring_schedule_timeout(struct io_wait_queue *iowq)
+{
+	iowq->hit_timeout = 0;
+	hrtimer_init_on_stack(&iowq->t, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	iowq->t.function = io_cqring_timer_wakeup;
+	hrtimer_set_expires_range_ns(&iowq->t, iowq->timeout, 0);
+	hrtimer_start_expires(&iowq->t, HRTIMER_MODE_ABS);
+
+	if (!READ_ONCE(iowq->hit_timeout))
+		schedule();
+
+	hrtimer_cancel(&iowq->t);
+	destroy_hrtimer_on_stack(&iowq->t);
+	__set_current_state(TASK_RUNNING);
+
+	return READ_ONCE(iowq->hit_timeout) ? -ETIME : 0;
+}
+
 static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 				     struct io_wait_queue *iowq)
 {
@@ -2536,10 +2567,10 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	io_wait = current->in_iowait;
 	if (current_pending_io())
 		current->in_iowait = 1;
-	if (iowq->timeout == KTIME_MAX)
+	if (iowq->timeout != KTIME_MAX)
+		ret = io_cqring_schedule_timeout(iowq);
+	else
 		schedule();
-	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
-		ret = -ETIME;
 	current->in_iowait = io_wait;
 	return ret;
 }
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 1ca99522811b..d7295ae2c8a6 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -40,7 +40,9 @@ struct io_wait_queue {
 	struct io_ring_ctx *ctx;
 	unsigned cq_tail;
 	unsigned nr_timeouts;
+	int hit_timeout;
 	ktime_t timeout;
+	struct hrtimer t;
 
 #ifdef CONFIG_NET_RX_BUSY_POLL
 	unsigned int napi_busy_poll_to;
-- 
2.43.0


