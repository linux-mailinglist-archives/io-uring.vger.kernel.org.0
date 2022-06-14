Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 363FE54B0ED
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238220AbiFNMef (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:34:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239463AbiFNMeW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:34:22 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143644BBA1
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:31:00 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id m32-20020a05600c3b2000b0039756bb41f2so4707088wms.3
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VdgQMW5jxhkuYvwndjirbk6yyzG8N1G9hnlDD6URUMA=;
        b=fVCBvm47gXMMrJzj71SNlSolJvuiLlBHc3cSeoYssM+tq1s5T9ynml3PmMt+8H3Y9T
         V4+5Cj0Wy5YYUtKACEI0Ss+HNBejPKamoE2YEoSmhMf+9AJQCuNQJFW5Zp7M1WS+go7+
         /aVnu6lk0A9oPxH+z/pg9sPcnrHWhq1q7owPvUbHbbLR0BLRw8K/5PyltjnKKWkelULo
         BuFTxuws1pxGKVAJuUW17SztRmlqIt/6Im5oDdRlvgPrKg1zGaG/YP7VSMgTy3KGxW34
         ceJsCIiWeOjfc90AecLAzWCPxeqUbEAzSXkgF82ejR1pLLk5bdevfe+QiqYuMyhxQOHl
         qcIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VdgQMW5jxhkuYvwndjirbk6yyzG8N1G9hnlDD6URUMA=;
        b=DDqyEjskTI4JNMuBb6obJZoMVj8MI0bHyTLYKpviLrdMcn9j3y0oNDbBioAgfRLKm5
         /9olw5Jh0uxEex/7xYgj6QcjsrPO78z4+gr+rnQkNruXN8iyRjYBJK+oGHsT4tjOErVP
         HOHBQ1KoQk6YKbSAV/d2M6WaBkW/2kpJBIR8LEFjTeKFzq7vYPfzNUEuRbCuj7qBc082
         is2zKwG51iEQuO5bTyaUBjLV3YID4KpkflKIA6s8fVpa0l0vBk9pCTikuHC+7Nj7gE59
         D8QQEo4xriooGzCI1SS2MLkvHX3Vse83JjLGut7WB+gvnIMjX8lD6LDgiZsYn5Uu+UG3
         6Idg==
X-Gm-Message-State: AOAM530nXe0vAVg65WS6bPxz8Fl7uJAxCkRAqu+oOWkSNLij4eEIxODV
        0db2j/nooOPjyHWHs9vdXa7lDdwN7/JyYw==
X-Google-Smtp-Source: ABdhPJyFT+s6sXcTlxPk/OwbTJ/f65jkAL9P1mU3kcqSLcSXHPwgeBvF7fRBfZb5WR6/56xjjRRiPw==
X-Received: by 2002:a7b:c4d8:0:b0:39c:97ed:baa3 with SMTP id g24-20020a7bc4d8000000b0039c97edbaa3mr3912809wmk.58.1655209859274;
        Tue, 14 Jun 2022 05:30:59 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 19/25] io_uring: clean up io_ring_ctx_alloc
Date:   Tue, 14 Jun 2022 13:29:57 +0100
Message-Id: <1dfcb8d34f9e51d6da65cb6aac8e943dfcef86e3.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
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

Add a variable for the number of hash buckets in io_ring_ctx_alloc(),
makes it more readable.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a203943f3d71..89696efcead4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -700,6 +700,8 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 {
 	struct io_ring_ctx *ctx;
+	unsigned hash_buckets;
+	size_t hash_size;
 	int hash_bits;
 
 	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
@@ -715,15 +717,15 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	 */
 	hash_bits = ilog2(p->cq_entries) - 5;
 	hash_bits = clamp(hash_bits, 1, 8);
+	hash_buckets = 1U << hash_bits;
+	hash_size = hash_buckets * sizeof(struct io_hash_bucket);
 
 	ctx->cancel_hash_bits = hash_bits;
-	ctx->cancel_hash =
-		kmalloc((1U << hash_bits) * sizeof(struct io_hash_bucket),
-			GFP_KERNEL);
+	ctx->cancel_hash = kmalloc(hash_size, GFP_KERNEL);
 	if (!ctx->cancel_hash)
 		goto err;
 
-	init_hash_table(ctx->cancel_hash, 1U << hash_bits);
+	init_hash_table(ctx->cancel_hash, hash_buckets);
 
 	ctx->dummy_ubuf = kzalloc(sizeof(*ctx->dummy_ubuf), GFP_KERNEL);
 	if (!ctx->dummy_ubuf)
-- 
2.36.1

