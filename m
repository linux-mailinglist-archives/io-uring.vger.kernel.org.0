Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DB331FDA8
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbhBSRLN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbhBSRLG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:11:06 -0500
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD03C0617AA
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:25 -0800 (PST)
Received: by mail-il1-x130.google.com with SMTP id w1so5056567ilm.12
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dQGlowyq6zwdQ9oCBoVfhLlTaumq7FVSF0ara59osYE=;
        b=P8zH7r60KloNaWpj45hrxMfvEM9FvhlwFBb1Jl7ka+mcWJcaYvZQm1mzdZurdr/cio
         oTbnG9m9IDjpz/3d6+zabXEITscsdtIbUEF5BsbmVJmkKUwaT813sMvPi3HaOLQHuez1
         Y6JdUmXQTP7//w4qeSNqfqOyueE7JU7/ObWlhISkhNUnb9vgOkxgWYxKBzLELHXA54dH
         KxwVhvObentNh2NqJu42EMojb6Lq+R9wrZJeoCgtoiHgKvL3QEWhvQl4LRXiuj2qCSuP
         faTBMXvFnRhAQLVAxWOFkV93RDv7YTNSHpKWmebD9raqf2zCkikwM35+lfrSLHSb/Gca
         GuXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dQGlowyq6zwdQ9oCBoVfhLlTaumq7FVSF0ara59osYE=;
        b=cynVjRYKeYtSVVAKxmDAEQv9OxVXKKmbYx6+68FMpXhf2EKbmwP2H9UX7fj5RHv5kM
         P+bAe1XQny+zOdtmUTUEEwgT5GCQXT1IM59aXnKFw4ApV35uKsUr2srcNaJNwl7x3tDL
         aV7hop04yaVcfOhj1aG8tgv/q3XLV8Y1gRzyPnpoOhuY0uY5U6hLXsnY71HjKC7g/Ckz
         BWHzy0psY/+fLkoRTw7LxX1GaIEg0mBWfEJJBhpC7j+INjaFIlh1v4zUzZaEAtmxG+tw
         hLG1G0KP63PAi/jsB7QXQyR3A4C3nDXoUQ8hEcqrsGwaAHoe7NhMpBuGKsTpwmb02JWP
         pk1g==
X-Gm-Message-State: AOAM532exrWCLbyVAf/MX3kPm+7z6IX5Y6b0n0kKwcXOP1ltqkiFTn9/
        bFl9VSVfkG4yxuWxulMg0CLKmUVYTrZk4haQ
X-Google-Smtp-Source: ABdhPJx0OBnhqAo0ekSXoR56exyt83VHILQJ+UOhGtAKRVfNRyVJRPVDE7HDOcmEoaDVAjdQHYQUNA==
X-Received: by 2002:a92:d0d:: with SMTP id 13mr4708010iln.36.1613754624846;
        Fri, 19 Feb 2021 09:10:24 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:24 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/18] io-wq: fork worker threads from original task
Date:   Fri, 19 Feb 2021 10:10:01 -0700
Message-Id: <20210219171010.281878-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of using regular kthread kernel threads, create kernel threads
that are like a real thread that the task would create. This ensures that
we get all the context that we need, without having to carry that state
around. This greatly reduces the code complexity, and the risk of missing
state for a given request type.

With the move away from kthread, we can also dump everything related to
assigned state to the new threads.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c            | 301 +++++++++++++++---------------------------
 fs/io_uring.c         |   7 +
 include/linux/sched.h |   3 +
 3 files changed, 114 insertions(+), 197 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index ec7f1106b659..b53f569b5b4e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -13,12 +13,9 @@
 #include <linux/sched/mm.h>
 #include <linux/percpu.h>
 #include <linux/slab.h>
-#include <linux/kthread.h>
 #include <linux/rculist_nulls.h>
-#include <linux/fs_struct.h>
-#include <linux/blk-cgroup.h>
-#include <linux/audit.h>
 #include <linux/cpu.h>
+#include <linux/tracehook.h>
 
 #include "../kernel/sched/sched.h"
 #include "io-wq.h"
@@ -57,13 +54,6 @@ struct io_worker {
 	spinlock_t lock;
 
 	struct rcu_head rcu;
-	struct mm_struct *mm;
-#ifdef CONFIG_BLK_CGROUP
-	struct cgroup_subsys_state *blkcg_css;
-#endif
-	const struct cred *cur_creds;
-	const struct cred *saved_creds;
-	struct nsproxy *restore_nsproxy;
 };
 
 #if BITS_PER_LONG == 64
