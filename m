Return-Path: <io-uring+bounces-11887-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0+YfAx5Wcmk7iwAAu9opvQ
	(envelope-from <io-uring+bounces-11887-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 17:53:50 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 98DC46A658
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 17:53:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 6310F301534F
	for <lists+io-uring@lfdr.de>; Thu, 22 Jan 2026 16:44:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74F553EB208;
	Thu, 22 Jan 2026 16:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hMDQRUh/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625093E7CAC
	for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 16:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769099084; cv=none; b=b8uWo43oHf7IgNQbz+f9Bdg+g8IhRVvRthdu93Ao/GO3x2fEbTiXQ8o/ITzuU8dqLGP7/bOpDHNktnDv1+1dNAgEXy4nfj60mLOn41MQ3yypqmQ1Ns3LcxRpWihjG3GsK7jCxzlDKRapr/m690UOyxXc465XcTjcJLEEa+K3WpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769099084; c=relaxed/simple;
	bh=HtfuPgu7aB8Fcu8IvKvSs+jPeBG85WYTVGr/7GfCUx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uyK8F2X7oCZ9peiv31RzxB7xNlz106TlDQiLAs9WO9mVpPo/FrBVoRCgLqYPIuErhF4itkmuhiYYH9LNWqhHpi12iqlv60FuV9BSmb4pSqcGE3/wVrk1tGfPjjvUForOQH/VU9+MvuM15x0WUtd02iGo1x+bE4blZTaPTzBqjuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hMDQRUh/; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-40413188553so682619fac.1
        for <io-uring@vger.kernel.org>; Thu, 22 Jan 2026 08:24:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1769099069; x=1769703869; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MGPAVswE9Rj+8aSppgj1Q/VAvIDu2EkvNfcWBmwRcew=;
        b=hMDQRUh/OvoF3lQMsuIaska91k9CCf/R2sYL22cTvo2QOdoGpAJybK+3Q9AYft3KGR
         +4TgUQjb5z8bs8QH8YGVw927gB/h2WhDNq5o1naLvnmUbOydVO2J5jYdU1K/uoxkTcYc
         h685bOyVSEdBqMexFV6P8PkM5ZCZ8ZKYvPMWRgHJ6ZQO6XJpLMNz9yoSciT45NOLiTd7
         R2BRhwAERxLjf8RrUpDtAWYtKiDECT5/UW7pG0TY8sZlfVY95JmV1fq9OT4t8J30qMOr
         a7/7ldBt1Jk63gKVvUIshXqJuyjJIxobA3sQVPOuGoFXh2pNqvcKhVVrbf4TZH2TeQKR
         B0NA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769099069; x=1769703869;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MGPAVswE9Rj+8aSppgj1Q/VAvIDu2EkvNfcWBmwRcew=;
        b=ljt0Kla9QmehtTyBmubnCoxIDY2eVl2By4vBPQDt/k8ueYfAp8CE9vv4U6T8opKxX4
         KKu9nCLBt8uXvnbEPP0czcf9Gmx4SNxZ4sp5AOsStWmAUvB2tmtPeZRygWOs4ZDLyJEM
         yU8AQV8/qM8jOCqXYscMFZeE2Qtk1fM+5fx4XWDhf4l7g4uCw9MRw9O4MeGF1ePOgh8q
         vwUrGc8mWr6ny/FhANFhZKKR4673rljLahPvWq8iCks7JCS1DlZqZVzFgtuCq9onZETD
         njcg4VkFwf3BqOIEx3cbE+gAGMMw7+l0t+b2cv37xstXwSiHQ5do3iaxXpPpDqFXBh6j
         AHcA==
X-Gm-Message-State: AOJu0Yyf6eQ6tFXeo0HnjV4cqk8pg43i/a9fJt+52FQsGMejntryoA6N
	5C+QLp/2N7FBcigSmCwu5jG2Kj2v1405HQmrHX1oskrEN9uIL0SaU+jI7kqrgQhcGscoLKZLhR+
	JR3ZR
X-Gm-Gg: AZuq6aLAxGVsqA/OWksf24Iw2z7zNlPNo+OXWTJmPYtY6OVqQkoVrluS9qy3oUEepRV
	ztNdPxlTlYtKzB5nFhqDB7nM3IPcS8bd2tM9Bw1WEJgX6ZJdpaSKj/DJUEpqMg60MIe/ISBRZp0
	eZnNVjwS90XI37kz6opl7rPeCOeTKC2HwVXqD2Y6vPhG/xdqgVnMbsGZzTNQOX0s3iG66XLYB91
	vDmKKLm3gdAYp4rlOMaH8M/yz7ZsHtgJH90leMvEZyTUj7sRTXm5MksJ8zfRzDb/nrWVf++q1oH
	ouGsbOqRAzAynofSPQtOvINgc0BBrztFQ2FedDpvnHAbqfOY6D9gigLlojRkL9idtp5OxUhfrqy
	N2vZ2zU3b9OLDZ9xRz9lGzyABG7K3W0M+Uh0BUPsNvZ6aCbnlxeQucbctH5wOhqexKgv2hLxThM
	6AQ42XhfHScELK+5KAscDTjpFpuCaZeNYmYupMjVU0unplAHBUsxsK75Y=
X-Received: by 2002:a05:6870:23a9:b0:404:1da3:8005 with SMTP id 586e51a60fabf-408ab883da2mr34969fac.54.1769099068567;
        Thu, 22 Jan 2026 08:24:28 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bd14883sm13408105fac.12.2026.01.22.08.24.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 08:24:27 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: split out task work code into tw.c
Date: Thu, 22 Jan 2026 09:21:51 -0700
Message-ID: <20260122162424.353513-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260122162424.353513-1-axboe@kernel.dk>
References: <20260122162424.353513-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-11887-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	TO_DN_SOME(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCVD_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,kernel.dk:email,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,fallback_work.work:url]
X-Rspamd-Queue-Id: 98DC46A658
X-Rspamd-Action: no action

Move the task work handling code out of io_uring.c into a new tw.c file.
This includes the local work, normal work, and fallback work handling
infrastructure.

The associated tw.h header contains io_should_terminate_tw() as a static
inline helper, along with the necessary function declarations.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/Makefile   |   3 +-
 io_uring/io_uring.c | 371 --------------------------------------------
 io_uring/io_uring.h |  79 +---------
 io_uring/tw.c       | 354 ++++++++++++++++++++++++++++++++++++++++++
 io_uring/tw.h       | 124 +++++++++++++++
 5 files changed, 483 insertions(+), 448 deletions(-)
 create mode 100644 io_uring/tw.c
 create mode 100644 io_uring/tw.h

diff --git a/io_uring/Makefile b/io_uring/Makefile
index bc4e4a3fa0a5..b7ea66a9fcfc 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -8,12 +8,13 @@ endif
 
 obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					tctx.o filetable.o rw.o poll.o \
-					eventfd.o uring_cmd.o openclose.o \
+					tw.o eventfd.o uring_cmd.o openclose.o \
 					sqpoll.o xattr.o nop.o fs.o splice.o \
 					sync.o msg_ring.o advise.o openclose.o \
 					statx.o timeout.o cancel.o \
 					waitid.o register.o truncate.o \
 					memmap.o alloc_cache.o query.o
+
 obj-$(CONFIG_IO_URING_ZCRX)	+= zcrx.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6c9003a3efae..f9b716c819d1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -110,19 +110,10 @@
 
 #define IO_COMPL_BATCH			32
 #define IO_REQ_ALLOC_BATCH		8
-#define IO_LOCAL_TW_DEFAULT_MAX		20
 
 /* requests with any of those set should undergo io_disarm_next() */
 #define IO_DISARM_MASK (REQ_F_ARM_LTIMEOUT | REQ_F_LINK_TIMEOUT | REQ_F_FAIL)
 
-/*
- * No waiters. It's larger than any valid value of the tw counter
- * so that tests against ->cq_wait_nr would fail and skip wake_up().
- */
-#define IO_CQ_WAKE_INIT		(-1U)
-/* Forced wake up if there is a waiter regardless of ->cq_wait_nr */
-#define IO_CQ_WAKE_FORCE	(IO_CQ_WAKE_INIT >> 1)
-
 static void io_queue_sqe(struct io_kiocb *req, unsigned int extra_flags);
 static void __io_req_caches_free(struct io_ring_ctx *ctx);
 
@@ -205,38 +196,6 @@ static __cold void io_ring_ctx_ref_free(struct percpu_ref *ref)
 	complete(&ctx->ref_comp);
 }
 
