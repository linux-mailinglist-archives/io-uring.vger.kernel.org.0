Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C714DBCD4
	for <lists+io-uring@lfdr.de>; Thu, 17 Mar 2022 03:05:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358430AbiCQCGU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Mar 2022 22:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358401AbiCQCGO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Mar 2022 22:06:14 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940541EAD1
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:04:58 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id w4so4867632edc.7
        for <io-uring@vger.kernel.org>; Wed, 16 Mar 2022 19:04:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IUpuFoukBivRi0Ccn0Bly68yj0WlQJWLmqMgIN+V9NU=;
        b=IaH2SUVReLF364qsx2tX44SNKBoCppCejEiDmzX2edOqGgn6OzX/P6TSZKtB+E8enI
         kr6U1+NKh3aaQQ+96GCsTQqeFWk0iv/A8Vm/UIOL5Z3eXj46g8nyk8JvFDFcvw6Bi4Y6
         Yn+meQGbo08Tuh/ibXogb3uuryqPST0tYLteRS0m13GYCq+pP5IiPvzu5c+ctVRcUSqn
         DXdzNut+TaXBPwOfCuah75ka/NV0ZC3wflgaa4szBhVIqwMvXN1auFyjhvNjfmx1RXWN
         M8w2BwL9JJmHr45TsKyd8Hl5YaRrr85SMgkEOaRMDtPtAox6JzI25TWUPm8Oym1dLTC8
         UVXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IUpuFoukBivRi0Ccn0Bly68yj0WlQJWLmqMgIN+V9NU=;
        b=LUXTc15GNaBMMJQ5hhZO/LFmJKwSkVKaBu5297r2cUS2I8rCzK8tXJ8uKdvszNdwb+
         ftMS49h/2Kj7KzRjEX/FCEdO49yHZTbtnGd9Fww72RGyVu/XDI+GNApO/sAyBOxPs5yN
         GaQ7paoiAFYAeZZwdOevUPjku+eYYiBdO0sHc0bBrmufeNBc+OvgQn/xCG6s1SM7pHlp
         8oP7VhA8iLzvV8WWXfkGqLpZ7HUILGuiMFvBEHrJc8Vv9RgQkb58UN/FXQJnjZ8jBSBn
         UE/myZ/V37ax6mae6wwqDJu8rkN13m81/0bZvmK0NskJSRA0H/dyZ3RrcP1mGRzaGFVK
         SS8g==
X-Gm-Message-State: AOAM530gVdRLyscUVFd0SfrflUKVjGxKX8pkz6q9nCTGViRel99gvK6Z
        H8G/Z9ypVZwGPw18FORjIoJMqNcnMPgjoQ==
X-Google-Smtp-Source: ABdhPJzaU66/7cZhckkvkIUoMfHWMnh7mZNQPlC0w8DsxyoNakHvBrTNog58XbKe9Q0YxAupV3DmOA==
X-Received: by 2002:aa7:d0d5:0:b0:418:f8c7:23ee with SMTP id u21-20020aa7d0d5000000b00418f8c723eemr892850edo.175.1647482696880;
        Wed, 16 Mar 2022 19:04:56 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.234.67])
        by smtp.gmail.com with ESMTPSA id b26-20020aa7df9a000000b00416b3005c4bsm1876048edy.46.2022.03.16.19.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 19:04:56 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/7] io_uring: normilise naming for fill_cqe*
Date:   Thu, 17 Mar 2022 02:03:36 +0000
Message-Id: <bd016ff5c1a4f74687828069d2619d8a65e0c6d7.1647481208.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647481208.git.asml.silence@gmail.com>
References: <cover.1647481208.git.asml.silence@gmail.com>
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

Restore consistency in __io_fill_cqe* like helpers, always honouring
"io_" prefix and adding "req" when we're passing in a request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 299154efcd8a..10fb82f1c8ca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2011,7 +2011,7 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 	return true;
 }
 
-static inline bool __fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
+static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
 				 s32 res, u32 cflags)
 {
 	struct io_uring_cqe *cqe;
@@ -2031,16 +2031,16 @@ static inline bool __fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
 	return io_cqring_event_overflow(ctx, user_data, res, cflags);
 }
 
-static inline bool __io_fill_cqe(struct io_kiocb *req, s32 res, u32 cflags)
+static inline bool __io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
 {
 	trace_io_uring_complete(req->ctx, req, req->user_data, res, cflags);
-	return __fill_cqe(req->ctx, req->user_data, res, cflags);
+	return __io_fill_cqe(req->ctx, req->user_data, res, cflags);
 }
 
 static noinline void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
 {
 	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe(req, res, cflags);
+		__io_fill_cqe_req(req, res, cflags);
 }
 
 static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
@@ -2048,7 +2048,7 @@ static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
 {
 	ctx->cq_extra++;
 	trace_io_uring_complete(ctx, NULL, user_data, res, cflags);
-	return __fill_cqe(ctx, user_data, res, cflags);
+	return __io_fill_cqe(ctx, user_data, res, cflags);
 }
 
 static void __io_req_complete_post(struct io_kiocb *req, s32 res,
@@ -2057,7 +2057,7 @@ static void __io_req_complete_post(struct io_kiocb *req, s32 res,
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!(req->flags & REQ_F_CQE_SKIP))
-		__io_fill_cqe(req, res, cflags);
+		__io_fill_cqe_req(req, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -2649,7 +2649,7 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 						    comp_list);
 
 			if (!(req->flags & REQ_F_CQE_SKIP))
-				__io_fill_cqe(req, req->result, req->cflags);
+				__io_fill_cqe_req(req, req->result, req->cflags);
 		}
 
 		io_commit_cqring(ctx);
@@ -2771,7 +2771,7 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (unlikely(req->flags & REQ_F_CQE_SKIP))
 			continue;
 
-		__io_fill_cqe(req, req->result, io_put_kbuf(req, 0));
+		__io_fill_cqe_req(req, req->result, io_put_kbuf(req, 0));
 		nr_events++;
 	}
 
-- 
2.35.1

