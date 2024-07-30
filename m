Return-Path: <io-uring+bounces-2615-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EE6F9421A0
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 22:29:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CE1A01F25706
	for <lists+io-uring@lfdr.de>; Tue, 30 Jul 2024 20:29:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE3081662F4;
	Tue, 30 Jul 2024 20:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bdZf2IGh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D666618DF9A
	for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 20:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722371369; cv=none; b=QQpGDNSbFDGgWhN/JYGOyYKPijQZfaXkoA7vOp7Ai1vzq4u31MDXWiuKGtS5Tg0ENDU91kKFYIIqe9FMvWBeNF+ST/CEzUm1Aq0yblxkabbQQXkhuNXmV8p8ygvQwquapRFrZFhhm6gwYfgD9oEJqvfOeibAhKh6V4cw7r4RvZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722371369; c=relaxed/simple;
	bh=JZOOWWe04FmpSsGhdrgPhCnpAbAOD6Rq2mMhZw+BKjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uEhHuiC4waSaQhyotR88Uo4R5BvJwve9iBoOeLvHhLACBGDftA/fl7WkDLQTBNxq9voER8sGQhP/EdGBDFhRv+W5zKbOAOmN2WhbMU1YLpz9Uf9wlKaDYtbfBaZhmRPhMsKU91897X6pjyMKTTrzF9WMteMGFTpILDSRzucva8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bdZf2IGh; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-428243f928fso13266165e9.0
        for <io-uring@vger.kernel.org>; Tue, 30 Jul 2024 13:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722371366; x=1722976166; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xb8u2LzTqPXQGpAJX7Eawxnuj0oeSkULgKH2OZy+MqQ=;
        b=bdZf2IGhhWUq1vfE+U1V//rnjSwPgO/D5afOHe3MHePFaG/GYrcahmk7rFXYmPZZgA
         V3NepThcyv8iY0Iny5+d17KD2Tv8S21qvV04k4RovLOqlNHYT1dLKl4HkZn1bWZN8ueR
         Dfprs3cr0+D+3nNni5LnU9Zfmqs2Z6L0TPvLFTkeNHl1NkVDUzoQzIVwnC3VnTEyQlBx
         XL2SUmciWJ3YEclMhJ8TebD4f5741CxN3RNi21jCa3x1GxCvvOnZ24HdC1AhiU6WpAPM
         wzD80zL3gamMvZqZRI7BmarulhcizH1TXHdoMSzOYC1XlKalOsKSxdW9AtBFBuBoXFuB
         NzXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722371366; x=1722976166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xb8u2LzTqPXQGpAJX7Eawxnuj0oeSkULgKH2OZy+MqQ=;
        b=IrBlm+t8YfrGPv7LuJol2bqaclcAGDSL7Tode+vj5s/kQ/W/Q7Ppsjb28/Fu671vp8
         30xQ1tBSogGt9b4vLhTL18SbYasA90Xb1I3Co5lAT1GlQfz1wcK1YWX1IBRl1COT1gmj
         rvCPCXT5TLjTPEPQaKDoK5CdDtSZ7SnYHrDczqhpAGMG4hNwvRW3K1pv8bdUxPRKc4KK
         wy5PD5vlFPwtSoJRyWSCdvZQk07AzeFyzYlLXkf9OeMMbpXElYiZ8EAnDeHSqLrpK8Eb
         Exl1BDALpvqKIZ1AXEeYEiGdGqX5bNE/Cwmba/19ApfhgH/tkGjG0SBsdhfCjfZ7h2Sy
         fEDA==
X-Gm-Message-State: AOJu0Yzrtmf2neYcu0gzZWRrNZKnBJaxZbzldMIwB99RexRGGopTt3xN
	0Y8Qug7QMSMD0OcctRrSa3Vr+hO/ekSfcW4aSXFremGxHzYVpqJ5UOQ2og==
X-Google-Smtp-Source: AGHT+IFEi5Vr8c/q+mEPUHBtUOwriUpfA5Hz1dQuRJSM0ghM5w/qzu7YdG4QIN8ekovfZXSVMbqFNQ==
X-Received: by 2002:a05:600c:4fcd:b0:426:545b:ec00 with SMTP id 5b1f17b1804b1-42811da0861mr103358135e9.19.1722371365568;
        Tue, 30 Jul 2024 13:29:25 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.235.94])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42808457c7fsm214488065e9.32.2024.07.30.13.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jul 2024 13:29:24 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Lewis Baker <lewissbaker@gmail.com>
Subject: [PATCH 3/3] io_uring: add absolute mode wait timeouts
Date: Tue, 30 Jul 2024 21:29:44 +0100
Message-ID: <8db7af5ac6f6c81dc731e214f927c58e53d2d015.1722357468.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1722357468.git.asml.silence@gmail.com>
References: <cover.1722357468.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In addition to current relative timeouts for the waiting loop, where the
timespec argument specifies the maximum time it can wait for, add
support for the absolute mode, with the value carrying a CLOCK_MONOTONIC
absolute time until which we should return control back to the user.

Link: https://github.com/axboe/liburing/issues/1162
Suggested-by: Lewis Baker <lewissbaker@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/io_uring.c           | 13 +++++++------
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2aaf7ee256ac..afc901502804 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -507,6 +507,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_SQ_WAIT		(1U << 2)
 #define IORING_ENTER_EXT_ARG		(1U << 3)
 #define IORING_ENTER_REGISTERED_RING	(1U << 4)
+#define IORING_ENTER_ABS_TIMER		(1U << 5)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9ec07f76ad19..5940bd8f5630 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2387,7 +2387,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
  * Wait until events become available, if we don't already have some. The
  * application must reap them itself, as they reside on the shared cq ring.
  */
-static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
+static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 			  const sigset_t __user *sig, size_t sigsz,
 			  struct __kernel_timespec __user *uts)
 {
@@ -2416,13 +2416,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	if (uts) {
 		struct timespec64 ts;
-		ktime_t dt;
 
 		if (get_timespec64(&ts, uts))
 			return -EFAULT;
 
-		dt = timespec64_to_ktime(ts);
-		iowq.timeout = ktime_add(dt, ktime_get());
+		iowq.timeout = timespec64_to_ktime(ts);
+		if (!(flags & IORING_ENTER_ABS_TIMER))
+			iowq.timeout = ktime_add(iowq.timeout, ktime_get());
 	}
 
 	if (sig) {
@@ -3153,7 +3153,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
 			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
-			       IORING_ENTER_REGISTERED_RING)))
+			       IORING_ENTER_REGISTERED_RING |
+			       IORING_ENTER_ABS_TIMER)))
 		return -EINVAL;
 
 	/*
@@ -3252,7 +3253,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 				min_complete = min(min_complete,
 						   ctx->cq_entries);
 				ret2 = io_cqring_wait(ctx, min_complete, sig,
-						      argsz, ts);
+						      flags, argsz, ts);
 			}
 		}
 
-- 
2.45.2


