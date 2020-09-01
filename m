Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5B1D258A8B
	for <lists+io-uring@lfdr.de>; Tue,  1 Sep 2020 10:41:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgIAIl4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 1 Sep 2020 04:41:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726064AbgIAIlz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 1 Sep 2020 04:41:55 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E008AC061244;
        Tue,  1 Sep 2020 01:41:54 -0700 (PDT)
Date:   Tue, 1 Sep 2020 10:41:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1598949707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=72xj66RsNWNX+Nxr9adNGdcXuz/k3DETm/60JNxkvpI=;
        b=TKPP/aEhYg0NnGHE1OIWK60H7QebRAALaaaktAHW4T6FKMiZzlr2TnITbvhhJATd7oqhIX
        X0IZpF4gEXqcHNztpjoG9XQiomQgEKiNP4MXlI2BS5I7Sl/SIPjCBWDN2DN3mUfEGBGH+1
        wPKp0+acKYxuKvw/Iwo3cLzOzyYRHy2+gCh+y4i+rVGrx6Fn3uS2v3JCycEXMYiVK6feJT
        svzn0JUV5cuKRMz0eFKK01oXGA7vqBL2Fp9JgI1AlPFnPQhKYKWGMXuJZFHA80hLMVUKjp
        Jb4PAXXDIHrN5XBt9p3GD6v+chC10PZGgwOOxLzwbL4u/7LXwyNO1da/LXrAGw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1598949707;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=72xj66RsNWNX+Nxr9adNGdcXuz/k3DETm/60JNxkvpI=;
        b=ce55Gwq+swQJMcz4bQZ5eq0S74SZwJI8a4aIxKhb/SUiwHDzptFeTbABVu+Z9LqEsa81tL
        5S5y7rWfztKZzlDg==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     peterz@infradead.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH v2] io_wq: Make io_wqe::lock a raw_spinlock_t
Message-ID: <20200901084146.4ttqrom2avcoatea@linutronix.de>
References: <20200819123758.6v45rj2gvojddsnn@linutronix.de>
 <20200819131507.GC2674@hirez.programming.kicks-ass.net>
 <f26205ac-9da9-253e-ea43-db2417714a94@kernel.dk>
 <20200819194443.eabkhlkocvkgifyh@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20200819194443.eabkhlkocvkgifyh@linutronix.de>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

During a context switch the scheduler invokes wq_worker_sleeping() with
disabled preemption. Disabling preemption is needed because it protects
access to `worker->sleeping'. As an optimisation it avoids invoking
schedule() within the schedule path as part of possible wake up (thus
preempt_enable_no_resched() afterwards).

The io-wq has been added to the mix in the same section with disabled
preemption. This breaks on PREEMPT_RT because io_wq_worker_sleeping()
acquires a spinlock_t. Also within the schedule() the spinlock_t must be
acquired after tsk_is_pi_blocked() otherwise it will block on the
sleeping lock again while scheduling out.

While playing with `io_uring-bench' I didn't notice a significant
latency spike after converting io_wqe::lock to a raw_spinlock_t. The
latency was more or less the same.

In order to keep the spinlock_t it would have to be moved after the
tsk_is_pi_blocked() check which would introduce a branch instruction
into the hot path.

