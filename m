Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512C950335C
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 07:48:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiDPA2l (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 20:28:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiDPA2k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 20:28:40 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 328E4EBB84
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 17:26:07 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id u2so9059052pgq.10
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 17:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Yaj0xFOTSZBpKJGtHJ36pBqmihTYeVxXb03DtNqs/zw=;
        b=bLqZlX4hWh7PM7NBetDtViIfHXUV5Cz+C7Yw37GzopRqA7iU17bSSASFWFhw4KHgzF
         5EziSUd5appKMSYqq77awWBtDrQS7NYRvyYFEiwLtR8ostIf/zF3PZmO4jKvIY01JMKd
         cYvy+99F3bYjB50EEXhoO9JtxHDrmxQh2sodhE3jomVjCjIjvuYBgc2DT9zKM2zGPOgA
         eiCI7I1OD/yCghNQsW4InAmd7EB08+kN6XgO3UYKRTARkpBje00F04ljlZN4PDX4Caqo
         rr1MAqmsfEYf0gcdNmoa4FTWKi7IFxs19UHOy/1e90/CzPtJ40X+Em4Hq/3XGThhhRX8
         Ha6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Yaj0xFOTSZBpKJGtHJ36pBqmihTYeVxXb03DtNqs/zw=;
        b=wB7Tk8rCZ2QhpjQaSemhdVrCcJyrO5DY+MGyc4ZN5v58dBbsVZWCi9wrkR2R/dEehX
         mPl1tmojX3SSct3BoTOiwBbVN2MOgWm8Y0f3Qv/dj/jKL0QKpzeSoO6K2eC5O6Cbg5RZ
         1O9iK1SlcLDu2Jw12ln2jelT6AvDqP9zGOFU65S1bhEdvmblU7aoM/jK4D+7Rv27PvbH
         klB40jhurZhqqp0G47MWDpdnvMS7apwOKLPoSEVP39IiSFmAVm/nDoe5o0Uu5+Qqfr8J
         Qtv7AVKWrq2v3Xbc2eGip/nESHLXfnaYOS2HqlwLaTS5tengCfFLKHjc4/jzkEOqxDyF
         DV2g==
X-Gm-Message-State: AOAM530XUONGgyxIeNsqcs0U5KIwLsG6Is/kk6ZHwxIbyp65JcBBaQZ4
        b1+JwhX1PsDJYnk5h3hWATiZx4d2SlLjHQ==
X-Google-Smtp-Source: ABdhPJxb00cvf2YikzelwKkZpVOPxVDAJV3rkyEO0n+CE5KUNadPJ5v4fZeSV2CW9xq3Iro3RZsccQ==
X-Received: by 2002:a05:6a00:4211:b0:506:5061:3e38 with SMTP id cd17-20020a056a00421100b0050650613e38mr1340912pfb.74.1650068765954;
        Fri, 15 Apr 2022 17:26:05 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id s20-20020aa78d54000000b004fac74c83b3sm3895375pfe.186.2022.04.15.17.26.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 17:26:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: pass in struct io_cancel_data consistently
Date:   Fri, 15 Apr 2022 18:25:59 -0600
Message-Id: <20220416002601.360026-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220416002601.360026-1-axboe@kernel.dk>
References: <20220416002601.360026-1-axboe@kernel.dk>
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
index 878d30a31606..16f8e1f7dcae 100644
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
@@ -6288,16 +6293,16 @@ static __cold bool io_poll_remove_all(struct io_ring_ctx *ctx,
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
@@ -6316,10 +6321,10 @@ static bool io_poll_disarm(struct io_kiocb *req)
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
@@ -6411,13 +6416,14 @@ static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
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
@@ -6477,7 +6483,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 }
 
 static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
-					   __u64 user_data)
+					   struct io_cancel_data *cd)
 	__must_hold(&ctx->timeout_lock)
 {
 	struct io_timeout_data *io;
@@ -6485,7 +6491,7 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 	bool found = false;
 
 	list_for_each_entry(req, &ctx->timeout_list, timeout.list) {
-		found = user_data == req->cqe.user_data;
+		found = cd->data == req->cqe.user_data;
 		if (found)
 			break;
 	}
@@ -6499,11 +6505,11 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
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
@@ -6556,7 +6562,8 @@ static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 			     struct timespec64 *ts, enum hrtimer_mode mode)
 	__must_hold(&ctx->timeout_lock)
 {
-	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
+	struct io_cancel_data cd = { .data = user_data, };
+	struct io_kiocb *req = io_timeout_extract(ctx, &cd);
 	struct io_timeout_data *data;
 
 	if (IS_ERR(req))
@@ -6621,9 +6628,11 @@ static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -6752,30 +6761,24 @@ static int io_timeout(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -6791,14 +6794,14 @@ static int io_async_cancel_one(struct io_uring_task *tctx, u64 user_data,
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
@@ -6807,12 +6810,12 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
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
@@ -6837,11 +6840,14 @@ static int io_async_cancel_prep(struct io_kiocb *req,
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
 
@@ -6851,7 +6857,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
 
-		ret = io_async_cancel_one(tctx, req->cancel.addr, ctx);
+		ret = io_async_cancel_one(tctx, &cd);
 		if (ret != -ENOENT)
 			break;
 	}
@@ -7455,8 +7461,14 @@ static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
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

