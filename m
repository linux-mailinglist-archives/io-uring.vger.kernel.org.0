Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4E213DA723
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237800AbhG2PGq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237783AbhG2PGq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:46 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B06CC061765
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:42 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id b7so7357669wri.8
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HDBpRxcgqGqE9trT1kKVbUJD63IvHFBukofqbcwdJ7s=;
        b=sOU6iC1knvlxptLoFkT127mFffDuBIx3x1JAryijzsHQrsl0nYkvvKyFxetY17Dppl
         e+JKIvr8qInBs0HTSHj81rHyPXdk2Anaq9lW7O3UWxQQlWApJgxM0r2W3JRlZqwGG979
         zKpniGUeIpVoA/yBMArKywaJgap4Zlz8k+OHIh8aQobhcW/PuK7+I6I9AZUe/+AJlH/d
         13ux64KMqbSZGijxRgOmf7u/3BaCir9VoiSFrKYHLF0g4PmTy33Otw6W3upXQOBNxpRB
         ghTm80vaTkNLNjpGl2lBXjbehQ5s3NVwt1R266ohmoQiCVwVR1d4j37a/fZVuLe7Kbih
         GVnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HDBpRxcgqGqE9trT1kKVbUJD63IvHFBukofqbcwdJ7s=;
        b=QoUor0lqPSBS3tvYPdVif01iFQ/qWT49F6DcecwEMKVXMgbqqJOVeU2kMRDOB2b1eK
         mbgOskd7z//D0+qCHF2Um/LuiONPe2MBfX8B9Bghe39yty+ECYEUZT1RZzyeV0dS9eXZ
         rnYsx8LOyEKxZeW5I8KXgJPf3ZMqpqdNeEqD/lOkrytpSUbfGMeX2vjnr84n3501gXm/
         /hzotODCd4AurCgyNS1iEs/ZUh9Vt3huGt7+CLD17SYwr2npfyTcPi9GoUKDFKIkTc8m
         gKInTqTGcbdsv7+v40Ev3VYg249bmsSrF7IW229UF/xqSMltegiVeoN1N6zpR9tpgJTD
         wlng==
X-Gm-Message-State: AOAM5333akQkSDjBnLgEyyDxY0HAxBreUhhvU6pV6ur1dwsgF8W5Tk4m
        /mfPFnh9Kj0fQgcFCuUdJ3zmBK33PmA=
X-Google-Smtp-Source: ABdhPJzNEiyQx8NjCAGph7n1NpLc+cdy9F3A3DRj/ptMmY8TixwjOBogcj/meUm4slhsUnRZWHmwIA==
X-Received: by 2002:a05:6000:10c6:: with SMTP id b6mr5513589wrx.110.1627571201154;
        Thu, 29 Jul 2021 08:06:41 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 21/23] io_uring: inline struct io_comp_state
