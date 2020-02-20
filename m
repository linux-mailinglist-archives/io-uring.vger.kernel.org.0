Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8298166860
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 21:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728400AbgBTUcG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 15:32:06 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:44409 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728996AbgBTUcG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 15:32:06 -0500
Received: by mail-pl1-f196.google.com with SMTP id d9so1984070plo.11
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 12:32:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aPQUAemdwmwOCP3rRfGa9jqHsC5YuXWE2S5LfjBxoNw=;
        b=MBdMvYlrV9IGWVPbplnsLuNLi+Yl7CLidrXZX8yAwAYWk0f21pooU7ZzvCxOLxZPGD
         LXrrr8F/POgAdJWNPztZdFjq67BYS+JrkFzqJskNYY4lF3yPRpBGu+WPpyo7AwHJ/Duu
         Pekj5XvAVEJ6/mFpayNJ96nXKzEjIRI7cPLQivC2Zqcha+DScWAIatPkRZ0gxU7U8SAH
         IEkdidg9WX+Ywxusd1Ph76w0pgauVjNJfycBB/RjAlqk4i+jbX7rQE/bJP/qHXIbfUYn
         ICLdMy69Uu9k8E6qHkDG7FKzam+j7Pz5GR6hvhXERvbCy0uASPZpwaYGPLyaWdsnfzQm
         AZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aPQUAemdwmwOCP3rRfGa9jqHsC5YuXWE2S5LfjBxoNw=;
        b=FnMHIbh3tK4PU3NJHCptrEsfR/JT/4Z06dfqX/y9Q7MXrfY2J6+Y1/YmGNpMYGo+Li
         W3A5u1BiTF+v3uJ10Gvo+AyWQ2P+hfFnPDhL/ZAQJmVBGE3Ug+gIWkETffXqi73OBEKX
         3OPiKOzVVAS981NlVq6Pak5i+yd0CxA4Zr3pvmJWqGwTy6npc9p8H/UqgZM6glFFYm+3
         qkjjuGtjfaUqo725X3EjaPmOi1Xodg5TnoaRySj853dYj2fUEABY9GoeEu9Y3kAA2WQf
         HLRz8xsudBCNV9sFbhsulCDUBBc25I/OfV2Yr7Tb+YaE7DIaswrK15oLX5vgOEUSDOsF
         gdrg==
X-Gm-Message-State: APjAAAW4Lnu7uZyjMUiFfG4wNFH4c5Wx/2a6944mPtUheJ3KFZq902PD
        y6REBKWSsHXlwVmL2hulrC5kpFi03C8=
X-Google-Smtp-Source: APXvYqy4RJbAphIEHw0Ihq7a+Npn1J1ezRpFAlbKiA9BB8BIFAOlevTPLr1sWkU87+PtLO67e2l4aQ==
X-Received: by 2002:a17:902:a40c:: with SMTP id p12mr33104942plq.3.1582230723485;
        Thu, 20 Feb 2020 12:32:03 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:8495:a173:67ea:559c])
        by smtp.gmail.com with ESMTPSA id z10sm169672pgj.73.2020.02.20.12.32.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Feb 2020 12:32:03 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/9] io_uring: add per-task callback handler
Date:   Thu, 20 Feb 2020 13:31:49 -0700
Message-Id: <20200220203151.18709-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200220203151.18709-1-axboe@kernel.dk>
References: <20200220203151.18709-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For poll requests, it's not uncommon to link a read (or write) after
the poll to execute immediately after the file is marked as ready.
Since the poll completion is called inside the waitqueue wake up handler,
we have to punt that linked request to async context. This slows down
the processing, and actually means it's faster to not use a link for this
use case.

We also run into problems if the completion_lock is contended, as we're
doing a different lock ordering than the issue side is. Hence we have
to do trylock for completion, and if that fails, go async. Poll removal
needs to go async as well, for the same reason.

eventfd notification needs special case as well, to avoid stack blowing
recursion or deadlocks.

These are all deficiencies that were inherited from the aio poll
implementation, but I think we can do better. When a poll completes,
simply queue it up in the task poll list. When the task completes the
list, we can run dependent links inline as well. This means we never
have to go async, and we can remove a bunch of code associated with
that, and optimizations to try and make that run faster. The diffstat
speaks for itself.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 189 ++++++++++++++------------------------------------
 1 file changed, 53 insertions(+), 136 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c3fe2022e343..5991bcc24387 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -76,6 +76,7 @@
 #include <linux/fadvise.h>
 #include <linux/eventpoll.h>
 #include <linux/fs_struct.h>
