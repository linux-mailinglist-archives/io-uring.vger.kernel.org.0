Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 755A631FD96
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:10:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbhBSRKf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:10:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhBSRKe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:10:34 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 225A4C061786
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:19 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id o7so5088782ils.2
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=glcflFMTPo+V4pr96KJi9y0ST7SMUT2v/hO8M62Kfuw=;
        b=x0W2Xv00uAwlc7DVMTPUw1Fr8dR2FvtQLMfbImp6MqQDtHZPtmnjj0UEy6HK4icXeC
         8pRq511Xlna8ZdfK06iYHU7gSEEuS/vaOKBKNMFC44+nabgKTN5VioA4I5iddeSSLnf0
         +Jsk+OV5PwCYy1Qsc4wpK6Q3Y+ubOvHvJrmoA3BH3sgwehu/XY1luTMXy3xRor+upU2i
         t0NF4xdg54DKi/Pu1QOUNTKB80pygOaeXJg3r25xrSakDnuUEZcBF9r2fF3u1kYvYvAx
         ZM4wsA3mxEAV5ogJ1SI1d4QKS2uzmgCfRdJH0tQ7XzLfvGqKZ254iqv8l7nD+IxpoUMW
         p4vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=glcflFMTPo+V4pr96KJi9y0ST7SMUT2v/hO8M62Kfuw=;
        b=MMGxU+59YdZiaJGkuwlXLsMe1YeZ24q2pCgLVqNTIDAGi0KnhS56/rRaDAT28WeVJp
         cNzlwBfWm18LZ4ngt/z7x9H1Nphi+7889fWn9m2Ei2xPLXoeql3cnQGDFH4pH3BzfiQD
         WYwMhvjqUwsc9X0Udah6Tl9fg0SJkH7xe3pJ1zgB9HuxugO6KQOallbZhEDJzE4v2uxW
         Vj1JkJuJT6JI8BfyBMLnpiD2WOGbjd5NO5mTw5yJPgpCLLzk4lTlSda/4trhrjjHyPYa
         OyMQukFRlBJ/Z7REsHJyPipyYhEQ6/AcSx5XfL/sZQgJK0Lk+cjsRgKaTJMMAgQAo5EG
         3okg==
X-Gm-Message-State: AOAM530/bSi7t9hnp2u42dgo2uDdgz8lgOhWMZWO25n7Jj04B3ec1nt3
        Ewfj0c0FKHFFzOENkzhZilPWVC2Ss/V7nMYY
X-Google-Smtp-Source: ABdhPJxWA4xrsHT6Jo8uo8bL8rel7irL9qwzl7JQLSCvcjivTGWJZELwJhbLbbFx2lPQ7rghMoUL9A==
X-Received: by 2002:a92:d80d:: with SMTP id y13mr4455184ilm.299.1613754618364;
        Fri, 19 Feb 2021 09:10:18 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:17 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/18] io_uring: remove the need for relying on an io-wq fallback worker
Date:   Fri, 19 Feb 2021 10:09:53 -0700
Message-Id: <20210219171010.281878-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We hit this case when the task is exiting, and we need somewhere to
do background cleanup of requests. Instead of relying on the io-wq
task manager to do this work for us, just stuff it somewhere where
we can safely run it ourselves directly.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 12 ------------
 fs/io-wq.h    |  2 --
 fs/io_uring.c | 38 +++++++++++++++++++++++++++++++++++---
 3 files changed, 35 insertions(+), 17 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index c36bbcd823ce..800b299f9772 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -16,7 +16,6 @@
 #include <linux/kthread.h>
 #include <linux/rculist_nulls.h>
 #include <linux/fs_struct.h>
-#include <linux/task_work.h>
 #include <linux/blk-cgroup.h>
 #include <linux/audit.h>
 #include <linux/cpu.h>
@@ -775,9 +774,6 @@ static int io_wq_manager(void *data)
 	complete(&wq->done);
 
 	while (!kthread_should_stop()) {
-		if (current->task_works)
-			task_work_run();
-
 		for_each_node(node) {
 			struct io_wqe *wqe = wq->wqes[node];
 			bool fork_worker[2] = { false, false };
@@ -800,9 +796,6 @@ static int io_wq_manager(void *data)
 		schedule_timeout(HZ);
 	}
 
-	if (current->task_works)
-		task_work_run();
-
 out:
 	if (refcount_dec_and_test(&wq->refs)) {
 		complete(&wq->done);
@@ -1160,11 +1153,6 @@ void io_wq_destroy(struct io_wq *wq)
 		__io_wq_destroy(wq);
 }
 
-struct task_struct *io_wq_get_task(struct io_wq *wq)
-{
-	return wq->manager;
-}
-
 static bool io_wq_worker_affinity(struct io_worker *worker, void *data)
 {
 	struct task_struct *task = worker->task;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 096f1021018e..a1610702f222 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -124,8 +124,6 @@ typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
 enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 					void *data, bool cancel_all);
 
-struct task_struct *io_wq_get_task(struct io_wq *wq);
-
 #if defined(CONFIG_IO_WQ)
 extern void io_wq_worker_sleeping(struct task_struct *);
 extern void io_wq_worker_running(struct task_struct *);
diff --git a/fs/io_uring.c b/fs/io_uring.c
index d951acb95117..bbd1ec7aa9e9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -455,6 +455,9 @@ struct io_ring_ctx {
 
 	struct io_restriction		restrictions;
 
+	/* exit task_work */
+	struct callback_head		*exit_task_work;
+
 	/* Keep this last, we don't need it for the fast path */
 	struct work_struct		exit_work;
 };
@@ -2313,11 +2316,14 @@ static int io_req_task_work_add(struct io_kiocb *req)
 static void io_req_task_work_add_fallback(struct io_kiocb *req,
 					  task_work_func_t cb)
 {
-	struct task_struct *tsk = io_wq_get_task(req->ctx->io_wq);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct callback_head *head;
 
 	init_task_work(&req->task_work, cb);
-	task_work_add(tsk, &req->task_work, TWA_NONE);
-	wake_up_process(tsk);
+	do {
+		head = ctx->exit_task_work;
+		req->task_work.next = head;
+	} while (cmpxchg(&ctx->exit_task_work, head, &req->task_work) != head);
 }
 
 static void __io_req_task_cancel(struct io_kiocb *req, int error)
@@ -9258,6 +9264,30 @@ void __io_uring_task_cancel(void)
 	io_uring_remove_task_files(tctx);
 }
 
+static void io_run_ctx_fallback(struct io_ring_ctx *ctx)
+{
+	struct callback_head *work, *head, *next;
+
+	do {
+		do {
+			head = NULL;
+			work = READ_ONCE(ctx->exit_task_work);
+			if (!work)
+				break;
+		} while (cmpxchg(&ctx->exit_task_work, work, head) != work);
+
+		if (!work)
+			break;
+
+		do {
+			next = work->next;
+			work->func(work);
+			work = next;
+			cond_resched();
+		} while (work);
+	} while (1);
+}
+
 static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_uring_task *tctx = current->io_uring;
@@ -9268,6 +9298,8 @@ static int io_uring_flush(struct file *file, void *data)
 		io_req_caches_free(ctx, current);
 	}
 
+	io_run_ctx_fallback(ctx);
+
 	if (!tctx)
 		return 0;
 
-- 
2.30.0

