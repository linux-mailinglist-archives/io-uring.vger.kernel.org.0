Return-Path: <io-uring+bounces-10806-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1466C877BA
	for <lists+io-uring@lfdr.de>; Wed, 26 Nov 2025 00:40:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5F50D3B5FAF
	for <lists+io-uring@lfdr.de>; Tue, 25 Nov 2025 23:40:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 211032F068C;
	Tue, 25 Nov 2025 23:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Ro57Z19t"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 345E02F260C
	for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 23:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764113987; cv=none; b=AuCI8T55Pw4g6qFFgdnVlk5FYomuJmT/PCpnhpkU9jDFnM7/nNrs/EKzDrrAX9rQd2mTL9YC530kL9Z2V9LGbCzc6IfrhH87cjwzi0q7OI3wv4SA+SpyA9wHLSTCcLBRokBZn/Gwjxh0FcYjpKvAYitpsKicjWdALLH4ko6YyYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764113987; c=relaxed/simple;
	bh=zzSnmJEub77QXmuVB0ktRkpeRZUFxtBXKb7u39w7wIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dIc4B3mVdDiTNcgcZ5pP8XGb6CVSLvaAM9LGHb2oNkP5Py9YDn2o7m32GIEO2ptjjn5XKQYfM/QW6W+7n9c6X8pkleS+zt1mXYu1BHJ1hSVhIyO7czpLnXIugjql4oP1Aaw60BfwGf1xx1FsrCr/s70FBtQVmeRcPu+YaraCxFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Ro57Z19t; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-3436b2dbfb9so856284a91.0
        for <io-uring@vger.kernel.org>; Tue, 25 Nov 2025 15:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1764113981; x=1764718781; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=H+ywcbrfo4sjCpAz5caosn8SI3IUkTEI5mPINT/19bw=;
        b=Ro57Z19ttFDgRNCdm4zc6blozlsmRiqXt3AZLf//sBgROYU5tV7Vo4ijknEZeEkVLd
         ceP6Sc9VcvWwP1KBQ8EpeHG5IxUk4WhcyMPKxCiApVHN0rLv/tjyHLFieY5WwoPfBXdH
         CO/8UZXEWwuQDkhkYDLLL/XvWJLmHwbHxBWxUWO6fC3tuqyhM4AX29p2stu6gU/3hGGx
         F37qWWiIAX/RhcuETJjE1mZI7zEgxTJURIilUfIFBGAoiLOEuEb57jYQYTOPfPNRVmUY
         HSj7l3bRmsO4Bdwh4ETNf9Vfa+eLt6Td/oJ2buN653LZ2SkzMJt3CwTBt/OeVOHmkLHc
         XB1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764113981; x=1764718781;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=H+ywcbrfo4sjCpAz5caosn8SI3IUkTEI5mPINT/19bw=;
        b=iZJWTGa7zK40+IJpN2RcjyEros8vX4AvpEtNrbUeVEv4wbH6BH12GSHjh+rCrNzdoS
         WrUkAJG/MT9W5ayrTtABpxzo33IghYD1xEsW87r0z02/CA/CmOonaqMyMvUkHwdYHUUp
         L/yZlMBVAXlTIek9AXi6/RY8c5sXUAiwByxIQs2mvhxLO+vZ2O1ItPt0/vH/zW2w1pid
         cNLVB9Dbewh+8AqbltygkybCBZ3K/nMofc39jv7NkhaaKB7e38JL55HYH2HHa7zX98hg
         L6sblDIaaSs+SF802LDK38YC7g59huobvU30W4KhQJ1UhyIPus4mOq/rM7IPbavWhsCa
         RbEw==
X-Gm-Message-State: AOJu0Yw20DIlggajl7crqtKq1/3ocAVxO0JeF1oqmyuAgYr6jqxxmBzc
	dpNQO40+YlGtZsErrIQUIVKZdlVDGHgkO3nezz7vnUaPjAGYr7vZ9hRCOkyeBZIvCdD/J9pkqWL
	enC6l02TEEh1TklcZnKfa56tLcbHKlbyX/0V/
X-Gm-Gg: ASbGncvRY7GB6jk/lXY+oMCnhOFuJmTinHLaMN6uhNkdLwjqMnNhN1sBJCUr2ZJACZb
	lq5sj5IDWORAC++lw2w0ZlVxOEyTyJ9cd5sjMbap81jGr/AnpfxG7odnyS77ujS6jJe3kPYJz+M
	CZeOF+t1djaEkQZZC4CkwXUyY0V7wufZry3hyatJQIRfqFsIPw27sKmuHruvz5rUtf13daZQcBJ
	GiptoLk7O12yeC5oEoMY6UxUS6ZD2OXiElgAsX3Ngi7fjuF2G0jV2vxxeE11orOIiDDYTX3YitC
	mT1qTbPncUaD60pMJqTpBba0RJiE+BnnEsJTfeLxylwTCiVzxTkq27cekVtEMYe7M/Be5IIS8P+
	k2fzWYsdiuP+KxY9Ts/HFw2CEU9BVwLHEf5uKtj02dA==
X-Google-Smtp-Source: AGHT+IHAJ6SfmLkSspJpXWCu6pb+0LseTsaErcP1cQ1yalrt1QxRX8WtTLeZ3GVoNxGAZWnHn3c2VamJcQPi
X-Received: by 2002:a05:6a20:6a26:b0:35d:3b70:762c with SMTP id adf61e73a8af0-3614eb3a8c6mr11619479637.2.1764113981176;
        Tue, 25 Nov 2025 15:39:41 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id 41be03b00d2f7-bd75dfedd7fsm1000974a12.1.2025.11.25.15.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Nov 2025 15:39:41 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 85550340185;
	Tue, 25 Nov 2025 16:39:40 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 83759E41EF2; Tue, 25 Nov 2025 16:39:40 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 3/4] io_uring: factor out uring_lock helpers
Date: Tue, 25 Nov 2025 16:39:27 -0700
Message-ID: <20251125233928.3962947-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20251125233928.3962947-1-csander@purestorage.com>
References: <20251125233928.3962947-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A subsequent commit will skip acquiring the io_ring_ctx uring_lock in
io_uring_enter() and io_handle_tw_list() for IORING_SETUP_SINGLE_ISSUER.
Prepare for this change by factoring out the uring_lock accesses under
these functions into helpers. A separate set of helpers is provided for
the io_uring_register() syscall, as it will need a different locking
mechanism in IORING_SETUP_SINGLE_ISSUER mode. Aside from the helpers,
the only remaining access of uring_lock is its mutex_init() call.
Define a struct io_ring_ctx_lock_state to pass state from
io_ring_ctx_lock() to io_ring_ctx_unlock(). It's currently empty but
a subsequent commit will add fields.

Non-io_uring_register() helpers:
- io_ring_ctx_lock() for mutex_lock(&ctx->uring_lock)
- io_ring_ctx_trylock() for mutex_trylock(&ctx->uring_lock)
- io_ring_ctx_unlock() for mutex_unlock(&ctx->uring_lock)
- io_ring_ctx_assert_locked() for lockdep_assert_held(&ctx->uring_lock)

io_uring_register() helpers:
- io_ring_register_ctx_lock() for mutex_lock(&ctx->uring_lock)
- io_ring_register_ctx_lock_nested() for
  mutex_lock_nested(&ctx->uring_lock, ...)
- io_ring_register_ctx_unlock() for mutex_unlock(&ctx->uring_lock)
- io_ring_register_ctx_lock_held() for lockdep_is_held(&ctx->uring_lock)
- io_ring_register_ctx_assert_locked() for
  lockdep_assert_held(&ctx->uring_lock)
