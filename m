Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8106432EBDA
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 14:03:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbhCENDG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 5 Mar 2021 08:03:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230200AbhCENCq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 5 Mar 2021 08:02:46 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAE37C061574
        for <io-uring@vger.kernel.org>; Fri,  5 Mar 2021 05:02:45 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id n22so1375559wmc.2
        for <io-uring@vger.kernel.org>; Fri, 05 Mar 2021 05:02:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=kJSbcL/Puw52TJ/P92VQTnEWoevENv+tEsQOyo1zg0A=;
        b=XTcmj+F4Gxb1oJQslgioO4QhUGU+8cFJFatAb00pUHVhPOY4DJIalG9+mPCY2tqL2L
         F8ygg2pQMv7Gfm/rvY5oxp4l6Ma6uDlseIa0uQ4pZsjM2CNCqIEGMMr0oPhPIkQ+soxr
         UOsfL6FKvMCM9C1dA4y6o5G7i0lBlPW+7fHFN2mAIncch8jjLJJrh5++bz31kBezwnCS
         Q1t7h02iqaAVuAiG5FMf5FML6+evCAWKY5UqXYA5HgQoVF83CCp2jUwlgX3izsfhhYnp
         3Xwkvbs1evmpy+IoJVADBOBdodtziUcMvJ3bKx3iwqJPZeT+eA2p59WQ2SmUQa/QwyOT
         ZarQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kJSbcL/Puw52TJ/P92VQTnEWoevENv+tEsQOyo1zg0A=;
        b=HjlVQEA0MuLjng0CRFWaMcCON8gQ5w4l7je5W2FBFUVGA7fz0UlfvEm4jas/R8OwHi
         jJRoFhq2bkEjJ8wsbLOrCUNtbyAd4pBNZK6hkyMPLHjzEEUvAumMPf8XeWPTDq59LVsI
         m9VmUXqgFBd87lgSxmgev9TGs5J+M0qAqxCAFzGzoFBiqstbhMKCf99MeA3iV9IujVdf
         bAv9Pe9cQOTbIXVSaxuGS9o1r+8y5K5WALhiKFpYoHqr1d2VyKgd3TVDFOIiV/Ah7j4w
         EneSfKor9zCpCE+e5lJuU6WLw3ZyoU3hAR7431VaFHxNJqn0P0O2supLWuqCgTZIYJ0X
         NZ5A==
X-Gm-Message-State: AOAM530yqdFm6+cxLz7vjjOpdzs7jaPqWwV+ZFKvw4JghVOM+bk7SPAk
        9k9us7E1eZNaJDzzf1Ue24MNWKeKsfNWfA==
X-Google-Smtp-Source: ABdhPJwrlmEuZaWADo1nk+oMgUeGCBnDNoByENhLMY5mOftxlcqPTktY528SWlOSDfZsPTnYEx05Nw==
X-Received: by 2002:a7b:c214:: with SMTP id x20mr8877339wmi.186.1614949364621;
        Fri, 05 Mar 2021 05:02:44 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id h20sm4345385wmm.19.2021.03.05.05.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Mar 2021 05:02:44 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 2/6] io_uring: introduce ctx to tctx back map
Date:   Fri,  5 Mar 2021 12:58:37 +0000
Message-Id: <b1a70b22d837d7e2a294d87f5a9cdbbb8da60392.1614942979.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614942979.git.asml.silence@gmail.com>
References: <cover.1614942979.git.asml.silence@gmail.com>
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

