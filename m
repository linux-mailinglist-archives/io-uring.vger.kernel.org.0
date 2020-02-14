Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87BC615F7E7
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 21:44:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728216AbgBNUog (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 15:44:36 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55813 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727742AbgBNUog (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 15:44:36 -0500
Received: by mail-pj1-f68.google.com with SMTP id d5so4332814pjz.5
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 12:44:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kTntWlQzY9pW+Kb6k9ooaEodmR3cjwpKfYiFHRje3LA=;
        b=tstVJ5cu8258CCpurqlEy+CYXpsUD6CqZXqYcJpQRfHNHmXuDeVWDZ14FphNBKSMfa
         lFtl5tk/pG2V9E7kOADqIxbJ1wpwzxcN40ahAMHM8K5J5hyMgjYV5aFqbtL6gWb3bCjs
         Xo7JaA5Ax0Rg2MLMhejOLYUt7jVUtbPKsD2ymsyYxtcW+FqC6uRvRZDMFALLmguit6qX
         2DiU8qcmsMdOZKyNbTHF7+BaSFFs5YNNZzHYuEk/yuQETW09oHK3llmcKLNKraUZy3Bz
         SHYR1zn1QqvfUXH+n59JvW9d5B0SZHDBGxO3D1v0Bfj6rKqgjEseCZXRIb35pAC6lvdA
         4vSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kTntWlQzY9pW+Kb6k9ooaEodmR3cjwpKfYiFHRje3LA=;
        b=FQCMuml6JzD7yrBCay3mjp5gWfIuvLYtr2Aw9eClMdDgoCfJ5cf22S7vuEDj352mD9
         lctO8BsmDQ4WD/tg3m0EqKMvrqYwm2xp7cPOqHG0D7tVwBVFdsHxg/GG9oejRrbB6FIH
         Tde4xM0y0QIeYd/68kV5xHIEgjKaSVfn8Zs3/ATneZr8ZKeg411taweusYG6L+JtVXqX
         VF+SkkKc+PVoy0xQKoc2Ik4sT0AjFnZcHtfTm589RiTWsljXTFiDoMsNxWqnx0drbxo3
         L/Y0jCOYf9YodDMiGm7miAFoGONKIjKbB9PYWNhjrtufkbJf22J2r3Gs1Lzclf4EqLxv
         CTlw==
X-Gm-Message-State: APjAAAVVp2oonEgaVDzeOpkX9/Lj8FIfG7fzo0t0g9XZlosKZWpd01JK
        sTbPsIox5u/wQBmiklaFKxcsZXGeFXI=
X-Google-Smtp-Source: APXvYqxOD+0zXUXva+2i0zi+Xn9j4nvh3S0iQyRFqIDN1u64Pe5Zq3CvSKkNuCQsKp6sFc/HhytNpQ==
X-Received: by 2002:a17:90a:e28e:: with SMTP id d14mr6044078pjz.56.1581713074947;
        Fri, 14 Feb 2020 12:44:34 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id w25sm7996608pfi.106.2020.02.14.12.44.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 12:44:34 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
From:   Jens Axboe <axboe@kernel.dk>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
References: <9FEF0D34-A012-4505-AA4E-FF97CC302A33@eoitek.com>
 <8a3ee653-77ed-105d-c1c3-87087451914e@kernel.dk>
 <ADF462D7-A381-4314-8931-DDB0A2C18761@eoitek.com>
 <9a8e4c8a-f8b2-900d-92b6-cc69b6adf324@gmail.com>
 <5f09d89a-0c6d-47c2-465c-993af0c7ae71@kernel.dk>
 <7E66D70C-BE4E-4236-A49B-9843F66EA322@eoitek.com>
 <671A3FE3-FA12-43D8-ADF0-D1DB463B053F@eoitek.com>
 <217eda7b-3742-a50b-7d6a-c1294a85c8e0@kernel.dk>
 <1b9a7390-7539-a8bc-d437-493253b13d77@kernel.dk>
 <20200214153218.GM14914@hirez.programming.kicks-ass.net>
 <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
Message-ID: <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
Date:   Fri, 14 Feb 2020 13:44:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/20 10:52 AM, Jens Axboe wrote:
> On 2/14/20 9:18 AM, Jens Axboe wrote:
>> On 2/14/20 8:47 AM, Jens Axboe wrote:
>>>> I suspect you meant to put that in finish_task_switch() which is the
>>>> tail end of every schedule(), schedule_tail() is the tail end of
>>>> clone().
>>>>
>>>> Or maybe you meant to put it in (and rename) sched_update_worker() which
>>>> is after every schedule() but in a preemptible context -- much saner
>>>> since you don't want to go add an unbounded amount of work in a
>>>> non-preemptible context.
>>>>
>>>> At which point you already have your callback: io_wq_worker_running(),
>>>> or is this for any random task?
>>>
>>> Let me try and clarify - this isn't for the worker tasks, this is for
>>> any task that is using io_uring. In fact, it's particularly not for the
>>> worker threads, just the task itself.
>>>
>>> I basically want the handler to be called when:
>>>
>>> 1) The task is scheduled in. The poll will complete and stuff some items
>>>    on that task list, and I want to task to process them as it wakes up.
>>>
>>> 2) The task is going to sleep, don't want to leave entries around while
>>>    the task is sleeping.
>>>
>>> 3) I need it to be called from "normal" context, with ints enabled,
>>>    preempt enabled, etc.
>>>
>>> sched_update_worker() (with a rename) looks ideal for #1, and the
>>> context is sane for me. Just need a good spot to put the hook call for
>>> schedule out. I think this:
>>>
>>> 	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER)) {
>>> 		preempt_disable();
>>> 		if (tsk->flags & PF_WQ_WORKER)
>>> 			wq_worker_sleeping(tsk);
>>> 		else
>>> 			io_wq_worker_sleeping(tsk);
>>> 		preempt_enable_no_resched();
>>> 	}
>>>
>>> just needs to go into another helper, and then I can call it there
>>> outside of the preempt.
>>>
>>> I'm sure there are daemons lurking here, but I'll test and see how it
>>> goes...
>>
>> Here's a stab at cleaning it up:
>>
>> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-task-poll
>>
>> top two patches. First one simply cleans up the sched_update_worker(),
>> so we now have sched_in_update() and sched_out_update(). No changes in
>> this patch, just moves the worker sched-out handling into a helper.
>>
>> 2nd patch then utilizes this to flush the per-task requests that may
>> have been queued up.
> 
> In fact, we can go even further. If we have this task handler, then we:
> 
> 1) Never need to go async for poll completion, and we can remove a bunch
>    of code that handles that
> 2) Don't need to worry about nested eventfd notification, that code goes
>    away too
> 3) Don't need the poll llist for batching flushes, that goes away
> 
> In terms of performance, for the single client case we did about 48K
> requests per second on my kvm on the laptop, now we're doing 148K.
> So it's definitely worthwhile... On top of that, diffstat:
> 
>  fs/io_uring.c | 166 +++++++-------------------------------------------
>  1 file changed, 22 insertions(+), 144 deletions(-)

