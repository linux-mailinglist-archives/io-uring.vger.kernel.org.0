Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 385026D97EB
	for <lists+io-uring@lfdr.de>; Thu,  6 Apr 2023 15:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238029AbjDFNVD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Apr 2023 09:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238141AbjDFNU5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Apr 2023 09:20:57 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619E9A246;
        Thu,  6 Apr 2023 06:20:26 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-50299ceefa4so1300953a12.2;
        Thu, 06 Apr 2023 06:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680787224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OFPFrQtthgmu2R5B+cqkgAt4SXW7neAKcH/973v1o60=;
        b=jDHpciR8zlv2xmb3+NF0BJkS/+wymZqezlIUfWqud0zV2V+oRkaFEMPNULVUHUNnNT
         0Nj2KAh3ZJPzkgQQXQxB3owvsxSTEBJ4+RC5oWBRbDieJstz/KAWzFTJ2CB/eL9xEumO
         H20k5ZIoNSSmEBoLRPPcc37wkfXpi5Ikhm78V7ORHSoq6CbpNhkwIggCqTsW+DxI7IFt
         c+tCwUpoOorU/BR2AO9S3zm+YJMITMR6DSDkz3uE4FEShzsyOCfzsLE3qZHB+VBhBqt9
         ym4Sa2CKWpsiNmtcRiDkM9NUjNsEEZl9Aa3BsG+fMcrPE/jI4JEX9pu8BghKfdj/Pbzq
         zUSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680787224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OFPFrQtthgmu2R5B+cqkgAt4SXW7neAKcH/973v1o60=;
        b=sAIk8A35l1TgOI+q9mAnYW3xz31+3bTZ+5wJKkq4dpAkznNzT1JCsHiyB1pQAgzNQz
         IUuKBeVV8JLTWk6QCqrOGtpfmE3jrXhp2UfuxoEu83oBV92Fm3FzRkFNFEBsld0eCrrt
         U3m+KN9K29biBCzphO9SmqnHGrdGKh6MUvZMCHrPZuGN5TjwAKqoiqHDHEvjnLMz8qkL
         Pr9wr9C7+PHSGBflXPQ61sk8lyrw/Iv7A5XWg1hHR8n4xthKo+8X/CFIhcYvItFTWdCQ
         4YGwoxa1+wppD5fo9UBlCgFVuD2HZRSBWgfZJ+AV3kBUUlGybfUBqbqGd7hpMZKZrdXx
         eDzQ==
X-Gm-Message-State: AAQBX9dbuKheAfJBvyMIqtyJKG5ZS0kDdx9jA9olXOhfUFalPMYZKRpz
        imDVwWCc5jJkVUu636eDVESDY5g6EeA=
X-Google-Smtp-Source: AKy350bY+R7WtlKIXO+D9HY+v7ORLddUWtatGabkl2J9KHqXzp6m/oSg+uZnS30TIjZI/rikaS7M/w==
X-Received: by 2002:aa7:ce15:0:b0:502:2148:2980 with SMTP id d21-20020aa7ce15000000b0050221482980mr5078208edv.30.1680787224359;
        Thu, 06 Apr 2023 06:20:24 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a638])
        by smtp.gmail.com with ESMTPSA id m20-20020a509994000000b0050470aa444fsm312732edb.51.2023.04.06.06.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 06:20:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/8] io_uring: optimie local tw add ctx pinning
Date:   Thu,  6 Apr 2023 14:20:08 +0100
Message-Id: <cbdfcb6b232627f30e9e50ef91f13c4f05910247.1680782017.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1680782016.git.asml.silence@gmail.com>
References: <cover.1680782016.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently pin the ctx for io_req_local_work_add() with
percpu_ref_get/put, which imply two rcu_read_lock/unlock pairs and some
extra overhead on top in the fast path. Replace it with a pure rcu read
and let io_ring_exit_work() synchronise against it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 29a0516ee5ce..fb7215b543cd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1332,9 +1332,9 @@ void __io_req_task_work_add(struct io_kiocb *req, bool allow_local)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (allow_local && ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-		percpu_ref_get(&ctx->refs);
+		rcu_read_lock();
 		io_req_local_work_add(req);
-		percpu_ref_put(&ctx->refs);
+		rcu_read_unlock();
 		return;
 	}
 
@@ -3052,6 +3052,10 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	spin_lock(&ctx->completion_lock);
 	spin_unlock(&ctx->completion_lock);
 
+	/* pairs with RCU read section in io_req_local_work_add() */
+	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+		synchronize_rcu();
+
 	io_ring_ctx_free(ctx);
 }
 
-- 
2.40.0

