Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D14EA77D12D
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238912AbjHORdh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238925AbjHORdW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:22 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31E791BD9
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:20 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2b9db1de50cso85722541fa.3
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120798; x=1692725598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HnxxpondMX0aLczSzWm6JuyWlbpdwrNND3OM3Yt44kY=;
        b=bt4h+8NXY/G4i9d+eX7RH9cNGMrWlMWbbwyXKC0SZcreepSmsxZo66oAIosSkC2Uah
         zIaOxwDNUxLPk4RvfkfMMhvAhS33Qjh39RehSF61HJhG5Za4yXzki6TeElmrZTnFIuDJ
         vRGDGu7SqNb8z6peIjpX7eXjcsSKMxYEBYatfREnul+Ama5QKfVJsaHYN/90pgrRT+/+
         Ctx1IrfoDcSglOJMuX+y5u5mRlRyBr+NzC/OCOGWn1IZuvl4H9XZRmSuXUo/bCZe0l60
         UUXoVWlKeMFIInb1Hjhd6XMAXYQAQ2O7SWIcXmobeH2wGmK5zvprwm5nNz5czIjey160
         7vBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120798; x=1692725598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HnxxpondMX0aLczSzWm6JuyWlbpdwrNND3OM3Yt44kY=;
        b=LJ+3Zh1uE1mqL/1rHLY2dhYsXER5DGWNPmSWjCxlrGrbfUnVWMwaic/pxYFQSbNrZj
         zk9nYaKkFf7Gekg6Q+C4l9qZiAIfi7RdGXV/nLPiwvyb9u7XaX3FCu6AyQhMP4Z4AJG6
         chnE2oNOMo9CO0M5xwG2KJ2qLqfHfcpkQfT+ZM1x+6TtIdh77g1hYFV6XbzMb6pIlU4V
         mecbh6kkXpjE8aQZ/GJvrtIX9XVt2V/naBMSaTvXfGxmDAaqtrqCjaig7HnxEY2v4YXo
         XPwjzqorvXF73sZ013QWCpMGAz0AKuCtgs3RcK/ZpNBHr7K5JqbuEQo7iCpfDi+nejBK
         fbyQ==
X-Gm-Message-State: AOJu0YwY0rZmuqGn6sECU6PsqVab2Eh3f1i19Hoi5gimiXVxv7loB1I2
        fGZlQipsIZ/y4mXRDcxpsd4qNA0CA9w=
X-Google-Smtp-Source: AGHT+IHHS8EoiYTjqNICdruoUOWF1Esbx++ib8DRNvKYQM9phZU8dwzYsYgfdiLwg4i5JNiYHGGb9w==
X-Received: by 2002:a2e:9b98:0:b0:2b9:5b06:b73c with SMTP id z24-20020a2e9b98000000b002b95b06b73cmr9053738lji.17.1692120798131;
        Tue, 15 Aug 2023 10:33:18 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 05/16] io_uring: optimise extra io_get_cqe null check
Date:   Tue, 15 Aug 2023 18:31:34 +0100
Message-ID: <c3816ff286b95714efa5fb8cdde2b01d28202cb1.1692119257.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692119257.git.asml.silence@gmail.com>
References: <cover.1692119257.git.asml.silence@gmail.com>
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
index 623d41755714..e5378dc7aa19 100644
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

