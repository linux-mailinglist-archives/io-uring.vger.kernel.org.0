Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CC16B247B
	for <lists+io-uring@lfdr.de>; Thu,  9 Mar 2023 13:48:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbjCIMsT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 07:48:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229523AbjCIMsS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 07:48:18 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 663D632508
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 04:48:15 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id ay14so6409584edb.11
        for <io-uring@vger.kernel.org>; Thu, 09 Mar 2023 04:48:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678366093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=qYW69VXMrB8BTi+TpKpEk2bY2FrQYn+mQWPZ3R6CtJU=;
        b=eVAIP76xJeqAsM6fcnzcyjI5sNYH+S0ZelHZBEwgFnOGob9vHO8QrtmAnOjVOx8JXJ
         4Vth3Gr2cFjq5Kjy6Ht/8fY0mldqrTjKq6fFzCSyI1ZwPmga+MYH/+AFh52yI5lYRHPe
         KH8hZ/3nU/xVQctxNgVB1NV3RSJ2BpaH+lypUfIoj6UvHAgAEGo7x+UVED5mwgj31iDh
         i7BOs/GgEAvSSx5PYu7TrgZeXFiU9OzeCugMu/9Ovj1D4cUqi/u/nkiKWYBu39EA/89L
         a8Szoo0Y66Y2uue8a9bY2j0kMLM0ucFeodvtZjdt//GyzeqGDLioby7apjpPtraTqo1s
         NDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678366093;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qYW69VXMrB8BTi+TpKpEk2bY2FrQYn+mQWPZ3R6CtJU=;
        b=BN4QOmHkpTvkAOz1OuzNOCgBf86J9L8PCgnkGHDcgRFJuJ+qpD8CvER45/nGJWtnP+
         IztXw6VcWu8k5X4Zd6rItSPIPN0UF0ROh2PWt+/nhCU4UFt1Dorcb4WOLKA9KSbnm7o+
         qoyhgs/TBdlLajsNNecxwY8bl3srYyuOQdIY01XY5kY0WdCetFNes9YqLaT8Kwrr7Mlv
         hP8/TqhG73em2fkaz9Sekzj/0XByoLY2A9n75ajjAThAhVO58NkbQ8jfSkFdLhTNSFVY
         IkqPfYXMO4R0slramV/USGHHBVdtEcNGKyGq64BHUHPa9kKVbkCG9U2vznaX2sEuPUiG
         RVow==
X-Gm-Message-State: AO0yUKVK4oO9ydXyhe1oKoO3dSORX+UkymuiUnKBlZW8AxuxsUiTS4er
        6T+rY7/mrrx2bIFB0CAFi+vO3SnrHCSaCQ==
X-Google-Smtp-Source: AK7set9zUk/utqrhzaR3TNzJwo64u/kmpA2rC7I3JHHW4TiODmGMTSE6y4TAFaqpL3qQRAL3m9tPlg==
X-Received: by 2002:a17:906:2da2:b0:889:7781:f62e with SMTP id g2-20020a1709062da200b008897781f62emr20385151eji.22.1678366093557;
        Thu, 09 Mar 2023 04:48:13 -0800 (PST)
Received: from localhost.localdomain ([2001:b07:5d37:537d:5e25:9ef5:7977:d60c])
        by smtp.gmail.com with ESMTPSA id f27-20020a50a6db000000b004acc61206cfsm9581675edc.33.2023.03.09.04.48.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 04:48:12 -0800 (PST)
From:   Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Subject: [PATCH v1] io_uring: suppress an unused warning
Date:   Thu,  9 Mar 2023 13:47:58 +0100
Message-Id: <20230309124758.158474-1-vincenzopalazzodev@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

suppress unused warnings and fix the error that there is
with the W=1 enabled.

Warning generated

io_uring/io_uring.c: In function ‘__io_submit_flush_completions’:
io_uring/io_uring.c:1502:40: error: variable ‘prev’ set but not used [-Werror=unused-but-set-variable]
 1502 |         struct io_wq_work_node *node, *prev;

Signed-off-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fd1cc35a1c00..f2fd13043e12 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1499,7 +1499,7 @@ void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node)
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
-	struct io_wq_work_node *node, *prev;
+	struct io_wq_work_node *node, *prev UNUSED;
 	struct io_submit_state *state = &ctx->submit_state;
 
 	__io_cq_lock(ctx);
-- 
2.39.2