+#include <linux/task_work.h>
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/io_uring.h>
@@ -295,7 +296,6 @@ struct io_ring_ctx {
 
 	struct {
 		spinlock_t		completion_lock;
-		struct llist_head	poll_llist;
 
 		/*
 		 * ->poll_list is protected by the ctx->uring_lock for
@@ -552,10 +552,6 @@ struct io_kiocb {
 	};
 
 	struct io_async_ctx		*io;
-	/*
-	 * llist_node is only used for poll deferred completions
-	 */
-	struct llist_node		llist_node;
 	bool				in_async;
 	bool				needs_fixed_file;
 	u8				opcode;
@@ -574,7 +570,17 @@ struct io_kiocb {
 
 	struct list_head	inflight_entry;
 
-	struct io_wq_work	work;
+	union {
+		/*
+		 * Only commands that never go async can use the below fields,
+		 * obviously. Right now only IORING_OP_POLL_ADD uses them.
+		 */
+		struct {
+			struct task_struct	*task;
+			struct callback_head	sched_work;
+		};
+		struct io_wq_work	work;
+	};
 };
 
 #define IO_PLUG_THRESHOLD		2
@@ -764,6 +770,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 static int io_grab_files(struct io_kiocb *req);
 static void io_ring_file_ref_flush(struct fixed_file_data *data);
 static void io_cleanup_req(struct io_kiocb *req);
+static void __io_queue_sqe(struct io_kiocb *req,
+			   const struct io_uring_sqe *sqe);
 
 static struct kmem_cache *req_cachep;
 
@@ -834,7 +842,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
 	spin_lock_init(&ctx->completion_lock);
-	init_llist_head(&ctx->poll_llist);
 	INIT_LIST_HEAD(&ctx->poll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
@@ -1056,24 +1063,19 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
 		return false;
 	if (!ctx->eventfd_async)
 		return true;
-	return io_wq_current_is_worker() || in_interrupt();
+	return io_wq_current_is_worker();
 }
 
-static void __io_cqring_ev_posted(struct io_ring_ctx *ctx, bool trigger_ev)
+static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
 {
 	if (waitqueue_active(&ctx->wait))
 		wake_up(&ctx->wait);
 	if (waitqueue_active(&ctx->sqo_wait))
 		wake_up(&ctx->sqo_wait);
-	if (trigger_ev)
+	if (io_should_trigger_evfd(ctx))
 		eventfd_signal(ctx->cq_ev_fd, 1);
 }
 
-static void io_cqring_ev_posted(struct io_ring_ctx *ctx)
-{
-	__io_cqring_ev_posted(ctx, io_should_trigger_evfd(ctx));
-}
-
 /* Returns true if there are no backlogged entries after the flush */
 static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 {
@@ -3450,18 +3452,27 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
 #endif
 }
 
-static void io_poll_remove_one(struct io_kiocb *req)
+static bool io_poll_remove_one(struct io_kiocb *req)
 {
 	struct io_poll_iocb *poll = &req->poll;
+	bool do_complete = false;
 
 	spin_lock(&poll->head->lock);
 	WRITE_ONCE(poll->canceled, true);
 	if (!list_empty(&poll->wait.entry)) {
 		list_del_init(&poll->wait.entry);
-		io_queue_async_work(req);
+		do_complete = true;
 	}
 	spin_unlock(&poll->head->lock);
 	hash_del(&req->hash_node);
+	if (do_complete) {
+		io_cqring_fill_event(req, -ECANCELED);
+		io_commit_cqring(req->ctx);
+		req->flags |= REQ_F_COMP_LOCKED;
+		io_put_req(req);
+	}
+
+	return do_complete;
 }
 
 static void io_poll_remove_all(struct io_ring_ctx *ctx)
@@ -3479,6 +3490,8 @@ static void io_poll_remove_all(struct io_ring_ctx *ctx)
 			io_poll_remove_one(req);
 	}
 	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
 }
 
 static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
@@ -3488,10 +3501,11 @@ static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
 
 	list = &ctx->cancel_hash[hash_long(sqe_addr, ctx->cancel_hash_bits)];
 	hlist_for_each_entry(req, list, hash_node) {
-		if (sqe_addr == req->user_data) {
-			io_poll_remove_one(req);
+		if (sqe_addr != req->user_data)
+			continue;
+		if (io_poll_remove_one(req))
 			return 0;
-		}
+		return -EALREADY;
 	}
 
 	return -ENOENT;
@@ -3544,92 +3558,28 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 	io_commit_cqring(ctx);
 }
 
