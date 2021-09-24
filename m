Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B642A417CAD
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhIXVCi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346598AbhIXVCa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:30 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23FB8C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:57 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id y89so30104658ede.2
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=p1Vm1tw/YO4wgCSdPylPbVCgMGjlcW/l0xWkL6kNHHw=;
        b=UAM6EwAbo0fSUJtY4Emkee5xXZE5pr9J1a9yIdQmqPvyQA9yav72vYOv+CQPQccZ2S
         l6LzzqjW4hA1Yv3joj2uPZrWZSFnxyWOttBfeKi2e0VFUeRzXCQgAFWbvwqhnPhFD5IA
         makIsDQ5QNF/c9je0fAfz9WAlvWgzzNRq1pvLt2bah2PSfaqn2VXwROVpizKLP6VSdpd
         rEMg7P73nVRLtJxsEa6DWdVFqIahmMcJsExxBS0cVKMNS7elzVX51H5xHw3CY0OiWbVF
         o6v2GOoDLcsuR8jas0c2PO1+MyT/7jNKVUSDGTXhJn4wUOgx1asVtjt5ye8F0Gs5g4Zr
         uAlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p1Vm1tw/YO4wgCSdPylPbVCgMGjlcW/l0xWkL6kNHHw=;
        b=63XzVet7yH2UQxhr3/VGudGOch+kpwZqhH32q/F+jVraSX4dsoeH0dutYRS5RlFwZi
         7jbTihpdT1EK4Viu/UHFGQ5a+l2mq27IuR6fSxhZJ3tOHcNvGmHVSyjuYgAlwE5072yy
         Psw9pPz7VeGxDsjH6ODDK65ymEs+EQ5GG45UzvjjjX9HWVrg/l2YMRC8Latk9inSz4w/
         VvqDl1yb4IyTPCMwkFJOVWexlxtMWF20+KK6Sx9Y4tOaaN9WiyYgjNehGzjI5YOIzEz/
         18fTa0egD6lvaIVhu1P45J2fg6KWAu5I/9Ns/sOMoCfDQZa3v33pnmmnhW5syuWNYpTi
         BWnw==
X-Gm-Message-State: AOAM53206xgsZyWki07MHpFzJRhFnmr1y70onO+igLI580daWKmP/5tx
        NFJEcig0R0ZqfYlEtiB+T9DK+KZw34I=
X-Google-Smtp-Source: ABdhPJwY9ziTfNGX2IiBSWOqTUu4bY6QLc3WQ5r5WfTmlnNUoKjrl/k8kmxC6OxFYpXY68epMLB84w==
X-Received: by 2002:a17:906:5586:: with SMTP id y6mr13501901ejp.189.1632517255727;
        Fri, 24 Sep 2021 14:00:55 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:00:55 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 07/24] io_uring: replace list with stack for req caches
Date:   Fri, 24 Sep 2021 21:59:47 +0100
Message-Id: <1bc942b82422fb2624b8353bd93aca183a022846.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Replace struct list_head free_list serving for caching requests with
singly linked stack, which is faster.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 51 ++++++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9d8d79104d75..e29f75bc69ae 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -319,7 +319,7 @@ struct io_submit_state {
 	struct io_wq_work_list	compl_reqs;
 
 	/* inline/task_work completion list, under ->uring_lock */
-	struct list_head	free_list;
+	struct io_wq_work_node	free_list;
 };
 
 struct io_ring_ctx {
@@ -379,7 +379,7 @@ struct io_ring_ctx {
 	} ____cacheline_aligned_in_smp;
 
 	/* IRQ completion list, under ->completion_lock */
-	struct list_head	locked_free_list;
+	struct io_wq_work_list	locked_free_list;
 	unsigned int		locked_free_nr;
 
 	const struct cred	*sq_creds;	/* cred used for __io_sq_thread() */
@@ -1319,8 +1319,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_llist_head(&ctx->rsrc_put_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
-	INIT_LIST_HEAD(&ctx->submit_state.free_list);
-	INIT_LIST_HEAD(&ctx->locked_free_list);
+	ctx->submit_state.free_list.next = NULL;
+	INIT_WQ_LIST(&ctx->locked_free_list);
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	return ctx;
@@ -1811,7 +1811,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		}
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
-		list_add(&req->inflight_entry, &ctx->locked_free_list);
+		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
 		percpu_ref_put(&ctx->refs);
 	}
