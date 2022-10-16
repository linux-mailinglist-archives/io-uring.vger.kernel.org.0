Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A183A600346
	for <lists+io-uring@lfdr.de>; Sun, 16 Oct 2022 22:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiJPUdI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Oct 2022 16:33:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJPUdH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Oct 2022 16:33:07 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1938230F5F
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 13:33:06 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id bj12so20785202ejb.13
        for <io-uring@vger.kernel.org>; Sun, 16 Oct 2022 13:33:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7kJ/8KrJtwWrQtL3HJvPRSeBswfmXX7pgLh8LlFHkeQ=;
        b=MJNd//DhY0B1B5RJxLzgCAoHw+3v3pyAxsGF76IoSXh/SXEZ06yhQcB00VCCsMNfAY
         l57EeWVAtu4lBstcGIAEja/yoEznOfDc/JDiIz0btRI+IuUc9vbkkreZN9UMAfvbNl6x
         wat8bwO2YA5O+cX2ub3wlXfezkqhB+GjA6XkCxWiG98ibC4yuOoC6zmIOdnb2P5ta2ro
         PG98DfBbiBR3k/nh4fmxfTcd4EyChfCkZVoypHuwFDDzy00THIw+d086LP8hVFirFX0V
         csShOfo1brR/Iy3y9ImM9MxFng86Vkt1BHIgBrtI6/6RYlCf0zLY4yWjQ3w2m6/UoqoV
         os8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7kJ/8KrJtwWrQtL3HJvPRSeBswfmXX7pgLh8LlFHkeQ=;
        b=LrHZTfFTno2nNYSJ1oM425+mZianyzpwsaZIXcWKC0mFX2eVK+3fRLJwdBWzjSIh1Y
         QS2GApgPaagYfTnktPkHzqjr7Tf3urhL2aGN/oiP0Afuqjx+96EKArZ6Y1QyPBBvi42u
         mOUrSlUPVDG+QS5+K+aX+FDwyHQhnfaYG9YpUIQWRFRfo/UzSr3AERDR7d+7kM08EBM8
         +D7Do9HvJXp1NIO0ByGthM6DZqqXMIRdFPySu2HG5difxmqHbizrXlUuqiBdRvt5MYvV
         A+FwQwi9mwHpCvbJ97Bm2Qan7kFR2wLmN2O3+sJRR4CTSh/LnmXLjoaX9p0MF2Fa5Ykb
         ykRw==
X-Gm-Message-State: ACrzQf3uEsqUjgZs3e67m98298kjH2S+axf2fY3f51bDB8PROrBWtyMH
        MofkZPn3C8l8OwtMcjsF2TuDZ444fqM=
X-Google-Smtp-Source: AMsMyM4ihH7Z7+omEL5JzqYhtw4lNT9IJcgnKY8b/TdcxfMm4o4YboG/ppCLSDMOAzstzFXWScebew==
X-Received: by 2002:a17:907:7f07:b0:779:7f94:d259 with SMTP id qf7-20020a1709077f0700b007797f94d259mr6204310ejc.525.1665952385312;
        Sun, 16 Oct 2022 13:33:05 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id y11-20020a1709060a8b00b00788c622fa2csm5069345ejf.135.2022.10.16.13.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 13:33:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/4] io_uring: reuse io_alloc_req()
Date:   Sun, 16 Oct 2022 21:30:50 +0100
Message-Id: <6005fc88274864a49fc3096c22d8bdd605cf8576.1665891182.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665891182.git.asml.silence@gmail.com>
References: <cover.1665891182.git.asml.silence@gmail.com>
MIME-Version: 1.0
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

Don't duplicate io_alloc_req() in io_req_caches_free() but reuse the
helper.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6e50f548de1a..62be51fbf39c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2560,18 +2560,14 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 
 static void io_req_caches_free(struct io_ring_ctx *ctx)
 {
-	struct io_submit_state *state = &ctx->submit_state;
 	int nr = 0;
 
 	mutex_lock(&ctx->uring_lock);
-	io_flush_cached_locked_reqs(ctx, state);
+	io_flush_cached_locked_reqs(ctx, &ctx->submit_state);
 
 	while (!io_req_cache_empty(ctx)) {
-		struct io_wq_work_node *node;
-		struct io_kiocb *req;
+		struct io_kiocb *req = io_alloc_req(ctx);
 
-		node = wq_stack_extract(&state->free_list);
-		req = container_of(node, struct io_kiocb, comp_list);
 		kmem_cache_free(req_cachep, req);
 		nr++;
 	}
-- 
2.38.0

