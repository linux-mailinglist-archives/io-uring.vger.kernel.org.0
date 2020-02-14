Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A7A015F020
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 18:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729345AbgBNRwr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 12:52:47 -0500
Received: from mail-il1-f196.google.com ([209.85.166.196]:44942 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388347AbgBNRwp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 12:52:45 -0500
Received: by mail-il1-f196.google.com with SMTP id s85so8747842ill.11
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 09:52:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8O2NXXpydF8IPu+btBFrNU3vzOdcp6Kz5iRRdVOldac=;
        b=hl57dHHEVzqBjxa0cHbfQq1RIxYtjsuu/M/E7tXqpRIcdQbDZlUlUuvKI9PPBmKCbJ
         SQRlOsrcQe4CH4fbj9VWokum29nCLVm/sySyJ/JB7R+kLcCt4RoLH4t9FgIFBNpbf6Kv
         WyMOncf4MQxyJP/ATKiklW+NDLIOmlgWKk8HJjfAVTgRTE/jDpQJ0PoDjdejbL0O84lr
         aUzdnC/Alu+O8RoIlKtKPQm7azTkTb3mp7hm1Dkpg5nwcNIXH82iHCwdf6KZALk2KghS
         uUXVkvcAI8K35N66cQ9GVpFpwvqjYKYOZU9K8SeXvr2eGZhYKMfWTbr/khO6WWkE5Hxa
         cx7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8O2NXXpydF8IPu+btBFrNU3vzOdcp6Kz5iRRdVOldac=;
        b=jLAQ9NH3BOw4NWDOG/6mZXIFfYihhUAt51RBSNqBmWttE8ncWt/pvqPzPRGa6rmtPW
         zyNHlBPtT6375T5FabaM2UsP5FKidvCRnaRvZArVu9B804aUcIo040zcCGtnX+Nm++zd
         F59F91XS2YRZM+5ixqD6ahgvSVPos5d4POdSvRVy+OZeRgHh9RftAwaWlIgN8afeeI2h
         jNEeX7TOjTrKhd4eDFYgPnoc4qKW/x+wcNQjvMt3dmWQI0PPDNCxQFj90TVOBuDQft9Q
         W4qtjRv9UTNhgp4topU+uYAuKYwHzFuqYXDjGVpOKmV4CrqWWCLoKhrwjjOyAFmJqbZd
         c5cg==
X-Gm-Message-State: APjAAAWntv65HSm8cNZsL8LRv8+efxiAeTmBOpdUJdE/HJ4nI9rsgeT8
        hm2BJ5L+SoQ1UkMvy+BYNbq01fk34JU=
X-Google-Smtp-Source: APXvYqx4AyeRsuYXcmKT9h6iJfSGtJlmBpMcu58fRr8X8d/hTwLAJRKayKNZKgKMopcb11OGkHxORw==
X-Received: by 2002:a92:9107:: with SMTP id t7mr4120726ild.51.1581702764569;
        Fri, 14 Feb 2020 09:52:44 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id z20sm1622355iof.48.2020.02.14.09.52.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 09:52:44 -0800 (PST)
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
Message-ID: <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
Date:   Fri, 14 Feb 2020 10:52:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/20 9:18 AM, Jens Axboe wrote:
> On 2/14/20 8:47 AM, Jens Axboe wrote:
>>> I suspect you meant to put that in finish_task_switch() which is the
>>> tail end of every schedule(), schedule_tail() is the tail end of
>>> clone().
>>>
>>> Or maybe you meant to put it in (and rename) sched_update_worker() which
>>> is after every schedule() but in a preemptible context -- much saner
>>> since you don't want to go add an unbounded amount of work in a
>>> non-preemptible context.
>>>
>>> At which point you already have your callback: io_wq_worker_running(),
>>> or is this for any random task?
>>
>> Let me try and clarify - this isn't for the worker tasks, this is for
>> any task that is using io_uring. In fact, it's particularly not for the
>> worker threads, just the task itself.
>>
>> I basically want the handler to be called when:
>>
>> 1) The task is scheduled in. The poll will complete and stuff some items
>>    on that task list, and I want to task to process them as it wakes up.
>>
>> 2) The task is going to sleep, don't want to leave entries around while
>>    the task is sleeping.
>>
>> 3) I need it to be called from "normal" context, with ints enabled,
>>    preempt enabled, etc.
>>
>> sched_update_worker() (with a rename) looks ideal for #1, and the
>> context is sane for me. Just need a good spot to put the hook call for
>> schedule out. I think this:
>>
>> 	if (tsk->flags & (PF_WQ_WORKER | PF_IO_WORKER)) {
>> 		preempt_disable();
>> 		if (tsk->flags & PF_WQ_WORKER)
>> 			wq_worker_sleeping(tsk);
>> 		else
>> 			io_wq_worker_sleeping(tsk);
>> 		preempt_enable_no_resched();
>> 	}
>>
>> just needs to go into another helper, and then I can call it there
>> outside of the preempt.
>>
>> I'm sure there are daemons lurking here, but I'll test and see how it
>> goes...
> 
> Here's a stab at cleaning it up:
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=io_uring-task-poll
> 
> top two patches. First one simply cleans up the sched_update_worker(),
> so we now have sched_in_update() and sched_out_update(). No changes in
> this patch, just moves the worker sched-out handling into a helper.
> 
> 2nd patch then utilizes this to flush the per-task requests that may
> have been queued up.

