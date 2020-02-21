Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC46A16810F
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 16:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728690AbgBUPDF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 10:03:05 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:41259 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727315AbgBUPDF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 10:03:05 -0500
Received: by mail-ot1-f67.google.com with SMTP id r27so2222047otc.8
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 07:03:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wce+WQ3RkyDZxhwp7gQJ//doVFzwE3TAuHI0uabjWq4=;
        b=vhpRtCXrfWRusUYf0v8JBn6SHuW3ui5QmbaUx1mDRB9Z5rVessoytDE4J2D1cRqAyj
         eElGm4p2nqR5GsyqtbAZbd82VSu4NVkYLuHZdeM63x/G+/eQEFyfHJ8fVGWvERmxxaVG
         kJOvDi/A7rOWba+2BgokGp39WkoiG2K0D44jKZll9Uu14ZCx9JsKEZSsytYHMIvR1GCS
         f8kbi2Mv4k02jA8s9e/6mdQ8wqojpi2/fTPWYQxNQ4atG4vNwJ1lgTYa8A2GnuFyvOk8
         DpKfQe6MBT0V+RGf7EnkSx59LfSc8SJfHyxN/EJ+uyT0XQniA9TYOX7Zm0SA9HSp6plr
         Q7MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wce+WQ3RkyDZxhwp7gQJ//doVFzwE3TAuHI0uabjWq4=;
        b=GdwRjmpPXu4tse0AEg3lI1OixiqrodKt5aNcLJoxl9sh1+S2xcmx8vufWTa4vxLCp+
         bZ58jKIqCACknPf6Ah81lU9xCuJOEuWes7vUiSwE8Ps99OvSsRR6Gm8KaP4Id+c1JPv+
         3wdg+8ez0zrhP2F5nrFPMIm6WVQ+OI1UyL8ookpqu5qv/Y8zof4vW0CPAWbdeu0rD95n
         G9vc2jQbsXEKpN61GOWfcAdmfVYhdowsMPJDtNytTBgnO1YAW4zK2mq27TUg0oNN52oa
         nMntGWIngjr2v9yNquPVH4FS/uUJOzPOHCu+h/73chJ/xamB+ERXVPJsv3mmGVx4vzWz
         GghA==
X-Gm-Message-State: APjAAAWJDe/JFoFQb+xe2GQOb3D0EI1dzJI5vJvSUK19o0WA4ppEPkJH
        QiOHtcR6fhjFsbN0+LaLycOGUhOxR9k1t6Axw3p+3g==
X-Google-Smtp-Source: APXvYqz/BEXfwBufJtlswnQg1lGfROdgEK0oEl4699ycLPEyBJQh5arRUm/NkZjuOvKK+ocZTdplWCWW8TqWOdu8BgU=
X-Received: by 2002:a9d:268:: with SMTP id 95mr29216796otb.183.1582297383771;
 Fri, 21 Feb 2020 07:03:03 -0800 (PST)
MIME-Version: 1.0
References: <20200220203151.18709-1-axboe@kernel.dk> <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <20200221104740.GE18400@hirez.programming.kicks-ass.net> <7e8d4355-fd2c-b155-b28c-57fd20db949d@kernel.dk>
In-Reply-To: <7e8d4355-fd2c-b155-b28c-57fd20db949d@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 21 Feb 2020 16:02:36 +0100
Message-ID: <CAG48ez3Bc6gCVX7Gd2mFDR=ktGE0M_H+s6pHao2NjUrbxub20w@mail.gmail.com>
Subject: Re: [PATCH 7/9] io_uring: add per-task callback handler
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        io-uring <io-uring@vger.kernel.org>,
        Glauber Costa <glauber@scylladb.com>,
        Pavel Begunkov <asml.silence@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Feb 21, 2020 at 3:49 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 2/21/20 3:47 AM, Peter Zijlstra wrote:
> > On Thu, Feb 20, 2020 at 11:02:16PM +0100, Jann Horn wrote:
> >> On Thu, Feb 20, 2020 at 9:32 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> For poll requests, it's not uncommon to link a read (or write) after
> >>> the poll to execute immediately after the file is marked as ready.
> >>> Since the poll completion is called inside the waitqueue wake up handler,
> >>> we have to punt that linked request to async context. This slows down
> >>> the processing, and actually means it's faster to not use a link for this
> >>> use case.
> >>>
> >>> We also run into problems if the completion_lock is contended, as we're
> >>> doing a different lock ordering than the issue side is. Hence we have
> >>> to do trylock for completion, and if that fails, go async. Poll removal
> >>> needs to go async as well, for the same reason.
> >>>
> >>> eventfd notification needs special case as well, to avoid stack blowing
> >>> recursion or deadlocks.
> >>>
> >>> These are all deficiencies that were inherited from the aio poll
> >>> implementation, but I think we can do better. When a poll completes,
> >>> simply queue it up in the task poll list. When the task completes the
> >>> list, we can run dependent links inline as well. This means we never
> >>> have to go async, and we can remove a bunch of code associated with
> >>> that, and optimizations to try and make that run faster. The diffstat
> >>> speaks for itself.
> >> [...]
> >>> -static void io_poll_trigger_evfd(struct io_wq_work **workptr)
> >>> +static void io_poll_task_func(struct callback_head *cb)
> >>>  {
> >>> -       struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> >>> +       struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
> >>> +       struct io_kiocb *nxt = NULL;
> >>>
> >> [...]
> >>> +       io_poll_task_handler(req, &nxt);
> >>> +       if (nxt)
> >>> +               __io_queue_sqe(nxt, NULL);
> >>
> >> This can now get here from anywhere that calls schedule(), right?
> >> Which means that this might almost double the required kernel stack
> >> size, if one codepath exists that calls schedule() while near the
> >> bottom of the stack and another codepath exists that goes from here
> >> through the VFS and again uses a big amount of stack space? This is a
> >> somewhat ugly suggestion, but I wonder whether it'd make sense to
> >> check whether we've consumed over 25% of stack space, or something
> >> like that, and if so, directly punt the request.
> >
> > I'm still completely confused as to how io_uring works, and concequently
> > the ramifications of all this.
> >
> > But I thought to understand that these sched_work things were only
> > queued on tasks that were stuck waiting on POLL (or it's io_uring
> > equivalent). Earlier patches were explicitly running things from
> > io_cqring_wait(), which might have given me this impression.
>
> No, that is correct.

Really? I was pretty sure that io_uring does not force the calling
thread to block on the io_uring operations to continue; and isn't that
the whole point?

I think that when Peter says "stuck waiting on POLL", he really means
"blocked in the context of sys_io_uring_enter() and can't go
anywhere"; while I think you interpret it as "has pending POLL work
queued up in the background and may decide to wait for it in
sys_io_uring_enter(), but might also be doing anything else".

> > The above seems to suggest this is not the case. Which then does indeed
> > lead to all the worries expressed by Jann. All sorts of nasty nesting is
> > possible with this.
> >
> > Can someone please spell this out for me?
>
> Let me try with an example - the tldr is that a task wants to eg read
> from a socket, it issues a io_uring recv() for example. We always do
> these non-blocking, there's no data there, the task gets -EAGAIN on the
> attempt. What would happen in the previous code is the task would then
> offload the recv() to a worker thread, and the worker thread would
> block waiting on the receive. This is sub-optimal, in that it both
> requires a thread offload and has a thread alive waiting for that data
> to come in.
>
> This, instead, arms a poll handler for the task.

And then returns to userspace, which can do whatever it wants, right?

> When we get notified of
> data availability, we queue a work item that will the perform the
> recv(). This is what is offloaded to the sched_work list currently.
>
> > Afaict the req->tsk=current thing is set for whomever happens to run
> > io_poll_add_prep(), which is either a sys_io_uring_enter() or an io-wq
> > thread afaict.
> >
> > But I'm then unsure what happens to that thread afterwards.
> >
> > Jens, what exactly is the benefit of running this on every random
> > schedule() vs in io_cqring_wait() ? Or even, since io_cqring_wait() is
> > the very last thing the syscall does, task_work.
>
> I took a step back and I think we can just use the task work, which
> makes this a lot less complicated in terms of locking and schedule
> state. Ran some quick testing with the below and it works for me.
>
> I'm going to re-spin based on this and just dump the sched_work
> addition.

Task work only run on transitions between userspace and kernel, more
or less, right? I guess that means that you'd have to wake up the
ctx->cq_wait queue so that anyone who might e.g. be waiting for the
ring with select() or poll() or epoll or whatever gets woken up and
returns out of the polling syscall? Essentially an intentional
spurious notification to force the task to pick up work. And the
interaction with eventfds would then be a bit weird, I think, since
you may have to signal completion on an eventfd in order to get the
task to pick up the work; but then the work may block, and then stuff
is a bit weird.
