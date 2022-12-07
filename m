Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAFB66452BE
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 04:54:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiLGDyt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 22:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229853AbiLGDyq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 22:54:46 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2FB752149
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 19:54:44 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id bj12so10993334ejb.13
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 19:54:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VFoHvlXm6jZqrvKe7FCJj4gL6hq6dRVmZkk3fOr4bcQ=;
        b=PPMMm0qTXUcovbtDSAdEz8yvpYppj84MF3JYdQkEz5pyV4FvKe9onYfZSpViEFqk/b
         9ElniL+wz7N2a2WHqpR3cWx4wF9NaHJnfnW322HiYl56cUDhMN4DqaSnjUrKLK19FR1y
         je0/QzdtSTPcgGFaB7qghiuP4pB+Cs8SluaKfWL8RHwLvqim9ig5M9oBSAkqHOYDNJFG
         7KdzVTL6CP+WBqpfDDQDSsaI1BpUwXNAc5RNtqfc1w+gj9GsFaZ7VUUR0sx3uV+5MGxg
         a11fXGpNVNqDyvzbCKGj6A4chWRq3ercQsMP8cLpENsGppBvfTrt246DB0vW4WexTSI7
         4CnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VFoHvlXm6jZqrvKe7FCJj4gL6hq6dRVmZkk3fOr4bcQ=;
        b=1oM13JwR01ufcMo67xpD9/2OIdhI7i3qi4ZkQpcUxKnNpDf2APD5MVsoPbYSB567ub
         MaQhkpMuwHO9zzcmdYnxcQ1mb5T93IuEkUZhXKmDCKW0DJZfy/+s6q+b8hmvO9Jpwoqq
         /ldwk5Iay/InbUWC6NL8EunqL+DfW4XaSVtZy5pMr4Dak7DvgpbfnnD3Rr0Jo5/ePRd7
         a17j3FnZkHOLQFZFcjCA3/zpxqNtcav1Be/GdWWSNU5f83txkLpPRPWcWRlJM+xzxrD1
         x5iqLf6pJmvsnGbjmRxRqai0ApWNfuvplyrtuIDGCXBpGOQiBVQx7VfYiIAdwfUmtyni
         9rLw==
X-Gm-Message-State: ANoB5pke0sYuqH5LYXWJlgFErmXYYvxzRmSP9PGAJpPNgEp+j5530tt7
        w9jWzauwkSyUWCIV/XhVxdZLAau7j6A=
X-Google-Smtp-Source: AA0mqf63iD2cKIxfxJ4VgXy2IgX6alYdOg21qeswsSEw+bCvjg9UP2z/onPBHKLSpaGRG6jPiarviA==
X-Received: by 2002:a17:907:2387:b0:7c0:d6b2:1fd4 with SMTP id vf7-20020a170907238700b007c0d6b21fd4mr14859861ejb.703.1670385283243;
        Tue, 06 Dec 2022 19:54:43 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm7938939ejt.197.2022.12.06.19.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 19:54:43 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 12/12] io_uring: skip spinlocking for ->task_complete
Date:   Wed,  7 Dec 2022 03:53:37 +0000
Message-Id: <2a8c91fd82cfcdcc1d2e5bac7051fe2c183bda73.1670384893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670384893.git.asml.silence@gmail.com>
References: <cover.1670384893.git.asml.silence@gmail.com>
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
index 0e424d8721ab..529ea5942dea 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -595,13 +595,25 @@ static inline void io_cq_unlock(struct io_ring_ctx *ctx)
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
@@ -609,7 +621,10 @@ static inline void io_cq_unlock_post_inline(struct io_ring_ctx *ctx)
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
@@ -796,12 +811,13 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
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
 
@@ -824,10 +840,6 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32
 		}
 		return true;
 	}
-
-	if (allow_overflow)
-		return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
-
 	return false;
 }
 
@@ -841,7 +853,17 @@ static void __io_flush_post_cqes(struct io_ring_ctx *ctx)
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
@@ -852,7 +874,10 @@ static bool __io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u
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
@@ -876,10 +901,10 @@ bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 res, u32
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
@@ -1414,7 +1439,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	struct io_wq_work_node *node, *prev;
 	struct io_submit_state *state = &ctx->submit_state;
 
-	io_cq_lock(ctx);
+	__io_cq_lock(ctx);
 	/* must come first to preserve CQE ordering in failure cases */
 	if (state->cqes_count)
 		__io_flush_post_cqes(ctx);
@@ -1422,10 +1447,18 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
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
index 62227ec3260c..c117e029c8dc 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -110,7 +110,7 @@ static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
 	return io_get_cqe_overflow(ctx, false);
 }
 
-static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
+static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 				     struct io_kiocb *req)
 {
 	struct io_uring_cqe *cqe;
@@ -122,7 +122,7 @@ static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
 	 */
 	cqe = io_get_cqe(ctx);
 	if (unlikely(!cqe))
-		return io_req_cqe_overflow(req);
+		return false;
 
 	trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
 				req->cqe.res, req->cqe.flags,
@@ -145,6 +145,14 @@ static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
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

