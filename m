Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F601344DFE
	for <lists+io-uring@lfdr.de>; Mon, 22 Mar 2021 19:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbhCVSB2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Mar 2021 14:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbhCVSBL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Mar 2021 14:01:11 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62428C061762
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 11:01:05 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id v26so14893498iox.11
        for <io-uring@vger.kernel.org>; Mon, 22 Mar 2021 11:01:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=37vRW6kNJtS6uATvuvZAE6ZvuRn5o2T3YQrFWYCwWa8=;
        b=CqsOH3RSxTWbfr4asgTWL2oFi6VoZGc5Pt4aWpSAvD3oTvDtVTZfMzPhFEha1gwgop
         71vBwGVnkoT7sJ2ikJvG57wUmJLLEQKafHuZRGpfOQCBcTcvyZQZVX1bvJ2ZZQrIys4I
         EEfikpgiMVgs3dub+0BcJXvIdMuc1qvqfzrPVGa29Sk3+GfTY2+Bn2DXtWZpZaLJxPK5
         sfkEtFtL5t7GfMk6OgTb9BMpQbA4ZDvoRurfwvNqlPCramXAbDJfuQlmwmN/l+Z/MH1s
         kPMM3taegOW5E6ctaHRvIASvn0rDl+7rxX5PghMLs+FhEPJeUlfqtwOTaRTfAhtB0KTe
         /lMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=37vRW6kNJtS6uATvuvZAE6ZvuRn5o2T3YQrFWYCwWa8=;
        b=dd0qltA6hvs8IisNKWYyYK5p4VQ3VceA5s76gQ6eLk29O7IT1hoDmklP3eOoJyP4i9
         7dALW2q6NQl6fX8O0l2clRfjg2DLac5qQ1Y/U0fgJJK0K+7Kne9cn6z5mYLYIrKR7CWT
         gMdad8hbGEJsrhrasMFhfrubGqnGljAWRqUN92b1evZLcQHdU/NMGszeeiLUExgivv9z
         TjCpzNcg1UM/3IJbNEZBz2m4Xws0DUdchD/L9Rh0YBS2Vs0bxXYMOJ2Rw6K3gHjKFznH
         4ZpS6qpS9nATti70QLg31hdGlcLC1UBTrWrqnJZ/RfdcpzUGPLDb11qyVsO9skfM1nq9
         M15A==
X-Gm-Message-State: AOAM5323hgG9bHyIKCYo8uaejxH9sgKnxnXSz6jnHciIVynwMBPMgplT
        ncoATgTVM/GgbrFXHb5O+SeHGVo5SHyDjQ==
X-Google-Smtp-Source: ABdhPJxdVWVbnTvn/5KiTzLtP6fgIYJIwt1mz6/x7ah8LHqbKpDTV7P9HsytJkKWOxsLCKtH9oM8jw==
X-Received: by 2002:a05:6638:3ba:: with SMTP id z26mr590987jap.40.1616436064457;
        Mon, 22 Mar 2021 11:01:04 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r12sm2903562ile.64.2021.03.22.11.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Mar 2021 11:01:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io-wq: eliminate the need for a manager thread
Date:   Mon, 22 Mar 2021 12:00:59 -0600
Message-Id: <20210322180059.275415-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322180059.275415-1-axboe@kernel.dk>
References: <20210322180059.275415-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq relies on a manager thread to create/fork new workers, as needed.
But there's really no strong need for it anymore. We have the following
cases that fork a new worker:

1) Work queue. This is done from the task itself always, and it's trivial
   to create a worker off that path, if needed.

2) All workers have gone to sleep, and we have more work. This is called
   off the sched out path. For this case, use a task_work items to queue
   a fork-worker operation.

3) Hashed work completion. Don't think we need to do anything off this
   case. If need be, it could just use approach 2 as well.

