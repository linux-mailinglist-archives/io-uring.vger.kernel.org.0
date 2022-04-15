Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46718502AFF
	for <lists+io-uring@lfdr.de>; Fri, 15 Apr 2022 15:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240643AbiDONiG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 09:38:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354021AbiDONfy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 09:35:54 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EE8674D6
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:33:25 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id bg9so7280023pgb.9
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 06:33:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L6FUFvPLmMwd/Xoznj6/mDk4ffdpoBfXfQeWLgt9omk=;
        b=183PtIdpPfytJmjsFqQ3yAFvtNK6tvxej7XTY7T6mKMIx8LJbpzPZQdnolPUNKf/n7
         8JCiUsY3WbU/4/rwnA1q+rZDUWmLUZwCADN0QUPblzlt2RdumZ3b7oqBKPiup4o2EX1U
         XL2uHrL8aIkjuN5P6YU7cFiMRJNMrK2N1riarVzZGCE+vUXrWIR6SKEq4CmCyayqGm2/
         cc2ZyqXgapqMnCo8yda2gP0MKwLbs4WxLI4z2gB2saYz6Gp7Rlg2AvyUax5D+TDjp1R9
         fPIESdpKgwiiCzhg4UlQeisqAkkMfNq0oeOQinjmbvLqccWZngQFK+8C3NZu/If6GYHk
         FE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L6FUFvPLmMwd/Xoznj6/mDk4ffdpoBfXfQeWLgt9omk=;
        b=RipS6dGK9VLL2H6Q8omJxwqs4DCpGCYW4piwdDVUqPgLLrDRP0XR2Sd6sVFO0vODMi
         qM9EpaNYv6HfjD/wwq5q4FtiEPvG6atgwhkPXFxMvfUG1Vo2ZOSgSfwidU3pmTLCKk+v
         yFxcu+1PCnnS38F8qLRT8xFHg+Lupk68+FZaXUDQUcxwyfLWxHqCXX2BmBC/WulZ6rKJ
         bjorSAai+F0vPhF/QcYy2TWQV+X1Ez3EfkEItWLvVh+Z21QtFTLOa+aQUbOUe9fhj9Z4
         58blNMv1J01LR6vHupw7bPA8iKt7meBGLdz5x6DZbQdvKZYBCxT0XY8Dyu8pZAlcfSs7
         8MnA==
X-Gm-Message-State: AOAM533Vsu7iRV0W98wKj8mn+cPsXTKC5+nUTlSLU5uVifCGT33S2LQ6
        +Ws8Cz6BwUbPevE6+ti94YXYYLbHQbQ89w==
X-Google-Smtp-Source: ABdhPJwclhFwqeOjhH9D2TRMqCzLNdhaBjIw5zwEh8KhXBVb6JXyTbzlev74ns4Z6X2ZJ8k01RiRzA==
X-Received: by 2002:aa7:920d:0:b0:505:c9d4:5819 with SMTP id 13-20020aa7920d000000b00505c9d45819mr8947068pfo.15.1650029604719;
        Fri, 15 Apr 2022 06:33:24 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id n19-20020a635c53000000b0039dc2ea9876sm4576604pgm.49.2022.04.15.06.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 06:33:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: pass in struct io_cancel_data consistently
Date:   Fri, 15 Apr 2022 07:33:16 -0600
Message-Id: <20220415133319.75077-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220415133319.75077-1-axboe@kernel.dk>
References: <20220415133319.75077-1-axboe@kernel.dk>
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

In preparation for being able to not only key cancel off the user_data,
pass in the io_cancel_data struct.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 878d30a31606..a45ab678a455 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6316,10 +6316,15 @@ static bool io_poll_disarm(struct io_kiocb *req)
 	return true;
 }
 
