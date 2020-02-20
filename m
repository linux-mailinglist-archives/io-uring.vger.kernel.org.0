Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C91EC16685B
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 21:32:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728985AbgBTUb7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 15:31:59 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45348 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728400AbgBTUb7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 15:31:59 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so2466253pfg.12
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 12:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+nPrlaHTVnMxA+FeQQMqtpSdWy/JIJGZUdrBVsVeySQ=;
        b=skA83dKbFKzaa3DgTNWJc6vZXKMGvsNLfyUnjE2Yw2shaV3Y/KnXyA7rntZrEiCglB
         Z1SjHAfSedbNQ1HuUk22taAhy8J065GzRbsBBdKyAZGFk2cEybFBjZU4VeI4HXxMNtcn
         LjOGgthXGePV6bkQaM41UyMyrfnJjLWnirhiXZdck8fnR94raltJPQPVrFGpC+TUpdU+
         nDkuTBjQ3Z9LksZNIGJT9d0GZnuufdVOupmXu4DG9A2LV4RyCCdDFIu14hQ66O6NMmXj
         hJJd1vtz2YUkJ1FcKhj1c8pK4XDxaBQKJtmF58cTiN6Mx1lQUoMmb2pXe448uD8YI5DF
         R4+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+nPrlaHTVnMxA+FeQQMqtpSdWy/JIJGZUdrBVsVeySQ=;
        b=IWdElySBi62CPUVxLRmabv3njoNjFutsZzUcrsrE3ehgmUX8C+Z9Lw6z0xOT2JDrA/
         A1cp31AMRmjK9ttnceJbn3bJ8G66W8yD4Zu8jt52z/TMe0YtADZpjQY+/ioOv1cxP1E7
         56BqS3nMAB0H0HDNlCCeZ6dNmJz4//9UmPykHQl6R9bl0cA59JGjBlfwlmYI+g7IdLyq
         uwcBhumHFaq0DmyjLD1l4zP+tTGpLboME5vPatZiTgIZRVgrv16n20Hj2l6IYSrKH6Xl
         /CSKQfPbZDYfCUNLdpQJJ8jtyPzwrUjtKdKhShEagGXxKSJBVWaoM+IO14A9lCzrpgof
         4lsA==
X-Gm-Message-State: APjAAAUT5qDm5Yi9207ty7YKbeEwiXPm86G2TGhyuuYdfOwz2naotQR+
        2lmisiXLx9QewicId/t2Ji2M19hHc9c=
X-Google-Smtp-Source: APXvYqz4n4BPAAFqUAIwj+ATWZGB+CX/ReFMD08+qDS0UwEUYEVS3D8zzHix4/EczdVFJuUQaFAcRw==
X-Received: by 2002:a62:5bc3:: with SMTP id p186mr10630119pfb.162.1582230718599;
        Thu, 20 Feb 2020 12:31:58 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id z10sm169672pgj.73.2020.02.20.12.31.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 12:31:58 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/9] sched: move io-wq/workqueue worker sched in/out into helpers
Date:   Thu, 20 Feb 2020 13:31:45 -0700
Message-Id: <20200220203151.18709-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200220203151.18709-1-axboe@kernel.dk>
References: <20200220203151.18709-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We already have sched_update_worker() which calls the "I woke up" handler
for io-wq and workqueue threads, rename it to sched_in_update(). The code
that is called when the threads are going to sleep is moved into an
identical helper, sched_out_update(), so that it mirrors the schedule in
side.

No functional changes in this patch.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 kernel/sched/core.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 1a9983da4408..c7bab13f9caa 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4102,11 +4102,8 @@ void __noreturn do_task_dead(void)
 		cpu_relax();
 }
 
-static inline void sched_submit_work(struct task_struct *tsk)
+static void sched_out_update(struct task_struct *tsk)
 {
-	if (!tsk->state)
-		return;
-
 	/*
 	 * If a worker went to sleep, notify and ask workqueue whether
 	 * it wants to wake up a task to maintain concurrency.
@@ -4122,6 +4119,24 @@ static inline void sched_submit_work(struct task_struct *tsk)
 			io_wq_worker_sleeping(tsk);
 		preempt_enable_no_resched();
 	}
+}
+
+static void sched_in_update(struct task_struct *tsk)
+{
+	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER)) {
+		if (tsk->flags & PF_WQ_WORKER)
+			wq_worker_running(tsk);
+		else
+			io_wq_worker_running(tsk);
+	}
+}
+
+static inline void sched_submit_work(struct task_struct *tsk)
+{
+	if (!tsk->state)
+		return;
+
+	sched_out_update(tsk);
 
 	if (tsk_is_pi_blocked(tsk))
 		return;
@@ -4134,16 +4149,6 @@ static inline void sched_submit_work(struct task_struct *tsk)
 		blk_schedule_flush_plug(tsk);
 }
 
-static void sched_update_worker(struct task_struct *tsk)
-{
-	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER)) {
-		if (tsk->flags & PF_WQ_WORKER)
-			wq_worker_running(tsk);
-		else
-			io_wq_worker_running(tsk);
-	}
-}
-
 asmlinkage __visible void __sched schedule(void)
 {
 	struct task_struct *tsk = current;
@@ -4154,7 +4159,7 @@ asmlinkage __visible void __sched schedule(void)
 		__schedule(false);
 		sched_preempt_enable_no_resched();
 	} while (need_resched());
-	sched_update_worker(tsk);
+	sched_in_update(tsk);
 }
 EXPORT_SYMBOL(schedule);
 
-- 
2.25.1

