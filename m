Return-Path: <io-uring+bounces-8914-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 88CEFB1ED96
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 19:04:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 240F07A8B68
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 17:02:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AD561C2437;
	Fri,  8 Aug 2025 17:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ohd3gjDw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A2CF267F48
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 17:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754672635; cv=none; b=pFRZZB/DpN3CSjOjzRbVAOSib0TLGsLcu3WUyJ3tOZ23N2R6P1ayyqHfcMdr/YMEwc1rtJqemxse6mD/kH0jiZ8rPUqfJUTWyyNGpKaGTA6Q7Lx7utIhRLMymFFJb5AN5eV/gLWOHhT5UqPQcSsL2UpQm7R1Gd4i+vf+h8UR54w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754672635; c=relaxed/simple;
	bh=YXFf5rJE8LJ9YgQqwMI8XciqPw+fJlSKIkGGfMUlbKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kZ663WQA0L/fpAfwKva1zqfy1P5IrAyr1KAvHKlHx2Ii81pbs+KgJ8wQZqHcAEdBzJTt8PpJ3k3KzNPoz6Pi/gL35aTMYcrcbYxjdpWdPQLy0K/gEYC1tDpsonMJZ3C/+OlUADppHJ/URXfnk7A7wdgExfr6yevjUhdtaEGDP3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ohd3gjDw; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-86cdb330b48so140960639f.0
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 10:03:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1754672632; x=1755277432; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9u9nAceIW8B30K14vv6r7iUvWQ+yGx4XlWs7mOAl2Y=;
        b=Ohd3gjDwLhlhrcrcaqcGf4dACIS+4C+Qq0S1GoRDdidJOXhuxhMoJeTLSRTG+mo9hp
         Q124Td5PCpHVxqywgQ3eD1eX3gYUg+Tqe6ddT3XVPTjsrDz8pgqDu6kYSJu0Mu9tKxLa
         l6cib19mGFQfbLuKYGlN4TJ8kawM1SH02uXStJc22XbBRgi3oMfoVABc2naLC+dfG+yR
         yPYXiNLnc/p365XUWbgPH/JJYBArG0xQKAWx37hdyO+42IUinovfsDrQfaoT2k9Q5yLz
         WnIb7ENpYbcq70GW8J5kfpAKuBEoYg2uVQV5sLyQX8rFqx3swkCw07tDL01CXPf8eJ0N
         3aOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754672632; x=1755277432;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9u9nAceIW8B30K14vv6r7iUvWQ+yGx4XlWs7mOAl2Y=;
        b=JhlPl1oyenOkwCYCuV24u5B9cBwsLTPlxB8wNMopkkHbtxOGNpCpJyS59qTtOd63e/
         NJ05ZJme65Ds4vgHz2IzU7D5pJtyiWiValnmBQ9t5OcygdSNadtNJmojGd3c8UvoEFNg
         B9LZMOOyQnKtmVI7L6NhSmF6V8QJKVnTZFv6kIcPoKDMa+nCL58sdII4GyRZlL7gGe3n
         d9aEVE8NuGtjEj1fRQbe3UjEgp4zhNQGRysFjoo9hZSwXJ5resm9vpTEZCrjKouYs6h5
         69UVpr4ltdM9i6J6U9R9/jKcdKpA/lUcC3L+8fEeehdQbAg4XtgHVHGCUXH/muqh/+dh
         /4Vg==
X-Gm-Message-State: AOJu0Yx/hmyUUrV50Flsf0ySOS2DfnQzeYdvZpF62jqUMsk46JGM7s7I
	4XBPj9UvGopbdhk+V70SoyNCbJ5P7CnRlGJ9gqcTpQgXQ6LsuxHhdG6eKCukDPfwx3pdPi5svHD
	WxPFJ
X-Gm-Gg: ASbGnctPnB3B8mdtwDbWCOGyXZnXdPgb5WmlPkLeCGcVRkU3G1hrTVoIvJZEZNsAZpD
	5mc5wxr31ULEkjt4KnoFQhG6xtdr0GrElLlD/0Egip6c8G6epXnc7wzplVeJ2g57rqBaWezSKhA
	vAj12UbdSpMI7yprdWCOwOBM7BCN8cub51OtIbxbW8jwhtXgiSu27lnTjVgpK2FWlwt9V0+1K2m
	9OomDu0GdL5pHTSM0tpCkESJNArMtbMeoxPhc8mnNUWWwKor7vN+lPByErJGkpF31+8ALuOXYX+
	50EpjFixNnnOxu71nDBzVrnMfpEsiuYqkatihMBXxf5BmyWIy6nRbIUN6OjkaddkxAeuGMWwNXM
	WmAoRMA==
