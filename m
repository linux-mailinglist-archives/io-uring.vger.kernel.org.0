Return-Path: <io-uring+bounces-3338-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7371398AE96
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 22:40:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 215582838A5
	for <lists+io-uring@lfdr.de>; Mon, 30 Sep 2024 20:40:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2671C2C190;
	Mon, 30 Sep 2024 20:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RUfUwS11"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A97C199FAF
	for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 20:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727728829; cv=none; b=nvLTz9C+KVBcnAaqNy7iiCv2lgn6vlgoFrGlVuPyPqLjXCxhMFuy5p31lNVfZn51NUOLN62IDezVVNVC4rlgQKCJayDAwtrXbTwBy96xlHbVu8MhviETJnYq+utba+Dl8+PdbdwFRXqmPSKPhDzjCe/j+uvw/UE2CnFyu/xT0To=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727728829; c=relaxed/simple;
	bh=AHcnLaXM698lQPMYEtrGO8ii8vBk6G9LhwjUbBlLlhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R6K85Ho2xF6xC6YpBW5YPykEKMV9mBIRZsxOkcQyu95sdZ4DyVG8qEeWJO8LC1s2+QY0MlPgQnkeSF/lv6BbVluIZ0/BUxbn07Gq4GFNQZVlV0NY+2wxAeabs1FTPJmRU1/SXKM4bBO2yk1cG9/zSBljF49thjODpz4iLLmGwaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RUfUwS11; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-82ce1cd202cso278055139f.0
        for <io-uring@vger.kernel.org>; Mon, 30 Sep 2024 13:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1727728825; x=1728333625; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PC7IMRLmnudLU0k1domBB6+v/EkL/Zxt7NFChK5oTY0=;
        b=RUfUwS117iM5vlwgnT8HR0xT7IaGXakES7fzKUAbZJTSHLq3/CElLRbIT8SCnHhBHx
         gx2OV1o2qHXTiYfOMAxmwpu3UVHuXblsUkNTfx21s7TTJwwlobIuSFp5bANQEoOFc+Av
         DiwWJjEbo4jei3UCthnb84wCO2U7msIs7jkbOkrausEfHLI8R2Puj/qqlFHrdSlBvdzu
         1xBiLOp472FyZctWnenwIgbQagaAFVl1ZTPkSMBm26NDx//kf5XimfHWauQGPOqSvXJ5
         vFLJyhiFHu139/HHIjaaURnZSe53fctTv1QrgAmZkHXmjSKDpr5ad1ZWaR5Qu5ylGp2U
         cHQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727728825; x=1728333625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PC7IMRLmnudLU0k1domBB6+v/EkL/Zxt7NFChK5oTY0=;
        b=ifIPNXLQnu55mC/+vbctFjwxGR5T3rJDEnZqjNRAURZfbL2w/kin49H/fBGYNqK5jz
         gzoz3lEumsp9LBFUFS5duEEEuNHkxnc7YKKtvSJ4mAy8RdIUmOFxkGijbLIcpQBi4hAO
         6/Q0NiZ0iXVYGgiU6iqvUYY1qWvgU2Iggl6Rhi7M8rK3Q7kF/4w/7o6MtZbjCISBzLzM
         uIipqcFEdWcSgdWJ/SLzLtxFdQaSWRHdRfKC7+2c8hTH5VnUMd9pCYgBX+4Kg151E0Zx
         b4n3VHOyLFRIUUlSDhymCPQj/DNReD1Dz9gl5HkumHhAFZLodTNB6D3oCKRl4Ld6zThj
         3hYQ==
X-Gm-Message-State: AOJu0YyeAMAb643maZB6goU/U8xJrSo0crW/JdRKIs5DlKv4H1MluSxe
	tRMKgXQg200nW/62npNYlstc/JOa0jrTis5n2JvGZ9tNZf5RkY2zyDzlKLvG5bm3UuhCmyChSU/
	sKBE=
