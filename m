Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE5D2807E6
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 21:42:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732866AbgJATmP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Oct 2020 15:42:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730093AbgJATmP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Oct 2020 15:42:15 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2364AC0613D0
        for <io-uring@vger.kernel.org>; Thu,  1 Oct 2020 12:42:15 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id k6so8224516ior.2
        for <io-uring@vger.kernel.org>; Thu, 01 Oct 2020 12:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=exCBRV9x3/u9XF6kdn60C7z3g/RQW1onuTvH2IX7xZ0=;
        b=hZIBrcXiyFnXfcXM+rlq/Cx5+NQ6gmnycTrxDL1zGOH11M4Czyzxs91kcGZ8VbgtBO
         qypDMcVoreiSeCCmqqGgecvOBxoJPcQE4z/1QVlHppf1ARCuoN0jnZ0MCbVmTxtqswQN
         RaQX95aJg1Ok0C2q/AVNr8z42rFSrWNwnZr4rCinxp5nFxuzL81YgrgOhz2NGyOyymgg
         kTdHUIh+xHJNVXxPYERfEZfxT0Iwv0OXSPkKN0io5Z6CGib26ppZMWqB4DF9F104sPFO
         MglDJ4j/GqZ6nvTdC5IB0xWp2PkcVvjbGqyGFR4GwkVcNO0qZT41FgTbpBI3wGgGDZ/W
         cfeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=exCBRV9x3/u9XF6kdn60C7z3g/RQW1onuTvH2IX7xZ0=;
        b=Z+GCLRnf8+g120qAB6RbIWUedSVrHkd+tIQUZJ3+Xw+XTTEiIXKmyW/Pm0dU/rr/jA
         RPJrxSt03wOyRHKxV4tmAntDVLq/YSZB7yGOrx57PJGkT6zYwmDoJmbTsEIy05FUZYYX
         Klb5BWwe8xSrRc2w1GsmOpIg7lIJKGB6FiJBVTvRXkNmuYVT1H2uQCev1//EuZqLBuW/
         5KIwiOlTsAwj2KMqBkkSzKQZzjksG6YL9NWOQ6MRSbcL4d5QzTstYcO61Dr7m32YV6nz
         se9Djnh3Lq8l6wWOP5WqTLfnpqHRfBhjKryn3C6kgWxtQl9Kvkvjbb7fOIhSzb2gIBfn
         JADA==
X-Gm-Message-State: AOAM530PvuJlUr18L7UJ90vwwr0v9DsuhpCX6DNvMzAQRQ8HMrhKeP88
        S7c9PXJ44KYueN4wJQgo2QQOIA==
X-Google-Smtp-Source: ABdhPJyU477HOS6pgUtY7Wo7EGtmqjjmiF3YHCm9dfvHIvU2WpLahE5waGI7QszuSEC8ygOBmrjRWA==
X-Received: by 2002:a6b:3742:: with SMTP id e63mr6681403ioa.50.1601581334306;
        Thu, 01 Oct 2020 12:42:14 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t11sm739609ill.61.2020.10.01.12.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 12:42:13 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>,
        Roman Gershman <romger@amazon.com>
Subject: [PATCH 2/3] kernel: decouple TASK_WORK TWA_SIGNAL handling from signals
Date:   Thu,  1 Oct 2020 13:42:07 -0600
Message-Id: <20201001194208.1153522-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001194208.1153522-1-axboe@kernel.dk>
References: <20201001194208.1153522-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Users of TWA_SIGNAL need to break out of kernel waits loops, or force
re-entry into the kernel, to ensure that the queued task_work is run.
TWA_SIGNAL currently works like signal delivery in that sense, and uses
the same delivery mechanism. This currently works well from a functional
standpoint, but it is very heavy handed on a multithreaded application
where sighand is shared between all threads and main process. Adding
TWA_SIGNAL task_work on such setups need to grab the sighand->lock, which
creates a hot spot for otherwise unrelated task_work. This lock grabbing
is necessary on both the queue-work and run-work side of things,
exacerbating the problem/contention.

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
 arch/x86/include/asm/thread_info.h |  2 ++
 arch/x86/kernel/signal.c           | 32 +++++++++++++++++-------------
 include/linux/entry-common.h       | 20 ++++++++++++++++---
 include/linux/sched/signal.h       | 19 ++++++++++++++++--
 kernel/entry/common.c              | 14 ++++++++++---
 5 files changed, 65 insertions(+), 22 deletions(-)

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
index e6f34d8fbf4d..3093a7d30a24 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -360,6 +360,15 @@ static inline int task_sigpending(struct task_struct *p)
 
 static inline int signal_pending(struct task_struct *p)
 {
+#ifdef TIF_TASKWORK
+	/*
+	 * IF_TASKWORK isn't really a signal, but it requires the same
+	 * behavior in terms of ensuring that we break out of wait loops
+	 * so that task_work can be processed.
+	 */
+	if (unlikely(test_tsk_thread_flag(p, TIF_TASKWORK)))
+		return 1;
+#endif
 	return task_sigpending(p);
 }
 
@@ -506,10 +515,16 @@ extern int set_user_sigmask(const sigset_t __user *umask, size_t sigsetsize);
 
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
-- 
2.28.0

