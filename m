Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D91F16897F
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 22:46:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728815AbgBUVqT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 16:46:19 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:37814 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728433AbgBUVqS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 16:46:18 -0500
Received: by mail-pl1-f196.google.com with SMTP id c23so1427606plz.4
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 13:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f/b8Xxl8DMZ+VD9a1TClZiVVlq71+yMJp534BbCiztQ=;
        b=05VQOAmeNPD6vwjKCBuqF3Ypq7Bg6qeuiUjzODIoVXxmDzaRwsDdmggxrPrtQYOXuj
         FzpBs9RfJfEEkeIp3mcyl4n/YrCqJ1wUwlIkhmFSPU336uJ9lMaAoZD2roXsWa66do08
         SdMsVnOiyBULkXX9M6yJGuq6Sr7icZoObTEY1RncCWDwFlLLpulqjnIgrsyD1pZ5nhgO
         ZfagdFFNzYuoR8Yc4hSabjWCtk0Qa8bZgh9sL0gvKb7QQ6yy77qxuSgTAZycKcmA7U5R
         HONu2ZOHA8Bt2dW+anvtyeBaHdUAv908nAIYzNsmL2RKfc1+6NWaBGm3kfdyeBITQMi5
         eW7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f/b8Xxl8DMZ+VD9a1TClZiVVlq71+yMJp534BbCiztQ=;
        b=USIkWecbOVb0w9FOiayGVDtPuGyWOjh9L6kRq+zPqa3RmThXkWURMji9GCNZgserl/
         +IUuhZPyaLVmAOOawfaGMeJMEJS7kAxJyrCO8qbAbZrQLLjjei8mT38Cb8u+5+8h1by8
         lOkmgcROQh6YIHkborhwpqgdOFcQ9V0Rvh2AVBWUW3MU8JkRI4gfLlZ8P+/VK6p07J0K
         KIdvec36CKv7ZfRZDNfieubfJ/WulxYBWvEidIaHXmNBJoJsg1BG6pdN6ywKoYFcuZcP
         BcSXGN3DyxmfHoazrxwjVuNh1LQT1FdeZKwDfN2AEFFzKLemKLC4qvVKYB/E2KaAPoxt
         a6Uw==
X-Gm-Message-State: APjAAAVkLrodph29Hzdjmvyv6YfbNqGRQzlWxfg38MJgbs59buAipMxm
        adHNPqJSKCMbYw8yGZvl0ggWSUrnSqE=
X-Google-Smtp-Source: APXvYqyOih+xUwf35yEGLjOq78n6lsFTGRrafDkvG2eDMl67lztmOdzqronknIJ36Gv62Eno8bVIAA==
X-Received: by 2002:a17:90a:8545:: with SMTP id a5mr5392788pjw.43.1582321576030;
        Fri, 21 Feb 2020 13:46:16 -0800 (PST)
Received: from x1.localdomain ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id a22sm4043312pfk.108.2020.02.21.13.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 13:46:15 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     glauber@scylladb.com, peterz@infradead.org, asml.silence@gmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/7] io_uring: add per-task callback handler
Date:   Fri, 21 Feb 2020 14:46:04 -0700
Message-Id: <20200221214606.12533-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221214606.12533-1-axboe@kernel.dk>
References: <20200221214606.12533-1-axboe@kernel.dk>
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
 fs/io_uring.c | 211 +++++++++++++++++---------------------------------
 1 file changed, 73 insertions(+), 138 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 634e5b2d822d..5262527af86e 100644
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
+			struct callback_head	task_work;
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
-
-	if (work->flags & IO_WQ_WORK_CANCEL) {
-		WRITE_ONCE(poll->canceled, true);
-		ret = -ECANCELED;
-	} else if (READ_ONCE(poll->canceled)) {
-		ret = -ECANCELED;
-	}
 
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
 }
 
-static void io_poll_flush(struct io_wq_work **workptr)
+static void io_poll_task_func(struct callback_head *cb)
 {
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct llist_node *nodes;
-
-	nodes = llist_del_all(&req->ctx->poll_llist);
-	if (nodes)
-		__io_poll_flush(req->ctx, nodes);
-}
-
-static void io_poll_trigger_evfd(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
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
 	struct io_kiocb *req = wait->private;
 	struct io_poll_iocb *poll = &req->poll;
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
+	init_task_work(&req->task_work, io_poll_task_func);
+	task_work_add(tsk, &req->task_work, true);
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
@@ -5185,6 +5102,10 @@ static int io_sq_thread(void *data)
 				}
 				if (signal_pending(current))
 					flush_signals(current);
+				if (current->task_works) {
+					task_work_run();
+					continue;
+				}
 				schedule();
 				finish_wait(&ctx->sqo_wait, &wait);
 
@@ -5267,8 +5188,13 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	struct io_rings *rings = ctx->rings;
 	int ret = 0;
 
-	if (io_cqring_events(ctx, false) >= min_events)
-		return 0;
+	do {
+		if (io_cqring_events(ctx, false) >= min_events)
+			return 0;
+		if (!current->task_works)
+			break;
+		task_work_run();
+	} while (1);
 
 	if (sig) {
 #ifdef CONFIG_COMPAT
@@ -5290,6 +5216,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 						TASK_INTERRUPTIBLE);
 		if (io_should_wake(&iowq, false))
 			break;
+		if (current->task_works) {
+			task_work_run();
+			if (io_should_wake(&iowq, false))
+				break;
+			continue;
+		}
 		schedule();
 		if (signal_pending(current)) {
 			ret = -EINTR;
@@ -6597,6 +6529,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 	int submitted = 0;
 	struct fd f;
 
+	if (current->task_works)
+		task_work_run();
+
 	if (flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP))
 		return -EINVAL;
 
-- 
2.25.1

