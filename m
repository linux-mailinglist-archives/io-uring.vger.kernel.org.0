Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 827EE4DBCD5
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 03:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358423AbiCQCGW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 22:06:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358427AbiCQCGT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 22:06:19 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C9381EAE8
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:05:01 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id m12so4852612edc.12
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=U3M6eAjqTEsQe3B4WXnBdsBGUdh7aRt4QVvDKHknjdM=;
        b=lei/g7TFioqZMQ/luOA1yU2dfITqnqVXbdu1kRMeNJqLsw6g60pj121h0LOasho8J3
         8Mk4kJCmatWQBTI5Ra5unEpIbbJsZIo+QWsxIYlxltKwC7N8cNRn/UL98kyEIYudWmQk
         bUdllmmtwxEw5xnoKFVDCUeCUcpcb2mdm948wBLnlY3bfLGmIY1f5ssE5FprgJWNS019
         pi0x8Wi1BiN7kIyMw13NXRoiHQfZEoQtfAmVH6/wbqgCzI0h2aMFwzH0tlFXQ/qsx0Se
         Zf6x6VOlkvSBqegbmP6/wFHXCKP5aNZ39kfoHEB4mC4yQTsYVckkPhtGFTvf9cHhTFT0
         AZYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=U3M6eAjqTEsQe3B4WXnBdsBGUdh7aRt4QVvDKHknjdM=;
        b=cVit+TrYrl50z90O9Wl/TcGGJhewphn0ulfXNrWkDaWOzNodhO3vN5Jq93UAcs4Cvz
         QxFN/K84kbX2y4YGcSkHTdaY+K7Gv1kAHI6wP6eH6ARNCUzgUAssG1DrdT/UNiokjzo6
         0YSLnnZNo+PTEY69Q8gT+cQqJJy9IawegF8n6SqDGyGd3azSDq4w7fiFNA8HyLhiAp69
         6/ZZNh4fveZ4q7VfGIgH1Ibqy6jMHT847smb9ElgpGI1Fb+LdnvSDpjDEq+CiZR0ka09
         KE2NFNDdXhPo4VY0oscxmZHXAHZFabd254J10JeBSYDzgkIwYXesiqnmgMIwGNb7vOH3
         xMEA==
X-Gm-Message-State: AOAM533NWVlCIO4Y8msjfjZhSfD+hrst8jSQ2O5J2Gqx84vpJyknDpuM
        Uq5CY0OtwokqtrXs5/wOHkt02cAuqqe+Tw==
X-Google-Smtp-Source: ABdhPJwKzUJbACOP00i/hb53SgCp6vq3vYwPCFnXd1mouMnHstXu58helQzOUMfV8TeHo/WwZzDRhQ==
X-Received: by 2002:aa7:c34d:0:b0:418:c96a:cb58 with SMTP id j13-20020aa7c34d000000b00418c96acb58mr2057571edr.49.1647482699772;
        Wed, 16 Mar 2022 19:04:59 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.67])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7df9a000000b00416b3005c4bsm1876048edy.46.2022.03.16.19.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 19:04:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 4/7] io_uring: remove extra barrier for non-sqpoll iopoll
Date:   Thu, 17 Mar 2022 02:03:39 +0000
Message-Id: <d72e8ef6f7a3f6a72e18fad8409f7d47afc8da7d.1647481208.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647481208.git.asml.silence@gmail.com>
References: <cover.1647481208.git.asml.silence@gmail.com>
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

smp_mb() in io_cqring_ev_posted_iopoll() is only there because of
waitqueue_active(). However, non-SQPOLL IOPOLL ring doesn't wake the CQ
and so the barrier there is useless. Kill it, it's usually pretty
expensive.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bbbbf889dfd8..603cbe687dd2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1869,11 +1869,8 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 {
-	/* see waitqueue_active() comment */
-	smp_mb();
-
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		if (waitqueue_active(&ctx->cq_wait))
+		if (wq_has_sleeper(&ctx->cq_wait))
 			wake_up_all(&ctx->cq_wait);
 	}
 	io_eventfd_signal(ctx);
-- 
2.35.1

