Return-Path: <io-uring+bounces-1073-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1F0E687E15C
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:44:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F1371C21215
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9581222069;
	Mon, 18 Mar 2024 00:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mNEr+XtC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B13D520DE8;
	Mon, 18 Mar 2024 00:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722634; cv=none; b=Lo3VR9k6/hNfe+56ZKH1T8uLF5APAb6FXSS6nAaN1hpWCSoQ39IQ3egVTURRtwu2eguu1+8O7+PeIm13iB+BqVwrz+yeM2LtKx7e2xjblxZa3inNUODhsRUymKoQF03gLiLSxcwTeMRIL2DL4NEJmfFU6n8nwKaZNXgE55GgHIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722634; c=relaxed/simple;
	bh=x2/cLve01Gl9KonIriyqaOu836GCLMtAir5I+UFsNBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/rulofAz4zc0eM/O79y4HgNHAgW/0KdDzAE4JIhjTSAWZjSu+8sryhb411/PzVxiHgKLTwZSduNVcaT3ClBZM3L9m9tpObmzbLihympmHEh6LOky58EqSQazuRfADb6YYji5MbVC17ApHOxsvW6s6mLDAOdeCXESqU4x9OfEG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mNEr+XtC; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-568a9c331a3so3279012a12.0;
        Sun, 17 Mar 2024 17:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722631; x=1711327431; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ENeNI8erwyYqlcnu32QiKd1Gq82426YelFfnxEPhMrM=;
        b=mNEr+XtCbaVpe9AjQn1sy8ysI31xFZLuhUg1op5/gH+dlHhUH2RCaHlmjmlYrFZWlz
         dkkr4dBahP1JQ528TYdax1O9LntUJ089NioyzvUW8+23wFPlo/IlSghRHDnRbXDuAQG4
         KISyoH9GPF8CgEXalFz/9YhtFwLZ8cHT3i+ghFoCR7snlEiPovWA4Em25RiHsi/684YS
         PcVvlRutzbhScCDC/b2sVamXdl2y0jSvd1SETHObN29ZehdLPwvHVVnZbdZ+yszOXyKe
         FK5AlrcbVVNudaZxjELLpPMY1AhfqeEXhU2b1RIxOn7ccdtRjwlUH2/5Haf7zl+1Int2
         y7mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722631; x=1711327431;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ENeNI8erwyYqlcnu32QiKd1Gq82426YelFfnxEPhMrM=;
        b=k8d0b0SrZh/LZGGo/UbKSwXcCGKr0wYrbIb+1I1qJG0AYMqQEuoi5P8TE0OsXb/jQQ
         TFrJGSQMl7I4QR100IT7IwUbLKynDDpI/opmFnxALxpuMaep86Ov4kdT70zppvKSRCDk
         m7rcdCZtVVOw7u8k4cACdo36U2CyAmDbIY61V5HPn+wGPquo4rvgk858ZVLenJEbU1Ei
         zEO0pjcotPDWHcpZr5N8qQwg+WlfTpNRU/f/mBVBoq4uejCDTQUGMhuFK/88R1iLP5H2
         KLPm4LQ15OZxgUZK8CE/f1ABcXeq4lMID0HsaaVU9A8KPvYaa/WAPw0Hy1Bk57QljW/k
         rG1w==
X-Gm-Message-State: AOJu0Yz4yH5Yh6CjU4/3Ultze69b4SOsF9DBDG9CpmcyU9Gy2Tnskbw+
	+bS87uy0oslyo9jPVK5DOfkjH+Zr/14qwRT1XJxMZdhnxhlpJ07f26BuvBvH
X-Google-Smtp-Source: AGHT+IFifW6UGgAX+3YlBzNel2SfEM9hqh6EhYll2yzJzkFWJGRgB72veFvMsHA/6T1lOATLjZsZeQ==
X-Received: by 2002:a05:6402:3648:b0:568:1b94:fb88 with SMTP id em8-20020a056402364800b005681b94fb88mr8843363edb.23.1710722631021;
        Sun, 17 Mar 2024 17:43:51 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:50 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 11/14] io_uring: get rid of intermediate aux cqe caches
Date: Mon, 18 Mar 2024 00:41:56 +0000
Message-ID: <a23c620eaf39d5f303e5b1f3f1fa37693382621e.1710720150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710720150.git.asml.silence@gmail.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_post_aux_cqe(), which is used for multishot requests, delays
completions by putting CQEs into a temporary array for the purpose
completion lock/flush batching.

