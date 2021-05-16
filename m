Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3B0382158
	for <lists+io-uring@lfdr.de>; Sun, 16 May 2021 23:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229969AbhEPV7v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 May 2021 17:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhEPV7s (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 May 2021 17:59:48 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3494C06174A
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:31 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id x8so4405870wrq.9
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eAteyY02xVK/XZGcyA1bJReCG5gHl25mxSVSfpnb10Y=;
        b=hiYWAdldRArqpFiu5NhozUFMORknwfnm2WFPqItFY/bqgKmGvR7L7VXtXoUhpLkVlz
         +rNWfKD3r2r5mFphcwh+8NghVTXSNeqQwFzlIK218VZwi+jLSjvSNOL2QFauIvf4JG59
         5cCTleKMFCfBhN8cG+VQ5iWcBp7VuN0QwDvP98ejU/ie4WWhv+5kWUX3q93R7gUBsWMn
         C7uHPZeBGMCOd+yuW1BEheq0VrwkTmh68/xsj4dKo4py/QpZ36K4kk2ai5i0Cnni+4V6
         6uyuFTDzLQxH57g8qiyW5ofm6vohOUbwazjIIu4yfCjg4GtjnZelwQRJhkR7E4XR4ziP
         YAaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eAteyY02xVK/XZGcyA1bJReCG5gHl25mxSVSfpnb10Y=;
        b=NnOLsRTMvgToqsmQwFrp0mjqbU6DzsPTX1UWO3LFlm9dHYcmXJhXvOm9G/JW8e5/f1
         ww/wW+2qFhDjHfuFif4z32O6mxPEcVwS6mpsg3IQQVtS0udMyHIyNIX0mj0Z7r1HUvhJ
         3K9w+4BSUfanMQa8Awe1UgVSAlLCCf/UbzGAP0YvOXls8JG+Jp5ZAHoRorW6xMz9W+dB
         GGXklmev0qSMtkyyqoE0J9Sd9huy3+JNtxPJkZGiKxJynp1hrY+LoMi/7DJsffJ3FK87
         fTBQoKNkUdwu8sPxvNHsFgqxJASdvpGtAo535mTlPXJ3/wto1iorbda5vXTG0c2W7ARu
         8Dww==
X-Gm-Message-State: AOAM533QMVsz1CmjzckYudilALjiTfAAnuheP6UJRbKfB3mZvuYFhXPO
        GiRk/DADx8l9HzuNdwnI3yIKoyt0uVo=
X-Google-Smtp-Source: ABdhPJwEb5FFtPAigN95wuogxuzief8JuOyU23/OPSt+DDpzQQM4re/pWVgl+S2JdpvqvAh5Fo8gkA==
X-Received: by 2002:adf:f6cd:: with SMTP id y13mr1152279wrp.325.1621202310451;
        Sun, 16 May 2021 14:58:30 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.7])
        by smtp.gmail.com with ESMTPSA id p10sm13666365wmq.14.2021.05.16.14.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:58:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 05/13] io_uring: get rid of files in exit cancel
Date:   Sun, 16 May 2021 22:58:04 +0100
Message-Id: <7bfc5409a78f8e2d6b27dec3293ec2d248677348.1621201931.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
References: <cover.1621201931.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't match against files on cancellation anymore, so no need to drag
around files_struct anymore, just pass a flag telling whether only
inflight or all requests should be killed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 63 +++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 192ce31d310c..9dfffd66362e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1031,7 +1031,7 @@ static bool io_disarm_next(struct io_kiocb *req);
 static void io_uring_del_task_file(unsigned long index);
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
-					 struct files_struct *files);
+					 bool cancel_all);
 static void io_uring_cancel_sqpoll(struct io_sq_data *sqd);
 static struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
 
@@ -1100,15 +1100,14 @@ static void io_refs_resurrect(struct percpu_ref *ref, struct completion *compl)
 		percpu_ref_put(ref);
 }
 
-static bool io_match_task(struct io_kiocb *head,
-			  struct task_struct *task,
-			  struct files_struct *files)
+static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
+			  bool cancel_all)
 {
 	struct io_kiocb *req;
 
 	if (task && head->task != task)
 		return false;
-	if (!files)
+	if (cancel_all)
 		return true;
 
 	io_for_each_link(req, head) {
@@ -5251,7 +5250,7 @@ static bool io_poll_remove_one(struct io_kiocb *req)
  * Returns true if we found and killed one or more poll requests
  */
 static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
-			       struct files_struct *files)
+			       bool cancel_all)
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
@@ -5263,7 +5262,7 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
-			if (io_match_task(req, tsk, files))
+			if (io_match_task(req, tsk, cancel_all))
 				posted += io_poll_remove_one(req);
 		}
 	}
