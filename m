Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67AC787BB8
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243972AbjHXWzo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244036AbjHXWzf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:35 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D731FD4
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:26 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-99c93638322so82674766b.1
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917724; x=1693522524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=f2DEBEI1Rhro87I5c331VMzG9L/kWUItjuQZp5E+Z+g=;
        b=C6EbkJzQNTy6eC066kxnL3PBgnsbdfomW6X+FCk8KxRaEPS+IA0XdJrwsINO2Vel9O
         n47N2lDoRo44pJBrbV3nrMJq3Mg/aVLrQqUirYNQFyXA2pkNZVUiiVlBAIubB0/5jq0O
         tsnkJqTENyoMepfC877D/NrTHU6IrwAPJwIr/1Rxh8raQozIhNf6VsDJ4cnvJChvLgNL
         Ym+DxuUxP4btP3SaA1z9uxM3o9Xr5tUiROL5mlCxiYgOndekdHHg1m6jBH4TvcDSmIoh
         Yrwh7eKfJ7grTC3eGSgp99KRz7Byb8fxDfymgcygNsDqgeYtPkVzibbqhkHKRq+xVXMa
         HCyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917724; x=1693522524;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f2DEBEI1Rhro87I5c331VMzG9L/kWUItjuQZp5E+Z+g=;
        b=WF9rXm9Uxq2iY5N0YGoCCrpwLkHcPcjoSOiAdVe2MH6qtiwYcpkmPwK3B7ZzXatExm
         111WxGxvVeetx3V5rXdQM6cAnqaRUGrpKZSkxb1GTDVp+9MSuo5d3AgxjD0pVXHB5sRw
         DITD8YokFbIfQwvVNW8BFy1cUbAiQUwEMqc2qEZlGAkk4SU8Xxhmh7ZTQivEs3sfhctT
         Zlf5tOByZw4J5qmGyo8fSAfWMmMhyEILrlCsmoGVhipSmFals/RM42IODcz7YtnhNuyh
         j77IDbb1iI+9YHQu1APuAuK8+iJpV14oYA78prCa8dqCe0PHJPk5M6lWF1RWyK3Arabf
         8SmA==
X-Gm-Message-State: AOJu0YzKYXLdKjuC/HC7Y6LfySXIJ+tmxJGuXdRBP15MADe5JI30/n2R
        DK1086RRdq8vgcRhyr+uqVG/J3njNNo=
X-Google-Smtp-Source: AGHT+IGfrOnKQbGVXpbfIeoFCnyMsZrBur8vlDhm2MndWt3c5/JjJZdgA80aBUui9kyz3GijnqKLyA==
X-Received: by 2002:a17:906:974a:b0:9a1:c69c:9388 with SMTP id o10-20020a170906974a00b009a1c69c9388mr8709018ejy.37.1692917724666;
        Thu, 24 Aug 2023 15:55:24 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 08/15] io_uring: force inline io_fill_cqe_req
Date:   Thu, 24 Aug 2023 23:53:30 +0100
Message-ID: <ffce4fc5e3521966def848a4d930586dfe33ae11.1692916914.git.asml.silence@gmail.com>
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

There are only 2 callers of io_fill_cqe_req left, and one of them is
extremely hot. Force inline the function.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 07fd185064d2..547c30582fb8 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -132,7 +132,8 @@ static inline bool io_get_cqe(struct io_ring_ctx *ctx, struct io_uring_cqe **ret
 	return io_get_cqe_overflow(ctx, ret, false);
 }
 
-static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx, struct io_kiocb *req)
+static __always_inline bool io_fill_cqe_req(struct io_ring_ctx *ctx,
+					    struct io_kiocb *req)
 {
 	struct io_uring_cqe *cqe;
 
-- 
2.41.0

