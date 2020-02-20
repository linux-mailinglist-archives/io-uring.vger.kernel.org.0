Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCABF166861
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 21:32:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgBTUcH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 15:32:07 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39505 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbgBTUcH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 15:32:07 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so1995567plp.6
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 12:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SBZGLAJOXpeWNydqcmggx/Oh6GJI/F6yxDt2U03vmLQ=;
        b=yiGTPHg7oHnMTyO4YDHsbpCO25HepxkxJ3j8n8JP0pb5usd+4TSN+LpDsZ0XC4wnWW
         Ux1GZck2XZBidEg0SRSMFJAnOfe14xOCl3M7jqxEDHVai5ASGaq/XyDBpVMktpfigwo1
         DR+wb7q3BuPK0A+lK6lbdomsngkLhYmfbAWN031qQdFtk3uFGZ28BQeKc3aTfFrxJtFd
         saYoqqDoJxiO/fRRb3IswYt8jjmZYaDjojZangnxWfweV619UP9Z2/D7vhaEsv+ieFjK
         dv93lgIvnXIlv8mFBn9F4CFwfStRCLZOhYMVPvTXqv6ZsgTfFk4kyGphsEkpDRfI6QWw
         qlpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SBZGLAJOXpeWNydqcmggx/Oh6GJI/F6yxDt2U03vmLQ=;
        b=D9JWUpELibXb+HCzKnf3zEdDbU+gnHMu09/yopNy1hKFDfNfOG199bTieAtECubb+Z
         iexLKsWztN2lfTavo6rXQk1UNOpkeFrIpjAbC8DYahdTDZZiTHwA2jLBHHoBCAteOnfD
         h59XPVkKpLi4mxS2z9N7BkiXYOWG3jG7EGjwB/3K8FXyw60lmHl5LaAyQW6uyjf+vDGy
         UW2i5ppOnFO7/3eO4BzePGO6U8Pt3IQ0CKSR5kyb5890tpk8GK90w/PP3/4it1T2fsMy
         zo2MfPGRPlo1jozhJWtQfK2QHo6CI8q12vaThWlY8Irqk1q1Pb91y5rRGjJeUUrunx/X
         JkVQ==
X-Gm-Message-State: APjAAAVkElw6LTdBZK8YvvdMFXO0+3xhY79CsGIb3dTwTeZpj3xOBJT9
        Ztm0VX8SH4zVBWaVyDrVwpOuMQKfbhg=
X-Google-Smtp-Source: APXvYqzJgoXT5+jAAPJeDa5LDb8dNCTLRU4YFKvK1GNp+kYPmb0UsZNM/kINhzCWK7y4zsij/nA77Q==
X-Received: by 2002:a17:902:864c:: with SMTP id y12mr32411857plt.8.1582230725780;
        Thu, 20 Feb 2020 12:32:05 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id z10sm169672pgj.73.2020.02.20.12.32.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 12:32:05 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 9/9] io_uring: use poll driven retry for files that support it
Date:   Thu, 20 Feb 2020 13:31:51 -0700
Message-Id: <20200220203151.18709-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200220203151.18709-1-axboe@kernel.dk>
References: <20200220203151.18709-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently io_uring tries any request in a non-blocking manner, if it can,
and then retries from a worker thread if we got -EAGAIN. Now that we have
a new and fancy poll based retry backend, use that to retry requests if
the file supports it.

This means that, for example, an IORING_OP_RECVMSG on a socket no longer
requires an async thread to complete the IO. If we get -EAGAIN reading
from the socket in a non-blocking manner, we arm a poll handler for
notification on when the socket becomes readable. When it does, the
pending read is executed directly by the task again, through the io_uring
scheduler handlers.

Note that this is very much a work-in-progress, but it does pass the full
test suite. Notable missing features:

- Need to double check req->apoll life time.

- Probably a lot I don't quite recall right now...

It does work for the basic read/write, send/recv, etc testing I've
tried as well.

