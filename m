Return-Path: <io-uring+bounces-9163-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95026B2FC82
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 16:28:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D565E1D21317
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 14:21:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63B9F284B4F;
	Thu, 21 Aug 2025 14:20:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qVgJmyk9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273C326E158
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 14:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755786011; cv=none; b=ria9Qxa7XVCKk5XnD2kH1WsrTYkTh3pkdlxXUCvwj3wDLFaSJNlttS26WKhUtC2CyicifkRkevSnVHZhbplhqICk+d/Rdhc5onqbbU6skbHY59OQi08L/hqyF6dnUwrPiulkSswq1pKWlhqZ4FHV+rShNv3yq4bpYxeo/rzoiss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755786011; c=relaxed/simple;
	bh=htrGNDWPCEszatfHa+INprrNiCQMwI1oQ5toKCDnwQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xtyl4FKqdrF1vUUEEIOoQhbxxqSwi9W/ur2UJRm+es5Ha4t/HejpHZLRMIdAQSMmQAR7DP95/M3z5WXM0rzCt4ATxvljGj80E4P/3uUbzyp37zbrjNx49L/Vu5n1JDsQQnlBmhRTa8aUBf0JN6EcHlHY2193jQvB9xq5SAxhHy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qVgJmyk9; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-88428cb5dfdso34270639f.1
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 07:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755786008; x=1756390808; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pc3jTdoFAag93oJxF5KgL1ZZGR1FR/ZqfSN4jOySPY8=;
        b=qVgJmyk97boqOSi2e7wutqhZ9uF9wOmUjhkqPe5sU5FZ+4sqIp1LM6ULG8yCNjJIoV
         PDG7S6KUcbfYAlR8XMQ0HZPKk+T+u9zHN/01JqLp/qanSiqhaLfbKWRXht5E/5bRriyk
         Oj5ORkk3ZFyw5OPp167a80H4bfdGa6b8ouQSazPcmwAa8z5ws3ryYe2pCvjJXTnXTg1M
         cOXboxmrJoQEYZhMmSSZUCMhuIZ9WjlCuvTTTcmYFESZqd4896EJ9orogu2Xeprqu2+H
         KAd7c1f1Xuo1DO1dpDruTNqFp0KiqbkqN5xzarUbYc9vfcD4TVtlzt5Lu6RMtHoLDCdf
         eYKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755786008; x=1756390808;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pc3jTdoFAag93oJxF5KgL1ZZGR1FR/ZqfSN4jOySPY8=;
        b=oG2QdoAtGQ6EHShsUUExzCCTUR4/7rW/l4ICpWXSIl3YymJ6G+/04UqyTbeGY6KjSv
         0vWcMMEFMWwHDrrBwEcwmyizs9o6RMpKQTR6LBnsVtNJFZ3E03Rbr2uBFR8G90ghrHgC
         jZI0DV2FCIv0lkntWRcjNsrup2Sg6P0FngbCrbKsNNXhRitLYz+EqAWzyk4W2uAXuZPF
         zkaRaNz514HyDQWS1KX5V04AvYV4ViRoPM072v90S1s+BJKQCVtEyTjzI0jAyhuDKO4B
         p1fCSNV2Xh4B/BJoBMkbcgTrHY7UF3d1LS1QQgHbCTXaRngV3UwoOkTph5/FzBDNgh+P
         pnaw==
X-Gm-Message-State: AOJu0YzOpr+5Twoseek+8ce/9lWJN2FGETPv/iRYuX5mSaNFldLWKPQd
	qGQFSiQFqkZobU+mq7jyqm5vQ2hz1WgL60Zo7gmgdRKCLmhyBuKLzAm2KTYuSDv6tUeXONbTyi7
	YVy9C
X-Gm-Gg: ASbGncuIUbnsELHtWus1w9EgPcLolthVd5URCrhjhZuXw3BEUcTzAIXXDa5VkCPN0Fk
	HMG2Nc5c5FTueAyAUMP3yUbzWRtkPP2UcsCirlKXZoG/eqxzQyOeoLrjY8p8Gjg0I57FTjYeHkL
	KEjpF/pLiq05Zz4qjjrVs/s8zRQQHjQubpgC8pffTGd4DhN2J5K4IGq5Dcd89PXRKPi0BHNiVHD
	7uHMN25wmqT6cdE7ldHoGFzonHksWqrqvEF0sVZVN66XsP9eKDwfGbq7E3duc0SSOX/6zuxvzOF
	mLagFR+s0vdJod4tsA8QFcPhUsFwovoRluwgBuGNeKk6qfh2J1knTCV1zEjXu9Pq7H1ZjPrdUGx
	Vd1nrYA==
