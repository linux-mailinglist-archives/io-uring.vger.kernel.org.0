Return-Path: <io-uring+bounces-4364-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 76DFD9BA74D
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 18:51:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B5E69B2128F
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 17:51:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 510227080F;
	Sun,  3 Nov 2024 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="nEuifwto"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ADEB139D1E
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 17:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730656277; cv=none; b=GqKIMBdpKz+DhuGQYCgUVid+RCkzkww68r4+b2eRF4GGkOVew6mRQ9jommldxPe4cDKeWNsNqmqkgU+Vq30rWHuKl7OgR9H6YqHSBAaeag3K0qRcZ0FK5grK5hS0Nm2zKchciPa25GJDdIhVZRkIqehsVF4WcVHGE1l4wtuRHM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730656277; c=relaxed/simple;
	bh=KrV1SvLs8gqak6ZGB0xFXD31exMNJLbqc+BvRMdSU4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JXoUfxmqslmdbjoXC5e76RcNIJAmi5ZXrDVVWetwQpGXg2y8ck3TSFFB24LPBuGMML5GYRRN/9YLdsXG8l+BLDMOWNJTGRHF2xEC+SHaNN8VsAQb70Ejf81IrQe1qKrGe+c42TSFMDwA9OM0NJGfWhmY6WW0u2b0fjtVpMiA4ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=nEuifwto; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-71e70c32cd7so3161151b3a.1
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 09:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730656273; x=1731261073; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZB9yhZy++aY1BShlUhDLQwTugEC+6TX2zcOoMR/l9y0=;
        b=nEuifwtom3CyrjgXMc8XFycKI+kcUqACMJD/u8DdZY0tm1NWApw3qH1kTGQbpMuAVK
         6+gB5LGfqTRwxtCimHKZw31vmTzUAllFjr0MUOSBhIp+VjronBzJqlff+2vwlbSNeSUA
         yabqPX9pe49Oh0m/0NhLMcYLkQhCTbvbwKEJzDCaLkVwO7/OmrACMTu4kloCtykmsgp9
         VC06s/n73q5A3G1ht7/vjIK0Loqs2XJxJ81XomZXwzcbGpOe+9Gy59O3ZYl1ln9ileAG
         WDgMfDCC/UOeDuR/hPqFNo3uYxltIs3l02cBDrRQyueUy0NXJ9baqwhiOqJC28HdgTUs
         BeRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730656273; x=1731261073;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZB9yhZy++aY1BShlUhDLQwTugEC+6TX2zcOoMR/l9y0=;
        b=N7Jj/cHYAvHs0bbRwl7Ft8trcxfUgoC2uU8xa+Ax9ZLolnGIMFIcfHg40pRxZwLzgE
         hd9/mf0/hGVy8R54Bq+GbnHcaJFwN3NQkciI6sRAq4hyHbvlTmM/E+jdgu/RmKYG9Wg2
         rIonF3X/euTrwV9NDRNOmmdIL/cA6qf3ABOivXDSmScWqtK2Y95X8MjpFwoPVb7QW8Ik
         m8/b6Y0DNm2iXugepz0SgvIxaMac4GSN3Izc66aG9iVwRwDmI6FERC6/cvRmS7AD2dB5
         /WltBMrOisH7JX2t17S+sqdkvRKYBY30P11U9sJste8klGPtGoaXCEvBRBSLsWAsnIfe
         CK2g==
X-Gm-Message-State: AOJu0YwZ+OOI4hbZOoevzosRf778SZ6Zxn+XjD9btmKvdrIUHqpv1tWG
	QcTwdKKmw3FKbTtzBHfhB2TAHlzxZ8ScC2Bomy62EIlnM4bq6Xf2YBt06f3vVjhvGI3zxHbaE0/
	7QXU=
X-Google-Smtp-Source: AGHT+IEP3Gmh4YNPlGaPnfM6BaDn/RaUQy3tuX7kMgao9fz4Bmgvvm35KLvZGbBZK6pbJAMdAseTpw==
X-Received: by 2002:a05:6a00:80c:b0:714:2069:d90e with SMTP id d2e1a72fcca58-7206309353dmr38867663b3a.26.1730656272985;
        Sun, 03 Nov 2024 09:51:12 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1ed4e6sm5875109b3a.80.2024.11.03.09.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 09:51:11 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring: move cancelations to be io_uring_task based
