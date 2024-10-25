Return-Path: <io-uring+bounces-4035-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B0DE9B0541
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 16:14:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A24B8B21B4E
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 14:14:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 768C31632F8;
	Fri, 25 Oct 2024 14:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="No8vlC3k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17A814204D
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729865650; cv=none; b=nT3qQ8XMRHt+4bnzu2ZJ4Qc9vQTCawuSrF+b6rLRZLfjpWRpxy2iS69QGzSdOubJ13iif5av05IkdBvNPJAJzZcqW0/Toeka3xBYv7dUoq9kQHt+//iJI06J8SfIeundGviJpA8MI4tjEvuGKlIMgXpwG66wO4n/B4XW0IF+mv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729865650; c=relaxed/simple;
	bh=my0fm8LbHFc9gjVpgCS6YSeHPVh3y9Nz69IniuB/M5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZOin9CpFRNpvFuuQfVMzHq2rSky4jgjlxUXi8NybgpaR9knRX+cXHzex0WtEzopn1oOe8AOebdNu2a05W84u3M7SB3qJfQ4i8IZb9L8KKZ2mz6n/mDZ6NPQUXLkRrhOeTJ/yU1oXfbuiwc2LUbiXyq9xWjY/wSK4xEcNQ5g6jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=No8vlC3k; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-83aba237c03so78711939f.3
        for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 07:14:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729865646; x=1730470446; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ld0ONGuVg0T6cvZPhvY8xhX+HTZGFZmfqIprNzjRZvQ=;
        b=No8vlC3kCMPdOZDLT8diY+dm/ImF5wA21ihDUVWlZFJyj+cV5iFtu/Oz4/vILYcWo3
         Y2MC9AGs8e3I+djZ4utQay2af9gwRf8UTKDn9i7dKf2zc+OmX1dArStBzw95vf/EnyoD
         hhlLcdHGDLneFIThBbulja+Hw7KhuOzv7siB2CupyYXs8jXW/803gYEgdYO0gFQok9kG
         mQIrckjVdXC8v/jaaIhoqs9t7HDG7ryQSQUAdGWMPPtgpnJPs0o588a++xADViw8jJVs
         9XNlw8IeMuc92lmkm1S9rRiUBo698HVa2l2H7PTvM2QYqA7vS5s1gCTnJAyGkHO+yhbp
         yaYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729865646; x=1730470446;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ld0ONGuVg0T6cvZPhvY8xhX+HTZGFZmfqIprNzjRZvQ=;
        b=Is8a7QxpsdqjtGUGDoPV/YdbDWbyBlUdH/grDuHlLz+kSKlxtRykYeAh6H+OT9JYcS
         AKNNEX039fyV8ef4uF9wpDY5QMGNQlydbIa5TF9Z3vEjbtCv89GyyNK0eQrbMq+DANsq
         4lgdfPWOLrCAXsipX4JWvkTKJ0Op8+kzobo8ApFJyYmt52qnJ6Aj2si/hP2ra9Fw2IgA
         KGcW0W2bd1plzfpSb6tVTkqxBJki3jFGiAOhB4JUGEn/GT42QviMQSckLLN9nMsg4lL2
         bG+gh6nXNnk0pVOWTjZG1+NYC1/JTA5rF+JjG6A0c5K/0uE0j++uH0agz4HM+xsQ827s
         cRjQ==
X-Gm-Message-State: AOJu0YxRtcaRl0DaY2MQSJ5Q+m4V6FeACJ6I9LrjR7VzIZeN55IM7aZi
	FVJAgGKpHXpYzM/ftgIqtyHV4S7LEP9gfFQ4l3m9Ox6bXFMw/cX19fnR9/3P9GpecwNhfEblsDH
	E
X-Google-Smtp-Source: AGHT+IH572IyFTFpLI+WkmMY1BYM04d5htu84+m7WjIf1e402ShzCXqc38blueWGFzQqDSI/diLE1g==
X-Received: by 2002:a05:6602:640f:b0:83a:b901:3150 with SMTP id ca18e2360f4ac-83af6199c33mr1138513239f.8.1729865646435;
        Fri, 25 Oct 2024 07:14:06 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb673sm277292173.16.2024.10.25.07.14.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 07:14:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: switch struct ext_arg from __kernel_timespec to timespec64
Date: Fri, 25 Oct 2024 08:12:58 -0600
Message-ID: <20241025141403.169518-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241025141403.169518-1-axboe@kernel.dk>
References: <20241025141403.169518-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This avoids intermediate storage for turning a __kernel_timespec
user pointer into an on-stack struct timespec64, only then to turn it
into a ktime_t.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 140cd47fbdb3..8f0e0749a581 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2495,9 +2495,10 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 
 struct ext_arg {
 	size_t argsz;
-	struct __kernel_timespec __user *ts;
+	struct timespec64 ts;
 	const sigset_t __user *sig;
 	ktime_t min_time;
+	bool ts_set;
 };
 
 /*
@@ -2535,13 +2536,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	iowq.timeout = KTIME_MAX;
 	start_time = io_get_time(ctx);
 
-	if (ext_arg->ts) {
-		struct timespec64 ts;
-
-		if (get_timespec64(&ts, ext_arg->ts))
-			return -EFAULT;
-
-		iowq.timeout = timespec64_to_ktime(ts);
+	if (ext_arg->ts_set) {
+		iowq.timeout = timespec64_to_ktime(ext_arg->ts);
 		if (!(flags & IORING_ENTER_ABS_TIMER))
 			iowq.timeout = ktime_add(iowq.timeout, start_time);
 	}
@@ -3252,7 +3248,6 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 	 */
 	if (!(flags & IORING_ENTER_EXT_ARG)) {
 		ext_arg->sig = (const sigset_t __user *) argp;
-		ext_arg->ts = NULL;
 		return 0;
 	}
 
@@ -3267,7 +3262,11 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 	ext_arg->min_time = arg.min_wait_usec * NSEC_PER_USEC;
 	ext_arg->sig = u64_to_user_ptr(arg.sigmask);
 	ext_arg->argsz = arg.sigmask_sz;
-	ext_arg->ts = u64_to_user_ptr(arg.ts);
+	if (arg.ts) {
+		if (get_timespec64(&ext_arg->ts, u64_to_user_ptr(arg.ts)))
+			return -EFAULT;
+		ext_arg->ts_set = true;
+	}
 	return 0;
 }
 
-- 
2.45.2


