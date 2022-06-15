Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D1AB54C5FB
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:23:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240029AbiFOKXu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:23:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348720AbiFOKXg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:23:36 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 363A8167F8
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:35 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id w17so7213039wrg.7
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LcX43DmmGMu+lcbKelq5QUR+uzMmfZHUi91+QyPedxs=;
        b=Ucrylz1Q/6qIvjbTmtNPRi0U7A2gucrJaaJvDccfB0xZP0eCyAtBREGs//lqFgKKuR
         RoLwRafi65GAhxUzuiFthGErgQ0p/4a/5Wsdbx1fw6sIZ02smf+hEHZ4/K6Awr/CkJfa
         RvlS/p260TUyQ2mKaQsF67toTLP2A8U4mJEZqqJj4ii03Ozf1ytAEv5T6t9oTmQMxx6S
         vrEia+Iau8AFwPRpY/qyiznStbNRwZaQ+NvTkS9URKR6UeldI7r+nEjAjzdP16JT/kss
         +sGBKA39MnCWsvuulbIkzk3LOWx8pAekjZ94KxfBekeI2KO14P0DiilpXlp/CZV5Bn/d
         1WHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=LcX43DmmGMu+lcbKelq5QUR+uzMmfZHUi91+QyPedxs=;
        b=W+URFG3PNYLZXIz53qZ5octb5D8Zz1yu7tP4Fubpz9KVyX9i4vUeoQSHNak39M6Dsx
         NgR225J3I7Hxgpemm5p60WQbw2xMvum+ZgOc2UGke5WwTpuAolwOCu6od0gy1sjpYWTA
         2fnDhbF14kA0kBNqh75FaDCD/xMpWtzWxXHw4Njy8Or9Vv1H1djAEtdRuT0UuvfAFFmP
         vA08qxUFRBSMDZrrNgMS0yS1a331rjT5tcRmRV+Rbl5C1jOuq3Rf93zwMPQl2dkDbFjq
         hDMMLNKNWEsEeMAjT8Gvrb9SOffLbcoBJeBW3g0+iSrKKRgj4/qSvGqiKSjbkLkuuAa/
         DqRw==
X-Gm-Message-State: AJIora/VXDJj2wLJuJWfPLFWJoJEnabuwtJqMOa92+WeandNl7KmVco4
        fgqpwqFT/nl+F2VYV1LlpWEEG8KIXwdHAA==
X-Google-Smtp-Source: AGRyM1t50Op7LLy5ghiHk7hegsC7ZqxuuHo0susR47mO62B91Bvt0+ouc3Kv1HEEOAZMU9UwtRc47w==
X-Received: by 2002:adf:d206:0:b0:214:d2b:7141 with SMTP id j6-20020adfd206000000b002140d2b7141mr9079948wrh.706.1655288613368;
        Wed, 15 Jun 2022 03:23:33 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id p124-20020a1c2982000000b0039c7dbafa7asm1964984wmp.19.2022.06.15.03.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:23:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 2/6] io_uring: unite fill_cqe and the 32B version
Date:   Wed, 15 Jun 2022 11:23:03 +0100
Message-Id: <8085c5b2f74141520f60decd45334f87e389b718.1655287457.git.asml.silence@gmail.com>
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

We want just one function that will handle both normal cqes and 32B
cqes. Combine __io_fill_cqe_req() and __io_fill_cqe_req32(). It's still
not entirely correct yet, but saves us from cases when we fill an CQE of
a wrong size.

Fixes: 76c68fbf1a1f9 ("io_uring: enable CQE32")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 61 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 42 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 654c2f897497..eb858cf92af9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2469,21 +2469,48 @@ static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 {
 	struct io_uring_cqe *cqe;
 
-	trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
-				req->cqe.res, req->cqe.flags, 0, 0);
+	if (!(ctx->flags & IORING_SETUP_CQE32)) {
+		trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
+					req->cqe.res, req->cqe.flags, 0, 0);
 
-	/*
-	 * If we can't get a cq entry, userspace overflowed the
-	 * submission (by quite a lot). Increment the overflow count in
-	 * the ring.
-	 */
-	cqe = io_get_cqe(ctx);
-	if (likely(cqe)) {
-		memcpy(cqe, &req->cqe, sizeof(*cqe));
-		return true;
+		/*
+		 * If we can't get a cq entry, userspace overflowed the
+		 * submission (by quite a lot). Increment the overflow count in
+		 * the ring.
+		 */
+		cqe = io_get_cqe(ctx);
+		if (likely(cqe)) {
+			memcpy(cqe, &req->cqe, sizeof(*cqe));
+			return true;
+		}
+
+		return io_cqring_event_overflow(ctx, req->cqe.user_data,
+						req->cqe.res, req->cqe.flags,
+						0, 0);
+	} else {
+		u64 extra1 = req->extra1;
+		u64 extra2 = req->extra2;
+
+		trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
+					req->cqe.res, req->cqe.flags, extra1, extra2);
+
+		/*
+		 * If we can't get a cq entry, userspace overflowed the
+		 * submission (by quite a lot). Increment the overflow count in
+		 * the ring.
+		 */
+		cqe = io_get_cqe(ctx);
+		if (likely(cqe)) {
+			memcpy(cqe, &req->cqe, sizeof(struct io_uring_cqe));
+			WRITE_ONCE(cqe->big_cqe[0], extra1);
+			WRITE_ONCE(cqe->big_cqe[1], extra2);
+			return true;
+		}
+
+		return io_cqring_event_overflow(ctx, req->cqe.user_data,
+				req->cqe.res, req->cqe.flags,
+				extra1, extra2);
 	}
-	return io_cqring_event_overflow(ctx, req->cqe.user_data,
-					req->cqe.res, req->cqe.flags, 0, 0);
 }
 
 static inline bool __io_fill_cqe32_req(struct io_ring_ctx *ctx,
@@ -3175,12 +3202,8 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 			struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
 
-			if (!(req->flags & REQ_F_CQE_SKIP)) {
-				if (!(ctx->flags & IORING_SETUP_CQE32))
-					__io_fill_cqe_req(ctx, req);
-				else
-					__io_fill_cqe32_req(ctx, req);
-			}
+			if (!(req->flags & REQ_F_CQE_SKIP))
+				__io_fill_cqe_req(ctx, req);
 		}
 
 		io_commit_cqring(ctx);
-- 
2.36.1

