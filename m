Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2683C24A711
	for <lists+io-uring@lfdr.de>; Wed, 19 Aug 2020 21:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbgHSTou (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Aug 2020 15:44:50 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41670 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbgHSTos (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Aug 2020 15:44:48 -0400
Date:   Wed, 19 Aug 2020 21:44:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1597866285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ph4AV42sXpm7h1oWvi7gXQwMp6v8BCIenBHSbkZYXMo=;
        b=UBWBZmtz1FCbOTG/QrXMYwSNQ71+b+qx1D3dnKgyZfh+VGlxtA5ASOm0v/Qxfo+Kb34hsv
        qfJ+YXJ5iqqH4mIm8y4z8d6fuQREUSpKSRriXsaCjUQDTZQX5Px6ala50/DAM/BUjZ+nQA
        e+JB5/CJBusSscqBMTRUo5zfDb2eGZbuOqlt70lDNIb7Tg75vwUmLB5kwVI5h+hyCxZTbf
        6kWvMWBd+gpcoIg/7F5C54vqUhimnzHpqGq/iBdlsYEf4cY2E8UwtYSPPY5+o0IJgMOpNK
        Aijrhhkw5rRVgyezqNPvmptp1bbB5zHhVaL1T4S6rKq54HPQWJjbpT0Rt/7t8w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1597866285;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ph4AV42sXpm7h1oWvi7gXQwMp6v8BCIenBHSbkZYXMo=;
        b=1w/aY5Ve3FeiZQ9hbF0NdOeN7uCXkinec6hPyEbNVfjawFbgAUXqVkWc3lclFCwDkBsYH6
        2jRhON8Emk8fyEBA==
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
Subject: [PATCH] io_wq: Make io_wqe::lock a raw_spinlock_t
Message-ID: <20200819194443.eabkhlkocvkgifyh@linutronix.de>
References: <20200819123758.6v45rj2gvojddsnn@linutronix.de>
 <20200819131507.GC2674@hirez.programming.kicks-ass.net>
 <f26205ac-9da9-253e-ea43-db2417714a94@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f26205ac-9da9-253e-ea43-db2417714a94@kernel.dk>
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
 fs/io-wq.c | 52 ++++++++++++++++++++++++++--------------------------
 1 file changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index e92c4724480ca..16dd3a5534a06 100644
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
@@ -148,7 +148,7 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
 
 	if (current->files != worker->restore_files) {
 		__acquire(&wqe->lock);
-		spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock_irq(&wqe->lock);
 		dropped_lock = true;
 
 		task_lock(current);
@@ -166,7 +166,7 @@ static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
 	if (worker->mm) {
 		if (!dropped_lock) {
 			__acquire(&wqe->lock);
-			spin_unlock_irq(&wqe->lock);
+			raw_spin_unlock_irq(&wqe->lock);
 			dropped_lock = true;
 		}
 		__set_current_state(TASK_RUNNING);
@@ -220,17 +220,17 @@ static void io_worker_exit(struct io_worker *worker)
 	worker->flags = 0;
 	preempt_enable();
 
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
 	nr_workers = wqe->acct[IO_WQ_ACCT_BOUND].nr_workers +
 			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers;
-	spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock_irq(&wqe->lock);
 
 	/* all workers gone, wq exit can proceed */
 	if (!nr_workers && refcount_dec_and_test(&wqe->wq->refs))
@@ -504,7 +504,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		else if (!wq_list_empty(&wqe->work_list))
 			wqe->flags |= IO_WQE_FLAG_STALLED;
 
-		spin_unlock_irq(&wqe->lock);
+		raw_spin_unlock_irq(&wqe->lock);
 		if (!work)
 			break;
 		io_assign_current_work(worker, work);
@@ -538,17 +538,17 @@ static void io_worker_handle_work(struct io_worker *worker)
 				io_wqe_enqueue(wqe, linked);
 
 			if (hash != -1U && !next_hashed) {
-				spin_lock_irq(&wqe->lock);
+				raw_spin_lock_irq(&wqe->lock);
 				wqe->hash_map &= ~BIT_ULL(hash);
 				wqe->flags &= ~IO_WQE_FLAG_STALLED;
 				/* skip unnecessary unlock-lock wqe->lock */
 				if (!work)
 					goto get_next;
-				spin_unlock_irq(&wqe->lock);
+				raw_spin_unlock_irq(&wqe->lock);
 			}
 		} while (work);
 
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 	} while (1);
 }
 
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
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
-		spin_lock_irq(&wqe->lock);
+		raw_spin_lock_irq(&wqe->lock);
 		if (!wq_list_empty(&wqe->work_list))
 			io_worker_handle_work(worker);
 		else
-			spin_unlock_irq(&wqe->lock);
+			raw_spin_unlock_irq(&wqe->lock);
 	}
 
 	io_worker_exit(worker);
