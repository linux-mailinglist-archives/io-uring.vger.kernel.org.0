Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A054476571
	for <lists+io-uring@lfdr.de>; Wed, 15 Dec 2021 23:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbhLOWJJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Dec 2021 17:09:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhLOWJI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Dec 2021 17:09:08 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E11C061574
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:08 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id e3so80852820edu.4
        for <io-uring@vger.kernel.org>; Wed, 15 Dec 2021 14:09:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dMBLplRfdSNcxu2PigdLiW0W4SYDXcu0x/DjPErUjZ0=;
        b=HGvF2p+J9ZtvH7AVwzhjX+vhVZn36Mr/o7HO/DCqC+TZ+cct+92og33XPPU8TqNE3I
         JIwXplVmnIngQXO9Oe+MtAzUwwOdMROVPilYy62JWv2uLXcvduP1IUNXD0sMX2AoxZCK
         q+QTx0K+DcGuk0s/dJ0pXeHku+BxI4KZWjaSLufpWvp/NB6tmlUcHA/+E3xBL7jl+I31
         VP+KSLmcZnFiSHJLxePQhpehNirD1vyyE0kbkKl3D9/slT/upG8zTCUx3J8y/ZYjOepu
         0XyrOsnhefsm2I0H2RRNOTKzZvY0/j1aLYxN7CJm21zL3H+h4ZlUjgtEX1CK3gKIZ10H
         bz/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dMBLplRfdSNcxu2PigdLiW0W4SYDXcu0x/DjPErUjZ0=;
        b=l+kagb4khQzIVmm4GGb+qiCJIskLNp6e2hoX0NvCheq6GBDVDkcNqnskDDvZahOyOC
         tTpXlQFbLxbppOouZydFbK3uZu0BRWfi16RhVuzt4JVoVtVnWTF41ffA5H/rDx82DGKw
         tZ4a7c7B9kAWg4/mxymoGuWkqwuDX6PJV8iK9m1foshSrHKWPBbBW2vOCDYkAi0YZEEB
         2TREbCnY/YzdAWFRfst5lophut22E0UZ4kOUPFjSQZJaJSs7XoTcq4RaxL2KIUWFCekh
         1iu+hz8TiwV2Fkv96k0hF2HmE5iagAasWyLMFAlpGQDm82cvYeqT/yhgCCFYW8UJ/DaP
         Hj1g==
X-Gm-Message-State: AOAM530l8VDqjQCGiM/0WHMfTDhhw9lgE9Z4zIrWTt2HX96cPtzFzB7S
        zj9emHf0yWFxB271oBh1oy158W/gV6o=
X-Google-Smtp-Source: ABdhPJznd0KgcJOHPrVs844aPSeRCU9pGYgRNq7VQelm9x9G6+5689oF6i8BFbO8+ofOWPDKxu3aGg==
X-Received: by 2002:a17:907:1b06:: with SMTP id mp6mr13246526ejc.275.1639606146078;
        Wed, 15 Dec 2021 14:09:06 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.129.75])
        by smtp.gmail.com with ESMTPSA id l16sm1572006edb.59.2021.12.15.14.09.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 14:09:05 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH 5/7] io_uring: poll rework
Date:   Wed, 15 Dec 2021 22:08:48 +0000
Message-Id: <6b652927c77ed9580ea4330ac5612f0e0848c946.1639605189.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1639605189.git.asml.silence@gmail.com>
References: <cover.1639605189.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It's not possible to go forward with the current state of io_uring
polling, we need a more straightforward and easier synchronisation.
There are a lot of problems with how it is at the moment, including
missing events on rewait.

The main idea here is to introduce a notion of request ownership while
polling, no one but the owner can modify any part but ->poll_refs of
struct io_kiocb, that grants us protection against all sorts of races.

Main users of such exclusivity are poll task_work handler, so before
queueing a tw one should have/acquire ownership, which will be handed
off to the tw handler.
The other user is __io_arm_poll_handler() do initial poll arming. It
starts taking the ownership, so tw handlers won't be run until it's
released later in the function after vfs_poll. note: also prevents
races in __io_queue_proc().
Poll wake/etc. may not be able to get ownership, then they need to
increase the poll refcount and the task_work should notice it and retry
if necessary, see io_poll_check_events().
There is also IO_POLL_CANCEL_FLAG flag to notify that we want to kill
request.

