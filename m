Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C14845B3A3
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 05:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhKXEuJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 23:50:09 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:41133 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229951AbhKXEuI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 23:50:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R361e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uy45oE2_1637729208;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uy45oE2_1637729208)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 12:46:57 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 7/9] io-wq: implement fixed worker logic
Date:   Wed, 24 Nov 2021 12:46:46 +0800
Message-Id: <20211124044648.142416-8-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211124044648.142416-1-haoxu@linux.alibaba.com>
References: <20211124044648.142416-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The current implementation of io-wq has big spinlock contension. The
main reason is the single work list model. All producers(who insert
works) and consumers(io-workers) have to grap wqe->lock to move ahead.
Set max_worker to 3 or 4, do a fio read test, we can see 40%~50% lock
contension.
Introduce fixed io-workers which sticks there to handle works and have
their own work list.

previous:

  producer0 ---insert---> work_list ---get---> io-worker0,1,2

now:

                     ---> private work_list0 --get--> fixed-worker0
                    /
  producer0 --insert----> private work_list1 --get--> fixed-worker1
      |             \
      |              ---> private work_list2 --get--> fixed-worker2
      |
      |---insert---> public work_list --get--> (normal)io-worker

Since each fixed-worker has a private work list, the contension will be
limited to a smaller range(the private work list).
Logic of fixed-worker: first handle private works then public ones.
Logic of normal io-worker: only handle public works.
Logic of producer: 1) create fixed-workers as needed
                   2) randomly pick a private work list and check if it
                      is full, insert the work if it's not
                   3) insert the work to the public work list if 2)
                      fails.
The get logic of a private list: fixed-worker grab all the works in
its private work list(like what tctx_task_work() does) each time rather
than one by one.(this code is in the next patches as a optimization)

To achieve this, we need to add an io_wqe_acct for each fixed-worker
struct. And move the work list lock to io_wqe_acct from io_wqe

Good things of this feature:
  1) bound and unbound work lists now have different spinlocks.
  2) much smaller contension between work producers and consumers.
  3) fixed workers are friendly for users to control: binding cpus,
     reset priority etc.

Wrote a nop test program to test it, set max number of fixed-workers to
3, max number of all workers to 4.
previous: IOPS = 40w~50w
now:      IOPS = ~100w
And 50w is the peak IOPS the old version can achieve, while with proper
number of loop and depth(see test code in the cover letter) this (whole)
patchset can achieve ~160w IOPS. From perf result, almost no acct->lock
contension.
(The test program attached in the cover letter of this patchset)

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 186 ++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 161 insertions(+), 25 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index fcdfbb904cdf..b53019d4691d 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -251,6 +251,17 @@ static void io_worker_exit(struct io_worker *worker)
 	current->flags &= ~PF_IO_WORKER;
 	preempt_enable();
 
+	if (worker->flags & IO_WORKER_F_FIXED) {
+		unsigned int index = worker->acct.index;
+
+		raw_spin_lock(&wqe->fixed_lock);
+		kfree(wqe->fixed_workers[worker->index]);
+		spin_lock_irq(&wq->hash->wait.lock);
+		list_del_init(&worker->acct.wait.entry);
+		spin_unlock_irq(&wq->hash->wait.lock);
+		wqe->nr_fixed[index]--;
+		raw_spin_unlock(&wqe->fixed_lock);
+	}
 	kfree_rcu(worker, rcu);
 	io_worker_ref_put(wqe->wq);
 	do_exit(0);
@@ -542,9 +553,8 @@ static void io_assign_current_work(struct io_worker *worker,
 
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 
-static void io_worker_handle_work(struct io_worker *worker)
+static void io_worker_handle_work(struct io_worker *worker, struct io_wqe_acct *acct)
 {
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
@@ -606,13 +616,24 @@ static void io_worker_handle_work(struct io_worker *worker)
 	} while (1);
 }
 
