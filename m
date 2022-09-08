Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 577415B22ED
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 17:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiIHP7F (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 11:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbiIHP7E (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 11:59:04 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847A6E55BB
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 08:59:03 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gb36so39048591ejc.10
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 08:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=mgVWDGO+sTjtFaqfFa3pHvlo4gSFJ+pkOC743IR4S0A=;
        b=o7kEKh3Li7g6nSerKYuR02tKSfmvGHmpR+zhctJKMF+gz4vIlhsI8XKt4Lpr/sTzjF
         Oy70Jy1q225JaceK87UHBA0A7kYtxu2og2GAEVUwW/IPoTg2pyDVUNg920aoL06xrIZm
         3AWB8FcHu8wZEw8AcD2miN6xIQSF+vtcxUnF8yijBTr1NNjwxkrAto/t7+09ttS1S+Uh
         D6lAQw+joiJji/BFAaoG2T0C2UuNVO/DUQNLtMi5ZGmTGAgMVjklL+f5T5p+PBncShyo
         hJzXrrkim2Qyfi2rbnaFVv4qsLBj9NRofVl7kcDkT1EDO0iVjiOXgMi8yAxo71NPi3d9
         SmFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=mgVWDGO+sTjtFaqfFa3pHvlo4gSFJ+pkOC743IR4S0A=;
        b=hLFLZA0UNLWUBerWvIaeiHVeGylAiC1rY/J7L9PSHSasS5+wGbiz4slBOmVIOauLQj
         X7OuoiUvSIhV2/C4ESymbjgBIBsdayWlvzsdCx5drpe8+V8tW7tDyqab+BRw3YCqfKaN
         bxTphRILgZ5v5dfaPQqeIcSsuZZL8zGH9rajCfyI4VY2QCR21GAr37+x9zXT1x3oiAWR
         knEXubUtMmmTVe1Lb01T51tm1dgyU5foo1yH3kv+jKrAFmrBAPNMWH1bbmPHkwh6zeZk
         zd4ZEJSLk3jg02dWrApNGl1FlsMUdahg2e8HsYbzBCtSdU8cVPsjCCJUdhR2ERzd9yTG
         yhQA==
X-Gm-Message-State: ACgBeo15pgLPhQ6UsapqtOCRB3/FPgsekehv9JYGgtZ1erUFDhOCc2Eq
        PPa1ag9vEvPO7VvNVpuHnfeRIoznaL4=
X-Google-Smtp-Source: AA6agR4hvOUpK/+fgFlm5oGZZHq/OJDujT2FVrFelWJUSMnIoFhclgtv3XFyOgDweLrQ+NwrzOuOsw==
X-Received: by 2002:a17:906:730d:b0:73d:c8a1:a6ae with SMTP id di13-20020a170906730d00b0073dc8a1a6aemr6694199ejc.540.1662652741567;
        Thu, 08 Sep 2022 08:59:01 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id q26-20020a1709060e5a00b0073872f367cesm1392503eji.112.2022.09.08.08.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:59:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 3/6] io_uring/iopoll: fix unexpected returns
Date:   Thu,  8 Sep 2022 16:56:54 +0100
Message-Id: <c442bb87f79cea10b3f857cbd4b9a4f0a0493fa3.1662652536.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662652536.git.asml.silence@gmail.com>
References: <cover.1662652536.git.asml.silence@gmail.com>
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

We may propagate a positive return value of io_run_task_work() out of
io_iopoll_check(), which breaks our tests. io_run_task_work() doesn't
return anything useful for us, ignore the return value.

Fixes: dacbb30102689 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 7f60d384e917..8233a375e8c9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1435,12 +1435,9 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
 				u32 tail = ctx->cached_cq_tail;
 
 				mutex_unlock(&ctx->uring_lock);
-				ret = io_run_task_work();
+				io_run_task_work();
 				mutex_lock(&ctx->uring_lock);
 
-				if (ret < 0)
-					break;
-
 				/* some requests don't go through iopoll_list */
 				if (tail != ctx->cached_cq_tail ||
 				    wq_list_empty(&ctx->iopoll_list))
-- 
2.37.2

