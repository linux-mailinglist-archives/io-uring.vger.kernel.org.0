Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A6332D959
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 19:21:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233950AbhCDSU2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 13:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbhCDSUA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 13:20:00 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63B89C061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 10:19:20 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id o9so15871694iow.6
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 10:19:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Us1yHYLfdwMg2//E/PxpgkyGr78zkgqbCefDPctUvtk=;
        b=ADROreY2WW02apsGata9LrOXzIHXZSaL41cQPdz+gt1ncbjofBWM8Qobuy/XRTtXmQ
         oPSI5ZD4MwLOIzeD3M2gdmgY6qGXEk3EmD/XgvsINRyEg2p3WsdcPEVCEvuDOlz5buI5
         /a9zPnrVHRMe4fPCmXIFKpjUw8Jb02GhPClbsAs4NuZT83x277wb1vVKeaNdJozCIiRN
         fzQK6wP1aOd8ux2u+yi1FYh+uHZiE5/D8uZypj4QDGGm4vhObxz0mhkUlm2p5zx3V+8A
         9zoMJW+04b/fZFeYlewACrKUWvsUItfd/gdx4Q+aFzJn4Z3aLq/NxjmyMCqy54nnCnpl
         ixew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Us1yHYLfdwMg2//E/PxpgkyGr78zkgqbCefDPctUvtk=;
        b=I3Js88kMwlDu7ApAB9sDgPSBPLhaszscpF0fvwmFqw6PQ/SJtrN5JAJIDvZ6hUGt0q
         y1cHuX8l/vVC+lA4ccRNiVKTMj+Ajx+9U2pt8+nA0jDRP6JmpjuC8/tar0DtNwiFBEi6
         53zHtlcm0ujADlzaUPkgcYxVRn1/AL0wokHoIF0hwKiRGSmt9Sg/wQrMZvHB1TR0mdgJ
         9lsWZo7JjpI4wmaejhqV595XWtCqmDMt1cACbdv1VaCS0XKRD5c2ZcEW++Nz1aOSoJFM
         +O6+GUH+PR66ZEbIaP9nTGWRRd9FcoSuOB6+Cem0jq9Df0Lm+E3kO0R5k0VqczxXDHcy
         M5zA==
X-Gm-Message-State: AOAM530YcOO8a40GvLfTRqQhFBd1SWXYHokmiELy19aI0asjmz3mxCXF
        VGq+h+BCAvDzy6cY7+HCTjlZjA==
X-Google-Smtp-Source: ABdhPJxfsFO6QgDto82AT6g72vsXWVEmtYI8SQwmv+OQPyxQ8dto6zToWax04A1+NatwHcr/AQlp6w==
X-Received: by 2002:a6b:c40b:: with SMTP id y11mr4483525ioa.205.1614881959544;
        Thu, 04 Mar 2021 10:19:19 -0800 (PST)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w1sm110339ilv.52.2021.03.04.10.19.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Mar 2021 10:19:19 -0800 (PST)
Subject: Re: [PATCH 09/18] io-wq: fork worker threads from original task
From:   Jens Axboe <axboe@kernel.dk>
To:     Stefan Metzmacher <metze@samba.org>, io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org
References: <20210219171010.281878-1-axboe@kernel.dk>
 <20210219171010.281878-10-axboe@kernel.dk>
 <85bc236d-94af-6878-928b-c69dbdcd46f9@samba.org>
 <d9704b9e-ae5e-0795-ba2e-029293f89616@kernel.dk>
 <a9f58269-b260-6281-4e83-43cb5e881d25@samba.org>
 <d3dfc422-8762-0078-bc80-989f1d71f006@samba.org>
 <32f1218b-49c3-eeb6-5866-3ec45acbc1c5@kernel.dk>
 <34857989-ff46-b2a7-9730-476636848acc@samba.org>
 <47c76a83-a449-3a65-5850-1d3dff4f3249@kernel.dk>