Part of this change is incrementing the running worker count before the
fork, to avoid cases where we observe we need a worker and then queue
creation of one. Then new work comes in, we fork a new one. That last
queue operation should have waited for the previous worker to come up,
it's quite possible we don't even need it. Hence move the worker running
from before we fork it off to more efficiently handle that case.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 237 +++++++++++++++++++++--------------------------------
 1 file changed, 94 insertions(+), 143 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index d805ca8e3439..ec4f60659268 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -69,6 +69,7 @@ struct io_worker {
 struct io_wqe_acct {
 	unsigned nr_workers;
 	unsigned max_workers;
+	int index;
 	atomic_t nr_running;
 };
 
@@ -109,19 +110,16 @@ struct io_wq {
 	free_work_fn *free_work;
 	io_wq_work_fn *do_work;
 
-	struct task_struct *manager;
-
 	struct io_wq_hash *hash;
 
 	refcount_t refs;
-	struct completion exited;
 
 	atomic_t worker_refs;
 	struct completion worker_done;
 
 	struct hlist_node cpuhp_node;
 
-	pid_t task_pid;
+	struct task_struct *task;
 };
 
 static enum cpuhp_state io_wq_online;
@@ -136,6 +134,7 @@ struct io_cb_cancel_data {
 
 static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
 				       struct io_cb_cancel_data *match);
+static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
 
 static bool io_worker_get(struct io_worker *worker)
 {
@@ -207,7 +206,7 @@ static inline bool io_wqe_run_queue(struct io_wqe *wqe)
 
 /*
  * Check head of free list for an available worker. If one isn't available,
- * caller must wake up the wq manager to create one.
+ * caller must create one.
  */
 static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
 	__must_hold(RCU)
@@ -231,7 +230,7 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe)
 
 /*
  * We need a worker. If we find a free one, we're good. If not, and we're
- * below the max number of workers, wake up the manager to create one.
+ * below the max number of workers, create one.
  */
 static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 {
@@ -247,8 +246,10 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	ret = io_wqe_activate_free_worker(wqe);
 	rcu_read_unlock();
 
-	if (!ret && acct->nr_workers < acct->max_workers)
-		wake_up_process(wqe->wq->manager);
+	if (!ret && acct->nr_workers < acct->max_workers) {
+		atomic_inc(&acct->nr_running);
+		create_io_worker(wqe->wq, wqe, acct->index);
+	}
 }
 
 static void io_wqe_inc_running(struct io_worker *worker)
@@ -258,14 +259,55 @@ static void io_wqe_inc_running(struct io_worker *worker)
 	atomic_inc(&acct->nr_running);
 }
 
+struct create_worker_data {
+	struct callback_head work;
+	struct io_wqe *wqe;
+	int index;
+};
+
+static void create_worker_cb(struct callback_head *cb)
+{
+	struct create_worker_data *cwd;
+	struct io_wq *wq;
+
+	cwd = container_of(cb, struct create_worker_data, work);
+	wq = cwd->wqe->wq;
+	create_io_worker(wq, cwd->wqe, cwd->index);
+	kfree(cwd);
+}
+
+static void io_queue_worker_create(struct io_wqe *wqe, struct io_wqe_acct *acct)
+{
+	struct create_worker_data *cwd;
+
+	cwd = kmalloc(sizeof(*cwd), GFP_ATOMIC);
+	if (cwd) {
+		struct io_wq *wq = wqe->wq;
+
+		init_task_work(&cwd->work, create_worker_cb);
+		cwd->wqe = wqe;
+		cwd->index = acct->index;
+		if (!task_work_add(wq->task, &cwd->work, TWA_SIGNAL))
+			return;
+
+		kfree(cwd);
+	}
+	atomic_dec(&acct->nr_running);
+}
+
 static void io_wqe_dec_running(struct io_worker *worker)
 	__must_hold(wqe->lock)
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 	struct io_wqe *wqe = worker->wqe;
 