The feature is marked with IORING_FEAT_FAST_POLL, meaning that async
pollable IO is fast, and that poll<link>other_op is fast as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                   | 398 +++++++++++++++++++++++++-------
 include/trace/events/io_uring.h |  80 +++++++
 include/uapi/linux/io_uring.h   |   1 +
 3 files changed, 397 insertions(+), 82 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca96e0206132..39939b4935ca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -482,6 +482,8 @@ enum {
 	REQ_F_COMP_LOCKED_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_OVERFLOW_BIT,
+	REQ_F_WORK_BIT,
+	REQ_F_POLLED_BIT,
 };
 
 enum {
@@ -524,6 +526,15 @@ enum {
 	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
 	/* in overflow list */
 	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
+	/* ->work is valid */
+	REQ_F_WORK		= BIT(REQ_F_WORK_BIT),
+	/* already went through poll handler */
+	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
+};
+
+struct async_poll {
+	struct io_poll_iocb	poll;
+	struct io_wq_work	work;
 };
 
 /*
@@ -557,10 +568,7 @@ struct io_kiocb {
 	u8				opcode;
 
 	struct io_ring_ctx	*ctx;
-	union {
-		struct list_head	list;
-		struct hlist_node	hash_node;
-	};
+	struct list_head	list;
 	struct list_head	link_list;
 	unsigned int		flags;
 	refcount_t		refs;
@@ -570,14 +578,17 @@ struct io_kiocb {
 
 	struct list_head	inflight_entry;
 
+	struct task_struct	*task;
+
 	union {
 		/*
 		 * Only commands that never go async can use the below fields,
 		 * obviously. Right now only IORING_OP_POLL_ADD uses them.
 		 */
 		struct {
-			struct task_struct	*task;
 			struct callback_head	sched_work;
+			struct hlist_node	hash_node;
+			struct async_poll	*apoll;
 		};
 		struct io_wq_work	work;
 	};
@@ -953,10 +964,13 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 	}
 	if (!req->work.task_pid)
 		req->work.task_pid = task_pid_vnr(current);
