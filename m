Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E513281CB9
	for <lists+io-uring@lfdr.de>; Fri,  2 Oct 2020 22:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725355AbgJBUO0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Oct 2020 16:14:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBUO0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Oct 2020 16:14:26 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08363C0613D0
        for <io-uring@vger.kernel.org>; Fri,  2 Oct 2020 13:14:26 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id u19so2899666ion.3
        for <io-uring@vger.kernel.org>; Fri, 02 Oct 2020 13:14:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WbkMzy7VmsaQRlC/1UTKy9t6TA3Vnaiwkxq3useYutY=;
        b=n2E5NOYpEwDuGQKrrLJUjZGPqTw/VnWqLE6RjF6xgOgm9VyU5W3kisnKsEKZYrrxM1
         VQnOPPhg1cYv2fLUaMPIx2ElpiGVczJ5/6i7U6WMRh3z45Dn1ZdnCBl8BdeW1ewOI0o6
         mNxQ/nQz2CvcOVNb1R31Geuw2t8lLqnyo7rW2tgDC2tiMTtDrMNwNlwtk2634TdnIDm3
         I3d2GLNsp3JuwvYHSuFKEhuRhzjjkmW2ESTIkTKfYKgfoP1wjvfmw8/VYWHVS1cEKD7s
         c7V35nc0Uyl7RokvtjsRhfn+59BZjOqG5tighogKQJeBt9WCs/Br7EF4m6QroSaQL2/C
         uAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WbkMzy7VmsaQRlC/1UTKy9t6TA3Vnaiwkxq3useYutY=;
        b=uhtkJXCFWMZztrwe3lz9iPklps1HL6elG0OAFtUKuhVHi58vv315BhNixXXEUHabSq
         2Em8DUTduKA7xnRFQAF63i4OqJxAuVCXADOhOdMNno/3vcL59X0GgIkX1oz9E+ASfX9u
         U744XlkC5uzMCh0lmnOmegEMZXdygA4VryXg/Bm5NP2CJgAZpUEbwAw47Fft2/eXdnLW
         7kVTa7sL+NO1rkr4qHi2XqH4E3+jZ/bBj2lWzNp5+jqlqBTI+vrdxKKFGBbypduVWL5K
         ZOR7JsY/7rSW4dUdbl5IjWek3ZP1nJB/DkfH/U558dFCN+imdFo1SClaj7BBEs2v3oK8
         RGLQ==
X-Gm-Message-State: AOAM53244WQnizOU5ZXfWRdBHPAtiHjS0a4+Drknx9tXEgGvPaOTAWvn
        piMuBj5tFLsRa89chkUo5hyawg==
X-Google-Smtp-Source: ABdhPJw9OiNS5tOs5BpCVSTSNBA0hiZOBa+aszKcVp0EYMdgKuZs+cbUsyhAzlLO240C8GcXIDY3jg==
X-Received: by 2002:a5e:9b11:: with SMTP id j17mr3212665iok.176.1601669665256;
        Fri, 02 Oct 2020 13:14:25 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id a7sm1278093ilh.46.2020.10.02.13.14.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2020 13:14:24 -0700 (PDT)
Subject: Re: [PATCH 3/3] task_work: use TIF_TASKWORK if available
To:     Thomas Gleixner <tglx@linutronix.de>,
        Oleg Nesterov <oleg@redhat.com>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        peterz@infradead.org
References: <20201001194208.1153522-1-axboe@kernel.dk>
 <20201001194208.1153522-4-axboe@kernel.dk>
 <20201002151415.GA29066@redhat.com> <871rigejb8.fsf@nanos.tec.linutronix.de>
 <4c9dbcc4-cae7-c7ad-8066-31d49239750a@kernel.dk>
 <87y2kocukv.fsf@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <a4e6f8a3-f33e-ed96-1c9b-fa222cde2320@kernel.dk>
Date:   Fri, 2 Oct 2020 14:14:24 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <87y2kocukv.fsf@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 10/2/20 1:10 PM, Thomas Gleixner wrote:
> On Fri, Oct 02 2020 at 09:52, Jens Axboe wrote:
>> On 10/2/20 9:31 AM, Thomas Gleixner wrote:
>>>> This way task_work_run() doesn't need to clear TIF_NOTIFY_SIGNAL and it can
>>>> have more users.
>>>
>>> I think it's fundamentaly wrong that we have several places and several
>>> flags which handle task_work_run() instead of having exactly one place
>>> and one flag.
>>
>> I don't disagree with that. I know it's not happening in this series, but
>> if we to the TIF_NOTIFY_SIGNAL route and get all archs supporting that,
>> then we can kill the signal and notify resume part of running task_work.
>> And that leaves us with exactly one place that runs it.
>>
>> So we can potentially improve the current situation in that regard.
> 
> I'll think about it over the weekend.

