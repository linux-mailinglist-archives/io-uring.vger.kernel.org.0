Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27A68417CAC
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348465AbhIXVCh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231531AbhIXVC3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:29 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DD3C061571
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:55 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id g8so40857779edt.7
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XP7GEAJwOBQ/BeCVayiLXFwPF0VSpNv88Q0SNiN1YY4=;
        b=Rua9bgHAwYmCH8taLTUOV+34s8yuX58opdSzbtgqKmfws/0EZ2FE4tw8eHr5UJVT+6
         uAr5tLql8kMLsAeHA3ZXHbUjqFiIsKbwbEr0Gx2LHlaStbpbCDc0ZQ1JEQud89Wga1PD
         LZ1APvF4wjmTcHNyxFumjBMRrAVKDVz9+F0aYqr+sBymfgAfZKvUo+GrMYyrvE87nINU
         1zBMP2C1PbOVTBQbxX+4AHGjjXDuGZOJVxopajScUZBiUSLUih9p9Y5O9S/i6MwLPXSL
         dNdczdB8z/l1tbfaf73o5Iz0ToNcqAsMUzwmGQhQWOEZG/Z6zJjmpHD+QSlCYUad8bdZ
         AV2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XP7GEAJwOBQ/BeCVayiLXFwPF0VSpNv88Q0SNiN1YY4=;
        b=6DwvWOjNNzivlCD7MUeWgTeqED+hfWnnRJhRqxKNQqfGYVD7Ob3m6sVhsPra/INrL9
         4wjfgy3Pw33ylwEbOrUscVzZ3MRipYov21TRKfz6UF8s0QPEzf9hh9SxU842o7VguIk4
         DAcrlt34/PL3oKoT4SWDDBTgxI0LMOw3FYoRLWqy791RKbk4mU2gjpZVndsilz3aHDwO
         mA41qColJ59EXqYL+5vhv0Gpf0b7+T4UehXwm/02SPSThAsddHexFUGsgfwm96RHzJuX
         GyXSASOC72LmW2JRWmUkuVxFIsCFrS2QNL1UyPc9NDHUU3gSjwYBakYBqkX/CcmBujmQ
         2RPQ==
X-Gm-Message-State: AOAM531DXAptwuAfNyGZmAIKuvszKPW7flg7aLTV1LrOgs9b5W1SyPSD
        4i74JcmSpIOuz3ZyODKOur9P/BOojQQ=
X-Google-Smtp-Source: ABdhPJzC0RQMxHq8Uk9S6kudvmtGZsI9CtDv6cChQ0iPTN1gEp0j4lRfy9U2gC/JHYR+CbgV6lvLcw==
X-Received: by 2002:a17:906:d287:: with SMTP id ay7mr13551349ejb.402.1632517254097;
        Fri, 24 Sep 2021 14:00:54 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:00:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 05/24] io_uring: remove allocation cache array
Date:   Fri, 24 Sep 2021 21:59:45 +0100
Message-Id: <8547095c35f7a87bab14f6447ecd30a273ed7500.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
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
index 9a76c4f84311..9d8d79104d75 100644
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
 
@@ -1903,7 +1897,6 @@ static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
-	int nr;
 
 	/*
 	 * If we have more than a batch's worth of requests in our IRQ side
@@ -1912,20 +1905,7 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
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
@@ -1939,33 +1919,36 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
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
@@ -2323,10 +2306,7 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 	rb->task_refs++;
 	rb->ctx_refs++;
 
-	if (state->free_reqs != ARRAY_SIZE(state->reqs))
-		state->reqs[state->free_reqs++] = req;
-	else
-		list_add(&req->inflight_entry, &state->free_list);
+	list_add(&req->inflight_entry, &state->free_list);
 }
 
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
@@ -9235,12 +9215,6 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
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

