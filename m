Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951BB32DB21
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 21:25:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbhCDUYV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 15:24:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234662AbhCDUYQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 15:24:16 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 074A3C061756
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 12:23:36 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id f20so31198262ioo.10
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 12:23:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=MICWK7/wHfjVXHZfeYLYdvcTl+EdSA4UhhG+QR+blTQ=;
        b=civg7YxVnN8tbBiHJhZL0SYWsJZ/aSODiIW55y1YBhyp5JH8R/d+B3yFH2I2A6WObu
         boUKHbEw9TMOp/L17vhGG78NGXIsKvuANiQqr31FQJoxAHMvSpiTHP3SEe36IiNTb7hw
         Gh4E4USWOkgZIL+Pc560wRkbhseSeDSVanlq6va2rAjfMFJCeGY0YC0kLO3CD6lIffgI
         CxpfedfFBRe/BUxtvAcuWlnSAP4PnKew/s7E95uZiuQF5OLkIWTFZyC9idmULa1kAap+
         srwDuXkK2GYGPImyj34Oel3Bic1t386+yNMtqweSb8b2UjuuZo4AujMRHbmFoYqPHzi5
         MJTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=MICWK7/wHfjVXHZfeYLYdvcTl+EdSA4UhhG+QR+blTQ=;
        b=qDwfZoAhgvkS/nCBsOFjhNPeNofRi0r28k3xUh8ismruZF9GOr7SrNbVfvz61zCLoI
         jOuzdcWMJT9CVHMEosamtCGbk0PkyY5tObLa14zjVKP1qe+BYk9YnYhOoKamF7wxm28E
         1i542PV0pqt9Kwe2REqw+0c9quCbtLVVIl5wUnP0rZto/HXY1X9OCmAxTqXXYHfkhFZ4
         2RLiw69A5H4ijTuwPjpV/+/y80+Ip0bJy75oB9gu6lCrUqKPa3pyOyUCRAel0Y9TjxE4
         haKJEpADZwJQNxPQB6vFXTkbxM00RXUnnagHZK/j49YMLHB2rShfggHwfm7LCGzTCKNT
         w1jg==
X-Gm-Message-State: AOAM530JPmsfPQg3dhSgMU5NWmkjeUcdsi7L7W9rOxjLO6hFea8fVUMs
        neKHpMyrtzKulUMyW2WrqqCG6lZ11LWZxQ==
X-Google-Smtp-Source: ABdhPJwlJaK6y6+23xgjAGAgjaWXkQ5A3wqxlBGpj5z1XRf5HRbAGp5GR9mc9Q3j+PWtG9uiVwIEIQ==
X-Received: by 2002:a05:6638:1648:: with SMTP id a8mr5795835jat.25.1614889415305;
        Thu, 04 Mar 2021 12:23:35 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id b19sm164537ioj.50.2021.03.04.12.23.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 12:23:33 -0800 (PST)
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Stefan Metzmacher <metze@samba.org>,
        io-uring <io-uring@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Al Viro <viro@zeniv.linux.org.uk>
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-10-axboe@kernel.dk>
 <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org>
 <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
 <a9f58269-b260-6281-4e83-43cb5e881d25@samba.org>
 <d3dfc422-8762-0078-bc80-989f1d71f006@samba.org>
 <32f1218b-49c3-eeb6-5866-3ec45acbc1c5@kernel.dk>
 <34857989-ff46-b2a7-9730-476636848acc@samba.org>
 <47c76a83-a449-3a65-5850-1d3dff4f3249@kernel.dk>
 <09579257-8d8e-8f25-6ceb-eea4f5596eb3@kernel.dk>
 <CAHk-=wgqJdq6GjydKoAb41K9QX5Q8XMLA2dPaM3a3xqQQa_ygg@mail.gmail.com>
 <f42dcb4e-5044-33ed-9563-c91b9f8b7e64@kernel.dk>
 <CAHk-=wj8BnbsSKWx=kUFPqpoohDdPchsW00c4L-x6ES8bOWLSg@mail.gmail.com>
 <bcab873a-eced-b906-217f-c52a113a95a9@kernel.dk>
 <7dc54165-ac8a-ab3b-c03d-9e696b8a577e@kernel.dk>
