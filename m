Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CFF632EBD8
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 14:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230169AbhCENDH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 08:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbhCENCt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 08:02:49 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C68BC061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 05:02:49 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id n11-20020a05600c4f8bb029010e5cf86347so751096wmq.1
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 05:02:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=a1GEpy9kgUCjNwbzDzpfFm4GGJZ4eXdACf42WCHO/7o=;
        b=GUI/Is/DhmDBF9TXoGR+xebYDPbfWtEGBYbxuUJisf9pgcYd5e+o4YSlUJVG3BTsDT
         3BIxivKoY5NJIGg2O7TUri9+89Rxvo/M2+Spcr6O4N6TtgJuWK99B9cGQM57HGi1Zn8x
         yve/us0hcqrNPslOJyUILwp0nKsVDwb3uw52DQ8nM2OuCOpItkjuRxKZIDfQqbdGaJAh
         jgDmG9xOpRcfl1iEIFRiiAeCXaFXbwfm5+RB1QRWaXd346PeJ7kP46vyz3JFJdoXJNAB
         W9BpuXUagOTOz01oX8Ayfbu2YB32IddBGhmXPYVbP6vkixXZOuT+undRf+ts+2OTh+wO
         KXhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=a1GEpy9kgUCjNwbzDzpfFm4GGJZ4eXdACf42WCHO/7o=;
        b=PATbCNuFfUQM3D7yp+7CGph3j5Yo3mWzT+2jR2fs0uPGaHHbQya5ttqvS78dmMcy+9
         BOQgiAxShpgAZoPjHDM+RBarqxenjW6pXT5T6vw+KVX+SuFAXQ2hqP9tT5RArXyvEnLd
         atx4RmthnOjwJusGtZKFz6+juAMTVKaAv3/uk11UWUbL68es/Vl7LL3BWbOieYsFvA22
         UutFf9z8Ek7HXmPuuccyXBftZn/6+P9YdKuufB8KchqfxUAd5QqkomFgvRmOmKnrkSNe
         DyloCdijQe4UjVcJ/T3o3H/D3FQnEFyY8YsAS+6QHY9BnqRNd62g4IDE1kZO30m5GXs3
         Z+Bw==
X-Gm-Message-State: AOAM533uLUrwUFAD25Ay2tOa4UVqQbeGbN8roTpjhQ8SMTc2G0rZqAYi
        AJ1LQ7RLC2Fxney9ROB16xg=
X-Google-Smtp-Source: ABdhPJz5Vy5Dx2M3oPmh/OHuOQky3nmw9mjgSOT/uv74E6lkshP4EZbqEkaKNe7YGbkhqpcWm6w7Og==
X-Received: by 2002:a05:600c:20d3:: with SMTP id y19mr8948853wmm.146.1614949367744;
        Fri, 05 Mar 2021 05:02:47 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id h20sm4345385wmm.19.2021.03.05.05.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 05:02:47 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 5/6] io_uring: index io_uring->xa by ctx not file
Date:   Fri,  5 Mar 2021 12:58:40 +0000
Message-Id: <bc85580c4dbb8cfb14ab492d034e38248cd8b49f.1614942979.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614942979.git.asml.silence@gmail.com>
References: <cover.1614942979.git.asml.silence@gmail.com>
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

