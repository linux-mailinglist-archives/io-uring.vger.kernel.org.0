Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D501454C5FA
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:23:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239593AbiFOKXt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:23:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348688AbiFOKXf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:23:35 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 163FC165A7
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:34 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id o8so14735211wro.3
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LDQSAWiBnCEPM2LQzZO/iGVI5Xe9uF7XB3/IgLRw4W0=;
        b=haJqwUONFOm5BrCeCj5jEcIjW5+pvzHZQAOeOGHgnovX3i6iafl1mlCUXd/Q6t2Ag/
         j/5vV1KKgOetnylSGdQVXQn5ECumLEnkxuG1F8REfTxw6hjYD659O/nG9f9sQcxgYfiY
         V+ljd3cE9j26LjHjdzhyquBVZPKgFlvLScEbxx3oS9ptMSaqEUAj3atG/ej5POwtKiXl
         p4rXuIjf/n5q44gjfHEJuATM120LCbylA2nSmUcrnBd5pQGwqTuPOF3h+k6L4UubuTYm
         9fqCGGC/kHWEM4bY0/m/GhUp+zaoCa5VCRLO+7whL5Ap9UtA52lQK4eOC7SFF5xCYaTc
         QwQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LDQSAWiBnCEPM2LQzZO/iGVI5Xe9uF7XB3/IgLRw4W0=;
        b=ptQXYKWMd6HCRATnaeohgyqnlV8RBa8FXX+TAyYNu+UwY+9jFRb8rFy40HKcJkyeu3
         AtAc+W1cNtGgHMlq/58/C/PI14+n61lXuLj2u/aDGS+4b7VczsxbEXSgl/inS9je0gUS
         uz62v/fPu+YfBkoF0ficKFyFamYRZgsc8Y8VCg9ff96xH1dnoKLW5wetBIwpElSfQ2SW
         aAC9QyeYoEbqaUvgTuw3AcoyXbpmg5+Ceav2mOlNGG3pMGV4K9bQrtXDZDc+9n9ZBcj0
         eWdgQ9YKYmp6y8SwjraWtNA3DCJGYF0wypAI+IImMUY3s7Y5U7ZEDl2kI66iWroRGTAT
         p/Ew==
X-Gm-Message-State: AJIora9Av3YFG6fGs/jUruv6JscPYOAD+SpG+JPnQvuciMYY9w7lGLn7
        Nep5Tp/un0QVtDqLUVSFZqVvXmv+x+rwEA==
X-Google-Smtp-Source: AGRyM1szXJU6YLzm511zHdijZ3r3+s9A0I+9DWosf9tciv5eC++xAaTH8U3X1w2tTk2Aq+7jzzgMbw==
X-Received: by 2002:a5d:67c9:0:b0:218:4a6a:298e with SMTP id n9-20020a5d67c9000000b002184a6a298emr9428144wrw.153.1655288612214;
        Wed, 15 Jun 2022 03:23:32 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id p124-20020a1c2982000000b0039c7dbafa7asm1964984wmp.19.2022.06.15.03.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:23:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 1/6] io_uring: get rid of __io_fill_cqe{32}_req()
Date:   Wed, 15 Jun 2022 11:23:02 +0100
Message-Id: <c18e0d191014fb574f24721245e4e3fddd0b6917.1655287457.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655287457.git.asml.silence@gmail.com>
References: <cover.1655287457.git.asml.silence@gmail.com>
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

There are too many cqe filling helpers, kill __io_fill_cqe{32}_req(),
use __io_fill_cqe{32}_req_filled() instead, and then rename it. It'll
simplify fixing in following patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 70 ++++++++++++++++-----------------------------------
 1 file changed, 21 insertions(+), 49 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1b0b6099e717..654c2f897497 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2464,8 +2464,8 @@ static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
 	return io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
 }
 
-static inline bool __io_fill_cqe_req_filled(struct io_ring_ctx *ctx,
-					    struct io_kiocb *req)
+static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
+				     struct io_kiocb *req)
 {
 	struct io_uring_cqe *cqe;
 
@@ -2486,8 +2486,8 @@ static inline bool __io_fill_cqe_req_filled(struct io_ring_ctx *ctx,
 					req->cqe.res, req->cqe.flags, 0, 0);
 }
 
