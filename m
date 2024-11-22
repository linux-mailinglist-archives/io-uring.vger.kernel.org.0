Return-Path: <io-uring+bounces-4977-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F97F9D61DF
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 17:17:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DC96A283082
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 16:17:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D95101DF720;
	Fri, 22 Nov 2024 16:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="eHy0sX5E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F3C1DE8BE
	for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 16:16:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732292216; cv=none; b=Nq89eEEnovMTdtSoIn8zKdKubOBDf1GgIV/3YvT3bRYCJuIQz0ASSeBuWBn6jw8Nv+f6MHKuXYltiK90LhiFal4f/pYvhlvIlITpuCmtVhIoY2odkYVR57GoauOHCAPLVRlQo0hCm0EQTDj477iIr7cH6n4hDvYX3ZuryiqQ0fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732292216; c=relaxed/simple;
	bh=3dEGIseN8FavbBePoBQAp5qbtFY1WYjsB+MN0Y9em7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d0JsHn7hMzOXNz8iA55PSaSNPaw/lOHG1FEq9hbH65GQHOquPvXJ6vXJzTt2Ml6oggRR8uskFm8uleQaXxXuppUCRCcCNck5d7GfWTsnj01MSh7qpNOQRr95ydSjxUpFQ95S5/8SjbKFuzgZ9W+xfcX//sX6c3RAPHbDjrJGuD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=eHy0sX5E; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-5ee1e04776cso1251126eaf.0
        for <io-uring@vger.kernel.org>; Fri, 22 Nov 2024 08:16:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1732292212; x=1732897012; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Urhq4JJDr5tcDlZi6G1vBV7eoJeum5ij2plMDVPz9BE=;
        b=eHy0sX5EmMRzsIJeaxbVxdLWmpon8I+dj4/T5ZRCqG+fTrvetQxhkE7aMzlzcKXMyB
         xmLt7JgIgV6wOG8/zxxTNV3s5GeJJ3R7W4Hsk/OcCGr6DDfeVW8dLVpSPX15kvMcEeHw
         mvfpP4GxSqqSAUTwJgHjcDOcxFTSNsBAlgYIOkn+28EdSHLfqzE/APKVUb6n9VfWAzlZ
         y4WKts9WlZgWCRb2fQLAZZkexQ3bbQUsHwsNFXMYlJUZ418b/5AdWgyQKuljgKXYpySx
         M6VtZRiCvj7bdDMpjQqYhX7/nEPrH6cxaRkZJ+G1KdoykeuOoyVGAl9wSiysSiWVFTnj
         6Tpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732292212; x=1732897012;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Urhq4JJDr5tcDlZi6G1vBV7eoJeum5ij2plMDVPz9BE=;
        b=MNLXLEI0hXG+2HnHsso7TB7AqrrhXY4ke2HTlnMvMY+l/PZFwofU2yerLzkMfa+Ex+
         h6a1Pq8TaRTqymLjEjjan6J8Tr3TjAXWViBjrAdy1zPc+DWPsZOiq7n11kYtZNG7J3uO
         KYo+y8/DsWdfizrQrA+5K2Ah5zZq4BUnt2lYxV5iEGoZzf7PdKdI7lV0N7U6Cv08CPlh
         u7hXrQmsSPFXb+BFWzKbz7iW2smxX4LhxBhSZXGw6lPFL3A5jhxOgxYvwRGf9FPUyJ0o
         lJSaMItmwM1roqCoDdKXRPzZa4wqz4OAV7QK7ne8ru0T3YB2G2S+OcsNgFiAOITzOM+H
         HhsQ==
X-Gm-Message-State: AOJu0YxOhQPee/NNyIQKQHoG09NUo6IFA883VEHHeTq5vDWJt/QFRpCR
	6oTKit8ycJpnUZcDEioQ6K3Osks2C1sWondxhijtpRxfujLtO0nKgwB0+hibyN0yi8dXMP5ZnaJ
	Mfew=