It makes cancellations more reliable, enables double multishot polling,
fixes double poll rewait, fixes missing poll events and fixes another
bunch of races.

Even though it adds some overhead for new refcounting, and there are a
couple of nice performance wins:
- no req->refs refcounting for poll requests anymore
- if the data is already there (once measured for some test to be 1-2%
  of all apoll requests), it removes it doesn't add atomics and removes
  spin_lock/unlock pair.
- works well with multishots, we don't do remove from queue / add to
  queue for each new poll event.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 526 ++++++++++++++++++++++----------------------------
 1 file changed, 227 insertions(+), 299 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9a2b3cf7c0c5..d59d3fa93c9c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -487,8 +487,6 @@ struct io_poll_iocb {
 	struct file			*file;
 	struct wait_queue_head		*head;
 	__poll_t			events;
-	bool				done;
-	bool				canceled;
 	struct wait_queue_entry		wait;
 };
 
@@ -892,6 +890,7 @@ struct io_kiocb {
 	const struct cred		*creds;
 	/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 	struct io_buffer		*kbuf;
+	atomic_t			poll_refs;
 };
 
 struct io_tctx_node {
@@ -5353,6 +5352,25 @@ struct io_poll_table {
 	int error;
 };
 
+#define IO_POLL_CANCEL_FLAG	BIT(31)
+#define IO_POLL_REF_MASK	((1u << 20)-1)
+
+/*
+ * If refs part of ->poll_refs (see IO_POLL_REF_MASK) is 0, it's free. We can
+ * bump it and acquire ownership. It's disallowed to modify requests while not
+ * owning it, that prevents from races for enqueueing task_work's and b/w
+ * arming poll and wakeups.
+ */
+static inline bool io_poll_get_ownership(struct io_kiocb *req)
+{
+	return !(atomic_fetch_inc(&req->poll_refs) & IO_POLL_REF_MASK);
+}
+
+static void io_poll_mark_cancelled(struct io_kiocb *req)
+{
+	atomic_or(IO_POLL_CANCEL_FLAG, &req->poll_refs);
+}
+
 static struct io_poll_iocb *io_poll_get_double(struct io_kiocb *req)
 {
 	/* pure poll stashes this in ->async_data, poll driven retry elsewhere */
@@ -5381,8 +5399,6 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 			      wait_queue_func_t wake_func)
 {
 	poll->head = NULL;
-	poll->done = false;
-	poll->canceled = false;
 #define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
 	/* mask in events that we always want/need */
 	poll->events = events | IO_POLL_UNMASK;
@@ -5390,161 +5406,170 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 	init_waitqueue_func_entry(&poll->wait, wake_func);
 }
 
-static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
-			   __poll_t mask, io_req_tw_func_t func)
+static inline void io_poll_remove_entry(struct io_poll_iocb *poll)
 {
-	/* for instances that support it check for an event match first: */
-	if (mask && !(mask & poll->events))
-		return 0;
-
-	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
+	struct wait_queue_head *head = poll->head;
 
+	spin_lock_irq(&head->lock);
 	list_del_init(&poll->wait.entry);
+	poll->head = NULL;
+	spin_unlock_irq(&head->lock);
+}
 
-	req->result = mask;
-	req->io_task_work.func = func;
+static void io_poll_remove_entries(struct io_kiocb *req)
+{
+	struct io_poll_iocb *poll = io_poll_get_single(req);
+	struct io_poll_iocb *poll_double = io_poll_get_double(req);
 
-	/*
-	 * If this fails, then the task is exiting. When a task exits, the
-	 * work gets canceled, so just cancel this request as well instead
-	 * of executing it. We can't safely execute it anyway, as we may not
-	 * have the needed state needed for it anyway.
-	 */
-	io_req_task_work_add(req, false);
-	return 1;
+	if (poll->head)
+		io_poll_remove_entry(poll);
+	if (poll_double && poll_double->head)
+		io_poll_remove_entry(poll_double);
 }
 