- must_hold_io_ring_register_ctx_lock for __must_hold(&ctx->uring_lock)
- releases_io_ring_register_ctx_lock for __releases(ctx->uring_lock)
- acquires_io_ring_register_ctx_lock for __acquires(ctx->uring_lock)

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 include/linux/io_uring_types.h |  12 +--
 io_uring/cancel.c              |  36 ++++---
 io_uring/eventfd.c             |   5 +-
 io_uring/fdinfo.c              |   6 +-
 io_uring/filetable.c           |   8 +-
 io_uring/futex.c               |  14 +--
 io_uring/io_uring.c            | 185 +++++++++++++++++++--------------
 io_uring/io_uring.h            | 109 ++++++++++++++++---
 io_uring/kbuf.c                |  38 ++++---
 io_uring/memmap.h              |   2 +-
 io_uring/msg_ring.c            |  29 ++++--
 io_uring/notif.c               |   5 +-
 io_uring/notif.h               |   3 +-
 io_uring/openclose.c           |  14 +--
 io_uring/poll.c                |  21 ++--
 io_uring/register.c            |  34 +++---
 io_uring/rsrc.c                |  37 ++++---
 io_uring/rsrc.h                |   3 +-
 io_uring/rw.c                  |   2 +-
 io_uring/splice.c              |   5 +-
 io_uring/sqpoll.c              |   5 +-
 io_uring/tctx.c                |  24 +++--
 io_uring/uring_cmd.c           |  13 ++-
 io_uring/waitid.c              |  13 +--
 io_uring/zcrx.c                |   2 +-
 25 files changed, 392 insertions(+), 233 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index e1adb0d20a0a..74d202394b20 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -86,11 +86,11 @@ struct io_mapped_region {
 
 /*
  * Return value from io_buffer_list selection, to avoid stashing it in
  * struct io_kiocb. For legacy/classic provided buffers, keeping a reference
  * across execution contexts are fine. But for ring provided buffers, the
- * list may go away as soon as ->uring_lock is dropped. As the io_kiocb
+ * list may go away as soon as the ctx uring lock is dropped. As the io_kiocb
  * persists, it's better to just keep the buffer local for those cases.
  */
 struct io_br_sel {
 	struct io_buffer_list *buf_list;
 	/*
@@ -231,11 +231,11 @@ struct io_submit_link {
 	struct io_kiocb		*head;
 	struct io_kiocb		*last;
 };
 
 struct io_submit_state {
-	/* inline/task_work completion list, under ->uring_lock */
+	/* inline/task_work completion list, under ctx uring lock */
 	struct io_wq_work_node	free_list;
 	/* batch completion logic */
 	struct io_wq_work_list	compl_reqs;
 	struct io_submit_link	link;
 
@@ -303,16 +303,16 @@ struct io_ring_ctx {
 		unsigned		cached_sq_head;
 		unsigned		sq_entries;
 
 		/*
 		 * Fixed resources fast path, should be accessed only under
-		 * uring_lock, and updated through io_uring_register(2)
+		 * ctx uring lock, and updated through io_uring_register(2)
 		 */
 		atomic_t		cancel_seq;
 
 		/*
-		 * ->iopoll_list is protected by the ctx->uring_lock for
+		 * ->iopoll_list is protected by the ctx uring lock for
 		 * io_uring instances that don't use IORING_SETUP_SQPOLL.
 		 * For SQPOLL, only the single threaded io_sq_thread() will
 		 * manipulate the list, hence no extra locking is needed there.
 		 */
 		bool			poll_multi_queue;
@@ -324,11 +324,11 @@ struct io_ring_ctx {
 		struct io_alloc_cache	imu_cache;
 
 		struct io_submit_state	submit_state;
 
 		/*
-		 * Modifications are protected by ->uring_lock and ->mmap_lock.
+		 * Modifications protected by ctx uring lock and ->mmap_lock.
 		 * The buffer list's io mapped region should be stable once
 		 * published.
 		 */
 		struct xarray		io_bl_xa;
 
@@ -467,11 +467,11 @@ struct io_ring_ctx {
 	struct io_mapped_region		param_region;
 };
 
 /*
  * Token indicating function is called in task work context:
- * ctx->uring_lock is held and any completions generated will be flushed.
+ * ctx uring lock is held and any completions generated will be flushed.
  * ONLY core io_uring.c should instantiate this struct.
  */
 struct io_tw_state {
 	bool cancel;
 };
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index ca12ac10c0ae..54ca7f15cb7b 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -168,10 +168,11 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static int __io_async_cancel(struct io_cancel_data *cd,
 			     struct io_uring_task *tctx,
 			     unsigned int issue_flags)
 {
 	bool all = cd->flags & (IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_ANY);
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = cd->ctx;
 	struct io_tctx_node *node;
 	int ret, nr = 0;
 
 	do {
@@ -182,21 +183,21 @@ static int __io_async_cancel(struct io_cancel_data *cd,
 			return ret;
 		nr++;
 	} while (1);
 
 	/* slow path, try all io-wq's */
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	ret = -ENOENT;
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		ret = io_async_cancel_one(node->task->io_uring, cd);
 		if (ret != -ENOENT) {
 			if (!all)
 				break;
 			nr++;
 		}
 	}
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	return all ? nr : ret;
 }
 
 int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -238,11 +239,11 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 static int __io_sync_cancel(struct io_uring_task *tctx,
 			    struct io_cancel_data *cd, int fd)
 {
 	struct io_ring_ctx *ctx = cd->ctx;
 
-	/* fixed must be grabbed every time since we drop the uring_lock */
+	/* fixed must be grabbed every time since we drop the ctx uring lock */
 	if ((cd->flags & IORING_ASYNC_CANCEL_FD) &&
 	    (cd->flags & IORING_ASYNC_CANCEL_FD_FIXED)) {
 		struct io_rsrc_node *node;
 
 		node = io_rsrc_node_lookup(&ctx->file_table.data, fd);
@@ -255,11 +256,11 @@ static int __io_sync_cancel(struct io_uring_task *tctx,
 
 	return __io_async_cancel(cd, tctx, 0);
 }
 
 int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
-	__must_hold(&ctx->uring_lock)
+	must_hold_io_ring_register_ctx_lock(ctx)
 {
 	struct io_cancel_data cd = {
 		.ctx	= ctx,
 		.seq	= atomic_inc_return(&ctx->cancel_seq),
 	};
@@ -317,11 +318,11 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
 
 		prepare_to_wait(&ctx->cq_wait, &wait, TASK_INTERRUPTIBLE);
 
 		ret = __io_sync_cancel(current->io_uring, &cd, sc.fd);
 
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_register_ctx_unlock(ctx);
 		if (ret != -EALREADY)
 			break;
 
 		ret = io_run_task_work_sig(ctx);
 		if (ret < 0)
@@ -329,15 +330,15 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
 		ret = schedule_hrtimeout(&timeout, HRTIMER_MODE_ABS);
 		if (!ret) {
 			ret = -ETIME;
 			break;
 		}
-		mutex_lock(&ctx->uring_lock);
+		io_ring_register_ctx_lock(ctx);
 	} while (1);
 
 	finish_wait(&ctx->cq_wait, &wait);
-	mutex_lock(&ctx->uring_lock);
+	io_ring_register_ctx_lock(ctx);
 
 	if (ret == -ENOENT || ret > 0)
 		ret = 0;
 out:
 	if (file)
@@ -351,11 +352,11 @@ bool io_cancel_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
 	bool found = false;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	hlist_for_each_entry_safe(req, tmp, list, hash_node) {
 		if (!io_match_task_safe(req, tctx, cancel_all))
 			continue;
 		hlist_del_init(&req->hash_node);
@@ -368,24 +369,25 @@ bool io_cancel_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tctx,
 
 int io_cancel_remove(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		     unsigned int issue_flags, struct hlist_head *list,
 		     bool (*cancel)(struct io_kiocb *))
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
 	int nr = 0;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	hlist_for_each_entry_safe(req, tmp, list, hash_node) {
 		if (!io_cancel_req_match(req, cd))
 			continue;
 		if (cancel(req))
 			nr++;
 		if (!(cd->flags & IORING_ASYNC_CANCEL_ALL))
 			break;
 	}
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	return nr ?: -ENOENT;
 }
 
 static bool io_match_linked(struct io_kiocb *head)
 {
@@ -477,37 +479,39 @@ __cold bool io_cancel_ctx_cb(struct io_wq_work *work, void *data)
 	return req->ctx == data;
 }
 
 static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_tctx_node *node;
 	enum io_wq_cancel cret;
 	bool ret = false;
 
-	mutex_lock(&ctx->uring_lock);
+	io_ring_ctx_lock(ctx, &lock_state);
 	list_for_each_entry(node, &ctx->tctx_list, ctx_node) {
 		struct io_uring_task *tctx = node->task->io_uring;
 
 		/*
-		 * io_wq will stay alive while we hold uring_lock, because it's
-		 * killed after ctx nodes, which requires to take the lock.
+		 * io_wq will stay alive while we hold ctx uring lock, because
+		 * it's killed after ctx nodes, which requires to take the lock.
 		 */
 		if (!tctx || !tctx->io_wq)
 			continue;
 		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_ctx_cb, ctx, true);
 		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
 	}
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_ctx_unlock(ctx, &lock_state);
 
 	return ret;
 }
 
 __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct io_uring_task *tctx,
 					 bool cancel_all, bool is_sqpoll_thread)
 {
 	struct io_task_cancel cancel = { .tctx = tctx, .all = cancel_all, };
+	struct io_ring_ctx_lock_state lock_state;
 	enum io_wq_cancel cret;
 	bool ret = false;
 
 	/* set it so io_req_local_work_add() would wake us up */
 	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
@@ -542,17 +546,17 @@ __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	}
 
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    io_allowed_defer_tw_run(ctx))
 		ret |= io_run_local_work(ctx, INT_MAX, INT_MAX) > 0;
-	mutex_lock(&ctx->uring_lock);
+	io_ring_ctx_lock(ctx, &lock_state);
 	ret |= io_cancel_defer_files(ctx, tctx, cancel_all);
 	ret |= io_poll_remove_all(ctx, tctx, cancel_all);
 	ret |= io_waitid_remove_all(ctx, tctx, cancel_all);
 	ret |= io_futex_remove_all(ctx, tctx, cancel_all);
 	ret |= io_uring_try_cancel_uring_cmd(ctx, tctx, cancel_all);
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_ctx_unlock(ctx, &lock_state);
 	ret |= io_kill_timeouts(ctx, tctx, cancel_all);
 	if (tctx)
 		ret |= io_run_task_work() > 0;
 	else
 		ret |= flush_delayed_work(&ctx->fallback_work);
diff --git a/io_uring/eventfd.c b/io_uring/eventfd.c
index 78f8ab7db104..c21ec95cb36c 100644
--- a/io_uring/eventfd.c
+++ b/io_uring/eventfd.c
@@ -6,10 +6,11 @@
 #include <linux/eventfd.h>
 #include <linux/eventpoll.h>
 #include <linux/io_uring.h>
 #include <linux/io_uring_types.h>
 
+#include "io_uring.h"
 #include "io-wq.h"
 #include "eventfd.h"
 
 struct io_ev_fd {
 	struct eventfd_ctx	*cq_ev_fd;
@@ -118,11 +119,11 @@ int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 	struct io_ev_fd *ev_fd;
 	__s32 __user *fds = arg;
 	int fd;
 
 	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
-					lockdep_is_held(&ctx->uring_lock));
+					io_ring_register_ctx_lock_held(ctx));
 	if (ev_fd)
 		return -EBUSY;
 
 	if (copy_from_user(&fd, fds, sizeof(*fds)))
 		return -EFAULT;
@@ -154,11 +155,11 @@ int io_eventfd_register(struct io_ring_ctx *ctx, void __user *arg,
 int io_eventfd_unregister(struct io_ring_ctx *ctx)
 {
 	struct io_ev_fd *ev_fd;
 
 	ev_fd = rcu_dereference_protected(ctx->io_ev_fd,
-					lockdep_is_held(&ctx->uring_lock));
+					io_ring_register_ctx_lock_held(ctx));
 	if (ev_fd) {
 		ctx->has_evfd = false;
 		rcu_assign_pointer(ctx->io_ev_fd, NULL);
 		io_eventfd_put(ev_fd);
 		return 0;
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index a87d4e26eee8..2cb362fc8e80 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -75,11 +75,11 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 	if (ctx->flags & IORING_SETUP_SQE128)
 		sq_shift = 1;
 
 	/*
 	 * we may get imprecise sqe and cqe info if uring is actively running
-	 * since we get cached_sq_head and cached_cq_tail without uring_lock
+	 * since we get cached_sq_head and cached_cq_tail without ctx uring lock
 	 * and sq_tail and cq_head are changed by userspace. But it's ok since
 	 * we usually use these info when it is stuck.
 	 */
 	seq_printf(m, "SqMask:\t0x%x\n", sq_mask);
 	seq_printf(m, "SqHead:\t%u\n", sq_head);
@@ -255,10 +255,10 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	/*
 	 * Avoid ABBA deadlock between the seq lock and the io_uring mutex,
 	 * since fdinfo case grabs it in the opposite direction of normal use
 	 * cases.
 	 */
-	if (mutex_trylock(&ctx->uring_lock)) {
+	if (io_ring_ctx_trylock(ctx)) {
 		__io_uring_show_fdinfo(ctx, m);
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_ctx_unlock(ctx, NULL);
 	}
 }
diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 794ef95df293..40ad4a08dc89 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -55,14 +55,15 @@ void io_free_file_tables(struct io_ring_ctx *ctx, struct io_file_table *table)
 	table->bitmap = NULL;
 }
 
 static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 				 u32 slot_index)
-	__must_hold(&ctx->uring_lock)
 {
 	struct io_rsrc_node *node;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	if (io_is_uring_fops(file))
 		return -EBADF;
 	if (!ctx->file_table.data.nr)
 		return -ENXIO;
 	if (slot_index >= ctx->file_table.data.nr)
@@ -105,16 +106,17 @@ int __io_fixed_fd_install(struct io_ring_ctx *ctx, struct file *file,
  * fput() is called correspondingly.
  */
 int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
 			struct file *file, unsigned int file_slot)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	ret = __io_fixed_fd_install(ctx, file, file_slot);
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 
 	if (unlikely(ret < 0))
 		fput(file);
 	return ret;
 }
diff --git a/io_uring/futex.c b/io_uring/futex.c
index 11bfff5a80df..aeda00981c7a 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -220,22 +220,23 @@ static void io_futex_wake_fn(struct wake_q_head *wake_q, struct futex_q *q)
 
 int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
 	struct io_futexv_data *ifd = req->async_data;
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret, woken = -1;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 
 	ret = futex_wait_multiple_setup(ifd->futexv, iof->futex_nr, &woken);
 
 	/*
 	 * Error case, ret is < 0. Mark the request as failed.
 	 */
 	if (unlikely(ret < 0)) {
-		io_ring_submit_unlock(ctx, issue_flags);
+		io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 		req_set_fail(req);
 		io_req_set_res(req, ret, 0);
 		io_req_async_data_free(req);
 		return IOU_COMPLETE;
 	}
@@ -265,27 +266,28 @@ int io_futexv_wait(struct io_kiocb *req, unsigned int issue_flags)
 		iof->futexv_unqueued = 1;
 		if (woken != -1)
 			io_req_set_res(req, woken, 0);
 	}
 
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	return IOU_ISSUE_SKIP_COMPLETE;
 }
 
 int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_futex *iof = io_kiocb_to_cmd(req, struct io_futex);
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_futex_data *ifd = NULL;
 	int ret;
 
 	if (!iof->futex_mask) {
 		ret = -EINVAL;
 		goto done;
 	}
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	ifd = io_cache_alloc(&ctx->futex_cache, GFP_NOWAIT);
 	if (!ifd) {
 		ret = -ENOMEM;
 		goto done_unlock;
 	}
