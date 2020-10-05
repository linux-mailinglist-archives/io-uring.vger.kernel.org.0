Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DABCC2838FC
	for <lists+io-uring@lfdr.de>; Mon,  5 Oct 2020 17:05:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgJEPFG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Oct 2020 11:05:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727040AbgJEPEt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Oct 2020 11:04:49 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC56C0613A8
        for <io-uring@vger.kernel.org>; Mon,  5 Oct 2020 08:04:48 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id d197so9486585iof.0
        for <io-uring@vger.kernel.org>; Mon, 05 Oct 2020 08:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ii95YAmxsR+HgUSEM40q9HyLP82YkIrTtWRY6tj6XKA=;
        b=nAIDX9/BdTq6VeJCKeMZcBw7nGz2yhGVdsicoPdXtbanu/guAngS7qgLAVBz6l6vkr
         sYmEwWx5JYOfO8GYgjyY0RcoYEXfAJpFcqd4mPPoy6710wWwD/xsFCgYJAYEeQH7gfM3
         CL0v+6I8sofRV4d065ioHpXqrXWMk8BTey8hOVQ7dLFl8kbNjyyZPa02VbqQiEfzdfoq
         pvVi36rPFRhXLlmVKulsj6woHUhGg/RVVfXxRgBeSgQla6OMdFvCZ4c1gFtS61WLt+Lf
         KIu8GsDyzg5JhxSMfDhs8rPhcmVYH559zodEUXitSlMWqooyZpZJ9U8XMI5Mj8BrrQbo
         Zukg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ii95YAmxsR+HgUSEM40q9HyLP82YkIrTtWRY6tj6XKA=;
        b=U1685tncXXQGlnbA8rwallFjBytaVJJwvN6KqkZiAFrKsmLClllc9Vh7qhbybHsCU5
         3BFgnxOR9ZDWuHn/HVDDiCUDD3Gsbc+YzDjzNegY8KUwknmXKsmPb9sNPq7QojL3ytat
         q/VlHBbIHl9DBtCq7LIc3wGhYA50b6BvLPveCatZxVGiYIzdfUAzfX2VBMr3fE/yWv0/
         up+N8KY7zE6LH6NnetpkTuBUSi350JKktizyIYaplysaIh3emCli1hUdFBGuqowvEMK4
         zwqXGCuOW+y+W5k2WBSJYPLGlR/03vBdeQXtyqj/T2hjB/RDShSv98LdbRtwFAssYKaM
         xU3w==
X-Gm-Message-State: AOAM531Olu18RfjYD6orUjbLnP5juGGNnyFbAFv3QzpF/9bwTGtRkFg6
        5PNYu8RiYgTuw+mDnx39rLzGaQ==
X-Google-Smtp-Source: ABdhPJy7/TJEUjF2NrxpmbDLU9aJ/Ak31e+0juJNyKzsYMCKQTUt5Vus6jdA0/UnyfWcwE7HiYIgqQ==
X-Received: by 2002:a5d:96c1:: with SMTP id r1mr182313iol.147.1601910287866;
        Mon, 05 Oct 2020 08:04:47 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 15sm33140ilz.66.2020.10.05.08.04.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 08:04:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] kernel: add support for TIF_NOTIFY_SIGNAL
Date:   Mon,  5 Oct 2020 09:04:36 -0600
Message-Id: <20201005150438.6628-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005150438.6628-1-axboe@kernel.dk>
References: <20201005150438.6628-1-axboe@kernel.dk>
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
 include/linux/entry-common.h |  6 +++++-
 include/linux/entry-kvm.h    |  4 ++--
 include/linux/sched/signal.h | 19 +++++++++++++++++--
 include/linux/tracehook.h    | 27 +++++++++++++++++++++++++++
 kernel/entry/common.c        |  5 ++++-
 kernel/entry/kvm.c           |  3 +++
 6 files changed, 58 insertions(+), 6 deletions(-)

diff --git a/include/linux/entry-common.h b/include/linux/entry-common.h
index ccfcc4769925..0929385b9d8d 100644
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
index e6f34d8fbf4d..3117ff205a14 100644
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
 
@@ -506,10 +515,16 @@ extern int set_user_sigmask(const sigset_t __user *umask, size_t sigsetsize);
 
 static inline void restore_saved_sigmask_unless(bool interrupted)
 {
-	if (interrupted)
+	if (interrupted) {
+#ifdef TIF_NOTIFY_SIGNAL
+		WARN_ON(!test_thread_flag(TIF_SIGPENDING) &&
+			!test_thread_flag(TIF_NOTIFY_SIGNAL));
+#else
 		WARN_ON(!test_thread_flag(TIF_SIGPENDING));
-	else
+#endif
+	} else {
 		restore_saved_sigmask();
+	}
 }
 
 static inline sigset_t *sigmask_to_save(void)
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
index 0c0cc3cf3eba..6cf9f4fa0f6e 100644
--- a/kernel/entry/common.c
+++ b/kernel/entry/common.c
@@ -140,7 +140,7 @@ bool __weak arch_do_signal(struct pt_regs *regs) { return true; }
 static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 					    unsigned long ti_work)
 {
-	bool restart_sys = ti_work & _TIF_SIGPENDING;
+	bool restart_sys = ti_work & (_TIF_SIGPENDING | _TIF_NOTIFY_SIGNAL);
 
 	/*
 	 * Before returning to user space ensure that all pending work
@@ -159,6 +159,9 @@ static unsigned long exit_to_user_mode_loop(struct pt_regs *regs,
 		if (ti_work & _TIF_PATCH_PENDING)
 			klp_update_patch_state(current);
 
+		if (ti_work & _TIF_NOTIFY_SIGNAL)
+			tracehook_notify_signal();
+
 		if ((ti_work & _TIF_SIGPENDING) && arch_do_signal(regs))
 			restart_sys = false;
 
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