-static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
-	__acquires(&req->ctx->completion_lock)
+/*
+ * All poll tw should go through this. Checks for poll events, manages
+ * references, does rewait, etc.
+ *
+ * Returns a negative error on failure. >0 when no action require, which is
+ * either spurious wakeup or multishot CQE is served. 0 when it's done with
+ * the request, then the mask is stored in req->result.
+ */
+static int io_poll_check_events(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	struct io_poll_iocb *poll = io_poll_get_single(req);
+	int v;
 
 	/* req->task == current here, checking PF_EXITING is safe */
 	if (unlikely(req->task->flags & PF_EXITING))
-		WRITE_ONCE(poll->canceled, true);
+		io_poll_mark_cancelled(req);
 
-	if (!req->result && !READ_ONCE(poll->canceled)) {
-		struct poll_table_struct pt = { ._key = poll->events };
+	do {
+		v = atomic_read(&req->poll_refs);
 
-		req->result = vfs_poll(req->file, &pt) & poll->events;
-	}
+		/* tw handler should be the owner, and so have some references */
+		if (WARN_ON_ONCE(!(v & IO_POLL_REF_MASK)))
+			return 0;
+		if (v & IO_POLL_CANCEL_FLAG)
+			return -ECANCELED;
 
-	spin_lock(&ctx->completion_lock);
-	if (!req->result && !READ_ONCE(poll->canceled)) {
-		add_wait_queue(poll->head, &poll->wait);
-		return true;
-	}
+		if (!req->result) {
+			struct poll_table_struct pt = { ._key = poll->events };
 
-	return false;
-}
+			req->result = vfs_poll(req->file, &pt) & poll->events;
+		}
 
-static void io_poll_remove_double(struct io_kiocb *req)
-	__must_hold(&req->ctx->completion_lock)
-{
-	struct io_poll_iocb *poll = io_poll_get_double(req);
+		/* multishot, just fill an CQE and proceed */
+		if (req->result && !(poll->events & EPOLLONESHOT)) {
+			__poll_t mask = mangle_poll(req->result & poll->events);
+			bool filled;
 
-	lockdep_assert_held(&req->ctx->completion_lock);
+			spin_lock(&ctx->completion_lock);
+			filled = io_fill_cqe_aux(ctx, req->user_data, mask,
+						 IORING_CQE_F_MORE);
+			io_commit_cqring(ctx);
+			spin_unlock(&ctx->completion_lock);
+			if (unlikely(!filled))
+				return -ECANCELED;
+			io_cqring_ev_posted(ctx);
+		} else if (req->result) {
+			return 0;
+		}
 
-	if (poll && poll->head) {
-		struct wait_queue_head *head = poll->head;
+		/*
+		 * Release all references, retry if someone tried to restart
+		 * task_work while we were executing it.
+		 */
+	} while (atomic_sub_return(v & IO_POLL_REF_MASK, &req->poll_refs));
 
-		spin_lock_irq(&head->lock);
-		list_del_init(&poll->wait.entry);
-		if (poll->wait.private)
-			req_ref_put(req);
-		poll->head = NULL;
-		spin_unlock_irq(&head->lock);
-	}
+	return 1;
 }
 
-static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
-	__must_hold(&req->ctx->completion_lock)
+static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned flags = IORING_CQE_F_MORE;
-	int error;
+	int ret;
 
-	if (READ_ONCE(req->poll.canceled)) {
-		error = -ECANCELED;
-		req->poll.events |= EPOLLONESHOT;
+	ret = io_poll_check_events(req);
+	if (ret > 0)
+		return;
+
+	if (!ret) {
+		req->result = mangle_poll(req->result & req->poll.events);
 	} else {
-		error = mangle_poll(mask);
+		req->result = ret;
+		req_set_fail(req);
 	}
-	if (req->poll.events & EPOLLONESHOT)
-		flags = 0;
 
-	if (!(flags & IORING_CQE_F_MORE)) {
-		io_fill_cqe_req(req, error, flags);
-	} else if (!io_fill_cqe_aux(ctx, req->user_data, error, flags)) {
-		req->poll.events |= EPOLLONESHOT;
-		flags = 0;
-	}
-	return !(flags & IORING_CQE_F_MORE);
+	io_poll_remove_entries(req);
+	spin_lock(&ctx->completion_lock);
+	hash_del(&req->hash_node);
+	__io_req_complete_post(req, req->result, 0);
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
 }
 
