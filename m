Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C1A32F9A1
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 12:07:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbhCFLHH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 06:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbhCFLG0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 06:06:26 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DCDC061762
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 03:06:25 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso828790wmi.0
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 03:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=W1su2/Ie7YNzP7FkMPjA61uBEdl9wIbiGqtwGwi6py4=;
        b=H1Uz8du+hIzWGGtJ1SNTsopzeg4hunPYT96sQlJp3l8UhA/eaYUxKO0utxFlT0oILi
         hg1IyNZArFVg937VXtIvBhtMXUDwnwBGb4qhY0/SLpqFbCBOy8C29pZsxcDrc0wRtjRm
         tdva6hHBh9Vs4GRwVAwpHDGKn3cvKVo+BkrWAQOjRKavSFiOokxTJgoDJ7rEfJ34aIac
         kt1zdyJT9gAVArwjgtddqe8cpAU0keVwxjJ1vEgSDGEAW4nJ7Y6PJUMqXnu5uCtEfF5z
         iHFBvY5y8bQQuS1qNC0ESZNPIUllKoIYskRdlM0I3sP7t8cEMxNP7oqEjRpwpjfNSNDh
         XPbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=W1su2/Ie7YNzP7FkMPjA61uBEdl9wIbiGqtwGwi6py4=;
        b=A/Vd5CtROYfk38oJQkkdpFm+Y49JHz4Csjdyjavs0F31OtemGP0P5ZZohkfAXgtazf
         m5fms9yZ9inhee2gjN1EmWJ2Rjnt6lqdVOziexPlCEkHBSmoqSZXvywIWE1DFyQPkaZH
         7Aa1e7Bf2NW/4OyMsLC7LgvxgGIsicEBILzBOrBxykKApuCW+yu/kiDFf+x86sie9FJ/
         a/2pV1RbpsM9W7EuNMhWFJDw6Mhm0refTdTQYraR5fLMlHc3aT/BJ52DmQmX1QY293n3
         PTGaa/3oEG/uzLqWL378Vr+4muEuQBH+7zvjcHrAE2xmSSIqiYnceJ+AV+hIolTb3rw7
         ERSg==
X-Gm-Message-State: AOAM53000O5ZE21V9yR6hkNu8UeB0+IwmV5haSgQOu1ZXpBvFPHaC1QE
        L+4I98BPNzDnORV5W0J7P2m39ivA5mwjrg==
X-Google-Smtp-Source: ABdhPJzb/6mN9HnwbWJfQHMRnyrRx4Xz6cRTin+ZSAPf2vTbrAz7j+CFsAbhBltUaBX6kNv6biNxMg==
X-Received: by 2002:a1c:e388:: with SMTP id a130mr13335692wmh.187.1615028784495;
        Sat, 06 Mar 2021 03:06:24 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.8])
        by smtp.gmail.com with ESMTPSA id h2sm9442365wrq.81.2021.03.06.03.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 03:06:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 5/8] io_uring: index io_uring->xa by ctx not file
Date:   Sat,  6 Mar 2021 11:02:15 +0000
Message-Id: <0c7ca04dca59ff15b607aa7c628f2bdd736b73e9.1615028377.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615028377.git.asml.silence@gmail.com>
References: <cover.1615028377.git.asml.silence@gmail.com>
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
index a4e5acb058d2..c5436b24d221 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -809,7 +809,6 @@ struct io_kiocb {
 struct io_tctx_node {
 	struct list_head	ctx_node;
 	struct task_struct	*task;
-	struct file		*file;
 	struct io_ring_ctx	*ctx;
 };
 
@@ -8535,7 +8534,7 @@ static bool io_run_ctx_fallback(struct io_ring_ctx *ctx)
 struct io_tctx_exit {
 	struct callback_head		task_work;
 	struct completion		completion;
-	unsigned long			index;
+	struct io_ring_ctx		*ctx;
 };
 
 static void io_tctx_exit_cb(struct callback_head *cb)
@@ -8549,7 +8548,7 @@ static void io_tctx_exit_cb(struct callback_head *cb)
 	 * node. It'll be removed by the end of cancellation, just ignore it.
 	 */
 	if (!atomic_read(&tctx->in_idle))
-		io_uring_del_task_file(work->index);
+		io_uring_del_task_file((unsigned long)work->ctx);
 	complete(&work->completion);
 }
 
@@ -8574,7 +8573,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	while (!list_empty(&ctx->tctx_list)) {
 		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
 					ctx_node);
-		exit.index = (unsigned long)node->file;
+		exit.ctx = ctx;
 		init_completion(&exit.completion);
 		init_task_work(&exit.task_work, io_tctx_exit_cb);
 		ret = task_work_add(node->task, &exit.task_work, TWA_SIGNAL);
@@ -8793,7 +8792,7 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 /*
  * Note that this task has used io_uring. We use it for cancelation purposes.
  */
-static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
+static int io_uring_add_task_file(struct io_ring_ctx *ctx)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
@@ -8805,18 +8804,17 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
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
@@ -8827,7 +8825,7 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 			list_add(&node->ctx_node, &ctx->tctx_list);
 			mutex_unlock(&ctx->uring_lock);
 		}
-		tctx->last = file;
+		tctx->last = ctx;
 	}
 
 	/*
@@ -8862,7 +8860,7 @@ static void io_uring_del_task_file(unsigned long index)
 	list_del(&node->ctx_node);
 	mutex_unlock(&node->ctx->uring_lock);
 
-	if (tctx->last == node->file)
+	if (tctx->last == node->ctx)
 		tctx->last = NULL;
 	kfree(node);
 }
@@ -9161,7 +9159,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		}
 		submitted = to_submit;
 	} else if (to_submit) {
-		ret = io_uring_add_task_file(ctx, f.file);
+		ret = io_uring_add_task_file(ctx);
 		if (unlikely(ret))
 			goto out;
 		mutex_lock(&ctx->uring_lock);
@@ -9370,7 +9368,7 @@ static int io_uring_install_fd(struct io_ring_ctx *ctx, struct file *file)
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

