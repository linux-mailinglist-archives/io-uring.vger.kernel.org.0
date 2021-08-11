Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D912F3E98EB
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 21:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230413AbhHKTlV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 15:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbhHKTlV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 15:41:21 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E21C061765
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:40:57 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id a20so4124397plm.0
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 12:40:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FtlhnhhFqEqRgzWXlG8Kms5M4qcfh4EKRdFIuC+yWaE=;
        b=bvqplIIctJZb4uuJ9Ywrf9Us9AwRWW/AC0Xj22Mf0gIsK4p70B9drrsLJpfjFNUner
         7gsoGheUkJWJWlqQWYkmpIe0CsbHsjd2o1s0IWhwnnkdqXOHGdXCA6R51ix3PBUvnIA4
         17TOlz7X+p0umDLfJrtDJuZFbZJ227oj6xXDjv0ZQ79hUMo6T8vgEqBkivil3+DYEqac
         cQKoILOFrk+zaJE/OWQI41919Zox53tB6zel+Y92J37gAuzgCy3i96pRayx4BZUYPq7M
         kft90ZOqoJopuDe5rufT+/p3p8iyV9xzAvbf8K3xdh3ed5SBEfj0DS4db3PEyqp/JT4H
         ZWkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FtlhnhhFqEqRgzWXlG8Kms5M4qcfh4EKRdFIuC+yWaE=;
        b=Hlw5vHLd2tlOdsOkWnD4xbxMZij29yS3KpdXvfAjL6fd0PFtMmNMy+/uPE6jdI1+nd
         SHh3bTXFdroiY/bhoapLNwFEx54CgMlz897j32lVCL0mUJf7nwqhPRVs1IB5mxnBf9H4
         N8gFOPUXV3W6eS8Yxcsvcwrro1r+NEgpLnQYtsrSdwgm9dVcHUT6wIeOMjo5k+W9pH36
         Oci+YZpxP/skgJMxyO1nXQO2r6kw8cf+3CAEN4hZI/UF3ke+r7VwpY9Q403aWF4Pj1ez
         rxW3C6jhDxa114uCfz9gjWX8zVwJkE6y7GEEGT7gONtr4R1rF5ycmeEclaRMX6mC+Ups
         Xefw==
X-Gm-Message-State: AOAM530T2gQe1wBb/MR3Cez6N81YxKjkTjF/G8jt1XFoK7QFDl7VNSGW
        trP1ghKw4V/+i4/QHWmznP57KgOwONc0o50v
X-Google-Smtp-Source: ABdhPJxHGOW5g8lPlsNoY1GSc6/9+hooysD/UU45lM3kpehGln8kNI/B0R+BEWNkGoivkLAXCZvvWA==
X-Received: by 2002:a17:90a:9511:: with SMTP id t17mr12314685pjo.194.1628710856794;
        Wed, 11 Aug 2021 12:40:56 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id y2sm336118pfe.146.2021.08.11.12.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 12:40:56 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: run timeouts from task_work
Date:   Wed, 11 Aug 2021 13:40:50 -0600
Message-Id: <20210811194053.767588-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210811194053.767588-1-axboe@kernel.dk>
References: <20210811194053.767588-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is in preparation to making the completion lock work outside of
hard/soft IRQ context.