Message-ID: <09579257-8d8e-8f25-6ceb-eea4f5596eb3@kernel.dk>
Date:   Thu, 4 Mar 2021 11:19:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <47c76a83-a449-3a65-5850-1d3dff4f3249@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/4/21 10:32 AM, Jens Axboe wrote:
> On 3/4/21 10:09 AM, Stefan Metzmacher wrote:
>>
>> Am 04.03.21 um 17:42 schrieb Jens Axboe:
>>> On 3/4/21 9:13 AM, Stefan Metzmacher wrote:
>>>>
>>>> Am 04.03.21 um 14:19 schrieb Stefan Metzmacher:
>>>>> Hi Jens,
>>>>>
>>>>>>> Can you please explain why CLONE_SIGHAND is used here?
>>>>>>
>>>>>> We can't have CLONE_THREAD without CLONE_SIGHAND... The io-wq workers
>>>>>> don't really care about signals, we don't use them internally.
>>>>>
>>>>> I'm 100% sure, but I heard rumors that in some situations signals get
>>>>> randomly delivered to any thread of a userspace process.
>>>>
>>>> Ok, from task_struct:
>>>>
>>>>         /* Signal handlers: */
>>>>         struct signal_struct            *signal;
>>>>         struct sighand_struct __rcu             *sighand;
>>>>         sigset_t                        blocked;
>>>>         sigset_t                        real_blocked;
>>>>         /* Restored if set_restore_sigmask() was used: */
>>>>         sigset_t                        saved_sigmask;
>>>>         struct sigpending               pending;
>>>>
>>>> The signal handlers are shared, but 'blocked' is per thread/task.
>>>>
>>>>> My fear was that the related logic may select a kernel thread if they
>>>>> share the same signal handlers.
>>>>
>>>> I found the related logic in the interaction between
>>>> complete_signal() and wants_signal().
>>>>
>>>> static inline bool wants_signal(int sig, struct task_struct *p)
>>>> {
>>>>         if (sigismember(&p->blocked, sig))
>>>>                 return false;
>>>>
>>>> ...
>>>>
>>>> Would it make sense to set up task->blocked to block all signals?
>>>>
>>>> Something like this:
>>>>
>>>> --- a/fs/io-wq.c
>>>> +++ b/fs/io-wq.c
>>>> @@ -611,15 +611,15 @@ pid_t io_wq_fork_thread(int (*fn)(void *), void *arg)
>>>>  {
>>>>         unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
>>>>                                 CLONE_IO|SIGCHLD;
>>>> -       struct kernel_clone_args args = {
>>>> -               .flags          = ((lower_32_bits(flags) | CLONE_VM |
>>>> -                                   CLONE_UNTRACED) & ~CSIGNAL),
>>>> -               .exit_signal    = (lower_32_bits(flags) & CSIGNAL),
>>>> -               .stack          = (unsigned long)fn,
>>>> -               .stack_size     = (unsigned long)arg,
>>>> -       };
>>>> +       sigset_t mask, oldmask;
>>>> +       pid_t pid;
>>>>
>>>> -       return kernel_clone(&args);
>>>> +       sigfillset(&mask);
>>>> +       sigprocmask(SIG_BLOCK, &mask, &oldmask);
>>>> +       pid = kernel_thread(fn, arg, flags);
>>>> +       sigprocmask(SIG_SETMASK, &oldmask, NULL);
>>>> +
>>>> +       return ret;
>>>>  }
>>>>
>>>> I think using kernel_thread() would be a good simplification anyway.
>>>
>>> I like this approach, we're really not interested in signals for those
>>> threads, and this makes it explicit. Ditto on just using the kernel_thread()
>>> helper, looks fine too. I'll run this through the testing. Do you want to
>>> send this as a "real" patch, or should I just attribute you in the commit
>>> message?
>>
>> You can do the patch, it was mostly an example.
>> I'm not sure if sigprocmask() is the correct function here.
>>
>> Or if we better use something like this:
>>
>>         set_restore_sigmask();
>>         current->saved_sigmask = current->blocked;
>>         set_current_blocked(&kmask);
>>         pid = kernel_thread(fn, arg, flags);
>>         restore_saved_sigmask();
> 
> Might be cleaner, and allows fatal signals.

How about this - it moves the signal fiddling into the task
itself, and leaves the parent alone. Also allows future cleanups
of how we wait for thread creation. And moves the PF_IO_WORKER
into a contained spot, instead of having it throughout where we
call the worker fork.

Later cleanups can focus on having copy_process() do the right
thing and we can kill this PF_IO_WORKER dance completely


commit eeb485abb7a189058858f941fb3432bee945a861
Author: Jens Axboe <axboe@kernel.dk>
Date:   Thu Mar 4 09:46:37 2021 -0700

    io-wq: block signals by default for any io-wq worker
    
    We're not interested in signals, so let's make it explicit and block
    it for any worker. Wrap the thread creation in our own handler, so we
    can set blocked signals and serialize creation of them. A future cleanup
    can now simplify the waiting on thread creation from the other paths,
    just pushing the 'startup' completion further down.
    
    Move the PF_IO_WORKER flag dance in there as well. This will go away in
    the future when we teach copy_process() how to deal with this
    automatically.
    
    Reported-by: Stefan Metzmacher <metze@samba.org>
    Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 19f18389ead2..bf5df1a31a0e 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -607,19 +607,54 @@ static int task_thread_unbound(void *data)
 	return task_thread(data, IO_WQ_ACCT_UNBOUND);
 }
 
