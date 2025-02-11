Return-Path: <io-uring+bounces-6345-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A75F6A30065
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 02:35:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CF90E1884D5F
	for <lists+io-uring@lfdr.de>; Tue, 11 Feb 2025 01:35:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D9131F0E4A;
	Tue, 11 Feb 2025 01:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="te5O2QA0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6123E1F0E42;
	Tue, 11 Feb 2025 01:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739237458; cv=none; b=mSk61JGM3H497laTF86JSmIZBW/1zGR5QVQX7aK5/sYdVpZxMydPAk6UX6FiyEiil2vLphSulI4rNlKNf6RX9Tb2MRyuGs1oKVL9uXODd+j9b1YfG+ccU05N25IHW50VgmRnwXrQ4CB2jgWD8pyFZDaYqaCFbtGa3lsrNTKgy6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739237458; c=relaxed/simple;
	bh=rdCS7DT4FRpvkM4l8TBKCiuvAJ8b/eC7sdjK2Ghv6Sw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VqQr7dI4ijVRdufhWXx0NMrTZZ1o3A+C1/knRh+Y0cNegrSHELZmB695p+Z4MPsxpsODKiJQwzDcy5IRtL+42Zux13FMSaPHyjQL4lMUQ3upCH22PyBxcAS8hg8c5r58+5uGKWtl8IdrgQ5jQN5AIzNKpMJ6EdHDR8jFcACSXbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=te5O2QA0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61A8C4CED1;
	Tue, 11 Feb 2025 01:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739237457;
	bh=rdCS7DT4FRpvkM4l8TBKCiuvAJ8b/eC7sdjK2Ghv6Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=te5O2QA0jDSLpVqU5IIdZWMluic2/wkSpHseskh4B2NI32jm8wmGhPYuICliJXTIb
	 tK0s1TiGvhYkhpjPcFOmBBn7JX2PBu1diF81/hIKu2atthFdoZxXj6VTcOCmV8UsNO
	 LxnONcPDGOWxsI+UgbbufN/oATu4TK24RAEMav3LtK6wOGSp9nQBoJF+dLZ0gHcjjF
	 HiZ57gG3lYPXwsWyhIrPxinwOY0lr3XVt9hzzXwRgigGbiiG2AqV0CTGVMMyt5AJ8X
	 lqYNjPLGE7UhmlANz/MuvxOx74epN3cN/KkeV04hsiSeaJ7/g8OcRqJmhRtyqMtYCK
	 QGMBQfiFU/W3g==
From: Sasha Levin <sashal@kernel.org>
To: linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Jann Horn <jannh@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>,
	asml.silence@gmail.com,
	mingo@redhat.com,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.12 06/19] futex: Pass in task to futex_queue()
Date: Mon, 10 Feb 2025 20:30:34 -0500
Message-Id: <20250211013047.4096767-6-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250211013047.4096767-1-sashal@kernel.org>
References: <20250211013047.4096767-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.12.13
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 5e0e02f0d7e52cfc8b1adfc778dd02181d8b47b4 ]

futex_queue() -> __futex_queue() uses 'current' as the task to store in
the struct futex_q->task field. This is fine for synchronous usage of
the futex infrastructure, but it's not always correct when used by
io_uring where the task doing the initial futex_queue() might not be
available later on. This doesn't lead to any issues currently, as the
io_uring side doesn't support PI futexes, but it does leave a
potentially dangling pointer which is never a good idea.

Have futex_queue() take a task_struct argument, and have the regular
callers pass in 'current' for that. Meanwhile io_uring can just pass in
NULL, as the task should never be used off that path. In theory
req->tctx->task could be used here, but there's no point populating it
with a task field that will never be used anyway.

Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/22484a23-542c-4003-b721-400688a0d055@kernel.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/futex.c        |  2 +-
 kernel/futex/core.c     |  5 +++--
 kernel/futex/futex.h    | 11 ++++++++---
 kernel/futex/pi.c       |  2 +-
 kernel/futex/waitwake.c |  4 ++--
 5 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/io_uring/futex.c b/io_uring/futex.c
index 914848f46beb2..01f044f89f8fa 100644
--- a/io_uring/futex.c
+++ b/io_uring/futex.c
@@ -349,7 +349,7 @@ int io_futex_wait(struct io_kiocb *req, unsigned int issue_flags)
 		hlist_add_head(&req->hash_node, &ctx->futex_list);
 		io_ring_submit_unlock(ctx, issue_flags);
 
