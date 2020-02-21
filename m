Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFF8168A1D
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 23:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbgBUW4f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 17:56:35 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42871 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726802AbgBUW4f (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 17:56:35 -0500
Received: by mail-ot1-f67.google.com with SMTP id 66so3517450otd.9
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 14:56:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VCr/P0VPx5ZpTDeXJAgfRfV8oJSqaY9IUoP0tev124w=;
        b=ro+PpZRIV6xJ6mIyvvmjCkaFu0+aOdN8IsTCZ43vnIDrAvZsrTFSTASG3v9Xzmr/fn
         5rh762t0kbgVhVOVa9t0JNMM6GJG5JwXA0nSyn8ydkl42FALwF0yppprrDEhgSAcRgDW
         Y0w3WAu71vDpnnZhTCda9AyV5npyYefJfZm3SThMTCEkQqT3DMpJyIUENmGlLY8HbKwV
         9Es5m7jcQzjhdTay2qUpHgL6exOrV3lWHgFlYJzAb7alrE3KYUdl0/F3Uq78RZDhpQpA
         Thj6QgZ1gPnnsJqZ82fYjuDWkk7PHwLTbTNMs6bHcg/LUapub231w+WzjkVsV4K8N/rd
         17ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VCr/P0VPx5ZpTDeXJAgfRfV8oJSqaY9IUoP0tev124w=;
        b=NOLdddXytBWzL1q9CcHsaPBsuRKxv9wwiah5duhLF5Q1IMzelteNkQPuvk+2Kw0pES
         d54/K3lp5bsq5DDyUe4cbHhQlH9aUgGD7vtfJ2IRYNurXg20ged8QjUnQLrz21hyj4j5
         vJ47Q1WQtMBMkHS2im9c2LunrkjA9lyjlrC3e+ewR/+2/2RQwceX/4sBoLj4+8k5Jjpn
         Oc2WiSkEWeUz2bECGW6IIlI+W8SMXUycA3MRKWstdmc2W4mgWIVD8LKdxfJls3cjIXWH
         glQgqXi3St60jvXdQOJyemFAJHm788h12jRCX0a+kQWjqgns/1Oy5FlxHwyu82xb/1P3
         g8fQ==
X-Gm-Message-State: APjAAAXgZY8boGpOGjxHGvDRFYBizaLgfZc7CKfIrXYtkTgt4NjLevhv
        5eo8I00kuJVDiNhBcOC6tF9lOrOdkD4z1lLIsU/ofw==
X-Google-Smtp-Source: APXvYqy2+ksoQInUyJsEJezS2s6AOc2sqKamAEwD4BzPbt/7ANOV6OzvWsnsdEJL5wKhBguXkUGL8FiGhxc0eWAy09U=
X-Received: by 2002:a9d:5e8b:: with SMTP id f11mr16913645otl.110.1582325793847;
 Fri, 21 Feb 2020 14:56:33 -0800 (PST)
MIME-Version: 1.0
References: <20200221214606.12533-1-axboe@kernel.dk> <20200221214606.12533-6-axboe@kernel.dk>
In-Reply-To: <20200221214606.12533-6-axboe@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 21 Feb 2020 23:56:07 +0100
Message-ID: <CAG48ez2ErAJgEiPdkK+PeNBoHchVEkkw5674Wt2eSaNjqyZ98g@mail.gmail.com>
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

On Fri, Feb 21, 2020 at 10:46 PM Jens Axboe <axboe@kernel.dk> wrote:
> For poll requests, it's not uncommon to link a read (or write) after
> the poll to execute immediately after the file is marked as ready.
> Since the poll completion is called inside the waitqueue wake up handler,
> we have to punt that linked request to async context. This slows down
> the processing, and actually means it's faster to not use a link for this
> use case.
>
> We also run into problems if the completion_lock is contended, as we're
> doing a different lock ordering than the issue side is. Hence we have
> to do trylock for completion, and if that fails, go async. Poll removal
> needs to go async as well, for the same reason.
>
> eventfd notification needs special case as well, to avoid stack blowing
> recursion or deadlocks.
>
> These are all deficiencies that were inherited from the aio poll
> implementation, but I think we can do better. When a poll completes,
> simply queue it up in the task poll list. When the task completes the
> list, we can run dependent links inline as well. This means we never
> have to go async, and we can remove a bunch of code associated with
> that, and optimizations to try and make that run faster. The diffstat
> speaks for itself.
[...]
> @@ -3637,8 +3587,8 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>  {
>         struct io_kiocb *req = wait->private;
>         struct io_poll_iocb *poll = &req->poll;
> -       struct io_ring_ctx *ctx = req->ctx;
>         __poll_t mask = key_to_poll(key);
> +       struct task_struct *tsk;
>
>         /* for instances that support it check for an event match first: */
>         if (mask && !(mask & poll->events))
> @@ -3646,46 +3596,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>
>         list_del_init(&poll->wait.entry);
>
[...]
> +       tsk = req->task;
> +       req->result = mask;
> +       init_task_work(&req->task_work, io_poll_task_func);
> +       task_work_add(tsk, &req->task_work, true);
> +       wake_up_process(tsk);
>         return 1;
>  }

Let's say userspace has some code like this:

[prepare two uring requests: one POLL and a RECVMSG linked behind it]
// submit requests
io_uring_enter(uring_fd, 2, 0, 0, NULL, 0);
// wait for something to happen, either a completion event from uring
or input from stdin
struct pollfd fds[] = {
  { .fd = 0, .events = POLLIN },
  { .fd = uring_fd, .events = POLLIN }
};
while (1) {
  poll(fds, 2, -1);
  if (fds[0].revents) {
    [read stuff from stdin]
  }
  if (fds[1].revents) {
    [fetch completions from shared memory]
  }
}

If userspace has reached the poll() by the time the uring POLL op
completes, I think you'll wake up the do_poll() loop while it is in
poll_schedule_timeout(); then it will do another iteration, see that
no signals are pending and none of the polled files have become ready,
and go to sleep again. So things are stuck until the io_uring fd
signals that it is ready.

The options I see are:

 - Tell the kernel to go through signal delivery code, which I think
will cause the pending syscall to actually abort and return to
userspace (which I think is kinda gross). You could maybe add a
special case where that doesn't happen if the task is already in
io_uring_enter() and waiting for CQ events.
 - Forbid eventfd notifications, ensure that the ring's ->poll handler
reports POLLIN when work items are pending for userspace, and then
rely on the fact that those work items will be picked up when
returning from the poll syscall. Unfortunately, this gets a bit messy
when you're dealing with multiple threads that access the same ring,
since then you'd have to ensure that *any* thread can pick up this
work, and that that doesn't mismatch how the uring instance is shared
between threads; but you could probably engineer your way around this.
For userspace, this whole thing just means "POLLIN may be spurious".
 - Like the previous item, except you tell userspace that if it gets
POLLIN (or some special poll status like POLLRDBAND) and sees nothing
in the completion queue, it should call io_uring_enter() to process
the work. This addresses the submitter-is-not-completion-reaper
scenario without having to add some weird version of task_work that
will be processed by the first thread, but you'd get some extra
syscalls.
