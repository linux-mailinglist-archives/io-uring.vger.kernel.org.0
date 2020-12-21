Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BC052DFB4A
	for <lists+io-uring@lfdr.de>; Mon, 21 Dec 2020 12:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbgLULBG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 06:01:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725811AbgLULBG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 06:01:06 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7108C0613D3
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 03:00:25 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id q5so8466495ilc.10
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 03:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MzciD2bLHH65SXb1PYkUX+gCwpRg5mT3Ug5iG15yiNM=;
        b=Be5VjV2oeGOl4EfPWuVr++SJ6c7Xs/+suZyfRywcm/wujEACtbBjlYsmRee4u2f3UV
         BSx8bgkVjxSyKNAhfgpBQd/HuTf8+84uSkFhH8EKY3+ckFujODlnt1Is4RX/eMVpeptT
         tfh5K9HYuqqRg5CNi834EUdP+8sf8lV41HpZlFqVNjCFbDY5Sx4gu4I9qF+VcUeqGCVa
         8xjBJ+aCE23sgzmPqhI7ANcsu1LgV0i2KirT876ACZiL7CgAy+7q+6/js6a2xyDAH1k0
         LnoL/15HeXZxGHOyBja9u+SdCWnJz57OuFMZjFo2oCa5nGZ34uC9HqPdH+t6cficQXuk
         e5VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MzciD2bLHH65SXb1PYkUX+gCwpRg5mT3Ug5iG15yiNM=;
        b=ApaMHPPal7TDYQUbZU4Uu5H9uEc4kTeWRSnNjRrmf7eOrGDTJcx0N+iUFofI6oriB+
         pcfDuZGEHYhE/vuosy5LSXp3tkA26uUidq40mO7df9QFHAiGAaWb08VE3uuEWe5eIwSI
         97cxiXcxD/x/pct+hL+iUmnB0WxP89rFANGJMpIhlSssVcFlrguKjwu/Q5Z7jzQ0l4uy
         /Ws3VFMam+NqdOsXgwJIBYlxsNTBroR/8EXBNOunuf961mwwz37ypuQ6ozShPSfc4MI7
         xsjIc+icBBNF3NtxcTNTc6qdqZusMlPg7n14U7eU/7MK74SbDnPY74nUONt/oCuE2w2v
         3pSw==
X-Gm-Message-State: AOAM530JjhosEQ0guVGjDDoRxLfBTz3nrJFNBesmZdqVn3fNOdz8Q2Gy
        PUY915DHASR3Q9u2UcgcCUKWIUp8F/DcCHJ8U77v99aj5wGEYw==
X-Google-Smtp-Source: ABdhPJxEfo7DwWdjstFcBO4WdzMiNUfeUowCpxRqJAFHLl9TOZbWlXwumAsYbJ5T5OHWtIz4WIVCQ88jROGOSrkP81w=
X-Received: by 2002:a92:9881:: with SMTP id a1mr16097893ill.238.1608548425071;
 Mon, 21 Dec 2020 03:00:25 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk> <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com> <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <2e968c77-912d-6ae1-7000-5e34eb978ab5@gmail.com> <CAOKbgA5YD_MxY-RqJzP7eqdkqrnQCgjRin7w29QtszHaCJqwrg@mail.gmail.com>
In-Reply-To: <CAOKbgA5YD_MxY-RqJzP7eqdkqrnQCgjRin7w29QtszHaCJqwrg@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Mon, 21 Dec 2020 18:00:14 +0700
Message-ID: <CAOKbgA7TyscndB7nn409NsFfoJriipHG80fgh=7SRESbiguNAg@mail.gmail.com>
Subject: Re: "Cannot allocate memory" on ring creation (not RLIMIT_MEMLOCK)
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Josef <josef.grieb@gmail.com>,
        Norman Maurer <norman.maurer@googlemail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Dec 21, 2020 at 5:35 PM Dmitry Kadashev <dkadashev@gmail.com> wrote:
>
> On Sun, Dec 20, 2020 at 7:59 AM Pavel Begunkov <asml.silence@gmail.com> wrote:
> >
> > On 20/12/2020 00:25, Jens Axboe wrote:
> > > On 12/19/20 4:42 PM, Pavel Begunkov wrote:
> > >> On 19/12/2020 23:13, Jens Axboe wrote:
> > >>> On 12/19/20 2:54 PM, Jens Axboe wrote:
> > >>>> On 12/19/20 1:51 PM, Josef wrote:
> > >>>>>> And even more so, it's IOSQE_ASYNC on the IORING_OP_READ on an eventfd
> > >>>>>> file descriptor. You probably don't want/mean to do that as it's
> > >>>>>> pollable, I guess it's done because you just set it on all reads for the
> > >>>>>> test?
> > >>>>>
> > >>>>> yes exactly, eventfd fd is blocking, so it actually makes no sense to
> > >>>>> use IOSQE_ASYNC
> > >>>>
> > >>>> Right, and it's pollable too.
> > >>>>
> > >>>>> I just tested eventfd without the IOSQE_ASYNC flag, it seems to work
> > >>>>> in my tests, thanks a lot :)
> > >>>>>
> > >>>>>> In any case, it should of course work. This is the leftover trace when
> > >>>>>> we should be exiting, but an io-wq worker is still trying to get data
> > >>>>>> from the eventfd:
> > >>>>>
> > >>>>> interesting, btw what kind of tool do you use for kernel debugging?
> > >>>>
> > >>>> Just poking at it and thinking about it, no hidden magic I'm afraid...
> > >>>
> > >>> Josef, can you try with this added? Looks bigger than it is, most of it
> > >>> is just moving one function below another.
> > >>
> > >> Hmm, which kernel revision are you poking? Seems it doesn't match
> > >> io_uring-5.10, and for 5.11 io_uring_cancel_files() is never called with
> > >> NULL files.
> > >>
> > >> if (!files)
> > >>      __io_uring_cancel_task_requests(ctx, task);
> > >> else
> > >>      io_uring_cancel_files(ctx, task, files);
> > >
> > > Yeah, I think I messed up. If files == NULL, then the task is going away.
> > > So we should cancel all requests that match 'task', not just ones that
> > > match task && files.
> > >
> > > Not sure I have much more time to look into this before next week, but
> > > something like that.
> > >
> > > The problem case is the async worker being queued, long before the task
> > > is killed and the contexts go away. But from exit_files(), we're only
> > > concerned with canceling if we have inflight. Doesn't look right to me.
> >
> > In theory all that should be killed in io_ring_ctx_wait_and_kill(),
> > of course that's if the ring itself is closed.
> >
> > Guys, do you share rings between processes? Explicitly like sending
> > io_uring fd over a socket, or implicitly e.g. sharing fd tables
> > (threads), or cloning with copying fd tables (and so taking a ref
> > to a ring).
>
> We do not share rings between processes. Our rings are accessible from different
> threads (under locks), but nothing fancy.
>
> > In other words, if you kill all your io_uring applications, does it
> > go back to normal?
>
> I'm pretty sure it does not, the only fix is to reboot the box. But I'll find an
> affected box and double check just in case.

So, I've just tried stopping everything that uses io-uring. No io_wq* processes
remained:

$ ps ax | grep wq
    9 ?        I<     0:00 [mm_percpu_wq]
  243 ?        I<     0:00 [tpm_dev_wq]
  246 ?        I<     0:00 [devfreq_wq]
27922 pts/4    S+     0:00 grep --colour=auto wq
$

But not a single ring (with size 1024) can be created afterwards anyway.

Apparently the problem netty hit and this one are different?

-- 
Dmitry Kadashev
