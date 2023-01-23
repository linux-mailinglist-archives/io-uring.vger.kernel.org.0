Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0A27677E42
	for <lists+io-uring@lfdr.de>; Mon, 23 Jan 2023 15:42:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231131AbjAWOmO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Jan 2023 09:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231274AbjAWOmO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Jan 2023 09:42:14 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6408621A0F
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:13 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id r2so11015398wrv.7
        for <io-uring@vger.kernel.org>; Mon, 23 Jan 2023 06:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y/gwzENu7t4nMdkMhSj5Kug78/grQEpfrseTPk5aKbs=;
        b=EgVyv1lhLgLuxvvizCiU1TURdoNYztMwMHfHJMD7F9smRI/4EwwOC8hlFNhG+s+xfB
         lNGTW61BC+DFCZwQffckOTYg2QxQUuyfK7Fq1ShmUd1FOBSDoOc5YNzgKy5dU8Cbzhoz
         A1/XJYQsveJ26eUU+Ll+6Ynfj2DaR27dIDWO5Cdq3fYWUkLlPKTDe0TfQm2iTpjWvBl3
         ccABb+J2uxZt5vwVzthZdR5da8WuugVJCsY4zwOaHEwkkNdEAIwjcQFUAGOP21yaA8+i
         CR1XyluCwWfycUHNRT8xoNNTK6Axl7cc0r1wfPq73hoiINVPVJ5So6/+Mcqds9bJ9Tw+
         foiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y/gwzENu7t4nMdkMhSj5Kug78/grQEpfrseTPk5aKbs=;
        b=zUUWKINUOLiiQ0AQEPzbk+5mnB6XcrzsGsOkoGVqMRy7x6fMwwbV6JwbbzbzoTXC3o
         u9MLdv8pLDhOLjlPrlnFjekbz10RbAbo/luRsb1AAX8HqZauppS0wPnQ9gGt7Pb5Ynpq
         S1JCmkmurVHAiv7B+y3v00OSsPKb/aUB4WSaPQSO4i5SNQM1Hs3iJHiYhCpT3jK8amVL
         NPmOzWQOXAmjpYHQ8A6BdxKcLGCUyB4DgqLOqe0cRu5Xz0oLKafdUOrBI0YTcgDPOipH
         iMP9Dpf3N16fyoL5UbyCNks95RqiRnMPIgOn16i6O1NwoMeZCS/G0VknVthndNJ9+v95
         nuqg==
X-Gm-Message-State: AFqh2kqaGTZp0jazyvtc3j21hd+mr4TLoLoq3eg1M9uNJDKR3Dp9ziZz
        WG0PYdSow2VjrTSbKO/V76TMyTRUn5k=
X-Google-Smtp-Source: AMrXdXu+XmBXgUrz7ZR2LQ6Cu4wRW5Y32YTiPtT4intQdJ3rKOJruEv8Q7ZA/hJ17F+8cFKeny7Xqg==
X-Received: by 2002:adf:eb8f:0:b0:2be:34fa:786b with SMTP id t15-20020adfeb8f000000b002be34fa786bmr16227834wrn.38.1674484931720;
        Mon, 23 Jan 2023 06:42:11 -0800 (PST)
Received: from 127.0.0.1localhost (188.30.84.186.threembb.co.uk. [188.30.84.186])
        by smtp.gmail.com with ESMTPSA id d24-20020adfa358000000b00236883f2f5csm3250534wrb.94.2023.01.23.06.42.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Jan 2023 06:42:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/7] io_uring: refactor req allocation
Date:   Mon, 23 Jan 2023 14:37:16 +0000
Message-Id: <8c37c2e8a3cb5e4cd6a8ae3b91371227a92708a6.1674484266.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674484266.git.asml.silence@gmail.com>
References: <cover.1674484266.git.asml.silence@gmail.com>
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

Follow the io_get_sqe pattern returning the result via a pointer
and hide request cache refill inside io_alloc_req().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  7 +++----
 io_uring/io_uring.h | 19 +++++++++++--------
 io_uring/notif.c    |  3 +--
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6af11a60dc8a..8a99791a507a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2417,9 +2417,8 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
 
-		if (unlikely(!io_alloc_req_refill(ctx)))
+		if (unlikely(!io_alloc_req(ctx, &req)))
 			break;
-		req = io_alloc_req(ctx);
 		if (unlikely(!io_get_sqe(ctx, &sqe))) {
 			io_req_add_to_cache(req, ctx);
 			break;
@@ -2738,14 +2737,14 @@ static int io_eventfd_unregister(struct io_ring_ctx *ctx)
 
 static void io_req_caches_free(struct io_ring_ctx *ctx)
 {
+	struct io_kiocb *req;
 	int nr = 0;
 
 	mutex_lock(&ctx->uring_lock);
 	io_flush_cached_locked_reqs(ctx, &ctx->submit_state);
 
 	while (!io_req_cache_empty(ctx)) {
-		struct io_kiocb *req = io_alloc_req(ctx);
-
+		req = io_extract_req(ctx);
 		kmem_cache_free(req_cachep, req);
 		nr++;
 	}
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 3ee6fc74f020..1cc6c2a8696b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -333,16 +333,9 @@ static inline bool io_req_cache_empty(struct io_ring_ctx *ctx)
 	return !ctx->submit_state.free_list.next;
 }
 
-static inline bool io_alloc_req_refill(struct io_ring_ctx *ctx)
-{
-	if (unlikely(io_req_cache_empty(ctx)))
-		return __io_alloc_req_refill(ctx);
-	return true;
-}
-
 extern struct kmem_cache *req_cachep;
 
-static inline struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
+static inline struct io_kiocb *io_extract_req(struct io_ring_ctx *ctx)
 {
 	struct io_kiocb *req;
 
@@ -352,6 +345,16 @@ static inline struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
 	return req;
 }
 
+static inline bool io_alloc_req(struct io_ring_ctx *ctx, struct io_kiocb **req)
+{
+	if (unlikely(io_req_cache_empty(ctx))) {
+		if (!__io_alloc_req_refill(ctx))
+			return false;
+	}
+	*req = io_extract_req(ctx);
+	return true;
+}
+
 static inline bool io_allowed_defer_tw_run(struct io_ring_ctx *ctx)
 {
 	return likely(ctx->submitter_task == current);
diff --git a/io_uring/notif.c b/io_uring/notif.c
index c4bb793ebf0e..09dfd0832d19 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -68,9 +68,8 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	struct io_kiocb *notif;
 	struct io_notif_data *nd;
 
-	if (unlikely(!io_alloc_req_refill(ctx)))
+	if (unlikely(!io_alloc_req(ctx, &notif)))
 		return NULL;
-	notif = io_alloc_req(ctx);
 	notif->opcode = IORING_OP_NOP;
 	notif->flags = 0;
 	notif->file = NULL;
-- 
2.38.1

