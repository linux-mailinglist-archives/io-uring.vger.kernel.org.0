Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2602168A2D
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2020 00:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729266AbgBUXA5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 18:00:57 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:44455 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgBUXA4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 18:00:56 -0500
Received: by mail-oi1-f194.google.com with SMTP id d62so3231033oia.11
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 15:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zlq6RiRvm/X0+rC9zhzocthEsmrZqg7d6hg53/Ba8lI=;
        b=G6oH+zgH6dlw29JmVK6IHuc5efJcMD1LVzooHocZSabojkQaLPbnmImBW9prLwKxkZ
         eqxRydybrmYZBWYbjxGkMnw9QMoX9k/PX23oVLenf1sfQ7dFRKt7BmoafLQukpRWeS08
         BOUiD/40RYrS0/PWYt5x/qMDn4L0WnEGIPpdwGbB+tssIhiZlK75BbFa+1fkjX+6piDB
         9QzqYrWhF+6+mwpENzVUrdRUzwfkOzoyTljdlPXdTHyqX90DKeAIbnBI5ygGziN+xvgJ
         3YIxtVvtC3hivSf/Xc7Jjb1TLIB3V16qKVM5tWoEvWjbw1c0fAayzb8Uv7xhJZ0ou6k3
         Mjng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zlq6RiRvm/X0+rC9zhzocthEsmrZqg7d6hg53/Ba8lI=;
        b=OI+t5/rrD4QZ7+0wQJ9J28tU487gGEnU0/4X5eiTvkpmdoNl68Vi/BaxYa/bBYI93e
         m/3KPqzfh3pChunJpCx3arAxND/O1xOSHSHDJYMMfYle2kJqQclPA437BSluZcoQ+YCg
         fSMmmDh1zstWGnWp0kmDQ9GX8GOp/HHJaIFgEYmwTwqeaaJ0q8SkzP1AXromfDEVESJD
         zOpTcstvY+H3f7TdkJXMdzgmSUhUdH56e/DD77buiButmYGzHE5ngXZNDxKyOFrkAJ/3
         g6n2EMX+xcR7Azp0k67UEigxqGKXuxx7fNf6R0tccBFocna3/K6WywwyaP347XDXdf1k
         P/Ow==
X-Gm-Message-State: APjAAAUAQJuSnCRTvCZDizmKcC4ciMUg6rCh9YGvqIUX8w9kiiacyvM9
        yLj9bpLgU8gatFU0wFsqd5uSXpJ/xxuv+c5+kYPzRqzlRbA=
X-Google-Smtp-Source: APXvYqwNSFLLOz+vJL4Zgu+QMQjgAJ8ApKDpY44g0p53F5hAJWaZRur6/FCn8NScYoW/QKM9JWUnxY9yG0VaKD4FtI0=
X-Received: by 2002:aca:1913:: with SMTP id l19mr3870337oii.47.1582326055759;
 Fri, 21 Feb 2020 15:00:55 -0800 (PST)
MIME-Version: 1.0
References: <20200221214606.12533-1-axboe@kernel.dk> <20200221214606.12533-6-axboe@kernel.dk>
 <CAG48ez2ErAJgEiPdkK+PeNBoHchVEkkw5674Wt2eSaNjqyZ98g@mail.gmail.com>
In-Reply-To: <CAG48ez2ErAJgEiPdkK+PeNBoHchVEkkw5674Wt2eSaNjqyZ98g@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Sat, 22 Feb 2020 00:00:29 +0100
Message-ID: <CAG48ez3rsk6TzF82Q0PvDDCRp6wfWWUn8bsSZ2+OB9FgSOGgsw@mail.gmail.com>
Subject: Re: [PATCH 5/7] io_uring: add per-task callback handler
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

