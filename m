Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8D4505C94
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 18:44:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346357AbiDRQqs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 12:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237766AbiDRQqr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 12:46:47 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53D1326EB
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 09:44:07 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id k12so1923570ilv.3
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 09:44:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ChgVR7oin7ditoi63czzpBXeOdm930Tl8Svdi8C7mLg=;
        b=7c4vXkn0pyTNtYDcrgOogog1PRArA90S8ztfByRCFDWhfkxC4DL3FZl2HB2A5CG7nW
         2lO7TWmx6ITCoLM3pI5zeqfqHY9aFXqvTQYhEUlymIhU3CoXM+UAK7MLJExfVfNwDvAw
         cjf+WBAbImt9OHEU35/a9HrbKf3Y1IBYC/gIPTzEmJJbXCoiHSN1O8y1uAbQEVeDU7XC
         NXtjiwkTIXbYaMYhzRawPtrlRv1x8gpfchUMUSP2h7xZIXXX5+NyzrC0stzDzhUGG7uv
         EeeyNs9LEQ/zbPcX59sicW3f2YrHxCnqCgQgYkMWpj7y1kJxY4E+dnJ0svjpvr3P25yd
         Xgfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ChgVR7oin7ditoi63czzpBXeOdm930Tl8Svdi8C7mLg=;
        b=YY4omdjuEaEv9ZAbEwQmE4bbwgqHz8HT6cAbIhgdiPxx7jJnFLy0/ZHMfvnAoqcVxg
         VpkQlswBZL/yJfv+zYhiPJgsP4JBg9UQ6MoaHg0nzVCGfuewr0TGOhwsEQnRFbtZWMPf
         RJ0oM9TWpDRB1XFlFJ8bQqSG4aEcY3BS8TU9M6ZSjS1N+BIJfVgCONVb5A4lyykAtFHI
         yP16KL6e34ieIGl3CgGEpnrlB9y3G61nZyoEnoFzegzL0FhvEl8Wh5TNP/Dy98ToWaoD
         iElltYFP3qmkMdnA16CJlEwfqYTyA/Oq/8JIa8aonLziEDXhSywfKVRyLVH9Df4HAU3x
         hThQ==
X-Gm-Message-State: AOAM530/vCduHn8JFwwZQq5o24z3pU097yb28eso/Gh/AF7JdRyIn0yN
        kdboFfSiVmTBdcat0s1P9OarYks6ww6yIA==
X-Google-Smtp-Source: ABdhPJy3vZ/ZoupRa23iNBTY4ko/LjGd2/B9EyWzkeNxphGiCdpnVe+h+h/252r68gsMdkIwfzjwtA==
X-Received: by 2002:a05:6e02:b29:b0:2cc:354:a156 with SMTP id e9-20020a056e020b2900b002cc0354a156mr5025245ilu.194.1650300246615;
        Mon, 18 Apr 2022 09:44:06 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y19-20020a056e020f5300b002cc33e5997dsm1188926ilj.63.2022.04.18.09.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 09:44:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: pass in struct io_cancel_data consistently
Date:   Mon, 18 Apr 2022 10:43:59 -0600
Message-Id: <20220418164402.75259-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220418164402.75259-1-axboe@kernel.dk>
References: <20220418164402.75259-1-axboe@kernel.dk>
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
pass in the io_cancel_data struct for the various functions that deal
with request cancelation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 76 +++++++++++++++++++++++++++++----------------------
 1 file changed, 44 insertions(+), 32 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c0f8c5b15f2f..eab464e0c323 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -971,6 +971,11 @@ struct io_defer_entry {
 	u32			seq;
 };
 
+struct io_cancel_data {
+	struct io_ring_ctx *ctx;
+	u64 data;
+};
+
 struct io_op_def {
 	/* needs req->file assigned */
 	unsigned		needs_file : 1;
@@ -6254,16 +6259,16 @@ static __cold bool io_poll_remove_all(struct io_ring_ctx *ctx,
 	return found;
 }
 
-static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr,
-				     bool poll_only)
+static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
+				     struct io_cancel_data *cd)
 	__must_hold(&ctx->completion_lock)
 {
 	struct hlist_head *list;
 	struct io_kiocb *req;
 
-	list = &ctx->cancel_hash[hash_long(sqe_addr, ctx->cancel_hash_bits)];
+	list = &ctx->cancel_hash[hash_long(cd->data, ctx->cancel_hash_bits)];
 	hlist_for_each_entry(req, list, hash_node) {
-		if (sqe_addr != req->cqe.user_data)
+		if (cd->data != req->cqe.user_data)
 			continue;
 		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
 			continue;
@@ -6282,10 +6287,10 @@ static bool io_poll_disarm(struct io_kiocb *req)
 	return true;
 }
 
-static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
+static int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 	__must_hold(&ctx->completion_lock)
 {
-	struct io_kiocb *req = io_poll_find(ctx, sqe_addr, false);
+	struct io_kiocb *req = io_poll_find(ctx, false, cd);
 
 	if (!req)
 		return -ENOENT;
@@ -6377,13 +6382,14 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct io_cancel_data cd = { .data = req->poll_update.old_user_data, };
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *preq;
 	int ret2, ret = 0;
 	bool locked;
 
 	spin_lock(&ctx->completion_lock);
-	preq = io_poll_find(ctx, req->poll_update.old_user_data, true);
+	preq = io_poll_find(ctx, true, &cd);
 	if (!preq || !io_poll_disarm(preq)) {
 		spin_unlock(&ctx->completion_lock);
 		ret = preq ? -EALREADY : -ENOENT;
@@ -6443,7 +6449,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 }
 
 static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
-					   __u64 user_data)
+					   struct io_cancel_data *cd)
 	__must_hold(&ctx->timeout_lock)
 {
 	struct io_timeout_data *io;
@@ -6451,7 +6457,7 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 	bool found = false;
 
 	list_for_each_entry(req, &ctx->timeout_list, timeout.list) {
-		found = user_data == req->cqe.user_data;
+		found = cd->data == req->cqe.user_data;
 		if (found)
 			break;
 	}
@@ -6465,11 +6471,11 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 	return req;
 }
 
