Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D10D38F685
	for <lists+io-uring@lfdr.de>; Tue, 25 May 2021 01:51:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbhEXXxL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 May 2021 19:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229894AbhEXXxK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 May 2021 19:53:10 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16C83C061756
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:41 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id j14so28430259wrq.5
        for <io-uring@vger.kernel.org>; Mon, 24 May 2021 16:51:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+XahhMGWoSLUIX+I8/2d3ZNVHVtS/HdcC/LzyH03Vak=;
        b=h797+t3hJHk76NRl50FBBOgf9m+LW1q1z2WFxwuzYiyvagMtTNA6vbOjAkvdjw3lQ9
         MYe1F3dMYCkK8BUchxqY3L1QGSj4kqZypms/vlswunJlgfiPl54SJTHGY1VuWqS6x0RA
         ZXXRRULbPsScseCLqAHfuHF0O49ewYpHu8Ds6BWcRoBUY+Vh13WqRsNaAhNchGLDUzkc
         gg6KNLH4EebTcOES2Zg71tHZSzeYW3b0x0xowAU0mogfJLx1TOM/FJaTjBcF7ppzDDI9
         poRmbD5bVU8QeWoaBvHuXvxjUdaxcUN/Hk4Iz3vNbMDH/yEInnnprEtUOLQ2O77cnaug
         tx7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+XahhMGWoSLUIX+I8/2d3ZNVHVtS/HdcC/LzyH03Vak=;
        b=m0UP12iYTcp9SvZLoAKGq5RAH5cAfXE4MShjzjf4RGHswbTwuOoMdEoM9SJQfa/HLk
         LOQcqEj8nr2pAgRZMrBLCUaqX85nMHvlizS5ZSrA2DYNVJp0Rja9o4gJai+4VICYcleK
         qnAn6+zJXuQlomfAXvXfheJndvEqn7I+vXKD4x0CnWl4YrR1D8lQiFaq2SBxQiZWc2/A
         F9+oD8LL+uwn//oYnR28Z6sJDnqISqblLZRqByrgI7uNLzebwekdeIph1pXSiE3C5yaC
         P9+mY0i1RTKquFnNqg0j3927KS0xLegGRa2/bM6rIrVsAvgmS4KprURW499E78TgLmOZ
         z3JQ==
X-Gm-Message-State: AOAM5335x2EO93kj9W7+FMm1G++YGD9L5IYOUw/b4+Kiq2YfEOybQXSK
        GMEIQTplcI4GQwDvejWD5is=
X-Google-Smtp-Source: ABdhPJx6e/1wYFCs4ssCWEObaWsnA0oNPXQUmgF5Nkl/0x8iGP1ntNj568UFtK4gyevxx/autzs1+w==
X-Received: by 2002:a5d:4b08:: with SMTP id v8mr24620293wrq.122.1621900299765;
        Mon, 24 May 2021 16:51:39 -0700 (PDT)
Received: from localhost.localdomain ([85.255.235.116])
        by smtp.gmail.com with ESMTPSA id f7sm8961069wmq.30.2021.05.24.16.51.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 16:51:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 13/13] io_uring: unify SQPOLL and user task cancellations
Date:   Tue, 25 May 2021 00:51:12 +0100
Message-Id: <00d85dbdd0f7bf5b80bed15c82ec551689f9851c.1621899872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621899872.git.asml.silence@gmail.com>
References: <cover.1621899872.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Merge io_uring_cancel_sqpoll() and __io_uring_cancel() as it's easier to
have a conditional ctx traverse inside than keeping them in sync.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 89 +++++++++++++++++----------------------------------
 1 file changed, 30 insertions(+), 59 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a95d55a0f9be..7db6aaf31080 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1036,7 +1036,7 @@ static void io_uring_del_tctx_node(unsigned long index);
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
 					 bool cancel_all);
-static void io_uring_cancel_sqpoll(struct io_sq_data *sqd);
+static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd);
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 
 static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
@@ -6921,7 +6921,7 @@ static int io_sq_thread(void *data)
 		timeout = jiffies + sqd->sq_thread_idle;
 	}
 
