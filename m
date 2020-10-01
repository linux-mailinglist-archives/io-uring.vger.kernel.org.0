Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA761280218
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 17:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732583AbgJAPDw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Oct 2020 11:03:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732577AbgJAPDw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Oct 2020 11:03:52 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF78CC0613D0
        for <io-uring@vger.kernel.org>; Thu,  1 Oct 2020 08:03:51 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id z13so6973862iom.8
        for <io-uring@vger.kernel.org>; Thu, 01 Oct 2020 08:03:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=6gLC9pJwL7el6FDX/E+nKhZmdb6dkHkZTtQvXJFKUnc=;
        b=sivY6BX2ogCRTNOc9HiCLW38GOiO7dtpBoUwnYPUhInpBvVEekySzj+ujRySFmLo87
         MABOoxT7CPgEu9ub4Cwp0bht+Iw342nYMeGbdfwCzibqb7nxIXuXUCSHh5FcsWE0ruMi
         tufaPVcBv69oHWIehey9ItE7s1gWwmmjJfz9uUB+pqRYVQbz9FqGzPZuBmlcU2RQkk92
         L9fuw+0TvQ6FVoV/DSGZOXI8Z6Y3AZWilQB51c5P0B0fJG/EIm0C3dAPquH5CqMUZEpp
         c+yMfnlDSWFHs6OSCZTnfuBoiyWBmPRjirn5C1IQLVPFRYxJhIOuOwAR888gkK3sudVn
         5oAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=6gLC9pJwL7el6FDX/E+nKhZmdb6dkHkZTtQvXJFKUnc=;
        b=g8+D4VndQqkBfLjX9dJsXrc93spZgGkOgQhtJ943esEX/2d++yWg9N2i3/FnrLxEt8
         GC1nzLHwWITbseSF74zmzuKFTUQZYRRO6SlI7goSxD7sGOaKXhKHoroTwajMOv3t2RSJ
         CyW3Gg8E3U5W57Q3qb75UAH1MOPHS+sabgptq7hwNobVkW0729y2xm6vQ905UF/jbGhv
         rbVe/dQqiCWwRJ4IxhvpPCH8A40l/w7rCrLmUFAK5Qcf2DqZHBtTS1bXVCGAd1BWcmNu
         bBKXH57H+GEqvP8+zY4VqntD1sfkmPqbbWk4RwWEWouq1LmB1NhFl2FAe0R1Qa63SzGA
         Ateg==
X-Gm-Message-State: AOAM532iSHgownZt4m/gf7ZEjjfZCsn7Vt3E5endDE6SMazeCHhYxxlS
        iWCtTwfA022kXqMSzIZWrp+zxg==
X-Google-Smtp-Source: ABdhPJy3U9spKEYrtv9kC3PN1pZvNtYUUhvEoeOaFjbwNalgbPfLCo2h/RLJUgK7HHN95qIGkBLD3A==
X-Received: by 2002:a6b:ee10:: with SMTP id i16mr5637736ioh.112.1601564630838;
        Thu, 01 Oct 2020 08:03:50 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b16sm2110245iod.30.2020.10.01.08.03.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2020 08:03:50 -0700 (PDT)
To:     io-uring <io-uring@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH RFC v2] kernel: decouple TASK_WORK TWA_SIGNAL handling from
 signals
Message-ID: <3ce9e205-aad0-c9ce-86a7-b281f1c0237a@kernel.dk>
Date:   Thu, 1 Oct 2020 09:03:49 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Users of TWA_SIGNAL need to have system calls interrupted and go through
a kernel/user transition to ensure they are run. This currently works
well from a functional standpoint, but it is heavy handed on a
multithreaded application where sighand is shared between the threads and
main process. Adding TWA_SIGNAL task_work on such setups need to grab
the sighand->lock, which creates a hot spot for otherwise unrelated
task_work.

This adds TIF_TASKWORK for x86, which if set, will return true on
checking for pending signals. That in turn causes tasks to restart the
system call, which will run the added task_work. If TIF_TASKWORK is
available, we'll use that for notification when TWA_SIGNAL is specified.
If it isn't available, the existing TIF_SIGPENDING path is used.

