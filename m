Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E31430F463
	for <lists+io-uring@lfdr.de>; Thu,  4 Feb 2021 15:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236499AbhBDN6P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 08:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236511AbhBDN4q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 08:56:46 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD036C061793
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 05:56:00 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id p15so3570347wrq.8
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 05:56:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=J3NxzPWkT8jPEBK66+CJGJKAjTA07964mm/ay3XaP1Q=;
        b=A4a3ThdJbzwGT7s/KkjVn23TU+fOx21vIb+JmK4OmVnmtnIwum4IGtdzW5uT9hbbqU
         xV6LPYkxD0QztKdHDDT/jPTY4YPU3Qch9jJBJ5x8xclyX3FXEHWZb87GLaXrYMmODnLG
         0Jd/JpuB+1gvk9GPZIlmfu283GD2nSlbJgrpsMfWdi8RpCPXgXf0cg6aNpHDCkThzu97
         w+CaZrOQuWFt02iE730aBU7wkn8LO5b9hJV4slJtRnP6lEt3U1+M70ARmZZUj6r5oWvf
         2+ymbk7OwVGHOdZWXcWyTEi+Z+JiBy5ut9DM2bemm51n9m1SZNe2v2luSkm46zgErTEs
         CqEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J3NxzPWkT8jPEBK66+CJGJKAjTA07964mm/ay3XaP1Q=;
        b=bPI7XimdDX3Q5IDIlVrgp6njuFdKW2E4rOBLqfMuQ/Wtej70k7pzxWUjMoRNLeNAVY
         0h4E+RKXDOITTxyEDrbIC2xuQrI0R5bmk9durfHt0q/grNe4y+9QCSJuWAZCeF207aD2
         ajqIaMEMyKSLTeeaWFp8EWbqvoqFdN4mzsE52ylYok4YpJPpD8vRKzQnGnt/vK5txCk8
         lDKD+OjOi3QgNO7sw0AxeV8REMFMjtrjPhdIByA5qId2PKZrOdcMMlXcdorIhgIhPfpt
         tFiFhtfwUGl3r6GZc6OwteoU1E4pvgYUxCdGGyU1xd7z11W2hhgi+haw7Eqcq8E5KIfV
         bU2A==
X-Gm-Message-State: AOAM532oVL//PfyYoF/8ES0FjJ+uOrwdAe0IMqU9YPkMk9ST6d+wjfin
        GNkb2VwBLKOrTs/FvFF99dSsxhT/Uo6JDQ==
X-Google-Smtp-Source: ABdhPJxSrK0TPJDC9yoykb/MRV0TyRy9sfIZnGeKTMfiT+MXsX4QuJvt/QbKfeCHG6MyNDrGd7F7dg==
X-Received: by 2002:a5d:6041:: with SMTP id j1mr9508040wrt.155.1612446959501;
        Thu, 04 Feb 2021 05:55:59 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id k4sm8910561wrm.53.2021.02.04.05.55.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 05:55:59 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 01/13] io_uring: deduplicate core cancellations sequence
Date:   Thu,  4 Feb 2021 13:51:56 +0000
Message-Id: <9b97d6afbfdb1c33ae92aa93c43db5ae5dca465b.1612446019.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612446019.git.asml.silence@gmail.com>
References: <cover.1612446019.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Files and task cancellations go over same steps trying to cancel
requests in io-wq, poll, etc. Deduplicate it with a helper.

note: new io_uring_try_cancel_requests() is former
__io_uring_cancel_task_requests() with files passed as an agrument and
flushing overflowed requests.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 85 ++++++++++++++++++++++++---------------------------
 1 file changed, 40 insertions(+), 45 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 24ad36d71289..a750c504366d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1003,9 +1003,9 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
-static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					    struct task_struct *task);
-
+static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
+					 struct task_struct *task,
+					 struct files_struct *files);
 static void destroy_fixed_rsrc_ref_node(struct fixed_rsrc_ref_node *ref_node);
 static struct fixed_rsrc_ref_node *alloc_fixed_rsrc_ref_node(
 			struct io_ring_ctx *ctx);
