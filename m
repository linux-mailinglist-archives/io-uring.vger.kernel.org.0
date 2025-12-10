Return-Path: <io-uring+bounces-10999-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 16008CB277F
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 09:55:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0635830052B5
	for <lists+io-uring@lfdr.de>; Wed, 10 Dec 2025 08:55:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 681502C15B0;
	Wed, 10 Dec 2025 08:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e7zxpHCn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A9422256B
	for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 08:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765356923; cv=none; b=Ja2sOaBIL5Kpb4vRJKO2nhzCeLxGv8dVtnGtv1i0HMeJ/BDteFejWEUFp772i+j9X2dp99Ig51xQfBd66azNUqiZT8hCV9FzJ0JHiwApDvJuxvapAF4J4kqx0X62xhEXEBzXmEX/Y1K5Lc+1bULt9EDDW4EXyKfz2r3Ca5WAmT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765356923; c=relaxed/simple;
	bh=wDFHtDKFQdi5YI/FD0Uo1yEdliK2HXUdra2o4KtX6ag=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Yo8jXZA9/3FxNyVHQiQPEyCHyHphi+su/6Vc4MwWiqHSpClOHvCgVKY1o7K3dMuKHMm6qSwhM4oCcen3bbiPiujqFKXaKJ2YECx26JqeeJu1JbbPhuD6oIz0z95BrNXiY+5nzFgvdbI8HIzp29lYbBDVOoaqqn6WuVWMF6q8ytc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e7zxpHCn; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7b75e366866so2880662b3a.2
        for <io-uring@vger.kernel.org>; Wed, 10 Dec 2025 00:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765356921; x=1765961721; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkV1ipOZlpQUvwzCiY+HeP1kZedHCybSOXzbxEizszI=;
        b=e7zxpHCnzLe36P5U/cc1ER1sy8SAeKJguBGzfpdUm0wpHuNQbWs3H3BiKcpxqlXP/L
         A0D5sl94NKl7RFPATUUqxkmm+daIm6fKXtSrZRCkuhukFlcY2O6/RX+fyA0pz6/KmvZm
         uCT0kDdUzxzq+Q6R/9Ts5jX1sDuC/14z8iGobbm7K7KdBEICI40KI/YFb9Bod/UcinGX
         boC+nC2KwS8YKCXS+LEe1ICScajebp2vqdcEgm0/cis1XU+6ea742m0KMZT7q2b29TC0
         KhMUnsd2SHbViefCThp0gyPn0gbK7Ms4uqCRkvSB3yf+LzhSmVgQvmmw5f6dFXEoqPwJ
         yHsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765356921; x=1765961721;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PkV1ipOZlpQUvwzCiY+HeP1kZedHCybSOXzbxEizszI=;
        b=eNYI7tcb4h6o6qKjNLAAYuIIFbT1GuMw5JZGhIrXw4Ongt6c1TMl9fdsRnYq2fA5g3
         h/VUsXm3P8Qjv3hloUxJoheWXJ/a9QJ3n3nICEHI8ONkukVC8EW9vUkQzOzdtlVtqHNM
         DxHIXXjuRNQAz0mtf6lOkrnJjFf/fb53bSQtHJGCI9KVgZUI2CFtIxFztTlyBs8AEQIl
         oHtMaOp5aL7vBhVf3VXWBj5LwYvdOPhRdyrhtbq/QB1bR73WbEvOOVY8oGxyjQQwO2QJ
         xpp5LfojuAkzQG1BqqGWqIPmOgnPJNpnNDEjJ87pXVeGv+iC1Jl05j7xk8dQUk0fV4t2
         aGEQ==
X-Forwarded-Encrypted: i=1; AJvYcCXL1MroK9MpixNHHHSKQ7tjO0rwC5Gmh7P8IYS4g3SeWuk1a3Go4O0pyuWQKid7AA3SMndvXw4wbg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzotpCOKNX7OHuHmd2PeYgbRh5RQjXD2NvtrfsE9eyf6bJWfQBy
	M5skG4ALFhEbpt6E4kc3A0MSiYPWG0xEPClw+qggXiVllRE/+ErStnOtBhQKrRQo
