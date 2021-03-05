Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B42BC32E09D
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 05:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhCEEW1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 23:22:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCEEW1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 23:22:27 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ADD7C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 20:22:27 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id d15so616360wrv.5
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 20:22:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kJSbcL/Puw52TJ/P92VQTnEWoevENv+tEsQOyo1zg0A=;
        b=NK7AXgD0NS9LGJpRubS94NnjlPWpqPv0wDFOp/wMj15hBFXWrxGLBouTwmu4nZI1xb
         p9xpWS/NPYj3ZtY3Hik626grNFfme1IS7CXEcNE6ToKijrbC0YiMRlGGAjwfsaM6uk3+
         gq0Ydx+1gLujJf4d1JyUaqyQw+rikYn7HMu1PJfYkmYW3gbZba53LiXWSxaYq2/1ZAc6
         CFIXZ+rFd3NXiHx+uDKez/mgLbRddNKFN6+gQCZ8ksLWae9C31HimwEILzWvKa5s5Xqi
         vcArfvdFsiOuCFgTsnTq8gAoVl7pyHmmYBPJA73+16ZOoWRn2S9GWHf/6zKTnvannFzs
         0XDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kJSbcL/Puw52TJ/P92VQTnEWoevENv+tEsQOyo1zg0A=;
        b=syy1bEx8cHM8VYTIn2T1FaTLEzEqMdmlh7JxN7GYksMBgEY/nZ057ON2sD3L3LkKjO
         q3P0RYtNfkiaJGhU1kLPRQYQohct0KwJFnBUDumi7THirKdVpj3ygA1vm1KvYuOMQuAF
         +iiNuIA7t5GBdKgQ9YQ0mMbHXH3He2OXnOHj9jqKTJaAIy0dWoQLLph7ttEsn7u26lFD
         hEwNeNA4Xj/ycKSdihQ7oGuZnoNi1IofapvI6MIhdktbIEsctA4k+dxsvt5e7pdh/8v/
         NV+MxcQ7F6ASWrz0piRQfdRuFaJPli8NZsJfMM308oJIPPwr9OzHb7AOAPEBn5VBiwgi
         m0iA==
X-Gm-Message-State: AOAM531nyD2QG6JnmvjsbOsng6h2i3fdmZYELbxW9gfs+gk9hRbf7qbi
        1ZTfzoEgxDRbQ5hCQ+Y0CRs=
X-Google-Smtp-Source: ABdhPJyIw9z2yznaBIuOGY4VvHXRQL0rIxVAbZyLT+uUcjLXHdNCo0VvBEr8Aza3Jgu/P322w/fVXQ==
X-Received: by 2002:adf:e54a:: with SMTP id z10mr7068701wrm.87.1614918146049;
        Thu, 04 Mar 2021 20:22:26 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id z3sm2170446wrs.55.2021.03.04.20.22.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:22:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 2/6] io_uring: introduce ctx to tctx back map
