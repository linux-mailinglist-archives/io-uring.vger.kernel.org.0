Return-Path: <io-uring+bounces-2838-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BF4E9578AA
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 01:30:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6D538B21D0F
	for <lists+io-uring@lfdr.de>; Mon, 19 Aug 2024 23:30:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 522D015A865;
	Mon, 19 Aug 2024 23:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="xa32N3ew"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AFBC1DF666
	for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 23:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724110253; cv=none; b=KpwhMCCxDARV/YFgo0Dozbb05TEiX5L5oc9W9tj0VcrdbDmRNuksyI2gxM4xLsJJFedaW/oBw+83ZgyecSuQO9F1Vp1RD9o6Hsjd2u3qtMhCK4r5z3IW/Ikwj+0dIpJCYhdv6PgvOgs5G77FouWntMOkXcqGc811kHeZSVddKAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724110253; c=relaxed/simple;
	bh=90pR2Ey96PSI1+J+Epa5/I/AV2VBjzGktD9NBso+DpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OzBtRyweayGDbg66xNyOSE/zNIk3qt2xnqdQR+f1emGA0ABdkuTCjZk06f7nL9zQaK0uhGEpqr3mZ6OinbOMKwyBq3fYIARBuf3M2NRWLGuc/g1Kcg4eIL4ZBRlOol8vI7xJx7yvJ94KHv2zjHh3wwMbBVfTPODjxNQ4lThmXzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=xa32N3ew; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7a12bb0665eso329569a12.3
        for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 16:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724110250; x=1724715050; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tVKZdW1Aw/5ZOZerCJF/LQrFswF3tPTr8IaFuf4/pDo=;
        b=xa32N3ewe0eMVBpNYtaKkA5C3qyVAXyUZyDBc531xXQ6E1xDscw5rPcOfpkdaN12Sa
         sTJ7aNve5CRqEDb3kSEaglpJp+O0daO2If/AMxEp8Gidhtgm+ju7tUrVlZlQTctSny6T
         mG9gXmaa3jfHxitu0RFmJqKHrNPDJWvxdMTuUzmH0TZxDKh7tYMDDFHyuB9J6z8WJbgq
         SPgZhc3ndViFZB7tM5NUbbUGynHqzsZf/J73nuYx1AM4uQW0WwApEU4qDOFhll1ySVoJ
         NqwsIRoqUXquZP61LwBG6o7E2tizZPU0KFmkCTxa306XFiyHnJYNuteGN2IDmQI/Y9FX
         etKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724110250; x=1724715050;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tVKZdW1Aw/5ZOZerCJF/LQrFswF3tPTr8IaFuf4/pDo=;
        b=BOO8b0BE0YDjf9GDyLjHJqTSWh45zYK4L3+JK3kTvIRhExbhJ91B2V9uy3fAxMR7v0
         3YtQyzxK0G0oEkKDpMaIEMDbJx4BnRjMOrDtKopnY6gzzcNfheYUZHyC04ZYlz003YAI
         xGFDSJotYiZB6hE4yx2Af6FxV49u/gG6R9nIrDtkomJX93VLxRqn1Vm2Cdq3oKQH2L9X
         cnSk//7Kvp7YAzEy5yPILTk1eQuxZPXMjNWPTcuhsGVOGsk/bnsDcP3ZgQvOCL8xNVMt
         gRtt67uUCLcIKO/4zfId5kVJXV9FZbl6kLTHROyD05TntPuN6I6yQRGwTvH2jDZmA0lt
         NxbQ==
X-Gm-Message-State: AOJu0YxI2TEbsC5TDF28gj/zsgnadugt+wzH+chExduM4IkEp7SAeFFa
	fTnLzx5sTIaGZ5/ZDuugkDqb9BxP2alo9EiJdSu3z/1m7+i1i8X5xzLLhFT5rJEuCZEphaJgQLF
	c
X-Google-Smtp-Source: AGHT+IFGpUShF0uMSTvctlrg4WiaSdepQbs/MkF+H4ZdNvJ/0SQ0tKT040f3z4ApeUYL33rLzd+txg==
X-Received: by 2002:a05:6a00:6f15:b0:704:173c:5111 with SMTP id d2e1a72fcca58-713c5652357mr9068332b3a.3.1724110250336;
        Mon, 19 Aug 2024 16:30:50 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61dc929sm8219838a12.40.2024.08.19.16.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 16:30:49 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring: implement our own schedule timeout handling
Date: Mon, 19 Aug 2024 17:28:51 -0600
Message-ID: <20240819233042.230956-4-axboe@kernel.dk>
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

In preparation for having two distinct timeouts and avoid waking the
task if we don't need to.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 41 ++++++++++++++++++++++++++++++++++++-----
 io_uring/io_uring.h |  2 ++
 2 files changed, 38 insertions(+), 5 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9e2b8d4c05db..ddfbe04c61ed 100644
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
@@ -2350,6 +2350,38 @@ static bool current_pending_io(void)
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
@@ -2362,11 +2394,10 @@ static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
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