On Fri, Feb 21, 2020 at 11:56 PM Jann Horn <jannh@google.com> wrote:
> On Fri, Feb 21, 2020 at 10:46 PM Jens Axboe <axboe@kernel.dk> wrote:
> > For poll requests, it's not uncommon to link a read (or write) after
> > the poll to execute immediately after the file is marked as ready.
> > Since the poll completion is called inside the waitqueue wake up handler,
> > we have to punt that linked request to async context. This slows down
> > the processing, and actually means it's faster to not use a link for this
> > use case.
> >
> > We also run into problems if the completion_lock is contended, as we're
> > doing a different lock ordering than the issue side is. Hence we have
> > to do trylock for completion, and if that fails, go async. Poll removal
> > needs to go async as well, for the same reason.
> >
> > eventfd notification needs special case as well, to avoid stack blowing
> > recursion or deadlocks.
> >
> > These are all deficiencies that were inherited from the aio poll
> > implementation, but I think we can do better. When a poll completes,
> > simply queue it up in the task poll list. When the task completes the
> > list, we can run dependent links inline as well. This means we never
> > have to go async, and we can remove a bunch of code associated with
> > that, and optimizations to try and make that run faster. The diffstat
> > speaks for itself.
> [...]
> > @@ -3637,8 +3587,8 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
> >  {
> >         struct io_kiocb *req = wait->private;
> >         struct io_poll_iocb *poll = &req->poll;
> > -       struct io_ring_ctx *ctx = req->ctx;
> >         __poll_t mask = key_to_poll(key);
> > +       struct task_struct *tsk;
> >
> >         /* for instances that support it check for an event match first: */
> >         if (mask && !(mask & poll->events))
> > @@ -3646,46 +3596,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
> >
> >         list_del_init(&poll->wait.entry);
> >
> [...]
> > +       tsk = req->task;
> > +       req->result = mask;
> > +       init_task_work(&req->task_work, io_poll_task_func);
> > +       task_work_add(tsk, &req->task_work, true);
> > +       wake_up_process(tsk);
> >         return 1;
> >  }
>
> Let's say userspace has some code like this:
>
> [prepare two uring requests: one POLL and a RECVMSG linked behind it]
> // submit requests
> io_uring_enter(uring_fd, 2, 0, 0, NULL, 0);
> // wait for something to happen, either a completion event from uring
> or input from stdin
> struct pollfd fds[] = {
>   { .fd = 0, .events = POLLIN },
>   { .fd = uring_fd, .events = POLLIN }
> };
> while (1) {
>   poll(fds, 2, -1);
>   if (fds[0].revents) {
>     [read stuff from stdin]
>   }
>   if (fds[1].revents) {
>     [fetch completions from shared memory]
>   }
> }
>
> If userspace has reached the poll() by the time the uring POLL op
> completes, I think you'll wake up the do_poll() loop while it is in
> poll_schedule_timeout(); then it will do another iteration, see that
> no signals are pending and none of the polled files have become ready,
> and go to sleep again. So things are stuck until the io_uring fd
> signals that it is ready.
>
> The options I see are:
>
>  - Tell the kernel to go through signal delivery code, which I think
> will cause the pending syscall to actually abort and return to
> userspace (which I think is kinda gross). You could maybe add a
> special case where that doesn't happen if the task is already in
> io_uring_enter() and waiting for CQ events.
>  - Forbid eventfd notifications, ensure that the ring's ->poll handler
> reports POLLIN when work items are pending for userspace, and then
> rely on the fact that those work items will be picked up when
> returning from the poll syscall. Unfortunately, this gets a bit messy
> when you're dealing with multiple threads that access the same ring,
> since then you'd have to ensure that *any* thread can pick up this
> work, and that that doesn't mismatch how the uring instance is shared
> between threads; but you could probably engineer your way around this.
> For userspace, this whole thing just means "POLLIN may be spurious".
>  - Like the previous item, except you tell userspace that if it gets
> POLLIN (or some special poll status like POLLRDBAND) and sees nothing
> in the completion queue, it should call io_uring_enter() to process
> the work. This addresses the submitter-is-not-completion-reaper
> scenario without having to add some weird version of task_work that
> will be processed by the first thread, but you'd get some extra
> syscalls.

... or I suppose you could punt to worker context if anyone uses the
ring's ->poll handler or has an eventfd registered, if you don't
expect high-performance users to do those things.
