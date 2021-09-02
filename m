Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC56D3FF41C
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 21:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347254AbhIBT0Z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 15:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243515AbhIBT0Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 15:26:25 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF071C061575
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 12:25:26 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id u7so2951366ilk.7
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 12:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TWY35YeufeDuefurhCEfy753kDqXx83XtUkNwlp9+c4=;
        b=gEij8OTSQlHtEAy9gkds2WsJ1WZc48vK/XEAP4NUctgrGGA9unqhoVaZ9D12wQVzh7
         VVCaSDF5OHzuTaywu/XWUGPTcrI0SmK0GTAUTh9pIxp4vFRI1ZZwIJixi1djMHbtsqCU
         /fWdddVLgkVHHIKI6LQrNIVM03iw0lAnNuhF8eCt7jmmmdxqOpXf1OiIOyK5Mmj9w3z7
         R7n2iiGZ6tdIQanPd/YFYLf4+08VWfXTpdxko3KMDKAnnUUE3Zd6DJsIRc0qTGw8M3dE
         sA6NRJG6mPp//UyqrlzPcN0BrSopyRBu41LckEiwByE+zFOWs8GJgD1A8gpf78c4Pzd2
         XCRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TWY35YeufeDuefurhCEfy753kDqXx83XtUkNwlp9+c4=;
        b=ruXb4/nVyV68FKCeE+BjZnzW+qhpHIO+zUDXXKr1vpAd9rbotzeRKlImoB/3063gYk
         XtYDJl8sguEq7nzyvr3X7h4+qvCH369KcfGqCyHGCmCn0jKISThXihqY8b8sWl/BuxF7
         TML7pUHsJ+rpz1zEzjEeK+zpv+KPZrPbuWimHoCFDHohrJw9cnGcSEc2Kn6r3CUpcrnf
         c6P3UHU07VgCRHcUqqXodHk9GdRhg5OHhvzrJPS7k7w6g7ng1eMdELzhilJ8Fe/7vMfN
         MnDSBlAFPjd04/EvNCwkaydo7Hf1/F3lg4XLSGyewTqSDdb7SrhazlHPQpQ91d1aN973
         KYFQ==
X-Gm-Message-State: AOAM533kPgudBGKNkfJ/Y82m/GJgznEKxjaJJwq1Xh7LT31u22IZtSwf
        d+tO3SsVgC/piw5g+9unE17LUYQ4+T9Xeg==
X-Google-Smtp-Source: ABdhPJz2WFE/qhVRs/khcDEM3DE9sjPro0M1bA4K06a5w7UwSAezajUx98Sz3cydHRZ8lVogC27feg==
X-Received: by 2002:a92:ca0a:: with SMTP id j10mr3519405ils.192.1630610725834;
        Thu, 02 Sep 2021 12:25:25 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g12sm1399406iok.32.2021.09.02.12.25.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:25:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io-wq: split bounded and unbounded work into separate lists
Date:   Thu,  2 Sep 2021 13:25:17 -0600
Message-Id: <20210902192520.326283-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210902192520.326283-1-axboe@kernel.dk>
References: <20210902192520.326283-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We've got a few issues that all boil down to the fact that we have one
list of pending work items, yet two different types of workers to
serve them. This causes some oddities around workers switching type and
even hashed work vs regular work on the same bounded list.

Just separate them out cleanly, similarly to how we already do
accounting of what is running. That provides a clean separation and
removes some corner cases that can cause stalls when handling IO
that is punted to io-wq.

Fixes: ecc53c48c13d ("io-wq: check max_worker limits if a worker transitions bound state")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 156 +++++++++++++++++++++++------------------------------
 1 file changed, 68 insertions(+), 88 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index aa9656eb832e..8cba77a937a1 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -32,7 +32,7 @@ enum {
 };
 
 enum {
-	IO_WQE_FLAG_STALLED	= 1,	/* stalled on hash */
+	IO_ACCT_STALLED_BIT	= 0,	/* stalled on hash */
 };
 
 /*
@@ -71,25 +71,24 @@ struct io_wqe_acct {
 	unsigned max_workers;
 	int index;
 	atomic_t nr_running;
+	struct io_wq_work_list work_list;
+	unsigned long flags;
 };
 
 enum {
 	IO_WQ_ACCT_BOUND,
 	IO_WQ_ACCT_UNBOUND,
+	IO_WQ_ACCT_NR,
 };
 
 /*
  * Per-node worker thread pool
  */
 struct io_wqe {
-	struct {
-		raw_spinlock_t lock;
-		struct io_wq_work_list work_list;
-		unsigned flags;
-	} ____cacheline_aligned_in_smp;
+	raw_spinlock_t lock;
+	struct io_wqe_acct acct[2];
 
 	int node;
-	struct io_wqe_acct acct[2];
 
 	struct hlist_nulls_head free_list;
 	struct list_head all_list;
@@ -195,11 +194,10 @@ static void io_worker_exit(struct io_worker *worker)
 	do_exit(0);
 }
 