-static void io_poll_task_func(struct io_kiocb *req, bool *locked)
+static void io_apoll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
 
-	if (io_poll_rewait(req, &req->poll)) {
-		spin_unlock(&ctx->completion_lock);
-	} else {
-		bool done;
+	ret = io_poll_check_events(req);
+	if (ret > 0)
+		return;
 
-		if (req->poll.done) {
-			spin_unlock(&ctx->completion_lock);
-			return;
-		}
-		done = __io_poll_complete(req, req->result);
-		if (done) {
-			io_poll_remove_double(req);
-			hash_del(&req->hash_node);
-			req->poll.done = true;
-		} else {
-			req->result = 0;
-			add_wait_queue(req->poll.head, &req->poll.wait);
-		}
-		io_commit_cqring(ctx);
-		spin_unlock(&ctx->completion_lock);
-		io_cqring_ev_posted(ctx);
+	io_poll_remove_entries(req);
+	spin_lock(&ctx->completion_lock);
+	hash_del(&req->hash_node);
+	spin_unlock(&ctx->completion_lock);
 
-		if (done)
-			io_put_req(req);
-	}
+	if (!ret)
+		io_req_task_submit(req, locked);
+	else
+		io_req_complete_failed(req, ret);
 }
 
-static int io_poll_double_wake(struct wait_queue_entry *wait, unsigned mode,
-			       int sync, void *key)
+static void __io_poll_execute(struct io_kiocb *req, int mask)
+{
+	req->result = mask;
+	if (req->opcode == IORING_OP_POLL_ADD)
+		req->io_task_work.func = io_poll_task_func;
+	else
+		req->io_task_work.func = io_apoll_task_func;
+
+	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
+	io_req_task_work_add(req, false);
+}
+
+static inline void io_poll_execute(struct io_kiocb *req, int res)
+{
+	if (io_poll_get_ownership(req))
+		__io_poll_execute(req, res);
+}
+
+static void io_poll_cancel_req(struct io_kiocb *req)
+{
+	io_poll_mark_cancelled(req);
+	/* kick tw, which should complete the request */
+	io_poll_execute(req, 0);
+}
+
+static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
+			void *key)
 {
 	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = io_poll_get_single(req);
+	struct io_poll_iocb *poll = container_of(wait, struct io_poll_iocb,
+						 wait);
 	__poll_t mask = key_to_poll(key);
-	unsigned long flags;
 
-	/* for instances that support it check for an event match first: */
+	/* for instances that support it check for an event match first */
 	if (mask && !(mask & poll->events))
 		return 0;
-	if (!(poll->events & EPOLLONESHOT))
-		return poll->wait.func(&poll->wait, mode, sync, key);
 
-	list_del_init(&wait->entry);
-
-	if (poll->head) {
-		bool done;
-
-		spin_lock_irqsave(&poll->head->lock, flags);
-		done = list_empty(&poll->wait.entry);
-		if (!done)
-			list_del_init(&poll->wait.entry);
-		/* make sure double remove sees this as being gone */
-		wait->private = NULL;
-		spin_unlock_irqrestore(&poll->head->lock, flags);
-		if (!done) {
-			/* use wait func handler, so it matches the rq type */
-			poll->wait.func(&poll->wait, mode, sync, key);
-		}
-	}
-	req_ref_put(req);
+	if (io_poll_get_ownership(req))
+		__io_poll_execute(req, mask);
 	return 1;
 }
 
