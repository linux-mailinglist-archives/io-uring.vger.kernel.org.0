Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F7E3156D4
	for <lists+io-uring@lfdr.de>; Tue,  9 Feb 2021 20:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233538AbhBITaV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 14:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233341AbhBITFc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 14:05:32 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C3D2C0617A9
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 11:04:26 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id q7so19970508iob.0
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 11:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tn3nrWKoK4S/gl0B8R9NWXuUigN7IFyD9nNAEXxposs=;
        b=TlTX4qgGrG5VJgGpuklV9mywG8ADA0YonN84CjAmgfGGfMyvoupUfqHR2Z0nwKPg2b
         G8V5mijfqxno0Z5qJFTjYoYiDF2/xFqu9fYaz02nSc+W0OLxMQV1p1YXr5c/phSlS2lp
         8W3/+d0NcUReAOZlQ6MH9WgsuyhXdoElLGKAgrnttCYjeGnVT2cUUfV7U7jbnVuByEkd
         +RlVo/onAVYkNh4svgxGFuuzSleqC/d5mwLkahD7ndrL6RBETYW32fQzFLnjfWn+1JFx
         PT4EL+MaSIZITSjH8xTHl4oVd9JOgfMmx8mVHb6aqKjajC1V7ikER4NTDQ+8vV1z9qbb
         IZlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tn3nrWKoK4S/gl0B8R9NWXuUigN7IFyD9nNAEXxposs=;
        b=JGiGJXUJmAAMfTUZaVJN4ZX8Bd6AMQnZlFXYF0mhLTkqCTduZThlH6oSqD4hXAARB8
         vaCcqweqdcBO1xkUGH+UuOhipe59L7QccUZFhaXzAxWS/JXzGLskeqERzQtJWZdkCJ92
         c7IN1tYOpMKOpbcCFbWXG5ywkoLo3ZwkLwTd+R8ZyRLKa9GwOAiuhB6Ki8h92ZJ9VWi1
         We4DYueOVM4KLE/+jrr1kIUYAaxHA1cI1Br+OFdgi9imjOAH9ArxIcyBfYyPFL5kCvb4
         g+/dTCLArRsQQwaFZbwj+Z7f04eE9LgfF57xXfVynxUR9K3gWmp4ylwzBFQfcuXsKaNN
         Qw2A==
X-Gm-Message-State: AOAM532ZHiRzoWEgspzADjqIgg5lvx+t5oJLBVhLq5OgEXy+e8cyFif4
        6SCg5lEo7sdYsvv/xnA9RGTMOzkqZ1e2HSis
X-Google-Smtp-Source: ABdhPJyQ6wmMO8TIN81aa+gVPqVu30qxZr1Uj96OMAP6dgZzBFxiqdoYKLGpHA8tWJQok1av+Ku++w==
X-Received: by 2002:a02:a492:: with SMTP id d18mr23323645jam.11.1612897465140;
        Tue, 09 Feb 2021 11:04:25 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id i8sm10645554ilv.57.2021.02.09.11.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 11:04:24 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: provide FIFO ordering for task_work
Date:   Tue,  9 Feb 2021 12:04:17 -0700
Message-Id: <20210209190418.208827-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210209190418.208827-1-axboe@kernel.dk>
References: <20210209190418.208827-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

task_work is a LIFO list, due to how it's implemented as a lockless
list. For long chains of task_work, this can be problematic as the
first entry added is the last one processed. Similarly, we'd waste
a lot of CPU cycles reversing this list.

Wrap the task_work so we have a single task_work entry per task per
ctx, and use that to run it in the right order.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.h               |   9 ----
 fs/io_uring.c            | 101 ++++++++++++++++++++++++++++++++++++---
 include/linux/io_uring.h |  14 ++++++
 3 files changed, 108 insertions(+), 16 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index e37a0f217cc8..096f1021018e 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -27,15 +27,6 @@ enum io_wq_cancel {
 	IO_WQ_CANCEL_NOTFOUND,	/* work not found */
 };
 
-struct io_wq_work_node {
-	struct io_wq_work_node *next;
-};
-
-struct io_wq_work_list {
-	struct io_wq_work_node *first;
-	struct io_wq_work_node *last;
-};
-
 static inline void wq_list_add_after(struct io_wq_work_node *node,
 				     struct io_wq_work_node *pos,
 				     struct io_wq_work_list *list)
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 502bdef41460..5700b2f75364 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -717,6 +717,11 @@ struct async_poll {
 	struct io_poll_iocb	*double_poll;
 };
 
+struct io_task_work {
+	struct io_wq_work_node	node;
+	task_work_func_t	func;
+};
+
 /*
  * NOTE! Each of the iocb union members has the file pointer
  * as the first entry in their struct definition. So you can
@@ -775,7 +780,10 @@ struct io_kiocb {
 	 * 2. to track reqs with ->files (see io_op_def::file_table)
 	 */
 	struct list_head		inflight_entry;
-	struct callback_head		task_work;
+	union {
+		struct io_task_work	io_task_work;
+		struct callback_head	task_work;
+	};
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
 	struct async_poll		*apoll;
@@ -2150,6 +2158,81 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	return __io_req_find_next(req);
 }
 
