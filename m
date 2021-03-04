Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0F7832D4DA
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 15:06:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236481AbhCDOFK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 09:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239185AbhCDOEz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 09:04:55 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D483C0613D8
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 06:03:43 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id k66so9816046wmf.1
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 06:03:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=02vxqkamnG0coNOndk46ORLY1laOAIWxeiBKztsYYN4=;
        b=YV3T/54noi/kuKJO4rbCW+ds8Xd8wHhG6Wk0K4W3/o2yXh4Fcd8buzOk3Yu1SMiQP6
         +PXfZer1sL7TKPsy0AseFItOkmv/ttjA3DdoJ7yWzjlvqN4+riAbEFnCPDx6va/xrLVx
         WbinntKZo9YuMVJE/HzTSnFnmaP6HRpg2LJOSaYwllTwJb2GxhaG3/r4fVefoD/GwYbH
         V1asbS5tVTIB0FxYZlQFBEsi/RNrM27Oh1wSvK1xRRQ/o9DhdPFI6gI6gM1LWPVmUBGa
         qiWPp0Xr2bAHt0nXdzyzxPcac1Vs6rB96iCn2mqaol+uLDwMjs3JPTIwAyj11lw89I0x
         H+Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=02vxqkamnG0coNOndk46ORLY1laOAIWxeiBKztsYYN4=;
        b=pQ3BvhA0Bt8AcvXWmyamUr4ukguAuD+MpjIEND/mrpEuHPNIbXmO+spS3pe0wvMSsj
         2MRhUbCYBjDY9PHpohEPNd68lPRAb94SZZk+d2EkLoKs5+bJmYdz30OsnX4kUJK8LHa0
         zIBdDUrWJO0uTatcOtBc11BRklWyOAgNcuSGB46ds+9DTA70G39Ftsf3S9BNcy0wxXak
         hQ1avTPIDJmViEMgtr/Btrop0bxMBTFR9zYa+NTXTvrBddJDY5NQWoshMjBlsBhS/r8J
         I8w692oTcplDyggg/gmHSheRnmiupVgKMSh3N6QWEr6bVeFxP3INF6dI2srwPlQt0OyZ
         7Suw==
X-Gm-Message-State: AOAM531xrkP768dG0AceHusg3GsvfuyqeYXTKTs/oeG0FZRmkIAyjOTh
        Qq8ZDa5xsQe6BDHKh4Qzjg76UniAWX8=
X-Google-Smtp-Source: ABdhPJwkBTFiIhMN3w7hkP73XIYVnDbLLfN9orH8gMKjUEPiihMyEpAuZcgS/TIYR3YIxp/e4k5WuQ==
X-Received: by 2002:a1c:67d6:: with SMTP id b205mr4133041wmc.118.1614866621972;
        Thu, 04 Mar 2021 06:03:41 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id o124sm9975488wmo.41.2021.03.04.06.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 06:03:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 7/8] io_uring: index io_uring->xa by ctx not file
Date:   Thu,  4 Mar 2021 13:59:30 +0000
Message-Id: <9d8d4fc1ec54d62accb85c88ce729e2bd0476eaa.1614866085.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614866085.git.asml.silence@gmail.com>
References: <cover.1614866085.git.asml.silence@gmail.com>
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
index da93ae7b3aef..46a2417187ff 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -809,7 +809,6 @@ struct io_kiocb {
 struct io_tctx_node {
 	struct list_head	ctx_node;
 	struct task_struct	*task;
-	struct file		*file;
 	struct io_ring_ctx	*ctx;
 };
 
@@ -8525,7 +8524,7 @@ static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
 struct io_tctx_exit {
 	struct callback_head		task_work;
 	struct completion		completion;
-	unsigned long			index;
+	struct io_ring_ctx		*ctx;
 };
 
 static void io_tctx_exit_cb(struct callback_head *cb)
@@ -8539,7 +8538,7 @@ static void io_tctx_exit_cb(struct callback_head *cb)
 	 * node. It'll be removed by the end of cancellation, just ignore it.
 	 */
 	if (!atomic_read(&tctx->in_idle))
-		io_uring_del_task_file(work->index);
+		io_uring_del_task_file((unsigned long)work->ctx);
 	complete(&work->completion);
 }
 
@@ -8564,7 +8563,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	while (!list_empty(&ctx->tctx_list)) {
 		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
 					ctx_node);
-		exit.index = (unsigned long)node->file;
+		exit.ctx = ctx;
 		init_completion(&exit.completion);
 		init_task_work(&exit.task_work, io_tctx_exit_cb);
 		ret = task_work_add(node->task, &exit.task_work, TWA_SIGNAL);
@@ -8785,7 +8784,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 /*
  * Note that this task has used io_uring. We use it for cancelation purposes.
  */
-static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
+static int io_uring_add_task_file(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
@@ -8797,18 +8796,17 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
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
@@ -8819,7 +8817,7 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 			list_add(&node->ctx_node, &ctx->tctx_list);
 			mutex_unlock(&ctx->uring_lock);
 		}
-		tctx->last = file;
+		tctx->last = ctx;
 	}
 
 	/*
@@ -8854,7 +8852,7 @@ static void io_uring_del_task_file(unsigned long index)
 	list_del(&node->ctx_node);
 	mutex_unlock(&node->ctx->uring_lock);
 
-	if (tctx->last == node->file)
+	if (tctx->last == node->ctx)
 		tctx->last = NULL;
 	kfree(node);
 }
@@ -9176,7 +9174,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		}
 		submitted = to_submit;
 	} else if (to_submit) {
-		ret = io_uring_add_task_file(ctx, f.file);
+		ret = io_uring_add_task_file(ctx);
 		if (unlikely(ret))
 			goto out;
 		mutex_lock(&ctx->uring_lock);
@@ -9385,7 +9383,7 @@ static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
 	if (fd < 0)
 		return fd;
 
-	ret = io_uring_add_task_file(ctx, file);
+	ret = io_uring_add_task_file(ctx);
 	if (ret) {
 		put_unused_fd(fd);
 		return ret;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 796e0d7d186d..0e7dfd9e82c0 100644
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