Date: Sun,  3 Nov 2024 10:49:33 -0700
Message-ID: <20241103175108.76460-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241103175108.76460-1-axboe@kernel.dk>
References: <20241103175108.76460-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Right now the task_struct pointer is used as the key to match a task,
but in preparation for some io_kiocb changes, move it to using struct
io_uring_task instead. No functional changes intended in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/futex.c     |  4 ++--
 io_uring/futex.h     |  4 ++--
 io_uring/io_uring.c  | 42 +++++++++++++++++++++---------------------
 io_uring/io_uring.h  |  2 +-
 io_uring/poll.c      |  4 ++--
 io_uring/poll.h      |  2 +-
 io_uring/timeout.c   |  8 ++++----
 io_uring/timeout.h   |  2 +-
 io_uring/uring_cmd.c |  4 ++--
 io_uring/uring_cmd.h |  2 +-
 io_uring/waitid.c    |  4 ++--
 io_uring/waitid.h    |  2 +-
 12 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 914848f46beb..e29662f039e1 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -141,7 +141,7 @@ int io_futex_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 	return -ENOENT;
 }
 
-bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
+bool io_futex_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			 bool cancel_all)
 {
 	struct hlist_node *tmp;
@@ -151,7 +151,7 @@ bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
 	lockdep_assert_held(&ctx->uring_lock);
 
 	hlist_for_each_entry_safe(req, tmp, &ctx->futex_list, hash_node) {
-		if (!io_match_task_safe(req, task, cancel_all))
+		if (!io_match_task_safe(req, tctx, cancel_all))
 			continue;
 		hlist_del_init(&req->hash_node);
 		__io_futex_cancel(ctx, req);
diff --git a/io_uring/futex.h b/io_uring/futex.h
index b8bb09873d57..d789fcf715e3 100644
--- a/io_uring/futex.h
+++ b/io_uring/futex.h
@@ -11,7 +11,7 @@ int io_futex_wake(struct io_kiocb *req, unsigned int issue_flags);
 #if defined(CONFIG_FUTEX)
 int io_futex_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		    unsigned int issue_flags);
-bool io_futex_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
+bool io_futex_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			 bool cancel_all);
 bool io_futex_cache_init(struct io_ring_ctx *ctx);
 void io_futex_cache_free(struct io_ring_ctx *ctx);
@@ -23,7 +23,7 @@ static inline int io_futex_cancel(struct io_ring_ctx *ctx,
 	return 0;
 }
 static inline bool io_futex_remove_all(struct io_ring_ctx *ctx,
-				       struct task_struct *task, bool cancel_all)
+				       struct io_uring_task *tctx, bool cancel_all)
 {
 	return false;
 }
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5b421e67c031..701cbd4670d8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -143,7 +143,7 @@ struct io_defer_entry {
 #define IO_CQ_WAKE_FORCE	(IO_CQ_WAKE_INIT >> 1)
 
 static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
-					 struct task_struct *task,
+					 struct io_uring_task *tctx,
 					 bool cancel_all);
 
 static void io_queue_sqe(struct io_kiocb *req);
@@ -202,12 +202,12 @@ static bool io_match_linked(struct io_kiocb *head)
  * As io_match_task() but protected against racing with linked timeouts.
  * User must not hold timeout_lock.
  */
-bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
+bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
 			bool cancel_all)
 {
 	bool matched;
 
-	if (task && head->task != task)
+	if (tctx && head->task->io_uring != tctx)
 		return false;
 	if (cancel_all)
 		return true;
@@ -3286,7 +3286,7 @@ static int io_uring_release(struct inode *inode, struct file *file)
 }
 
 struct io_task_cancel {
-	struct task_struct *task;
+	struct io_uring_task *tctx;
 	bool all;
 };
 
@@ -3295,11 +3295,11 @@ static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_task_cancel *cancel = data;
 
