Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 926A645B39D
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 05:46:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbhKXEuF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 23:50:05 -0500
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:60793 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229623AbhKXEuF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 23:50:05 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uy45oE2_1637729208;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uy45oE2_1637729208)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 12:46:55 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/9] io-wq: decouple work_list protection from the big wqe->lock
Date:   Wed, 24 Nov 2021 12:46:40 +0800
Message-Id: <20211124044648.142416-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211124044648.142416-1-haoxu@linux.alibaba.com>
References: <20211124044648.142416-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 fs/io-wq.c | 89 +++++++++++++++++++++++++++++++++---------------------
 1 file changed, 54 insertions(+), 35 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index fe6b2abcaa49..1869cf6c39f3 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -74,6 +74,7 @@ struct io_wqe_acct {
 	unsigned max_workers;
 	int index;
 	atomic_t nr_running;
+	raw_spinlock_t lock;
 	struct io_wq_work_list work_list;
 	unsigned long flags;
 };
@@ -221,12 +222,13 @@ static void io_worker_exit(struct io_worker *worker)
 	if (worker->flags & IO_WORKER_F_FREE)
 		hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
-	preempt_disable();
+	raw_spin_unlock(&wqe->lock);
+
 	io_wqe_dec_running(worker);
 	worker->flags = 0;
+	preempt_disable();
 	current->flags &= ~PF_IO_WORKER;
 	preempt_enable();
-	raw_spin_unlock(&wqe->lock);
 
 	kfree_rcu(worker, rcu);
 	io_worker_ref_put(wqe->wq);
@@ -380,11 +382,19 @@ static void io_wqe_dec_running(struct io_worker *worker)
 	if (!(worker->flags & IO_WORKER_F_UP))
 		return;
 
-	if (atomic_dec_and_test(&acct->nr_running) && io_acct_run_queue(acct)) {
-		atomic_inc(&acct->nr_running);
-		atomic_inc(&wqe->wq->worker_refs);
-		io_queue_worker_create(worker, acct, create_worker_cb);
+	if (!atomic_dec_and_test(&acct->nr_running))
+		return;
+
+	raw_spin_lock(&acct->lock);
+	if (!io_acct_run_queue(acct)) {
+		raw_spin_unlock(&acct->lock);
+		return;
 	}
+
+	raw_spin_unlock(&acct->lock);
+	atomic_inc(&acct->nr_running);
+	atomic_inc(&wqe->wq->worker_refs);
+	io_queue_worker_create(worker, acct, create_worker_cb);
 }
 
 /*
@@ -479,9 +489,9 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		 * work being added and clearing the stalled bit.
 		 */
 		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
-		raw_spin_unlock(&wqe->lock);
+		raw_spin_unlock(&acct->lock);
 		io_wait_on_hash(wqe, stall_hash);
-		raw_spin_lock(&wqe->lock);
+		raw_spin_lock(&acct->lock);
 	}
 
 	return NULL;
@@ -531,12 +541,14 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * clear the stalled flag.
 		 */
 		work = io_get_next_work(acct, worker);
-		if (work)
+		raw_spin_unlock(&acct->lock);
+		if (work) {
+			raw_spin_lock(&wqe->lock);
 			__io_worker_busy(wqe, worker, work);
-
-		raw_spin_unlock(&wqe->lock);
-		if (!work)
+			raw_spin_unlock(&wqe->lock);
+		} else {
 			break;
+		}
 		io_assign_current_work(worker, work);
 		__set_current_state(TASK_RUNNING);
 
@@ -567,15 +579,15 @@ static void io_worker_handle_work(struct io_worker *worker)
 				clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 				if (wq_has_sleeper(&wq->hash->wait))
 					wake_up(&wq->hash->wait);
-				raw_spin_lock(&wqe->lock);
+				raw_spin_lock(&acct->lock);
 				/* skip unnecessary unlock-lock wqe->lock */
 				if (!work)
 					goto get_next;
-				raw_spin_unlock(&wqe->lock);
+				raw_spin_unlock(&acct->lock);
 			}
 		} while (work);
 
-		raw_spin_lock(&wqe->lock);
+		raw_spin_lock(&acct->lock);
 	} while (1);
 }
 
@@ -598,11 +610,14 @@ static int io_wqe_worker(void *data)
 
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
@@ -627,7 +642,7 @@ static int io_wqe_worker(void *data)
 	}
 
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
-		raw_spin_lock(&wqe->lock);
+		raw_spin_lock(&acct->lock);
 		io_worker_handle_work(worker);
 	}
 
@@ -668,10 +683,7 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 		return;
 
 	worker->flags &= ~IO_WORKER_F_RUNNING;
-
-	raw_spin_lock(&worker->wqe->lock);
 	io_wqe_dec_running(worker);
-	raw_spin_unlock(&worker->wqe->lock);
 }
 
 static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
@@ -734,10 +746,12 @@ static void create_worker_cont(struct callback_head *cb)
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
@@ -870,6 +884,7 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
+	struct io_cb_cancel_data match;
 	unsigned work_flags = work->flags;
 	bool do_create;
 
@@ -883,10 +898,12 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
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
@@ -902,18 +919,19 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 			return;
 
 		raw_spin_lock(&wqe->lock);
+		if (acct->nr_workers) {
+			raw_spin_unlock(&wqe->lock);
+			return;
+		}
+		raw_spin_unlock(&wqe->lock);
+
 		/* fatal condition, failed to create the first worker */
-		if (!acct->nr_workers) {
-			struct io_cb_cancel_data match = {
-				.fn		= io_wq_work_match_item,
-				.data		= work,
-				.cancel_all	= false,
-			};
+		match.fn = io_wq_work_match_item,
+		match.data = work,
+		match.cancel_all = false,
 
-			if (io_acct_cancel_pending_work(wqe, acct, &match))
-				raw_spin_lock(&wqe->lock);
-		}
 		raw_spin_unlock(&wqe->lock);
+		io_acct_cancel_pending_work(wqe, acct, &match);
 	}
 }
 
@@ -982,17 +1000,19 @@ static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
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
@@ -1002,7 +1022,6 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 {
 	int i;
 retry:
-	raw_spin_lock(&wqe->lock);
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
 
@@ -1012,7 +1031,6 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 			return;
 		}
 	}
-	raw_spin_unlock(&wqe->lock);
 }
 
 static void io_wqe_cancel_running_work(struct io_wqe *wqe,
@@ -1134,6 +1152,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 			acct->index = i;
 			atomic_set(&acct->nr_running, 0);
 			INIT_WQ_LIST(&acct->work_list);
+			raw_spin_lock_init(&acct->lock);
 		}
 		wqe->wq = wq;
 		raw_spin_lock_init(&wqe->lock);
-- 
2.24.4

