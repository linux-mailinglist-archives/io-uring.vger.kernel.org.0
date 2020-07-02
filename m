Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75DE212FD9
	for <lists+io-uring@lfdr.de>; Fri,  3 Jul 2020 01:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726300AbgGBXG7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Jul 2020 19:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgGBXG7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Jul 2020 19:06:59 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35B71C08C5C1
        for <io-uring@vger.kernel.org>; Thu,  2 Jul 2020 16:06:59 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id f2so11880873plr.8
        for <io-uring@vger.kernel.org>; Thu, 02 Jul 2020 16:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=irUdtm/PJXc6nJdGhX7NwI/AazdF60y/Ld2NkkU5rus=;
        b=2TNGsGBs7DDlzx+k5PRiQnXKh7EjEnkwX6UDyUAY+ZojjqUPqWLfHLj5odTHBi1SMy
         TZg7dfjNPtpf5+Cd4eTsJquPWKyEe4V5UcKmBuFKoo75k6KEO/rBk6M/G+0KKTOpiB0y
         EYkTyjRqEnZOJbmrQSDvNw/x6vCxhEvbx8zKiLUG6y6LeyWY0KJaxtBRgdRYyTtOGxvJ
         GNkEAir5j5Co/YtOneqJSSeFxWQY961frd+sK3ax3ResCWMCSIMGnNUO9dPZHHTKZ8V6
         y/55jTcaRdt9c4Ol4ghvVqY1Klt8req7CemxDl6HKu+sAhA4av2BQxQydqduI6kAyuKT
         c9IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=irUdtm/PJXc6nJdGhX7NwI/AazdF60y/Ld2NkkU5rus=;
        b=rCzoWCtiL3Wfn1NY4uBhehvTTW8Q6fGoLZJHCDIfiuy9seU5AJqe7QrBcWkg4hgp35
         STaTbR+GP0EocDl+hPi+egL1uvJtaQHpYtK6j6V7yk5w8wzr2jCfRKQt6UktAQBolpaK
         0aRkHdL7IRSrWaHQ4PCBrf9KyGmJEWgUekeApcXT1OoYfXN6M6nypxNtpEw6fnCXz3Dg
         U9BQ3FJa8VAIrNnT9gF0V8yQ72ZClGe7uwjmxSPQEh28GPslmXc6BukSCOmstFmBYEPz
         mI/w9DWR5TXD0vTn2kDQdUa1OMs/OijgnZ9kqmgPrc5g6BgyE/NGBWUK/09LVcmwzX+w
         Tbvg==
X-Gm-Message-State: AOAM532P+a111omWFG2z9s5/aA2ufIUqGVuzu+CFM2z+0rTnGyVMJYyG
        eg096Cb1GcEmem03akG6PM3QRrXKACtn/w==
X-Google-Smtp-Source: ABdhPJySCtaav2MdW2HgvV01tBe0YEm3TylXPHamp3Ivil8BACiovRaxW5DqQNwsitoYbJLXjEeflA==
X-Received: by 2002:a17:902:7c87:: with SMTP id y7mr27661072pll.240.1593731218484;
        Thu, 02 Jul 2020 16:06:58 -0700 (PDT)
Received: from x1.mib2p ([204.156.180.104])
        by smtp.gmail.com with ESMTPSA id j36sm10024463pgj.39.2020.07.02.16.06.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jul 2020 16:06:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Oleg Nesterov <oleg@redhat.com>
Subject: [PATCH 1/2] io_uring: abstract out task work running
Date:   Thu,  2 Jul 2020 17:06:52 -0600
Message-Id: <20200702230653.1379419-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200702230653.1379419-1-axboe@kernel.dk>
References: <20200702230653.1379419-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Provide a helper to run task_work instead of checking and running
manually in a bunch of different spots. While doing so, also move the
task run state setting where we run the task work. Then we can move it
out of the callback helpers. This also helps ensure we only do this once
per task_work list run, not per task_work item.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a0c86c726ae3..982f49096580 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1714,7 +1714,6 @@ static void __io_req_task_submit(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
-	__set_current_state(TASK_RUNNING);
 	if (!__io_sq_thread_acquire_mm(ctx)) {
 		mutex_lock(&ctx->uring_lock);
 		__io_queue_sqe(req, NULL, NULL);
@@ -1899,6 +1898,17 @@ static int io_put_kbuf(struct io_kiocb *req)
 	return cflags;
 }
 
+static inline bool io_run_task_work(void)
+{
+	if (current->task_works) {
+		__set_current_state(TASK_RUNNING);
+		task_work_run();
+		return true;
+	}
+
+	return false;
+}
+
 static void io_iopoll_queue(struct list_head *again)
 {
 	struct io_kiocb *req;
@@ -2079,8 +2089,7 @@ static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
 		 */
 		if (!(++iters & 7)) {
 			mutex_unlock(&ctx->uring_lock);
-			if (current->task_works)
-				task_work_run();
+			io_run_task_work();
 			mutex_lock(&ctx->uring_lock);
 		}
 
@@ -2176,8 +2185,6 @@ static void io_rw_resubmit(struct callback_head *cb)
 	struct io_ring_ctx *ctx = req->ctx;
 	int err;
 
-	__set_current_state(TASK_RUNNING);
-
 	err = io_sq_thread_acquire_mm(ctx, req);
 
 	if (io_resubmit_prep(req, err)) {
@@ -6353,8 +6360,7 @@ static int io_sq_thread(void *data)
 			if (!list_empty(&ctx->poll_list) || need_resched() ||
 			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
 			    !percpu_ref_is_dying(&ctx->refs))) {
-				if (current->task_works)
-					task_work_run();
+				io_run_task_work();
 				cond_resched();
 				continue;
 			}
@@ -6386,8 +6392,7 @@ static int io_sq_thread(void *data)
 					finish_wait(&ctx->sqo_wait, &wait);
 					break;
 				}
-				if (current->task_works) {
-					task_work_run();
+				if (io_run_task_work()) {
 					finish_wait(&ctx->sqo_wait, &wait);
 					continue;
 				}
@@ -6412,8 +6417,7 @@ static int io_sq_thread(void *data)
 		timeout = jiffies + ctx->sq_thread_idle;
 	}
 
-	if (current->task_works)
-		task_work_run();
+	io_run_task_work();
 
 	io_sq_thread_drop_mm(ctx);
 	revert_creds(old_cred);
@@ -6478,9 +6482,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	do {
 		if (io_cqring_events(ctx, false) >= min_events)
 			return 0;
-		if (!current->task_works)
+		if (!io_run_task_work())
 			break;
-		task_work_run();
 	} while (1);
 
 	if (sig) {
@@ -6502,8 +6505,8 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 		prepare_to_wait_exclusive(&ctx->wait, &iowq.wq,
 						TASK_INTERRUPTIBLE);
 		/* make sure we run task_work before checking for signals */
-		if (current->task_works)
-			task_work_run();
+		if (io_run_task_work())
+			continue;
 		if (signal_pending(current)) {
 			ret = -ERESTARTSYS;
 			break;
@@ -7938,8 +7941,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	int submitted = 0;
 	struct fd f;
 
-	if (current->task_works)
-		task_work_run();
+	io_run_task_work();
 
 	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP))
 		return -EINVAL;
-- 
2.27.0

