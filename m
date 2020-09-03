Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB10825B8B5
	for <lists+io-uring@lfdr.de>; Thu,  3 Sep 2020 04:21:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgICCVH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Sep 2020 22:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726814AbgICCVF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Sep 2020 22:21:05 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767F0C061244
        for <io-uring@vger.kernel.org>; Wed,  2 Sep 2020 19:21:05 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id g29so848632pgl.2
        for <io-uring@vger.kernel.org>; Wed, 02 Sep 2020 19:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QnmGqfB7ZFZPI/7IBaYu/oPzAG2NQ7dgESdiLhVGI6k=;
        b=AWxoYdJKTIlbcZGYmF2k4GRxzmnRyLXqnYVnDeAaUObCZKygi50lvl/xyK5D+ecoET
         rkZesUiAIabI2GwVHD8woz5auGFgkgQvCNGwYVq/HNEpM/sZnbI5n3kknhAimOQ/PYI8
         ltiJ3bV0/gRbXaBJiZVTMFZ5l0ttIn1dOcNyFXZqXA2JqS3bY/J62NDD5lkLKLSjUSGe
         pQVWfSkqfnYbgt9TqMo9gC95pCRJFHUcuwEr4Kyw0epMQXCAGt5+wCHwimWGX5SaJ2ws
         GGwhWgkqh53Qo509XN2QgYG3TSoH6A0qshXHmq8kjWS5kQFulsw0CjJJBrt4CdUA0oRS
         9Usg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QnmGqfB7ZFZPI/7IBaYu/oPzAG2NQ7dgESdiLhVGI6k=;
        b=b0gOUC2dGV6SpTK9/tBprUdgx8af9EaeWAopYX+1jPNjaog7h9Mjpzo8CaCmMwbXfl
         GIsRXsDAvtjCBb4QnxoGROSvAQWYvi5rmduXTxV5ZkkRkmptsfyCukBkGhlpxBMNJ+Sb
         XlDF8ZvpJXOr9Z2sVR/v6QCS3FuuCBEWu+wHmZvNuyKhGFsrOMIq5BYWGNrKOP4/x3ud
         NhDZ2S0JFdiM2OW376xtF+6zl9PAySyPDQn5oYtE+GLCErgH91M4aMiINx1FNurRg9X3
         OsUAz5h9YlncieeCtymFCONHplRsLJLm6ycYP3SMKSWcYcQ9LIgMcegZU0j3TgGaf3Bj
         3r7Q==
X-Gm-Message-State: AOAM531WjLD7gueSBOyn2fhQ50CC4y0F/PzI+e0ukuvRFj/sQ9j6S6Ag
        aFVjatKGWlyE2eOtBM7/9cwUxFIb8AqS19yq
X-Google-Smtp-Source: ABdhPJwVKM+vj96eqK4VTyDaY3/CFbbTDL6HgNVnOPsFz6XH0fwqcQt20wY22a7T+nVV3DGR3UBeIw==
X-Received: by 2002:aa7:957b:: with SMTP id x27mr1410394pfq.177.1599099664525;
        Wed, 02 Sep 2020 19:21:04 -0700 (PDT)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id ie13sm663102pjb.5.2020.09.02.19.21.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2020 19:21:03 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/8] io_uring: split work handling part of SQPOLL into helper
Date:   Wed,  2 Sep 2020 20:20:50 -0600
Message-Id: <20200903022053.912968-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200903022053.912968-1-axboe@kernel.dk>
References: <20200903022053.912968-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is done in preparation for handling more than one ctx, but it also
cleans up the code a bit since io_sq_thread() was a bit too unwieldy to
get a get overview on.

__io_sq_thread() is now the main handler, and it returns an enum sq_ret
that tells io_sq_thread() what it ended up doing. The parent then makes
a decision on idle, spinning, or work handling based on that.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 183 ++++++++++++++++++++++++++------------------------
 1 file changed, 96 insertions(+), 87 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 95c81e0395d9..8ce1b4247120 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6625,114 +6625,123 @@ static int io_sq_wake_function(struct wait_queue_entry *wqe, unsigned mode,
 	return ret;
 }
 
