Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CD1F2838F4
	for <lists+io-uring@lfdr.de>; Mon,  5 Oct 2020 17:05:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgJEPEv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Oct 2020 11:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726604AbgJEPEr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Oct 2020 11:04:47 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5AB0C0613A7
        for <io-uring@vger.kernel.org>; Mon,  5 Oct 2020 08:04:46 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id t7so2871855ilf.10
        for <io-uring@vger.kernel.org>; Mon, 05 Oct 2020 08:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OKHEwyhXDdp8uX1hEir8o6uX9DNPT+xN2S2hGhhzuBw=;
        b=tIMTDmTzfwS7O3XCnluqjFDBpyKHZIDbOfqT737mh9wXmgemyUhXuOBlIgSfN18mgK
         g617dRgIWiiGX987GCRpK/JAARRv34ZXwbuXjbYB3Ft7Q0FxbwrDGayyPjR5NipCAqL2
         wAnnqGmhWtuGY1ftqQ6KspYK2c1s2r5CEHOg4nyTKCeauz7W1j27Waj3iYHMz0m1gXUn
         B7X3C7E7NDp6WKzdUW2kmABEcIXw4On42PXnv+fGB24DZ9F1VudIWAaFZpMadtbWoNom
         o8g0Vau2GMUN+knSnaK6nHOunBjQsQ8Z3cm4hgIAUWKS9lzbJdYd1WS3tXIG3Kpfi6kw
         uxtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OKHEwyhXDdp8uX1hEir8o6uX9DNPT+xN2S2hGhhzuBw=;
        b=mAfrPUghl2AbA8EZxuXJ2JDCxkQsFeKLY38zMtv7CzJLr+NhvN1/AdG7FcCIvGALef
         +rHmb+uAO4ydBpMwHLvJ0NKP/P8teMH0Oms5g+CwS32OXfp6vR1Igs1ECY+Jc3kjVXhB
         6TLJojOMuvJga2rI250g6cYVxoVFdiawfdV5KT/y+LQOqcbrdrYxM9mLo66nXhzoGtF6
         jypyGPC0+AByNZgA3ii2Ip055NXasitp9sYabtf/4AP8nHxRdKdGNyZSPxnLxpWGfgNQ
         Kv7l8fT6kyr2kDTpZdDIUpe5jTqpOf9l/oLltPbRB+xCPYK1g792iSZbvwotMTH8piV6
         CRmA==
X-Gm-Message-State: AOAM530tDAPZBbvqxv0beX9kMPqcZU5VzQczIuzkl7WWfcwHHVvyHWQW
        Z8czDJFARfYDJTS/blQsSsfA8kzMpWVp0w==
X-Google-Smtp-Source: ABdhPJwisHkH1ck+5kUQXkK8CqvLUdy6QGv8Fx/w34hqXi3pbdf1CcmnggEElptLJisMkm24giCHjA==
X-Received: by 2002:a92:9859:: with SMTP id l86mr12800760ili.167.1601910285907;
        Mon, 05 Oct 2020 08:04:45 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 15sm33140ilz.66.2020.10.05.08.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 08:04:45 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/6] kernel: add task_sigpending() helper
Date:   Mon,  5 Oct 2020 09:04:34 -0600
Message-Id: <20201005150438.6628-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005150438.6628-1-axboe@kernel.dk>
References: <20201005150438.6628-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is in preparation for maintaining signal_pending() as the decider
of whether or not a schedule() loop should be broken, or continue
sleeping. This is different than the core signal use cases, where we
really want to know if an actual signal is pending or not.
task_sigpending() returns non-zero if TIF_SIGPENDING is set.

Only core kernel use cases should care about the distinction between
the two, make sure those use the task_sigpending() helper.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/sched/signal.h | 13 +++++++++----
 kernel/events/uprobes.c      |  2 +-
 kernel/ptrace.c              |  2 +-
 kernel/signal.c              | 12 ++++++------
 4 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 1bad18a1d8ba..e6f34d8fbf4d 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -353,11 +353,16 @@ static inline int restart_syscall(void)
 	return -ERESTARTNOINTR;
 }
 
-static inline int signal_pending(struct task_struct *p)
+static inline int task_sigpending(struct task_struct *p)
 {
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }
 