-static inline bool __io_fill_cqe32_req_filled(struct io_ring_ctx *ctx,
-					      struct io_kiocb *req)
+static inline bool __io_fill_cqe32_req(struct io_ring_ctx *ctx,
+				       struct io_kiocb *req)
 {
 	struct io_uring_cqe *cqe;
 	u64 extra1 = req->extra1;
@@ -2513,44 +2513,6 @@ static inline bool __io_fill_cqe32_req_filled(struct io_ring_ctx *ctx,
 					req->cqe.flags, extra1, extra2);
 }
 
-static inline bool __io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
-{
-	trace_io_uring_complete(req->ctx, req, req->cqe.user_data, res, cflags, 0, 0);
-	return __io_fill_cqe(req->ctx, req->cqe.user_data, res, cflags);
-}
-
-static inline void __io_fill_cqe32_req(struct io_kiocb *req, s32 res, u32 cflags,
-				u64 extra1, u64 extra2)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct io_uring_cqe *cqe;
-
-	if (WARN_ON_ONCE(!(ctx->flags & IORING_SETUP_CQE32)))
-		return;
-	if (req->flags & REQ_F_CQE_SKIP)
-		return;
-
-	trace_io_uring_complete(ctx, req, req->cqe.user_data, res, cflags,
-				extra1, extra2);
-
-	/*
-	 * If we can't get a cq entry, userspace overflowed the
-	 * submission (by quite a lot). Increment the overflow count in
-	 * the ring.
-	 */
-	cqe = io_get_cqe(ctx);
-	if (likely(cqe)) {
-		WRITE_ONCE(cqe->user_data, req->cqe.user_data);
-		WRITE_ONCE(cqe->res, res);
-		WRITE_ONCE(cqe->flags, cflags);
-		WRITE_ONCE(cqe->big_cqe[0], extra1);
-		WRITE_ONCE(cqe->big_cqe[1], extra2);
-		return;
-	}
-
-	io_cqring_event_overflow(ctx, req->cqe.user_data, res, cflags, extra1, extra2);
-}
-
 static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
 				     s32 res, u32 cflags)
 {
@@ -2593,16 +2555,24 @@ static void __io_req_complete_put(struct io_kiocb *req)
 static void __io_req_complete_post(struct io_kiocb *req, s32 res,
 				   u32 cflags)
 {
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe_req(req, res, cflags);
+	if (!(req->flags & REQ_F_CQE_SKIP)) {
+		req->cqe.res = res;
+		req->cqe.flags = cflags;
+		__io_fill_cqe_req(req->ctx, req);
+	}
 	__io_req_complete_put(req);
 }
 
 static void __io_req_complete_post32(struct io_kiocb *req, s32 res,
 				   u32 cflags, u64 extra1, u64 extra2)
 {
-	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe32_req(req, res, cflags, extra1, extra2);
+	if (!(req->flags & REQ_F_CQE_SKIP)) {
+		req->cqe.res = res;
+		req->cqe.flags = cflags;
+		req->extra1 = extra1;
+		req->extra2 = extra2;
+		__io_fill_cqe32_req(req->ctx, req);
+	}
 	__io_req_complete_put(req);
 }
 
@@ -3207,9 +3177,9 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 
 			if (!(req->flags & REQ_F_CQE_SKIP)) {
 				if (!(ctx->flags & IORING_SETUP_CQE32))
-					__io_fill_cqe_req_filled(ctx, req);
+					__io_fill_cqe_req(ctx, req);
 				else
-					__io_fill_cqe32_req_filled(ctx, req);
+					__io_fill_cqe32_req(ctx, req);
 			}
 		}
 
@@ -3329,7 +3299,9 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		nr_events++;
 		if (unlikely(req->flags & REQ_F_CQE_SKIP))
 			continue;
-		__io_fill_cqe_req(req, req->cqe.res, io_put_kbuf(req, 0));
+
+		req->cqe.flags = io_put_kbuf(req, 0);
+		__io_fill_cqe_req(req->ctx, req);
 	}
 
 	if (unlikely(!nr_events))
-- 
2.36.1

