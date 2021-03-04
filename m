Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5422E32DAA5
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 20:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhCDTzb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 14:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234788AbhCDTzX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 14:55:23 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15324C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 11:54:43 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id n14so31111841iog.3
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 11:54:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=leXQz8BWjFk/wNPjwySuMFvvGjb7i4nehGHUhP7YVoU=;
        b=dGSe/F7J+za4EXjCHW6mKcoHs3U2Cr7py8mkH6Jc2KMIfQ3Car6hV3TdHF1MtTnQu2
         CcNkkhdAaLtvxg14npuR9NJNENWBeiXBr709g3BBttCrsHKLly83ZK0xkrjKvocVJM9e
         alN+N9Et5hLVNXi42oibyVfuCFTU0u42Jplrnq5azAyuxIpgmm5vaaKUAGjvMUmdTXoI
         hUPPZvJHi4WNUB7WHCSihaSPaVCNOd3PsTbdmwCD9iJCwx9BaN7GukUPLhcbaegDyY5Z
         XoQWpFYTg/ngOZWebIFBT94KnrvrMXf31c1zSLWUwhsqb5hQELHAmh2NNqxnu5HjZgQY
         4WTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language;
        bh=leXQz8BWjFk/wNPjwySuMFvvGjb7i4nehGHUhP7YVoU=;
        b=PAMCMVAcE8mjvRvjRQElbWQ6UvbVBiUSkcEy0P6T7qCSAyb0xskwYKomP7FEJJ1hft
         Nc4ehI/MeXRopXMUT1pAtdqJ3F6sPyYQ7Ppgq5fhoRq+fFTet2g1ZKvMJA2d+xUqpZcf
         ZZh625iaDC6WHqMQ/Fb6zTR6l+SHlh9jScPTtq+fmshd/JypbuF14CIaxdlJI4J5B6vz
         XG5MhcOaxxHSYsBGv5bn98ICq6n0u7daRA5Sks/H83GNjpfwV3oKciDvPGAAod7NUoX4
         iuCgexeDQ1cd9lhdHBUCMXgFIHQy7+QJi0EXIt54iWaziofP/VkYU12MH1UTDiYUtKn3
         G1AA==
X-Gm-Message-State: AOAM5331HauKMvHq2T/eW3eiyQiZzU4LUjz5hk8wBzpu/p7R/4H5mXhy
        ps2mmE82kuAYKqgvbYzWsHenYw==
X-Google-Smtp-Source: ABdhPJy1luWaJPeUSdHS15R79vCkgbzZ3o5TTEv7i8G23P9Ob2FqmoAJYNPDtsbGADaXWTMGvM9l2w==
X-Received: by 2002:a5e:c911:: with SMTP id z17mr5047005iol.153.1614887682381;
        Thu, 04 Mar 2021 11:54:42 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id 128sm160782iov.1.2021.03.04.11.54.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 11:54:41 -0800 (PST)
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
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
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <bcab873a-eced-b906-217f-c52a113a95a9@kernel.dk>
Date:   Thu, 4 Mar 2021 12:54:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wj8BnbsSKWx=kUFPqpoohDdPchsW00c4L-x6ES8bOWLSg@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------A9189EEB89DDD271B52B6A3F"
Content-Language: en-US
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------A9189EEB89DDD271B52B6A3F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

On 3/4/21 12:46 PM, Linus Torvalds wrote:
> On Thu, Mar 4, 2021 at 11:19 AM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> Took a quick look at this, and I agree that's _much_ better. In fact, it
>> boils down to just calling copy_process() and then having the caller do
>> wake_up_new_task(). So not sure if it's worth adding an
>> create_io_thread() helper, or just make copy_process() available
>> instead. This is ignoring the trace point for now...
> 
> I really don't want to expose copy_process() outside of kernel/fork.c.
> 
> The whole three-phase "copy - setup - activate" model is a really
> really good thing, and it's how we've done things internally almost
> forever, but I really don't want to expose those middle stages to any
> outsiders.
> 
> So I'd really prefer a simple new "create_io_worker()", even if it's
> literally just some four-line function that does
> 
>    p = copy_process(..);
>    if (!IS_ERR(p)) {
>       block all signals in p
>       set PF_IO_WORKER flag
>       wake_up_new_task(p);
>    }
>    return p;
> 
> I very much want that to be inside kernel/fork.c and have all these
> rules about creating new threads localized there.

I agree, here are the two current patches. Just need to add the signal
blocking, which I'd love to do in create_io_thread(), but seems to
require either an allocation or provide a helper to do it in the thread
itself (with an on-stack mask).

Removes code, even with comment added.

 fs/io-wq.c                 | 68 ++++++++++++++++---------------------------------------------
 fs/io-wq.h                 |  2 --
 fs/io_uring.c              | 29 ++++++++++++++------------
 include/linux/sched/task.h |  2 ++
 kernel/fork.c              | 24 ++++++++++++++++++++++
 5 files changed, 59 insertions(+), 66 deletions(-)