X-Google-Smtp-Source: AGHT+IHqR7M+bWLd5ZoQMRwgkPjtRG8jTo8nwmrGXIFN/ocTzDocX9IgwuKZSQnXW2FK3XiRpWLkAA==
X-Received: by 2002:a92:b712:0:b0:3a3:6045:f8bd with SMTP id e9e14a558f8ab-3a36045fa4cmr1926645ab.5.1727728824802;
        Mon, 30 Sep 2024 13:40:24 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a344d60728sm26430175ab.2.2024.09.30.13.40.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Sep 2024 13:40:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring/poll: get rid of unlocked cancel hash
Date: Mon, 30 Sep 2024 14:37:46 -0600
Message-ID: <20240930204018.109617-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240930204018.109617-1-axboe@kernel.dk>
References: <20240930204018.109617-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

io_uring maintains two hash lists of inflight requests:

1) ctx->cancel_table_locked. This is used when the caller has the
   ctx->uring_lock held already. This is only an issue side parameter,
   as removal or task_work will always have it held.

2) ctx->cancel_table. This is used when the issuer does NOT have the
   ctx->uring_lock held, and relies on the table spinlocks for access.

However, it's pretty trivial to simply grab the lock in the one spot
where we care about it, for insertion. With that, we can kill the
unlocked table (and get rid of the _locked postfix for the other one).

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   6 +-
 io_uring/fdinfo.c              |  11 +--
 io_uring/io_uring.c            |   4 -
 io_uring/poll.c                | 139 ++++++++-------------------------
 4 files changed, 36 insertions(+), 124 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 4b9ba523978d..d8ca27da1341 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -291,7 +291,7 @@ struct io_ring_ctx {
 
 		struct xarray		io_bl_xa;
 
-		struct io_hash_table	cancel_table_locked;
+		struct io_hash_table	cancel_table;
 		struct io_alloc_cache	apoll_cache;
 		struct io_alloc_cache	netmsg_cache;
 		struct io_alloc_cache	rw_cache;
@@ -342,7 +342,6 @@ struct io_ring_ctx {
 
 	struct list_head	io_buffers_comp;
 	struct list_head	cq_overflow_list;
-	struct io_hash_table	cancel_table;
 
 	struct hlist_head	waitid_list;
 
@@ -459,7 +458,6 @@ enum {
 	REQ_F_DOUBLE_POLL_BIT,
 	REQ_F_APOLL_MULTISHOT_BIT,
 	REQ_F_CLEAR_POLLIN_BIT,
-	REQ_F_HASH_LOCKED_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -534,8 +532,6 @@ enum {
 	REQ_F_APOLL_MULTISHOT	= IO_REQ_FLAG(REQ_F_APOLL_MULTISHOT_BIT),
 	/* recvmsg special flag, clear EPOLLIN */
 	REQ_F_CLEAR_POLLIN	= IO_REQ_FLAG(REQ_F_CLEAR_POLLIN_BIT),
-	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
-	REQ_F_HASH_LOCKED	= IO_REQ_FLAG(REQ_F_HASH_LOCKED_BIT),
 	/* don't use lazy poll wake for this request */
 	REQ_F_POLL_NO_LAZY	= IO_REQ_FLAG(REQ_F_POLL_NO_LAZY_BIT),
 	/* file is pollable */
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 6b1247664b35..a6bac533edbe 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -190,22 +190,13 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	}
 
 	seq_puts(m, "PollList:\n");
-	for (i = 0; i < (1U << ctx->cancel_table.hash_bits); i++) {
+	for (i = 0; has_lock && i < (1U << ctx->cancel_table.hash_bits); i++) {
 		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
-		struct io_hash_bucket *hbl = &ctx->cancel_table_locked.hbs[i];
 		struct io_kiocb *req;
 
-		spin_lock(&hb->lock);
 		hlist_for_each_entry(req, &hb->list, hash_node)
 			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
 					task_work_pending(req->task));
-		spin_unlock(&hb->lock);
-
-		if (!has_lock)
-			continue;
-		hlist_for_each_entry(req, &hbl->list, hash_node)
-			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
-					task_work_pending(req->task));
 	}
 
 	if (has_lock)
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index feb61d68dca6..6685932aea9b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -294,8 +294,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	hash_bits = clamp(hash_bits, 1, 8);
 	if (io_alloc_hash_table(&ctx->cancel_table, hash_bits))
 		goto err;
-	if (io_alloc_hash_table(&ctx->cancel_table_locked, hash_bits))
-		goto err;
 	if (percpu_ref_init(&ctx->refs, io_ring_ctx_ref_free,
 			    0, GFP_KERNEL))
 		goto err;
@@ -358,7 +356,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	io_alloc_cache_free(&ctx->msg_cache, io_msg_cache_free);
 	io_futex_cache_free(ctx);
 	kfree(ctx->cancel_table.hbs);
-	kfree(ctx->cancel_table_locked.hbs);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
 	return NULL;
@@ -2771,7 +2768,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		io_wq_put_hash(ctx->hash_map);
 	io_napi_free(ctx);
 	kfree(ctx->cancel_table.hbs);
-	kfree(ctx->cancel_table_locked.hbs);
 	xa_destroy(&ctx->io_bl_xa);
 	kfree(ctx);
 }
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 175c279e59ea..69382da48c00 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -122,28 +122,6 @@ static void io_poll_req_insert(struct io_kiocb *req)
 {
 	struct io_hash_table *table = &req->ctx->cancel_table;
 	u32 index = hash_long(req->cqe.user_data, table->hash_bits);
-	struct io_hash_bucket *hb = &table->hbs[index];
-
-	spin_lock(&hb->lock);
-	hlist_add_head(&req->hash_node, &hb->list);
-	spin_unlock(&hb->lock);
-}
-
-static void io_poll_req_delete(struct io_kiocb *req)
-{
-	struct io_hash_table *table = &req->ctx->cancel_table;
-	u32 index = hash_long(req->cqe.user_data, table->hash_bits);
-	spinlock_t *lock = &table->hbs[index].lock;
-
-	spin_lock(lock);
-	hash_del(&req->hash_node);
-	spin_unlock(lock);
-}
-
-static void io_poll_req_insert_locked(struct io_kiocb *req)
-{
-	struct io_hash_table *table = &req->ctx->cancel_table_locked;
-	u32 index = hash_long(req->cqe.user_data, table->hash_bits);
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
@@ -154,19 +132,14 @@ static void io_poll_tw_hash_eject(struct io_kiocb *req, struct io_tw_state *ts)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	if (req->flags & REQ_F_HASH_LOCKED) {
-		/*
-		 * ->cancel_table_locked is protected by ->uring_lock in
-		 * contrast to per bucket spinlocks. Likely, tctx_task_work()
-		 * already grabbed the mutex for us, but there is a chance it
-		 * failed.
-		 */
-		io_tw_lock(ctx, ts);
-		hash_del(&req->hash_node);
-		req->flags &= ~REQ_F_HASH_LOCKED;
-	} else {
-		io_poll_req_delete(req);
-	}
+	/*
+	 * ->cancel_table_locked is protected by ->uring_lock in
+	 * contrast to per bucket spinlocks. Likely, tctx_task_work()
+	 * already grabbed the mutex for us, but there is a chance it
+	 * failed.
+	 */
+	io_tw_lock(ctx, ts);
+	hash_del(&req->hash_node);
 }
 
 static void io_init_poll_iocb(struct io_poll *poll, __poll_t events)
@@ -563,12 +536,13 @@ static bool io_poll_can_finish_inline(struct io_kiocb *req,
 	return pt->owning || io_poll_get_ownership(req);
 }
 
-static void io_poll_add_hash(struct io_kiocb *req)
+static void io_poll_add_hash(struct io_kiocb *req, unsigned int issue_flags)
 {
-	if (req->flags & REQ_F_HASH_LOCKED)
-		io_poll_req_insert_locked(req);
-	else
-		io_poll_req_insert(req);
+	struct io_ring_ctx *ctx = req->ctx;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	io_poll_req_insert(req);
+	io_ring_submit_unlock(ctx, issue_flags);
 }
 
 /*
@@ -605,11 +579,6 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	ipt->owning = issue_flags & IO_URING_F_UNLOCKED;
 	atomic_set(&req->poll_refs, (int)ipt->owning);
 
-	/* io-wq doesn't hold uring_lock */
-	if (issue_flags & IO_URING_F_UNLOCKED)
-		req->flags &= ~REQ_F_HASH_LOCKED;
-
-
 	/*
 	 * Exclusive waits may only wake a limited amount of entries
 	 * rather than all of them, this may interfere with lazy
@@ -638,7 +607,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	if (mask &&
 	   ((poll->events & (EPOLLET|EPOLLONESHOT)) == (EPOLLET|EPOLLONESHOT))) {
 		if (!io_poll_can_finish_inline(req, ipt)) {
-			io_poll_add_hash(req);
+			io_poll_add_hash(req, issue_flags);
 			return 0;
 		}
 		io_poll_remove_entries(req);
@@ -647,7 +616,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 		return 1;
 	}
 
-	io_poll_add_hash(req);
+	io_poll_add_hash(req, issue_flags);
 
 	if (mask && (poll->events & EPOLLET) &&
 	    io_poll_can_finish_inline(req, ipt)) {
@@ -720,12 +689,6 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	__poll_t mask = POLLPRI | POLLERR | EPOLLET;
 	int ret;
 
-	/*
-	 * apoll requests already grab the mutex to complete in the tw handler,
-	 * so removal from the mutex-backed hash is free, use it by default.
-	 */
-	req->flags |= REQ_F_HASH_LOCKED;
-
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
 	if (!io_file_can_poll(req))
@@ -761,18 +724,22 @@ int io_arm_poll_handler(struct io_kiocb *req, unsigned issue_flags)
 	return IO_APOLL_OK;
 }
 