X-Google-Smtp-Source: AGHT+IE256oDgT279umrNwZAAVVlCSlI5SL+nyt7VpWBIW7JHyvmk0ykcI42Iwx8eXIKO4ufEaa+iw==
X-Received: by 2002:a05:6e02:3e91:b0:3e2:77d9:f8fc with SMTP id e9e14a558f8ab-3e6e2495e88mr38746145ab.10.1755786007531;
        Thu, 21 Aug 2025 07:20:07 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e58c1basm73196595ab.5.2025.08.21.07.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Aug 2025 07:20:06 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] io_uring: add support for IORING_SETUP_CQE_MIXED
Date: Thu, 21 Aug 2025 08:18:05 -0600
Message-ID: <20250821141957.680570-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821141957.680570-1-axboe@kernel.dk>
References: <20250821141957.680570-1-axboe@kernel.dk>
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
 io_uring/io_uring.c           | 78 ++++++++++++++++++++++++++++-------
 io_uring/io_uring.h           | 49 +++++++++++++++-------
 io_uring/register.c           |  3 +-
 4 files changed, 105 insertions(+), 31 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7af8d10b3aba..5135e1be0390 100644
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
index 6247d582fb40..58f7c2403a15 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -620,27 +620,29 @@ static void io_cq_unlock_post(struct io_ring_ctx *ctx)
 
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
+		bool is_cqe32 = false;
 
 		ocqe = list_first_entry(&ctx->cq_overflow_list,
 					struct io_overflow_cqe, list);
+		if (ocqe->cqe.flags & IORING_CQE_F_32 ||
+		    ctx->flags & IORING_SETUP_CQE32) {
+			is_cqe32 = true;
+			cqe_size <<= 1;
+		}
 
 		if (!dying) {
-			if (!io_get_cqe_overflow(ctx, &cqe, true))
+			if (!io_get_cqe_overflow(ctx, &cqe, true, is_cqe32))
 				break;
 			memcpy(cqe, &ocqe->cqe, cqe_size);
 		}
@@ -752,10 +754,12 @@ static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
 {
 	struct io_overflow_cqe *ocqe;
 	size_t ocq_size = sizeof(struct io_overflow_cqe);
-	bool is_cqe32 = (ctx->flags & IORING_SETUP_CQE32);
+	bool is_cqe32 = false;
 
-	if (is_cqe32)
-		ocq_size += sizeof(struct io_uring_cqe);
+	if (cqe->flags & IORING_CQE_F_32 || ctx->flags & IORING_SETUP_CQE32) {
+		is_cqe32 = true;
+		ocq_size <<= 1;
+	}
 
 	ocqe = kzalloc(ocq_size, gfp | __GFP_ACCOUNT);
 	trace_io_uring_cqe_overflow(ctx, cqe->user_data, cqe->res, cqe->flags, ocqe);
@@ -773,12 +777,30 @@ static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
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
+		cqe->user_data = 0;
+		cqe->res = 0;
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
@@ -792,12 +814,22 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow)
 	if (!overflow && (ctx->check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)))
 		return false;
 
+	/*
+	 * Post dummy CQE if a 32b CQE is needed and there's only room for a
+	 * 16b CQE before the ring wraps.
+	 */
+	if (cqe32 && off + 1 == ctx->cq_entries) {
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
@@ -815,9 +847,9 @@ static bool io_fill_cqe_aux32(struct io_ring_ctx *ctx,
 {
 	struct io_uring_cqe *cqe;
 
-	if (WARN_ON_ONCE(!(ctx->flags & IORING_SETUP_CQE32)))
+	if (WARN_ON_ONCE(!(ctx->flags & (IORING_SETUP_CQE32|IORING_SETUP_CQE_MIXED))))
 		return false;
-	if (unlikely(!io_get_cqe(ctx, &cqe)))
+	if (unlikely(!io_get_cqe(ctx, &cqe, true)))
 		return false;
 
 	memcpy(cqe, src_cqe, 2 * sizeof(*cqe));
@@ -828,14 +860,15 @@ static bool io_fill_cqe_aux32(struct io_ring_ctx *ctx,
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
@@ -2755,6 +2788,10 @@ unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 		if (check_shl_overflow(off, 1, &off))
 			return SIZE_MAX;
 	}
+	if (flags & IORING_SETUP_CQE_MIXED) {
+		if (cq_entries < 2)
+			return SIZE_MAX;
+	}
 
 #ifdef CONFIG_SMP
 	off = ALIGN(off, SMP_CACHE_BYTES);
@@ -3679,6 +3716,14 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
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
 
@@ -3905,7 +3950,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
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