Message-ID: <d0eb6092-cbc9-dd37-e49f-6ff8c6b8b136@kernel.dk>
Date:   Thu, 4 Mar 2021 13:23:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7dc54165-ac8a-ab3b-c03d-9e696b8a577e@kernel.dk>
Content-Type: multipart/mixed;
 boundary="------------08BD5CF4CE25B7C4BC17324E"
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------08BD5CF4CE25B7C4BC17324E
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 3/4/21 1:00 PM, Jens Axboe wrote:
> On 3/4/21 12:54 PM, Jens Axboe wrote:
>> On 3/4/21 12:46 PM, Linus Torvalds wrote:
>>> On Thu, Mar 4, 2021 at 11:19 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> Took a quick look at this, and I agree that's _much_ better. In fact, it
>>>> boils down to just calling copy_process() and then having the caller do
>>>> wake_up_new_task(). So not sure if it's worth adding an
>>>> create_io_thread() helper, or just make copy_process() available
>>>> instead. This is ignoring the trace point for now...
>>>
>>> I really don't want to expose copy_process() outside of kernel/fork.c.
>>>
>>> The whole three-phase "copy - setup - activate" model is a really
>>> really good thing, and it's how we've done things internally almost
>>> forever, but I really don't want to expose those middle stages to any
>>> outsiders.
>>>
>>> So I'd really prefer a simple new "create_io_worker()", even if it's
>>> literally just some four-line function that does
>>>
>>>    p = copy_process(..);
>>>    if (!IS_ERR(p)) {
>>>       block all signals in p
>>>       set PF_IO_WORKER flag
>>>       wake_up_new_task(p);
>>>    }
>>>    return p;
>>>
>>> I very much want that to be inside kernel/fork.c and have all these
>>> rules about creating new threads localized there.
>>
>> I agree, here are the two current patches. Just need to add the signal
>> blocking, which I'd love to do in create_io_thread(), but seems to
>> require either an allocation or provide a helper to do it in the thread
>> itself (with an on-stack mask).
> 
> Nevermind, it's actually copied, so we can do it in create_io_thread().
> I know you'd prefer not to expose the 'task created but not active' state,
> but:
> 
> 1) That allows us to do further setup in the creator and hence eliminate
>    wait+complete for that
> 
> 2) It's not exported, so not available to drivers etc.
> 

Here's a version that includes the signal blocking too, inside the
create_io_thread() helper. I'll run this through the usual testing.

-- 
Jens Axboe


--------------08BD5CF4CE25B7C4BC17324E
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-kernel-provide-create_io_thread-helper.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-kernel-provide-create_io_thread-helper.patch"

From 81910fbd73e7eecea2827c407dbcaab49085c5e3 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 4 Mar 2021 12:21:05 -0700
Subject: [PATCH 1/2] kernel: provide create_io_thread() helper

Provide a generic helper for setting up an io_uring worker. Returns a
task_struct so that the caller can do whatever setup is needed, then call
wake_up_new_task() to kick it into gear.

Add a kernel_clone_args member, io_thread, which tells copy_process() to
mark the task with PF_IO_WORKER.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/sched/task.h |  2 ++
 kernel/fork.c              | 28 ++++++++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/sched/task.h b/include/linux/sched/task.h
index c0f71f2e7160..ef02be869cf2 100644
--- a/include/linux/sched/task.h
+++ b/include/linux/sched/task.h
@@ -31,6 +31,7 @@ struct kernel_clone_args {
 	/* Number of elements in *set_tid */
 	size_t set_tid_size;
 	int cgroup;
+	int io_thread;
 	struct cgroup *cgrp;
 	struct css_set *cset;
 };