-static inline bool io_wqe_run_queue(struct io_wqe *wqe)
-	__must_hold(wqe->lock)
+static inline bool io_acct_run_queue(struct io_wqe_acct *acct)
 {
-	if (!wq_list_empty(&wqe->work_list) &&
-	    !(wqe->flags & IO_WQE_FLAG_STALLED))
+	if (!wq_list_empty(&acct->work_list) &&
+	    !test_bit(IO_ACCT_STALLED_BIT, &acct->flags))
 		return true;
 	return false;
 }
@@ -208,7 +206,8 @@ static inline bool io_wqe_run_queue(struct io_wqe *wqe)
  * Check head of free list for an available worker. If one isn't available,
  * caller must create one.
  */
-static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
+static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
+					struct io_wqe_acct *acct)
 	__must_hold(RCU)
 {
 	struct hlist_nulls_node *n;
@@ -222,6 +221,10 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
 	hlist_nulls_for_each_entry_rcu(worker, n, &wqe->free_list, nulls_node) {
 		if (!io_worker_get(worker))
 			continue;
+		if (io_wqe_get_acct(worker) != acct) {
+			io_worker_release(worker);
+			continue;
+		}
 		if (wake_up_process(worker->task)) {
 			io_worker_release(worker);
 			return true;
@@ -340,7 +343,7 @@ static void io_wqe_dec_running(struct io_worker *worker)
 	if (!(worker->flags & IO_WORKER_F_UP))
 		return;
 
-	if (atomic_dec_and_test(&acct->nr_running) && io_wqe_run_queue(wqe)) {
+	if (atomic_dec_and_test(&acct->nr_running) && io_acct_run_queue(acct)) {
 		atomic_inc(&acct->nr_running);
 		atomic_inc(&wqe->wq->worker_refs);
 		io_queue_worker_create(wqe, worker, acct);
@@ -355,29 +358,10 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
 			     struct io_wq_work *work)
 	__must_hold(wqe->lock)
 {
-	bool worker_bound, work_bound;
-
-	BUILD_BUG_ON((IO_WQ_ACCT_UNBOUND ^ IO_WQ_ACCT_BOUND) != 1);
-
 	if (worker->flags & IO_WORKER_F_FREE) {
 		worker->flags &= ~IO_WORKER_F_FREE;
 		hlist_nulls_del_init_rcu(&worker->nulls_node);
 	}
-
-	/*
-	 * If worker is moving from bound to unbound (or vice versa), then
-	 * ensure we update the running accounting.
-	 */
-	worker_bound = (worker->flags & IO_WORKER_F_BOUND) != 0;
-	work_bound = (work->flags & IO_WQ_WORK_UNBOUND) == 0;
-	if (worker_bound != work_bound) {
-		int index = work_bound ? IO_WQ_ACCT_UNBOUND : IO_WQ_ACCT_BOUND;
-		io_wqe_dec_running(worker);
-		worker->flags ^= IO_WORKER_F_BOUND;
-		wqe->acct[index].nr_workers--;
-		wqe->acct[index ^ 1].nr_workers++;
-		io_wqe_inc_running(worker);
-	 }
 }
 
 /*
@@ -416,44 +400,23 @@ static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 	spin_unlock_irq(&wq->hash->wait.lock);
 }
 
-/*
- * We can always run the work if the worker is currently the same type as
- * the work (eg both are bound, or both are unbound). If they are not the
- * same, only allow it if incrementing the worker count would be allowed.
- */
-static bool io_worker_can_run_work(struct io_worker *worker,
-				   struct io_wq_work *work)
-{
-	struct io_wqe_acct *acct;
-
-	if (!(worker->flags & IO_WORKER_F_BOUND) !=
-	    !(work->flags & IO_WQ_WORK_UNBOUND))
-		return true;
-
-	/* not the same type, check if we'd go over the limit */
-	acct = io_work_get_acct(worker->wqe, work);
-	return acct->nr_workers < acct->max_workers;
-}
-
-static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
+static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 					   struct io_worker *worker)
 	__must_hold(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work, *tail;
 	unsigned int stall_hash = -1U;
+	struct io_wqe *wqe = worker->wqe;
 
-	wq_list_for_each(node, prev, &wqe->work_list) {
+	wq_list_for_each(node, prev, &acct->work_list) {
 		unsigned int hash;
 
 		work = container_of(node, struct io_wq_work, list);
 
-		if (!io_worker_can_run_work(worker, work))
-			break;
-
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
-			wq_list_del(&wqe->work_list, node, prev);
+			wq_list_del(&acct->work_list, node, prev);
 			return work;
 		}
 
@@ -464,7 +427,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
 		/* hashed, can run if not already running */
 		if (!test_and_set_bit(hash, &wqe->wq->hash->map)) {
 			wqe->hash_tail[hash] = NULL;
-			wq_list_cut(&wqe->work_list, &tail->list, prev);
+			wq_list_cut(&acct->work_list, &tail->list, prev);
 			return work;
 		}
 		if (stall_hash == -1U)
@@ -478,7 +441,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe,
 		 * Set this before dropping the lock to avoid racing with new
 		 * work being added and clearing the stalled bit.
 		 */
-		wqe->flags |= IO_WQE_FLAG_STALLED;
+		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 		raw_spin_unlock(&wqe->lock);
 		io_wait_on_hash(wqe, stall_hash);
 		raw_spin_lock(&wqe->lock);
@@ -515,6 +478,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 static void io_worker_handle_work(struct io_worker *worker)
 	__releases(wqe->lock)
 {
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	bool do_kill = test_bit(IO_WQ_BIT_EXIT, &wq->state);
@@ -529,7 +493,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		work = io_get_next_work(wqe, worker);
+		work = io_get_next_work(acct, worker);
 		if (work)
 			__io_worker_busy(wqe, worker, work);
 
@@ -563,10 +527,10 @@ static void io_worker_handle_work(struct io_worker *worker)
 
 			if (hash != -1U && !next_hashed) {
 				clear_bit(hash, &wq->hash->map);
+				clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 				if (wq_has_sleeper(&wq->hash->wait))
 					wake_up(&wq->hash->wait);
 				raw_spin_lock(&wqe->lock);
-				wqe->flags &= ~IO_WQE_FLAG_STALLED;
 				/* skip unnecessary unlock-lock wqe->lock */
 				if (!work)
 					goto get_next;
@@ -581,6 +545,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 static int io_wqe_worker(void *data)
 {
 	struct io_worker *worker = data;
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 	char buf[TASK_COMM_LEN];
@@ -596,7 +561,7 @@ static int io_wqe_worker(void *data)
 		set_current_state(TASK_INTERRUPTIBLE);
 loop:
 		raw_spin_lock(&wqe->lock);
-		if (io_wqe_run_queue(wqe)) {
+		if (io_acct_run_queue(acct)) {
 			io_worker_handle_work(worker);
 			goto loop;
 		}
@@ -764,12 +729,13 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 
 static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 {
+	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
 	unsigned int hash;
 	struct io_wq_work *tail;
 
 	if (!io_wq_is_hashed(work)) {
 append:
-		wq_list_add_tail(&work->list, &wqe->work_list);
+		wq_list_add_tail(&work->list, &acct->work_list);
 		return;
 	}
 
@@ -779,7 +745,7 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 	if (!tail)
 		goto append;
 
-	wq_list_add_after(&work->list, &tail->list, &wqe->work_list);
+	wq_list_add_after(&work->list, &tail->list, &acct->work_list);
 }
 
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
@@ -800,10 +766,10 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 
 	raw_spin_lock(&wqe->lock);
 	io_wqe_insert_work(wqe, work);
-	wqe->flags &= ~IO_WQE_FLAG_STALLED;
+	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 
 	rcu_read_lock();
-	do_create = !io_wqe_activate_free_worker(wqe);
+	do_create = !io_wqe_activate_free_worker(wqe, acct);
 	rcu_read_unlock();
 
 	raw_spin_unlock(&wqe->lock);
@@ -855,6 +821,7 @@ static inline void io_wqe_remove_pending(struct io_wqe *wqe,
 					 struct io_wq_work *work,
 					 struct io_wq_work_node *prev)
 {
+	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
 	unsigned int hash = io_get_work_hash(work);
 	struct io_wq_work *prev_work = NULL;
 
@@ -866,7 +833,7 @@ static inline void io_wqe_remove_pending(struct io_wqe *wqe,
 		else
 			wqe->hash_tail[hash] = NULL;
 	}
-	wq_list_del(&wqe->work_list, &work->list, prev);
+	wq_list_del(&acct->work_list, &work->list, prev);
 }
 
 static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
@@ -874,22 +841,27 @@ static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
+	int i;
 
 retry:
 	raw_spin_lock(&wqe->lock);
-	wq_list_for_each(node, prev, &wqe->work_list) {
-		work = container_of(node, struct io_wq_work, list);
-		if (!match->fn(work, match->data))
-			continue;
-		io_wqe_remove_pending(wqe, work, prev);
-		raw_spin_unlock(&wqe->lock);
-		io_run_cancel(work, wqe);
-		match->nr_pending++;
-		if (!match->cancel_all)
-			return;
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
 
-		/* not safe to continue after unlock */
-		goto retry;
+		wq_list_for_each(node, prev, &acct->work_list) {
+			work = container_of(node, struct io_wq_work, list);
+			if (!match->fn(work, match->data))
+				continue;
+			io_wqe_remove_pending(wqe, work, prev);
+			raw_spin_unlock(&wqe->lock);
+			io_run_cancel(work, wqe);
+			match->nr_pending++;
+			if (!match->cancel_all)
+				return;
+
+			/* not safe to continue after unlock */
+			goto retry;
+		}
 	}
 	raw_spin_unlock(&wqe->lock);
 }
@@ -950,18 +922,24 @@ static int io_wqe_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 			    int sync, void *key)
 {
 	struct io_wqe *wqe = container_of(wait, struct io_wqe, wait);
+	int i;
 
 	list_del_init(&wait->entry);
 
 	rcu_read_lock();
-	io_wqe_activate_free_worker(wqe);
+	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+		struct io_wqe_acct *acct = &wqe->acct[i];
+
+		if (test_and_clear_bit(IO_ACCT_STALLED_BIT, &acct->flags))
+			io_wqe_activate_free_worker(wqe, acct);
+	}
 	rcu_read_unlock();
 	return 1;
 }
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
-	int ret, node;
+	int ret, node, i;
 	struct io_wq *wq;
 
 	if (WARN_ON_ONCE(!data->free_work || !data->do_work))
@@ -996,18 +974,20 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		cpumask_copy(wqe->cpu_mask, cpumask_of_node(node));
 		wq->wqes[node] = wqe;
 		wqe->node = alloc_node;
-		wqe->acct[IO_WQ_ACCT_BOUND].index = IO_WQ_ACCT_BOUND;
-		wqe->acct[IO_WQ_ACCT_UNBOUND].index = IO_WQ_ACCT_UNBOUND;
 		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
-		atomic_set(&wqe->acct[IO_WQ_ACCT_BOUND].nr_running, 0);
 		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
 					task_rlimit(current, RLIMIT_NPROC);
-		atomic_set(&wqe->acct[IO_WQ_ACCT_UNBOUND].nr_running, 0);
-		wqe->wait.func = io_wqe_hash_wake;
 		INIT_LIST_HEAD(&wqe->wait.entry);
+		wqe->wait.func = io_wqe_hash_wake;
+		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
+			struct io_wqe_acct *acct = &wqe->acct[i];
+
+			acct->index = i;
+			atomic_set(&acct->nr_running, 0);
+			INIT_WQ_LIST(&acct->work_list);
+		}
 		wqe->wq = wq;
 		raw_spin_lock_init(&wqe->lock);
-		INIT_WQ_LIST(&wqe->work_list);
 		INIT_HLIST_NULLS_HEAD(&wqe->free_list, 0);
 		INIT_LIST_HEAD(&wqe->all_list);
 	}
@@ -1189,7 +1169,7 @@ int io_wq_max_workers(struct io_wq *wq, int *new_count)
 	for_each_node(node) {
 		struct io_wqe_acct *acct;
 
-		for (i = 0; i < 2; i++) {
+		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 			acct = &wq->wqes[node]->acct[i];
 			prev = max_t(int, acct->max_workers, prev);
 			if (new_count[i])
-- 
2.33.0