@@ -299,17 +301,17 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = futex_wait_setup(iof->uaddr, iof->futex_val, iof->futex_flags,
 			       &ifd->q, NULL, NULL);
 	if (!ret) {
 		hlist_add_head(&req->hash_node, &ctx->futex_list);
-		io_ring_submit_unlock(ctx, issue_flags);
+		io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
 done_unlock:
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 done:
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
 	io_req_async_data_free(req);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index d7aaa6e4bfe4..e05e56a840f9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -234,20 +234,21 @@ static inline bool io_should_terminate_tw(struct io_ring_ctx *ctx)
 static __cold void io_fallback_req_func(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
 						fallback_work.work);
 	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_kiocb *req, *tmp;
 	struct io_tw_state ts = {};
 
 	percpu_ref_get(&ctx->refs);
-	mutex_lock(&ctx->uring_lock);
+	io_ring_ctx_lock(ctx, &lock_state);
 	ts.cancel = io_should_terminate_tw(ctx);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
 		req->io_task_work.func((struct io_tw_req){req}, ts);
 	io_submit_flush_completions(ctx);
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_ctx_unlock(ctx, &lock_state);
 	percpu_ref_put(&ctx->refs);
 }
 
 static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
 {
@@ -514,11 +515,11 @@ unsigned io_linked_nr(struct io_kiocb *req)
 
 static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
 {
 	bool drain_seen = false, first = true;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 	__io_req_caches_free(ctx);
 
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
@@ -577,13 +578,15 @@ static void io_cq_unlock_post(struct io_ring_ctx *ctx)
 	spin_unlock(&ctx->completion_lock);
 	io_cqring_wake(ctx);
 	io_commit_cqring_flush(ctx);
 }
 
-static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
+static void
+__io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying,
+			   struct io_ring_ctx_lock_state *lock_state)
 {
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	/* don't abort if we're dying, entries must get freed */
 	if (!dying && __io_cqring_events(ctx) == ctx->cq_entries)
 		return;
 
@@ -618,13 +621,13 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 		 * to care for a non-real case.
 		 */
 		if (need_resched()) {
 			ctx->cqe_sentinel = ctx->cqe_cached;
 			io_cq_unlock_post(ctx);
-			mutex_unlock(&ctx->uring_lock);
+			io_ring_ctx_unlock(ctx, lock_state);
 			cond_resched();
-			mutex_lock(&ctx->uring_lock);
+			io_ring_ctx_lock(ctx, lock_state);
 			io_cq_lock(ctx);
 		}
 	}
 
 	if (list_empty(&ctx->cq_overflow_list)) {
@@ -632,21 +635,24 @@ static void __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool dying)
 		atomic_andnot(IORING_SQ_CQ_OVERFLOW, &ctx->rings->sq_flags);
 	}
 	io_cq_unlock_post(ctx);
 }
 
-static void io_cqring_overflow_kill(struct io_ring_ctx *ctx)
+static void io_cqring_overflow_kill(struct io_ring_ctx *ctx,
+				    struct io_ring_ctx_lock_state *lock_state)
 {
 	if (ctx->rings)
-		__io_cqring_overflow_flush(ctx, true);
+		__io_cqring_overflow_flush(ctx, true, lock_state);
 }
 
 static void io_cqring_do_overflow_flush(struct io_ring_ctx *ctx)
 {
-	mutex_lock(&ctx->uring_lock);
-	__io_cqring_overflow_flush(ctx, false);
-	mutex_unlock(&ctx->uring_lock);
+	struct io_ring_ctx_lock_state lock_state;
+
+	io_ring_ctx_lock(ctx, &lock_state);
+	__io_cqring_overflow_flush(ctx, false, &lock_state);
+	io_ring_ctx_unlock(ctx, &lock_state);
 }
 
 /* must to be called somewhat shortly after putting a request */
 static inline void io_put_task(struct io_kiocb *req)
 {
@@ -881,15 +887,15 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 	return filled;
 }
 
 /*
  * Must be called from inline task_work so we know a flush will happen later,
- * and obviously with ctx->uring_lock held (tw always has that).
+ * and obviously with ctx uring lock held (tw always has that).
  */
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags)
 {
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 	lockdep_assert(ctx->lockless_cq);
 
 	if (!io_fill_cqe_aux(ctx, user_data, res, cflags)) {
 		struct io_cqe cqe = io_init_cqe(user_data, res, cflags);
 
@@ -914,11 +920,11 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	 */
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
 		__io_submit_flush_completions(ctx);
 
 	lockdep_assert(!io_wq_current_is_worker());
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	if (!ctx->lockless_cq) {
 		spin_lock(&ctx->completion_lock);
 		posted = io_fill_cqe_aux(ctx, req->cqe.user_data, res, cflags);
 		spin_unlock(&ctx->completion_lock);
@@ -938,11 +944,11 @@ bool io_req_post_cqe32(struct io_kiocb *req, struct io_uring_cqe cqe[2])
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	bool posted;
 
 	lockdep_assert(!io_wq_current_is_worker());
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	cqe[0].user_data = req->cqe.user_data;
 	if (!ctx->lockless_cq) {
 		spin_lock(&ctx->completion_lock);
 		posted = io_fill_cqe_aux32(ctx, cqe);
@@ -967,11 +973,11 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	if (WARN_ON_ONCE(!(issue_flags & IO_URING_F_IOWQ)))
 		return;
 
 	/*
 	 * Handle special CQ sync cases via task_work. DEFER_TASKRUN requires
-	 * the submitter task context, IOPOLL protects with uring_lock.
+	 * the submitter task context, IOPOLL protects with ctx uring lock.
 	 */
 	if (ctx->lockless_cq || (req->flags & REQ_F_REISSUE)) {
 defer_complete:
 		req->io_task_work.func = io_req_task_complete;
 		io_req_task_work_add(req);
@@ -992,15 +998,14 @@ static void io_req_complete_post(struct io_kiocb *req, unsigned issue_flags)
 	 */
 	req_ref_put(req);
 }
 
 void io_req_defer_failed(struct io_kiocb *req, s32 res)
-	__must_hold(&ctx->uring_lock)
 {
 	const struct io_cold_def *def = &io_cold_defs[req->opcode];
 
-	lockdep_assert_held(&req->ctx->uring_lock);
+	io_ring_ctx_assert_locked(req->ctx);
 
 	req_set_fail(req);
 	io_req_set_res(req, res, io_put_kbuf(req, res, NULL));
 	if (def->fail)
 		def->fail(req);
@@ -1008,20 +1013,21 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
 }
 
 /*
  * A request might get retired back into the request caches even before opcode
  * handlers and io_issue_sqe() are done with it, e.g. inline completion path.
- * Because of that, io_alloc_req() should be called only under ->uring_lock
+ * Because of that, io_alloc_req() should be called only under ctx uring lock
  * and with extra caution to not get a request that is still worked on.
  */
 __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
 {
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN | __GFP_ZERO;
 	void *reqs[IO_REQ_ALLOC_BATCH];
 	int ret;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	ret = kmem_cache_alloc_bulk(req_cachep, gfp, ARRAY_SIZE(reqs), reqs);
 
 	/*
 	 * Bulk alloc is all-or-nothing. If we fail to get a batch,
 	 * retry single alloc to be on the safe side.
@@ -1078,19 +1084,20 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	nxt = req->link;
 	req->link = NULL;
 	return nxt;
 }
 
-static void ctx_flush_and_put(struct io_ring_ctx *ctx, io_tw_token_t tw)
+static void ctx_flush_and_put(struct io_ring_ctx *ctx, io_tw_token_t tw,
+			      struct io_ring_ctx_lock_state *lock_state)
 {
 	if (!ctx)
 		return;
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 
 	io_submit_flush_completions(ctx);
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_ctx_unlock(ctx, lock_state);
 	percpu_ref_put(&ctx->refs);
 }
 
 /*
  * Run queued task_work, returning the number of entries processed in *count.
@@ -1099,38 +1106,39 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, io_tw_token_t tw)
  */
 struct llist_node *io_handle_tw_list(struct llist_node *node,
 				     unsigned int *count,
 				     unsigned int max_entries)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = NULL;
 	struct io_tw_state ts = { };
 
 	do {
 		struct llist_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
 
 		if (req->ctx != ctx) {
-			ctx_flush_and_put(ctx, ts);
+			ctx_flush_and_put(ctx, ts, &lock_state);
 			ctx = req->ctx;
-			mutex_lock(&ctx->uring_lock);
+			io_ring_ctx_lock(ctx, &lock_state);
 			percpu_ref_get(&ctx->refs);
 			ts.cancel = io_should_terminate_tw(ctx);
 		}
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
 				(struct io_tw_req){req}, ts);
 		node = next;
 		(*count)++;
 		if (unlikely(need_resched())) {
-			ctx_flush_and_put(ctx, ts);
+			ctx_flush_and_put(ctx, ts, &lock_state);
 			ctx = NULL;
 			cond_resched();
 		}
 	} while (node && *count < max_entries);
 
-	ctx_flush_and_put(ctx, ts);
+	ctx_flush_and_put(ctx, ts, &lock_state);
 	return node;
 }
 
 static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
 {
@@ -1399,16 +1407,17 @@ static inline int io_run_local_work_locked(struct io_ring_ctx *ctx,
 					max(IO_LOCAL_TW_DEFAULT_MAX, min_events));
 }
 
 int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_events)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_tw_state ts = {};
 	int ret;
 
-	mutex_lock(&ctx->uring_lock);
+	io_ring_ctx_lock(ctx, &lock_state);
 	ret = __io_run_local_work(ctx, ts, min_events, max_events);
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_ctx_unlock(ctx, &lock_state);
 	return ret;
 }
 
 static void io_req_task_cancel(struct io_tw_req tw_req, io_tw_token_t tw)
 {
@@ -1463,12 +1472,13 @@ static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
 		io_put_rsrc_node(req->ctx, req->buf_node);
 }
 
 static void io_free_batch_list(struct io_ring_ctx *ctx,
 			       struct io_wq_work_node *node)
-	__must_hold(&ctx->uring_lock)
 {
+	io_ring_ctx_assert_locked(ctx);
+
 	do {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
 
 		if (unlikely(req->flags & IO_REQ_CLEAN_SLOW_FLAGS)) {
@@ -1504,15 +1514,16 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 		io_req_add_to_cache(req, ctx);
 	} while (node);
 }
 
 void __io_submit_flush_completions(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 	struct io_wq_work_node *node;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	__io_cq_lock(ctx);
 	__wq_list_for_each(node, &state->compl_reqs) {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 					    comp_list);
 
@@ -1553,51 +1564,54 @@ static unsigned io_cqring_events(struct io_ring_ctx *ctx)
  * We can't just wait for polled events to come to us, we have to actively
  * find and complete them.
  */
 __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 {
+	struct io_ring_ctx_lock_state lock_state;
+
 	if (!(ctx->flags & IORING_SETUP_IOPOLL))
 		return;
 
-	mutex_lock(&ctx->uring_lock);
+	io_ring_ctx_lock(ctx, &lock_state);
 	while (!wq_list_empty(&ctx->iopoll_list)) {
 		/* let it sleep and repeat later if can't complete a request */
 		if (io_do_iopoll(ctx, true) == 0)
 			break;
 		/*
 		 * Ensure we allow local-to-the-cpu processing to take place,
 		 * in this case we need to ensure that we reap all events.
 		 * Also let task_work, etc. to progress by releasing the mutex
 		 */
 		if (need_resched()) {
-			mutex_unlock(&ctx->uring_lock);
+			io_ring_ctx_unlock(ctx, &lock_state);
 			cond_resched();
-			mutex_lock(&ctx->uring_lock);
+			io_ring_ctx_lock(ctx, &lock_state);
 		}
 	}
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_ctx_unlock(ctx, &lock_state);
 
 	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 		io_move_task_work_from_local(ctx);
 }
 
-static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
+static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events,
+			   struct io_ring_ctx_lock_state *lock_state)
 {
 	unsigned int nr_events = 0;
 	unsigned long check_cq;
 
 	min_events = min(min_events, ctx->cq_entries);
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
 
 	check_cq = READ_ONCE(ctx->check_cq);
 	if (unlikely(check_cq)) {
 		if (check_cq & BIT(IO_CHECK_CQ_OVERFLOW_BIT))
-			__io_cqring_overflow_flush(ctx, false);
+			__io_cqring_overflow_flush(ctx, false, lock_state);
 		/*
 		 * Similarly do not spin if we have not informed the user of any
 		 * dropped CQE.
 		 */
 		if (check_cq & BIT(IO_CHECK_CQ_DROPPED_BIT))
@@ -1615,11 +1629,11 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
 		int ret = 0;
 
 		/*
 		 * If a submit got punted to a workqueue, we can have the
 		 * application entering polling for a command before it gets
-		 * issued. That app will hold the uring_lock for the duration
+		 * issued. That app holds the ctx uring lock for the duration
 		 * of the poll right here, so we need to take a breather every
 		 * now and then to ensure that the issue has a chance to add
 		 * the poll to the issued list. Otherwise we can spin here
 		 * forever, while the workqueue is stuck trying to acquire the
 		 * very same mutex.
@@ -1630,13 +1644,13 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
 
 			(void) io_run_local_work_locked(ctx, min_events);
 
 			if (task_work_pending(current) ||
 			    wq_list_empty(&ctx->iopoll_list)) {
-				mutex_unlock(&ctx->uring_lock);
+				io_ring_ctx_unlock(ctx, lock_state);
 				io_run_task_work();
-				mutex_lock(&ctx->uring_lock);
+				io_ring_ctx_lock(ctx, lock_state);
 			}
 			/* some requests don't go through iopoll_list */
 			if (tail != ctx->cached_cq_tail ||
 			    wq_list_empty(&ctx->iopoll_list))
 				break;
@@ -1667,14 +1681,15 @@ void io_req_task_complete(struct io_tw_req tw_req, io_tw_token_t tw)
  * find it from a io_do_iopoll() thread before the issuer is done
  * accessing the kiocb cookie.
  */
 static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	/* workqueue context doesn't hold uring_lock, grab it now */
-	io_ring_submit_lock(ctx, issue_flags);
+	/* workqueue context doesn't hold ctx uring lock, grab it now */
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 
 	/*
 	 * Track whether we have multiple files in our lists. This will impact
 	 * how we do polling eventually, not spinning if we're on potentially
 	 * different devices.
@@ -1708,11 +1723,11 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 		 */
 		if ((ctx->flags & IORING_SETUP_SQPOLL) &&
 		    wq_has_sleeper(&ctx->sq_data->wait))
 			wake_up(&ctx->sq_data->wait);
 
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_ctx_unlock(ctx, &lock_state);
 	}
 }
 
 io_req_flags_t io_file_get_flags(struct file *file)
 {
@@ -1726,16 +1741,17 @@ io_req_flags_t io_file_get_flags(struct file *file)
 		res |= REQ_F_SUPPORT_NOWAIT;
 	return res;
 }
 
 static __cold void io_drain_req(struct io_kiocb *req)
-	__must_hold(&ctx->uring_lock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	bool drain = req->flags & IOSQE_IO_DRAIN;
 	struct io_defer_entry *de;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
 		io_req_defer_failed(req, -ENOMEM);
 		return;
 	}
@@ -1958,23 +1974,24 @@ void io_wq_submit_work(struct io_wq_work *work)
 }
 
 inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 				      unsigned int issue_flags)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_rsrc_node *node;
 	struct file *file = NULL;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	node = io_rsrc_node_lookup(&ctx->file_table.data, fd);
 	if (node) {
 		node->refs++;
 		req->file_node = node;
 		req->flags |= io_slot_flags(node);
 		file = io_slot_file(node);
 	}
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	return file;
 }
 
 struct file *io_file_get_normal(struct io_kiocb *req, int fd)
 {
@@ -2002,12 +2019,13 @@ static int io_req_sqe_copy(struct io_kiocb *req, unsigned int issue_flags)
 	def->sqe_copy(req);
 	return 0;
 }
 
 static void io_queue_async(struct io_kiocb *req, unsigned int issue_flags, int ret)
