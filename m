Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A5E14AAEB2
	for <lists+io-uring@lfdr.de>; Sun,  6 Feb 2022 10:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232685AbiBFJwx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Feb 2022 04:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232868AbiBFJwx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Feb 2022 04:52:53 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D673FC0612A4
        for <io-uring@vger.kernel.org>; Sun,  6 Feb 2022 01:52:51 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R661e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V3fxVZ._1644141169;
Received: from localhost.localdomain(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V3fxVZ._1644141169)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 06 Feb 2022 17:52:49 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/3] io-wq: decouple work_list protection from the big wqe->lock
Date:   Sun,  6 Feb 2022 17:52:39 +0800
Message-Id: <20220206095241.121485-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220206095241.121485-1-haoxu@linux.alibaba.com>
References: <20220206095241.121485-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

wqe->lock is abused, it now protects acct->work_list, hash stuff,
nr_workers, wqe->free_list and so on. Lets first get the work_list out
of the wqe-lock mess by introduce a specific lock for work list. This
is the first step to solve the huge contension between work insertion
and work consumption.
good thing:
  - split locking for bound and unbound work list
  - reduce contension between work_list visit and (worker's)free_list.

For the hash stuff, since there won't be a work with same file in both
bound and unbound work list, thus they won't visit same hash entry. it
works well to use the new lock to protect hash stuff.

Results:
set max_unbound_worker = 4, test with echo-server:
nice -n -15 ./io_uring_echo_server -p 8081 -f -n 1000 -l 16
(-n connection, -l workload)
before this patch:
Samples: 2M of event 'cycles:ppp', Event count (approx.): 1239982111074
Overhead  Command          Shared Object         Symbol
  28.59%  iou-wrk-10021    [kernel.vmlinux]      [k] native_queued_spin_lock_slowpath
   8.89%  io_uring_echo_s  [kernel.vmlinux]      [k] native_queued_spin_lock_slowpath
   6.20%  iou-wrk-10021    [kernel.vmlinux]      [k] _raw_spin_lock
   2.45%  io_uring_echo_s  [kernel.vmlinux]      [k] io_prep_async_work
   2.36%  iou-wrk-10021    [kernel.vmlinux]      [k] _raw_spin_lock_irqsave
   2.29%  iou-wrk-10021    [kernel.vmlinux]      [k] io_worker_handle_work
   1.29%  io_uring_echo_s  [kernel.vmlinux]      [k] io_wqe_enqueue
   1.06%  iou-wrk-10021    [kernel.vmlinux]      [k] io_wqe_worker
   1.06%  io_uring_echo_s  [kernel.vmlinux]      [k] _raw_spin_lock
   1.03%  iou-wrk-10021    [kernel.vmlinux]      [k] __schedule
   0.99%  iou-wrk-10021    [kernel.vmlinux]      [k] tcp_sendmsg_locked

with this patch:
Samples: 1M of event 'cycles:ppp', Event count (approx.): 708446691943
Overhead  Command          Shared Object         Symbol
  16.86%  iou-wrk-10893    [kernel.vmlinux]      [k] native_queued_spin_lock_slowpat
   9.10%  iou-wrk-10893    [kernel.vmlinux]      [k] _raw_spin_lock
   4.53%  io_uring_echo_s  [kernel.vmlinux]      [k] native_queued_spin_lock_slowpat
   2.87%  iou-wrk-10893    [kernel.vmlinux]      [k] io_worker_handle_work
   2.57%  iou-wrk-10893    [kernel.vmlinux]      [k] _raw_spin_lock_irqsave
   2.56%  io_uring_echo_s  [kernel.vmlinux]      [k] io_prep_async_work
   1.82%  io_uring_echo_s  [kernel.vmlinux]      [k] _raw_spin_lock
   1.33%  iou-wrk-10893    [kernel.vmlinux]      [k] io_wqe_worker
   1.26%  io_uring_echo_s  [kernel.vmlinux]      [k] try_to_wake_up

spin_lock failure from 25.59% + 8.89% =  34.48% to 16.86% + 4.53% = 21.39%
TPS is similar, while cpu usage is from almost 400% to 350%

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 96 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 52 insertions(+), 44 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index bb7f161bb19c..9595616ccaa3 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -76,6 +76,7 @@ struct io_wqe_acct {
 	unsigned max_workers;
 	int index;
 	atomic_t nr_running;
+	raw_spinlock_t lock;
 	struct io_wq_work_list work_list;
 	unsigned long flags;
 };
@@ -224,12 +225,12 @@ static void io_worker_exit(struct io_worker *worker)
 	if (worker->flags & IO_WORKER_F_FREE)
 		hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
-	preempt_disable();
+	raw_spin_unlock(&wqe->lock);
 	io_wqe_dec_running(worker);
 	worker->flags = 0;
+	preempt_disable();
 	current->flags &= ~PF_IO_WORKER;
 	preempt_enable();
-	raw_spin_unlock(&wqe->lock);
 
 	kfree_rcu(worker, rcu);
 	io_worker_ref_put(wqe->wq);
@@ -385,7 +386,6 @@ static bool io_queue_worker_create(struct io_worker *worker,
 }
 
 static void io_wqe_dec_running(struct io_worker *worker)
-	__must_hold(wqe->lock)
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
@@ -393,13 +393,18 @@ static void io_wqe_dec_running(struct io_worker *worker)
 	if (!(worker->flags & IO_WORKER_F_UP))
 		return;
 
-	if (atomic_dec_and_test(&acct->nr_running) && io_acct_run_queue(acct)) {
-		atomic_inc(&acct->nr_running);
-		atomic_inc(&wqe->wq->worker_refs);
+	if (!atomic_dec_and_test(&acct->nr_running))
+		return;
+	raw_spin_lock(&wqe->lock);
+	if (!io_acct_run_queue(acct)) {
 		raw_spin_unlock(&wqe->lock);
-		io_queue_worker_create(worker, acct, create_worker_cb);
-		raw_spin_lock(&wqe->lock);
+		return;
 	}
+
+	raw_spin_unlock(&wqe->lock);
+	atomic_inc(&acct->nr_running);
+	atomic_inc(&wqe->wq->worker_refs);
+	io_queue_worker_create(worker, acct, create_worker_cb);
 }
 
 /*
@@ -407,11 +412,12 @@ static void io_wqe_dec_running(struct io_worker *worker)
  * it's currently on the freelist
  */
 static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker)
