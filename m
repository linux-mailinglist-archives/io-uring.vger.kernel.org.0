Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31475640C8D
	for <lists+io-uring@lfdr.de>; Fri,  2 Dec 2022 18:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbiLBRsy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Dec 2022 12:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234048AbiLBRsu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Dec 2022 12:48:50 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 429F8BFCCA
        for <io-uring@vger.kernel.org>; Fri,  2 Dec 2022 09:48:49 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id h7so2884780wrs.6
        for <io-uring@vger.kernel.org>; Fri, 02 Dec 2022 09:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yoefvsER00SUtr3JL020XR4BJX3LqQFz/lbi4KivLe8=;
        b=SzaGjGHleBNLw7y1Tnj0t+I9Pj+zuWKyHdV2Eu+GcX8Loa8H5/CwfrPxO7Rg4u5sg1
         yqu8qGK6UXKCQTQIJovkvPiJY0JYrTe3514GeGpbfW9pU+pllKDR/koKi3Z5xfQ5jcvJ
         hQ9z6CdZtO+Bxi0lPs2zs40XV4fe14m2O10W0t8qR7bC5Pgxw/f9rUeBXSiDpLYA1XRm
         vrOLQdwIKZOnWIQgQzpwdhNyEXdeaSnxCbIm+X+cOWl4B+Y3+a/azgSzoAh9/ooFtO+G
         ivstP3uLkwqIvv7GdhVXrLuwqNLNeMhZDam93yIk/SrB896AqfUWlr/u63wSdeECq61X
         i57Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yoefvsER00SUtr3JL020XR4BJX3LqQFz/lbi4KivLe8=;
        b=AXLBbOBlgjYQ16H0BLg7w39mxh4N3N/yNupi2gz/SXhFoAPWNuoxxhtO9q8cnrnZR6
         nFppCferUszwuJXQKuv0InGZMol0GqFtAnWeg5FKEr/G4Wt17XFDEn3r868fLw2BokeS
         LxDjfASb4ljAOB8OZhuOCM1/FZB9CizFo35+lIpyTdBhanmjQRVniDB4d6q/xNdQjzGM
         uv0wRhrz/CjhUrLLhpWcv9ZZNiH0Y8cYaBkh3lXwNKwCiBtEHdnMXzdxvmtskTFJV3HS
         eh+NG7k0etU+ESwq7pxiZ+4QQdsoeqASV764s47eJ4lsGfKBcjJ5PFzZoLYzSzYKQhcc
         619g==
X-Gm-Message-State: ANoB5plNLYvIM5+7CvsvcQpErnauI4SzN51pqPiEX5PEDMt88UdxkrvS
        ye/3cMdi/pTCiSWgjbMf7qGaPGdvcm8=
X-Google-Smtp-Source: AA0mqf6eaXCPNBUmLr7QpJFfvZEQxYT9RGTNxQpSgZYVq9heqjBnF67BxZjVyUxmKIm4OYyjQ1rSQA==
X-Received: by 2002:a5d:6444:0:b0:241:f75a:d6aa with SMTP id d4-20020a5d6444000000b00241f75ad6aamr28677104wrw.672.1670003327651;
        Fri, 02 Dec 2022 09:48:47 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id i1-20020adfaac1000000b002238ea5750csm9368585wrc.72.2022.12.02.09.48.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Dec 2022 09:48:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/4] io_uring: ease timeout flush locking requirements
Date:   Fri,  2 Dec 2022 17:47:24 +0000
Message-Id: <1e3dc657975ac445b80e7bdc40050db783a5935a.1670002973.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670002973.git.asml.silence@gmail.com>
References: <cover.1670002973.git.asml.silence@gmail.com>
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

We don't need completion_lock for timeout flushing, don't take it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 9 ++++-----
 io_uring/timeout.c  | 2 --
 2 files changed, 4 insertions(+), 7 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 57c1c0da7648..4593016c6e37 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -570,12 +570,11 @@ static void io_eventfd_flush_signal(struct io_ring_ctx *ctx)
 
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
-	if (ctx->off_timeout_used || ctx->drain_active) {
+	if (ctx->off_timeout_used)
+		io_flush_timeouts(ctx);
+	if (ctx->drain_active) {
 		spin_lock(&ctx->completion_lock);
-		if (ctx->off_timeout_used)
-			io_flush_timeouts(ctx);
-		if (ctx->drain_active)
-			io_queue_deferred(ctx);
+		io_queue_deferred(ctx);
 		spin_unlock(&ctx->completion_lock);
 	}
 	if (ctx->has_evfd)
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index eae005b2d1d2..826a51bca3e4 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -50,7 +50,6 @@ static inline void io_put_req(struct io_kiocb *req)
 }
 
 static bool io_kill_timeout(struct io_kiocb *req, int status)
-	__must_hold(&req->ctx->completion_lock)
 	__must_hold(&req->ctx->timeout_lock)
 {
 	struct io_timeout_data *io = req->async_data;
@@ -70,7 +69,6 @@ static bool io_kill_timeout(struct io_kiocb *req, int status)
 }
 
 __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->completion_lock)
 {
 	u32 seq;
 	struct io_timeout *timeout, *tmp;
-- 
2.38.1

