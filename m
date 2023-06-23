Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07C5973B615
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 13:24:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbjFWLYs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 07:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231316AbjFWLYo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 07:24:44 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4F01739
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:43 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id a640c23a62f3a-9891c73e0fbso106321266b.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687519482; x=1690111482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W/0GCHAnwAQDlppeivwuLOoAX8CU5QX5fMWO37pepWE=;
        b=l2TZWufFQaUmTeC4g8BmLmBbR7dxJYsNxHDDr+l6IpOIsczxiB9T07j4cqadUVqYqr
         4YxqcEyS1bUllVz8njPrDhQz5dgY7xJEIwOH3aTA6e04XSE74bzhdSnqR+Quk/MxH9jI
         MOSVyge3leQSyXKW2ZZGP+Gor62/0q91g3bVJfmm/dWgEiGVtV7c+a9nMGLQI3EM5M0u
         Lv1p6sI44eg/tverg/ctsUkeIB+KaeaeGynaH9PsAcsKM5bO0K+vxAcoHZ5jJoBMA4ly
         xw35gj/MqbbhHreq0rIXT8HdrWqDbhFSdFul7s6J+LHWydFa0hs432eCvGh97XLkTT0V
         RvYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519482; x=1690111482;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W/0GCHAnwAQDlppeivwuLOoAX8CU5QX5fMWO37pepWE=;
        b=cTtDc6I36gwJP+hHjjfiy5HhhmTw43iKsFfruEeDXrILDKinc6P+JJdukG6Np1A6MB
         hbXmzHutj3/X2j9nuuYpznHYGaYwQrufTxEIzaRj/FkgDS7w67s2CGCLCy11uMdqVBZf
         uzc5ZRxurS81+xB64NGqDSWjtbA3blY9JHhDzQTHM+tEKE6VxokZ0TnHs14EZyMvwl32
         CK7ZWja2CpsfN5qApfB3ihxbP8yuekvJmJA+c9DamontiiQ7GWzkqAQ/H+cjDGdZc9Ss
         GoJRmuCGqe1aF9odWIoihEW8IS4kjZvIFjyGcwG3xWx3Jj2Flab2vOwqP2Xgwjy3o7yT
         n8pg==
X-Gm-Message-State: AC+VfDzgVlCpVw192zTObBmTg+PxKtMPjKQG5xmWeHHOgAs5Wd6WEp9r
        hTCmIKWir+GGdr/ghLSpsLDGeOdD/pI=
X-Google-Smtp-Source: ACHHUZ4KV9HEjAWSBUk7IIJud9h5j9nkeODFGjA2HB9U3oFC1GIiNca7eVUq9qp0xkxx3ezUz4h7Vg==
X-Received: by 2002:a17:907:3e16:b0:985:259f:6f50 with SMTP id hp22-20020a1709073e1600b00985259f6f50mr21242995ejc.34.1687519482154;
        Fri, 23 Jun 2023 04:24:42 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7d95])
        by smtp.gmail.com with ESMTPSA id h10-20020a1709067cca00b00969f44bbef3sm5959769ejp.11.2023.06.23.04.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:24:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 10/11] io_uring: make io_cq_unlock_post static
Date:   Fri, 23 Jun 2023 12:23:30 +0100
Message-Id: <3dc8127dda4514e1dd24bb32035faac887c5fa37.1687518903.git.asml.silence@gmail.com>
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

io_cq_unlock_post() is exclusively used in io_uring/io_uring.c, mark it
static and don't expose to other files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 io_uring/io_uring.h | 2 --
 2 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 39d83b631107..70fffed83e95 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -666,7 +666,7 @@ static void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
 	}
 }
 
-void io_cq_unlock_post(struct io_ring_ctx *ctx)
+static void io_cq_unlock_post(struct io_ring_ctx *ctx)
 	__releases(ctx->completion_lock)
 {
 	io_commit_cqring(ctx);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 20ba6df49b1f..d3606d30cf6f 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -110,8 +110,6 @@ static inline void io_req_task_work_add(struct io_kiocb *req)
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
-void io_cq_unlock_post(struct io_ring_ctx *ctx);
-
 static inline struct io_uring_cqe *io_get_cqe_overflow(struct io_ring_ctx *ctx,
 						       bool overflow)
 {
-- 
2.40.0

