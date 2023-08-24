Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66CBA787BB0
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243938AbjHXWzn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244023AbjHXWzc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:32 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E9B21FC3
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:23 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2bbbda48904so4370761fa.2
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917721; x=1693522521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+MCzLayGP6DIzHUSXyvUW9IwK0Due1vKOjR85NCwaD0=;
        b=LmuKzJRuH0jR39EmS763qyYUd/xwqNgMEJhXIjFnrTXUR3rbhqBCg/qz4jIZuXPLP4
         4L+sE5u3IHiYZBMcMP33cTSNke2hSTYtoX1KQvphVUIt//2EleqQqwpRsQBxYPV+rCMf
         czwQJhuZt9TLwRbnsM705I6bwmJGltGIQ64NbgzwkC9RijRr9uqmE3LGJh4nxLiGd7FL
         0qOzulwfme/wqIGo5vpRYvv2juLGW1w1fW/MSNguM31GaQqPros6bMhUVB928zUp7heM
         a6rfAjIUQWb10RE7P5rSpMbAEdG4LrGerOsXtoeUKs1IoxFS3SFw0Tz1PhwXP25Zlini
         FTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917721; x=1693522521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+MCzLayGP6DIzHUSXyvUW9IwK0Due1vKOjR85NCwaD0=;
        b=Shd0AlOp9hFBno9FGVbNUP2kKfUHVrXOSRlNDAKoCiSth7w6XWQzsQ4Jc1dZ18lZNn
         D2RBsTTb7+jZLAiL9lMTfmap5kqsR1m1CquZKDYY3uhKingtsM/hWhUByJkqOxGUDqr/
         a0wO8/pYX3w612LKcZ2D/E2FtdKdmsb/SyzpgH3TsCT7/rIvqmxNJ9zSEVvebbyB0ZV6
         tSfnEPQ/1YjV+4d3pqjqYVX/JBLjuKZbOOLCu3VGhzVhpuEmxD5Yl4cCIHuPoII1dFO9
         M6kjSfKxMjMNzjNum4KGDpoWk7/XDh4jadPwU0fRySrP1C5Ol4AUJxa/bkaQNdZ42sK3
         OQpw==
X-Gm-Message-State: AOJu0YwhNiuKxdlvc0uHEg6dpj2KXn2VRehyMz2NaQQrbyPoc2nlMZ51
        qQXt+V8T1NfXH4dUxMiGV4sJJi7LjsY=
X-Google-Smtp-Source: AGHT+IHWqPkpais3IjixT599RTDAtOm+7gSLec2Bfx7kIzoNevzr1ZmJxS7Dxx+lSHNJG4A8u/UwYQ==
X-Received: by 2002:a2e:87d6:0:b0:2bc:bece:2264 with SMTP id v22-20020a2e87d6000000b002bcbece2264mr9864294ljj.50.1692917721205;
        Thu, 24 Aug 2023 15:55:21 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 04/15] io_uring: refactor __io_get_cqe()
Date:   Thu, 24 Aug 2023 23:53:26 +0100
Message-ID: <74dc8fdf2657e438b2e05e1d478a3596924604e9.1692916914.git.asml.silence@gmail.com>
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

Make __io_get_cqe simpler by not grabbing the cqe from refilled cached,
but letting io_get_cqe() do it for us. That's cleaner and removes some
duplication.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 13 ++++---------
 io_uring/io_uring.h | 23 ++++++++++++-----------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0aeb33256a6d..de05831eeca7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -818,7 +818,7 @@ void io_req_cqe_overflow(struct io_kiocb *req)
  * control dependency is enough as we're using WRITE_ONCE to
  * fill the cq entry
  */
-struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
+bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow)
 {
 	struct io_rings *rings = ctx->rings;
 	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
@@ -830,7 +830,7 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
 	 * Force overflow the completion.
 	 */
 	if (!overflow && (ctx->check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT)))
-		return NULL;
+		return false;
 
 	/* userspace may cheat modifying the tail, be safe and do min */
 	queued = min(__io_cqring_events(ctx), ctx->cq_entries);
@@ -838,7 +838,7 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
 	/* we need a contiguous range, limit based on the current array offset */
 	len = min(free, ctx->cq_entries - off);
 	if (!len)
-		return NULL;
+		return false;
 
 	if (ctx->flags & IORING_SETUP_CQE32) {
 		off <<= 1;
@@ -847,12 +847,7 @@ struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow)
 
 	ctx->cqe_cached = &rings->cqes[off];
 	ctx->cqe_sentinel = ctx->cqe_cached + len;
-
-	ctx->cached_cq_tail++;
-	ctx->cqe_cached++;
-	if (ctx->flags & IORING_SETUP_CQE32)
-		ctx->cqe_cached++;
-	return &rings->cqes[off];
+	return true;
 }
 
 static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 9b5dfb6ef484..9c80d20fe18f 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -38,7 +38,7 @@ enum {
 	IOU_STOP_MULTISHOT	= -ECANCELED,
 };
 
-struct io_uring_cqe *__io_get_cqe(struct io_ring_ctx *ctx, bool overflow);
+bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow);
 void io_req_cqe_overflow(struct io_kiocb *req);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
@@ -112,19 +112,20 @@ static inline void io_req_task_work_add(struct io_kiocb *req)
 static inline struct io_uring_cqe *io_get_cqe_overflow(struct io_ring_ctx *ctx,
 						       bool overflow)
 {
-	io_lockdep_assert_cq_locked(ctx);
+	struct io_uring_cqe *cqe;
 
-	if (likely(ctx->cqe_cached < ctx->cqe_sentinel)) {
-		struct io_uring_cqe *cqe = ctx->cqe_cached;
+	io_lockdep_assert_cq_locked(ctx);
 
-		ctx->cached_cq_tail++;
-		ctx->cqe_cached++;
-		if (ctx->flags & IORING_SETUP_CQE32)
-			ctx->cqe_cached++;
-		return cqe;
+	if (unlikely(ctx->cqe_cached >= ctx->cqe_sentinel)) {
+		if (unlikely(!io_cqe_cache_refill(ctx, overflow)))
+			return NULL;
 	}
-
-	return __io_get_cqe(ctx, overflow);
+	cqe = ctx->cqe_cached;
+	ctx->cached_cq_tail++;
+	ctx->cqe_cached++;
+	if (ctx->flags & IORING_SETUP_CQE32)
+		ctx->cqe_cached++;
+	return cqe;
 }
 
 static inline struct io_uring_cqe *io_get_cqe(struct io_ring_ctx *ctx)
-- 
2.41.0

