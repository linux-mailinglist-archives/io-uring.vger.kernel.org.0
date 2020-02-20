Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B7616685D
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 21:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728990AbgBTUcC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 15:32:02 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:46747 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgBTUcC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 15:32:02 -0500
Received: by mail-pg1-f195.google.com with SMTP id y30so2479881pga.13
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 12:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HC5dXWOhSIMKy3j5FSGVnlKuUpzM0tKelk8u/6Ep3xc=;
        b=arsVQwTiDJN/FcKbTd/UNR19Xci51xWoW8x/ngIO8sIzxLQw+cXNyLkKtFiIpvcOYn
         l2sdPifgsumhwreXBrFTRD1u6cfYuV7uZNPyo2J4KneyVOUhIx04Qyim00jP959FoHgl
         gXBn6vDpD3lqx+vgiYCvVWvMx3TwLTPnUMl/rJg6dkJ7+PSND27ioQktv+VznCBKkrAf
         vXeOSo70go7rbs5kSwKm+oXCyDcpbdKlo56B2J84lQgw4n7XN40I5IomCZ4qCk4abmmI
         YJpPI9siAfm/z7i2naUeQMA7TuSYNSHTKSCYEXi0dH8ydCMKVfk+nguan0O0Swm896TM
         +Lmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HC5dXWOhSIMKy3j5FSGVnlKuUpzM0tKelk8u/6Ep3xc=;
        b=FWPvdWN87soHkcwW7hwuCGHPbvw/ntIB8Ju+j6JNq2RXQ29t3vSFKbTHoEYJ40f/NB
         KRGCGtYx+WH/ie9gDxD64Ze5VNezczpAc5eaON7M6XGuo/XcHm8huEHGuUC0haRCjCQs
         bwQaVdacXivfcxNmfvxSmg9RO4GHRutez3bc9B3e9UlbKyZymYZ12rl7vRTJidvZ5CAg
         QM+CbYPkpk2SVZ/Jc1R8+CproeVuw6bt/yg5gU0Fb+m40GZJctIYid5z3i+09C6aTefD
         SFCl2I2dR8B8KKwOVgkAgTGiPSasGrHsPGh3jwHLsxjtq6Z09VTMHYvHlAcIk8zJziKW
         XCMg==
X-Gm-Message-State: APjAAAWHiMQtKTfcJSZ3ChFux45uwYQce+gbXR6FdHvr/Xi7Cc6NOS9X
        ysOWv6rWiiJoRaNZQKEI1vQVqEa7BnI=
X-Google-Smtp-Source: APXvYqwBP8T6HD1Dt4B+2MKengbAm691PiW+Rh6E9PuJla016v/H6S9HWyif25vQS+6mzKXq8vPNkg==
X-Received: by 2002:a62:1a09:: with SMTP id a9mr33785950pfa.64.1582230720948;
        Thu, 20 Feb 2020 12:32:00 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id z10sm169672pgj.73.2020.02.20.12.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 12:32:00 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/9] kernel: abstract out task work helpers
Date:   Thu, 20 Feb 2020 13:31:47 -0700
Message-Id: <20200220203151.18709-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200220203151.18709-1-axboe@kernel.dk>
References: <20200220203151.18709-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is in preparation for adding a ditto sched_work list.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/task_work.c | 88 +++++++++++++++++++++++++++++-----------------
 1 file changed, 56 insertions(+), 32 deletions(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 825f28259a19..3445421266e7 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -5,6 +5,22 @@
 
 static struct callback_head work_exited; /* all we need is ->next == NULL */
 
+static int __task_work_add(struct task_struct *task,
+			   struct callback_head **headptr,
+			   struct callback_head *work)
+{
+	struct callback_head *head;
+
+	do {
+		head = READ_ONCE(*headptr);
+		if (unlikely(head == &work_exited))
+			return -ESRCH;
+		work->next = head;
+	} while (cmpxchg(headptr, head, work) != head);
+
+	return 0;
+}
+
 /**
  * task_work_add - ask the @task to execute @work->func()
  * @task: the task which should run the callback
@@ -27,39 +43,25 @@ static struct callback_head work_exited; /* all we need is ->next == NULL */
 int
 task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 {
-	struct callback_head *head;
+	int ret;
 
-	do {
-		head = READ_ONCE(task->task_works);
-		if (unlikely(head == &work_exited))
-			return -ESRCH;
-		work->next = head;
-	} while (cmpxchg(&task->task_works, head, work) != head);
+	ret = __task_work_add(task, &task->task_works, work);
 
 	if (notify)
 		set_notify_resume(task);
-	return 0;
+
+	return ret;
 }
 
-/**
- * task_work_cancel - cancel a pending work added by task_work_add()
- * @task: the task which should execute the work
- * @func: identifies the work to remove
- *
- * Find the last queued pending work with ->func == @func and remove
- * it from queue.
- *
- * RETURNS:
- * The found work or NULL if not found.
- */
-struct callback_head *
-task_work_cancel(struct task_struct *task, task_work_func_t func)
+static struct callback_head *__task_work_cancel(struct task_struct *task,
+						struct callback_head **headptr,
+						task_work_func_t func)
 {
-	struct callback_head **pprev = &task->task_works;
+	struct callback_head **pprev = headptr;
 	struct callback_head *work;
 	unsigned long flags;
 
-	if (likely(!task->task_works))
+	if (likely(!(*headptr)))
 		return NULL;
 	/*
 	 * If cmpxchg() fails we continue without updating pprev.
@@ -80,16 +82,25 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
 }
 
 /**
- * task_work_run - execute the works added by task_work_add()
+ * task_work_cancel - cancel a pending work added by task_work_add()
+ * @task: the task which should execute the work
+ * @func: identifies the work to remove
  *
- * Flush the pending works. Should be used by the core kernel code.
- * Called before the task returns to the user-mode or stops, or when
- * it exits. In the latter case task_work_add() can no longer add the
- * new work after task_work_run() returns.
+ * Find the last queued pending work with ->func == @func and remove
+ * it from queue.
+ *
+ * RETURNS:
+ * The found work or NULL if not found.
  */
-void task_work_run(void)
+struct callback_head *
+task_work_cancel(struct task_struct *task, task_work_func_t func)
+{
+	return __task_work_cancel(task, &task->task_works, func);
+}
+
+static void __task_work_run(struct task_struct *task,
+			    struct callback_head **headptr)
 {
-	struct task_struct *task = current;
 	struct callback_head *work, *head, *next;
 
 	for (;;) {
@@ -99,14 +110,14 @@ void task_work_run(void)
 		 */
 		do {
 			head = NULL;
-			work = READ_ONCE(task->task_works);
+			work = READ_ONCE(*headptr);
 			if (!work) {
 				if (task->flags & PF_EXITING)
 					head = &work_exited;
 				else
 					break;
 			}
-		} while (cmpxchg(&task->task_works, work, head) != work);
+		} while (cmpxchg(headptr, work, head) != work);
 
 		if (!work)
 			break;
@@ -126,3 +137,16 @@ void task_work_run(void)
 		} while (work);
 	}
 }
+
+/**
+ * task_work_run - execute the works added by task_work_add()
+ *
+ * Flush the pending works. Should be used by the core kernel code.
+ * Called before the task returns to the user-mode or stops, or when
+ * it exits. In the latter case task_work_add() can no longer add the
+ * new work after task_work_run() returns.
+ */
+void task_work_run(void)
+{
+	__task_work_run(current, &current->task_works);
+}
-- 
2.25.1

