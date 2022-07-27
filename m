Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9404E58232A
	for <lists+io-uring@lfdr.de>; Wed, 27 Jul 2022 11:33:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiG0JdU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jul 2022 05:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbiG0JdS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jul 2022 05:33:18 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B16286D0
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 02:33:17 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id i8so414914wro.11
        for <io-uring@vger.kernel.org>; Wed, 27 Jul 2022 02:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fQynxLZkg5Bfv1QIdRQPWQ9ZPxrOKEcJMluHF9Wmzco=;
        b=gHtjTT2XLjipGL5tsODby5dZ7UXydQfqcw4gGOj7lwdG7QqFcGFm3qNNGPxeJQ/Dxd
         v4V9u4U2vhB9laXJ9wrbTsezzXB0pRyuN4tuq7cC8OQJY11Rm0jTvFT6jJtiFoQMZXip
         ajGdzZ4U8DUZhBTt8DkSYMiYASKcvhLbLslN2A3GFT9rd9UcjQ1RAaM1YR0NuPFuNV8i
         1jnsl3vQBzEdSxknRJ/Qlb1UPQnmbVV9viYuEigrz3vY5H43tKIvrNs2avSxagblCOIs
         1KFSC48hwDAgl+dMUkn+fxWJo6iiNXCu5s0U/JlcR8MG0pO4zh/42sXkoYL9xfpUiZWu
         cxww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fQynxLZkg5Bfv1QIdRQPWQ9ZPxrOKEcJMluHF9Wmzco=;
        b=w3miUGI9BDv6esExi4Z84Xo17KH9hPZ7fNVWjsBr/TbMPeSjKm9Ha9SAQWdRQm7Xd2
         bZUxanAyQtSYmjY6WubSPBrsAe4syLwFLKhpuw2nvYpfo/irk5eaDfZe3v5er+iN8WlN
         WjmNRfV8b5IePpl+XGkdvGzEvnaH5Tu+BCAu5S6RaYfKmsT0uorMIR0GMo6GNI4bW1Zl
         KaEf4ZSwwFq8gfNyur0KVdPbAxK5jQtHAHMnX5gl1KZ2wUO+1Nxc1KmCZ8UftNkDzA7U
         xq6D/BkPRkT9ZkfR0morT03lhZhREjKPmzc6G8VxrZJXHGWkpgTzktrkyEOqM6dJiEOu
         trbw==
X-Gm-Message-State: AJIora9xmW6hBbhaJqbCQ+hSdOBK7cLhkhmdTFq5qaINdmpAQ3NpfZdP
        uktlwk6gfmyxUEDUdaTcRvF4ugtat/i9zw==
X-Google-Smtp-Source: AGRyM1sVPDm6WJoZ/NdRj3FDTFs7g+8J6TqQ14nScHoVmZS4nmqGfae5sStMwqRqX5Wm6hcF5Pf9ZQ==
X-Received: by 2002:a5d:59a8:0:b0:21d:8a9d:732b with SMTP id p8-20020a5d59a8000000b0021d8a9d732bmr12970276wrr.28.1658914395621;
        Wed, 27 Jul 2022 02:33:15 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c093:600::1:754a])
        by smtp.gmail.com with ESMTPSA id v1-20020adfe281000000b0021e5adb92desm15605302wri.60.2022.07.27.02.33.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jul 2022 02:33:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 1/2] io_uring: export req alloc from core
Date:   Wed, 27 Jul 2022 10:30:40 +0100
Message-Id: <0314fedd3a02a514210ba42d4720332538c65956.1658913593.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658913593.git.asml.silence@gmail.com>
References: <cover.1658913593.git.asml.silence@gmail.com>
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

We want to do request allocation out of the core io_uring code, make the
allocation functions public for other io_uring parts.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 22 +---------------------
 io_uring/io_uring.h | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 1d600a63643b..822819d0f607 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -852,18 +852,13 @@ static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 	spin_unlock(&ctx->completion_lock);
 }
 
-static inline bool io_req_cache_empty(struct io_ring_ctx *ctx)
-{
-	return !ctx->submit_state.free_list.next;
-}
-
 /*
  * A request might get retired back into the request caches even before opcode
  * handlers and io_issue_sqe() are done with it, e.g. inline completion path.
  * Because of that, io_alloc_req() should be called only under ->uring_lock
  * and with extra caution to not get a request that is still worked on.
  */
-static __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
+__cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
@@ -904,21 +899,6 @@ static __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	return true;
 }
 
-static inline bool io_alloc_req_refill(struct io_ring_ctx *ctx)
-{
-	if (unlikely(io_req_cache_empty(ctx)))
-		return __io_alloc_req_refill(ctx);
-	return true;
-}
-
-static inline struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
-{
-	struct io_wq_work_node *node;
-
-	node = wq_stack_extract(&ctx->submit_state.free_list);
-	return container_of(node, struct io_kiocb, comp_list);
-}
-
 static inline void io_dismantle_req(struct io_kiocb *req)
 {
 	unsigned int flags = req->flags;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index cc81a9d1fd4d..2f73f83af960 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -75,6 +75,7 @@ void io_free_req(struct io_kiocb *req);
 void io_queue_next(struct io_kiocb *req);
 void __io_put_task(struct task_struct *task, int nr);
 void io_task_refs_refill(struct io_uring_task *tctx);
+bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
@@ -280,4 +281,24 @@ static inline void io_get_task_refs(int nr)
 		io_task_refs_refill(tctx);
 }
 
+static inline bool io_req_cache_empty(struct io_ring_ctx *ctx)
+{
+	return !ctx->submit_state.free_list.next;
+}
+
+static inline bool io_alloc_req_refill(struct io_ring_ctx *ctx)
+{
+	if (unlikely(io_req_cache_empty(ctx)))
+		return __io_alloc_req_refill(ctx);
+	return true;
+}
+
+static inline struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
+{
+	struct io_wq_work_node *node;
+
+	node = wq_stack_extract(&ctx->submit_state.free_list);
+	return container_of(node, struct io_kiocb, comp_list);
+}
+
 #endif
-- 
2.37.0