+	req->flags |= REQ_F_WORK;
 }
 
 static inline void io_req_work_drop_env(struct io_kiocb *req)
 {
+	if (!(req->flags & REQ_F_WORK))
+		return;
 	if (req->work.mm) {
 		mmdrop(req->work.mm);
 		req->work.mm = NULL;
@@ -3467,9 +3481,199 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
 #endif
 }
 
-static bool io_poll_remove_one(struct io_kiocb *req)
+struct io_poll_table {
+	struct poll_table_struct pt;
+	struct io_kiocb *req;
+	int error;
+};
+
+static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
+			    struct wait_queue_head *head)
+{
+	if (unlikely(poll->head)) {
+		pt->error = -EINVAL;
+		return;
+	}
+
+	pt->error = 0;
+	poll->head = head;
+	add_wait_queue(head, &poll->wait);
+}
+
+static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
+			       struct poll_table_struct *p)
+{
+	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
+
+	__io_queue_proc(&pt->req->apoll->poll, pt, head);
+}
+
+static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
+			   __poll_t mask, task_work_func_t func)
+{
+	struct task_struct *tsk;
+
+	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
+
+	/* for instances that support it check for an event match first: */
+	if (mask && !(mask & poll->events))
+		return 0;
+
+	list_del_init(&poll->wait.entry);
+
+	tsk = req->task;
+	req->result = mask;
+	init_task_work(&req->sched_work, func);
+	sched_work_add(tsk, &req->sched_work);
+	wake_up_process(tsk);
+	return 1;
+}
+
+static void io_async_task_func(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
+	void *to_free;
+
+	if (hash_hashed(&req->hash_node)) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock_irq(&ctx->completion_lock);
+		hash_del(&req->hash_node);
+		spin_unlock_irq(&ctx->completion_lock);
+	}
+
+	to_free = req->apoll;
+	WARN_ON_ONCE(!list_empty(&req->apoll->poll.wait.entry));
+
+	__set_current_state(TASK_RUNNING);
+	__io_queue_sqe(req, NULL);
+
+	kfree(to_free);
+}
+
+static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
+			void *key)
+{
+	struct io_kiocb *req = wait->private;
+	struct io_poll_iocb *poll = &req->apoll->poll;
+
+	trace_io_uring_poll_wake(req->ctx, req->opcode, req->user_data,
+					key_to_poll(key));
+
+	return __io_async_wake(req, poll, key_to_poll(key), io_async_task_func);
+}
+
+static void io_poll_req_insert(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct hlist_head *list;
+
+	list = &ctx->cancel_hash[hash_long(req->user_data, ctx->cancel_hash_bits)];
+	hlist_add_head(&req->hash_node, list);
+}
+
+static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
+				      struct io_poll_iocb *poll,
+				      struct io_poll_table *ipt, __poll_t mask,
+				      wait_queue_func_t wake_func, void *priv)
+	__acquires(&ctx->completion_lock)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	bool cancel = false;
+
+	poll->file = req->file;
+	poll->head = NULL;
+	poll->done = poll->canceled = false;
+	poll->events = mask;
+
+	ipt->pt._key = mask;
+	ipt->req = req;
+	ipt->error = -EINVAL;
+
+	INIT_LIST_HEAD(&poll->wait.entry);
+	init_waitqueue_func_entry(&poll->wait, wake_func);
+	poll->wait.private = priv;
+
+	mask = vfs_poll(req->file, &ipt->pt) & poll->events;
+
+	spin_lock_irq(&ctx->completion_lock);
+	if (likely(poll->head)) {
+		spin_lock(&poll->head->lock);
+		if (unlikely(list_empty(&poll->wait.entry))) {
+			if (ipt->error)
+				cancel = true;
+			ipt->error = 0;
+			mask = 0;
+		}
+		if (mask || ipt->error)
+			list_del_init(&poll->wait.entry);
+		else if (cancel)
+			WRITE_ONCE(poll->canceled, true);
+		else if (!poll->done) /* actually waiting for an event */
+			io_poll_req_insert(req);
+		spin_unlock(&poll->head->lock);
+	}
+
+	return mask;
+}
+
+static bool io_arm_poll_handler(struct io_kiocb *req)
+{
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+	struct io_ring_ctx *ctx = req->ctx;
+	struct async_poll *apoll;
+	struct io_poll_table ipt;
+	__poll_t mask, ret;
+
+	if (!req->file || !file_can_poll(req->file))
+		return false;
+	if (req->flags & (REQ_F_MUST_PUNT | REQ_F_WORK))
+		return false;
+	if (req->flags & REQ_F_POLLED) {
+		memcpy(&req->work, &req->apoll->work, sizeof(req->work));
+		return false;
+	}
+	if (!def->pollin && !def->pollout)
+		return false;
+
+	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
+	if (unlikely(!apoll))
+		return false;
+
+	req->flags |= REQ_F_POLLED;
+	memcpy(&apoll->work, &req->work, sizeof(req->work));
+
+	req->task = current;
+	req->apoll = apoll;
+	INIT_HLIST_NODE(&req->hash_node);
+
+	if (def->pollin)
+		mask = POLLIN | POLLRDNORM;
+	if (def->pollout)
+		mask |= POLLOUT | POLLWRNORM;
+	mask |= POLLERR | POLLPRI;
+
+	ipt.pt._qproc = io_async_queue_proc;
+
+	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
+					io_async_wake, req);
+	if (ret) {
+		ipt.error = 0;
+		apoll->poll.done = true;
+		spin_unlock_irq(&ctx->completion_lock);
+		memcpy(&req->work, &apoll->work, sizeof(req->work));
+		kfree(apoll);
+		return false;
+	}
+	spin_unlock_irq(&ctx->completion_lock);
+	trace_io_uring_poll_arm(ctx, req->opcode, req->user_data, mask,
+					apoll->poll.events);
+	return true;
+}
+
+static bool __io_poll_remove_one(struct io_kiocb *req,
+				 struct io_poll_iocb *poll)
 {
-	struct io_poll_iocb *poll = &req->poll;
 	bool do_complete = false;
 
 	spin_lock(&poll->head->lock);
@@ -3479,7 +3683,24 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		do_complete = true;
 	}
 	spin_unlock(&poll->head->lock);