It's now up to 3.5x the original performance for the single client case.
Here's the updated patch, folded with the original that only went half
the way there.


commit b9c04ea10d10cf80f2d2f3b96e1668e523602072
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Feb 14 09:15:29 2020 -0700

    io_uring: add per-task callback handler
    
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

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5a826017ebb8..2756654e2955 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -295,7 +295,6 @@ struct io_ring_ctx {
 
 	struct {
 		spinlock_t		completion_lock;
-		struct llist_head	poll_llist;
 
 		/*
 		 * ->poll_list is protected by the ctx->uring_lock for
@@ -552,19 +551,13 @@ struct io_kiocb {
 	};
 
 	struct io_async_ctx		*io;
-	/*
-	 * llist_node is only used for poll deferred completions
-	 */
-	struct llist_node		llist_node;
 	bool				in_async;
 	bool				needs_fixed_file;
 	u8				opcode;
 
 	struct io_ring_ctx	*ctx;
-	union {
-		struct list_head	list;
-		struct hlist_node	hash_node;
-	};
+	struct list_head	list;
+	struct hlist_node	hash_node;
 	struct list_head	link_list;
 	unsigned int		flags;
 	refcount_t		refs;
@@ -574,6 +567,7 @@ struct io_kiocb {
 
 	struct list_head	inflight_entry;
 
+	struct task_struct	*task;
 	struct io_wq_work	work;
 };
 
@@ -834,7 +828,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
 	spin_lock_init(&ctx->completion_lock);
-	init_llist_head(&ctx->poll_llist);
 	INIT_LIST_HEAD(&ctx->poll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
@@ -1056,24 +1049,19 @@ static inline bool io_should_trigger_evfd(struct io_ring_ctx *ctx)
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
@@ -1238,6 +1226,8 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
 	req->result = 0;
+	/* task will wait for requests on exit, don't need a ref */
+	req->task = current;
 	INIT_IO_WORK(&req->work, io_wq_submit_work);
 	return req;
 fallback:
@@ -3448,15 +3438,22 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
 static void io_poll_remove_one(struct io_kiocb *req)
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
 }
 
 static void io_poll_remove_all(struct io_ring_ctx *ctx)
@@ -3474,6 +3471,8 @@ static void io_poll_remove_all(struct io_ring_ctx *ctx)
 			io_poll_remove_one(req);
 	}
 	spin_unlock_irq(&ctx->completion_lock);
+
+	io_cqring_ev_posted(ctx);
 }
 
 static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
