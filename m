Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 415A9334BD1
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232181AbhCJWom (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbhCJWoS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:18 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B94A6C061761
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:18 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id x29so12377249pgk.6
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d+YxrujXhhT3g0BBV59F9wflxh5ZMWDQNI/4CLio9FI=;
        b=E7Csl+NrhoFsdBHHAm0VqXnliXhDCpm8uA1S3ekyavzHf6zr7+WkRlL9HWLNZygxrK
         //5ASIU8PQu38IqqZPbs0AUWTZ9BAXg6Zl2LyMA1bwzPOxpOxfa6ZHmKhtzH7kbbsMcn
         RYat883J9csXGXqSxFsaNRa4FpZHBCqVSqclcah06rLKubiCgkSlkC/+SfKmaI0GNfWK
         vZPcKTp4tJGz1flHV7+J40o3hNY/OSBFaibV2rNQMa9L5LscLt0KBcHQFeYTx9CEB+t3
         h42ZgzsGk05yDlbKiqLp4dfKiH499r8alznt0sGZHTmE2K8PaH5yFkVeKpFayIlarkky
         cVtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d+YxrujXhhT3g0BBV59F9wflxh5ZMWDQNI/4CLio9FI=;
        b=g/XMaglQ3Nqs/I6r6hVcMaF3UTij455Eja4e8YdC6bulvGXtjrfPZN2BUmU/SqRFUY
         TP9yOTVgwiVnu/UkDPv30AiVRwQDh8lXXR2nOT7m1xPy8UY7s4aYBkW2Kntj4QsNTyyS
         EDXbMOc902vVp+n2YfRBOHY8Lr/7eiRPR7LPDKn8qYjnsyfS5AdTO+P04ApXLaxR9oP0
         qZ2rnCHotQkWZP93UvRroEKzW9E02MCIu9OsnEgS/GNrN5R5qdArSq3couFzq3dhpXpz
         xO3p7BvD/NE5DnW0V1aGL8wDUhBDuMaEOjSAR+0OAHnPELDyUv1wrzJQyJgg/T/DPNBy
         YuWQ==
X-Gm-Message-State: AOAM533ZDwXVjFFk993slpPXeZg4OaP3UbWa+kyMEHKeaeO+VFYw71/m
        LMKJXZF6lqCJdVP2tXCzeHz7+HTMHkjwag==
X-Google-Smtp-Source: ABdhPJzIbidKG8pOznAFGEyuOiwC/mNq95caKJH1F4RIBgCGJNldBw6H9ie2HH1CeXlqGR36e3vREA==
X-Received: by 2002:a63:fd0a:: with SMTP id d10mr4479204pgh.405.1615416257859;
        Wed, 10 Mar 2021 14:44:17 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:17 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 13/27] io_uring: SQPOLL parking fixes
Date:   Wed, 10 Mar 2021 15:43:44 -0700
Message-Id: <20210310224358.1494503-14-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We keep running into weird dependency issues between the sqd lock and
the parking state. Disentangle the SQPOLL thread from the last bits of
the kthread parking inheritance, and just replace the parking state,
and two associated locks, with a single rw mutex. The SQPOLL thread
keeps the mutex for read all the time, except if someone has marked us
needing to park. Then we drop/re-acquire and try again.

This greatly simplifies the parking state machine (by just getting rid
of it), and makes it a lot more obvious how it works - if you need to
modify the ctx list, then you simply park the thread which will grab
the lock for writing.

Fold in fix from Hillf Danton on not setting STOP on a fatal signal.