-	if (atomic_dec_and_test(&acct->nr_running) && io_wqe_run_queue(wqe))
-		io_wqe_wake_worker(wqe, acct);
+	if (!(worker->flags & IO_WORKER_F_UP))
+		return;
+
+	if (atomic_dec_and_test(&acct->nr_running) && io_wqe_run_queue(wqe)) {
+		atomic_inc(&acct->nr_running);
+		io_queue_worker_create(wqe, acct);
+	}
 }
 
 /*
@@ -480,9 +522,8 @@ static int io_wqe_worker(void *data)
 	char buf[TASK_COMM_LEN];
 
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
-	io_wqe_inc_running(worker);
 
-	sprintf(buf, "iou-wrk-%d", wq->task_pid);
+	sprintf(buf, "iou-wrk-%d", wq->task->pid);
 	set_task_comm(current, buf);
 
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
@@ -562,7 +603,7 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 	raw_spin_unlock_irq(&worker->wqe->lock);
 }
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
+static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 {
 	struct io_wqe_acct *acct = &wqe->acct[index];
 	struct io_worker *worker;
@@ -572,7 +613,7 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 
 	worker = kzalloc_node(sizeof(*worker), GFP_KERNEL, wqe->node);
 	if (!worker)
-		return false;
+		goto fail;
 
 	refcount_set(&worker->ref, 1);
 	worker->nulls_node.pprev = NULL;
@@ -587,7 +628,9 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		if (atomic_dec_and_test(&wq->worker_refs))
 			complete(&wq->worker_done);
 		kfree(worker);
-		return false;
+fail:
+		atomic_dec(&acct->nr_running);
+		return;
 	}
 
 	tsk->pf_io_worker = worker;
@@ -606,7 +649,6 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	acct->nr_workers++;
 	raw_spin_unlock_irq(&wqe->lock);
 	wake_up_new_task(tsk);
-	return true;
 }
 
 static inline bool io_wqe_need_worker(struct io_wqe *wqe, int index)
@@ -654,89 +696,6 @@ static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 	return false;
 }
 
-static void io_wq_check_workers(struct io_wq *wq)
-{
-	int node;
-
-	for_each_node(node) {
-		struct io_wqe *wqe = wq->wqes[node];
-		bool fork_worker[2] = { false, false };
-
-		if (!node_online(node))
-			continue;
-
-		raw_spin_lock_irq(&wqe->lock);
-		if (io_wqe_need_worker(wqe, IO_WQ_ACCT_BOUND))
-			fork_worker[IO_WQ_ACCT_BOUND] = true;
-		if (io_wqe_need_worker(wqe, IO_WQ_ACCT_UNBOUND))
-			fork_worker[IO_WQ_ACCT_UNBOUND] = true;
-		raw_spin_unlock_irq(&wqe->lock);
-		if (fork_worker[IO_WQ_ACCT_BOUND])
-			create_io_worker(wq, wqe, IO_WQ_ACCT_BOUND);
-		if (fork_worker[IO_WQ_ACCT_UNBOUND])
-			create_io_worker(wq, wqe, IO_WQ_ACCT_UNBOUND);
-	}
-}
-
-static bool io_wq_work_match_all(struct io_wq_work *work, void *data)
-{
-	return true;
-}
-
-static void io_wq_cancel_pending(struct io_wq *wq)
-{
-	struct io_cb_cancel_data match = {
-		.fn		= io_wq_work_match_all,
-		.cancel_all	= true,
-	};
-	int node;
-
-	for_each_node(node)
-		io_wqe_cancel_pending_work(wq->wqes[node], &match);
-}
-
-/*
- * Manager thread. Tasked with creating new workers, if we need them.
- */
-static int io_wq_manager(void *data)
-{
-	struct io_wq *wq = data;
-	char buf[TASK_COMM_LEN];
-	int node;
-
-	sprintf(buf, "iou-mgr-%d", wq->task_pid);
-	set_task_comm(current, buf);
-
-	do {
-		set_current_state(TASK_INTERRUPTIBLE);
-		io_wq_check_workers(wq);
-		schedule_timeout(HZ);
-		try_to_freeze();
-		if (fatal_signal_pending(current))
-			set_bit(IO_WQ_BIT_EXIT, &wq->state);
-	} while (!test_bit(IO_WQ_BIT_EXIT, &wq->state));
-
-	io_wq_check_workers(wq);
-
-	rcu_read_lock();
-	for_each_node(node)
-		io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
-	rcu_read_unlock();
-
-	if (atomic_dec_and_test(&wq->worker_refs))
-		complete(&wq->worker_done);
-	wait_for_completion(&wq->worker_done);
-
-	spin_lock_irq(&wq->hash->wait.lock);
-	for_each_node(node)
-		list_del_init(&wq->wqes[node]->wait.entry);
-	spin_unlock_irq(&wq->hash->wait.lock);
-
-	io_wq_cancel_pending(wq);
-	complete(&wq->exited);
-	do_exit(0);
-}
-
 static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 {
 	struct io_wq *wq = wqe->wq;
@@ -768,39 +727,13 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 	wq_list_add_after(&work->list, &tail->list, &wqe->work_list);
 }
 
