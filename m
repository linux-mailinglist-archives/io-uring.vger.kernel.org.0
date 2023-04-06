Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 835606D97EF
	for <lists+io-uring@lfdr.de>; Thu,  6 Apr 2023 15:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbjDFNVF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Apr 2023 09:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238262AbjDFNU6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Apr 2023 09:20:58 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82A659ECC;
        Thu,  6 Apr 2023 06:20:27 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a640c23a62f3a-92fcb45a2cdso132000466b.0;
        Thu, 06 Apr 2023 06:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680787226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kd+SeWCUjtszJlrB0nyw1/x5gRJWByJn0vCgXmRmawk=;
        b=n8UKppUQgIobKFVZb2sLFFpuYMPwI0XY962g8cv91Wn6fYVRlcLjFgqyKpUxv2UsCS
         ho1g8mhE/jXxRK8YpYHOzqXKQJ2S4Lgf/kFStzG9aEN64+RQM/PyNtmeerS0IwZlqZ2K
         bjoqkwIs0zH/popw2+JLnf7e76tbfmr+CTpTnwsshKb8rMjPqc8lilicXYbRTx4Ei/wl
         oRME80Q5I4eqA3gbPrbR3Y+2FC0jrXAwh/u0aaHlaQImTxrHvTXvkC9Tt1746b4YwdCQ
         +xPXK5y3jDY0lQDrwItBocsQs5dwtJJkOQKCknXE1yFedND8PGv9i1QUJEs4cjzrmiaA
         KNLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680787226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kd+SeWCUjtszJlrB0nyw1/x5gRJWByJn0vCgXmRmawk=;
        b=mNwQ82VGdccgDj+nmH3TabQv/sz3J8nhfAbltoD68sZwmnsViImbVvhAUi1qAsSncE
         YxdUJdAWN0EThetqExcu9gqmjcrguAKGG2MKqXnHgr4ku4mClvrdkVHukjD0X0X5Jch7
         leXD6PMVOhkqnns7dNdHk2d6eZbJedyEKBqJjIBJIGcyP35UEmUIfgbC0HGlcyLcajKr
         ig/XesfZfzoWAJpvjRBwIf8OGm8T8cBaG1CZ7fS95PAKgXq+P1ZkPKuu0BLY6NwY8ND3
         W03vZqyBfncMvR45QIlTgw6nCQLi/75OeIbrVLzx5GMb47teyiFcovgnHMyTk2ZsAxK3
         fwoQ==
X-Gm-Message-State: AAQBX9fAIEm3hXD4zPKlPbOEguemxod6R5yvNUsvrOEGSXnUWnDv/BPT
        AdULgmPrKWBaEdMh8huieNlptcw+b0k=
X-Google-Smtp-Source: AKy350bhE2mjaejsTWWBSMuODW5lajEQKrz5rVRvVXQS1/jWUfuXzOtJk3PO9fhznIcDpZlww7t3yg==
X-Received: by 2002:aa7:c2c6:0:b0:4fd:5a28:2eff with SMTP id m6-20020aa7c2c6000000b004fd5a282effmr4709789edp.26.1680787225836;
        Thu, 06 Apr 2023 06:20:25 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a638])
        by smtp.gmail.com with ESMTPSA id m20-20020a509994000000b0050470aa444fsm312732edb.51.2023.04.06.06.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:20:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 5/8] io_uring: inline llist_add()
Date:   Thu,  6 Apr 2023 14:20:11 +0100
Message-Id: <f0165493af7b379943c792114b972f331e7d7d10.1680782017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1680782016.git.asml.silence@gmail.com>
References: <cover.1680782016.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We'll need to grab some information from the previous request in the tw
list, inline llist_add(), it'll be used in the following patch.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6f175fe682e4..786ecfa01c54 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1303,8 +1303,15 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx)
 static void io_req_local_work_add(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct llist_node *first;
 
-	if (!llist_add(&req->io_task_work.node, &ctx->work_llist))
+	first = READ_ONCE(ctx->work_llist.first);
+	do {
+		req->io_task_work.node.next = first;
+	} while (!try_cmpxchg(&ctx->work_llist.first, &first,
+			      &req->io_task_work.node));
+
+	if (first)
 		return;
 
 	/* needed for the following wake up */
-- 
2.40.0