X-Gm-Gg: ASbGnctxP4womhpH2Lle8N9/EtHz4Ha9k72hIrPafrZ33zB0j4xSjbX35oO8nPi8HHe
	d7O06USZO/1gXu5/YHAFO5aFX2ZZ8/pMELfqSxJ4wIFacsOMxwODmXTWRS+gK68rR2Fa5Rq+vYZ
	XV4I/RAWP2y+sammxTscxNcqzJ+kv5RXxdi1njOoVauBjcTe1Vr03DcmCP8u4e3EwsKyg0QlNe2
	T4k12QGXaNdIp504h6hgn0TLZLL7Z12dOK+6ZT94v7JOXY3Qke6Fw==
X-Google-Smtp-Source: AGHT+IFbkRffx1ZBz+QDCzwfcYInLiXxJW/zv4ACoYNTZi1Bsjh8oLKqhG94/boMvhqnI6R9U8Y1vw==
X-Received: by 2002:a05:6820:3093:b0:5eb:c72e:e29b with SMTP id 006d021491bc7-5f06aa20e0emr3167447eaf.7.1732292212238;
        Fri, 22 Nov 2024 08:16:52 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-5f06976585esm436958eaf.18.2024.11.22.08.16.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Nov 2024 08:16:51 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] io_uring: replace defer task_work llist with io_wq_work_list