@@ -5560,10 +5585,10 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 	 * if this happens.
 	 */
 	if (unlikely(pt->nr_entries)) {
-		struct io_poll_iocb *poll_one = poll;
+		struct io_poll_iocb *first = poll;
 
 		/* double add on the same waitqueue head, ignore */
-		if (poll_one->head == head)
+		if (first->head == head)
 			return;
 		/* already have a 2nd entry, fail a third attempt */
 		if (*poll_ptr) {
@@ -5572,21 +5597,13 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			pt->error = -EINVAL;
 			return;
 		}
-		/*
-		 * Can't handle multishot for double wait for now, turn it
-		 * into one-shot mode.
-		 */
-		if (!(poll_one->events & EPOLLONESHOT))
-			poll_one->events |= EPOLLONESHOT;
+
 		poll = kmalloc(sizeof(*poll), GFP_ATOMIC);
 		if (!poll) {
 			pt->error = -ENOMEM;
 			return;
 		}
-		io_init_poll_iocb(poll, poll_one->events, io_poll_double_wake);
-		req_ref_get(req);
-		poll->wait.private = req;
-
+		io_init_poll_iocb(poll, first->events, first->wait.func);
 		*poll_ptr = poll;
 		if (req->opcode == IORING_OP_POLL_ADD)
 			req->flags |= REQ_F_ASYNC_DATA;
@@ -5594,6 +5611,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 
 	pt->nr_entries++;
 	poll->head = head;
+	poll->wait.private = req;
 
 	if (poll->events & EPOLLEXCLUSIVE)
 		add_wait_queue_exclusive(head, &poll->wait);
@@ -5601,61 +5619,24 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 		add_wait_queue(head, &poll->wait);
 }
 
-static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
+static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 			       struct poll_table_struct *p)
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
-	struct async_poll *apoll = pt->req->apoll;
 
-	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
+	__io_queue_proc(&pt->req->poll, pt, head,
+			(struct io_poll_iocb **) &pt->req->async_data);
 }
 
-static void io_async_task_func(struct io_kiocb *req, bool *locked)
+static int __io_arm_poll_handler(struct io_kiocb *req,
+				 struct io_poll_iocb *poll,
+				 struct io_poll_table *ipt, __poll_t mask)
 {
-	struct async_poll *apoll = req->apoll;
 	struct io_ring_ctx *ctx = req->ctx;
-
-	trace_io_uring_task_run(req->ctx, req, req->opcode, req->user_data);
-
-	if (io_poll_rewait(req, &apoll->poll)) {
-		spin_unlock(&ctx->completion_lock);
-		return;
-	}
-
-	hash_del(&req->hash_node);
-	io_poll_remove_double(req);
-	apoll->poll.done = true;
-	spin_unlock(&ctx->completion_lock);
-
-	if (!READ_ONCE(apoll->poll.canceled))
-		io_req_task_submit(req, locked);
-	else
-		io_req_complete_failed(req, -ECANCELED);
-}
-
-static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
-			void *key)
-{
-	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = &req->apoll->poll;
-
-	trace_io_uring_poll_wake(req->ctx, req->opcode, req->user_data,
-					key_to_poll(key));
-
-	return __io_async_wake(req, poll, key_to_poll(key), io_async_task_func);
-}
-
-static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
-				      struct io_poll_iocb *poll,
-				      struct io_poll_table *ipt, __poll_t mask,
-				      wait_queue_func_t wake_func)
-	__acquires(&ctx->completion_lock)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	bool cancel = false;
+	int v;
 
 	INIT_HLIST_NODE(&req->hash_node);
-	io_init_poll_iocb(poll, mask, wake_func);
+	io_init_poll_iocb(poll, mask, io_poll_wake);
 	poll->file = req->file;
 	poll->wait.private = req;
 
@@ -5664,31 +5645,54 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 	ipt->error = 0;
 	ipt->nr_entries = 0;
 
+	/*
+	 * Take the ownership to delay any tw execution up until we're done
+	 * with poll arming. see io_poll_get_ownership().
+	 */
+	atomic_set(&req->poll_refs, 1);
 	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
-	if (unlikely(!ipt->nr_entries) && !ipt->error)
-		ipt->error = -EINVAL;
+
+	if (mask && (poll->events & EPOLLONESHOT)) {
+		io_poll_remove_entries(req);
+		/* no one else has access to the req, forget about the ref */
+		return mask;
+	}
+	if (!mask && unlikely(ipt->error || !ipt->nr_entries)) {
+		io_poll_remove_entries(req);
+		if (!ipt->error)
+			ipt->error = -EINVAL;
+		return 0;
+	}
 
 	spin_lock(&ctx->completion_lock);
