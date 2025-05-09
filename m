Return-Path: <io-uring+bounces-7931-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A645AB11EC
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 13:13:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D34031B644E3
	for <lists+io-uring@lfdr.de>; Fri,  9 May 2025 11:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A3D028E561;
	Fri,  9 May 2025 11:11:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QWdhsBtB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7630F28F942
	for <io-uring@vger.kernel.org>; Fri,  9 May 2025 11:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746789118; cv=none; b=SC+ldB8HDvO2pLMZBXOp1pRjSHDe3mcQGb7IrunyenHsmSevH3Wz6a6sPKr4Ix2n7lvx3F2Rww3RPKPeyNmcW1KRMQ0R1sLaZ6m3e6wTpcTbRw2167cIigRUrTejcIzCSsE7bF6hXg1VvHcKVuh3bpAdRitFYqSRJU4MPt3u/SA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746789118; c=relaxed/simple;
	bh=u65yDkBUAA95x/3bFFZimhNDrPnPV1soCsQsmt680HU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJPlU/062WHUqZLX+CWqfY6X9srY/tcjds0kmq5irAeSQcH94ODmW6JGZMnHAjw18uicofJdmlfL3gMsKx+ORW8yPfnvd+PVwFlHOOgmWW7ZBE4CeCqOmNgJbUTaT04+jJTnDoE49bE08sZZ8nID2SKZ5S7/rKEfY7aCXjDmQtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QWdhsBtB; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5fbf52aad74so4821974a12.1
        for <io-uring@vger.kernel.org>; Fri, 09 May 2025 04:11:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746789114; x=1747393914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4+2EMgNcYB8BlRRZoIBot/TpIJW1t/CDt6qL0wwR8sM=;
        b=QWdhsBtBsUOamF9kWa6IO9i/RNq7J5ObYI8568K9raptLdXaRj2H6OF7wNA+2j9KSt
         75uknJ84Shhn+8P1zkOjPH8sRM41NY5vnaGoVUwllm3yrcCGYEHaxFcsAUJ10IpXPj1Y
         AP4JO38cIFav5yrXQkz7r2dLtuAJja4b77aMoA0pFMVqMiMhvY0GAom6cmrpfrcY3+K8
         Z2CrKGG9VihfzOga9v+PPso/Zad9FRWdgKRj3iEdqE7+60d5C/jOcu+2Z2KxkZyLVwf+
         YbZpw3joPf6rzMjMZ8bgD9Hoeb1rxO5ZrTxbEHLD2LgHjMEBnoPs96j/gz/jVAqAwiN1
         qJMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746789114; x=1747393914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4+2EMgNcYB8BlRRZoIBot/TpIJW1t/CDt6qL0wwR8sM=;
        b=qFiXWjUwWdd6k5c4wJweq2LaZ+kYq9B7JycjNS02+/Hi/8exmCfQ72DxmYuHIXF127
         +MSqEvWZNCk+hBmcQcGML9wTMdCFkS54BGAxtynFh7rCxt6jTInelU2yQSwnt621VNqk
         uuJ2liNgicxLCHJnu/X5tRe5PyPahaTinTyGyUmoMUarv8aWALhvse5oMjucyXg+o/6k
         lbM06zeFvTPNvTxt2Inwny+RCgbgtwnoyguMt5yE7UtFxjGiKTLafb9+FHw2yWDgL70t
         6N4ZAve5tpOFQMh2ZXM3wlaP7yX34bg0UbJM6w97dhsU18ELJ65uqg5n96u6BmGNtuOx
         787w==
X-Gm-Message-State: AOJu0YxXR7QXwjlE2OM9JtUZ4J2pENjvY4yALKJ2dcy8rLZcaB4bu8xd
	/zDIP6bzLLOMukqufgFj8D63IwOJvqlRN3jirKbV1cDhBByo7PaxKXjxBA==
