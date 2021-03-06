Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5860832F99A
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 12:07:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhCFLGg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 06:06:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbhCFLGW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 06:06:22 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6292BC06175F
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 03:06:22 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id 124-20020a1c00820000b029010b871409cfso854714wma.4
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 03:06:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ymki1qMhmAXYexlh9+FCuFnTVU+snG1zwh6MbO/O/hg=;
        b=mxRDRhF3rkqagt5SyEevxhXR0X8k//qqJszeba9iTjdPml3m8F/STUhjm9s+qqd+/K
         FhhtaRa3rNclIdo/qEVS8Y9aQfYzKengY0uqL5Li+oguKGzHuOpKavhp5DkykrMnWPPP
         L+kgB96IDKRYy+ikzzTZPe+sQKcfXzBHyyCoseQ3pMRal0UUNhVSRK7eAII8d6j7NOIi
         ydvhjoH5CLPdmiQVajTk5ol/im5JC+50uePGBwWPn/JWMD5NOocCDewJsTcF+s1m3PfU
         HBIIyltjVj7IiKt+FmaZhLZLPyufGvIzO3fIgCxwcYbgTx4xpiTH/IM+aFTS3xBr1LSN
         A1CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ymki1qMhmAXYexlh9+FCuFnTVU+snG1zwh6MbO/O/hg=;
        b=SXrHcZ7RTKqgXy0xMN0CZ/e6dMwVILEvh3XfGDxhl+uciXB1ANU8jSANeJUpd5K8Wt
         9+nwg5iccLSYgR68W/jnis7hgWRANjhN/BiP1F9J8rQG1AhebTm+OfGNZkKWlQBNIRuF
         6qrLhnoaCTw0eH+sHA3t8LeEwK+UorY2qCuns27gGVwwZes11Hl+6XF0Mwg4dKNLjSIE
         MGvIW+34/6lJpUb0YXzJ1ZZ9o8krIRl9AsGaVKmNcid78Aokw6jGYo1t/jnEiWhOzm6U
         8P854ED9H+GQpjnHu+nv30bKF7dndMo6se45zY62ITMyooQ3EQ5h5ISpUwkJmrcZMc31
         fqYw==
X-Gm-Message-State: AOAM532dJpUnF/WYmJRwmFvaFmEQ7XeJxYisC1qLpgdITkfHRBSJ7oBz
        7mWv7/Kh8qnDTDPYKbOfa38=
X-Google-Smtp-Source: ABdhPJycQjqvs11ktPiDwgnFIRZ11Ssoty+EjDKXB8FuQSBIcQPffG5oN9McCHw0mYeVyPx578YCuw==
X-Received: by 2002:a1c:1dd4:: with SMTP id d203mr12976829wmd.83.1615028781098;
        Sat, 06 Mar 2021 03:06:21 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.8])
        by smtp.gmail.com with ESMTPSA id h2sm9442365wrq.81.2021.03.06.03.06.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 03:06:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 2/8] io_uring: introduce ctx to tctx back map
Date:   Sat,  6 Mar 2021 11:02:12 +0000
Message-Id: <27593efc21aadc34312f4900caa8b7b4aa71802e.1615028377.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615028377.git.asml.silence@gmail.com>
References: <cover.1615028377.git.asml.silence@gmail.com>
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
index 4c6a92e5d5a3..f26f8199e4ab 100644
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
@@ -8743,6 +8752,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	struct io_tctx_node *node;
 	int ret;
 
 	if (unlikely(!tctx)) {
@@ -8755,13 +8765,25 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
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
@@ -8783,23 +8805,31 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
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
@@ -8810,13 +8840,13 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
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
@@ -8879,11 +8909,11 @@ void __io_uring_task_cancel(void)
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