-	if (ipt->error || (mask && (poll->events & EPOLLONESHOT)))
-		io_poll_remove_double(req);
-	if (likely(poll->head)) {
-		spin_lock_irq(&poll->head->lock);
-		if (unlikely(list_empty(&poll->wait.entry))) {
-			if (ipt->error)
-				cancel = true;
-			ipt->error = 0;
-			mask = 0;
-		}
-		if ((mask && (poll->events & EPOLLONESHOT)) || ipt->error)
-			list_del_init(&poll->wait.entry);
-		else if (cancel)
-			WRITE_ONCE(poll->canceled, true);
-		else if (!poll->done) /* actually waiting for an event */
-			io_poll_req_insert(req);
-		spin_unlock_irq(&poll->head->lock);
+	io_poll_req_insert(req);
+	spin_unlock(&ctx->completion_lock);
+
+	if (mask) {
+		/* can't multishot if failed, just queue the event we've got */
+		if (unlikely(ipt->error || !ipt->nr_entries))
+			poll->events |= EPOLLONESHOT;
+		__io_poll_execute(req, mask);
+		return 0;
 	}
 
-	return mask;
+	/*
+	 * Release ownership. If someone tried to queue a tw while it was
+	 * locked, kick it off for them.
+	 */
+	v = atomic_dec_return(&req->poll_refs);
+	if (unlikely(v & IO_POLL_REF_MASK))
+		__io_poll_execute(req, 0);
+	return 0;
+}
+
+static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
+			       struct poll_table_struct *p)
+{
+	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
+	struct async_poll *apoll = pt->req->apoll;
+
+	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
 }
 
 enum {
@@ -5703,7 +5707,8 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct async_poll *apoll;
 	struct io_poll_table ipt;
-	__poll_t ret, mask = EPOLLONESHOT | POLLERR | POLLPRI;
+	__poll_t mask = EPOLLONESHOT | POLLERR | POLLPRI;
+	int ret;
 
 	if (!def->pollin && !def->pollout)
 		return IO_APOLL_ABORTED;
@@ -5728,11 +5733,8 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	req->apoll = apoll;
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
-	io_req_set_refcount(req);
 
-	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
-					io_async_wake);
-	spin_unlock(&ctx->completion_lock);
+	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask);
 	if (ret || ipt.error)
 		return ret ? IO_APOLL_READY : IO_APOLL_ABORTED;
 
@@ -5741,43 +5743,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	return IO_APOLL_OK;
 }
 
-static bool __io_poll_remove_one(struct io_kiocb *req,
-				 struct io_poll_iocb *poll, bool do_cancel)
-	__must_hold(&req->ctx->completion_lock)
-{
-	bool do_complete = false;
-
-	if (!poll->head)
-		return false;
-	spin_lock_irq(&poll->head->lock);
-	if (do_cancel)
-		WRITE_ONCE(poll->canceled, true);
-	if (!list_empty(&poll->wait.entry)) {
-		list_del_init(&poll->wait.entry);
-		do_complete = true;
-	}
-	spin_unlock_irq(&poll->head->lock);
-	hash_del(&req->hash_node);
-	return do_complete;
-}
-
-static bool io_poll_remove_one(struct io_kiocb *req)
-	__must_hold(&req->ctx->completion_lock)
-{
-	bool do_complete;
-
-	io_poll_remove_double(req);
-	do_complete = __io_poll_remove_one(req, io_poll_get_single(req), true);
-
-	if (do_complete) {
-		req_set_fail(req);
-		io_fill_cqe_req(req, -ECANCELED, 0);
-		io_commit_cqring(req->ctx);
-		io_put_req_deferred(req);
-	}
-	return do_complete;
-}
-
 /*
  * Returns true if we found and killed one or more poll requests
  */