Thanks, I appreciate it!

Just to drive the point home, we'd end up with something like the below.
Which also enables me to remove a nasty sighand->lock deadlock
workaround in io_uring.

Not in this patch, but the io_uring cqring_wait() call can also be
removed. Outside of the core calling it in tracehook_notify_signal(),
the only callers are then the case where kthreads are used with
task_work.


 fs/io_uring.c                  | 41 ++++++++++++----------------------
 include/linux/sched/jobctl.h   |  4 +---
 include/linux/task_work.h      |  4 +---
 include/linux/tracehook.h      |  9 --------
 kernel/signal.c                | 22 ------------------
 kernel/task_work.c             | 40 +++------------------------------
 kernel/time/posix-cpu-timers.c |  2 +-
 7 files changed, 20 insertions(+), 102 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2a67552a9c2f..3a5f4a7bd369 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1597,12 +1597,12 @@ static void __io_free_req(struct io_kiocb *req)
 		int ret;
 
 		init_task_work(&req->task_work, io_req_task_file_table_put);
-		ret = task_work_add(req->task, &req->task_work, TWA_RESUME);
+		ret = task_work_add(req->task, &req->task_work, true);
 		if (unlikely(ret)) {
 			struct task_struct *tsk;
 
 			tsk = io_wq_get_task(req->ctx->io_wq);
-			task_work_add(tsk, &req->task_work, 0);
+			task_work_add(tsk, &req->task_work, false);
 		}
 	}
 }
@@ -1746,25 +1746,21 @@ static struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	return __io_req_find_next(req);
 }
 
-static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
-				bool twa_signal_ok)
+static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
 {
 	struct task_struct *tsk = req->task;
 	struct io_ring_ctx *ctx = req->ctx;
-	int ret, notify;
+	bool notify = false;
+	int ret;
 
 	if (tsk->flags & PF_EXITING)
 		return -ESRCH;
 
 	/*
-	 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
-	 * all other cases, use TWA_SIGNAL unconditionally to ensure we're
-	 * processing task_work. There's no reliable way to tell if TWA_RESUME
-	 * will do the job.
+	 * SQPOLL kernel thread doesn't need notification, just a wakeup.
 	 */
-	notify = 0;
-	if (!(ctx->flags & IORING_SETUP_SQPOLL) && twa_signal_ok)
-		notify = TWA_SIGNAL;
+	if (!(ctx->flags & IORING_SETUP_SQPOLL))
+		notify = true;
 
 	ret = task_work_add(tsk, cb, notify);
 	if (!ret)
@@ -1825,13 +1821,13 @@ static void io_req_task_queue(struct io_kiocb *req)
 	init_task_work(&req->task_work, io_req_task_submit);
 	percpu_ref_get(&req->ctx->refs);
 
-	ret = io_req_task_work_add(req, &req->task_work, true);
+	ret = io_req_task_work_add(req, &req->task_work);
 	if (unlikely(ret)) {
 		struct task_struct *tsk;
 
 		init_task_work(&req->task_work, io_req_task_cancel);
 		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, 0);
+		task_work_add(tsk, &req->task_work, false);
 		wake_up_process(tsk);
 	}
 }
@@ -3056,14 +3052,14 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 
 	/* submit ref gets dropped, acquire a new one */
 	refcount_inc(&req->refs);
-	ret = io_req_task_work_add(req, &req->task_work, true);
+	ret = io_req_task_work_add(req, &req->task_work);
 	if (unlikely(ret)) {
 		struct task_struct *tsk;
 
 		/* queue just for cancelation */
 		init_task_work(&req->task_work, io_req_task_cancel);
 		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, 0);
+		task_work_add(tsk, &req->task_work, false);
 		wake_up_process(tsk);
 	}
 	return 1;
