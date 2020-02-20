Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1CB316685E
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 21:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728993AbgBTUcD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 15:32:03 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33622 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgBTUcD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 15:32:03 -0500
Received: by mail-pj1-f67.google.com with SMTP id m7so1465921pjs.0
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 12:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TGpTX9FqGABffgoPHPbs15/ozOFDNVksfOd/8LEWnKw=;
        b=0RtXfv/a08KEBZzEOFbAINZlaSGqGO4lB/qdu3sFMHPsm5NMMPYOPMIWNF7cDWl56s
         1CDOl0wZ56TNo7u3vvxO1LhQfyEib32AA25ic/Zxjbyk8FLUtWArpeNMMwvV7c3oY+zF
         V2u8zb+ogWXbUOUFUebrDC4ewhWL5D2iWaMpmc2OGK6B2pqVCg1Y+fzaGv3hPMxXiD40
         L7tlnXtukcREe+PXwQg+vvmhbcDChJ1FBqqHjEHjdtSjApJ/dHZ6HyY08tOgDV0TBXLw
         Ss8GZCijO8uAjjcD46thjON+rOrrbFOBqdiAwzuXewibD21brJG/hWIEAiQIIvPLO8cy
         9iNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TGpTX9FqGABffgoPHPbs15/ozOFDNVksfOd/8LEWnKw=;
        b=D0kO27ArywpJu7X6x/8fqwaRwfC5bNt1tFMkU+1pLvEZ8pSDZzFTFw+I++/ZZq/L3U
         dyVyxHjTiNuVJB4G+DbcT1orvb1RXi7aEpi6P8uXiK5CUE7GoJMWSU4RQ5soiIYVT210
         pQxyVKANIJp/mDwwZxKcsC1uwF33eMll6YFXrEb/42G8eWb6rXhSEKuiReZ/CurPDBwa
         X7hB9fCDzy43o6oW9hnSFn9JEtRaXrV+wyrQd9ucw6d25x0M85bH17wqz7/jmrbe1UXr
         0+ZSXzvEJATgrFnELx4LVaFWvyjpdFDlxTUTWGcYmTptXTOQcsIPWDfm+jhK03pn4er0
         IBWg==
X-Gm-Message-State: APjAAAVhiLGw1xNgynsqxsc3Haf8V0PlvSZHJD3rl8APkLFVXjpMO0ux
        bCmaHoMqeDnRfDDAz9WMe09F4pe20Q8=
X-Google-Smtp-Source: APXvYqyKewroqU6mAeIgWnrB9gdAjvBgGifGOtK4ifYYLbmUSYlzupeOQmItIeGAVjx3xJdSvBSO4w==
X-Received: by 2002:a17:902:567:: with SMTP id 94mr32169360plf.174.1582230722168;
        Thu, 20 Feb 2020 12:32:02 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id z10sm169672pgj.73.2020.02.20.12.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 12:32:01 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/9] sched: add a sched_work list
Date:   Thu, 20 Feb 2020 13:31:48 -0700
Message-Id: <20200220203151.18709-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200220203151.18709-1-axboe@kernel.dk>
References: <20200220203151.18709-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is similar to the task_works, and uses the same infrastructure, but
the sched_work list is run when the task is being scheduled in or out.

