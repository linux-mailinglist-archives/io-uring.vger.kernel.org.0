Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1C328F305
	for <lists+io-uring@lfdr.de>; Thu, 15 Oct 2020 15:17:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729009AbgJONRM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 15 Oct 2020 09:17:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728884AbgJONRL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 15 Oct 2020 09:17:11 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38361C0613D2
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 06:17:11 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id p9so4049873ilr.1
        for <io-uring@vger.kernel.org>; Thu, 15 Oct 2020 06:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ySJmiV6pZ66encLr0ACqPd40Yi3LeN6xjC4l1TOnISo=;
        b=cuMDln4JOHqPAw7CdzjmLn/iTyTCZbvI5OegfIljamRYynOsZJF258Zo0WBgr5B3Gl
         9xOANGq9UC19YEd5vBqsLBAWr7JlgX2gJfO1YD2YOIdv0XefWlkFZoSaGI9VLKYLAs1q
         MfJpT0dYe3ccWLqx/S+sQrSMgdSr2dqmLsvRnJHffDvp7XwFgnpkPfX49cJPLyQPgU7W
         aJ19G08YWvThbbLaNk4PghTaIxcFNPcgxFKlfDu2m+lRgkmiyftPEI8bXukbVFgrPMLM
         SF53F4yxeaOtzaegMSW6xCuAS1E/vX7Izqvu1Mww2zHNcZJqPsTmjXPJkZwW7Q76QwbU
         7UQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ySJmiV6pZ66encLr0ACqPd40Yi3LeN6xjC4l1TOnISo=;
        b=TpLJsoW0jkqCY98+OHSzbbQbOQv4OI8CIoRM3rNKRLggoP+KgeinzbQblFykp5q5mW
         m636b6VgnagRH7fqGA3FUBuTf0KsplvVK4bHgEiRzv/AyEP6Rsop+aeEgKX04dVmuX3p
         rgB9iuKnqAS+cqml/a6PTev893RETh15GIgkzKyj0uEOMVPdMUNzp+QR+9S4BNdpeJPK
         InrwuPGf0tQFgGaEVlLhps0ThBxgRMnH7B2ZL69EHtT6R/+dc5hzOZneDwZUNCXZTo+7
         YKTRLhjBPBYqUHCcYb1Q6euS05pobq3bDQu+ROpzXAuwS9PnKz5EiNLi+/NnKEsW0eQx
         +s0Q==
X-Gm-Message-State: AOAM532Kyjw8IypiEEoGGkh/YqH4gmT9gGu59UDv8bN4qOKNIbCmn9i2
        go593G/oa/1fZwUayYk4/o6Ihw==
X-Google-Smtp-Source: ABdhPJwtRjttjEB+sPxJzGX2aecJn5FFPN8CcvG60eskaRhV1o/QypGaIs2YvQvfCMBXx6nji1dUVw==
X-Received: by 2002:a05:6e02:d01:: with SMTP id g1mr2901622ilj.246.1602767830328;
        Thu, 15 Oct 2020 06:17:10 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m13sm2486736ioo.9.2020.10.15.06.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2020 06:17:09 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>,
        Roman Gershman <romger@amazon.com>
Subject: [PATCH 5/5] task_work: use TIF_NOTIFY_SIGNAL if available
Date:   Thu, 15 Oct 2020 07:17:01 -0600
Message-Id: <20201015131701.511523-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201015131701.511523-1-axboe@kernel.dk>
References: <20201015131701.511523-1-axboe@kernel.dk>
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
index 613b2d634af8..81163b946224 100644
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
+#if defined(CONFIG_GENERIC_ENTRY) && defined(TIF_NOTIFY_SIGNAL)
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