-static int io_wq_fork_manager(struct io_wq *wq)
-{
-	struct task_struct *tsk;
-
-	if (wq->manager)
-		return 0;
-
-	WARN_ON_ONCE(test_bit(IO_WQ_BIT_EXIT, &wq->state));
-
-	init_completion(&wq->worker_done);
-	atomic_set(&wq->worker_refs, 1);
-	tsk = create_io_thread(io_wq_manager, wq, NUMA_NO_NODE);
-	if (!IS_ERR(tsk)) {
-		wq->manager = get_task_struct(tsk);
-		wake_up_new_task(tsk);
-		return 0;
-	}
-
-	if (atomic_dec_and_test(&wq->worker_refs))
-		complete(&wq->worker_done);
-
-	return PTR_ERR(tsk);
-}
-
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct = io_work_get_acct(wqe, work);
 	int work_flags;
 	unsigned long flags;
 
-	/* Can only happen if manager creation fails after exec */
-	if (io_wq_fork_manager(wqe->wq) ||
-	    test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state)) {
+	if (test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state)) {
 		io_run_cancel(work, wqe);
 		return;
 	}
@@ -955,17 +888,12 @@ static int io_wqe_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 			    int sync, void *key)
 {
 	struct io_wqe *wqe = container_of(wait, struct io_wqe, wait);
-	int ret;
 
 	list_del_init(&wait->entry);
 
 	rcu_read_lock();
-	ret = io_wqe_activate_free_worker(wqe);
+	io_wqe_activate_free_worker(wqe);
 	rcu_read_unlock();
-
-	if (!ret)
-		wake_up_process(wqe->wq->manager);
-
 	return 1;
 }
 
@@ -1006,6 +934,8 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 			goto err;
 		wq->wqes[node] = wqe;
 		wqe->node = alloc_node;
+		wqe->acct[IO_WQ_ACCT_BOUND].index = IO_WQ_ACCT_BOUND;
+		wqe->acct[IO_WQ_ACCT_UNBOUND].index = IO_WQ_ACCT_UNBOUND;
 		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 		atomic_set(&wqe->acct[IO_WQ_ACCT_BOUND].nr_running, 0);
 		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
@@ -1020,13 +950,11 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		INIT_LIST_HEAD(&wqe->all_list);
 	}
 
-	wq->task_pid = current->pid;
-	init_completion(&wq->exited);
+	wq->task = get_task_struct(current);
 	refcount_set(&wq->refs, 1);
-
-	ret = io_wq_fork_manager(wq);
-	if (!ret)
-		return wq;
+	atomic_set(&wq->worker_refs, 1);
+	init_completion(&wq->worker_done);
+	return wq;
 err:
 	io_wq_put_hash(data->hash);
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
@@ -1041,12 +969,35 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 
 static void io_wq_destroy_manager(struct io_wq *wq)
 {
-	if (wq->manager) {
-		wake_up_process(wq->manager);
-		wait_for_completion(&wq->exited);
-		put_task_struct(wq->manager);
-		wq->manager = NULL;
+	struct callback_head *cb;
+	int node;
+
+	if (!wq->task)
+		return;
+
+	while ((cb = task_work_cancel(wq->task, create_worker_cb)) != NULL) {
+		struct create_worker_data *cwd;
+
+		cwd = container_of(cb, struct create_worker_data, work);
+		atomic_dec(&cwd->wqe->acct[cwd->index].nr_running);
+		kfree(cwd);
+	}
+
+	rcu_read_lock();
+	for_each_node(node) {
+		struct io_wqe *wqe = wq->wqes[node];
+
+		io_wq_for_each_worker(wqe, io_wq_worker_wake, NULL);
+		spin_lock_irq(&wq->hash->wait.lock);
+		list_del_init(&wq->wqes[node]->wait.entry);
+		spin_unlock_irq(&wq->hash->wait.lock);
 	}
+	rcu_read_unlock();
+	if (atomic_dec_and_test(&wq->worker_refs))
+		complete(&wq->worker_done);
+	wait_for_completion(&wq->worker_done);
+	put_task_struct(wq->task);
+	wq->task = NULL;
 }
 
 static void io_wq_destroy(struct io_wq *wq)
-- 
2.31.0