-	__must_hold(&req->ctx->uring_lock)
 {
+	io_ring_ctx_assert_locked(req->ctx);
+
 	if (ret != -EAGAIN || (req->flags & REQ_F_NOWAIT)) {
 fail:
 		io_req_defer_failed(req, ret);
 		return;
 	}
@@ -2027,16 +2045,17 @@ static void io_queue_async(struct io_kiocb *req, unsigned int issue_flags, int r
 		break;
 	}
 }
 
 static inline void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags)
-	__must_hold(&req->ctx->uring_lock)
 {
 	unsigned int issue_flags = IO_URING_F_NONBLOCK |
 				   IO_URING_F_COMPLETE_DEFER | extra_flags;
 	int ret;
 
+	io_ring_ctx_assert_locked(req->ctx);
+
 	ret = io_issue_sqe(req, issue_flags);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
 	 * doesn't support non-blocking read/write attempts
@@ -2044,12 +2063,13 @@ static inline void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags)
 	if (unlikely(ret))
 		io_queue_async(req, issue_flags, ret);
 }
 
 static void io_queue_sqe_fallback(struct io_kiocb *req)
-	__must_hold(&req->ctx->uring_lock)
 {
+	io_ring_ctx_assert_locked(req->ctx);
+
 	if (unlikely(req->flags & REQ_F_FAIL)) {
 		/*
 		 * We don't submit, fail them all, for that replace hardlinks
 		 * with normal links. Extra REQ_F_LINK is tolerated.
 		 */
@@ -2114,17 +2134,18 @@ static __cold int io_init_fail_req(struct io_kiocb *req, int err)
 	return err;
 }
 
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe, unsigned int *left)
-	__must_hold(&ctx->uring_lock)
 {
 	const struct io_issue_def *def;
 	unsigned int sqe_flags;
 	int personality;
 	u8 opcode;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	req->ctx = ctx;
 	req->opcode = opcode = READ_ONCE(sqe->opcode);
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	sqe_flags = READ_ONCE(sqe->flags);
 	req->flags = (__force io_req_flags_t) sqe_flags;
@@ -2267,15 +2288,16 @@ static __cold int io_submit_fail_init(const struct io_uring_sqe *sqe,
 	return 0;
 }
 
 static inline int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 			 const struct io_uring_sqe *sqe, unsigned int *left)
-	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_link *link = &ctx->submit_state.link;
 	int ret;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	ret = io_init_req(ctx, req, sqe, left);
 	if (unlikely(ret))
 		return io_submit_fail_init(sqe, req, ret);
 
 	trace_io_uring_submit_req(req);
@@ -2396,16 +2418,17 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	*sqe = &ctx->sq_sqes[head];
 	return true;
 }
 
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
-	__must_hold(&ctx->uring_lock)
 {
 	unsigned int entries = io_sqring_entries(ctx);
 	unsigned int left;
 	int ret;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	entries = min(nr, entries);
 	if (unlikely(!entries))
 		return 0;
 
 	ret = left = entries;
@@ -2825,28 +2848,33 @@ static __cold void __io_req_caches_free(struct io_ring_ctx *ctx)
 	}
 }
 
 static __cold void io_req_caches_free(struct io_ring_ctx *ctx)
 {
-	guard(mutex)(&ctx->uring_lock);
+	struct io_ring_ctx_lock_state lock_state;
+
+	io_ring_ctx_lock(ctx, &lock_state);
 	__io_req_caches_free(ctx);
+	io_ring_ctx_unlock(ctx, &lock_state);
 }
 
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
+	struct io_ring_ctx_lock_state lock_state;
+
 	io_sq_thread_finish(ctx);
 
-	mutex_lock(&ctx->uring_lock);
+	io_ring_ctx_lock(ctx, &lock_state);
 	io_sqe_buffers_unregister(ctx);
 	io_sqe_files_unregister(ctx);
 	io_unregister_zcrx_ifqs(ctx);
-	io_cqring_overflow_kill(ctx);
+	io_cqring_overflow_kill(ctx, &lock_state);
 	io_eventfd_unregister(ctx);
 	io_free_alloc_caches(ctx);
 	io_destroy_buffers(ctx);
 	io_free_region(ctx->user, &ctx->param_region);
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_ctx_unlock(ctx, &lock_state);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
 	if (ctx->submitter_task)
 		put_task_struct(ctx->submitter_task);
 
@@ -2877,14 +2905,15 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 
 static __cold void io_activate_pollwq_cb(struct callback_head *cb)
 {
 	struct io_ring_ctx *ctx = container_of(cb, struct io_ring_ctx,
 					       poll_wq_task_work);
+	struct io_ring_ctx_lock_state lock_state;
 
-	mutex_lock(&ctx->uring_lock);
+	io_ring_ctx_lock(ctx, &lock_state);
 	ctx->poll_activated = true;
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_ctx_unlock(ctx, &lock_state);
 
 	/*
 	 * Wake ups for some events between start of polling and activation
 	 * might've been lost due to loose synchronisation.
 	 */
@@ -2974,10 +3003,11 @@ static __cold void io_tctx_exit_cb(struct callback_head *cb)
 }
 
 static __cold void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
+	struct io_ring_ctx_lock_state lock_state;
 	unsigned long timeout = jiffies + HZ * 60 * 5;
 	unsigned long interval = HZ / 20;
 	struct io_tctx_exit exit;
 	struct io_tctx_node *node;
 	int ret;
@@ -2988,13 +3018,13 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	 * we're waiting for refs to drop. We need to reap these manually,
 	 * as nobody else will be looking for them.
 	 */
 	do {
 		if (test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq)) {
-			mutex_lock(&ctx->uring_lock);
-			io_cqring_overflow_kill(ctx);
-			mutex_unlock(&ctx->uring_lock);
+			io_ring_ctx_lock(ctx, &lock_state);
+			io_cqring_overflow_kill(ctx, &lock_state);
+			io_ring_ctx_unlock(ctx, &lock_state);
 		}
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 			io_move_task_work_from_local(ctx);
 
@@ -3035,11 +3065,11 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 
 	init_completion(&exit.completion);
 	init_task_work(&exit.task_work, io_tctx_exit_cb);
 	exit.ctx = ctx;
 
-	mutex_lock(&ctx->uring_lock);
+	io_ring_ctx_lock(ctx, &lock_state);
 	while (!list_empty(&ctx->tctx_list)) {
 		WARN_ON_ONCE(time_after(jiffies, timeout));
 
 		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
 					ctx_node);
@@ -3047,20 +3077,20 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 		list_rotate_left(&ctx->tctx_list);
 		ret = task_work_add(node->task, &exit.task_work, TWA_SIGNAL);
 		if (WARN_ON_ONCE(ret))
 			continue;
 
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_ctx_unlock(ctx, &lock_state);
 		/*
 		 * See comment above for
 		 * wait_for_completion_interruptible_timeout() on why this
 		 * wait is marked as interruptible.
 		 */
 		wait_for_completion_interruptible(&exit.completion);
-		mutex_lock(&ctx->uring_lock);
+		io_ring_ctx_lock(ctx, &lock_state);
 	}
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_ctx_unlock(ctx, &lock_state);
 	spin_lock(&ctx->completion_lock);
 	spin_unlock(&ctx->completion_lock);
 
 	/* pairs with RCU read section in io_req_local_work_add() */
 	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
@@ -3069,18 +3099,19 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	io_ring_ctx_free(ctx);
 }
 
 static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	unsigned long index;
 	struct creds *creds;
 
