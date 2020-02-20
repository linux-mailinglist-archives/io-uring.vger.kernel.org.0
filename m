Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8DCB166A9D
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 23:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729335AbgBTW4x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 17:56:53 -0500
Received: from mail-ot1-f66.google.com ([209.85.210.66]:33466 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729130AbgBTW4x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 17:56:53 -0500
Received: by mail-ot1-f66.google.com with SMTP id w6so343619otk.0
        for <io-uring@vger.kernel.org>; Thu, 20 Feb 2020 14:56:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=udSQjP2zpwW8wxEC0irpv/d6oryvIHJArzGHSkq96iI=;
        b=uVlNQ1fz7UWoZ1ATyjCqSY/9lM/7DW1CW4+8C1vKzY15n4pUzm70/Dyb/8RnDJx2fW
         Yee8Vd0BjzVl6vpQfWl/bONKYxAl78dQib2L/ONd64FddXzyrk66epiFZrwuI8VthFn9
         WaNoDzWnTrkpwGvD54jvzDmjGgeCvf38bQ0USawNRntw3iv2bUZh8hyKlUzhEqlICFi9
         damReOcDkk33ncsQPeh+Sbl/faGLN/vI6+u4OqMTjiEWjvoUXexkGavouuj610ploEf8
         w1b7/GmMbJKJw0xXlhpLBTa8P93v1N+DSyOFDXyjeFG88n+25EzfQMtb3AXh3TotT83L
         r9qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=udSQjP2zpwW8wxEC0irpv/d6oryvIHJArzGHSkq96iI=;
        b=ofBN3QEyl4cDU/6g613lJE63+iXN66e1EbdgP7qQaWCUltgn26u5fNOIro+MAE7nhY
         ccDL2iaQmwk2zYzMW89PbbSJ/UkYPlM9PaejWOjGDrBA4P1Ajjvjhs0GwVBVjA95NKZ5
         GKvx+1V1/gtwxUfaRYnwAkPPJpIzuAvpS/fK3uKQHl0aEfg0VXHOTNdbPqvxNwxK7bmo
         ely4TQBBSu759EFbbT0HJ7Akq0lRJ//SgfYhJZLpZFRTyxCzxlEUS2Ssnu1HGeGcvBNY
         eyBVt9Zad4Lo7jMdBR8coUH68CQxykuYvZOvlltYMixvMylVFmmVj5g4dBOrKsPDb7d2
         dhAA==
X-Gm-Message-State: APjAAAU8hHuSD6tD/yXQN6yRGq4bM7z90dgvuu7Kwz1WQGa1nyKVuIqG
        XcqusNOSGxzHmFCmBKpfASLrwYQgHjSb52/quw1uLg==
X-Google-Smtp-Source: APXvYqyHKsOIkUFNrGwpc/MokogAnUCbBL4xNCyhPZZzIrsYvArJWa+mAdbgkVVi40PcViNKAAPFlo36SwSDTKqHxLg=
X-Received: by 2002:a05:6830:1219:: with SMTP id r25mr1210786otp.180.1582239412050;
 Thu, 20 Feb 2020 14:56:52 -0800 (PST)
MIME-Version: 1.0
References: <20200220203151.18709-1-axboe@kernel.dk> <20200220203151.18709-8-axboe@kernel.dk>
 <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
In-Reply-To: <CAG48ez1sQi7ntGnLxyo9X_642-wr55+Kn662XyyEYGLyi0iLwQ@mail.gmail.com>
From:   Jann Horn <jannh@google.com>
Date:   Thu, 20 Feb 2020 23:56:25 +0100
Message-ID: <CAG48ez3d-HD2_tC+kUwS4ch4ifd=ota27J_2wZ7ovGFT5R7Hnw@mail.gmail.com>
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

On Thu, Feb 20, 2020 at 11:02 PM Jann Horn <jannh@google.com> wrote:
> On Thu, Feb 20, 2020 at 9:32 PM Jens Axboe <axboe@kernel.dk> wrote:
> >
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
> > -static void io_poll_trigger_evfd(struct io_wq_work **workptr)
> > +static void io_poll_task_func(struct callback_head *cb)
> >  {
> > -       struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
> > +       struct io_kiocb *req = container_of(cb, struct io_kiocb, sched_work);
> > +       struct io_kiocb *nxt = NULL;
> >
> [...]
> > +       io_poll_task_handler(req, &nxt);
> > +       if (nxt)
> > +               __io_queue_sqe(nxt, NULL);
>
> This can now get here from anywhere that calls schedule(), right?
> Which means that this might almost double the required kernel stack
> size, if one codepath exists that calls schedule() while near the
> bottom of the stack and another codepath exists that goes from here
> through the VFS and again uses a big amount of stack space?

Oh, I think this also implies that any mutex reachable via any of the
nonblocking uring ops nests inside any mutex under which we happen to
schedule(), right? I wonder whether that's going to cause deadlocks...

For example, FUSE's ->read_iter() can call fuse_direct_io(), which can
call inode_lock() and then call fuse_sync_writes() under the inode
lock, which can wait_event(), which can schedule(); and if uring then
from schedule() calls ->read_iter() again, you could reach
inode_lock() on the same inode again, causing a deadlock, I think?