@@ -5786,7 +5751,8 @@ static __cold bool io_poll_remove_all(struct io_ring_ctx *ctx,
 {
 	struct hlist_node *tmp;
 	struct io_kiocb *req;
-	int posted = 0, i;
+	bool found = false;
+	int i;
 
 	spin_lock(&ctx->completion_lock);
 	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
@@ -5794,16 +5760,14 @@ static __cold bool io_poll_remove_all(struct io_ring_ctx *ctx,
 
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
-			if (io_match_task(req, tsk, cancel_all))
-				posted += io_poll_remove_one(req);
+			if (io_match_task(req, tsk, cancel_all)) {
+				io_poll_cancel_req(req);
+				found = true;
+			}
 		}
 	}
 	spin_unlock(&ctx->completion_lock);
-
-	if (posted)
-		io_cqring_ev_posted(ctx);
-
-	return posted != 0;
+	return found;
 }
 
 static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr,
@@ -5824,19 +5788,26 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, __u64 sqe_addr,
 	return NULL;
 }
 
+static bool io_poll_disarm(struct io_kiocb *req)
+	__must_hold(&ctx->completion_lock)
+{
+	if (!io_poll_get_ownership(req))
+		return false;
+	io_poll_remove_entries(req);
+	hash_del(&req->hash_node);
+	return true;
+}
+
 static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr,
 			  bool poll_only)
 	__must_hold(&ctx->completion_lock)
 {
-	struct io_kiocb *req;
+	struct io_kiocb *req = io_poll_find(ctx, sqe_addr, poll_only);
 
-	req = io_poll_find(ctx, sqe_addr, poll_only);
 	if (!req)
 		return -ENOENT;
-	if (io_poll_remove_one(req))
-		return 0;
-
-	return -EALREADY;
+	io_poll_cancel_req(req);
+	return 0;
 }
 
 static __poll_t io_poll_parse_events(const struct io_uring_sqe *sqe,
@@ -5886,23 +5857,6 @@ static int io_poll_update_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
-			void *key)
-{
-	struct io_kiocb *req = wait->private;
-	struct io_poll_iocb *poll = &req->poll;
-
-	return __io_async_wake(req, poll, key_to_poll(key), io_poll_task_func);
-}
-
-static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
-			       struct poll_table_struct *p)
-{
-	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
-
-	__io_queue_proc(&pt->req->poll, pt, head, (struct io_poll_iocb **) &pt->req->async_data);
-}
-
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_poll_iocb *poll = &req->poll;
@@ -5926,57 +5880,31 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 static int io_poll_add(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_poll_iocb *poll = &req->poll;
-	struct io_ring_ctx *ctx = req->ctx;
 	struct io_poll_table ipt;
-	__poll_t mask;
-	bool done;
+	int ret;
 
 	ipt.pt._qproc = io_poll_queue_proc;
 
-	mask = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events,
-					io_poll_wake);
-
-	if (mask) { /* no async, we'd stolen it */
-		ipt.error = 0;
-		done = __io_poll_complete(req, mask);
-		io_commit_cqring(req->ctx);
-	}
-	spin_unlock(&ctx->completion_lock);
-
-	if (mask) {
-		io_cqring_ev_posted(ctx);
-		if (done)
-			io_put_req(req);
-	}
-	return ipt.error;
+	ret = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events);
+	ret = ret ?: ipt.error;
+	if (ret)
+		__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
 }
 
 static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *preq;
-	bool completing;
 	int ret2, ret = 0;
 
 	spin_lock(&ctx->completion_lock);
 	preq = io_poll_find(ctx, req->poll_update.old_user_data, true);
-	if (!preq) {
-		ret = -ENOENT;
-fail:
+	if (!preq || !io_poll_disarm(preq)) {
 		spin_unlock(&ctx->completion_lock);
+		ret = preq ? -EALREADY : -ENOENT;
 		goto out;
 	}
-	io_poll_remove_double(preq);
-	/*
-	 * Don't allow racy completion with singleshot, as we cannot safely
-	 * update those. For multishot, if we're racing with completion, just
-	 * let completion re-add it.
-	 */
-	completing = !__io_poll_remove_one(preq, &preq->poll, false);
-	if (completing && (preq->poll.events & EPOLLONESHOT)) {
-		ret = -EALREADY;
-		goto fail;
-	}
 	spin_unlock(&ctx->completion_lock);
 
 	if (req->poll_update.update_events || req->poll_update.update_user_data) {
-- 
2.34.0

