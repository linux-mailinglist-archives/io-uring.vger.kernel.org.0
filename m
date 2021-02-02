Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8575D30B413
	for <lists+io-uring@lfdr.de>; Tue,  2 Feb 2021 01:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbhBBA0S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Feb 2021 19:26:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbhBBA0R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Feb 2021 19:26:17 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E46BC061756
        for <io-uring@vger.kernel.org>; Mon,  1 Feb 2021 16:25:37 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id o10so862054wmc.1
        for <io-uring@vger.kernel.org>; Mon, 01 Feb 2021 16:25:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=J3NxzPWkT8jPEBK66+CJGJKAjTA07964mm/ay3XaP1Q=;
        b=PNHQ5VKb53+R2S00RV6KR0JaTp2J7BMnZ10WaC8i6s2nB3J3IlnQgiZRNk4DCMkQw7
         CndvYNr2N4Kw7ttXqolhawaiV+3TJ5dy1GIbfCTEnLeQkCC7D344gd9XtybewOk17QTV
         t2YnH9tzTmvzvcpf7TOfqmNGf+kIs/mj8xD93CAFFH8dO40HujSNI6g7LjcTl+pG9voQ
         wSBpY7rWpimdVLP5y1LmKe2F+Pno/MCZ1xW5lgtg5fUhUbOJ44DCYCiGRrENKQnNRPoE
         XY++eJikLaQLtMbD78DbSz8WdNWD8grflptm2YwHkbl23qwGEmqt5lB3j7xvrJ7ZiQaT
         cU6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=J3NxzPWkT8jPEBK66+CJGJKAjTA07964mm/ay3XaP1Q=;
        b=HFK0DqxQwrENtTrpFtpUwGJttpB83mB455ryM6NRUXUVWjWfhBE/kpWYBEzHmOwgIO
         zCT7/szwBlMzH/hywLEQy1zwhW8PjriD1/+sYM0krYYGlG4foslJUsxG7+9YMLFjwihN
         gm+q3UK7lnf4eCD9pNFIrsJkE5gP+buBJR9tP+AGVoh4vjNadvtxDHpUYw+CuWfSYyro
         nQDVUCMfID9z0B+BaOVDY2lYsQRNxrnJLTgGfbLtx2rHhwwfjqQXrALKl3A/xkSydA5Z
         i55hk38DO6q3y/EGFDWkoXHR9hcrn9M72wBPQ9z9DahBpNYvtw0aSGsHVFHsDqbtCEwC
         GJEA==
X-Gm-Message-State: AOAM530hniFa0l+6EHn2tFZI9h6MQQiR7WPGpGadwFZG23mfbZ16dZFQ
        +e7rHLz3ZWnnayrl7ui1wysZlBpJ0NU=
X-Google-Smtp-Source: ABdhPJxdmuXP93JiPuk5RQ6jm5LjrGsi1PoMkYlo7HrofFbjEWvA0iDsutTIIncZaMd0XOLHluimcA==
X-Received: by 2002:a7b:ce92:: with SMTP id q18mr1095645wmj.113.1612225536242;
        Mon, 01 Feb 2021 16:25:36 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.241])
        by smtp.gmail.com with ESMTPSA id n187sm851740wmf.29.2021.02.01.16.25.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 16:25:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/8] io_uring: deduplicate core cancellations sequence
Date:   Tue,  2 Feb 2021 00:21:39 +0000
Message-Id: <9b97d6afbfdb1c33ae92aa93c43db5ae5dca465b.1612223953.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612223953.git.asml.silence@gmail.com>
References: <cover.1612223953.git.asml.silence@gmail.com>
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

