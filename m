Return-Path: <io-uring+bounces-1233-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EBD6D88CC3D
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 19:46:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1BE061C3A57A
	for <lists+io-uring@lfdr.de>; Tue, 26 Mar 2024 18:46:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3650813C91F;
	Tue, 26 Mar 2024 18:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="CHIDRW0m"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1E713C813
	for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 18:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711478785; cv=none; b=OlNrZ+rP7AhJMAlcr/ng4bP9EIG0AIby1AqVEDzMgZ5FPfV/NK9jGXejRcHrNXbPwfHC4HreNMlStjlQx0tkPicRtbKaN/A2wl+Oga0QgAJQH82ZhqwVEVjazQ5BeThflT+IRyeLhVdjONFAWp7VJNQ1VHOnbmVgwORU762FBlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711478785; c=relaxed/simple;
	bh=pUUGwF07yN+J+vXYBNDodN7f8qkqDa+p3UsKuamD6VA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JehuYIkcMzHnOSfUQdxBdkM17dXtlLp681MfqzihG9VSKSutAYHReHD5IDQvOpz1K27Er8eHk1XhHAyUdM3TEs49NrUgo5B2IQCcmLI0Vfo/1Gdvvot/z2warbghYsRv3lsoUtXARY9CHbYd8cZOis45sctPPBPaczn7/aCL8JY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=CHIDRW0m; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5d862e8b163so1240861a12.1
        for <io-uring@vger.kernel.org>; Tue, 26 Mar 2024 11:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711478782; x=1712083582; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ly44eJhB0sMZoHxDFB9fvObE0Vhl/f3hyfUEw7Lcr9Y=;
        b=CHIDRW0mC3COV6lPOAoQQsuWZ4YOLy6CMBpPaG2/biQKdiUNeSnfGWwWpYBG3HUvcx
         7zAKP/JKYPjJ4adhTWf0iYbaT8bQ8tqc7SLWj2SbgHu2TYi+wJjA/cGD62M4I04dNmAj
         bqAVZzqPAnXMFFaFOfjMTdkwsLjbxR/EmuoK1s+QBCv+RcHCJE8siaa1jpU0xj0TgkoK
         d+4VTRAo3CofqqCYZxa2O7qpR+ybh6709EvqeNjoHJN6hTwWmzVWJ9ivre/bmrxaHJhj
         NCis745csFDxmZdYOkFoQeMcKn2NPMvnbVUvrDdrb3yAhXydOiTlfmx6127a56QXnqa5
         pKbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711478782; x=1712083582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ly44eJhB0sMZoHxDFB9fvObE0Vhl/f3hyfUEw7Lcr9Y=;
        b=n9EJYb1WmWX5Lb0RzxdOuS/cCTYF5RDrB4epnA+jkbGroMAAyE3WMF5SQQU6B18NBx
         gWRCTB3K0EvnTL64EDDdI5qcDa/ZiNPFcVN3Evki3rj0d+0ldp+oH/FdxPBfLDroEk1q
         5+npjp70gLK0sUiAecFCR1pe58wTYMYyyYZixqKPWpnzTWTPzao/KHyhu5B2ms7hH3Rg
         qL4uNqzPPlCmBR8XrZzh1M2GpbhvSbymdnQrJiqzmg+qqjb98681ennj5xH9C1W3L7AE
         gOq10BOwmnPKuJASuHCh7Nlrw+9eAINqmH1vfvc0fIsmxAVMwKYBdkxtgMzMVa3F57Lc
         Jf4Q==
X-Gm-Message-State: AOJu0Yy03wA34QQNujcv3RZ1AwR3x9yZfIajmFy7aah3kZhEM6SF7Lta
	ROY+AOLmBhZx0U+8homMGtFgtOaf9E4wi0LWGQVKBlh09kXrSsBPRwJSGUe3KkMJc62p8YP10Lp
	v