-	mutex_lock(&ctx->uring_lock);
+	io_ring_ctx_lock(ctx, &lock_state);
 	percpu_ref_kill(&ctx->refs);
 	xa_for_each(&ctx->personalities, index, creds)
 		io_unregister_personality(ctx, index);
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_ctx_unlock(ctx, &lock_state);
 
 	flush_delayed_work(&ctx->fallback_work);
 
 	INIT_WORK(&ctx->exit_work, io_ring_exit_work);
 	/*
@@ -3211,10 +3242,11 @@ static int io_get_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
 
 SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		u32, min_complete, u32, flags, const void __user *, argp,
 		size_t, argsz)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx;
 	struct file *file;
 	long ret;
 
 	if (unlikely(flags & ~IORING_ENTER_FLAGS))
@@ -3267,14 +3299,14 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	} else if (to_submit) {
 		ret = io_uring_add_tctx_node(ctx);
 		if (unlikely(ret))
 			goto out;
 
-		mutex_lock(&ctx->uring_lock);
+		io_ring_ctx_lock(ctx, &lock_state);
 		ret = io_submit_sqes(ctx, to_submit);
 		if (ret != to_submit) {
-			mutex_unlock(&ctx->uring_lock);
+			io_ring_ctx_unlock(ctx, &lock_state);
 			goto out;
 		}
 		if (flags & IORING_ENTER_GETEVENTS) {
 			if (ctx->syscall_iopoll)
 				goto iopoll_locked;
@@ -3283,11 +3315,11 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			 * it should handle ownership problems if any.
 			 */
 			if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 				(void)io_run_local_work_locked(ctx, min_complete);
 		}
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_ctx_unlock(ctx, &lock_state);
 	}
 
 	if (flags & IORING_ENTER_GETEVENTS) {
 		int ret2;
 
@@ -3296,16 +3328,17 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			 * We disallow the app entering submit/complete with
 			 * polling, but we still need to lock the ring to
 			 * prevent racing with polled issue that got punted to
 			 * a workqueue.
 			 */
-			mutex_lock(&ctx->uring_lock);
+			io_ring_ctx_lock(ctx, &lock_state);
 iopoll_locked:
 			ret2 = io_validate_ext_arg(ctx, flags, argp, argsz);
 			if (likely(!ret2))
-				ret2 = io_iopoll_check(ctx, min_complete);
-			mutex_unlock(&ctx->uring_lock);
+				ret2 = io_iopoll_check(ctx, min_complete,
+						       &lock_state);
+			io_ring_ctx_unlock(ctx, &lock_state);
 		} else {
 			struct ext_arg ext_arg = { .argsz = argsz };
 
 			ret2 = io_get_ext_arg(ctx, flags, argp, &ext_arg);
 			if (likely(!ret2))
@@ -3474,12 +3507,12 @@ static int io_uring_sanitise_params(struct io_uring_params *p)
 		return -EINVAL;
 
 	/*
 	 * If IORING_SETUP_SQPOLL is set, only the SQ thread issues SQEs,
 	 * but other threads may call io_uring_register() concurrently.
-	 * We still need uring_lock to synchronize these io_ring_ctx accesses,
-	 * so disable the single issuer optimizations.
+	 * We still need ctx uring lock to synchronize these io_ring_ctx
+	 * accesses, so disable the single issuer optimizations.
 	 */
 	if (flags & IORING_SETUP_SQPOLL)
 		p->flags &= ~IORING_SETUP_SINGLE_ISSUER;
 
 	return 0;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index a790c16854d3..23dae0af530b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -195,20 +195,98 @@ void io_queue_next(struct io_kiocb *req);
 void io_task_refs_refill(struct io_uring_task *tctx);
 bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 
 void io_activate_pollwq(struct io_ring_ctx *ctx);
 
+struct io_ring_ctx_lock_state {
+};
+
+/* Acquire the ctx uring lock */
+static inline void io_ring_ctx_lock(struct io_ring_ctx *ctx,
+				    struct io_ring_ctx_lock_state *state)
+{
+	mutex_lock(&ctx->uring_lock);
+}
+
+/* Attempt to acquire the ctx uring lock without blocking */
+static inline bool io_ring_ctx_trylock(struct io_ring_ctx *ctx)
+{
+	return mutex_trylock(&ctx->uring_lock);
+}
+
+/* Release the ctx uring lock */
+static inline void io_ring_ctx_unlock(struct io_ring_ctx *ctx,
+				      struct io_ring_ctx_lock_state *state)
+{
+	mutex_unlock(&ctx->uring_lock);
+}
+
+/* Assert (if CONFIG_LOCKDEP) that the ctx uring lock is held */
+static inline void io_ring_ctx_assert_locked(const struct io_ring_ctx *ctx)
+{
+	lockdep_assert_held(&ctx->uring_lock);
+}
+
+/* Acquire the ctx uring lock during the io_uring_register() syscall */
+static inline void io_ring_register_ctx_lock(struct io_ring_ctx *ctx)
+{
+	mutex_lock(&ctx->uring_lock);
+}
+
+/*
+ * Acquire the ctx uring lock with the given nesting level
+ * during the io_uring_register() syscall
+ */
+static inline void
+io_ring_register_ctx_lock_nested(struct io_ring_ctx *ctx, unsigned int subclass)
+{
+	mutex_lock_nested(&ctx->uring_lock, subclass);
+}
+
+/* Release the ctx uring lock during the io_uring_register() syscall */
+static inline void io_ring_register_ctx_unlock(struct io_ring_ctx *ctx)
+{
+	mutex_unlock(&ctx->uring_lock);
+}
+
+/*
+ * Return (if CONFIG_LOCKDEP) whether the ctx uring lock is held
+ * during the io_uring_register() syscall
+ */
+static inline bool io_ring_register_ctx_lock_held(const struct io_ring_ctx *ctx)
+{
+	return lockdep_is_held(&ctx->uring_lock);
+}
+
+/*
+ * Assert (if CONFIG_LOCKDEP) that the ctx uring lock is held
+ * during the io_uring_register() syscall. Implies io_ring_ctx_assert_locked().
+ */
+static inline void
+io_ring_register_ctx_assert_locked(const struct io_ring_ctx *ctx)
+{
+	lockdep_assert_held(&ctx->uring_lock);
+}
+
+/* Annotations for functions called during the io_uring_register() syscall */
+/* Must be called with the ctx uring lock held */
+#define must_hold_io_ring_register_ctx_lock(ctx) __must_hold(&(ctx)->uring_lock)
+/* Acquires the ctx uring lock */
+#define releases_io_ring_register_ctx_lock(ctx) __releases((ctx)->uring_lock)
+/* Releases the ctx uring lock */
+#define acquires_io_ring_register_ctx_lock(ctx) __acquires((ctx)->uring_lock)
+
 static inline void io_lockdep_assert_cq_locked(struct io_ring_ctx *ctx)
 {
 #if defined(CONFIG_PROVE_LOCKING)
 	lockdep_assert(in_task());
 
 	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
-		lockdep_assert_held(&ctx->uring_lock);
+		io_ring_ctx_assert_locked(ctx);
 
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		lockdep_assert_held(&ctx->uring_lock);
+		io_ring_ctx_assert_locked(ctx);
 	} else if (!ctx->task_complete) {
 		lockdep_assert_held(&ctx->completion_lock);
 	} else if (ctx->submitter_task) {
 		/*
 		 * ->submitter_task may be NULL and we can still post a CQE,
@@ -373,30 +451,32 @@ static inline void io_put_file(struct io_kiocb *req)
 {
 	if (!(req->flags & REQ_F_FIXED_FILE) && req->file)
 		fput(req->file);
 }
 
-static inline void io_ring_submit_unlock(struct io_ring_ctx *ctx,
-					 unsigned issue_flags)
+static inline void
+io_ring_submit_unlock(struct io_ring_ctx *ctx, unsigned issue_flags,
+		      struct io_ring_ctx_lock_state *lock_state)
 {
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_ctx_unlock(ctx, lock_state);
 }
 
-static inline void io_ring_submit_lock(struct io_ring_ctx *ctx,
-				       unsigned issue_flags)
+static inline void
+io_ring_submit_lock(struct io_ring_ctx *ctx, unsigned issue_flags,
+		    struct io_ring_ctx_lock_state *lock_state)
 {
 	/*
-	 * "Normal" inline submissions always hold the uring_lock, since we
+	 * "Normal" inline submissions always hold the ctx uring lock, since we
 	 * grab it from the system call. Same is true for the SQPOLL offload.
 	 * The only exception is when we've detached the request and issue it
 	 * from an async worker thread, grab the lock for that case.
 	 */
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
-		mutex_lock(&ctx->uring_lock);
-	lockdep_assert_held(&ctx->uring_lock);
+		io_ring_ctx_lock(ctx, lock_state);
+	io_ring_ctx_assert_locked(ctx);
 }
 
 static inline void io_commit_cqring(struct io_ring_ctx *ctx)
 {
 	/* order cqe stores with ring update */
@@ -504,24 +584,23 @@ static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 	return task_work_pending(current) || io_local_work_pending(ctx);
 }
 
 static inline void io_tw_lock(struct io_ring_ctx *ctx, io_tw_token_t tw)
 {
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 }
 
 /*
  * Don't complete immediately but use deferred completion infrastructure.
- * Protected by ->uring_lock and can only be used either with
+ * Protected by ctx uring lock and can only be used either with
  * IO_URING_F_COMPLETE_DEFER or inside a tw handler holding the mutex.
  */
 static inline void io_req_complete_defer(struct io_kiocb *req)
-	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_submit_state *state = &req->ctx->submit_state;
 
-	lockdep_assert_held(&req->ctx->uring_lock);
+	io_ring_ctx_assert_locked(req->ctx);
 
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
 static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 8a329556f8df..592e3d3a42ee 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -72,22 +72,22 @@ bool io_kbuf_commit(struct io_kiocb *req,
 }
 
 static inline struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
 							unsigned int bgid)
 {
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	return xa_load(&ctx->io_bl_xa, bgid);
 }
 
 static int io_buffer_add_list(struct io_ring_ctx *ctx,
 			      struct io_buffer_list *bl, unsigned int bgid)
 {
 	/*
 	 * Store buffer group ID and finally mark the list as visible.
 	 * The normal lookup doesn't care about the visibility as we're
-	 * always under the ->uring_lock, but lookups from mmap do.
+	 * always under the ctx uring lock, but lookups from mmap do.
 	 */
 	bl->bgid = bgid;
 	guard(mutex)(&ctx->mmap_lock);
 	return xa_err(xa_store(&ctx->io_bl_xa, bgid, bl, GFP_KERNEL));
 }
@@ -101,23 +101,24 @@ void io_kbuf_drop_legacy(struct io_kiocb *req)
 	req->kbuf = NULL;
 }
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 	struct io_buffer *buf;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 
 	buf = req->kbuf;
 	bl = io_buffer_get_list(ctx, buf->bgid);
 	list_add(&buf->list, &bl->buf_list);
 	bl->nbufs++;
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
 
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	return true;
 }
 
 static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 					      struct io_buffer_list *bl)
@@ -210,24 +211,25 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 }
 
 struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 				  unsigned buf_group, unsigned int issue_flags)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_br_sel sel = { };
 	struct io_buffer_list *bl;
 
-	io_ring_submit_lock(req->ctx, issue_flags);
+	io_ring_submit_lock(req->ctx, issue_flags, &lock_state);
 
 	bl = io_buffer_get_list(ctx, buf_group);
 	if (likely(bl)) {
 		if (bl->flags & IOBL_BUF_RING)
 			sel = io_ring_buffer_select(req, len, bl, issue_flags);
 		else
 			sel.addr = io_provided_buffer_select(req, len, bl);
 	}
-	io_ring_submit_unlock(req->ctx, issue_flags);
+	io_ring_submit_unlock(req->ctx, issue_flags, &lock_state);
 	return sel;
 }
 
 /* cap it at a reasonable 256, will be one page even for 4K */
 #define PEEK_MAX_IMPORT		256