-	__must_hold(wqe->lock)
 {
 	if (worker->flags & IO_WORKER_F_FREE) {
 		worker->flags &= ~IO_WORKER_F_FREE;
+		raw_spin_lock(&wqe->lock);
 		hlist_nulls_del_init_rcu(&worker->nulls_node);
+		raw_spin_unlock(&wqe->lock);
 	}
 }
 
@@ -456,7 +462,7 @@ static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 
 static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 					   struct io_worker *worker)
-	__must_hold(wqe->lock)
+	__must_hold(acct->lock)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work, *tail;
@@ -498,9 +504,9 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		 * work being added and clearing the stalled bit.
 		 */
 		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
-		raw_spin_unlock(&wqe->lock);
+		raw_spin_unlock(&acct->lock);
 		unstalled = io_wait_on_hash(wqe, stall_hash);
-		raw_spin_lock(&wqe->lock);
+		raw_spin_lock(&acct->lock);
 		if (unstalled) {
 			clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 			if (wq_has_sleeper(&wqe->wq->hash->wait))
@@ -538,7 +544,7 @@ static void io_assign_current_work(struct io_worker *worker,
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 
 static void io_worker_handle_work(struct io_worker *worker)
-	__releases(wqe->lock)
+	__releases(acct->lock)
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
@@ -556,6 +562,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * clear the stalled flag.
 		 */
 		work = io_get_next_work(acct, worker);
+		raw_spin_unlock(&acct->lock);
 		if (work) {
 			__io_worker_busy(wqe, worker);
 
@@ -569,10 +576,9 @@ static void io_worker_handle_work(struct io_worker *worker)
 			raw_spin_lock(&worker->lock);
 			worker->next_work = work;
 			raw_spin_unlock(&worker->lock);
-		}
-		raw_spin_unlock(&wqe->lock);
-		if (!work)
+		} else {
 			break;
+		}
 		io_assign_current_work(worker, work);
 		__set_current_state(TASK_RUNNING);
 
@@ -609,7 +615,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 			}
 		} while (work);
 
-		raw_spin_lock(&wqe->lock);
+		raw_spin_lock(&acct->lock);
 	} while (1);
 }
 
@@ -634,11 +640,14 @@ static int io_wqe_worker(void *data)
 
 		set_current_state(TASK_INTERRUPTIBLE);
 loop:
-		raw_spin_lock(&wqe->lock);
+		raw_spin_lock(&acct->lock);
 		if (io_acct_run_queue(acct)) {
 			io_worker_handle_work(worker);
 			goto loop;
+		} else {
+			raw_spin_unlock(&acct->lock);
 		}
+		raw_spin_lock(&wqe->lock);
 		/* timed out, exit unless we're the last worker */
 		if (last_timeout && acct->nr_workers > 1) {
 			acct->nr_workers--;
@@ -663,7 +672,7 @@ static int io_wqe_worker(void *data)
 	}
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
-		raw_spin_lock(&wqe->lock);
+		raw_spin_lock(&acct->lock);
 		io_worker_handle_work(worker);
 	}
 
@@ -705,10 +714,7 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 		return;
 
 	worker->flags &= ~IO_WORKER_F_RUNNING;
