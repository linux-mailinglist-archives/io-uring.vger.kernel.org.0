Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C83032E0A0
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 05:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbhCEEWa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 23:22:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229798AbhCEEWa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 23:22:30 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5B2C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 20:22:29 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id e23so240432wmh.3
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 20:22:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=a1GEpy9kgUCjNwbzDzpfFm4GGJZ4eXdACf42WCHO/7o=;
        b=oRn6dTBXq/HfUwMFfuFPp7wqEh7EJBVo7r0Z+nZiyuYhsCMWO9KJFWMA/cvModzjMa
         W5i9k0r+lkk/b//jfINhQ4/YssTNowGF7/3JfBIwpglSzMwxc1y/LaXorFTP9kDw/0fn
         OVsFViVVHncEtdrqws2sGj7X0o+Jb03PPajOkZzY/J/b9hJKQefi+qyG/RTNmMR7+a3O
         DF88NDHe480UOH3LFbOI75Uyek557DBwfQ54aRD5RP2ASnaW+Xcj5pmUUuTxQIemLiFa
         74sfDwCnJKZ+c8+IjVtVc3Dpmng0aq4reDqRbdo9CdRw/Cnwf3TRAzwo1grRwXzZJ8zC
         ocPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a1GEpy9kgUCjNwbzDzpfFm4GGJZ4eXdACf42WCHO/7o=;
        b=elfCycz/O8KJc9ZLya7QlxwQf2CPSJ42r8fPtyTt9GMcvEgOM1QtfnoR2YAUEbMA6w
         gMzqxJSAJ2hFuuAl4MxvzrxW3NBLle5pS5MaDfC++pnXcluCqJ1GwfhcwQJf538a1fi6
         6ycTZT4Oa2JGGOheONnq6WQyJ/DpCd+xmS5gDCk1Mk/ShUpZ0+rqWzCWsQtLp/1bMbg9
         OmQznxvuvtApRd1yLBqNIkevZE1VSEJodyRIK9Ttc5jE6tXNj01FFbZOaqi2oA0Xb37O
         uykT9UDlh5dNsmPRp8ilXTIRPPLEot5Zv/aZsNm2wmHWvExjBuJZ1tgSej50/d7HqmXv
         O9fQ==
X-Gm-Message-State: AOAM530Dg5KnfTeXeotE9YhYfPDomUuQdF6e8tYnqe6yydwmQ4oPu4UD
        5vCPiM8J/+3rlMv/9b+/itc=
X-Google-Smtp-Source: ABdhPJzIC590OK/eGrnIoas6hrHwAqS8aVdUrpgYXauzNzpQ4LT2MMYPFfbj+fPpAqZbeI7/E8iWcA==
X-Received: by 2002:a1c:e041:: with SMTP id x62mr6617311wmg.95.1614918148494;
        Thu, 04 Mar 2021 20:22:28 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id z3sm2170446wrs.55.2021.03.04.20.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:22:28 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 5/6] io_uring: index io_uring->xa by ctx not file
Date:   Fri,  5 Mar 2021 04:18:23 +0000
Message-Id: <bc85580c4dbb8cfb14ab492d034e38248cd8b49f.1614917790.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614917790.git.asml.silence@gmail.com>
References: <cover.1614917790.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't use task file notes anymore, and no need left in indexing
task->io_uring->xa by file, and replace it with ctx. It's better
design-wise, especially since we keep a dangling file, and so have to
keep an eye on not dereferencing it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c            | 24 +++++++++++-------------
 include/linux/io_uring.h |  2 +-
 2 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d819d389f4ee..92ba3034de64 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -809,7 +809,6 @@ struct io_kiocb {
 struct io_tctx_node {
 	struct list_head	ctx_node;
 	struct task_struct	*task;
-	struct file		*file;
 	struct io_ring_ctx	*ctx;
 };
 
@@ -8532,7 +8531,7 @@ static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
 struct io_tctx_exit {
 	struct callback_head		task_work;
 	struct completion		completion;
-	unsigned long			index;
+	struct io_ring_ctx		*ctx;
 };
 
 static void io_tctx_exit_cb(struct callback_head *cb)
@@ -8546,7 +8545,7 @@ static void io_tctx_exit_cb(struct callback_head *cb)
 	 * node. It'll be removed by the end of cancellation, just ignore it.
 	 */
 	if (!atomic_read(&tctx->in_idle))
-		io_uring_del_task_file(work->index);
+		io_uring_del_task_file((unsigned long)work->ctx);
 	complete(&work->completion);
 }
 
@@ -8571,7 +8570,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	while (!list_empty(&ctx->tctx_list)) {
 		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
 					ctx_node);
-		exit.index = (unsigned long)node->file;
+		exit.ctx = ctx;
 		init_completion(&exit.completion);
 		init_task_work(&exit.task_work, io_tctx_exit_cb);
 		ret = task_work_add(node->task, &exit.task_work, TWA_SIGNAL);
@@ -8792,7 +8791,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 /*
  * Note that this task has used io_uring. We use it for cancelation purposes.
  */
-static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
+static int io_uring_add_task_file(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
@@ -8804,18 +8803,17 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
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
@@ -8826,7 +8824,7 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 			list_add(&node->ctx_node, &ctx->tctx_list);
 			mutex_unlock(&ctx->uring_lock);
 		}
-		tctx->last = file;
+		tctx->last = ctx;
 	}
 
 	/*
@@ -8861,7 +8859,7 @@ static void io_uring_del_task_file(unsigned long index)
 	list_del(&node->ctx_node);
 	mutex_unlock(&node->ctx->uring_lock);
 
-	if (tctx->last == node->file)
+	if (tctx->last == node->ctx)
 		tctx->last = NULL;
 	kfree(node);
 }
@@ -9163,7 +9161,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		}
 		submitted = to_submit;
 	} else if (to_submit) {
-		ret = io_uring_add_task_file(ctx, f.file);
+		ret = io_uring_add_task_file(ctx);
 		if (unlikely(ret))
 			goto out;
 		mutex_lock(&ctx->uring_lock);
@@ -9372,7 +9370,7 @@ static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
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
2.24.0

