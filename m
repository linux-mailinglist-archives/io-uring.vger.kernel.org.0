Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3787D6D97EE
	for <lists+io-uring@lfdr.de>; Thu,  6 Apr 2023 15:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbjDFNVE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Apr 2023 09:21:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238194AbjDFNU6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Apr 2023 09:20:58 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C7DEA247;
        Thu,  6 Apr 2023 06:20:26 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-5002e950e23so1106603a12.1;
        Thu, 06 Apr 2023 06:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680787225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0P/A55sLOHJRbU1KHHDwi5FVeFyN2Okmbek6N7Le9GE=;
        b=XZtiB11LYu2Mbw9kRBm4PjXbKhMDnbKNQ+XdPxc/hE283xc2gRRqWXZIut13AASAdQ
         cL4/ezsKzXHNp5Il6f9ukuXn8JBY38gKaZTzAqTcDNNdUzkTa8Vbs+ijkQLzH8ylebkh
         O6AC8TmYcLxzBUtBn+X0Uq6VpTJaF7mZUru7Fopghshko6cFWW5pxgZ9OMY3UtF2rEPk
         dG0c6e/V2yv8pAxLlJwLTFsX1HRFlb2dls8CyXXmhFV3pOWlwzXbjpXeUuN6+H4SwXzg
         AnKpJEYWcSrWOzg6Xb+j4jkfLeuO5XvPc+FAV8qCjlWS4JoZ1UYkK9+b6ZDgBB5O9iJm
         tWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680787225;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0P/A55sLOHJRbU1KHHDwi5FVeFyN2Okmbek6N7Le9GE=;
        b=dVKaOsscGWSjRh895vg3vuW6WBqU9jJV1AjrliHnONyvLXs7YGsnkoCbeStKLz7LwF
         nw1Vp9gZgOCfjl+y/EVMF/DI9rrHgdaSOkGrJVx5sa3ciqJr6BuDqiumD+leZS4H1Cdx
         Ltu9dqweWXx5X9STsazSRRTByv7YeQUtomPcM4wNXYvqnDZRksJ5iIftIyD/fX45w0uz
         Rrfs/rzqXAQ9WMdrEd6FGjd8jG1GX4eMrSqIh0UCoWzzC6r/MKeLJmSoma4joKNXF3TZ
         4pWL0/LqptOKRP2/yd60aZAz6QRsWp8xGUXvsDhlMuSdf3Dg6b9opXrMQoiKDVOrO0yW
         eg3w==
X-Gm-Message-State: AAQBX9c9pxyxySF1dYzP8Qqh7AymW8RNU7u/6bpZEZ6JM3o7qebqeSM1
        h3o9733rQWBahCyh8fGehfhOFXMBOO0=
X-Google-Smtp-Source: AKy350ZHdcxGcANxNJDAWob5UDwkyXqr+5PXsWTs2s8LktRqsw0ZpXxz31AGaXNLZMCoGlJ1SOVzdg==
X-Received: by 2002:aa7:ccce:0:b0:502:3376:7872 with SMTP id y14-20020aa7ccce000000b0050233767872mr5748603edt.35.1680787224697;
        Thu, 06 Apr 2023 06:20:24 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a638])
        by smtp.gmail.com with ESMTPSA id m20-20020a509994000000b0050470aa444fsm312732edb.51.2023.04.06.06.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:20:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/8] io_uring: refactor __io_cq_unlock_post_flush()
Date:   Thu,  6 Apr 2023 14:20:09 +0100
Message-Id: <662ee5d898168ac206be06038525e97b64072a46.1680782017.git.asml.silence@gmail.com>
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

Instead of smp_mb() + __io_cqring_wake() in __io_cq_unlock_post_flush()
use equivalent io_cqring_wake(). With that we can clean it up further
and remove __io_cqring_wake().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  6 ++----
 io_uring/io_uring.h | 11 ++---------
 2 files changed, 4 insertions(+), 13 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index fb7215b543cd..d4ac62de2113 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -640,10 +640,8 @@ static inline void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
 	 * it will re-check the wakeup conditions once we return we can safely
 	 * skip waking it up.
 	 */
-	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN)) {
-		smp_mb();
-		__io_cqring_wake(ctx);
-	}
+	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
+		io_cqring_wake(ctx);
 }
 
 void io_cq_unlock_post(struct io_ring_ctx *ctx)
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 193b2db39fe8..24d8196bbca3 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -228,8 +228,7 @@ static inline void io_poll_wq_wake(struct io_ring_ctx *ctx)
 				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 }
 
-/* requires smb_mb() prior, see wq_has_sleeper() */
-static inline void __io_cqring_wake(struct io_ring_ctx *ctx)
+static inline void io_cqring_wake(struct io_ring_ctx *ctx)
 {
 	/*
 	 * Trigger waitqueue handler on all waiters on our waitqueue. This
@@ -241,17 +240,11 @@ static inline void __io_cqring_wake(struct io_ring_ctx *ctx)
 	 * waitqueue handlers, we know we have a dependency between eventfd or
 	 * epoll and should terminate multishot poll at that point.
 	 */
-	if (waitqueue_active(&ctx->cq_wait))
+	if (wq_has_sleeper(&ctx->cq_wait))
 		__wake_up(&ctx->cq_wait, TASK_NORMAL, 0,
 				poll_to_key(EPOLL_URING_WAKE | EPOLLIN));
 }
 
-static inline void io_cqring_wake(struct io_ring_ctx *ctx)
-{
-	smp_mb();
-	__io_cqring_wake(ctx);
-}
-
 static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 {
 	struct io_rings *r = ctx->rings;
-- 
2.40.0

