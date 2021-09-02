Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570FC3FF422
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 21:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347326AbhIBT0b (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 15:26:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347257AbhIBT01 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 15:26:27 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4B2C061760
        for <io-uring@vger.kernel.org>; Thu,  2 Sep 2021 12:25:29 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id v2so2933736ilg.12
        for <io-uring@vger.kernel.org>; Thu, 02 Sep 2021 12:25:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xw0C4mLZhnYizJwX1JAkH1SYBgflSm8kECCsgdfUjEM=;
        b=Wmvuq5cbkZRsbLIHeGHZOCdT92PjEu8fdfE9JDP2/sn69kk2PF7OZEET9Klv/jxdsP
         vFmz8/Asgbpd8OhpwS1Pl8DTGFCupvFz09V9x540G5nlKmiQxQZ9Sm7b49MFa3lxnjBt
         ZVkSleLRZDW/EaCxObp97hB7ftD+z1fRIGtx+SVrNo4sAl1JrKPbAY5t9knNxhYpZGse
         TqVpEpr25P03jzyBRz6rfSZq+Im8neY1JScHVY3Gy6JTXNjvOXBUyr+eH9BF9G+qaMtr
         fkzHWqT7z3L28AWU1/Ild9jT+l1oVJoiSK/nGh/OuHcmT/dm6AoDTAGym+hj6Uf4hJYf
         E8qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xw0C4mLZhnYizJwX1JAkH1SYBgflSm8kECCsgdfUjEM=;
        b=tAUCPYovnMxdDREHMc/K6xvxe/ylj7ucsxpsUKlWKZMg59O4ykJDGhjyNA+mzQO54M
         tAAOCONwwVKdiA7ZJHFIMTnzt4s4MEhJlH3kPZ5lJM4cGfzWC6Pbh2lAe/TWK+T+o/lu
         fZROgIcIlXWnnwJldGb5t9g02/uSxQN1IlnLYCOEZOK/skYgQ3TZQbl8wJjZwCSq93fs
         oIncTgB/IuehJicoVGkFw3tZw/r/3Arl/2d+KvgmFFrlDODMcu5cW1X0/aFxyu6mJxp1
         PVpNIiOynM/kqTpxztOxnCONynMWZGFfescU4zy7pYBXxiJQ7WetZFG4RsSXMSoHyd8W
         btUQ==
X-Gm-Message-State: AOAM530fC+UhndqXBRW24wbUmd/LcGFKf0HluuhBONtVRU0aZhGPHcH7
        iqn4+/gysysXk6G3ksRUEKalZym1BjYG0A==
X-Google-Smtp-Source: ABdhPJyiORLZW7D7Q5l/A6QFzh3LgZziEF03O/q9EeCCf4n2XmSGlJfh3oCBA/ohCbAFsckLpoY16g==
X-Received: by 2002:a05:6e02:1c03:: with SMTP id l3mr3457540ilh.219.1630610728447;
        Thu, 02 Sep 2021 12:25:28 -0700 (PDT)
Received: from p1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id g12sm1399406iok.32.2021.09.02.12.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 12:25:28 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io-wq: make worker creation resilient against signals
Date:   Thu,  2 Sep 2021 13:25:20 -0600
Message-Id: <20210902192520.326283-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210902192520.326283-1-axboe@kernel.dk>
References: <20210902192520.326283-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a task is queueing async work and also handling signals, then we can
run into the case where create_io_thread() is interrupted and returns
failure because of that. If this happens for creating the first worker
in a group, then that worker will never get created and we can hang the
ring.

If we do get a fork failure, retry from task_work. With signals we have
to be a bit careful as we cannot simply queue as task_work, as we'll
still have signals pending at that point. Punt over a normal workqueue
first and then create from task_work after that.

Lastly, ensure that we handle fatal worker creations. Worker creation
failures are normally not fatal, only if we fail to create one in an empty
worker group can we not make progress. Right now that is ignored, ensure
that we handle that and run cancel on the work item.

There are two paths that create new workers - one is the "existing worker
going to sleep", and the other is "no workers found for this work, create
one". The former is never fatal, as workers do exist in the group. Only
the latter needs to be carefully handled.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 223 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 166 insertions(+), 57 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 50ea07764a99..d80e4a735677 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -54,7 +54,10 @@ struct io_worker {
 	struct callback_head create_work;
 	int create_index;
 
-	struct rcu_head rcu;
+	union {
+		struct rcu_head rcu;
+		struct work_struct work;
+	};
 };
 
 #if BITS_PER_LONG == 64
@@ -131,8 +134,11 @@ struct io_cb_cancel_data {
 	bool cancel_all;
 };
 
-static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
+static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
 static void io_wqe_dec_running(struct io_worker *worker);
+static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
+					struct io_wqe_acct *acct,
+					struct io_cb_cancel_data *match);
 
 static bool io_worker_get(struct io_worker *worker)
 {
@@ -238,7 +244,7 @@ static bool io_wqe_activate_free_worker(struct io_wqe *wqe,
  * We need a worker. If we find a free one, we're good. If not, and we're
  * below the max number of workers, create one.
  */
-static void io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
+static bool io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 {
 	bool do_create = false;
 
@@ -258,8 +264,10 @@ static void io_wqe_create_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	if (do_create) {
 		atomic_inc(&acct->nr_running);
 		atomic_inc(&wqe->wq->worker_refs);
-		create_io_worker(wqe->wq, wqe, acct->index);
+		return create_io_worker(wqe->wq, wqe, acct->index);
 	}
+
+	return true;
 }
 
 static void io_wqe_inc_running(struct io_worker *worker)
@@ -297,9 +305,11 @@ static void create_worker_cb(struct callback_head *cb)
 	io_worker_release(worker);
 }
 
-static void io_queue_worker_create(struct io_wqe *wqe, struct io_worker *worker,
-				   struct io_wqe_acct *acct)
+static bool io_queue_worker_create(struct io_worker *worker,
+				   struct io_wqe_acct *acct,
+				   task_work_func_t func)
 {
+	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 
 	/* raced with exit, just ignore create call */
@@ -317,16 +327,17 @@ static void io_queue_worker_create(struct io_wqe *wqe, struct io_worker *worker,
 	    test_and_set_bit_lock(0, &worker->create_state))
 		goto fail_release;
 
-	init_task_work(&worker->create_work, create_worker_cb);
+	init_task_work(&worker->create_work, func);
 	worker->create_index = acct->index;
 	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL))