-	return io_match_task_safe(req, cancel->task, cancel->all);
+	return io_match_task_safe(req, cancel->tctx, cancel->all);
 }
 
 static __cold bool io_cancel_defer_files(struct io_ring_ctx *ctx,
-					 struct task_struct *task,
+					 struct io_uring_task *tctx,
 					 bool cancel_all)
 {
 	struct io_defer_entry *de;
@@ -3307,7 +3307,7 @@ static __cold bool io_cancel_defer_files(struct io_ring_ctx *ctx,
 
 	spin_lock(&ctx->completion_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
-		if (io_match_task_safe(de->req, task, cancel_all)) {
+		if (io_match_task_safe(de->req, tctx, cancel_all)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
@@ -3350,11 +3350,10 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 }
 
 static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
-						struct task_struct *task,
+						struct io_uring_task *tctx,
 						bool cancel_all)
 {
-	struct io_task_cancel cancel = { .task = task, .all = cancel_all, };
-	struct io_uring_task *tctx = task ? task->io_uring : NULL;
+	struct io_task_cancel cancel = { .tctx = tctx, .all = cancel_all, };
 	enum io_wq_cancel cret;
 	bool ret = false;
 
@@ -3368,9 +3367,9 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	if (!ctx->rings)
 		return false;
 
-	if (!task) {
+	if (!tctx) {
 		ret |= io_uring_try_cancel_iowq(ctx);
-	} else if (tctx && tctx->io_wq) {
+	} else if (tctx->io_wq) {
 		/*
 		 * Cancels requests of all rings, not only @ctx, but
 		 * it's fine as the task is in exit/exec.
@@ -3393,15 +3392,15 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    io_allowed_defer_tw_run(ctx))
 		ret |= io_run_local_work(ctx, INT_MAX) > 0;
-	ret |= io_cancel_defer_files(ctx, task, cancel_all);
+	ret |= io_cancel_defer_files(ctx, tctx, cancel_all);
 	mutex_lock(&ctx->uring_lock);
-	ret |= io_poll_remove_all(ctx, task, cancel_all);
-	ret |= io_waitid_remove_all(ctx, task, cancel_all);
-	ret |= io_futex_remove_all(ctx, task, cancel_all);
-	ret |= io_uring_try_cancel_uring_cmd(ctx, task, cancel_all);
+	ret |= io_poll_remove_all(ctx, tctx, cancel_all);
+	ret |= io_waitid_remove_all(ctx, tctx, cancel_all);
+	ret |= io_futex_remove_all(ctx, tctx, cancel_all);
+	ret |= io_uring_try_cancel_uring_cmd(ctx, tctx, cancel_all);
 	mutex_unlock(&ctx->uring_lock);
-	ret |= io_kill_timeouts(ctx, task, cancel_all);
-	if (task)
+	ret |= io_kill_timeouts(ctx, tctx, cancel_all);
+	if (tctx)
 		ret |= io_run_task_work() > 0;
 	else
 		ret |= flush_delayed_work(&ctx->fallback_work);
@@ -3454,12 +3453,13 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 				if (node->ctx->sq_data)
 					continue;
 				loop |= io_uring_try_cancel_requests(node->ctx,
-							current, cancel_all);
+							current->io_uring,
+							cancel_all);
 			}
 		} else {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				loop |= io_uring_try_cancel_requests(ctx,
-								     current,
+								     current->io_uring,
 								     cancel_all);
 		}
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 52d15ac8d209..14d73a727320 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -116,7 +116,7 @@ void io_queue_next(struct io_kiocb *req);
 void io_task_refs_refill(struct io_uring_task *tctx);
 bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 
-bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
+bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
 			bool cancel_all);
 
 void io_activate_pollwq(struct io_ring_ctx *ctx);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 2d6698fb7400..7db3010b5733 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -714,7 +714,7 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 /*
  * Returns true if we found and killed one or more poll requests
  */
-__cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
+__cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			       bool cancel_all)
 {
 	unsigned nr_buckets = 1U << ctx->cancel_table.hash_bits;
@@ -729,7 +729,7 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
 
 		hlist_for_each_entry_safe(req, tmp, &hb->list, hash_node) {
-			if (io_match_task_safe(req, tsk, cancel_all)) {
+			if (io_match_task_safe(req, tctx, cancel_all)) {
 				hlist_del_init(&req->hash_node);
 				io_poll_cancel_req(req);
 				found = true;
diff --git a/io_uring/poll.h b/io_uring/poll.h
index b0e3745f5a29..04ede93113dc 100644
--- a/io_uring/poll.h
+++ b/io_uring/poll.h
@@ -40,7 +40,7 @@ struct io_cancel_data;
 int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		   unsigned issue_flags);
 int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags);
-bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
+bool io_poll_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			bool cancel_all);
 
 void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index ed6c74f1a475..31fbea366d43 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -643,13 +643,13 @@ void io_queue_linked_timeout(struct io_kiocb *req)
 	io_put_req(req);
 }
 
-static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
+static bool io_match_task(struct io_kiocb *head, struct io_uring_task *tctx,
 			  bool cancel_all)
 	__must_hold(&head->ctx->timeout_lock)
 {
 	struct io_kiocb *req;
 
-	if (task && head->task != task)
+	if (tctx && head->task->io_uring != tctx)
 		return false;
 	if (cancel_all)
 		return true;
@@ -662,7 +662,7 @@ static bool io_match_task(struct io_kiocb *head, struct task_struct *task,
 }
 
 /* Returns true if we found and killed one or more timeouts */
-__cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
+__cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			     bool cancel_all)
 {
 	struct io_timeout *timeout, *tmp;
@@ -677,7 +677,7 @@ __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
 
-		if (io_match_task(req, tsk, cancel_all) &&
+		if (io_match_task(req, tctx, cancel_all) &&
 		    io_kill_timeout(req, -ECANCELED))
 			canceled++;
 	}
diff --git a/io_uring/timeout.h b/io_uring/timeout.h
index a6939f18313e..e91b32448dcf 100644
--- a/io_uring/timeout.h
+++ b/io_uring/timeout.h
@@ -24,7 +24,7 @@ static inline struct io_kiocb *io_disarm_linked_timeout(struct io_kiocb *req)
 __cold void io_flush_timeouts(struct io_ring_ctx *ctx);
 struct io_cancel_data;
 int io_timeout_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd);
-__cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
+__cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			     bool cancel_all);
 void io_queue_linked_timeout(struct io_kiocb *req);
 void io_disarm_next(struct io_kiocb *req);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 88a73d21fc0b..f88fbc9869d0 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -47,7 +47,7 @@ static void io_req_uring_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 }
 
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
-				   struct task_struct *task, bool cancel_all)
+				   struct io_uring_task *tctx, bool cancel_all)
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
@@ -61,7 +61,7 @@ bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				struct io_uring_cmd);
 		struct file *file = req->file;
 
