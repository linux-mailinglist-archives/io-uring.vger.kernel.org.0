Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF252838F7
	for <lists+io-uring@lfdr.de>; Mon,  5 Oct 2020 17:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgJEPFA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Oct 2020 11:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727043AbgJEPEx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Oct 2020 11:04:53 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E7C9C0613AB
        for <io-uring@vger.kernel.org>; Mon,  5 Oct 2020 08:04:51 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v8so9471106iom.6
        for <io-uring@vger.kernel.org>; Mon, 05 Oct 2020 08:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=m8iZ8MjkSc6erbT/UXuLX8pK+PMOfNjl6qhqMPOTqMQ=;
        b=DvdzXRPPZtb8tpBLfxyvRj9sOIvmqo2lz8j8U0Ud4nt4OoJsEJ9EW2yJDM9vE6oPj+
         GHl1Q2fxc9FKSCuGWFg7qlyq974nMDmcYSqDCsjXRBI2Rm4MNLiQ8TzoQJrSvH8AEBMd
         s9AJSMMrtnxN7bzuwjioqsjQpSjKixr/rhkx1jajrglR6/y1Kdd4ZXM2dbQfP1qTUldb
         +HYWC5kVfEw9diYQpJI97XmBasMH37ps7VY7mAAivQrq89U31VC8SbUvdGiQHm7ttR3T
         iIyhiTGOCMj2qC90BDzeHYTPMmesd4REufs9ESuX/AyUzDjGv4QZa8xdEQNQcrayD+m4
         GlJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=m8iZ8MjkSc6erbT/UXuLX8pK+PMOfNjl6qhqMPOTqMQ=;
        b=uWwThtCExV2Fdn5DCL8puo9522NSQuN+LTB1ABtTn+fvbQsqmFF17zVD5EPbiZlepK
         2LE870jXib+m/x/568PsR/0uc3Ybt2xhEkcHCABCJVKSrDGhTsWMMu/EO/0N1+2XbohP
         1J+km71NEOiUummM1/RDUzkvutE8KOqqceJSwbFUAHstYJjz4cA15F3tdmjlXYZpRnMB
         4YHBtG1sRmTux7p7F0IW8w+QUjE5NEoWh300SB9bbS9RXbr7mMh6Tba1y2B4+ZLHbOGc
         iRcPhNKjwzqJoyV8abcXt2RE8foI8yySYTnR7P/pwVAxbnr+yyZOdHP+VH02t2iQgUNZ
         dReQ==
X-Gm-Message-State: AOAM530Hkv8CRJamiEpkkCqlU//oZwgkhFhVSLKSCkOfBRpWZ1WfOciG
        gJV/qK6VyQaM+pRXUBRwZAzLcg==
X-Google-Smtp-Source: ABdhPJyPmhv+W28xa2YPihJ8SpTVhGAnY3sRwSGmW6cXOSEqjGi9G6bUrm3BCSL3VgxNutC925W5Aw==
X-Received: by 2002:a05:6638:10e9:: with SMTP id g9mr302722jae.139.1601910290342;
        Mon, 05 Oct 2020 08:04:50 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 15sm33140ilz.66.2020.10.05.08.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2020 08:04:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>,
        Roman Gershman <romger@amazon.com>
Subject: [PATCH 6/6] task_work: use TIF_NOTIFY_SIGNAL if available
Date:   Mon,  5 Oct 2020 09:04:38 -0600
Message-Id: <20201005150438.6628-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005150438.6628-1-axboe@kernel.dk>
References: <20201005150438.6628-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the arch supports TIF_NOTIFY_SIGNAL, then use that for TWA_SIGNAL as
it's more efficient than using the signal delivery method. This is
especially true on threaded applications, where ->sighand is shared
across threads, but it's also lighter weight on non-shared cases.

io_uring is a heavy consumer of TWA_SIGNAL based task_work. On my test
box, even just using 16 threads shows a nice improvement running an
io_uring based echo server.

stock kernel:
0.01% <= 0.1 milliseconds
95.86% <= 0.2 milliseconds
98.27% <= 0.3 milliseconds
99.71% <= 0.4 milliseconds
100.00% <= 0.5 milliseconds
100.00% <= 0.6 milliseconds
100.00% <= 0.7 milliseconds
100.00% <= 0.8 milliseconds
100.00% <= 0.9 milliseconds
100.00% <= 1.0 milliseconds
100.00% <= 1.1 milliseconds
100.00% <= 2 milliseconds
100.00% <= 3 milliseconds
100.00% <= 3 milliseconds
1378930.00 requests per second
~1600% CPU

1.38M requests/second, and all 16 CPUs are maxed out.

patched kernel:
0.01% <= 0.1 milliseconds
98.24% <= 0.2 milliseconds
99.47% <= 0.3 milliseconds
99.99% <= 0.4 milliseconds
100.00% <= 0.5 milliseconds
100.00% <= 0.6 milliseconds
100.00% <= 0.7 milliseconds
100.00% <= 0.8 milliseconds
100.00% <= 0.9 milliseconds
100.00% <= 1.2 milliseconds
1666111.38 requests per second
~1450% CPU

1.67M requests/second, and we're no longer just hammering on the sighand
lock. The original reporter states:

"For 5.7.15 my benchmark achieves 1.6M qps and system cpu is at ~80%.
 for 5.7.16 or later it achieves only 1M qps and the system cpu is is
 at ~100%"

with the only difference there being that TWA_SIGNAL is used
unconditionally in 5.7.16, since we need it to be able to solve an
inability to run task_work if the application is waiting in the kernel
already on an event that needs task_work run to be satisfied. Also
see commit 0ba9c9edcd15.

Reported-by: Roman Gershman <romger@amazon.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/task_work.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 613b2d634af8..95604e57af46 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -5,6 +5,34 @@
 
 static struct callback_head work_exited; /* all we need is ->next == NULL */
 
+/*
+ * TWA_SIGNAL signaling - use TIF_NOTIFY_SIGNAL, if available, as it's faster
+ * than TIF_SIGPENDING as there's no dependency on ->sighand. The latter is
+ * shared for threads, and can cause contention on sighand->lock. Even for
+ * the non-threaded case TIF_NOTIFY_SIGNAL is more efficient, as no locking
+ * or IRQ disabling is involved for notification (or running) purposes.
+ */
+static void task_work_notify_signal(struct task_struct *task)
+{
+#ifdef TIF_NOTIFY_SIGNAL
+	set_notify_signal(task);
+#else
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
+#endif
+}
+
 /**
  * task_work_add - ask the @task to execute @work->func()
  * @task: the task which should run the callback
@@ -28,7 +56,6 @@ int
 task_work_add(struct task_struct *task, struct callback_head *work, int notify)
 {
 	struct callback_head *head;
-	unsigned long flags;
 
 	do {
 		head = READ_ONCE(task->task_works);
@@ -42,17 +69,7 @@ task_work_add(struct task_struct *task, struct callback_head *work, int notify)
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
+		task_work_notify_signal(task);
 		break;
 	}
 
-- 
2.28.0

