Return-Path: <io-uring+bounces-13673-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ifgyKGjeKmrZyQMAu9opvQ
	(envelope-from <io-uring+bounces-13673-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 18:12:24 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DDDBF673589
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 18:12:23 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b="FHa/dQpL";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13673-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13673-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2842935733E6
	for <lists+io-uring@lfdr.de>; Thu, 11 Jun 2026 16:06:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7B8134BA5A;
	Thu, 11 Jun 2026 16:06:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B26A3E1232
	for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 16:06:04 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781193966; cv=none; b=t6QsflMVgdP08hCKaUBpDBTRJLkDA8pZrO5ZrNzfGTN5vVa03Cu+TiLm/qButH0k/qKsg3NGDog04KLr4MmxLQcvNdw+PFGZ39OPZuVP29sbu5bMAnaXv6VVWdkJUuNZyxymrhyvzFSCi6Up7C0DicFS1GXirI/aN6/rmzCuV88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781193966; c=relaxed/simple;
	bh=cn+En0wJ1Q+IZH8aSbyv/OVM6Crvldm6pno0cMiQ3HY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4nu3HjHZHXQuai088muEJTzWIdxjCxav2ZrC4nnGd/7xHHXziqojHyQol/43bshCGnL1kZbcqKM47x0BE42klWflJQ0sMUS8c8qmXsv5LpD+XlMLYnfETqgtqbRjrQ+yg/q9bOurcgn5mGdfPSg4/QQlY73bbwSXv3+48kY3x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=FHa/dQpL; arc=none smtp.client-ip=209.85.160.49
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-440f9c48b85so50403fac.1
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 09:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781193963; x=1781798763; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=43dgi8qSdGfitHpEpHHSWdqB2k4SvvtLM+xVMoYkj+c=;
        b=FHa/dQpL2fhBAfPqNmKmP/F+P9Wb2s6OCciaWhORZaMcsF4XcrKvbneole9S1S8qSR
         DIu29EaxFUqjtVsCRR+GK7k+AkE1YBMf8YDtnQ9GuYHsX3Smvrhk0YVoqSqAKIV5Gx/g
         criNkcEoCTc8vzSKhH6lTXDHQuRwD/jvWSaCS5BtTMRhEWJB6RhcSYWcO/urqhfGzGfi
         TTc6xNBokiNsp1iIz74PV+aDKZ4JUfQ4n4cTfNJ3DtEClXwuMjnyreu6/aAPQhuCUfcI
         FZA/UGIJHbnGP4lgiZ8sFyvGCyySSkE1umtBZyrG+a8TFnNQEFbr78aA58wI5sFLQJk8
         6nbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781193963; x=1781798763;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=43dgi8qSdGfitHpEpHHSWdqB2k4SvvtLM+xVMoYkj+c=;
        b=H3fvOmld2DpYANxd+6dk5hIrt60wkYj6z9ggn+3bklnM9h2tf6UPrCC7VvYGkJ/iQS
         Jh6K1qAWCWYic6JoD/FJHRFHqhyRiUayUcGACEInoEigM+0s++0QRhHaGU4IXUOL0vvA
         63EF5l0UquiVWoklVFzBAA7XpYHJ2/eRTaFiwr58kbSUNqWk5ozH6lHDgJpzeoHNWiBy
         durgQuz/ByN1w8APie5p0fsJzWmOmZsCfBg4TdG8yG8cpyau2tRjD2h+SigF2AsktESQ
         n0NPyhCD+7Yr0GznkpgzsvcFzgK8tpG62VaSFqpno+kI0q8MRIhpjI1rHQUoBWXGgTUg
         a1RQ==
X-Gm-Message-State: AOJu0YwBDCU+7JQrIyFXnj8FWsz+UFsi2YP6JcHGJt0l/rgi5FTZcVi1
	RqlPcD9gtWIOxgwyoUD97tRyoGtO36G+ld2VRLmico5/+RS3jBc//Q5qa+A3I2/uVbpmdMq8x9U
	E1bhdXyk=
X-Gm-Gg: Acq92OFIY67Qu4UXP0ZENX+RR4PFQBvJgRceJ32XhM3zwm/69hrlN1xlH251poV6Qa1
	fVDW6MGUihaVpvI+4wYynqmsicR2OkbfNpHEbZEMffi9XeM88l5Colhr1viZNO92HhvbiErwg0h
	rBM8LeLFXUwltpbrJj/7dn6dCmMI/kbtlbekCTFdyVWeyst1hoB4bx4y/EX88v66qHn41NyduVp
	b8s/QakvZARpxOmQyGxyLcSDV8DJ1KUE4A0ZWCiM6lfG4AqHc5NIXyh9/XPMWCweouKDSMe8woS
	Xq0iciwJXw5An2nNFm51/5uJLXEK0Fzh/kkFCrekxkA1UiYQx4nFGFGWEzkoNmkSuTNwTyURxvF
	nTkxIH8NSKIBqJMB5wMKlS+mhmA24Y8WegaFKCVhuVJ+IOKI8tMIviJc1HKbpiaV/MNHHeEykOD
	OCDnq7P1l+ipFXnHzRAUH2b9MSIwCVwF61JIrV/iaYuAorK1+7nv7igq53qeEKgmkItjGcF8CWa
	YXONQ==
X-Received: by 2002:a05:6870:fe98:b0:43b:516f:5f0e with SMTP id 586e51a60fabf-442412c566emr1706886fac.9.1781193962970;
        Thu, 11 Jun 2026 09:06:02 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-442444c7d9csm1353221fac.3.2026.06.11.09.06.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 09:06:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dvyukov@google.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: switch local task_work to a mpscq
Date: Thu, 11 Jun 2026 09:58:42 -0600
Message-ID: <20260611160553.1486640-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260611160553.1486640-1-axboe@kernel.dk>
References: <20260611160553.1486640-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-0.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13673-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:axboe@kernel.dk,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DMARC_NA(0.00)[kernel.dk];
	FORWARDED(0.00)[lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel-dk.20251104.gappssmtp.com:dkim,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DDDBF673589

The local (DEFER_TASKRUN) task_work list is an llist, which is LIFO
ordered, and hence __io_run_local_work() has to restore the right
running order with an O(n) llist_reverse_order() pass first. On top of
that, a batch that gets capped by max_events needs the leftover entries
parked on a separate ->retry_llist, as they can't be pushed back to the
shared list.

Switch it to the FIFO mpscq. Adds are wait-free instead of a cmpxchg
retry loop, entries are popped in queue order with no reversal pass,
capping a run simply leaves the remainder on the queue, and
->retry_llist goes away entirely. The consumer cursor, ->work_head,
lives with the rest of the ->uring_lock protected state rather than
next to the queue, so that popping entries doesn't dirty the producer
side cacheline.

For low amounts of task_work, this ends up being a bit more efficient
than the existing scheme. As an example of that, doing multishot
receives for 8 clients has the following task_work overhead:

     1.02%  sock-test  [kernel.kallsyms]  [k] io_req_local_work_add
     0.88%  sock-test  [kernel.kallsyms]  [k] __io_run_local_work_loop
     0.60%  sock-test  [kernel.kallsyms]  [k] llist_reverse_order
     0.14%  sock-test  [kernel.kallsyms]  [k] __io_run_local_work
     2.64% at ~46Gb/sec

and after this change:

     1.08%  sock-test  [kernel.kallsyms]  [k] io_req_local_work_add
     1.03%  sock-test  [kernel.kallsyms]  [k] __io_run_local_work
     2.11% at ~53Gb/sec

which has less overhead even though that test run was faster. For a case
of having 1024 clients on a single ring:

     2.22%  sock-test  [kernel.kallsyms]  [k] llist_reverse_order
     0.84%  sock-test  [kernel.kallsyms]  [k] __io_run_local_work_loop
     0.42%  sock-test  [kernel.kallsyms]  [k] io_req_local_work_add
     0.02%  sock-test  [kernel.kallsyms]  [k] __io_run_local_work
     3.50% at ~24Gb/sec

we start to see the llist reversing taking a considerable amount of
time, and the total add+run task_work overhead is around 3.5%. After
the change:

     0.90%  sock-test  [kernel.kallsyms]  [k] __io_run_local_work
     0.42%  sock-test  [kernel.kallsyms]  [k] io_req_local_work_add
     1.32% at ~26Gb/sec

most of that overhead is gone, and performance is better as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  14 +++-
 io_uring/io_uring.c            |   2 +-
 io_uring/loop.c                |   2 +-
 io_uring/tw.c                  | 145 ++++++++++++++++-----------------
 io_uring/tw.h                  |   4 +-
 io_uring/wait.c                |   8 +-
 io_uring/wait.h                |  20 ++++-
 7 files changed, 106 insertions(+), 89 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 85e12b4884a5..e918301da5fc 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -351,6 +351,14 @@ struct io_ring_ctx {
 		 */
 		atomic_t		cancel_seq;
 
+		/*
+		 * Consumer cursor for ->work_list, protected by ->uring_lock.
+		 * Deliberately kept away from the producer side of the queue,
+		 * as it's written for every popped entry, and the producer
+		 * cacheline is contended enough as it is.
+		 */
+		struct llist_node	*work_head;
+
 		/*
 		 * ->iopoll_list is protected by the ctx->uring_lock for
 		 * io_uring instances that don't use IORING_SETUP_SQPOLL.
@@ -417,10 +425,10 @@ struct io_ring_ctx {
 	 */
 	struct {
 		struct io_rings	__rcu	*rings_rcu;
-		struct llist_head	work_llist;
-		struct llist_head	retry_llist;
+		struct mpscq		work_list;
 		unsigned long		check_cq;
 		atomic_t		cq_wait_nr;
+		atomic_t		cq_wait_added;
 		atomic_t		cq_timeouts;
 		struct wait_queue_head	cq_wait;
 	} ____cacheline_aligned_in_smp;
@@ -742,8 +750,6 @@ struct io_kiocb {
 	 */
 	u16				buf_index;
 
-	unsigned			nr_tw;
-
 	/* REQ_F_* flags */
 	io_req_flags_t			flags;
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 753ac23401c5..16acd99ff083 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -280,7 +280,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
-	init_llist_head(&ctx->work_llist);
+	mpscq_init(&ctx->work_list, &ctx->work_head);
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	mutex_init(&ctx->tctx_lock);
 	ctx->submit_state.free_list.next = NULL;
diff --git a/io_uring/loop.c b/io_uring/loop.c
index bbbb6ef14e6a..2ecc1cf49f84 100644
--- a/io_uring/loop.c
+++ b/io_uring/loop.c
@@ -11,7 +11,7 @@ static inline int io_loop_nr_cqes(const struct io_ring_ctx *ctx,
 
 static inline void io_loop_wait_start(struct io_ring_ctx *ctx, unsigned nr_wait)
 {
-	atomic_set(&ctx->cq_wait_nr, nr_wait);
+	io_cq_wait_arm(ctx, nr_wait);
 	set_current_state(TASK_INTERRUPTIBLE);
 }
 
diff --git a/io_uring/tw.c b/io_uring/tw.c
index 023d5e6bc491..4cf350cffb6c 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -14,6 +14,7 @@
 #include "rw.h"
 #include "eventfd.h"
 #include "wait.h"
+#include "mpscq.h"
 
 void io_fallback_req_func(struct work_struct *work)
 {
@@ -170,11 +171,8 @@ static void io_ctx_mark_taskrun(struct io_ring_ctx *ctx)
 void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned nr_wait, nr_tw, nr_tw_prev;
-	struct llist_node *head;
-
-	/* See comment above IO_CQ_WAKE_INIT */
-	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
+	struct llist_node *prev;
+	unsigned nr_wait;
 
 	/*
 	 * We don't know how many requests there are in the link and whether
@@ -185,55 +183,47 @@ void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 
 	guard(rcu)();
 
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
 	/*
-	 * cmpxchg implies a full barrier, which pairs with the barrier
-	 * in set_current_state() on the io_cqring_wait() side. It's used
-	 * to ensure that either we see updated ->cq_wait_nr, or waiters
-	 * going to sleep will observe the work added to the list, which
-	 * is similar to the wait/wawke task state sync.
+	 * The xchg() in mpscq_push() implies a full barrier, which pairs with
+	 * the barrier in set_current_state() on the io_cqring_wait() side. This
+	 * ensures that either we see the updated ->cq_wait_nr, or waiters going
+	 * to sleep will observe the work added to the list, which is similar to
+	 * the wait/wake task state sync.
 	 */
+	prev = mpscq_push(&ctx->work_list, &req->io_task_work.node);
 
-	if (!head) {
+	if (prev == &ctx->work_list.stub) {
 		io_ctx_mark_taskrun(ctx);
 		if (data_race(ctx->int_flags) & IO_RING_F_HAS_EVFD)
 			io_eventfd_signal(ctx, false);
 	}
 
-	nr_wait = atomic_read(&ctx->cq_wait_nr);
-	/* not enough or no one is waiting */
-	if (nr_tw < nr_wait)
+	/* acquire pairs with the release in io_cq_wait_arm() */
+	nr_wait = atomic_read_acquire(&ctx->cq_wait_nr);
+	/* no one is waiting */
+	if (nr_wait == IO_CQ_WAKE_INIT)
 		return;
-	/* the previous add has already woken it up */
-	if (nr_tw_prev >= nr_wait)
+	/*
+	 * For a lazy wake, defer waking the task until enough work is pending
+	 * to satisfy the number of events it's waiting for. As a waiter only
+	 * sleeps on an empty queue, the lazy adds counted since it armed
+	 * ->cq_wait_nr are the full pending count, see io_cq_wait_arm(). If we
+	 * instead saw a stale, unarmed (or previous cycle) ->cq_wait_nr, then
+	 * per the barrier pairing above, the waiter's check after arming will
+	 * see our work and abort the sleep - no wakeup is needed from here in
+	 * that case.
+	 */
+	if ((flags & IOU_F_TWQ_LAZY_WAKE) &&
+	    atomic_inc_return(&ctx->cq_wait_added) < nr_wait)
 		return;
-	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
+	/*
+	 * Only one wake up is needed per arming of the wait. Claim it by
+	 * resetting ->cq_wait_nr - the waiter re-arms it for every wait cycle
+	 * and checks for pending work after arming, so a wakeup cannot get
+	 * lost.
+	 */
+	if (atomic_try_cmpxchg(&ctx->cq_wait_nr, &nr_wait, IO_CQ_WAKE_INIT))
+		wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 }
 
 void io_req_normal_work_add(struct io_kiocb *req)
@@ -273,21 +263,27 @@ void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags)
 
 void __cold io_move_task_work_from_local(struct io_ring_ctx *ctx)
 {
-	struct llist_node *node;
+	struct llist_node *node, *first = NULL, **tail = &first;
 
 	/*
-	 * Running the work items may utilize ->retry_llist as a means
-	 * for capping the number of task_work entries run at the same
-	 * time. But that list can potentially race with moving the work
-	 * from here, if the task is exiting. As any normal task_work
-	 * running holds ->uring_lock already, just guard this slow path
-	 * with ->uring_lock to avoid racing on ->retry_llist.
+	 * The work list consumer side is serialized by ->uring_lock, see
+	 * __io_run_local_work(). Grab it to guard against racing with normal
+	 * task_work running, as the task may be exiting.
 	 */
 	guard(mutex)(&ctx->uring_lock);
-	node = llist_del_all(&ctx->work_llist);
-	__io_fallback_tw(node, false);
-	node = llist_del_all(&ctx->retry_llist);
-	__io_fallback_tw(node, false);
+
+	while (!mpscq_empty(&ctx->work_list)) {
+		node = mpscq_pop(&ctx->work_list, &ctx->work_head);
+		if (!node) {
+			/* a producer is mid-push, wait for it to link */
+			cpu_relax();
+			continue;
+		}
+		*tail = node;
+		tail = &node->next;
+	}
+	*tail = NULL;
+	__io_fallback_tw(first, false);
 }
 
 static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
@@ -302,22 +298,23 @@ static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
 	return false;
 }
 
-static int __io_run_local_work_loop(struct llist_node **node,
+static int __io_run_local_work_loop(struct io_ring_ctx *ctx,
 				    io_tw_token_t tw,
 				    int events)
 {
 	int ret = 0;
 
-	while (*node) {
-		struct llist_node *next = (*node)->next;
-		struct io_kiocb *req = container_of(*node, struct io_kiocb,
-						    io_task_work.node);
+	while (ret < events) {
+		struct llist_node *node = mpscq_pop(&ctx->work_list, &ctx->work_head);
+		struct io_kiocb *req;
+
+		if (!node)
+			break;
+		req = container_of(node, struct io_kiocb, io_task_work.node);
 		INDIRECT_CALL_2(req->io_task_work.func,
 				io_poll_task_func, io_req_rw_complete,
 				(struct io_tw_req){req}, tw);
-		*node = next;
-		if (++ret >= events)
-			break;
+		ret++;
 	}
 
 	return ret;
@@ -326,7 +323,6 @@ static int __io_run_local_work_loop(struct llist_node **node,
 static int __io_run_local_work(struct io_ring_ctx *ctx, io_tw_token_t tw,
 			       int min_events, int max_events)
 {
-	struct llist_node *node;
 	unsigned int loops = 0;
 	int ret = 0;
 
@@ -335,24 +331,21 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, io_tw_token_t tw,
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
 		atomic_andnot(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
 again:
-	tw.cancel = io_should_terminate_tw(ctx);
-	min_events -= ret;
-	ret = __io_run_local_work_loop(&ctx->retry_llist.first, tw, max_events);
-	if (ctx->retry_llist.first)
-		goto retry_done;
-
 	/*
-	 * llists are in reverse order, flip it back the right way before
-	 * running the pending items.
+	 * If the last loop made no progress while work is still pending,
+	 * a producer has published a node but hasn't linked it into the
+	 * queue yet (see mpscq_pop()). Give it a chance to finish rather
+	 * than spinning on the queue.
 	 */
-	node = llist_reverse_order(llist_del_all(&ctx->work_llist));
-	ret += __io_run_local_work_loop(&node, tw, max_events - ret);
-	ctx->retry_llist.first = node;
+	if (unlikely(loops && !ret))
+		cond_resched();
+	tw.cancel = io_should_terminate_tw(ctx);
+	min_events -= ret;
+	ret = __io_run_local_work_loop(ctx, tw, max_events);
 	loops++;
 
 	if (io_run_local_work_continue(ctx, ret, min_events))
 		goto again;
-retry_done:
 	io_submit_flush_completions(ctx);
 	if (io_run_local_work_continue(ctx, ret, min_events))
 		goto again;
diff --git a/io_uring/tw.h b/io_uring/tw.h
index 415e330fabde..f42db5fdbded 100644
--- a/io_uring/tw.h
+++ b/io_uring/tw.h
@@ -6,6 +6,8 @@
 #include <linux/percpu-refcount.h>
 #include <linux/io_uring_types.h>
 
+#include "mpscq.h"
+
 #define IO_LOCAL_TW_DEFAULT_MAX		20
 
 /*
@@ -89,7 +91,7 @@ static inline int io_run_task_work(void)
 
 static inline bool io_local_work_pending(struct io_ring_ctx *ctx)
 {
-	return !llist_empty(&ctx->work_llist) || !llist_empty(&ctx->retry_llist);
+	return !mpscq_empty(&ctx->work_list);
 }
 
 static inline bool io_task_work_pending(struct io_ring_ctx *ctx)
diff --git a/io_uring/wait.c b/io_uring/wait.c
index ec01e78a216d..05ac779635e8 100644
--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -96,9 +96,13 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
 	 * the task and return.
 	 */
 	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
+		/*
+		 * No need to zero ->cq_wait_added when arming with 1, any
+		 * counted add will satisfy it.
+		 */
 		atomic_set(&ctx->cq_wait_nr, 1);
 		smp_mb();
-		if (!llist_empty(&ctx->work_llist))
+		if (io_local_work_pending(ctx))
 			goto out_wake;
 	}
 
@@ -257,7 +261,7 @@ int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 		unsigned long check_cq;
 
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-			atomic_set(&ctx->cq_wait_nr, nr_wait);
+			io_cq_wait_arm(ctx, nr_wait);
 			set_current_state(TASK_INTERRUPTIBLE);
 		} else {
 			prepare_to_wait_exclusive(&ctx->cq_wait, &iowq.wq,
diff --git a/io_uring/wait.h b/io_uring/wait.h
index a4274b137f81..2ecea3e2a63f 100644
--- a/io_uring/wait.h
+++ b/io_uring/wait.h
@@ -5,12 +5,24 @@
 #include <linux/io_uring_types.h>
 
 /*
- * No waiters. It's larger than any valid value of the tw counter
- * so that tests against ->cq_wait_nr would fail and skip wake_up().
+ * No waiters. ->cq_wait_nr holds this when no task is waiting, and is
+ * reset back to it by the task work add side when it claims a wake up,
+ * so that only one wake up is issued per arming of the wait.
  */
 #define IO_CQ_WAKE_INIT		(-1U)
-/* Forced wake up if there is a waiter regardless of ->cq_wait_nr */
-#define IO_CQ_WAKE_FORCE	(IO_CQ_WAKE_INIT >> 1)
+
+/*
+ * A waiter only sleeps on an empty work list (it checks for pending work after
+ * arming), hence the number of lazy adds since arming is the full pending
+ * count. The release pairs with the acquire in io_req_local_work_add(), hence
+ * a producer observing the armed ->cq_wait_nr also observes the zeroed
+ * ->cq_wait_added.
+ */
+static inline void io_cq_wait_arm(struct io_ring_ctx *ctx, int nr_wait)
+{
+	atomic_set(&ctx->cq_wait_added, 0);
+	atomic_set_release(&ctx->cq_wait_nr, nr_wait);
+}
 
 struct ext_arg {
 	size_t argsz;
-- 
2.53.0