-/*
- * Terminate the request if either of these conditions are true:
- *
- * 1) It's being executed by the original task, but that task is marked
- *    with PF_EXITING as it's exiting.
- * 2) PF_KTHREAD is set, in which case the invoker of the task_work is
- *    our fallback task_work.
- * 3) The ring has been closed and is going away.
- */
-static inline bool io_should_terminate_tw(struct io_ring_ctx *ctx)
-{
-	return (current->flags & (PF_EXITING | PF_KTHREAD)) || percpu_ref_is_dying(&ctx->refs);
-}
-
-static __cold void io_fallback_req_func(struct work_struct *work)
-{
-	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
-						fallback_work.work);
-	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
-	struct io_kiocb *req, *tmp;
-	struct io_tw_state ts = {};
-
-	percpu_ref_get(&ctx->refs);
-	mutex_lock(&ctx->uring_lock);
-	ts.cancel = io_should_terminate_tw(ctx);
-	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
-		req->io_task_work.func((struct io_tw_req){req}, ts);
-	io_submit_flush_completions(ctx);
-	mutex_unlock(&ctx->uring_lock);
-	percpu_ref_put(&ctx->refs);
-}
-
 static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
 {
 	unsigned int hash_buckets;
@@ -1070,336 +1029,6 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	return nxt;
 }
 
