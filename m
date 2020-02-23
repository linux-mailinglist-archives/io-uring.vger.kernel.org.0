Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A37D169596
	for <lists+io-uring@lfdr.de>; Sun, 23 Feb 2020 04:31:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgBWDbE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Feb 2020 22:31:04 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:42501 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727093AbgBWDbD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Feb 2020 22:31:03 -0500
Received: by mail-pf1-f193.google.com with SMTP id 4so3454757pfz.9
        for <io-uring@vger.kernel.org>; Sat, 22 Feb 2020 19:31:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NnKd5QZcbQ0Z9Jl7qC8S5Pr0nkg84FSdSx17OdDaFbI=;
        b=gphvdmL09Z5+xp78TD9iBxRI8T3B8Cl4kYIP4oa6gcNqForx8j27HANX1/a7e/sUJm
         sqdrw9k2p9SOLVcS36lMdgaRFYxQgW6oCVZOAC4Ph4gLU40zucrZOHw8/T4CdwnIJ1/k
         o5UGi0rkwhiKDyG8Px9cqB+x6qbS76dJajo15aGXx80kUewnSAKVeSedYxEYEA8PR0JT
         4dBWb47BPe6MabmREBuWx8w5R9DKxi08LaFoyFlhTT/fUg77RbmBoez31AK95ejXQC4t
         46ZLqoSFKDLhqkd7sKRuE1darlqRiBYn9DdAlwuTwvxCKcuublHhlBUFoGxISsGksleZ
         ZF3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NnKd5QZcbQ0Z9Jl7qC8S5Pr0nkg84FSdSx17OdDaFbI=;
        b=feaqBAoS5j4ClwjxsOuiRNmkOkD11fUBdgbzsiEUYQXpwWBLwVjT7tqVxu/VevXjfa
         9GgN9GBbFJ2wdMESORCsm8kMnjKkXqZYVcknhQylORVeNgY5XIe5THrHT/aLRNmkMoj5
         4DcV/yfow9LfIEytUdtOOe6AmOIiOXRbtYWHe6PyIJJQaX1zHjVnE0uWkNWhfDNO2cbw
         ZqIKV+8UbEnLe3ed8HIP2PmnW+9dxhVX+wrTXx1txcYyV6MoktDGIgAx2IyCdnS79yas
         hA0bUII/oWAvG+BKz0tILX6zQ7vi9iB3Ev9Yg+omoSoBnIbOuXZ8oEhxMfGvcoZmI97h
         KlkQ==
X-Gm-Message-State: APjAAAUshGIX+/SrEBOFWnrLXrJJCfregKponT0gHEv4iNvEkMByPE4k
        Fdg1I42UK68IiBFCSco0pvglwg==
X-Google-Smtp-Source: APXvYqyFT/ed/Z4B4DkNvjvJU00iVYfW9q7h6QsUYZJSTNmcHnAaGETyAt6T/uj/fxtUgOAFBgMFAA==
X-Received: by 2002:aa7:8610:: with SMTP id p16mr46147325pfn.28.1582428661398;
        Sat, 22 Feb 2020 19:31:01 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id u23sm7585113pfm.29.2020.02.22.19.30.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Feb 2020 19:31:00 -0800 (PST)
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
 <5799c0a1-8b65-cc68-7f95-789d90b01ab7@kernel.dk>
 <df12b33a-4fee-d6ca-83bc-3c03bf7c56c9@kernel.dk>
 <04d65662-9117-518a-f07f-f35a9ec742e5@kernel.dk>