@@ -8817,7 +8817,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	 * as nobody else will be looking for them.
 	 */
 	do {
-		__io_uring_cancel_task_requests(ctx, NULL);
+		io_uring_try_cancel_requests(ctx, NULL, NULL);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
 }
@@ -8931,6 +8931,40 @@ static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 	}
 }
 
+static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
+					 struct task_struct *task,
+					 struct files_struct *files)
+{
+	struct io_task_cancel cancel = { .task = task, .files = files, };
+
+	while (1) {
+		enum io_wq_cancel cret;
+		bool ret = false;
+
+		if (ctx->io_wq) {
+			cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb,
+					       &cancel, true);
+			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+		}
+
+		/* SQPOLL thread does its own polling */
+		if (!(ctx->flags & IORING_SETUP_SQPOLL) && !files) {
+			while (!list_empty_careful(&ctx->iopoll_list)) {
+				io_iopoll_try_reap_events(ctx);
+				ret = true;
+			}
+		}
+
+		ret |= io_poll_remove_all(ctx, task, files);
+		ret |= io_kill_timeouts(ctx, task, files);
+		ret |= io_run_task_work();
+		io_cqring_overflow_flush(ctx, true, task, files);
+		if (!ret)
+			break;
+		cond_resched();
+	}
+}
+
 static int io_uring_count_inflight(struct io_ring_ctx *ctx,
 				   struct task_struct *task,
 				   struct files_struct *files)
@@ -8950,7 +8984,6 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
 	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_task_cancel cancel = { .task = task, .files = files };
 		DEFINE_WAIT(wait);
 		int inflight;
 
@@ -8958,13 +8991,7 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 		if (!inflight)
 			break;
 
-		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
-		io_poll_remove_all(ctx, task, files);
-		io_kill_timeouts(ctx, task, files);
-		io_cqring_overflow_flush(ctx, true, task, files);
-		/* cancellations _may_ trigger task work */
-		io_run_task_work();
-
+		io_uring_try_cancel_requests(ctx, task, files);
 		prepare_to_wait(&task->io_uring->wait, &wait,
 				TASK_UNINTERRUPTIBLE);
 		if (inflight == io_uring_count_inflight(ctx, task, files))
@@ -8973,37 +9000,6 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 	}
 }
 
-static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
-					    struct task_struct *task)
-{
-	while (1) {
-		struct io_task_cancel cancel = { .task = task, .files = NULL, };
-		enum io_wq_cancel cret;
-		bool ret = false;
-
-		if (ctx->io_wq) {
-			cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb,
-					       &cancel, true);
-			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
-		}
-
-		/* SQPOLL thread does its own polling */
-		if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
-			while (!list_empty_careful(&ctx->iopoll_list)) {
-				io_iopoll_try_reap_events(ctx);
-				ret = true;
-			}
-		}
-
-		ret |= io_poll_remove_all(ctx, task, NULL);
-		ret |= io_kill_timeouts(ctx, task, NULL);
-		ret |= io_run_task_work();
-		if (!ret)
-			break;
-		cond_resched();
-	}
-}
-
 static void io_disable_sqo_submit(struct io_ring_ctx *ctx)
 {
 	mutex_lock(&ctx->uring_lock);
@@ -9033,11 +9029,10 @@ static void io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 	}
 
 	io_cancel_defer_files(ctx, task, files);
-	io_cqring_overflow_flush(ctx, true, task, files);
 
 	io_uring_cancel_files(ctx, task, files);
 	if (!files)
-		__io_uring_cancel_task_requests(ctx, task);
+		io_uring_try_cancel_requests(ctx, task, NULL);
 
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && ctx->sq_data) {
 		atomic_dec(&task->io_uring->in_idle);
-- 
2.24.0

