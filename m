Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A4D23F262
	for <lists+io-uring@lfdr.de>; Fri,  7 Aug 2020 20:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHGSBU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 Aug 2020 14:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726015AbgHGSBT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 Aug 2020 14:01:19 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E97C061756
        for <io-uring@vger.kernel.org>; Fri,  7 Aug 2020 11:01:19 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id k13so1445462lfo.0
        for <io-uring@vger.kernel.org>; Fri, 07 Aug 2020 11:01:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JTic4giSZGUWWZNg/+8f50l+AfTbn0l73GhMPTAVdTs=;
        b=M5PCwwxjR6KXd8bob9IydE2xQMl3voZ6v6TwUviitlUXWuB3m0nX4HcpqySL5ifK7V
         o5iXadWtNJIjgD2F4St29eDLESeGKCn1Vn0/eK+xo5ZV9IEYl1WshOmlU6kVB1JszKbm
         GrnJTbH/Ra6ZqVplbR/b/WNxEUDbP2Scv1jMq+yhd+6Nqu0S+9y8RFRjz30DITq+lV2u
         TkdDqqwdG13SyFmN0pEAafOZ3oOkIbl9t/SnwKu4PAp3ywJQcbyDj6dPiUskVNxcca5q
         Ax3JmT2mwFMQ5g5qgcxZYlsEB7UphgVNWbLhzhCaMmPmSIjXPyDgQOZGS20rpRvmcrHr
         uOTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=JTic4giSZGUWWZNg/+8f50l+AfTbn0l73GhMPTAVdTs=;
        b=uVWn0GCAlZ6AILcijqjHTIw9dVn/uucipwjy7n4avdWVh3yomHtbVTGiKNMqo3ILps
         RM6nZXmpsykE+JzFAdXT4Vn/UBaX5qhL7HzjUZlPSHZb+q6rj5SgrkfFgNFZ3A4yr+ji
         dYSUik/cKu2RENPCte3cjkn5/Y3x5KWZ75+Q7BXYUeb+unQbjGSbNILtdx6gxx0Mnt2Y
         /l1n+bTkzi0vsmn377ek4606ZZDxL/mGwNsH5g1QpyHW0FoBT1eJAkYURye439TBkwLI
         l5V251HqiHUaPZcAJQKMYgvYNaPXrN3vuyZojTJHDqIy+xbxUCArk051dSse8cZmWsPk
         zohw==
X-Gm-Message-State: AOAM530ypylRW5P57X4KNEV0BI4VrGmQf6kycejfIDTtY/ahwQ3E8TWb
        +j/+7pKSoamcK0B4RxjDaonfTAnkQ2WIKAtlgy+1JKlL
X-Google-Smtp-Source: ABdhPJzAFYUYN3KheoP21jlZp2hNkuCrMYJpcd9N8bz2QG75ukfOx0er9N6IwEJcmQO4GAonInBV9MbxXLaeuEGgCH4=
X-Received: by 2002:ac2:5383:: with SMTP id g3mr6725765lfh.45.1596823277619;
 Fri, 07 Aug 2020 11:01:17 -0700 (PDT)
MIME-Version: 1.0
References: <ba5b8ee4-2c6f-dec7-97f2-d02c8b3fe3f8@kernel.dk>
In-Reply-To: <ba5b8ee4-2c6f-dec7-97f2-d02c8b3fe3f8@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Fri, 7 Aug 2020 20:00:51 +0200
Message-ID: <CAG48ez3dX8aK2m918fxAZGaOf5h9QV6X+Z5LMzJV2yZO8+bsvg@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Aug 7, 2020 at 6:56 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> An earlier commit:
>
> b7db41c9e03b ("io_uring: fix regression with always ignoring signals in io_cqring_wait()")
>
> ensured that we didn't get stuck waiting for eventfd reads when it's
> registered with the io_uring ring for event notification, but we still
> have a gap where the task can be waiting on other events in the kernel
> and need a bigger nudge to make forward progress.
>
> Ensure that we use signaled notifications for a task that isn't currently
> running, to be certain the work is seen and processed immediately.
>
> Cc: stable@vger.kernel.org # v5.7+
> Reported-by: Josef <josef.grieb@gmail.com>
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>
> ---
>
> This isn't perfect, as it'll use TWA_SIGNAL even for cases where we
> don't absolutely need it (like task waiting for completions in
> io_cqring_wait()), but we don't have a good way to tell right now. We
> can probably improve on this in the future, for now I think this is the
> best solution.
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index e9b27cdaa735..b4300a61f231 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -1720,7 +1720,7 @@ static int io_req_task_work_add(struct io_kiocb *req, struct callback_head *cb)
>          */
>         if (ctx->flags & IORING_SETUP_SQPOLL)
>                 notify = 0;
> -       else if (ctx->cq_ev_fd)
> +       else if (ctx->cq_ev_fd || (tsk->state != TASK_RUNNING))
>                 notify = TWA_SIGNAL;
>
>         ret = task_work_add(tsk, cb, notify);

I don't get it. Apart from still not understanding the big picture:

What guarantees that the lockless read of tsk->state is in any way
related to the state of the remote process by the time we reach
task_work_add()? And why do we not need to signal in TASK_RUNNING
state (e.g. directly before the remote process switches to
TASK_INTERRUPTIBLE or something like that)?

Even if this is correct, it would still be nice if you could add a big
comment that explains the precise semantics this is attempting to
provide. As far as I understand so far, the goal is to trigger -EINTR
returns from certain syscalls, or something like that? But I don't
understand whether that's indeed what's going on, or which syscalls
precisely this is attempting to make return -EINTR.

(Also, lockless reads of concurrently changing variables should be
written with READ_ONCE().)
