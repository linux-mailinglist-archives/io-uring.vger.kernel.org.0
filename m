Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FD122908C2
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 17:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410412AbgJPPpx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 11:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410386AbgJPPpx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 11:45:53 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07EEC061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 08:45:53 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id g16so1597321pjv.3
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 08:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0Yi4RdQAQ9dBaZZwuzCkTRlRDNjzOUHCMcuRAr32RQg=;
        b=H45/etki4hZeM2JIyzBC/PYY2ozk4AVJyokSoVRhZnpWa9yLbziqFsHXcA7UieOrYt
         2dkAFwVxXNtUr6PprN9vKyWLEcCugvWub+nCScnnKm7a8vC0lyYUdPB6RzufqlKckxSO
         rQzjIcmO0zIRsJCetRXkCGa9TkatnfwbTv+KMi0mvrFvoS4yZQkUJiYBwm0o6EjE5nL+
         /0OPYG3+pkYJX6tOdPaUsSaM2vx0R91Q3rt0M6p8uea0KjClpqYowGNvAzuENgQlquoB
         tL3wyxLntBrWQQnXZm0eouaz/tJb6P3oiwh4jbHFyHru1oQpHGizs/b/p+e105gvP3wh
         dvfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0Yi4RdQAQ9dBaZZwuzCkTRlRDNjzOUHCMcuRAr32RQg=;
        b=ElZfUy4F7++GDZmr/xw7ulX4Qj6gKRMfcvLQrRQ0E3mK4wFuLUd7L7umR0FwdZiLNa
         /GkjZ+lPoZrUzly7BU3FIGHBJXyezKvIg2tz5Jk8OfzXA0OKNL9X+0tc6BpqipLZ2Wkq
         D/guyxw05IsAW2kMmjH5hoY2BnE2F9CcZxMoCl6mB39L12KejsdyPD6X+lovr5oO3ubU
         FcM0+KnRGPwl374Fj+XErTw6w7dnPbXBbMQjdhramgEg0Qtb7OP1XxRrYumRO62+uk+j
         0rLz4BzLoTWhHaOd4amYjy/+F04JT/dkRXHqopb//czZ66+uKQMZzRIfvAmMBvdXSrMU
         TZbg==
X-Gm-Message-State: AOAM5317GBaFlH3JzZjAiP+F/3V83y8XzSRZn16a3cb3SNWgv0zGXLr3
        f245QJ7aeJc6DZyxDOVjYVKLDAdngEvI/V8k
X-Google-Smtp-Source: ABdhPJzObwnGqH10n5NLOaQTS3HvykhrIDo04qbSwdLgxphTGD4JShDH4QbSQGIbktklqBZCKlsWeA==
X-Received: by 2002:a17:902:bf41:b029:d5:c01a:4f4f with SMTP id u1-20020a170902bf41b02900d5c01a4f4fmr4677225pls.14.1602863153142;
        Fri, 16 Oct 2020 08:45:53 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s11sm3346194pjz.29.2020.10.16.08.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 08:45:52 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] kernel: add task_sigpending() helper
Date:   Fri, 16 Oct 2020 09:45:44 -0600
Message-Id: <20201016154547.1573096-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016154547.1573096-1-axboe@kernel.dk>
References: <20201016154547.1573096-1-axboe@kernel.dk>
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

Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/sched/signal.h | 9 +++++++--
 kernel/events/uprobes.c      | 2 +-
 kernel/signal.c              | 8 ++++----
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 1bad18a1d8ba..404145dc536e 100644
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
@@ -365,7 +370,7 @@ static inline int __fatal_signal_pending(struct task_struct *p)
 
 static inline int fatal_signal_pending(struct task_struct *p)
 {
-	return signal_pending(p) && __fatal_signal_pending(p);
+	return task_sigpending(p) && __fatal_signal_pending(p);
 }
 
 static inline int signal_pending_state(long state, struct task_struct *p)
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
diff --git a/kernel/signal.c b/kernel/signal.c
index a38b3edc6851..9f86246a8637 100644
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
-- 
2.28.0

