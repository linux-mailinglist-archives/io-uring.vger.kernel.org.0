Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21925B22EC
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 17:59:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbiIHP7E (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 11:59:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230241AbiIHP7D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 11:59:03 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7237C9CCCC
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 08:59:02 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id e18so25067163edj.3
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 08:59:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=rNeqALpVAO/+TKzL6QzySY7His6uDpVJ/a3IOMvrhUM=;
        b=AyJxHXZx83BgPSTWK3GKzIaFp2W+0NGspXoBGvyw6T/q1LBFOtIaw+bdpWSjxiWjVQ
         UfRukVeuvSyJcFoAqkCF28mc5Aj7/E7/728L5xw7zqR1Yx2JsIX/yYG1gBAMMD3eA/y/
         uNEejpOsbLnB+DikMd0hQxYm3A7bQQ5SHhvDA7tjLwXP9OMvtkUQNv0ETW1aMkvjnX3L
         N/O+Mv+zA2P+s+rZZxl/RUN4dRWw0CU1rrEvnNaPMc/5vZ9LoYVOyGdZV59xqS0kpEvv
         TIXpJCrRZxs3V2sDja0foO21DHKtiJ26NUw+S+KhjlZC9qfeac1VUMlO8KhnvrF0SWjM
         D2Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=rNeqALpVAO/+TKzL6QzySY7His6uDpVJ/a3IOMvrhUM=;
        b=XyUwwdIZWRiMWlofP05eL08vG+IldzCtl0im/e4eG1LSfUP1pWTtq0VbaP6s4KxPqG
         m07IQYJmDz6VenB4w2MR+VxwtTrRhZABxJx9yBxmK3I4Gx/ZpzkSeXPAbueruro5ehku
         qx+9Hv2ouo4vbjGmZeHG08SXMehZJhnrsQb2SbeB5cMtwZJvb5sEr+RzWQ+VVn36yQuT
         yd4W0MBkNBcOHPYpjLp21C5vHBboJWgw6qSK+k2HqRH/X5/KtvS4Dq7GJuU57lNWnsD3
         TK/+s7Z66/Ic93izWOMBLORl8maavxRokrbeJlWUjhz+PR+W5cYIJ+sw1q9argGQgzuB
         PonA==
X-Gm-Message-State: ACgBeo0fd+qXNdBBJa/2wkPn7GgpujeXPUZA34oH2CVr44wEiXRJxY8u
        5pOy007RdkIQFjW9Pq8WynB5aw6TMHQ=
X-Google-Smtp-Source: AA6agR7OFURyitmmo/k6yrCq72/O4j2DtjzIaBj7k51x0Ydc3s1R0/VQUz0lAa6w3nlIr5a4BZmPVg==
X-Received: by 2002:aa7:c458:0:b0:44e:9078:5712 with SMTP id n24-20020aa7c458000000b0044e90785712mr8012745edr.25.1662652740765;
        Thu, 08 Sep 2022 08:59:00 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id q26-20020a1709060e5a00b0073872f367cesm1392503eji.112.2022.09.08.08.59.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:59:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 2/6] io_uring: disallow defer-tw run w/ no submitters
Date:   Thu,  8 Sep 2022 16:56:53 +0100
Message-Id: <b4f0d3f14236d7059d08c5abe2661ef0b78b5528.1662652536.git.asml.silence@gmail.com>
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

We try to restrict CQ waiters when IORING_SETUP_DEFER_TASKRUN is set,
but if nothing has been submitted yet it'll allow any waiter, which
violates the contract.

Fixes: dacbb30102689 ("io_uring: add IORING_SETUP_DEFER_TASKRUN")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 7 +------
 io_uring/io_uring.h | 9 ++-------
 2 files changed, 3 insertions(+), 13 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index dc6f64ecd926..7f60d384e917 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1169,13 +1169,8 @@ int __io_run_local_work(struct io_ring_ctx *ctx, bool locked)
 	int ret;
 	unsigned int loops = 1;
 
-	if (unlikely(ctx->submitter_task != current)) {
-		/* maybe this is before any submissions */
-		if (!ctx->submitter_task)
-			return 0;
-
+	if (unlikely(ctx->submitter_task != current))
 		return -EEXIST;
-	}
 
 	node = io_llist_xchg(&ctx->work_llist, &fake);
 	ret = 0;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 4eea0836170e..d38173b9ac19 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -331,13 +331,8 @@ static inline struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 
 static inline bool io_allowed_run_tw(struct io_ring_ctx *ctx)
 {
-	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
-		return true;
-	if (unlikely(ctx->submitter_task != current)) {
-		/* maybe this is before any submissions */
-		return !ctx->submitter_task;
-	}
-	return true;
+	return likely(!(ctx->flags & IORING_SETUP_DEFER_TASKRUN) ||
+		      ctx->submitter_task == current);
 }
 
 #endif
-- 
2.37.2