+	return do_complete;
+}
+
+static bool io_poll_remove_one(struct io_kiocb *req)
+{
+	bool do_complete;
+
+	if (req->opcode == IORING_OP_POLL_ADD) {
+		do_complete = __io_poll_remove_one(req, &req->poll);
+	} else {
+		/* non-poll requests have submit ref still */
+		do_complete = __io_poll_remove_one(req, &req->apoll->poll);
+		if (do_complete)
+			io_put_req(req);
+	}
+
 	hash_del(&req->hash_node);
+
 	if (do_complete) {
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(req->ctx);
@@ -3602,51 +3823,16 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 {
 	struct io_poll_iocb *poll = wait->private;
 	struct io_kiocb *req = container_of(poll, struct io_kiocb, poll);
-	__poll_t mask = key_to_poll(key);
-	struct task_struct *tsk;
-
-	/* for instances that support it check for an event match first: */
-	if (mask && !(mask & poll->events))
-		return 0;
-
-	list_del_init(&poll->wait.entry);
 
-	tsk = req->task;
-	req->result = mask;
-	init_task_work(&req->sched_work, io_poll_task_func);
-	sched_work_add(tsk, &req->sched_work);
-	wake_up_process(tsk);
-	return 1;
+	return __io_async_wake(req, poll, key_to_poll(key), io_poll_task_func);
 }
 
-struct io_poll_table {
-	struct poll_table_struct pt;
-	struct io_kiocb *req;
-	int error;
-};
-
 static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,
 			       struct poll_table_struct *p)
 {
 	struct io_poll_table *pt = container_of(p, struct io_poll_table, pt);
 
-	if (unlikely(pt->req->poll.head)) {
-		pt->error = -EINVAL;
-		return;
-	}
-
-	pt->error = 0;
-	pt->req->poll.head = head;
-	add_wait_queue(head, &pt->req->poll.wait);
-}
-
-static void io_poll_req_insert(struct io_kiocb *req)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-	struct hlist_head *list;
-
-	list = &ctx->cancel_hash[hash_long(req->user_data, ctx->cancel_hash_bits)];
-	hlist_add_head(&req->hash_node, list);
+	__io_queue_proc(&pt->req->poll, pt, head);
 }
 
 static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -3674,46 +3860,15 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 	struct io_poll_iocb *poll = &req->poll;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_poll_table ipt;
-	bool cancel = false;
 	__poll_t mask;
 
 	INIT_HLIST_NODE(&req->hash_node);
-
-	poll->head = NULL;
-	poll->done = false;
-	poll->canceled = false;
-
-	ipt.pt._qproc = io_poll_queue_proc;
-	ipt.pt._key = poll->events;
-	ipt.req = req;
-	ipt.error = -EINVAL; /* same as no support for IOCB_CMD_POLL */
-
-	/* initialized the list so that we can do list_empty checks */
-	INIT_LIST_HEAD(&poll->wait.entry);
-	init_waitqueue_func_entry(&poll->wait, io_poll_wake);
-	poll->wait.private = poll;
-
 	INIT_LIST_HEAD(&req->list);
+	ipt.pt._qproc = io_poll_queue_proc;
 
-	mask = vfs_poll(poll->file, &ipt.pt) & poll->events;
+	mask = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events,
+					io_poll_wake, &req->poll);
 