-static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
+struct io_cancel_data {
+	struct io_ring_ctx *ctx;
+	u64 user_data;
+};
+
+static int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 	__must_hold(&ctx->completion_lock)
 {
-	struct io_kiocb *req = io_poll_find(ctx, sqe_addr, false);
+	struct io_kiocb *req = io_poll_find(ctx, cd->user_data, false);
 
 	if (!req)
 		return -ENOENT;
@@ -6752,11 +6757,6 @@ static int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-struct io_cancel_data {
-	struct io_ring_ctx *ctx;
-	u64 user_data;
-};
-
 static bool io_cancel_cb(struct io_wq_work *work, void *data)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
@@ -6765,17 +6765,16 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
 	return req->ctx == cd->ctx && req->cqe.user_data == cd->user_data;
 }
 
-static int io_async_cancel_one(struct io_uring_task *tctx, u64 user_data,
-			       struct io_ring_ctx *ctx)
+static int io_async_cancel_one(struct io_uring_task *tctx,
+			       struct io_cancel_data *cd)
 {
-	struct io_cancel_data data = { .ctx = ctx, .user_data = user_data, };
 	enum io_wq_cancel cancel_ret;
 	int ret = 0;
 
 	if (!tctx || !tctx->io_wq)
 		return -ENOENT;
 
-	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, &data, false);
+	cancel_ret = io_wq_cancel_cb(tctx->io_wq, io_cancel_cb, cd, false);
 	switch (cancel_ret) {
 	case IO_WQ_CANCEL_OK:
 		ret = 0;
@@ -6791,14 +6790,14 @@ static int io_async_cancel_one(struct io_uring_task *tctx, u64 user_data,
 	return ret;
 }
 
-static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
+static int io_try_cancel(struct io_kiocb *req, struct io_cancel_data *cd)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	WARN_ON_ONCE(!io_wq_current_is_worker() && req->task != current);
 
-	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
+	ret = io_async_cancel_one(req->task->io_uring, cd);
 	/*
 	 * Fall-through even for -EALREADY, as we may have poll armed
 	 * that need unarming.
@@ -6807,12 +6806,12 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
 		return 0;
 
 	spin_lock(&ctx->completion_lock);
-	ret = io_poll_cancel(ctx, sqe_addr);
+	ret = io_poll_cancel(ctx, cd);
 	if (ret != -ENOENT)
 		goto out;
 
 	spin_lock_irq(&ctx->timeout_lock);
-	ret = io_timeout_cancel(ctx, sqe_addr);
+	ret = io_timeout_cancel(ctx, cd->user_data);
 	spin_unlock_irq(&ctx->timeout_lock);
 out:
 	spin_unlock(&ctx->completion_lock);
@@ -6837,11 +6836,14 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	u64 sqe_addr = req->cancel.addr;
+	struct io_cancel_data cd = {
+		.ctx		= ctx,
+		.user_data	= req->cancel.addr,
+	};
 	struct io_tctx_node *node;
 	int ret;
 
-	ret = io_try_cancel_userdata(req, sqe_addr);
+	ret = io_try_cancel(req, &cd);
 	if (ret != -ENOENT)
 		goto done;
 
@@ -6851,7 +6853,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
 
-		ret = io_async_cancel_one(tctx, req->cancel.addr, ctx);
+		ret = io_async_cancel_one(tctx, &cd);
 		if (ret != -ENOENT)
 			break;
 	}
@@ -7455,8 +7457,14 @@ static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 	int ret = -ENOENT;
 
 	if (prev) {
-		if (!(req->task->flags & PF_EXITING))
-			ret = io_try_cancel_userdata(req, prev->cqe.user_data);
+		if (!(req->task->flags & PF_EXITING)) {
+			struct io_cancel_data cd = {
+				.ctx		= req->ctx,
+				.user_data	= prev->cqe.user_data,
+			};
+
+			ret = io_try_cancel(req, &cd);
+		}
 		io_req_complete_post(req, ret ?: -ETIME, 0);
 		io_put_req(prev);
 	} else {
-- 
2.35.1

