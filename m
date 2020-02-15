Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D1D6E15FD04
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 07:01:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725797AbgBOGBi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 01:01:38 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:39470 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbgBOGBh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 01:01:37 -0500
Received: by mail-pf1-f194.google.com with SMTP id 84so6023584pfy.6
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2020 22:01:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6z9aIIwQaSPSkvipntOGsmU/CzKW7xKVTg0l2N+a3q4=;
        b=famz0c34DqGYV+1u0WKuMb6x3xcZpCySiaPxF5lkmhlC2HFa0GXkL0cQMbrcwOsTQt
         C2kRMQCl1hQtIqBu+K+r9zsWi3txkeL9UFXFEX05R3wdAzUqtNKhSn1XvGy7Q3F/PfBO
         vdiFaICcW+wSDlDZ21txzU3rD8YCgGemfHe4Cs/7rE3ISjpNwjayJ1yaFZ2bmdlCW0dQ
         TWusmMwCjuXnSC4aYyMW625c9iUpceUZBtwzPy/U28RMLC1n3kK1W54WELGZwW0GT7Qt
         8otG4693ADug49kZPCa1iadXUMCdqHkk8MnV4yZ96ZG6oWv/BOJTZmtXSlgwHRG8EjGn
         jWJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6z9aIIwQaSPSkvipntOGsmU/CzKW7xKVTg0l2N+a3q4=;
        b=aF3qi8OLovpz9ysKi/XctxgMsrlZc/6rZB0e3h+lIXK5BwpO5vcyZA/OOGAnyBKZ2k
         4Lgb6Iy8YfKm3X2r3AB3Qe2jD0kSC5iPfJgV+X7/n5F/o+7Ilak2W1P6F3lvi62nsBj2
         FbssRkNV4y7VGBYYB9cYzu+E5cdMK+Hv64eZioAj9ayWks4P9YevBCaJrvP/Uwa63KsT
         trY9y+J90I/x+ckh3J9KU1uf8S/TBPzlRXHlSVjvTWJJCNJ8UJa1xcD+D8MhPlI3unn5
         0xjwnaeknR2eM1L0bxEXetSklcl4v3fiuaspUc27s1840jvPxirATncRqHuvnXLGnfCA
         5KSA==
X-Gm-Message-State: APjAAAUtFMpJ1/9Xb4wyMX08OJcaaNRITxViL9NoVsxxvldpszyZ29v6
        G5xmZoOVNrf+ypWjdjfIJcGoJDRkAS0=
X-Google-Smtp-Source: APXvYqxDXDFMKYJX9+YfP9L1I7LnAsd626YOhu1KHmbiHSU4KXpVUay+rgFVrHKmgHLUu385lOVpJg==
X-Received: by 2002:a63:2bc3:: with SMTP id r186mr7218580pgr.294.1581746494946;
        Fri, 14 Feb 2020 22:01:34 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id y18sm9153449pfe.19.2020.02.14.22.01.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Feb 2020 22:01:34 -0800 (PST)
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
From:   Jens Axboe <axboe@kernel.dk>
To:     =?UTF-8?B?Q2FydGVyIExpIOadjumAmua0sg==?= <carter.li@eoitek.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
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
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <FA1CECBA-FBFE-4228-BA5C-1B8A4A2B3534@eoitek.com>
 <f1610a65-0bf9-8134-3e8d-72cccd2f5468@kernel.dk>
 <72423161-38EF-49D1-8229-18C328AB5DA1@eoitek.com>
 <3124507b-3458-48da-27e0-abeefcd9eb08@kernel.dk>
Message-ID: <5cba3020-7d99-56b0-8927-f679118c90e9@kernel.dk>
Date:   Fri, 14 Feb 2020 23:01:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <3124507b-3458-48da-27e0-abeefcd9eb08@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/20 6:27 PM, Jens Axboe wrote:
> On 2/14/20 6:25 PM, Carter Li 李通洲 wrote:
>> There are at least 2 benefits over POLL->READ
>>
>> 1. Reduce a little complexity of user code, and save lots of sqes.
>> 2. Better performance. Users can’t if an operation will block without
>> issuing an extra O_NONBLOCK syscall, which ends up with always using
>> POLL->READ link. If it’s handled by kernel, we may only poll when
>> we know it’s needed.
> 
> Exactly, it'll enable the app to do read/recv or write/send without
> having to worry about anything, and it'll be as efficient as having
> it linked to a poll command.

Couldn't help myself... The below is the general direction, but not
done by any stretch of the imagination. There are a few hacks in there.
But, in short, it does allow eg send/recv to behave in an async manner
without needing the thread offload. Tested it with the test/send_recv
and test/send_recvmsg test apps, and it works there. There seems to be
some weird issue with eg test/socket-rw, not sure what that is yet.

Just wanted to throw it out there. It's essentially the same as the
linked poll, except it's just done internally.


