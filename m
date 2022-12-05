Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFD86421AD
	for <lists+io-uring@lfdr.de>; Mon,  5 Dec 2022 03:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiLECpr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Dec 2022 21:45:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbiLECpp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Dec 2022 21:45:45 -0500
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8035510077
        for <io-uring@vger.kernel.org>; Sun,  4 Dec 2022 18:45:44 -0800 (PST)
Received: by mail-wm1-x334.google.com with SMTP id p13-20020a05600c468d00b003cf8859ed1bso8964763wmo.1
        for <io-uring@vger.kernel.org>; Sun, 04 Dec 2022 18:45:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3Yv9W3MRI4b+o6DpSQxY7QbWQXPCf1pUEqejWq6FCA8=;
        b=MmLd64M0amzzpl35D4YprfTAXwtXsY7BTh4bCsmAHD2PTQ3BSBE/SvZRQpO7j5l+s5
         wZSMEHuSkUCLegn1tBrCH5DkpP3i3qkctjRqbx/uHIkIER3Lr2AI5+f3W8O5+pCNtdG1
         oalGg2tZ89tv/UvmNTBOuW/l0j7LcDyrchAcv5FqFb5D9e3xRjT1NRTL+zkISQfEJOSc
         7U1mYDD3sgf6nKF6wyQyIJkUUJj9YjXCCXO+sbHkEjGbZmghPJES2XF5g+g8pWV0S9vm
         YKLfuLbXrTdzLfWH+ezizseAZqG7IZtK7ecvhNaaXVV/LK01Pm0HAZTSK9yJXrYpuW2g
         TVwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3Yv9W3MRI4b+o6DpSQxY7QbWQXPCf1pUEqejWq6FCA8=;
        b=NU3QwLXOFEzK2HAUrtFNhDWmkOXLYB8E2XPfJPoHoUsKP2YEosCPR7wH/8vR+s0DES
         Zlr5AUyIQgTeSDqQZO5ZLtRtCKj/5a4SSqRNb17Rv1cUZNpEfcXfD8Gd0xJ9G0YGKYCP
         4qyZa+De/Uwnm3aseQ6LFvzBwxur9v7j3j9FKFpnPN6XbcnIMLXcyssUGhr5wlGUUk8Q
         poBSH8lf2OfXEFVKM3nMqZ9Xt5zusCOgNcwnhGtQ8UHzN9MdR29cNqL4zooTP96DKUvF
         EeNuFxSNWKISXICXPJ35WSluydIulSA32wHwbXpMtOJK1MgpPz7G7Mgufm38XnpUGXeL
         Yw2g==
X-Gm-Message-State: ANoB5pnqewZpYOyeqp4L2hJZsIHcl2Btv68ILK6IVJxJqF65V0BIalLR
        xR4SgU0eL9/jKDzx62L6XQJrfPs+fVY=
X-Google-Smtp-Source: AA0mqf4E9btS7fyFBWIAt1E3ZEYJOM6PtzvhQi8Xl6eQ7bK/gs1FVrUJr4QP65p+U1051wfpiwwuvg==
X-Received: by 2002:a05:600c:4a99:b0:3cf:91e5:3d69 with SMTP id b25-20020a05600c4a9900b003cf91e53d69mr63084137wmp.160.1670208342783;
        Sun, 04 Dec 2022 18:45:42 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c41d100b003cf71b1f66csm15281532wmh.0.2022.12.04.18.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 18:45:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 7/7] io_uring: skip spinlocking for ->task_complete
Date:   Mon,  5 Dec 2022 02:44:31 +0000
Message-Id: <76ed0107ff51cec483eda84056363cc0d0775c7e.1670207706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670207706.git.asml.silence@gmail.com>
References: <cover.1670207706.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

->task_complete was added to serialised CQE posting by doing it from
the task context only (or fallback wq when the task is dead), and now we
can use that to avoid taking ->completion_lock while filling CQ entries.
The patch skips spinlocking only in two spots,
__io_submit_flush_completions() and flushing in io_aux_cqe, it's safer
and covers all cases we care about. Extra care is taken to force taking
the lock while queueing overflow entries.

It fundamentally relies on SINGLE_ISSUER to have only one task posting
events. It also need to take into account overflowed CQEs, flushing of
which happens in the cq wait path, and so this implementation also needs
DEFER_TASKRUN to limit waiters. For the same reason we disable it for
SQPOLL, and for IOPOLL as it won't benefit from it in any case.
DEFER_TASKRUN, SQPOLL and IOPOLL requirement may be relaxed in the
future.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 71 +++++++++++++++++++++++++++++++++------------
 io_uring/io_uring.h | 12 ++++++--
 2 files changed, 62 insertions(+), 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9eb771a4c912..36cb63e4174f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -594,13 +594,25 @@ static inline void io_cq_unlock(struct io_ring_ctx *ctx)
 	spin_unlock(&ctx->completion_lock);
 }
 
+static inline void __io_cq_lock(struct io_ring_ctx *ctx)
+	__acquires(ctx->completion_lock)
+{
+	if (!ctx->task_complete)
+		spin_lock(&ctx->completion_lock);
+}
+
+static inline void __io_cq_unlock(struct io_ring_ctx *ctx)
+{
+	if (!ctx->task_complete)
+		spin_unlock(&ctx->completion_lock);
+}
+
 /* keep it inlined for io_submit_flush_completions() */
