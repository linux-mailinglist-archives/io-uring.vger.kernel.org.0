Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 101A6166A9F
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 23:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbgBTW6n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 17:58:43 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:39315 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbgBTW6n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 17:58:43 -0500
Received: by mail-ot1-f66.google.com with SMTP id 77so313562oty.6
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 14:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XmpqTmH6msXy3QbaOupW8fPNhbYbkp3EODKW7zqB3YM=;
        b=YYuu9uOwAPcl9mT0YBGrVbbYwUK7cxBnrulVU7qwe1UjoQpT/v2X0Q6N5wIuLsf0tV
         QWSxxgqUvD810sukcz714DlT6ZmCv4gQP6GEBqaajuDOsZXYwPYku5ekpEJjFbDuPixZ
         WmLTzVwqhQ7OjN+zAthdCjlBKed8rG9vqHwBISXqnQpleTa2K4BrN7kIe+H+nwO9JEn9
         WPMOK+nCvI51c6gEhlyyTFIkhEcqd9zbaIxFCIkX/uaA7VHi+8XiNNNPjPF0g318AILj
         V+noR6NID+LsmPXasrfzfqrA0hn/ul+4/v04DOl/8LcMsXJETMDR0d9Q99KC3jWfYvYG
         hTDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XmpqTmH6msXy3QbaOupW8fPNhbYbkp3EODKW7zqB3YM=;
        b=GIe4/WcLpfMGj0ZaeawZGeGLIt0c0ZTU9bMnz4kdsd03HwBO1jA49BjZJR3K2/TYQc
         JphnoHkIdNbOGR3/7vdqhu2eH1/BzpejY23tX4edNxLARx1hWRjBNjZcLcBwbI+tgNIX
         5sLHJe6jW4cKleBhROP7zAJIgHeFujaIhqhoFigeyrbaBL20RRMycMGl5zTTYbKpCXyA
         JBumGQAJV2ZAhZn4XBZ3QptQMspMrkYWnjL9sr3ZYZgihSin64/s3UAdsbvkLI7ravzl
         nz6lSwmhwUQ17t8vGNFBBedpv7FvuxUuvzumAZ0DVcL/+pw0nfzw1HaXKvD1q19uobqV
         vYSw==
X-Gm-Message-State: APjAAAXcJbYtdyxVp9Uk19z0p2PNFyVH6pCf2gBARNiVxjzktdXa2I+Q
        HgBBV+JEvRhd7KYYxQTNxlWr8hmP4DmDUlBx7d1hbw==
X-Google-Smtp-Source: APXvYqyoZLGwq2YZrdlhA2Lsl74wJO9hJ+vgEs84zkh9+mwavBdN5lToKnFvwiNs+9uej/uKAcSiwlPdhsYZpqLE1t8=
X-Received: by 2002:a9d:5e8b:: with SMTP id f11mr12022061otl.110.1582239522032;
 Thu, 20 Feb 2020 14:58:42 -0800 (PST)
MIME-Version: 1.0
References: <20200220203151.18709-1-axboe@kernel.dk> <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
 <b78cd45a-9e6f-04ec-d096-d6e1f6cec8bd@kernel.dk> <67a62039-0cb0-b5b2-d7f8-fade901c59f4@kernel.dk>
 <CAG48ez3R3DWLry_aRAt47BQ05Y4Mr9yVXq49yuiRGNoyRMr3Lg@mail.gmail.com> <1658b860-6419-fac9-8ec3-b2d91d74b293@kernel.dk>
In-Reply-To: <1658b860-6419-fac9-8ec3-b2d91d74b293@kernel.dk>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 20 Feb 2020 23:58:15 +0100
Message-ID: <CAG48ez3jS0VbeaW2VYBoGBKHDzkYaR-f_wA69TPFrWdz9iwmdA@mail.gmail.com>
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

On Thu, Feb 20, 2020 at 11:56 PM Jens Axboe <axboe@kernel.dk> wrote:
> On 2/20/20 3:38 PM, Jann Horn wrote:
> > On Thu, Feb 20, 2020 at 11:23 PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 2/20/20 3:14 PM, Jens Axboe wrote:
> >>>>> @@ -3646,46 +3596,11 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
> >>>>>
> >>>>>         list_del_init(&poll->wait.entry);
> >>>>>
> >>>> [...]
> >>>>> +       tsk = req->task;
> >>>>> +       req->result = mask;
> >>>>> +       init_task_work(&req->sched_work, io_poll_task_func);
> >>>>> +       sched_work_add(tsk, &req->sched_work);
> >>>>
> >>>> Doesn't this have to check the return value?
> >>>
> >>> Trying to think if we can get here with TASK_EXITING, but probably safer
> >>> to just handle it in any case. I'll add that.
> >>
> >> Double checked this one, and I think it's good as-is, but needs a
> >> comment. If the sched_work_add() fails, then the work item is still in
> >> the poll hash on the ctx. That work is canceled on exit.
> >
> > You mean via io_poll_remove_all()? That doesn't happen when a thread
> > dies, right?
>
> Off of io_uring_flush, we do:
>
> if (fatal_signal_pending(current) || (current->flags & PF_EXITING)) {
>         io_uring_cancel_task_poll(current);
>         io_uring_cancel_task_async(current);
>         io_wq_cancel_pid(ctx->io_wq, task_pid_vnr(current));
> }
>
> to cancel _anything_ that the task has pending.

->flush() is only for when the uring instance is dropped from a file
descriptor table; threads typically share their file descriptor
tables, and therefore won't ->flush() until the last one dies.