Fixes: e54945ae947f ("io_uring: SQPOLL stop error handling fixes")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 133 +++++++++++++-------------------------------------
 1 file changed, 34 insertions(+), 99 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7cf96be691d8..2a3542b487ff 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -258,12 +258,11 @@ enum {
 
 struct io_sq_data {
 	refcount_t		refs;
-	struct mutex		lock;
+	struct rw_semaphore	rw_lock;
 
 	/* ctx's that are using this sqd */
 	struct list_head	ctx_list;
 	struct list_head	ctx_new_list;
-	struct mutex		ctx_lock;
 
 	struct task_struct	*thread;
 	struct wait_queue_head	wait;
@@ -274,7 +273,6 @@ struct io_sq_data {
 
 	unsigned long		state;
 	struct completion	startup;
-	struct completion	parked;
 	struct completion	exited;
 };
 
@@ -6638,45 +6636,6 @@ static void io_sqd_init_new(struct io_sq_data *sqd)
 	io_sqd_update_thread_idle(sqd);
 }
 
-static bool io_sq_thread_should_stop(struct io_sq_data *sqd)
-{
-	return test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
-}
-
-static bool io_sq_thread_should_park(struct io_sq_data *sqd)
-{
-	return test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
-}
-
-static void io_sq_thread_parkme(struct io_sq_data *sqd)
-{
-	for (;;) {
-		/*
-		 * TASK_PARKED is a special state; we must serialize against
-		 * possible pending wakeups to avoid store-store collisions on
-		 * task->state.
-		 *
-		 * Such a collision might possibly result in the task state
-		 * changin from TASK_PARKED and us failing the
-		 * wait_task_inactive() in kthread_park().
-		 */
-		set_special_state(TASK_PARKED);
-		if (!test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state))
-			break;
-
-		/*
-		 * Thread is going to call schedule(), do not preempt it,
-		 * or the caller of kthread_park() may spend more time in
-		 * wait_task_inactive().
-		 */
-		preempt_disable();
-		complete(&sqd->parked);
-		schedule_preempt_disabled();
-		preempt_enable();
-	}
-	__set_current_state(TASK_RUNNING);
-}
-
 static int io_sq_thread(void *data)
 {
 	struct io_sq_data *sqd = data;
@@ -6697,17 +6656,16 @@ static int io_sq_thread(void *data)
 
 	wait_for_completion(&sqd->startup);
 
-	while (!io_sq_thread_should_stop(sqd)) {
+	down_read(&sqd->rw_lock);
+
+	while (!test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)) {
 		int ret;
 		bool cap_entries, sqt_spin, needs_sched;
 
-		/*
-		 * Any changes to the sqd lists are synchronized through the
-		 * thread parking. This synchronizes the thread vs users,
-		 * the users are synchronized on the sqd->ctx_lock.
-		 */
-		if (io_sq_thread_should_park(sqd)) {
-			io_sq_thread_parkme(sqd);
+		if (test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
+			up_read(&sqd->rw_lock);
+			cond_resched();
+			down_read(&sqd->rw_lock);
 			continue;
 		}
 		if (unlikely(!list_empty(&sqd->ctx_new_list))) {
@@ -6752,12 +6710,14 @@ static int io_sq_thread(void *data)
 			}
 		}
 
-		if (needs_sched && !io_sq_thread_should_park(sqd)) {
+		if (needs_sched && !test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_set_wakeup_flag(ctx);
 
+			up_read(&sqd->rw_lock);
 			schedule();
 			try_to_freeze();
+			down_read(&sqd->rw_lock);
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_clear_wakeup_flag(ctx);
 		}
@@ -6768,28 +6728,16 @@ static int io_sq_thread(void *data)
 
 	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		io_uring_cancel_sqpoll(ctx);
+	up_read(&sqd->rw_lock);
 
 	io_run_task_work();
 
-	/*
-	 * Ensure that we park properly if racing with someone trying to park
-	 * while we're exiting. If we fail to grab the lock, check park and
-	 * park if necessary. The ordering with the park bit and the lock
-	 * ensures that we catch this reliably.
-	 */
-	if (!mutex_trylock(&sqd->lock)) {
-		if (io_sq_thread_should_park(sqd))
-			io_sq_thread_parkme(sqd);
-		mutex_lock(&sqd->lock);
-	}
-
+	down_write(&sqd->rw_lock);
 	sqd->thread = NULL;
-	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 		io_ring_set_wakeup_flag(ctx);
-	}
-
+	up_write(&sqd->rw_lock);
 	complete(&sqd->exited);
-	mutex_unlock(&sqd->lock);
 	do_exit(0);
 }
 
@@ -7088,44 +7036,40 @@ static int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 }
 
 static void io_sq_thread_unpark(struct io_sq_data *sqd)