-static void ctx_flush_and_put(struct io_ring_ctx *ctx, io_tw_token_t tw)
-{
-	if (!ctx)
-		return;
-	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
-		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
-
-	io_submit_flush_completions(ctx);
-	mutex_unlock(&ctx->uring_lock);
-	percpu_ref_put(&ctx->refs);
-}
-
-/*
- * Run queued task_work, returning the number of entries processed in *count.
- * If more entries than max_entries are available, stop processing once this
- * is reached and return the rest of the list.
- */
-struct llist_node *io_handle_tw_list(struct llist_node *node,
-				     unsigned int *count,
-				     unsigned int max_entries)
-{
-	struct io_ring_ctx *ctx = NULL;
-	struct io_tw_state ts = { };
-
-	do {
-		struct llist_node *next = node->next;
-		struct io_kiocb *req = container_of(node, struct io_kiocb,
-						    io_task_work.node);
-
-		if (req->ctx != ctx) {
-			ctx_flush_and_put(ctx, ts);
-			ctx = req->ctx;
-			mutex_lock(&ctx->uring_lock);
-			percpu_ref_get(&ctx->refs);
-			ts.cancel = io_should_terminate_tw(ctx);
-		}
-		INDIRECT_CALL_2(req->io_task_work.func,
-				io_poll_task_func, io_req_rw_complete,
-				(struct io_tw_req){req}, ts);
-		node = next;
-		(*count)++;
-		if (unlikely(need_resched())) {
-			ctx_flush_and_put(ctx, ts);
-			ctx = NULL;
-			cond_resched();
-		}
-	} while (node && *count < max_entries);
-
-	ctx_flush_and_put(ctx, ts);
-	return node;
-}
-
-static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
-{
-	struct io_ring_ctx *last_ctx = NULL;
-	struct io_kiocb *req;
-
-	while (node) {
-		req = container_of(node, struct io_kiocb, io_task_work.node);
-		node = node->next;
-		if (last_ctx != req->ctx) {
-			if (last_ctx) {
-				if (sync)
-					flush_delayed_work(&last_ctx->fallback_work);
-				percpu_ref_put(&last_ctx->refs);
-			}
-			last_ctx = req->ctx;
-			percpu_ref_get(&last_ctx->refs);
-		}
-		if (llist_add(&req->io_task_work.node, &last_ctx->fallback_llist))
-			schedule_delayed_work(&last_ctx->fallback_work, 1);
-	}
-
-	if (last_ctx) {
-		if (sync)
-			flush_delayed_work(&last_ctx->fallback_work);
-		percpu_ref_put(&last_ctx->refs);
-	}
-}
-
-static void io_fallback_tw(struct io_uring_task *tctx, bool sync)
-{
-	struct llist_node *node = llist_del_all(&tctx->task_list);
-
-	__io_fallback_tw(node, sync);
-}
-
-struct llist_node *tctx_task_work_run(struct io_uring_task *tctx,
-				      unsigned int max_entries,
-				      unsigned int *count)
-{
-	struct llist_node *node;
-
-	node = llist_del_all(&tctx->task_list);
-	if (node) {
-		node = llist_reverse_order(node);
-		node = io_handle_tw_list(node, count, max_entries);
-	}
-
-	/* relaxed read is enough as only the task itself sets ->in_cancel */
-	if (unlikely(atomic_read(&tctx->in_cancel)))
-		io_uring_drop_tctx_refs(current);
-
-	trace_io_uring_task_work_run(tctx, *count);
-	return node;
-}
-
-void tctx_task_work(struct callback_head *cb)
-{
-	struct io_uring_task *tctx;
-	struct llist_node *ret;
-	unsigned int count = 0;
-
-	tctx = container_of(cb, struct io_uring_task, task_work);
-	ret = tctx_task_work_run(tctx, UINT_MAX, &count);
-	/* can't happen */
-	WARN_ON_ONCE(ret);
-}
-
-static void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	unsigned nr_wait, nr_tw, nr_tw_prev;
-	struct llist_node *head;
-
-	/* See comment above IO_CQ_WAKE_INIT */
-	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
-
-	/*
-	 * We don't know how many requests there are in the link and whether
-	 * they can even be queued lazily, fall back to non-lazy.
-	 */
-	if (req->flags & IO_REQ_LINK_FLAGS)
-		flags &= ~IOU_F_TWQ_LAZY_WAKE;
-
-	guard(rcu)();
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
-
-	if (!head) {
-		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
-			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
-		if (ctx->has_evfd)
-			io_eventfd_signal(ctx, false);
-	}
-
-	nr_wait = atomic_read(&ctx->cq_wait_nr);
-	/* not enough or no one is waiting */
-	if (nr_tw < nr_wait)
-		return;
-	/* the previous add has already woken it up */
-	if (nr_tw_prev >= nr_wait)
-		return;
-	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
-}
-
-static void io_req_normal_work_add(struct io_kiocb *req)
-{
-	struct io_uring_task *tctx = req->tctx;
-	struct io_ring_ctx *ctx = req->ctx;
-
-	/* task_work already pending, we're done */
-	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
-		return;
-
-	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
-		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
-
-	/* SQPOLL doesn't need the task_work added, it'll run it itself */
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		__set_notify_signal(tctx->task);
-		return;
-	}
-
-	if (likely(!task_work_add(tctx->task, &tctx->task_work, ctx->notify_method)))
-		return;
-
-	io_fallback_tw(tctx, false);
-}
-
-void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
-{
-	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
-		io_req_local_work_add(req, flags);
-	else
-		io_req_normal_work_add(req);
-}
-
-void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags)
-{
-	if (WARN_ON_ONCE(!(req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)))
-		return;
-	__io_req_task_work_add(req, flags);
-}
-
-static void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
-{
-	struct llist_node *node = llist_del_all(&ctx->work_llist);
-
-	__io_fallback_tw(node, false);
-	node = llist_del_all(&ctx->retry_llist);
-	__io_fallback_tw(node, false);
-}
-
-static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
-				       int min_events)
-{
-	if (!io_local_work_pending(ctx))
-		return false;
-	if (events < min_events)
-		return true;
-	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
-		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
-	return false;
-}
-
-static int __io_run_local_work_loop(struct llist_node **node,
-				    io_tw_token_t tw,
-				    int events)
-{
-	int ret = 0;
-
-	while (*node) {
-		struct llist_node *next = (*node)->next;
-		struct io_kiocb *req = container_of(*node, struct io_kiocb,
-						    io_task_work.node);
-		INDIRECT_CALL_2(req->io_task_work.func,
-				io_poll_task_func, io_req_rw_complete,
-				(struct io_tw_req){req}, tw);
-		*node = next;
-		if (++ret >= events)
-			break;
-	}
-
-	return ret;
-}
-
-static int __io_run_local_work(struct io_ring_ctx *ctx, io_tw_token_t tw,
-			       int min_events, int max_events)
-{
-	struct llist_node *node;
-	unsigned int loops = 0;
-	int ret = 0;
-
-	if (WARN_ON_ONCE(ctx->submitter_task != current))
-		return -EEXIST;
-	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
-		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
-again:
-	tw.cancel = io_should_terminate_tw(ctx);
-	min_events -= ret;
-	ret = __io_run_local_work_loop(&ctx->retry_llist.first, tw, max_events);
-	if (ctx->retry_llist.first)
-		goto retry_done;
-
-	/*
-	 * llists are in reverse order, flip it back the right way before
-	 * running the pending items.
-	 */
-	node = llist_reverse_order(llist_del_all(&ctx->work_llist));
-	ret += __io_run_local_work_loop(&node, tw, max_events - ret);
-	ctx->retry_llist.first = node;
-	loops++;
-
-	if (io_run_local_work_continue(ctx, ret, min_events))
-		goto again;
-retry_done:
-	io_submit_flush_completions(ctx);
-	if (io_run_local_work_continue(ctx, ret, min_events))
-		goto again;
-
-	trace_io_uring_local_work_run(ctx, ret, loops);
-	return ret;
-}
-
-static inline int io_run_local_work_locked(struct io_ring_ctx *ctx,
-					   int min_events)
-{
-	struct io_tw_state ts = {};
-
-	if (!io_local_work_pending(ctx))
-		return 0;
-	return __io_run_local_work(ctx, ts, min_events,
-					max(IO_LOCAL_TW_DEFAULT_MAX, min_events));
-}
-
-int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_events)
-{
-	struct io_tw_state ts = {};
-	int ret;
-
-	mutex_lock(&ctx->uring_lock);
-	ret = __io_run_local_work(ctx, ts, min_events, max_events);
-	mutex_unlock(&ctx->uring_lock);
-	return ret;
-}
-
 static void io_req_task_cancel(struct io_tw_req tw_req, io_tw_token_t tw)
 {
 	struct io_kiocb *req = tw_req.req;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 2df861200b4f..29b8f90fdabf 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -10,6 +10,7 @@
 #include "alloc_cache.h"
 #include "io-wq.h"
 #include "slist.h"
+#include "tw.h"
 #include "opdef.h"
 
 #ifndef CREATE_TRACE_POINTS
@@ -88,6 +89,8 @@ struct io_ctx_config {
 			IOSQE_BUFFER_SELECT |\
 			IOSQE_CQE_SKIP_SUCCESS)
 
+#define IO_REQ_LINK_FLAGS (REQ_F_LINK | REQ_F_HARDLINK)
+
 /*
  * Complaint timeout for io_uring cancelation exits, and for io-wq exit
  * worker waiting.
@@ -156,8 +159,6 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 int io_prepare_config(struct io_ctx_config *config);
 
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32);
-int io_run_task_work_sig(struct io_ring_ctx *ctx);
-int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_events);
 void io_req_defer_failed(struct io_kiocb *req, s32 res);
 bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
 void io_add_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags);
@@ -171,15 +172,10 @@ struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
 
-void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
-void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags);
 void io_req_task_queue(struct io_kiocb *req);
 void io_req_task_complete(struct io_tw_req tw_req, io_tw_token_t tw);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
 void io_req_task_submit(struct io_tw_req tw_req, io_tw_token_t tw);
-struct llist_node *io_handle_tw_list(struct llist_node *node, unsigned int *count, unsigned int max_entries);
-struct llist_node *tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
-void tctx_task_work(struct callback_head *cb);
 __cold void io_uring_drop_tctx_refs(struct task_struct *task);
 
 int io_ring_add_registered_file(struct io_uring_task *tctx, struct file *file,
@@ -232,11 +228,6 @@ static inline bool io_is_compat(struct io_ring_ctx *ctx)
 	return IS_ENABLED(CONFIG_COMPAT) && unlikely(ctx->compat);
 }
 
-static inline void io_req_task_work_add(struct io_kiocb *req)
-{
-	__io_req_task_work_add(req, 0);
-}
-
 static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
 	if (!wq_list_empty(&ctx->submit_state.compl_reqs) ||
@@ -461,59 +452,6 @@ static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 	return min(entries, ctx->sq_entries);
 }
 
-static inline int io_run_task_work(void)
-{
-	bool ret = false;
-
-	/*
-	 * Always check-and-clear the task_work notification signal. With how
-	 * signaling works for task_work, we can find it set with nothing to
-	 * run. We need to clear it for that case, like get_signal() does.
-	 */
-	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
-		clear_notify_signal();
-	/*
-	 * PF_IO_WORKER never returns to userspace, so check here if we have
-	 * notify work that needs processing.
-	 */
-	if (current->flags & PF_IO_WORKER) {
-		if (test_thread_flag(TIF_NOTIFY_RESUME)) {
-			__set_current_state(TASK_RUNNING);
-			resume_user_mode_work(NULL);
-		}
-		if (current->io_uring) {
-			unsigned int count = 0;
-
-			__set_current_state(TASK_RUNNING);
-			tctx_task_work_run(current->io_uring, UINT_MAX, &count);
-			if (count)
-				ret = true;
-		}
-	}
-	if (task_work_pending(current)) {
-		__set_current_state(TASK_RUNNING);
-		task_work_run();
-		ret = true;
-	}
-
-	return ret;
-}
-
-static inline bool io_local_work_pending(struct io_ring_ctx *ctx)
-{
-	return !llist_empty(&ctx->work_llist) || !llist_empty(&ctx->retry_llist);
-}
-
-static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
-{
-	return task_work_pending(current) || io_local_work_pending(ctx);
-}
-
-static inline void io_tw_lock(struct io_ring_ctx *ctx, io_tw_token_t tw)
-{
-	lockdep_assert_held(&ctx->uring_lock);
-}
-
 /*
  * Don't complete immediately but use deferred completion infrastructure.
  * Protected by ->uring_lock and can only be used either with
@@ -571,17 +509,6 @@ static inline bool io_alloc_req(struct io_ring_ctx *ctx, struct io_kiocb **req)
 	return true;
 }
 
-static inline bool io_allowed_defer_tw_run(struct io_ring_ctx *ctx)
-{
-	return likely(ctx->submitter_task == current);
-}
-
-static inline bool io_allowed_run_tw(struct io_ring_ctx *ctx)
-{
-	return likely(!(ctx->flags & IORING_SETUP_DEFER_TASKRUN) ||
-		      ctx->submitter_task == current);
-}
-
 static inline void io_req_queue_tw_complete(struct io_kiocb *req, s32 res)
 {
 	io_req_set_res(req, res, 0);
diff --git a/io_uring/tw.c b/io_uring/tw.c
new file mode 100644
index 000000000000..f20ffc529040
--- /dev/null
+++ b/io_uring/tw.c
@@ -0,0 +1,354 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Task work handling for io_uring
+ */
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/sched/signal.h>
+#include <linux/io_uring.h>
+#include <linux/indirect_call_wrapper.h>
+
+#include "io_uring.h"
+#include "tctx.h"
+#include "poll.h"
+#include "rw.h"
+#include "eventfd.h"
+
+void io_fallback_req_func(struct work_struct *work)
+{
+	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
+						fallback_work.work);
+	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
+	struct io_kiocb *req, *tmp;
+	struct io_tw_state ts = {};
+
+	percpu_ref_get(&ctx->refs);
+	mutex_lock(&ctx->uring_lock);
+	ts.cancel = io_should_terminate_tw(ctx);
+	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
+		req->io_task_work.func((struct io_tw_req){req}, ts);
+	io_submit_flush_completions(ctx);
+	mutex_unlock(&ctx->uring_lock);
+	percpu_ref_put(&ctx->refs);
+}
+
+static void ctx_flush_and_put(struct io_ring_ctx *ctx, io_tw_token_t tw)
+{
+	if (!ctx)
+		return;
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+
+	io_submit_flush_completions(ctx);
+	mutex_unlock(&ctx->uring_lock);
+	percpu_ref_put(&ctx->refs);
+}
+
+/*
+ * Run queued task_work, returning the number of entries processed in *count.
+ * If more entries than max_entries are available, stop processing once this
+ * is reached and return the rest of the list.
+ */
+struct llist_node *io_handle_tw_list(struct llist_node *node,
+				     unsigned int *count,
+				     unsigned int max_entries)
+{
+	struct io_ring_ctx *ctx = NULL;
+	struct io_tw_state ts = { };
+
+	do {
+		struct llist_node *next = node->next;
+		struct io_kiocb *req = container_of(node, struct io_kiocb,
+						    io_task_work.node);
+
+		if (req->ctx != ctx) {
+			ctx_flush_and_put(ctx, ts);
+			ctx = req->ctx;
+			mutex_lock(&ctx->uring_lock);
+			percpu_ref_get(&ctx->refs);
+			ts.cancel = io_should_terminate_tw(ctx);
+		}
+		INDIRECT_CALL_2(req->io_task_work.func,
+				io_poll_task_func, io_req_rw_complete,
+				(struct io_tw_req){req}, ts);
+		node = next;
+		(*count)++;
+		if (unlikely(need_resched())) {
+			ctx_flush_and_put(ctx, ts);
+			ctx = NULL;
+			cond_resched();
+		}
+	} while (node && *count < max_entries);
+
+	ctx_flush_and_put(ctx, ts);
+	return node;
+}
+
+static __cold void __io_fallback_tw(struct llist_node *node, bool sync)
+{
+	struct io_ring_ctx *last_ctx = NULL;
+	struct io_kiocb *req;
+
+	while (node) {
+		req = container_of(node, struct io_kiocb, io_task_work.node);
+		node = node->next;
+		if (last_ctx != req->ctx) {
+			if (last_ctx) {
+				if (sync)
+					flush_delayed_work(&last_ctx->fallback_work);
+				percpu_ref_put(&last_ctx->refs);
+			}
+			last_ctx = req->ctx;
+			percpu_ref_get(&last_ctx->refs);
+		}
+		if (llist_add(&req->io_task_work.node, &last_ctx->fallback_llist))
+			schedule_delayed_work(&last_ctx->fallback_work, 1);
+	}
+
+	if (last_ctx) {
+		if (sync)
+			flush_delayed_work(&last_ctx->fallback_work);
+		percpu_ref_put(&last_ctx->refs);
+	}
+}
+
+static void io_fallback_tw(struct io_uring_task *tctx, bool sync)
+{
+	struct llist_node *node = llist_del_all(&tctx->task_list);
+
+	__io_fallback_tw(node, sync);
+}
+
+struct llist_node *tctx_task_work_run(struct io_uring_task *tctx,
+				      unsigned int max_entries,
+				      unsigned int *count)
+{
+	struct llist_node *node;
+
+	node = llist_del_all(&tctx->task_list);
+	if (node) {
+		node = llist_reverse_order(node);
+		node = io_handle_tw_list(node, count, max_entries);
+	}
+
+	/* relaxed read is enough as only the task itself sets ->in_cancel */
+	if (unlikely(atomic_read(&tctx->in_cancel)))
+		io_uring_drop_tctx_refs(current);
+
+	trace_io_uring_task_work_run(tctx, *count);
+	return node;
+}
+
+void tctx_task_work(struct callback_head *cb)
+{
+	struct io_uring_task *tctx;
+	struct llist_node *ret;
+	unsigned int count = 0;
+
+	tctx = container_of(cb, struct io_uring_task, task_work);
+	ret = tctx_task_work_run(tctx, UINT_MAX, &count);
+	/* can't happen */
+	WARN_ON_ONCE(ret);
+}
+
+void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned nr_wait, nr_tw, nr_tw_prev;
+	struct llist_node *head;
+
+	/* See comment above IO_CQ_WAKE_INIT */
+	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
+
+	/*
+	 * We don't know how many requests there are in the link and whether
+	 * they can even be queued lazily, fall back to non-lazy.
+	 */
+	if (req->flags & IO_REQ_LINK_FLAGS)
+		flags &= ~IOU_F_TWQ_LAZY_WAKE;
+
+	guard(rcu)();
+
+	head = READ_ONCE(ctx->work_llist.first);
+	do {
+		nr_tw_prev = 0;
+		if (head) {
+			struct io_kiocb *first_req = container_of(head,
+							struct io_kiocb,
+							io_task_work.node);
+			/*
+			 * Might be executed at any moment, rely on
+			 * SLAB_TYPESAFE_BY_RCU to keep it alive.
+			 */
+			nr_tw_prev = READ_ONCE(first_req->nr_tw);
+		}
+
+		/*
+		 * Theoretically, it can overflow, but that's fine as one of
+		 * previous adds should've tried to wake the task.
+		 */
+		nr_tw = nr_tw_prev + 1;
+		if (!(flags & IOU_F_TWQ_LAZY_WAKE))
+			nr_tw = IO_CQ_WAKE_FORCE;
+
+		req->nr_tw = nr_tw;
+		req->io_task_work.node.next = head;
+	} while (!try_cmpxchg(&ctx->work_llist.first, &head,
+			      &req->io_task_work.node));
+
+	/*
+	 * cmpxchg implies a full barrier, which pairs with the barrier
+	 * in set_current_state() on the io_cqring_wait() side. It's used
+	 * to ensure that either we see updated ->cq_wait_nr, or waiters
+	 * going to sleep will observe the work added to the list, which
+	 * is similar to the wait/wawke task state sync.
+	 */
+
+	if (!head) {
+		if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+			atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+		if (ctx->has_evfd)
+			io_eventfd_signal(ctx, false);
+	}
+
+	nr_wait = atomic_read(&ctx->cq_wait_nr);
+	/* not enough or no one is waiting */
+	if (nr_tw < nr_wait)
+		return;
+	/* the previous add has already woken it up */
+	if (nr_tw_prev >= nr_wait)
+		return;
+	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
+}
+
+void io_req_normal_work_add(struct io_kiocb *req)
+{
+	struct io_uring_task *tctx = req->tctx;
+	struct io_ring_ctx *ctx = req->ctx;
+
+	/* task_work already pending, we're done */
+	if (!llist_add(&req->io_task_work.node, &tctx->task_list))
+		return;
+
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+
+	/* SQPOLL doesn't need the task_work added, it'll run it itself */
+	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		__set_notify_signal(tctx->task);
+		return;
+	}
+
+	if (likely(!task_work_add(tctx->task, &tctx->task_work, ctx->notify_method)))
+		return;
+
+	io_fallback_tw(tctx, false);
+}
+
+void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags)
+{
+	if (WARN_ON_ONCE(!(req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)))
+		return;
+	__io_req_task_work_add(req, flags);
+}
+
+void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
+{
+	struct llist_node *node = llist_del_all(&ctx->work_llist);
+
+	__io_fallback_tw(node, false);
+	node = llist_del_all(&ctx->retry_llist);
+	__io_fallback_tw(node, false);
+}
+
+static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
+				       int min_events)
+{
+	if (!io_local_work_pending(ctx))
+		return false;
+	if (events < min_events)
+		return true;
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+	return false;
+}
+
+static int __io_run_local_work_loop(struct llist_node **node,
+				    io_tw_token_t tw,
+				    int events)
+{
+	int ret = 0;
+
+	while (*node) {
+		struct llist_node *next = (*node)->next;
+		struct io_kiocb *req = container_of(*node, struct io_kiocb,
+						    io_task_work.node);
+		INDIRECT_CALL_2(req->io_task_work.func,
+				io_poll_task_func, io_req_rw_complete,
+				(struct io_tw_req){req}, tw);
+		*node = next;
+		if (++ret >= events)
+			break;
+	}
+
+	return ret;
+}
+
+static int __io_run_local_work(struct io_ring_ctx *ctx, io_tw_token_t tw,
+			       int min_events, int max_events)
+{
+	struct llist_node *node;
+	unsigned int loops = 0;
+	int ret = 0;
+
+	if (WARN_ON_ONCE(ctx->submitter_task != current))
+		return -EEXIST;
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+again:
+	tw.cancel = io_should_terminate_tw(ctx);
+	min_events -= ret;
+	ret = __io_run_local_work_loop(&ctx->retry_llist.first, tw, max_events);
+	if (ctx->retry_llist.first)
+		goto retry_done;
+
+	/*
+	 * llists are in reverse order, flip it back the right way before
+	 * running the pending items.
+	 */
+	node = llist_reverse_order(llist_del_all(&ctx->work_llist));
+	ret += __io_run_local_work_loop(&node, tw, max_events - ret);
+	ctx->retry_llist.first = node;
+	loops++;
+
+	if (io_run_local_work_continue(ctx, ret, min_events))
+		goto again;
+retry_done:
+	io_submit_flush_completions(ctx);
+	if (io_run_local_work_continue(ctx, ret, min_events))
+		goto again;
+
+	trace_io_uring_local_work_run(ctx, ret, loops);
+	return ret;
+}
+
+int io_run_local_work_locked(struct io_ring_ctx *ctx, int min_events)
+{
+	struct io_tw_state ts = {};
+
+	if (!io_local_work_pending(ctx))
+		return 0;
+	return __io_run_local_work(ctx, ts, min_events,
+					max(IO_LOCAL_TW_DEFAULT_MAX, min_events));
+}
+
+int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_events)
+{
+	struct io_tw_state ts = {};
+	int ret;
+
+	mutex_lock(&ctx->uring_lock);
+	ret = __io_run_local_work(ctx, ts, min_events, max_events);
+	mutex_unlock(&ctx->uring_lock);
+	return ret;
+}
diff --git a/io_uring/tw.h b/io_uring/tw.h
new file mode 100644
index 000000000000..8683efca58ef
--- /dev/null
+++ b/io_uring/tw.h
@@ -0,0 +1,124 @@
+// SPDX-License-Identifier: GPL-2.0
+#ifndef IOU_TW_H
+#define IOU_TW_H
+
+#include <linux/sched.h>
+#include <linux/percpu-refcount.h>
+#include <linux/io_uring_types.h>
+
+#define IO_LOCAL_TW_DEFAULT_MAX		20
+
+/*
+ * No waiters. It's larger than any valid value of the tw counter
+ * so that tests against ->cq_wait_nr would fail and skip wake_up().
+ */
+#define IO_CQ_WAKE_INIT		(-1U)
+/* Forced wake up if there is a waiter regardless of ->cq_wait_nr */
+#define IO_CQ_WAKE_FORCE	(IO_CQ_WAKE_INIT >> 1)
+
+/*
+ * Terminate the request if either of these conditions are true:
+ *
+ * 1) It's being executed by the original task, but that task is marked
+ *    with PF_EXITING as it's exiting.
+ * 2) PF_KTHREAD is set, in which case the invoker of the task_work is
+ *    our fallback task_work.
+ * 3) The ring has been closed and is going away.
+ */
+static inline bool io_should_terminate_tw(struct io_ring_ctx *ctx)
+{
+	return (current->flags & (PF_EXITING | PF_KTHREAD)) || percpu_ref_is_dying(&ctx->refs);
+}
+
+void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags);
+struct llist_node *io_handle_tw_list(struct llist_node *node, unsigned int *count, unsigned int max_entries);
+void tctx_task_work(struct callback_head *cb);
+int io_run_local_work(struct io_ring_ctx *ctx, int min_events, int max_events);
+int io_run_task_work_sig(struct io_ring_ctx *ctx);
+
+__cold void io_fallback_req_func(struct work_struct *work);
+__cold void io_move_task_work_from_local(struct io_ring_ctx *ctx);
+int io_run_local_work_locked(struct io_ring_ctx *ctx, int min_events);
+
+void io_req_local_work_add(struct io_kiocb *req, unsigned flags);
+void io_req_normal_work_add(struct io_kiocb *req);
+struct llist_node *tctx_task_work_run(struct io_uring_task *tctx, unsigned int max_entries, unsigned int *count);
+
+static inline void __io_req_task_work_add(struct io_kiocb *req, unsigned flags)
+{
+	if (req->ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+		io_req_local_work_add(req, flags);
+	else
+		io_req_normal_work_add(req);
+}
+
+static inline void io_req_task_work_add(struct io_kiocb *req)
+{
+	__io_req_task_work_add(req, 0);
+}
+
+static inline int io_run_task_work(void)
+{
+	bool ret = false;
+
+	/*
+	 * Always check-and-clear the task_work notification signal. With how
+	 * signaling works for task_work, we can find it set with nothing to
+	 * run. We need to clear it for that case, like get_signal() does.
+	 */
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+		clear_notify_signal();
+	/*
+	 * PF_IO_WORKER never returns to userspace, so check here if we have
+	 * notify work that needs processing.
+	 */
+	if (current->flags & PF_IO_WORKER) {
+		if (test_thread_flag(TIF_NOTIFY_RESUME)) {
+			__set_current_state(TASK_RUNNING);
+			resume_user_mode_work(NULL);
+		}
+		if (current->io_uring) {
+			unsigned int count = 0;
+
+			__set_current_state(TASK_RUNNING);
+			tctx_task_work_run(current->io_uring, UINT_MAX, &count);
+			if (count)
+				ret = true;
+		}
+	}
+	if (task_work_pending(current)) {
+		__set_current_state(TASK_RUNNING);
+		task_work_run();
+		ret = true;
+	}
+
+	return ret;
+}
+
+static inline bool io_local_work_pending(struct io_ring_ctx *ctx)
+{
+	return !llist_empty(&ctx->work_llist) || !llist_empty(&ctx->retry_llist);
+}
+
+static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
+{
+	return task_work_pending(current) || io_local_work_pending(ctx);
+}
+
+static inline void io_tw_lock(struct io_ring_ctx *ctx, io_tw_token_t tw)
+{
+	lockdep_assert_held(&ctx->uring_lock);
+}
+
+static inline bool io_allowed_defer_tw_run(struct io_ring_ctx *ctx)
+{
+	return likely(ctx->submitter_task == current);
+}
+
+static inline bool io_allowed_run_tw(struct io_ring_ctx *ctx)
+{
+	return likely(!(ctx->flags & IORING_SETUP_DEFER_TASKRUN) ||
+		      ctx->submitter_task == current);
+}
+
+#endif
-- 
2.51.0