-		return;
+		return true;
 	clear_bit_unlock(0, &worker->create_state);
 fail_release:
 	io_worker_release(worker);
 fail:
 	atomic_dec(&acct->nr_running);
 	io_worker_ref_put(wq);
+	return false;
 }
 
 static void io_wqe_dec_running(struct io_worker *worker)
@@ -341,7 +352,7 @@ static void io_wqe_dec_running(struct io_worker *worker)
 	if (atomic_dec_and_test(&acct->nr_running) && io_acct_run_queue(acct)) {
 		atomic_inc(&acct->nr_running);
 		atomic_inc(&wqe->wq->worker_refs);
-		io_queue_worker_create(wqe, worker, acct);
+		io_queue_worker_create(worker, acct, create_worker_cb);
 	}
 }
 
@@ -633,7 +644,91 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 	raw_spin_unlock(&worker->wqe->lock);
 }
 
-static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
+static void io_init_new_worker(struct io_wqe *wqe, struct io_worker *worker,
+			       struct task_struct *tsk)
+{
+	tsk->pf_io_worker = worker;
+	worker->task = tsk;
+	set_cpus_allowed_ptr(tsk, wqe->cpu_mask);
+	tsk->flags |= PF_NO_SETAFFINITY;
+
+	raw_spin_lock(&wqe->lock);
+	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
+	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
+	worker->flags |= IO_WORKER_F_FREE;
+	raw_spin_unlock(&wqe->lock);
+	wake_up_new_task(tsk);
+}
+
+static bool io_wq_work_match_all(struct io_wq_work *work, void *data)
+{
+	return true;
+}
+
+static inline bool io_should_retry_thread(long err)
+{
+	switch (err) {
+	case -EAGAIN:
+	case -ERESTARTSYS:
+	case -ERESTARTNOINTR:
+	case -ERESTARTNOHAND:
+		return true;
+	default:
+		return false;
+	}
+}
+
+static void create_worker_cont(struct callback_head *cb)
+{
+	struct io_worker *worker;
+	struct task_struct *tsk;
+	struct io_wqe *wqe;
+
+	worker = container_of(cb, struct io_worker, create_work);
+	clear_bit_unlock(0, &worker->create_state);
+	wqe = worker->wqe;
+	tsk = create_io_thread(io_wqe_worker, worker, wqe->node);
+	if (!IS_ERR(tsk)) {
+		io_init_new_worker(wqe, worker, tsk);
+		io_worker_release(worker);
+		return;
+	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+		struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+
+		atomic_dec(&acct->nr_running);
+		raw_spin_lock(&wqe->lock);
+		acct->nr_workers--;
+		if (!acct->nr_workers) {
+			struct io_cb_cancel_data match = {
+				.fn		= io_wq_work_match_all,
+				.cancel_all	= true,
+			};
+
+			while (io_acct_cancel_pending_work(wqe, acct, &match))
+				raw_spin_lock(&wqe->lock);
+		}
+		raw_spin_unlock(&wqe->lock);
+		io_worker_ref_put(wqe->wq);
+		return;
+	}
+
+	/* re-create attempts grab a new worker ref, drop the existing one */
+	io_worker_release(worker);
+	schedule_work(&worker->work);
+}
+
+static void io_workqueue_create(struct work_struct *work)
+{
+	struct io_worker *worker = container_of(work, struct io_worker, work);
+	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+
+	if (!io_queue_worker_create(worker, acct, create_worker_cont)) {
+		clear_bit_unlock(0, &worker->create_state);
+		io_worker_release(worker);
+	}
+}
+
+static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 {
 	struct io_wqe_acct *acct = &wqe->acct[index];
 	struct io_worker *worker;
@@ -642,40 +737,35 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	__set_current_state(TASK_RUNNING);
 
 	worker = kzalloc_node(sizeof(*worker), GFP_KERNEL, wqe->node);
-	if (!worker)
-		goto fail;
-
-	refcount_set(&worker->ref, 1);
-	worker->nulls_node.pprev = NULL;
-	worker->wqe = wqe;
-	spin_lock_init(&worker->lock);
-	init_completion(&worker->ref_done);
-
-	tsk = create_io_thread(io_wqe_worker, worker, wqe->node);
-	if (IS_ERR(tsk)) {
-		kfree(worker);
+	if (!worker) {
 fail:
 		atomic_dec(&acct->nr_running);
 		raw_spin_lock(&wqe->lock);
 		acct->nr_workers--;
 		raw_spin_unlock(&wqe->lock);
 		io_worker_ref_put(wq);
-		return;
+		return false;
 	}
 
-	tsk->pf_io_worker = worker;
-	worker->task = tsk;
-	set_cpus_allowed_ptr(tsk, wqe->cpu_mask);
-	tsk->flags |= PF_NO_SETAFFINITY;
+	refcount_set(&worker->ref, 1);
+	worker->wqe = wqe;
+	spin_lock_init(&worker->lock);
+	init_completion(&worker->ref_done);
 
-	raw_spin_lock(&wqe->lock);
-	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
-	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
-	worker->flags |= IO_WORKER_F_FREE;
 	if (index == IO_WQ_ACCT_BOUND)
 		worker->flags |= IO_WORKER_F_BOUND;
-	raw_spin_unlock(&wqe->lock);
-	wake_up_new_task(tsk);
+
+	tsk = create_io_thread(io_wqe_worker, worker, wqe->node);
+	if (!IS_ERR(tsk)) {
+		io_init_new_worker(wqe, worker, tsk);
+	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+		goto fail;
+	} else {
+		INIT_WORK(&worker->work, io_workqueue_create);
+		schedule_work(&worker->work);
+	}
+
+	return true;
 }
 
 /*
@@ -710,11 +800,6 @@ static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 	return false;
 }
 
-static bool io_wq_work_match_all(struct io_wq_work *work, void *data)
-{
-	return true;
-}
-
 static void io_run_cancel(struct io_wq_work *work, struct io_wqe *wqe)
 {
 	struct io_wq *wq = wqe->wq;
@@ -759,6 +844,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	 */
 	if (test_bit(IO_WQ_BIT_EXIT, &wqe->wq->state) ||
 	    (work->flags & IO_WQ_WORK_CANCEL)) {
+run_cancel:
 		io_run_cancel(work, wqe);
 		return;
 	}
@@ -774,8 +860,20 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 	raw_spin_unlock(&wqe->lock);
 
 	if (do_create && ((work_flags & IO_WQ_WORK_CONCURRENT) ||
-	    !atomic_read(&acct->nr_running)))
-		io_wqe_create_worker(wqe, acct);
+	    !atomic_read(&acct->nr_running))) {
+		bool did_create;
+
+		did_create = io_wqe_create_worker(wqe, acct);
+		if (unlikely(!did_create)) {
+			raw_spin_lock(&wqe->lock);
+			/* fatal condition, failed to create the first worker */
+			if (!acct->nr_workers) {
+				raw_spin_unlock(&wqe->lock);
+				goto run_cancel;
+			}
+			raw_spin_unlock(&wqe->lock);
+		}
+	}
 }
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
@@ -835,31 +933,42 @@ static inline void io_wqe_remove_pending(struct io_wqe *wqe,
 	wq_list_del(&acct->work_list, &work->list, prev);
 }
 
