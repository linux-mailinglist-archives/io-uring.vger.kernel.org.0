Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 17065166C52
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 02:30:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729535AbgBUBaI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 20:30:08 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42294 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729502AbgBUBaI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 20:30:08 -0500
Received: by mail-ot1-f66.google.com with SMTP id 66so588049otd.9
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 17:30:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PvrvR7mcQGalJBUBtRVdWFl5mEyZ7c/z7OOE/eTBfUc=;
        b=QKrQLkJk1rg3x/OWJXfT6dFKJUBkCVihKhCavbSsrgEio9x1XaendcuX8NL8K6EE8H
         9k35m9otcOqe2X4Hx/npUgHwsxya7v3XkTP0t8onvfen4+A6uu5cdVKbYzfI36pjj3G5
         vP+sWeRM0kWPs8x9Al4K9KgPWeocM3uhrGC8laEWAXgwWo46MrvwYaE8fLYkdAnDluAU
         K8QxorbC67C91LBzlWzC318LSwcbYoRE1WTR18w3HHRijaeAVcLhVpSenOPdgGjhlcNU
         kvzIhoMYUo+hJEfflPeT37BDj2gIGbuB5Y1OKREgrILwccKd+thLQ94601CJsYd8tpch
         4zMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PvrvR7mcQGalJBUBtRVdWFl5mEyZ7c/z7OOE/eTBfUc=;
        b=qTZVJQong76mks5IqAkhF1BOjB8o1rMSHV7BuOQpawTGVfr1mFJGA364Nn0iolwTtD
         rMB/6AzBq17uQDxObuwm77U6LEdgU6dXK8lwGH1dTrx8jwjuWkKV5H1MX38eYvuXXfRN
         RYhMhy90OGovoMcBuWXOoDSZbsPxEM2TKs9ts5gtIlNdElYOtEZ6+0eIJNIEm6TiQtrq
         MfK7waJnWQiVSPZltcs7uOfwNliEn67b4lJs3QCOlXlwFGLqKBoy8vHx8h9d8c48nNGt
         PPKW6BFeiPznJiZ0NvjjvRt6Y5ovEwUTJn9BmjELEmhdxf9MUMhrL/lAUX6TYYVe/gI2
         duBw==
X-Gm-Message-State: APjAAAXBcygmi5TgjL7G/RV1Wm6qSWWETMk9Vf/w0TKfsyYcYfWgFRT6
        WTkFneCNmjRz8VvDwPuj4xF0biXbqCrqLViqME3YzzUxgcQ=
X-Google-Smtp-Source: APXvYqwuKZACJJNBm4XUqoxo11jpXcgQAnrQpawGxZQ30RWzFIOsPValsiXlxN7PoEO+LF/ENRtVGZ/piIX2D7BduHU=
X-Received: by 2002:a9d:268:: with SMTP id 95mr26628703otb.183.1582248606256;
 Thu, 20 Feb 2020 17:30:06 -0800 (PST)
MIME-Version: 1.0
References: <20200220203151.18709-1-axboe@kernel.dk> <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk> <CAG48ez37KerMukJ6zU=VQPtHsxo29S7TxqcqvU=Bs7Lfxtfdcg@mail.gmail.com>
 <4caec29c-469d-7448-f779-af3ba9c6c6a9@kernel.dk> <CAG48ez2vXYgW8WqBxeb=A=+_2WRL98b_Heoe8rPeXOMXuuf4oQ@mail.gmail.com>
 <bdf25a89-fedd-06b4-58ba-103170bcde06@kernel.dk>
