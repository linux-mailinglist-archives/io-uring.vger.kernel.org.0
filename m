Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 637231626E8
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 14:13:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgBRNNW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 08:13:22 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59306 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726086AbgBRNNW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 08:13:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=etIfrVQGUAnDbN410kayXbNX4GbwPXBTzUsE//3KSVU=; b=G46grnAddBeuKIlfKJ6NSTP40s
        2LFPQibUGK5B/jbJYvXh9Krrjzs1kVg1YJ1Qv0b0LrkaZwMYURdXvNFsIJae5R3KHG9AncBco2+m/
        JYpWqkxhKQqdAkLJRuOGR08nTnQCZUFQ/pPt3HbM+H1Y0jAmIqSIpz737Hq08xdBJ0vA/YIkUQqvY
        eLwkMvQc5a42u0G7IQZlEHrGsdUBDo5I5QDxkwBPZLH3ErJzhoDN6bFJR038KYmoVBXVcbIvBAVne
        Ad8pmnTN8NEc/NzqFiF5x5xXp8fTwOSyuEBASoCX6N9cs4hTGeYdphEhQPvm4guYQ2IGNXxCQMJPF
        aDRqFrIQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j42gb-0005cb-Fv; Tue, 18 Feb 2020 13:13:13 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 1F28B3008A9;
        Tue, 18 Feb 2020 14:11:18 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id B05632B92E2C2; Tue, 18 Feb 2020 14:13:10 +0100 (CET)
Date:   Tue, 18 Feb 2020 14:13:10 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Message-ID: <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
References: <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Feb 17, 2020 at 10:16:20AM -0800, Jens Axboe wrote:

> Enjoy! Thanks again for taking a look. I've pushed out the update:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-task-poll

Oleg, we're looking at adding sched-out/sched-in work, based on
task_work. Either see the above git tree, or the folded patch at the
very end of this email.

But this has me wondering about task_work_run(), as it is it will
unconditionally take pi_lock, would not something like this make sense?

(with the caveat that try_cmpxchg() doesn't seem available on !x86 -- I
should go fix that)

---
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 0fef395662a6..bf5a1f37c3c0 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -93,16 +93,20 @@ void task_work_run(void)
 	struct callback_head *work, *head, *next;
 
 	for (;;) {
+		work = READ_ONCE(task->task_work);
+		if (!work)
+			break
+
 		/*
 		 * work->func() can do task_work_add(), do not set
 		 * work_exited unless the list is empty.
 		 */
 		raw_spin_lock_irq(&task->pi_lock);
 		do {
-			work = READ_ONCE(task->task_works);
-			head = !work && (task->flags & PF_EXITING) ?
-				&work_exited : NULL;
-		} while (cmpxchg(&task->task_works, work, head) != work);
+			head = NULL;
+			if (unlikely(!work && (task->flags & PF_EXITING)))
+				head = &work_exited;
+		} while (!try_cmpxchg(&task->task_works, &work, head));
 		raw_spin_unlock_irq(&task->pi_lock);
 
 		if (!work)



---

Jens, I think you want something like this on top of what you have,
mostly it is adding sched_work_run() to exit_task_work().

---

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index c688c56ce01d..e0c56f461df6 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -17,13 +17,14 @@ int task_work_add(struct task_struct *task, struct callback_head *twork, bool);
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
 void task_work_run(void);
 
+int sched_work_add(struct task_struct *task, struct callback_head *work);
+struct callback_head *sched_work_cancel(struct task_struct *, task_work_func_t);
+void sched_work_run(void);
+
 static inline void exit_task_work(struct task_struct *task)
 {
 	task_work_run();
+	sched_work_run();
 }
 
-int sched_work_add(struct task_struct *task, struct callback_head *work);
-void sched_work_run(struct task_struct *task);
-struct callback_head *sched_work_cancel(struct task_struct *, task_work_func_t);
-
 #endif	/* _LINUX_TASK_WORK_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 6fda35072c2d..26d6ecf0e0cc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4106,7 +4106,7 @@ void __noreturn do_task_dead(void)
 static bool sched_out_update(struct task_struct *tsk)
 {
 	if (unlikely(tsk->sched_work)) {
-		sched_work_run(tsk);
+		sched_work_run();
 		return true;
 	}
 
@@ -4138,7 +4138,7 @@ static void sched_in_update(struct task_struct *tsk)
 			io_wq_worker_running(tsk);
 	}
 	if (unlikely(tsk->sched_work))
-		sched_work_run(tsk);
+		sched_work_run();
 }
 
 static inline void sched_submit_work(struct task_struct *tsk)
diff --git a/kernel/task_work.c b/kernel/task_work.c
index d73d1cd0c4dd..679550c8c7a4 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -117,10 +117,10 @@ sched_work_cancel(struct task_struct *task, task_work_func_t func)
 	return __task_work_cancel(task, &task->sched_work, func);
 }
 
