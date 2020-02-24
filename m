Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF73316ADC2
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:39:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727644AbgBXRjr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:39:47 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:40493 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgBXRjr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:39:47 -0500
Received: by mail-io1-f66.google.com with SMTP id x1so11118065iop.7
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:39:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OthndQTQywFcP4SP2g7JEEcA7Lx7UH61KZ6rRaC59Bw=;
        b=wN06hjFb6dzsOiPes4ygVi8AArtJgYTeXgL/JKCItIh6sI23HNbNxBzYuAovkoU1/0
         d59iPtliWrsvmDB1/r+bMj9CsUrgoAsAFbAWQpMquRBFNApRRtA3aSJJ3+2im6dTOs+K
         IMt6UnKOKdB9t9UBk7jjR8hauIw1ZVkiV2+Tx8gyiMEo5IHiJ70ksCucxGkNDCKh53mA
         kkemeG9zVqFrTP+Mh474BYj5NU1TspxEXStt9Hd/2XrmofNcHvrXFAZZj+s/njf2nitl
         M3rZNf4oZuSPm8JRsN+U/M4TrGVGPK7sdgcBw7ccDTHku1GNARf33XqTGe9/FjEQGThA
         DJNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OthndQTQywFcP4SP2g7JEEcA7Lx7UH61KZ6rRaC59Bw=;
        b=hDix3Q650oHOF+AgFnJ1bBxXKny2xzwH8TyhAKh8DOwO1rs/96rD8dWi6uExpSqvWy
         CQUJ/1NHQAE6v29zcu94FDT6Ep45KVmfBo5EAntppvCSf1/C1NJEMoPoXtvEjMM68YFL
         jTOvRa1jDgfL9C50Zr4wDblsvb9IlYMcMvEZ53+uvKySRL6DrpMRLr2qwECrlZCwdFFy
         eYamiFQ8ZPJOvJDEmykM48vxaz2EBze0PKCoiGpMf04TifGjngiQqsQLdpG0i1KyPAqc
         G0VPUwtRx1blyCtWHnYigIwvmAq63b6fGmXU0KRZl38SpxWX0X4CbE4lEiZR5ThItS3f
         /0BA==
X-Gm-Message-State: APjAAAVoBvHm9YmTFp/vCbbQmUvi/IPMbOPvIDc6Ul6dRmv+B4whZTD7
        Vxw2xPCaGwgZoyYKokVlKlwTFfs7qLw=
X-Google-Smtp-Source: APXvYqyzQiFzqUEc3DgRrB9y/pmw97W5pcgufinVszic9Y0vboxVQWfUUTRGTYRJEAwepLeB90QEQQ==
X-Received: by 2002:a5e:8309:: with SMTP id x9mr51806735iom.184.1582565984762;
        Mon, 24 Feb 2020 09:39:44 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id p79sm4541982ill.66.2020.02.24.09.39.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 09:39:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: use poll driven retry for files that support it
Date:   Mon, 24 Feb 2020 10:39:37 -0700
Message-Id: <20200224173937.16481-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200224173937.16481-1-axboe@kernel.dk>
References: <20200224173937.16481-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently io_uring tries any request in a non-blocking manner, if it can,
and then retries from a worker thread if we get -EAGAIN. Now that we have
a new and fancy poll based retry backend, use that to retry requests if
the file supports it.

This means that, for example, an IORING_OP_RECVMSG on a socket no longer
requires an async thread to complete the IO. If we get -EAGAIN reading
from the socket in a non-blocking manner, we arm a poll handler for
notification on when the socket becomes readable. When it does, the
pending read is executed directly by the task again, through the io_uring
task work handlers. Not only is this faster and more efficient, it also
means we're not generating potentially tons of async threads that just
sit and block, waiting for the IO to complete.

