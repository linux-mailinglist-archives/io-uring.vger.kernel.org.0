Return-Path: <io-uring+bounces-2870-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D317C959F8E
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 16:19:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB31E1C21D4F
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 14:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 823161AF4D2;
	Wed, 21 Aug 2024 14:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JH5Aq49b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC861B1D56
	for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 14:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724249959; cv=none; b=Fk8lHl1ejogzoCMom+j2yjCcjsgmCVgjQkG82I950EFer9nookk6qmUqLY7yw/2oHtG/yzuygKF1ntgdnGZyzog3j0B7W7VtvpZcDk2H8FVO4wyb1ezQTU0c8Tt6pUc4Vo7fYtgl48ek0fX5t060RMPj5S9DLTAKK1/xX/dKJnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724249959; c=relaxed/simple;
	bh=ZuKjf4ATUzMHz+NDRSe13wyM+i7gX2rCoBO5erLvIOQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MURB4FGapz1xD88n2NABvBlRuZy9+g8ctesBsWCzUQMy4RxfPUku9nlYKpWOnrSmgyAPTrmKnZNtunWdZffptXgky01aOBalq6vd9iV++r/af3n02ieQsd5uvggFcAjhltq29hz+mLKTYd0YP1i6idcWrqqo5nyAaXegg3rq388=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JH5Aq49b; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-37636c3872bso26033395ab.3
        for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 07:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724249956; x=1724854756; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GVnsGmbj3k+86VX6mvfNHtIqtKsh1mg4Q0PTn3axPDg=;
        b=JH5Aq49bRVx6QuG/aMDLPFbtzgCm/7Gn2AIGB2kmfF99pvYhjOCVYxS34SBp+QlzC2
         Z0DS1OlE7/Loe4wlFBlPihc8h7N4Ptl2MuYgqzj7DJ5dxH8FKNci6pPxG9X6wprBUenU
         WUNygLA5xuQRVxhG7lS+hAkvzfS6sumsuKOGLt+0QTH/mPSsam99dEMUVK03oRlpoPgs
         sGyckGczw0McN6XJh9FTc/t2ebVftr36suGh9A2EHuF0jbrXW3OJ1Sgt2UWtp2EokWEy
         QUGPAfYb4f9MrUsx3LGncwTVegItB2ZLS5Y3WtjaoN0KMt7z4bom2M6szfLca6k4fRUj
         ODEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724249956; x=1724854756;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GVnsGmbj3k+86VX6mvfNHtIqtKsh1mg4Q0PTn3axPDg=;
        b=UJ1VrfeW00Y6L4chKanunwsZ6DbHVm3lYSQ89l2PEWnJsace5BmezpT+j5fjnhH3dt
         4Iptc5domnRFDJp9Y+TWk6gPyk4mmAgJlx6UhnLkeB24ip2UpFIy3PiS8LCpaeOBWSg1
         BOKYxWlSAoMPdYolL4Xyju9h7U8+BpevG3MlmuUhU04zRGet1HI3/yHWa3XtIPTtHjJR
         0XZexXIoRLhb4XjK0p5eo2SRptic2e8A9s5Nbsh8vMTti6KjBfs8pJixNs7261EWzFiH
         k/+j2ZDh1h+ejo6OZFEW+XlFyZKYGAR6dnlnFoLexXGwtMirTpa8B80vsBE+5JDPBQAZ
         B93g==
X-Gm-Message-State: AOJu0YxeOJJmOcWoIJqftP8SWNKVv9Dm/G/kPm2GGiNA0ECUFb4qdFaQ
	STqyd8Ag5aZjpUz0wuXceHAoe5hj8GrH+TzASYETHp7s5L/at1g/dfnRe2ncwSFICV2Mw84IyXX
	V
X-Google-Smtp-Source: AGHT+IEqwHsIoSyZnluWkAyY0OLmXSNQn8BEkZm3eSxM2qQmaQDAWyCyiVrYqxSQfLjEIJh401YBPQ==
X-Received: by 2002:a05:6e02:1fe5:b0:39d:25ef:541e with SMTP id e9e14a558f8ab-39d6c3c7820mr24231875ab.26.1724249955807;
        Wed, 21 Aug 2024 07:19:15 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39d1eb0bc93sm50967285ab.19.2024.08.21.07.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:19:14 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: implement our own schedule timeout handling
Date: Wed, 21 Aug 2024 08:16:24 -0600
Message-ID: <20240821141910.204660-4-axboe@kernel.dk>
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

In preparation for having two distinct timeouts and avoid waking the
task if we don't need to.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 37 ++++++++++++++++++++++++++++++++-----
 io_uring/io_uring.h |  2 ++
 2 files changed, 34 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9e2b8d4c05db..4ba5292137c3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2322,7 +2322,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 	 * Cannot safely flush overflowed CQEs from here, ensure we wake up
 	 * the task, and the next invocation will do it.
 	 */
-	if (io_should_wake(iowq) || io_has_work(iowq->ctx))
+	if (io_should_wake(iowq) || io_has_work(iowq->ctx) || iowq->hit_timeout)
 		return autoremove_wake_function(curr, mode, wake_flags, key);
 	return -1;
 }
@@ -2350,6 +2350,34 @@ static bool current_pending_io(void)
 	return percpu_counter_read_positive(&tctx->inflight);
 }
 
+static enum hrtimer_restart io_cqring_timer_wakeup(struct hrtimer *timer)
+{
+	struct io_wait_queue *iowq = container_of(timer, struct io_wait_queue, t);
+
+	WRITE_ONCE(iowq->hit_timeout, 1);
+	wake_up_process(iowq->wq.private);
+	return HRTIMER_NORESTART;
+}
+
+static int io_cqring_schedule_timeout(struct io_wait_queue *iowq,
+				      clockid_t clock_id)
+{
+	iowq->hit_timeout = 0;
+	hrtimer_init_on_stack(&iowq->t, clock_id, HRTIMER_MODE_ABS);
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
@@ -2362,11 +2390,10 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 */
 	if (current_pending_io())
 		current->in_iowait = 1;
-	if (iowq->timeout == KTIME_MAX)
+	if (iowq->timeout != KTIME_MAX)
+		ret = io_cqring_schedule_timeout(iowq, ctx->clockid);
+	else
 		schedule();
-	else if (!schedule_hrtimeout_range_clock(&iowq->timeout, 0,
-						 HRTIMER_MODE_ABS, ctx->clockid))
-		ret = -ETIME;
 	current->in_iowait = 0;
 	return ret;
 }
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9935819f12b7..f95c1b080f4b 100644
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
 	ktime_t napi_busy_poll_dt;
-- 
2.43.0