X-Gm-Gg: ASbGncshD7YQ+JMUqtjXgLzpGY1+NITw5RvB6mJ5uluYTeFKGoy3gMTuAgcP8Q32Bdl
	83HeS7Owd8WMw6TKGLlDFvZJMUtqHhaCOekmgKivz4cdFrga7BpOs+s2A7sinTeu8ghFhZoOUNk
	cLOizgSjgS6/2akGQ++pszLS3P0+l59gBCzb2QGt7k18hNcTTl8VqwCzOLW4nxpuQK61MnHep/y
	dvPOKPthdOD59ZWFZ7Gcy1Wi2Y1dCYxlBvwLYiUQyDp7zJmGNK0itNkl4/HGsxt+0F5WbkLKwRp
	Ula7xGpIikz7Hfj6IZ7QVQdR
X-Google-Smtp-Source: AGHT+IEfrZ1m+gVVEpCJCKqWrtSG2mMhfq2PSXF/6c7am5BYzy1+V9ECEkBhPMhKUKokwWL5Ky5QHg==
X-Received: by 2002:a17:907:97c4:b0:ad2:134d:d64e with SMTP id a640c23a62f3a-ad21b425d82mr219627366b.19.1746789114181;
        Fri, 09 May 2025 04:11:54 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:4a65])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad219746dfasm132717066b.119.2025.05.09.04.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 May 2025 04:11:53 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 8/8] io_uring: drain based on allocates reqs
Date: Fri,  9 May 2025 12:12:54 +0100
Message-ID: <46ece1e34320b046c06fee2498d6b4cd12a700f2.1746788718.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1746788718.git.asml.silence@gmail.com>
References: <cover.1746788718.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Don't rely on CQ sequence numbers for draining, as it has become messy
and needs cq_extra adjustments. Instead, base it on the number of
allocated requests and only allow flushing when all requests are in the
drain list.

As a result, cq_extra is gone, no overhead for its accounting in aux cqe
posting, less bloating as it was inlined before, and it's in general
simpler than trying to track where we should bump it and where it should
be put back like in cases of overflow. Also, it'll likely help with
cleaning and unifying some of the CQ posting helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/io_uring.c            | 83 +++++++++++++++-------------------
 io_uring/io_uring.h            |  3 +-
 3 files changed, 38 insertions(+), 50 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 73b289b48280..00dbd7cd0e7d 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -341,7 +341,6 @@ struct io_ring_ctx {
 		unsigned		cached_cq_tail;
 		unsigned		cq_entries;
 		struct io_ev_fd	__rcu	*io_ev_fd;
-		unsigned		cq_extra;
 
 		void			*cq_wait_arg;
 		size_t			cq_wait_size;
@@ -417,6 +416,7 @@ struct io_ring_ctx {
 
 	struct callback_head		poll_wq_task_work;
 	struct list_head		defer_list;
+	unsigned			nr_drained;
 
 	struct io_alloc_cache		msg_cache;
 	spinlock_t			msg_lock;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 14188f49a4ce..0fda1b1a33ae 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -129,7 +129,6 @@
 struct io_defer_entry {
 	struct list_head	list;
 	struct io_kiocb		*req;
-	u32			seq;
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -149,6 +148,7 @@ static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 bool is_sqpoll_thread);
 
 static void io_queue_sqe(struct io_kiocb *req);
+static void __io_req_caches_free(struct io_ring_ctx *ctx);
 
 static __read_mostly DEFINE_STATIC_KEY_FALSE(io_key_has_sqarray);
 
@@ -540,46 +540,45 @@ void io_req_queue_iowq(struct io_kiocb *req)
 	io_req_task_work_add(req);
 }
 
-static bool io_drain_defer_seq(struct io_kiocb *req, u32 seq)
+static unsigned io_linked_nr(struct io_kiocb *req)
 {
-	struct io_ring_ctx *ctx = req->ctx;
+	struct io_kiocb *tmp;
+	unsigned nr = 0;
 
-	return seq + READ_ONCE(ctx->cq_extra) != ctx->cached_cq_tail;
+	io_for_each_link(tmp, req)
+		nr++;
+	return nr;
 }
 
-static __cold noinline void __io_queue_deferred(struct io_ring_ctx *ctx)
+static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
 {
 	bool drain_seen = false, first = true;
 
+	lockdep_assert_held(&ctx->uring_lock);
+	__io_req_caches_free(ctx);
+
 	while (!list_empty(&ctx->defer_list)) {
 		struct io_defer_entry *de = list_first_entry(&ctx->defer_list,
 						struct io_defer_entry, list);
 
 		drain_seen |= de->req->flags & REQ_F_IO_DRAIN;
-		if ((drain_seen || first) && io_drain_defer_seq(de->req, de->seq))
-			break;
+		if ((drain_seen || first) && ctx->nr_req_allocated != ctx->nr_drained)
+			return;
 
 		list_del_init(&de->list);
+		ctx->nr_drained -= io_linked_nr(de->req);
 		io_req_task_queue(de->req);
 		kfree(de);
 		first = false;
 	}
 }
 
-static __cold noinline void io_queue_deferred(struct io_ring_ctx *ctx)
-{
-	guard(spinlock)(&ctx->completion_lock);
-	__io_queue_deferred(ctx);
-}
-
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
 	if (ctx->poll_activated)
 		io_poll_wq_wake(ctx);
 	if (ctx->off_timeout_used)
 		io_flush_timeouts(ctx);
-	if (ctx->drain_active)
-		io_queue_deferred(ctx);
 	if (ctx->has_evfd)
 		io_eventfd_signal(ctx, true);
 }