-	io_uring_cancel_sqpoll(sqd);
+	io_uring_cancel_generic(true, sqd);
 	sqd->thread = NULL;
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		io_ring_set_wakeup_flag(ctx);
@@ -9089,21 +9089,6 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-static void io_uring_try_cancel(bool cancel_all)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	struct io_tctx_node *node;
-	unsigned long index;
-
-	xa_for_each(&tctx->xa, index, node) {
-		struct io_ring_ctx *ctx = node->ctx;
-
-		/* sqpoll task will cancel all its requests */
-		if (!ctx->sq_data)
-			io_uring_try_cancel_requests(ctx, current, cancel_all);
-	}
-}
-
 static void io_uring_drop_tctx_refs(struct task_struct *task)
 {
 	struct io_uring_task *tctx = task->io_uring;
@@ -9114,69 +9099,50 @@ static void io_uring_drop_tctx_refs(struct task_struct *task)
 	put_task_struct_many(task, refs);
 }
 
-/* should only be called by SQPOLL task */
-static void io_uring_cancel_sqpoll(struct io_sq_data *sqd)
+/*
+ * Find any io_uring ctx that this task has registered or done IO on, and cancel
+ * requests. @sqd should be not-null IIF it's an SQPOLL thread cancellation.
+ */
+static void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_ring_ctx *ctx;
 	s64 inflight;
 	DEFINE_WAIT(wait);
 
+	WARN_ON_ONCE(sqd && sqd->thread != current);
+
 	if (!current->io_uring)
 		return;
 	if (tctx->io_wq)
 		io_wq_exit_start(tctx->io_wq);
 
-	WARN_ON_ONCE(!sqd || sqd->thread != current);
-
 	io_uring_drop_tctx_refs(current);
 	atomic_inc(&tctx->in_idle);
 	do {
 		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx, false);
+		inflight = tctx_inflight(tctx, !cancel_all);
 		if (!inflight)
 			break;
-		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-			io_uring_try_cancel_requests(ctx, current, true);
 
-		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
-		/*
-		 * If we've seen completions, retry without waiting. This
-		 * avoids a race where a completion comes in before we did
-		 * prepare_to_wait().
-		 */
-		if (inflight == tctx_inflight(tctx, false))
-			schedule();
-		finish_wait(&tctx->wait, &wait);
-	} while (1);
-	atomic_dec(&tctx->in_idle);
-}
+		if (!sqd) {
+			struct io_tctx_node *node;
+			unsigned long index;
 
-/*
- * Find any io_uring fd that this task has registered or done IO on, and cancel
- * requests.
- */
-void __io_uring_cancel(struct files_struct *files)
-{
-	struct io_uring_task *tctx = current->io_uring;
-	DEFINE_WAIT(wait);
-	s64 inflight;
-	bool cancel_all = !files;
-
-	if (tctx->io_wq)
-		io_wq_exit_start(tctx->io_wq);
+			xa_for_each(&tctx->xa, index, node) {
+				/* sqpoll task will cancel all its requests */
+				if (node->ctx->sq_data)
+					continue;
+				io_uring_try_cancel_requests(node->ctx, current,
+							     cancel_all);
+			}
+		} else {
+			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
+				io_uring_try_cancel_requests(ctx, current,
+							     cancel_all);
+		}
 
-	/* make sure overflow events are dropped */
-	io_uring_drop_tctx_refs(current);
-	atomic_inc(&tctx->in_idle);
-	do {
-		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx, !cancel_all);
-		if (!inflight)
-			break;
-		io_uring_try_cancel(cancel_all);
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
-
 		/*
 		 * If we've seen completions, retry without waiting. This
 		 * avoids a race where a completion comes in before we did
@@ -9195,6 +9161,11 @@ void __io_uring_cancel(struct files_struct *files)
 	}
 }
 
+void __io_uring_cancel(struct files_struct *files)
+{
+	io_uring_cancel_generic(!files, NULL);
+}
+
 static void *io_uring_validate_mmap_request(struct file *file,
 					    loff_t pgoff, size_t sz)
 {
-- 
2.31.1