-static __cold bool io_poll_remove_all_table(struct task_struct *tsk,
-					    struct io_hash_table *table,
-					    bool cancel_all)
+/*
+ * Returns true if we found and killed one or more poll requests
+ */
+__cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
+			       bool cancel_all)
 {
-	unsigned nr_buckets = 1U << table->hash_bits;
+	unsigned nr_buckets = 1U << ctx->cancel_table.hash_bits;
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
 	bool found = false;
 	int i;
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	for (i = 0; i < nr_buckets; i++) {
-		struct io_hash_bucket *hb = &table->hbs[i];
+		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
 
 		spin_lock(&hb->lock);
 		hlist_for_each_entry_safe(req, tmp, &hb->list, hash_node) {
@@ -787,28 +754,13 @@ static __cold bool io_poll_remove_all_table(struct task_struct *tsk,
 	return found;
 }
 
-/*
- * Returns true if we found and killed one or more poll requests
- */
-__cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
-			       bool cancel_all)
-	__must_hold(&ctx->uring_lock)
-{
-	bool ret;
-
-	ret = io_poll_remove_all_table(tsk, &ctx->cancel_table, cancel_all);
-	ret |= io_poll_remove_all_table(tsk, &ctx->cancel_table_locked, cancel_all);
-	return ret;
-}
-
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 				     struct io_cancel_data *cd,
-				     struct io_hash_table *table,
 				     struct io_hash_bucket **out_bucket)
 {
 	struct io_kiocb *req;
-	u32 index = hash_long(cd->data, table->hash_bits);
-	struct io_hash_bucket *hb = &table->hbs[index];
+	u32 index = hash_long(cd->data, ctx->cancel_table.hash_bits);
+	struct io_hash_bucket *hb = &ctx->cancel_table.hbs[index];
 
 	*out_bucket = NULL;
 
@@ -831,17 +783,16 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 
 static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 					  struct io_cancel_data *cd,
-					  struct io_hash_table *table,
 					  struct io_hash_bucket **out_bucket)
 {
-	unsigned nr_buckets = 1U << table->hash_bits;
+	unsigned nr_buckets = 1U << ctx->cancel_table.hash_bits;
 	struct io_kiocb *req;
 	int i;
 
 	*out_bucket = NULL;
 
 	for (i = 0; i < nr_buckets; i++) {
-		struct io_hash_bucket *hb = &table->hbs[i];
+		struct io_hash_bucket *hb = &ctx->cancel_table.hbs[i];
 
 		spin_lock(&hb->lock);
 		hlist_for_each_entry(req, &hb->list, hash_node) {
@@ -866,17 +817,16 @@ static int io_poll_disarm(struct io_kiocb *req)
 	return 0;
 }
 
-static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
-			    struct io_hash_table *table)
+static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd)
 {
 	struct io_hash_bucket *bucket;
 	struct io_kiocb *req;
 
 	if (cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP |
 			 IORING_ASYNC_CANCEL_ANY))
-		req = io_poll_file_find(ctx, cd, table, &bucket);
+		req = io_poll_file_find(ctx, cd, &bucket);
 	else
-		req = io_poll_find(ctx, false, cd, table, &bucket);
+		req = io_poll_find(ctx, false, cd, &bucket);
 
 	if (req)
 		io_poll_cancel_req(req);
@@ -890,12 +840,8 @@ int io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 {
 	int ret;
 
-	ret = __io_poll_cancel(ctx, cd, &ctx->cancel_table);
-	if (ret != -ENOENT)
-		return ret;
-
 	io_ring_submit_lock(ctx, issue_flags);
-	ret = __io_poll_cancel(ctx, cd, &ctx->cancel_table_locked);
+	ret = __io_poll_cancel(ctx, cd);
 	io_ring_submit_unlock(ctx, issue_flags);
 	return ret;
 }
@@ -972,13 +918,6 @@ int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 
 	ipt.pt._qproc = io_poll_queue_proc;
 
-	/*
-	 * If sqpoll or single issuer, there is no contention for ->uring_lock
-	 * and we'll end up holding it in tw handlers anyway.
-	 */
-	if (req->ctx->flags & (IORING_SETUP_SQPOLL|IORING_SETUP_SINGLE_ISSUER))
-		req->flags |= REQ_F_HASH_LOCKED;
-
 	ret = __io_arm_poll_handler(req, poll, &ipt, poll->events, issue_flags);
 	if (ret > 0) {
 		io_req_set_res(req, ipt.result_mask, 0);
@@ -997,26 +936,16 @@ int io_poll_remove(struct io_kiocb *req, unsigned int issue_flags)
 	int ret2, ret = 0;
 
 	io_ring_submit_lock(ctx, issue_flags);
-	preq = io_poll_find(ctx, true, &cd, &ctx->cancel_table, &bucket);
+	preq = io_poll_find(ctx, true, &cd, &bucket);
 	ret2 = io_poll_disarm(preq);
 	if (bucket)
 		spin_unlock(&bucket->lock);
 	if (!ret2)
 		goto found;
-	if (ret2 != -ENOENT) {
-		ret = ret2;
-		goto out;
-	}
-
-	preq = io_poll_find(ctx, true, &cd, &ctx->cancel_table_locked, &bucket);
-	ret2 = io_poll_disarm(preq);
-	if (bucket)
-		spin_unlock(&bucket->lock);
 	if (ret2) {
 		ret = ret2;
 		goto out;
 	}
-
 found:
 	if (WARN_ON_ONCE(preq->opcode != IORING_OP_POLL_ADD)) {
 		ret = -EFAULT;
-- 
2.45.2


