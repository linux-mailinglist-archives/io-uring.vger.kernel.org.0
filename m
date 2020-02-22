Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A80A5168FB1
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2020 16:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgBVPJf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Feb 2020 10:09:35 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:34033 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727820AbgBVPJf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Feb 2020 10:09:35 -0500
Received: by mail-pg1-f194.google.com with SMTP id j4so2588265pgi.1
        for <io-uring@vger.kernel.org>; Sat, 22 Feb 2020 07:09:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b/Lns+ckWSVxgtfGhRN9DJkI3yIPMrRul35WzQCDEhc=;
        b=IWsFbacIsMxdPrYJLJtRe43JQy+c64LkS5kIma9HwFgMDOMN2qGuLpPAk+UxCCScP6
         l1O9aJtXqybeSqvFtsMj5zqxvvdUu9soQ45TevIc5awAKzo7hitd59TLWbRPnZo3xJuf
         j1JyeSxQ7RDSkUzoVniQaH1POmO1xRo8WAf24j1niDkkM8d6X20BiTwMF+bXYqsA33th
         3cx//Eb9K94xRRixUbjuRnltwHLWp9n16NX9paxlnheIW2RLJHh6OTkUjSPeZDFJPv/T
         XIAw9orjSd7aPSWM41abkEkXgbjcKrZ6bGK06CYA/wk52YTzUi+aycSvf80taTOF34G+
         lkGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b/Lns+ckWSVxgtfGhRN9DJkI3yIPMrRul35WzQCDEhc=;
        b=G9TqptQxOmbaPQ0QdKt2M/fUVlu6RTn3aZfBKYut1v8tADUIw6f3CZf8G2aanyBmgf
         avqemlYXUpdowCwVm1kXRzxAZnSrE/ggOQ3AmJoZ+hb0A7Og9bZ3xuFmvj24BlPIL7bQ
         rCQTDZDOSJiB8YL/rYKmW3v0IxSGG0DkwnXSnQWhKr2Q2z3dUqNzX8iJtBDuZ8Q7HqBc
         HCAxdU3RfalG9h2Hjs3rZPmzIO1LA+SzNZgDKt1dg++TkXlAimTYa0wgdRWKWsAbHCTc
         h12jpBb4MW3HCGepRVpFBnBmmxJX/MaISGg23G1ZV2PbE+AWfOogjMsPtOkUN9HZxnqJ
         632A==
X-Gm-Message-State: APjAAAViDYPNUNlWjTRPjfelqHlyDJXaWlQlMg0KByheB1l1oZU2w0He
        5wmbIueVJ4NwT+Y+kDdm3BDJAg==
X-Google-Smtp-Source: APXvYqxjBYjEUrrAjUqwJ6KATgbr3iyMFwAIxFii/H3WxRz8TMdzil6r8c+PsUdYy4Lo+ox3H4JdsA==
X-Received: by 2002:a63:1d09:: with SMTP id d9mr24724734pgd.117.1582384174700;
        Sat, 22 Feb 2020 07:09:34 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:d487:5bdf:4186:2ae1? ([2605:e000:100e:8c61:d487:5bdf:4186:2ae1])
        by smtp.gmail.com with ESMTPSA id x6sm6544454pfi.83.2020.02.22.07.09.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2020 07:09:33 -0800 (PST)
Subject: Re: [PATCH 5/7] io_uring: add per-task callback handler
From:   Jens Axboe <axboe@kernel.dk>
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20200221214606.12533-1-axboe@kernel.dk>
 <20200221214606.12533-6-axboe@kernel.dk>
 <CAG48ez2ErAJgEiPdkK+PeNBoHchVEkkw5674Wt2eSaNjqyZ98g@mail.gmail.com>
 <CAG48ez3rsk6TzF82Q0PvDDCRp6wfWWUn8bsSZ2+OB9FgSOGgsw@mail.gmail.com>
 <f9fe1046-543a-1541-ad87-2a70da906ac5@kernel.dk>