-		if (!cancel_all && req->task != task)
+		if (!cancel_all && req->task->io_uring != tctx)
 			continue;
 
 		if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index a361f98664d2..7dba0f1efc58 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -8,4 +8,4 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
-				   struct task_struct *task, bool cancel_all);
+				   struct io_uring_task *tctx, bool cancel_all);
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 6362ec20abc0..9b7c23f96c47 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -184,7 +184,7 @@ int io_waitid_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 	return -ENOENT;
 }
 
-bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
+bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			  bool cancel_all)
 {
 	struct hlist_node *tmp;
@@ -194,7 +194,7 @@ bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
 	lockdep_assert_held(&ctx->uring_lock);
 
 	hlist_for_each_entry_safe(req, tmp, &ctx->waitid_list, hash_node) {
-		if (!io_match_task_safe(req, task, cancel_all))
+		if (!io_match_task_safe(req, tctx, cancel_all))
 			continue;
 		hlist_del_init(&req->hash_node);
 		__io_waitid_cancel(ctx, req);
diff --git a/io_uring/waitid.h b/io_uring/waitid.h
index 956a8adafe8c..d5544aaf302a 100644
--- a/io_uring/waitid.h
+++ b/io_uring/waitid.h
@@ -11,5 +11,5 @@ int io_waitid_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_waitid(struct io_kiocb *req, unsigned int issue_flags);
 int io_waitid_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		     unsigned int issue_flags);
-bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct task_struct *task,
+bool io_waitid_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 			  bool cancel_all);
-- 
2.45.2