The intended use case here is for core code to be able to add work
that should be automatically run by the task, without the task needing
to do anything. This is done outside of the task, one example would be
from waitqueue handlers, or anything else that is invoked out-of-band
from the task itself.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/sched.h     |  4 ++-
 include/linux/task_work.h |  5 ++++
 kernel/sched/core.c       | 16 ++++++++--
 kernel/task_work.c        | 62 ++++++++++++++++++++++++++++++++++++---
 4 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 04278493bf15..da15112c1140 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -648,6 +648,7 @@ struct task_struct {
 	/* Per task flags (PF_*), defined further below: */
 	unsigned int			flags;
 	unsigned int			ptrace;
+	int				on_rq;
 
 #ifdef CONFIG_SMP
 	struct llist_node		wake_entry;
@@ -670,13 +671,14 @@ struct task_struct {
 	int				recent_used_cpu;
 	int				wake_cpu;
 #endif
-	int				on_rq;
 
 	int				prio;
 	int				static_prio;
 	int				normal_prio;
 	unsigned int			rt_priority;
 
+	struct callback_head		*sched_work;
+
 	const struct sched_class	*sched_class;
 	struct sched_entity		se;
 	struct sched_rt_entity		rt;
diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index bd9a6a91c097..e0c56f461df6 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -17,9 +17,14 @@ int task_work_add(struct task_struct *task, struct callback_head *twork, bool);
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
 void task_work_run(void);
 
+int sched_work_add(struct task_struct *task, struct callback_head *work);
+struct callback_head *sched_work_cancel(struct task_struct *, task_work_func_t);
+void sched_work_run(void);
+
 static inline void exit_task_work(struct task_struct *task)
 {
 	task_work_run();
+	sched_work_run();
 }
 
 #endif	/* _LINUX_TASK_WORK_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c7bab13f9caa..9e0f754e0630 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2678,6 +2678,7 @@ int wake_up_state(struct task_struct *p, unsigned int state)
 static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 {
 	p->on_rq			= 0;
+	p->sched_work			= NULL;
 
 	p->se.on_rq			= 0;
 	p->se.exec_start		= 0;
@@ -4102,8 +4103,13 @@ void __noreturn do_task_dead(void)
 		cpu_relax();
 }
 
-static void sched_out_update(struct task_struct *tsk)
+static bool sched_out_update(struct task_struct *tsk)
 {
+	if (unlikely(tsk->sched_work)) {
+		sched_work_run();
+		return true;
+	}
+
 	/*
 	 * If a worker went to sleep, notify and ask workqueue whether
 	 * it wants to wake up a task to maintain concurrency.
@@ -4119,6 +4125,8 @@ static void sched_out_update(struct task_struct *tsk)
 			io_wq_worker_sleeping(tsk);
 		preempt_enable_no_resched();
 	}
+
+	return false;
 }
 
 static void sched_in_update(struct task_struct *tsk)
@@ -4129,6 +4137,8 @@ static void sched_in_update(struct task_struct *tsk)
 		else
 			io_wq_worker_running(tsk);
 	}
+	if (unlikely(tsk->sched_work))
+		sched_work_run();
 }
 
 static inline void sched_submit_work(struct task_struct *tsk)
@@ -4136,7 +4146,9 @@ static inline void sched_submit_work(struct task_struct *tsk)
 	if (!tsk->state)
 		return;
 
-	sched_out_update(tsk);
+	/* if we processed work, we could be runnable again. check. */
+	if (sched_out_update(tsk) && !tsk->state)
+		return;
 
 	if (tsk_is_pi_blocked(tsk))
 		return;
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 3445421266e7..ba62485d5b3d 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -3,7 +3,14 @@
 #include <linux/task_work.h>
 #include <linux/tracehook.h>
 
-static struct callback_head work_exited; /* all we need is ->next == NULL */
+static void task_exit_func(struct callback_head *head)
+{
+}
+
+static struct callback_head work_exited = {
+	.next	= NULL,
+	.func	= task_exit_func,
+};
 
 static int __task_work_add(struct task_struct *task,
 			   struct callback_head **headptr,
@@ -53,6 +60,28 @@ task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 	return ret;
 }
 
+/**
+ * sched_work_add - ask the @task to execute @work->func()
+ * @task: the task which should run the callback
+ * @work: the callback to run
+ * @notify: send the notification if true
+ *
+ * Queue @work for sched_work_run() below.
+ * Fails if the @task is exiting/exited and thus it can't process this @work.
+ * Otherwise @work->func() will be called when the @task is either scheduled
+ * in or out.
+ *
+ * Note: there is no ordering guarantee on works queued here.
+ *
+ * RETURNS:
+ * 0 if succeeds or -ESRCH.
+ */
+int
+sched_work_add(struct task_struct *task, struct callback_head *work)
+{
+	return __task_work_add(task, &task->sched_work, work);
+}
+
 static struct callback_head *__task_work_cancel(struct task_struct *task,
 						struct callback_head **headptr,
 						task_work_func_t func)
@@ -98,10 +127,27 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
 	return __task_work_cancel(task, &task->task_works, func);
 }
 
-static void __task_work_run(struct task_struct *task,
-			    struct callback_head **headptr)
+/**
+ * sched_work_cancel - cancel a pending work added by sched_work_add()
+ * @task: the task which should execute the work
+ * @func: identifies the work to remove
+ *
+ * Find the last queued pending work with ->func == @func and remove
+ * it from queue.
+ *
+ * RETURNS:
+ * The found work or NULL if not found.
+ */
+struct callback_head *
+sched_work_cancel(struct task_struct *task, task_work_func_t func)
+{
+	return __task_work_cancel(task, &task->sched_work, func);
+}
+
+static void __task_work_run(struct callback_head **headptr)
 {
 	struct callback_head *work, *head, *next;
+	struct task_struct *task = current;
 
 	for (;;) {
 		/*
@@ -148,5 +194,13 @@ static void __task_work_run(struct task_struct *task,
  */
 void task_work_run(void)
 {
-	__task_work_run(current, &current->task_works);
+	__task_work_run(&current->task_works);
+}
+
+/**
+ * sched_work_run - execute the works added by sched_work_add()
+ */
+void sched_work_run()
+{
+	__task_work_run(&current->sched_work);
 }
-- 
2.25.1

