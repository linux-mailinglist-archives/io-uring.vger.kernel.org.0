Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D5F3EC3D4
	for <lists+io-uring@lfdr.de>; Sat, 14 Aug 2021 18:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235606AbhHNQ1W (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 Aug 2021 12:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235567AbhHNQ1V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 Aug 2021 12:27:21 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7395FC0613CF
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 09:26:52 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id z9so17424048wrh.10
        for <io-uring@vger.kernel.org>; Sat, 14 Aug 2021 09:26:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5XqMzvzdaoc8eM9dxG0DjOxH1iOdy7kyEQqhjDfuoWw=;
        b=STMurmla9MAuZJR8q84a5xXUItoZ3rqAcHKwiO2Rbu4gfhW9G6LCwqgZB0DpbdVf3r
         M+yvGLBXkdPVVYJidpdELBRgAxrD+6sjoNpt/kpMh5f3mBT1foEeJHcWNRvLzvuaZA64
         eXCANEzIXa106o19+14v+9nfqzPkMwZQM2Jp9BOMFoBVupP6zw1V8EUpyhZeb6QEobgO
         m7/ZHRY2wN2X4tBeF7Dio827hnaTm4kdatm4xLXfArMGSp3L08X1CWxP/Fpta3d0gW50
         E+lCe+Snpv7qDVDNp7DQXNEUb+89E7fWoSB0L3izFZFQ4mfTtXN1QaR+UAC/JSZ6ar0h
         nu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5XqMzvzdaoc8eM9dxG0DjOxH1iOdy7kyEQqhjDfuoWw=;
        b=jqy9m8XwaNvDXjUhy9rya7NPzM2FxNThlqvZvu3Dt4Mo8NYSZcPLndL7VMCVOmK6Ld
         Xrsm/GCgBQ/U6KPMyIQ5KqjOP9bzzXlOylJTFvFPb9VIECeKEJhoifHLQ6IiEAI0PvsM
         JUhV8TLJEVUMVf1nbryx7/6F96yzbCcDYK4qkSfFQHPJ8/PpRh+euh3cF13LTI2ssBfI
         VeZDS0QGJ1qZk0DAru9yBF/gp9xkktdOGAaM82ykF1FZtd/pFD5fBzTsnKU6qMf/AP6z
         xhuUUF731gYSjc5DIZ+N95hili5tOwgEpVLn90scw/rnbDiIUlSBchiObFLBztX4Nc8j
         vgRQ==
X-Gm-Message-State: AOAM533eeurpqzMDZZqQkODReOehX12rxyc/gCcuKtVHCc4iSfcZqQ+I
        MH42g3XvEiTmWZ2WH7kLCdA=
X-Google-Smtp-Source: ABdhPJxpJzbU0MUAg0YvX6BroZ52U9uhlykr9deqIVEflAUIcSLd3+GP6JiQqkWmRyY1GaehgH0nqg==
X-Received: by 2002:a05:6000:1086:: with SMTP id y6mr9135922wrw.406.1628958411143;
        Sat, 14 Aug 2021 09:26:51 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id m62sm5028263wmm.8.2021.08.14.09.26.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 09:26:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/5] io_uring: deduplicate cancellations
Date:   Sat, 14 Aug 2021 17:26:10 +0100
Message-Id: <bcb51c4a43b17044f10166355f38896e2f3fa982.1628957788.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628957788.git.asml.silence@gmail.com>
References: <cover.1628957788.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_ASYNC_CANCEL and IORING_OP_LINK_TIMEOUT have enough of
overlap, so extract a helper for request cancellation and use in both.
Also, removes some amount of ugliness because of success_ret.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 46 ++++++++++++++++++----------------------------
 1 file changed, 18 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c16d172ca37f..5560620968c9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5790,32 +5790,24 @@ static int io_async_cancel_one(struct io_uring_task *tctx, u64 user_data,
 	return ret;
 }
 
-static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
-				     struct io_kiocb *req, __u64 sqe_addr,
-				     int success_ret)
+static int io_try_cancel_userdata(struct io_kiocb *req, u64 sqe_addr)
+	__acquires(&req->ctx->completion_lock)
 {
+	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
+	WARN_ON_ONCE(req->task != current);
+
 	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
 	spin_lock(&ctx->completion_lock);
 	if (ret != -ENOENT)
-		goto done;
+		return ret;
 	spin_lock_irq(&ctx->timeout_lock);
 	ret = io_timeout_cancel(ctx, sqe_addr);
 	spin_unlock_irq(&ctx->timeout_lock);
 	if (ret != -ENOENT)
-		goto done;
-	ret = io_poll_cancel(ctx, sqe_addr, false);
-done:
-	if (!ret)
-		ret = success_ret;
-	io_cqring_fill_event(ctx, req->user_data, ret, 0);
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
-
-	if (ret < 0)
-		req_set_fail(req);
+		return ret;
+	return io_poll_cancel(ctx, sqe_addr, false);
 }
 
 static int io_async_cancel_prep(struct io_kiocb *req,
@@ -5839,17 +5831,7 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_tctx_node *node;
 	int ret;
 
-	/* tasks should wait for their io-wq threads, so safe w/o sync */
-	ret = io_async_cancel_one(req->task->io_uring, sqe_addr, ctx);
-	spin_lock(&ctx->completion_lock);
-	if (ret != -ENOENT)
-		goto done;
-	spin_lock_irq(&ctx->timeout_lock);
-	ret = io_timeout_cancel(ctx, sqe_addr);
-	spin_unlock_irq(&ctx->timeout_lock);
-	if (ret != -ENOENT)
-		goto done;
-	ret = io_poll_cancel(ctx, sqe_addr, false);
+	ret = io_try_cancel_userdata(req, sqe_addr);
 	if (ret != -ENOENT)
 		goto done;
 	spin_unlock(&ctx->completion_lock);
@@ -6416,9 +6398,17 @@ static void io_req_task_link_timeout(struct io_kiocb *req)
 {
 	struct io_kiocb *prev = req->timeout.prev;
 	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
 
 	if (prev) {
-		io_async_find_and_cancel(ctx, req, prev->user_data, -ETIME);
+		ret = io_try_cancel_userdata(req, prev->user_data);
+		if (!ret)
+			ret = -ETIME;
+		io_cqring_fill_event(ctx, req->user_data, ret, 0);
+		io_commit_cqring(ctx);
+		spin_unlock(&ctx->completion_lock);
+		io_cqring_ev_posted(ctx);
+
 		io_put_req(prev);
 		io_put_req(req);
 	} else {
-- 
2.32.0