Message-ID: <85377537-92fc-0d24-8c01-289b0a98d665@kernel.dk>
Date:   Sat, 22 Feb 2020 20:30:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <04d65662-9117-518a-f07f-f35a9ec742e5@kernel.dk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/22/20 11:54 AM, Jens Axboe wrote:
> On 2/22/20 11:49 AM, Jens Axboe wrote:
>> On 2/22/20 8:09 AM, Jens Axboe wrote:
>>> On 2/22/20 7:41 AM, Jens Axboe wrote:
>>>> On 2/21/20 4:00 PM, Jann Horn wrote:
>>>>> On Fri, Feb 21, 2020 at 11:56 PM Jann Horn <jannh@google.com> wrote:
>>>>>> On Fri, Feb 21, 2020 at 10:46 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>> For poll requests, it's not uncommon to link a read (or write) after
>>>>>>> the poll to execute immediately after the file is marked as ready.
>>>>>>> Since the poll completion is called inside the waitqueue wake up handler,
>>>>>>> we have to punt that linked request to async context. This slows down
>>>>>>> the processing, and actually means it's faster to not use a link for this
>>>>>>> use case.
>>>>>>>
>>>>>>> We also run into problems if the completion_lock is contended, as we're
>>>>>>> doing a different lock ordering than the issue side is. Hence we have
>>>>>>> to do trylock for completion, and if that fails, go async. Poll removal
>>>>>>> needs to go async as well, for the same reason.
>>>>>>>
>>>>>>> eventfd notification needs special case as well, to avoid stack blowing
>>>>>>> recursion or deadlocks.
>>>>>>>
>>>>>>> These are all deficiencies that were inherited from the aio poll
>>>>>>> implementation, but I think we can do better. When a poll completes,
>>>>>>> simply queue it up in the task poll list. When the task completes the
>>>>>>> list, we can run dependent links inline as well. This means we never
>>>>>>> have to go async, and we can remove a bunch of code associated with
>>>>>>> that, and optimizations to try and make that run faster. The diffstat
>>>>>>> speaks for itself.
>>>>>> [...]
>>>>>>> @@ -3637,8 +3587,8 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>>>>>>  {
>>>>>>>         struct io_kiocb *req = wait->private;
>>>>>>>         struct io_poll_iocb *poll = &req->poll;
>>>>>>> -       struct io_ring_ctx *ctx = req->ctx;
>>>>>>>         __poll_t mask = key_to_poll(key);
>>>>>>> +       struct task_struct *tsk;
>>>>>>>
>>>>>>>         /* for instances that support it check for an event match first: */
>>>>>>>         if (mask && !(mask & poll->events))
>>>>>>> @@ -3646,46 +3596,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>>>>>>>
>>>>>>>         list_del_init(&poll->wait.entry);
>>>>>>>
>>>>>> [...]
>>>>>>> +       tsk = req->task;
>>>>>>> +       req->result = mask;
>>>>>>> +       init_task_work(&req->task_work, io_poll_task_func);
>>>>>>> +       task_work_add(tsk, &req->task_work, true);
>>>>>>> +       wake_up_process(tsk);
>>>>>>>         return 1;
>>>>>>>  }
>>>>>>
>>>>>> Let's say userspace has some code like this:
>>>>>>
>>>>>> [prepare two uring requests: one POLL and a RECVMSG linked behind it]
>>>>>> // submit requests
>>>>>> io_uring_enter(uring_fd, 2, 0, 0, NULL, 0);
>>>>>> // wait for something to happen, either a completion event from uring
>>>>>> or input from stdin
>>>>>> struct pollfd fds[] = {
>>>>>>   { .fd = 0, .events = POLLIN },
>>>>>>   { .fd = uring_fd, .events = POLLIN }
>>>>>> };
>>>>>> while (1) {
>>>>>>   poll(fds, 2, -1);
>>>>>>   if (fds[0].revents) {
>>>>>>     [read stuff from stdin]
>>>>>>   }
>>>>>>   if (fds[1].revents) {
>>>>>>     [fetch completions from shared memory]
>>>>>>   }
>>>>>> }
>>>>>>
>>>>>> If userspace has reached the poll() by the time the uring POLL op
>>>>>> completes, I think you'll wake up the do_poll() loop while it is in
>>>>>> poll_schedule_timeout(); then it will do another iteration, see that
>>>>>> no signals are pending and none of the polled files have become ready,
>>>>>> and go to sleep again. So things are stuck until the io_uring fd
>>>>>> signals that it is ready.
>>>>>>
>>>>>> The options I see are:
>>>>>>
>>>>>>  - Tell the kernel to go through signal delivery code, which I think
>>>>>> will cause the pending syscall to actually abort and return to
>>>>>> userspace (which I think is kinda gross). You could maybe add a
>>>>>> special case where that doesn't happen if the task is already in
>>>>>> io_uring_enter() and waiting for CQ events.
>>>>>>  - Forbid eventfd notifications, ensure that the ring's ->poll handler
>>>>>> reports POLLIN when work items are pending for userspace, and then
>>>>>> rely on the fact that those work items will be picked up when
>>>>>> returning from the poll syscall. Unfortunately, this gets a bit messy
>>>>>> when you're dealing with multiple threads that access the same ring,
>>>>>> since then you'd have to ensure that *any* thread can pick up this
>>>>>> work, and that that doesn't mismatch how the uring instance is shared
>>>>>> between threads; but you could probably engineer your way around this.
>>>>>> For userspace, this whole thing just means "POLLIN may be spurious".
>>>>>>  - Like the previous item, except you tell userspace that if it gets
>>>>>> POLLIN (or some special poll status like POLLRDBAND) and sees nothing
>>>>>> in the completion queue, it should call io_uring_enter() to process
>>>>>> the work. This addresses the submitter-is-not-completion-reaper
>>>>>> scenario without having to add some weird version of task_work that
>>>>>> will be processed by the first thread, but you'd get some extra
>>>>>> syscalls.
>>>>>
>>>>> ... or I suppose you could punt to worker context if anyone uses the
>>>>> ring's ->poll handler or has an eventfd registered, if you don't
>>>>> expect high-performance users to do those things.
>>>>
>>>> Good points, thanks Jann. We have some precedence in the area of
>>>> requiring the application to enter the kernel, that's how the CQ ring
>>>> overflow is handled as well. For liburing users, that'd be trivial to
>>>> hide, for the raw interface that's not necessarily the case. I'd hate to
>>>> make the feature opt-in rather than just generally available.
>>>>
>>>> I'll try and play with some ideas in this area and see how it falls out.
>>>
>>> I wonder if the below is enough - it'll trigger a poll and eventfd
>>> wakeup, if we add work. If current->task_works != NULL, we could also
>>> set POLLPRI to make it explicit why this happened, that seems like a
>>> better fit than POLLRDBAND.
>>
>> I guess we still need a way to ensure that the task is definitely run.
>> The app could still just do peeks and decided nothing is there, then
>> poll again (or eventfd wait again).
>>
>> I wonder how well it'd work to simply have a timer, with some
>> arbitrarily selected timeout, that we arm (if it isn't already) when
>> task work is queued. If the timer expires and there's task work pending,
>> we grab it and run it async. That'd work for any case without needing
>> any action on the application side, the downside would be that it'd be
>> slow if the application assumes it can just do ring peeks, it'd only
>> help as a last resort "ensure this work is definitely run" kind of
>> thing. So we'd have this weird corner case of "things work, but why is
>> it running slower than it should". Seems that the likelihood of never
>> entering the kernel is low, but it's not impossible at all.
> 
> And I'll keep musing... I wonder if something ala:
> 
> if (task_currently_in_kernel)
>     task_work_add();
> else
>     punt async
> 
> would be good enough, done in the proper order to avoid races, of
> course. If the usual case is task in io_cqring_wait(), then that'd work.
> It means async for the polled/eventfd case always, though, unless the
> task happens to be in the kernel waiting on that side.
> 
> Also requires some means to check if the task is in the kernel
> currently, haven't checked if we already have something that'd tell us
> that.

Just on a flight, took a closer look at the task_work. Do we really need
anything else? If 'notify' is set, then we call set_notify_resume(),
which in turn sets TIF_NOTIFY_RESUME and kicks the process. That should
go through signal handling (like TIF_SIGPENDING), regardless of whether
or not the task is currently in the kernel.

Unless I'm missing something, looks to me like we have everything we
need. I even wrote a sample small tester that submits IO and never
enters the kernel deliberately, and we peek events just fine. If we do,
then the notification side should just as well.

-- 
Jens Axboe