Date: Fri, 22 Nov 2024 09:12:40 -0700
Message-ID: <20241122161645.494868-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241122161645.494868-1-axboe@kernel.dk>
References: <20241122161645.494868-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a spinlock for the list, and replace the lockless llist with the
work list instead. This avoids needing to reverse items in the list
before running them, as the io_wq_work_list is FIFO by nature whereas
the llist is LIFO.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  13 ++-
 io_uring/io_uring.c            | 194 ++++++++++++++++-----------------
 io_uring/io_uring.h            |   2 +-
 3 files changed, 104 insertions(+), 105 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 011860ade268..e9ba99cb0ed0 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -335,8 +335,9 @@ struct io_ring_ctx {
 	 * regularly bounce b/w CPUs.
 	 */
 	struct {
-		struct llist_head	work_llist;
-		struct llist_head	retry_llist;
+		struct io_wq_work_list	work_list;
+		spinlock_t		work_lock;
+		int			work_items;
 		unsigned long		check_cq;
 		atomic_t		cq_wait_nr;
 		atomic_t		cq_timeouts;
@@ -566,7 +567,11 @@ enum {
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
 
 struct io_task_work {
-	struct llist_node		node;
+	/* DEFER_TASKRUN uses work_node, regular task_work node */
+	union {
+		struct io_wq_work_node	work_node;
+		struct llist_node	node;
+	};
 	io_req_tw_func_t		func;
 };
 
@@ -622,8 +627,6 @@ struct io_kiocb {
 	 */
 	u16				buf_index;
 
-	unsigned			nr_tw;
-
 	/* REQ_F_* flags */
 	io_req_flags_t			flags;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c3a7d0197636..b7eb962e9872 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -339,7 +339,8 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
-	init_llist_head(&ctx->work_llist);
+	INIT_WQ_LIST(&ctx->work_list);
+	spin_lock_init(&ctx->work_lock);
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	ctx->submit_state.free_list.next = NULL;
 	INIT_HLIST_HEAD(&ctx->waitid_list);
@@ -1066,25 +1067,31 @@ struct llist_node *io_handle_tw_list(struct llist_node *node,
 	return node;
 }
 
-static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
+static __cold void __io_fallback_tw(struct io_kiocb *req, bool sync,
+				    struct io_ring_ctx **last_ctx)
 {
+	if (sync && *last_ctx != req->ctx) {
+		if (*last_ctx) {
+			flush_delayed_work(&(*last_ctx)->fallback_work);
+			percpu_ref_put(&(*last_ctx)->refs);
+		}
+		*last_ctx = req->ctx;
+		percpu_ref_get(&(*last_ctx)->refs);
+	}
+	if (llist_add(&req->io_task_work.node, &req->ctx->fallback_llist))
+		schedule_delayed_work(&req->ctx->fallback_work, 1);
+}
+
+static void io_fallback_tw(struct io_uring_task *tctx, bool sync)
+{
+	struct llist_node *node = llist_del_all(&tctx->task_list);
 	struct io_ring_ctx *last_ctx = NULL;
 	struct io_kiocb *req;
 
 	while (node) {
 		req = container_of(node, struct io_kiocb, io_task_work.node);
 		node = node->next;
-		if (sync && last_ctx != req->ctx) {
-			if (last_ctx) {
-				flush_delayed_work(&last_ctx->fallback_work);
-				percpu_ref_put(&last_ctx->refs);
-			}
-			last_ctx = req->ctx;
-			percpu_ref_get(&last_ctx->refs);
-		}
-		if (llist_add(&req->io_task_work.node,
-			      &req->ctx->fallback_llist))
-			schedule_delayed_work(&req->ctx->fallback_work, 1);
+		__io_fallback_tw(req, sync, &last_ctx);
 	}
 
 	if (last_ctx) {
@@ -1093,13 +1100,6 @@ static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
 	}
 }
 
-static void io_fallback_tw(struct io_uring_task *tctx, bool sync)
-{
-	struct llist_node *node = llist_del_all(&tctx->task_list);
-
-	__io_fallback_tw(node, sync);
-}
-
 struct llist_node *tctx_task_work_run(struct io_uring_task *tctx,
 				      unsigned int max_entries,
 				      unsigned int *count)
@@ -1139,65 +1139,45 @@ void tctx_task_work(struct callback_head *cb)
 
 static inline void io_req_local_work_add(struct io_kiocb *req,
 					 struct io_ring_ctx *ctx,
-					 unsigned flags)
+					 unsigned tw_flags)
 {
-	unsigned nr_wait, nr_tw, nr_tw_prev;
-	struct llist_node *head;
+	unsigned nr_tw, nr_tw_prev, nr_wait;
+	unsigned long flags;
 
 	/* See comment above IO_CQ_WAKE_INIT */
 	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
 
 	/*
-	 * We don't know how many reuqests is there in the link and whether
-	 * they can even be queued lazily, fall back to non-lazy.
+	 * We don't know how many requests are in the link and whether they can
+	 * even be queued lazily, fall back to non-lazy.
 	 */
 	if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK))
-		flags &= ~IOU_F_TWQ_LAZY_WAKE;
+		tw_flags &= ~IOU_F_TWQ_LAZY_WAKE;
 
-	guard(rcu)();
+	spin_lock_irqsave(&ctx->work_lock, flags);
+	wq_list_add_tail(&req->io_task_work.work_node, &ctx->work_list);
+	nr_tw_prev = ctx->work_items++;
+	spin_unlock_irqrestore(&ctx->work_lock, flags);
 
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
-
-		req->nr_tw = nr_tw;
-		req->io_task_work.node.next = head;
-	} while (!try_cmpxchg(&ctx->work_llist.first, &head,
-			      &req->io_task_work.node));
-
-	/*
-	 * cmpxchg implies a full barrier, which pairs with the barrier
-	 * in set_current_state() on the io_cqring_wait() side. It's used
-	 * to ensure that either we see updated ->cq_wait_nr, or waiters
-	 * going to sleep will observe the work added to the list, which
-	 * is similar to the wait/wawke task state sync.
-	 */
+	nr_tw = nr_tw_prev + 1;
+	if (!(tw_flags & IOU_F_TWQ_LAZY_WAKE))
+		nr_tw = IO_CQ_WAKE_FORCE;
 
-	if (!head) {
+	if (!nr_tw_prev) {
 		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 		if (ctx->has_evfd)
 			io_eventfd_signal(ctx);
 	}
 
+	/*
+	 * We need a barrier after unlock, which pairs with the barrier
+	 * in set_current_state() on the io_cqring_wait() side. It's used
+	 * to ensure that either we see updated ->cq_wait_nr, or waiters
+	 * going to sleep will observe the work added to the list, which
+	 * is similar to the wait/wake task state sync.
+	 */
+	smp_mb();
 	nr_wait = atomic_read(&ctx->cq_wait_nr);
 	/* not enough or no one is waiting */
 	if (nr_tw < nr_wait)
@@ -1253,11 +1233,27 @@ void io_req_task_work_add_remote(struct io_kiocb *req, struct io_ring_ctx *ctx,
 
 static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 {
-	struct llist_node *node = llist_del_all(&ctx->work_llist);
+	struct io_ring_ctx *last_ctx = NULL;
+	struct io_wq_work_node *node;
+	unsigned long flags;
 
-	__io_fallback_tw(node, false);
-	node = llist_del_all(&ctx->retry_llist);
-	__io_fallback_tw(node, false);
+	spin_lock_irqsave(&ctx->work_lock, flags);
+	node = ctx->work_list.first;
+	INIT_WQ_LIST(&ctx->work_list);
+	ctx->work_items = 0;
+	spin_unlock_irqrestore(&ctx->work_lock, flags);
+
+	while (node) {
+		struct io_kiocb *req;
+
+		req = container_of(node, struct io_kiocb, io_task_work.work_node);
+		node = node->next;
+		__io_fallback_tw(req, false, &last_ctx);
+	}
+	if (last_ctx) {
+		flush_delayed_work(&last_ctx->fallback_work);
+		percpu_ref_put(&last_ctx->refs);
+	}
 }
 
 static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
@@ -1272,52 +1268,52 @@ static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
 	return false;
 }
 
-static int __io_run_local_work_loop(struct llist_node **node,
-				    struct io_tw_state *ts,
-				    int events)
-{
-	while (*node) {
-		struct llist_node *next = (*node)->next;
-		struct io_kiocb *req = container_of(*node, struct io_kiocb,
-						    io_task_work.node);
-		INDIRECT_CALL_2(req->io_task_work.func,
-				io_poll_task_func, io_req_rw_complete,
-				req, ts);
-		*node = next;
-		if (--events <= 0)
-			break;
-	}
-
-	return events;
-}
-
 static int __io_run_local_work(struct io_ring_ctx *ctx, struct io_tw_state *ts,
 			       int min_events)
 {
-	struct llist_node *node;
+	struct io_wq_work_node *node, *tail;
+	int ret, limit, nitems;
 	unsigned int loops = 0;
-	int ret, limit;
 
 	if (WARN_ON_ONCE(ctx->submitter_task != current))
 		return -EEXIST;
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+	ret = 0;
 	limit = max(IO_LOCAL_TW_DEFAULT_MAX, min_events);
 again:
-	ret = __io_run_local_work_loop(&ctx->retry_llist.first, ts, limit);
-	if (ctx->retry_llist.first)
+	spin_lock_irq(&ctx->work_lock);
+	node = ctx->work_list.first;
+	tail = ctx->work_list.last;
+	nitems = ctx->work_items;
+	INIT_WQ_LIST(&ctx->work_list);
+	ctx->work_items = 0;
+	spin_unlock_irq(&ctx->work_lock);
+
+	while (node) {
+		struct io_kiocb *req = container_of(node, struct io_kiocb,
+						    io_task_work.work_node);
+		node = node->next;
+		INDIRECT_CALL_2(req->io_task_work.func,
+				io_poll_task_func, io_req_rw_complete,
+				req, ts);
+		nitems--;
+		if (++ret >= limit)
+			break;
+	}
+
+	if (unlikely(node)) {
+		spin_lock_irq(&ctx->work_lock);
+		tail->next = ctx->work_list.first;
+		ctx->work_list.first = node;
+		if (!ctx->work_list.last)
+			ctx->work_list.last = tail;
+		ctx->work_items += nitems;
+		spin_unlock_irq(&ctx->work_lock);
 		goto retry_done;
+	}
 
-	/*
-	 * llists are in reverse order, flip it back the right way before
-	 * running the pending items.
-	 */
-	node = llist_reverse_order(llist_del_all(&ctx->work_llist));
-	ret = __io_run_local_work_loop(&node, ts, ret);
-	ctx->retry_llist.first = node;
 	loops++;
-
-	ret = limit - ret;
 	if (io_run_local_work_continue(ctx, ret, min_events))
 		goto again;
 retry_done:
@@ -2413,7 +2409,7 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
 	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
 		atomic_set(&ctx->cq_wait_nr, 1);
 		smp_mb();
-		if (!llist_empty(&ctx->work_llist))
+		if (io_local_work_pending(ctx))
 			goto out_wake;
 	}
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 214f9f175102..2fae27803116 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -349,7 +349,7 @@ static inline int io_run_task_work(void)
 
 static inline bool io_local_work_pending(struct io_ring_ctx *ctx)
 {
-	return !llist_empty(&ctx->work_llist) || !llist_empty(&ctx->retry_llist);
+	return READ_ONCE(ctx->work_list.first);
 }
 
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
-- 
2.45.2


