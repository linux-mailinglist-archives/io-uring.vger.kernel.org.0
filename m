Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92DBF4E7278
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 12:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345557AbiCYLzI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 07:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357538AbiCYLzB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 07:55:01 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF67AE67
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 04:53:28 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id qx21so14803731ejb.13
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 04:53:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XZiKlX4Cbg/I6gV+SQBSy6mZlSVGf7IaN3/F8YEAsKw=;
        b=eQtJeMJCkOHN3lN3snFUzkNGvEH7NfWf2Bf/vWxmKo1N+C7ZjL7itifZamiDH6ccZ8
         tZJdbe6CP7W+vBTar1/ig4nUUK/zS9iv9chkSH80C3o/9rrOidvE+gaaRpa75T1Anta+
         WR+pBF9lOH7shkk5PNf9ivIRa6GqzpdHLXR/SKtA4sr3Yb3jEW3qm7JAfLXGOLaDnEAe
         8BaleTlUHrrgrT481+y6tI4EJUOU55BC11ck53ITgg/wCYPDfRgNomKoOCm34+2aoQT2
         LRoR4U++1UIup7OUbXSQLo2z8o9VunPFkW0Q8+caNk6tvMoKpZYCFT2WfUirkrzSI2Xq
         8OMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XZiKlX4Cbg/I6gV+SQBSy6mZlSVGf7IaN3/F8YEAsKw=;
        b=xxIOOnmA1amPS2TAEC25B4GDx8LPFJL8dENmfAiaHSJ80RQiyZWsl8/Hk1a6iaySpX
         7xYizyIQzV7aCtUnRJlW6hWJxVcqTXHp3TYq6mRRogdJ6xZajEifFKVM4potJxq5kEI8
         r5zC9KMNUgsMZB3zzwjcXjrQpTBvF0q60WtvnDSQliXSoZo81NZyWJ/JJ3pISbeCcEgs
         Z2GxpN21J0Sh2DDc41Pc7r+rx3LwWkpuCG1pGsJrPKQ+Cf8WZAygzUjtDqaxGfEoTJ7U
         JaS0b/R+fIf8wJTqMVmEJlKKZwX4N3Jefdxx/gx7M4v2jhmR0Znut6A2oY5jvtvODolC
         Gi1Q==
X-Gm-Message-State: AOAM5300aJ68rm3pfoFKvBRdArUdQ7NkpCGS9Ag0AkZjhoJAUwDvJdBg
        bDPGa29wEfjHSw0esnacFGNdmb19X2TMGA==
X-Google-Smtp-Source: ABdhPJxypgxvoQXqinlk5yTz7R6vdvmlsG+o6Qt0Vru5IKzs6MikxVhsLcEs7Y25j3SMkmt4PwcYrA==
X-Received: by 2002:a17:906:58cb:b0:6df:f696:9b32 with SMTP id e11-20020a17090658cb00b006dff6969b32mr11380703ejs.384.1648209206531;
        Fri, 25 Mar 2022 04:53:26 -0700 (PDT)
Received: from 127.0.0.1localhost ([78.179.227.119])
        by smtp.gmail.com with ESMTPSA id u4-20020aa7db84000000b004136c2c357csm2706777edt.70.2022.03.25.04.53.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 04:53:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/5] io_uring: refactor io_req_add_compl_list()
Date:   Fri, 25 Mar 2022 11:52:17 +0000
Message-Id: <f0a5272b45efe4ffc41cb79b99784e39c699aade.1648209006.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648209006.git.asml.silence@gmail.com>
References: <cover.1648209006.git.asml.silence@gmail.com>
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

A small refactoring for io_req_add_compl_list() deduplicating some code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e651a0bb00fe..9cd33278089b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1726,11 +1726,10 @@ static void io_prep_async_link(struct io_kiocb *req)
 
 static inline void io_req_add_compl_list(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_submit_state *state = &ctx->submit_state;
+	struct io_submit_state *state = &req->ctx->submit_state;
 
 	if (!(req->flags & REQ_F_CQE_SKIP))
-		ctx->submit_state.flush_cqes = true;
+		state->flush_cqes = true;
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
-- 
2.35.1

