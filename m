Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB1AA787BB4
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243968AbjHXWzo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244024AbjHXWzc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:32 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 358E41FC4
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:24 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-529fb2c6583so537149a12.1
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917722; x=1693522522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ofRW9/wUGWpYyVONjUTn3Q1b6uINI4jGUtdfvGoE5vc=;
        b=nYLiIhJNECLHJxPonMWN3yRXfIQ8q1wr5vnivlZX0+pG2trL8SScuet9zBKObhPLxp
         l6S4DjWUYBtInX9Ym73tQRJtSPNCdyxBL+ouAy/L5RqzbDFwddiHyagioqO4BoeZaOO6
         FFC/SodjAhk2PQnIaxepoMZa49Jru7XE5HdWP4EHA6p8VTHkf8F8XlpAqm416boCkMiu
         2Jic65/+olut6dPBLSSuEXGVtErH3Z4RpCWIZGaS+GWjfAm3EDPaxyBEMqY4EriFpI1n
         ovkpP5T1ecYP2HYxvBd9tF2smEw+JUKLjIhd5cndOruY7ejbx/6dR6eqwOqhtuVBppPA
         AT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917722; x=1693522522;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ofRW9/wUGWpYyVONjUTn3Q1b6uINI4jGUtdfvGoE5vc=;
        b=FysfPNJxPWwh6Lylmgh6Nu9eQ9BmLctsiceH8gKFFTA3zdKENLUCeajez6TZcmNesa
         rAnTxIF/g2Yv8fEbC2LwZAL5nomm8Xo1h6A0eRVIy1rtY4dYy4/UYKyVP9DEeMXYfbnK
         DcGwKZxp7WSbuWc2UYNuObHgCxbsOkTatvKVyjLEU/T2W3gezK6cRs8o1P+ATz/VXsi8
         +mdZ5BNeNcucqwJDp12QIttOZ+oizZUsww//WWqi/whiXwnPpQN87/1YeLaOddM38Fw+
         Lxth0WSr1XyGUcRxhqpx/q67dp7PPERp5raTZg37dFY46uYxTwxpyisvfiIWVfsugFfj
         ClWw==
X-Gm-Message-State: AOJu0Yyfsga6aj4ccyK1iyNbRM9qJ2LIlowJpdya7qaNOimhDvlb+jnQ
        +xsXFmH0nC4Fxwg7jdZD+i2e3+khuFE=
X-Google-Smtp-Source: AGHT+IGfNYk06nQxsak/4bCdpxun/PbHqZNSohSW5GzQ5+T18uoql8jMsBNrAaFvjh00VRwSw+qCxQ==
X-Received: by 2002:a17:906:105c:b0:9a1:72f9:49fe with SMTP id j28-20020a170906105c00b009a172f949femr13780203ejj.65.1692917722274;
        Thu, 24 Aug 2023 15:55:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 05/15] io_uring: optimise extra io_get_cqe null check
Date:   Thu, 24 Aug 2023 23:53:27 +0100
Message-ID: <322ea4d3377d3d4efd8ae90ab8ed28a99f518210.1692916914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692916914.git.asml.silence@gmail.com>
References: <cover.1692916914.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the cached cqe check passes in io_get_cqe*() it already means that
the cqe we return is valid and non-zero, however the compiler is unable
to optimise null checks like in io_fill_cqe_req().

Do a bit of trickery, return success/fail boolean from io_get_cqe*()
and store cqe in the cqe parameter. That makes it do the right thing,
erasing the check together with the introduced indirection.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c |  7 +++----
 io_uring/io_uring.h | 20 +++++++++-----------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index de05831eeca7..cfc2dc8c4b2f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -683,10 +683,10 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx)
 
 	io_cq_lock(ctx);
 	while (!list_empty(&ctx->cq_overflow_list)) {
-		struct io_uring_cqe *cqe = io_get_cqe_overflow(ctx, true);
+		struct io_uring_cqe *cqe;
 		struct io_overflow_cqe *ocqe;
 
-		if (!cqe)
+		if (!io_get_cqe_overflow(ctx, &cqe, true))
 			break;
 		ocqe = list_first_entry(&ctx->cq_overflow_list,
 					struct io_overflow_cqe, list);
@@ -862,8 +862,7 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 	 * submission (by quite a lot). Increment the overflow count in
 	 * the ring.
 	 */
-	cqe = io_get_cqe(ctx);
-	if (likely(cqe)) {
+	if (likely(io_get_cqe(ctx, &cqe))) {
 		trace_io_uring_complete(ctx, NULL, user_data, res, cflags, 0, 0);
 
 		WRITE_ONCE(cqe->user_data, user_data);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9c80d20fe18f..2960e35b32a5 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -109,28 +109,27 @@ static inline void io_req_task_work_add(struct io_kiocb *req)
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
-static inline struct io_uring_cqe *io_get_cqe_overflow(struct io_ring_ctx *ctx,
-						       bool overflow)
+static inline bool io_get_cqe_overflow(struct io_ring_ctx *ctx,
+					struct io_uring_cqe **ret,
+					bool overflow)
 {
-	struct io_uring_cqe *cqe;
-
 	io_lockdep_assert_cq_locked(ctx);
 
 	if (unlikely(ctx->cqe_cached >= ctx->cqe_sentinel)) {
 		if (unlikely(!io_cqe_cache_refill(ctx, overflow)))
-			return NULL;
+			return false;
 	}
-	cqe = ctx->cqe_cached;
+	*ret = ctx->cqe_cached;
 	ctx->cached_cq_tail++;
 	ctx->cqe_cached++;
 	if (ctx->flags & IORING_SETUP_CQE32)
 		ctx->cqe_cached++;
-	return cqe;
+	return true;
 }
 
-static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
+static inline bool io_get_cqe(struct io_ring_ctx *ctx, struct io_uring_cqe **ret)
 {
-	return io_get_cqe_overflow(ctx, false);
+	return io_get_cqe_overflow(ctx, ret, false);
 }
 
 static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx, struct io_kiocb *req)
@@ -142,8 +141,7 @@ static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx, struct io_kiocb *req
 	 * submission (by quite a lot). Increment the overflow count in
 	 * the ring.
 	 */
-	cqe = io_get_cqe(ctx);
-	if (unlikely(!cqe))
+	if (unlikely(!io_get_cqe(ctx, &cqe)))
 		return false;
 
 	if (trace_io_uring_complete_enabled())
-- 
2.41.0

