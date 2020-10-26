Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0EF7299800
	for <lists+io-uring@lfdr.de>; Mon, 26 Oct 2020 21:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732192AbgJZUct (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Oct 2020 16:32:49 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:37267 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732102AbgJZUcj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Oct 2020 16:32:39 -0400
Received: by mail-io1-f65.google.com with SMTP id q25so11831294ioh.4
        for <io-uring@vger.kernel.org>; Mon, 26 Oct 2020 13:32:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WqNJgzUJ730nftaXzhmDP2PjcBlHnvqhfXXpoZKk+Cg=;
        b=rHPO5+VVrPfse+fV612DyhXyGzf2LsPDSv9jbH/n2+OtjYsIZZQ99L+5XyRWdOras1
         xwr6Y049mpLLuYYTwAiLYjugjCp/Y8Gm8+wZqnBte95dw1RMPHOFj4gDLLlyTnJ0wtqK
         vr8kJUe7xpsGyxF8tHRMahnO8PQMDUFAcULaDaUw78txqMcYx6zUOLUuEqg/W32WFX2J
         2QGNnozOFvMmD7XuPCfmq0w+nAzHgg4PYPpDXC/ZFOie8mqavk7S9AbmrPNFPy5QVRFp
         EMo9yR3jP2O173Rt5qd34B1146FlFGa9a/29UPsoPHST4NcU3T2WhqqDNibLoDcNTnwk
         C4Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WqNJgzUJ730nftaXzhmDP2PjcBlHnvqhfXXpoZKk+Cg=;
        b=McHEEnG1mvG9Rxsa01RWwHyMJv41AzDG9+u8l9fQa7sA8l6KbpCLCdENMMaJNIh4on
         LTfcGh9D//NBRJBbm1/Ldj7FxsMHT/Vubdc36+soGIVeO2XLVlK9eiiM+Fhq/JNbVtor
         9+cqWWS9gwFH1XniwUa0LKb/9VzmK0QWDAijp9vMWazhc3xYdGbVNQp41DIWdypkU8iU
         9WPAcL4YvA9EWcYVH5BoylrZqoOUDeksDeiwS9aHqOwkYH7D1lB/6ZWmwBkwGcPGCtrL
         HNaUKcJ4G4W5KpC5zMhVC84nIY6jP1SMp34hEKnzGUB3xaoeX27GLojwW8rc0Hb4YxC4
         uNTw==
X-Gm-Message-State: AOAM5327wjLvLBeJ2RnoRTEr3neR/vILAXBlg03UDVLgwavd5ztmubv4
        K4AXSOYlZjkYdksusImXN7DueA==
X-Google-Smtp-Source: ABdhPJw7/DJO/4KNfjJqHXElP5SoVmaIK2Tj6PlGMYmDQjAPG1tc2o34EoVoUAdlIx4P+/LJPugmqw==
X-Received: by 2002:a6b:92c6:: with SMTP id u189mr12162338iod.192.1603744357353;
        Mon, 26 Oct 2020 13:32:37 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e12sm6770373ilq.65.2020.10.26.13.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 13:32:36 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>,
        Roman Gershman <romger@amazon.com>
Subject: [PATCH 4/4] task_work: use TIF_NOTIFY_SIGNAL if available
Date:   Mon, 26 Oct 2020 14:32:30 -0600
Message-Id: <20201026203230.386348-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20201026203230.386348-1-axboe@kernel.dk>
References: <20201026203230.386348-1-axboe@kernel.dk>
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
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/task_work.c | 41 +++++++++++++++++++++++++++++------------
 1 file changed, 29 insertions(+), 12 deletions(-)

diff --git a/kernel/task_work.c b/kernel/task_work.c
index 8d6e1217c451..15b087286bea 100644
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
+#if defined(TIF_NOTIFY_SIGNAL)
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
@@ -33,7 +61,6 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
 		  enum task_work_notify_mode notify)
 {
 	struct callback_head *head;
-	unsigned long flags;
 
 	do {
 		head = READ_ONCE(task->task_works);
@@ -49,17 +76,7 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
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
 	default:
 		WARN_ON_ONCE(1);
-- 
2.29.0

