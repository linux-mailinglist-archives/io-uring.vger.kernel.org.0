Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D3F334BCD
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233077AbhCJWol (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbhCJWoO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:14 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A359C061761
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:14 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id gb6so2453094pjb.0
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1lMSaY7gjFEa1tO9QLyx6rVbqOTMeRQE0SKacIK774M=;
        b=j0BzRqDH/fvHjXGMV5WKuOxGyVIRbiHDAoxf+qKukMtKEmfkK6Bpeh1++9mzFtz4dI
         NlYaovX8MY+rV6qlLdDAuE5K7tgH8SaTgg02c/r0gGlYJsyjK1F60xYoUbPyUd4Ie5oC
         tofaayCdYlAqeDKkFkWh3kwolyHJoz3ojKwpVeMHpNCuHqQPjw6GR5tWR6Bggl09TbVP
         nywmb+w/Hhlp4SgR94FVvM7L8PcqIA0g5/BlTw//MJDdEIgNETnCJuGjhkcFtbOWlaLI
         namBtD8W58wrvZYzzKzL0h73HycJc7VZcMH+Aw1VAVSlLD9d1hvFilTI8prTjXNZKDop
         fr+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1lMSaY7gjFEa1tO9QLyx6rVbqOTMeRQE0SKacIK774M=;
        b=LQaG9+4TA9hoeKfrFn9EecB1nqkIMU+NkF8kMLbtVBSUBTHNYcii/117sDqu/FoJwO
         aJfmMPJzNNi6/bmcd156Vv9nDywbRpM4CBBgdJSrd3R/+UFloxUeRw83wWgzG7a8DStM
         UXf7KVCHcpIOzjKThjiGGFZ1AJAJVcMFPAhOgu3BrxbzIU6jrgZEmldecD5LO5HFIJBr
         ICP9/BcdjqrIZsZvMu8nguGwGDM2AE7rIBPlNgWLYpQiN7VvLZHF7T6I//wgFWY+nTCj
         q3aoXjfiLiIvlmgjytQ5VYYBBGZY55JT0RbQPVzQjlOZQ4iYg5uxLRMwySNIDo6rA0hw
         YUPQ==
X-Gm-Message-State: AOAM531z2feyIhuYAg1jivGeoiC84USL17tupM+inK4kAOwtUPy72RzG
        6qf9C3KwiazSCeGHJfacqFOKzSOZuRTuHQ==
X-Google-Smtp-Source: ABdhPJwvOIYGd+Sc7dPnU2VwLw2n8AZmcJ17+EwqyoTeva1gqCYwBenSA1FcrI6icOiCdbbDOVnSqQ==
X-Received: by 2002:a17:902:b781:b029:e4:545d:77 with SMTP id e1-20020a170902b781b02900e4545d0077mr5121367pls.59.1615416251959;
        Wed, 10 Mar 2021 14:44:11 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:11 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 07/27] io_uring: index io_uring->xa by ctx not file
Date:   Wed, 10 Mar 2021 15:43:38 -0700
Message-Id: <20210310224358.1494503-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

We don't use task file notes anymore, and no need left in indexing
task->io_uring->xa by file, and replace it with ctx. It's better
design-wise, especially since we keep a dangling file, and so have to
keep an eye on not dereferencing it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c            | 24 +++++++++++-------------
 include/linux/io_uring.h |  2 +-
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f448213267c8..01a7fa4a4889 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -809,7 +809,6 @@ struct io_kiocb {
 struct io_tctx_node {
 	struct list_head	ctx_node;
 	struct task_struct	*task;
-	struct file		*file;
 	struct io_ring_ctx	*ctx;
 };
 
@@ -8540,7 +8539,7 @@ static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
 struct io_tctx_exit {
 	struct callback_head		task_work;
 	struct completion		completion;
-	unsigned long			index;
+	struct io_ring_ctx		*ctx;
 };
 
 static void io_tctx_exit_cb(struct callback_head *cb)
@@ -8554,7 +8553,7 @@ static void io_tctx_exit_cb(struct callback_head *cb)
 	 * node. It'll be removed by the end of cancellation, just ignore it.
 	 */
 	if (!atomic_read(&tctx->in_idle))
-		io_uring_del_task_file(work->index);
+		io_uring_del_task_file((unsigned long)work->ctx);
 	complete(&work->completion);
 }
 
@@ -8579,7 +8578,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	while (!list_empty(&ctx->tctx_list)) {
 		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
 					ctx_node);
-		exit.index = (unsigned long)node->file;
+		exit.ctx = ctx;
 		init_completion(&exit.completion);
 		init_task_work(&exit.task_work, io_tctx_exit_cb);
 		ret = task_work_add(node->task, &exit.task_work, TWA_SIGNAL);
@@ -8798,7 +8797,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 /*
  * Note that this task has used io_uring. We use it for cancelation purposes.
  */
-static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
+static int io_uring_add_task_file(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
@@ -8810,18 +8809,17 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 			return ret;
 		tctx = current->io_uring;
 	}
-	if (tctx->last != file) {
-		void *old = xa_load(&tctx->xa, (unsigned long)file);
+	if (tctx->last != ctx) {
+		void *old = xa_load(&tctx->xa, (unsigned long)ctx);
 
 		if (!old) {
 			node = kmalloc(sizeof(*node), GFP_KERNEL);
 			if (!node)
 				return -ENOMEM;
 			node->ctx = ctx;
-			node->file = file;
 			node->task = current;
 
-			ret = xa_err(xa_store(&tctx->xa, (unsigned long)file,
+			ret = xa_err(xa_store(&tctx->xa, (unsigned long)ctx,
 						node, GFP_KERNEL));
 			if (ret) {
 				kfree(node);
@@ -8832,7 +8830,7 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 			list_add(&node->ctx_node, &ctx->tctx_list);
 			mutex_unlock(&ctx->uring_lock);
 		}
-		tctx->last = file;
+		tctx->last = ctx;
 	}
 
 	/*
@@ -8867,7 +8865,7 @@ static void io_uring_del_task_file(unsigned long index)
 	list_del(&node->ctx_node);
 	mutex_unlock(&node->ctx->uring_lock);
 
-	if (tctx->last == node->file)
+	if (tctx->last == node->ctx)
 		tctx->last = NULL;
 	kfree(node);
 }
@@ -9166,7 +9164,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		}
 		submitted = to_submit;
 	} else if (to_submit) {
-		ret = io_uring_add_task_file(ctx, f.file);
+		ret = io_uring_add_task_file(ctx);
 		if (unlikely(ret))
 			goto out;
 		mutex_lock(&ctx->uring_lock);
@@ -9375,7 +9373,7 @@ static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
 	if (fd < 0)
 		return fd;
 
-	ret = io_uring_add_task_file(ctx, file);
+	ret = io_uring_add_task_file(ctx);
 	if (ret) {
 		put_unused_fd(fd);
 		return ret;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 7cb7bd0e334c..9761a0ec9f95 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -18,7 +18,7 @@ struct io_uring_task {
 	/* submission side */
 	struct xarray		xa;
 	struct wait_queue_head	wait;
-	struct file		*last;
+	void			*last;
 	void			*io_wq;
 	struct percpu_counter	inflight;
 	atomic_t		in_idle;
-- 
2.30.2