@@ -1888,7 +1888,7 @@ static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 					struct io_submit_state *state)
 {
 	spin_lock(&ctx->completion_lock);
-	list_splice_init(&ctx->locked_free_list, &state->free_list);
+	wq_list_splice(&ctx->locked_free_list, &state->free_list);
 	ctx->locked_free_nr = 0;
 	spin_unlock(&ctx->completion_lock);
 }
@@ -1905,7 +1905,7 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 	 */
 	if (READ_ONCE(ctx->locked_free_nr) > IO_COMPL_BATCH)
 		io_flush_cached_locked_reqs(ctx, state);
-	return !list_empty(&state->free_list);
+	return !!state->free_list.next;
 }
 
 /*
@@ -1920,10 +1920,11 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	void *reqs[IO_REQ_ALLOC_BATCH];
+	struct io_wq_work_node *node;
 	struct io_kiocb *req;
 	int ret, i;
 
-	if (likely(!list_empty(&state->free_list) || io_flush_cached_reqs(ctx)))
+	if (likely(state->free_list.next || io_flush_cached_reqs(ctx)))
 		goto got_req;
 
 	ret = kmem_cache_alloc_bulk(req_cachep, gfp, ARRAY_SIZE(reqs), reqs);
@@ -1943,12 +1944,11 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 		req = reqs[i];
 
 		io_preinit_req(req, ctx);
-		list_add(&req->inflight_entry, &state->free_list);
+		wq_stack_add_head(&req->comp_list, &state->free_list);
 	}
 got_req:
-	req = list_first_entry(&state->free_list, struct io_kiocb, inflight_entry);
-	list_del(&req->inflight_entry);
-	return req;
+	node = wq_stack_extract(&state->free_list);
+	return container_of(node, struct io_kiocb, comp_list);
 }
 
 static inline void io_put_file(struct file *file)
@@ -1981,7 +1981,7 @@ static void __io_free_req(struct io_kiocb *req)
 	io_put_task(req->task, 1);
 
 	spin_lock(&ctx->completion_lock);
-	list_add(&req->inflight_entry, &ctx->locked_free_list);
+	wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 	ctx->locked_free_nr++;
 	spin_unlock(&ctx->completion_lock);
 
@@ -2305,8 +2305,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	}
 	rb->task_refs++;
 	rb->ctx_refs++;
-
-	list_add(&req->inflight_entry, &state->free_list);
+	wq_stack_add_head(&req->comp_list, &state->free_list);
 }
 
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
@@ -7268,7 +7267,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		}
 		sqe = io_get_sqe(ctx);
 		if (unlikely(!sqe)) {
-			list_add(&req->inflight_entry, &ctx->submit_state.free_list);
+			wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
 			break;
 		}
 		/* will complete beyond this point, count as submitted */
@@ -9200,23 +9199,21 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 	}
 }
 
-static void io_req_cache_free(struct list_head *list)
-{
-	struct io_kiocb *req, *nxt;
-
-	list_for_each_entry_safe(req, nxt, list, inflight_entry) {
-		list_del(&req->inflight_entry);
-		kmem_cache_free(req_cachep, req);
-	}
-}
-
 static void io_req_caches_free(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
 	mutex_lock(&ctx->uring_lock);
 	io_flush_cached_locked_reqs(ctx, state);
-	io_req_cache_free(&state->free_list);
+
+	while (state->free_list.next) {
+		struct io_wq_work_node *node;
+		struct io_kiocb *req;
+
+		node = wq_stack_extract(&state->free_list);
+		req = container_of(node, struct io_kiocb, comp_list);
+		kmem_cache_free(req_cachep, req);
+	}
 	mutex_unlock(&ctx->uring_lock);
 }
 
-- 
2.33.0

