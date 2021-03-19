Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B175534234C
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 18:27:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbhCSR1G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 13:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230336AbhCSR0y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 13:26:54 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D8C1C06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:54 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id u5-20020a7bcb050000b029010e9316b9d5so5651807wmj.2
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 10:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6iWiVrillEo0yFlgs9YBvt1poKT1j2p/6Cw/1CTx5Fs=;
        b=VzcZF/MPObek3BB7mMXuVKIdpi1G6pMxSZtpVqJCYJ0WJ/OvfqSzgWrH6mkY/GWdqn
         6QAjTLZINAr500Lpg8NZDPIB9/Z70GPs7FDMDfg9pqOZoyEyecAeRKdN3u0mI9dgBpan
         Gsn4/M95ChKipVOQczw4GrEYtSZvBplPQA0+d20oOX+fP6n80ab3NpTKLrvGs0p3sSmI
         ve0z/6n2EZs4TUz7PkRNNsecqQzZl9Hairw6mbI6o36pl5N8EKAfVNQaS2OzCvkRLF4M
         Nlq4ASHfsZqLeS5aK1yYzLlPgdZ/HmWQkhhYwe8J05hOPKNOPufUG9nDCcgIj5DQvpUE
         ou8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6iWiVrillEo0yFlgs9YBvt1poKT1j2p/6Cw/1CTx5Fs=;
        b=iT7qRDoNW38y5BivVBgM++SLxVzYzLWHeWfkuY9Zn1naNvNQvbwRNFUq+EK9ahEueU
         eSK4boMPyf+pMG/SFgZJiA3V7xn6xd8AXqRHsD36R9X7cA3sbP8l0DGuZGwYkiwNv5wY
         MoPVThykmXeSpU0Il8Ge3tnm9SwXsFCKNdsN3YVgYCFmG5yC3tmnwwAAx4aqONlm1Q6T
         8c11aTbTAQO8AhlH/YaDcpLYp50ZVct6zMX4ME2DK2/vAdOREMyqY+XZ0oYVCy+JDcy7
         j4qKJ+AiXtbmUo202zlG3+8dd6ZQ8WJplTPb54syHzTBvxlpjvUYv8EvF1G8X1HighFb
         ZP6Q==
X-Gm-Message-State: AOAM532h/Z+bm48hihfcCmWDXUR/KjNTTB7GYLdGSiYddRrJJTFugkFu
        xrAQ0U7Xpvvod5pqMeiGk3E=
X-Google-Smtp-Source: ABdhPJzjyHh763Jfv9+nYBh2G7rLt5lUkWlwZaqN6LUtO65RlA19kH7vE9zoAIRFwplJqBeEUtJjVQ==
X-Received: by 2002:a1c:bc56:: with SMTP id m83mr4729975wmf.174.1616174812937;
        Fri, 19 Mar 2021 10:26:52 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.195])
        by smtp.gmail.com with ESMTPSA id i8sm7112943wmi.6.2021.03.19.10.26.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 10:26:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/16] io_uring: optimise tctx node checks/alloc
Date:   Fri, 19 Mar 2021 17:22:31 +0000
Message-Id: <23ef5a5588e533a2e07cbdebfacb836eaf9207a4.1616167719.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616167719.git.asml.silence@gmail.com>
References: <cover.1616167719.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

First of all, w need to set tctx->sqpoll only when we add a new entry
into ->xa, so move it from the hot path. Also extract a hot path for
io_uring_add_task_file() as an inline helper.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 53 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 439f95111b18..e00ac529df0e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8803,10 +8803,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 	}
 }
 
-/*
- * Note that this task has used io_uring. We use it for cancelation purposes.
- */
-static int io_uring_add_task_file(struct io_ring_ctx *ctx)
+static int __io_uring_add_task_file(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
@@ -8818,32 +8815,40 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx)
 			return ret;
 		tctx = current->io_uring;
 	}
-	if (tctx->last != ctx) {
-		void *old = xa_load(&tctx->xa, (unsigned long)ctx);
-
-		if (!old) {
-			node = kmalloc(sizeof(*node), GFP_KERNEL);
-			if (!node)
-				return -ENOMEM;
-			node->ctx = ctx;
-			node->task = current;
-
-			ret = xa_err(xa_store(&tctx->xa, (unsigned long)ctx,
-						node, GFP_KERNEL));
-			if (ret) {
-				kfree(node);
-				return ret;
-			}
+	if (!xa_load(&tctx->xa, (unsigned long)ctx)) {
+		node = kmalloc(sizeof(*node), GFP_KERNEL);
+		if (!node)
+			return -ENOMEM;
+		node->ctx = ctx;
+		node->task = current;
 
-			mutex_lock(&ctx->uring_lock);
-			list_add(&node->ctx_node, &ctx->tctx_list);
-			mutex_unlock(&ctx->uring_lock);
+		ret = xa_err(xa_store(&tctx->xa, (unsigned long)ctx,
+					node, GFP_KERNEL));
+		if (ret) {
+			kfree(node);
+			return ret;
 		}
-		tctx->last = ctx;
+
+		mutex_lock(&ctx->uring_lock);
+		list_add(&node->ctx_node, &ctx->tctx_list);
+		mutex_unlock(&ctx->uring_lock);
 	}
+	tctx->last = ctx;
 	return 0;
 }
 
+/*
+ * Note that this task has used io_uring. We use it for cancelation purposes.
+ */
+static inline int io_uring_add_task_file(struct io_ring_ctx *ctx)
+{
+	struct io_uring_task *tctx = current->io_uring;
+
+	if (likely(tctx && tctx->last == ctx))
+		return 0;
+	return __io_uring_add_task_file(ctx);
+}
+
 /*
  * Remove this io_uring_file -> task mapping.
  */
-- 
2.24.0

