Return-Path: <io-uring+bounces-2666-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8FB3594A9E5
	for <lists+io-uring@lfdr.de>; Wed,  7 Aug 2024 16:18:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 44A97285124
	for <lists+io-uring@lfdr.de>; Wed,  7 Aug 2024 14:18:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0A6D339B1;
	Wed,  7 Aug 2024 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OxWAZr6f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4D46BFD4
	for <io-uring@vger.kernel.org>; Wed,  7 Aug 2024 14:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723040264; cv=none; b=cnm6rKqJecPqKGNuqcD5EKt47WiN8GpUitacpHcDl7vge4C+TBavn2uF1IcGnJv8cy0emA8B987ndIw7Gp0hitZR4p8xqG06h8SLExF3cTNG1rOGiSYPa40x8HA1Y/sgQfkxKENG0pYGOY+RKi4H4lfMhjXirQ4Mbgy7Sy17Ktg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723040264; c=relaxed/simple;
	bh=CofWqGuEpePArAbEME3kTKzrlGGzPO/8E/k2B9aobuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3DYB2cBe4uhowKVVhZ05pM4/E/odrLZadtV6vpV6CtXq9t0aCZHhJZJc2XAlv89JykdtQnf4i8X1T674nMqj7T3crfIWTDYnOD37awNTNp4N7T1QkSdyAwhccqfaXMsVmDBioo/kewoNeFy1lFa2HfNYs5IYrLyas5DxFK/9gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OxWAZr6f; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5a156556fb4so2169133a12.3
        for <io-uring@vger.kernel.org>; Wed, 07 Aug 2024 07:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723040261; x=1723645061; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dvi2VSofIFFrnhxlbK+KYhrQHGkaB2+Ul72FbaXCv+Q=;
        b=OxWAZr6fUKqdMzOHp4YfK1RSvPpqMJ433Hkdt5TBIbcH/E2sqCfq2HLI7fZ99rINSa
         6BpWoRJIsd5xWGobrzNkRYluAzYCavAjcl4ygOocBUG85zbKadDgkfje/nx6/L0G7NS+
         u8wQRPpvbA58Iy6VrFtG4KuG4V39v8u1uGf7DrKpJ+Ij7cuG+LjTb4iFAWEA7HeL3fzY
         DsvlJuWxWY+X3c2vYLHybaa6WIuTP79uvoo0+ELgnoWX6XzXVL2UK4iU8MGYdq90Io0U
         1Hu1ahAG+RkVzyhbPZHLknXLll3IXKZsmzU1HLjglgrLiU1o4C6VZnqRJuRVijLOze7r
         46Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723040261; x=1723645061;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dvi2VSofIFFrnhxlbK+KYhrQHGkaB2+Ul72FbaXCv+Q=;
        b=uIBPo2Zsvol8dexr127Iq8M2yKYHhkWl1NtdpUe/GAe+GKbopQzkhKkz4VdcjaEzfk
         VwUrywj4TacYs9h5FN22H02Fsqub7GGngWBkEyXuKWuAAHSvyS4kPF51w3kxXSZ4ulK3
         5v76kcrI9iW4nnzBQOsNW4KamxAmUOPZmhOzUCjwbK6lo8MKgNX7TTBh8Bj5a5H0XL2j
         5OmI0p6BiKUX7LSYmQxYQ41ZPOYPYnV5mkPYaH6wvRtfeeo4bTRyXaxQ9FsNGjOegCOQ
         UhVp4vzFx5uCgjw/OjHZTgQzXvxV7029EXdUthZQcZtVrDDijv2dr6HtALH0zVRSALUj
         L/7Q==
X-Gm-Message-State: AOJu0YxND39drP9JwKGMIlLdH+Pum87cxgjqTZzKAyv8K8ZM5xzoPN6G
	ZSY3rayf6J+JOC84eiqfEpDNv0WpX6n1nsy7Td5vu2bSMNyaHal3GMDVHw==
X-Google-Smtp-Source: AGHT+IEJPM8Kk4de3cFxvMI8EeqnAh9q43GfLYT7HFAQspVZIqMBqmLmAk4FCgnd5a7uMVTZqpe5QA==
X-Received: by 2002:aa7:d309:0:b0:5bb:9ae0:4a3e with SMTP id 4fb4d7f45d1cf-5bb9ae04b08mr3056101a12.29.1723040260950;
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
Subject: [PATCH v2 4/4] io_uring: user registered clockid for wait timeouts
Date: Wed,  7 Aug 2024 15:18:14 +0100
Message-ID: <98f2bc8a3c36cdf8f0e6a275245e81e903459703.1723039801.git.asml.silence@gmail.com>
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

Add a new registration opcode IORING_REGISTER_CLOCK, which allows the
user to select which clock id it wants to use with CQ waiting timeouts.
It only allows a subset of all posix clocks and currently supports
CLOCK_MONOTONIC and CLOCK_BOOTTIME.

