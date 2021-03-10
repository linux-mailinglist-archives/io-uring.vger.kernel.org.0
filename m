Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16B2334BC8
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhCJWoj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232633AbhCJWoJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:09 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 854B7C061761
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:09 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id 30so4675284ple.4
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=F3RYcBP5n818AZ3maWouobsyB65S7Nfn2orFhByigIY=;
        b=WQ8x5VTCSTtfRITBY7t9pqPWGT045UwvHJrukPTbkf2tQuQBqSvDFK5LPBIfCAySqE
         k22gZ+GKm6bJ5aQz9X1DB1zdnYseb6nyF1PEZSAcKQIeaLDZkDVgBkA73TEPdma2mXLG
         kMNvLrECElMykDckRCcb2nzsUY7xUrUve5dLOvCVBPBn0HRzQW/+9MkzPZBiY1nsjjMJ
         S2s+27/J0e44P0lriJG0dnozIdEPforhC3m3vT4T2U8nf6vIWPVAGoIKrVuAAocRQsE8
         DobQ21nYw2kLt4IanquNt8sDo/aj/3Uq27JXJDZOAwYGi19Q/Rfpp4S8yYDrCXYIXNLe
         WfTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=F3RYcBP5n818AZ3maWouobsyB65S7Nfn2orFhByigIY=;
        b=IvdGXJQFmzzvPfUMuBixHQIvYWzQlBAbbxJbyim+Gdqf2AuwV4ycV2tW+/h53Jf/fF
         FBUDBoNtCHzeUMOGf0kQVkAQ0KLPlr/f1VN+MJeiW/iREVmtt3ZmVp+LTp86mGWDIQPB
         oy2hW18NaU3ysk1RurTQpGvC9IpifXaE0u+vsWZ07uMxCCy0rerCK07aX3LtSfiE5v6x
         SHK5MnZWuLvQF00d6YPtyJv3QMvfi7oP+LPb6XT5epnYX3qIy8l9OA5yNYF78tDNs0c2
         ZnMQmE5cww3FDioin04Q8rjsO5EOBBfnfNprFL2WYxqQLlhMWKyf22D+5b1aR3cQhblt
         NP3g==
X-Gm-Message-State: AOAM531lL3OK5Ezp8bjlAsq1QPUClwxNTJ9tyVqMOiz6Iki2uIbttWAG
        meVSys9k7tSwRoxn1awXGBs34+Kz6o9QGw==
X-Google-Smtp-Source: ABdhPJyHAoeTqCeDjUwbnEXGoUhU63a0XZv+V4qHBKsnRV5MxYpyTR2K1CarHFoLIYUV30/ipHMh2A==
X-Received: by 2002:a17:90a:6e44:: with SMTP id s4mr5447456pjm.112.1615416248825;
        Wed, 10 Mar 2021 14:44:08 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:08 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/27] io_uring: introduce ctx to tctx back map
Date:   Wed, 10 Mar 2021 15:43:35 -0700
Message-Id: <20210310224358.1494503-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

For each pair tcxt-ctx create an object and chain it into ctx, so we
have a way to traverse all tctx that are using current ctx. Preparation
patch, will be used later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 58 ++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 44 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 00a736867b76..9a2cff0662e0 100644
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
@@ -8748,6 +8757,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	struct io_tctx_node *node;
 	int ret;
 
 	if (unlikely(!tctx)) {
@@ -8760,13 +8770,25 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
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
@@ -8788,23 +8810,31 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
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
@@ -8815,13 +8845,13 @@ static void io_uring_clean_tctx(struct io_uring_task *tctx)
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
@@ -8884,11 +8914,11 @@ void __io_uring_task_cancel(void)
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
2.30.2

