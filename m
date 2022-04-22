Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0DC850C397
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 01:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233214AbiDVWnq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Apr 2022 18:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233305AbiDVWnh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Apr 2022 18:43:37 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 168C41DB5D3
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:42:20 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id bg9so8326549pgb.9
        for <io-uring@vger.kernel.org>; Fri, 22 Apr 2022 14:42:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lEau4k6lbTQ9lqJfBFgL32mD1tqEjCcVozijP5814T8=;
        b=ufARaz+/CPZcKctSsxz1BdwbvEBmg/K74W1G6zKiDJ+pcsNo+AucV1lwfpjyXjNO6t
         Ztu8AiNphHPZkQcJjP1YHzX4e1EiveDzOKOebOh/OuUe8uZxhJAkoRZFWcBG3EbQCom0
         VjA7hRIxQn+lqgltDr57Gr5jzmIswursgUG3mK8vP2XTiL/Tlug7MZl5Yd9yLZ4VZEq3
         jEQvz8e4myoC9DTN9GgbElcPQ1YSD4ayPicCXNdhrKN29+LhfkapcvZ2exUgzavPFHfg
         iOCVgC+Wi9eiYrSyFBE1zTYBXo9X6yn7yYZXw22P4wOPscG7DWSAfp6QjkAn9c81JwWP
         //qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lEau4k6lbTQ9lqJfBFgL32mD1tqEjCcVozijP5814T8=;
        b=hpXtzGO2z660oN7opNiKKZWYn6PjAmhVYqhQTD/I2OTP3u1NgORiCkcyLxWklr1t0n
         QNcgfNxbt/wAr6vU8/ir5qx5kggz8EvUT/1Gj71L7XkiofxrLkdLxNBvvJtDXs2pxQvJ
         f563yEglQZpgbArWe7GNPu4mPfmYkgpaQ+KBrtiw8AL1sKKmnyxLQ7tmu4FWlUHZ6AQo
         497ImXQiC2YE0Y65XxqKRS8V/C3KknW78c7bG1i/+wwdDxM/n9qCTSV0REwO+N+rCtjG
         j50fDJiveIW9Nh5Qb8CenFW4tVn+zWSpnu7C2iYEcXHN16nLecfr3teNymJ8dUwPYOWY
         +tgw==
X-Gm-Message-State: AOAM5327p3VFowqOZ1JsgzR1Q2xFxhjE4zZMwYUAIhtm5LQP9C1C9Tbw
        9LxXm1F6nGDh+CLgyKilWJl7BG9WFG7BWce5
X-Google-Smtp-Source: ABdhPJwC0Y1BonKfVqlk4+QdkwjRUGkU5norX2Bcb9cHq0dYYCBDRPCV6cRuPwRv1GfqlDbiWK5z+Q==
X-Received: by 2002:a65:48c6:0:b0:398:b858:e332 with SMTP id o6-20020a6548c6000000b00398b858e332mr5473783pgs.291.1650663739270;
        Fri, 22 Apr 2022 14:42:19 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c5-20020a62f845000000b0050ceac49c1dsm3473098pfm.125.2022.04.22.14.42.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 14:42:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] task_work: allow TWA_SIGNAL without a rescheduling IPI
Date:   Fri, 22 Apr 2022 15:42:10 -0600
Message-Id: <20220422214214.260947-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220422214214.260947-1-axboe@kernel.dk>
References: <20220422214214.260947-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Some use cases don't always need an IPI when sending a TWA_SIGNAL
notification. Add TWA_SIGNAL_NO_IPI, which is just like TWA_SIGNAL,
except it doesn't send an IPI to the target task. It merely sets
TIF_NOTIFY_SIGNAL and wakes up the task.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/sched/signal.h | 13 +++++++++++--
 include/linux/task_work.h    |  1 +
 kernel/task_work.c           | 15 ++++++++++-----
 3 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/include/linux/sched/signal.h b/include/linux/sched/signal.h
index 3c8b34876744..66b689f6cfcb 100644
--- a/include/linux/sched/signal.h
+++ b/include/linux/sched/signal.h
@@ -355,14 +355,23 @@ static inline void clear_notify_signal(void)
 	smp_mb__after_atomic();
 }
 
+/*
+ * Returns 'true' if kick_process() is needed to force a transition from
+ * user -> kernel to guarantee expedient run of TWA_SIGNAL based task_work.
+ */
+static inline bool __set_notify_signal(struct task_struct *task)
+{
+	return !test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
+	       !wake_up_state(task, TASK_INTERRUPTIBLE);
+}
+
 /*
  * Called to break out of interruptible wait loops, and enter the
  * exit_to_user_mode_loop().
  */
 static inline void set_notify_signal(struct task_struct *task)
 {
-	if (!test_and_set_tsk_thread_flag(task, TIF_NOTIFY_SIGNAL) &&
-	    !wake_up_state(task, TASK_INTERRUPTIBLE))
+	if (__set_notify_signal(task))
 		kick_process(task);
 }
 
diff --git a/include/linux/task_work.h b/include/linux/task_work.h
index 897494b597ba..795ef5a68429 100644
--- a/include/linux/task_work.h
+++ b/include/linux/task_work.h
@@ -17,6 +17,7 @@ enum task_work_notify_mode {
 	TWA_NONE,
 	TWA_RESUME,
 	TWA_SIGNAL,
+	TWA_SIGNAL_NO_IPI,
 };
 
 static inline bool task_work_pending(struct task_struct *task)
diff --git a/kernel/task_work.c b/kernel/task_work.c
index c59e1a49bc40..fa8fdd04aa17 100644
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -13,11 +13,13 @@ static struct callback_head work_exited; /* all we need is ->next == NULL */
  *
  * Queue @work for task_work_run() below and notify the @task if @notify
  * is @TWA_RESUME or @TWA_SIGNAL. @TWA_SIGNAL works like signals, in that the
- * it will interrupt the targeted task and run the task_work. @TWA_RESUME
- * work is run only when the task exits the kernel and returns to user mode,
- * or before entering guest mode. Fails if the @task is exiting/exited and thus
- * it can't process this @work. Otherwise @work->func() will be called when the
- * @task goes through one of the aforementioned transitions, or exits.
+ * it will interrupt the targeted task and run the task_work. @TWA_SIGNAL_NO_IPI
+ * works like @TWA_SIGNAL, except it doesn't send a reschedule IPI to force the
+ * targeted task to reschedule and run task_work. @TWA_RESUME work is run only
+ * when the task exits the kernel and returns to user mode, or before entering
+ * guest mode. Fails if the @task is exiting/exited and thus it can't process
+ * this @work. Otherwise @work->func() will be called when the @task goes
+ * through one of the aforementioned transitions, or exits.
  *
  * If the targeted task is exiting, then an error is returned and the work item
  * is not queued. It's up to the caller to arrange for an alternative mechanism
@@ -53,6 +55,9 @@ int task_work_add(struct task_struct *task, struct callback_head *work,
 	case TWA_SIGNAL:
 		set_notify_signal(task);
 		break;
+	case TWA_SIGNAL_NO_IPI:
+		__set_notify_signal(task);
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		break;
-- 
2.35.1

