Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BB4928F303
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 15:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbgJONRL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 09:17:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728521AbgJONRK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 09:17:10 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E724C0613D5
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 06:17:09 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id t12so4028562ilh.3
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 06:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gcXNClmvNGT0ZcZm/PYa3YKMmvRI86wf/VrdveKe5Mw=;
        b=p2zoKyk3R6z74d2ZY5D871Cu1F02mngcKJyOWn17rMhYy5EiMaVsG4JqN6BMDvUkyi
         MW1ntb2dtVwNaHwRmLvPS0Kwr6RJxASfuWcMx17kduWHnPamufK/xEzNypxHnXnTSJLU
         HaYMAbkZFgeqYohoFCnLvOHF+VIu7QbdFU5Im9afMOsn43+ttk5z5Sn0guB66mXR13/V
         Rjtarkfx0E4sHMCkBHW17HI82TKlGVXZfrQHgqS3NW5P/ez5JMITSEJDdwE/DcqOtR/4
         yq6mh/+D48mxwri70hGcSPx9DHdNhge9o9jzuvZYweDGlqnw03Zo0dJmdar1wK1VqJ8T
         L3OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gcXNClmvNGT0ZcZm/PYa3YKMmvRI86wf/VrdveKe5Mw=;
        b=j+LpkVPVzmq1RD0zjHjGr2li2X4uO8U+Eq0V26UxU0Kl1y+F6zNKXDldws5/o6iL3o
         cDJn5nt5sByAtfzAHQjvdrALMBuXCw/P783qbzbCTxS8FaqYIdQq0xA/ixf3RLdWWb0K
         +Tb2VN7YpV+u66I7KtipvbFKjTgdfiRGVUwqKSQMzt812/uN3w7GlMWoWPSDfG5+Sv4T
         koFFQThCoPqN+f0UP1x7ogP4LBwEYO1H9XE0AoPNnBdQumTA1d9o6rkfLFAFnjouWVsC
         D9HwPmCWLmjK8W1m/MaVs+s5/GDuALdCwpVzxYECN4GzsvaHgF3pID241TJeQaFJTrS1
         xLJw==
X-Gm-Message-State: AOAM533xWPe+SPulJrT8ETeftdXg5bHgD/zK74YRzeGiC992XH3U3eEF
        JYvxFSAcbF8ZKPrxl8Thm/gu+Q==
X-Google-Smtp-Source: ABdhPJxBC5rES6GTgDbiJXq/23LwRSUv6LcM0o2cMCuuEo5j5D/RP8V783dkwu/3FOnDOFdyDUoN8A==
X-Received: by 2002:a05:6e02:cf:: with SMTP id r15mr885977ilq.90.1602767828325;
        Thu, 15 Oct 2020 06:17:08 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m13sm2486736ioo.9.2020.10.15.06.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 06:17:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] kernel: add support for TIF_NOTIFY_SIGNAL
Date:   Thu, 15 Oct 2020 07:16:59 -0600
Message-Id: <20201015131701.511523-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015131701.511523-1-axboe@kernel.dk>
References: <20201015131701.511523-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds TIF_NOTIFY_SIGNAL handling in the generic code, which if set,
will return true if signal_pending() is used in a wait loop. That causes
an exit of the loop so that notify_signal tracehooks can be run. If the
wait loop is currently inside a system call, the system call is restarted
once task_work has been processed.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 arch/x86/kernel/signal.c     |  2 +-
 include/linux/entry-common.h |  9 +++++++--
 include/linux/entry-kvm.h    |  4 ++--
 include/linux/sched/signal.h | 11 ++++++++++-
 include/linux/tracehook.h    | 27 +++++++++++++++++++++++++++
 kernel/entry/common.c        |  6 +++---
 kernel/entry/kvm.c           |  3 +++
 7 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index be0d7d4152ec..d18304e84c09 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -804,7 +804,7 @@ static inline unsigned long get_nr_restart_syscall(const struct pt_regs *regs)
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
  */