Suggested-by: Lewis Baker <lewissbaker@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  3 +++
 include/uapi/linux/io_uring.h  |  7 +++++++
 io_uring/io_uring.c            |  8 ++++++--
 io_uring/io_uring.h            |  8 ++++++++
 io_uring/napi.c                |  2 +-
 io_uring/register.c            | 31 +++++++++++++++++++++++++++++++
 6 files changed, 56 insertions(+), 3 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3315005df117..4b9ba523978d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -239,6 +239,9 @@ struct io_ring_ctx {
 		struct io_rings		*rings;
 		struct percpu_ref	refs;
 
+		clockid_t		clockid;
+		enum tk_offsets		clock_offset;
+
 		enum task_work_notify_mode	notify_method;
 		unsigned			sq_thread_idle;
 	} ____cacheline_aligned_in_smp;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index afc901502804..48c440edf674 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -596,6 +596,8 @@ enum io_uring_register_op {
 	IORING_REGISTER_NAPI			= 27,
 	IORING_UNREGISTER_NAPI			= 28,
 
+	IORING_REGISTER_CLOCK			= 29,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -676,6 +678,11 @@ struct io_uring_restriction {
 	__u32 resv2[3];
 };
 
+struct io_uring_clock_register {
+	__u32	clockid;
+	__u32	__resv[3];
+};
+
 struct io_uring_buf {
 	__u64	addr;
 	__u32	len;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5282f9887440..20229e72b65c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2377,7 +2377,8 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 	ret = 0;
 	if (iowq->timeout == KTIME_MAX)
 		schedule();
-	else if (!schedule_hrtimeout(&iowq->timeout, HRTIMER_MODE_ABS))
+	else if (!schedule_hrtimeout_range_clock(&iowq->timeout, 0,
+						 HRTIMER_MODE_ABS, ctx->clockid))
 		ret = -ETIME;
 	current->in_iowait = 0;
 	return ret;
@@ -2422,7 +2423,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 
 		iowq.timeout = timespec64_to_ktime(ts);
 		if (!(flags & IORING_ENTER_ABS_TIMER))
-			iowq.timeout = ktime_add(iowq.timeout, ktime_get());
+			iowq.timeout = ktime_add(iowq.timeout, io_get_time(ctx));
 	}
 
 	if (sig) {
@@ -3424,6 +3425,9 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (!ctx)
 		return -ENOMEM;
 
+	ctx->clockid = CLOCK_MONOTONIC;
+	ctx->clock_offset = 0;
+
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    !(ctx->flags & IORING_SETUP_IOPOLL) &&
 	    !(ctx->flags & IORING_SETUP_SQPOLL))
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index c2acf6180845..9935819f12b7 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -437,6 +437,14 @@ static inline bool io_file_can_poll(struct io_kiocb *req)
 	return false;
 }
 
+static inline ktime_t io_get_time(struct io_ring_ctx *ctx)
+{
+	if (ctx->clockid == CLOCK_MONOTONIC)
+		return ktime_get();
+
+	return ktime_get_with_offset(ctx->clock_offset);
+}
+
 enum {
 	IO_CHECK_CQ_OVERFLOW_BIT,
 	IO_CHECK_CQ_DROPPED_BIT,
diff --git a/io_uring/napi.c b/io_uring/napi.c
index d39ae20a3db8..1c3e7562e90b 100644
--- a/io_uring/napi.c
+++ b/io_uring/napi.c
@@ -285,7 +285,7 @@ void __io_napi_busy_loop(struct io_ring_ctx *ctx, struct io_wait_queue *iowq)
 
 	iowq->napi_busy_poll_dt = READ_ONCE(ctx->napi_busy_poll_dt);
 	if (iowq->timeout != KTIME_MAX) {
-		ktime_t dt = ktime_sub(iowq->timeout, ktime_get());
+		ktime_t dt = ktime_sub(iowq->timeout, io_get_time(ctx));
 
 		iowq->napi_busy_poll_dt = min_t(u64, iowq->napi_busy_poll_dt, dt);
 	}
diff --git a/io_uring/register.c b/io_uring/register.c
index e3c20be5a198..57cb85c42526 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -335,6 +335,31 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	return ret;
 }
 
+static int io_register_clock(struct io_ring_ctx *ctx,
+			     struct io_uring_clock_register __user *arg)
+{
+	struct io_uring_clock_register reg;
+
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+	if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)))
+		return -EINVAL;
+
+	switch (reg.clockid) {
+	case CLOCK_MONOTONIC:
+		ctx->clock_offset = 0;
+		break;
+	case CLOCK_BOOTTIME:
+		ctx->clock_offset = TK_OFFS_BOOT;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	ctx->clockid = reg.clockid;
+	return 0;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -511,6 +536,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_unregister_napi(ctx, arg);
 		break;
+	case IORING_REGISTER_CLOCK:
+		ret = -EINVAL;
+		if (!arg || nr_args)
+			break;
+		ret = io_register_clock(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.45.2


