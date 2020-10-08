Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79CE7287718
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 17:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731000AbgJHP2B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 11:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730998AbgJHP2B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 11:28:01 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDB6C0613D4
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 08:27:59 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id k6so6606806ior.2
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 08:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WdNU1/1s6MZ8klR4m0H2ADstj9Y1OQ9mPuj9tKk20pA=;
        b=pVezvOiIaURw+DUbX9JEP3YVGuWO2zROTmevBe0w+81wMug4KZiRH8oCa0c41Yusxm
         WBAdGoKQKTyNCWGKhtKBa0geWPAlAsop0ydosh4xytArI4Ko107Arx2d05C/R3P2Lb/c
         02RGSYZDGefIKlBRJ5yB5cczFuFlvTHwkaFLsuHug3NhHHGDcRrEZw9I/0EiPoIyYox8
         4UBJv3wDU0Eppa0LODVDaNRuwV7TT3tjzqjqvVI6a1kjcEQwyMlVl57YZVUhZWUgwSpn
         tRA+t8xcda9KhsDydwjR3UoAHfIGSMg8otwbG9syYyYG7MVP0Pfu/3BotOib2IAbBoFA
         iQ2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WdNU1/1s6MZ8klR4m0H2ADstj9Y1OQ9mPuj9tKk20pA=;
        b=R7lAQ0EujMHsxGbtVSL3UeyUlLk/3r1YTxT35W3aqXOKScEQyO7ELDBLnHgKRLaN5k
         G+nM0nA27RTo2NmmPqFvpZoJ06YJzeBbTnYZ4jw3XPFe1hE8vFnvxVkWZlD5XMdp3dpG
         SazfkRO7QaogE/qhgmsNJkzV1N00bJJUPm5CgnSGxd04HgtbRbV6Ckp0dv086+hEiTWa
         LIn9PcK+FXRBFswQnxdLbtBr8yutgeP2ZHWu+zdR9W8R15tna1HOOQdn08sF1A+ddv8k
         BFd/LOAJjZ8jfAvWmXgls3dR+dbYjcGe2Fl09PCOfPJY2aeJsEmiurNIiA6bYqnauyhX
         lAUQ==
X-Gm-Message-State: AOAM530JvaBfMLYOHcAzfOP6Asn02xxOl8xqxyk4PXNfGmfnDHFqwaYE
        Ok4J3gOAw1HzvKU3eZxxIW+oeg==
X-Google-Smtp-Source: ABdhPJwosQopgV7CRkgemTnQ8LvLzkDhZjRmYQ7BWyy2luDuCbcjIxbp5Lr+3hqUivzP7l5JBZoYpA==
X-Received: by 2002:a02:c785:: with SMTP id n5mr7430189jao.128.1602170878850;
        Thu, 08 Oct 2020 08:27:58 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l77sm2866260ill.4.2020.10.08.08.27.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:27:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] kernel: add support for TIF_NOTIFY_SIGNAL
Date:   Thu,  8 Oct 2020 09:27:51 -0600
Message-Id: <20201008152752.218889-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201008152752.218889-1-axboe@kernel.dk>
References: <20201008152752.218889-1-axboe@kernel.dk>
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

x86 is using the generic entry code, add the necessary TIF_NOTIFY_SIGNAL
definitions for it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 arch/x86/include/asm/thread_info.h |  2 ++
 arch/x86/kernel/signal.c           |  5 ++++-
 include/linux/entry-common.h       |  6 +++++-
 include/linux/entry-kvm.h          |  4 ++--
 include/linux/sched/signal.h       | 11 ++++++++++-
 include/linux/tracehook.h          | 27 +++++++++++++++++++++++++++
 kernel/entry/common.c              |  2 +-
 kernel/entry/kvm.c                 |  3 +++
 8 files changed, 54 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/thread_info.h b/arch/x86/include/asm/thread_info.h
index 267701ae3d86..86ade67f21b7 100644
--- a/arch/x86/include/asm/thread_info.h
+++ b/arch/x86/include/asm/thread_info.h
@@ -93,6 +93,7 @@ struct thread_info {
 #define TIF_NOTSC		16	/* TSC is not accessible in userland */
 #define TIF_IA32		17	/* IA32 compatibility process */
 #define TIF_SLD			18	/* Restore split lock detection on context switch */
+#define TIF_NOTIFY_SIGNAL	19	/* signal notifications exist */
 #define TIF_MEMDIE		20	/* is terminating due to OOM killer */
 #define TIF_POLLING_NRFLAG	21	/* idle is polling for TIF_NEED_RESCHED */
 #define TIF_IO_BITMAP		22	/* uses I/O bitmap */
@@ -123,6 +124,7 @@ struct thread_info {
 #define _TIF_NOTSC		(1 << TIF_NOTSC)
 #define _TIF_IA32		(1 << TIF_IA32)
 #define _TIF_SLD		(1 << TIF_SLD)
+#define _TIF_NOTIFY_SIGNAL	(1 << TIF_NOTIFY_SIGNAL)
 #define _TIF_POLLING_NRFLAG	(1 << TIF_POLLING_NRFLAG)
 #define _TIF_IO_BITMAP		(1 << TIF_IO_BITMAP)
 #define _TIF_FORCED_TF		(1 << TIF_FORCED_TF)
diff --git a/arch/x86/kernel/signal.c b/arch/x86/kernel/signal.c
index be0d7d4152ec..cd140bbf8520 100644
--- a/arch/x86/kernel/signal.c
+++ b/arch/x86/kernel/signal.c
@@ -808,7 +808,10 @@ void arch_do_signal(struct pt_regs *regs)
 {
 	struct ksignal ksig;
 
-	if (get_signal(&ksig)) {
+	if (test_thread_flag(TIF_NOTIFY_SIGNAL))
+		tracehook_notify_signal();
+
+	if (task_sigpending(current) && get_signal(&ksig)) {
 		/* Whee! Actually deliver the signal.  */
 		handle_signal(&ksig, regs);
 		return;
diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
index 159c7476b11b..f4234aaac36c 100644
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
index 404145dc536e..9bc13ade2ff9 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -360,6 +360,15 @@ static inline int task_sigpending(struct task_struct *p)
 
 static inline int signal_pending(struct task_struct *p)
 {
+#ifdef TIF_NOTIFY_SIGNAL
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
index b480e1a07ed8..bec952f51439 100644
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
+#ifdef TIF_NOTIFY_SIGNAL
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
+#ifdef TIF_NOTIFY_SIGNAL
+	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
+	    !wake_up_state(task, TASK_INTERRUPTIBLE))
+		kick_process(task);
+#endif
+}
+
 #endif	/* <linux/tracehook.h> */
diff --git a/kernel/entry/common.c b/kernel/entry/common.c
index d20ab4ac7183..89a068252897 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -157,7 +157,7 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		if (ti_work & _TIF_PATCH_PENDING)
 			klp_update_patch_state(current);
 
-		if (ti_work & _TIF_SIGPENDING)
+		if (ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL))
 			arch_do_signal(regs);
 
 		if (ti_work & _TIF_NOTIFY_RESUME) {
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

