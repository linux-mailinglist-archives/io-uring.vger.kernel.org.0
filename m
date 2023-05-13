Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06AA37017A8
	for <lists+io-uring@lfdr.de>; Sat, 13 May 2023 16:16:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238993AbjEMOQz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 May 2023 10:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239091AbjEMOQy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 May 2023 10:16:54 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 233E81BD3
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 07:16:53 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1ab125a198dso17072215ad.1
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 07:16:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1683987412; x=1686579412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i7i1Q+mmWPUWbGIul4vuYP4Z7cMnZnct/1f0uEfnrgU=;
        b=iHLLHtMkhpQX0AH0heUj05vnyWTNv4B4oN7gxOHndYAGErYiflrvtiSU37Cd0cCyQZ
         IrQT/w0HOIR0zPFBH6d5RcT60C9+4M4E3HkdduiJvnCqDHb+PBEjNrucw31K5zGqqU3u
         oeah4WEdRwouqVYdPvI3PtTgyszt4VBNhoYEOkM6svlfnbb31q3fnUc00LuLkiuEB6lV
         2p5UczVNPjLgPTTzzdZFAmNp7aE2SANc5qpTe62Wm4l8UHdnoumSg3Sr2bmDHgu21Ppt
         TUHq/AKyo5zl+gffZGh4A471jAaXltPzJ1IgppAxSIIwzeWC/IkDsYPfSvVsmQTVRfu3
         WX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683987412; x=1686579412;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i7i1Q+mmWPUWbGIul4vuYP4Z7cMnZnct/1f0uEfnrgU=;
        b=DyybA2V5uxaxv4Kl3gldG2QvgnTEHXnXvtescornLiPeAVcx6ZE2ee1wcy8Wqufl7B
         iIlprDDokiQ6gbedt8WDqRaEQuS56bYNWLYucvfdXQSvJ2C2MDrYHTCwBpM2sPCXqB3m
         Av4sXAS5V2w+Nv6b6Okgy9ZP2sEqubAxhyvtgcIUdeAJQoFil9E9y/y25iI1sv1m5337
         t2SAb/DW2uGlWPOqTCsEN4R1h4zATHe0m37mBVSAB69TjR/Zam5OQ2qsArqN01KVruxd
         JJcaPN5S2Twg+RIgWFxX2W4rXTtXbqhHLD49Pzh8qLekT4QKdfdSyPEntsAVCby1i+1w
         acSw==
X-Gm-Message-State: AC+VfDxsMFKowieiBc6692GfcYb2/vMQGxuH124K3dtdzF3RsfLu4ykn
        IOVYEJvAvhzShOY+tQGMGyINGLTQSogXuZugBts=
X-Google-Smtp-Source: ACHHUZ75bMiEYYDaEnLKakYrjG4OYoaFbrCo2fI6iPv9V62N8JBU9GtZRK2TqDLgG2UvJ7FXcolSDA==
X-Received: by 2002:a17:902:ecd0:b0:1ac:881b:494 with SMTP id a16-20020a170902ecd000b001ac881b0494mr23471093plh.0.1683987412093;
        Sat, 13 May 2023 07:16:52 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o4-20020a63f144000000b00513973a7014sm8360027pgk.12.2023.05.13.07.16.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 May 2023 07:16:51 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring: add ring freeing helper
Date:   Sat, 13 May 2023 08:16:42 -0600
Message-Id: <20230513141643.1037620-4-axboe@kernel.dk>
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

We do rings and sqes separately, move them into a helper that does both
the freeing and clearing of the memory.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6266a870c89f..5433e8d6c481 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2709,6 +2709,14 @@ static void io_mem_free(void *ptr)
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
@@ -2873,8 +2881,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		mmdrop(ctx->mm_account);
 		ctx->mm_account = NULL;
 	}
-	io_mem_free(ctx->rings);
-	io_mem_free(ctx->sq_sqes);
+	io_rings_free(ctx);
 
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
@@ -3703,15 +3710,13 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
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