Date:   Fri,  5 Mar 2021 04:18:20 +0000
Message-Id: <b1a70b22d837d7e2a294d87f5a9cdbbb8da60392.1614917790.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614917790.git.asml.silence@gmail.com>
References: <cover.1614917790.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For each pair tcxt-ctx create an object and chain it into ctx, so we
have a way to traverse all tctx that are using current ctx. Preparation
patch, will be used later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 58 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bcf2c08fc12e..e62f28512cc4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -454,6 +454,7 @@ struct io_ring_ctx {
 
 	/* Keep this last, we don't need it for the fast path */
 	struct work_struct		exit_work;
+	struct list_head		tctx_list;
 };
 
 /*
@@ -805,6 +806,13 @@ struct io_kiocb {
 	struct io_wq_work		work;
 };
 
+struct io_tctx_node {
+	struct list_head	ctx_node;
+	struct task_struct	*task;
+	struct file		*file;
+	struct io_ring_ctx	*ctx;
+};
+
 struct io_defer_entry {
 	struct list_head	list;
 	struct io_kiocb		*req;
@@ -1144,6 +1152,7 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	INIT_DELAYED_WORK(&ctx->rsrc_put_work, io_rsrc_put_work);
 	init_llist_head(&ctx->rsrc_put_llist);
+	INIT_LIST_HEAD(&ctx->tctx_list);
 	INIT_LIST_HEAD(&ctx->submit_state.comp.free_list);
 	INIT_LIST_HEAD(&ctx->submit_state.comp.locked_free_list);
 	return ctx;
@@ -8742,6 +8751,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	struct io_tctx_node *node;
 	int ret;
 
 	if (unlikely(!tctx)) {
@@ -8754,13 +8764,25 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 		void *old = xa_load(&tctx->xa, (unsigned long)file);
 
 		if (!old) {
+			node = kmalloc(sizeof(*node), GFP_KERNEL);
+			if (!node)
+				return -ENOMEM;
+			node->ctx = ctx;
+			node->file = file;
+			node->task = current;
+
 			get_file(file);
 			ret = xa_err(xa_store(&tctx->xa, (unsigned long)file,
-						file, GFP_KERNEL));
+						node, GFP_KERNEL));
 			if (ret) {
 				fput(file);
+				kfree(node);
 				return ret;
 			}
+
+			mutex_lock(&ctx->uring_lock);
+			list_add(&node->ctx_node, &ctx->tctx_list);
+			mutex_unlock(&ctx->uring_lock);
 		}
 		tctx->last = file;
 	}
@@ -8782,23 +8804,31 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 static void io_uring_del_task_file(unsigned long index)
 {
 	struct io_uring_task *tctx = current->io_uring;
-	struct file *file;
+	struct io_tctx_node *node;
 
-	file = xa_erase(&tctx->xa, index);
-	if (!file)
+	node = xa_erase(&tctx->xa, index);
+	if (!node)
 		return;
 
-	if (tctx->last == file)
+	WARN_ON_ONCE(current != node->task);
+	WARN_ON_ONCE(list_empty(&node->ctx_node));
+
+	mutex_lock(&node->ctx->uring_lock);
+	list_del(&node->ctx_node);
+	mutex_unlock(&node->ctx->uring_lock);
+
+	if (tctx->last == node->file)
 		tctx->last = NULL;
-	fput(file);
+	fput(node->file);
+	kfree(node);
 }
 
 static void io_uring_clean_tctx(struct io_uring_task *tctx)
 {
-	struct file *file;
+	struct io_tctx_node *node;
 	unsigned long index;
 
-	xa_for_each(&tctx->xa, index, file)
+	xa_for_each(&tctx->xa, index, node)
 		io_uring_del_task_file(index);
 	if (tctx->io_wq) {
 		io_wq_put_and_exit(tctx->io_wq);
@@ -8809,13 +8839,13 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
 void __io_uring_files_cancel(struct files_struct *files)
 {
 	struct io_uring_task *tctx = current->io_uring;
-	struct file *file;
+	struct io_tctx_node *node;
 	unsigned long index;
 
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
-	xa_for_each(&tctx->xa, index, file)
-		io_uring_cancel_task_requests(file->private_data, files);
+	xa_for_each(&tctx->xa, index, node)
+		io_uring_cancel_task_requests(node->ctx, files);
 	atomic_dec(&tctx->in_idle);
 
 	if (files)
@@ -8881,11 +8911,11 @@ void __io_uring_task_cancel(void)
 	atomic_inc(&tctx->in_idle);
 
 	if (tctx->sqpoll) {
-		struct file *file;
+		struct io_tctx_node *node;
 		unsigned long index;
 
-		xa_for_each(&tctx->xa, index, file)
-			io_uring_cancel_sqpoll(file->private_data);
+		xa_for_each(&tctx->xa, index, node)
+			io_uring_cancel_sqpoll(node->ctx);
 	}
 
 	do {
-- 
2.24.0