@@ -122,6 +112,8 @@ struct io_wq {
 	struct completion done;
 
 	struct hlist_node cpuhp_node;
+
+	pid_t task_pid;
 };
 
 static enum cpuhp_state io_wq_online;
@@ -137,61 +129,6 @@ static void io_worker_release(struct io_worker *worker)
 		wake_up_process(worker->task);
 }
 
-/*
- * Note: drops the wqe->lock if returning true! The caller must re-acquire
- * the lock in that case. Some callers need to restart handling if this
- * happens, so we can't just re-acquire the lock on behalf of the caller.
- */
-static bool __io_worker_unuse(struct io_wqe *wqe, struct io_worker *worker)
-{
-	bool dropped_lock = false;
-
-	if (worker->saved_creds) {
-		revert_creds(worker->saved_creds);
-		worker->cur_creds = worker->saved_creds = NULL;
-	}
-
-	if (current->files) {
-		__acquire(&wqe->lock);
-		raw_spin_unlock_irq(&wqe->lock);
-		dropped_lock = true;
-
-		task_lock(current);
-		current->files = NULL;
-		current->nsproxy = worker->restore_nsproxy;
-		task_unlock(current);
-	}
-
-	if (current->fs)
-		current->fs = NULL;
-
-	/*
-	 * If we have an active mm, we need to drop the wq lock before unusing
-	 * it. If we do, return true and let the caller retry the idle loop.
-	 */
-	if (worker->mm) {
-		if (!dropped_lock) {
-			__acquire(&wqe->lock);
-			raw_spin_unlock_irq(&wqe->lock);
-			dropped_lock = true;
-		}
-		__set_current_state(TASK_RUNNING);
-		kthread_unuse_mm(worker->mm);
-		mmput(worker->mm);
-		worker->mm = NULL;
-	}
-
-#ifdef CONFIG_BLK_CGROUP
-	if (worker->blkcg_css) {
-		kthread_associate_blkcg(NULL);
-		worker->blkcg_css = NULL;
-	}
-#endif
-	if (current->signal->rlim[RLIMIT_FSIZE].rlim_cur != RLIM_INFINITY)
-		current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
-	return dropped_lock;
-}
-
 static inline struct io_wqe_acct *io_work_get_acct(struct io_wqe *wqe,
 						   struct io_wq_work *work)
 {
@@ -237,10 +174,6 @@ static void io_worker_exit(struct io_worker *worker)
 	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
-	if (__io_worker_unuse(wqe, worker)) {
-		__release(&wqe->lock);
-		raw_spin_lock_irq(&wqe->lock);
-	}
 	acct->nr_workers--;
 	raw_spin_unlock_irq(&wqe->lock);
 
@@ -323,14 +256,7 @@ static void io_wqe_dec_running(struct io_worker *worker)
 
 static void io_worker_start(struct io_worker *worker)
 {
-	allow_kernel_signal(SIGINT);
-
-	current->flags |= PF_IO_WORKER;
-	current->fs = NULL;
-	current->files = NULL;
-
 	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
-	worker->restore_nsproxy = current->nsproxy;
 	io_wqe_inc_running(worker);
 }
 
@@ -387,7 +313,7 @@ static bool __io_worker_idle(struct io_wqe *wqe, struct io_worker *worker)
 		hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
 	}
 
-	return __io_worker_unuse(wqe, worker);
+	return false;
 }
 
 static inline unsigned int io_get_work_hash(struct io_wq_work *work)
@@ -426,96 +352,23 @@ static struct io_wq_work *io_get_next_work(struct io_wqe *wqe)
 	return NULL;
 }
 
