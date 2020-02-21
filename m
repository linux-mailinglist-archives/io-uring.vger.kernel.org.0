Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AED0B16882F
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 21:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgBUUSg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 15:18:36 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:39889 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726483AbgBUUSg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 15:18:36 -0500
Received: by mail-pg1-f195.google.com with SMTP id j15so1539885pgm.6
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 12:18:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=v+f4ZduYZ8+q/2RCcA1lAECvzI0ERa55r5luqVEBpAA=;
        b=tW2/G2+HpfdpFbKWZK4QWCWkB+BCsLaM4ID42kMYOPAL7VNg5qegcVLUyGStsCLTg/
         g7bXP+umnM4hR/IOE6hfs8qgIxspFhK6dRT4nxyqnDTwv715X/k9vimgLZoqWYvb0GL2
         9tRpfwoH66DhWIcSqz4fWaxpQnK6aWE6lCGEF4gW6Av/efzh6Cvrw1AGYtTLEYqKm49V
         eGFcZetrQYla15qwVb2nZsLhy1PkGvrMomrxOsLBrFFJs28HlDZbmke+Gb3JjvD+qPRy
         T1BUx7PVl9CpsrLfRdoIsOtin1NcsR/cD35ulT4/Z9ayfLQe3oAB/2UQLEm+/MNMwygY
         MkKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v+f4ZduYZ8+q/2RCcA1lAECvzI0ERa55r5luqVEBpAA=;
        b=HUt0+w3tFW2dMNR6vAwOlYynA+Q64QougLt1qZzREV/btxgSsQ6WO5C5AKlFeJdizA
         XvtZL+/3+7gugrObz021YtpWoOl9a0rTudbb3ZNnwXirdqOQgYqJiXUVlM7vR/ZmakfK
         TYwIPnfTm9bee1ytxpmsTRu4e5V0e89sO3/jPr1o/AMssZAXCsW8lh6QcGzZSdnK4fxR
         A7NudeGymqxJbjVYCn5lmPKYelyWxOfJ28Qs4eveCfLdscJ9EXYYYe99RAbGb8TwRVyR
         52E3OPNaOwCM2MibIAQRCO8swArfkPK1BNyPKhDxN6j5oNGeE753PrLTFmpY5z0iWVlR
         OF4w==
X-Gm-Message-State: APjAAAWyvBGzWjgOHvzzg6myU1aNIYP0YDSY/SM4WYH+HBybffGZhRgX
        wiug0rCvkTfu8QS96BshH8U4HA==
X-Google-Smtp-Source: APXvYqzMwDArsRsTYsoN7s5DTBfcvPpmHtrknVbNjTPkOavA6LFJpmgE6qWU/Fpoxe6JyvbYVcOO+g==
X-Received: by 2002:a05:6a00:2c1:: with SMTP id b1mr39888886pft.80.1582316314920;
        Fri, 21 Feb 2020 12:18:34 -0800 (PST)
Received: from ?IPv6:2605:e000:100e:8c61:91ff:e31e:f68d:32a9? ([2605:e000:100e:8c61:91ff:e31e:f68d:32a9])
        by smtp.gmail.com with ESMTPSA id m18sm3227273pgd.39.2020.02.21.12.18.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 12:18:34 -0800 (PST)
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
 <ee96f96d-ff69-1ca8-25d8-a9b5b25512cd@kernel.dk>
 <CAG48ez0wObFg58RyZW4eOiJP39xSxeU9VedOD2OJQqSFV7dAwg@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <d5453bc0-7a2f-abdf-cd3e-c56582d6e563@kernel.dk>