-static int io_sq_thread(void *data)
+enum sq_ret {
+	SQT_IDLE	= 1,
+	SQT_SPIN	= 2,
+	SQT_DID_WORK	= 4,
+};
+
+static enum sq_ret __io_sq_thread(struct io_ring_ctx *ctx,
+				  unsigned long start_jiffies)
 {
-	struct io_ring_ctx *ctx = data;
-	const struct cred *old_cred;
-	unsigned long timeout;
+	unsigned long timeout = start_jiffies + ctx->sq_thread_idle;
+	unsigned int to_submit;
 	int ret = 0;
 
-	init_wait(&ctx->sqo_wait_entry);
-	ctx->sqo_wait_entry.func = io_sq_wake_function;
+again:
+	if (!list_empty(&ctx->iopoll_list)) {
+		unsigned nr_events = 0;
 
-	complete(&ctx->sq_thread_comp);
+		mutex_lock(&ctx->uring_lock);
+		if (!list_empty(&ctx->iopoll_list) && !need_resched())
+			io_do_iopoll(ctx, &nr_events, 0);
+		mutex_unlock(&ctx->uring_lock);
+	}
 
-	old_cred = override_creds(ctx->creds);
+	to_submit = io_sqring_entries(ctx);
 
-	task_lock(current);
-	current->files = ctx->sqo_files;
-	task_unlock(current);
+	/*
+	 * If submit got -EBUSY, flag us as needing the application
+	 * to enter the kernel to reap and flush events.
+	 */
+	if (!to_submit || ret == -EBUSY || need_resched()) {
+		/*
+		 * Drop cur_mm before scheduling, we can't hold it for
+		 * long periods (or over schedule()). Do this before
+		 * adding ourselves to the waitqueue, as the unuse/drop
+		 * may sleep.
+		 */
+		io_sq_thread_drop_mm();
 
-	timeout = jiffies + ctx->sq_thread_idle;
-	while (!kthread_should_park()) {
-		unsigned int to_submit;
+		/*
+		 * We're polling. If we're within the defined idle
+		 * period, then let us spin without work before going
+		 * to sleep. The exception is if we got EBUSY doing
+		 * more IO, we should wait for the application to
+		 * reap events and wake us up.
+		 */
+		if (!list_empty(&ctx->iopoll_list) || need_resched() ||
+		    (!time_after(start_jiffies, timeout) && ret != -EBUSY &&
+		    !percpu_ref_is_dying(&ctx->refs)))
+			return SQT_SPIN;
 
-		if (!list_empty(&ctx->iopoll_list)) {
-			unsigned nr_events = 0;
+		prepare_to_wait(ctx->sqo_wait, &ctx->sqo_wait_entry,
+					TASK_INTERRUPTIBLE);
 
-			mutex_lock(&ctx->uring_lock);
-			if (!list_empty(&ctx->iopoll_list) && !need_resched())
-				io_do_iopoll(ctx, &nr_events, 0);
-			else
-				timeout = jiffies + ctx->sq_thread_idle;
-			mutex_unlock(&ctx->uring_lock);
+		/*
+		 * While doing polled IO, before going to sleep, we need
+		 * to check if there are new reqs added to iopoll_list,
+		 * it is because reqs may have been punted to io worker
+		 * and will be added to iopoll_list later, hence check
+		 * the iopoll_list again.
+		 */
+		if ((ctx->flags & IORING_SETUP_IOPOLL) &&
+		    !list_empty_careful(&ctx->iopoll_list)) {
+			finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
+			goto again;
 		}
 
+		io_ring_set_wakeup_flag(ctx);
+
 		to_submit = io_sqring_entries(ctx);
+		if (!to_submit || ret == -EBUSY)
+			return SQT_IDLE;
 
-		/*
-		 * If submit got -EBUSY, flag us as needing the application
-		 * to enter the kernel to reap and flush events.
-		 */
-		if (!to_submit || ret == -EBUSY || need_resched()) {
-			/*
-			 * Drop cur_mm before scheduling, we can't hold it for
-			 * long periods (or over schedule()). Do this before
-			 * adding ourselves to the waitqueue, as the unuse/drop
-			 * may sleep.
-			 */
-			io_sq_thread_drop_mm();
+		finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
+		io_ring_clear_wakeup_flag(ctx);
+	}
 
-			/*
-			 * We're polling. If we're within the defined idle
-			 * period, then let us spin without work before going
-			 * to sleep. The exception is if we got EBUSY doing
-			 * more IO, we should wait for the application to
-			 * reap events and wake us up.
-			 */
-			if (!list_empty(&ctx->iopoll_list) || need_resched() ||
-			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
-			    !percpu_ref_is_dying(&ctx->refs))) {
-				io_run_task_work();
-				cond_resched();
-				continue;
-			}
+	mutex_lock(&ctx->uring_lock);
+	if (likely(!percpu_ref_is_dying(&ctx->refs)))
+		ret = io_submit_sqes(ctx, to_submit, NULL, -1);
+	mutex_unlock(&ctx->uring_lock);
+	return SQT_DID_WORK;
+}
 
-			prepare_to_wait(ctx->sqo_wait, &ctx->sqo_wait_entry,
-						TASK_INTERRUPTIBLE);
+static int io_sq_thread(void *data)
+{
+	struct io_ring_ctx *ctx = data;
+	const struct cred *old_cred;
+	unsigned long start_jiffies;
 
-			/*
-			 * While doing polled IO, before going to sleep, we need
-			 * to check if there are new reqs added to iopoll_list,
-			 * it is because reqs may have been punted to io worker
-			 * and will be added to iopoll_list later, hence check
-			 * the iopoll_list again.
-			 */
-			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
-			    !list_empty_careful(&ctx->iopoll_list)) {
-				finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
-				continue;
-			}
+	init_wait(&ctx->sqo_wait_entry);
+	ctx->sqo_wait_entry.func = io_sq_wake_function;
 
-			io_ring_set_wakeup_flag(ctx);
+	complete(&ctx->sq_thread_comp);
 
-			to_submit = io_sqring_entries(ctx);
-			if (!to_submit || ret == -EBUSY) {
-				if (kthread_should_park()) {
-					finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
-					break;
-				}
-				if (io_run_task_work()) {
-					finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
-					io_ring_clear_wakeup_flag(ctx);
-					continue;
-				}
-				schedule();
-				finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
+	old_cred = override_creds(ctx->creds);
 
-				ret = 0;
-				continue;
-			}
-			finish_wait(ctx->sqo_wait, &ctx->sqo_wait_entry);
+	task_lock(current);
+	current->files = ctx->sqo_files;
+	task_unlock(current);
 
-			io_ring_clear_wakeup_flag(ctx);
-		}
+	start_jiffies = jiffies;
+	while (!kthread_should_park()) {
+		enum sq_ret ret;
 
-		mutex_lock(&ctx->uring_lock);
-		if (likely(!percpu_ref_is_dying(&ctx->refs)))
-			ret = io_submit_sqes(ctx, to_submit, NULL, -1);
-		mutex_unlock(&ctx->uring_lock);
-		timeout = jiffies + ctx->sq_thread_idle;
+		ret = __io_sq_thread(ctx, start_jiffies);
+		switch (ret) {
+		case SQT_IDLE:
+			schedule();
+			start_jiffies = jiffies;
+			continue;
+		case SQT_SPIN:
+			io_run_task_work();
+			cond_resched();
+			fallthrough;
+		case SQT_DID_WORK:
+			continue;
+		}
 	}
 
 	io_run_task_work();
-- 
2.28.0

