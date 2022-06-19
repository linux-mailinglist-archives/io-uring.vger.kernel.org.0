Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53195507F2
	for <lists+io-uring@lfdr.de>; Sun, 19 Jun 2022 04:07:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiFSCHW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 22:07:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbiFSCHU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 22:07:20 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37C1BE12
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 19:07:19 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id r1so6893722plo.10
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 19:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qnYCdoubkpiLmSN6UHWGctyowhlzWD/sapXtgqX+VFE=;
        b=lJc6uK3jeelmmM32+nNdkmzTJV2Xd5/sH3yYHqM+OdfeeoNjzOyJ7m+uzES0jbRW64
         J0b2J+W4pznHfMJmEe8M5Moy+Rn4avBV5bxhGdKX4nPqbdJp5neuYrJT8ZZlIwvnQ1RE
         qaFoVARme87pZCbsh/AN3crhcJHrtXEeb/SGfMO20q01eJvfWswTPmZfL1DZuZGSKnv1
         mvKqv8kmPkdIsfu5pM+A/oxHT2AEbwTWI9e5E9mXgXIhT5m3K4Cg30ANHolOqat401kl
         P/OLvEzRrp0laq+yU2Ep1MIp3jGHlAAz//6hkb2wde1EeyfRYVKL+M9Rq37gMigGJG+l
         bFqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qnYCdoubkpiLmSN6UHWGctyowhlzWD/sapXtgqX+VFE=;
        b=VqeUnzrgBMmhqnWOF8eXWt2kLqiynaDbmG2NFgQz5XGo6CJYIC+tqcjJVL8TMBcBVy
         nYH+5gpmV3Y+fNgRPYkKmdYFOrOi3AejE9gsqn5g5+sc9PX0Se/kxLI+SzBCY1x8U456
         NMyanW7JCU4zmoQtgOQz5tjoJjSuBHkyjqI/qWCxr44byWhJYh3EbUBauz6KoUScqohP
         0ev0nOVhElIiVl/5nJiQys+aglmSzhkTC+z5B63cRiCfHZiu9dkNzlAsIhZndmAgYo8l
         MaJKE4pl1n+xeVdKxb3W0B2cfP4ktTZevmQ5ctyqZt58eBiQPdCxznHtnWQicq+SxaF2
         ueqg==
X-Gm-Message-State: AJIora9pj/pUlVXdF9eOfigdvBYPxVB3DJQyPpvz0ocki5n/dstCHI8v
        7H0JkmG4JfpkfGMpOGZM1XAzv9QSuSpoGA==
X-Google-Smtp-Source: AGRyM1vIYLZbNWw9werOyyeaXSe96iIjsZC7ZEb1SS7L20lSJLPNIJloZ0cJtDH2GSi31XNUVvO0Kw==
X-Received: by 2002:a17:903:1d2:b0:168:e3b9:e62b with SMTP id e18-20020a17090301d200b00168e3b9e62bmr17098487plh.115.1655604439103;
        Sat, 18 Jun 2022 19:07:19 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p24-20020aa78618000000b0051c7038bd52sm6118598pfn.220.2022.06.18.19.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jun 2022 19:07:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, carter.li@eoitek.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: have cancelation API accept io_uring_task directly
Date:   Sat, 18 Jun 2022 20:07:13 -0600
Message-Id: <20220619020715.1327556-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220619020715.1327556-1-axboe@kernel.dk>
References: <20220619020715.1327556-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We just use the io_kiocb passed in to find the io_uring_task, and we
already pass in the ctx via cd->ctx anyway.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cancel.c  | 17 +++++++++--------
 io_uring/cancel.h  |  2 +-
 io_uring/timeout.c |  2 +-
 3 files changed, 11 insertions(+), 10 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index d1e7f5a955ab..500ee5f5fd23 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -77,15 +77,15 @@ static int io_async_cancel_one(struct io_uring_task *tctx,
 	return ret;
 }
 
-int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd,
+int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 		  unsigned issue_flags)
 {
-	struct io_ring_ctx *ctx = req->ctx;
+	struct io_ring_ctx *ctx = cd->ctx;
 	int ret;
 
-	WARN_ON_ONCE(!io_wq_current_is_worker() && req->task != current);
+	WARN_ON_ONCE(!io_wq_current_is_worker() && tctx != current->io_uring);
 
-	ret = io_async_cancel_one(req->task->io_uring, cd);
+	ret = io_async_cancel_one(tctx, cd);
 	/*
 	 * Fall-through even for -EALREADY, as we may have poll armed
 	 * that need unarming.
@@ -104,7 +104,6 @@ int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd,
 	return ret;
 }
 
-
 int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_cancel *cancel = io_kiocb_to_cmd(req);
@@ -127,7 +126,8 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int __io_async_cancel(struct io_cancel_data *cd, struct io_kiocb *req,
+static int __io_async_cancel(struct io_cancel_data *cd,
+			     struct io_uring_task *tctx,
 			     unsigned int issue_flags)
 {
 	bool all = cd->flags & (IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_ANY);
@@ -136,7 +136,7 @@ static int __io_async_cancel(struct io_cancel_data *cd, struct io_kiocb *req,
 	int ret, nr = 0;
 
 	do {
-		ret = io_try_cancel(req, cd, issue_flags);
+		ret = io_try_cancel(tctx, cd, issue_flags);
 		if (ret == -ENOENT)
 			break;
 		if (!all)
@@ -170,6 +170,7 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 		.flags	= cancel->flags,
 		.seq	= atomic_inc_return(&req->ctx->cancel_seq),
 	};
+	struct io_uring_task *tctx = req->task->io_uring;
 	int ret;
 
 	if (cd.flags & IORING_ASYNC_CANCEL_FD) {
@@ -185,7 +186,7 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 		cd.file = req->file;
 	}
 
-	ret = __io_async_cancel(&cd, req, issue_flags);
+	ret = __io_async_cancel(&cd, tctx, issue_flags);
 done:
 	if (ret < 0)
 		req_set_fail(req);
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 2338012a5b06..1bc7e917ce94 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -16,6 +16,6 @@ struct io_cancel_data {
 int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
 
-int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd,
+int io_try_cancel(struct io_uring_task *tctx, struct io_cancel_data *cd,
 		  unsigned int issue_flags);
 void init_hash_table(struct io_hash_table *table, unsigned size);
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 557c637af158..a01480a9d29f 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -272,7 +272,7 @@ static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 				.data		= prev->cqe.user_data,
 			};
 
-			ret = io_try_cancel(req, &cd, issue_flags);
+			ret = io_try_cancel(req->task->io_uring, &cd, issue_flags);
 		}
 		io_req_set_res(req, ret ?: -ETIME, 0);
 		io_req_complete_post(req);
-- 
2.35.1

