Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E311168503
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 18:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726032AbgBURci (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 12:32:38 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:56267 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbgBURci (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 12:32:38 -0500
Received: by mail-pj1-f67.google.com with SMTP id d5so1045867pjz.5
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 09:32:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zZ/x/Eo4sgN1RR+iZmVMYzVryHshANhkJ6S0G8djlwk=;
        b=zXq9kROu0v/T36LiMde7pk+Uwsuu775JipFPfv0ISrRb0nc8SqGq9ES5iitOiiyjEL
         6jWDJmfMt7Xb0CEgjDjr4quToNzLxCnqjnGkFjmuagfuhQ2QzoJ2cnAgV60flpjMghNP
         f0szgX7tQOydhVsOlE/PaQAGEtXhBjALAbYTaEqroYGlyOeoDoNyGYiJb6e+Dponuu0C
         KfFKFaZmD2/QqfrRW7SadqP59WvxZy20ItIHNgJ3ajL4VEKxqFkF8ZiV+r70BCEYNYkd
         M+770HWxjxKWutXmV/QFtVKAnJkkjXs64LtusVvNOk5Fv0Wt27FNK/M9Oa544i4UR8M9
         scow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zZ/x/Eo4sgN1RR+iZmVMYzVryHshANhkJ6S0G8djlwk=;
        b=RQ7bZfLUieF24sDBA5lyBPOHWGrXrZHh6BHMKel9L8f+zlBjJNznY6JfM9fYjsCDQe
         w/nM2Qnc6GUEeXnT7pgxC7yvurnbfek6y4cBfv9kYAqKO1+W84lodbKcGoVPj6ZN9Z1Y
         JJAIKU1BW9yZHGl/XiDPOGXo3xdS8DG4ol99zhe6pW7vMOgnf7BLAlYPVPzfSAbuhCXH
         1nF5CCyeuzArrfBLGD5MGss9CQr/hM4VBevP7fs/umGvH/sjksg1jmDZ/j08rjPIqlDp
         pNOA6YpjQRTyzh50QWV4sDMgj4x4ZlHMUlCHRGX0jQXFS2UmNjAFcW7fSengQxKNFgCO
         16lQ==
X-Gm-Message-State: APjAAAWoc3/xUsbB/ugSo8UJN7YwdEGUZkwKYrSuj+btZPD8F9SgQ43b
        t4FVZSb1b4Zd7zREubDQAxrOXw==
X-Google-Smtp-Source: APXvYqzt4K8erntFLUoApGZUEnMZuTV+0GeJGsQHQGCTp/pz3g1PNsEuFjLsjApk/Od5XnE++RiX3g==
X-Received: by 2002:a17:90a:f013:: with SMTP id bt19mr4283243pjb.47.1582306357718;
        Fri, 21 Feb 2020 09:32:37 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:91ff:e31e:f68d:32a9? ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id 23sm3511969pfh.28.2020.02.21.09.32.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 09:32:37 -0800 (PST)
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Jann Horn <jannh@google.com>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk>
 <CAG48ez37KerMukJ6zU=VQPtHsxo29S7TxqcqvU=Bs7Lfxtfdcg@mail.gmail.com>
 <4caec29c-469d-7448-f779-af3ba9c6c6a9@kernel.dk>
 <CAG48ez2vXYgW8WqBxeb=A=+_2WRL98b_Heoe8rPeXOMXuuf4oQ@mail.gmail.com>
 <bdf25a89-fedd-06b4-58ba-103170bcde06@kernel.dk>
 <CAG48ez3V+=R4JjfCxUhX_ok1yuwEzvvWERer5VyQpC5i9sy=_Q@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ee96f96d-ff69-1ca8-25d8-a9b5b25512cd@kernel.dk>
Date:   Fri, 21 Feb 2020 09:32:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez3V+=R4JjfCxUhX_ok1yuwEzvvWERer5VyQpC5i9sy=_Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/20/20 6:29 PM, Jann Horn wrote:
> On Fri, Feb 21, 2020 at 12:22 AM Jens Axboe <axboe@kernel.dk> wrote:
>> On 2/20/20 4:12 PM, Jann Horn wrote:
>>> On Fri, Feb 21, 2020 at 12:00 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 2/20/20 3:23 PM, Jann Horn wrote:
>>>>> On Thu, Feb 20, 2020 at 11:14 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> On 2/20/20 3:02 PM, Jann Horn wrote:
>>>>>>> On Thu, Feb 20, 2020 at 9:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>> For poll requests, it's not uncommon to link a read (or write) after
>>>>>>>> the poll to execute immediately after the file is marked as ready.
>>>>>>>> Since the poll completion is called inside the waitqueue wake up handler,
>>>>>>>> we have to punt that linked request to async context. This slows down
>>>>>>>> the processing, and actually means it's faster to not use a link for this
>>>>>>>> use case.
>>> [...]
>>>>>>>> -static void io_poll_trigger_evfd(struct io_wq_work **workptr)
>>>>>>>> +static void io_poll_task_func(struct callback_head *cb)
>>>>>>>>  {
>>>>>>>> -       struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
>>>>>>>> +       struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
>>>>>>>> +       struct io_kiocb *nxt = NULL;
>>>>>>>>
>>>>>>> [...]
>>>>>>>> +       io_poll_task_handler(req, &nxt);
>>>>>>>> +       if (nxt)
>>>>>>>> +               __io_queue_sqe(nxt, NULL);
>>>>>>>
>>>>>>> This can now get here from anywhere that calls schedule(), right?
>>>>>>> Which means that this might almost double the required kernel stack
>>>>>>> size, if one codepath exists that calls schedule() while near the
>>>>>>> bottom of the stack and another codepath exists that goes from here
>>>>>>> through the VFS and again uses a big amount of stack space? This is a
>>>>>>> somewhat ugly suggestion, but I wonder whether it'd make sense to
>>>>>>> check whether we've consumed over 25% of stack space, or something
>>>>>>> like that, and if so, directly punt the request.
>>> [...]
>>>>>>> Also, can we recursively hit this point? Even if __io_queue_sqe()
>>>>>>> doesn't *want* to block, the code it calls into might still block on a
>>>>>>> mutex or something like that, at which point the mutex code would call
>>>>>>> into schedule(), which would then again hit sched_out_update() and get
>>>>>>> here, right? As far as I can tell, this could cause unbounded
>>>>>>> recursion.
>>>>>>
>>>>>> The sched_work items are pruned before being run, so that can't happen.
>>>>>
>>>>> And is it impossible for new ones to be added in the meantime if a
>>>>> second poll operation completes in the background just when we're
>>>>> entering __io_queue_sqe()?
>>>>
>>>> True, that can happen.
>>>>
>>>> I wonder if we just prevent the recursion whether we can ignore most
>>>> of it. Eg never process the sched_work list if we're not at the top
>>>> level, so to speak.
>>>>
>>>> This should also prevent the deadlock that you mentioned with FUSE
>>>> in the next email that just rolled in.
>>>
>>> But there the first ->read_iter could be from outside io_uring. So you
>>> don't just have to worry about nesting inside an already-running uring
>>> work; you also have to worry about nesting inside more or less
>>> anything else that might be holding mutexes. So I think you'd pretty
>>> much have to whitelist known-safe schedule() callers, or something
>>> like that.
>>
>> I'll see if I can come up with something for that. Ideally any issue
>> with IOCB_NOWAIT set should be honored, and trylock etc should be used.
> 
> Are you sure? For example, an IO operation typically copies data to
> userspace, which can take pagefaults. And those should be handled
> synchronously even with IOCB_NOWAIT set, right? And the page fault
> code can block on mutexes (like the mmap_sem) or even wait for a
> blocking filesystem operation (via file mappings) or for userspace
> (via userfaultfd or FUSE mappings).

Yeah that's a good point. The more I think about it, the less I think
the scheduler invoked callback is going to work. We need to be able to
manage the context of when we are called, see later messages on the
task_work usage instead.

>> But I don't think we can fully rely on that, we need something a bit
>> more solid...
>>
>>> Taking a step back: Do you know why this whole approach brings the
>>> kind of performance benefit you mentioned in the cover letter? 4x is a
>>> lot... Is it that expensive to take a trip through the scheduler?
>>> I wonder whether the performance numbers for the echo test would
>>> change if you commented out io_worker_spin_for_work()...
>>
>> If anything, I expect the spin removal to make it worse. There's really
>> no magic there on why it's faster, if you offload work to a thread that
>> is essentially sync, then you're going to take a huge hit in
>> performance. It's the difference between:
>>
>> 1) Queue work with thread, wake up thread
>> 2) Thread wakes, starts work, goes to sleep.
> 
> If we go to sleep here, then the other side hasn't yet sent us
> anything, so up to this point, it shouldn't have any impact on the
> measured throughput, right?
> 
>> 3) Data available, thread is woken, does work
> 
> This is the same in the other case: Data is available, the
> application's thread is woken and does the work.
> 
>> 4) Thread signals completion of work
> 
> And this is also basically the same, except that in the worker-thread
> case, we have to go through the scheduler to reach userspace, while
> with this patch series, we can signal "work is completed" and return
> to userspace without an extra trip through the scheduler.