+static bool __tctx_task_work(struct io_uring_task *tctx)
+{
+	struct io_wq_work_list list;
+	struct io_wq_work_node *node;
+
+	if (wq_list_empty(&tctx->task_list))
+		return false;
+
+	spin_lock(&tctx->task_lock);
+	list = tctx->task_list;
+	INIT_WQ_LIST(&tctx->task_list);
+	spin_unlock(&tctx->task_lock);
+
+	node = list.first;
+	while (node) {
+		struct io_wq_work_node *next = node->next;
+		struct io_kiocb *req;
+
+		req = container_of(node, struct io_kiocb, io_task_work.node);
+		req->task_work.func(&req->task_work);
+		node = next;
+	}
+
+	return list.first != NULL;
+}
+
+static void tctx_task_work(struct callback_head *cb)
+{
+	struct io_uring_task *tctx = container_of(cb, struct io_uring_task, task_work);
+
+	while (__tctx_task_work(tctx))
+		cond_resched();
+
+	clear_bit(0, &tctx->task_state);
+}
+
+static int io_task_work_add(struct task_struct *tsk, struct io_kiocb *req,
+			    enum task_work_notify_mode notify)
+{
+	struct io_uring_task *tctx = tsk->io_uring;
+	struct io_wq_work_node *node, *prev;
+	int ret;
+
+	WARN_ON_ONCE(!tctx);
+
+	spin_lock(&tctx->task_lock);
+	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
+	spin_unlock(&tctx->task_lock);
+
+	/* task_work already pending, we're done */
+	if (test_bit(0, &tctx->task_state) ||
+	    test_and_set_bit(0, &tctx->task_state))
+		return 0;
+
+	if (!task_work_add(tsk, &tctx->task_work, notify))
+		return 0;
+
+	/*
+	 * Slow path - we failed, find and delete work. if the work is not
+	 * in the list, it got run and we're fine.
+	 */
+	ret = 0;
+	spin_lock(&tctx->task_lock);
+	wq_list_for_each(node, prev, &tctx->task_list) {
+		if (&req->io_task_work.node == node) {
+			wq_list_del(&tctx->task_list, node, prev);
+			ret = 1;
+			break;
+		}
+	}
+	spin_unlock(&tctx->task_lock);
+	clear_bit(0, &tctx->task_state);
+	return ret;
+}
+
 static int io_req_task_work_add(struct io_kiocb *req)
 {
 	struct task_struct *tsk = req->task;
@@ -2170,7 +2253,7 @@ static int io_req_task_work_add(struct io_kiocb *req)
 	if (!(ctx->flags & IORING_SETUP_SQPOLL))
 		notify = TWA_SIGNAL;
 
-	ret = task_work_add(tsk, &req->task_work, notify);
+	ret = io_task_work_add(tsk, req, notify);
 	if (!ret)
 		wake_up_process(tsk);
 
@@ -2178,7 +2261,7 @@ static int io_req_task_work_add(struct io_kiocb *req)
 }
 
 static void io_req_task_work_add_fallback(struct io_kiocb *req,
-					  void (*cb)(struct callback_head *))
+					  task_work_func_t cb)
 {
 	struct task_struct *tsk = io_wq_get_task(req->ctx->io_wq);
 
@@ -2237,7 +2320,7 @@ static void io_req_task_queue(struct io_kiocb *req)
 {
 	int ret;
 
-	init_task_work(&req->task_work, io_req_task_submit);
+	req->task_work.func = io_req_task_submit;
 	percpu_ref_get(&req->ctx->refs);
 
 	ret = io_req_task_work_add(req);
@@ -2369,7 +2452,7 @@ static void io_free_req_deferred(struct io_kiocb *req)
 {
 	int ret;
 
-	init_task_work(&req->task_work, io_put_req_deferred_cb);
+	req->task_work.func = io_put_req_deferred_cb;
 	ret = io_req_task_work_add(req);
 	if (unlikely(ret))
 		io_req_task_work_add_fallback(req, io_put_req_deferred_cb);
@@ -3414,7 +3497,7 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	req->rw.kiocb.ki_flags &= ~IOCB_WAITQ;
 	list_del_init(&wait->entry);
 
-	init_task_work(&req->task_work, io_req_task_submit);
+	req->task_work.func = io_req_task_submit;
 	percpu_ref_get(&req->ctx->refs);
 
 	/* submit ref gets dropped, acquire a new one */
@@ -5113,7 +5196,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	list_del_init(&poll->wait.entry);
 
 	req->result = mask;
-	init_task_work(&req->task_work, func);
+	req->task_work.func = func;
 	percpu_ref_get(&req->ctx->refs);
 
 	/*
@@ -8120,6 +8203,10 @@ static int io_uring_alloc_task_context(struct task_struct *task)
 	io_init_identity(&tctx->__identity);
 	tctx->identity = &tctx->__identity;
 	task->io_uring = tctx;
+	spin_lock_init(&tctx->task_lock);
+	INIT_WQ_LIST(&tctx->task_list);
+	tctx->task_state = 0;
+	init_task_work(&tctx->task_work, tctx_task_work);
 	return 0;
 }
 
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 35b2d845704d..2eb6d19de336 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -22,6 +22,15 @@ struct io_identity {
 	refcount_t			count;
 };
 
+struct io_wq_work_node {
+	struct io_wq_work_node *next;
+};
+
+struct io_wq_work_list {
+	struct io_wq_work_node *first;
+	struct io_wq_work_node *last;
+};
+
 struct io_uring_task {
 	/* submission side */
 	struct xarray		xa;
@@ -32,6 +41,11 @@ struct io_uring_task {
 	struct io_identity	*identity;
 	atomic_t		in_idle;
 	bool			sqpoll;
+
+	spinlock_t		task_lock;
+	struct io_wq_work_list	task_list;
+	unsigned long		task_state;
+	struct callback_head	task_work;
 };
 
 #if defined(CONFIG_IO_URING)
-- 
2.30.0

