Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4EA94178DE
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344201AbhIXQh6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347465AbhIXQha (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:30 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85965C0613AE
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:54 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id y89so27464379ede.2
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=RlkuLRq021QrBzfTDUk7OE8sj5Z8kua25E79lsZW76k=;
        b=UWJKQ0VLYJ65Rp+y6UY06MNDOtDJz51cZfQvHUJ4lw3/EDJMftfADQiMsFvV21FUgr
         tooLahxTWYjk+B0TG99eZ7YPzQvnN8m4cY9FFabxutXOeIYkBC+ztN18EzE24FkbW/BP
         JWPXcj/mUdRV/FSnBnRr68q9cHLe8EofpFZ22i9W0ur6AFchPuvsSHEvpOiDEaaIB7uR
         fHJsWJe5FOGdZyDHhDs1dejqIsGwZvchypRZQzfMmW6p8KAQIk3/JCfXVqDO2qBh/4r1
         KGIEOKgzWPIHz0KnugZwM4UxQw3lewz+neScZZmVgwB+amDYeB3YB8lkWxJoqHP/in0K
         pvsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RlkuLRq021QrBzfTDUk7OE8sj5Z8kua25E79lsZW76k=;
        b=B501R2WhBsjrhWxRP/3YjO3AYuBu2d5rEExJc7JhSZDs9jwx6g4g3aHVX8Crt1VozJ
         +PPSe9/0x3pw0+aMMguWptDHQ4o7yl2JvGek4DBmQAO9lw7r/B9MxVP60jaNIQnovKsd
         g7In2tQGb2skbJbCU3dlfqiO0qB8Vmr0B2knSgR6lP0K9VohPsH7sYlSgAFIhTK1n3pe
         xK//p6B0bum3SH4gJhXLoCj4dJO5h0/U7v+79v+XXoEA2SeJO+GLK7ggwawfLWSCLmZD
         0ED/ZUKyyuL5jx9F8cTaIhV6F1JyS+yBS678uHlvBnW61tcjFzmZTltZMX9OAWBphKBJ
         368w==
X-Gm-Message-State: AOAM533nTsVpjUes+OilrXL336zQfxYIlyNvTqa1/S7/WgdfULlei7aU
        fieOE1zOG60gKcKkOp6UbDXLH7pAxmo=
X-Google-Smtp-Source: ABdhPJwc9MApbiyxI+O1KNTkcQr2LsYopu6SC3KKtWF1h9F8JD+Q50njJ++m0pGSOiGAyT0a+cW8tA==
X-Received: by 2002:a17:906:1f81:: with SMTP id t1mr12217071ejr.510.1632501173153;
        Fri, 24 Sep 2021 09:32:53 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/23] io_uring: replace list with stack for req caches
Date:   Fri, 24 Sep 2021 17:31:45 +0100
Message-Id: <fa66aa76e3dd212adc96bbd9d9c45f03c6701f53.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
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
index bf59ca19aef2..67390b131fb0 100644
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
@@ -1316,8 +1316,8 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
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
@@ -1808,7 +1808,7 @@ static void io_req_complete_post(struct io_kiocb *req, long res,
 		}
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
-		list_add(&req->inflight_entry, &ctx->locked_free_list);
+		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 		ctx->locked_free_nr++;
 		percpu_ref_put(&ctx->refs);
 	}
@@ -1885,7 +1885,7 @@ static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 					struct io_submit_state *state)
 {
 	spin_lock(&ctx->completion_lock);
-	list_splice_init(&ctx->locked_free_list, &state->free_list);
+	wq_list_splice(&ctx->locked_free_list, &state->free_list);
 	ctx->locked_free_nr = 0;
 	spin_unlock(&ctx->completion_lock);
 }
@@ -1902,7 +1902,7 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 	 */
 	if (READ_ONCE(ctx->locked_free_nr) > IO_COMPL_BATCH)
 		io_flush_cached_locked_reqs(ctx, state);
-	return !list_empty(&state->free_list);
+	return !!state->free_list.next;
 }
 
 /*
@@ -1917,10 +1917,11 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
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
@@ -1940,12 +1941,11 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
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
@@ -1978,7 +1978,7 @@ static void __io_free_req(struct io_kiocb *req)
 	io_put_task(req->task, 1);
 
 	spin_lock(&ctx->completion_lock);
-	list_add(&req->inflight_entry, &ctx->locked_free_list);
+	wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
 	ctx->locked_free_nr++;
 	spin_unlock(&ctx->completion_lock);
 
@@ -2302,8 +2302,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	}
 	rb->task_refs++;
 	rb->ctx_refs++;
-
-	list_add(&req->inflight_entry, &state->free_list);
+	wq_stack_add_head(&req->comp_list, &state->free_list);
 }
 
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
@@ -7252,7 +7251,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		}
 		sqe = io_get_sqe(ctx);
 		if (unlikely(!sqe)) {
-			list_add(&req->inflight_entry, &ctx->submit_state.free_list);
+			wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
 			break;
 		}
 		/* will complete beyond this point, count as submitted */
@@ -9144,23 +9143,21 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 		__io_remove_buffers(ctx, buf, index, -1U);
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

