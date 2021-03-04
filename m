Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354E332D4D3
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 15:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234767AbhCDOFH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 09:05:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238930AbhCDOEy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 09:04:54 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BE8C061764
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 06:03:39 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id b18so21299100wrn.6
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 06:03:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=wFbtv7FLfmfuLcUfQ3ZSNlIl2tlJJWT6qVK77D8Xb5c=;
        b=pi+XtsBhZ78O/3PGRcfufsFmsvrlaZozzdzlzDnjwsMp1h2symUrIONXkICx2Y9OAn
         F0Aeb5qCQ2kyLecdvk5d/DoWfah+3VopQh+0IAAvF3/tEaGeqmsDGd8L2KlXGAPmeEbl
         lMjlwEMiqk3lqmjWEu/RlRHcyFQPXeNSTFj8+CoX4vNXQq4zt9NtqHRLbixFF2v0B7sQ
         v5GWW/lLH3EfiAuhC7/hnhHpHud0sWcMwJi3BPzit7diOQRJGDl6yX4oBkcwwDLwOFe9
         CMcOdrMM1c7xeWmNSrhb8xmd2dirKamxnCG15Y3FQEZyHoc7m/r/B/fA5wZRgweMTHmj
         pR4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wFbtv7FLfmfuLcUfQ3ZSNlIl2tlJJWT6qVK77D8Xb5c=;
        b=pZHIanlhO5i4sjuYd8pXKMU7oTrBhfkZfraxOkYT9dkVIla3tUx81hh9dL8CAPhtrX
         0cCnC3KKm++a3pUeyPrz/fcljKyETyiepoIieDTIztBsHCb3DjrciVuwuM3WsrLYzJy1
         QXygTH6G/VnL1ddEtrXQS4w5rjlSRB4ci9st8gQ5tP8AQyfActhSRVUGxStaXk5qiGtg
         qwUsb2YAPbZty9m+OvX/rrxHZM7AePBRfD9Ru8x7Vrl1I3XlMg10T/uJChBaFE0Bp3RP
         HTfgbVfyo3Jpu+KJifHC1fopl+o6uJkZRnVVeAupmQ2+ZeOwzP8Y0bUjIHG0llM6uNAw
         drzg==
X-Gm-Message-State: AOAM533xD8h219t9260WK2XknH/A7T1N9NarL7YGw6P1ltJhX1hkaqBt
        sDIlHyroHJ+D/Jvah+kyQbx8sU6+6ps=
X-Google-Smtp-Source: ABdhPJzSuyyeFrP2c1qnz1WyXByV/PepH2P5TXnI1m6L0D0VbQFtgER5LOaZsLWeluSKg84Elj4sng==
X-Received: by 2002:adf:eb8e:: with SMTP id t14mr4300379wrn.20.1614866618763;
        Thu, 04 Mar 2021 06:03:38 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id o124sm9975488wmo.41.2021.03.04.06.03.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 06:03:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/8] io_uring: introduce ctx to tctx back map
Date:   Thu,  4 Mar 2021 13:59:27 +0000
Message-Id: <9528400f82fc0ec350a5bcce6848cf73a43a11af.1614866085.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614866085.git.asml.silence@gmail.com>
References: <cover.1614866085.git.asml.silence@gmail.com>
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
 fs/io_uring.c | 68 ++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 55e1ec4c0099..8d632fa61799 100644
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
@@ -8735,6 +8744,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	struct io_tctx_node *node;
 	int ret;
 
 	if (unlikely(!tctx)) {
@@ -8747,13 +8757,25 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
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
@@ -8775,23 +8797,31 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
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
@@ -8802,13 +8832,13 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
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
@@ -8874,11 +8904,11 @@ void __io_uring_task_cancel(void)
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
@@ -8910,18 +8940,16 @@ void __io_uring_task_cancel(void)
 void __io_uring_unshare(void)
 {
 	struct io_uring_task *tctx = current->io_uring;
-	struct file *file;
+	struct io_tctx_node *node;
 	unsigned long index;
 
 	io_wq_unshare(tctx->io_wq);
 	if (!tctx->sqpoll)
 		return;
 
-	xa_for_each(&tctx->xa, index, file) {
-		struct io_ring_ctx *ctx = file->private_data;
-
-		if (ctx->sq_data)
-			io_sq_thread_stop(ctx->sq_data);
+	xa_for_each(&tctx->xa, index, node) {
+		if (node->ctx->sq_data)
+			io_sq_thread_stop(node->ctx->sq_data);
 	}
 }
 
-- 
2.24.0