There's a big difference between:

- Task needs to do work, task goes to sleep on it, task is woken

and

- Task needs to do work, task passes work to thread. Task goes to sleep.
  Thread wakes up, tries to do work, goes to sleep. Thread is woken,
  does work, notifies task. Task is woken up.

If you've ever done any sort of thread poll (userspace or otherwise),
this is painful, and particularly so when you're only keeping one
work item in flight. That kind of pipeline is rife with bubbles. If we
can have multiple items in flight, then we start to gain ground due to
the parallelism.

> I could imagine this optimization having some performance benefit, but
> I'm still sceptical about it buying a 4x benefit without some more
> complicated reason behind it.

I just re-ran the testing, this time on top of the current tree, where
instead of doing the task/sched_work_add() we simply queue for async.
This should be an even better case than before, since hopefully the
thread will not need to go to sleep to process the work, it'll complete
without blocking. For an echo test setup over a socket, this approach
yields about 45-48K requests per second. This, btw, is with the io-wq
spin removed. Using the callback method where the task itself does the
work, 175K-180K requests per second.

>> versus just completing the work when it's ready and not having any
>> switches to a worker thread at all. As the cover letter mentions, the
>> single client case is a huge win, and that is of course the biggest win
>> because everything is idle. If the thread doing the offload can be kept
>> running, the gains become smaller as we're not paying those wake/sleep
>> penalties anymore.
> 
> I'd really like to see what the scheduler behavior looks like here,
> for this single-client echo test. I can imagine three cases (which I
> guess are probably going to be mixed because the scheduler moves tasks
> around; but I don't actually know much about how the scheduler works,
> so my guesses are probably not very helpful):
> 
> Case 1: Both the worker and the userspace task are on the same CPU. In
> this case, the worker will waste something on the order of 10000
> cycles for every message while userspace is runnable, unless the
> scheduler decides that the worker has spent so much time on the CPU
> that it should relinquish it to the userspace task. (You test for
> need_resched() in the busyloop, but AFAIK that just asks the scheduler
> whether it wants you to get off the CPU right now, not whether there
> are any other runnable tasks on the CPU at the moment.)
> Case 2: The worker and the userspace task are on different *physical*
> cores and don't share L1D and L2. This will cause a performance
> penalty due to constant cacheline bouncing.
> Case 3: The worker and the userspace task are on hyperthreads, so they
> share L1D and L2 and can run concurrently. Compared to the other two
> cases, this would probably work best, but I'm not sure whether the
> scheduler is smart enough to specifically target this behavior? (And
> if you're running inside a VM, or on a system without hyperthreading,
> this isn't even an option.)
> 
> So I wonder what things look like if you force the worker and the
> userspace task to run on the same CPU without any idle polling in the
> worker; or how it looks when you pin the worker and the userspace task
> on hyperthreads. And if that does make a difference, it might be worth
> considering whether the interaction between io_uring and the scheduler
> could be optimized.

We can probably get closer with smarter placement, but it's never going
to be anywhere near as fast as when the task itself does the work. For
the echo example, ideally you want the server and client on the same
CPU. And since it's a benchmark, both of them soak up the core, in my
testing I see about 55-60% backend CPU, and 40-40% from the client. I
could affinitize the async thread to the same CPU, but we're just going
to be stealing cycles at that point.

-- 
Jens Axboe

