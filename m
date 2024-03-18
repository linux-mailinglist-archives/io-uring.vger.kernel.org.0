Return-Path: <io-uring+bounces-1124-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A0B787F2DB
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 23:03:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6A9EE1C21149
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 22:03:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13D995A0F4;
	Mon, 18 Mar 2024 22:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PWDpkAFZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327D759B55;
	Mon, 18 Mar 2024 22:02:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710799347; cv=none; b=RCL+H/zAZqyi1iIvn3U89q/V73LPJIloHbHGRPPNovdNCqg/KrN3XbV9LiAZv0dWRJ3btDG5M2NkmFV7kVyBGjwj2opUlmxQGyAachDGU7i4/PkGI8s+PFUwgJdItR0gQ+en8q+gRyawjLMDj/g+b5AnR5IcXDWa2DO1pDyAg6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710799347; c=relaxed/simple;
	bh=6DyMkqr75yfWeDIM3662oU67xNgT52unN6qI7wySI0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sslbehndoyfQIjToI+GWBlaCjDeiYn20mLDHGQihPch1Z8f4KUSzi+ptjmlLuIv1LLqCR11JyinGaGzSU1JJrYIEGAJbj+/1xERCwgBVF4HkrOuLU7SzVcO0NjwgAaLO9Je7XZMi+JVFgvNeAdXPtjFbIa9mVmrkPVvKeHnhj20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PWDpkAFZ; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-414645c349dso172205e9.1;
        Mon, 18 Mar 2024 15:02:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710799343; x=1711404143; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jSNiymRZGIzeU7c1VJWT/0qmrS71IrYaJn9rdaLg9SE=;
        b=PWDpkAFZkrV5+89jlUe2OO3wpbpVGJcS0zwJbbPh07msqQyxVym6tTauQGnxE4eor8
         1ZQozeWv00aqSQhxahlB2EVoq2voICcM27xFyZhobHUCWu3bszZjAIG3AgeKp/nQXDMC
         kCsl7JZaDoIpbadGA1Dsq1C+xLeIw+y/mxz+0Bzy4o6qBYnlUCjte58AUbLh7T50JXz2
         Jb21XZMbywZUkeaknAUX/PXqaLRcp7djmg9fS3jbu601awkUUAP/3leTUkzLVBxT6pDy
         8RV8sW7txQXAOsrh42S/3b/QCO91K0CGOamL/GnlLvaVYdfgRGYmMNo23uWJL43RWVb8
         JEQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710799343; x=1711404143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jSNiymRZGIzeU7c1VJWT/0qmrS71IrYaJn9rdaLg9SE=;
        b=KiWn9JRV0L1xlMOtT9TJky2dxKNyrW9OxSe6F8vTAUYB7s+YqypL6ibWgt1ka6kbpb
         KaEv2KvCEFbF6FVuj5qYrRaf6rSP5XR02IfZ8jndq57eIUnAJzF5+fc2VFlMV9VO8R+L
         hwduEIVMgb+LvJ/+DhPSSnD6p+GRcmZ8qL76c3ti1EiWY6VORnmzlrCHicgj+hNGDzlR
         1iDvj7qb8hb6wnhHBsfmThlYh4PfhSCEh7qQdlvnVSD6ouHf66Vk2NRDRRFYsQx/ZI0j
         iPHG3AVDiS2WLN67LAyWpVn9+kb+MyVaQLgIVJEZ+N7nJcOsACXvFlckPtuVpTU20WBt
         NaGg==
X-Gm-Message-State: AOJu0YxDbkA+8lOIo5g3UpYjxYB2gikQ0sQKCLHdpS5Dcw0CQAhtfp6h
	FsLlI8KSCwNul+OAlO2WioCb/4C/PUb+bX3TqNNgaor2yaWzQnJqaJoA4Gv2
X-Google-Smtp-Source: AGHT+IGzyT+9CzTPfMvaQYGC94NAByYBy4IWyhF8w6H1tBlBz/NHLbPzKMrEoZTJqtGZ9317QQNzwg==
X-Received: by 2002:adf:c98f:0:b0:33e:48dd:2927 with SMTP id f15-20020adfc98f000000b0033e48dd2927mr811748wrh.18.1710799342833;
        Mon, 18 Mar 2024 15:02:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id bj25-20020a0560001e1900b0033e68338fbasm2771038wrb.81.2024.03.18.15.02.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Mar 2024 15:02:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v3 10/13] io_uring: get rid of intermediate aux cqe caches
Date: Mon, 18 Mar 2024 22:00:32 +0000
Message-ID: <b1d05a81fd27aaa2a07f9860af13059e7ad7a890.1710799188.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710799188.git.asml.silence@gmail.com>
References: <cover.1710799188.git.asml.silence@gmail.com>
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
 io_uring/io_uring.c            | 62 +++++++---------------------------
 io_uring/io_uring.h            |  2 +-
 3 files changed, 15 insertions(+), 52 deletions(-)

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
index 9a4cc46582b2..f5e2b5bef10f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -630,6 +630,12 @@ static inline void __io_cq_lock(struct io_ring_ctx *ctx)
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
@@ -882,31 +888,6 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
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
@@ -927,31 +908,16 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
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
@@ -1545,9 +1511,6 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	struct io_wq_work_node *node;
 
 	__io_cq_lock(ctx);
-	/* must come first to preserve CQE ordering in failure cases */
-	if (state->cqes_count)
-		__io_flush_post_cqes(ctx);
 	__wq_list_for_each(node, &state->compl_reqs) {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
@@ -1569,6 +1532,7 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		io_free_batch_list(ctx, state->compl_reqs.first);
 		INIT_WQ_LIST(&state->compl_reqs);
 	}
+	ctx->submit_state.cq_flush = false;
 }
 
 static unsigned io_cqring_events(struct io_ring_ctx *ctx)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 460290e1bdec..5119265a11c2 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -156,7 +156,7 @@ static inline void io_req_task_work_add(struct io_kiocb *req)
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs) ||
-	    ctx->submit_state.cqes_count)
+	    ctx->submit_state.cq_flush)
 		__io_submit_flush_completions(ctx);
 }
 
-- 
2.44.0


