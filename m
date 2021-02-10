Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64C1A315B07
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235055AbhBJAU0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:20:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234010AbhBJALL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:11:11 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B55BC061356
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:30 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id 190so326340wmz.0
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5WdLqMSzMk14UeQwMOZaifw18/D7emd1xYdPamRV7Kw=;
        b=Jwnr0olc51ilYaofYhZ+8XKNhwJ9l4kcMhJb7YzHxftR78nVe84kFAUwvFzVuvhbbk
         rNz0/TXV/rwCrKNWMOhPqztk8Emukrm6p55hjUDjxBQcfg8GljoMPlenSDUhxwg10oXS
         GkCKs0FIlKGAZpOp8wpmq/t5kjYGZ0MIociQLXJfB6JdxdTZa3K7rubYuZv8/9n49T8s
         YaR0bGMTFRefeZfnQuBZFSmKuYtrMq601QoG+aqJ4y0PaXn0Ii9YhBc7AU2OsdUuOeeZ
         8SPj1Fl1Ev6DDNlQ2nEnkVompF1263dc8OnoUtHwFgUTcpccNJbHT0H8mFqc4UzlfWNM
         TKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5WdLqMSzMk14UeQwMOZaifw18/D7emd1xYdPamRV7Kw=;
        b=VXotoh/yNLbQ3LWPDfnpVseChEpWiSVOtqVrkY7OTIPRs4BbBPWs+fv0TwGOTdx3W4
         7kwgSzvDYr3hjfL3VAGTzd0WR2M8UufEeQiEpIYATiBz6o3lWnLUQ3SaFVWisF6Dlyze
         6/TrtxbmHCkKWiVCg9I5FdiU8UjkcBOTJ+/CnwHPn2703kzbhJln0x6pto/VFFivitAF
         ETQ2vzE/ifPF7x2h9Mnf/TTvhrMCSNiVwXaYRzHc64gJP7xL/Lp9H23h2jpD0BDALbpZ
         NBkKGZ7fUsD3UfS58qj65KPPhBEwRSGbUc61vrgWuXZm3NPG8dwWc0fpqvwtPmG9RV5o
         iUcQ==
X-Gm-Message-State: AOAM531q1W9Bkbupz+IwD4kioky8fLboMExLhcXSyXq456CNYhdC/H3w
        ts2wKSOD7QFk286BHqxH2PK/lj0x7+xfZQ==
X-Google-Smtp-Source: ABdhPJzq0CdMfzzih3+ejGZR+X9xuYf3DRp8WcY2yOLWS5r0t2BtxHboLcMFNEHuhZkGksuj+lI4Rw==
X-Received: by 2002:a05:600c:4ec7:: with SMTP id g7mr465881wmq.56.1612915648868;
        Tue, 09 Feb 2021 16:07:28 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:28 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 14/17] io_uring: provide FIFO ordering for task_work
Date:   Wed, 10 Feb 2021 00:03:20 +0000
Message-Id: <5c6b2f10b98c56abd3e4f78cd77f688feedad5ce.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

task_work is a LIFO list, due to how it's implemented as a lockless
list. For long chains of task_work, this can be problematic as the
first entry added is the last one processed. Similarly, we'd waste
a lot of CPU cycles reversing this list.

Wrap the task_work so we have a single task_work entry per task per
ctx, and use that to run it in the right order.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
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
index 58f150680c05..1d55ff827242 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -721,6 +721,11 @@ struct async_poll {
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
@@ -779,7 +784,10 @@ struct io_kiocb {
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
@@ -2130,6 +2138,81 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
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
@@ -2150,7 +2233,7 @@ static int io_req_task_work_add(struct io_kiocb *req)
 	if (!(ctx->flags & IORING_SETUP_SQPOLL))
 		notify = TWA_SIGNAL;
 
-	ret = task_work_add(tsk, &req->task_work, notify);
+	ret = io_task_work_add(tsk, req, notify);
 	if (!ret)
 		wake_up_process(tsk);
 
@@ -2158,7 +2241,7 @@ static int io_req_task_work_add(struct io_kiocb *req)
 }
 
 static void io_req_task_work_add_fallback(struct io_kiocb *req,
-					  void (*cb)(struct callback_head *))
+					  task_work_func_t cb)
 {
 	struct task_struct *tsk = io_wq_get_task(req->ctx->io_wq);
 
@@ -2217,7 +2300,7 @@ static void io_req_task_queue(struct io_kiocb *req)
 {
 	int ret;
 
-	init_task_work(&req->task_work, io_req_task_submit);
+	req->task_work.func = io_req_task_submit;
 	percpu_ref_get(&req->ctx->refs);
 
 	ret = io_req_task_work_add(req);
@@ -2348,7 +2431,7 @@ static void io_free_req_deferred(struct io_kiocb *req)
 {
 	int ret;
 
-	init_task_work(&req->task_work, io_put_req_deferred_cb);
+	req->task_work.func = io_put_req_deferred_cb;
 	ret = io_req_task_work_add(req);
 	if (unlikely(ret))
 		io_req_task_work_add_fallback(req, io_put_req_deferred_cb);
@@ -3393,7 +3476,7 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	req->rw.kiocb.ki_flags &= ~IOCB_WAITQ;
 	list_del_init(&wait->entry);
 
-	init_task_work(&req->task_work, io_req_task_submit);
+	req->task_work.func = io_req_task_submit;
 	percpu_ref_get(&req->ctx->refs);
 
 	/* submit ref gets dropped, acquire a new one */
@@ -5090,7 +5173,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	list_del_init(&poll->wait.entry);
 
 	req->result = mask;
-	init_task_work(&req->task_work, func);
+	req->task_work.func = func;
 	percpu_ref_get(&req->ctx->refs);
 
 	/*
@@ -8093,6 +8176,10 @@ static int io_uring_alloc_task_context(struct task_struct *task)
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
2.24.0

