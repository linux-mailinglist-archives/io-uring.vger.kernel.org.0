Return-Path: <io-uring+bounces-2665-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B32A094A9E4
	for <lists+io-uring@lfdr.de>; Wed,  7 Aug 2024 16:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C89D285073
	for <lists+io-uring@lfdr.de>; Wed,  7 Aug 2024 14:18:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5777576056;
	Wed,  7 Aug 2024 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tcry4YEB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7EE53804
	for <io-uring@vger.kernel.org>; Wed,  7 Aug 2024 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040264; cv=none; b=XCCJHJYN4okFlT03ahkjPvFI9TsIr+dsQGsASo7eeznI5IfwdfnQ50Iz83ehKWt8bgc45nFsNkTyVJhcFJh1/rSnpe4Ekoj+xFByHgkvPGX18DT4z0ia1rqQCP7CwlHR+L4Iv70GEBMv8Lkogf1KdsSE8rF2AGCKGBzz8jLW1Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040264; c=relaxed/simple;
	bh=0KgL9mAOHnAXHqaLMBB/ti8Vpc9CRu9oziRb/ufYV64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n24oEswiFu1SPny71Lic7GNhWfTyQdvMYJhFqwY7I/cpT0fmwWbTGM4qGqVYQNZtxKdpyPCcoeJP1q+7RE/mGvjUjeGUCuWgZli6gLXPyScQ068C5JQbSXY+ZoROxU2ZvYPQ0lnpr4mnm7pKzAMDkGcNTGK7UAph0LpCPNDKqr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tcry4YEB; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5b8c2a6135dso2695026a12.1
        for <io-uring@vger.kernel.org>; Wed, 07 Aug 2024 07:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723040261; x=1723645061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y87uv01/QSe4u5tLRXTf6I7wzSiuLnMLzrUhMtzt6X8=;
        b=Tcry4YEBCzb77uqc+Yxa8MhtS+Ob24qrFD1ZgmMK0aMGBmXOvxqor6zGMxQ8nmpQlN
         WE0LvaDSTXqKxxf55FWq5HM1idWq3F5aSBIHUWBwIu8uQ9I//sBgBh0IBkq92R7rVaI9
         hEsrshVKPu1RyAXie0yHs0Qf13KzHPElqJUvYNLHvdr9l8zpJaKIRbckPGUrMEZncgYA
         UyOBKJ2pVH0T2Mh3QR+VzkYf55V5SlneP+hEWFLuskJ3w2SZgoKPVNydFNWMVR56h+cb
         iXPpNJ9E7TL2ns+svoaeKqqAH5L/YLJC6Fe8HAys0q/8KUlBWE2k7LAlu5OVU3F+fJe5
         HsbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723040261; x=1723645061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y87uv01/QSe4u5tLRXTf6I7wzSiuLnMLzrUhMtzt6X8=;
        b=kHyTYbZ6dQBLXm0aYYKM3B5vc1654Rw8/+Jn3wbzRAifmT20ra8fmf9opnDZoAivL/
         P9y1thanRgYM70/uZcKlPpwaXjYoI1eUYfjEmVf43xtLfnLIAWwYy6tc2JNqUItONJg7
         cIzhCBwbPMSVc+9ZT0d8lXbIP/HfAXHItl/gVDwf9bwm/bHRqlvG9+6XhzxZDfG0vVb+
         V1LACd37GZzgxxM3wxV0WNSpU853YFEfIc6z2q3MSfI5YKMcx1iI7YISyRIjpP8p66ML
         BH3j1eqXASQmUrpk5oFeI987Ydtj8RkS2brhymS3/ad+7Ggt0IR+EHDLq4+ZwgToUq2m
         +qHQ==
X-Gm-Message-State: AOJu0Yw0R3fVUNGQrpd4pwu0TbDLloukcuDs3bKqCrUmaKR2/uM9GbDF
	obxN/cwT/M62vCueoGnq3GM4OsneVDiPp+osaEQFSWznoSCLOzVzOFo4cg==
X-Google-Smtp-Source: AGHT+IGnx1wVDScEKFhg43qOXl0vJPYbyCBAlq1YU3PwnOpXjtipPiyvg/gUgYN8nKxoD7AIEB8esg==
X-Received: by 2002:a05:6402:5251:b0:5bb:9ae0:4a41 with SMTP id 4fb4d7f45d1cf-5bb9ae04b7dmr3636034a12.28.1723040260533;
        Wed, 07 Aug 2024 07:17:40 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5b83bf3a37bsm7176928a12.88.2024.08.07.07.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Aug 2024 07:17:40 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Lewis Baker <lewissbaker@gmail.com>
Subject: [PATCH v2 3/4] io_uring: add absolute mode wait timeouts
Date: Wed,  7 Aug 2024 15:18:13 +0100
Message-ID: <4d5b74d67ada882590b2e42aa3aa7117bbf6b55f.1723039801.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1723039801.git.asml.silence@gmail.com>
References: <cover.1723039801.git.asml.silence@gmail.com>
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

Suggested-by: Lewis Baker <lewissbaker@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/io_uring.c           | 15 ++++++++-------
 2 files changed, 9 insertions(+), 7 deletions(-)

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
index 9ec07f76ad19..5282f9887440 100644
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
@@ -3251,8 +3252,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			if (likely(!ret2)) {
 				min_complete = min(min_complete,
 						   ctx->cq_entries);
-				ret2 = io_cqring_wait(ctx, min_complete, sig,
-						      argsz, ts);
+				ret2 = io_cqring_wait(ctx, min_complete, flags,
+						      sig, argsz, ts);
 			}
 		}
 
-- 
2.45.2