Once all archs have added support for TIF_TASKWORK, we can kill the
old code completely. That will also allow removal of JOBCTL_TASK_WORK
and related code.

On my test box, even just using 16 threads shows a nice improvement
running an io_uring based echo server.

stock kernel:
0.01% <= 0.1 milliseconds
95.86% <= 0.2 milliseconds
98.27% <= 0.3 milliseconds
99.71% <= 0.4 milliseconds
100.00% <= 0.5 milliseconds
100.00% <= 0.6 milliseconds
100.00% <= 0.7 milliseconds
100.00% <= 0.8 milliseconds
100.00% <= 0.9 milliseconds
100.00% <= 1.0 milliseconds
100.00% <= 1.1 milliseconds
100.00% <= 2 milliseconds
100.00% <= 3 milliseconds
100.00% <= 3 milliseconds
1378930.00 requests per second
~1600% CPU

1.38M requests/second, and all 16 CPUs are maxed out.

patched kernel:
0.01% <= 0.1 milliseconds
98.24% <= 0.2 milliseconds
99.47% <= 0.3 milliseconds
99.99% <= 0.4 milliseconds
100.00% <= 0.5 milliseconds
100.00% <= 0.6 milliseconds
100.00% <= 0.7 milliseconds
100.00% <= 0.8 milliseconds
100.00% <= 0.9 milliseconds
100.00% <= 1.2 milliseconds
1666111.38 requests per second
~1450% CPU

1.67M requests/second, and we're no longer just hammering on the sighand
lock. The original reporter states:

"For 5.7.15 my benchmark achieves 1.6M qps and system cpu is at ~80%.
 for 5.7.16 or later it achieves only 1M qps and the system cpu is is
 at ~100%"

with the only difference there being that TWA_SIGNAL is used
unconditionally in 5.7.16, since we need it to be able to solve an
inability to run task_work if the application is waiting in the kernel
already on an event that needs task_work run to be satisfied. Also
see commit 0ba9c9edcd15.

Reported-by: Roman Gershman <romger@amazon.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

V2: Ensure we don't restart syscall if we did deliver a signal

This likely needs some splitting into two parts, but figured I'd toss
this one out there for comments. It's fixing a performance regression
for me, while still fixing the original issue that introduced the
regression.

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 267701ae3d86..79fe7db3208c 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -93,6 +93,7 @@ struct thread_info {
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* IA32 compatibility process */
 #define TIF_SLD			18	/* Restore split lock detection on context switch */
+#define TIF_TASKWORK		19	/* task_work pending */
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
 #define TIF_POLLING_NRFLAG	21	/* idle is polling for TIF_NEED_RESCHED */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
@@ -123,6 +124,7 @@ struct thread_info {
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_SLD		(1 << TIF_SLD)
+#define _TIF_TASKWORK		(1 << TIF_TASKWORK)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index be0d7d4152ec..5dc1eeaf0866 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -799,21 +799,8 @@ static inline unsigned long get_nr_restart_syscall(const struct pt_regs *regs)
 #endif
 }
 
-/*
- * Note that 'init' is a special process: it doesn't get signals it doesn't
- * want to handle. Thus you cannot kill init even with a SIGKILL even by
- * mistake.
- */
-void arch_do_signal(struct pt_regs *regs)
+void arch_restart_syscall(struct pt_regs *regs)
 {
-	struct ksignal ksig;
-
-	if (get_signal(&ksig)) {
-		/* Whee! Actually deliver the signal.  */
-		handle_signal(&ksig, regs);
-		return;
-	}
-
 	/* Did we come from a system call? */
 	if (syscall_get_nr(current, regs) >= 0) {
 		/* Restart the system call - no handlers present */
@@ -831,12 +818,29 @@ void arch_do_signal(struct pt_regs *regs)
 			break;
 		}
 	}
+}
+
+/*
+ * Note that 'init' is a special process: it doesn't get signals it doesn't
+ * want to handle. Thus you cannot kill init even with a SIGKILL even by
+ * mistake.
+ */
+bool arch_do_signal(struct pt_regs *regs)
+{
+	struct ksignal ksig;
+
+	if (get_signal(&ksig)) {
+		/* Whee! Actually deliver the signal.  */
+		handle_signal(&ksig, regs);
+		return true;
+	}
 
 	/*
 	 * If there's no signal to deliver, we just put the saved sigmask
 	 * back.
 	 */
 	restore_saved_sigmask();
+	return false;
 }
 
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index eed0d068904c..e0fec19b5faa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1767,7 +1767,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb,
 		notify = TWA_SIGNAL;
 
 	ret = task_work_add(tsk, cb, notify);