-void arch_do_signal(struct pt_regs *regs)
+void arch_do_signal(struct pt_regs *regs, unsigned long ti_work)
 {
 	struct ksignal ksig;
 
diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
index 159c7476b11b..42e899b3b4a1 100644
--- a/include/linux/entry-common.h
+++ b/include/linux/entry-common.h
@@ -37,6 +37,10 @@
 # define _TIF_UPROBE			(0)
 #endif
 
+#ifndef _TIF_NOTIFY_SIGNAL
+# define _TIF_NOTIFY_SIGNAL		(0)
+#endif
+
 /*
  * TIF flags handled in syscall_enter_from_usermode()
  */
@@ -69,7 +73,7 @@
 
 #define EXIT_TO_USER_MODE_WORK						\
 	(_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_UPROBE |		\
-	 _TIF_NEED_RESCHED | _TIF_PATCH_PENDING |			\
+	 _TIF_NEED_RESCHED | _TIF_PATCH_PENDING | _TIF_NOTIFY_SIGNAL |	\
 	 ARCH_EXIT_TO_USER_MODE_WORK)
 
 /**
@@ -261,10 +265,11 @@ static __always_inline void arch_exit_to_user_mode(void) { }
 /**
  * arch_do_signal -  Architecture specific signal delivery function
  * @regs:	Pointer to currents pt_regs
+ * @ti_work:	task thread info work flags
  *
  * Invoked from exit_to_user_mode_loop().
  */
-void arch_do_signal(struct pt_regs *regs);
+void arch_do_signal(struct pt_regs *regs, unsigned long ti_work);
 
 /**
  * arch_syscall_exit_tracehook - Wrapper around tracehook_report_syscall_exit()
diff --git a/include/linux/entry-kvm.h b/include/linux/entry-kvm.h
index 0cef17afb41a..9b93f8584ff7 100644
--- a/include/linux/entry-kvm.h
+++ b/include/linux/entry-kvm.h
@@ -11,8 +11,8 @@
 # define ARCH_XFER_TO_GUEST_MODE_WORK	(0)
 #endif
 
-#define XFER_TO_GUEST_MODE_WORK					\
-	(_TIF_NEED_RESCHED | _TIF_SIGPENDING |			\
+#define XFER_TO_GUEST_MODE_WORK						\
+	(_TIF_NEED_RESCHED | _TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL |	\
 	 _TIF_NOTIFY_RESUME | ARCH_XFER_TO_GUEST_MODE_WORK)
 
 struct kvm_vcpu;
diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 404145dc536e..b2ecc34284b0 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -360,6 +360,15 @@ static inline int task_sigpending(struct task_struct *p)
 
 static inline int signal_pending(struct task_struct *p)
 {
+#if defined(CONFIG_GENERIC_ENTRY) && defined(TIF_NOTIFY_SIGNAL)
+	/*
+	 * TIF_NOTIFY_SIGNAL isn't really a signal, but it requires the same
+	 * behavior in terms of ensuring that we break out of wait loops
+	 * so that notify signal callbacks can be processed.
+	 */
+	if (unlikely(test_tsk_thread_flag(p, TIF_NOTIFY_SIGNAL)))
+		return 1;
+#endif
 	return task_sigpending(p);
 }
 
@@ -507,7 +516,7 @@ extern int set_user_sigmask(const sigset_t __user *umask, size_t sigsetsize);
 static inline void restore_saved_sigmask_unless(bool interrupted)
 {
 	if (interrupted)
-		WARN_ON(!test_thread_flag(TIF_SIGPENDING));
+		WARN_ON(!signal_pending(current));
 	else
 		restore_saved_sigmask();
 }
diff --git a/include/linux/tracehook.h b/include/linux/tracehook.h
index b480e1a07ed8..0a5bb866e7a6 100644
--- a/include/linux/tracehook.h
+++ b/include/linux/tracehook.h
@@ -198,4 +198,31 @@ static inline void tracehook_notify_resume(struct pt_regs *regs)
 	blkcg_maybe_throttle_current();
 }
 
+/*
+ * called by exit_to_user_mode_loop() if ti_work & _TIF_NOTIFY_SIGNAL. This
+ * is currently used by TWA_SIGNAL based task_work, which requires breaking
+ * wait loops to ensure that task_work is noticed and run.
+ */
+static inline void tracehook_notify_signal(void)
+{
+#if defined(CONFIG_GENERIC_ENTRY) && defined(TIF_NOTIFY_SIGNAL)
+	clear_thread_flag(TIF_NOTIFY_SIGNAL);
+	smp_mb__after_atomic();
+	if (current->task_works)
+		task_work_run();
+#endif
+}
+
+/*
+ * Called when we have work to process from exit_to_user_mode_loop()
+ */
+static inline void set_notify_signal(struct task_struct *task)
+{
+#if defined(CONFIG_GENERIC_ENTRY) && defined(TIF_NOTIFY_SIGNAL)
+	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
+	    !wake_up_state(task, TASK_INTERRUPTIBLE))
+		kick_process(task);
+#endif
+}
+
 #endif	/* <linux/tracehook.h> */
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index d20ab4ac7183..bd3cf6279e94 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -135,7 +135,7 @@ static __always_inline void exit_to_user_mode(void)
 }
 
 /* Workaround to allow gradual conversion of architecture code */
-void __weak arch_do_signal(struct pt_regs *regs) { }
+void __weak arch_do_signal(struct pt_regs *regs, unsigned long ti_work) { }
 
 static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 					    unsigned long ti_work)
@@ -157,8 +157,8 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		if (ti_work & _TIF_PATCH_PENDING)
 			klp_update_patch_state(current);
 
-		if (ti_work & _TIF_SIGPENDING)
-			arch_do_signal(regs);
+		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
+			arch_do_signal(regs, ti_work);
 
 		if (ti_work & _TIF_NOTIFY_RESUME) {
 			tracehook_notify_resume(regs);
diff --git a/kernel/entry/kvm.c b/kernel/entry/kvm.c
index b6678a5e3cf6..49972ee99aff 100644
--- a/kernel/entry/kvm.c
+++ b/kernel/entry/kvm.c
@@ -8,6 +8,9 @@ static int xfer_to_guest_mode_work(struct kvm_vcpu *vcpu, unsigned long ti_work)
 	do {
 		int ret;
 
+		if (ti_work & _TIF_NOTIFY_SIGNAL)
+			tracehook_notify_signal();
+
 		if (ti_work & _TIF_SIGPENDING) {
 			kvm_handle_signal_exit(vcpu);
 			return -EINTR;
-- 
2.28.0