-static void io_wq_switch_mm(struct io_worker *worker, struct io_wq_work *work)
+static void io_flush_signals(void)
 {
-	if (worker->mm) {
-		kthread_unuse_mm(worker->mm);
-		mmput(worker->mm);
-		worker->mm = NULL;
+	if (unlikely(test_tsk_thread_flag(current, TIF_NOTIFY_SIGNAL))) {
+		if (current->task_works)
+			task_work_run();
+		clear_tsk_thread_flag(current, TIF_NOTIFY_SIGNAL);
 	}
-
-	if (mmget_not_zero(work->identity->mm)) {
-		kthread_use_mm(work->identity->mm);
-		worker->mm = work->identity->mm;
-		return;
-	}
-
-	/* failed grabbing mm, ensure work gets cancelled */
-	work->flags |= IO_WQ_WORK_CANCEL;
-}
-
-static inline void io_wq_switch_blkcg(struct io_worker *worker,
-				      struct io_wq_work *work)
-{
-#ifdef CONFIG_BLK_CGROUP
-	if (!(work->flags & IO_WQ_WORK_BLKCG))
-		return;
-	if (work->identity->blkcg_css != worker->blkcg_css) {
-		kthread_associate_blkcg(work->identity->blkcg_css);
-		worker->blkcg_css = work->identity->blkcg_css;
-	}
-#endif
-}
-
-static void io_wq_switch_creds(struct io_worker *worker,
-			       struct io_wq_work *work)
-{
-	const struct cred *old_creds = override_creds(work->identity->creds);
-
-	worker->cur_creds = work->identity->creds;
-	if (worker->saved_creds)
-		put_cred(old_creds); /* creds set by previous switch */
-	else
-		worker->saved_creds = old_creds;
-}
-
-static void io_impersonate_work(struct io_worker *worker,
-				struct io_wq_work *work)
-{
-	if ((work->flags & IO_WQ_WORK_FILES) &&
-	    current->files != work->identity->files) {
-		task_lock(current);
-		current->files = work->identity->files;
-		current->nsproxy = work->identity->nsproxy;
-		task_unlock(current);
-		if (!work->identity->files) {
-			/* failed grabbing files, ensure work gets cancelled */
-			work->flags |= IO_WQ_WORK_CANCEL;
-		}
-	}
-	if ((work->flags & IO_WQ_WORK_FS) && current->fs != work->identity->fs)
-		current->fs = work->identity->fs;
-	if ((work->flags & IO_WQ_WORK_MM) && work->identity->mm != worker->mm)
-		io_wq_switch_mm(worker, work);
-	if ((work->flags & IO_WQ_WORK_CREDS) &&
-	    worker->cur_creds != work->identity->creds)
-		io_wq_switch_creds(worker, work);
-	if (work->flags & IO_WQ_WORK_FSIZE)
-		current->signal->rlim[RLIMIT_FSIZE].rlim_cur = work->identity->fsize;
-	else if (current->signal->rlim[RLIMIT_FSIZE].rlim_cur != RLIM_INFINITY)
-		current->signal->rlim[RLIMIT_FSIZE].rlim_cur = RLIM_INFINITY;
-	io_wq_switch_blkcg(worker, work);
-#ifdef CONFIG_AUDIT
-	current->loginuid = work->identity->loginuid;
-	current->sessionid = work->identity->sessionid;
-#endif
 }
 
 static void io_assign_current_work(struct io_worker *worker,
 				   struct io_wq_work *work)
 {
 	if (work) {
-		/* flush pending signals before assigning new work */
-		if (signal_pending(current))
-			flush_signals(current);
+		io_flush_signals();
 		cond_resched();
 	}
 
-#ifdef CONFIG_AUDIT
-	current->loginuid = KUIDT_INIT(AUDIT_UID_UNSET);
-	current->sessionid = AUDIT_SID_UNSET;
-#endif
-
 	spin_lock_irq(&worker->lock);
 	worker->cur_work = work;
 	spin_unlock_irq(&worker->lock);
@@ -556,7 +409,6 @@ static void io_worker_handle_work(struct io_worker *worker)
 			unsigned int hash = io_get_work_hash(work);
 
 			next_hashed = wq_next_work(work);
-			io_impersonate_work(worker, work);
 			wq->do_work(work);
 			io_assign_current_work(worker, NULL);
 
@@ -608,10 +460,11 @@ static int io_wqe_worker(void *data)
 			goto loop;
 		}
 		raw_spin_unlock_irq(&wqe->lock);
-		if (signal_pending(current))
-			flush_signals(current);
+		io_flush_signals();
 		if (schedule_timeout(WORKER_IDLE_TIMEOUT))
 			continue;
+		if (fatal_signal_pending(current))
+			break;
 		/* timed out, exit unless we're the fixed worker */
 		if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
 		    !(worker->flags & IO_WORKER_F_FIXED))
