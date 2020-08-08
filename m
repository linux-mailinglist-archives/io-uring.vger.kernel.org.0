Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4A323F873
	for <lists+io-uring@lfdr.de>; Sat,  8 Aug 2020 20:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgHHSew (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 8 Aug 2020 14:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726232AbgHHSep (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 8 Aug 2020 14:34:45 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569DAC061756
        for <io-uring@vger.kernel.org>; Sat,  8 Aug 2020 11:34:45 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id 17so2877554pfw.9
        for <io-uring@vger.kernel.org>; Sat, 08 Aug 2020 11:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ypmlUkZSk15R2u3hy9BlmtfIaIX/aDcxNtGy0K2Hr0w=;
        b=Q4lTpZnGZYrJA7Zg85rM3UjQccHnkhWj/uLZoyquwjyI1NYXivrLBQYt9fTfDAjEs/
         XYBWcdzPkjawgr/LbgKAFRtWXtRkQrYryTrzVoHN6VM0Cj3RBDLB49DE2HCz9xZYSNaK
         /EBxrp186imJeMa+2HVgdNc/mV4oMEgsxgIEvVm5oQCm2+/LcJceBfwZnT8tLvzstt0S
         KM6cC0+KkSb8I9N6kHnBmbDLqg17ztyuMH8zecXNk2o8ddi/0nMRqBu191X4Sn7k7CEV
         UPPHR67kNamJGJUHPPUFwJS7AQYM8jfQkblkFTIaCtkzVYmCSwn4dVafjlf3DmYa/Aeh
         t0cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ypmlUkZSk15R2u3hy9BlmtfIaIX/aDcxNtGy0K2Hr0w=;
        b=rnbaJIgUK0KbDLC+DwfO4QswSzB6q5oxUzVZ02izxINN4meHIDEXthxeQIWTN7a/JS
         j7QPNt/iv7sBEoKCd9Zgw6xEZ7P/ibkSF2I/kifpcPVBNmD17k68PBk+pQVGk5U3+HGe
         6/OOn2PUiYWE7WoGZURH9VuCFXg7daHD2t/T/2PVMd/DmyxxLh+9XY2OOiHZ3QdpWZ8Q
         guFIsqfEd6qYSrX/fNiU8xCHnI/DbqgW6elEeDE8aDwDgC5j0UezlKEmbZsmgF5CvFlf
         BPEjl28FVltSMyrPWezQ3nl5LFzu2TVsQXRG6rrx9cu+pVy879f/H/feReSul83zec9l
         3bkg==
X-Gm-Message-State: AOAM5322gzDVQafUptLgEYwk5W4DiOn1mUGLFRROsat27S+7pE8sFbQf
        57zo+m72zIkTb6kwi5D8TCuxZw4Mb3Q=
X-Google-Smtp-Source: ABdhPJyNSbKsPJIPgJ/hXDjfenjjDjMxteaR6e+zNjZgVl5P+9KZVreH9aYyMEx9/d7w5yz2FDjAoQ==
X-Received: by 2002:a62:f904:: with SMTP id o4mr8804307pfh.14.1596911684360;
        Sat, 08 Aug 2020 11:34:44 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j142sm17955584pfd.100.2020.08.08.11.34.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2020 11:34:43 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     peterz@infradead.org, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] kernel: split task_work_add() into two separate helpers
Date:   Sat,  8 Aug 2020 12:34:38 -0600
Message-Id: <20200808183439.342243-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200808183439.342243-1-axboe@kernel.dk>
References: <20200808183439.342243-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some callers may need to make signaling decisions based on the state
of the targeted task, and that can only safely be done post adding
the task_work to the task. Split task_work_add() into:

__task_work_add()	- adds the work item
__task_work_notify()	- sends the notification

No functional changes in this patch.

Cc: Peter Zijlstra <peterz@infradead.org>
Cc: stable@vger.kernel.org # v5.7+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/task_work.h | 19 ++++++++++++++++
 kernel/task_work.c        | 48 +++++++++++++++++++++------------------
 2 files changed, 45 insertions(+), 22 deletions(-)

diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index 0fb93aafa478..7abbd8df5e13 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -5,6 +5,8 @@
 #include <linux/list.h>
 #include <linux/sched.h>
 
+extern struct callback_head work_exited;
+
 typedef void (*task_work_func_t)(struct callback_head *);
 
 static inline void
@@ -13,6 +15,21 @@ init_task_work(struct callback_head *twork, task_work_func_t func)
 	twork->func = func;
 }
 
+static inline int __task_work_add(struct task_struct *task,
+				  struct callback_head *work)
+{
+	struct callback_head *head;
+
+	do {
+		head = READ_ONCE(task->task_works);
+		if (unlikely(head == &work_exited))
+			return -ESRCH;
+		work->next = head;
+	} while (cmpxchg(&task->task_works, head, work) != head);
+
+	return 0;
+}
+
 #define TWA_RESUME	1
 #define TWA_SIGNAL	2
 int task_work_add(struct task_struct *task, struct callback_head *twork, int);
@@ -20,6 +37,8 @@ int task_work_add(struct task_struct *task, struct callback_head *twork, int);
 struct callback_head *task_work_cancel(struct task_struct *, task_work_func_t);
 void task_work_run(void);
 
+void __task_work_notify(struct task_struct *task, int notify);
+
 static inline void exit_task_work(struct task_struct *task)
 {
 	task_work_run();
diff --git a/kernel/task_work.c b/kernel/task_work.c
index 5c0848ca1287..9bde81481984 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -3,7 +3,27 @@
 #include <linux/task_work.h>
 #include <linux/tracehook.h>
 
-static struct callback_head work_exited; /* all we need is ->next == NULL */
+struct callback_head work_exited = {
+	.next = NULL	/* all we need is ->next == NULL */
+};
+
+void __task_work_notify(struct task_struct *task, int notify)
+{
+	unsigned long flags;
+
+	switch (notify) {
+	case TWA_RESUME:
+		set_notify_resume(task);
+		break;
+	case TWA_SIGNAL:
+		if (lock_task_sighand(task, &flags)) {
+			task->jobctl |= JOBCTL_TASK_WORK;
+			signal_wake_up(task, 0);
+			unlock_task_sighand(task, &flags);
+		}
+		break;
+	}
+}
 
 /**
  * task_work_add - ask the @task to execute @work->func()
@@ -27,29 +47,13 @@ static struct callback_head work_exited; /* all we need is ->next == NULL */
 int
 task_work_add(struct task_struct *task, struct callback_head *work, int notify)
 {
-	struct callback_head *head;
-	unsigned long flags;
+	int ret;
 
-	do {
-		head = READ_ONCE(task->task_works);
-		if (unlikely(head == &work_exited))
-			return -ESRCH;
-		work->next = head;
-	} while (cmpxchg(&task->task_works, head, work) != head);
-
-	switch (notify) {
-	case TWA_RESUME:
-		set_notify_resume(task);
-		break;
-	case TWA_SIGNAL:
-		if (lock_task_sighand(task, &flags)) {
-			task->jobctl |= JOBCTL_TASK_WORK;
-			signal_wake_up(task, 0);
-			unlock_task_sighand(task, &flags);
-		}
-		break;
-	}
+	ret = __task_work_add(task, work);
+	if (unlikely(ret))
+		return ret;
 
+	__task_work_notify(task, notify);
 	return 0;
 }
 
-- 
2.28.0