-static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
-				       struct io_cb_cancel_data *match)
+static bool io_acct_cancel_pending_work(struct io_wqe *wqe,
+					struct io_wqe_acct *acct,
+					struct io_cb_cancel_data *match)
+	__releases(wqe->lock)
 {
 	struct io_wq_work_node *node, *prev;
 	struct io_wq_work *work;
-	int i;
 
+	wq_list_for_each(node, prev, &acct->work_list) {
+		work = container_of(node, struct io_wq_work, list);
+		if (!match->fn(work, match->data))
+			continue;
+		io_wqe_remove_pending(wqe, work, prev);
+		raw_spin_unlock(&wqe->lock);
+		io_run_cancel(work, wqe);
+		match->nr_pending++;
+		/* not safe to continue after unlock */
+		return true;
+	}
+
+	return false;
+}
+
+static void io_wqe_cancel_pending_work(struct io_wqe *wqe,
+				       struct io_cb_cancel_data *match)
+{
+	int i;
 retry:
 	raw_spin_lock(&wqe->lock);
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		struct io_wqe_acct *acct = io_get_acct(wqe, i == 0);
 
-		wq_list_for_each(node, prev, &acct->work_list) {
-			work = container_of(node, struct io_wq_work, list);
-			if (!match->fn(work, match->data))
-				continue;
-			io_wqe_remove_pending(wqe, work, prev);
-			raw_spin_unlock(&wqe->lock);
-			io_run_cancel(work, wqe);
-			match->nr_pending++;
-			if (!match->cancel_all)
-				return;
-
-			/* not safe to continue after unlock */
-			goto retry;
+		if (io_acct_cancel_pending_work(wqe, acct, match)) {
+			if (match->cancel_all)
+				goto retry;
+			return;
 		}
 	}
 	raw_spin_unlock(&wqe->lock);
@@ -1013,7 +1122,7 @@ static bool io_task_work_match(struct callback_head *cb, void *data)
 {
 	struct io_worker *worker;
 
-	if (cb->func != create_worker_cb)
+	if (cb->func != create_worker_cb || cb->func != create_worker_cont)
 		return false;
 	worker = container_of(cb, struct io_worker, create_work);
 	return worker->wqe->wq == data;
-- 
2.33.0