-static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
+static int io_timeout_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 	__must_hold(&ctx->completion_lock)
 	__must_hold(&ctx->timeout_lock)
 {
-	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
+	struct io_kiocb *req = io_timeout_extract(ctx, cd);
 
 	if (IS_ERR(req))
 		return PTR_ERR(req);
@@ -6522,7 +6528,8 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 			     struct timespec64 *ts, enum hrtimer_mode mode)
 	__must_hold(&ctx->timeout_lock)
 {
-	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
+	struct io_cancel_data cd = { .data = user_data, };
+	struct io_kiocb *req = io_timeout_extract(ctx, &cd);
 	struct io_timeout_data *data;
 
 	if (IS_ERR(req))
@@ -6587,9 +6594,11 @@ static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 	int ret;
 
 	if (!(req->timeout_rem.flags & IORING_TIMEOUT_UPDATE)) {
+		struct io_cancel_data cd = { .data = tr->addr, };
+
 		spin_lock(&ctx->completion_lock);
 		spin_lock_irq(&ctx->timeout_lock);
-		ret = io_timeout_cancel(ctx, tr->addr);
+		ret = io_timeout_cancel(ctx, &cd);
 		spin_unlock_irq(&ctx->timeout_lock);
 		spin_unlock(&ctx->completion_lock);
 	} else {
@@ -6718,30 +6727,24 @@ static int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
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
 	struct io_cancel_data *cd = data;
 
-	return req->ctx == cd->ctx && req->cqe.user_data == cd->user_data;
+	return req->ctx == cd->ctx && req->cqe.user_data == cd->data;
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
@@ -6757,14 +6760,14 @@ static int io_async_cancel_one(struct io_uring_task *tctx, u64 user_data,
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
@@ -6773,12 +6776,12 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
 		return 0;
 
 	spin_lock(&ctx->completion_lock);
-	ret = io_poll_cancel(ctx, sqe_addr);
+	ret = io_poll_cancel(ctx, cd);
 	if (ret != -ENOENT)
 		goto out;
 
 	spin_lock_irq(&ctx->timeout_lock);
-	ret = io_timeout_cancel(ctx, sqe_addr);
+	ret = io_timeout_cancel(ctx, cd);
 	spin_unlock_irq(&ctx->timeout_lock);
 out:
 	spin_unlock(&ctx->completion_lock);
@@ -6803,11 +6806,14 @@ static int io_async_cancel_prep(struct io_kiocb *req,
 static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	u64 sqe_addr = req->cancel.addr;
+	struct io_cancel_data cd = {
+		.ctx		= ctx,
+		.data		= req->cancel.addr,
+	};
 	struct io_tctx_node *node;
 	int ret;
 
-	ret = io_try_cancel_userdata(req, sqe_addr);
+	ret = io_try_cancel(req, &cd);
 	if (ret != -ENOENT)
 		goto done;
 
@@ -6817,7 +6823,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
 
-		ret = io_async_cancel_one(tctx, req->cancel.addr, ctx);
+		ret = io_async_cancel_one(tctx, &cd);
 		if (ret != -ENOENT)
 			break;
 	}
@@ -7419,8 +7425,14 @@ static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 	int ret = -ENOENT;
 
 	if (prev) {
-		if (!(req->task->flags & PF_EXITING))
-			ret = io_try_cancel_userdata(req, prev->cqe.user_data);
+		if (!(req->task->flags & PF_EXITING)) {
+			struct io_cancel_data cd = {
+				.ctx		= req->ctx,
+				.data		= prev->cqe.user_data,
+			};
+
+			ret = io_try_cancel(req, &cd);
+		}
 		io_req_complete_post(req, ret ?: -ETIME, 0);
 		io_put_req(prev);
 	} else {
-- 
2.35.1

