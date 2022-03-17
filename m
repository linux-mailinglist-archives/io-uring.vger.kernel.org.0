Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA59B4DBCD9
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 03:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358424AbiCQCGY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 22:06:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358433AbiCQCGU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 22:06:20 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 977F11EACC
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:05:02 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id bg10so7861800ejb.4
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:05:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=JWPU7HAiFaon0o2bD0/q7YCTL0rG4zdvVUhd1m4Z6RM=;
        b=aOUd3oS0NX5Ln3XxtgXA1V7tQFWcotzei+ZE1p5+jIXGpTL0YJr4+YlWPD67lgO+Tw
         fW4x/IEAdFCJQZ+5dy3Y8iW2tBmx5w1b7coLzDAp90mGjCeauN+AiK++4ySl6zxtfhOY
         BoPvgc8xy2WLqN7Um+uU9pqFqva7akNllUKLXg09e+PiKohlwLmWAq3iICNvEjsNGXQE
         fNbfdTQ9wBXGa8QyXGBV76p3ExxwOFkZAQ6u2GhG0bdWrytaHi4Re6+RIDscPe0siBDk
         eYOlOPfKHscEQtxAZ9I4nL+tJDZNJUVpk2ggkHYe6iwnug7T1CEPsqjzYAfg0C9hKIiP
         p14A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JWPU7HAiFaon0o2bD0/q7YCTL0rG4zdvVUhd1m4Z6RM=;
        b=gyvKhd+YtRRmmj4DHwrzuiqVbZio0fsemRoP60CMGIiduSOc+hsPpICibM2IUihDpB
         GL47M5spmo5Wzisx4flI3jfofITm0MlCVYfzfRxEld+Iiwac/NlwKbMeEWUPfHAe0qF2
         +LFWl45C7nIE4LTebmN9D3sZHOXFR497O4XEemnEsEUYSHEikUmx7epu+uPmR0JUbNBs
         PnOGVAfoQsUjLW1s/juIn6MXEgaoH3YOnXf/F79FFNZaOJNcKZPP7heVpTkozqXQDXY0
         r/s5gStaLzrNd41B8CQJ5UaPzLQBhMG2EFIuYNAndKyD7h3H6bsfCVr11S3uENC0HOJG
         ATZg==
X-Gm-Message-State: AOAM532W9SD99DLwZcuGUILDYkpjjdG9AcWOMaYVYGt9qmiET6hqNrEQ
        CR61ke+oBVq06OnkBWxKYIwlzxqkcQQhvA==
X-Google-Smtp-Source: ABdhPJx4frbz+ds0b+l51Prq5Zrr2JCWzmKR8Xd53ddtdJewMlTtm+yJzqbhGUon+iPA65/yKCI7wg==
X-Received: by 2002:a17:907:a41f:b0:6d6:f925:1696 with SMTP id sg31-20020a170907a41f00b006d6f9251696mr2395414ejc.62.1647482700970;
        Wed, 16 Mar 2022 19:05:00 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.67])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7df9a000000b00416b3005c4bsm1876048edy.46.2022.03.16.19.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 19:05:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/7] io_uring: shuffle io_eventfd_signal() bits around
Date:   Thu, 17 Mar 2022 02:03:40 +0000
Message-Id: <ec4091ac76d43912b73917e8db651c2dac4b7b01.1647481208.git.asml.silence@gmail.com>
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

A preparation patch, which moves a fast ->io_ev_fd check out of
io_eventfd_signal() into ev_posted*(). Compilers are smart enough for it
to not change anything, but will need it later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 603cbe687dd2..5a87e0622ecb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1820,10 +1820,6 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 {
 	struct io_ev_fd *ev_fd;
 
-	/* Return quickly if ctx->io_ev_fd doesn't exist */
-	if (likely(!rcu_dereference_raw(ctx->io_ev_fd)))
-		return;
-
 	rcu_read_lock();
 	/*
 	 * rcu_dereference ctx->io_ev_fd once and use it for both for checking
@@ -1843,7 +1839,6 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 
 	if (!ev_fd->eventfd_async || io_wq_current_is_worker())
 		eventfd_signal(ev_fd->cq_ev_fd, 1);
-
 out:
 	rcu_read_unlock();
 }
@@ -1855,7 +1850,7 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
  * 1:1 relationship between how many times this function is called (and
  * hence the eventfd count) and number of CQEs posted to the CQ ring.
  */
-static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
+static inline void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
 	/*
 	 * wake_up_all() may seem excessive, but io_wake_function() and
@@ -1864,7 +1859,8 @@ static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 	 */
 	if (wq_has_sleeper(&ctx->cq_wait))
 		wake_up_all(&ctx->cq_wait);
-	io_eventfd_signal(ctx);
+	if (unlikely(rcu_dereference_raw(ctx->io_ev_fd)))
+		io_eventfd_signal(ctx);
 }
 
 static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
@@ -1873,7 +1869,8 @@ static void io_cqring_ev_posted_iopoll(struct io_ring_ctx *ctx)
 		if (wq_has_sleeper(&ctx->cq_wait))
 			wake_up_all(&ctx->cq_wait);
 	}
-	io_eventfd_signal(ctx);
+	if (unlikely(rcu_dereference_raw(ctx->io_ev_fd)))
+		io_eventfd_signal(ctx);
 }
 
 /* Returns true if there are no backlogged entries after the flush */
-- 
2.35.1