-
-	raw_spin_lock(&worker->wqe->lock);
 	io_wqe_dec_running(worker);
-	raw_spin_unlock(&worker->wqe->lock);
 }
 
 static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
@@ -778,10 +784,12 @@ static void create_worker_cont(struct callback_head *cb)
 				.cancel_all	= true,
 			};
 
+			raw_spin_unlock(&wqe->lock);
 			while (io_acct_cancel_pending_work(wqe, acct, &match))
-				raw_spin_lock(&wqe->lock);
+				;
+		} else {
+			raw_spin_unlock(&wqe->lock);
 		}
-		raw_spin_unlock(&wqe->lock);
 		io_worker_ref_put(wqe->wq);
 		kfree(worker);
 		return;
@@ -914,6 +922,7 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
+	struct io_cb_cancel_data match;
 	unsigned work_flags = work->flags;
 	bool do_create;
 
@@ -927,10 +936,12 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 		return;
 	}
 
-	raw_spin_lock(&wqe->lock);
+	raw_spin_lock(&acct->lock);
 	io_wqe_insert_work(wqe, work);
 	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
+	raw_spin_unlock(&acct->lock);
 
+	raw_spin_lock(&wqe->lock);
 	rcu_read_lock();
 	do_create = !io_wqe_activate_free_worker(wqe, acct);
 	rcu_read_unlock();
@@ -946,18 +957,18 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 			return;
 
 		raw_spin_lock(&wqe->lock);
-		/* fatal condition, failed to create the first worker */
-		if (!acct->nr_workers) {
-			struct io_cb_cancel_data match = {
-				.fn		= io_wq_work_match_item,
-				.data		= work,
-				.cancel_all	= false,
-			};
-
-			if (io_acct_cancel_pending_work(wqe, acct, &match))
-				raw_spin_lock(&wqe->lock);
+		if (acct->nr_workers) {
+			raw_spin_unlock(&wqe->lock);
+			return;
 		}
 		raw_spin_unlock(&wqe->lock);
+
+		/* fatal condition, failed to create the first worker */
+		match.fn		= io_wq_work_match_item,
+		match.data		= work,
+		match.cancel_all	= false,
+
+		io_acct_cancel_pending_work(wqe, acct, &match);
 	}
 }
 
@@ -1032,22 +1043,23 @@ static inline void io_wqe_remove_pending(struct io_wqe *wqe,
 static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
 					struct io_wqe_acct *acct,
 					struct io_cb_cancel_data *match)
-	__releases(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
 
+	raw_spin_lock(&acct->lock);
 	wq_list_for_each(node, prev, &acct->work_list) {
 		work = container_of(node, struct io_wq_work, list);
 		if (!match->fn(work, match->data))
 			continue;
 		io_wqe_remove_pending(wqe, work, prev);
-		raw_spin_unlock(&wqe->lock);
+		raw_spin_unlock(&acct->lock);
 		io_run_cancel(work, wqe);
 		match->nr_pending++;
 		/* not safe to continue after unlock */
 		return true;
 	}
+	raw_spin_unlock(&acct->lock);
 
 	return false;
 }
@@ -1061,7 +1073,6 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
 
 		if (io_acct_cancel_pending_work(wqe, acct, match)) {
-			raw_spin_lock(&wqe->lock);
 			if (match->cancel_all)
 				goto retry;
 			break;
@@ -1103,13 +1114,11 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	for_each_node(node) {
 		struct io_wqe *wqe = wq->wqes[node];
 
-		raw_spin_lock(&wqe->lock);
 		io_wqe_cancel_pending_work(wqe, &match);
-		if (match.nr_pending && !match.cancel_all) {
-			raw_spin_unlock(&wqe->lock);
+		if (match.nr_pending && !match.cancel_all)
 			return IO_WQ_CANCEL_OK;
-		}
 
+		raw_spin_lock(&wqe->lock);
 		io_wqe_cancel_running_work(wqe, &match);
 		raw_spin_unlock(&wqe->lock);
 		if (match.nr_running && !match.cancel_all)
@@ -1190,6 +1199,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 			acct->index = i;
 			atomic_set(&acct->nr_running, 0);
 			INIT_WQ_LIST(&acct->work_list);
+			raw_spin_lock_init(&acct->lock);
 		}
 		wqe->wq = wq;
 		raw_spin_lock_init(&wqe->lock);
@@ -1282,9 +1292,7 @@ static void io_wq_destroy(struct io_wq *wq)
 			.fn		= io_wq_work_match_all,
 			.cancel_all	= true,
 		};
-		raw_spin_lock(&wqe->lock);
 		io_wqe_cancel_pending_work(wqe, &match);
-		raw_spin_unlock(&wqe->lock);
 		free_cpumask_var(wqe->cpu_mask);
 		kfree(wqe);
 	}
-- 
2.25.1