-		futex_queue(&ifd->q, hb);
+		futex_queue(&ifd->q, hb, NULL);
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
diff --git a/kernel/futex/core.c b/kernel/futex/core.c
index 136768ae26375..010607a991949 100644
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -554,7 +554,8 @@ void futex_q_unlock(struct futex_hash_bucket *hb)
 	futex_hb_waiters_dec(hb);
 }
 
-void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
+void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb,
+		   struct task_struct *task)
 {
 	int prio;
 
@@ -570,7 +571,7 @@ void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
 
 	plist_node_init(&q->list, prio);
 	plist_add(&q->list, &hb->chain);
-	q->task = current;
+	q->task = task;
 }
 
 /**
diff --git a/kernel/futex/futex.h b/kernel/futex/futex.h
index 8b195d06f4e8e..12e47386232ed 100644
--- a/kernel/futex/futex.h
+++ b/kernel/futex/futex.h
@@ -230,13 +230,15 @@ extern int futex_get_value_locked(u32 *dest, u32 __user *from);
 extern struct futex_q *futex_top_waiter(struct futex_hash_bucket *hb, union futex_key *key);
 
 extern void __futex_unqueue(struct futex_q *q);
-extern void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb);
+extern void __futex_queue(struct futex_q *q, struct futex_hash_bucket *hb,
+				struct task_struct *task);
 extern int futex_unqueue(struct futex_q *q);
 
 /**
  * futex_queue() - Enqueue the futex_q on the futex_hash_bucket
  * @q:	The futex_q to enqueue
  * @hb:	The destination hash bucket
+ * @task: Task queueing this futex
  *
  * The hb->lock must be held by the caller, and is released here. A call to
  * futex_queue() is typically paired with exactly one call to futex_unqueue().  The
@@ -244,11 +246,14 @@ extern int futex_unqueue(struct futex_q *q);
  * or nothing if the unqueue is done as part of the wake process and the unqueue
  * state is implicit in the state of woken task (see futex_wait_requeue_pi() for
  * an example).
+ *
+ * Note that @task may be NULL, for async usage of futexes.
  */
-static inline void futex_queue(struct futex_q *q, struct futex_hash_bucket *hb)
+static inline void futex_queue(struct futex_q *q, struct futex_hash_bucket *hb,
+			       struct task_struct *task)
 	__releases(&hb->lock)
 {
-	__futex_queue(q, hb);
+	__futex_queue(q, hb, task);
 	spin_unlock(&hb->lock);
 }
 
diff --git a/kernel/futex/pi.c b/kernel/futex/pi.c
index 5722467f27379..8ec12f1aff83b 100644
--- a/kernel/futex/pi.c
+++ b/kernel/futex/pi.c
@@ -981,7 +981,7 @@ int futex_lock_pi(u32 __user *uaddr, unsigned int flags, ktime_t *time, int tryl
 	/*
 	 * Only actually queue now that the atomic ops are done:
 	 */
-	__futex_queue(&q, hb);
+	__futex_queue(&q, hb, current);
 
 	if (trylock) {
 		ret = rt_mutex_futex_trylock(&q.pi_state->pi_mutex);
diff --git a/kernel/futex/waitwake.c b/kernel/futex/waitwake.c
index 3a10375d95218..a9056acb75eef 100644
--- a/kernel/futex/waitwake.c
+++ b/kernel/futex/waitwake.c
@@ -350,7 +350,7 @@ void futex_wait_queue(struct futex_hash_bucket *hb, struct futex_q *q,
 	 * access to the hash list and forcing another memory barrier.
 	 */
 	set_current_state(TASK_INTERRUPTIBLE|TASK_FREEZABLE);
-	futex_queue(q, hb);
+	futex_queue(q, hb, current);
 
 	/* Arm the timer */
 	if (timeout)
@@ -461,7 +461,7 @@ int futex_wait_multiple_setup(struct futex_vector *vs, int count, int *woken)
 			 * next futex. Queue each futex at this moment so hb can
 			 * be unlocked.
 			 */
-			futex_queue(q, hb);
+			futex_queue(q, hb, current);
 			continue;
 		}
 
-- 
2.39.5


