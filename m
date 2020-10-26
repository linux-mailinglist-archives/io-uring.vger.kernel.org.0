Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B47F299804
	for <lists+io-uring@lfdr.de>; Mon, 26 Oct 2020 21:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732428AbgJZUdH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Oct 2020 16:33:07 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:42032 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731968AbgJZUcg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Oct 2020 16:32:36 -0400
Received: by mail-il1-f195.google.com with SMTP id c11so6858612iln.9
        for <io-uring@vger.kernel.org>; Mon, 26 Oct 2020 13:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ST09bAbLnEfHnubeqHuDY7K93apYHiTyug5wUNPRE6k=;
        b=DE01M4tfPExCH+UH5N2zhJqLyQhT9tHYycm4CXsT6S48fu4SPiUvlTW0dXWJzYLit+
         p54k+uboQpGAxguVfolz+plKKtmiF1xxPNG3vr6AQamxIMeiJmZMbmvLfdU74wB5Et54
         bp9hsIgWeGoQi+HRyBNVQjC+Krdb5vh/yFbDoWjMhFByhMsGKTrWhSFOyeUQnkU+pB78
         potva0KRwWj/H6Fde9j9L/OlzgwRCdHSLie/srrt2ewhhZWvKQjzeaISclqJ9cGfahBA
         /nBj8C8COMQxfu68OHIOggiab0uPqcJ9bjAC1Z7x/AZNB5wpXxBq/k/NrzTqAqQp3DK1
         REag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ST09bAbLnEfHnubeqHuDY7K93apYHiTyug5wUNPRE6k=;
        b=pMkWpso0jCneREK/KmyakPz08X8zrPZKzWVBoPNDuInFPUx5/b8Yaju3D+iVrc3TZI
         RjYXWAN7rV9YtpRyQEDw+DLLciQfJqPSQ0Z6lPWa/E2WroE/tm2GQ534Moh9zqdWbwZy
         6JQGI2mW6SITw4YjaZaKGptPuNPgKLrTx8swLaGCqmI/s3by38TlXvrC3+bfcHK7g73K
         QQJzwb3wDOGSu/7fCvqA8fs8Kui3krSKIm/Dm7kZpmp2F1cActEBH1m+IirTOgMlb88v
         1PiZnxu3HcenMIEClVyPdhYdAIJtwLNx07MEMC7TOri8BdbAH83YKrdBF7ORuBvGZtur
         VmoQ==
X-Gm-Message-State: AOAM530ZwshtcI9eF2g4o8QZYkFk2GvB8ZeN8QyG+AIAYI9cMuG8GJBp
        7SjGwMJfeRUTcqtbKF7wco/jiXSvrwBKVw==
X-Google-Smtp-Source: ABdhPJx1R8b9M9Xwa/F9uknaYsgz06NTTXXCFRfxKgIBi4/HETuzC3AMKrpwx7iAeJg3zdnTYnvCsQ==
X-Received: by 2002:a92:99ce:: with SMTP id t75mr12624304ilk.257.1603744354808;
        Mon, 26 Oct 2020 13:32:34 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e12sm6770373ilq.65.2020.10.26.13.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 13:32:34 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] kernel: add task_sigpending() helper
Date:   Mon, 26 Oct 2020 14:32:27 -0600
Message-Id: <20201026203230.386348-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201026203230.386348-1-axboe@kernel.dk>
References: <20201026203230.386348-1-axboe@kernel.dk>
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
index 00b0358739ab..bf9edd8d75be 100644
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
2.29.0