X-Google-Smtp-Source: AGHT+IHQYUjGIy2PVTqsGGZ3A5iR2bCEDboHp2kSwp7vV5+/8n8r+zuYeabVtx2v902KIWTCW8H2Lg==
X-Received: by 2002:a17:903:2448:b0:1dd:dab5:ce0d with SMTP id l8-20020a170903244800b001dddab5ce0dmr12263376pls.2.1711478781529;
        Tue, 26 Mar 2024 11:46:21 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:163c])
        by smtp.gmail.com with ESMTPSA id lg4-20020a170902fb8400b001dede7dd3c7sm7152833plb.111.2024.03.26.11.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Mar 2024 11:46:19 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] io_uring: switch deferred task_work to an io_wq_work_list
Date: Tue, 26 Mar 2024 12:42:46 -0600
Message-ID: <20240326184615.458820-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240326184615.458820-1-axboe@kernel.dk>
References: <20240326184615.458820-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Lockless lists may be handy for some things, but they mean that items
are in the reverse order as we can only add to the head of the list.
That in turn means that iterating items on the list needs to reverse it
first, if it's sensitive to ordering between items on the list.

Switch the DEFER_TASKRUN work list from an llist to a normal
io_wq_work_list, and protect it with a lock. Then we can get rid of the
manual reversing of the list when running it, which takes considerable
cycles particularly for bursty task_work additions.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  11 ++--
 io_uring/io_uring.c            | 117 ++++++++++++---------------------
 io_uring/io_uring.h            |   4 +-
 3 files changed, 51 insertions(+), 81 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index aeb4639785b5..e51bf15196e4 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -329,7 +329,9 @@ struct io_ring_ctx {
 	 * regularly bounce b/w CPUs.
 	 */
 	struct {
-		struct llist_head	work_llist;
+		struct io_wq_work_list	work_list;
+		spinlock_t		work_lock;
+		int			work_items;
 		unsigned long		check_cq;
 		atomic_t		cq_wait_nr;
 		atomic_t		cq_timeouts;
@@ -559,7 +561,10 @@ enum {
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
 
 struct io_task_work {
-	struct llist_node		node;
+	union {
+		struct io_wq_work_node		node;
+		struct llist_node		llist_node;
+	};
 	io_req_tw_func_t		func;
 };
 
@@ -615,8 +620,6 @@ struct io_kiocb {
 	 */
 	u16				buf_index;
 
-	unsigned			nr_tw;
-
 	/* REQ_F_* flags */
 	io_req_flags_t			flags;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 87d7d8bbf814..9c06911077db 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -249,7 +249,7 @@ static __cold void io_fallback_req_func(struct work_struct *work)
 
 	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
-	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
+	llist_for_each_entry_safe(req, tmp, node, io_task_work.llist_node)
 		req->io_task_work.func(req, &ts);
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
@@ -330,7 +330,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
 	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
-	init_llist_head(&ctx->work_llist);
+	INIT_WQ_LIST(&ctx->work_list);
+	spin_lock_init(&ctx->work_lock);
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	ctx->submit_state.free_list.next = NULL;
 	INIT_WQ_LIST(&ctx->locked_free_list);
@@ -1135,7 +1136,7 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 	do {
 		struct llist_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
-						    io_task_work.node);
+						    io_task_work.llist_node);
 
 		if (req->ctx != ctx) {
 			ctx_flush_and_put(ctx, &ts);
@@ -1159,20 +1160,6 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 	return node;
 }
 
-/**
- * io_llist_xchg - swap all entries in a lock-less list
- * @head:	the head of lock-less list to delete all entries
- * @new:	new entry as the head of the list
- *
- * If list is empty, return NULL, otherwise, return the pointer to the first entry.
- * The order of entries returned is from the newest to the oldest added one.
- */
-static inline struct llist_node *io_llist_xchg(struct llist_head *head,
-					       struct llist_node *new)
-{
-	return xchg(&head->first, new);
-}
-
 static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 {
 	struct llist_node *node = llist_del_all(&tctx->task_list);
@@ -1180,7 +1167,7 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 	struct io_kiocb *req;
 
 	while (node) {
-		req = container_of(node, struct io_kiocb, io_task_work.node);
+		req = container_of(node, struct io_kiocb, io_task_work.llist_node);
 		node = node->next;
 		if (sync && last_ctx != req->ctx) {
 			if (last_ctx) {
@@ -1190,7 +1177,7 @@ static __cold void io_fallback_tw(struct io_uring_task *tctx, bool sync)
 			last_ctx = req->ctx;
 			percpu_ref_get(&last_ctx->refs);
 		}
-		if (llist_add(&req->io_task_work.node,
+		if (llist_add(&req->io_task_work.llist_node,
 			      &req->ctx->fallback_llist))
 			schedule_delayed_work(&req->ctx->fallback_work, 1);
 	}
@@ -1238,48 +1225,26 @@ void tctx_task_work(struct callback_head *cb)
 	WARN_ON_ONCE(ret);
 }
 
-static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
+static inline void io_req_local_work_add(struct io_kiocb *req, unsigned tw_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned nr_wait, nr_tw, nr_tw_prev;
-	struct llist_node *head;
+	unsigned nr_wait, nr_tw;
+	unsigned long flags;
 
 	/* See comment above IO_CQ_WAKE_INIT */
 	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
 
 	/*
-	 * We don't know how many reuqests is there in the link and whether
+	 * We don't know how many requests is there in the link and whether
 	 * they can even be queued lazily, fall back to non-lazy.
 	 */
 	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
-		flags &= ~IOU_F_TWQ_LAZY_WAKE;
-
-	head = READ_ONCE(ctx->work_llist.first);
-	do {
-		nr_tw_prev = 0;
-		if (head) {
-			struct io_kiocb *first_req = container_of(head,
-							struct io_kiocb,
-							io_task_work.node);
-			/*
-			 * Might be executed at any moment, rely on
-			 * SLAB_TYPESAFE_BY_RCU to keep it alive.
-			 */
-			nr_tw_prev = READ_ONCE(first_req->nr_tw);
-		}
-
-		/*
-		 * Theoretically, it can overflow, but that's fine as one of
-		 * previous adds should've tried to wake the task.
-		 */
-		nr_tw = nr_tw_prev + 1;
-		if (!(flags & IOU_F_TWQ_LAZY_WAKE))
-			nr_tw = IO_CQ_WAKE_FORCE;
+		tw_flags &= ~IOU_F_TWQ_LAZY_WAKE;
 
-		req->nr_tw = nr_tw;
-		req->io_task_work.node.next = head;
-	} while (!try_cmpxchg(&ctx->work_llist.first, &head,
-			      &req->io_task_work.node));
+	spin_lock_irqsave(&ctx->work_lock, flags);
+	wq_list_add_tail(&req->io_task_work.node, &ctx->work_list);
+	nr_tw = ++ctx->work_items;
+	spin_unlock_irqrestore(&ctx->work_lock, flags);
 
 	/*
 	 * cmpxchg implies a full barrier, which pairs with the barrier
@@ -1289,7 +1254,7 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	 * is similar to the wait/wawke task state sync.
 	 */
 
-	if (!head) {
+	if (nr_tw == 1) {
 		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 		if (ctx->has_evfd)
@@ -1297,13 +1262,8 @@ static inline void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	}
 
 	nr_wait = atomic_read(&ctx->cq_wait_nr);
-	/* not enough or no one is waiting */
-	if (nr_tw < nr_wait)
-		return;
-	/* the previous add has already woken it up */
-	if (nr_tw_prev >= nr_wait)
-		return;
-	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
+	if (nr_tw >= nr_wait)
+		wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 }
 
 static void io_req_normal_work_add(struct io_kiocb *req)
@@ -1312,7 +1272,7 @@ static void io_req_normal_work_add(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	/* task_work already pending, we're done */
-	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
+	if (!llist_add(&req->io_task_work.llist_node, &tctx->task_list))
 		return;
 
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
@@ -1346,9 +1306,15 @@ void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
 
 static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 {
-	struct llist_node *node;
+	struct io_wq_work_node *node;
+	unsigned long flags;
+
+	spin_lock_irqsave(&ctx->work_lock, flags);
+	node = ctx->work_list.first;
+	INIT_WQ_LIST(&ctx->work_list);
+	ctx->work_items = 0;
+	spin_unlock_irqrestore(&ctx->work_lock, flags);
 
-	node = llist_del_all(&ctx->work_llist);
 	while (node) {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
@@ -1361,7 +1327,7 @@ static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
 				       int min_events)
 {
-	if (llist_empty(&ctx->work_llist))
+	if (wq_list_empty(&ctx->work_list))
 		return false;
 	if (events < min_events)
 		return true;
@@ -1373,7 +1339,7 @@ static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
 static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
 			       int min_events)
 {
-	struct llist_node *node;
+	struct io_wq_work_node *node;
 	unsigned int loops = 0;
 	int ret = 0;
 
@@ -1382,13 +1348,14 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 again:
-	/*
-	 * llists are in reverse order, flip it back the right way before
-	 * running the pending items.
-	 */
-	node = llist_reverse_order(io_llist_xchg(&ctx->work_llist, NULL));
+	spin_lock_irq(&ctx->work_lock);
+	node = ctx->work_list.first;
+	INIT_WQ_LIST(&ctx->work_list);
+	ctx->work_items = 0;
+	spin_unlock_irq(&ctx->work_lock);
+
 	while (node) {
-		struct llist_node *next = node->next;
+		struct io_wq_work_node *next = node->next;
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    io_task_work.node);
 		INDIRECT_CALL_2(req->io_task_work.func,
@@ -1414,7 +1381,7 @@ static inline int io_run_local_work_locked(struct io_ring_ctx *ctx,
 {
 	struct io_tw_state ts = {};
 
-	if (llist_empty(&ctx->work_llist))
+	if (wq_list_empty(&ctx->work_list))
 		return 0;
 	return __io_run_local_work(ctx, &ts, min_events);
 }
@@ -2426,7 +2393,7 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 
 int io_run_task_work_sig(struct io_ring_ctx *ctx)
 {
-	if (!llist_empty(&ctx->work_llist)) {
+	if (!wq_list_empty(&ctx->work_list)) {
 		__set_current_state(TASK_RUNNING);
 		if (io_run_local_work(ctx, INT_MAX) > 0)
 			return 0;
@@ -2455,7 +2422,7 @@ static inline int io_cqring_wait_schedule(struct io_ring_ctx *ctx,
 
 	if (unlikely(READ_ONCE(ctx->check_cq)))
 		return 1;
-	if (unlikely(!llist_empty(&ctx->work_llist)))
+	if (unlikely(!wq_list_empty(&ctx->work_list)))
 		return 1;
 	if (unlikely(test_thread_flag(TIF_NOTIFY_SIGNAL)))
 		return 1;
@@ -2494,7 +2461,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	if (!io_allowed_run_tw(ctx))
 		return -EEXIST;
-	if (!llist_empty(&ctx->work_llist))
+	if (!wq_list_empty(&ctx->work_list))
 		io_run_local_work(ctx, min_events);
 	io_run_task_work();
 	io_cqring_overflow_flush(ctx);
@@ -2558,7 +2525,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		 * now rather than let the caller do another wait loop.
 		 */
 		io_run_task_work();
-		if (!llist_empty(&ctx->work_llist))
+		if (!wq_list_empty(&ctx->work_list))
 			io_run_local_work(ctx, nr_wait);
 
 		/*
@@ -3331,7 +3298,7 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 		io_run_task_work();
 		io_uring_drop_tctx_refs(current);
 		xa_for_each(&tctx->xa, index, node) {
-			if (!llist_empty(&node->ctx->work_llist)) {
+			if (!wq_list_empty(&node->ctx->work_list)) {
 				WARN_ON_ONCE(node->ctx->submitter_task &&
 					     node->ctx->submitter_task != current);
 				goto end_wait;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 27d039ddb05e..bb30a29d0e27 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -343,7 +343,7 @@ static inline int io_run_task_work(void)
 
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
 {
-	return task_work_pending(current) || !llist_empty(&ctx->work_llist);
+	return task_work_pending(current) || !wq_list_empty(&ctx->work_list);
 }
 
 static inline void io_tw_lock(struct io_ring_ctx *ctx, struct io_tw_state *ts)
@@ -457,6 +457,6 @@ enum {
 static inline bool io_has_work(struct io_ring_ctx *ctx)
 {
 	return test_bit(IO_CHECK_CQ_OVERFLOW_BIT, &ctx->check_cq) ||
-	       !llist_empty(&ctx->work_llist);
+	       !wq_list_empty(&ctx->work_list);
 }
 #endif
-- 
2.43.0