@@ -3539,92 +3538,18 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
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
-}
-
-static void io_poll_trigger_evfd(struct io_wq_work **workptr)
-{
-	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-
-	eventfd_signal(req->ctx->cq_ev_fd, 1);
-	io_put_req(req);
 }
 
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
@@ -3632,8 +3557,9 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 {
 	struct io_poll_iocb *poll = wait->private;
 	struct io_kiocb *req = container_of(poll, struct io_kiocb, poll);
-	struct io_ring_ctx *ctx = req->ctx;
 	__poll_t mask = key_to_poll(key);
+	struct task_struct *tsk;
+	unsigned long flags;
 
 	/* for instances that support it check for an event match first: */
 	if (mask && !(mask & poll->events))
@@ -3641,46 +3567,12 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 
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
+	raw_spin_lock_irqsave(&tsk->uring_lock, flags);
+	list_add_tail(&req->list, &tsk->uring_work);
+	raw_spin_unlock_irqrestore(&tsk->uring_lock, flags);
+	wake_up_process(tsk);
 	return 1;
 }
 
@@ -3739,7 +3631,6 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 	bool cancel = false;
 	__poll_t mask;
 
-	INIT_IO_WORK(&req->work, io_poll_complete_work);
 	INIT_HLIST_NODE(&req->hash_node);
 
 	poll->head = NULL;
@@ -5243,6 +5134,28 @@ static int io_wake_function(struct wait_queue_entry *curr, unsigned int mode,
 	return autoremove_wake_function(curr, mode, wake_flags, key);
 }
 
+void io_uring_task_handler(struct task_struct *tsk)
+{
+	LIST_HEAD(local_list);
+	struct io_kiocb *req;
+
+	raw_spin_lock_irq(&tsk->uring_lock);
+	if (!list_empty(&tsk->uring_work))
+		list_splice_init(&tsk->uring_work, &local_list);
+	raw_spin_unlock_irq(&tsk->uring_lock);
+
+	while (!list_empty(&local_list)) {
+		struct io_kiocb *nxt = NULL;
+
+		req = list_first_entry(&local_list, struct io_kiocb, list);
+		list_del(&req->list);
+
+		io_poll_task_handler(req, &nxt);
+		if (nxt)
+			__io_queue_sqe(nxt, NULL);
+	}
+}
+
 /*
  * Wait until events become available, if we don't already have some. The
  * application must reap them itself, as they reside on the shared cq ring.
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 04278493bf15..447b06c6bed0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -685,6 +685,11 @@ struct task_struct {
 #endif
 	struct sched_dl_entity		dl;
 
+#ifdef CONFIG_IO_URING
+	struct list_head		uring_work;
+	raw_spinlock_t			uring_lock;
+#endif
+
 #ifdef CONFIG_UCLAMP_TASK
 	/* Clamp values requested for a scheduling entity */
 	struct uclamp_se		uclamp_req[UCLAMP_CNT];
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 51ca491d99ed..170fefa1caf8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2717,6 +2717,11 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 	INIT_HLIST_HEAD(&p->preempt_notifiers);
 #endif
 
+#ifdef CONFIG_IO_URING
+	INIT_LIST_HEAD(&p->uring_work);
+	raw_spin_lock_init(&p->uring_lock);
+#endif
+
 #ifdef CONFIG_COMPACTION
 	p->capture_control = NULL;
 #endif
@@ -4104,6 +4109,20 @@ void __noreturn do_task_dead(void)
 		cpu_relax();
 }
 
+#ifdef CONFIG_IO_URING
+extern void io_uring_task_handler(struct task_struct *tsk);
+
+static inline void io_uring_handler(struct task_struct *tsk)
+{
+	if (!list_empty(&tsk->uring_work))
+		io_uring_task_handler(tsk);
+}
+#else /* !CONFIG_IO_URING */
+static inline void io_uring_handler(struct task_struct *tsk)
+{
+}
+#endif
+
 static void sched_out_update(struct task_struct *tsk)
 {
 	/*
@@ -4121,6 +4140,7 @@ static void sched_out_update(struct task_struct *tsk)
 			io_wq_worker_sleeping(tsk);
 		preempt_enable_no_resched();
 	}
+	io_uring_handler(tsk);
 }
 
 static void sched_in_update(struct task_struct *tsk)
@@ -4131,6 +4151,7 @@ static void sched_in_update(struct task_struct *tsk)
 		else
 			io_wq_worker_running(tsk);
 	}
+	io_uring_handler(tsk);
 }
 
 static inline void sched_submit_work(struct task_struct *tsk)

-- 
Jens Axboe