-static void io_poll_complete_work(struct io_wq_work **workptr)
+static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 {
-	struct io_wq_work *work = *workptr;
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct io_poll_iocb *poll = &req->poll;
-	struct poll_table_struct pt = { ._key = poll->events };
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_kiocb *nxt = NULL;
-	__poll_t mask = 0;
-	int ret = 0;
 
-	if (work->flags & IO_WQ_WORK_CANCEL) {
-		WRITE_ONCE(poll->canceled, true);
-		ret = -ECANCELED;
-	} else if (READ_ONCE(poll->canceled)) {
-		ret = -ECANCELED;
-	}
-
-	if (ret != -ECANCELED)
-		mask = vfs_poll(poll->file, &pt) & poll->events;
-
-	/*
-	 * Note that ->ki_cancel callers also delete iocb from active_reqs after
-	 * calling ->ki_cancel.  We need the ctx_lock roundtrip here to
-	 * synchronize with them.  In the cancellation case the list_del_init
-	 * itself is not actually needed, but harmless so we keep it in to
-	 * avoid further branches in the fast path.
-	 */
 	spin_lock_irq(&ctx->completion_lock);
-	if (!mask && ret != -ECANCELED) {
-		add_wait_queue(poll->head, &poll->wait);
-		spin_unlock_irq(&ctx->completion_lock);
-		return;
-	}
 	hash_del(&req->hash_node);
-	io_poll_complete(req, mask, ret);
-	spin_unlock_irq(&ctx->completion_lock);
-
-	io_cqring_ev_posted(ctx);
-
-	if (ret < 0)
-		req_set_fail_links(req);
-	io_put_req_find_next(req, &nxt);
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
-}
-
-static void __io_poll_flush(struct io_ring_ctx *ctx, struct llist_node *nodes)
-{
-	struct io_kiocb *req, *tmp;
-	struct req_batch rb;
-
-	rb.to_free = rb.need_iter = 0;
-	spin_lock_irq(&ctx->completion_lock);
-	llist_for_each_entry_safe(req, tmp, nodes, llist_node) {
-		hash_del(&req->hash_node);
-		io_poll_complete(req, req->result, 0);
-
-		if (refcount_dec_and_test(&req->refs) &&
-		    !io_req_multi_free(&rb, req)) {
-			req->flags |= REQ_F_COMP_LOCKED;
-			io_free_req(req);
-		}
-	}
+	io_poll_complete(req, req->result, 0);
+	req->flags |= REQ_F_COMP_LOCKED;
+	io_put_req_find_next(req, nxt);
 	spin_unlock_irq(&ctx->completion_lock);
 
 	io_cqring_ev_posted(ctx);
-	io_free_req_many(ctx, &rb);
-}
-
-static void io_poll_flush(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct llist_node *nodes;
-
-	nodes = llist_del_all(&req->ctx->poll_llist);
-	if (nodes)
-		__io_poll_flush(req->ctx, nodes);
 }
 
-static void io_poll_trigger_evfd(struct io_wq_work **workptr)
+static void io_poll_task_func(struct callback_head *cb)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
+	struct io_kiocb *nxt = NULL;
 
-	eventfd_signal(req->ctx->cq_ev_fd, 1);
-	io_put_req(req);
+	io_poll_task_handler(req, &nxt);
+	if (nxt)
+		__io_queue_sqe(nxt, NULL);
 }
 
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
@@ -3637,8 +3587,8 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 {
 	struct io_poll_iocb *poll = wait->private;
 	struct io_kiocb *req = container_of(poll, struct io_kiocb, poll);
-	struct io_ring_ctx *ctx = req->ctx;
 	__poll_t mask = key_to_poll(key);
+	struct task_struct *tsk;
 
 	/* for instances that support it check for an event match first: */
 	if (mask && !(mask & poll->events))
@@ -3646,46 +3596,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 
 	list_del_init(&poll->wait.entry);
 
-	/*
-	 * Run completion inline if we can. We're using trylock here because
-	 * we are violating the completion_lock -> poll wq lock ordering.
-	 * If we have a link timeout we're going to need the completion_lock
-	 * for finalizing the request, mark us as having grabbed that already.
-	 */
-	if (mask) {
-		unsigned long flags;
-
-		if (llist_empty(&ctx->poll_llist) &&
-		    spin_trylock_irqsave(&ctx->completion_lock, flags)) {
-			bool trigger_ev;
-
-			hash_del(&req->hash_node);
-			io_poll_complete(req, mask, 0);
-
-			trigger_ev = io_should_trigger_evfd(ctx);
-			if (trigger_ev && eventfd_signal_count()) {
-				trigger_ev = false;
-				req->work.func = io_poll_trigger_evfd;
-			} else {
-				req->flags |= REQ_F_COMP_LOCKED;
-				io_put_req(req);
-				req = NULL;
-			}
-			spin_unlock_irqrestore(&ctx->completion_lock, flags);
-			__io_cqring_ev_posted(ctx, trigger_ev);
-		} else {
-			req->result = mask;
-			req->llist_node.next = NULL;
-			/* if the list wasn't empty, we're done */
-			if (!llist_add(&req->llist_node, &ctx->poll_llist))
-				req = NULL;
-			else
-				req->work.func = io_poll_flush;
-		}
-	}
-	if (req)
-		io_queue_async_work(req);
-
+	tsk = req->task;
+	req->result = mask;
+	init_task_work(&req->sched_work, io_poll_task_func);
+	sched_work_add(tsk, &req->sched_work);
+	wake_up_process(tsk);
 	return 1;
 }
 
@@ -3733,6 +3648,9 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 
 	events = READ_ONCE(sqe->poll_events);
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
+
+	/* task will wait for requests on exit, don't need a ref */
+	req->task = current;
 	return 0;
 }
 
@@ -3744,7 +3662,6 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 	bool cancel = false;
 	__poll_t mask;
 
-	INIT_IO_WORK(&req->work, io_poll_complete_work);
 	INIT_HLIST_NODE(&req->hash_node);
 
 	poll->head = NULL;
-- 
2.25.1