-static inline void io_cq_unlock_post_inline(struct io_ring_ctx *ctx)
+static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
 	__releases(ctx->completion_lock)
 {
 	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-
+	__io_cq_unlock(ctx);
 	io_commit_cqring_flush(ctx);
 	io_cqring_wake(ctx);
 }
@@ -608,7 +620,10 @@ static inline void io_cq_unlock_post_inline(struct io_ring_ctx *ctx)
 void io_cq_unlock_post(struct io_ring_ctx *ctx)
 	__releases(ctx->completion_lock)
 {
-	io_cq_unlock_post_inline(ctx);
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_commit_cqring_flush(ctx);
+	io_cqring_wake(ctx);
 }
 
 /* Returns true if there are no backlogged entries after the flush */
@@ -795,12 +810,13 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
 	return &rings->cqes[off];
 }
 
-static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags,
-			    bool allow_overflow)
+static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
+			      u32 cflags)
 {
 	struct io_uring_cqe *cqe;
 
-	lockdep_assert_held(&ctx->completion_lock);
+	if (!ctx->task_complete)
+		lockdep_assert_held(&ctx->completion_lock);
 
 	ctx->cq_extra++;
 
@@ -823,10 +839,6 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32
 		}
 		return true;
 	}
-
-	if (allow_overflow)
-		return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
-
 	return false;
 }
 
@@ -840,7 +852,17 @@ static void __io_flush_post_cqes(struct io_ring_ctx *ctx)
 	for (i = 0; i < state->cqes_count; i++) {
 		struct io_uring_cqe *cqe = &state->cqes[i];
 
-		io_fill_cqe_aux(ctx, cqe->user_data, cqe->res, cqe->flags, true);
+		if (!io_fill_cqe_aux(ctx, cqe->user_data, cqe->res, cqe->flags)) {
+			if (ctx->task_complete) {
+				spin_lock(&ctx->completion_lock);
+				io_cqring_event_overflow(ctx, cqe->user_data,
+							cqe->res, cqe->flags, 0, 0);
+				spin_unlock(&ctx->completion_lock);
+			} else {
+				io_cqring_event_overflow(ctx, cqe->user_data,
+							cqe->res, cqe->flags, 0, 0);
+			}
+		}
 	}
 	state->cqes_count = 0;
 }
@@ -851,7 +873,10 @@ static bool __io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u
 	bool filled;
 
 	io_cq_lock(ctx);
-	filled = io_fill_cqe_aux(ctx, user_data, res, cflags, allow_overflow);
+	filled = io_fill_cqe_aux(ctx, user_data, res, cflags);
+	if (!filled && allow_overflow)
+		filled = io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
+
 	io_cq_unlock_post(ctx);
 	return filled;
 }
@@ -887,10 +912,10 @@ bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 res, u32
 	lockdep_assert_held(&ctx->uring_lock);
 
 	if (ctx->submit_state.cqes_count == length) {
-		io_cq_lock(ctx);
+		__io_cq_lock(ctx);
 		__io_flush_post_cqes(ctx);
 		/* no need to flush - flush is deferred */
-		io_cq_unlock(ctx);
+		__io_cq_unlock_post(ctx);
 	}
 
 	/* For defered completions this is not as strict as it is otherwise,
@@ -1418,7 +1443,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	struct io_wq_work_node *node, *prev;
 	struct io_submit_state *state = &ctx->submit_state;
 
-	io_cq_lock(ctx);
+	__io_cq_lock(ctx);
 	/* must come first to preserve CQE ordering in failure cases */
 	if (state->cqes_count)
 		__io_flush_post_cqes(ctx);
@@ -1426,10 +1451,18 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
 
-		if (!(req->flags & REQ_F_CQE_SKIP))
-			io_fill_cqe_req(ctx, req);
+		if (!(req->flags & REQ_F_CQE_SKIP) &&
+		    unlikely(!__io_fill_cqe_req(ctx, req))) {
+			if (ctx->task_complete) {
+				spin_lock(&ctx->completion_lock);
+				io_req_cqe_overflow(req);
+				spin_unlock(&ctx->completion_lock);
+			} else {
+				io_req_cqe_overflow(req);
+			}
+		}
 	}
-	io_cq_unlock_post_inline(ctx);
+	__io_cq_unlock_post(ctx);
 
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs)) {
 		io_free_batch_list(ctx, state->compl_reqs.first);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index a0b11a631e29..c20f15f5024d 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -112,7 +112,7 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 	return io_get_cqe_overflow(ctx, false);
 }
 
-static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
+static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 				     struct io_kiocb *req)
 {
 	struct io_uring_cqe *cqe;
@@ -124,7 +124,7 @@ static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
 	 */
 	cqe = io_get_cqe(ctx);
 	if (unlikely(!cqe))
-		return io_req_cqe_overflow(req);
+		return false;
 
 	trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
 				req->cqe.res, req->cqe.flags,
@@ -147,6 +147,14 @@ static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
 	return true;
 }
 
+static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
+				   struct io_kiocb *req)
+{
+	if (likely(__io_fill_cqe_req(ctx, req)))
+		return true;
+	return io_req_cqe_overflow(req);
+}
+
 static inline void req_set_fail(struct io_kiocb *req)
 {
 	req->flags |= REQ_F_FAIL;
-- 
2.38.1

