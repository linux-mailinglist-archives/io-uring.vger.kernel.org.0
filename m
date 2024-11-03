Return-Path: <io-uring+bounces-4366-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 645429BA74C
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 18:51:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 218F2281A8F
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 17:51:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E592B1487C8;
	Sun,  3 Nov 2024 17:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3bCSUMa5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9157139D1E
	for <io-uring@vger.kernel.org>; Sun,  3 Nov 2024 17:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730656279; cv=none; b=lF+lSE9z9ahRQSxfZPr2CLtT9vNIIo5M+DcaPMqO+DxFDnmwL7T2OrikjIb6kYm6SKQ7aNI3uvjLkTdzY1NFQJHrq59X2M8F0qcO4jNr5FyD8gR/HUH83wU/pz8K426TEgA0fwOMegAfnutDZUyCT+xKwCYuuEJsHeZVll3UhTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730656279; c=relaxed/simple;
	bh=AUDA0pET7klyxWwdKpjY9lWaCeZLFOpHDMBt4zZ43ZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sMUZWEbJj+56w6CQdWSDWl0PzkW7nhSeP8NS+7WSqQnRvae6WZLvbmAOvhimci0cHCVfpc1nCoSdPSsmzemLBGJMLKrJZZZV1iBJmYIs9h20tzCDIAsdphCPvQubCvchB6T8Rk36XOJDPvw8/3M9mr9+Bvt7rl5m24lflBzTrXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3bCSUMa5; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-71e79f73aaeso2884559b3a.3
        for <io-uring@vger.kernel.org>; Sun, 03 Nov 2024 09:51:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730656276; x=1731261076; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lvB2O7oUaXac56tCaXihhZnUr9lki2+NffJN6XII4Is=;
        b=3bCSUMa5aR4u9bOxMWOFk87pdzcswe/4oxDc3nWLkLxALekBTZdcPv1Wg786yJH/Vu
         9/pzlaUy7Ql7vh6wrlb521gwdqDdxOLtuDmUQKsJyJv0+p1nmiggP2rmg53z8cS0Fi/t
         k/PI6Um7fqbStGQ7HVx8/+f96AX6ucscGM/G/Ipm+/s0SBSEyijGP6dtgPZsoruE5t/F
         FPCmc3CRXix/8K6ANwqfjqJEePaDHkHgbhm6JeosPKLq08OBDffFwGubOLUCNLYRfN6Q
         2J2eYr3QntgvtPcz4Byf5vLf7vMl/+Z5udoGlDlHFz+ufV73hB3YfB567Vqg2K8i2E4w
         ckJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730656276; x=1731261076;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lvB2O7oUaXac56tCaXihhZnUr9lki2+NffJN6XII4Is=;
        b=JF1uvz0TsRm4Wmhb5xySpujeq7gb1AXt9+z1WiM088US69Qz5z3YvA/ZnqTdDDfOAl
         E0jRc9SUOBNgI0lgootvP/aFvrk4h8lK3t9txGY6wlAZXqlJi6WXcxN74/Vusbtx7X45
         Jq9LhVEnuvxnK+zuzC0EPB9Q+32bXfSl7pEIGVfy2b4wTuv87zjzFzErr2FSjaFu35nV
         eAbGPOjLbke8UH9YmaJ9ENFZE83cNY3Sh0q9E2f+GOS40gLz3CrZUu/1HwFgjF96c2Tk
         eBXvxGvIL6Seq9LqLUr/wx+NITQLjH6NkloUC1lUiyk9JK5j9cKxPZ+HOt1g4YA6uDFX
         Q9rQ==
X-Gm-Message-State: AOJu0YxByywB3MrC5HUMvzFVNyHAoi0J1hsBKg5r5pqDmJAEvucPwZOE
	m41ePll+x6tKmxab7RiQ7uKITWo847DDAkBRcKBs+fv9J+PJ/B7ah+mRsfptpFkIjAlo6BApiBx
	rSmQ=
