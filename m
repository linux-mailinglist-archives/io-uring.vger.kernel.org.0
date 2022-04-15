Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82636503178
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352150AbiDOVLz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:11:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350280AbiDOVLz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:11:55 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 072D91158
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:25 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id t25so11080525edt.9
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R8MM7j6QWi5orHzax5KnbcjNUn2PwnSdKkvjDDhbIiE=;
        b=ja8P/SYwGfrIbNlBfXBGdYl20mL8EV71Hq3ym+zxQ0fSJuxiP98xJvrgVJ8pDFCG5n
         Uqyunut3lfzd3uPnFGmsBFO8GgK5bNFq5r5eEdCqnpwOgT4AaSQy/mXXRFF4HvUbasUV
         Aoku6PyF0n6N9qPZ1FBftM1u2sMz3pVz8osy7u+8hHxDngPkF++nrr3rntOxtYm7DpUc
         Gndw0zoVRZzVKdavRAoUNwu9liCxuO5JO1aeH3z6/fwaC9M+pqFq2+mg0Lg2brrori4r
         PAV6x54dFQ6Y+2fhMQfS0n4GUlUHBI4LlWLsBvnWImboBANGBDH7M6mx148U1/rmJgt5
         iiIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R8MM7j6QWi5orHzax5KnbcjNUn2PwnSdKkvjDDhbIiE=;
        b=g90YSkHQHt2XR5EYTe3Axdc7ayRDt4I1C5fDzNn0OHqveU1VGZZs1NBRQxPsk4NUjL
         77AifZnv5Lq+0IUkYfZAMUXsdre0a2EcTlNhTE6/QHzhM/S2SKlJlITTJt3C2hVzGXWJ
         bgccfHakLyFKMiIFgbF/aEUlNb+XAIsnVhGiiZ1ApkZIBWoP3y557I1YnR9RjwVP5w6B
         4uoeFj9wKEIrLGn+4+NDrrd9veMnEK15450KLRvjvNGwNTRIIgb4Y4W68+zgWum1F0FI
         kPWoQcEDe+PENeIa+Wl/iPrEFTyxfIxpCH7sbxysbAWv/fBVRX97MELetBOB+wX3vEAE
         TOUg==
X-Gm-Message-State: AOAM530K+QZ+HfKDqv8Ycr2MEQVGfsz1c5pDPQMB5Rs04uAXCoAhtznI
        k2KlUQxPdfnMsGuVftd0y7CUxw1P0X4=
X-Google-Smtp-Source: ABdhPJyqKkEhHqPJXkOTOwIP2/0NQXy+O0Za5ZNgIutbmmh1KN8smS2TxHcbeW5CxQReIZl18Cf42Q==
X-Received: by 2002:a05:6402:3046:b0:420:120e:ef2c with SMTP id bs6-20020a056402304600b00420120eef2cmr1008043edb.160.1650056963424;
        Fri, 15 Apr 2022 14:09:23 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 10/14] io_uring: introduce IO_REQ_LINK_FLAGS
Date:   Fri, 15 Apr 2022 22:08:29 +0100
Message-Id: <df38b883e31e7e0ca4e364d25a0743862961b180.1650056133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650056133.git.asml.silence@gmail.com>
References: <cover.1650056133.git.asml.silence@gmail.com>
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

Add a macro for all link request flags to avoid duplication.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ef7bee562fa2..3b9fcadb3895 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1180,6 +1180,7 @@ static const struct io_op_def io_op_defs[] = {
 
 /* requests with any of those set should undergo io_disarm_next() */
 #define IO_DISARM_MASK (REQ_F_ARM_LTIMEOUT | REQ_F_LINK_TIMEOUT | REQ_F_FAIL)
+#define IO_REQ_LINK_FLAGS (REQ_F_LINK | REQ_F_HARDLINK)
 
 static bool io_disarm_next(struct io_kiocb *req);
 static void io_uring_del_tctx_node(unsigned long index);
@@ -2164,7 +2165,7 @@ static void __io_req_complete_post(struct io_kiocb *req, s32 res,
 	 * free_list cache.
 	 */
 	if (req_ref_put_and_test(req)) {
-		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
+		if (req->flags & IO_REQ_LINK_FLAGS) {
 			if (req->flags & IO_DISARM_MASK)
 				io_disarm_next(req);
 			if (req->link) {
@@ -2712,7 +2713,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 						&ctx->apoll_cache);
 				req->flags &= ~REQ_F_POLLED;
 			}
-			if (req->flags & (REQ_F_LINK|REQ_F_HARDLINK))
+			if (req->flags & IO_REQ_LINK_FLAGS)
 				io_queue_next(req);
 			if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
 				io_clean_op(req);
@@ -2772,7 +2773,7 @@ static inline struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
 	struct io_kiocb *nxt = NULL;
 
 	if (req_ref_put_and_test(req)) {
-		if (unlikely(req->flags & (REQ_F_LINK|REQ_F_HARDLINK)))
+		if (unlikely(req->flags & IO_REQ_LINK_FLAGS))
 			nxt = io_req_find_next(req);
 		io_free_req(req);
 	}
@@ -7708,7 +7709,7 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			 */
 			if (!(link->head->flags & REQ_F_FAIL))
 				req_fail_link_node(link->head, -ECANCELED);
-		} else if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
+		} else if (!(req->flags & IO_REQ_LINK_FLAGS)) {
 			/*
 			 * the current req is a normal req, we should return
 			 * error and thus break the submittion loop.
@@ -7746,12 +7747,12 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		link->last->link = req;
 		link->last = req;
 
-		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
+		if (req->flags & IO_REQ_LINK_FLAGS)
 			return 0;
 		/* last request of a link, enqueue the link */
 		link->head = NULL;
 		req = head;
-	} else if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
+	} else if (req->flags & IO_REQ_LINK_FLAGS) {
 		link->head = req;
 		link->last = req;
 		return 0;
-- 
2.35.2