@@ -742,7 +741,6 @@ static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 		 * on the floor.
 		 */
 		WRITE_ONCE(r->cq_overflow, READ_ONCE(r->cq_overflow) + 1);
-		ctx->cq_extra--;
 		set_bit(IO_CHECK_CQ_DROPPED_BIT, &ctx->check_cq);
 		return false;
 	}
@@ -812,8 +810,6 @@ static bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data, s32 res,
 {
 	struct io_uring_cqe *cqe;
 
-	ctx->cq_extra++;
-
 	if (likely(io_get_cqe(ctx, &cqe))) {
 		WRITE_ONCE(cqe->user_data, user_data);
 		WRITE_ONCE(cqe->res, res);
@@ -1456,6 +1452,10 @@ void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		io_free_batch_list(ctx, state->compl_reqs.first);
 		INIT_WQ_LIST(&state->compl_reqs);
 	}
+
+	if (unlikely(ctx->drain_active))
+		io_queue_deferred(ctx);
+
 	ctx->submit_state.cq_flush = false;
 }
 
@@ -1643,23 +1643,14 @@ io_req_flags_t io_file_get_flags(struct file *file)
 	return res;
 }
 
-static u32 io_get_sequence(struct io_kiocb *req)
-{
-	u32 seq = req->ctx->cached_sq_head;
-	struct io_kiocb *cur;
-
-	/* need original cached_sq_head, but it was increased for each req */
-	io_for_each_link(cur, req)
-		seq--;
-	return seq;
-}
-
 static __cold void io_drain_req(struct io_kiocb *req)
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	bool drain = req->flags & IOSQE_IO_DRAIN;
 	struct io_defer_entry *de;
+	struct io_kiocb *tmp;
+	int nr = 0;
 
 	de = kmalloc(sizeof(*de), GFP_KERNEL_ACCOUNT);
 	if (!de) {
@@ -1667,17 +1658,17 @@ static __cold void io_drain_req(struct io_kiocb *req)
 		return;
 	}
 
+	io_for_each_link(tmp, req)
+		nr++;
 	io_prep_async_link(req);
 	trace_io_uring_defer(req);
 	de->req = req;
-	de->seq = io_get_sequence(req);
 
