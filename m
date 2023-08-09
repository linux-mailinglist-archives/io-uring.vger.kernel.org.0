Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3F2775EE2
	for <lists+io-uring@lfdr.de>; Wed,  9 Aug 2023 14:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbjHIM1j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Aug 2023 08:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjHIM1i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Aug 2023 08:27:38 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AE71FCA
        for <io-uring@vger.kernel.org>; Wed,  9 Aug 2023 05:27:37 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id ffacd0b85a97d-31768ce2e81so5781065f8f.1
        for <io-uring@vger.kernel.org>; Wed, 09 Aug 2023 05:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691584056; x=1692188856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DdAq4R7gaB15+yMOyYmnA4Dq+d0eeDq9QZwz37ndhSM=;
        b=fpg1Xp3v+xbHkJJ0PrDsquiancBYye5w43W9NMc9LWl4ILrRNBSYFDYW/wVHXBRTxO
         r8+PjPXH8IJTKwMlqnsK6AH7QI6EAUAMZyW4ij6j2TEWqbh1B3yrdxQ1qZofI3jlcdvC
         cWPS4b7qZKJ0p4jqv6UoocIv3N7lGXt57yfKIF3at3YKVm24tm3W1sWqnlPbAimvy8Hf
         RuJ2SE6VQJ5KTyXyay0RsHuQnoo8owDEUkMwrEXcq57VVcUzoVf74PSaLggJPOW9fKWu
         G0D8PdJfRGzG0E585LUcye+1woeLlSuOcuCFxARfzMNDNDg9lBGPpKXOzZrmcQ/sLD3m
         uKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691584056; x=1692188856;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DdAq4R7gaB15+yMOyYmnA4Dq+d0eeDq9QZwz37ndhSM=;
        b=gWXWgNqCV7lNm8mdr9oAsUbtK5pOTTVDoYZiUw2jehtIWkD0yS/kJ9MzRjma97Swn4
         BBluKZNFTdSy0kDy9Km8oZKvlcGAe685ZmQ2m5hZv1MNrWefPCuFYx/4OmRMrysAUmur
         CnIQgPZPIA7SzUPHajIJIUhOJXF/EZRoBdi7rfjvJZAV2/2MVONMCjAbASyFt8sRaphe
         uxiMKmgwyu9HFGC3QAFjf2wRHaX7llDT4B00Ll6qufgahMFUgImlmmXhKKkKAd3iiNY3
         mMNdY/S1sgO5kr4JBMKtYnKleDQDuRkIADZOAQB+qsYgxqUaljzy4+om7IeM1nk/fXzP
         65+A==
X-Gm-Message-State: AOJu0YwWmydTFV25xIdXvTGmX9/fDFN0WPN2/en7Elhnp+8sLjWgffd4
        feGAR6v9JI94kaCYlmhtSk1ddb72M0c=
X-Google-Smtp-Source: AGHT+IFQ8bGkkkh0ghYfijL1Ct0LWJxED0PsqKEZzE3jV+qq1SZDMSH8sFUvEFg6WHuvAAshVqbAEQ==
X-Received: by 2002:a5d:5959:0:b0:317:5f04:bc00 with SMTP id e25-20020a5d5959000000b003175f04bc00mr1604376wri.27.1691584056220;
        Wed, 09 Aug 2023 05:27:36 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-78.dab.02.net. [82.132.230.78])
        by smtp.gmail.com with ESMTPSA id n4-20020a5d4204000000b0030ae499da59sm16558111wrq.111.2023.08.09.05.27.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 05:27:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: simplify io_run_task_work_sig return
Date:   Wed,  9 Aug 2023 13:25:27 +0100
Message-ID: <cc882a706b7e3c221261fb387826ecec09033e21.1691546329.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1691546329.git.asml.silence@gmail.com>
References: <cover.1691546329.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Nobody cares about io_run_task_work_sig returning 1, we only check for
negative errors. Simplify by keeping to 0/-error returns.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3c97401240c2..aa531debeb81 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2485,10 +2485,10 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 	if (!llist_empty(&ctx->work_llist)) {
 		__set_current_state(TASK_RUNNING);
 		if (io_run_local_work(ctx) > 0)
-			return 1;
+			return 0;
 	}
 	if (io_run_task_work() > 0)
-		return 1;
+		return 0;
 	if (task_sigpending(current))
 		return -EINTR;
 	return 0;
-- 
2.41.0