-	if (!ret)
+	if (!ret && !notify)
 		wake_up_process(tsk);
 
 	return ret;
@@ -6744,27 +6744,17 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 
 	iowq.nr_timeouts = atomic_read(&ctx->cq_timeouts);
 	trace_io_uring_cqring_wait(ctx, min_events);
-	do {
+	while (!io_should_wake(&iowq, false)) {
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
-		/* make sure we run task_work before checking for signals */
 		if (io_run_task_work())
 			continue;
 		if (signal_pending(current)) {
-			if (current->jobctl & JOBCTL_TASK_WORK) {
-				spin_lock_irq(&current->sighand->siglock);
-				current->jobctl &= ~JOBCTL_TASK_WORK;
-				recalc_sigpending();
-				spin_unlock_irq(&current->sighand->siglock);
-				continue;
-			}
 			ret = -EINTR;
 			break;
 		}
-		if (io_should_wake(&iowq, false))
-			break;
 		schedule();
-	} while (1);
+	}
 	finish_wait(&ctx->wait, &iowq.wq);
 
 	restore_saved_sigmask_unless(ret == -EINTR);
diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
index 159c7476b11b..03cab8b9ddab 100644
--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -37,6 +37,10 @@
 # define _TIF_UPROBE			(0)
 #endif
 
+#ifndef _TIF_TASKWORK
+# define _TIF_TASKWORK			(0)
+#endif
+
 /*
  * TIF flags handled in syscall_enter_from_usermode()
  */
@@ -69,7 +73,7 @@
 
 #define EXIT_TO_USER_MODE_WORK						\
 	(_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_UPROBE |		\
-	 _TIF_NEED_RESCHED | _TIF_PATCH_PENDING |			\
+	 _TIF_NEED_RESCHED | _TIF_PATCH_PENDING | _TIF_TASKWORK|	\
 	 ARCH_EXIT_TO_USER_MODE_WORK)
 
 /**
@@ -262,9 +266,19 @@ static __always_inline void arch_exit_to_user_mode(void) { }
  * arch_do_signal -  Architecture specific signal delivery function
  * @regs:	Pointer to currents pt_regs
  *
- * Invoked from exit_to_user_mode_loop().
+ * Invoked from exit_to_user_mode_loop(). Returns true if a signal was
+ * handled.
+ */
+bool arch_do_signal(struct pt_regs *regs);
+
+/**
+ * arch_restart_syscall -  Architecture specific syscall restarting
+ * @regs:	Pointer to currents pt_regs
+ *
+ * Invoked from exit_to_user_mode_loop(), if we need to restart the current
+ * system call.
  */
-void arch_do_signal(struct pt_regs *regs);
+void arch_restart_syscall(struct pt_regs *regs);
 
 /**
  * arch_syscall_exit_tracehook - Wrapper around tracehook_report_syscall_exit()
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 1bad18a1d8ba..d1a02749df74 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -355,7 +355,17 @@ static inline int restart_syscall(void)
 
 static inline int signal_pending(struct task_struct *p)
 {
-	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
+#ifdef TIF_TASKWORK
+	/*
+	 * TIF_TASKWORK isn't really a signal, but it requires the same
+	 * behavior of restarting the system call to force a kernel/user
+	 * transition.
+	 */
+	return unlikely(test_tsk_thread_flag(p, TIF_SIGPENDING) ||
+			test_tsk_thread_flag(p, TIF_TASKWORK));
+#else
+	return unlikely(test_tsk_thread_flag(p, TIF_SIGPENDING));
+#endif
 }
 
 static inline int __fatal_signal_pending(struct task_struct *p)