The feature is marked with IORING_FEAT_FAST_POLL, meaning that async
pollable IO is fast, and that poll<link>other_op is fast as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                   | 346 ++++++++++++++++++++++++--------
 include/trace/events/io_uring.h | 103 ++++++++++
 include/uapi/linux/io_uring.h   |   1 +
 3 files changed, 368 insertions(+), 82 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 890f28527c8b..4a981529bc69 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -492,6 +492,7 @@ enum {
 	REQ_F_COMP_LOCKED_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_OVERFLOW_BIT,
+	REQ_F_POLLED_BIT,
 };
 
 enum {
@@ -534,6 +535,13 @@ enum {
 	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
 	/* in overflow list */
 	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
+	/* already went through poll handler */
+	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
+};
+
+struct async_poll {
+	struct io_poll_iocb	poll;
+	struct io_wq_work	work;
 };
 
 /*
@@ -567,27 +575,29 @@ struct io_kiocb {
 	u8				opcode;
 
 	struct io_ring_ctx	*ctx;
-	union {
-		struct list_head	list;
-		struct hlist_node	hash_node;
-	};
-	struct list_head	link_list;
+	struct list_head	list;
 	unsigned int		flags;
 	refcount_t		refs;
+	struct task_struct	*task;
 	u64			user_data;
 	u32			result;
 	u32			sequence;
 
+	struct list_head	link_list;
+
 	struct list_head	inflight_entry;
 
 	union {
 		/*
 		 * Only commands that never go async can use the below fields,
-		 * obviously. Right now only IORING_OP_POLL_ADD uses them.
+		 * obviously. Right now only IORING_OP_POLL_ADD uses them, and
+		 * async armed poll handlers for regular commands. The latter
+		 * restore the work, if needed.
 		 */
 		struct {
-			struct task_struct	*task;
 			struct callback_head	task_work;
+			struct hlist_node	hash_node;
+			struct async_poll	*apoll;
 		};
 		struct io_wq_work	work;
 	};
@@ -3560,9 +3570,208 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
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
+	/* for instances that support it check for an event match first: */
+	if (mask && !(mask & poll->events))
+		return 0;
+
+	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
+
+	list_del_init(&poll->wait.entry);
+
+	tsk = req->task;
+	req->result = mask;
+	init_task_work(&req->task_work, func);
+	/*
+	 * If this fails, then the task is exiting. If that is the case, then
+	 * the exit check will ultimately cancel these work items. Hence we
+	 * don't need to check here and handle it specifically.
+	 */
+	task_work_add(tsk, &req->task_work, true);
+	wake_up_process(tsk);
+	return 1;
+}
+
+static void io_async_task_func(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct async_poll *apoll = req->apoll;
+
+	trace_io_uring_task_run(req->ctx, req->opcode, req->user_data);
+
+	WARN_ON_ONCE(!list_empty(&req->apoll->poll.wait.entry));
+
+	if (hash_hashed(&req->hash_node)) {
+		struct io_ring_ctx *ctx = req->ctx;
+
+		spin_lock_irq(&ctx->completion_lock);
+		hash_del(&req->hash_node);
+		spin_unlock_irq(&ctx->completion_lock);
+	}
+
+	/* restore ->work in case we need to retry again */
+	memcpy(&req->work, &apoll->work, sizeof(req->work));
+
+	__set_current_state(TASK_RUNNING);
+	__io_queue_sqe(req, NULL);
+
+	kfree(apoll);
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
+				      wait_queue_func_t wake_func)
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
+	poll->wait.private = req;
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
+	if (req->flags & (REQ_F_MUST_PUNT | REQ_F_POLLED))
+		return false;
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
+	/*
+	 * Don't need a reference here, as we're adding it to the task
+	 * task_works list. If the task exits, the list is pruned.
+	 */
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
+					io_async_wake);
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
@@ -3572,7 +3781,24 @@ static bool io_poll_remove_one(struct io_kiocb *req)
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
@@ -3695,51 +3921,16 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 {
 	struct io_kiocb *req = wait->private;
 	struct io_poll_iocb *poll = &req->poll;
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
-	init_task_work(&req->task_work, io_poll_task_func);
-	task_work_add(tsk, &req->task_work, true);
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
@@ -3757,7 +3948,10 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	events = READ_ONCE(sqe->poll_events);
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
 
-	/* task will wait for requests on exit, don't need a ref */
+	/*
+	 * Don't need a reference here, as we're adding it to the task
+	 * task_works list. If the task exits, the list is pruned.
+	 */
 	req->task = current;
 	return 0;
 }
