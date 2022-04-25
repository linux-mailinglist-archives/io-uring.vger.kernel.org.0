Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22BBD50E2EA
	for <lists+io-uring@lfdr.de>; Mon, 25 Apr 2022 16:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242321AbiDYOY1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Apr 2022 10:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242230AbiDYOY0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Apr 2022 10:24:26 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C90721E22
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:21:22 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id y11so9428580ilp.4
        for <io-uring@vger.kernel.org>; Mon, 25 Apr 2022 07:21:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lEau4k6lbTQ9lqJfBFgL32mD1tqEjCcVozijP5814T8=;
        b=cGTgB4QGkF/BDbAPYdXgPdbD7Xesm8bPdkJrLu3Lrb26PJg7PejZeJgsxJvr3W8QhU
         FSRfgHocZcUoxP4O/IwfiE42nuT7pSSFCaLakuok/1oX1ABWWxxy/tHA4WvL3apTtDJ1
         SNU1M/R8gAY36Qcqdobcz1Zd9ts+fDRHV7qOg3plxSc2YGQ5KxUE6R558y/4G+VaaFk+
         I55sudHNV6lN6+7EmhqQJyzEpkNNqT/MoeoC6gPH6/ZhfMl1+/zTyDfndOyr4Xn5Rmz2
         6Q/0uhVALaVhL0ZAthlD2W2aQvtfKfxbQYTSFgFNhQTORzXcwNv6blOXPKqXialkLAXg
         A1rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lEau4k6lbTQ9lqJfBFgL32mD1tqEjCcVozijP5814T8=;
        b=11E2eRMbX8ZJLpS99fi0VwBcJus9gZqbVTQ5qdljscrWeeA0fD8gZpDYaPmE6QBtrh
         M2qpEuMJLNFl1uoj8yyC1VCdwejwfK5ghXmKAwmedEf7DSKr8JkE1sbos+m3NP9B3Uua
         Xi6fAIX5XGfVa8Djtcl+9q+mYtY1SBkycWwx3L6wqLeuBOPspN1jZW/oQ9qc481P3CP5
         Nzl4rBY/X6zNJzbhKYrAtUVgUpUSrMRAUF4MzoUiC4Frywg8FvwJ6y+94IC2n2+1nuj2
         uvBbIW+df16xt7bg8p+ZTMMsOr+52RhXWbKfXC+evctUC5GliXKNrhhyW2NeklsCO82H
         0T5Q==
X-Gm-Message-State: AOAM531tUXwEfVb2m8Qu/GioOenJLjINNhC81k6oyqA6zOPcvI1NsVt0
        Qc2sUabP0lTNQqZKFYoEb3rNoG8js2LGgQ==
X-Google-Smtp-Source: ABdhPJy+WjQx5mB8VFpEgE3Wxqw6Lry4Uzvyf0crI1P3FoBqnCAQRp09bTIRY3yRzOEmJtsZfiNWSg==
X-Received: by 2002:a05:6e02:1d83:b0:2cc:1dbc:7c34 with SMTP id h3-20020a056e021d8300b002cc1dbc7c34mr7537534ila.315.1650896481435;
        Mon, 25 Apr 2022 07:21:21 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p6-20020a0566022b0600b0064c59797e67sm8136737iov.46.2022.04.25.07.21.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Apr 2022 07:21:20 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/6] task_work: allow TWA_SIGNAL without a rescheduling IPI
Date:   Mon, 25 Apr 2022 08:21:13 -0600
Message-Id: <20220425142118.1448840-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220425142118.1448840-1-axboe@kernel.dk>
References: <20220425142118.1448840-1-axboe@kernel.dk>
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