X-Google-Smtp-Source: AGHT+IH6pNRpT2H7kwMS0SDrHtmlGyo3tC2RaSzwpFwOLc9soPH71Zsf4VEVQegpSCk4AzkRlTjtqw==
X-Received: by 2002:a05:6602:6b0c:b0:881:85cd:d08e with SMTP id ca18e2360f4ac-883f11b3adbmr735854739f.3.1754672631842;
        Fri, 08 Aug 2025 10:03:51 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-883f198d65esm68203439f.20.2025.08.08.10.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Aug 2025 10:03:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] io_uring: add support for IORING_SETUP_CQE_MIXED
Date: Fri,  8 Aug 2025 11:03:05 -0600
Message-ID: <20250808170339.610340-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250808170339.610340-1-axboe@kernel.dk>
References: <20250808170339.610340-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Normal rings support 16b CQEs for posting completions, while certain
features require the ring to be configured with IORING_SETUP_CQE32, as
they need to convey more information per completion. This, in turn,
makes ALL the CQEs be 32b in size. This is somewhat wasteful and
inefficient, particularly when only certain CQEs need to be of the
bigger variant.

This adds support for setting up a ring with mixed CQE sizes, using
IORING_SETUP_CQE_MIXED. When setup in this mode, CQEs posted to the ring
may be either 16b or 32b in size. If a CQE is 32b in size, then
IORING_CQE_F_32 is set in the CQE flags to indicate that this is the
case. If this flag isn't set, the CQE is the normal 16b variant.

CQEs on these types of mixed rings may also have IORING_CQE_F_SKIP set.
This can happen if the ring is one (small) CQE entry away from wrapping,
and an attempt is made to post a 32b CQE. As CQEs must be contigious in
the CQ ring, a 32b CQE cannot wrap the ring. For this case, a single
dummy CQE is posted with the SKIP flag set. The application should
simply ignore those.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  6 +++
 io_uring/io_uring.c           | 71 +++++++++++++++++++++++++++--------
 io_uring/io_uring.h           | 49 +++++++++++++++++-------
 io_uring/register.c           |  3 +-
 4 files changed, 99 insertions(+), 30 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 69337eb1db33..9396afb01dc8 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -225,6 +225,12 @@ enum io_uring_sqe_flags_bit {
 /* Use hybrid poll in iopoll process */
 #define IORING_SETUP_HYBRID_IOPOLL	(1U << 17)
 
+/*
+ * Allow both 16b and 32b CQEs. If a 32b CQE is posted, it will have
+ * IORING_CQE_F_32 set in cqe->flags.
+ */
+#define IORING_SETUP_CQE_MIXED		(1U << 18)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ef69dd58734..c83e065ed56d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -598,27 +598,27 @@ static void io_cq_unlock_post(struct io_ring_ctx *ctx)
 
 static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 {
-	size_t cqe_size = sizeof(struct io_uring_cqe);
-
 	lockdep_assert_held(&ctx->uring_lock);
 
 	/* don't abort if we're dying, entries must get freed */
 	if (!dying && __io_cqring_events(ctx) == ctx->cq_entries)
 		return;
 
-	if (ctx->flags & IORING_SETUP_CQE32)
-		cqe_size <<= 1;
-
 	io_cq_lock(ctx);
 	while (!list_empty(&ctx->cq_overflow_list)) {
+		size_t cqe_size = sizeof(struct io_uring_cqe);
 		struct io_uring_cqe *cqe;
 		struct io_overflow_cqe *ocqe;
+		bool is_cqe32;
 
 		ocqe = list_first_entry(&ctx->cq_overflow_list,
 					struct io_overflow_cqe, list);
+		is_cqe32 = !!(ocqe->cqe.flags & IORING_CQE_F_32);
+		if (is_cqe32)
+			cqe_size <<= 1;
 
 		if (!dying) {
-			if (!io_get_cqe_overflow(ctx, &cqe, true))
+			if (!io_get_cqe_overflow(ctx, &cqe, true, is_cqe32))
 				break;
 			memcpy(cqe, &ocqe->cqe, cqe_size);
 		}
@@ -730,10 +730,10 @@ static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
 {
 	struct io_overflow_cqe *ocqe;
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
-	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
+	bool is_cqe32 = cqe->flags & IORING_CQE_F_32;
 
 	if (is_cqe32)
-		ocq_size += sizeof(struct io_uring_cqe);
+		ocq_size <<= 1;
 
 	ocqe = kzalloc(ocq_size, gfp | __GFP_ACCOUNT);
 	trace_io_uring_cqe_overflow(ctx, cqe->user_data, cqe->res, cqe->flags, ocqe);
@@ -751,12 +751,29 @@ static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
 	return ocqe;
 }
 
+/*
+ * Fill an empty dummy CQE, in case alignment is off for posting a 32b CQE
+ * because the ring is a single 16b entry away from wrapping.
+ */
+static bool io_fill_nop_cqe(struct io_ring_ctx *ctx, unsigned int off)
+{
+	if (__io_cqring_events(ctx) < ctx->cq_entries) {
+		struct io_uring_cqe *cqe = &ctx->rings->cqes[off];
+
+		memset(cqe, 0, sizeof(*cqe));
+		cqe->flags = IORING_CQE_F_SKIP;
+		ctx->cached_cq_tail++;
+		return true;
+	}
+	return false;
+}
+
 /*
  * writes to the cq entry need to come after reading head; the
  * control dependency is enough as we're using WRITE_ONCE to
  * fill the cq entry
  */
-bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow)
+bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32)
 {
 	struct io_rings *rings = ctx->rings;
 	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
@@ -770,12 +787,22 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow)
 	if (!overflow && (ctx->check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)))
 		return false;
 