-- 
Jens Axboe


--------------A9189EEB89DDD271B52B6A3F
Content-Type: text/x-patch; charset=UTF-8;
 name="0001-kernel-provide-create_io_thread-helper.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0001-kernel-provide-create_io_thread-helper.patch"

From 396142d9878cc1a02149616c7032b3e647205341 Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 4 Mar 2021 12:21:05 -0700
Subject: [PATCH 1/2] kernel: provide create_io_thread() helper

Provide a generic helper for setting up an io_uring worker. Returns a
task_struct so that the caller can do whatever setup is needed, then call
wake_up_new_task() to kick it into gear.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/sched/task.h |  2 ++
 kernel/fork.c              | 24 ++++++++++++++++++++++++
 2 files changed, 26 insertions(+)

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
index d66cd1014211..549acc6324f0 100644
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
@@ -2410,6 +2412,28 @@ struct mm_struct *copy_init_mm(void)
 	return dup_mm(NULL, &init_mm);
 }
 
+/*
+ * This is like kernel_clone(), but shaved down and tailored to just
+ * creating io_uring workers. It returns a created task, or an error pointer.
+ * The returned task is inactive, and the caller must fire it up through
+ * wake_up_new_task(p).
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
+
+	return copy_process(NULL, 0, node, &args);
+}
+
 /*
  *  Ok, this is the main fork-routine.
  *
-- 
2.30.1


--------------A9189EEB89DDD271B52B6A3F
Content-Type: text/x-patch; charset=UTF-8;
 name="0002-io_uring-move-to-using-create_io_thread.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0002-io_uring-move-to-using-create_io_thread.patch"

From 9dee8128025806e74c7fd3915294649dc0b11f5f Mon Sep 17 00:00:00 2001
From: Jens Axboe <axboe@kernel.dk>
Date: Thu, 4 Mar 2021 12:39:36 -0700
Subject: [PATCH 2/2] io_uring: move to using create_io_thread()

This allows us to do task creation and setup without needing to use
completions to try and synchronize with the starting thread.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c    | 68 +++++++++++++--------------------------------------
 fs/io-wq.h    |  2 --
 fs/io_uring.c | 29 ++++++++++++----------
 3 files changed, 33 insertions(+), 66 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 19f18389ead2..693239ed4de5 100644
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
 
@@ -752,10 +724,6 @@ static int io_wq_manager(void *data)
 
 	sprintf(buf, "iou-mgr-%d", wq->task_pid);
 	set_task_comm(current, buf);
-	current->flags |= PF_IO_WORKER;
-	wq->manager = get_task_struct(current);
-
-	complete(&wq->started);
 
 	do {
 		set_current_state(TASK_INTERRUPTIBLE);
@@ -815,21 +783,20 @@ static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *work)
 
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
@@ -1062,7 +1029,6 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
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
index e55369555e5c..04f04ac3c4cf 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6677,8 +6677,6 @@ static int io_sq_thread(void *data)
 		set_cpus_allowed_ptr(current, cpu_online_mask);
 	current->flags |= PF_NO_SETAFFINITY;
 
-	complete(&sqd->completion);
-
 	wait_for_completion(&sqd->startup);
 
 	while (!io_sq_thread_should_stop(sqd)) {
@@ -7818,21 +7816,24 @@ void __io_uring_free(struct task_struct *tsk)
 
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
+	tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
+	if (IS_ERR(tsk)) {
 		sqd->thread = NULL;
 		return ret;
 	}
-	wait_for_completion(&sqd->completion);
-	return io_uring_alloc_task_context(sqd->thread, ctx);
+	sqd->thread = tsk;
+	ret = io_uring_alloc_task_context(tsk, ctx);
+	if (ret)
+		set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+	wake_up_new_task(tsk);
+	return ret;
 }
 
 static int io_sq_offload_create(struct io_ring_ctx *ctx,
@@ -7855,6 +7856,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		fdput(f);
 	}
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
+		struct task_struct *tsk;
 		struct io_sq_data *sqd;
 
 		ret = -EPERM;
@@ -7896,15 +7898,16 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		}
 
 		sqd->task_pid = current->pid;
-		current->flags |= PF_IO_WORKER;
-		ret = io_wq_fork_thread(io_sq_thread, sqd);
-		current->flags &= ~PF_IO_WORKER;
-		if (ret < 0) {
+		tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
+		if (IS_ERR(tsk)) {
 			sqd->thread = NULL;
 			goto err;
 		}
-		wait_for_completion(&sqd->completion);
 		ret = io_uring_alloc_task_context(sqd->thread, ctx);
+		if (ret)
+			set_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
+		sqd->thread = tsk;
+		wake_up_new_task(tsk);
 		if (ret)
 			goto err;
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
-- 
2.30.1


--------------A9189EEB89DDD271B52B6A3F--
