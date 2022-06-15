Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ECE454C5FE
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345138AbiFOKXw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348737AbiFOKXh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:23:37 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65F3183B8
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:36 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id j5-20020a05600c1c0500b0039c5dbbfa48so856440wms.5
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=H+1s9q09mzQGGYXSBRIzOmlSGml7cgvMX4AVEHn5P0c=;
        b=Ed5OPm5VGw0fXl721sKPgAmyJ8rEVVDwP+akirjONtaXsP09Sc5fngTchXo+2Jx6DI
         3pccmZ09wCm0KvD6eP979uk7q99Ik6qcELQkGR9J/pRhVHAjhsXRaGbE+MzEH2P05Ro9
         fcVj5yrqbJWx09iwm8HcBLCswh9km6ShM9yWRULN3l/UxGVJSlZrJLq9Y8uwM21ANHiu
         JZXccQyDQxvoq9nKZBdb1FxUkbLqRJJgyC4jfIqbl9zUs1JiIF9NexVhBHdQ8sR2qi1u
         jsofk87GHSi/KR5zheau/Xk2viKAENK2CS4e9vsnW5PxDjEAjyxgFXBaIhUhd3F50JUk
         pe2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=H+1s9q09mzQGGYXSBRIzOmlSGml7cgvMX4AVEHn5P0c=;
        b=q0yxgxLEeVhLe4Sur9aeSF6MV+AV5OYWTkmsIB+nrhHHj7NUnJiMK+HBr8G3GP9TTB
         n0nDCE2HfgLF8tP1rTdB3FHpodfouSGoyuwc7Wr2D6iPSi4SuLg3IlZ1Hj2hjmSE041v
         ZAjQ0/PapHrgZ2XIs25dvD/q8vl8ajKzEyUSSTkoqxvWs0xMELZ14Y7NOJbc/A3sJIcj
         4vRuEHHHtSH1skYwu06QALM1hdU0sSUfPgKJFHDNI6p64C2m/5T6JzCp7HsYWGLabzqY
         ByJy+DgCBRIpicbIVuwumNSX7uZGJhtjiPbxWgS+Z2ObzU2C9PCPhZmhfh8T1ATBzxr/
         T8mw==
X-Gm-Message-State: AOAM530EnpRuZDXVPYqvIEIPVbHai+sPSXz5Avt1/c5meRGMIGHiCHDe
        b+cDqY/CbWqiKHUS8xhc4hBRNeU4JeeQ0Q==
X-Google-Smtp-Source: ABdhPJyzdDYKqQabMWrOSqLkzoYir+z1FQ9K53AhA/bmkHgUOOujnYg+JZilP/y10vurEGgdFKJHyg==
X-Received: by 2002:a05:600c:1d8a:b0:39c:69c7:7158 with SMTP id p10-20020a05600c1d8a00b0039c69c77158mr9046989wms.48.1655288614699;
        Wed, 15 Jun 2022 03:23:34 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id p124-20020a1c2982000000b0039c7dbafa7asm1964984wmp.19.2022.06.15.03.23.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:23:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5.19 3/6] io_uring: fill extra big cqe fields from req
Date:   Wed, 15 Jun 2022 11:23:04 +0100
Message-Id: <af1319eb661b1f9a0abceb51cbbf72b8002e019d.1655287457.git.asml.silence@gmail.com>
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

The only user of io_req_complete32()-like functions is cmd
requests. Instead of keeping the whole complete32 family, remove them
and provide the extras in already added for inline completions
req->extra{1,2}. When fill_cqe_res() finds CQE32 option enabled
it'll use those fields to fill a 32B cqe.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 78 +++++++--------------------------------------------
 1 file changed, 10 insertions(+), 68 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index eb858cf92af9..10901db93f7e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2513,33 +2513,6 @@ static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 	}
 }
 
-static inline bool __io_fill_cqe32_req(struct io_ring_ctx *ctx,
-				       struct io_kiocb *req)
-{
-	struct io_uring_cqe *cqe;
-	u64 extra1 = req->extra1;
-	u64 extra2 = req->extra2;
-
-	trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
-				req->cqe.res, req->cqe.flags, extra1, extra2);
-
-	/*
-	 * If we can't get a cq entry, userspace overflowed the
-	 * submission (by quite a lot). Increment the overflow count in
-	 * the ring.
-	 */
-	cqe = io_get_cqe(ctx);
-	if (likely(cqe)) {
-		memcpy(cqe, &req->cqe, sizeof(struct io_uring_cqe));
-		cqe->big_cqe[0] = extra1;
-		cqe->big_cqe[1] = extra2;
-		return true;
-	}
-
-	return io_cqring_event_overflow(ctx, req->cqe.user_data, req->cqe.res,
-					req->cqe.flags, extra1, extra2);
-}
-
 static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
 				     s32 res, u32 cflags)
 {
@@ -2590,19 +2563,6 @@ static void __io_req_complete_post(struct io_kiocb *req, s32 res,
 	__io_req_complete_put(req);
 }
 
-static void __io_req_complete_post32(struct io_kiocb *req, s32 res,
-				   u32 cflags, u64 extra1, u64 extra2)
-{
-	if (!(req->flags & REQ_F_CQE_SKIP)) {
-		req->cqe.res = res;
-		req->cqe.flags = cflags;
-		req->extra1 = extra1;
-		req->extra2 = extra2;
-		__io_fill_cqe32_req(req->ctx, req);
-	}
-	__io_req_complete_put(req);
-}
-
 static void io_req_complete_post(struct io_kiocb *req, s32 res, u32 cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -2614,18 +2574,6 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res, u32 cflags)
 	io_cqring_ev_posted(ctx);
 }
 
-static void io_req_complete_post32(struct io_kiocb *req, s32 res,
-				   u32 cflags, u64 extra1, u64 extra2)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	spin_lock(&ctx->completion_lock);
-	__io_req_complete_post32(req, res, cflags, extra1, extra2);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
-}
-
 static inline void io_req_complete_state(struct io_kiocb *req, s32 res,
 					 u32 cflags)
 {
@@ -2643,19 +2591,6 @@ static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
 		io_req_complete_post(req, res, cflags);
 }
 
-static inline void __io_req_complete32(struct io_kiocb *req,
-				       unsigned int issue_flags, s32 res,
-				       u32 cflags, u64 extra1, u64 extra2)
-{
-	if (issue_flags & IO_URING_F_COMPLETE_DEFER) {
-		io_req_complete_state(req, res, cflags);
-		req->extra1 = extra1;
-		req->extra2 = extra2;
-	} else {
-		io_req_complete_post32(req, res, cflags, extra1, extra2);
-	}
-}
-
 static inline void io_req_complete(struct io_kiocb *req, s32 res)
 {
 	if (res < 0)
@@ -5079,6 +5014,13 @@ void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_complete_in_task);
 
+static inline void io_req_set_cqe32_extra(struct io_kiocb *req,
+					  u64 extra1, u64 extra2)
+{
+	req->extra1 = extra1;
+	req->extra2 = extra2;
+}
+
 /*
  * Called by consumers of io_uring_cmd, if they originally returned
  * -EIOCBQUEUED upon receiving the command.
@@ -5089,10 +5031,10 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, ssize_t res2)
 
 	if (ret < 0)
 		req_set_fail(req);
+
 	if (req->ctx->flags & IORING_SETUP_CQE32)
-		__io_req_complete32(req, 0, ret, 0, res2, 0);
-	else
-		io_req_complete(req, ret);
+		io_req_set_cqe32_extra(req, res2, 0);
+	io_req_complete(req, ret);
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
-- 
2.36.1