X-Google-Smtp-Source: AGHT+IG7TjjwQNsZm1nnNwpW12fSoL6ACP+gwyN+DrPCcSZjA8tn678IKvUglm69doJk9cXme9IlGA==
X-Received: by 2002:a05:6a21:164e:b0:1d9:87e3:120c with SMTP id adf61e73a8af0-1d9a851e807mr41207101637.32.1730656276441;
        Sun, 03 Nov 2024 09:51:16 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc1ed4e6sm5875109b3a.80.2024.11.03.09.51.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Nov 2024 09:51:15 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: move struct io_kiocb from task_struct to io_uring_task
Date: Sun,  3 Nov 2024 10:49:35 -0700
Message-ID: <20241103175108.76460-4-axboe@kernel.dk>
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

Rather than store the task_struct itself in struct io_kiocb, store
the io_uring specific task_struct. The life times are the same in terms
of io_uring, and this avoids doing some dereferences through the
task_struct. For the hot path of putting local task references, we can
deref req->tctx instead, which we'll need anyway in that function
regardless of whether it's local or remote references.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring/cmd.h   |  2 +-
 include/linux/io_uring_types.h |  3 ++-
 io_uring/cancel.c              |  2 +-
 io_uring/fdinfo.c              |  2 +-
 io_uring/io_uring.c            | 34 +++++++++++++++-------------------
 io_uring/msg_ring.c            |  4 ++--
 io_uring/notif.c               |  4 ++--
 io_uring/poll.c                |  3 +--
 io_uring/rw.c                  |  2 +-
 io_uring/tctx.c                |  1 +
 io_uring/timeout.c             |  6 +++---
 io_uring/uring_cmd.c           |  2 +-
 io_uring/waitid.c              |  2 +-
 13 files changed, 32 insertions(+), 35 deletions(-)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index c189d36ad55e..578a3fdf5c71 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -110,7 +110,7 @@ static inline void io_uring_cmd_complete_in_task(struct io_uring_cmd *ioucmd,
 
 static inline struct task_struct *io_uring_cmd_get_task(struct io_uring_cmd *cmd)
 {
-	return cmd_to_io_kiocb(cmd)->task;
+	return cmd_to_io_kiocb(cmd)->tctx->task;
 }
 
 #endif /* _LINUX_IO_URING_CMD_H */
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index a87927a392f2..ad5001102c86 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -84,6 +84,7 @@ struct io_uring_task {
 	/* submission side */
 	int				cached_refs;
 	const struct io_ring_ctx 	*last;
+	struct task_struct		*task;
 	struct io_wq			*io_wq;
 	struct file			*registered_rings[IO_RINGFD_REG_MAX];
 
@@ -633,7 +634,7 @@ struct io_kiocb {
 	struct io_cqe			cqe;
 
 	struct io_ring_ctx		*ctx;
-	struct task_struct		*task;
+	struct io_uring_task		*tctx;
 
 	union {
 		/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index bbca5cb69cb5..484193567839 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -205,7 +205,7 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 		.opcode	= cancel->opcode,
 		.seq	= atomic_inc_return(&req->ctx->cancel_seq),
 	};
-	struct io_uring_task *tctx = req->task->io_uring;
+	struct io_uring_task *tctx = req->tctx;
 	int ret;
 
 	if (cd.flags & IORING_ASYNC_CANCEL_FD) {
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 8da0d9e4533a..efbec34ccb18 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -203,7 +203,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 
 		hlist_for_each_entry(req, &hb->list, hash_node)
 			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
-					task_work_pending(req->task));
+					task_work_pending(req->tctx->task));
 	}
 
 	if (has_lock)
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 496f61de0f9b..d9a6a8703563 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -207,7 +207,7 @@ bool io_match_task_safe(struct io_kiocb *head, struct io_uring_task *tctx,
 {
 	bool matched;
 
-	if (tctx && head->task->io_uring != tctx)
+	if (tctx && head->tctx != tctx)
 		return false;
 	if (cancel_all)
 		return true;
@@ -408,11 +408,8 @@ static void io_clean_op(struct io_kiocb *req)
 		kfree(req->apoll);
 		req->apoll = NULL;
 	}
-	if (req->flags & REQ_F_INFLIGHT) {
-		struct io_uring_task *tctx = req->task->io_uring;
-
-		atomic_dec(&tctx->inflight_tracked);
-	}
+	if (req->flags & REQ_F_INFLIGHT)
+		atomic_dec(&req->tctx->inflight_tracked);
 	if (req->flags & REQ_F_CREDS)
 		put_cred(req->creds);
 	if (req->flags & REQ_F_ASYNC_DATA) {
@@ -426,7 +423,7 @@ static inline void io_req_track_inflight(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_INFLIGHT)) {
 		req->flags |= REQ_F_INFLIGHT;
-		atomic_inc(&req->task->io_uring->inflight_tracked);
+		atomic_inc(&req->tctx->inflight_tracked);
 	}
 }
 
@@ -515,7 +512,7 @@ static void io_prep_async_link(struct io_kiocb *req)
 static void io_queue_iowq(struct io_kiocb *req)
 {
 	struct io_kiocb *link = io_prep_linked_timeout(req);
-	struct io_uring_task *tctx = req->task->io_uring;
+	struct io_uring_task *tctx = req->tctx;
 
 	BUG_ON(!tctx);
 	BUG_ON(!tctx->io_wq);
@@ -530,7 +527,7 @@ static void io_queue_iowq(struct io_kiocb *req)
 	 * procedure rather than attempt to run this request (or create a new
 	 * worker for it).
 	 */
-	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
+	if (WARN_ON_ONCE(!same_thread_group(tctx->task, current)))
 		atomic_or(IO_WQ_WORK_CANCEL, &req->work.flags);
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
@@ -679,17 +676,17 @@ static void io_cqring_do_overflow_flush(struct io_ring_ctx *ctx)
 }
 
 /* must to be called somewhat shortly after putting a request */
-static inline void io_put_task(struct task_struct *task)
+static inline void io_put_task(struct io_kiocb *req)
 {
-	struct io_uring_task *tctx = task->io_uring;
+	struct io_uring_task *tctx = req->tctx;
 
-	if (likely(task == current)) {
+	if (likely(tctx->task == current)) {
 		tctx->cached_refs++;
 	} else {
 		percpu_counter_sub(&tctx->inflight, 1);
 		if (unlikely(atomic_read(&tctx->in_cancel)))
 			wake_up(&tctx->wait);
-		put_task_struct(task);
+		put_task_struct(tctx->task);
 	}
 }
 
@@ -1340,7 +1337,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req,
 
 static void io_req_normal_work_add(struct io_kiocb *req)
 {
-	struct io_uring_task *tctx = req->task->io_uring;
+	struct io_uring_task *tctx = req->tctx;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	/* task_work already pending, we're done */
@@ -1359,7 +1356,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 		return;
 	}
 
-	if (likely(!task_work_add(req->task, &tctx->task_work, ctx->notify_method)))
+	if (likely(!task_work_add(tctx->task, &tctx->task_work, ctx->notify_method)))
 		return;
 
 	io_fallback_tw(tctx, false);
@@ -1476,8 +1473,7 @@ static void io_req_task_cancel(struct io_kiocb *req, struct io_tw_state *ts)
 void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	io_tw_lock(req->ctx, ts);
-	/* req->task == current here, checking PF_EXITING is safe */
-	if (unlikely(req->task->flags & PF_EXITING))
+	if (unlikely(current->flags & PF_EXITING))
 		io_req_defer_failed(req, -EFAULT);
 	else if (req->flags & REQ_F_FORCE_ASYNC)
 		io_queue_iowq(req);
@@ -1561,7 +1557,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 		}
 		io_put_file(req);
 		io_req_put_rsrc_nodes(req);
-		io_put_task(req->task);
+		io_put_task(req);
 
 		node = req->comp_list.next;
 		io_req_add_to_cache(req, ctx);
@@ -2181,7 +2177,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->flags = (__force io_req_flags_t) sqe_flags;
 	req->cqe.user_data = READ_ONCE(sqe->user_data);
 	req->file = NULL;
-	req->task = current;
+	req->tctx = current->io_uring;
 	req->cancel_seq_set = false;
 
 	if (unlikely(opcode >= IORING_OP_LAST)) {
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 99af39e1d0fb..e63af34004b7 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -89,8 +89,8 @@ static void io_msg_tw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 static int io_msg_remote_post(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			      int res, u32 cflags, u64 user_data)
 {
-	req->task = READ_ONCE(ctx->submitter_task);
-	if (!req->task) {
+	req->tctx = READ_ONCE(ctx->submitter_task->io_uring);
+	if (!req->tctx) {
 		kmem_cache_free(req_cachep, req);
 		return -EOWNERDEAD;
 	}
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 8dfbb0bd8e4d..ee3a33510b3c 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -89,7 +89,7 @@ static int io_link_skb(struct sk_buff *skb, struct ubuf_info *uarg)
 
 	/* make sure all noifications can be finished in the same task_work */
 	if (unlikely(notif->ctx != prev_notif->ctx ||
-		     notif->task != prev_notif->task))
+		     notif->tctx != prev_notif->tctx))
 		return -EEXIST;
 
 	nd->head = prev_nd->head;
@@ -115,7 +115,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	notif->opcode = IORING_OP_NOP;
 	notif->flags = 0;
 	notif->file = NULL;
-	notif->task = current;
+	notif->tctx = current->io_uring;
 	io_get_task_refs(1);
 	notif->file_node = NULL;
 	notif->buf_node = NULL;
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 7db3010b5733..56332893a4b0 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -224,8 +224,7 @@ static int io_poll_check_events(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	int v;
 
-	/* req->task == current here, checking PF_EXITING is safe */
-	if (unlikely(req->task->flags & PF_EXITING))
+	if (unlikely(current->flags & PF_EXITING))
 		return -ECANCELED;
 
 	do {
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 144730344c0f..e368b9afde03 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -435,7 +435,7 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 	 * Play it safe and assume not safe to re-import and reissue if we're
 	 * not in the original thread group (or in task context).
 	 */
-	if (!same_thread_group(req->task, current) || !in_task())
+	if (!same_thread_group(req->tctx->task, current) || !in_task())
 		return false;
 	return true;
 }
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index c043fe93a3f2..503f3ff8bc4f 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -81,6 +81,7 @@ __cold int io_uring_alloc_task_context(struct task_struct *task,
 		return ret;
 	}
 
+	tctx->task = task;
 	xa_init(&tctx->xa);
 	init_waitqueue_head(&tctx->wait);
 	atomic_set(&tctx->in_cancel, 0);
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 31fbea366d43..fd1f58f68fa1 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -305,13 +305,13 @@ static void io_req_task_link_timeout(struct io_kiocb *req, struct io_tw_state *t
 	int ret = -ENOENT;
 
 	if (prev) {
-		if (!(req->task->flags & PF_EXITING)) {
+		if (!(current->flags & PF_EXITING)) {
 			struct io_cancel_data cd = {
 				.ctx		= req->ctx,
 				.data		= prev->cqe.user_data,
 			};
 
-			ret = io_try_cancel(req->task->io_uring, &cd, 0);
+			ret = io_try_cancel(req->tctx, &cd, 0);
 		}
 		io_req_set_res(req, ret ?: -ETIME, 0);
 		io_req_task_complete(req, ts);
@@ -649,7 +649,7 @@ static bool io_match_task(struct io_kiocb *head, struct io_uring_task *tctx,
 {
 	struct io_kiocb *req;
 
-	if (tctx && head->task->io_uring != tctx)
+	if (tctx && head->tctx != tctx)
 		return false;
 	if (cancel_all)
 		return true;
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index f88fbc9869d0..40b8b777ba12 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -61,7 +61,7 @@ bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 				struct io_uring_cmd);
 		struct file *file = req->file;
 
-		if (!cancel_all && req->task->io_uring != tctx)
+		if (!cancel_all && req->tctx != tctx)
 			continue;
 
 		if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 9b7c23f96c47..daef5dd644f0 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -331,7 +331,7 @@ int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
 	hlist_add_head(&req->hash_node, &ctx->waitid_list);
 
 	init_waitqueue_func_entry(&iwa->wo.child_wait, io_waitid_wait);
-	iwa->wo.child_wait.private = req->task;
+	iwa->wo.child_wait.private = req->tctx->task;
 	iw->head = &current->signal->wait_chldexit;
 	add_wait_queue(iw->head, &iwa->wo.child_wait);
 
-- 
2.45.2


