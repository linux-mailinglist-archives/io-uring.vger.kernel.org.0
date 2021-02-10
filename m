Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26B52315B03
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:22:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235023AbhBJAUK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235120AbhBJAKq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:10:46 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFA73C0617AB
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:28 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id t142so320712wmt.1
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=aKE7jprr6vQijlFEPiGV2ycRQpi8XmS7N23ijjLYw+4=;
        b=NTNWrwjRkFU2WGhj3ecE+U/aqcPMq1b13QcS92GSwT3wNifbTu1Q/qzJuTjUGwW1Hx
         UiuoFZsO5lQ76fTFa2hceGFvOhHBE3CtwLkCSpiK+s/Q98XeJe0mV5IvGB7LpbV1F63j
         pX9eVXuow2QQcqd7ES0lh33i8Q83tyswQcy/wJsbIz46a8DYLOEnZeOhMbkhLCH04Lbf
         J9cwM2OZN8tYTSYi9SyBKXM1p0idK4YkLGH7m5VGFpVyhL6KbrF8W2dk2eU3ZcLbFLzM
         eOo/nVfHlKlLYwzriNaZvU+gSEVMoax5txznCT7nKCGcR7/UZOYChH1oH3ZMGOja9wa6
         HDbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aKE7jprr6vQijlFEPiGV2ycRQpi8XmS7N23ijjLYw+4=;
        b=Ek8PnAEeqHcZzTMYuu4DQvuA0uhvH8nmWQNZJa35f5mhuifV4JVQat52JmZU//NSw2
         zAOJYs9ixyNoRfE4wUFGb1fBQ/H2PspFYKsMnIZc0nPg7sNQgYAAThyC9SdAQGd9548e
         v/VX4TYSEBQqjX47siPvmZny+ubGKdD3Zxt4TlC+br8/16Txz81WzMUOBPujBmd5eH4c
         EGyJrs7VSi9nLRWY+b2gxyXpiHL3CPpvdxjPYkn1ZQCfUMsC4OvoBq6lS7kZtqHeIwhw
         nfo4BpH/81IF/alYm5Z6I6rIOk8TCSyZW6WgtmELmzzrf1jyN0252HmvfiQBsGclWSiC
         2eCg==
X-Gm-Message-State: AOAM533rW/NfQBVRyhOqCQJXPnqvG9J5DK/eS/RX3IJ0AvNQk0pbCiqc
        hrFOdxn3xdSJ1eNZWU5+e7U=
X-Google-Smtp-Source: ABdhPJzQglWkyGcI7lyYD1vMBCYtnPOdArzo4Ik/TzkuXoBg1vBEuscDOS+1hd51EOQob0FFkveImw==
X-Received: by 2002:a05:600c:3212:: with SMTP id r18mr464558wmp.132.1612915647670;
        Tue, 09 Feb 2021 16:07:27 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 13/17] io_uring: use persistent request cache
Date:   Wed, 10 Feb 2021 00:03:19 +0000
Message-Id: <df890f4c676ee944fb9d389dece05243418e153a.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

Now that we have the submit_state in the ring itself, we can have io_kiocb
allocations that are persistent across invocations. This reduces the time
spent doing slab allocations and frees.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
[sil: rebased]
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 53 +++++++++++++++++++++++++++++----------------------
 1 file changed, 30 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1918b410b6f2..58f150680c05 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -270,8 +270,9 @@ struct io_sq_data {
 #define IO_REQ_ALLOC_BATCH		8
 
 struct io_comp_state {
-	unsigned int		nr;
 	struct io_kiocb		*reqs[IO_COMPL_BATCH];
+	unsigned int		nr;
+	struct list_head	free_list;
 };
 
 struct io_submit_state {
@@ -1294,7 +1295,6 @@ static inline bool io_is_timeout_noseq(struct io_kiocb *req)
 
 static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
-	struct io_submit_state *submit_state;
 	struct io_ring_ctx *ctx;
 	int hash_bits;
 
@@ -1343,10 +1343,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_llist_head(&ctx->rsrc_put_llist);
 
-	submit_state = &ctx->submit_state;
-	submit_state->comp.nr = 0;
-	submit_state->file_refs = 0;
-	submit_state->free_reqs = 0;
+	INIT_LIST_HEAD(&ctx->submit_state.comp.free_list);
 	return ctx;
 err:
 	kfree(ctx->cancel_hash);
@@ -1952,6 +1949,15 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 
 	BUILD_BUG_ON(IO_REQ_ALLOC_BATCH > ARRAY_SIZE(state->reqs));
 
+	if (!list_empty(&state->comp.free_list)) {
+		struct io_kiocb *req;
+
+		req = list_first_entry(&state->comp.free_list, struct io_kiocb,
+					compl.list);
+		list_del(&req->compl.list);
+		return req;
+	}
+
 	if (!state->free_reqs) {
 		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 		int ret;
@@ -2234,34 +2240,21 @@ static void io_free_req(struct io_kiocb *req)
 }
 
 struct req_batch {
-	void *reqs[IO_IOPOLL_BATCH];
-	int to_free;
-	int ctx_refs;
-
 	struct task_struct	*task;
 	int			task_refs;
+	int			ctx_refs;
 };
 
 static inline void io_init_req_batch(struct req_batch *rb)
 {
-	rb->to_free = 0;
 	rb->task_refs = 0;
 	rb->ctx_refs = 0;
 	rb->task = NULL;
 }
 
-static void __io_req_free_batch_flush(struct io_ring_ctx *ctx,
-				      struct req_batch *rb)
-{
-	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
-	rb->to_free = 0;
-}
-
 static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 				     struct req_batch *rb)
 {
-	if (rb->to_free)
-		__io_req_free_batch_flush(ctx, rb);
 	if (rb->task) {
 		io_put_task(rb->task, rb->task_refs);
 		rb->task = NULL;
@@ -2288,9 +2281,9 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	if (state->free_reqs != ARRAY_SIZE(state->reqs)) {
 		state->reqs[state->free_reqs++] = req;
 	} else {
-		rb->reqs[rb->to_free++] = req;
-		if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
-			__io_req_free_batch_flush(req->ctx, rb);
+		struct io_comp_state *cs = &req->ctx->submit_state.comp;
+
+		list_add(&req->compl.list, &cs->free_list);
 	}
 }
 
@@ -8646,6 +8639,19 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 	idr_destroy(&ctx->io_buffer_idr);
 }
 
+static void io_req_cache_free(struct io_ring_ctx *ctx)
+{
+	struct io_comp_state *cs = &ctx->submit_state.comp;
+
+	while (!list_empty(&cs->free_list)) {
+		struct io_kiocb *req;
+
+		req = list_first_entry(&cs->free_list, struct io_kiocb, compl.list);
+		list_del(&req->compl.list);
+		kmem_cache_free(req_cachep, req);
+	}
+}
+
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *submit_state = &ctx->submit_state;
@@ -8688,6 +8694,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	free_uid(ctx->user);
 	put_cred(ctx->creds);
 	kfree(ctx->cancel_hash);
+	io_req_cache_free(ctx);
 	kfree(ctx);
 }
 
-- 
2.24.0

