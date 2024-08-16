Return-Path: <io-uring+bounces-2804-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B9B7A9551F9
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 22:44:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3A1EB1F22A4C
	for <lists+io-uring@lfdr.de>; Fri, 16 Aug 2024 20:44:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 606131C37A3;
	Fri, 16 Aug 2024 20:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="giq4LD9p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEEC1C230D
	for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 20:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723841059; cv=none; b=MQZxWxBL8bLcN8j2V7ZM/TntvtQYRYww05WcQli0FarbbqRMl9IqVC9bVYXFVrAx6He4OV2UjJwaZdwi+TAX2CJN/ldyqYWV9Gtilv2EH2cxhbZyHx18G+F5btFNj/xPZSjXZpLS623pvNpyEHVihMjtgG0cKqBj0mXOYUAPab8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723841059; c=relaxed/simple;
	bh=1OZtNl0JDoIJwVXs5EoR0J9akC7TB1Si3RWg55ueBoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g0Y8yXLF4Owobq82/mm8qSkFl2Jx3lmVTIlG4Usp9Vj+0Jtvy1cj5VWguQ9KS4MP81uwRrb3LB32VXAlfURJn6eflImNGvh+aoiN2CPXMYdK3uqSVRYpiTnWBN1Une3HYcvo6/GRP7UNFvih/Is0yAD46iwFFnicoWzwWyX2s0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=giq4LD9p; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-72703dd2b86so212888a12.1
        for <io-uring@vger.kernel.org>; Fri, 16 Aug 2024 13:44:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723841056; x=1724445856; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4PLbe43VndWrCSAbyZINoMHbTMY+BQS7gvEu5PBtTVs=;
        b=giq4LD9pj024JkgViWRj+i+TVFpWFAEPJRyF9GUnTERmzR4LMGLoL5NM7jqTrHB/RS
         1bF9+qWAGg/71bMoWio8kvFkkw1bcm8KnMtwohuJzQHwa/mqw7PW/VDYV6YUZAdGHDCk
         fWiZljtQw8+RC+iFAzZhpHODzOfpVHsE9jlj8pStrgV88GkBEfy5zdahb4RZDVuljSyV
         mSOQFoEN0gvfDFOL4AZZUsOMAks65queR74fKvZaVfPYRCbiURsYdlEDkJp0LVo1TMRo
         CujzCqgL3v1qkCRwZ7eJPXZtDOh5x/j+5RItCZnB0a3NniNIcpp1MYYHP1DObxDPvtvp
         QGUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723841056; x=1724445856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4PLbe43VndWrCSAbyZINoMHbTMY+BQS7gvEu5PBtTVs=;
        b=Kg1q14wm1ufzM5ebruujxmejwGrwUIerYr4W3yPh9K+kqvgwUu40zbIDdQKghazWY0
         Yq15sX7wgwmlfCLwjASycZUnPJpFiQVLEGzjxjvdCUmDaRpJIk4Xe9Cn+avWzYmF/F4x
         TG7pbqLU10VJ7ImzvDDtnzd5caMEwsmtH5Tybh3YelNIzJb69fzZJ8xYCART+XX9BFJw
         RUlO4H17CthP58NS43eQkPzGojkdKQ1+SUVBpyZ9IAQ5NkLmIuNZjn0+e69S1JIHVPU9
         8BolH6l7y6eWdqNe2JjpYwKKJWML9/bSnKTOii8jqmPfHZ7yecJSEXnu50qAslFbpYFN
         RREQ==
X-Gm-Message-State: AOJu0YwiWFMMlnGbjJZZB1d9YZiJoH0fkgFd7DaW2S0+nOrsiUlw3Nb+
	BNp7MDO9w+Q4MW05WnFjDpFAG2hkaxOZxiJ4+F/cobGO/7JVGrNX7EKlPvhl3uN3K7WDFvqc4Qe
	f
