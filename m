Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50E4E287719
	for <lists+io-uring@lfdr.de>; Thu,  8 Oct 2020 17:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731005AbgJHP2B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Oct 2020 11:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730995AbgJHP2A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Oct 2020 11:28:00 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742B4C0613D2
        for <io-uring@vger.kernel.org>; Thu,  8 Oct 2020 08:27:58 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id o17so987374ioh.9
        for <io-uring@vger.kernel.org>; Thu, 08 Oct 2020 08:27:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IcUIU8NzkQ+HXDZ6+cKi7AHnLkUeUwvwPqZpRZWbdgs=;
        b=ljDaDVuF2ZhS6TsSyHoudrUln30UFKzFGDr7CoSRkenwrBwzylpaDEM3fNtJD1679X
         2fI6la+6h+N2iZZTnSareQt+CRusxg+cYbUY8z6X0yJIDPmjbOGkewKUPZTMtGfyryNZ
         RIhro9cK3fiOtHlksqdDuD0d7AUqwxzf+fGQFC/1rMO6rJLi3ktxpu4Fr2lVipf7aZrK
         HDq6DCtNdLhWoe6CVbhuxoU9cvIuffFuIt66zdyj0JnP7ii98LGs4I2mWC4TBxP3OIl1
         mOqhaKB911l5YVDP+IWbQTpbpBg2dsl8m97nVaaCCSwdH61YFO5jAzlWOdfCHRiMrnqD
         RPcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IcUIU8NzkQ+HXDZ6+cKi7AHnLkUeUwvwPqZpRZWbdgs=;
        b=EOw0pZsMY1Q+hHoEESWqsqWuj1Hn/6dkbIlwb6JJkqGjcj5aNho1i3UrHY3NhJXngl
         xOVDDVtkaUrsKmLUW+mdTsAC7NalPvm5hnm+GGfaFmT4W7Pr96Dtcu8JY8jsi46V05U+
         RR0KlVa2f1y6Lx70N5+oGy8VCFStY9J7F8xLKt8Y2jImVjnxFk4l+GaUwL+gnF83GHP3
         YwXfg9umIf8Sw0wP4k3dOl9Qoxi0xgoFZLc1KxQW+HYKMgWINi+sOrhP7Xt+R8MW6JQU
         Z6MnZV1wMJcUGuhtacjeu72rCQDegWAlQgQa70D40HrUGzE8L1QGE2G9NzneEbvouzvh
         bT/g==
X-Gm-Message-State: AOAM530G8gh0H0lho54JwzbXGO06oYHAUT+OntfZZKiT+/+oNtq/0dv5
        KLx7Go85PgE495KyKt4gxdJQt23Xl74Z+w==
X-Google-Smtp-Source: ABdhPJxZWnDRgwTpCUOutSBlhgVq6krcyqGYs+xofcGPQsouQ30SDQn0RBNPcqJt26GEMC2eCp8eFQ==
X-Received: by 2002:a02:6045:: with SMTP id d5mr5405151jaf.144.1602170877661;
        Thu, 08 Oct 2020 08:27:57 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id l77sm2866260ill.4.2020.10.08.08.27.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:27:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/4] kernel: add task_sigpending() helper
Date:   Thu,  8 Oct 2020 09:27:50 -0600
Message-Id: <20201008152752.218889-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201008152752.218889-1-axboe@kernel.dk>
References: <20201008152752.218889-1-axboe@kernel.dk>
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

