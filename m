Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6310473B614
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 13:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbjFWLYr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 07:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbjFWLYo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 07:24:44 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 455082685
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:43 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-988c495f35fso56965066b.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687519481; x=1690111481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V86l4zwMKuhgaLWzEpQqCEbB3yYQpidNZsksimiGaz4=;
        b=IQBPUqetn1ie4xNvdoLm+Hgwmh1xmbvsmmMdqEtIPF1TR0lGVaWWmz0D6wxHrdednt
         s6oqELQM78fb/Y+NpWFS3mqRwzsV4CP1zr7Pj4z8lnpaiduZLfWJ3ZUpjUjnwxQVj/81
         5yRRkk1b4fRscmRGvRvwMgnFLmPyaKFTlLPCZdbZkqH05yZ1R7Rv45h3JrA3TELdFUc8
         eXTfrXfFd4Oumq9rFbANYVNS0+JkNFBdQpDw7MxLhyQvp3jsickjsuyLIBL3oc4411rL
         I4K/628jB0J7U84NHFPTm9u3FXaC/fEBj6D1clgRz2tYqUezKgYpzzMSx1c4WH80jRD1
         5oeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519481; x=1690111481;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V86l4zwMKuhgaLWzEpQqCEbB3yYQpidNZsksimiGaz4=;
        b=fwkYlajSXutpVSHoVUKnkvooK+l2WX4wyaiW/AfHJBus/20h+hoJt9NevjyYBfJvsP
         9+SOLgdyhYv9xF6R7uEeE5vYnB1f8VCNZK1VPz2tH3EsaUhDkSRPk6tFEu/zof9MdVcm
         dhZ9Hq+n0zf3FOxeg0bBrImVwT++eRM53FSskpIPmm+n3mQwz692M0ba2Aya/qI9j2p1
         xdY2+MzzmKDydVnTKeJitXk45XgYRwREolRV1lnU6Uazz5Uhnelkm99xlVFzG7QAtaDV
         pL+/JAwReqy8W8cJiVKXDLsBv1/9o/clz53VHEo+atn7rsGf+4f3pKno9DwHdjsGRPb1
         hKIQ==
X-Gm-Message-State: AC+VfDwaF9teSHz4+dVdE2gzSvp540NDd1qGdWS1jxJvPaz/KFGiQ6Ap
        qrz54Kn2e6FA6+pHi7OOLdJJEbXGNTI=
X-Google-Smtp-Source: ACHHUZ7VH2gN2mTMoxpaln2HubwWXLfStemXcce2s2mPJ2+x0sTvHjGiJwq+SKgoUthnLj2A4cDSWg==
X-Received: by 2002:a17:907:2d28:b0:98d:81c7:f01c with SMTP id gs40-20020a1709072d2800b0098d81c7f01cmr1412191ejc.38.1687519481394;
        Fri, 23 Jun 2023 04:24:41 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7d95])
        by smtp.gmail.com with ESMTPSA id h10-20020a1709067cca00b00969f44bbef3sm5959769ejp.11.2023.06.23.04.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:24:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 09/11] io_uring: inline __io_cq_unlock
Date:   Fri, 23 Jun 2023 12:23:29 +0100
Message-Id: <d875c4cfb69f38ccecb58a57111446c77a614caa.1687518903.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1687518903.git.asml.silence@gmail.com>
References: <cover.1687518903.git.asml.silence@gmail.com>
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

__io_cq_unlock is not very helpful, and users should be calling flush
variants anyway. Open code the function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8cb0f60d2885..39d83b631107 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -631,12 +631,6 @@ static inline void __io_cq_lock(struct io_ring_ctx *ctx)
 		spin_lock(&ctx->completion_lock);
 }
 
-static inline void __io_cq_unlock(struct io_ring_ctx *ctx)
-{
-	if (!ctx->task_complete)
-		spin_unlock(&ctx->completion_lock);
-}
-
 static inline void io_cq_lock(struct io_ring_ctx *ctx)
 	__acquires(ctx->completion_lock)
 {
@@ -647,7 +641,9 @@ static inline void io_cq_lock(struct io_ring_ctx *ctx)
 static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
 {
 	io_commit_cqring(ctx);
-	__io_cq_unlock(ctx);
+	if (!ctx->task_complete)
+		spin_unlock(&ctx->completion_lock);
+
 	io_commit_cqring_flush(ctx);
 	io_cqring_wake(ctx);
 }
@@ -664,7 +660,7 @@ static void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
 		 */
 		io_commit_cqring_flush(ctx);
 	} else {
-		__io_cq_unlock(ctx);
+		spin_unlock(&ctx->completion_lock);
 		io_commit_cqring_flush(ctx);
 		io_cqring_wake(ctx);
 	}
-- 
2.40.0