Message-ID: <5799c0a1-8b65-cc68-7f95-789d90b01ab7@kernel.dk>
Date:   Sat, 22 Feb 2020 07:09:31 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <f9fe1046-543a-1541-ad87-2a70da906ac5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/22/20 7:41 AM, Jens Axboe wrote:
> On 2/21/20 4:00 PM, Jann Horn wrote:
>> On Fri, Feb 21, 2020 at 11:56 PM Jann Horn <jannh@google.com> wrote:
>>> On Fri, Feb 21, 2020 at 10:46 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>> For poll requests, it's not uncommon to link a read (or write) after
>>>> the poll to execute immediately after the file is marked as ready.
>>>> Since the poll completion is called inside the waitqueue wake up handler,
>>>> we have to punt that linked request to async context. This slows down
>>>> the processing, and actually means it's faster to not use a link for this
>>>> use case.
>>>>
>>>> We also run into problems if the completion_lock is contended, as we're
>>>> doing a different lock ordering than the issue side is. Hence we have
>>>> to do trylock for completion, and if that fails, go async. Poll removal
>>>> needs to go async as well, for the same reason.
>>>>
>>>> eventfd notification needs special case as well, to avoid stack blowing
>>>> recursion or deadlocks.
>>>>
>>>> These are all deficiencies that were inherited from the aio poll
>>>> implementation, but I think we can do better. When a poll completes,
>>>> simply queue it up in the task poll list. When the task completes the
>>>> list, we can run dependent links inline as well. This means we never
>>>> have to go async, and we can remove a bunch of code associated with
>>>> that, and optimizations to try and make that run faster. The diffstat
>>>> speaks for itself.
>>> [...]
>>>> @@ -3637,8 +3587,8 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>>>  {
>>>>         struct io_kiocb *req = wait->private;
>>>>         struct io_poll_iocb *poll = &req->poll;
>>>> -       struct io_ring_ctx *ctx = req->ctx;
>>>>         __poll_t mask = key_to_poll(key);
>>>> +       struct task_struct *tsk;
>>>>
>>>>         /* for instances that support it check for an event match first: */
>>>>         if (mask && !(mask & poll->events))
>>>> @@ -3646,46 +3596,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>>>
>>>>         list_del_init(&poll->wait.entry);
>>>>
>>> [...]
>>>> +       tsk = req->task;
>>>> +       req->result = mask;
>>>> +       init_task_work(&req->task_work, io_poll_task_func);
>>>> +       task_work_add(tsk, &req->task_work, true);
>>>> +       wake_up_process(tsk);
>>>>         return 1;
>>>>  }
>>>
>>> Let's say userspace has some code like this:
>>>
>>> [prepare two uring requests: one POLL and a RECVMSG linked behind it]
>>> // submit requests
>>> io_uring_enter(uring_fd, 2, 0, 0, NULL, 0);
>>> // wait for something to happen, either a completion event from uring
>>> or input from stdin
>>> struct pollfd fds[] = {
>>>   { .fd = 0, .events = POLLIN },
>>>   { .fd = uring_fd, .events = POLLIN }
>>> };
>>> while (1) {
>>>   poll(fds, 2, -1);
>>>   if (fds[0].revents) {
>>>     [read stuff from stdin]
>>>   }
>>>   if (fds[1].revents) {
>>>     [fetch completions from shared memory]
>>>   }
>>> }
>>>
>>> If userspace has reached the poll() by the time the uring POLL op
>>> completes, I think you'll wake up the do_poll() loop while it is in
>>> poll_schedule_timeout(); then it will do another iteration, see that
>>> no signals are pending and none of the polled files have become ready,
>>> and go to sleep again. So things are stuck until the io_uring fd
>>> signals that it is ready.
>>>
>>> The options I see are:
>>>
>>>  - Tell the kernel to go through signal delivery code, which I think
>>> will cause the pending syscall to actually abort and return to
>>> userspace (which I think is kinda gross). You could maybe add a
>>> special case where that doesn't happen if the task is already in
>>> io_uring_enter() and waiting for CQ events.
>>>  - Forbid eventfd notifications, ensure that the ring's ->poll handler
>>> reports POLLIN when work items are pending for userspace, and then
>>> rely on the fact that those work items will be picked up when
>>> returning from the poll syscall. Unfortunately, this gets a bit messy
>>> when you're dealing with multiple threads that access the same ring,
>>> since then you'd have to ensure that *any* thread can pick up this
>>> work, and that that doesn't mismatch how the uring instance is shared
>>> between threads; but you could probably engineer your way around this.
>>> For userspace, this whole thing just means "POLLIN may be spurious".
>>>  - Like the previous item, except you tell userspace that if it gets
>>> POLLIN (or some special poll status like POLLRDBAND) and sees nothing
>>> in the completion queue, it should call io_uring_enter() to process
>>> the work. This addresses the submitter-is-not-completion-reaper
>>> scenario without having to add some weird version of task_work that
>>> will be processed by the first thread, but you'd get some extra
>>> syscalls.
>>
>> ... or I suppose you could punt to worker context if anyone uses the
>> ring's ->poll handler or has an eventfd registered, if you don't
>> expect high-performance users to do those things.
> 
> Good points, thanks Jann. We have some precedence in the area of
> requiring the application to enter the kernel, that's how the CQ ring
> overflow is handled as well. For liburing users, that'd be trivial to
> hide, for the raw interface that's not necessarily the case. I'd hate to
> make the feature opt-in rather than just generally available.
> 
> I'll try and play with some ideas in this area and see how it falls out.

I wonder if the below is enough - it'll trigger a poll and eventfd
wakeup, if we add work. If current->task_works != NULL, we could also
set POLLPRI to make it explicit why this happened, that seems like a
better fit than POLLRDBAND.


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6f7ae3eab21f..dba2f0e1ae6a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3501,6 +3501,18 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 	__io_queue_proc(&pt->req->apoll->poll, pt, head);
 }
 
+static void io_task_work_notify(struct io_ring_ctx *ctx,
+				struct task_struct *tsk)
+{
+	if (wq_has_sleeper(&ctx->cq_wait)) {
+		wake_up_interruptible(&ctx->cq_wait);
+		kill_fasync(&ctx->cq_fasync, SIGIO, POLL_IN);
+	}
+	if (ctx->cq_ev_fd)
+		eventfd_signal(ctx->cq_ev_fd, 0);
+	wake_up_process(tsk);
+}
+
 static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, task_work_func_t func)
 {
@@ -3523,7 +3535,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	 * don't need to check here and handle it specifically.
 	 */
 	task_work_add(tsk, &req->task_work, true);
-	wake_up_process(tsk);
+	io_task_work_notify(req->ctx, tsk);
 	return 1;
 }
 
@@ -6488,7 +6500,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
 	if (READ_ONCE(ctx->rings->sq.tail) - ctx->cached_sq_head !=
 	    ctx->rings->sq_ring_entries)
 		mask |= EPOLLOUT | EPOLLWRNORM;
-	if (io_cqring_events(ctx, false))
+	if (io_cqring_events(ctx, false) || current->task_works != NULL)
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	return mask;


-- 
Jens Axboe