@@ -315,14 +317,15 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 }
 
 int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		      struct io_br_sel *sel, unsigned int issue_flags)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret = -ENOENT;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	sel->buf_list = io_buffer_get_list(ctx, arg->buf_group);
 	if (unlikely(!sel->buf_list))
 		goto out_unlock;
 
 	if (sel->buf_list->flags & IOBL_BUF_RING) {
@@ -342,11 +345,11 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		ret = io_provided_buffers_select(req, &arg->out_len, sel->buf_list, arg->iovs);
 	}
 out_unlock:
 	if (issue_flags & IO_URING_F_UNLOCKED) {
 		sel->buf_list = NULL;
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_ctx_unlock(ctx, &lock_state);
 	}
 	return ret;
 }
 
 int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
@@ -354,11 +357,11 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 	int ret;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	bl = io_buffer_get_list(ctx, arg->buf_group);
 	if (unlikely(!bl))
 		return -ENOENT;
 
@@ -409,12 +412,16 @@ static int io_remove_buffers_legacy(struct io_ring_ctx *ctx,
 				    unsigned long nbufs)
 {
 	unsigned long i = 0;
 	struct io_buffer *nxt;
 
-	/* protects io_buffers_cache */
-	lockdep_assert_held(&ctx->uring_lock);
+	/*
+	 * ctx uring lock protects io_buffers_cache. io_remove_buffers_legacy()
+	 * is called from both issue and io_uring_register() paths,
+	 * but io_ring_ctx_assert_locked() is valid for both.
+	 */
+	io_ring_ctx_assert_locked(ctx);
 	WARN_ON_ONCE(bl->flags & IOBL_BUF_RING);
 
 	for (i = 0; i < nbufs && !list_empty(&bl->buf_list); i++) {
 		nxt = list_first_entry(&bl->buf_list, struct io_buffer, list);
 		list_del(&nxt->list);
@@ -579,18 +586,19 @@ static int __io_manage_buffers_legacy(struct io_kiocb *req,
 }
 
 int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_provide_buf *p = io_kiocb_to_cmd(req, struct io_provide_buf);
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 	int ret;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	bl = io_buffer_get_list(ctx, p->bgid);
 	ret = __io_manage_buffers_legacy(req, bl);
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
 	return IOU_COMPLETE;
@@ -604,11 +612,11 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	struct io_uring_buf_ring *br;
 	unsigned long mmap_offset;
 	unsigned long ring_size;
 	int ret;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_register_ctx_assert_locked(ctx);
 
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
 	if (!mem_is_zero(reg.resv, sizeof(reg.resv)))
 		return -EINVAL;
@@ -680,11 +688,11 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_uring_buf_reg reg;
 	struct io_buffer_list *bl;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_register_ctx_assert_locked(ctx);
 
 	if (copy_from_user(&reg, arg, sizeof(reg)))
 		return -EFAULT;
 	if (!mem_is_zero(reg.resv, sizeof(reg.resv)) || reg.flags)
 		return -EINVAL;
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index a39d9e518905..080285686a05 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -35,11 +35,11 @@ static inline void io_region_publish(struct io_ring_ctx *ctx,
 				     struct io_mapped_region *src_region,
 				     struct io_mapped_region *dst_region)
 {
 	/*
 	 * Once published mmap can find it without holding only the ->mmap_lock
-	 * and not ->uring_lock.
+	 * and not the ctx uring lock.
 	 */
 	guard(mutex)(&ctx->mmap_lock);
 	*dst_region = *src_region;
 }
 
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 7063ea7964e7..67fa2fb7e0b9 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -30,29 +30,31 @@ struct io_msg {
 		u32 cqe_flags;
 	};
 	u32 flags;
 };
 
-static void io_double_unlock_ctx(struct io_ring_ctx *octx)
+static void io_double_unlock_ctx(struct io_ring_ctx *octx,
+				 struct io_ring_ctx_lock_state *lock_state)
 {
-	mutex_unlock(&octx->uring_lock);
+	io_ring_ctx_unlock(octx, lock_state);
 }
 
 static int io_lock_external_ctx(struct io_ring_ctx *octx,
-				unsigned int issue_flags)
+				unsigned int issue_flags,
+				struct io_ring_ctx_lock_state *lock_state)
 {
 	/*
 	 * To ensure proper ordering between the two ctxs, we can only
 	 * attempt a trylock on the target. If that fails and we already have
 	 * the source ctx lock, punt to io-wq.
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
-		if (!mutex_trylock(&octx->uring_lock))
+		if (!io_ring_ctx_trylock(octx))
 			return -EAGAIN;
 		return 0;
 	}
-	mutex_lock(&octx->uring_lock);
+	io_ring_ctx_lock(octx, lock_state);
 	return 0;
 }
 
 void io_msg_ring_cleanup(struct io_kiocb *req)
 {
@@ -116,10 +118,11 @@ static int io_msg_data_remote(struct io_ring_ctx *target_ctx,
 }
 
 static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
 			      struct io_msg *msg, unsigned int issue_flags)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	u32 flags = 0;
 	int ret;
 
 	if (msg->src_fd || msg->flags & ~IORING_MSG_RING_FLAGS_PASS)
 		return -EINVAL;
@@ -134,17 +137,18 @@ static int __io_msg_ring_data(struct io_ring_ctx *target_ctx,
 	if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
 		flags = msg->cqe_flags;
 
 	ret = -EOVERFLOW;
 	if (target_ctx->flags & IORING_SETUP_IOPOLL) {
-		if (unlikely(io_lock_external_ctx(target_ctx, issue_flags)))
+		if (unlikely(io_lock_external_ctx(target_ctx, issue_flags,
+						  &lock_state)))
 			return -EAGAIN;
 	}
 	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
 		ret = 0;
 	if (target_ctx->flags & IORING_SETUP_IOPOLL)
-		io_double_unlock_ctx(target_ctx);
+		io_double_unlock_ctx(target_ctx, &lock_state);
 	return ret;
 }
 
 static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 {
@@ -155,35 +159,38 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 }
 
 static int io_msg_grab_file(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_rsrc_node *node;
 	int ret = -EBADF;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	node = io_rsrc_node_lookup(&ctx->file_table.data, msg->src_fd);
 	if (node) {
 		msg->src_file = io_slot_file(node);
 		if (msg->src_file)
 			get_file(msg->src_file);
 		req->flags |= REQ_F_NEED_CLEANUP;
 		ret = 0;
 	}
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	return ret;
 }
 
 static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	struct io_ring_ctx_lock_state lock_state;
 	struct file *src_file = msg->src_file;
 	int ret;
 
-	if (unlikely(io_lock_external_ctx(target_ctx, issue_flags)))
+	if (unlikely(io_lock_external_ctx(target_ctx, issue_flags,
+					  &lock_state)))
 		return -EAGAIN;
 
 	ret = __io_fixed_fd_install(target_ctx, src_file, msg->dst_fd);
 	if (ret < 0)
 		goto out_unlock;
@@ -200,11 +207,11 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	 * later IORING_OP_MSG_RING delivers the message.
 	 */
 	if (!io_post_aux_cqe(target_ctx, msg->user_data, ret, 0))
 		ret = -EOVERFLOW;
 out_unlock:
-	io_double_unlock_ctx(target_ctx);
+	io_double_unlock_ctx(target_ctx, &lock_state);
 	return ret;
 }
 
 static void io_msg_tw_fd_complete(struct callback_head *head)
 {
diff --git a/io_uring/notif.c b/io_uring/notif.c
index f476775ba44b..8099b87af588 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -15,11 +15,11 @@ static void io_notif_tw_complete(struct io_tw_req tw_req, io_tw_token_t tw)
 {
 	struct io_kiocb *notif = tw_req.req;
 	struct io_notif_data *nd = io_notif_to_data(notif);
 	struct io_ring_ctx *ctx = notif->ctx;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	do {
 		notif = cmd_to_io_kiocb(nd);
 
 		if (WARN_ON_ONCE(ctx != notif->ctx))
@@ -109,15 +109,16 @@ static const struct ubuf_info_ops io_ubuf_ops = {
 	.complete = io_tx_ubuf_complete,
 	.link_skb = io_link_skb,
 };
 
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
-	__must_hold(&ctx->uring_lock)
 {
 	struct io_kiocb *notif;
 	struct io_notif_data *nd;
 
+	io_ring_ctx_assert_locked(ctx);
+
 	if (unlikely(!io_alloc_req(ctx, &notif)))
 		return NULL;
 	notif->ctx = ctx;
 	notif->opcode = IORING_OP_NOP;
 	notif->flags = 0;
diff --git a/io_uring/notif.h b/io_uring/notif.h
index f3589cfef4a9..c33c9a1179c9 100644
--- a/io_uring/notif.h
+++ b/io_uring/notif.h
@@ -31,14 +31,15 @@ static inline struct io_notif_data *io_notif_to_data(struct io_kiocb *notif)
 {
 	return io_kiocb_to_cmd(notif, struct io_notif_data);
 }
 
 static inline void io_notif_flush(struct io_kiocb *notif)
-	__must_hold(&notif->ctx->uring_lock)
 {
 	struct io_notif_data *nd = io_notif_to_data(notif);
 
+	io_ring_ctx_assert_locked(notif->ctx);
+
 	io_tx_ubuf_complete(NULL, &nd->uarg, true);
 }
 
 static inline int io_notif_account_mem(struct io_kiocb *notif, unsigned len)
 {
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index bfeb91b31bba..432a7a68eec1 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -189,15 +189,16 @@ void io_open_cleanup(struct io_kiocb *req)
 }
 
 int __io_close_fixed(struct io_ring_ctx *ctx, unsigned int issue_flags,
 		     unsigned int offset)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	int ret;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	ret = io_fixed_fd_remove(ctx, offset);
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 
 	return ret;
 }
 
 static inline int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags)
@@ -333,18 +334,19 @@ int io_pipe_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 static int io_pipe_fixed(struct io_kiocb *req, struct file **files,
 			 unsigned int issue_flags)
 {
 	struct io_pipe *p = io_kiocb_to_cmd(req, struct io_pipe);
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret, fds[2] = { -1, -1 };
 	int slot = p->file_slot;
 
 	if (p->flags & O_CLOEXEC)
 		return -EINVAL;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 
 	ret = __io_fixed_fd_install(ctx, files[0], slot);
 	if (ret < 0)
 		goto err;
 	fds[0] = ret;
@@ -361,23 +363,23 @@ static int io_pipe_fixed(struct io_kiocb *req, struct file **files,
 	if (ret < 0)
 		goto err;
 	fds[1] = ret;
 	files[1] = NULL;
 
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 
 	if (!copy_to_user(p->fds, fds, sizeof(fds)))
 		return 0;
 
 	ret = -EFAULT;
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 err:
 	if (fds[0] != -1)
 		io_fixed_fd_remove(ctx, fds[0]);
 	if (fds[1] != -1)
 		io_fixed_fd_remove(ctx, fds[1]);
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	return ret;
 }
 
 static int io_pipe_fd(struct io_kiocb *req, struct file **files)
 {
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 8aa4e3a31e73..3af45bef85f6 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -121,11 +121,11 @@ static struct io_poll *io_poll_get_single(struct io_kiocb *req)
 static void io_poll_req_insert(struct io_kiocb *req)
 {
 	struct io_hash_table *table = &req->ctx->cancel_table;
 	u32 index = hash_long(req->cqe.user_data, table->hash_bits);
 
-	lockdep_assert_held(&req->ctx->uring_lock);
+	io_ring_ctx_assert_locked(req->ctx);
 
 	hlist_add_head(&req->hash_node, &table->hbs[index].list);
 }
 
 static void io_init_poll_iocb(struct io_poll *poll, __poll_t events)
@@ -321,11 +321,11 @@ void io_poll_task_func(struct io_tw_req tw_req, io_tw_token_t tw)
 	} else if (ret == IOU_POLL_REQUEUE) {
 		__io_poll_execute(req, 0);
 		return;
 	}
 	io_poll_remove_entries(req);
-	/* task_work always has ->uring_lock held */
+	/* task_work always holds ctx uring lock */
 	hash_del(&req->hash_node);
 
 	if (req->opcode == IORING_OP_POLL_ADD) {
 		if (ret == IOU_POLL_DONE) {
 			struct io_poll *poll;
@@ -524,15 +524,16 @@ static bool io_poll_can_finish_inline(struct io_kiocb *req,
 	return pt->owning || io_poll_get_ownership(req);
 }
 
 static void io_poll_add_hash(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	io_poll_req_insert(req);
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 }
 
 /*
  * Returns 0 when it's handed over for polling. The caller owns the requests if
  * it returns non-zero, but otherwise should not touch it. Negative values
@@ -727,11 +728,11 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct io_uring_task *tc
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
 	bool found = false;
 	int i;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	for (i = 0; i < nr_buckets; i++) {
 		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
 
 		hlist_for_each_entry_safe(req, tmp, &hb->list, hash_node) {
@@ -813,15 +814,16 @@ static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 }
 
 int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 		   unsigned issue_flags)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	int ret;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	ret = __io_poll_cancel(ctx, cd);
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	return ret;
 }
 
 static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
 				     unsigned int flags)
@@ -904,16 +906,17 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 }
 
 int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_poll_update *poll_update = io_kiocb_to_cmd(req, struct io_poll_update);
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_cancel_data cd = { .ctx = ctx, .data = poll_update->old_user_data, };
 	struct io_kiocb *preq;
 	int ret2, ret = 0;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	preq = io_poll_find(ctx, true, &cd);
 	ret2 = io_poll_disarm(preq);
 	if (ret2) {
 		ret = ret2;
 		goto out;
@@ -944,11 +947,11 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	req_set_fail(preq);
 	io_req_set_res(preq, -ECANCELED, 0);
 	preq->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(preq);
 out:
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	if (ret < 0) {
 		req_set_fail(req);
 		return ret;
 	}
 	/* complete update request, we're done with it */
diff --git a/io_uring/register.c b/io_uring/register.c
index db42f98562c4..c6d5b6e7c422 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -205,13 +205,13 @@ static __cold int __io_register_iowq_aff(struct io_ring_ctx *ctx,
 	int ret;
 
 	if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
 		ret = io_wq_cpu_affinity(current->io_uring, new_mask);
 	} else {
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_register_ctx_unlock(ctx);
 		ret = io_sqpoll_wq_cpu_affinity(ctx, new_mask);
-		mutex_lock(&ctx->uring_lock);
+		io_ring_register_ctx_lock(ctx);
 	}
 
 	return ret;
 }
 
@@ -252,11 +252,11 @@ static __cold int io_unregister_iowq_aff(struct io_ring_ctx *ctx)
 	return __io_register_iowq_aff(ctx, NULL);
 }
 
 static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 					       void __user *arg)
-	__must_hold(&ctx->uring_lock)
+	must_hold_io_ring_register_ctx_lock(ctx)
 {
 	struct io_tctx_node *node;
 	struct io_uring_task *tctx = NULL;
 	struct io_sq_data *sqd = NULL;
 	__u32 new_count[2];
@@ -272,18 +272,18 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 		sqd = ctx->sq_data;
 		if (sqd) {
 			struct task_struct *tsk;
 
 			/*
-			 * Observe the correct sqd->lock -> ctx->uring_lock
-			 * ordering. Fine to drop uring_lock here, we hold
+			 * Observe the correct sqd->lock -> ctx uring lock
+			 * ordering. Fine to drop ctx uring lock here, we hold
 			 * a ref to the ctx.
 			 */
 			refcount_inc(&sqd->refs);
-			mutex_unlock(&ctx->uring_lock);
+			io_ring_register_ctx_unlock(ctx);
 			mutex_lock(&sqd->lock);
-			mutex_lock(&ctx->uring_lock);
+			io_ring_register_ctx_lock(ctx);
 			tsk = sqpoll_task_locked(sqd);
 			if (tsk)
 				tctx = tsk->io_uring;
 		}
 	} else {
@@ -304,14 +304,14 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 	} else {
 		memset(new_count, 0, sizeof(new_count));
 	}
 
 	if (sqd) {
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_register_ctx_unlock(ctx);
 		mutex_unlock(&sqd->lock);
 		io_put_sq_data(sqd);
-		mutex_lock(&ctx->uring_lock);
+		io_ring_register_ctx_lock(ctx);
 	}
 
 	if (copy_to_user(arg, new_count, sizeof(new_count)))
 		return -EFAULT;
 
@@ -331,14 +331,14 @@ static __cold int io_register_iowq_max_workers(struct io_ring_ctx *ctx,
 		(void)io_wq_max_workers(tctx->io_wq, new_count);
 	}
 	return 0;
 err:
 	if (sqd) {
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_register_ctx_unlock(ctx);
 		mutex_unlock(&sqd->lock);
 		io_put_sq_data(sqd);
-		mutex_lock(&ctx->uring_lock);
+		io_ring_register_ctx_lock(ctx);
 	}
 	return ret;
 }
 
 static int io_register_clock(struct io_ring_ctx *ctx,
@@ -468,13 +468,13 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 
 	/*
 	 * If using SQPOLL, park the thread
 	 */
 	if (ctx->sq_data) {
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_register_ctx_unlock(ctx);
 		io_sq_thread_park(ctx->sq_data);
-		mutex_lock(&ctx->uring_lock);
+		io_ring_register_ctx_lock(ctx);
 	}
 
 	/*
 	 * We'll do the swap. Grab the ctx->mmap_lock, which will exclude
 	 * any new mmap's on the ring fd. Clear out existing mappings to prevent
@@ -606,12 +606,12 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 	return 0;
 }
 
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
-	__releases(ctx->uring_lock)
-	__acquires(ctx->uring_lock)
+	releases_io_ring_register_ctx_lock(ctx)
+	acquires_io_ring_register_ctx_lock(ctx)
 {
 	int ret;
 
 	/*
 	 * We don't quiesce the refs for register anymore and so it can't be
@@ -913,15 +913,15 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	file = io_uring_register_get_file(fd, use_registered_ring);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 	ctx = file->private_data;
 
-	mutex_lock(&ctx->uring_lock);
+	io_ring_register_ctx_lock(ctx);
 	ret = __io_uring_register(ctx, opcode, arg, nr_args);
 
 	trace_io_uring_register(ctx, opcode, ctx->file_table.data.nr,
 				ctx->buf_table.nr, ret);
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_register_ctx_unlock(ctx);
 
 	fput(file);
 	return ret;
 }
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 3765a50329a8..ef2c75871f46 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -349,11 +349,11 @@ static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				     struct io_uring_rsrc_update2 *up,
 				     unsigned nr_args)
 {
 	__u32 tmp;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	if (check_add_overflow(up->offset, nr_args, &tmp))
 		return -EOVERFLOW;
 
 	switch (type) {
@@ -497,14 +497,16 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	up2.resv2 = 0;
 
 	if (up->offset == IORING_FILE_INDEX_ALLOC) {
 		ret = io_files_update_with_index_alloc(req, issue_flags);
 	} else {
-		io_ring_submit_lock(ctx, issue_flags);
+		struct io_ring_ctx_lock_state lock_state;
+
+		io_ring_submit_lock(ctx, issue_flags, &lock_state);
 		ret = __io_register_rsrc_update(ctx, IORING_RSRC_FILE,
 						&up2, up->nr_args);
-		io_ring_submit_unlock(ctx, issue_flags);
+		io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	}
 
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
@@ -940,18 +942,19 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 			    void (*release)(void *), unsigned int index,
 			    unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	struct io_rsrc_data *data = &ctx->buf_table;
+	struct io_ring_ctx_lock_state lock_state;
 	struct req_iterator rq_iter;
 	struct io_mapped_ubuf *imu;
 	struct io_rsrc_node *node;
 	struct bio_vec bv;
 	unsigned int nr_bvecs = 0;
 	int ret = 0;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	if (index >= data->nr) {
 		ret = -EINVAL;
 		goto unlock;
 	}
 	index = array_index_nospec(index, data->nr);
@@ -993,24 +996,25 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 	imu->nr_bvecs = nr_bvecs;
 
 	node->buf = imu;
 	data->nodes[index] = node;
 unlock:
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
 
 int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
 			      unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	struct io_rsrc_data *data = &ctx->buf_table;
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_rsrc_node *node;
 	int ret = 0;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	if (index >= data->nr) {
 		ret = -EINVAL;
 		goto unlock;
 	}
 	index = array_index_nospec(index, data->nr);
@@ -1026,11 +1030,11 @@ int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
 	}
 
 	io_put_rsrc_node(ctx, node);
 	data->nodes[index] = NULL;
 unlock:
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
 
 static int validate_fixed_range(u64 buf_addr, size_t len,
@@ -1117,27 +1121,28 @@ static int io_import_fixed(int ddir, struct iov_iter *iter,
 }
 
 inline struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 					     unsigned issue_flags)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_rsrc_node *node;
 
 	if (req->flags & REQ_F_BUF_NODE)
 		return req->buf_node;
 	req->flags |= REQ_F_BUF_NODE;
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
 	if (node) {
 		node->refs++;
 		req->buf_node = node;
-		io_ring_submit_unlock(ctx, issue_flags);
+		io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 		return node;
 	}
 	req->flags &= ~REQ_F_BUF_NODE;
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	return NULL;
 }
 
 int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
@@ -1154,24 +1159,24 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 /* Lock two rings at once. The rings must be different! */
 static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 {
 	if (ctx1 > ctx2)
 		swap(ctx1, ctx2);
-	mutex_lock(&ctx1->uring_lock);
-	mutex_lock_nested(&ctx2->uring_lock, SINGLE_DEPTH_NESTING);
+	io_ring_register_ctx_lock(ctx1);
+	io_ring_register_ctx_lock_nested(ctx2, SINGLE_DEPTH_NESTING);
 }
 
 /* Both rings are locked by the caller. */
 static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx,
 			    struct io_uring_clone_buffers *arg)
 {
 	struct io_rsrc_data data;
 	int i, ret, off, nr;
 	unsigned int nbufs;
 
-	lockdep_assert_held(&ctx->uring_lock);
-	lockdep_assert_held(&src_ctx->uring_lock);
+	io_ring_register_ctx_assert_locked(ctx);
+	io_ring_register_ctx_assert_locked(src_ctx);
 
 	/*
 	 * Accounting state is shared between the two rings; that only works if
 	 * both rings are accounted towards the same counters.
 	 */
@@ -1300,11 +1305,11 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
 	src_ctx = file->private_data;
 	if (src_ctx != ctx) {
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_register_ctx_unlock(ctx);
 		lock_two_rings(ctx, src_ctx);
 
 		if (src_ctx->submitter_task &&
 		    src_ctx->submitter_task != current) {
 			ret = -EEXIST;
@@ -1314,11 +1319,11 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 
 	ret = io_clone_buffers(ctx, src_ctx, &buf);
 
 out:
 	if (src_ctx != ctx)
-		mutex_unlock(&src_ctx->uring_lock);
+		io_ring_register_ctx_unlock(src_ctx);
 
 	fput(file);
 	return ret;
 }
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index d603f6a47f5e..de03296439dc 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -2,10 +2,11 @@
 #ifndef IOU_RSRC_H
 #define IOU_RSRC_H
 
 #include <linux/io_uring_types.h>
 #include <linux/lockdep.h>
+#include "io_uring.h"
 
 #define IO_VEC_CACHE_SOFT_CAP		256
 
 enum {
 	IORING_RSRC_FILE		= 0,
@@ -97,11 +98,11 @@ static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data
 	return NULL;
 }
 
 static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 	if (!--node->refs)
 		io_free_rsrc_node(ctx, node);
 }
 
 static inline bool io_reset_rsrc_node(struct io_ring_ctx *ctx,
diff --git a/io_uring/rw.c b/io_uring/rw.c
index a7b568c3dfe8..8ed1ba1b462b 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -463,11 +463,11 @@ int io_read_mshot_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 void io_readv_writev_cleanup(struct io_kiocb *req)
 {
 	struct io_async_rw *rw = req->async_data;
 
-	lockdep_assert_held(&req->ctx->uring_lock);
+	io_ring_ctx_assert_locked(req->ctx);
 	io_vec_free(&rw->vec);
 	io_rw_recycle(req, 0);
 }
 
 static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
diff --git a/io_uring/splice.c b/io_uring/splice.c
index e81ebbb91925..567695c39091 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -58,26 +58,27 @@ void io_splice_cleanup(struct io_kiocb *req)
 
 static struct file *io_splice_get_file(struct io_kiocb *req,
 				       unsigned int issue_flags)
 {
 	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_rsrc_node *node;
 	struct file *file = NULL;
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
 		return io_file_get_normal(req, sp->splice_fd_in);
 
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	node = io_rsrc_node_lookup(&ctx->file_table.data, sp->splice_fd_in);
 	if (node) {
 		node->refs++;
 		sp->rsrc_node = node;
 		file = io_slot_file(node);
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	return file;
 }
 
 int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 {
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 74c1a130cd87..0b4573b53cf3 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -211,29 +211,30 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, struct io_sq_data *sqd,
 	/* if we're handling multiple rings, cap submit size for fairness */
 	if (cap_entries && to_submit > IORING_SQPOLL_CAP_ENTRIES_VALUE)
 		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
 
 	if (to_submit || !wq_list_empty(&ctx->iopoll_list)) {
+		struct io_ring_ctx_lock_state lock_state;
 		const struct cred *creds = NULL;
 
 		io_sq_start_worktime(ist);
 
 		if (ctx->sq_creds != current_cred())
 			creds = override_creds(ctx->sq_creds);
 
-		mutex_lock(&ctx->uring_lock);
+		io_ring_ctx_lock(ctx, &lock_state);
 		if (!wq_list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, true);
 
 		/*
 		 * Don't submit if refs are dying, good for io_uring_register(),
 		 * but also it is relied upon by io_ring_exit_work()
 		 */
 		if (to_submit && likely(!percpu_ref_is_dying(&ctx->refs)) &&
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
 			ret = io_submit_sqes(ctx, to_submit);
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_ctx_unlock(ctx, &lock_state);
 
 		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
 			wake_up(&ctx->sqo_sq_wait);
 		if (creds)
 			revert_creds(creds);
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 5b66755579c0..7ac1cb963a72 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -13,27 +13,28 @@
 #include "tctx.h"
 
 static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 					struct task_struct *task)
 {
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_wq_hash *hash;
 	struct io_wq_data data;
 	unsigned int concurrency;
 
-	mutex_lock(&ctx->uring_lock);
+	io_ring_ctx_lock(ctx, &lock_state);
 	hash = ctx->hash_map;
 	if (!hash) {
 		hash = kzalloc(sizeof(*hash), GFP_KERNEL);
 		if (!hash) {
-			mutex_unlock(&ctx->uring_lock);
+			io_ring_ctx_unlock(ctx, &lock_state);
 			return ERR_PTR(-ENOMEM);
 		}
 		refcount_set(&hash->refs, 1);
 		init_waitqueue_head(&hash->wait);
 		ctx->hash_map = hash;
 	}
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_ctx_unlock(ctx, &lock_state);
 
 	data.hash = hash;
 	data.task = task;
 
 	/* Do QD, or 4 * CPUS, whatever is smallest */
@@ -121,10 +122,12 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 			if (ret)
 				return ret;
 		}
 	}
 	if (!xa_load(&tctx->xa, (unsigned long)ctx)) {
+		struct io_ring_ctx_lock_state lock_state;
+
 		node = kmalloc(sizeof(*node), GFP_KERNEL);
 		if (!node)
 			return -ENOMEM;
 		node->ctx = ctx;
 		node->task = current;
@@ -134,13 +137,13 @@ int __io_uring_add_tctx_node(struct io_ring_ctx *ctx)
 		if (ret) {
 			kfree(node);
 			return ret;
 		}
 
-		mutex_lock(&ctx->uring_lock);
+		io_ring_ctx_lock(ctx, &lock_state);
 		list_add(&node->ctx_node, &ctx->tctx_list);
-		mutex_unlock(&ctx->uring_lock);
+		io_ring_ctx_unlock(ctx, &lock_state);
 	}
 	return 0;
 }
 
 int __io_uring_add_tctx_node_from_submit(struct io_ring_ctx *ctx)
@@ -163,10 +166,11 @@ int __io_uring_add_tctx_node_from_submit(struct io_ring_ctx *ctx)
  * Remove this io_uring_file -> task mapping.
  */
 __cold void io_uring_del_tctx_node(unsigned long index)
 {
 	struct io_uring_task *tctx = current->io_uring;
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_tctx_node *node;
 
 	if (!tctx)
 		return;
 	node = xa_erase(&tctx->xa, index);
@@ -174,13 +178,13 @@ __cold void io_uring_del_tctx_node(unsigned long index)
 		return;
 
 	WARN_ON_ONCE(current != node->task);
 	WARN_ON_ONCE(list_empty(&node->ctx_node));
 
-	mutex_lock(&node->ctx->uring_lock);
+	io_ring_ctx_lock(node->ctx, &lock_state);
 	list_del(&node->ctx_node);
-	mutex_unlock(&node->ctx->uring_lock);
+	io_ring_ctx_unlock(node->ctx, &lock_state);
 
 	if (tctx->last == node->ctx)
 		tctx->last = NULL;
 	kfree(node);
 }
@@ -196,11 +200,11 @@ __cold void io_uring_clean_tctx(struct io_uring_task *tctx)
 		cond_resched();
 	}
 	if (wq) {
 		/*
 		 * Must be after io_uring_del_tctx_node() (removes nodes under
-		 * uring_lock) to avoid race with io_uring_try_cancel_iowq().
+		 * ctx uring lock) to avoid race with io_uring_try_cancel_iowq()
 		 */
 		io_wq_put_and_exit(wq);
 		tctx->io_wq = NULL;
 	}
 }
@@ -269,13 +273,13 @@ int io_ringfd_register(struct io_ring_ctx *ctx, void __user *__arg,
 	int ret, i;
 
 	if (!nr_args || nr_args > IO_RINGFD_REG_MAX)
 		return -EINVAL;
 
-	mutex_unlock(&ctx->uring_lock);
+	io_ring_register_ctx_unlock(ctx);
 	ret = __io_uring_add_tctx_node(ctx);
-	mutex_lock(&ctx->uring_lock);
+	io_ring_register_ctx_lock(ctx);
 	if (ret)
 		return ret;
 
 	tctx = current->io_uring;
 	for (i = 0; i < nr_args; i++) {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 197474911f04..a8a128a3f0a2 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -51,11 +51,11 @@ bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
 	bool ret = false;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	hlist_for_each_entry_safe(req, tmp, &ctx->cancelable_uring_cmd,
 			hash_node) {
 		struct io_uring_cmd *cmd = io_kiocb_to_cmd(req,
 				struct io_uring_cmd);
@@ -76,19 +76,20 @@ bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
 
 static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
 		unsigned int issue_flags)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE))
 		return;
 
 	cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 	hlist_del(&req->hash_node);
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 }
 
 /*
  * Mark this command as concelable, then io_uring_try_cancel_uring_cmd()
  * will try to cancel this issued command by sending ->uring_cmd() with
@@ -103,14 +104,16 @@ void io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
+		struct io_ring_ctx_lock_state lock_state;
+
 		cmd->flags |= IORING_URING_CMD_CANCELABLE;
-		io_ring_submit_lock(ctx, issue_flags);
+		io_ring_submit_lock(ctx, issue_flags, &lock_state);
 		hlist_add_head(&req->hash_node, &ctx->cancelable_uring_cmd);
-		io_ring_submit_unlock(ctx, issue_flags);
+		io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 	}
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_mark_cancelable);
 
 void __io_uring_cmd_do_in_task(struct io_uring_cmd *ioucmd,
diff --git a/io_uring/waitid.c b/io_uring/waitid.c
index 2d4cbd47c67c..a69eb1b30b89 100644
--- a/io_uring/waitid.c
+++ b/io_uring/waitid.c
@@ -130,11 +130,11 @@ static void io_waitid_complete(struct io_kiocb *req, int ret)
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
 
 	/* anyone completing better be holding a reference */
 	WARN_ON_ONCE(!(atomic_read(&iw->refs) & IO_WAITID_REF_MASK));
 
-	lockdep_assert_held(&req->ctx->uring_lock);
+	io_ring_ctx_assert_locked(req->ctx);
 
 	hlist_del_init(&req->hash_node);
 	io_waitid_remove_wq(req);
 
 	ret = io_waitid_finish(req, ret);
@@ -145,11 +145,11 @@ static void io_waitid_complete(struct io_kiocb *req, int ret)
 
 static bool __io_waitid_cancel(struct io_kiocb *req)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
 
-	lockdep_assert_held(&req->ctx->uring_lock);
+	io_ring_ctx_assert_locked(req->ctx);
 
 	/*
 	 * Mark us canceled regardless of ownership. This will prevent a
 	 * potential retry from a spurious wakeup.
 	 */
@@ -280,10 +280,11 @@ int io_waitid_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_waitid *iw = io_kiocb_to_cmd(req, struct io_waitid);
 	struct io_waitid_async *iwa = req->async_data;
+	struct io_ring_ctx_lock_state lock_state;
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	ret = kernel_waitid_prepare(&iwa->wo, iw->which, iw->upid, &iw->info,
 					iw->options, NULL);
@@ -301,11 +302,11 @@ int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
 	 * Cancel must hold the ctx lock, so there's no risk of cancelation
 	 * finding us until a) we remain on the list, and b) the lock is
 	 * dropped. We only need to worry about racing with the wakeup
 	 * callback.
 	 */
