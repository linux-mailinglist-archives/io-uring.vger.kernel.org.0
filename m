Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EB92807E4
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 21:42:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730152AbgJATmO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Oct 2020 15:42:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730093AbgJATmO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Oct 2020 15:42:14 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA824C0613D0
        for <io-uring@vger.kernel.org>; Thu,  1 Oct 2020 12:42:13 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id u19so8228269ion.3
        for <io-uring@vger.kernel.org>; Thu, 01 Oct 2020 12:42:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tK+bkvThP9B4n7miDafwlGXnRAvFhKo5iuDKDiOx2vk=;
        b=r2lXlae60ueizsPN77n56zr9N8TbguRH+EfIfa0UmbAcdj6zJBynliU2b0kddq73Kn
         ZVcQKC1LO9Ge/Fjd7YRo841cgJvobUTM7f7SGOmDsfjNfevbAQ8KAQWPGfgunKFAzH8H
         VwPsshIMwPw1b4XU/2uqjWnTAi9rAWQ20h8oP8+XCpVZMu4gbLJXRDdDuNW0PXyF/mRz
         OHn690KFCp8bIOLd0HPZ1DOaCaYVPm/iRUMzwHb0TeWgR4jlqXvq97dnKxTm145Yqay/
         rBPw4k8E+jgOQ226/xhedvdceu2/5JfqtQbDoPmNBHW9fK7uS0DkPnUEkoU00O0GRQgm
         bs5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tK+bkvThP9B4n7miDafwlGXnRAvFhKo5iuDKDiOx2vk=;
        b=Fa52/FvVJrqecsMuC33GubrPV8dXVwZaHPecHHgfPQOzswAIo4PeNz49DLxfo8TghB
         RwWeDMr5y0ZiUVwR38+OAypI58s7ls0hEJKTM6GcIZL/e+817RD1Is87F1HsrNqIIjBc
         6WNMNnhZQxF5E7EsSy9DvuMy550rlVkqkxl7CEdEvPC//ocCq0CSmJs6jSf76ss++COj
         0RmKgIbztKKXdy8mw7OJEx80v3A9j7SAV/bOoVuRrKC2XvicAfBXSVn0YrK1y9WojzEH
         DIRR/V4Mjm8I/OVshtatsaFy6YRQ7fV6N8syNZx05NF7Dph9uXsgoVsDSNdrag98xZz2
         TJvA==
X-Gm-Message-State: AOAM530ci+ogCGNT/VO6wYpq6aG9Q9jF3b+lvY5Qw8kZ8V4oY/qCixa7
        c0TaNUeYbMzia9a8hi1U/cK/Bw==
X-Google-Smtp-Source: ABdhPJwBTDmXKBF7s66rFeN9A8NrdeMlGKjV7RLhIPX35bB2jd+rU+jBtU+oKFTFheK01xNVX3iEiA==
X-Received: by 2002:a6b:15c7:: with SMTP id 190mr5855786iov.54.1601581333141;
        Thu, 01 Oct 2020 12:42:13 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t11sm739609ill.61.2020.10.01.12.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 12:42:12 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] kernel: add task_sigpending() helper
Date:   Thu,  1 Oct 2020 13:42:06 -0600
Message-Id: <20201001194208.1153522-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001194208.1153522-1-axboe@kernel.dk>
References: <20201001194208.1153522-1-axboe@kernel.dk>
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
index a38b3edc6851..ad52141ab0d2 100644
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
@@ -4443,7 +4443,7 @@ SYSCALL_DEFINE2(signal, int, sig, __sighandler_t, handler)
 
 SYSCALL_DEFINE0(pause)
 {
-	while (!signal_pending(current)) {
+	while (!task_sigpending(current)) {
 		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
 	}
@@ -4457,7 +4457,7 @@ static int sigsuspend(sigset_t *set)
 	current->saved_sigmask = current->blocked;
 	set_current_blocked(set);
 
-	while (!signal_pending(current)) {
+	while (!task_sigpending(current)) {
 		__set_current_state(TASK_INTERRUPTIBLE);
 		schedule();
 	}
-- 
2.28.0

