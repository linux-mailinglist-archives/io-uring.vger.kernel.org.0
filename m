Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0315B315AFB
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbhBJATN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:19:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235103AbhBJAKg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:10:36 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C71BC061797
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:25 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id t142so320636wmt.1
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WlPWh9e2xFUMQQMU1SbHggEgjAA69G5D6G/HU4FDShk=;
        b=Mw2smvNKYwvHSQPvVOHRIn4CU0HRJCdjpprqqnT4QwUOZ7OgAPnRK7OcW1smZoQtct
         87UH3VWQToMDF/yW5tDUkk+2p/0kh2nYMMjGD26GUD012J2977jef6SM/iVj0e1HaND5
         jR7rdQSvrqVKKcdN42FT/sBZnrwrtfVkIZSPjm32xkg7W3uQGMOkNTjHd8+R/bYz6F1K
         b1Xz3Qf8gswMP3ZfibRu85qW5REOl8vA+2HiZ0lT9PCxTbgbVRM/5dk9/Ly4NWGU1wyu
         akAJ9jl74p0rPWVY1s1mX3DFb0ucHIRHxOPkSs4KxHc5OjLjwOhg2oCB7NBjjrpw11p6
         Y0XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WlPWh9e2xFUMQQMU1SbHggEgjAA69G5D6G/HU4FDShk=;
        b=t6sgsDzoON10wt++bXW7PK5nSwmvN8BuG/gujO+55nN1JM3FBtXvEBsydWF468BYw7
         /Qan63XaUC3j++1xriPVcE1/X4fshtoSbLZ9LkD0EeJHnNbRWGrSNtjwxgaYufUkpaKg
         U+kg0qQS6GG4fHdeoIpmIUn2VjxKGI2kjxZet5z33LFaHkbXq0N28Sj4q+3zsjcY+KtG
         s3aFP4Vaoxkh2Fg1M8ElzlC3wYlaT8LzU+FDVDkclQVwrN07wLnqOzgtUIU3Oq472flt
         QMmsNzJQOtAT4Lj5p22M1HH/r7zWrM/q4JIVQVNjwyF8/84MbQXML6k3b9lZAtu05zwo
         vECg==
X-Gm-Message-State: AOAM530y/Lu16ZS1YqUFrImjjyrApfKXilc4cknp+29BwDN+caZSW5xB
        5by4FpYyncvaQ5/KH+BZUho=
X-Google-Smtp-Source: ABdhPJy4pStZCM//UD1qWWayHosp2f2zZ9Y9vxiX+5nBav/aNyXvQhf9/UpYDJ/UzeOlQZiwDw5lPA==
X-Received: by 2002:a1c:c308:: with SMTP id t8mr462646wmf.7.1612915643972;
        Tue, 09 Feb 2021 16:07:23 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/17] io_uring: remove fallback_req
Date:   Wed, 10 Feb 2021 00:03:15 +0000
Message-Id: <4279aff3ed81e20bdf6a7c12af8e876305369c65.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Remove fallback_req for now, it gets in the way of other changes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 38 ++------------------------------------
 1 file changed, 2 insertions(+), 36 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ed4c92f64d96..be940db96fb8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -386,9 +386,6 @@ struct io_ring_ctx {
 	struct completion	ref_comp;
 	struct completion	sq_thread_comp;
 
-	/* if all else fails... */
-	struct io_kiocb		*fallback_req;
-
 #if defined(CONFIG_UNIX)
 	struct socket		*ring_sock;
 #endif
@@ -1303,10 +1300,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	if (!ctx)
 		return NULL;
 
-	ctx->fallback_req = kmem_cache_alloc(req_cachep, GFP_KERNEL);
-	if (!ctx->fallback_req)
-		goto err;
-
 	/*
 	 * Use 5 bits less than the max cq entries, that should give us around
 	 * 32 entries per hash list if totally full and uniformly spread.
@@ -1354,8 +1347,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	submit_state->free_reqs = 0;
 	return ctx;
 err:
-	if (ctx->fallback_req)
-		kmem_cache_free(req_cachep, ctx->fallback_req);
 	kfree(ctx->cancel_hash);
 	kfree(ctx);
 	return NULL;
@@ -1953,23 +1944,6 @@ static inline void io_req_complete(struct io_kiocb *req, long res)
 	__io_req_complete(req, 0, res, 0);
 }
 
-static inline bool io_is_fallback_req(struct io_kiocb *req)
-{
-	return req == (struct io_kiocb *)
-			((unsigned long) req->ctx->fallback_req & ~1UL);
-}
-
-static struct io_kiocb *io_get_fallback_req(struct io_ring_ctx *ctx)
-{
-	struct io_kiocb *req;
-
-	req = ctx->fallback_req;
-	if (!test_and_set_bit_lock(0, (unsigned long *) &ctx->fallback_req))
-		return req;
-
-	return NULL;
-}
-
 static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
@@ -1989,7 +1963,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 		if (unlikely(ret <= 0)) {
 			state->reqs[0] = kmem_cache_alloc(req_cachep, gfp);
 			if (!state->reqs[0])
-				return io_get_fallback_req(ctx);
+				return NULL;
 			ret = 1;
 		}
 		state->free_reqs = ret;
@@ -2036,10 +2010,7 @@ static void __io_free_req(struct io_kiocb *req)
 	io_dismantle_req(req);
 	io_put_task(req->task, 1);
 
-	if (likely(!io_is_fallback_req(req)))
-		kmem_cache_free(req_cachep, req);
-	else
-		clear_bit_unlock(0, (unsigned long *) &ctx->fallback_req);
+	kmem_cache_free(req_cachep, req);
 	percpu_ref_put(&ctx->refs);
 }
 
@@ -2295,10 +2266,6 @@ static void io_req_free_batch_finish(struct io_ring_ctx *ctx,
 
 static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req)
 {
-	if (unlikely(io_is_fallback_req(req))) {
-		io_free_req(req);
-		return;
-	}
 	io_queue_next(req);
 
 	if (req->task != rb->task) {
@@ -8707,7 +8674,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	free_uid(ctx->user);
 	put_cred(ctx->creds);
 	kfree(ctx->cancel_hash);
-	kmem_cache_free(req_cachep, ctx->fallback_req);
 	kfree(ctx);
 }
 
-- 
2.24.0

