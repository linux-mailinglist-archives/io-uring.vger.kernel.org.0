Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED2B66E8531
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 00:48:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231877AbjDSWsP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 18:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbjDSWsL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 18:48:11 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615FD1701
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 15:48:10 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id 98e67ed59e1d1-24b39cb710dso44686a91.0
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 15:48:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681944489; x=1684536489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dtdhxjAc5NE0l6Xm4RKYrbJnPZddgUcv8zlUMpcItGE=;
        b=NG4dx3grn5brYbVxoktphpIpeJfH+bBon5I8CKEuvPKhK1FoRx6AIwwErveKp0Egtc
         Ivjq49TftfQVZw+h6tDmNhihBGO1k3BTZoPZ1xP22Yv1kaQJOPLOmxjk80Jmy5JrxZcI
         tijes1Eb3GhBnrP5YtxtDJd94v9B62+vNF0k2O/boyKeFr8xKGHMq3LT6Q6ebV7uLysd
         zARSRopVTvQ29aAaOMin4bbkKe/BCE72rMnINgOGCZEl+iBiRHWLx3jXUCUjdAMl3j36
         9wtv+k8h2IjLD2wbQVYSeS1iMK+M6Vi2TkItg/++TZuQMEuQbLGfP+yCuzvbb7LnKXSA
         +8Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681944489; x=1684536489;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dtdhxjAc5NE0l6Xm4RKYrbJnPZddgUcv8zlUMpcItGE=;
        b=HO3ku9csGum6YEn6LPAOMPdrNkvihPCdqJ+4Y7ssTFVXsE2JzaLc/j9nJVjk7XMFOv
         kbG8UaQagnmmiP3tcknHR16d/9s1mboLLPCJrMbo25ZGsUjP0uWALeC8BeBuD1UEX6Od
         t90GQI1RfMwpFrrXe1b9cuRhbsvs4gRSD9WYpi6MW3jdmhPzxsPBBRhRj1ZE8vKnfhvB
         BxFi7+gJWvQvJz0JoTckP8wE4eg1eyx/mLdJNgjJQ8u8B3OsChoUHRrFbNwC9iWr8jni
         +eZzwSWvlMxZGtuk1OrrjBUykOPci9ek02XSNJiBcPdrFj+KoT0q/As/B5AWdpxFKqdr
         nr2g==
X-Gm-Message-State: AAQBX9dDYufSV7D7GqPvEYRY52WJGmOFSlLMCNfnrSWudDN9Gq1VCkcE
        ivnLW0DL+D5H6k8XwVb7/xLxNLf6sYS9+9wF0Pw=
X-Google-Smtp-Source: AKy350bjXstxUBducg3D8WMXEwadmbG3MedYpok4UDgTfpycuwWDYZLkHh+QAwF/rb68j41MMEK//Q==
X-Received: by 2002:a17:90a:1d5:b0:246:fa2b:91be with SMTP id 21-20020a17090a01d500b00246fa2b91bemr16882360pjd.3.1681944489513;
        Wed, 19 Apr 2023 15:48:09 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l9-20020a17090a49c900b002353082958csm1853364pjm.10.2023.04.19.15.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:48:08 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: return error pointer from io_mem_alloc()
Date:   Wed, 19 Apr 2023 16:48:03 -0600
Message-Id: <20230419224805.693734-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230419224805.693734-1-axboe@kernel.dk>
References: <20230419224805.693734-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for having more than one time of ring allocator, make the
existing one return valid/error-pointer rather than just NULL.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7b4f3eb16a73..13faa3115eb5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2719,8 +2719,12 @@ static void io_mem_free(void *ptr)
 static void *io_mem_alloc(size_t size)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
+	void *ret;
 
-	return (void *) __get_free_pages(gfp, get_order(size));
+	ret = (void *) __get_free_pages(gfp, get_order(size));
+	if (ret)
+		return ret;
+	return ERR_PTR(-ENOMEM);
 }
 
 static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries,
@@ -3686,6 +3690,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 {
 	struct io_rings *rings;
 	size_t size, sq_array_offset;
+	void *ptr;
 
 	/* make sure these are sane, as we already accounted them */
 	ctx->sq_entries = p->sq_entries;
@@ -3696,8 +3701,8 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 		return -EOVERFLOW;
 
 	rings = io_mem_alloc(size);
-	if (!rings)
-		return -ENOMEM;
+	if (IS_ERR(rings))
+		return PTR_ERR(rings);
 
 	ctx->rings = rings;
 	ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
@@ -3716,13 +3721,14 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 		return -EOVERFLOW;
 	}
 
-	ctx->sq_sqes = io_mem_alloc(size);
-	if (!ctx->sq_sqes) {
+	ptr = io_mem_alloc(size);
+	if (IS_ERR(ptr)) {
 		io_mem_free(ctx->rings);
 		ctx->rings = NULL;
-		return -ENOMEM;
+		return PTR_ERR(ptr);
 	}
 
+	ctx->sq_sqes = io_mem_alloc(size);
 	return 0;
 }
 
-- 
2.39.2

