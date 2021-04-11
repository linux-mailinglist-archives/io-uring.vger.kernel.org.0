Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CEE135B110
	for <lists+io-uring@lfdr.de>; Sun, 11 Apr 2021 02:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234962AbhDKAvV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 10 Apr 2021 20:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234947AbhDKAvU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 10 Apr 2021 20:51:20 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654DEC06138B
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:05 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id y124-20020a1c32820000b029010c93864955so6648515wmy.5
        for <io-uring@vger.kernel.org>; Sat, 10 Apr 2021 17:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9rLoYHyFIGtOYDf1E+ivGy7PioqLTBZm1r2n35GyYiA=;
        b=D8cQnIvNclVbAdc+CzMYyHA7yvUZONjr+U4mdyHcYU6EUEnljpGy0e274oKuAXiu79
         h1BPyW3grvLnFiaWrBql53UJ97Pn8DBvXYkSGRrTG/xsLEsy5w4nS+jKq4Q1GnAG6Br5
         N/dX56jB8Guoc0163LKR3MfOptoj1/FhV/ZOR0lenQDL7g49rGgYOrIJiiIDGmLBAUIA
         Alg20wk1KNBa7Com+GNwsx8VOeaQov/jMnz+LdRgNBI54T/tdUFd5K6ytH2UOaFa5TwD
         BtQYs2Xn3nUVHNxXsiZpE9WE/pdc166aqMdmmw9fJ0Bm9QaX8H7oQjr9Rj8L75O+3jfe
         AEeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9rLoYHyFIGtOYDf1E+ivGy7PioqLTBZm1r2n35GyYiA=;
        b=jsSMtHqT2yyunPVMk1891f4jWqJB7dOm8z9PegIm88qZFgyI+O3JXnOm+Ljc3h6UnP
         Bkfb6n0yu0/bhNRNl3vGw/7O9tnqk5H7teYVRX+qLh7k2aETmpIy/UQD094uwf931my/
         XULNYSqSNBWgJ1wJMlonP9k+QhmFS7+92UfDyI0jY5SYkUaAtquS6focajA/PWyQhgqn
         yLgJiEBEP1Qujtu8yL1oE7WxalsoGs1wVwWF2tMJPm/62vOSnmZ7OzSSVsgt7Z6s9V4v
         /kVpAqW9rAEWBAOqnBYWfz+azjnGfokc2nO2djVMBU6+0fAudlHVX1PMqNIJNtI/vYbF
         QXgg==
X-Gm-Message-State: AOAM533kFYAuaa091ogj1McNd+uyKfIjSWMIkvDhYkQzYi8ECEnoX6uL
        ey4x1RMD6dLAMR6iGIAr4zQ=
X-Google-Smtp-Source: ABdhPJwuiULj2BcGMy/3rlmLJbNteEsEmOMOf1EmoKRWHnmoo3qadmiW+v4XoetV3hzYJU9PsdO0tA==
X-Received: by 2002:a05:600c:1912:: with SMTP id j18mr19999673wmq.137.1618102264200;
        Sat, 10 Apr 2021 17:51:04 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.117])
        by smtp.gmail.com with ESMTPSA id y20sm9204735wma.45.2021.04.10.17.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 17:51:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/16] io_uring: cleanup buffer register
Date:   Sun, 11 Apr 2021 01:46:36 +0100
Message-Id: <93292cb9708c8455e5070cc855861d94e11ca042.1618101759.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1618101759.git.asml.silence@gmail.com>
References: <cover.1618101759.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In preparation for more changes do a little cleanup of
io_sqe_buffers_register(). Move all args/invariant checking into it from
io_buffers_map_alloc(), because it's confusing. And add a bit more
cleaning for the loop.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 157e8b6f1fc4..4be1f1efce26 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8311,17 +8311,8 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 
 static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
 {
-	if (ctx->user_bufs)
-		return -EBUSY;
-	if (!nr_args || nr_args > UIO_MAXIOV)
-		return -EINVAL;
-
-	ctx->user_bufs = kcalloc(nr_args, sizeof(struct io_mapped_ubuf),
-					GFP_KERNEL);
-	if (!ctx->user_bufs)
-		return -ENOMEM;
-
-	return 0;
+	ctx->user_bufs = kcalloc(nr_args, sizeof(*ctx->user_bufs), GFP_KERNEL);
+	return ctx->user_bufs ? 0 : -ENOMEM;
 }
 
 static int io_buffer_validate(struct iovec *iov)
@@ -8353,26 +8344,26 @@ static int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	struct iovec iov;
 	struct page *last_hpage = NULL;
 
+	if (ctx->user_bufs)
+		return -EBUSY;
+	if (!nr_args || nr_args > UIO_MAXIOV)
+		return -EINVAL;
 	ret = io_buffers_map_alloc(ctx, nr_args);
 	if (ret)
 		return ret;
 
-	for (i = 0; i < nr_args; i++) {
+	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
 		struct io_mapped_ubuf *imu = &ctx->user_bufs[i];
 
 		ret = io_copy_iov(ctx, &iov, arg, i);
 		if (ret)
 			break;
-
 		ret = io_buffer_validate(&iov);
 		if (ret)
 			break;
-
 		ret = io_sqe_buffer_register(ctx, &iov, imu, &last_hpage);
 		if (ret)
 			break;
-
-		ctx->nr_user_bufs++;
 	}
 
 	if (ret)
-- 
2.24.0

