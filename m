Return-Path: <io-uring+bounces-963-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 834ED87D05C
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:31:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FDCE28289C
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 15:31:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5585F44C7E;
	Fri, 15 Mar 2024 15:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JquzFlcO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 730CE3D96E;
	Fri, 15 Mar 2024 15:31:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516685; cv=none; b=kO9y+SxUBtU3qwWD+7O7l9RRKS9UXa3qBgh7v5DOy2jZIf4xGsnYW9qdaZeRUQcM6tlndjIe8yFZ84mfj2pcEhhJYPoGRJBqL9v8+m6v2i8e9e9G0iIOHoOdnJXpme5/nLbHpmCKBWEd0G9oy4APw7QqMX7S6HOMZ3uFZRHnzU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516685; c=relaxed/simple;
	bh=0b0xANT5rn57TIxscmYXYbG3B66r7OZmchFYYxTy2TU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qqR82c0nCRtnJjtvhDzGIFG4DpopMYwyNpz7MLDggaZu/dSwPBVkNcxt5hUsvr/Lj4zPqMkFxSW/lofD9wbc6ULp6WIXHo1D/er+4vwDT0e9uifyom0990aBWmFe01JvmzOXZNCIbta+vtNb4hYvC7wqR2sityYlW5xk+urbpaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JquzFlcO; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-33ed7ba1a42so78685f8f.2;
        Fri, 15 Mar 2024 08:31:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710516681; x=1711121481; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LyQ7TwSuB2UzAPYUsilzhWfnsZo/NWLW8qWu01BUebQ=;
        b=JquzFlcOVH47iNZRCHCXkptz7OdQRu8n2FsRxryv3o9dhYZVeM284HrcPYEzR72INC
         tJD+0eDRwPGtYa0QVYuBZzoKu95C6O4ajnnF+DcdVecaUS/vAZ1RiZQGyfoYZZvcaTAm
         +ioxjArcgMxR72R/k6SVm98/wLO3tAS3tXfR2XSdE1UtPy7aJLz9K8MO2NkxhBDiABdp
         gcifM08yDtIhGK3QBEnSXzVjOWPV8zFLiJ1IjY5Iq9A0S7ZYYCCH/MJfHMP9VXYCQeNi
         bC4ZpyhdMs7ckJ9p/k/uPQKGaDgoCtz4B/Z1ty2FeP2Qe6Ew4ox8Ib0S6U4PNuSmihhW
         fGGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516681; x=1711121481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LyQ7TwSuB2UzAPYUsilzhWfnsZo/NWLW8qWu01BUebQ=;
        b=h7/jAqBC1XeL5UXYz++SIMWCL6DYcbZmDb7YG7BYruekFObNV7FetW9YZGy0MIK8hX
         Pa26O2kNSvAVcZJprd8iEe/Bo+DJaNtmAo9/cWPuob/TMtWJiiT+4Rqf+1Lfh+qFWkPE
         BNQLiEgyD8J1Q+yFNtNd+3+vS+67vnQXg4moG33afPgeNJFkmJIema9gGyJXAjiHbKgZ
         qQYq0Emve8NgjOkcXKRUYUN/BMJJ58Q+u8eU0Q5OT4XXgMCbLe6fFC7p6jtTQNCNRLth
         XN9EqNbfnh47xdmvtqmUIPmiGBpCZVqIVav4uBUI0o0bjvmbar1nRktWfWwC34MRucG4
         mr9g==
X-Gm-Message-State: AOJu0Yw849ZQmvg9/Nhork24U3WpDV9/Q0AWlxcbwIK9q8GpjnxVtlXx
	LJcBa/QMqVL61pPvH7M4pDSwEFFdwcqi0UeXRmtZpiGMlL6ne29vI8ALCGwn
X-Google-Smtp-Source: AGHT+IGp37IIkAgab01oSdxVqT+IQ8QLTYPVVW227ELd/el7CBClhRd0EA4n5tOjGuXQQYiuE3HthQ==
X-Received: by 2002:adf:e049:0:b0:33e:b73a:4a4b with SMTP id w9-20020adfe049000000b0033eb73a4a4bmr3259734wrh.28.1710516681658;
        Fri, 15 Mar 2024 08:31:21 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6ac3000000b0033dd2c3131fsm3415671wrw.65.2024.03.15.08.31.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 08:31:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 11/11] io_uring: get rid of intermediate aux cqe caches
Date: Fri, 15 Mar 2024 15:30:01 +0000
Message-ID: <0eb3f55722540a11b036d3c90771220eb082d65e.1710514702.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710514702.git.asml.silence@gmail.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
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
index 167a3429a056..023fcf5d52c1 100644
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
2.43.0


