Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 237F62997FD
	for <lists+io-uring@lfdr.de>; Mon, 26 Oct 2020 21:33:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732107AbgJZUci (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Oct 2020 16:32:38 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:34425 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732010AbgJZUch (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Oct 2020 16:32:37 -0400
Received: by mail-io1-f67.google.com with SMTP id z5so11879530iob.1
        for <io-uring@vger.kernel.org>; Mon, 26 Oct 2020 13:32:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4AnPuyy7/gG6oYUyQdb//jqNqAKJYACguXA57jzvo6k=;
        b=ZrMaxfsj4jXNi0My0rzGOwASqziLAJjL5ICTZqYmfUtVHbqU22nxSHQuIAc3vzZub1
         oJ17AVXFdDutpyqb7jPptxQiGbj6/T9g9E9zkZkCcHe9w8pszAl9wo6dER9HTpnt9uby
         2PTanA+zAYSzX0M0JtVUGErHeOq8cdd8kQUvX/kqtNF9hJkRCeG3PS3NSo0dCFfc7Ao0
         tQMFPzpECzTReVyt319jpixVUcBq0oOpTqxCTGxFVpPepjzn/tr3UmKv6w30IbsevRKs
         6HOtztkd0zcrJzos/HX3+o+NsIIIFVt9SAwNcHWF8AD20/HNcjVqyoNQDfAA2VJRMijY
         MseA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4AnPuyy7/gG6oYUyQdb//jqNqAKJYACguXA57jzvo6k=;
        b=Rh+VRC0j7rn/T6HAiF9tQuyLxNdFZuR7jnzxi4CBsguMATY23KqUAFtAGwmMdwikc+
         tRo4UnGVcqNjlizheEzBMBUU5nY9fLC+Rqtxjtn5xfEv+7kGSjCmRuvtxwql+vmjWw5+
         ML6p1U5XHMxSfldQV7xFQs38YRDNg8EOQKh0QG8mUrmQEzmNpDL5TehZGcRSIYj47oBk
         FIfXxAQsBAC9415QfdrKXP6qyUyjDk5JqjSaatt6HybxTf4sw3ca0ROvKZgaRJHjBh8H
         JTCFadX1DIzc3kAl6bsPpz5NftWmMoP6P5wth5HMNW0vDdMl1KVIkshqcOdwbLoqkvNW
         dmeA==
X-Gm-Message-State: AOAM532fdn/JB7ULzKFm/mg+vjHaBqdojMmUc+inaINVaWyUVrUZSXJz
        mnANzcsAQBd5xSVt0VUM7oMdOQ==
X-Google-Smtp-Source: ABdhPJwDLhFZaUYCOla3VLJx8AvpXlwnt/ECI5tpjVTlfcJcU7BtXAhblTOL48Lg4PXyOlY5Aecltg==
X-Received: by 2002:a05:6638:613:: with SMTP id g19mr12945855jar.44.1603744355695;
        Mon, 26 Oct 2020 13:32:35 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e12sm6770373ilq.65.2020.10.26.13.32.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 13:32:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] kernel: add support for TIF_NOTIFY_SIGNAL
Date:   Mon, 26 Oct 2020 14:32:28 -0600
Message-Id: <20201026203230.386348-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201026203230.386348-1-axboe@kernel.dk>
References: <20201026203230.386348-1-axboe@kernel.dk>
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

In preparation for only having arch_do_signal() handle syscall restarts
if _TIF_SIGPENDING isn't set, rename it to arch_do_signal_or_restart().
Pass in a boolean that tells the arch signal handler if it should attempt
to get a signal, or just process a potential syscall restart.

For !CONFIG_GENERIC_ENTRY archs, we add the TIF_NOTIFY_SIGNAL handling
to get_signal(). This is done to minimize the needed arch changes to
support this feature.

Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 arch/x86/kernel/signal.c     |  4 ++--
 include/linux/entry-common.h | 11 ++++++++---
 include/linux/entry-kvm.h    |  4 ++--
 include/linux/sched/signal.h | 11 ++++++++++-
 include/linux/tracehook.h    | 27 +++++++++++++++++++++++++++
 kernel/entry/common.c        | 14 +++++++++++---
 kernel/entry/kvm.c           |  3 +++
 kernel/signal.c              | 14 ++++++++++++++
 8 files changed, 77 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index be0d7d4152ec..ea794a083c44 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -804,11 +804,11 @@ static inline unsigned long get_nr_restart_syscall(const struct pt_regs *regs)
  * want to handle. Thus you cannot kill init even with a SIGKILL even by
  * mistake.
  */
-void arch_do_signal(struct pt_regs *regs)
+void arch_do_signal_or_restart(struct pt_regs *regs, bool has_signal)
 {
 	struct ksignal ksig;
 
-	if (get_signal(&ksig)) {
+	if (has_signal && get_signal(&ksig)) {
 		/* Whee! Actually deliver the signal.  */
 		handle_signal(&ksig, regs);
 		return;
diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
index 474f29638d2c..b9711e813ec2 100644
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
  * TIF flags handled in syscall_enter_from_user_mode()
  */
@@ -69,7 +73,7 @@
 
 #define EXIT_TO_USER_MODE_WORK						\
 	(_TIF_SIGPENDING | _TIF_NOTIFY_RESUME | _TIF_UPROBE |		\
-	 _TIF_NEED_RESCHED | _TIF_PATCH_PENDING |			\
+	 _TIF_NEED_RESCHED | _TIF_PATCH_PENDING | _TIF_NOTIFY_SIGNAL |	\
 	 ARCH_EXIT_TO_USER_MODE_WORK)
 
 /**
@@ -259,12 +263,13 @@ static __always_inline void arch_exit_to_user_mode(void) { }
 #endif
 
 /**
- * arch_do_signal -  Architecture specific signal delivery function
+ * arch_do_signal_or_restart -  Architecture specific signal delivery function
  * @regs:	Pointer to currents pt_regs
+ * @has_signal:	actual signal to handle
  *
  * Invoked from exit_to_user_mode_loop().
  */
-void arch_do_signal(struct pt_regs *regs);
+void arch_do_signal_or_restart(struct pt_regs *regs, bool has_signal);
 
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
index 404145dc536e..bd5afa076189 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -360,6 +360,15 @@ static inline int task_sigpending(struct task_struct *p)
 
 static inline int signal_pending(struct task_struct *p)
 {
+#if defined(TIF_NOTIFY_SIGNAL)
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
index b480e1a07ed8..f7d82e4fafd6 100644
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
+#if defined(TIF_NOTIFY_SIGNAL)
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
+#if defined(TIF_NOTIFY_SIGNAL)
+	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
+	    !wake_up_state(task, TASK_INTERRUPTIBLE))
+		kick_process(task);
+#endif
+}
+
 #endif	/* <linux/tracehook.h> */
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index 2b8366693d5c..54c07d386aeb 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -135,7 +135,15 @@ static __always_inline void exit_to_user_mode(void)
 }
 
 /* Workaround to allow gradual conversion of architecture code */
-void __weak arch_do_signal(struct pt_regs *regs) { }
+void __weak arch_do_signal_or_restart(struct pt_regs *regs, bool has_signal) { }
+
+static void handle_signal_work(struct pt_regs *regs, unsigned long ti_work)
+{
+	if (ti_work & _TIF_NOTIFY_SIGNAL)
+		tracehook_notify_signal();
+
+	arch_do_signal_or_restart(regs, ti_work & _TIF_SIGPENDING);
+}
 
 static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 					    unsigned long ti_work)
@@ -157,8 +165,8 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		if (ti_work & _TIF_PATCH_PENDING)
 			klp_update_patch_state(current);
 
-		if (ti_work & _TIF_SIGPENDING)
-			arch_do_signal(regs);
+		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
+			handle_signal_work(regs, ti_work);
 
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
diff --git a/kernel/signal.c b/kernel/signal.c
index 9f86246a8637..f67ea9a08ac0 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -2529,6 +2529,20 @@ bool get_signal(struct ksignal *ksig)
 	struct signal_struct *signal = current->signal;
 	int signr;
 
+	/*
+	 * For non-generic architectures, check for TIF_NOTIFY_SIGNAL so
+	 * that the arch handlers don't all have to do it. If we get here
+	 * without TIF_SIGPENDING, just exit after running signal work.
+	 */
+#ifdef TIF_NOTIFY_SIGNAL
+	if (!IS_ENABLED(CONFIG_GENERIC_ENTRY)) {
+		if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+			tracehook_notify_signal();
+		if (!task_sigpending(current))
+			return false;
+	}
+#endif
+
 	if (unlikely(uprobe_deny_signal()))
 		return false;
 
-- 
2.29.0

