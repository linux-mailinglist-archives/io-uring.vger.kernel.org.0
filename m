Return-Path: <io-uring+bounces-2868-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DFC4959F8D
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 16:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A3EB1F23DC4
	for <lists+io-uring@lfdr.de>; Wed, 21 Aug 2024 14:19:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D04B91B1D5A;
	Wed, 21 Aug 2024 14:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rOyZGsGV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12911AF4ED
	for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 14:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724249957; cv=none; b=HBV6kauUO5B1BiwYrjlMWrBZkbMVYOxpb7ZjoFm3ZHfbw2FX2sRX1KA8YHvFqjdOX/whrbRw8YfgoGTflwkNCuu1I7Cxrga7+8uXTC8zLg7gej6BrGalLfwN4iGhWFoALFOqw1yxClOnRdcBf7HAL5iDUVGkIOBFZ1WwBxM62WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724249957; c=relaxed/simple;
	bh=VQY2AbWmYzmJa+BvEd4NBvoFPgkwUcD+DdlnfHAS3AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JX/yKF5QCLcjt4zIVJIczDgrzA1SKJs6L1n7PJADAH3Wd8O0BrbYx9tby2d8B3Woa2JK4keUjjoERDlRdZF2WylwIKSpCooXcDjbQx7sizQhdkOtkR1TPotsJj9Dnid3Caz2T9o6MNQI8EyJ6NdYeOAGvNK7wamRjK3x0qT0Mr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rOyZGsGV; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-81fd1e1d38bso365100339f.1
        for <io-uring@vger.kernel.org>; Wed, 21 Aug 2024 07:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724249954; x=1724854754; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFCcMIWHME8JN9Gx6FSrjmoKIn8+i+WeAhjeL4V+qIE=;
        b=rOyZGsGVHcx2wSdBdu7jJ2Az/g2V42JK9LgM8/BnBoyz44v3BKeWwSjVmZziNnikv6
         64RYHFLNkT3XFcDOfKpPzM3X29NCX/L6devztElf8a2k01iGgPbL5WWMOn31fNL363dq
         gElWzje1bG7DE9o8UnVTi5H9ZBX9sUR871z3FneCxWryRaY3D9kUSvArppW2wV4yS9NT
         +A5vTsPhek2Y4nyYcbidlaRoYftlQ+IzC1Qs2GefrdR4XPu+LAyQGKktz4nNDDuzBt20
         ltg17b/uKu5bcljISuZOizooVCIU83Ca3IyUe7PSMLOVlICJYx8lvgFN1CjBtN4E1M8W
         2u9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724249954; x=1724854754;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jFCcMIWHME8JN9Gx6FSrjmoKIn8+i+WeAhjeL4V+qIE=;
        b=aOqGWX4ba2UlDremZL5qfgd7KDOcXcO0rGT+8r0sHGBav/qfFLRFyLXG9E8ru8i5pg
         d4gL0pD7bIL29N9VEG5cebvWe4B88Gszi0WNAjH5wVM/eRZ6//0u/X6kSqczEs8rEVPE
         jPQTDVzjp42XaCCXNSTGuPwcYdQLK+hK1ReyXRyUv7ywffscnYl6Bt1c+fNG8q/Mepkt
         wdcFdp3JhzoL/Q0UDPbcdVNVI5OWzmGXpggCwFD0BcPby62BYKbfW0VcFzH2ZrEjxSSv
         88WR7QtBPnaO1Qs1F+Gvc5L3qIVNUpZRiBGjxz02ZnUI2wPEKyCEQWydctJyJJe7SMi8
         hq9A==
X-Gm-Message-State: AOJu0Yzua16XFUt8eE3EWzp7oBqopSKjRENpv4PBeot5LJ5j2i0WTak+
	3QmpGUzOWFHaVATPSR9CtMiaxAB55OXxEt80J0ML0XNVmFgQG7rs6T/F1wiHNTIaLDVERRHwht9
	7
X-Google-Smtp-Source: AGHT+IG9psSgP1tmj+j1eU+szjm1hn/x7grDMXlbo+8xvA1EJg02Kru+3oSryJTspV+znRglW7pfDA==
X-Received: by 2002:a05:6e02:1a8e:b0:39d:35f2:6ed7 with SMTP id e9e14a558f8ab-39d6c3bc3bemr26200055ab.27.1724249954320;
        Wed, 21 Aug 2024 07:19:14 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-39d1eb0bc93sm50967285ab.19.2024.08.21.07.19.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Aug 2024 07:19:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: move schedule wait logic into helper
Date: Wed, 21 Aug 2024 08:16:23 -0600
Message-ID: <20240821141910.204660-3-axboe@kernel.dk>
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

In preparation for expanding how we handle waits, move the actual
schedule and schedule_timeout() handling into a helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 37 +++++++++++++++++++++----------------
 1 file changed, 21 insertions(+), 16 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 37053d32c668..9e2b8d4c05db 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2350,22 +2350,10 @@ static bool current_pending_io(void)
 	return percpu_counter_read_positive(&tctx->inflight);
 }
 
-/* when returns >0, the caller should retry */
-static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
-					  struct io_wait_queue *iowq)
+static int __io_cqring_wait_schedule(struct io_ring_ctx *ctx,
+				     struct io_wait_queue *iowq)
 {
-	int ret;
-
-	if (unlikely(READ_ONCE(ctx->check_cq)))
-		return 1;
-	if (unlikely(!llist_empty(&ctx->work_llist)))
-		return 1;
-	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
-		return 1;
-	if (unlikely(task_sigpending(current)))
-		return -EINTR;
-	if (unlikely(io_should_wake(iowq)))
-		return 0;
+	int ret = 0;
 
 	/*
 	 * Mark us as being in io_wait if we have pending requests, so cpufreq
@@ -2374,7 +2362,6 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	 */
 	if (current_pending_io())
 		current->in_iowait = 1;
-	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
 		schedule();
 	else if (!schedule_hrtimeout_range_clock(&iowq->timeout, 0,
@@ -2384,6 +2371,24 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+/* If this returns > 0, the caller should retry */
+static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
+					  struct io_wait_queue *iowq)
+{
+	if (unlikely(READ_ONCE(ctx->check_cq)))
+		return 1;
+	if (unlikely(!llist_empty(&ctx->work_llist)))
+		return 1;
+	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
+		return 1;
+	if (unlikely(task_sigpending(current)))
+		return -EINTR;
+	if (unlikely(io_should_wake(iowq)))
+		return 0;
+
+	return __io_cqring_wait_schedule(ctx, iowq);
+}
+
 struct ext_arg {
 	size_t argsz;
 	struct __kernel_timespec __user *ts;
-- 
2.43.0


