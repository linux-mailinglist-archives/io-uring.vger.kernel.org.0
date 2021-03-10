Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC34334BC9
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhCJWol (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233828AbhCJWoO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:14 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66754C061761
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:14 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id ba1so9249412plb.1
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NeODVOWsxpgrPqqMlxNuNiAPd84zYV3+BsPHCnhXgoM=;
        b=Z0/dNccDBhnAUb9xRaS1dPFDjKLpisqz+RU3moBQn7ecu/O0fbYD0VSyLyTTDsaf9l
         tvwbKr/AghhBju7HWzM8wF40mEWQSsG523mxihpx7oLgHE6/m9q9ML31MYRPu1wAKu75
         p3lnZMKrwZ6sfaIa2Xv2sQzLbnr7cMjCvil+ihuXSx8itmRj4tHvhGl2K24UHTffvTlu
         ClxlRyVrtBowzXDGixOiHRUiznXxwTr0AAnneHAsEAd03WU7LvJVT0tK6Gix7VvBG9eq
         hPiO4dAQhMf8mDzuhdiFG1Yud4M7fSxh++K7b1ImVehS+6s5sDxDlWQCx8GzE2qtagUp
         PLZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NeODVOWsxpgrPqqMlxNuNiAPd84zYV3+BsPHCnhXgoM=;
        b=gGfN/yr+H4tW1i2oDFLKomM/Yjgqes7DD+VX4iocX4fGfuHZjmfev303VfUAVUelgQ
         wn1KgaIRn7dKKz+ilgrOpkrBT7GdXqdwoN7eBlQdQLspw004yCoHRwCjcdqpyQeU/irj
         xua6Q8TgCD7yhQZWqyrrwrXOfKspfJDaXv759+X5kHbGE5izC2wLQiqO96mMtShizm3w
         k4FUFwKlqsk6M+yafSap9lNVbXko/vMPkEKVWvXdR+4heFQ/q4AC75XG0kfyJ1KuqcSF
         +ftA/22D27a1pYWQ8QWOzGNXLZ9tDkQ+OSDOnPTiee/taTaMRfH4+o5pLYU3jOE+UEmZ
         jo4Q==
X-Gm-Message-State: AOAM530X4/BYtNqcMedKdyvuQFM9putFe+3QTbqoXxxVV15jQZ/CG3zx
        Ljw23ylr2cCRjE1HcApM9/xbzHRO6dyXjQ==
X-Google-Smtp-Source: ABdhPJwxEN0NDuWxc4WX6N6HJ/JuLiAtBx8sw0dl9hmbdp8jopKZkAAiX8hxEprYujPw3bE4hj/X7w==
X-Received: by 2002:a17:90a:6385:: with SMTP id f5mr5802437pjj.91.1615416253745;
        Wed, 10 Mar 2021 14:44:13 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:13 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/27] io_uring: cancel reqs of all iowq's on ring exit
Date:   Wed, 10 Mar 2021 15:43:40 -0700
Message-Id: <20210310224358.1494503-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

io_ring_exit_work() have to cancel all requests, including those staying
in io-wq, however it tries only cancellation of current tctx, which is
NULL. If we've got task==NULL, use the ctx-to-tctx map to go over all
tctx/io-wq and try cancellations on them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 42 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 945e54690b81..8c74c7799960 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8688,19 +8688,55 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 	}
 }
 
+static bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
+{
+	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+
+	return req->ctx == data;
+}
+
+static bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
+{
+	struct io_tctx_node *node;
+	enum io_wq_cancel cret;
+	bool ret = false;
+
+	mutex_lock(&ctx->uring_lock);
+	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
+		struct io_uring_task *tctx = node->task->io_uring;
+
+		/*
+		 * io_wq will stay alive while we hold uring_lock, because it's
+		 * killed after ctx nodes, which requires to take the lock.
+		 */
+		if (!tctx || !tctx->io_wq)
+			continue;
+		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_ctx_cb, ctx, true);
+		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+	}
+	mutex_unlock(&ctx->uring_lock);
+
+	return ret;
+}
+
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 struct files_struct *files)
 {
 	struct io_task_cancel cancel = { .task = task, .files = files, };
-	struct task_struct *tctx_task = task ?: current;
-	struct io_uring_task *tctx = tctx_task->io_uring;
+	struct io_uring_task *tctx = task ? task->io_uring : NULL;
 
 	while (1) {
 		enum io_wq_cancel cret;
 		bool ret = false;
 
-		if (tctx && tctx->io_wq) {
+		if (!task) {
+			ret |= io_uring_try_cancel_iowq(ctx);
+		} else if (tctx && tctx->io_wq) {
+			/*
+			 * Cancels requests of all rings, not only @ctx, but
+			 * it's fine as the task is in exit/exec.
+			 */
 			cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_task_cb,
 					       &cancel, true);
 			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
-- 
2.30.2

