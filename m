Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD7528F308
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 15:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728749AbgJONRK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 09:17:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728418AbgJONRJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 09:17:09 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71795C0613D3
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 06:17:08 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id n6so4221876ioc.12
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 06:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WTmL06FHUzHZIgnmMADoS0LxIHWnkbferYQGPtLLnsY=;
        b=erVfJZjhLpwNHHuy5iHq0c2bcRxlxLVYZF2nSeDiKSPyvFzl24CAkMVQVJFRqTTJAP
         GBONmEaHM7r2I+krRKvZhdMjJxUlxnvjJlXwBiOMPX5NmyjOC4VkQ6mKEJQ2BKMGwVn5
         49tqVqoYiVJNZI2mcOPMeGn7YEkyw2dFaMESfyWD1sslHEJA7yeuXu+/dys4lDeQXu7S
         1blrpm/2JdVn1rJPpore7e6hE5hCvglnycUc6JgcislETEwUxiwSTepY39dMpWPh3uM4
         EU5zTN6+yQJtFcOehM1qFRz1u6Ysm9hDIRgCnFY4cFTauoSt9m63enm94jp0eM6iFlE9
         Yslg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WTmL06FHUzHZIgnmMADoS0LxIHWnkbferYQGPtLLnsY=;
        b=oj73NX9zcz/wTxi3FIz5eEfwX6/rJ3WRIeRUMZY/HWppJdfepZfT/BEtOUuE5gK9yF
         SlFbH1wF82xrV7mKFYEwO3lNCVtyCKC3s5x1PbKq0uBEWxO6eipSUfozehix9SI1EeMO
         srCQcdnt11Ay4sJUNMoZ7BZp9/LfCUXYu5PXHfgDqnFNwCmFyoNK0PEYnyqS7k/pq4H1
         lv5lxuWpOGDhGJiUV/AkjpUzDfcpQyEXO+3ugtWwWKzGCZJzpEYYtMAKLOkeNpO/3CVL
         7THZK9c5vKPmPwh2yzjHLZAH1EMx7jYfWp7jZK17KkNIfjsCHm3iVtmAXVPfyauxC9yD
         YHQQ==
X-Gm-Message-State: AOAM531OXb4vNf/+k3hpXy3+eGV1elVyXTS4FxtmrAANJ90GZLTkHHw7
        kb7AtEEXpG8uj614X1Sw50P5Xw==
X-Google-Smtp-Source: ABdhPJzyqwW7mEFYrrQQSmm2ty2mufyAvVie3S+NtCk1GHIvHgAupIuI5yLGgXb5Jxo706k2rdc7kQ==
X-Received: by 2002:a02:3b57:: with SMTP id i23mr3619877jaf.110.1602767827191;
        Thu, 15 Oct 2020 06:17:07 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m13sm2486736ioo.9.2020.10.15.06.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 06:17:06 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] kernel: add task_sigpending() helper
Date:   Thu, 15 Oct 2020 07:16:58 -0600
Message-Id: <20201015131701.511523-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015131701.511523-1-axboe@kernel.dk>
References: <20201015131701.511523-1-axboe@kernel.dk>
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

