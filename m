Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D70E54FE376
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 16:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238543AbiDLOM6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 10:12:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355270AbiDLOM4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 10:12:56 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4041CFD4
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:38 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id c7so27995143wrd.0
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Smn05f5Tu+EeP6C8DNfy0/wo2TZIZjGZdIk2Y/5RMjk=;
        b=SZ6BtjCWt4eQsgb9IMINk1uMKRnG+roh9vWqC4rIrkNQaN5egMPaVy0Y5ddxtzuLtd
         Xg29PZeg0Dqywg0/RFYj/WZn5Cgsa6fk7u04CLRj3HAetPn9EBEdj8hkjKEQzUKAJhXI
         kPWdEjKEaJw1UQwuo9CgsZ96TG5TaQ885zX6Pc4XnurfBWV9qzjPAoDtAfgYXNj4goN+
         +H4boTkKKRa790/RM47AIDvJ0B752sChGgqZH5XBfAGi0l/UxcUQfpSmmQ/B5sh4NgSb
         FFX9FRgrfsd/0y8FImbchqWwWYktyZHmqKYZ8lZ+bUYAMnUeC7XofKnk8JvnY4ABzILJ
         2tAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Smn05f5Tu+EeP6C8DNfy0/wo2TZIZjGZdIk2Y/5RMjk=;
        b=RpPFl+vw3Ou/b9cWXxzncocnpraMrTVF2uCm2KKWFQ4eTZRNmbj2FSzmfCjtKeYCsV
         qybfHhYjBO+z1BqjGWg8tGtCKSBrgDC42w4YK5SBZxeZTP+BWmpuvek/JK3T//aeepJ5
         pzd4v8ctAI9Qdn1iNeg4TZdmTJn6XOeeZrE/cPFUqah4wn3PMdvUny/O7XAkz7pSxpxq
         oL8EfI7yA8xvKyCI7UDOoMJDn1r0mvbtf6bT/5YA4DdgEoHqQ5QrclSIDNWoDY92tf1h
         NWVEMsjt3EzfTx1a7zPAt21KP0anaI48DzK4M0Zn1x6Np9zpECVIBAPZ8ufII1+nhKwi
         5Tgw==
X-Gm-Message-State: AOAM533ndeXPO1p/usEBdIK8b+wbrvXPKEVXl8RS5OeJdHzdh2BW5zGm
        aRX6C7alHBCdy6jTpCrDKucxkUJGPx8=
X-Google-Smtp-Source: ABdhPJzdoNUmfiVNtaQ+Cxs2a++I6YTTWOekWtSGdqvp2oeKnK6eZ0FI75dscxhGfX7YAAPUJTxBSg==
X-Received: by 2002:adf:ffd2:0:b0:207:afb7:f81b with SMTP id x18-20020adfffd2000000b00207afb7f81bmr2365822wrs.531.1649772637083;
        Tue, 12 Apr 2022 07:10:37 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.222])
        by smtp.gmail.com with ESMTPSA id ay41-20020a05600c1e2900b0038e75fda4edsm2363703wmb.47.2022.04.12.07.10.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 07:10:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/9] io_uring: inline io_flush_cached_reqs
Date:   Tue, 12 Apr 2022 15:09:46 +0100
Message-Id: <ec38abe65a883d9fe6b169793119ce86806655a4.1649771823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649771823.git.asml.silence@gmail.com>
References: <cover.1649771823.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_flush_cached_reqs() isn't descriptive and has only one caller, inline
it into __io_alloc_req_refill().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d996d7f82d5d..73422af2dd79 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2211,21 +2211,6 @@ static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 	spin_unlock(&ctx->completion_lock);
 }
 
-/* Returns true IFF there are requests in the cache */
-static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
-{
-	struct io_submit_state *state = &ctx->submit_state;
-
-	/*
-	 * If we have more than a batch's worth of requests in our IRQ side
-	 * locked cache, grab the lock and move them over to our submission
-	 * side cache.
-	 */
-	if (READ_ONCE(ctx->locked_free_nr) > IO_COMPL_BATCH)
-		io_flush_cached_locked_reqs(ctx, state);
-	return !!state->free_list.next;
-}
-
 /*
  * A request might get retired back into the request caches even before opcode
  * handlers and io_issue_sqe() are done with it, e.g. inline completion path.
@@ -2238,11 +2223,18 @@ static __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	struct io_submit_state *state = &ctx->submit_state;
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
 	void *reqs[IO_REQ_ALLOC_BATCH];
-	struct io_kiocb *req;
 	int ret, i;
 
-	if (likely(state->free_list.next || io_flush_cached_reqs(ctx)))
-		return true;
+	/*
+	 * If we have more than a batch's worth of requests in our IRQ side
+	 * locked cache, grab the lock and move them over to our submission
+	 * side cache.
+	 */
+	if (READ_ONCE(ctx->locked_free_nr) > IO_COMPL_BATCH) {
+		io_flush_cached_locked_reqs(ctx, &ctx->submit_state);
+		if (state->free_list.next)
+			return true;
+	}
 
 	ret = kmem_cache_alloc_bulk(req_cachep, gfp, ARRAY_SIZE(reqs), reqs);
 
@@ -2259,7 +2251,7 @@ static __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 
 	percpu_ref_get_many(&ctx->refs, ret);
 	for (i = 0; i < ret; i++) {
-		req = reqs[i];
+		struct io_kiocb *req = reqs[i];
 
 		io_preinit_req(req, ctx);
 		wq_stack_add_head(&req->comp_list, &state->free_list);
-- 
2.35.1

