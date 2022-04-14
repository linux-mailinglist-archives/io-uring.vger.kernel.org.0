Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE904501C9F
	for <lists+io-uring@lfdr.de>; Thu, 14 Apr 2022 22:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245244AbiDNU0x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Apr 2022 16:26:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346283AbiDNU0w (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Apr 2022 16:26:52 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEE80CC1
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 13:24:24 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id s14so5598939plk.8
        for <io-uring@vger.kernel.org>; Thu, 14 Apr 2022 13:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1Pd6N8Vii4K92wCz+FFwJ7T0hatEOtvpkLvmsrfcMBw=;
        b=6zpiuyiGuYWidrSVbhj8Jt2ao3R9HWS5k9GEMY8jvIiVKzc828Tft417Z6KniYyQtE
         JjanVNRUDmLZ+hKcYMeTRCqJvNeki9mYoItL6MsZDykeYKnEWuCyK3ONRW41OFVyILvH
         StzcR+39oxl7Od/0GgGhAW7cYe1hkHdpCYkrmMGuK/CvWxVgVpxLhQxqPGD5WLCvMhJX
         2T1d4gknQ7fO7VZP8+VuA3Kx/p1cCYv4zz55HD82CCAh/KxuCkBjQxzy+qIrUUpEY/37
         nGgdrG6fP0b19I68jvyJziaJK9NolzVJ/BpY+IJbXbrl10zoRkovZltQmJ9AX9V/XVvo
         QC1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1Pd6N8Vii4K92wCz+FFwJ7T0hatEOtvpkLvmsrfcMBw=;
        b=zCDbvXi9fb9YNJvfWb3WVxrW8YcJhPCrkOWbHWs9vCvyK8aOkCp4vZzXOcAW1nJqCV
         DOPhYICyYSKr7lKV7KWUwED8Ibs0LxFkvitRAIv9f4ljejdowqZ0Mmv0y0iIhAwkT51j
         z24mp6AN0ekG5MfW7RrGqY6KilTmgPA/6biBm/Xq02tGalP2M2v/MG6UyJvcgGsExGsY
         ZsTU6WfyfH5lJNrgFooNladAFCJXssISW3JkxROV7GKhKYGJEJ4ZQYBBx0ro+wm7Z428
         4DGjh5CWKzNaTd5LtmGZeJDYMM1KwEbuXUPn1eIIv6c0HJTbRXW8qzZX/AK9dKx/nmOs
         QjcQ==
X-Gm-Message-State: AOAM533qCCeFh5xtzcYTiAYgop0wFQIXP0lx+e0lxZs46nL4N/BrW6NE
        AlML0eEkV8FsDLYrVAHmQcY20+wtRkyNSw==
X-Google-Smtp-Source: ABdhPJyrBFI5wFTX8Q9jxnnaOFYFlCEbDJAnRnen7tW94l79bvPA41fHNKbb5RHSzeJaAKea/xD5zQ==
X-Received: by 2002:a17:90b:2385:b0:1cb:7b13:934b with SMTP id mr5-20020a17090b238500b001cb7b13934bmr322863pjb.121.1649967863891;
        Thu, 14 Apr 2022 13:24:23 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id v16-20020a62a510000000b0050759c9a891sm689365pfm.6.2022.04.14.13.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 13:24:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: pass in struct io_cancel_data consistently
Date:   Thu, 14 Apr 2022 14:24:17 -0600
Message-Id: <20220414202419.201614-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220414202419.201614-1-axboe@kernel.dk>
References: <20220414202419.201614-1-axboe@kernel.dk>
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
 fs/io_uring.c | 49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 878d30a31606..c3955b9709c6 100644
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
@@ -6791,14 +6790,15 @@ static int io_async_cancel_one(struct io_uring_task *tctx, u64 user_data,
 	return ret;
 }
 
-static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
+static int io_try_cancel_userdata(struct io_kiocb *req,
+				  struct io_cancel_data *cd)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	WARN_ON_ONCE(!io_wq_current_is_worker() && req->task != current);
 
-	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
+	ret = io_async_cancel_one(req->task->io_uring, cd);
 	/*
 	 * Fall-through even for -EALREADY, as we may have poll armed
 	 * that need unarming.
@@ -6807,12 +6807,12 @@ static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
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
@@ -6837,11 +6837,14 @@ static int io_async_cancel_prep(struct io_kiocb *req,
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
+	ret = io_try_cancel_userdata(req, &cd);
 	if (ret != -ENOENT)
 		goto done;
 
@@ -6851,7 +6854,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
 
-		ret = io_async_cancel_one(tctx, req->cancel.addr, ctx);
+		ret = io_async_cancel_one(tctx, &cd);
 		if (ret != -ENOENT)
 			break;
 	}
@@ -7455,8 +7458,14 @@ static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
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
+			ret = io_try_cancel_userdata(req, &cd);
+		}
 		io_req_complete_post(req, ret ?: -ETIME, 0);
 		io_put_req(prev);
 	} else {
-- 
2.35.1