-static void __task_work_run(struct task_struct *task,
-			    struct callback_head **headptr)
+static void __task_work_run(struct callback_head **headptr)
 {
 	struct callback_head *work, *head, *next;
+	struct task_struct *task = current;
 
 	for (;;) {
 		/*
@@ -157,10 +157,10 @@ static void __task_work_run(struct task_struct *task,
  */
 void task_work_run(void)
 {
-	__task_work_run(current, &current->task_works);
+	__task_work_run(&current->task_works);
 }
 
-void sched_work_run(struct task_struct *task)
+void sched_work_run()
 {
-	__task_work_run(task, &task->sched_work);
+	__task_work_run(&task->sched_work);
 }


----

folded patches from Jens

---
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 0918904c939d..8d3fbf6e815b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -649,6 +649,7 @@ struct task_struct {
 	/* Per task flags (PF_*), defined further below: */
 	unsigned int			flags;
 	unsigned int			ptrace;
+	int				on_rq;
 
 #ifdef CONFIG_SMP
 	struct llist_node		wake_entry;
@@ -671,13 +672,14 @@ struct task_struct {
 	int				recent_used_cpu;
 	int				wake_cpu;
 #endif
-	int				on_rq;
 
 	int				prio;
 	int				static_prio;
 	int				normal_prio;
 	unsigned int			rt_priority;
 
+	struct callback_head		*sched_work;
+
 	const struct sched_class	*sched_class;
 	struct sched_entity		se;
 	struct sched_rt_entity		rt;
diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index bd9a6a91c097..c688c56ce01d 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -22,4 +22,8 @@ static inline void exit_task_work(struct task_struct *task)
 	task_work_run();
 }
 
+int sched_work_add(struct task_struct *task, struct callback_head *work);
+void sched_work_run(struct task_struct *task);
+struct callback_head *sched_work_cancel(struct task_struct *, task_work_func_t);
+
 #endif	/* _LINUX_TASK_WORK_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e94819d573be..6fda35072c2d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2678,6 +2678,7 @@ int wake_up_state(struct task_struct *p, unsigned int state)
 static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 {
 	p->on_rq			= 0;
+	p->sched_work			= NULL;
 
 	p->se.on_rq			= 0;
 	p->se.exec_start		= 0;
@@ -4102,10 +4103,12 @@ void __noreturn do_task_dead(void)
 		cpu_relax();
 }
 
-static inline void sched_submit_work(struct task_struct *tsk)
+static bool sched_out_update(struct task_struct *tsk)
 {
-	if (!tsk->state)
-		return;
+	if (unlikely(tsk->sched_work)) {
+		sched_work_run(tsk);
+		return true;
+	}
 
 	/*
 	 * If a worker went to sleep, notify and ask workqueue whether
@@ -4123,18 +4126,10 @@ static inline void sched_submit_work(struct task_struct *tsk)
 		preempt_enable_no_resched();
 	}
 
-	if (tsk_is_pi_blocked(tsk))
-		return;
-
-	/*
-	 * If we are going to sleep and we have plugged IO queued,
-	 * make sure to submit it to avoid deadlocks.
-	 */
-	if (blk_needs_flush_plug(tsk))
-		blk_schedule_flush_plug(tsk);
+	return false;
 }
 
-static void sched_update_worker(struct task_struct *tsk)
+static void sched_in_update(struct task_struct *tsk)
 {
 	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER)) {
 		if (tsk->flags & PF_WQ_WORKER)
@@ -4142,6 +4137,28 @@ static void sched_update_worker(struct task_struct *tsk)
 		else
 			io_wq_worker_running(tsk);
 	}
+	if (unlikely(tsk->sched_work))
+		sched_work_run(tsk);
+}
+
+static inline void sched_submit_work(struct task_struct *tsk)
+{
+	if (!tsk->state)
+		return;
+
+	/* if we processed work, we could be runnable again. check. */
+	if (sched_out_update(tsk) && !tsk->state)
+		return;
+
+	if (tsk_is_pi_blocked(tsk))
+		return;
+
+	/*
+	 * If we are going to sleep and we have plugged IO queued,
+	 * make sure to submit it to avoid deadlocks.
+	 */
+	if (blk_needs_flush_plug(tsk))
+		blk_schedule_flush_plug(tsk);
 }
 
 asmlinkage __visible void __sched schedule(void)
@@ -4154,7 +4171,7 @@ asmlinkage __visible void __sched schedule(void)
 		__schedule(false);
 		sched_preempt_enable_no_resched();
 	} while (need_resched());
-	sched_update_worker(tsk);
+	sched_in_update(tsk);
 }
 EXPORT_SYMBOL(schedule);
 
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 0fef395662a6..d73d1cd0c4dd 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -3,7 +3,30 @@
 #include <linux/task_work.h>
 #include <linux/tracehook.h>
 
