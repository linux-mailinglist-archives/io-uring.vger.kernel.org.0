Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B456E8532
	for <lists+io-uring@lfdr.de>; Thu, 20 Apr 2023 00:48:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232125AbjDSWsS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Apr 2023 18:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231543AbjDSWsN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Apr 2023 18:48:13 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5516D1703
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 15:48:11 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-2470f9acb51so57478a91.0
        for <io-uring@vger.kernel.org>; Wed, 19 Apr 2023 15:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681944490; x=1684536490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PBUBPDrWetaBK6Buf5vqOOjXplexDaTAi8W+z5Uki0s=;
        b=sfQhV0a3DxY6PGcv4MQakd2ACpOcQuhQFLyf5eXRaFv8UWEdcfRAOjKtJ7FtQKJu16
         mJktGFLK86iKuIYHD94qpc/QpV3BpUqoYuMcrhpGppDSU21HlmJ/AhRVfVBOdEYbHP8H
         8kI2pJGUtcCYQz9yLpLKLOY7tZ/1Kcw3Kft2WHNqXyen1gl7cE0MbEkR4XARPXzUxSiu
         6xilrEwB06hWpz3a4bWV8ENhKkLMw3VwN03hsdxN+syQZIxg89SBPkU7QCU3yxPE5GLv
         oSfjEQGAF72+VLz94NaCr8veX+abwxk4Kgw8R93jqOaVC++i9BbYI0gXUbIgiLr3Rmc/
         BYEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681944490; x=1684536490;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PBUBPDrWetaBK6Buf5vqOOjXplexDaTAi8W+z5Uki0s=;
        b=FLepo1kf7clyZzK3kNrqEYQCRhtJODbBaUPqK0AMB5wuDpFOJCYymTcPlL6eulJabX
         o7usTCGH3A8Yg9dWjrYiDvGvrkUKxGBDwIOdGYXq9EnzHZrjYuTgSavAk44HqyXTiZdM
         STcIXCcQHhV3bAeFtehNzDXHbmP2EEEQ2qorEyh+4kAngfuZzbzNA8OdrI6C8xdpOmOq
         x6p9cos8LU1EEFtrQL+D14Kz4PO2IzcQsboUo0i+ES7aCW/Q8TDwIHS2Yf6BsnQkfs+B
         pgODdTDj61KPLKwn5Y7JWyCPaV7vgwHWRkL4pB3sJ2YIUJVTBrE5ZL5XT9tCBHJNN2IG
         PICg==
X-Gm-Message-State: AAQBX9dQfYpoBd8hBD20dL1sMYxCLfAih3UVpbRx6GhCsEmOjtz57E6l
        qZutrbDfYtERkswU8QKrQ5fl7i2njElMV90iw6o=
X-Google-Smtp-Source: AKy350a1TdIDOWyn6ozc9Tn4NsHTxS1VTx2H5UfloYPXaco7h28fSTcllo53q2HHhSFw6qUTcpU/dA==
X-Received: by 2002:a17:90a:1a17:b0:247:9e56:d895 with SMTP id 23-20020a17090a1a1700b002479e56d895mr9267079pjk.1.1681944490416;
        Wed, 19 Apr 2023 15:48:10 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l9-20020a17090a49c900b002353082958csm1853364pjm.10.2023.04.19.15.48.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 15:48:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: add ring freeing helper
Date:   Wed, 19 Apr 2023 16:48:04 -0600
Message-Id: <20230419224805.693734-4-axboe@kernel.dk>
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

We do rings and sqes separately, move them into a helper that does both
the freeing and clearing of the memory.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 13faa3115eb5..cf570b0f82ec 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2716,6 +2716,14 @@ static void io_mem_free(void *ptr)
 		free_compound_page(page);
 }
 
+static void io_rings_free(struct io_ring_ctx *ctx)
+{
+	io_mem_free(ctx->rings);
+	io_mem_free(ctx->sq_sqes);
+	ctx->rings = NULL;
+	ctx->sq_sqes = NULL;
+}
+
 static void *io_mem_alloc(size_t size)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
@@ -2880,8 +2888,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		mmdrop(ctx->mm_account);
 		ctx->mm_account = NULL;
 	}
-	io_mem_free(ctx->rings);
-	io_mem_free(ctx->sq_sqes);
+	io_rings_free(ctx);
 
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
@@ -3716,15 +3723,13 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	else
 		size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
 	if (size == SIZE_MAX) {
-		io_mem_free(ctx->rings);
-		ctx->rings = NULL;
+		io_rings_free(ctx);
 		return -EOVERFLOW;
 	}
 
 	ptr = io_mem_alloc(size);
 	if (IS_ERR(ptr)) {
-		io_mem_free(ctx->rings);
-		ctx->rings = NULL;
+		io_rings_free(ctx);
 		return PTR_ERR(ptr);
 	}
 
-- 
2.39.2