X-Gm-Gg: ASbGncsqgDimwdtXhs3A2K5KPIGFiWi+ucz6jj1f/TV60bXteSVSRoEw6wQp2lWSSuB
	4AQuXiRY29lSMGizJf309ethCxWbUBhjy+m32BT4y8TSHMxUfSOZS8QFIHeVvQzmOU2Gur3Mdd8
	QnQZ/+EPDm5VjnW3WBPkvOTnnhOZy9GaGyhjNLPR28ZswdizaDf8vI7aSEcZ2FX64u2QpKbbVEM
	nkqa/wyvbAU38i/+DjrBmMGTyf7w17qW7K76YkLWhEUYUExQIhzz/Y0DAaECyLAiJOnF4aI3PiP
	TTdSNOcj/EwY8OzJRqPIklRbfH7U+gXq57YP83qYtxC25751qXPPlo3aOkrXqr4u/cScHqP5HZD
	H3AFyivlDMHvSinCDIsk5qwOB1Ka0dxKSEs1tlfdiwpQnIbj6BDxXzNDyV8UyMOIormXIbbYP2I
	WAHQeE0gCSsJPwNyiE5/Z6W/Nnjdvu80z4K/gt0xrq8/B11n2cwrMbrw==
X-Google-Smtp-Source: AGHT+IFnfLRlDmWloHO20Qy16Tj0IVL4pbMrcwY8WYF7dxiJ6HXHiwxbbUCghKT/C7MysCn0tdngvw==
X-Received: by 2002:a05:6a20:a127:b0:35d:2172:5ffb with SMTP id adf61e73a8af0-366e24507b7mr1731951637.47.1765356920495;
        Wed, 10 Dec 2025 00:55:20 -0800 (PST)
Received: from localhost.localdomain ([101.71.133.196])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-7e2ae6fcc87sm18681836b3a.49.2025.12.10.00.55.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Dec 2025 00:55:20 -0800 (PST)
From: Fengnan Chang <fengnanchang@gmail.com>
X-Google-Original-From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Cc: Fengnan Chang <changfengnan@bytedance.com>,
	Diangang Li <lidiangang@bytedance.com>
Subject: [RFC PATCH 2/2] io_uring: fix io may accumulation in poll mode
Date: Wed, 10 Dec 2025 16:55:01 +0800
Message-Id: <20251210085501.84261-3-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20251210085501.84261-1-changfengnan@bytedance.com>
References: <20251210085501.84261-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the io_do_iopoll function, when the poll loop of iopoll_list ends, it
is considered that the current req is the actual completed request.
This may be reasonable for multi-queue ctx, but is problematic for
single-queue ctx because the current request may not be done when the
poll gets to the result. In this case, the completed io needs to wait
for the first io on the chain to complete before notifying the user,
which may cause io accumulation in the list.
Our modification plan is as follows: change io_wq_work_list to normal
list so that the iopoll_list list in it can be removed and put into the
comp_reqs list when the request is completed. This way each io is
handled independently and all gets processed in time.

After modification,  test with:

./t/io_uring -p1 -d128 -b4096 -s32 -c32 -F1 -B1 -R1 -X1 -n1 -P1
/dev/nvme6n1

base IOPS is 725K,  patch IOPS is 782K.

./t/io_uring -p1 -d128 -b4096 -s32 -c1 -F1 -B1 -R1 -X1 -n1 -P1
/dev/nvme6n1

Base IOPS is 880k, patch IOPS is 895K.

Signed-off-by: Diangang Li <lidiangang@bytedance.com>
Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 include/linux/blk-mq.h         |  1 +
 include/linux/blkdev.h         |  1 +
 include/linux/io_uring_types.h |  8 +++---
 io_uring/io_uring.c            | 51 ++++++++++++++++------------------
 io_uring/io_uring.h            | 15 ++++------
 io_uring/rw.c                  | 35 +++++++----------------
 io_uring/slist.h               |  9 ------
 io_uring/sqpoll.c              |  8 +++---
 8 files changed, 49 insertions(+), 79 deletions(-)

diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index c16875b35521..39151998f8df 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -902,6 +902,7 @@ static inline bool blk_mq_add_to_batch(struct request *req,
 		return false;
 	iob->need_ts |= blk_mq_need_time_stamp(req);
 	rq_list_add_tail(&iob->req_list, req);
+	iob->req_count++;
 	return true;
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e25d9802e08b..923dbb1de6cf 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1822,6 +1822,7 @@ void bdev_fput(struct file *bdev_file);
 
 struct io_comp_batch {
 	struct rq_list req_list;
+	unsigned int req_count;
 	bool need_ts;
 	void (*complete)(struct io_comp_batch *);
 };
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c2ea6280901d..e9c70219c0f2 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -235,9 +235,9 @@ struct io_submit_link {
 
 struct io_submit_state {
 	/* inline/task_work completion list, under ->uring_lock */
-	struct io_wq_work_node	free_list;
+	struct list_head	free_list;
 	/* batch completion logic */
-	struct io_wq_work_list	compl_reqs;
+	struct list_head	compl_reqs;
 	struct io_submit_link	link;
 
 	bool			plug_started;
@@ -317,7 +317,7 @@ struct io_ring_ctx {
 		 * manipulate the list, hence no extra locking is needed there.
 		 */
 		bool			poll_multi_queue;
-		struct io_wq_work_list	iopoll_list;
+		struct list_head	iopoll_list;
 
 		struct io_file_table	file_table;
 		struct io_rsrc_data	buf_table;
@@ -695,7 +695,7 @@ struct io_kiocb {
 
 	union {
 		/* used by request caches, completion batching and iopoll */
-		struct io_wq_work_node	comp_list;
+		struct list_head	comp_list;
 		/* cache ->apoll->events */
 		__poll_t apoll_events;
 	};
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 296667ba712c..a7166656093a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -255,7 +255,7 @@ static inline void io_req_add_to_cache(struct io_kiocb *req, struct io_ring_ctx
 {
 	if (IS_ENABLED(CONFIG_KASAN))
 		io_poison_cached_req(req);
-	wq_stack_add_head(&req->comp_list, &ctx->submit_state.free_list);
+	list_add(&req->comp_list, &ctx->submit_state.free_list);
 }
 
 static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
@@ -367,20 +367,20 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	init_waitqueue_head(&ctx->poll_wq);
 	spin_lock_init(&ctx->completion_lock);
 	raw_spin_lock_init(&ctx->timeout_lock);
-	INIT_WQ_LIST(&ctx->iopoll_list);
+	INIT_LIST_HEAD(&ctx->iopoll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
 	init_llist_head(&ctx->work_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
-	ctx->submit_state.free_list.next = NULL;
+	INIT_LIST_HEAD(&ctx->submit_state.free_list);
 	INIT_HLIST_HEAD(&ctx->waitid_list);
 	xa_init_flags(&ctx->zcrx_ctxs, XA_FLAGS_ALLOC);
 #ifdef CONFIG_FUTEX
 	INIT_HLIST_HEAD(&ctx->futex_list);
 #endif
 	INIT_DELAYED_WORK(&ctx->fallback_work, io_fallback_req_func);
-	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
+	INIT_LIST_HEAD(&ctx->submit_state.compl_reqs);
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
 	io_napi_init(ctx);
 	mutex_init(&ctx->mmap_lock);
@@ -945,7 +945,7 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags)
 	 * those are flushed first before posting this one. If not, CQEs
 	 * could get reordered.
 	 */
-	if (!wq_list_empty(&ctx->submit_state.compl_reqs))
+	if (!list_empty(&ctx->submit_state.compl_reqs))
 		__io_submit_flush_completions(ctx);
 
 	lockdep_assert(!io_wq_current_is_worker());
@@ -1498,9 +1498,10 @@ static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
 }
 
 static void io_free_batch_list(struct io_ring_ctx *ctx,
-			       struct io_wq_work_node *node)
+			       struct list_head *head)
 	__must_hold(&ctx->uring_lock)
 {
+	struct list_head *node = head->next;
 	do {
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
@@ -1536,20 +1537,17 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 
 		node = req->comp_list.next;
 		io_req_add_to_cache(req, ctx);
-	} while (node);
+	} while (!list_is_head(node, head));
 }
 
 void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
-	struct io_wq_work_node *node;
+	struct io_kiocb *req;
 
 	__io_cq_lock(ctx);
-	__wq_list_for_each(node, &state->compl_reqs) {
-		struct io_kiocb *req = container_of(node, struct io_kiocb,
-					    comp_list);
-
+	list_for_each_entry(req, &state->compl_reqs, comp_list) {
 		/*
 		 * Requests marked with REQUEUE should not post a CQE, they
 		 * will go through the io-wq retry machinery and post one
@@ -1565,9 +1563,9 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	}
 	__io_cq_unlock_post(ctx);
 
-	if (!wq_list_empty(&state->compl_reqs)) {
-		io_free_batch_list(ctx, state->compl_reqs.first);
-		INIT_WQ_LIST(&state->compl_reqs);
+	if (!list_empty(&state->compl_reqs)) {
+		io_free_batch_list(ctx, &state->compl_reqs);
+		INIT_LIST_HEAD(&state->compl_reqs);
 	}
 
 	if (unlikely(ctx->drain_active))
@@ -1593,7 +1591,7 @@ static __cold void io_iopoll_try_reap_events(struct io_ring_ctx *ctx)
 		return;
 
 	mutex_lock(&ctx->uring_lock);
-	while (!wq_list_empty(&ctx->iopoll_list)) {
+	while (!list_empty(&ctx->iopoll_list)) {
 		/* let it sleep and repeat later if can't complete a request */
 		if (io_do_iopoll(ctx, true) == 0)
 			break;
@@ -1658,21 +1656,21 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned int min_events)
 		 * forever, while the workqueue is stuck trying to acquire the
 		 * very same mutex.
 		 */
-		if (wq_list_empty(&ctx->iopoll_list) ||
+		if (list_empty(&ctx->iopoll_list) ||
 		    io_task_work_pending(ctx)) {
 			u32 tail = ctx->cached_cq_tail;
 
 			(void) io_run_local_work_locked(ctx, min_events);
 
 			if (task_work_pending(current) ||
-			    wq_list_empty(&ctx->iopoll_list)) {
+			    list_empty(&ctx->iopoll_list)) {
 				mutex_unlock(&ctx->uring_lock);
 				io_run_task_work();
 				mutex_lock(&ctx->uring_lock);
 			}
 			/* some requests don't go through iopoll_list */
 			if (tail != ctx->cached_cq_tail ||
-			    wq_list_empty(&ctx->iopoll_list))
+			    list_empty(&ctx->iopoll_list))
 				break;
 		}
 		ret = io_do_iopoll(ctx, !min_events);
@@ -1715,13 +1713,12 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 	 * how we do polling eventually, not spinning if we're on potentially
 	 * different devices.
 	 */
-	if (wq_list_empty(&ctx->iopoll_list)) {
+	if (list_empty(&ctx->iopoll_list)) {
 		ctx->poll_multi_queue = false;
 	} else if (!ctx->poll_multi_queue) {
 		struct io_kiocb *list_req;
 
-		list_req = container_of(ctx->iopoll_list.first, struct io_kiocb,
-					comp_list);
+		list_req = list_first_entry(&ctx->iopoll_list, struct io_kiocb, comp_list);
 		if (list_req->file != req->file)
 			ctx->poll_multi_queue = true;
 	}
@@ -1731,9 +1728,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req, unsigned int issue_flags)
 	 * it to the front so we find it first.
 	 */
 	if (READ_ONCE(req->iopoll_completed))
-		wq_list_add_head(&req->comp_list, &ctx->iopoll_list);
+		list_add(&req->comp_list, &ctx->iopoll_list);
 	else
-		wq_list_add_tail(&req->comp_list, &ctx->iopoll_list);
+		list_add_tail(&req->comp_list, &ctx->iopoll_list);
 
 	if (unlikely(needs_lock)) {
 		/*
@@ -2454,7 +2451,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	if (unlikely(left)) {
 		ret -= left;
 		/* try again if it submitted nothing and can't allocate a req */
-		if (!ret && io_req_cache_empty(ctx))
+		if (!ret && list_empty(&ctx->submit_state.free_list))
 			ret = -EAGAIN;
 		current->io_uring->cached_refs += left;
 	}
@@ -2818,7 +2815,7 @@ static __cold void __io_req_caches_free(struct io_ring_ctx *ctx)
 	struct io_kiocb *req;
 	int nr = 0;
 
-	while (!io_req_cache_empty(ctx)) {
+	while (!list_empty(&ctx->submit_state.free_list)) {
 		req = io_extract_req(ctx);
 		io_poison_req(req);
 		kmem_cache_free(req_cachep, req);
@@ -3215,7 +3212,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	/* SQPOLL thread does its own polling */
 	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
 	    is_sqpoll_thread) {
-		while (!wq_list_empty(&ctx->iopoll_list)) {
+		while (!list_empty(&ctx->iopoll_list)) {
 			io_iopoll_try_reap_events(ctx);
 			ret = true;
 			cond_resched();
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 46d9141d772a..acc82a1b7107 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -215,7 +215,7 @@ static inline void io_req_task_work_add(struct io_kiocb *req)
 
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
-	if (!wq_list_empty(&ctx->submit_state.compl_reqs) ||
+	if (!list_empty(&ctx->submit_state.compl_reqs) ||
 	    ctx->submit_state.cq_flush)
 		__io_submit_flush_completions(ctx);
 }
@@ -502,7 +502,7 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 
 	lockdep_assert_held(&req->ctx->uring_lock);
 
-	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
+	list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
 static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
@@ -521,25 +521,20 @@ static inline void io_get_task_refs(int nr)
 		io_task_refs_refill(tctx);
 }
 
-static inline bool io_req_cache_empty(struct io_ring_ctx *ctx)
-{
-	return !ctx->submit_state.free_list.next;
-}
-
 extern struct kmem_cache *req_cachep;
 
 static inline struct io_kiocb *io_extract_req(struct io_ring_ctx *ctx)
 {
 	struct io_kiocb *req;
 
-	req = container_of(ctx->submit_state.free_list.next, struct io_kiocb, comp_list);
-	wq_stack_extract(&ctx->submit_state.free_list);
+	req = list_first_entry(&ctx->submit_state.free_list, struct io_kiocb, comp_list);
+	list_del_init(&req->comp_list);
 	return req;
 }
 
 static inline bool io_alloc_req(struct io_ring_ctx *ctx, struct io_kiocb **req)
 {
-	if (unlikely(io_req_cache_empty(ctx))) {
+	if (unlikely(list_empty(&ctx->submit_state.free_list))) {
 		if (!__io_alloc_req_refill(ctx))
 			return false;
 	}
diff --git a/io_uring/rw.c b/io_uring/rw.c
index abe68ba9c9dc..4ecd41f48812 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -616,6 +616,11 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 
 	/* order with io_iopoll_complete() checking ->iopoll_completed */
 	smp_store_release(&req->iopoll_completed, 1);
+
+	req->cqe.flags = io_put_kbuf(req, req->cqe.res, NULL);
+	if (req->opcode != IORING_OP_URING_CMD)
+		io_req_rw_cleanup(req, 0);
+	list_move_tail(&req->comp_list, &req->ctx->submit_state.compl_reqs);
 }
 
 static inline void io_rw_done(struct io_kiocb *req, ssize_t ret)
@@ -1326,10 +1331,9 @@ static int io_uring_hybrid_poll(struct io_kiocb *req,
 
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
-	struct io_wq_work_node *pos, *start, *prev;
+	struct io_kiocb *req, *next;
 	unsigned int poll_flags = 0;
 	DEFINE_IO_COMP_BATCH(iob);
-	int nr_events = 0;
 
 	/*
 	 * Only spin for completions if we don't have multiple devices hanging
@@ -1338,8 +1342,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	if (ctx->poll_multi_queue || force_nonspin)
 		poll_flags |= BLK_POLL_ONESHOT;
 
-	wq_list_for_each(pos, start, &ctx->iopoll_list) {
-		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
+	list_for_each_entry(req, &ctx->iopoll_list, comp_list) {
 		int ret;
 
 		/*
@@ -1368,32 +1371,14 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 
 	if (!rq_list_empty(&iob.req_list))
 		iob.complete(&iob);
-	else if (!pos)
+	else if (list_entry_is_head(req, &ctx->iopoll_list, comp_list))
 		return 0;
 
-	prev = start;
-	wq_list_for_each_resume(pos, prev) {
-		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
-
-		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
-		if (!smp_load_acquire(&req->iopoll_completed))
-			break;
-		nr_events++;
-		req->cqe.flags = io_put_kbuf(req, req->cqe.res, NULL);
-		if (req->opcode != IORING_OP_URING_CMD)
-			io_req_rw_cleanup(req, 0);
-	}
-	if (unlikely(!nr_events))
+	if (unlikely(!iob.req_count))
 		return 0;
 
-	pos = start ? start->next : ctx->iopoll_list.first;
-	wq_list_cut(&ctx->iopoll_list, prev, start);
-
-	if (WARN_ON_ONCE(!wq_list_empty(&ctx->submit_state.compl_reqs)))
-		return 0;
-	ctx->submit_state.compl_reqs.first = pos;
 	__io_submit_flush_completions(ctx);
-	return nr_events;
+	return iob.req_count;
 }
 
 void io_rw_cache_free(const void *entry)
diff --git a/io_uring/slist.h b/io_uring/slist.h
index 0eb194817242..f62e12c67e4f 100644
--- a/io_uring/slist.h
+++ b/io_uring/slist.h
@@ -99,15 +99,6 @@ static inline void wq_list_del(struct io_wq_work_list *list,
 	wq_list_cut(list, node, prev);
 }
 
-static inline
-struct io_wq_work_node *wq_stack_extract(struct io_wq_work_node *stack)
-{
-	struct io_wq_work_node *node = stack->next;
-
-	stack->next = node->next;
-	return node;
-}
-
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
 {
 	if (!work->list.next)
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index e22f072c7d5f..aac7a2c69892 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -211,7 +211,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, struct io_sq_data *sqd,
 	if (cap_entries && to_submit > IORING_SQPOLL_CAP_ENTRIES_VALUE)
 		to_submit = IORING_SQPOLL_CAP_ENTRIES_VALUE;
 
-	if (to_submit || !wq_list_empty(&ctx->iopoll_list)) {
+	if (to_submit || !list_empty(&ctx->iopoll_list)) {
 		const struct cred *creds = NULL;
 
 		io_sq_start_worktime(ist);
@@ -220,7 +220,7 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, struct io_sq_data *sqd,
 			creds = override_creds(ctx->sq_creds);
 
 		mutex_lock(&ctx->uring_lock);
-		if (!wq_list_empty(&ctx->iopoll_list))
+		if (!list_empty(&ctx->iopoll_list))
 			io_do_iopoll(ctx, true);
 
 		/*
@@ -343,7 +343,7 @@ static int io_sq_thread(void *data)
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, sqd, cap_entries, &ist);
 
-			if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
+			if (!sqt_spin && (ret > 0 || !list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
 		}
 		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
@@ -378,7 +378,7 @@ static int io_sq_thread(void *data)
 				atomic_or(IORING_SQ_NEED_WAKEUP,
 						&ctx->rings->sq_flags);
 				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
-				    !wq_list_empty(&ctx->iopoll_list)) {
+				    !list_empty(&ctx->iopoll_list)) {
 					needs_sched = false;
 					break;
 				}
-- 
2.39.5 (Apple Git-154)