X-Google-Smtp-Source: AGHT+IG836ZUkszCjcwwE2JcM+g3tIw4Lgj1BFbs9EfPbXHvv8JISY7Ao1dVVyDx8JMpKR1dwwGdBQ==
X-Received: by 2002:a17:902:f681:b0:1fd:a0b9:2be6 with SMTP id d9443c01a7336-20206081e3emr24300765ad.2.1723841056546;
        Fri, 16 Aug 2024 13:44:16 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-201f038a3d7sm29190995ad.186.2024.08.16.13.44.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Aug 2024 13:44:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: wire up min batch wake timeout
Date: Fri, 16 Aug 2024 14:38:16 -0600
Message-ID: <20240816204302.85938-7-axboe@kernel.dk>
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

Expose min_wait_usec in io_uring_getevents_arg, replacing the pad member
that is currently in there. The value is in usecs, which is explained in
the name as well.

Note that if min_wait_usec and a normal timeout is used in conjunction,
the normal timeout is still relative to the base time. For example, if
min_wait_usec is set to 100 and the normal timeout is 1000, the max
total time waited is still 1000. This also means that if the normal
timeout is shorter than min_wait_usec, then only the min_wait_usec will
take effect.

See previous commit for an explanation of how this works.

IORING_FEAT_MIN_TIMEOUT is added as a feature flag for this, as
applications doing submit_and_wait_timeout() style operations will
generally not see the -EINVAL from the wait side as they return the
number of IOs submitted. Only if no IOs are submitted will the -EINVAL
bubble back up to the application.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h | 3 ++-
 io_uring/io_uring.c           | 9 +++++----
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3a94afa8665e..da0d472d5ec7 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -545,6 +545,7 @@ struct io_uring_params {
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
 #define IORING_FEAT_RECVSEND_BUNDLE	(1U << 14)
 #define IORING_FEAT_IOWAIT_TOGGLE	(1U << 15)
+#define IORING_FEAT_MIN_TIMEOUT		(1U << 16)
 
 /*
  * io_uring_register(2) opcodes and arguments
@@ -768,7 +769,7 @@ enum io_uring_register_restriction_op {
 struct io_uring_getevents_arg {
 	__u64	sigmask;
 	__u32	sigmask_sz;
-	__u32	pad;
+	__u32	min_wait_usec;
 	__u64	ts;
 };
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 27d949ff84a3..ecebcea5cbd7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2475,6 +2475,7 @@ struct ext_arg {
 	size_t argsz;
 	struct __kernel_timespec __user *ts;
 	const sigset_t __user *sig;
+	ktime_t min_time;
 };
 
 /*
@@ -2507,7 +2508,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	iowq.cq_min_tail = READ_ONCE(ctx->rings->cq.tail);
 	iowq.cq_tail = READ_ONCE(ctx->rings->cq.head) + min_events;
-	iowq.min_timeout = 0;
+	iowq.min_timeout = ext_arg->min_time;
 	iowq.timeout = KTIME_MAX;
 	iowq.no_iowait = flags & IORING_ENTER_NO_IOWAIT;
 	start_time = io_get_time(ctx);
@@ -3232,8 +3233,7 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp,
 		return -EINVAL;
 	if (copy_from_user(&arg, argp, sizeof(arg)))
 		return -EFAULT;
-	if (arg.pad)
-		return -EINVAL;
+	ext_arg->min_time = arg.min_wait_usec * NSEC_PER_USEC;
 	ext_arg->sig = u64_to_user_ptr(arg.sigmask);
 	ext_arg->argsz = arg.sigmask_sz;
 	ext_arg->ts = u64_to_user_ptr(arg.ts);
@@ -3634,7 +3634,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
 			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
-			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_IOWAIT_TOGGLE;
+			IORING_FEAT_RECVSEND_BUNDLE | IORING_FEAT_IOWAIT_TOGGLE |
+			IORING_FEAT_MIN_TIMEOUT;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
-- 
2.43.0


