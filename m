Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24114166A50
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 23:24:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729090AbgBTWYZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 17:24:25 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37958 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729205AbgBTWYZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 17:24:25 -0500
Received: by mail-ot1-f65.google.com with SMTP id z9so238430oth.5
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 14:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cVWq4R7m+wrPm1Xh43Ta6P7RUC0zktOV29eAFSVszCU=;
        b=NGhpUZNej6HjRMGP1rFyyJnh9iEOG5bSvhMsqfiQ62MFx/LXQdkHIvLq6fQ6XQUxUO
         TKfxvmGwIK+IWNsqwZZtrTIz76V8/L5QV5W+/SLVorTvIfFG4PNDxhGBuYMJNeUMA6lM
         VZfCp+yosxvY9ZfgOeWI6t2K4rOVl01ocBRdH6UarqS8jfZvwlEN84K4lwLczWbtweBD
         TtorEmBiCWlm1H7Lhh0XDJiQ5EasTQdEbk40tNETxJT+t0lyrNc1sE94eWAHSHB+NeJq
         KAOAR+t4sOTd+9vD2NDUOhbxS2hd0EeOo/Zy31DOGOjn9P5JMjOOxFyqMnX5jpXZrkg7
         oh/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cVWq4R7m+wrPm1Xh43Ta6P7RUC0zktOV29eAFSVszCU=;
        b=KiBB+xIAM9TVh6PbYPjNPSgZKQttmze55RL3rS6m2MxOWVbQ5BIzl/xw3RKLJHRZr9
         MH29qZ3vKTn+AydrXun6I6oXDRKck8DLzpyeNoDN1tVJPwLhWA0zaqbFHSK096bpGGC8
         K8n6ZpyJd+BsQOTn4DNvLa0OF+Pej4OhY9a+w3Vpv40IVS7SDwR6nnR7U/2uAHFm7ccp
         DncqD4A1n7KeHy3JXSjq59ke/t4txiupWlVvfwAlykyp/0cQZSzzzAMqh6XngKzXiwob
         T0RbfXhc4xZAhv2PudyxpyDZ7hk87ETjfzi9FiR4wboPOqlLlYVd5VkF4W366sZiqBpm
         UM0Q==
X-Gm-Message-State: APjAAAXJKz+60d1GxVAsP8Bd0sps0tGzIe/zzrHfuvNV6zgOsygaXL/V
        2Q30TQprXmU6Q16X+g7kqlga0b7mS2uU/PIRzLdA5Q==
X-Google-Smtp-Source: APXvYqzT45PbchX7ocRT7v4WrhjKppi3NZ8tTlBE5RidukBAt86DijfQPTYk+m/VR0jpmrignvmRouJd0HQ22n0D5+s=
X-Received: by 2002:a9d:5e8b:: with SMTP id f11mr11931144otl.110.1582237463704;
 Thu, 20 Feb 2020 14:24:23 -0800 (PST)
MIME-Version: 1.0
References: <20200220203151.18709-1-axboe@kernel.dk> <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com> <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk>
In-Reply-To: <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 20 Feb 2020 23:23:57 +0100
Message-ID: <CAG48ez37KerMukJ6zU=VQPtHsxo29S7TxqcqvU=Bs7Lfxtfdcg@mail.gmail.com>
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

On Thu, Feb 20, 2020 at 11:14 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 2/20/20 3:02 PM, Jann Horn wrote:
> > On Thu, Feb 20, 2020 at 9:32 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> For poll requests, it's not uncommon to link a read (or write) after
> >> the poll to execute immediately after the file is marked as ready.
> >> Since the poll completion is called inside the waitqueue wake up handler,
> >> we have to punt that linked request to async context. This slows down
> >> the processing, and actually means it's faster to not use a link for this
> >> use case.
> >>
> >> We also run into problems if the completion_lock is contended, as we're
> >> doing a different lock ordering than the issue side is. Hence we have
> >> to do trylock for completion, and if that fails, go async. Poll removal
> >> needs to go async as well, for the same reason.
> >>
> >> eventfd notification needs special case as well, to avoid stack blowing
> >> recursion or deadlocks.
> >>
> >> These are all deficiencies that were inherited from the aio poll
> >> implementation, but I think we can do better. When a poll completes,
> >> simply queue it up in the task poll list. When the task completes the
> >> list, we can run dependent links inline as well. This means we never
> >> have to go async, and we can remove a bunch of code associated with
> >> that, and optimizations to try and make that run faster. The diffstat
> >> speaks for itself.
> > [...]
> >> -static void io_poll_trigger_evfd(struct io_wq_work **workptr)
> >> +static void io_poll_task_func(struct callback_head *cb)
> >>  {
> >> -       struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> >> +       struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
> >> +       struct io_kiocb *nxt = NULL;
> >>
> > [...]
> >> +       io_poll_task_handler(req, &nxt);
> >> +       if (nxt)
> >> +               __io_queue_sqe(nxt, NULL);
> >
> > This can now get here from anywhere that calls schedule(), right?
> > Which means that this might almost double the required kernel stack
> > size, if one codepath exists that calls schedule() while near the
> > bottom of the stack and another codepath exists that goes from here
> > through the VFS and again uses a big amount of stack space? This is a
> > somewhat ugly suggestion, but I wonder whether it'd make sense to
> > check whether we've consumed over 25% of stack space, or something
> > like that, and if so, directly punt the request.
>
> Right, it'll increase the stack usage. Not against adding some safe
> guard that punts if we're too deep in, though I'd have to look how to
> even do that... Looks like stack_not_used(), though it's not clear to me
> how efficient that is?

No, I don't think you want to do that... at least on X86-64, I think
something vaguely like this should do the job:

unsigned long cur_stack = (unsigned long)__builtin_frame_address(0);
unsigned long begin = (unsigned long)task_stack_page(task);
unsigned long end   = (unsigned long)task_stack_page(task) + THREAD_SIZE;
if (cur_stack < begin || cur_stack >= end || cur_stack < begin +
THREAD_SIZE*3/4)
  [bailout]

But since stacks grow in different directions depending on the
architecture and so on, it might have to be an arch-specific thing...
I'm not sure.

> > Also, can we recursively hit this point? Even if __io_queue_sqe()
> > doesn't *want* to block, the code it calls into might still block on a
> > mutex or something like that, at which point the mutex code would call
> > into schedule(), which would then again hit sched_out_update() and get
> > here, right? As far as I can tell, this could cause unbounded
> > recursion.
>
> The sched_work items are pruned before being run, so that can't happen.

And is it impossible for new ones to be added in the meantime if a
second poll operation completes in the background just when we're
entering __io_queue_sqe()?