In fact, we can go even further. If we have this task handler, then we:

1) Never need to go async for poll completion, and we can remove a bunch
   of code that handles that
2) Don't need to worry about nested eventfd notification, that code goes
   away too
3) Don't need the poll llist for batching flushes, that goes away

In terms of performance, for the single client case we did about 48K
requests per second on my kvm on the laptop, now we're doing 148K.
So it's definitely worthwhile... On top of that, diffstat:

 fs/io_uring.c | 166 +++++++-------------------------------------------
 1 file changed, 22 insertions(+), 144 deletions(-)


diff --git a/fs/io_uring.c b/fs/io_uring.c
index a683d7a08003..1e436b732f2a 100644
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
@@ -835,7 +828,6 @@ static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->wait);
 	spin_lock_init(&ctx->completion_lock);
-	init_llist_head(&ctx->poll_llist);
 	INIT_LIST_HEAD(&ctx->poll_list);
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
@@ -932,8 +924,6 @@ static inline void io_req_work_grab_env(struct io_kiocb *req,
 	}
 	if (!req->work.task_pid)
 		req->work.task_pid = task_pid_vnr(current);
-	if (!req->task)
-		req->task = get_task_struct(current);
 }
 
 static inline void io_req_work_drop_env(struct io_kiocb *req)
@@ -3545,92 +3535,18 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 	io_commit_cqring(ctx);
 }
 
-static void io_poll_complete_work(struct io_wq_work **workptr)
+static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe);
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
-
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
@@ -3638,8 +3554,9 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 {
 	struct io_poll_iocb *poll = wait->private;
 	struct io_kiocb *req = container_of(poll, struct io_kiocb, poll);
-	struct io_ring_ctx *ctx = req->ctx;
 	__poll_t mask = key_to_poll(key);
+	struct task_struct *tsk;
+	unsigned long flags;
 
 	/* for instances that support it check for an event match first: */
 	if (mask && !(mask & poll->events))
@@ -3647,56 +3564,12 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 
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
-				struct io_kiocb *nxt = NULL;
-
-				req->flags |= REQ_F_COMP_LOCKED;
-				io_put_req_find_next(req, &nxt);
-				if (nxt) {
-					struct task_struct *tsk = nxt->task;
-
-					raw_spin_lock(&tsk->uring_lock);
-					list_add_tail(&nxt->list, &tsk->uring_work);
-					raw_spin_unlock(&tsk->uring_lock);
-					/* do we need to wake tsk here??? */
-				}
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
 
@@ -3755,7 +3628,6 @@ static int io_poll_add(struct io_kiocb *req, struct io_kiocb **nxt)
 	bool cancel = false;
 	__poll_t mask;
 
-	INIT_IO_WORK(&req->work, io_poll_complete_work);
 	INIT_HLIST_NODE(&req->hash_node);
 
 	poll->head = NULL;
@@ -4863,6 +4735,8 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		return false;
 	}
 
+	req->task = get_task_struct(current);
+
 	/*
 	 * If we already have a head request, queue this one for async
 	 * submittal once the head completes. If we don't have a head but
@@ -5270,10 +5144,14 @@ void io_uring_task_handler(struct task_struct *tsk)
 	raw_spin_unlock_irq(&tsk->uring_lock);
 
 	while (!list_empty(&local_list)) {
+		struct io_kiocb *nxt = NULL;
+
 		req = list_first_entry(&local_list, struct io_kiocb, list);
 		list_del(&req->list);
 
-		__io_queue_sqe(req, NULL);
+		io_poll_task_handler(req, &nxt);
+		if (nxt)
+			__io_queue_sqe(req, NULL);
 	}
 }
 

-- 
Jens Axboe