The lock is used to maintain the `work_list' and wakes one task up at
most.
Should io_wqe_cancel_pending_work() cause latency spikes, while
searching for a specific item, then it would need to drop the lock
during iterations.
revert_creds() is also invoked under the lock. According to debug
cred::non_rcu is 0. Otherwise it should be moved outside of the locked
section because put_cred_rcu()->free_uid() acquires a sleeping lock.

Convert io_wqe::lock to a raw_spinlock_t.c

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
v1=E2=80=A6v2: Rebase to -rc3

 fs/io-wq.c |   52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -87,7 +87,7 @@ enum {
  */
 struct io_wqe {
 	struct {
-		spinlock_t lock;
+		raw_spinlock_t lock;
 		struct io_wq_work_list work_list;
 		unsigned long hash_map;
 		unsigned flags;
@@ -148,7 +148,7 @@ static bool __io_worker_unuse(struct io_
=20
 	if (current->files !=3D worker->restore_files) {
 		__acquire(&wqe->lock);
-		spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock_irq(&wqe->lock);
 		dropped_lock =3D true;
=20
 		task_lock(current);
@@ -166,7 +166,7 @@ static bool __io_worker_unuse(struct io_
 	if (worker->mm) {
 		if (!dropped_lock) {
 			__acquire(&wqe->lock);
-			spin_unlock_irq(&wqe->lock);
+			raw_spin_unlock_irq(&wqe->lock);
 			dropped_lock =3D true;
 		}
 		__set_current_state(TASK_RUNNING);
@@ -220,17 +220,17 @@ static void io_worker_exit(struct io_wor
 	worker->flags =3D 0;
 	preempt_enable();
=20
-	spin_lock_irq(&wqe->lock);
+	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
 	if (__io_worker_unuse(wqe, worker)) {
 		__release(&wqe->lock);
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 	}
 	acct->nr_workers--;
 	nr_workers =3D wqe->acct[IO_WQ_ACCT_BOUND].nr_workers +
 			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers;
-	spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock_irq(&wqe->lock);
=20
 	/* all workers gone, wq exit can proceed */
 	if (!nr_workers && refcount_dec_and_test(&wqe->wq->refs))
@@ -504,7 +504,7 @@ static void io_worker_handle_work(struct
 		else if (!wq_list_empty(&wqe->work_list))
 			wqe->flags |=3D IO_WQE_FLAG_STALLED;
=20
-		spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock_irq(&wqe->lock);
 		if (!work)
 			break;
 		io_assign_current_work(worker, work);
@@ -538,17 +538,17 @@ static void io_worker_handle_work(struct
 				io_wqe_enqueue(wqe, linked);
=20
 			if (hash !=3D -1U && !next_hashed) {
-				spin_lock_irq(&wqe->lock);
+				raw_spin_lock_irq(&wqe->lock);
 				wqe->hash_map &=3D ~BIT_ULL(hash);
 				wqe->flags &=3D ~IO_WQE_FLAG_STALLED;
 				/* skip unnecessary unlock-lock wqe->lock */
 				if (!work)
 					goto get_next;
-				spin_unlock_irq(&wqe->lock);
+				raw_spin_unlock_irq(&wqe->lock);
 			}
 		} while (work);
=20
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 	} while (1);
 }
=20
@@ -563,7 +563,7 @@ static int io_wqe_worker(void *data)
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		set_current_state(TASK_INTERRUPTIBLE);
 loop:
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 		if (io_wqe_run_queue(wqe)) {
 			__set_current_state(TASK_RUNNING);
 			io_worker_handle_work(worker);
@@ -574,7 +574,7 @@ static int io_wqe_worker(void *data)
 			__release(&wqe->lock);
 			goto loop;
 		}
-		spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock_irq(&wqe->lock);
 		if (signal_pending(current))
 			flush_signals(current);
 		if (schedule_timeout(WORKER_IDLE_TIMEOUT))
@@ -586,11 +586,11 @@ static int io_wqe_worker(void *data)
 	}
=20
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 		if (!wq_list_empty(&wqe->work_list))
 			io_worker_handle_work(worker);
 		else
-			spin_unlock_irq(&wqe->lock);
+			raw_spin_unlock_irq(&wqe->lock);
 	}
=20
 	io_worker_exit(worker);
@@ -630,9 +630,9 @@ void io_wq_worker_sleeping(struct task_s
=20
 	worker->flags &=3D ~IO_WORKER_F_RUNNING;
=20
-	spin_lock_irq(&wqe->lock);
+	raw_spin_lock_irq(&wqe->lock);
 	io_wqe_dec_running(wqe, worker);
-	spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock_irq(&wqe->lock);
 }
=20
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int ind=
ex)
@@ -656,7 +656,7 @@ static bool create_io_worker(struct io_w
 		return false;
 	}
=20
-	spin_lock_irq(&wqe->lock);
+	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
 	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
 	worker->flags |=3D IO_WORKER_F_FREE;
@@ -665,7 +665,7 @@ static bool create_io_worker(struct io_w
 	if (!acct->nr_workers && (worker->flags & IO_WORKER_F_BOUND))
 		worker->flags |=3D IO_WORKER_F_FIXED;
 	acct->nr_workers++;
-	spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock_irq(&wqe->lock);
=20
 	if (index =3D=3D IO_WQ_ACCT_UNBOUND)
 		atomic_inc(&wq->user->processes);
@@ -720,12 +720,12 @@ static int io_wq_manager(void *data)
 			if (!node_online(node))
 				continue;
=20
-			spin_lock_irq(&wqe->lock);
+			raw_spin_lock_irq(&wqe->lock);
 			if (io_wqe_need_worker(wqe, IO_WQ_ACCT_BOUND))
 				fork_worker[IO_WQ_ACCT_BOUND] =3D true;
 			if (io_wqe_need_worker(wqe, IO_WQ_ACCT_UNBOUND))
 				fork_worker[IO_WQ_ACCT_UNBOUND] =3D true;
-			spin_unlock_irq(&wqe->lock);
+			raw_spin_unlock_irq(&wqe->lock);
 			if (fork_worker[IO_WQ_ACCT_BOUND])
 				create_io_worker(wq, wqe, IO_WQ_ACCT_BOUND);
 			if (fork_worker[IO_WQ_ACCT_UNBOUND])
@@ -821,10 +821,10 @@ static void io_wqe_enqueue(struct io_wqe
 	}
=20
 	work_flags =3D work->flags;
-	spin_lock_irqsave(&wqe->lock, flags);
+	raw_spin_lock_irqsave(&wqe->lock, flags);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &=3D ~IO_WQE_FLAG_STALLED;
-	spin_unlock_irqrestore(&wqe->lock, flags);
+	raw_spin_unlock_irqrestore(&wqe->lock, flags);
=20
 	if ((work_flags & IO_WQ_WORK_CONCURRENT) ||
 	    !atomic_read(&acct->nr_running))
@@ -951,13 +951,13 @@ static void io_wqe_cancel_pending_work(s
 	unsigned long flags;
=20
 retry:
-	spin_lock_irqsave(&wqe->lock, flags);
+	raw_spin_lock_irqsave(&wqe->lock, flags);
 	wq_list_for_each(node, prev, &wqe->work_list) {
 		work =3D container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
 		io_wqe_remove_pending(wqe, work, prev);
-		spin_unlock_irqrestore(&wqe->lock, flags);
+		raw_spin_unlock_irqrestore(&wqe->lock, flags);
 		io_run_cancel(work, wqe);
 		match->nr_pending++;
 		if (!match->cancel_all)
@@ -966,7 +966,7 @@ static void io_wqe_cancel_pending_work(s
 		/* not safe to continue after unlock */
 		goto retry;
 	}
-	spin_unlock_irqrestore(&wqe->lock, flags);
+	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 }
=20
 static void io_wqe_cancel_running_work(struct io_wqe *wqe,
@@ -1074,7 +1074,7 @@ struct io_wq *io_wq_create(unsigned boun
 		}
 		atomic_set(&wqe->acct[IO_WQ_ACCT_UNBOUND].nr_running, 0);
 		wqe->wq =3D wq;
-		spin_lock_init(&wqe->lock);
+		raw_spin_lock_init(&wqe->lock);
 		INIT_WQ_LIST(&wqe->work_list);
 		INIT_HLIST_NULLS_HEAD(&wqe->free_list, 0);
 		INIT_LIST_HEAD(&wqe->all_list);