@@ -4598,7 +4594,6 @@ struct io_poll_table {
 static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, task_work_func_t func)
 {
-	bool twa_signal_ok;
 	int ret;
 
 	/* for instances that support it check for an event match first: */
@@ -4613,27 +4608,19 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	init_task_work(&req->task_work, func);
 	percpu_ref_get(&req->ctx->refs);
 
-	/*
-	 * If we using the signalfd wait_queue_head for this wakeup, then
-	 * it's not safe to use TWA_SIGNAL as we could be recursing on the
-	 * tsk->sighand->siglock on doing the wakeup. Should not be needed
-	 * either, as the normal wakeup will suffice.
-	 */
-	twa_signal_ok = (poll->head != &req->task->sighand->signalfd_wqh);
-
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
 	 * work gets canceled, so just cancel this request as well instead
 	 * of executing it. We can't safely execute it anyway, as we may not
 	 * have the needed state needed for it anyway.
 	 */
-	ret = io_req_task_work_add(req, &req->task_work, twa_signal_ok);
+	ret = io_req_task_work_add(req, &req->task_work);
 	if (unlikely(ret)) {
 		struct task_struct *tsk;
 
 		WRITE_ONCE(poll->canceled, true);
 		tsk = io_wq_get_task(req->ctx->io_wq);
-		task_work_add(tsk, &req->task_work, 0);
+		task_work_add(tsk, &req->task_work, false);
 		wake_up_process(tsk);
 	}
 	return 1;
diff --git a/include/linux/sched/jobctl.h b/include/linux/sched/jobctl.h
index d2b4204ba4d3..fa067de9f1a9 100644
--- a/include/linux/sched/jobctl.h
+++ b/include/linux/sched/jobctl.h
@@ -19,7 +19,6 @@ struct task_struct;
 #define JOBCTL_TRAPPING_BIT	21	/* switching to TRACED */
 #define JOBCTL_LISTENING_BIT	22	/* ptracer is listening for events */
 #define JOBCTL_TRAP_FREEZE_BIT	23	/* trap for cgroup freezer */
-#define JOBCTL_TASK_WORK_BIT	24	/* set by TWA_SIGNAL */
 
 #define JOBCTL_STOP_DEQUEUED	(1UL << JOBCTL_STOP_DEQUEUED_BIT)
 #define JOBCTL_STOP_PENDING	(1UL << JOBCTL_STOP_PENDING_BIT)
@@ -29,10 +28,9 @@ struct task_struct;
 #define JOBCTL_TRAPPING		(1UL << JOBCTL_TRAPPING_BIT)
 #define JOBCTL_LISTENING	(1UL << JOBCTL_LISTENING_BIT)
 #define JOBCTL_TRAP_FREEZE	(1UL << JOBCTL_TRAP_FREEZE_BIT)
-#define JOBCTL_TASK_WORK	(1UL << JOBCTL_TASK_WORK_BIT)
 
 #define JOBCTL_TRAP_MASK	(JOBCTL_TRAP_STOP | JOBCTL_TRAP_NOTIFY)
-#define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK | JOBCTL_TASK_WORK)
+#define JOBCTL_PENDING_MASK	(JOBCTL_STOP_PENDING | JOBCTL_TRAP_MASK)
 
 extern bool task_set_jobctl_pending(struct task_struct *task, unsigned long mask);
 extern void task_clear_jobctl_trapping(struct task_struct *task);
diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index 0fb93aafa478..a221bd5f746c 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -13,9 +13,7 @@ init_task_work(struct callback_head *twork, task_work_func_t func)
 	twork->func = func;
 }
 
