Return-Path: <io-uring+bounces-2837-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B3E5A9578A7
	for <lists+io-uring@lfdr.de>; Tue, 20 Aug 2024 01:30:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E69A81C2398A
	for <lists+io-uring@lfdr.de>; Mon, 19 Aug 2024 23:30:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D45571DF685;
	Mon, 19 Aug 2024 23:30:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="uJ1gF8rY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66A9615A865
	for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 23:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724110252; cv=none; b=hpH1YjSvnArYNumy3Cuup3aMC6mb17FLJizjRTS4wC3+UcxVlP4ggxcyHxZYYjs1UconmjE0F3mAQlTLmmrGW4+UIDDK5Nj5Sb2ceqBcLAX4HQiN5sgXgIkKLn8doaHJQRNlZABByj60xKRq6h2t5CR3iPKrh9Ocgvy8ajqxoPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724110252; c=relaxed/simple;
	bh=VQY2AbWmYzmJa+BvEd4NBvoFPgkwUcD+DdlnfHAS3AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WV9lGCN+25gar9f8RQ/ycF0csTJSkh94dT960UIm8ER0btauTtCw9rWdpft+6GBZ6t23YA49yhU8i+iueVa7UVdgUISRRavW9pEWZxvVMr0A8QG1OwIO88aKjIoQ+/QIgMiWsHkW0RL2GIZ2KExTF1LxC8/yKSTjN8nEtdUl+eE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=uJ1gF8rY; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-26110765976so651034fac.1
        for <io-uring@vger.kernel.org>; Mon, 19 Aug 2024 16:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724110249; x=1724715049; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jFCcMIWHME8JN9Gx6FSrjmoKIn8+i+WeAhjeL4V+qIE=;
        b=uJ1gF8rY8WfuFWn3IgKEThzVm+AkEiduBGOPSuIPx5u5mGpvbpRRlZ5FExnkD7Dm6F
         B2kSHdKiP7iui5QQbMVX6kwqGUNuI2z5L5KE8TiBlbWiOd9Nc6gTB73YSaEAmXzTzHiD
         7Yf6OZ5ECpzQU23Hhp+XLhyutkVV1gb3LI79lqFwejv/J36k0j0Et3bNmyfncdxcjzph
         GHfqi29T6TBsDaeI/C4YJjzKC7s0y/mi/MntlKDyuSWV4DX5pGJiQ2cdhG7dk50FvZPS
         FNMO9kW1M5aaQP1/sCbLqYgf74cVN03Hospw0ceGMruDYsZzC/3GOW79Ii7r4gRwVrWN
         6+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724110249; x=1724715049;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jFCcMIWHME8JN9Gx6FSrjmoKIn8+i+WeAhjeL4V+qIE=;
        b=sS5Q28PnQrNMOF7jkzOicgrWnEzBom1uBNB5ieVIsps3+KLHBtO8FoeTbB0CV2T8zP
         d5aKHUdm4CpJs5fTmw3+FRMIyqNIy785qm5GK+sjS9fTV/svUvnW6Jc1Yy5ByJ4NgZhC
         bMEZp84qqxqi3DblYhRukekqReVdr+HoNRyhMvHtojk9S6xHlNSnB0GucVnxkiorWcs1
         2+ZXMRxUmFH/CQx7soYpJ6ycjsDz6diw/TqEAD857MRRqhoyQkazZ1lUdtK0hxXGVK8z
         65z5H+mBfaAG7ycktPaC0OTsZ00+ntj5NY6S/FbhraBhxmqs5Lr241B3yjsVxftGuQ1l
         8fUw==
X-Gm-Message-State: AOJu0Yy6Hy5V0qsq1fTnawoyotJuHAGpsV3YezOJZQ9QsFmVFuKaADfs
	WbwZQzAjyz3LjfGEBo9UwHyCuS2pGNKENxzAbHWBg8mrOpumqJGrz+qIpxvKOb4MlaBuBu0579b
	Q
X-Google-Smtp-Source: AGHT+IEt3QogboPonSncMZrvZ0MCKYOJs6y4X44RDV4uIs2ZU9QAQGo+MmnStnx1VZKHChZAsuMQ5w==
X-Received: by 2002:a05:6870:d609:b0:260:ccfd:1eff with SMTP id 586e51a60fabf-2701c575dc3mr6528241fac.7.1724110249109;
        Mon, 19 Aug 2024 16:30:49 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7c6b61dc929sm8219838a12.40.2024.08.19.16.30.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Aug 2024 16:30:48 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: move schedule wait logic into helper
Date: Mon, 19 Aug 2024 17:28:50 -0600
Message-ID: <20240819233042.230956-3-axboe@kernel.dk>
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