+struct thread_start_data {
+	struct completion startup;
+	int (*fn)(void *);
+	void *arg;
+};
+
+static int thread_start(void *data)
+{
+	struct thread_start_data *d = data;
+	int (*fn)(void *) = d->fn;
+	void *arg = d->arg;
+	sigset_t mask;
+	int ret;
+
+	sigfillset(&mask);
+	set_restore_sigmask();
+	current->saved_sigmask = current->blocked;
+	set_current_blocked(&mask);
+	current->flags |= PF_IO_WORKER;
+	complete(&d->startup);
+	ret = fn(arg);
+	restore_saved_sigmask();
+	return ret;
+}
+
 pid_t io_wq_fork_thread(int (*fn)(void *), void *arg)
 {
 	unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
 				CLONE_IO|SIGCHLD;
-	struct kernel_clone_args args = {
-		.flags		= ((lower_32_bits(flags) | CLONE_VM |
-				    CLONE_UNTRACED) & ~CSIGNAL),
-		.exit_signal	= (lower_32_bits(flags) & CSIGNAL),
-		.stack		= (unsigned long)fn,
-		.stack_size	= (unsigned long)arg,
+	struct thread_start_data data = {
+		.startup	= COMPLETION_INITIALIZER_ONSTACK(data.startup),
+		.fn		= fn,
+		.arg		= arg
 	};
+	bool clear = false;
+	pid_t pid;
 
-	return kernel_clone(&args);
+	/* task path doesn't have it, manager path does */
+	if (!(current->flags & PF_IO_WORKER)) {
+		current->flags |= PF_IO_WORKER;
+		clear = true;
+	}
+	pid = kernel_thread(thread_start, &data, flags);
+	if (clear)
+		current->flags &= ~PF_IO_WORKER;
+	if (pid >= 0)
+		wait_for_completion(&data.startup);
+	return pid;
 }
 
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
@@ -752,7 +787,6 @@ static int io_wq_manager(void *data)
 
 	sprintf(buf, "iou-mgr-%d", wq->task_pid);
 	set_task_comm(current, buf);
-	current->flags |= PF_IO_WORKER;
 	wq->manager = get_task_struct(current);
 
 	complete(&wq->started);
@@ -821,9 +855,7 @@ static int io_wq_fork_manager(struct io_wq *wq)
 		return 0;
 
 	reinit_completion(&wq->worker_done);
-	current->flags |= PF_IO_WORKER;
 	ret = io_wq_fork_thread(io_wq_manager, wq);
-	current->flags &= ~PF_IO_WORKER;
 	if (ret >= 0) {
 		wait_for_completion(&wq->started);
 		return 0;
diff --git a/fs/io_uring.c b/fs/io_uring.c
index e55369555e5c..995f506e3a60 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7824,9 +7824,7 @@ static int io_sq_thread_fork(struct io_sq_data *sqd, struct io_ring_ctx *ctx)
 	reinit_completion(&sqd->completion);
 	ctx->sqo_exec = 0;
 	sqd->task_pid = current->pid;
-	current->flags |= PF_IO_WORKER;
 	ret = io_wq_fork_thread(io_sq_thread, sqd);
-	current->flags &= ~PF_IO_WORKER;
 	if (ret < 0) {
 		sqd->thread = NULL;
 		return ret;
@@ -7896,9 +7894,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		}
 
 		sqd->task_pid = current->pid;
-		current->flags |= PF_IO_WORKER;
 		ret = io_wq_fork_thread(io_sq_thread, sqd);
-		current->flags &= ~PF_IO_WORKER;
 		if (ret < 0) {
 			sqd->thread = NULL;
 			goto err;

-- 
Jens Axboe

