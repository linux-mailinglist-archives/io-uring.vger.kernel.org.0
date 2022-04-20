Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF16508857
	for <lists+io-uring@lfdr.de>; Wed, 20 Apr 2022 14:41:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241889AbiDTMoY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 08:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353718AbiDTMoW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 08:44:22 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A57201B2
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 05:41:36 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id g18so2072705wrb.10
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 05:41:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hoEBUiTCwylfQM5EEmwmQxs9tkcUGgbQm8NoluRGKXI=;
        b=jX4EfsPH+g6q/g50Mx7l/mWjbfFlCB+mYkdU2tNyKyGleMICNWYKsv86eo6MDmAMYt
         3HeWPsqBLuIuuvmdr2NHbt3pLo+wOliSUEBJftH/ptnq4VK+pIwIxo6b8N3LDue39AgZ
         gXnlPuAda1MHDatg+4cC1wHelt141ha8PydrTYUs/Mc3mpRhTRBlNuwQa39PCqbLhWd5
         XNk63FOI7eO37nq5GyzuzaFOsgbZXdq12a5TbGgIcynznWOfWfsqpt9hHAUQDiSas2Nd
         TF2IQxdXBYUGriZAPEXenlGmZeNRRtY58JNnTGkKv5wsHUD6jb8+DkGPzePwfpqlduAQ
         P4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hoEBUiTCwylfQM5EEmwmQxs9tkcUGgbQm8NoluRGKXI=;
        b=2rOQreKXXZTpnuFSTFnbVcbsjF6umAwYcsuxhZu+cme4Q0bmQAa7zITWI4ZZNLNeY1
         VaXqdL0MAe6KpavPbfVzkqddTbukyRJa2jslCimftfHTdOKZL0jr30u17VRJR5scT5mx
         03esf8o0OGPYy1IG9RLplQaHPTGA4347UTZhDGc5MR6I6TXeYH2Ov2A43yEhaZXRQy8y
         BrNwUPdAANQeJa9WIqukBydJAxm6KSVqjiLoI7sQV4S+8I9RIE0Vw+iwtVWMN5jwCR6w
         zTgAg/t9vlmWI43nYsFwW0FhsIkr33JLzBCKW+lp89Y4rhtrmSQD0PPd9Z0EmsUolahm
         xLwQ==
X-Gm-Message-State: AOAM531VnEbqX2H0U82/Hh5a0P1AJYAbqjcKTLYpkO5Ypiwn0ZtuB3fH
        +nMQjNM/sZ3t9nyNNsFM8MY5+tgaZW8=
X-Google-Smtp-Source: ABdhPJxmRtKtRPjnGHve/u/vX8sSw2IYVNA0qQDZvb48e34vQiq4XXfLvRnp9BzV9WDkGsXBR9Xbcw==
X-Received: by 2002:adf:f508:0:b0:207:a8fe:c8bd with SMTP id q8-20020adff508000000b00207a8fec8bdmr15293309wro.313.1650458494844;
        Wed, 20 Apr 2022 05:41:34 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-244-154.dab.02.net. [82.132.244.154])
        by smtp.gmail.com with ESMTPSA id v11-20020adfa1cb000000b0020ab21e1e61sm971322wrv.51.2022.04.20.05.41.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 05:41:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/3] io_uring: move tout locking in io_timeout_cancel()
Date:   Wed, 20 Apr 2022 13:40:54 +0100
Message-Id: <cde758c2897930d31e205ed8f476d4ec879a8849.1650458197.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650458197.git.asml.silence@gmail.com>
References: <cover.1650458197.git.asml.silence@gmail.com>
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

Move ->timeout_lock grabbing inside of io_timeout_cancel(), so
we can do io_req_task_queue_fail() outside of the lock. It's much nicer
than relying on triple nested locking.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2b9a3af9ff42..ce5941537b64 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6489,7 +6489,11 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	__must_hold(&ctx->completion_lock)
 	__must_hold(&ctx->timeout_lock)
 {
-	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
+	struct io_kiocb *req;
+
+	spin_lock_irq(&ctx->timeout_lock);
+	req = io_timeout_extract(ctx, user_data);
+	spin_unlock_irq(&ctx->timeout_lock);
 
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -6608,9 +6612,7 @@ static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!(req->timeout_rem.flags & IORING_TIMEOUT_UPDATE)) {
 		spin_lock(&ctx->completion_lock);
-		spin_lock_irq(&ctx->timeout_lock);
 		ret = io_timeout_cancel(ctx, tr->addr);
-		spin_unlock_irq(&ctx->timeout_lock);
 		spin_unlock(&ctx->completion_lock);
 	} else {
 		enum hrtimer_mode mode = io_translate_timeout_mode(tr->flags);
@@ -6796,10 +6798,7 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
 	ret = io_poll_cancel(ctx, sqe_addr, false);
 	if (ret != -ENOENT)
 		goto out;
-
-	spin_lock_irq(&ctx->timeout_lock);
 	ret = io_timeout_cancel(ctx, sqe_addr);
-	spin_unlock_irq(&ctx->timeout_lock);
 out:
 	spin_unlock(&ctx->completion_lock);
 	return ret;
-- 
2.36.0

