Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 681C8166A25
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 23:02:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727656AbgBTWCn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 17:02:43 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42739 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729145AbgBTWCn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 17:02:43 -0500
Received: by mail-oi1-f196.google.com with SMTP id j132so29177196oih.9
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 14:02:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NQQYbKsAMoEqt0hk/An/1yhAto/wHRFEPrHa2WN2CSo=;
        b=ToCOQIt8acVnbPaG2CW+SGkQZHSxWyBTdLtqDNo2HzFLI0cMix4soaRjmKnrooGrtb
         OtDOI6NWQfqIVLR/48YjMTA7XY1uPRQck9Qgn3ZgmlDW+8jtlABjwiAlPdSAUFapH3Nv
         /zdzGO7ZyWm3Ed4cRuTA0gAGc42qktmZ5UoIMYOxgdj4uN7iV+n5oYduZODQ84qooIzI
         dKDG8mcMqWdzfLOOyXKDkmsuT548eKYjuWo3UE/DxU1P3mz8ZyR0+VP3x1CAicEvPq5m
         nB+yvu0q/Xkue5NYARnm9XN1+OOtdAep+M1Rt3D82uAbFxJ048nCCPxwakiFlQmKOQAz
         iihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NQQYbKsAMoEqt0hk/An/1yhAto/wHRFEPrHa2WN2CSo=;
        b=ctVDkq5+wv6sAnsY+dm1DXx9zginqKvW2A3yfag1BXGgY9FN8c1/WMNXp8LgqGKqtr
         xfQkOxdPa7LxTzoclS/b1QP79WEXKnx2biW4FW7FRN5Y133vjf1es5J+A365OTdk9lxQ
         +bupxD/ho2HUCGUjUtLJJdCFuwVd27XJRwmdu8xyjXh4PtFK3x8wwYJoanukLUYfjOWm
         aTOl1MgkGnu1hGMTbpLoyYJdlrO3di28/4PueTkSiM7+D897eBqITv1XetrdWydcISKt
         QNtJOrjntxzagb+GbIBtNA+CpYJ3tHOdvSg2uaHcD8KbzLqCy9e2fRgIGhYJaALA6aGw
         /7HA==
X-Gm-Message-State: APjAAAUTbBNEiwjpecfcI81bEwobZ6bDjoaLrjgvU+5o27EoVCugz0NQ
        CcMiQyFimjb+KYAwsywCt5m/nYB8RKpDkYmk+GNUSQ==
X-Google-Smtp-Source: APXvYqz/Us4dDNrP0DPMHd2V8kjD3wBN8CXzVN2OcSsGjz2A8FVJYj6H/k1gR1QHp9ILalfqe1Jq9bjmEyJQPuvY0lg=
X-Received: by 2002:aca:d954:: with SMTP id q81mr3693243oig.157.1582236162290;
 Thu, 20 Feb 2020 14:02:42 -0800 (PST)
MIME-Version: 1.0
References: <20200220203151.18709-1-axboe@kernel.dk> <20200220203151.18709-8-axboe@kernel.dk>
In-Reply-To: <20200220203151.18709-8-axboe@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 20 Feb 2020 23:02:16 +0100
Message-ID: <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
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

On Thu, Feb 20, 2020 at 9:32 PM Jens Axboe <axboe@kernel.dk> wrote:
>
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
> -static void io_poll_trigger_evfd(struct io_wq_work **workptr)
> +static void io_poll_task_func(struct callback_head *cb)
>  {
> -       struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> +       struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
> +       struct io_kiocb *nxt = NULL;
>
[...]
> +       io_poll_task_handler(req, &nxt);
> +       if (nxt)
> +               __io_queue_sqe(nxt, NULL);

This can now get here from anywhere that calls schedule(), right?
Which means that this might almost double the required kernel stack
size, if one codepath exists that calls schedule() while near the
bottom of the stack and another codepath exists that goes from here
through the VFS and again uses a big amount of stack space? This is a
somewhat ugly suggestion, but I wonder whether it'd make sense to
check whether we've consumed over 25% of stack space, or something
like that, and if so, directly punt the request.

Also, can we recursively hit this point? Even if __io_queue_sqe()
doesn't *want* to block, the code it calls into might still block on a
mutex or something like that, at which point the mutex code would call
into schedule(), which would then again hit sched_out_update() and get
here, right? As far as I can tell, this could cause unbounded
recursion.

(On modern kernels with CONFIG_VMAP_STACK=y, running out of stack
space on a task stack is "just" a plain kernel oops instead of nasty
memory corruption, but we still should really try to avoid it.)

>  }
[...]
> @@ -3646,46 +3596,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
>
>         list_del_init(&poll->wait.entry);
>
[...]
> +       tsk = req->task;
> +       req->result = mask;
> +       init_task_work(&req->sched_work, io_poll_task_func);
> +       sched_work_add(tsk, &req->sched_work);

Doesn't this have to check the return value?

> +       wake_up_process(tsk);
>         return 1;
>  }
>
> @@ -3733,6 +3648,9 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
>
>         events = READ_ONCE(sqe->poll_events);
>         poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
> +
> +       /* task will wait for requests on exit, don't need a ref */
> +       req->task = current;

Can we get here in SQPOLL mode?

>         return 0;
>  }
