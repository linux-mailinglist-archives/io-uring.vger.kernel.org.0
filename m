Return-Path: <io-uring+bounces-13687-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id F7p5HHZ0K2qw9wMAu9opvQ
	(envelope-from <io-uring+bounces-13687-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:52:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F3C0467655F
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 04:52:37 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=mgPdJgUL;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13687-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13687-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 79A2432B78F1
	for <lists+io-uring@lfdr.de>; Fri, 12 Jun 2026 02:51:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF26219CD1D;
	Fri, 12 Jun 2026 02:51:35 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E7D37FF7F
	for <io-uring@vger.kernel.org>; Fri, 12 Jun 2026 02:51:33 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781232695; cv=none; b=I8lj2S5kxyuNLYvkSfZBxqj3P3gSdpj3dqnR4O29CYIc/6T/EUyC/6YlUnO5z3Qq8xPofU/eKDWrIKYHyLhbkGhpOkAMPCsFdblwXF7qjFVSX3GCTftb+f+CIcolpzyw/HVtCyaeGuHctH/89YsnE8q0SulAXLpccPBrtxNNXEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781232695; c=relaxed/simple;
	bh=QYn4tTVHSxN21ptC5GLK/mTXRok3PnShHWsgd4g2VLg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/jcIvdTgTn/8brCct+cy3yRzUaJw9MQKiBZDVAMGs+2mUr8iCbVsEQs5KMv3CZTMhpYrnLOaT4shBVEceUWMoziN4anhgumBZrsorRbR+yHhHdiTxsIh1o/qLgK81PFwlJaDmJYMWF4EttyV22Baxf9BPCEZ5EN6bfbOTBr2SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=mgPdJgUL; arc=none smtp.client-ip=209.85.210.46
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7e71198e0adso208408a34.2
        for <io-uring@vger.kernel.org>; Thu, 11 Jun 2026 19:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1781232692; x=1781837492; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w2GncsQ1r5oU0kLZctdTGUoxXoM2Wk/oRwbYNTr6w2I=;
        b=mgPdJgULet7mxwNY2sXe8AhCVPyZEBKT/D5hcOwiejdL9XZxswsTRfqN6V+SYshys0
         58pJZeuLp6nSuVPv/rboKGlUGMFrzoOvi5UgS676Upr5uYhxhlTYklu+hdfQ0uRHESoF
         dF/5l6zfFYXsvdERmBfNM25RcJgQZr2gDDvYDsmLP6WiIEnFu8CiGNjYCqjA2Zy7LoY6
         65b/FH5NvGhevis4/V/IVSrdRNQxvOqmDg56L3X8fzS3oSNu1DkSPWxW5RGKR/1LH0nj
         rpkNSjedT1VMcGLjLr8/AJfvKnH4sie+pc7U1mkPuRAAIBmZVSA8ol18kkUOvyUJxo6r
         kCvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781232692; x=1781837492;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w2GncsQ1r5oU0kLZctdTGUoxXoM2Wk/oRwbYNTr6w2I=;
        b=dvOiYOdTJiwwuGFFv9USOwVLepphwD2BQDd+WAbAMUC7nhk7SUH1NXS0XF7UMdJ6pf
         2sWUciOiyzy1lVx43Otu3xf/YHSyIes2iRWOr26pjnwYzEjP5gWgaTKAYclsLpUSRzDW
         jklAIq36TI/CbXbAzjhf08USzBRa0eYK5UVNX70XWFQVCAQsIkBExNa8MHH7UYooi2lh
         n9nbaeypc+R1fay1TGjgpCgOyo9N9GCoLnFhfMHIazRVXeFTIrIzMqj3NbeD7GTg2or6
         8+z84RU4sONZcQ8HsaXYvQDCKUT3qYsO56Zxk2JaG5JOHYgFOu95DVTa0UjwYRSLzCXQ
         J4Pw==
X-Gm-Message-State: AOJu0Yyzhua5LdLRvjZ90mzLAQV6Q5T1pbrmZQgy8jF3Fa3S4e2kGpo6
	VmNU5RKKVXvEpnxyVKlFabAiXb+YR/jJyrz9ND2quHrPd9l8XqT5l3JkwlNMFnRoajJwfFKA0s2
	UgBlm/ZA=
X-Gm-Gg: Acq92OH7emalffFQxekH7dWUVydlSJffNCofmPQiLNslmiKz+vqdNIIVY8x7sharaCC
	UNiArKA/a39RPmSKMmG0qa8QL/pbSh6Mya09+3A9cD7qtgA71WThaZECBm3kmJA5rnfs4xbVdbH
	A/WyLdB261i+GBBSkmRl9xWecn3oaxyxnSR9Kpj5z+DPxiZhgMZ4j86IfCzgOKbcbAcIeZ13GTe
	rZAIaSh0HQHw/mcGy3sYK3ApCmILZKzWghPjEL4e4vzxV3AKihQkvGZkTPgXHVBwYfZDgx1hhhV
	TlguWLrLW1CxNAsFr4WrISuGx+AF4QVavOcMu2dbwako2rWWLBCwO2M1dH3+YBMPRQjs6VHOFkF
	ZjFCO8WZCs1q/PPG89wwE/WBEZ8Eea2+irsrMMU5/FXPXt7kfSLIQ8kyaMt7t9pgbBeTNDILTK3
	q4E0UR+NkDaXRImN1E6bzV5UjVGHjpqp7oQ4p3zjfYnafNn01zz6FwXM1s7O8mjSp2qGPV
X-Received: by 2002:a05:6830:83ab:b0:7dc:dd19:7f69 with SMTP id 46e09a7af769-7e7847b92c0mr573151a34.17.1781232692356;
        Thu, 11 Jun 2026 19:51:32 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e781734190sm862128a34.19.2026.06.11.19.51.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Jun 2026 19:51:31 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: dvyukov@google.com,
	csander@purestorage.com,
	krisman@suse.de,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring: switch local task_work to a mpscq
Date: Thu, 11 Jun 2026 20:48:29 -0600
Message-ID: <20260612025125.1690253-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260612025125.1690253-1-axboe@kernel.dk>
References: <20260612025125.1690253-1-axboe@kernel.dk>
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
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13687-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS(0.00)[m:io-uring@vger.kernel.org,m:dvyukov@google.com,m:csander@purestorage.com,m:krisman@suse.de,m:axboe@kernel.dk,s:lists@lfdr.de];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:email,kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: F3C0467655F

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
 include/linux/io_uring_types.h |  13 +++-
 io_uring/io_uring.c            |   2 +-
 io_uring/tw.c                  | 135 ++++++++++++++-------------------
 io_uring/tw.h                  |   4 +-
 io_uring/wait.c                |   2 +-
 io_uring/wait.h                |  10 ++-
 6 files changed, 78 insertions(+), 88 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 85e12b4884a5..9df5584ec3b1 100644
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
@@ -417,8 +425,7 @@ struct io_ring_ctx {
 	 */
 	struct {
 		struct io_rings	__rcu	*rings_rcu;
-		struct llist_head	work_llist;
-		struct llist_head	retry_llist;
+		struct mpscq		work_list;
 		unsigned long		check_cq;
 		atomic_t		cq_wait_nr;
 		atomic_t		cq_timeouts;
@@ -742,8 +749,6 @@ struct io_kiocb {
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
diff --git a/io_uring/tw.c b/io_uring/tw.c
index f4335c8d50d9..b8d6027aaeff 100644
--- a/io_uring/tw.c
+++ b/io_uring/tw.c
@@ -14,6 +14,7 @@
 #include "rw.h"
 #include "eventfd.h"
 #include "wait.h"
+#include "mpscq.h"
 
 void io_fallback_req_func(struct work_struct *work)
 {
@@ -170,11 +171,7 @@ static void io_ctx_mark_taskrun(struct io_ring_ctx *ctx)
 void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned nr_wait, nr_tw, nr_tw_prev;
-	struct llist_node *head;
-
-	/* See comment above IO_CQ_WAKE_INIT */
-	BUILD_BUG_ON(IO_CQ_WAKE_FORCE <= IORING_MAX_CQ_ENTRIES);
+	int nr_wait;
 
 	/*
 	 * We don't know how many requests there are in the link and whether
@@ -183,56 +180,37 @@ void io_req_local_work_add(struct io_kiocb *req, unsigned flags)
 	if (req->flags & IO_REQ_LINK_FLAGS)
 		flags &= ~IOU_F_TWQ_LAZY_WAKE;
 
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
-
-	if (!head) {
+	if (mpscq_push(&ctx->work_list, &req->io_task_work.node)) {
 		io_ctx_mark_taskrun(ctx);
 		if (data_race(ctx->int_flags) & IO_RING_F_HAS_EVFD)
 			io_eventfd_signal(ctx, false);
 	}
 
+	/*
+	 * No one is waiting (IO_CQ_WAKE_INIT), or this cycle's wake up has
+	 * already been issued (zero or negative, see below).
+	 */
 	nr_wait = atomic_read(&ctx->cq_wait_nr);
-	/* not enough or no one is waiting */
-	if (nr_tw < nr_wait)
+	if (nr_wait <= 0)
 		return;
-	/* the previous add has already woken it up */
-	if (nr_tw_prev >= nr_wait)
+	if (flags & IOU_F_TWQ_LAZY_WAKE) {
+		/*
+		 * ->cq_wait_nr counts down the number of lazy adds, once it
+		 * hits zero we're good to wake the waiter.
+		 */
+		if (!atomic_dec_and_test(&ctx->cq_wait_nr))
+			return;
+	} else if (!atomic_try_cmpxchg(&ctx->cq_wait_nr, &nr_wait, IO_CQ_WAKE_INIT)) {
+		/* lost the race against another wake up, this one is covered */
 		return;
+	}
 	wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
 }
 
@@ -273,21 +251,27 @@ void io_req_task_work_add_remote(struct io_kiocb *req, unsigned flags)
 
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
@@ -302,22 +286,23 @@ static bool io_run_local_work_continue(struct io_ring_ctx *ctx, int events,
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
@@ -326,7 +311,6 @@ static int __io_run_local_work_loop(struct llist_node **node,
 static int __io_run_local_work(struct io_ring_ctx *ctx, io_tw_token_t tw,
 			       int min_events, int max_events)
 {
-	struct llist_node *node;
 	unsigned int loops = 0;
 	int ret = 0;
 
@@ -335,24 +319,21 @@ static int __io_run_local_work(struct io_ring_ctx *ctx, io_tw_token_t tw,
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
index ec01e78a216d..c5fc34d2ce97 100644
--- a/io_uring/wait.c
+++ b/io_uring/wait.c
@@ -98,7 +98,7 @@ static enum hrtimer_restart io_cqring_min_timer_wakeup(struct hrtimer *timer)
 	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
 		atomic_set(&ctx->cq_wait_nr, 1);
 		smp_mb();
-		if (!llist_empty(&ctx->work_llist))
+		if (io_local_work_pending(ctx))
 			goto out_wake;
 	}
 
diff --git a/io_uring/wait.h b/io_uring/wait.h
index a4274b137f81..6d494297e1ce 100644
--- a/io_uring/wait.h
+++ b/io_uring/wait.h
@@ -5,12 +5,14 @@
 #include <linux/io_uring_types.h>
 
 /*
- * No waiters. It's larger than any valid value of the tw counter
- * so that tests against ->cq_wait_nr would fail and skip wake_up().
+ * ->cq_wait_nr is armed with the number of lazy task_work adds the waiter
+ * still needs, and counted down by the add side, with the add reaching zero
+ * issuing the (single) wake up for this wait cycle. Zero and below means no
+ * wake up is to be issued: IO_CQ_WAKE_INIT when no task is waiting (also
+ * what a forced wake up resets it to when claiming one), zero once the
+ * countdown has fired.
  */
 #define IO_CQ_WAKE_INIT		(-1U)
-/* Forced wake up if there is a waiter regardless of ->cq_wait_nr */
-#define IO_CQ_WAKE_FORCE	(IO_CQ_WAKE_INIT >> 1)
 
 struct ext_arg {
 	size_t argsz;
-- 
2.53.0


