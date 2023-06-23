Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38D773B60C
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 13:24:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbjFWLYk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 07:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229902AbjFWLYj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 07:24:39 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED87199D
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:38 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-98cd280cf94so55249266b.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687519477; x=1690111477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+lwiOcyRcQxHexdz5pJ0BkWCi2jupIP80iYWP8FCMjU=;
        b=NrLyE/dUTEwRthfs8DlmOtOSmviumQfA6Xn8hjSZabDJo6wtL/5FJFk+nbXIWWMHR0
         +ja9ah/1kgKxvhZmOgRrd6EagukEigHXYEDISgKKE9nGl60ZMfbDjOgUF0GIq1Z99dOs
         4FndB+63BdAP2Z7+Q9l3Oa9D5vHEPaHumr5YhG8/DXQ+haP75Y8a6bc2tePU8QV8+4yi
         kg1FDgq3s4va+4mU/RX/rgaeGH3yCzjLz9jSb8FqdFkGoloDS+3opdzsvDYYgAjlrIQM
         l3NHdlZ43FWESnP4gvj8ResuErVNqOtCghgkEuYBIa1OwVKFFtJIKYBaa7SUPYO/MkOF
         P52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519477; x=1690111477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+lwiOcyRcQxHexdz5pJ0BkWCi2jupIP80iYWP8FCMjU=;
        b=XTFPxDlHxmCdH0KkfrbTFASYak++GP8KtURDbUktFv0hoFwqfcKXpfx97KLOI8Y/0K
         9GThDSH6A58PLND9x+tjlBuBJZuZIDUHnChGa7KZfu5eDKxPuVypaAYgR7Vdju5KQICR
         amOLEBLI6JAxfo3FGIXqW+baqM4F2EfudfDRAdwEIwuQyCcueUVZ+X+9cJE6RrT2FHau
         z667qoQCYAAIleb122sLGlKdbjWoeeeaIEZitX6rM5dTCoT4ZOhETDm+1V2HLkqkosv4
         VkAcR2hT93+7c5wBz+AlW23InZcpBe8c0ZIFGq1chJ6oh3Xfr4+opC8+G7RdjG4xFyEN
         TPCw==
X-Gm-Message-State: AC+VfDwkjUOssE/QwltJUVlGAV7pCyJGvkwosQDjwJWAH/VUslC2m6Dg
        QAJ9LZFbl9dhyMi7e9o6rOl8Q+Bqh/8=
X-Google-Smtp-Source: ACHHUZ5HLrelac8iGSiCk/ZD7Dou63qrthmmXTkIu2ALG94l0puD1LBS+PDnp+liTNYjDexxV1Q28g==
X-Received: by 2002:a17:907:a408:b0:98d:3ae:b683 with SMTP id sg8-20020a170907a40800b0098d03aeb683mr4469262ejc.19.1687519476729;
        Fri, 23 Jun 2023 04:24:36 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7d95])
        by smtp.gmail.com with ESMTPSA id h10-20020a1709067cca00b00969f44bbef3sm5959769ejp.11.2023.06.23.04.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:24:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 01/11] io_uring: open code io_put_req_find_next
Date:   Fri, 23 Jun 2023 12:23:21 +0100
Message-Id: <38b5c5e48e4adc8e6a0cd16fdd5c1531d7ff81a9.1687518903.git.asml.silence@gmail.com>
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

There is only one user of io_put_req_find_next() and it doesn't make
much sense to have it. Open code the function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index ae4cb3c4e730..b488a03ba009 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1586,22 +1586,6 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	}
 }
 
-/*
- * Drop reference to request, return next in chain (if there is one) if this
- * was the last reference to this request.
- */
-static inline struct io_kiocb *io_put_req_find_next(struct io_kiocb *req)
-{
-	struct io_kiocb *nxt = NULL;
-
-	if (req_ref_put_and_test(req)) {
-		if (unlikely(req->flags & IO_REQ_LINK_FLAGS))
-			nxt = io_req_find_next(req);
-		io_free_req(req);
-	}
-	return nxt;
-}
-
 static unsigned io_cqring_events(struct io_ring_ctx *ctx)
 {
 	/* See comment at the top of this file */
@@ -1954,9 +1938,14 @@ int io_poll_issue(struct io_kiocb *req, struct io_tw_state *ts)
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_kiocb *nxt = NULL;
 
-	req = io_put_req_find_next(req);
-	return req ? &req->work : NULL;
+	if (req_ref_put_and_test(req)) {
+		if (req->flags & IO_REQ_LINK_FLAGS)
+			nxt = io_req_find_next(req);
+		io_free_req(req);
+	}
+	return nxt ? &nxt->work : NULL;
 }
 
 void io_wq_submit_work(struct io_wq_work *work)
-- 
2.40.0

