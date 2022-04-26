Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9CB450EE46
	for <lists+io-uring@lfdr.de>; Tue, 26 Apr 2022 03:49:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241436AbiDZBwT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 21:52:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241375AbiDZBwQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 21:52:16 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DFE455493
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:09 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id n33-20020a17090a5aa400b001d28f5ee3f9so1101750pji.4
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 18:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lEau4k6lbTQ9lqJfBFgL32mD1tqEjCcVozijP5814T8=;
        b=K9r8Lbv6hBufORZUPqvkq1ErrroI/am0re6akf45e83sEHA2bmouoTF5GBY4QxEMfo
         23eEISjeHWdhavAJOog8X6Cl8KmVZ0ZPRlXg7lUm3cuyBjE8sc4gCxSFPEZwv0sSztmE
         4sIRfGuZkG1wUCXYeTF284VrfuOltFcds+QukS94Xe24uuuR9mCDwUjeNOVH2F8S3l2w
         sr36jahSBtOyWYqnV2gHUU1YYa9iwNgxFqaJKDobgGKJYt4eNjlNVmDyz+5rWLEvapHF
         MwK18vhhM8b+9fU2QoWxMeYNGW22zQKgCrYR16WDQrBiA470VK+NMSoU7GRoD7DOAEXx
         Kyng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lEau4k6lbTQ9lqJfBFgL32mD1tqEjCcVozijP5814T8=;
        b=KJSstgSbZ+q4SplEvShuYrdhWBnM0iPuXYEjQGF08u/GP77JpLQy09DMjBpECo6bmc
         Z8M07kIG+KHbsX23hkasEzSav3Zjd4ro81mkAxueY8QsjoYY+/1/oLMVLqQHwjcrc4xq
         G+BydObNtUtcVAvgk8gAACApU+ZWzB4e+Tcni6gIxDzSiY/2y2M+jJIp7qnpCkYEuk2O
         F7gDPJaWYgeIoEae0mr5Fim+YsNWkC7TxErW4Md8FRv0b3KJ4XGqYMkWHbP8K7hswrfU
         Mwp+QeDqmVH4KJZKWwpj3qHrmubL8tHBgnOsargbBJQfpf0zE1YamEBBmRMhl1Wkxf07
         sChw==
X-Gm-Message-State: AOAM531ofguBZsNO7XlY2Qe1jXXIEayHhBp54fc6CvgIWOXSa7dFwZ7i
        RiDWM936xSZMJb0n8TN696chTX5zlfxo3l++
X-Google-Smtp-Source: ABdhPJxOUT3iXmeH1SmC6H5ruaRiksP5gMDkPB1XmU693Zdaaa7bnuagNw+ZsXAohESqnF2/0baf1w==
X-Received: by 2002:a17:902:be08:b0:15d:2297:f294 with SMTP id r8-20020a170902be0800b0015d2297f294mr4993540pls.171.1650937748296;
        Mon, 25 Apr 2022 18:49:08 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id i23-20020a056a00225700b0050d38d0f58dsm6076149pfu.213.2022.04.25.18.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 18:49:07 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] task_work: allow TWA_SIGNAL without a rescheduling IPI
Date:   Mon, 25 Apr 2022 19:48:59 -0600
Message-Id: <20220426014904.60384-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220426014904.60384-1-axboe@kernel.dk>
References: <20220426014904.60384-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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

