Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF1754F386
	for <lists+io-uring@lfdr.de>; Fri, 17 Jun 2022 10:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381210AbiFQItq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Jun 2022 04:49:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381133AbiFQItp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Jun 2022 04:49:45 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB0EC69495
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:44 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id n10so7492464ejk.5
        for <io-uring@vger.kernel.org>; Fri, 17 Jun 2022 01:49:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Tqv5tBUne+CZOc241rUK/KpOvQ9YGwZ9YxD/px9rwDo=;
        b=AErLzww8zQzZW0uMoGmsif+AaIrbAh5MBNCYPiYrIBABVY8Cqc/6+M9Wrfxp80SH+q
         kx7ZJ6IKgy8MHc2iHbNp+XtxtP27ZIcoHmXSueoR4YsaPibEjycYSH1cLX1WwZUyVn5I
         7aYrQPY1FJ58s4TLAgvUMPApz7ZnbgE1E6Joxe5WFa4XyeQXhcaq8WVmVLC9VUf9R6PO
         kSVhSXoxTXI4Q/fHcygoW/PVMs7dEIei9+q1XsNK2a0vrjFDAnAOdQXCNitV8Yn4LobL
         p5EFld5fmh96lzi3r3Oew3m6V4QeUx9MEgudh2SMa1yQ3mkPIPyzZBwmRTX9+2SuzgWy
         fihQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Tqv5tBUne+CZOc241rUK/KpOvQ9YGwZ9YxD/px9rwDo=;
        b=VOGuMlywCenhSeO5qskYfv+nAfZ4anYqUks/f+JtjdO3CPWbUVfrI0y5U2SMBxR8Eo
         7UDXv3YElX2Z51+BBnOSeaJc80M9KHcqPEZXvfhynW+PNC4FN6YccePeC2uJVCvoXFN+
         JE6136wGbDHF2LONRKANclWWKJdxCjWH7dlV7frAh8Iilvil4w6fDtBDTpQEOCwttPs3
         RUftkGbGbC4+sQH6qWMgk6eMxE4Vkoiw0hgGXGsYJgyKBSYEsk8B3PDXf9V60XLNVE46
         7fgBWc7r571Wq03fnzqVlVMJgiZ2GIS7A9DIAyYcUIdL3Jiw55rxMxIYWh1ue/XEnCXS
         smtQ==
X-Gm-Message-State: AJIora9W+NrdN1Fv//0JD4Hm5TlReAs/M+Tyl3xkrD32i4Oqa1dU8t7I
        FmXZMQcVtBuSiyAGWRzKcnYox+0Md8MsSQ==
X-Google-Smtp-Source: AGRyM1u/AZRYdmh2qN8S4325oRJkAhpoDp5r8j0GfBg1y9V36OEzXTnWvkKibZ7eYzwyK1r/IHMfLg==
X-Received: by 2002:a17:907:3f0a:b0:711:f0e2:ad67 with SMTP id hq10-20020a1709073f0a00b00711f0e2ad67mr8096574ejc.277.1655455783024;
        Fri, 17 Jun 2022 01:49:43 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:b65a])
        by smtp.gmail.com with ESMTPSA id u17-20020a1709060b1100b006ff52dfccf3sm1851895ejg.211.2022.06.17.01.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 01:49:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 4/6] io_uring: deduplicate __io_fill_cqe_req tracing
Date:   Fri, 17 Jun 2022 09:48:03 +0100
Message-Id: <277ed85dba5189ab7d932164b314013a0f0b0fdc.1655455613.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655455613.git.asml.silence@gmail.com>
References: <cover.1655455613.git.asml.silence@gmail.com>
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

Deduplicate two trace_io_uring_complete() calls in __io_fill_cqe_req().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 668fff18d3cc..4134b206c33c 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -43,10 +43,12 @@ static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 {
 	struct io_uring_cqe *cqe;
 
-	if (!(ctx->flags & IORING_SETUP_CQE32)) {
-		trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
-					req->cqe.res, req->cqe.flags, 0, 0);
+	trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
+				req->cqe.res, req->cqe.flags,
+				(req->flags & REQ_F_CQE32_INIT) ? req->extra1 : 0,
+				(req->flags & REQ_F_CQE32_INIT) ? req->extra2 : 0);
 
+	if (!(ctx->flags & IORING_SETUP_CQE32)) {
 		/*
 		 * If we can't get a cq entry, userspace overflowed the
 		 * submission (by quite a lot). Increment the overflow count in
@@ -65,9 +67,6 @@ static inline bool __io_fill_cqe_req(struct io_ring_ctx *ctx,
 			extra2 = req->extra2;
 		}
 
-		trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
-					req->cqe.res, req->cqe.flags, extra1, extra2);
-
 		/*
 		 * If we can't get a cq entry, userspace overflowed the
 		 * submission (by quite a lot). Increment the overflow count in
-- 
2.36.1

