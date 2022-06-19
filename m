Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ABCA550A31
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 13:26:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiFSL0r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 07:26:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235295AbiFSL0q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 07:26:46 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEDB66153
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 04:26:45 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id v14so11090061wra.5
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 04:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/LavPulCuHLlYsXb/c3AGIbqLtOcsN8l0Dc366IHheI=;
        b=byhn4/9T3b7OKrK5M5uu8rr1ce7LHDRqo1+2kyIh/bRBPvX+rxgCD0rTE2OuP8Q6d4
         hSpVRMGT+Jgk/g0cXk3SazLaGvIsT6iQm/KWudl8KX2Apdvi3OzPRVWqQAe/8Qs+TAvv
         rvvLFC8Pwur8Tl6fn9KOO9KLuPsz9LzAsvvxU9Ihj+EW/nYTQp6mo74H8Ka+ZZ0e/ZI0
         BIPbY+Hq7+XLFqpzMxNTFD3yNubg8v4LkfziS0VCezE91zqtSctsmkNw3cwt1aLjKQvQ
         qZWibiauvIcZXLd6ekGm/U7oqDelNtk2+4BWNyVIuMx1YdSb+Kpi0nnJ9c9d9r5Rd6Ci
         /U+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/LavPulCuHLlYsXb/c3AGIbqLtOcsN8l0Dc366IHheI=;
        b=hcrS3y/NhvVI9ApYhyptHb1Y2cXk+unxfaCJfDQWJl5RuRM9KxnZbHpaXVlZCN5m0w
         AxrZ8GQGsK3zS8yiTz/NYzEJdnGsaNMxNfgYo00sVg7IUK+mVug5qUP/K1lK+69suPcn
         MD9GnaPuTxW+5CYF4pzaZL4rXnY1hS7gf2/jwIwWa04Bk60nIxokH88tje9Jbsk8plCh
         d7N7fGnwoPeZpVyFM0EltmliMkKRI5TOumgRUKn6BlcQIoukZvwxskXRWlC69BJZg2hK
         DLinE4ZBzFgEwIpkkxEHqVpk3ubNkRKqfrjgUblF4MmlY5hdyV9swnV9eThFUEwloKj0
         jRTA==
X-Gm-Message-State: AJIora84e/zpg6BhkAYdT/sQi2X0NS3S35tJmc508oYzsek17niJCwEd
        rV/jkfaChBUnBJTV7RSquFJdKRfvO8UcLg==
X-Google-Smtp-Source: AGRyM1vcgqkdadFTL9ZtPssy6sEq3o8SG7Ue1MXxf5qquABhqxYvKpVzIr6wi15S+S+GxtS0J31Z2Q==
X-Received: by 2002:a05:6000:1788:b0:219:e28f:dc98 with SMTP id e8-20020a056000178800b00219e28fdc98mr17747166wrg.144.1655638004291;
        Sun, 19 Jun 2022 04:26:44 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id y14-20020adfee0e000000b002119c1a03e4sm9921653wrn.31.2022.06.19.04.26.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 04:26:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/7] io_uring: move io_eventfd_signal()
Date:   Sun, 19 Jun 2022 12:26:06 +0100
Message-Id: <9ebebb3f6f56f5a5448a621e0b6a537720c43334.1655637157.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655637157.git.asml.silence@gmail.com>
References: <cover.1655637157.git.asml.silence@gmail.com>
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

Move io_eventfd_signal() in the sources without any changes and kill its
forward declaration.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 30 ++++++++++++++----------------
 1 file changed, 14 insertions(+), 16 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9e02c4a950ef..31beb9ccbf12 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -142,8 +142,6 @@ static void io_queue_sqe(struct io_kiocb *req);
 
 static void __io_submit_flush_completions(struct io_ring_ctx *ctx);
 
-static void io_eventfd_signal(struct io_ring_ctx *ctx);
-
 static struct kmem_cache *req_cachep;
 
 struct sock *io_uring_get_socket(struct file *file)
@@ -472,20 +470,6 @@ static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
 	}
 }
 
-void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
-{
-	if (ctx->off_timeout_used || ctx->drain_active) {
-		spin_lock(&ctx->completion_lock);
-		if (ctx->off_timeout_used)
-			io_flush_timeouts(ctx);
-		if (ctx->drain_active)
-			io_queue_deferred(ctx);
-		spin_unlock(&ctx->completion_lock);
-	}
-	if (ctx->has_evfd)
-		io_eventfd_signal(ctx);
-}
-
 static void io_eventfd_signal(struct io_ring_ctx *ctx)
 {
 	struct io_ev_fd *ev_fd;
@@ -513,6 +497,20 @@ static void io_eventfd_signal(struct io_ring_ctx *ctx)
 	rcu_read_unlock();
 }
 
+void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
+{
+	if (ctx->off_timeout_used || ctx->drain_active) {
+		spin_lock(&ctx->completion_lock);
+		if (ctx->off_timeout_used)
+			io_flush_timeouts(ctx);
+		if (ctx->drain_active)
+			io_queue_deferred(ctx);
+		spin_unlock(&ctx->completion_lock);
+	}
+	if (ctx->has_evfd)
+		io_eventfd_signal(ctx);
+}
+
 /*
  * This should only get called when at least one event has been posted.
  * Some applications rely on the eventfd notification count only changing
-- 
2.36.1

