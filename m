Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A930F7017A7
	for <lists+io-uring@lfdr.de>; Sat, 13 May 2023 16:16:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239014AbjEMOQy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 May 2023 10:16:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238993AbjEMOQw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 May 2023 10:16:52 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B67731720
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 07:16:51 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-6439e53ed82so1823011b3a.1
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 07:16:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683987411; x=1686579411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rt2hcdeuCY3fd8kRdAhLT1/J1gq2onluDKK2fZ7hxuU=;
        b=w0bpJFdrHUABzxWzCUfBfYZ03Hw1vC9RDFz64m6GKh6f0dUV6iKfjT/92OO3eSxjno
         z5csGPZKaxW8S3uZXZkxquUnu+/1LY/go3iwrXehfwc/3o8q7v5HDHFxD4yxTWg8ubLx
         G44rSxQrFuhWDto9xVLDQsYmg+Z+yvlp2ThKom+I33yB0IowQA8bFPw62+SAHZeMcUYP
         ySkbQulo27HjnvEtcXeWR2fFUXUh5WMvPeLdpIxyT7oqtgEXUvifMjRkFpTyhk/pono3
         TwBzSMzTlXXyU26xwxCOgtlPze4lXNgcU5UaRORcqwGMzI8/5PIArcu7UcUBa3gH4rKt
         2uFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683987411; x=1686579411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rt2hcdeuCY3fd8kRdAhLT1/J1gq2onluDKK2fZ7hxuU=;
        b=W82uFJUxBbqotsu5iHRHPHgtr+aPXHOOjVGj+V3AUaA1V9YtL8u6yTSp+j+/omNeaR
         HxE7eLPfKc4kdWSPKngJaCLohf9rNqK1AAFsoQJYUcreEKgqZ2dJmJtdffaWbnlDPL5t
         +Kwm7BrYleGEODSL3JY9D907xZn/zhZikozcsx0d/PtwW43jM6HU7n5w1CXINYe4Qopz
         ElP2fInB5KscXZme+KgdUUzcOe3kONBRXhbV0VhzT2hlcgztHYdF3iSCaL5a7un9Fmsn
         /PjZmo6mM1Uf2PPE3wrmhNhMJbFcfSxxIVu6JbNgK64lptBh7VA9XSjhQWEy0tn6MbDB
         luHg==
X-Gm-Message-State: AC+VfDyhn4SEw8Jt/28J0t/yiCtfOL6uao9mmvYYMH14zMNSoTy5UcwO
        ef98ZT51jQpaXZmrtTZiw5i3HEFf5SJBl3D4tdc=
X-Google-Smtp-Source: ACHHUZ529zWNCJmHFzzHJwuxZFpYDSnAPPVVCVqeBskn8n7wH68Kr8jdrDQ99lSlFSEUbgYKw6k6Ow==
X-Received: by 2002:a05:6a20:12ce:b0:105:66d3:854d with SMTP id v14-20020a056a2012ce00b0010566d3854dmr692198pzg.6.1683987410771;
        Sat, 13 May 2023 07:16:50 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o4-20020a63f144000000b00513973a7014sm8360027pgk.12.2023.05.13.07.16.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 07:16:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: return error pointer from io_mem_alloc()
Date:   Sat, 13 May 2023 08:16:41 -0600
Message-Id: <20230513141643.1037620-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230513141643.1037620-1-axboe@kernel.dk>
References: <20230513141643.1037620-1-axboe@kernel.dk>
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
index 3695c5e6fbf0..6266a870c89f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2712,8 +2712,12 @@ static void io_mem_free(void *ptr)
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
@@ -3673,6 +3677,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 {
 	struct io_rings *rings;
 	size_t size, sq_array_offset;
+	void *ptr;
 
 	/* make sure these are sane, as we already accounted them */
 	ctx->sq_entries = p->sq_entries;
@@ -3683,8 +3688,8 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 		return -EOVERFLOW;
 
 	rings = io_mem_alloc(size);
-	if (!rings)
-		return -ENOMEM;
+	if (IS_ERR(rings))
+		return PTR_ERR(rings);
 
 	ctx->rings = rings;
 	ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
@@ -3703,13 +3708,14 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
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