@@ -501,10 +511,16 @@ extern int set_user_sigmask(const sigset_t __user *umask, size_t sigsetsize);
 
 static inline void restore_saved_sigmask_unless(bool interrupted)
 {
-	if (interrupted)
+	if (interrupted) {
+#ifdef TIF_TASKWORK
+		WARN_ON(!test_thread_flag(TIF_SIGPENDING) &&
+			!test_thread_flag(TIF_TASKWORK));
+#else
 		WARN_ON(!test_thread_flag(TIF_SIGPENDING));
-	else
+#endif
+	} else {
 		restore_saved_sigmask();
+	}
 }
 
 static inline sigset_t *sigmask_to_save(void)
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 6fdb6105e6d6..d25ee8f7f071 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -135,11 +135,13 @@ static __always_inline void exit_to_user_mode(void)
 }
 
 /* Workaround to allow gradual conversion of architecture code */
-void __weak arch_do_signal(struct pt_regs *regs) { }
+bool __weak arch_do_signal(struct pt_regs *regs) { return true; }
 
 static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 					    unsigned long ti_work)
 {
+	bool restart_sys = (ti_work & (_TIF_SIGPENDING|_TIF_TASKWORK)) != 0;
+
 	/*
 	 * Before returning to user space ensure that all pending work
 	 * items have been completed.
@@ -157,8 +159,11 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		if (ti_work & _TIF_PATCH_PENDING)
 			klp_update_patch_state(current);
 
-		if (ti_work & _TIF_SIGPENDING)
-			arch_do_signal(regs);
+		if (ti_work & _TIF_TASKWORK)
+			task_work_run();
+
+		if ((ti_work & _TIF_SIGPENDING) && arch_do_signal(regs))
+			restart_sys = false;
 
 		if (ti_work & _TIF_NOTIFY_RESUME) {
 			clear_thread_flag(TIF_NOTIFY_RESUME);
@@ -178,6 +183,9 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		ti_work = READ_ONCE(current_thread_info()->flags);
 	}
 
+	if (restart_sys)
+		arch_restart_syscall(regs);
+
 	/* Return the latest work state for arch_exit_to_user_mode() */
 	return ti_work;
 }
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 613b2d634af8..3345a12df643 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -28,7 +28,6 @@ int
 task_work_add(struct task_struct *task, struct callback_head *work, int notify)
 {
 	struct callback_head *head;
-	unsigned long flags;
 
 	do {
 		head = READ_ONCE(task->task_works);
@@ -41,7 +40,10 @@ task_work_add(struct task_struct *task, struct callback_head *work, int notify)
 	case TWA_RESUME:
 		set_notify_resume(task);
 		break;
-	case TWA_SIGNAL:
+	case TWA_SIGNAL: {
+#ifndef TIF_TASKWORK
+		unsigned long flags;
+
 		/*
 		 * Only grab the sighand lock if we don't already have some
 		 * task_work pending. This pairs with the smp_store_mb()
@@ -53,7 +55,12 @@ task_work_add(struct task_struct *task, struct callback_head *work, int notify)
 			signal_wake_up(task, 0);
 			unlock_task_sighand(task, &flags);
 		}
+#else
+		set_tsk_thread_flag(task, TIF_TASKWORK);
+		wake_up_process(task);
+#endif
 		break;
+		}
 	}
 
 	return 0;
@@ -110,6 +117,11 @@ void task_work_run(void)
 	struct task_struct *task = current;
 	struct callback_head *work, *head, *next;
 
+#ifdef TIF_TASKWORK
+	if (test_tsk_thread_flag(task, TIF_TASKWORK))
+		clear_tsk_thread_flag(task, TIF_TASKWORK);
+#endif
+
 	for (;;) {
 		/*
 		 * work->func() can do task_work_add(), do not set

-- 
Jens Axboe