-	scoped_guard(spinlock, &ctx->completion_lock) {
-		list_add_tail(&de->list, &ctx->defer_list);
-		__io_queue_deferred(ctx);
-		if (!drain && list_empty(&ctx->defer_list))
-			ctx->drain_active = false;
-	}
+	ctx->nr_drained += io_linked_nr(req);
+	list_add_tail(&de->list, &ctx->defer_list);
+	io_queue_deferred(ctx);
+	if (!drain && list_empty(&ctx->defer_list))
+		ctx->drain_active = false;
 }
 
 static bool io_assign_file(struct io_kiocb *req, const struct io_issue_def *def,
@@ -2260,10 +2251,6 @@ static bool io_get_sqe(struct io_ring_ctx *ctx, const struct io_uring_sqe **sqe)
 	    (!(ctx->flags & IORING_SETUP_NO_SQARRAY))) {
 		head = READ_ONCE(ctx->sq_array[head]);
 		if (unlikely(head >= ctx->sq_entries)) {
-			/* drop invalid entries */
-			spin_lock(&ctx->completion_lock);
-			ctx->cq_extra--;
-			spin_unlock(&ctx->completion_lock);
 			WRITE_ONCE(ctx->rings->sq_dropped,
 				   READ_ONCE(ctx->rings->sq_dropped) + 1);
 			return false;
@@ -2681,13 +2668,11 @@ unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 	return off;
 }
 
-static void io_req_caches_free(struct io_ring_ctx *ctx)
+static __cold void __io_req_caches_free(struct io_ring_ctx *ctx)
 {
 	struct io_kiocb *req;
 	int nr = 0;
 
-	mutex_lock(&ctx->uring_lock);
-
 	while (!io_req_cache_empty(ctx)) {
 		req = io_extract_req(ctx);
 		kmem_cache_free(req_cachep, req);
@@ -2697,7 +2682,12 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 		ctx->nr_req_allocated -= nr;
 		percpu_ref_put_many(&ctx->refs, nr);
 	}
-	mutex_unlock(&ctx->uring_lock);
+}
+
+static __cold void io_req_caches_free(struct io_ring_ctx *ctx)
+{
+	guard(mutex)(&ctx->uring_lock);
+	__io_req_caches_free(ctx);
 }
 
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
@@ -3002,20 +2992,19 @@ static __cold bool io_cancel_defer_files(struct io_ring_ctx *ctx,
 	struct io_defer_entry *de;
 	LIST_HEAD(list);
 
-	spin_lock(&ctx->completion_lock);
 	list_for_each_entry_reverse(de, &ctx->defer_list, list) {
 		if (io_match_task_safe(de->req, tctx, cancel_all)) {
 			list_cut_position(&list, &ctx->defer_list, &de->list);
 			break;
 		}
 	}
-	spin_unlock(&ctx->completion_lock);
 	if (list_empty(&list))
 		return false;
 
 	while (!list_empty(&list)) {
 		de = list_first_entry(&list, struct io_defer_entry, list);
 		list_del_init(&de->list);
+		ctx->nr_drained -= io_linked_nr(de->req);
 		io_req_task_queue_fail(de->req, -ECANCELED);
 		kfree(de);
 	}
@@ -3090,8 +3079,8 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    io_allowed_defer_tw_run(ctx))
 		ret |= io_run_local_work(ctx, INT_MAX, INT_MAX) > 0;
-	ret |= io_cancel_defer_files(ctx, tctx, cancel_all);
 	mutex_lock(&ctx->uring_lock);
+	ret |= io_cancel_defer_files(ctx, tctx, cancel_all);
 	ret |= io_poll_remove_all(ctx, tctx, cancel_all);
 	ret |= io_waitid_remove_all(ctx, tctx, cancel_all);
 	ret |= io_futex_remove_all(ctx, tctx, cancel_all);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e4050b2d0821..81f22196a57d 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -196,7 +196,6 @@ static inline bool io_defer_get_uncommited_cqe(struct io_ring_ctx *ctx,
 {
 	io_lockdep_assert_cq_locked(ctx);
 
-	ctx->cq_extra++;
 	ctx->submit_state.cq_flush = true;
 	return io_get_cqe(ctx, cqe_ret);
 }
@@ -414,7 +413,7 @@ static inline void io_req_complete_defer(struct io_kiocb *req)
 
 static inline void io_commit_cqring_flush(struct io_ring_ctx *ctx)
 {
-	if (unlikely(ctx->off_timeout_used || ctx->drain_active ||
+	if (unlikely(ctx->off_timeout_used ||
 		     ctx->has_evfd || ctx->poll_activated))
 		__io_commit_cqring_flush(ctx);
 }
-- 
2.49.0


