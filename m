Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6D241C2C86
	for <lists+io-uring@lfdr.de>; Sun,  3 May 2020 14:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728378AbgECMxW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 May 2020 08:53:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728230AbgECMxV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 May 2020 08:53:21 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 843C3C061A0C
        for <io-uring@vger.kernel.org>; Sun,  3 May 2020 05:53:21 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id h4so5262238wmb.4
        for <io-uring@vger.kernel.org>; Sun, 03 May 2020 05:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=90yuMHeVCjpWeQC8vkFNrnj3KA/89tq32NRVSgV09AQ=;
        b=jJG/p43Xv7XonEuEyWT4AGRVlCknt48oPhcJHmb7IAm8OYmzsUP4pkbrYJatq5RbrI
         NOdNW5PgMtmEtn7/w0Ybx2vQ6iAI11FuBp1/aYnaAqJ6eM0MSy8fFvQ4Ivf+V8Gudq/f
         Fd9G5c4WEmAuvCxQFMm3+mko1c0s7X/01hZx/jSDIdJFGbvwsCgGTNH3mZtwtLqAHe/x
         yoi4oYT6o98utmzMLfKoQvQiQKcTvfnt3RYzVw1GQ7WAOcLgJn7yW0susw9r5F2n+EVx
         5QNjC8uvwwGI58eciZj/HfqNz1DJe9C5HP4HoHK0u/P+dAZDzrPnzgOa0xSb2AudvkGW
         UrYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=90yuMHeVCjpWeQC8vkFNrnj3KA/89tq32NRVSgV09AQ=;
        b=qGQzsr5eUOFztRMd7Gz7xnxniweuUNfRu+TQdrXYWjIFa+CEjZMD6yRIhbz1RVMH8v
         LrXi9Lxi2BGazAKHQPQQJRYmb4Rm1YLGBS6QiM10vUlYnLyHKrRjao4atX26RLDJTqAs
         ov5nJXIthUb0apHJONyjpr9aOBLXumb4GJ96SE69AKiW3Rb3ZLAoq59+O9kXSD16zHhT
         iw9NAHNGTdiiFwHxVwOWBBPd4hVCUOOIw1ulaJ7wbjYPtGqenogX5LBa1uTMVOpTH6hN
         EYd+x76gbYWw1r945YSn4kJyspv55Bwkt4l94NQ4p9e2shkweNgstzQpIq4p3mEb9nyU
         zAOA==
X-Gm-Message-State: AGi0PuYCUcFI5kKfZoylVq6JglCSl+ujuAGCj6jKiwo7l5KX6pY9xREo
        g/R9JYxjlQZKjJ38wnQC79cteMu4
X-Google-Smtp-Source: APiQypJzDxEMhB8+GDXbzwr1AfXNs4KmyEMbn6FJSap+AQBVJ95ex3X46t6STXtO/r+8Wq6dXqZR4g==
X-Received: by 2002:a1c:4d18:: with SMTP id o24mr8840471wmh.141.1588510399732;
        Sun, 03 May 2020 05:53:19 -0700 (PDT)
Received: from [192.168.43.133] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id 1sm8992275wmz.13.2020.05.03.05.53.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 May 2020 05:53:19 -0700 (PDT)
To:     Jens Axboe <axboe@kernel.dk>,
        Bijan Mottahedeh <bijan.mottahedeh@oracle.com>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <1588207670-65832-1-git-send-email-bijan.mottahedeh@oracle.com>
 <05997981-047c-a87b-c875-6ea7b229f586@kernel.dk>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 1/1] io_uring: use proper references for fallback_req
 locking
Message-ID: <07fda8ac-93e4-e488-0575-026b339d2c36@gmail.com>
Date:   Sun, 3 May 2020 15:52:13 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <05997981-047c-a87b-c875-6ea7b229f586@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/04/2020 17:52, Jens Axboe wrote:
> On 4/29/20 6:47 PM, Bijan Mottahedeh wrote:
>> Use ctx->fallback_req address for test_and_set_bit_lock() and
>> clear_bit_unlock().
> 
> Thanks, applied.
> 

How about getting rid of it? As once was fairly noticed, we're screwed in many
other ways in case of OOM. Otherwise we at least need to make async context
allocation more resilient.


Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b699e9a8d247..62f9709565d0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -282,9 +282,6 @@ struct io_ring_ctx {
 	/* 0 is for ctx quiesce/reinit/free, 1 is for sqo_thread started */
 	struct completion	*completions;

-	/* if all else fails... */
-	struct io_kiocb		*fallback_req;
-
 #if defined(CONFIG_UNIX)
 	struct socket		*ring_sock;
 #endif
@@ -911,10 +908,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct
io_uring_params *p)
 	if (!ctx)
 		return NULL;

-	ctx->fallback_req = kmem_cache_alloc(req_cachep, GFP_KERNEL);
-	if (!ctx->fallback_req)
-		goto err;
-
 	ctx->completions = kmalloc(2 * sizeof(struct completion), GFP_KERNEL);
 	if (!ctx->completions)
 		goto err;
@@ -956,8 +949,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct
io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->inflight_list);
 	return ctx;
 err:
-	if (ctx->fallback_req)
-		kmem_cache_free(req_cachep, ctx->fallback_req);
 	kfree(ctx->completions);
 	kfree(ctx->cancel_hash);
 	kfree(ctx);
@@ -1308,34 +1299,16 @@ static void io_cqring_add_event(struct io_kiocb *req,
long res)
 	__io_cqring_add_event(req, res, 0);
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
 static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
 				     struct io_submit_state *state)
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	struct io_kiocb *req;

-	if (!state) {
-		req = kmem_cache_alloc(req_cachep, gfp);
-		if (unlikely(!req))
-			goto fallback;
-	} else if (!state->free_reqs) {
+	if (!state)
+		return kmem_cache_alloc(req_cachep, gfp);
+
+	if (!state->free_reqs) {
 		size_t sz;
 		int ret;

@@ -1349,7 +1322,7 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
 		if (unlikely(ret <= 0)) {
 			state->reqs[0] = kmem_cache_alloc(req_cachep, gfp);
 			if (!state->reqs[0])
-				goto fallback;
+				return NULL;
 			ret = 1;
 		}
 		state->free_reqs = ret - 1;
@@ -1360,8 +1333,6 @@ static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx,
 	}

 	return req;
-fallback:
-	return io_get_fallback_req(ctx);
 }

 static inline void io_put_file(struct io_kiocb *req, struct file *file,
@@ -1403,10 +1374,7 @@ static void __io_free_req(struct io_kiocb *req)
 	}

 	percpu_ref_put(&req->ctx->refs);
-	if (likely(!io_is_fallback_req(req)))
-		kmem_cache_free(req_cachep, req);
-	else
-		clear_bit_unlock(0, (unsigned long *) &req->ctx->fallback_req);
+	kmem_cache_free(req_cachep, req);
 }

 struct req_batch {
@@ -1699,7 +1667,7 @@ static inline unsigned int io_sqring_entries(struct
io_ring_ctx *ctx)

 static inline bool io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
 {
-	if ((req->flags & REQ_F_LINK_HEAD) || io_is_fallback_req(req))
+	if (req->flags & REQ_F_LINK_HEAD)
 		return false;

 	if (!(req->flags & REQ_F_FIXED_FILE) || req->io)
@@ -7296,7 +7264,6 @@ static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	put_cred(ctx->creds);
 	kfree(ctx->completions);
 	kfree(ctx->cancel_hash);
-	kmem_cache_free(req_cachep, ctx->fallback_req);
 	kfree(ctx);
 }