Add a timeout_lock to handle the ordering of timeout completions or
cancelations with the timeouts actually triggering.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 43 +++++++++++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bd3f8529fe6f..06cd7d229501 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -409,6 +409,8 @@ struct io_ring_ctx {
 	struct {
 		spinlock_t		completion_lock;
 
+		spinlock_t		timeout_lock;
+
 		/*
 		 * ->iopoll_list is protected by the ctx->uring_lock for
 		 * io_uring instances that don't use IORING_SETUP_SQPOLL.
@@ -1186,6 +1188,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->cq_wait);
 	spin_lock_init(&ctx->completion_lock);
+	spin_lock_init(&ctx->timeout_lock);
 	INIT_LIST_HEAD(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
@@ -5452,6 +5455,20 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static void io_req_task_timeout(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	spin_lock_irq(&ctx->completion_lock);
+	io_cqring_fill_event(ctx, req->user_data, -ETIME, 0);
+	io_commit_cqring(ctx);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+	req_set_fail(req);
+	io_put_req(req);
+}
+
 static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 {
 	struct io_timeout_data *data = container_of(timer,
@@ -5460,24 +5477,20 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
-	spin_lock_irqsave(&ctx->completion_lock, flags);
+	spin_lock_irqsave(&ctx->timeout_lock, flags);
 	list_del_init(&req->timeout.list);
 	atomic_set(&req->ctx->cq_timeouts,
 		atomic_read(&req->ctx->cq_timeouts) + 1);
+	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
 
-	io_cqring_fill_event(ctx, req->user_data, -ETIME, 0);
-	io_commit_cqring(ctx);
-	spin_unlock_irqrestore(&ctx->completion_lock, flags);
-
-	io_cqring_ev_posted(ctx);
-	req_set_fail(req);
-	io_put_req(req);
+	req->io_task_work.func = io_req_task_timeout;
+	io_req_task_work_add(req);
 	return HRTIMER_NORESTART;
 }
 
 static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 					   __u64 user_data)
-	__must_hold(&ctx->completion_lock)
+	__must_hold(&ctx->timeout_lock)
 {
 	struct io_timeout_data *io;
 	struct io_kiocb *req;
@@ -5499,7 +5512,7 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 }
 
 static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
-	__must_hold(&ctx->completion_lock)
+	__must_hold(&ctx->timeout_lock)
 {
 	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
 
@@ -5514,7 +5527,7 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 
 static int io_timeout_update(struct io_ring_ctx *ctx, __u64 user_data,
 			     struct timespec64 *ts, enum hrtimer_mode mode)
-	__must_hold(&ctx->completion_lock)
+	__must_hold(&ctx->timeout_lock)
 {
 	struct io_kiocb *req = io_timeout_extract(ctx, user_data);
 	struct io_timeout_data *data;
@@ -5573,13 +5586,15 @@ static int io_timeout_remove(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	spin_lock_irq(&ctx->completion_lock);
+	spin_lock_irq(&ctx->timeout_lock);
 	if (!(req->timeout_rem.flags & IORING_TIMEOUT_UPDATE))
 		ret = io_timeout_cancel(ctx, tr->addr);
 	else
 		ret = io_timeout_update(ctx, tr->addr, &tr->ts,
 					io_translate_timeout_mode(tr->flags));
+	spin_unlock_irq(&ctx->timeout_lock);
 
+	spin_lock_irq(&ctx->completion_lock);
 	io_cqring_fill_event(ctx, req->user_data, ret, 0);
 	io_commit_cqring(ctx);
 	spin_unlock_irq(&ctx->completion_lock);
@@ -5727,7 +5742,9 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	spin_lock_irqsave(&ctx->completion_lock, flags);
 	if (ret != -ENOENT)
 		goto done;
+	spin_lock(&ctx->timeout_lock);
 	ret = io_timeout_cancel(ctx, sqe_addr);
+	spin_unlock(&ctx->timeout_lock);
 	if (ret != -ENOENT)
 		goto done;
 	ret = io_poll_cancel(ctx, sqe_addr, false);
@@ -5769,7 +5786,9 @@ static int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 	spin_lock_irq(&ctx->completion_lock);
 	if (ret != -ENOENT)
 		goto done;
+	spin_lock(&ctx->timeout_lock);
 	ret = io_timeout_cancel(ctx, sqe_addr);
+	spin_unlock(&ctx->timeout_lock);
 	if (ret != -ENOENT)
 		goto done;
 	ret = io_poll_cancel(ctx, sqe_addr, false);
-- 
2.32.0

