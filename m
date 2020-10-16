Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE0A12908CC
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 17:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436498AbgJPPqA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 11:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436490AbgJPPp6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 11:45:58 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29377C0613D5
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 08:45:58 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id y1so1491846plp.6
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 08:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=WNfSTXUT2iUDeZafCNWX8VIeVisI91/GonUZc3TO/Bw=;
        b=Si9mX/xC/7D+LMLWV397DGJ+QWrasEzm/CKU26eZ/VKae+MqoIxDAW5Ktg2YtF88t+
         eRExWKmtG+sk9tOWTib1IeFYjSiQ2+jELmaJVVBwzhEyfZvNZK/30NmlC5A3iCKbrtQI
         ziJAO9SL1TynGjuCTKQqnZUtwtpQWTR0mEMwYNfNB/OlSyTeLD8MdZOcAkkIULStQODH
         QoaGVBm319mNU/1H7Q5CwLv3TvkvI97zok2ibf3OLkBclmq/3iLTJbIs/YcsN3QJ3Rks
         D9lfBSfKy77t9+jVekPGXElg6+82nO15TDlMEUi55j/Q3Vhnh+TyjZVPbYCFajhDaiwt
         8/vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WNfSTXUT2iUDeZafCNWX8VIeVisI91/GonUZc3TO/Bw=;
        b=NR4tqWl0q5jZTUwUDxVbgemYb9ieFbrC/FPB1R255TzWFm94RbnkZ4zulasaz7rSzt
         r9ZnpzjUxbObLhT8QMDwTarhtm2ZuH6Sq5ApyQwgBc9bC81kHIkjQBdSxMNWMJOJunpn
         0yzdSunLY3cNNNJFE5nnP9h99Qvssr0Mg3lH5YscyDBPNc5T7aFu3GX9NPKxB+OM+8ne
         9lR9BTXCvga4PDePnSXCUhpN2aBgdKBzkgMKEMt/j8ir37+irDO4QG/4uOcxoaGu+LJZ
         1kZsf+dJEBmg/KVc1m7WVN7z/28rHn07Gh+PiC3QN+85sNASgRg3oGferB2uBNNvp7EL
         CRrA==
X-Gm-Message-State: AOAM531EZ2e7crZicLQiXQ0R3lT3xiyrjoPGf7GCpA/sYw1x1bb5FLvN
        dVsoR1ZTvPx/ICRhtzk55K2K3g==
X-Google-Smtp-Source: ABdhPJyXkV5N6dRYzAMAX2blh7rMsUC+u24mbRBviFPvSAHlOwa86n72i0PRCy6IpV+mpSg1gBJIfg==
X-Received: by 2002:a17:90a:1188:: with SMTP id e8mr4696092pja.61.1602863157607;
        Fri, 16 Oct 2020 08:45:57 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id s11sm3346194pjz.29.2020.10.16.08.45.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 08:45:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Cc:     peterz@infradead.org, oleg@redhat.com, tglx@linutronix.de,
        Jens Axboe <axboe@kernel.dk>,
        Roman Gershman <romger@amazon.com>
Subject: [PATCH 4/4] task_work: use TIF_NOTIFY_SIGNAL if available
Date:   Fri, 16 Oct 2020 09:45:47 -0600
Message-Id: <20201016154547.1573096-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016154547.1573096-1-axboe@kernel.dk>
References: <20201016154547.1573096-1-axboe@kernel.dk>
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
index 613b2d634af8..ae058893913c 100644
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