Date:   Fri, 21 Feb 2020 12:18:33 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <CAG48ez0wObFg58RyZW4eOiJP39xSxeU9VedOD2OJQqSFV7dAwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/21/20 12:24 PM, Jann Horn wrote:
> On Fri, Feb 21, 2020 at 6:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>> On 2/20/20 6:29 PM, Jann Horn wrote:
>>> On Fri, Feb 21, 2020 at 12:22 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>> On 2/20/20 4:12 PM, Jann Horn wrote:
>>>>> On Fri, Feb 21, 2020 at 12:00 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>> On 2/20/20 3:23 PM, Jann Horn wrote:
>>>>>>> On Thu, Feb 20, 2020 at 11:14 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>> On 2/20/20 3:02 PM, Jann Horn wrote:
>>>>>>>>> On Thu, Feb 20, 2020 at 9:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>>>>>> For poll requests, it's not uncommon to link a read (or write) after
>>>>>>>>>> the poll to execute immediately after the file is marked as ready.
>>>>>>>>>> Since the poll completion is called inside the waitqueue wake up handler,
>>>>>>>>>> we have to punt that linked request to async context. This slows down
>>>>>>>>>> the processing, and actually means it's faster to not use a link for this
>>>>>>>>>> use case.
>>>>> [...]
>>>>>>>>>> -static void io_poll_trigger_evfd(struct io_wq_work **workptr)
>>>>>>>>>> +static void io_poll_task_func(struct callback_head *cb)
>>>>>>>>>>  {
>>>>>>>>>> -       struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
>>>>>>>>>> +       struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
>>>>>>>>>> +       struct io_kiocb *nxt = NULL;
>>>>>>>>>>
>>>>>>>>> [...]
>>>>>>>>>> +       io_poll_task_handler(req, &nxt);
>>>>>>>>>> +       if (nxt)
>>>>>>>>>> +               __io_queue_sqe(nxt, NULL);
>>>>>>>>>
>>>>>>>>> This can now get here from anywhere that calls schedule(), right?
>>>>>>>>> Which means that this might almost double the required kernel stack
>>>>>>>>> size, if one codepath exists that calls schedule() while near the
>>>>>>>>> bottom of the stack and another codepath exists that goes from here
>>>>>>>>> through the VFS and again uses a big amount of stack space? This is a
>>>>>>>>> somewhat ugly suggestion, but I wonder whether it'd make sense to
>>>>>>>>> check whether we've consumed over 25% of stack space, or something
>>>>>>>>> like that, and if so, directly punt the request.
>>>>> [...]
>>>>>>>>> Also, can we recursively hit this point? Even if __io_queue_sqe()
>>>>>>>>> doesn't *want* to block, the code it calls into might still block on a
>>>>>>>>> mutex or something like that, at which point the mutex code would call
>>>>>>>>> into schedule(), which would then again hit sched_out_update() and get
>>>>>>>>> here, right? As far as I can tell, this could cause unbounded
>>>>>>>>> recursion.
>>>>>>>>
>>>>>>>> The sched_work items are pruned before being run, so that can't happen.
>>>>>>>
>>>>>>> And is it impossible for new ones to be added in the meantime if a
>>>>>>> second poll operation completes in the background just when we're
>>>>>>> entering __io_queue_sqe()?
>>>>>>
>>>>>> True, that can happen.
>>>>>>
>>>>>> I wonder if we just prevent the recursion whether we can ignore most
>>>>>> of it. Eg never process the sched_work list if we're not at the top
>>>>>> level, so to speak.
>>>>>>
>>>>>> This should also prevent the deadlock that you mentioned with FUSE
>>>>>> in the next email that just rolled in.
>>>>>
>>>>> But there the first ->read_iter could be from outside io_uring. So you
>>>>> don't just have to worry about nesting inside an already-running uring
>>>>> work; you also have to worry about nesting inside more or less
>>>>> anything else that might be holding mutexes. So I think you'd pretty
>>>>> much have to whitelist known-safe schedule() callers, or something
>>>>> like that.
>>>>
>>>> I'll see if I can come up with something for that. Ideally any issue
>>>> with IOCB_NOWAIT set should be honored, and trylock etc should be used.
>>>
>>> Are you sure? For example, an IO operation typically copies data to
>>> userspace, which can take pagefaults. And those should be handled
>>> synchronously even with IOCB_NOWAIT set, right? And the page fault
>>> code can block on mutexes (like the mmap_sem) or even wait for a
>>> blocking filesystem operation (via file mappings) or for userspace
>>> (via userfaultfd or FUSE mappings).
>>
>> Yeah that's a good point. The more I think about it, the less I think
>> the scheduler invoked callback is going to work. We need to be able to
>> manage the context of when we are called, see later messages on the
>> task_work usage instead.
>>
>>>> But I don't think we can fully rely on that, we need something a bit
>>>> more solid...
>>>>
>>>>> Taking a step back: Do you know why this whole approach brings the
>>>>> kind of performance benefit you mentioned in the cover letter? 4x is a
>>>>> lot... Is it that expensive to take a trip through the scheduler?
>>>>> I wonder whether the performance numbers for the echo test would
>>>>> change if you commented out io_worker_spin_for_work()...
>>>>
>>>> If anything, I expect the spin removal to make it worse. There's really
>>>> no magic there on why it's faster, if you offload work to a thread that
>>>> is essentially sync, then you're going to take a huge hit in
>>>> performance. It's the difference between:
>>>>
>>>> 1) Queue work with thread, wake up thread
>>>> 2) Thread wakes, starts work, goes to sleep.
>>>
>>> If we go to sleep here, then the other side hasn't yet sent us
>>> anything, so up to this point, it shouldn't have any impact on the
>>> measured throughput, right?
>>>
>>>> 3) Data available, thread is woken, does work
>>>
>>> This is the same in the other case: Data is available, the
>>> application's thread is woken and does the work.
>>>
>>>> 4) Thread signals completion of work
>>>
>>> And this is also basically the same, except that in the worker-thread
>>> case, we have to go through the scheduler to reach userspace, while
>>> with this patch series, we can signal "work is completed" and return
>>> to userspace without an extra trip through the scheduler.
>>
>> There's a big difference between:
>>
>> - Task needs to do work, task goes to sleep on it, task is woken
>>
>> and
>>
>> - Task needs to do work, task passes work to thread. Task goes to sleep.
>>   Thread wakes up, tries to do work, goes to sleep. Thread is woken,
>>   does work, notifies task. Task is woken up.
>>
>> If you've ever done any sort of thread poll (userspace or otherwise),
>> this is painful, and particularly so when you're only keeping one
>> work item in flight. That kind of pipeline is rife with bubbles. If we
>> can have multiple items in flight, then we start to gain ground due to
>> the parallelism.
>>
>>> I could imagine this optimization having some performance benefit, but
>>> I'm still sceptical about it buying a 4x benefit without some more
>>> complicated reason behind it.
>>
>> I just re-ran the testing, this time on top of the current tree, where
>> instead of doing the task/sched_work_add() we simply queue for async.
>> This should be an even better case than before, since hopefully the
>> thread will not need to go to sleep to process the work, it'll complete
>> without blocking. For an echo test setup over a socket, this approach
>> yields about 45-48K requests per second. This, btw, is with the io-wq
>> spin removed. Using the callback method where the task itself does the
>> work, 175K-180K requests per second.
> 
> Huh. So that's like, what, somewhere on the order of 7.6 microseconds
> or somewhere around 15000 cycles overhead for shoving a request
> completion event from worker context over to a task, assuming that
> you're running at something around 2GHz? Well, I guess that's a little
> more than twice as much time as it takes to switch from one blocked
> thread to another via eventfd (including overhead from syscall and CPU
> mitigations and stuff), so I guess it's not completely unreasonable...

This is on my laptop, running the kernel in kvm for testing. So it's not
a beefy setup:

Intel(R) Core(TM) i7-8665U CPU @ 1.90GHz

> Anyway, I'll stop nagging about this since it sounds like you're going
> to implement this in a less unorthodox way now. ^^

I'll post the updated series later today, processing off ->task_works
instead. I do agree that this is much saner than trying to entangle task
state on schedule() entry/exit, and it seems to work just as well in my
testing.

-- 
Jens Axboe