+static inline void io_worker_handle_private_work(struct io_worker *worker)
+{
+	io_worker_handle_work(worker, &worker->acct);
+}
+
+static inline void io_worker_handle_public_work(struct io_worker *worker)
+{
+	io_worker_handle_work(worker, io_wqe_get_acct(worker));
+}
+
 static int io_wqe_worker(void *data)
 {
 	struct io_worker *worker = data;
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
-	bool last_timeout = false;
+	bool fixed = worker->flags & IO_WORKER_F_FIXED;
+	bool last_timeout = false, run_private = false;
 	char buf[TASK_COMM_LEN];
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
@@ -625,18 +646,34 @@ static int io_wqe_worker(void *data)
 
 		set_current_state(TASK_INTERRUPTIBLE);
 loop:
-		if (io_acct_run_queue(acct)) {
-			io_worker_handle_work(worker);
+		if (fixed) {
+			run_private = io_acct_run_queue(&worker->acct);
+			if (run_private) {
+				io_worker_handle_private_work(worker);
+				goto loop;
+			}
+		}
+		if (!run_private && io_acct_run_queue(acct)) {
+			io_worker_handle_public_work(worker);
 			goto loop;
 		}
 		raw_spin_lock(&wqe->lock);
-		/* timed out, exit unless we're the last worker */
-		if (last_timeout && acct->nr_workers > 1) {
+		raw_spin_lock(&wqe->fixed_lock);
+		/* timed out, a worker will exit only if:
+		 * - not a fixed worker
+		 * - not the last non-fixed worker
+		 *
+		 * the second condition is due to we need at least one worker to handle the
+		 * public work list.
+		 */
+		if (last_timeout && !fixed && acct->nr_workers > wqe->nr_fixed[acct->index] + 1) {
+			raw_spin_unlock(&wqe->fixed_lock);
 			acct->nr_workers--;
 			raw_spin_unlock(&wqe->lock);
 			__set_current_state(TASK_RUNNING);
 			break;
 		}
+		raw_spin_unlock(&wqe->fixed_lock);
 		last_timeout = false;
 		__io_worker_idle(wqe, worker);
 		raw_spin_unlock(&wqe->lock);
@@ -653,8 +690,11 @@ static int io_wqe_worker(void *data)
 		last_timeout = !ret;
 	}
 
-	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
-		io_worker_handle_work(worker);
+	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
+		if (fixed)
+			io_worker_handle_private_work(worker);
+		io_worker_handle_public_work(worker);
+	}
 
 	io_worker_exit(worker);
 	return 0;
@@ -696,9 +736,36 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 	io_wqe_dec_running(worker);
 }
 
+static void io_init_new_fixed_worker(struct io_wqe *wqe, struct io_worker *worker)
+{
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	unsigned int index = acct->index;
+	unsigned int *nr_fixed, max_fixed;
+
+	raw_spin_lock(&wqe->fixed_lock);
+	nr_fixed = &wqe->nr_fixed[index];
+	max_fixed = wqe->max_fixed[index];
+	if (*nr_fixed < max_fixed) {
+		struct io_wqe_acct *iw_acct = &worker->acct;
+
+		worker->flags |= IO_WORKER_F_FIXED;
+		wqe->fixed_workers[index][*nr_fixed] = worker;
+		worker->index = *nr_fixed;
+		iw_acct->max_works = wqe->default_max_works[index];
+		iw_acct->index = index;
+		set_bit(IO_ACCT_IN_WORKER_BIT, &iw_acct->flags);
+		INIT_WQ_LIST(&iw_acct->work_list);
+		raw_spin_lock_init(&iw_acct->lock);
+		(*nr_fixed)++;
+	}
+	raw_spin_unlock(&wqe->fixed_lock);
+}
+
 static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
 			       struct task_struct *tsk)
 {
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+
 	tsk->pf_io_worker = worker;
 	worker->task = tsk;
 	set_cpus_allowed_ptr(tsk, wqe->cpu_mask);
@@ -708,6 +775,8 @@ static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
 	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
 	worker->flags |= IO_WORKER_F_FREE;
+	if (acct->nr_workers > 1)
+		io_init_new_fixed_worker(wqe, worker);
 	raw_spin_unlock(&wqe->lock);
 	wake_up_new_task(tsk);
 }
