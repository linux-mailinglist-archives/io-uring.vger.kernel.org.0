Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 716962DFB19
	for <lists+io-uring@lfdr.de>; Mon, 21 Dec 2020 11:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgLUKhv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 05:37:51 -0500
Received: from mail-io1-f41.google.com ([209.85.166.41]:39292 "EHLO
        mail-io1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgLUKhu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 05:37:50 -0500
Received: by mail-io1-f41.google.com with SMTP id d9so8385662iob.6
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 02:37:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K5Q4F538T7DZkQKuRWRtD4FCwf99m4cVJPanCXJHEpg=;
        b=PrFJ//4lEFTanDidiwYYNOU4mVNYjpJpfOjv6mbUwd+BplfqXojEPh6IyeYQvKpipF
         YT9Z/vKW80WmBQWlXBnUqxnM0ZMNokvw007w5BeNJEfACo9q5KHPXdtOd29fN+V8b+tQ
         Za/Fxce/r/XjjdPweG+I8PVtWL9Ru6qcku98TfrnvQmjv2iDdRHcLseLkg++LXvr/Vnx
         MwfIqGak3X0PcFYhP/JLvOpNZyyYejva64JHlzeW6Vur0O0GCQMtO1990A+FV03y4WZQ
         1UA9LLXDJFWQQKp7aZzuuzB+poygj0vOM+xRrBtTdCjvxh+nOv2T0pAmHDr0ihTqrLT5
         29rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K5Q4F538T7DZkQKuRWRtD4FCwf99m4cVJPanCXJHEpg=;
        b=tbOYYnwNChHs/AFHTnwninth45QqnksujTJQlsZarslegGHTgf/Criw/5yBNU8sNR7
         myZMXANLffcsGutzQ/qDSV3w5IM9AdSRjm2krB7TXqB52pUFp64bA4J2zu6w8jbNfT0V
         6Xj/5SiE7fwJ0g0qMWcJyWBtqIl/2O96RIPJFsplOOHrL0o14NR2eT7kaZ+JTHT71gaN
         e0ZwiAlNH31oR/egVSyzS9myOq/M15ZhimQQaJSqTHIeDgenf8cDqW9C2SDBTh76leRU
         BoPqg4TmCe42Ab0L9O5Mu+a29rNFucfIQqVLEtmaMvI83SXcurEo/MV6gyRr1VdBb7Te
         rAFA==
X-Gm-Message-State: AOAM532wlvfve/Les8d6edWFyd+fPPlsbplbdxavaDlef8dgd7UGT5Mt
        QhVrumApisB1L6KUCy3rQNdjCyll3U8BRAmkXq/4W0PK2tf0vg==
X-Google-Smtp-Source: ABdhPJzEwhOcBHiSMHFonyrPkMiO1khA7JR8OzVn/l9b7D8VpX/FlZifeilKs8rL3qk6l1Me1IHQVjYAiKzrCQLbYu0=
X-Received: by 2002:a02:cd87:: with SMTP id l7mr14177366jap.117.1608546969564;
 Mon, 21 Dec 2020 02:36:09 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk> <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com> <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <2e968c77-912d-6ae1-7000-5e34eb978ab5@gmail.com>
In-Reply-To: <2e968c77-912d-6ae1-7000-5e34eb978ab5@gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Mon, 21 Dec 2020 17:35:59 +0700
Message-ID: <CAOKbgA5YD_MxY-RqJzP7eqdkqrnQCgjRin7w29QtszHaCJqwrg@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Dec 20, 2020 at 7:59 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 20/12/2020 00:25, Jens Axboe wrote:
> > On 12/19/20 4:42 PM, Pavel Begunkov wrote:
> >> On 19/12/2020 23:13, Jens Axboe wrote:
> >>> On 12/19/20 2:54 PM, Jens Axboe wrote:
> >>>> On 12/19/20 1:51 PM, Josef wrote:
> >>>>>> And even more so, it's IOSQE_ASYNC on the IORING_OP_READ on an eventfd
> >>>>>> file descriptor. You probably don't want/mean to do that as it's
> >>>>>> pollable, I guess it's done because you just set it on all reads for the
> >>>>>> test?
> >>>>>
> >>>>> yes exactly, eventfd fd is blocking, so it actually makes no sense to
> >>>>> use IOSQE_ASYNC
> >>>>
> >>>> Right, and it's pollable too.
> >>>>
> >>>>> I just tested eventfd without the IOSQE_ASYNC flag, it seems to work
> >>>>> in my tests, thanks a lot :)
> >>>>>
> >>>>>> In any case, it should of course work. This is the leftover trace when
> >>>>>> we should be exiting, but an io-wq worker is still trying to get data
> >>>>>> from the eventfd:
> >>>>>
> >>>>> interesting, btw what kind of tool do you use for kernel debugging?
> >>>>
> >>>> Just poking at it and thinking about it, no hidden magic I'm afraid...
> >>>
> >>> Josef, can you try with this added? Looks bigger than it is, most of it
> >>> is just moving one function below another.
> >>
> >> Hmm, which kernel revision are you poking? Seems it doesn't match
> >> io_uring-5.10, and for 5.11 io_uring_cancel_files() is never called with
> >> NULL files.
> >>
> >> if (!files)
> >>      __io_uring_cancel_task_requests(ctx, task);
> >> else
> >>      io_uring_cancel_files(ctx, task, files);
> >
> > Yeah, I think I messed up. If files == NULL, then the task is going away.
> > So we should cancel all requests that match 'task', not just ones that
> > match task && files.
> >
> > Not sure I have much more time to look into this before next week, but
> > something like that.
> >
> > The problem case is the async worker being queued, long before the task
> > is killed and the contexts go away. But from exit_files(), we're only
> > concerned with canceling if we have inflight. Doesn't look right to me.
>
> In theory all that should be killed in io_ring_ctx_wait_and_kill(),
> of course that's if the ring itself is closed.
>
> Guys, do you share rings between processes? Explicitly like sending
> io_uring fd over a socket, or implicitly e.g. sharing fd tables
> (threads), or cloning with copying fd tables (and so taking a ref
> to a ring).

We do not share rings between processes. Our rings are accessible from different
threads (under locks), but nothing fancy.

> In other words, if you kill all your io_uring applications, does it
> go back to normal?

I'm pretty sure it does not, the only fix is to reboot the box. But I'll find an
affected box and double check just in case.

-- 
Dmitry Kadashev