-static struct callback_head work_exited; /* all we need is ->next == NULL */
+static void task_exit_func(struct callback_head *head)
+{
+}
+
+static struct callback_head work_exited = {
+	.next	= NULL,
+	.func	= task_exit_func,
+};
+
+static int __task_work_add(struct task_struct *task,
+			   struct callback_head **headptr,
+			   struct callback_head *work)
+{
+	struct callback_head *head;
+
+	do {
+		head = READ_ONCE(*headptr);
+		if (unlikely(head == &work_exited))
+			return -ESRCH;
+		work->next = head;
+	} while (cmpxchg(headptr, head, work) != head);
+
+	return 0;
+}
 
 /**
  * task_work_add - ask the @task to execute @work->func()
@@ -27,39 +50,31 @@ static struct callback_head work_exited; /* all we need is ->next == NULL */
 int
 task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 {
-	struct callback_head *head;
+	int ret;
 
-	do {
-		head = READ_ONCE(task->task_works);
-		if (unlikely(head == &work_exited))
-			return -ESRCH;
-		work->next = head;
-	} while (cmpxchg(&task->task_works, head, work) != head);
+	ret = __task_work_add(task, &task->task_works, work);
 
 	if (notify)
 		set_notify_resume(task);
-	return 0;
+
+	return ret;
 }
 
-/**
- * task_work_cancel - cancel a pending work added by task_work_add()
- * @task: the task which should execute the work
- * @func: identifies the work to remove
- *
- * Find the last queued pending work with ->func == @func and remove
- * it from queue.
- *
- * RETURNS:
- * The found work or NULL if not found.
- */
-struct callback_head *
-task_work_cancel(struct task_struct *task, task_work_func_t func)
+int
+sched_work_add(struct task_struct *task, struct callback_head *work)
+{
+	return __task_work_add(task, &task->sched_work, work);
+}
+
+static struct callback_head *__task_work_cancel(struct task_struct *task,
+						struct callback_head **headptr,
+						task_work_func_t func)
 {
-	struct callback_head **pprev = &task->task_works;
+	struct callback_head **pprev = headptr;
 	struct callback_head *work;
 	unsigned long flags;
 
-	if (likely(!task->task_works))
+	if (likely(!(*headptr)))
 		return NULL;
 	/*
 	 * If cmpxchg() fails we continue without updating pprev.
@@ -80,16 +95,31 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
 }
 
 /**
- * task_work_run - execute the works added by task_work_add()
+ * task_work_cancel - cancel a pending work added by task_work_add()
+ * @task: the task which should execute the work
+ * @func: identifies the work to remove
  *
- * Flush the pending works. Should be used by the core kernel code.
- * Called before the task returns to the user-mode or stops, or when
- * it exits. In the latter case task_work_add() can no longer add the
- * new work after task_work_run() returns.
+ * Find the last queued pending work with ->func == @func and remove
+ * it from queue.
+ *
+ * RETURNS:
+ * The found work or NULL if not found.
  */
-void task_work_run(void)
+struct callback_head *
+task_work_cancel(struct task_struct *task, task_work_func_t func)
+{
+	return __task_work_cancel(task, &task->task_works, func);
+}
+
+struct callback_head *
+sched_work_cancel(struct task_struct *task, task_work_func_t func)
+{
+	return __task_work_cancel(task, &task->sched_work, func);
+}
+
+static void __task_work_run(struct task_struct *task,
+			    struct callback_head **headptr)
 {
-	struct task_struct *task = current;
 	struct callback_head *work, *head, *next;
 
 	for (;;) {
@@ -99,10 +129,10 @@ void task_work_run(void)
 		 */
 		raw_spin_lock_irq(&task->pi_lock);
 		do {
-			work = READ_ONCE(task->task_works);
+			work = READ_ONCE(*headptr);
 			head = !work && (task->flags & PF_EXITING) ?
 				&work_exited : NULL;
-		} while (cmpxchg(&task->task_works, work, head) != work);
+		} while (cmpxchg(headptr, work, head) != work);
 		raw_spin_unlock_irq(&task->pi_lock);
 
 		if (!work)
@@ -116,3 +146,21 @@ void task_work_run(void)
 		} while (work);
 	}
 }
+
+/**
+ * task_work_run - execute the works added by task_work_add()
+ *
+ * Flush the pending works. Should be used by the core kernel code.
+ * Called before the task returns to the user-mode or stops, or when
+ * it exits. In the latter case task_work_add() can no longer add the
+ * new work after task_work_run() returns.
+ */
+void task_work_run(void)
+{
+	__task_work_run(current, &current->task_works);
+}
+
+void sched_work_run(struct task_struct *task)
+{
+	__task_work_run(task, &task->sched_work);
+}