-	__releases(&sqd->lock)
+	__releases(&sqd->rw_lock)
 {
 	if (sqd->thread == current)
 		return;
 	clear_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
-	if (sqd->thread)
-		wake_up_state(sqd->thread, TASK_PARKED);
-	mutex_unlock(&sqd->lock);
+	up_write(&sqd->rw_lock);
 }
 
 static void io_sq_thread_park(struct io_sq_data *sqd)
-	__acquires(&sqd->lock)
+	__acquires(&sqd->rw_lock)
 {
 	if (sqd->thread == current)
 		return;
 	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
-	mutex_lock(&sqd->lock);
-	if (sqd->thread) {
+	down_write(&sqd->rw_lock);
+	/* set again for consistency, in case concurrent parks are happening */
+	set_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state);
+	if (sqd->thread)
 		wake_up_process(sqd->thread);
-		wait_for_completion(&sqd->parked);
-	}
 }
 
 static void io_sq_thread_stop(struct io_sq_data *sqd)
 {
 	if (test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state))
 		return;
-	mutex_lock(&sqd->lock);
-	if (sqd->thread) {
-		set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
-		WARN_ON_ONCE(test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state));
-		wake_up_process(sqd->thread);
-		mutex_unlock(&sqd->lock);
-		wait_for_completion(&sqd->exited);
-		WARN_ON_ONCE(sqd->thread);
-	} else {
-		mutex_unlock(&sqd->lock);
+	down_write(&sqd->rw_lock);
+	if (!sqd->thread) {
+		up_write(&sqd->rw_lock);
+		return;
 	}
+	set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+	wake_up_process(sqd->thread);
+	up_write(&sqd->rw_lock);
+	wait_for_completion(&sqd->exited);
 }
 
 static void io_put_sq_data(struct io_sq_data *sqd)
@@ -7142,18 +7086,13 @@ static void io_sq_thread_finish(struct io_ring_ctx *ctx)
 
 	if (sqd) {
 		complete(&sqd->startup);
-		if (sqd->thread) {
+		if (sqd->thread)
 			wait_for_completion(&ctx->sq_thread_comp);
-			io_sq_thread_park(sqd);
-		}
 
-		mutex_lock(&sqd->ctx_lock);
+		io_sq_thread_park(sqd);
 		list_del(&ctx->sqd_list);
 		io_sqd_update_thread_idle(sqd);
-		mutex_unlock(&sqd->ctx_lock);
-
-		if (sqd->thread)
-			io_sq_thread_unpark(sqd);
+		io_sq_thread_unpark(sqd);
 
 		io_put_sq_data(sqd);
 		ctx->sq_data = NULL;
@@ -7202,11 +7141,9 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
 	refcount_set(&sqd->refs, 1);
 	INIT_LIST_HEAD(&sqd->ctx_list);
 	INIT_LIST_HEAD(&sqd->ctx_new_list);
-	mutex_init(&sqd->ctx_lock);
-	mutex_init(&sqd->lock);
+	init_rwsem(&sqd->rw_lock);
 	init_waitqueue_head(&sqd->wait);
 	init_completion(&sqd->startup);
-	init_completion(&sqd->parked);
 	init_completion(&sqd->exited);
 	return sqd;
 }
@@ -7880,9 +7817,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		ctx->sq_creds = get_current_cred();
 		ctx->sq_data = sqd;
 		io_sq_thread_park(sqd);
-		mutex_lock(&sqd->ctx_lock);
 		list_add(&ctx->sqd_list, &sqd->ctx_new_list);
-		mutex_unlock(&sqd->ctx_lock);
 		io_sq_thread_unpark(sqd);
 
 		ctx->sq_thread_idle = msecs_to_jiffies(p->sq_thread_idle);
-- 
2.30.2