@@ -82,6 +83,7 @@ extern void exit_files(struct task_struct *);
 extern void exit_itimers(struct signal_struct *);
 
 extern pid_t kernel_clone(struct kernel_clone_args *kargs);
+struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node);
 struct task_struct *fork_idle(int);
 struct mm_struct *copy_init_mm(void);
 extern pid_t kernel_thread(int (*fn)(void *), void *arg, unsigned long flags);
diff --git a/kernel/fork.c b/kernel/fork.c
index d66cd1014211..08708865c58f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1940,6 +1940,8 @@ static __latent_entropy struct task_struct *copy_process(
 	p = dup_task_struct(current, node);
 	if (!p)
 		goto fork_out;
+	if (args->io_thread)
+		p->flags |= PF_IO_WORKER;
 
 	/*
 	 * This _must_ happen before we call free_task(), i.e. before we jump
@@ -2410,6 +2412,32 @@ struct mm_struct *copy_init_mm(void)
 	return dup_mm(NULL, &init_mm);
 }
 
+/*
+ * This is like kernel_clone(), but shaved down and tailored to just
+ * creating io_uring workers. It returns a created task, or an error pointer.
+ * The returned task is inactive, and the caller must fire it up through
+ * wake_up_new_task(p). All signals are blocked in the created task.
+ */
+struct task_struct *create_io_thread(int (*fn)(void *), void *arg, int node)
+{
+	unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
+				CLONE_IO|SIGCHLD;
+	struct kernel_clone_args args = {
+		.flags		= ((lower_32_bits(flags) | CLONE_VM |
+				    CLONE_UNTRACED) & ~CSIGNAL),
+		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
+		.stack		= (unsigned long)fn,
+		.stack_size	= (unsigned long)arg,
+		.io_thread	= 1,
+	};
+	struct task_struct *tsk;
+
+	tsk = copy_process(NULL, 0, node, &args);
+	if (!IS_ERR(tsk))
+		sigfillset(&tsk->blocked);
+	return tsk;
+}
+
 /*
  *  Ok, this is the main fork-routine.
  *
-- 
2.30.1


--------------08BD5CF4CE25B7C4BC17324E
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-move-to-using-create_io_thread.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-io_uring-move-to-using-create_io_thread.patch"

From f11913b472cdc46082466dbb6cd56f105e5dcdd7 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 4 Mar 2021 12:39:36 -0700
Subject: [PATCH 2/2] io_uring: move to using create_io_thread()

This allows us to do task creation and setup without needing to use
completions to try and synchronize with the starting thread. Get rid of
the old io_wq_fork_thread() wrapper, and the 'wq' and 'worker' startup
completion events - we can now do setup before the task is running.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 69 ++++++++++++++-------------------------------------
 fs/io-wq.h    |  2 --
 fs/io_uring.c | 36 +++++++++++++--------------
 3 files changed, 35 insertions(+), 72 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 19f18389ead2..cee41b81747c 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -54,7 +54,6 @@ struct io_worker {
 	spinlock_t lock;
 
 	struct completion ref_done;
-	struct completion started;
 
 	struct rcu_head rcu;
 };
@@ -116,7 +115,6 @@ struct io_wq {
 	struct io_wq_hash *hash;
 
 	refcount_t refs;
-	struct completion started;
 	struct completion exited;
 
 	atomic_t worker_refs;
@@ -273,14 +271,6 @@ static void io_wqe_dec_running(struct io_worker *worker)
 		io_wqe_wake_worker(wqe, acct);
 }
 
-static void io_worker_start(struct io_worker *worker)
-{
-	current->flags |= PF_NOFREEZE;
-	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
-	io_wqe_inc_running(worker);
-	complete(&worker->started);
-}
-
 /*
  * Worker will start processing some work. Move it to the busy list, if
  * it's currently on the freelist
@@ -490,8 +480,6 @@ static int io_wqe_worker(void *data)
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
 
-	io_worker_start(worker);
-
 	while (!test_bit(IO_WQ_BIT_EXIT, &wq->state)) {
 		set_current_state(TASK_INTERRUPTIBLE);
 loop:
@@ -576,12 +564,6 @@ static int task_thread(void *data, int index)
 	sprintf(buf, "iou-wrk-%d", wq->task_pid);
 	set_task_comm(current, buf);
 
-	current->pf_io_worker = worker;
-	worker->task = current;
-
-	set_cpus_allowed_ptr(current, cpumask_of_node(wqe->node));
-	current->flags |= PF_NO_SETAFFINITY;
-
 	raw_spin_lock_irq(&wqe->lock);
 	hlist_nulls_add_head_rcu(&worker->nulls_node, &wqe->free_list);
 	list_add_tail_rcu(&worker->all_list, &wqe->all_list);
@@ -607,25 +589,10 @@ static int task_thread_unbound(void *data)
 	return task_thread(data, IO_WQ_ACCT_UNBOUND);
 }
 
-pid_t io_wq_fork_thread(int (*fn)(void *), void *arg)
-{
-	unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
-				CLONE_IO|SIGCHLD;
-	struct kernel_clone_args args = {
-		.flags		= ((lower_32_bits(flags) | CLONE_VM |
-				    CLONE_UNTRACED) & ~CSIGNAL),
-		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
-		.stack		= (unsigned long)fn,
-		.stack_size	= (unsigned long)arg,
-	};
-
-	return kernel_clone(&args);
-}
-
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 {
 	struct io_worker *worker;
-	pid_t pid;
+	struct task_struct *tsk;
 
 	__set_current_state(TASK_RUNNING);
 
@@ -638,21 +605,26 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	worker->wqe = wqe;
 	spin_lock_init(&worker->lock);
 	init_completion(&worker->ref_done);
-	init_completion(&worker->started);
 
 	atomic_inc(&wq->worker_refs);
 
 	if (index == IO_WQ_ACCT_BOUND)
-		pid = io_wq_fork_thread(task_thread_bound, worker);
+		tsk = create_io_thread(task_thread_bound, worker, wqe->node);
 	else
-		pid = io_wq_fork_thread(task_thread_unbound, worker);
-	if (pid < 0) {
+		tsk = create_io_thread(task_thread_unbound, worker, wqe->node);
+	if (IS_ERR(tsk)) {
 		if (atomic_dec_and_test(&wq->worker_refs))
 			complete(&wq->worker_done);
 		kfree(worker);
 		return false;
 	}
-	wait_for_completion(&worker->started);
+	worker->flags |= (IO_WORKER_F_UP | IO_WORKER_F_RUNNING);
+	io_wqe_inc_running(worker);
+	tsk->pf_io_worker = worker;
+	worker->task = tsk;
+	set_cpus_allowed_ptr(tsk, cpumask_of_node(wqe->node));
+	tsk->flags |= PF_NOFREEZE | PF_NO_SETAFFINITY;
+	wake_up_new_task(tsk);
 	return true;
 }
 
@@ -696,6 +668,7 @@ static bool io_wq_for_each_worker(struct io_wqe *wqe,
 
 static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 {
+	set_notify_signal(worker->task);
 	wake_up_process(worker->task);
 	return false;
 }
@@ -752,10 +725,6 @@ static int io_wq_manager(void *data)
 
 	sprintf(buf, "iou-mgr-%d", wq->task_pid);
 	set_task_comm(current, buf);
-	current->flags |= PF_IO_WORKER;
-	wq->manager = get_task_struct(current);
-
-	complete(&wq->started);
 
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -815,21 +784,20 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 
 static int io_wq_fork_manager(struct io_wq *wq)
 {
-	int ret;
+	struct task_struct *tsk;
 
 	if (wq->manager)
 		return 0;
 
 	reinit_completion(&wq->worker_done);
-	current->flags |= PF_IO_WORKER;
-	ret = io_wq_fork_thread(io_wq_manager, wq);
-	current->flags &= ~PF_IO_WORKER;
-	if (ret >= 0) {
-		wait_for_completion(&wq->started);
+	tsk = create_io_thread(io_wq_manager, wq, NUMA_NO_NODE);
+	if (!IS_ERR(tsk)) {
+		wq->manager = get_task_struct(tsk);
+		wake_up_new_task(tsk);
 		return 0;
 	}
 
-	return ret;
+	return PTR_ERR(tsk);
 }
 
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
@@ -1062,7 +1030,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	}
 
 	wq->task_pid = current->pid;
-	init_completion(&wq->started);
 	init_completion(&wq->exited);
 	refcount_set(&wq->refs, 1);
 
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 42f0be64a84d..5fbf7997149e 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -119,8 +119,6 @@ void io_wq_put_and_exit(struct io_wq *wq);
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_hash_work(struct io_wq_work *work, void *val);
 
-pid_t io_wq_fork_thread(int (*fn)(void *), void *arg);
-
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
 	return work->flags & IO_WQ_WORK_HASHED;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index e55369555e5c..d885fbd53bbc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6668,7 +6668,6 @@ static int io_sq_thread(void *data)
 
 	sprintf(buf, "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
-	sqd->thread = current;
 	current->pf_io_worker = NULL;
 
 	if (sqd->sq_cpu != -1)
@@ -6677,8 +6676,6 @@ static int io_sq_thread(void *data)
 		set_cpus_allowed_ptr(current, cpu_online_mask);
 	current->flags |= PF_NO_SETAFFINITY;
 
-	complete(&sqd->completion);
-
 	wait_for_completion(&sqd->startup);
 
 	while (!io_sq_thread_should_stop(sqd)) {
@@ -7818,21 +7815,22 @@ void __io_uring_free(struct task_struct *tsk)
 
 static int io_sq_thread_fork(struct io_sq_data *sqd, struct io_ring_ctx *ctx)
 {
+	struct task_struct *tsk;
 	int ret;
 
 	clear_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 	reinit_completion(&sqd->completion);
 	ctx->sqo_exec = 0;
 	sqd->task_pid = current->pid;
-	current->flags |= PF_IO_WORKER;
-	ret = io_wq_fork_thread(io_sq_thread, sqd);
-	current->flags &= ~PF_IO_WORKER;
-	if (ret < 0) {
-		sqd->thread = NULL;
+	tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
+	if (IS_ERR(tsk))
 		return ret;
-	}
-	wait_for_completion(&sqd->completion);
-	return io_uring_alloc_task_context(sqd->thread, ctx);
+	ret = io_uring_alloc_task_context(tsk, ctx);
+	if (ret)
+		set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+	sqd->thread = tsk;
+	wake_up_new_task(tsk);
+	return ret;
 }
 
 static int io_sq_offload_create(struct io_ring_ctx *ctx,
@@ -7855,6 +7853,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		fdput(f);
 	}
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		struct task_struct *tsk;
 		struct io_sq_data *sqd;
 
 		ret = -EPERM;
@@ -7896,15 +7895,14 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		}
 
 		sqd->task_pid = current->pid;
-		current->flags |= PF_IO_WORKER;
-		ret = io_wq_fork_thread(io_sq_thread, sqd);
-		current->flags &= ~PF_IO_WORKER;
-		if (ret < 0) {
-			sqd->thread = NULL;
+		tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
+		if (IS_ERR(tsk))
 			goto err;
-		}
-		wait_for_completion(&sqd->completion);
-		ret = io_uring_alloc_task_context(sqd->thread, ctx);
+		ret = io_uring_alloc_task_context(tsk, ctx);
+		if (ret)
+			set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+		sqd->thread = tsk;
+		wake_up_new_task(tsk);
 		if (ret)
 			goto err;
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
-- 
2.30.1


--------------08BD5CF4CE25B7C4BC17324E--