-#define TWA_RESUME	1
-#define TWA_SIGNAL	2
-int task_work_add(struct task_struct *task, struct callback_head *twork, int);
+int task_work_add(struct task_struct *task, struct callback_head *twork, bool);
 
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
 void task_work_run(void);
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index 7ec0e94c5250..3a4a35ae87d1 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -178,15 +178,6 @@ static inline void set_notify_resume(struct task_struct *task)
  */
 static inline void tracehook_notify_resume(struct pt_regs *regs)
 {
-	/*
-	 * The caller just cleared TIF_NOTIFY_RESUME. This barrier
-	 * pairs with task_work_add()->set_notify_resume() after
-	 * hlist_add_head(task->task_works);
-	 */
-	smp_mb__after_atomic();
-	if (unlikely(current->task_works))
-		task_work_run();
-
 #ifdef CONFIG_KEYS_REQUEST_CACHE
 	if (unlikely(current->cached_requested_key)) {
 		key_put(current->cached_requested_key);
diff --git a/kernel/signal.c b/kernel/signal.c
index ad52141ab0d2..d44fa9141cef 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2271,8 +2271,6 @@ static void ptrace_do_notify(int signr, int exit_code, int why)
 void ptrace_notify(int exit_code)
 {
 	BUG_ON((exit_code & (0x7f | ~0xffff)) != SIGTRAP);
-	if (unlikely(current->task_works))
-		task_work_run();
 
 	spin_lock_irq(&current->sighand->siglock);
 	ptrace_do_notify(SIGTRAP, exit_code, CLD_TRAPPED);
@@ -2541,26 +2539,6 @@ bool get_signal(struct ksignal *ksig)
 
 relock:
 	spin_lock_irq(&sighand->siglock);
-	/*
-	 * Make sure we can safely read ->jobctl() in task_work add. As Oleg
-	 * states:
-	 *
-	 * It pairs with mb (implied by cmpxchg) before READ_ONCE. So we
-	 * roughly have
-	 *
-	 *	task_work_add:				get_signal:
-	 *	STORE(task->task_works, new_work);	STORE(task->jobctl);
-	 *	mb();					mb();
-	 *	LOAD(task->jobctl);			LOAD(task->task_works);
-	 *
-	 * and we can rely on STORE-MB-LOAD [ in task_work_add].
-	 */
-	smp_store_mb(current->jobctl, current->jobctl & ~JOBCTL_TASK_WORK);
-	if (unlikely(current->task_works)) {
-		spin_unlock_irq(&sighand->siglock);
-		task_work_run();
-		goto relock;
-	}
 
 	/*
 	 * Every stopped thread goes here after wakeup. Check to see if
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 95604e57af46..e68f5831a078 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -5,34 +5,6 @@
 
 static struct callback_head work_exited; /* all we need is ->next == NULL */
 
-/*
- * TWA_SIGNAL signaling - use TIF_NOTIFY_SIGNAL, if available, as it's faster
- * than TIF_SIGPENDING as there's no dependency on ->sighand. The latter is
- * shared for threads, and can cause contention on sighand->lock. Even for
- * the non-threaded case TIF_NOTIFY_SIGNAL is more efficient, as no locking
- * or IRQ disabling is involved for notification (or running) purposes.
- */
-static void task_work_notify_signal(struct task_struct *task)
-{
-#ifdef TIF_NOTIFY_SIGNAL
-	set_notify_signal(task);
-#else
-	unsigned long flags;
-
-	/*
-	 * Only grab the sighand lock if we don't already have some
-	 * task_work pending. This pairs with the smp_store_mb()
-	 * in get_signal(), see comment there.
-	 */
-	if (!(READ_ONCE(task->jobctl) & JOBCTL_TASK_WORK) &&
-	    lock_task_sighand(task, &flags)) {
-		task->jobctl |= JOBCTL_TASK_WORK;
-		signal_wake_up(task, 0);
-		unlock_task_sighand(task, &flags);
-	}
-#endif
-}
-
 /**
  * task_work_add - ask the @task to execute @work->func()
  * @task: the task which should run the callback
@@ -53,7 +25,7 @@ static void task_work_notify_signal(struct task_struct *task)
  * 0 if succeeds or -ESRCH.
  */
 int
-task_work_add(struct task_struct *task, struct callback_head *work, int notify)
+task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 {
 	struct callback_head *head;
 
@@ -64,14 +36,8 @@ task_work_add(struct task_struct *task, struct callback_head *work, int notify)
 		work->next = head;
 	} while (cmpxchg(&task->task_works, head, work) != head);
 
-	switch (notify) {
-	case TWA_RESUME:
-		set_notify_resume(task);
-		break;
-	case TWA_SIGNAL:
-		task_work_notify_signal(task);
-		break;
-	}
+	if (notify)
+		set_notify_signal(task);
 
 	return 0;
 }
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index a71758e34e45..51080a1ed11f 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -1128,7 +1128,7 @@ static inline void __run_posix_cpu_timers(struct task_struct *tsk)
 
 	/* Schedule task work to actually expire the timers */
 	tsk->posix_cputimers_work.scheduled = true;
-	task_work_add(tsk, &tsk->posix_cputimers_work.work, TWA_RESUME);
+	task_work_add(tsk, &tsk->posix_cputimers_work.work, true);
 }
 
 static inline bool posix_cpu_timers_enable_work(struct task_struct *tsk,

-- 
Jens Axboe