-	io_ring_submit_lock(ctx, issue_flags);
+	io_ring_submit_lock(ctx, issue_flags, &lock_state);
 
 	/*
 	 * iw->head is valid under the ring lock, and as long as the request
 	 * is on the waitid_list where cancelations may find it.
 	 */
@@ -321,27 +322,27 @@ int io_waitid(struct io_kiocb *req, unsigned int issue_flags)
 		/*
 		 * Nobody else grabbed a reference, it'll complete when we get
 		 * a waitqueue callback, or if someone cancels it.
 		 */
 		if (!io_waitid_drop_issue_ref(req)) {
-			io_ring_submit_unlock(ctx, issue_flags);
+			io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 			return IOU_ISSUE_SKIP_COMPLETE;
 		}
 
 		/*
 		 * Wakeup triggered, racing with us. It was prevented from
 		 * completing because of that, queue up the tw to do that.
 		 */
-		io_ring_submit_unlock(ctx, issue_flags);
+		io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
 	hlist_del_init(&req->hash_node);
 	io_waitid_remove_wq(req);
 	ret = io_waitid_finish(req, ret);
 
-	io_ring_submit_unlock(ctx, issue_flags);
+	io_ring_submit_unlock(ctx, issue_flags, &lock_state);
 done:
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_set_res(req, ret, 0);
 	return IOU_COMPLETE;
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index b99cf2c6670a..f2ed49bbad63 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -851,11 +851,11 @@ static struct net_iov *__io_zcrx_get_free_niov(struct io_zcrx_area *area)
 
 void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	struct io_zcrx_ifq *ifq;
 
-	lockdep_assert_held(&ctx->uring_lock);
+	io_ring_ctx_assert_locked(ctx);
 
 	while (1) {
 		scoped_guard(mutex, &ctx->mmap_lock) {
 			unsigned long id = 0;
 
-- 
2.45.2