@@ -635,8 +488,10 @@ static int io_wqe_worker(void *data)
  */
 void io_wq_worker_running(struct task_struct *tsk)
 {
-	struct io_worker *worker = kthread_data(tsk);
+	struct io_worker *worker = tsk->pf_io_worker;
 
+	if (!worker)
+		return;
 	if (!(worker->flags & IO_WORKER_F_UP))
 		return;
 	if (worker->flags & IO_WORKER_F_RUNNING)
@@ -652,9 +507,10 @@ void io_wq_worker_running(struct task_struct *tsk)
  */
 void io_wq_worker_sleeping(struct task_struct *tsk)
 {
-	struct io_worker *worker = kthread_data(tsk);
-	struct io_wqe *wqe = worker->wqe;
+	struct io_worker *worker = tsk->pf_io_worker;
 
+	if (!worker)
+		return;
 	if (!(worker->flags & IO_WORKER_F_UP))
 		return;
 	if (!(worker->flags & IO_WORKER_F_RUNNING))
@@ -662,32 +518,27 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 
 	worker->flags &= ~IO_WORKER_F_RUNNING;
 
-	raw_spin_lock_irq(&wqe->lock);
+	raw_spin_lock_irq(&worker->wqe->lock);
 	io_wqe_dec_running(worker);
-	raw_spin_unlock_irq(&wqe->lock);
+	raw_spin_unlock_irq(&worker->wqe->lock);
 }
 
-static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
+static int task_thread(void *data, int index)
 {
+	struct io_worker *worker = data;
+	struct io_wqe *wqe = worker->wqe;
 	struct io_wqe_acct *acct = &wqe->acct[index];
-	struct io_worker *worker;
+	struct io_wq *wq = wqe->wq;
+	char buf[TASK_COMM_LEN];
 
-	worker = kzalloc_node(sizeof(*worker), GFP_KERNEL, wqe->node);
-	if (!worker)
-		return false;
+	sprintf(buf, "iou-wrk-%d", wq->task_pid);
+	set_task_comm(current, buf);
 
-	refcount_set(&worker->ref, 1);
-	worker->nulls_node.pprev = NULL;
-	worker->wqe = wqe;
-	spin_lock_init(&worker->lock);
+	current->pf_io_worker = worker;
+	worker->task = current;
 
-	worker->task = kthread_create_on_node(io_wqe_worker, worker, wqe->node,
-				"io_wqe_worker-%d/%d", index, wqe->node);
-	if (IS_ERR(worker->task)) {
-		kfree(worker);
-		return false;
-	}
-	kthread_bind_mask(worker->task, cpumask_of_node(wqe->node));
+	set_cpus_allowed_ptr(current, cpumask_of_node(wqe->node));
+	current->flags |= PF_NO_SETAFFINITY;
 
 	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
@@ -703,8 +554,58 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	if (index == IO_WQ_ACCT_UNBOUND)
 		atomic_inc(&wq->user->processes);
 
+	io_wqe_worker(data);
+	do_exit(0);
+}
+
+static int task_thread_bound(void *data)
+{
+	return task_thread(data, IO_WQ_ACCT_BOUND);
+}
+
+static int task_thread_unbound(void *data)
+{
+	return task_thread(data, IO_WQ_ACCT_UNBOUND);
+}
+
+static pid_t fork_thread(int (*fn)(void *), void *arg)
+{
+	unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
+				CLONE_IO|SIGCHLD;
+	struct kernel_clone_args args = {
+		.flags		= ((lower_32_bits(flags) | CLONE_VM |
+				    CLONE_UNTRACED) & ~CSIGNAL),
+		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
+		.stack		= (unsigned long)fn,
+		.stack_size	= (unsigned long)arg,
+	};
+
+	return kernel_clone(&args);
+}
+
+static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
+{
+	struct io_worker *worker;
+	pid_t pid;
+
+	worker = kzalloc_node(sizeof(*worker), GFP_KERNEL, wqe->node);
+	if (!worker)
+		return false;
+
+	refcount_set(&worker->ref, 1);
+	worker->nulls_node.pprev = NULL;
+	worker->wqe = wqe;
+	spin_lock_init(&worker->lock);
+
+	if (index == IO_WQ_ACCT_BOUND)
+		pid = fork_thread(task_thread_bound, worker);
+	else
+		pid = fork_thread(task_thread_unbound, worker);
+	if (pid < 0) {
+		kfree(worker);
+		return false;
+	}
 	refcount_inc(&wq->refs);
-	wake_up_process(worker->task);
 	return true;
 }
 
@@ -756,12 +657,17 @@ static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 static int io_wq_manager(void *data)
 {
 	struct io_wq *wq = data;
+	char buf[TASK_COMM_LEN];
 	int node;
 
-	refcount_set(&wq->refs, 1);
+	sprintf(buf, "iou-mgr-%d", wq->task_pid);
+	set_task_comm(current, buf);
+	current->flags |= PF_IO_WORKER;
+	wq->manager = current;
+
 	complete(&wq->done);
 
-	while (!kthread_should_stop()) {
+	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		for_each_node(node) {
 			struct io_wqe *wqe = wq->wqes[node];
 			bool fork_worker[2] = { false, false };
@@ -782,11 +688,13 @@ static int io_wq_manager(void *data)
 		}
 		set_current_state(TASK_INTERRUPTIBLE);
 		schedule_timeout(HZ);
+		if (fatal_signal_pending(current))
+			set_bit(IO_WQ_BIT_EXIT, &wq->state);
 	}
 
 	if (refcount_dec_and_test(&wq->refs)) {
 		complete(&wq->done);
-		return 0;
+		do_exit(0);
 	}
 	/* if ERROR is set and we get here, we have workers to wake */
 	if (test_bit(IO_WQ_BIT_ERROR, &wq->state)) {
@@ -795,7 +703,7 @@ static int io_wq_manager(void *data)
 			io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
 		rcu_read_unlock();
 	}
-	return 0;
+	do_exit(0);
 }
 
 static bool io_wq_can_queue(struct io_wqe *wqe, struct io_wqe_acct *acct,
@@ -919,7 +827,7 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 	spin_lock_irqsave(&worker->lock, flags);
 	if (worker->cur_work &&
 	    match->fn(worker->cur_work, match->data)) {
-		send_sig(SIGINT, worker->task, 1);
+		set_notify_signal(worker->task);
 		match->nr_running++;
 	}
 	spin_unlock_irqrestore(&worker->lock, flags);
@@ -1075,22 +983,21 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		INIT_LIST_HEAD(&wqe->all_list);
 	}
 
+	wq->task_pid = current->pid;
 	init_completion(&wq->done);
+	refcount_set(&wq->refs, 1);
 
-	wq->manager = kthread_create(io_wq_manager, wq, "io_wq_manager");
-	if (!IS_ERR(wq->manager)) {
-		wake_up_process(wq->manager);
+	current->flags |= PF_IO_WORKER;
+	ret = fork_thread(io_wq_manager, wq);
+	current->flags &= ~PF_IO_WORKER;
+	if (ret >= 0) {
 		wait_for_completion(&wq->done);
-		if (test_bit(IO_WQ_BIT_ERROR, &wq->state)) {
-			ret = -ENOMEM;
-			goto err;
-		}
 		reinit_completion(&wq->done);
 		return wq;
 	}
 
-	ret = PTR_ERR(wq->manager);
-	complete(&wq->done);
+	if (refcount_dec_and_test(&wq->refs))
+		complete(&wq->done);
 err:
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 	for_each_node(node)
@@ -1110,7 +1017,7 @@ void io_wq_destroy(struct io_wq *wq)
 
 	set_bit(IO_WQ_BIT_EXIT, &wq->state);
 	if (wq->manager)
-		kthread_stop(wq->manager);
+		wake_up_process(wq->manager);
 
 	rcu_read_lock();
 	for_each_node(node)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6ad3e1df6504..b0a7a2d3ab4f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1618,6 +1618,9 @@ static struct io_kiocb *__io_queue_async_work(struct io_kiocb *req)
 	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->task->io_uring;
 
+	BUG_ON(!tctx);
+	BUG_ON(!tctx->io_wq);
+
 	trace_io_uring_queue_async_work(ctx, io_wq_is_hashed(&req->work), req,
 					&req->work, req->flags);
 	io_wq_enqueue(tctx->io_wq, &req->work);
@@ -9266,6 +9269,10 @@ static int io_uring_flush(struct file *file, void *data)
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_ring_ctx *ctx = file->private_data;
 
+	/* Ignore helper thread files exit */
+	if (current->flags & PF_IO_WORKER)
+		return 0;
+
 	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
 		io_uring_cancel_task_requests(ctx, NULL);
 		io_req_caches_free(ctx, current);
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 6e3a5eeec509..a6a9f0323102 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -895,6 +895,9 @@ struct task_struct {
 	/* CLONE_CHILD_CLEARTID: */
 	int __user			*clear_child_tid;
 
+	/* PF_IO_WORKER */
+	void				*pf_io_worker;
+
 	u64				utime;
 	u64				stime;
 #ifdef CONFIG_ARCH_HAS_SCALED_CPUTIME
-- 
2.30.0

