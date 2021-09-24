Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DED24178E2
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 18:36:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344295AbhIXQiA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 12:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347416AbhIXQh3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 12:37:29 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE991C0613AB
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:52 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id dj4so38328942edb.5
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 09:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+mZohRSDgXnqBDXWtmR0vwh24ksKijItKSQqbC5GsgQ=;
        b=fNBrxCUN127LI9H04sHxtIYlRiPLg8DjIm5u7cjAML550Kw2hkiBN3AzXNt0c0ONO1
         zdtZwOJT9CvdnFB1KS0sOqyepcLcYDzZzO9OVbbYCNwIECNO0etNbCw3s3IGNI7LPBbH
         37yhC2fWj4UJ+oicVUbu7jBnV3+LaxzZFM9Ntn1wZn+9Wnf5dzLUNGR5DSRyJiWdZtzS
         t7DJQe52Fy+saKsrKI6JjcAu54tShkCzfjQrgeC8QP6tuCkBVVFBPl9jUdD/+3uLr4jA
         QaYJFHnyvV9jmIbKH6Eu3ED522JgdWttk1hyU1lXCJk++EVkHZTiaVG6XPRVotAG+S5s
         ZVdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+mZohRSDgXnqBDXWtmR0vwh24ksKijItKSQqbC5GsgQ=;
        b=hAdJLPToe0JGqA2GIL3qFb2iFbAfyOYyN5F0Ix+diHlSuL8+7HBJYqq2TQdIqFi9P8
         Z5sc6vDfehhD9BQ6fCVs4oClURRySWiVfyVlhGa+o5+iyX0WjafaHHeLHlYZj7vPE0Rm
         VZmmNI/4v760cb9ozG+P1/7l3Bun9hJHvttR238s5UDONsSfELWE+FM74SST1Dh6XTA1
         weZgedTqZhQ1YX779q0XdGB4n0ct/11yt4AXAVSao+lLcXNvKFsh6jxjbwQqZ8eaD7uD
         W2zIbax87YjGaau1pDpQr2vCv9Eq8Cdh4U4R3JCZrftbbDfotlduasZNzR9YZZJOzrOz
         6ILg==
X-Gm-Message-State: AOAM530GDPGYa70PK/bMFoE49qG+j7r0A7bOy1i6DGMYh5nbrgpP0n0L
        rAaeTm5TMrJasiihXg5RB6KEJcLG2Ss=
X-Google-Smtp-Source: ABdhPJwSJddTzUCsn2DrhK1DdDdmCoo25gSfJD3q+MKIuG5pYaQddILm7/V2ozjhveyNt67HVCuRVg==
X-Received: by 2002:a50:a0a2:: with SMTP id 31mr5844221edo.252.1632501171319;
        Fri, 24 Sep 2021 09:32:51 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id w10sm6167021eds.30.2021.09.24.09.32.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 09:32:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/23] io_uring: remove allocation cache array
Date:   Fri, 24 Sep 2021 17:31:43 +0100
Message-Id: <21ee9095e4b7fbb3fa42de8c4879a4a4cfa798a9.1632500264.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632500264.git.asml.silence@gmail.com>
References: <cover.1632500264.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We have several of request allocation layers, remove the last one, which
is the submit->reqs array, and always use submit->free_reqs instead.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 60 +++++++++++++++------------------------------------
 1 file changed, 17 insertions(+), 43 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 027e6595321e..bf59ca19aef2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -310,12 +310,6 @@ struct io_submit_state {
 	struct blk_plug		plug;
 	struct io_submit_link	link;
 
-	/*
-	 * io_kiocb alloc cache
-	 */
-	void			*reqs[IO_REQ_CACHE_SIZE];
-	unsigned int		free_reqs;
-
 	bool			plug_started;
 	bool			need_plug;
 
@@ -1900,7 +1894,6 @@ static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
-	int nr;
 
 	/*
 	 * If we have more than a batch's worth of requests in our IRQ side
@@ -1909,20 +1902,7 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 	 */
 	if (READ_ONCE(ctx->locked_free_nr) > IO_COMPL_BATCH)
 		io_flush_cached_locked_reqs(ctx, state);
-
-	nr = state->free_reqs;
-	while (!list_empty(&state->free_list)) {
-		struct io_kiocb *req = list_first_entry(&state->free_list,
-					struct io_kiocb, inflight_entry);
-
-		list_del(&req->inflight_entry);
-		state->reqs[nr++] = req;
-		if (nr == ARRAY_SIZE(state->reqs))
-			break;
-	}
-
-	state->free_reqs = nr;
-	return nr != 0;
+	return !list_empty(&state->free_list);
 }
 
 /*
@@ -1936,33 +1916,36 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
+	void *reqs[IO_REQ_ALLOC_BATCH];
+	struct io_kiocb *req;
 	int ret, i;
 
-	BUILD_BUG_ON(ARRAY_SIZE(state->reqs) < IO_REQ_ALLOC_BATCH);
-
-	if (likely(state->free_reqs || io_flush_cached_reqs(ctx)))
+	if (likely(!list_empty(&state->free_list) || io_flush_cached_reqs(ctx)))
 		goto got_req;
 
-	ret = kmem_cache_alloc_bulk(req_cachep, gfp, IO_REQ_ALLOC_BATCH,
-				    state->reqs);
+	ret = kmem_cache_alloc_bulk(req_cachep, gfp, ARRAY_SIZE(reqs), reqs);
 
 	/*
 	 * Bulk alloc is all-or-nothing. If we fail to get a batch,
 	 * retry single alloc to be on the safe side.
 	 */
 	if (unlikely(ret <= 0)) {
-		state->reqs[0] = kmem_cache_alloc(req_cachep, gfp);
-		if (!state->reqs[0])
+		reqs[0] = kmem_cache_alloc(req_cachep, gfp);
+		if (!reqs[0])
 			return NULL;
 		ret = 1;
 	}
 
-	for (i = 0; i < ret; i++)
-		io_preinit_req(state->reqs[i], ctx);
-	state->free_reqs = ret;
+	for (i = 0; i < ret; i++) {
+		req = reqs[i];
+
+		io_preinit_req(req, ctx);
+		list_add(&req->inflight_entry, &state->free_list);
+	}
 got_req:
-	state->free_reqs--;
-	return state->reqs[state->free_reqs];
+	req = list_first_entry(&state->free_list, struct io_kiocb, inflight_entry);
+	list_del(&req->inflight_entry);
+	return req;
 }
 
 static inline void io_put_file(struct file *file)
@@ -2320,10 +2303,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	rb->task_refs++;
 	rb->ctx_refs++;
 
-	if (state->free_reqs != ARRAY_SIZE(state->reqs))
-		state->reqs[state->free_reqs++] = req;
-	else
-		list_add(&req->inflight_entry, &state->free_list);
+	list_add(&req->inflight_entry, &state->free_list);
 }
 
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
@@ -9179,12 +9159,6 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 
 	mutex_lock(&ctx->uring_lock);
-
-	if (state->free_reqs) {
-		kmem_cache_free_bulk(req_cachep, state->free_reqs, state->reqs);
-		state->free_reqs = 0;
-	}
-
 	io_flush_cached_locked_reqs(ctx, state);
 	io_req_cache_free(&state->free_list);
 	mutex_unlock(&ctx->uring_lock);
-- 
2.33.0