Date:   Thu, 29 Jul 2021 16:05:48 +0100
Message-Id: <8cae54ac08e8b931cb712464a1d42a5b22ad4e6b.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline struct io_comp_state into struct io_submit_state. They are
already coupled tightly, together with mixed responsibilities it
only brings confusion having them separately.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 61 +++++++++++++++++++++++----------------------------
 1 file changed, 27 insertions(+), 34 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 33a1c45ecd13..c14206003725 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -305,13 +305,6 @@ struct io_sq_data {
 #define IO_REQ_CACHE_SIZE		32
 #define IO_REQ_ALLOC_BATCH		8
 
-struct io_comp_state {
-	struct io_kiocb		*reqs[IO_COMPL_BATCH];
-	unsigned int		nr;
-	/* inline/task_work completion list, under ->uring_lock */
-	struct list_head	free_list;
-};
-
 struct io_submit_link {
 	struct io_kiocb		*head;
 	struct io_kiocb		*last;
@@ -332,7 +325,10 @@ struct io_submit_state {
 	/*
 	 * Batch completion logic
 	 */
-	struct io_comp_state	comp;
+	struct io_kiocb		*compl_reqs[IO_COMPL_BATCH];
+	unsigned int		compl_nr;
+	/* inline/task_work completion list, under ->uring_lock */
+	struct list_head	free_list;
 
 	/*
 	 * File reference cache
@@ -1223,7 +1219,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_llist_head(&ctx->rsrc_put_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
-	INIT_LIST_HEAD(&ctx->submit_state.comp.free_list);
+	INIT_LIST_HEAD(&ctx->submit_state.free_list);
 	INIT_LIST_HEAD(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	return ctx;
@@ -1733,10 +1729,10 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
 }
 
 static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
-					struct io_comp_state *cs)
+					struct io_submit_state *state)
 {
 	spin_lock_irq(&ctx->completion_lock);
-	list_splice_init(&ctx->locked_free_list, &cs->free_list);
+	list_splice_init(&ctx->locked_free_list, &state->free_list);
 	ctx->locked_free_nr = 0;
 	spin_unlock_irq(&ctx->completion_lock);
 }
@@ -1745,7 +1741,6 @@ static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
-	struct io_comp_state *cs = &state->comp;
 	int nr;
 
 	/*
@@ -1754,11 +1749,11 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 	 * side cache.
 	 */
 	if (READ_ONCE(ctx->locked_free_nr) > IO_COMPL_BATCH)
-		io_flush_cached_locked_reqs(ctx, cs);
+		io_flush_cached_locked_reqs(ctx, state);
 
 	nr = state->free_reqs;
-	while (!list_empty(&cs->free_list)) {
-		struct io_kiocb *req = list_first_entry(&cs->free_list,
+	while (!list_empty(&state->free_list)) {
+		struct io_kiocb *req = list_first_entry(&state->free_list,
 					struct io_kiocb, inflight_entry);
 
 		list_del(&req->inflight_entry);
@@ -1941,7 +1936,7 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
 {
 	if (!ctx)
 		return;
-	if (ctx->submit_state.comp.nr) {
+	if (ctx->submit_state.compl_nr) {
 		mutex_lock(&ctx->uring_lock);
 		io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
@@ -2138,19 +2133,19 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	if (state->free_reqs != ARRAY_SIZE(state->reqs))
 		state->reqs[state->free_reqs++] = req;
 	else
-		list_add(&req->inflight_entry, &state->comp.free_list);
+		list_add(&req->inflight_entry, &state->free_list);
 }
 
 static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&req->ctx->uring_lock)
 {
-	struct io_comp_state *cs = &ctx->submit_state.comp;
-	int i, nr = cs->nr;
+	struct io_submit_state *state = &ctx->submit_state;
+	int i, nr = state->compl_nr;
 	struct req_batch rb;
 
 	spin_lock_irq(&ctx->completion_lock);
 	for (i = 0; i < nr; i++) {
-		struct io_kiocb *req = cs->reqs[i];
+		struct io_kiocb *req = state->compl_reqs[i];
 
 		__io_cqring_fill_event(ctx, req->user_data, req->result,
 					req->compl.cflags);
@@ -2161,7 +2156,7 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 
 	io_init_req_batch(&rb);
 	for (i = 0; i < nr; i++) {
-		struct io_kiocb *req = cs->reqs[i];
+		struct io_kiocb *req = state->compl_reqs[i];
 
 		/* submission and completion refs */
 		if (req_ref_sub_and_test(req, 2))
@@ -2169,7 +2164,7 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 	}
 
 	io_req_free_batch_finish(ctx, &rb);
-	cs->nr = 0;
+	state->compl_nr = 0;
 }
 
 /*
@@ -6479,10 +6474,10 @@ static void __io_queue_sqe(struct io_kiocb *req)
 		/* drop submission reference */
 		if (req->flags & REQ_F_COMPLETE_INLINE) {
 			struct io_ring_ctx *ctx = req->ctx;
-			struct io_comp_state *cs = &ctx->submit_state.comp;
+			struct io_submit_state *state = &ctx->submit_state;
 
-			cs->reqs[cs->nr++] = req;
-			if (cs->nr == ARRAY_SIZE(cs->reqs))
+			state->compl_reqs[state->compl_nr++] = req;
+			if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
 				io_submit_flush_completions(ctx);
 		} else {
 			io_put_req(req);
@@ -6686,7 +6681,7 @@ static void io_submit_state_end(struct io_submit_state *state,
 {
 	if (state->link.head)
 		io_queue_sqe(state->link.head);
-	if (state->comp.nr)
+	if (state->compl_nr)
 		io_submit_flush_completions(ctx);
 	if (state->plug_started)
 		blk_finish_plug(&state->plug);
@@ -8646,19 +8641,17 @@ static void io_req_cache_free(struct list_head *list)
 
 static void io_req_caches_free(struct io_ring_ctx *ctx)
 {
-	struct io_submit_state *submit_state = &ctx->submit_state;
-	struct io_comp_state *cs = &ctx->submit_state.comp;
+	struct io_submit_state *state = &ctx->submit_state;
 
 	mutex_lock(&ctx->uring_lock);
 
-	if (submit_state->free_reqs) {
-		kmem_cache_free_bulk(req_cachep, submit_state->free_reqs,
-				     submit_state->reqs);
-		submit_state->free_reqs = 0;
+	if (state->free_reqs) {
+		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
+		state->free_reqs = 0;
 	}
 
-	io_flush_cached_locked_reqs(ctx, cs);
-	io_req_cache_free(&cs->free_list);
+	io_flush_cached_locked_reqs(ctx, state);
+	io_req_cache_free(&state->free_list);
 	mutex_unlock(&ctx->uring_lock);
 }
 
-- 
2.32.0