In-Reply-To: <bdf25a89-fedd-06b4-58ba-103170bcde06@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 21 Feb 2020 02:29:39 +0100
Message-ID: <CAG48ez3V+=R4JjfCxUhX_ok1yuwEzvvWERer5VyQpC5i9sy=_Q@mail.gmail.com>
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 21, 2020 at 12:22 AM Jens Axboe <axboe@kernel.dk> wrote:
> On 2/20/20 4:12 PM, Jann Horn wrote:
> > On Fri, Feb 21, 2020 at 12:00 AM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 2/20/20 3:23 PM, Jann Horn wrote:
> >>> On Thu, Feb 20, 2020 at 11:14 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>> On 2/20/20 3:02 PM, Jann Horn wrote:
> >>>>> On Thu, Feb 20, 2020 at 9:32 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>> For poll requests, it's not uncommon to link a read (or write) after
> >>>>>> the poll to execute immediately after the file is marked as ready.
> >>>>>> Since the poll completion is called inside the waitqueue wake up handler,
> >>>>>> we have to punt that linked request to async context. This slows down
> >>>>>> the processing, and actually means it's faster to not use a link for this
> >>>>>> use case.
> > [...]
> >>>>>> -static void io_poll_trigger_evfd(struct io_wq_work **workptr)
> >>>>>> +static void io_poll_task_func(struct callback_head *cb)
> >>>>>>  {
> >>>>>> -       struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> >>>>>> +       struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
> >>>>>> +       struct io_kiocb *nxt = NULL;
> >>>>>>
> >>>>> [...]
> >>>>>> +       io_poll_task_handler(req, &nxt);
> >>>>>> +       if (nxt)
> >>>>>> +               __io_queue_sqe(nxt, NULL);
> >>>>>
> >>>>> This can now get here from anywhere that calls schedule(), right?
> >>>>> Which means that this might almost double the required kernel stack
> >>>>> size, if one codepath exists that calls schedule() while near the
> >>>>> bottom of the stack and another codepath exists that goes from here
> >>>>> through the VFS and again uses a big amount of stack space? This is a
> >>>>> somewhat ugly suggestion, but I wonder whether it'd make sense to
> >>>>> check whether we've consumed over 25% of stack space, or something
> >>>>> like that, and if so, directly punt the request.
> > [...]
> >>>>> Also, can we recursively hit this point? Even if __io_queue_sqe()
> >>>>> doesn't *want* to block, the code it calls into might still block on a
> >>>>> mutex or something like that, at which point the mutex code would call
> >>>>> into schedule(), which would then again hit sched_out_update() and get
> >>>>> here, right? As far as I can tell, this could cause unbounded
> >>>>> recursion.
> >>>>
> >>>> The sched_work items are pruned before being run, so that can't happen.
> >>>
> >>> And is it impossible for new ones to be added in the meantime if a
> >>> second poll operation completes in the background just when we're
> >>> entering __io_queue_sqe()?
> >>
> >> True, that can happen.
> >>
> >> I wonder if we just prevent the recursion whether we can ignore most
> >> of it. Eg never process the sched_work list if we're not at the top
> >> level, so to speak.
> >>
> >> This should also prevent the deadlock that you mentioned with FUSE
> >> in the next email that just rolled in.
> >
> > But there the first ->read_iter could be from outside io_uring. So you
> > don't just have to worry about nesting inside an already-running uring
> > work; you also have to worry about nesting inside more or less
> > anything else that might be holding mutexes. So I think you'd pretty
> > much have to whitelist known-safe schedule() callers, or something
> > like that.
>
> I'll see if I can come up with something for that. Ideally any issue
> with IOCB_NOWAIT set should be honored, and trylock etc should be used.

Are you sure? For example, an IO operation typically copies data to
userspace, which can take pagefaults. And those should be handled
synchronously even with IOCB_NOWAIT set, right? And the page fault
code can block on mutexes (like the mmap_sem) or even wait for a
blocking filesystem operation (via file mappings) or for userspace
(via userfaultfd or FUSE mappings).

> But I don't think we can fully rely on that, we need something a bit
> more solid...
>
> > Taking a step back: Do you know why this whole approach brings the
> > kind of performance benefit you mentioned in the cover letter? 4x is a
> > lot... Is it that expensive to take a trip through the scheduler?
> > I wonder whether the performance numbers for the echo test would
> > change if you commented out io_worker_spin_for_work()...
>
> If anything, I expect the spin removal to make it worse. There's really
> no magic there on why it's faster, if you offload work to a thread that
> is essentially sync, then you're going to take a huge hit in
> performance. It's the difference between:
>
> 1) Queue work with thread, wake up thread
> 2) Thread wakes, starts work, goes to sleep.

If we go to sleep here, then the other side hasn't yet sent us
anything, so up to this point, it shouldn't have any impact on the
measured throughput, right?

> 3) Data available, thread is woken, does work

This is the same in the other case: Data is available, the
application's thread is woken and does the work.

> 4) Thread signals completion of work

And this is also basically the same, except that in the worker-thread
case, we have to go through the scheduler to reach userspace, while
with this patch series, we can signal "work is completed" and return
to userspace without an extra trip through the scheduler.

I could imagine this optimization having some performance benefit, but
I'm still sceptical about it buying a 4x benefit without some more
complicated reason behind it.

> versus just completing the work when it's ready and not having any
> switches to a worker thread at all. As the cover letter mentions, the
> single client case is a huge win, and that is of course the biggest win
> because everything is idle. If the thread doing the offload can be kept
> running, the gains become smaller as we're not paying those wake/sleep
> penalties anymore.

I'd really like to see what the scheduler behavior looks like here,
for this single-client echo test. I can imagine three cases (which I
guess are probably going to be mixed because the scheduler moves tasks
around; but I don't actually know much about how the scheduler works,
so my guesses are probably not very helpful):

Case 1: Both the worker and the userspace task are on the same CPU. In
this case, the worker will waste something on the order of 10000
cycles for every message while userspace is runnable, unless the
scheduler decides that the worker has spent so much time on the CPU
that it should relinquish it to the userspace task. (You test for
need_resched() in the busyloop, but AFAIK that just asks the scheduler
whether it wants you to get off the CPU right now, not whether there
are any other runnable tasks on the CPU at the moment.)
Case 2: The worker and the userspace task are on different *physical*
cores and don't share L1D and L2. This will cause a performance
penalty due to constant cacheline bouncing.
Case 3: The worker and the userspace task are on hyperthreads, so they
share L1D and L2 and can run concurrently. Compared to the other two
cases, this would probably work best, but I'm not sure whether the
scheduler is smart enough to specifically target this behavior? (And
if you're running inside a VM, or on a system without hyperthreading,
this isn't even an option.)

So I wonder what things look like if you force the worker and the
userspace task to run on the same CPU without any idle polling in the
worker; or how it looks when you pin the worker and the userspace task
on hyperthreads. And if that does make a difference, it might be worth
considering whether the interaction between io_uring and the scheduler
could be optimized.
