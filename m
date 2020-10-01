Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A39732807EA
	for <lists+io-uring@lfdr.de>; Thu,  1 Oct 2020 21:42:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732836AbgJATmd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Oct 2020 15:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732912AbgJATmR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Oct 2020 15:42:17 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3B82C0613E2
        for <io-uring@vger.kernel.org>; Thu,  1 Oct 2020 12:42:15 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id q5so7474460ilj.1
        for <io-uring@vger.kernel.org>; Thu, 01 Oct 2020 12:42:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5MvAG2bGo2OYmDhLgwmA8/KdhDPmTxQa7GH82/DXFGo=;
        b=FCBCHa6zb+XSVqZgRBzdXNboyTbwleBmPdMQhO1iuPieijEtVdOT9UEFyOn1F2HCM3
         WMTPd+EZfmi2AplObbg9j6QmhUeTBiphrU08KjAKlUZ35AugG1EhIxiV97uG5V0Jjm4d
         PVjdTQZR9m7Lk5tcu43SKTTQE8PH7a1p5/XqYvOdwQI9IbZYaqn+2EZ3zvOCPl0iD37t
         +4dcBOPvYj8EQLWqSqfZuNPWOs6On/i/boUYeE503bU86+7BrOllY++RxMpAdr0z/PVE
         j1mL7zqS7JsBPXnsjOdwhMU/SzlKKsxZGVYwDxVPThMFZUy4MhDYjC5LF/GuVRu1IY1U
         igGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5MvAG2bGo2OYmDhLgwmA8/KdhDPmTxQa7GH82/DXFGo=;
        b=XZNVMUNis/vDpgu0qavCQSmj5kjsHNGzZlcw+gtjlHaCYSU8TMgs0ZVmCT70MEmCRv
         +hEUJvTOAquR2++x4FfbfHUo2YWKNl8DF+kHQboZsCbfO77gmmY9pqHqTiUUaF8LEYry
         /y9XDRnGJPDhqEzitNt1mxqppRNrf6GytUHuO6TUQ0SAV5xw7GP+MWyseMKea8wfdTP4
         inYe+/o4/IPB7TWAp4HitBc1W5/C9y7cWE7JGvoJ/QG0A5eu6DorNNCjzpJcPtMP60QY
         8HzM/beikiTuTHRs0fY4dqYMrjrQJyM/PR1P6gBpxd7tlMtsUnujbF2wTuxvb9XV600h
         m4EA==
X-Gm-Message-State: AOAM533HypYUK5N19i34WgapbaSp9JnPvfNl9ZlxHT07Whz8CPJy9Ogf
        RHfZo9oXwyckNJt3c8DKw7n15E2WJUXqlQ==
X-Google-Smtp-Source: ABdhPJyIgnEHSuOPj65ppvKPbvFrg6enec0IJPjCNl8GFKlbW5h0SN0lZ8/LUYazqjj0Xg8ZVhI2HA==
X-Received: by 2002:a92:905:: with SMTP id y5mr3776970ilg.210.1601581335138;
        Thu, 01 Oct 2020 12:42:15 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t11sm739609ill.61.2020.10.01.12.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 12:42:14 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] task_work: use TIF_TASKWORK if available
Date:   Thu,  1 Oct 2020 13:42:08 -0600
Message-Id: <20201001194208.1153522-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001194208.1153522-1-axboe@kernel.dk>
References: <20201001194208.1153522-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the arch supports TIF_TASKWORK, then use that for TWA_SIGNAL as
it's more efficient than using the signal delivery method. This is
especially true on threaded applications, where ->sighand is shared
across threads.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/task_work.c | 48 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 36 insertions(+), 12 deletions(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 613b2d634af8..ae317cfe86b8 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -5,6 +5,39 @@
 
 static struct callback_head work_exited; /* all we need is ->next == NULL */
 
+/*
+ * TWA_SIGNAL signaling - use TIF_TASKWORK, if available.
+ */
+static void task_work_signal(struct task_struct *task)
+{
+#ifndef TIF_TASKWORK
+	unsigned long flags;
+
+	/*
+	 * Only grab the sighand lock if we don't already have some
+	 * task_work pending. This pairs with the smp_store_mb()
+	 * in get_signal(), see comment there.
+	 */
+	if (!(READ_ONCE(task->jobctl) & JOBCTL_TASK_WORK) &&
+	    lock_task_sighand(task, &flags)) {
+		task->jobctl |= JOBCTL_TASK_WORK;
+		signal_wake_up(task, 0);
+		unlock_task_sighand(task, &flags);
+	}
+#else
+	set_tsk_thread_flag(task, TIF_TASKWORK);
+	set_notify_resume(task);
+#endif
+}
+
+static inline void clear_tsk_taskwork(struct task_struct *task)
+{
+#ifdef TIF_TASKWORK
+	if (test_tsk_thread_flag(task, TIF_TASKWORK))
+		clear_tsk_thread_flag(task, TIF_TASKWORK);
+#endif
+}
+
 /**
  * task_work_add - ask the @task to execute @work->func()
  * @task: the task which should run the callback
@@ -28,7 +61,6 @@ int
 task_work_add(struct task_struct *task, struct callback_head *work, int notify)
 {
 	struct callback_head *head;
-	unsigned long flags;
 
 	do {
 		head = READ_ONCE(task->task_works);
@@ -42,17 +74,7 @@ task_work_add(struct task_struct *task, struct callback_head *work, int notify)
 		set_notify_resume(task);
 		break;
 	case TWA_SIGNAL:
-		/*
-		 * Only grab the sighand lock if we don't already have some
-		 * task_work pending. This pairs with the smp_store_mb()
-		 * in get_signal(), see comment there.
-		 */
-		if (!(READ_ONCE(task->jobctl) & JOBCTL_TASK_WORK) &&
-		    lock_task_sighand(task, &flags)) {
-			task->jobctl |= JOBCTL_TASK_WORK;
-			signal_wake_up(task, 0);
-			unlock_task_sighand(task, &flags);
-		}
+		task_work_signal(task);
 		break;
 	}
 
@@ -110,6 +132,8 @@ void task_work_run(void)
 	struct task_struct *task = current;
 	struct callback_head *work, *head, *next;
 
+	clear_tsk_taskwork(task);
+
 	for (;;) {
 		/*
 		 * work->func() can do task_work_add(), do not set
-- 
2.28.0