+	/*
+	 * Post dummy CQE if a 32b CQE is needed and there's only room for a
+	 * 16b CQE before the ring wraps.
+	 */
+	if (cqe32 && ctx->cq_entries - off == 1) {
+		if (!io_fill_nop_cqe(ctx, off))
+			return false;
+		off = 0;
+	}
+
 	/* userspace may cheat modifying the tail, be safe and do min */
 	queued = min(__io_cqring_events(ctx), ctx->cq_entries);
 	free = ctx->cq_entries - queued;
 	/* we need a contiguous range, limit based on the current array offset */
 	len = min(free, ctx->cq_entries - off);
-	if (!len)
+	if (len < (cqe32 + 1))
 		return false;
 
 	if (ctx->flags & IORING_SETUP_CQE32) {
@@ -793,9 +820,9 @@ static bool io_fill_cqe_aux32(struct io_ring_ctx *ctx,
 {
 	struct io_uring_cqe *cqe;
 
-	if (WARN_ON_ONCE(!(ctx->flags & IORING_SETUP_CQE32)))
+	if (WARN_ON_ONCE(!(ctx->flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED))))
 		return false;
-	if (unlikely(!io_get_cqe(ctx, &cqe)))
+	if (unlikely(!io_get_cqe(ctx, &cqe, true)))
 		return false;
 
 	memcpy(cqe, src_cqe, 2 * sizeof(*cqe));
@@ -806,14 +833,15 @@ static bool io_fill_cqe_aux32(struct io_ring_ctx *ctx,
 static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 			      u32 cflags)
 {
+	bool cqe32 = cflags & IORING_CQE_F_32;
 	struct io_uring_cqe *cqe;
 
-	if (likely(io_get_cqe(ctx, &cqe))) {
+	if (likely(io_get_cqe(ctx, &cqe, cqe32))) {
 		WRITE_ONCE(cqe->user_data, user_data);
 		WRITE_ONCE(cqe->res, res);
 		WRITE_ONCE(cqe->flags, cflags);
 
-		if (ctx->flags & IORING_SETUP_CQE32) {
+		if (cqe32) {
 			WRITE_ONCE(cqe->big_cqe[0], 0);
 			WRITE_ONCE(cqe->big_cqe[1], 0);
 		}
@@ -2735,6 +2763,10 @@ unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 		if (check_shl_overflow(off, 1, &off))
 			return SIZE_MAX;
 	}
+	if (flags & IORING_SETUP_CQE_MIXED) {
+		if (cq_entries < 2)
+			return SIZE_MAX;
+	}
 
 #ifdef CONFIG_SMP
 	off = ALIGN(off, SMP_CACHE_BYTES);
@@ -3658,6 +3690,14 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 	    !(flags & IORING_SETUP_SINGLE_ISSUER))
 		return -EINVAL;
 
+	/*
+	 * Nonsensical to ask for CQE32 and mixed CQE support, it's not
+	 * supported to post 16b CQEs on a ring setup with CQE32.
+	 */
+	if ((flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED)) ==
+	    (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED))
+		return -EINVAL;
+
 	return 0;
 }
 
@@ -3884,7 +3924,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
 			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
-			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOPOLL))
+			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOPOLL |
+			IORING_SETUP_CQE_MIXED))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index abc6de227f74..2e4f7223a767 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -75,7 +75,7 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 			 unsigned int cq_entries, size_t *sq_offset);
 int io_uring_fill_params(unsigned entries, struct io_uring_params *p);
-bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow);
+bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
@@ -169,25 +169,31 @@ static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 
 static inline bool io_get_cqe_overflow(struct io_ring_ctx *ctx,
 					struct io_uring_cqe **ret,
-					bool overflow)
+					bool overflow, bool cqe32)
 {
 	io_lockdep_assert_cq_locked(ctx);
 
-	if (unlikely(ctx->cqe_cached >= ctx->cqe_sentinel)) {
-		if (unlikely(!io_cqe_cache_refill(ctx, overflow)))
+	if (unlikely(ctx->cqe_sentinel - ctx->cqe_cached < (cqe32 + 1))) {
+		if (unlikely(!io_cqe_cache_refill(ctx, overflow, cqe32)))
 			return false;
 	}
 	*ret = ctx->cqe_cached;
 	ctx->cached_cq_tail++;
 	ctx->cqe_cached++;
-	if (ctx->flags & IORING_SETUP_CQE32)
+	if (ctx->flags & IORING_SETUP_CQE32) {
+		ctx->cqe_cached++;
+	} else if (cqe32 && ctx->flags & IORING_SETUP_CQE_MIXED) {
 		ctx->cqe_cached++;
+		ctx->cached_cq_tail++;
+	}
+	WARN_ON_ONCE(ctx->cqe_cached > ctx->cqe_sentinel);
 	return true;
 }
 
-static inline bool io_get_cqe(struct io_ring_ctx *ctx, struct io_uring_cqe **ret)
+static inline bool io_get_cqe(struct io_ring_ctx *ctx, struct io_uring_cqe **ret,
+				bool cqe32)
 {
-	return io_get_cqe_overflow(ctx, ret, false);
+	return io_get_cqe_overflow(ctx, ret, false, cqe32);
 }
 
 static inline bool io_defer_get_uncommited_cqe(struct io_ring_ctx *ctx,
@@ -196,25 +202,24 @@ static inline bool io_defer_get_uncommited_cqe(struct io_ring_ctx *ctx,
 	io_lockdep_assert_cq_locked(ctx);
 
 	ctx->submit_state.cq_flush = true;
-	return io_get_cqe(ctx, cqe_ret);
+	return io_get_cqe(ctx, cqe_ret, false);
 }
 
 static __always_inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
 					    struct io_kiocb *req)
 {
+	bool is_cqe32 = req->cqe.flags & IORING_CQE_F_32;
 	struct io_uring_cqe *cqe;
 
 	/*
-	 * If we can't get a cq entry, userspace overflowed the
-	 * submission (by quite a lot). Increment the overflow count in
-	 * the ring.
+	 * If we can't get a cq entry, userspace overflowed the submission
+	 * (by quite a lot).
 	 */
-	if (unlikely(!io_get_cqe(ctx, &cqe)))
+	if (unlikely(!io_get_cqe(ctx, &cqe, is_cqe32)))
 		return false;
 
-
 	memcpy(cqe, &req->cqe, sizeof(*cqe));
-	if (ctx->flags & IORING_SETUP_CQE32) {
+	if (is_cqe32) {
 		memcpy(cqe->big_cqe, &req->big_cqe, sizeof(*cqe));
 		memset(&req->big_cqe, 0, sizeof(req->big_cqe));
 	}
@@ -239,6 +244,22 @@ static inline void io_req_set_res(struct io_kiocb *req, s32 res, u32 cflags)
 	req->cqe.flags = cflags;
 }
 
+static inline u32 ctx_cqe32_flags(struct io_ring_ctx *ctx)
+{
+	if (ctx->flags & IORING_SETUP_CQE_MIXED)
+		return IORING_CQE_F_32;
+	return 0;
+}
+
+static inline void io_req_set_res32(struct io_kiocb *req, s32 res, u32 cflags,
+				    __u64 extra1, __u64 extra2)
+{
+	req->cqe.res = res;
+	req->cqe.flags = cflags | ctx_cqe32_flags(req->ctx);
+	req->big_cqe.extra1 = extra1;
+	req->big_cqe.extra2 = extra2;
+}
+
 static inline void *io_uring_alloc_async_data(struct io_alloc_cache *cache,
 					      struct io_kiocb *req)
 {
diff --git a/io_uring/register.c b/io_uring/register.c
index a59589249fce..a1a9b2884eae 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -396,7 +396,8 @@ static void io_register_free_rings(struct io_ring_ctx *ctx,
 
 #define RESIZE_FLAGS	(IORING_SETUP_CQSIZE | IORING_SETUP_CLAMP)
 #define COPY_FLAGS	(IORING_SETUP_NO_SQARRAY | IORING_SETUP_SQE128 | \
-			 IORING_SETUP_CQE32 | IORING_SETUP_NO_MMAP)
+			 IORING_SETUP_CQE32 | IORING_SETUP_NO_MMAP | \
+			 IORING_SETUP_CQE_MIXED)
 
 static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 {
-- 
2.50.1