+static inline int signal_pending(struct task_struct *p)
+{
+	return task_sigpending(p);
+}
+
 static inline int __fatal_signal_pending(struct task_struct *p)
 {
 	return unlikely(sigismember(&p->pending.signal, SIGKILL));
@@ -365,14 +370,14 @@ static inline int __fatal_signal_pending(struct task_struct *p)
 
 static inline int fatal_signal_pending(struct task_struct *p)
 {
-	return signal_pending(p) && __fatal_signal_pending(p);
+	return task_sigpending(p) && __fatal_signal_pending(p);
 }
 
 static inline int signal_pending_state(long state, struct task_struct *p)
 {
 	if (!(state & (TASK_INTERRUPTIBLE | TASK_WAKEKILL)))
 		return 0;
-	if (!signal_pending(p))
+	if (!task_sigpending(p))
 		return 0;
 
 	return (state & TASK_INTERRUPTIBLE) || __fatal_signal_pending(p);
@@ -389,7 +394,7 @@ static inline bool fault_signal_pending(vm_fault_t fault_flags,
 {
 	return unlikely((fault_flags & VM_FAULT_RETRY) &&
 			(fatal_signal_pending(current) ||
-			 (user_mode(regs) && signal_pending(current))));
+			 (user_mode(regs) && task_sigpending(current))));
 }
 
 /*
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 0e18aaf23a7b..8bb26a338e06 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1973,7 +1973,7 @@ bool uprobe_deny_signal(void)
 
 	WARN_ON_ONCE(utask->state != UTASK_SSTEP);
 
-	if (signal_pending(t)) {
+	if (task_sigpending(t)) {
 		spin_lock_irq(&t->sighand->siglock);
 		clear_tsk_thread_flag(t, TIF_SIGPENDING);
 		spin_unlock_irq(&t->sighand->siglock);
diff --git a/kernel/ptrace.c b/kernel/ptrace.c
index 43d6179508d6..583b8da4c207 100644
--- a/kernel/ptrace.c
+++ b/kernel/ptrace.c
@@ -773,7 +773,7 @@ static int ptrace_peek_siginfo(struct task_struct *child,
 		data += sizeof(siginfo_t);
 		i++;
 
-		if (signal_pending(current))
+		if (task_sigpending(current))
 			break;
 
 		cond_resched();
diff --git a/kernel/signal.c b/kernel/signal.c
index a38b3edc6851..d57aafd9116c 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -983,7 +983,7 @@ static inline bool wants_signal(int sig, struct task_struct *p)
 	if (task_is_stopped_or_traced(p))
 		return false;
 
-	return task_curr(p) || !signal_pending(p);
+	return task_curr(p) || !task_sigpending(p);
 }
 
 static void complete_signal(int sig, struct task_struct *p, enum pid_type type)
@@ -2822,7 +2822,7 @@ static void retarget_shared_pending(struct task_struct *tsk, sigset_t *which)
 		/* Remove the signals this thread can handle. */
 		sigandsets(&retarget, &retarget, &t->blocked);
 
-		if (!signal_pending(t))
+		if (!task_sigpending(t))
 			signal_wake_up(t, 0);
 
 		if (sigisemptyset(&retarget))
@@ -2856,7 +2856,7 @@ void exit_signals(struct task_struct *tsk)
 
 	cgroup_threadgroup_change_end(tsk);
 
-	if (!signal_pending(tsk))
+	if (!task_sigpending(tsk))
 		goto out;
 
 	unblocked = tsk->blocked;
@@ -2900,7 +2900,7 @@ long do_no_restart_syscall(struct restart_block *param)
 
 static void __set_task_blocked(struct task_struct *tsk, const sigset_t *newset)
 {
-	if (signal_pending(tsk) && !thread_group_empty(tsk)) {
+	if (task_sigpending(tsk) && !thread_group_empty(tsk)) {
 		sigset_t newblocked;
 		/* A set of now blocked but previously unblocked signals. */
 		sigandnsets(&newblocked, newset, &current->blocked);
@@ -4447,7 +4447,7 @@ SYSCALL_DEFINE0(pause)
 		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
 	}
-	return -ERESTARTNOHAND;
+	return task_sigpending(current) ? -ERESTARTNOHAND : -ERESTARTSYS;
 }
 
 #endif
@@ -4462,7 +4462,7 @@ static int sigsuspend(sigset_t *set)
 		schedule();
 	}
 	set_restore_sigmask();
-	return -ERESTARTNOHAND;
+	return task_sigpending(current) ? -ERESTARTNOHAND : -ERESTARTSYS;
 }
 
 /**
-- 
2.28.0