-	spin_lock_irq(&ctx->completion_lock);
-	if (likely(poll->head)) {
-		spin_lock(&poll->head->lock);
-		if (unlikely(list_empty(&poll->wait.entry))) {
-			if (ipt.error)
-				cancel = true;
-			ipt.error = 0;
-			mask = 0;
-		}
-		if (mask || ipt.error)
-			list_del_init(&poll->wait.entry);
-		else if (cancel)
-			WRITE_ONCE(poll->canceled, true);
-		else if (!poll->done) /* actually waiting for an event */
-			io_poll_req_insert(req);
-		spin_unlock(&poll->head->lock);
-	}
 	if (mask) { /* no async, we'd stolen it */
 		ipt.error = 0;
 		io_poll_complete(req, mask, 0);
@@ -4660,6 +4815,11 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	 */
 	if (ret == -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
 	    (req->flags & REQ_F_MUST_PUNT))) {
+		if (io_arm_poll_handler(req)) {
+			if (linked_timeout)
+				io_put_req(linked_timeout);
+			goto done_req;
+		}
 punt:
 		if (io_op_defs[req->opcode].file_table) {
 			ret = io_grab_files(req);
@@ -5199,8 +5359,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	struct io_rings *rings = ctx->rings;
 	int ret = 0;
 
-	if (io_cqring_events(ctx, false) >= min_events)
-		return 0;
+	do {
+		if (io_cqring_events(ctx, false) >= min_events)
+			return 0;
+		if (!current->sched_work)
+			break;
+		sched_work_run();
+	} while (1);
 
 	if (sig) {
 #ifdef CONFIG_COMPAT
@@ -6435,6 +6600,62 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 	finish_wait(&ctx->inflight_wait, &wait);
 }
 
+static void __io_uring_cancel_task(struct task_struct *tsk,
+				   task_work_func_t func,
+				   void (*cancel)(struct io_kiocb *))
+{
+	struct callback_head *head;
+
+	while ((head = sched_work_cancel(tsk, func)) != NULL) {
+		struct io_kiocb *req;
+
+		req = container_of(head, struct io_kiocb, sched_work);
+		cancel(req);
+	}
+}
+
+static void async_cancel(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	void *to_free;
+
+	spin_lock_irq(&ctx->completion_lock);
+	hash_del(&req->hash_node);
+	io_cqring_fill_event(req, -ECANCELED);
+	io_commit_cqring(ctx);
+	req->flags |= REQ_F_COMP_LOCKED;
+	to_free = req->apoll;
+	io_double_put_req(req);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	kfree(to_free);
+	io_cqring_ev_posted(ctx);
+}
+
+static void io_uring_cancel_task_async(struct task_struct *tsk)
+{
+	__io_uring_cancel_task(tsk, io_async_task_func, async_cancel);
+}
+
+static void poll_cancel(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+
+	spin_lock_irq(&ctx->completion_lock);
+	hash_del(&req->hash_node);
+	io_poll_complete(req, -ECANCELED, 0);
+	req->flags |= REQ_F_COMP_LOCKED;
+	io_put_req(req);
+	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
+}
+
+static void io_uring_cancel_task_poll(struct task_struct *tsk)
+{
+	__io_uring_cancel_task(tsk, io_poll_task_func, poll_cancel);
+}
+
 static int io_uring_flush(struct file *file, void *data)
 {
 	struct io_ring_ctx *ctx = file->private_data;
@@ -6444,8 +6665,11 @@ static int io_uring_flush(struct file *file, void *data)
 	/*
 	 * If the task is going away, cancel work it may have pending
 	 */
-	if (fatal_signal_pending(current) || (current->flags & PF_EXITING))
+	if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
+		io_uring_cancel_task_poll(current);
+		io_uring_cancel_task_async(current);
 		io_wq_cancel_pid(ctx->io_wq, task_pid_vnr(current));
+	}
 
 	return 0;
 }
@@ -6650,6 +6874,16 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		seq_printf(m, "Personalities:\n");
 		idr_for_each(&ctx->personality_idr, io_uring_show_cred, m);
 	}
