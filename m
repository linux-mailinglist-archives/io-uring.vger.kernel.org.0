Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21962DFB2C
	for <lists+io-uring@lfdr.de>; Mon, 21 Dec 2020 11:51:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725802AbgLUKux (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Dec 2020 05:50:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725791AbgLUKux (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Dec 2020 05:50:53 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D39C0613D6
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 02:49:58 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id n9so8500874ili.0
        for <io-uring@vger.kernel.org>; Mon, 21 Dec 2020 02:49:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kGOJMd5x/n9/ltNxQzvq2lCLBkuywn9El+1Yg/iP7Ac=;
        b=lCHhNZZVIciIKchJnof8atJlUv10BQMXb9T6elfaeRGqCKgMGS3cj7N3WwIssbX7XF
         QRHcgbD9zF+Bx8MeQHr5qZxZIt4xUs9q+5RQMQBycGKd0+NbsxmApDhp0BNrsL+GWLzv
         0yQBKoCegKJyWoIlUdnFR8ix+WTjcSqdYLu696afFPRT7dUMK/zHzTYej78hMr6ZugvG
         Owanqp/fJb4nLjJwF4dIEkfiIOL6B2NMXAxsY72Sx0BOm28UsX47voKvUosElVyUiTVK
         P2V3afgmJ1nAQw/aIz3/WAvdUkkCswc1LaR4s5S7BDtjv3Dn+vBpoKoM+hOb5Ny1887w
         Z0VQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kGOJMd5x/n9/ltNxQzvq2lCLBkuywn9El+1Yg/iP7Ac=;
        b=XGTMp6bK2b+VhenhiaZBdstgjAGVLrXTf6uHrsMZ1zWf0UsE5eYLVJdoAdHaqM8/cR
         vOprU6I9eZJEUm6HXD1s2QG1Ex3waemHAc3O2PKohXX9M+xIW+3rY5L5fDzdL43risZ0
         mx9ES/ED2bMpl8l+ZCWbPJwNlFs3CfdKlggKI58Xqt2fbolNZOCUL2TtRnx7AcZ4ql4z
         FhDzmGtiADC+RhQC4td/acJv5k33Y1CA09CbcuWyIPjSS64SQd+g9HflJIJbsOCIFGmi
         oVnF7qq6scxvy/gVnLWi+S7VbBt1nJLeBc/9u8u0XAIJlkJmT7X6K2KLAQW5DYfggAKf
         atsQ==
X-Gm-Message-State: AOAM530pV9bMCw5//QXZGuR1cKiUKJDwsVJ5/EY0/tUBh6Zb3LMyaZIX
        qpQ9NcrR5nxXDg9afEEqMxJkMZ/VLRmfy2CQWxY=
X-Google-Smtp-Source: ABdhPJybqTe9NlseTA+vPRmwMDLDlp8sN48OC5U2KCIJ7C8biYMXXuw7/9Qk9M1ePCPHutufV9KakM3Qn2md4r3zdOs=
X-Received: by 2002:a05:6e02:c2a:: with SMTP id q10mr15541202ilg.92.1608547798067;
 Mon, 21 Dec 2020 02:49:58 -0800 (PST)
MIME-Version: 1.0
References: <4dc9c74b-249d-117c-debf-4bb9e0df2988@kernel.dk>
 <2B352D6C-4CA2-4B09-8751-D7BB8159072D@googlemail.com> <d9205a43-ebd7-9412-afc6-71fdcf517a32@kernel.dk>
 <CAAss7+ps4xC785yMjXC6u8NiH9PCCQQoPiH+AhZT7nMX7Q_uEw@mail.gmail.com>
 <0fe708e2-086b-94a8-def4-e4ebd6e0b709@kernel.dk> <614f8422-3e0e-25b9-4cc2-4f1c07705ab0@kernel.dk>
 <986c85af-bb77-60d4-8739-49b662554157@gmail.com> <e88403ad-e272-2028-4d7a-789086e12d8b@kernel.dk>
 <2e968c77-912d-6ae1-7000-5e34eb978ab5@gmail.com> <CAOKbgA5YD_MxY-RqJzP7eqdkqrnQCgjRin7w29QtszHaCJqwrg@mail.gmail.com>
In-Reply-To: <CAOKbgA5YD_MxY-RqJzP7eqdkqrnQCgjRin7w29QtszHaCJqwrg@mail.gmail.com>
From:   Dmitry Kadashev <dkadashev@gmail.com>
Date:   Mon, 21 Dec 2020 17:49:47 +0700
Message-ID: <CAOKbgA4jEKPh7tiqJRdVB6VD=PN=A7m7rPiCp=hgA4xd_X_mGw@mail.gmail.com>
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

Actually, I'm wrong about the locks part, forgot how it works. In our case it
works like this: a parent thread creates a ring, and passes it to a worker
thread, which does all of the work with it, no locks are involved. On
(clean) termination the parent notifies the worker, waits for it to exit and
then calls io_uring_queue_exit. Not sure if that counts as sharing rings between
the threads or not.

As I've mentioned in some other email, I'll try (again) to make a reproducer.

-- 
Dmitry Kadashev