@@ -630,9 +630,9 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 
 	worker->flags &= ~IO_WORKER_F_RUNNING;
 
-	spin_lock_irq(&wqe->lock);
+	raw_spin_lock_irq(&wqe->lock);
 	io_wqe_dec_running(wqe, worker);
-	spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock_irq(&wqe->lock);
 }
 
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
@@ -656,7 +656,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		return false;
 	}
 
-	spin_lock_irq(&wqe->lock);
+	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
 	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
 	worker->flags |= IO_WORKER_F_FREE;
@@ -665,7 +665,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	if (!acct->nr_workers && (worker->flags & IO_WORKER_F_BOUND))
 		worker->flags |= IO_WORKER_F_FIXED;
 	acct->nr_workers++;
-	spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock_irq(&wqe->lock);
 
 	if (index == IO_WQ_ACCT_UNBOUND)
 		atomic_inc(&wq->user->processes);
@@ -720,12 +720,12 @@ static int io_wq_manager(void *data)
 			if (!node_online(node))
 				continue;
 
-			spin_lock_irq(&wqe->lock);
+			raw_spin_lock_irq(&wqe->lock);
 			if (io_wqe_need_worker(wqe, IO_WQ_ACCT_BOUND))
 				fork_worker[IO_WQ_ACCT_BOUND] = true;
 			if (io_wqe_need_worker(wqe, IO_WQ_ACCT_UNBOUND))
 				fork_worker[IO_WQ_ACCT_UNBOUND] = true;
-			spin_unlock_irq(&wqe->lock);
+			raw_spin_unlock_irq(&wqe->lock);
 			if (fork_worker[IO_WQ_ACCT_BOUND])
 				create_io_worker(wq, wqe, IO_WQ_ACCT_BOUND);
 			if (fork_worker[IO_WQ_ACCT_UNBOUND])
@@ -821,10 +821,10 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	}
 
 	work_flags = work->flags;
-	spin_lock_irqsave(&wqe->lock, flags);
+	raw_spin_lock_irqsave(&wqe->lock, flags);
 	io_wqe_insert_work(wqe, work);
 	wqe->flags &= ~IO_WQE_FLAG_STALLED;
-	spin_unlock_irqrestore(&wqe->lock, flags);
+	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 
 	if ((work_flags & IO_WQ_WORK_CONCURRENT) ||
 	    !atomic_read(&acct->nr_running))
@@ -933,14 +933,14 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 	unsigned long flags;
 
 retry:
-	spin_lock_irqsave(&wqe->lock, flags);
+	raw_spin_lock_irqsave(&wqe->lock, flags);
 	wq_list_for_each(node, prev, &wqe->work_list) {
 		work = container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
 
 		wq_list_del(&wqe->work_list, node, prev);
-		spin_unlock_irqrestore(&wqe->lock, flags);
+		raw_spin_unlock_irqrestore(&wqe->lock, flags);
 		io_run_cancel(work, wqe);
 		match->nr_pending++;
 		if (!match->cancel_all)
@@ -949,7 +949,7 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 		/* not safe to continue after unlock */
 		goto retry;
 	}
-	spin_unlock_irqrestore(&wqe->lock, flags);
+	raw_spin_unlock_irqrestore(&wqe->lock, flags);
 }
 
 static void io_wqe_cancel_running_work(struct io_wqe *wqe,
@@ -1057,7 +1057,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		}
 		atomic_set(&wqe->acct[IO_WQ_ACCT_UNBOUND].nr_running, 0);
 		wqe->wq = wq;
-		spin_lock_init(&wqe->lock);
+		raw_spin_lock_init(&wqe->lock);
 		INIT_WQ_LIST(&wqe->work_list);
 		INIT_HLIST_NULLS_HEAD(&wqe->free_list, 0);
 		INIT_LIST_HEAD(&wqe->all_list);
-- 
2.28.0