@@ -865,13 +934,13 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 	} while (work);
 }
 
-static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
+static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work,
+			       struct io_wqe_acct *acct)
 {
-	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
 	unsigned int hash;
 	struct io_wq_work *tail;
 
-	if (!io_wq_is_hashed(work)) {
+	if (test_bit(IO_ACCT_IN_WORKER_BIT, &acct->flags) || !io_wq_is_hashed(work)) {
 append:
 		wq_list_add_tail(&work->list, &acct->work_list);
 		return;
@@ -886,17 +955,50 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 	wq_list_add_after(&work->list, &tail->list, &acct->work_list);
 }
 
+static bool io_wqe_insert_private_work(struct io_wqe *wqe, struct io_wq_work *work, int index)
+{
+	bool needs_fixed_worker;
+	unsigned int nr_fixed, max_fixed;
+	struct io_worker *fixed_worker;
+	struct io_wqe_acct *iw_acct;
+	unsigned int fixed_worker_index;
+
+	raw_spin_lock(&wqe->fixed_lock);
+	nr_fixed = wqe->nr_fixed[index];
+	max_fixed = wqe->max_fixed[index];
+	needs_fixed_worker = nr_fixed < max_fixed;
+	if (nr_fixed && !needs_fixed_worker) {
+		fixed_worker_index = (unsigned long)work % nr_fixed;
+		fixed_worker = wqe->fixed_workers[index][fixed_worker_index];
+		iw_acct = &fixed_worker->acct;
+
+		raw_spin_lock(&iw_acct->lock);
+		if (iw_acct->nr_works < iw_acct->max_works) {
+			io_wqe_insert_work(wqe, work, iw_acct);
+			iw_acct->nr_works++;
+			raw_spin_unlock(&iw_acct->lock);
+			raw_spin_unlock(&wqe->fixed_lock);
+			wake_up_process(fixed_worker->task);
+			return false;
+		}
+		raw_spin_unlock(&iw_acct->lock);
+	}
+	raw_spin_unlock(&wqe->fixed_lock);
+	return needs_fixed_worker;
+}
+
 static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
 {
 	return work == data;
 }
 
+
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
 	struct io_cb_cancel_data match;
-	unsigned work_flags = work->flags;
-	bool do_create;
+	unsigned int work_flags = work->flags;
+	bool do_create, needs_fixed_worker;
 
 	/*
 	 * If io-wq is exiting for this task, or if the request has explicitly
@@ -908,8 +1010,10 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 		return;
 	}
 
+	needs_fixed_worker = io_wqe_insert_private_work(wqe, work, acct->index);
+
 	raw_spin_lock(&acct->lock);
-	io_wqe_insert_work(wqe, work);
+	io_wqe_insert_work(wqe, work, acct);
 	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 	raw_spin_unlock(&acct->lock);
 
@@ -920,8 +1024,10 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 
 	raw_spin_unlock(&wqe->lock);
 
-	if (do_create && ((work_flags & IO_WQ_WORK_CONCURRENT) ||
-	    !atomic_read(&acct->nr_running))) {
+	if (needs_fixed_worker ||
+	    (do_create &&
+	     ((work_flags & IO_WQ_WORK_CONCURRENT) ||
+	      !atomic_read(&acct->nr_running)))) {
 		bool did_create;
 
 		did_create = io_wqe_create_worker(wqe, acct);
@@ -985,9 +1091,9 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 
 static inline void io_wqe_remove_pending(struct io_wqe *wqe,
 					 struct io_wq_work *work,
-					 struct io_wq_work_node *prev)
+					 struct io_wq_work_node *prev,
+					 struct io_wqe_acct *acct)
 {
-	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
 	unsigned int hash = io_get_work_hash(work);
 	struct io_wq_work *prev_work = NULL;
 
@@ -1014,7 +1120,7 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 		work = container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
-		io_wqe_remove_pending(wqe, work, prev);
+		io_wqe_remove_pending(wqe, work, prev, acct);
 		raw_spin_unlock(&acct->lock);
 		io_run_cancel(work, wqe);
 		match->nr_pending++;
@@ -1029,17 +1135,32 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 				       struct io_cb_cancel_data *match)
 {
-	int i;
-retry:
+	int i, j;
+retry_public:
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
 
 		if (io_acct_cancel_pending_work(wqe, acct, match)) {
 			if (match->cancel_all)
-				goto retry;
+				goto retry_public;
 			return;
 		}
 	}
+
+retry_private:
+	raw_spin_lock(&wqe->fixed_lock);
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		for (j = 0; j < wqe->nr_fixed[i]; j++) {
+			struct io_wqe_acct *acct = &wqe->fixed_workers[i][j]->acct;
+
+			if (io_acct_cancel_pending_work(wqe, acct, match)) {
+				if (match->cancel_all)
+					goto retry_private;
+				return;
+			}
+		}
+	}
+	raw_spin_unlock(&wqe->fixed_lock);
 }
 
 static void io_wqe_cancel_running_work(struct io_wqe *wqe,
@@ -1102,6 +1223,11 @@ static int io_wqe_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 
 	list_del_init(&wait->entry);
 	ret = test_and_clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
+	if (test_bit(IO_ACCT_IN_WORKER_BIT, &acct->flags)) {
+		wake_up_process(acct->worker->task);
+		return 1;
+	}
+
 	if (ret) {
 		rcu_read_lock();
 		io_wqe_activate_free_worker(acct->wqe, acct);
@@ -1145,6 +1271,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		wqe = kzalloc_node(sizeof(struct io_wqe), GFP_KERNEL, alloc_node);
 		if (!wqe)
 			goto err;
+
 		if (!alloc_cpumask_var(&wqe->cpu_mask, GFP_KERNEL))
 			goto err;
 		cpumask_copy(wqe->cpu_mask, cpumask_of_node(node));
@@ -1156,6 +1283,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 			struct io_wqe_acct *acct = &wqe->acct[i];
+			struct io_worker **fixed_workers;
 
 			acct->index = i;
 			atomic_set(&acct->nr_running, 0);
@@ -1166,6 +1294,11 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 			acct->wqe = wqe;
 			wqe->max_fixed[i] = DEFAULT_MAX_FIXED_WORKERS;
 			wqe->default_max_works[i] = DEFAULT_MAX_FIXED_WORKS;
+			fixed_workers = kzalloc_node(sizeof(struct io_worker *) * wqe->max_fixed[i],
+						     GFP_KERNEL, alloc_node);
+			if (!fixed_workers)
+				goto err;
+			wqe->fixed_workers[i] = fixed_workers;
 		}
 		wqe->wq = wq;
 		raw_spin_lock_init(&wqe->lock);
@@ -1184,6 +1317,8 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	for_each_node(node) {
 		if (!wq->wqes[node])
 			continue;
+		for (i = 0; i < IO_WQ_ACCT_NR; i++)
+			kfree(wq->wqes[node]->fixed_workers[i]);
 		free_cpumask_var(wq->wqes[node]->cpu_mask);
 		kfree(wq->wqes[node]);
 	}
@@ -1246,7 +1381,7 @@ static void io_wq_exit_workers(struct io_wq *wq)
 
 static void io_wq_destroy(struct io_wq *wq)
 {
-	int node;
+	int node, i;
 
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 
@@ -1258,7 +1393,8 @@ static void io_wq_destroy(struct io_wq *wq)
 		};
 		io_wqe_cancel_pending_work(wqe, &match);
 		free_cpumask_var(wqe->cpu_mask);
-		kfree(wqe->fixed_workers);
+		for (i = 0; i < IO_WQ_ACCT_NR; i++)
+			kfree(wqe->fixed_workers[i]);
 		kfree(wqe);
 	}
 	io_wq_put_hash(wq->hash);
-- 
2.24.4