@@ -3767,46 +3961,15 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
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
-	poll->wait.private = req;
-
 	INIT_LIST_HEAD(&req->list);
+	ipt.pt._qproc = io_poll_queue_proc;
 
-	mask = vfs_poll(poll->file, &ipt.pt) & poll->events;
+	mask = __io_arm_poll_handler(req, &req->poll, &ipt, poll->events,
+					io_poll_wake);
 
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
@@ -4751,6 +4914,9 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 
 	if (!(req->flags & REQ_F_LINK))
 		return NULL;
+	/* for polled retry, if flag is set, we already went through here */
+	if (req->flags & REQ_F_POLLED)
+		return NULL;
 
 	nxt = list_first_entry_or_null(&req->link_list, struct io_kiocb,
 					link_list);
@@ -4788,6 +4954,11 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	 */
 	if (ret == -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
 	    (req->flags & REQ_F_MUST_PUNT))) {
+		if (io_arm_poll_handler(req)) {
+			if (linked_timeout)
+				io_queue_linked_timeout(linked_timeout);
+			goto done_req;
+		}
 punt:
 		if (io_op_defs[req->opcode].file_table) {
 			ret = io_grab_files(req);
@@ -6792,6 +6963,17 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		seq_printf(m, "Personalities:\n");
 		idr_for_each(&ctx->personality_idr, io_uring_show_cred, m);
 	}
+	seq_printf(m, "PollList:\n");
+	spin_lock_irq(&ctx->completion_lock);
+	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
+		struct hlist_head *list = &ctx->cancel_hash[i];
+		struct io_kiocb *req;
+
+		hlist_for_each_entry(req, list, hash_node)
+			seq_printf(m, "  op=%d, task_works=%d\n", req->opcode,
+					req->task->task_works != NULL);
+	}
+	spin_unlock_irq(&ctx->completion_lock);
 	mutex_unlock(&ctx->uring_lock);
 }
 
@@ -7005,7 +7187,7 @@ static int io_uring_create(unsigned entries, struct io_uring_params *p)
 
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
-			IORING_FEAT_CUR_PERSONALITY;
+			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL;
 	trace_io_uring_create(ret, ctx, p->sq_entries, p->cq_entries, p->flags);
 	return ret;
 err:
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 27bd9e4f927b..9f0d3b7d56b0 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -357,6 +357,109 @@ TRACE_EVENT(io_uring_submit_sqe,
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
+TRACE_EVENT(io_uring_task_run,
+
+	TP_PROTO(void *ctx, u8 opcode, u64 user_data),
+
+	TP_ARGS(ctx, opcode, user_data),
+
+	TP_STRUCT__entry (
+		__field(  void *,	ctx		)
+		__field(  u8,		opcode		)
+		__field(  u64,		user_data	)
+	),
+
+	TP_fast_assign(
+		__entry->ctx		= ctx;
+		__entry->opcode		= opcode;
+		__entry->user_data	= user_data;
+	),
+
+	TP_printk("ring %p, op %d, data 0x%llx",
+			  __entry->ctx, __entry->opcode,
+			  (unsigned long long) __entry->user_data)
+);
+
 #endif /* _TRACE_IO_URING_H */
 
 /* This part must be outside protection */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 08891cc1c1e7..53b36311cdac 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -216,6 +216,7 @@ struct io_uring_params {
 #define IORING_FEAT_SUBMIT_STABLE	(1U << 2)
 #define IORING_FEAT_RW_CUR_POS		(1U << 3)
 #define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
+#define IORING_FEAT_FAST_POLL		(1U << 5)
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
2.25.1

