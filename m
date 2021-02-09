Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8603156D3
	for <lists+io-uring@lfdr.de>; Tue,  9 Feb 2021 20:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233339AbhBITaF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 14:30:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbhBITFc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 14:05:32 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014E5C0617A7
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 11:04:25 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id e7so17080903ile.7
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 11:04:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l8oAIMitjZsHIQyG3RvUawDDxXBD8JxLbCWMzFgpDVA=;
        b=GLvA5v3cpXuRJWk7pz4vOqaTwWSqYa7zUWGZixL+5mL0SRiqWUZoc7duekd7YQH99R
         crAPtOKY6oVBqO6xN/lsGxNDI+Wq4jOFN1ro8tzmMxwFysJH1IiIcXbmhUbDxvvX3Gqa
         KptbulEnVSwK2nXkzO1ukuH8NOfPuX7Vd841LkInzyoJk+AVetI4FvV6gUQ56ROlwZkF
         Pq0gx3bOSG/9T0upDq165e6gIzxiJ0X0eVOc6y8uuOKUm58g7pm/Zs/06HbIUuhUhtSL
         G3vbX7HNzj7XYaXkUQmOfwheib44ELQip2Mg9PXaV3JNwiv23bExUmRjGrUmqcXmo8LH
         ufLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l8oAIMitjZsHIQyG3RvUawDDxXBD8JxLbCWMzFgpDVA=;
        b=Vq3wDbiRr8lZCtDHYcjz1gT+xkcA0Gw68abzihb1Y9wkVB6CzOBQ5jnNe5lHSMBXk2
         rDCOUYgbOT2AcWucHSwsI96DsmDcEEhw2NbUXYdPSKzp7iGgGIrENxGnHPWc92Ms8sQX
         y/ylSn0Cbui+guc+HziaKETchoE+84j3hDvmvcyBjkZAIOT/7bdKHXhsOM9oHVRd/TXH
         VxXsQ49f/XHKrnVtvuNHMOs2RlcaUpVQbkYC6C+JfzjwMhuI4EeG48s5AnGtdsoJ8ImF
         lqedbpSUakiH04YTxsth6hm3rPJtpS1DzP1AZ8uiwlHi2j88ZzxL6uJ9Hvq8X9zALFTG
         bq+w==
X-Gm-Message-State: AOAM533ZOnzC1ArygT+8DOlA555ycL12SgOItXNpSwAYFo4WMY62E6Tr
        vry8BlSnv1Pu13sCcR35pidK7P6zoil8B41G
X-Google-Smtp-Source: ABdhPJwqPO/RW8LNGEhe+dyMYnd7MQDZ7apqIXr69PD0Z4Spfy69rKvPb3FMlAKRCi8G7e3M0wkz1g==
X-Received: by 2002:a92:c84e:: with SMTP id b14mr20114560ilq.255.1612897464155;
        Tue, 09 Feb 2021 11:04:24 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i8sm10645554ilv.57.2021.02.09.11.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 11:04:23 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_ring: use persistent request cache
Date:   Tue,  9 Feb 2021 12:04:16 -0700
Message-Id: <20210209190418.208827-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210209190418.208827-1-axboe@kernel.dk>
References: <20210209190418.208827-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now that we have the submit_state in the ring itself, we can have io_kiocb
allocations that are persistent across invocations. This reduces the time
spent doing slab allocations and frees.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 58 +++++++++++++++++++++++++++++++--------------------
 1 file changed, 35 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ab3f842869dd..502bdef41460 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -263,8 +263,9 @@ struct io_sq_data {
 #define IO_COMPL_BATCH			32
 
 struct io_comp_state {
-	unsigned int		nr;
 	struct io_kiocb		*reqs[IO_COMPL_BATCH];
+	unsigned int		nr;
+	struct list_head	free_list;
 };
 
 struct io_submit_state {
@@ -1290,7 +1291,6 @@ static inline bool io_is_timeout_noseq(struct io_kiocb *req)
 
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
 	if (ctx->fallback_req)
@@ -1969,6 +1966,14 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
+	if (!list_empty(&state->comp.free_list)) {
+		struct io_kiocb *req;
+
+		req = list_first_entry(&state->comp.free_list, struct io_kiocb,
+					compl.list);
+		list_del(&req->compl.list);
+		return req;
+	}
 	if (!state->free_reqs) {
 		gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 		size_t sz;
@@ -2255,33 +2260,25 @@ static void io_free_req(struct io_kiocb *req)
 }
 
 struct req_batch {
-	void *reqs[IO_IOPOLL_BATCH];
-	int to_free;
-
 	struct task_struct	*task;
 	int			task_refs;
+	int			ctx_refs;
 };
 
 static inline void io_init_req_batch(struct req_batch *rb)
 {
-	rb->to_free = 0;
+	rb->ctx_refs = 0;
 	rb->task_refs = 0;
 	rb->task = NULL;
 }
 
-static void __io_req_free_batch_flush(struct io_ring_ctx *ctx,
-				      struct req_batch *rb)
-{
-	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
-	percpu_ref_put_many(&ctx->refs, rb->to_free);
-	rb->to_free = 0;
-}
-
 static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 				     struct req_batch *rb)
 {
-	if (rb->to_free)
-		__io_req_free_batch_flush(ctx, rb);
+	if (rb->ctx_refs) {
+		percpu_ref_put_many(&ctx->refs, rb->ctx_refs);
+		rb->ctx_refs = 0;
+	}
 	if (rb->task) {
 		io_put_task(rb->task, rb->task_refs);
 		rb->task = NULL;
@@ -2290,6 +2287,8 @@ static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 
 static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 {
+	struct io_comp_state *cs = &req->ctx->submit_state.comp;
+
 	if (unlikely(io_is_fallback_req(req))) {
 		io_free_req(req);
 		return;
@@ -2305,9 +2304,8 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 	rb->task_refs++;
 
 	io_dismantle_req(req);
-	rb->reqs[rb->to_free++] = req;
-	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
-		__io_req_free_batch_flush(req->ctx, rb);
+	rb->ctx_refs++;
+	list_add(&req->compl.list, &cs->free_list);
 }
 
 static void io_submit_flush_completions(struct io_comp_state *cs,
@@ -8668,6 +8666,19 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
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
 	io_finish_async(ctx);
@@ -8705,6 +8716,7 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	put_cred(ctx->creds);
 	kfree(ctx->cancel_hash);
 	kmem_cache_free(req_cachep, ctx->fallback_req);
+	io_req_cache_free(ctx);
 	kfree(ctx);
 }
 
-- 
2.30.0

