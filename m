Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA57505EC3
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 21:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347791AbiDRT43 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 15:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347790AbiDRT4Y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 15:56:24 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD4A2C67A
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 12:53:44 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id v15so18578644edb.12
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 12:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uS9kjufEQ3GHPf9yIimoRvb67qLOD/GJWP4ExeC1+U8=;
        b=I82yEFqlT3UA3jwwlkhs6eS0jija9wNswz4UR8GwILfYMDaAO9Bc7JpfNhRgAmRdbO
         A8nvkid9KsfOtK33yAnm3j4GKNZ44UhyhSIa4/KxSvlqjRFaLTJyW55IKNPjQH+qV65o
         4SaCW7/iBsAZS1s7Oongk37QJ/BlyZ34pH9hak+lmL9ISI1dy+uPigqD1lC8R0Vmam2t
         MONpzE+fEAOdt5pRH53pbFggO/zaIoFwD0PSsP2Sd5iNOUU1g0Gi6+nSKjQTzU5uytic
         lBEZm7WZUJS5lfrxgRndPnNzVO0w4AJuHdcO+Zs5fyZynkZynORB4otnHAbSvgoSeNdi
         cNHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uS9kjufEQ3GHPf9yIimoRvb67qLOD/GJWP4ExeC1+U8=;
        b=VCZVJEodIEOm8Uvc7D/ZaDVp0eFOIWE3K2Pdm9jTYR2tGfQSyaRe3/YbcRbTjjeZUw
         a4ve8EQnVWfpZkvzxTbif54hG1DDXxvIo/VIclbZ+hUHwYth59spSHB7dO/FXPk/KxCF
         qHiYn+R/S2+yqHaOJp9INppt3/pNeg3GB3bWkfXoyBVeUuyQqG/IK0JtnznREn0p/IfE
         ++uq1tqMNzoyVZUSoU/e3TplYocdNCaBlRfTpSPXFrwydszqJa/KuAuSba7402Wu3R2y
         KML/ZtkeNbKGTs12prWTib9RtW0SssoFM65wTj4xV0IZaSndKsqnSWPxzNZTUJA4V5MZ
         tcEA==
X-Gm-Message-State: AOAM532btiydtL0+rnM+6YCONb/FnPNYk8qHUNB5uJZA2wdtNTyG92bR
        fOm9U1/H70ZKNxSblKTSa2J6EYgvdtk=
X-Google-Smtp-Source: ABdhPJxlZapwDZ/wIlAcAMS9TBn2mOLl/2jAVQJBiJb35rC2McqlvZP1Xyaj/jrmf95F6kBjIz02Sg==
X-Received: by 2002:a50:8d8a:0:b0:423:d77b:a683 with SMTP id r10-20020a508d8a000000b00423d77ba683mr10868526edh.138.1650311623230;
        Mon, 18 Apr 2022 12:53:43 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.70])
        by smtp.gmail.com with ESMTPSA id bf11-20020a0564021a4b00b00423e997a3ccsm1629143edb.19.2022.04.18.12.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 12:53:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/5] io_uring: kill ctx arg from io_req_put_rsrc
Date:   Mon, 18 Apr 2022 20:51:15 +0100
Message-Id: <bb51bf3ff02775b03e6ea21bc79c25d7870d1644.1650311386.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650311386.git.asml.silence@gmail.com>
References: <cover.1650311386.git.asml.silence@gmail.com>
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

The ctx argument of io_req_put_rsrc() is not used, kill it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c67748eabbd5..3905b3ec87b8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1344,7 +1344,7 @@ static inline void io_req_put_rsrc_locked(struct io_kiocb *req,
 	}
 }
 
-static inline void io_req_put_rsrc(struct io_kiocb *req, struct io_ring_ctx *ctx)
+static inline void io_req_put_rsrc(struct io_kiocb *req)
 {
 	if (req->rsrc_node)
 		io_rsrc_put_node(req->rsrc_node, 1);
@@ -2173,7 +2173,7 @@ static void __io_req_complete_post(struct io_kiocb *req, s32 res,
 				req->link = NULL;
 			}
 		}
-		io_req_put_rsrc(req, ctx);
+		io_req_put_rsrc(req);
 		/*
 		 * Selected buffer deallocation in io_clean_op() assumes that
 		 * we don't hold ->completion_lock. Clean them here to avoid
@@ -2336,7 +2336,7 @@ static __cold void io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_req_put_rsrc(req, ctx);
+	io_req_put_rsrc(req);
 	io_dismantle_req(req);
 	io_put_task(req->task, 1);
 
-- 
2.35.2