@@ -8736,7 +8735,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	 * as nobody else will be looking for them.
 	 */
 	do {
-		io_uring_try_cancel_requests(ctx, NULL, NULL);
+		io_uring_try_cancel_requests(ctx, NULL, true);
 		if (ctx->sq_data) {
 			struct io_sq_data *sqd = ctx->sq_data;
 			struct task_struct *tsk;
@@ -8787,14 +8786,14 @@ static void io_ring_exit_work(struct work_struct *work)
 
 /* Returns true if we found and killed one or more timeouts */
 static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
-			     struct files_struct *files)
+			     bool cancel_all)
 {
 	struct io_kiocb *req, *tmp;
 	int canceled = 0;
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
-		if (io_match_task(req, tsk, files)) {
+		if (io_match_task(req, tsk, cancel_all)) {
 			io_kill_timeout(req, -ECANCELED);
 			canceled++;
 		}
@@ -8820,8 +8819,8 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 		io_unregister_personality(ctx, index);
 	mutex_unlock(&ctx->uring_lock);
 
-	io_kill_timeouts(ctx, NULL, NULL);
-	io_poll_remove_all(ctx, NULL, NULL);
+	io_kill_timeouts(ctx, NULL, true);
+	io_poll_remove_all(ctx, NULL, true);
 
 	/* if we failed setting up the ctx, we might not have any rings */
 	io_iopoll_try_reap_events(ctx);
@@ -8847,7 +8846,7 @@ static int io_uring_release(struct inode *inode, struct file *file)
 
 struct io_task_cancel {
 	struct task_struct *task;
-	struct files_struct *files;
+	bool all;
 };
 
 static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
@@ -8856,30 +8855,29 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 	struct io_task_cancel *cancel = data;
 	bool ret;
 
-	if (cancel->files && (req->flags & REQ_F_LINK_TIMEOUT)) {
+	if (!cancel->all && (req->flags & REQ_F_LINK_TIMEOUT)) {
 		unsigned long flags;
 		struct io_ring_ctx *ctx = req->ctx;
 
 		/* protect against races with linked timeouts */
 		spin_lock_irqsave(&ctx->completion_lock, flags);
-		ret = io_match_task(req, cancel->task, cancel->files);
+		ret = io_match_task(req, cancel->task, cancel->all);
 		spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	} else {
-		ret = io_match_task(req, cancel->task, cancel->files);
+		ret = io_match_task(req, cancel->task, cancel->all);
 	}
 	return ret;
 }
 
 static bool io_cancel_defer_files(struct io_ring_ctx *ctx,
-				  struct task_struct *task,
-				  struct files_struct *files)
+				  struct task_struct *task, bool cancel_all)
 {
 	struct io_defer_entry *de;
 	LIST_HEAD(list);
 
 	spin_lock_irq(&ctx->completion_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
-		if (io_match_task(de->req, task, files)) {
+		if (io_match_task(de->req, task, cancel_all)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
@@ -8923,9 +8921,9 @@ static bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
-					 struct files_struct *files)
+					 bool cancel_all)
 {
-	struct io_task_cancel cancel = { .task = task, .files = files, };
+	struct io_task_cancel cancel = { .task = task, .all = cancel_all, };
 	struct io_uring_task *tctx = task ? task->io_uring : NULL;
 
 	while (1) {
@@ -8945,7 +8943,7 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		}
 
 		/* SQPOLL thread does its own polling */
-		if ((!(ctx->flags & IORING_SETUP_SQPOLL) && !files) ||
+		if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
 		    (ctx->sq_data && ctx->sq_data->thread == current)) {
 			while (!list_empty_careful(&ctx->iopoll_list)) {
 				io_iopoll_try_reap_events(ctx);
@@ -8953,9 +8951,9 @@ static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 			}
 		}
 
-		ret |= io_cancel_defer_files(ctx, task, files);
-		ret |= io_poll_remove_all(ctx, task, files);
-		ret |= io_kill_timeouts(ctx, task, files);
+		ret |= io_cancel_defer_files(ctx, task, cancel_all);
+		ret |= io_poll_remove_all(ctx, task, cancel_all);
+		ret |= io_kill_timeouts(ctx, task, cancel_all);
 		ret |= io_run_task_work();
 		ret |= io_run_ctx_fallback(ctx);
 		if (!ret)
@@ -9056,7 +9054,7 @@ static s64 tctx_inflight(struct io_uring_task *tctx, bool tracked)
 	return percpu_counter_sum(&tctx->inflight);
 }
 
-static void io_uring_try_cancel(struct files_struct *files)
+static void io_uring_try_cancel(bool cancel_all)
 {
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
@@ -9067,7 +9065,7 @@ static void io_uring_try_cancel(struct files_struct *files)
 
 		/* sqpoll task will cancel all its requests */
 		if (!ctx->sq_data)
-			io_uring_try_cancel_requests(ctx, current, files);
+			io_uring_try_cancel_requests(ctx, current, cancel_all);
 	}
 }
 
@@ -9090,7 +9088,7 @@ static void io_uring_cancel_sqpoll(struct io_sq_data *sqd)
 		if (!inflight)
 			break;
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-			io_uring_try_cancel_requests(ctx, current, NULL);
+			io_uring_try_cancel_requests(ctx, current, true);
 
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 		/*
@@ -9114,15 +9112,16 @@ void __io_uring_cancel(struct files_struct *files)
 	struct io_uring_task *tctx = current->io_uring;
 	DEFINE_WAIT(wait);
 	s64 inflight;
+	bool cancel_all = !files;
 
 	/* make sure overflow events are dropped */
 	atomic_inc(&tctx->in_idle);
 	do {
 		/* read completions before cancelations */
-		inflight = tctx_inflight(tctx, !!files);
+		inflight = tctx_inflight(tctx, !cancel_all);
 		if (!inflight)
 			break;
-		io_uring_try_cancel(files);
+		io_uring_try_cancel(cancel_all);
 		prepare_to_wait(&tctx->wait, &wait, TASK_UNINTERRUPTIBLE);
 
 		/*
@@ -9130,14 +9129,14 @@ void __io_uring_cancel(struct files_struct *files)
 		 * avoids a race where a completion comes in before we did
 		 * prepare_to_wait().
 		 */
-		if (inflight == tctx_inflight(tctx, !!files))
+		if (inflight == tctx_inflight(tctx, !cancel_all))
 			schedule();
 		finish_wait(&tctx->wait, &wait);
 	} while (1);
 	atomic_dec(&tctx->in_idle);
 
 	io_uring_clean_tctx(tctx);
-	if (!files) {
+	if (cancel_all) {
 		/* for exec all current's requests should be gone, kill tctx */
 		__io_uring_free(current);
 	}
-- 
2.31.1

