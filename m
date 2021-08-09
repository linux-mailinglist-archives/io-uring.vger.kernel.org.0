Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C47053E454A
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbhHIMFx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235357AbhHIMFt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:49 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7BFC061799
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:28 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id i4so3640241wru.0
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=glsIxtg+wNDPZw67ccdTOwM41V1hqzxxDQ3s947r0bs=;
        b=j0zenqrcs/LmughwliN1bomxP/pjT5gyPhpjTDKIXdsP5HLF7ML53vvAcHxhQsHCT8
         wHG/F3iHHLoor5Oqz7vNCu4hM52GU52wq0SYn59XSDwaLPD6OniAxA07vaTex2Ljwq6p
         BKKBO5Ase/sGYRsaf6V610C7ogxuxTTp/93vDfqqI2WIbUf3hecgIGb8h6yjPb+uSS7+
         0X6EmXGATyCaFLDEMmrF7oSk58X26lBzrtOoRFWYUZEBO0vne9b9cb1KlXZJ5ORoKn7x
         RaBDBzZgY6OXkd3Y4Tb6ZLCVNFBB3+/7TYD8myuL+Iyw/kBZ36OQC8d4nONOLnaSNXsx
         KtRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=glsIxtg+wNDPZw67ccdTOwM41V1hqzxxDQ3s947r0bs=;
        b=SYLwok95eag+RK6XJCBU6Bk7X9+gZBp0viiUWtBHYPWkY94ymW4xICRZh3o+YCze+b
         zKlF85J2Kzl9FuJIz6of4dDF5I/ULAeZg+dk4ICF2IAvdOd78xpHB44y5/KivRZlAuMH
         amkalFWkVcbPRIxGzMApyvL2gpn5QJIB+WFE45YMeOh0uhTso11aSoAF/NMhUkug6R1N
         N9yXxysT2+18TG3hkHUXYjGdlsBkd9ssxxcOM5eCXTTkEykQieJBNuZ3CYlIS5ukTK6/
         iuEHHTVtlQgjlXlOIXFdA2QdsjVcQcfdlAv7WRr3YCkGxRtNVh9HC5g+6PoJ5cVPnXOK
         M24Q==
X-Gm-Message-State: AOAM5335lBY4J/JIEcTcSpPI4yy5/03XaZnnUpfOfVFKGGTHLFOb1XjI
        IR6bXKOm5sgCW8WmF4nFyThWpKD/vzk=
X-Google-Smtp-Source: ABdhPJyHDlfZPBLAYS9RGNhuUDsdyA3DDev0S9337QIbS+mrqpTkA0vogz1VyQxuBgOEwPn9ZDZ32A==
X-Received: by 2002:a5d:420c:: with SMTP id n12mr24898707wrq.58.1628510727255;
        Mon, 09 Aug 2021 05:05:27 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 26/28] io_uring: inline struct io_comp_state
Date:   Mon,  9 Aug 2021 13:04:26 +0100
Message-Id: <c89b4b23c9974bb718909e44052c556a3d8db82f.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
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
index aaddbb4ce4ef..749c0712d98e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -299,13 +299,6 @@ struct io_sq_data {
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
@@ -326,7 +319,10 @@ struct io_submit_state {
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
@@ -1218,7 +1214,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_llist_head(&ctx->rsrc_put_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
-	INIT_LIST_HEAD(&ctx->submit_state.comp.free_list);
+	INIT_LIST_HEAD(&ctx->submit_state.free_list);
 	INIT_LIST_HEAD(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	return ctx;
@@ -1742,10 +1738,10 @@ static void io_preinit_req(struct io_kiocb *req, struct io_ring_ctx *ctx)
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
@@ -1754,7 +1750,6 @@ static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
-	struct io_comp_state *cs = &state->comp;
 	int nr;
 
 	/*
@@ -1763,11 +1758,11 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
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
@@ -1950,7 +1945,7 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
 {
 	if (!ctx)
 		return;
-	if (ctx->submit_state.comp.nr) {
+	if (ctx->submit_state.compl_nr) {
 		mutex_lock(&ctx->uring_lock);
 		io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
@@ -2147,19 +2142,19 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
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
@@ -2170,7 +2165,7 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 
 	io_init_req_batch(&rb);
 	for (i = 0; i < nr; i++) {
-		struct io_kiocb *req = cs->reqs[i];
+		struct io_kiocb *req = state->compl_reqs[i];
 
 		/* submission and completion refs */
 		if (req_ref_sub_and_test(req, 2))
@@ -2178,7 +2173,7 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 	}
 
 	io_req_free_batch_finish(ctx, &rb);
-	cs->nr = 0;
+	state->compl_nr = 0;
 }
 
 /*
@@ -6503,10 +6498,10 @@ static void __io_queue_sqe(struct io_kiocb *req)
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
@@ -6709,7 +6704,7 @@ static void io_submit_state_end(struct io_submit_state *state,
 {
 	if (state->link.head)
 		io_queue_sqe(state->link.head);
-	if (state->comp.nr)
+	if (state->compl_nr)
 		io_submit_flush_completions(ctx);
 	if (state->plug_started)
 		blk_finish_plug(&state->plug);
@@ -8657,19 +8652,17 @@ static void io_req_cache_free(struct list_head *list)
 
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