DEFER_TASKRUN doesn't need any locking, so for it we can put completions
directly into the CQ and defer post completion handling with a flag.
That leaves !DEFER_TASKRUN, which is not that interesting / hot for
multishot requests, so have conditional locking with deferred flush
for them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/0eb3f55722540a11b036d3c90771220eb082d65e.1710514702.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  3 +-
 io_uring/io_uring.c            | 64 ++++++++--------------------------
 2 files changed, 15 insertions(+), 52 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 5a2afbc93887..ea7e5488b3be 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -205,6 +205,7 @@ struct io_submit_state {
 
 	bool			plug_started;
 	bool			need_plug;
+	bool			cq_flush;
 	unsigned short		submit_nr;
 	unsigned int		cqes_count;
 	struct blk_plug		plug;
@@ -342,8 +343,6 @@ struct io_ring_ctx {
 		unsigned		cq_last_tm_flush;
 	} ____cacheline_aligned_in_smp;
 
-	struct io_uring_cqe	completion_cqes[16];
-
 	spinlock_t		completion_lock;
 
 	/* IRQ completion list, under ->completion_lock */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 30542dda1473..8c485bcb5cb7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -176,7 +176,7 @@ static struct ctl_table kernel_io_uring_disabled_table[] = {
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs) ||
-	    ctx->submit_state.cqes_count)
+	    ctx->submit_state.cq_flush)
 		__io_submit_flush_completions(ctx);
 }
 
@@ -636,6 +636,12 @@ static inline void __io_cq_lock(struct io_ring_ctx *ctx)
 		spin_lock(&ctx->completion_lock);
 }
 
+static inline void __io_cq_unlock(struct io_ring_ctx *ctx)
+{
+	if (!ctx->lockless_cq)
+		spin_unlock(&ctx->completion_lock);
+}
+
 static inline void io_cq_lock(struct io_ring_ctx *ctx)
 	__acquires(ctx->completion_lock)
 {
@@ -888,31 +894,6 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	return false;
 }
 
-static void __io_flush_post_cqes(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
-{
-	struct io_submit_state *state = &ctx->submit_state;
-	unsigned int i;
-
-	lockdep_assert_held(&ctx->uring_lock);
-	for (i = 0; i < state->cqes_count; i++) {
-		struct io_uring_cqe *cqe = &ctx->completion_cqes[i];
-
-		if (!io_fill_cqe_aux(ctx, cqe->user_data, cqe->res, cqe->flags)) {
-			if (ctx->lockless_cq) {
-				spin_lock(&ctx->completion_lock);
-				io_cqring_event_overflow(ctx, cqe->user_data,
-							cqe->res, cqe->flags, 0, 0);
-				spin_unlock(&ctx->completion_lock);
-			} else {
-				io_cqring_event_overflow(ctx, cqe->user_data,
-							cqe->res, cqe->flags, 0, 0);
-			}
-		}
-	}
-	state->cqes_count = 0;
-}
-
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
 	bool filled;
@@ -933,31 +914,16 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	u64 user_data = req->cqe.user_data;
-	struct io_uring_cqe *cqe;
+	bool posted;
 
 	lockdep_assert(!io_wq_current_is_worker());
 	lockdep_assert_held(&ctx->uring_lock);
 
-	if (ctx->submit_state.cqes_count == ARRAY_SIZE(ctx->completion_cqes)) {
-		__io_cq_lock(ctx);
-		__io_flush_post_cqes(ctx);
-		/* no need to flush - flush is deferred */
-		__io_cq_unlock_post(ctx);
-	}
-
-	/* For defered completions this is not as strict as it is otherwise,
-	 * however it's main job is to prevent unbounded posted completions,
-	 * and in that it works just as well.
-	 */
-	if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq))
-		return false;
-
-	cqe = &ctx->completion_cqes[ctx->submit_state.cqes_count++];
-	cqe->user_data = user_data;
-	cqe->res = res;
-	cqe->flags = cflags;
-	return true;
+	__io_cq_lock(ctx);
+	posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
+	ctx->submit_state.cq_flush = true;
+	__io_cq_unlock_post(ctx);
+	return posted;
 }
 
 static void __io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
@@ -1551,9 +1517,6 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	struct io_wq_work_node *node;
 
 	__io_cq_lock(ctx);
-	/* must come first to preserve CQE ordering in failure cases */
-	if (state->cqes_count)
-		__io_flush_post_cqes(ctx);
 	__wq_list_for_each(node, &state->compl_reqs) {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
@@ -1575,6 +1538,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		io_free_batch_list(ctx, state->compl_reqs.first);
 		INIT_WQ_LIST(&state->compl_reqs);
 	}
+	ctx->submit_state.cq_flush = false;
 }
 
 static unsigned io_cqring_events(struct io_ring_ctx *ctx)
-- 
2.44.0