commit d1fc97c5f132eaf39c06783925bd11dca9fa3ecd
Author: Jens Axboe <axboe@kernel.dk>
Date:   Fri Feb 14 22:23:12 2020 -0700

    io_uring: use poll driven retry for files that support it
    
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
    
    Note that this is very much a work-in-progress, and it doesn't (yet) pass
    the full test suite. Notable missing features:
    
    - With the work queued up async, we have a common method for locating it
      for cancelation purposes. I need to add cancel tracking for poll
      managed requests.
    
    - Need to double check req->apoll life time.
    
    - Probably a lot I don't quite recall right now...
    
    It does work for the basic read/write, send/recv, etc testing I've
    tried.
    
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fb94b8bac638..530dcd91fa53 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -577,6 +577,7 @@ struct io_kiocb {
 		struct {
 			struct task_struct	*task;
 			struct list_head	task_list;
+			struct io_poll_iocb	*apoll;
 		};
 		struct io_wq_work	work;
 	};
@@ -623,6 +624,9 @@ struct io_op_def {
 	unsigned		file_table : 1;
 	/* needs ->fs */
 	unsigned		needs_fs : 1;
+	/* set if opcode supports polled "wait" */
+	unsigned		pollin : 1;
+	unsigned		pollout : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -632,6 +636,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_WRITEV] = {
 		.async_ctx		= 1,
@@ -639,6 +644,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_FSYNC] = {
 		.needs_file		= 1,
@@ -646,11 +652,13 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_READ_FIXED] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_WRITE_FIXED] = {
 		.needs_file		= 1,
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
@@ -666,6 +674,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.needs_fs		= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_RECVMSG] = {
 		.async_ctx		= 1,
@@ -673,6 +682,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.needs_fs		= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_TIMEOUT] = {
 		.async_ctx		= 1,
@@ -684,6 +694,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.file_table		= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_ASYNC_CANCEL] = {},
 	[IORING_OP_LINK_TIMEOUT] = {
@@ -695,6 +706,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
@@ -723,11 +735,13 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_WRITE] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
@@ -739,11 +753,13 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
 	},
 	[IORING_OP_RECV] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
 	},
 	[IORING_OP_OPENAT2] = {
 		.needs_file		= 1,
@@ -2228,6 +2244,139 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	return 0;
 }
 
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
+	__io_queue_proc(pt->req->apoll, pt, head);
+}
+
+static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
+			   __poll_t mask)
+{
+	struct task_struct *tsk;
+	unsigned long flags;
+
+	/* for instances that support it check for an event match first: */
+	if (mask && !(mask & poll->events))
+		return 0;
+
+	list_del_init(&poll->wait.entry);
+
+	tsk = req->task;
+	req->result = mask;
+	spin_lock_irqsave(&tsk->uring_lock, flags);
+	list_add_tail(&req->task_list, &tsk->uring_work);
+	spin_unlock_irqrestore(&tsk->uring_lock, flags);
+	wake_up_process(tsk);
+	return 1;
+}
+
+static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
+			void *key)
+{
+	struct io_kiocb *req = wait->private;
+	struct io_poll_iocb *poll = req->apoll;
+
+	trace_io_uring_poll_wake(req->ctx, req->opcode, req->user_data, key_to_poll(key));
+	return __io_async_wake(req, poll, key_to_poll(key));
+}
+
+static bool io_arm_poll_handler(struct io_kiocb *req, int *retry_count)
+{
+	const struct io_op_def *def = &io_op_defs[req->opcode];
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_poll_iocb *poll;
+	struct io_poll_table ipt;
+	bool cancel = false;
+	__poll_t mask;
+
+	if (!file_can_poll(req->file))
+		return false;
+	if (req->flags & REQ_F_MUST_PUNT)
+		return false;
+	if (!def->pollin && !def->pollout)
+		return false;
+
+	poll = kmalloc(sizeof(*poll), GFP_ATOMIC);
+	if (unlikely(!poll))
+		return false;
+
+	req->task = current;
+	INIT_LIST_HEAD(&req->task_list);
+	req->apoll = poll;
+
+	if (def->pollin)
+		mask = POLLIN;
+	if (def->pollout)
+		mask |= POLLOUT;
+
+	poll->file = req->file;
+	poll->head = NULL;
+	poll->done = poll->canceled = false;
+	poll->events = mask;
+	ipt.pt._qproc = io_async_queue_proc;
+	ipt.pt._key = mask;
+	ipt.req = req;
+	ipt.error = -EINVAL;
+
+	INIT_LIST_HEAD(&poll->wait.entry);
+	init_waitqueue_func_entry(&poll->wait, io_async_wake);
+	poll->wait.private = req;
+
+	mask = vfs_poll(req->file, &ipt.pt) & poll->events;
+
+	spin_lock_irq(&ctx->completion_lock);
+	if (likely(poll->head)) {
+		spin_lock(&poll->head->lock);
+		if (unlikely(list_empty(&poll->wait.entry))) {
+			if (ipt.error)
+				cancel = true;
+			ipt.error = 0;
+			mask = 0;
+		}
+		if (mask || ipt.error)
+			list_del_init(&poll->wait.entry);
+		else if (cancel)
+			WRITE_ONCE(poll->canceled, true);
+#if 0
+		Needs tracking for cancelation
+		else if (!poll->done) /* actually waiting for an event */
+			io_poll_req_insert(req);
+#endif
+		spin_unlock(&poll->head->lock);
+	}
+	if (mask) {
+		ipt.error = 0;
+		poll->done = true;
+		(*retry_count)++;
+	}
+	spin_unlock_irq(&ctx->completion_lock);
+	trace_io_uring_poll_arm(ctx, req->opcode, req->user_data, mask,
+					poll->events);
+	return true;
+}
+
 static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 		   bool force_nonblock)
 {
@@ -3569,44 +3718,16 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 {
 	struct io_poll_iocb *poll = wait->private;
 	struct io_kiocb *req = container_of(poll, struct io_kiocb, poll);
-	__poll_t mask = key_to_poll(key);
-	struct task_struct *tsk;
-	unsigned long flags;
-
-	/* for instances that support it check for an event match first: */
-	if (mask && !(mask & poll->events))
-		return 0;
-
-	list_del_init(&poll->wait.entry);
 
-	tsk = req->task;
-	req->result = mask;
-	spin_lock_irqsave(&tsk->uring_lock, flags);
-	list_add_tail(&req->task_list, &tsk->uring_work);
-	spin_unlock_irqrestore(&tsk->uring_lock, flags);
-	wake_up_process(tsk);
-	return 1;
+	return __io_async_wake(req, poll, key_to_poll(key));
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
+	__io_queue_proc(&pt->req->poll, pt, head);
 }
 
 static void io_poll_req_insert(struct io_kiocb *req)
@@ -4617,11 +4738,13 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_kiocb *linked_timeout;
 	struct io_kiocb *nxt = NULL;
+	int retry_count = 0;
 	int ret;
 
 again:
 	linked_timeout = io_prep_linked_timeout(req);
 
+issue:
 	ret = io_issue_sqe(req, sqe, &nxt, true);
 
 	/*
@@ -4630,6 +4753,14 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	 */
 	if (ret == -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
 	    (req->flags & REQ_F_MUST_PUNT))) {
+
+		if (io_arm_poll_handler(req, &retry_count)) {
+			if (retry_count == 1)
+				goto issue;
+			else if (!retry_count)
+				goto done_req;
+			INIT_IO_WORK(&req->work, io_wq_submit_work);
+		}
 punt:
 		if (io_op_defs[req->opcode].file_table) {
 			ret = io_grab_files(req);
@@ -5154,26 +5285,40 @@ void io_uring_task_handler(struct task_struct *tsk)
 {
 	LIST_HEAD(local_list);
 	struct io_kiocb *req;
+	long state;
 
 	spin_lock_irq(&tsk->uring_lock);
 	if (!list_empty(&tsk->uring_work))
 		list_splice_init(&tsk->uring_work, &local_list);
 	spin_unlock_irq(&tsk->uring_lock);
 
+	state = current->state;
+	__set_current_state(TASK_RUNNING);
 	while (!list_empty(&local_list)) {
 		struct io_kiocb *nxt = NULL;
+		void *to_free = NULL;
 
 		req = list_first_entry(&local_list, struct io_kiocb, task_list);
 		list_del(&req->task_list);
 
-		io_poll_task_handler(req, &nxt);
+		if (req->opcode == IORING_OP_POLL_ADD) {
+			io_poll_task_handler(req, &nxt);
+		} else {
+			nxt = req;
+			to_free = req->apoll;
+			WARN_ON_ONCE(!list_empty(&req->apoll->wait.entry));
+		}
 		if (nxt)
 			__io_queue_sqe(nxt, NULL);
 
+		kfree(to_free);
+
 		/* finish next time, if we're out of time slice */
-		if (need_resched())
+		if (need_resched() && !(current->flags & PF_EXITING))
 			break;
 	}
+	WARN_ON_ONCE(current->state != TASK_RUNNING);
+	__set_current_state(state);
 
 	if (!list_empty(&local_list)) {
 		spin_lock_irq(&tsk->uring_lock);
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 27bd9e4f927b..133a16472423 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -357,6 +357,60 @@ TRACE_EVENT(io_uring_submit_sqe,
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
 #endif /* _TRACE_IO_URING_H */
 
 /* This part must be outside protection */
diff --git a/kernel/exit.c b/kernel/exit.c
index 2833ffb0c211..988799763f34 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -716,6 +716,7 @@ void __noreturn do_exit(long code)
 	profile_task_exit(tsk);
 	kcov_task_exit(tsk);
 
+	WARN_ON(!list_empty(&tsk->uring_work));
 	WARN_ON(blk_needs_flush_plug(tsk));
 
 	if (unlikely(in_interrupt()))

-- 
Jens Axboe