+	seq_printf(m, "Inflight:\n");
+	spin_lock_irq(&ctx->completion_lock);
+	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
+		struct hlist_head *list = &ctx->cancel_hash[i];
+		struct io_kiocb *req;
+
+		hlist_for_each_entry(req, list, hash_node)
+			seq_printf(m, "  req=%lx, op=%d, tsk list=%d\n", (long) req, req->opcode, req->task->sched_work != NULL);
+	}
+	spin_unlock_irq(&ctx->completion_lock);
 	mutex_unlock(&ctx->uring_lock);
 }
 
@@ -6863,7 +7097,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
-			IORING_FEAT_CUR_PERSONALITY;
+			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL;
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
 err:
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 27bd9e4f927b..433e02b3ffb7 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -357,6 +357,86 @@ TRACE_EVENT(io_uring_submit_sqe,
 			  __entry->force_nonblock, __entry->sq_thread)
 );
 
+TRACE_EVENT(io_uring_poll_arm,
+
+	TP_PROTO(void *ctx, u8 opcode, u64 user_data, int mask, int events),
+
+	TP_ARGS(ctx, opcode, user_data, mask, events),
+
+	TP_STRUCT__entry (
+		__field(  void *,	ctx		)
+		__field(  u8,		opcode		)
+		__field(  u64,		user_data	)
+		__field(  int,		mask		)
+		__field(  int,		events		)
+	),
+
+	TP_fast_assign(
+		__entry->ctx		= ctx;
+		__entry->opcode		= opcode;
+		__entry->user_data	= user_data;
+		__entry->mask		= mask;
+		__entry->events		= events;
+	),
+
+	TP_printk("ring %p, op %d, data 0x%llx, mask 0x%x, events 0x%x",
+			  __entry->ctx, __entry->opcode,
+			  (unsigned long long) __entry->user_data,
+			  __entry->mask, __entry->events)
+);
+
+TRACE_EVENT(io_uring_poll_wake,
+
+	TP_PROTO(void *ctx, u8 opcode, u64 user_data, int mask),
+
+	TP_ARGS(ctx, opcode, user_data, mask),
+
+	TP_STRUCT__entry (
+		__field(  void *,	ctx		)
+		__field(  u8,		opcode		)
+		__field(  u64,		user_data	)
+		__field(  int,		mask		)
+	),
+
+	TP_fast_assign(
+		__entry->ctx		= ctx;
+		__entry->opcode		= opcode;
+		__entry->user_data	= user_data;
+		__entry->mask		= mask;
+	),
+
+	TP_printk("ring %p, op %d, data 0x%llx, mask 0x%x",
+			  __entry->ctx, __entry->opcode,
+			  (unsigned long long) __entry->user_data,
+			  __entry->mask)
+);
+
+TRACE_EVENT(io_uring_task_add,
+
+	TP_PROTO(void *ctx, u8 opcode, u64 user_data, int mask),
+
+	TP_ARGS(ctx, opcode, user_data, mask),
+
+	TP_STRUCT__entry (
+		__field(  void *,	ctx		)
+		__field(  u8,		opcode		)
+		__field(  u64,		user_data	)
+		__field(  int,		mask		)
+	),
+
+	TP_fast_assign(
+		__entry->ctx		= ctx;
+		__entry->opcode		= opcode;
+		__entry->user_data	= user_data;
+		__entry->mask		= mask;
+	),
+
+	TP_printk("ring %p, op %d, data 0x%llx, mask %x",
+			  __entry->ctx, __entry->opcode,
+			  (unsigned long long) __entry->user_data,
+			  __entry->mask)
+);
+
 #endif /* _TRACE_IO_URING_H */
 
 /* This part must be outside protection */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 3f7961c1c243..653865554691 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -204,6 +204,7 @@ struct io_uring_params {
 #define IORING_FEAT_SUBMIT_STABLE	(1U << 2)
 #define IORING_FEAT_RW_CUR_POS		(1U << 3)
 #define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
+#define IORING_FEAT_FAST_POLL		(1U << 5)
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
2.25.1

