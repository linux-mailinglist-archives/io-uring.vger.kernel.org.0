Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B8FD9228969
	for <lists+io-uring@lfdr.de>; Tue, 21 Jul 2020 21:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730048AbgGUTob (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jul 2020 15:44:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730322AbgGUToX (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 21 Jul 2020 15:44:23 -0400
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D586022C9C
        for <io-uring@vger.kernel.org>; Tue, 21 Jul 2020 19:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595360663;
        bh=yPfilvL6mGVNKu4G5eZH+Fbv+tqaNwo2jtx+LBmp5J0=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KwzGcRpD0itKg0elf04EU6Oet5+2W9gZSnYnUHHJhY5sFC9BzbR/l8N+zNJvwL7G9
         1byOwK2vqVpBBB5i1ODabqUF2Xgcw3lEH2rSDuvBVprM6jujs+O5RoWzpFceFBVys3
         KhLyQgYB68npWx282EjdgNIISX/ODldTOEOO1fn8=
Received: by mail-wm1-f52.google.com with SMTP id o8so3944400wmh.4
        for <io-uring@vger.kernel.org>; Tue, 21 Jul 2020 12:44:22 -0700 (PDT)
X-Gm-Message-State: AOAM531D6VQxSGll9AJM2NHpNbcZt/fKpzgLHN9Lo9SdXR1/Yx1C+Y+H
        UrdGEsQ+BhQMFcfG2xLMKwLl+uSxpz8UMnRB62lotQ==
X-Google-Smtp-Source: ABdhPJw17BzEe5azYA+G4/JxAb6UdbQxxlTI739YKvoUcxWWDft8P6Wi1/wrS8f8s5b9/n3cemOCX6FTz80Rm9LPqxE=
X-Received: by 2002:a1c:e4d4:: with SMTP id b203mr5760719wmh.49.1595360661232;
 Tue, 21 Jul 2020 12:44:21 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegu3EwbBFTSJiPhm7eMyTK2MzijLUp1gcboOo3meMF_+Qg@mail.gmail.com>
 <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net> <20200715171130.GG12769@casper.infradead.org>
 <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com> <CAJfpegt9=p4uo5U2GXqc-rwqOESzZCWAkGMRTY1r8H6fuXx96g@mail.gmail.com>
 <48cc7eea-5b28-a584-a66c-4eed3fac5e76@gmail.com> <202007151511.2AA7718@keescook>
 <20200716131404.bnzsaarooumrp3kx@steredhat> <202007160751.ED56C55@keescook>
 <20200717080157.ezxapv7pscbqykhl@steredhat.lan> <CALCETrXSPdiVCgh3h=q7w9RyiKnp-=8jOHoFHX=an0cWqK7bzQ@mail.gmail.com>
 <39a3378a-f8f3-6706-98c8-be7017e64ddb@kernel.dk> <CALCETrXAxFzuRB5EJZR7bbgfrEcNc=9_E7wwhPaZ3YGJ1=DZ0w@mail.gmail.com>
 <ba989463-c627-8af7-9234-4dc8ac4eea0e@kernel.dk> <CALCETrUvOuKZWiQeZhf9DXyjS4OQdyW+s1YMh+vwe605jBS3LQ@mail.gmail.com>
 <65ad6c17-37d0-da30-4121-43554ad8f51f@kernel.dk>
In-Reply-To: <65ad6c17-37d0-da30-4121-43554ad8f51f@kernel.dk>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 21 Jul 2020 12:44:09 -0700
X-Gmail-Original-Message-ID: <CALCETrV_tOziNJOp8xanmCU0yJEHcGQk0TBxeiK4U7AVewkgAw@mail.gmail.com>
Message-ID: <CALCETrV_tOziNJOp8xanmCU0yJEHcGQk0TBxeiK4U7AVewkgAw@mail.gmail.com>
Subject: Re: strace of io_uring events?
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Andres Freund <andres@anarazel.de>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Kees Cook <keescook@chromium.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Matthew Wilcox <willy@infradead.org>,
        Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        strace-devel@lists.strace.io, io-uring@vger.kernel.org,
        Linux API <linux-api@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Jul 21, 2020 at 11:39 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/21/20 11:44 AM, Andy Lutomirski wrote:
> > On Tue, Jul 21, 2020 at 10:30 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 7/21/20 11:23 AM, Andy Lutomirski wrote:
> >>> On Tue, Jul 21, 2020 at 8:31 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>
> >>>> On 7/21/20 9:27 AM, Andy Lutomirski wrote:
> >>>>> On Fri, Jul 17, 2020 at 1:02 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >>>>>>
> >>>>>> On Thu, Jul 16, 2020 at 08:12:35AM -0700, Kees Cook wrote:
> >>>>>>> On Thu, Jul 16, 2020 at 03:14:04PM +0200, Stefano Garzarella wrote:
> >>>>>
> >>>>>>> access (IIUC) is possible without actually calling any of the io_uring
> >>>>>>> syscalls. Is that correct? A process would receive an fd (via SCM_RIGHTS,
> >>>>>>> pidfd_getfd, or soon seccomp addfd), and then call mmap() on it to gain
> >>>>>>> access to the SQ and CQ, and off it goes? (The only glitch I see is
> >>>>>>> waking up the worker thread?)
> >>>>>>
> >>>>>> It is true only if the io_uring istance is created with SQPOLL flag (not the
> >>>>>> default behaviour and it requires CAP_SYS_ADMIN). In this case the
> >>>>>> kthread is created and you can also set an higher idle time for it, so
> >>>>>> also the waking up syscall can be avoided.
> >>>>>
> >>>>> I stared at the io_uring code for a while, and I'm wondering if we're
> >>>>> approaching this the wrong way. It seems to me that most of the
> >>>>> complications here come from the fact that io_uring SQEs don't clearly
> >>>>> belong to any particular security principle.  (We have struct creds,
> >>>>> but we don't really have a task or mm.)  But I'm also not convinced
> >>>>> that io_uring actually supports cross-mm submission except by accident
> >>>>> -- as it stands, unless a user is very careful to only submit SQEs
> >>>>> that don't use user pointers, the results will be unpredictable.
> >>>>
> >>>> How so?
> >>>
> >>> Unless I've missed something, either current->mm or sqo_mm will be
> >>> used depending on which thread ends up doing the IO.  (And there might
> >>> be similar issues with threads.)  Having the user memory references
> >>> end up somewhere that is an implementation detail seems suboptimal.
> >>
> >> current->mm is always used from the entering task - obviously if done
> >> synchronously, but also if it needs to go async. The only exception is a
> >> setup with SQPOLL, in which case ctx->sqo_mm is the task that set up the
> >> ring. SQPOLL requires root privileges to setup, and there's no task
> >> entering the io_uring at all necessarily. It'll just submit sqes with
> >> the credentials that are registered with the ring.
> >
> > Really?  I admit I haven't fully followed how the code works, but it
> > looks like anything that goes through the io_queue_async_work() path
> > will use sqo_mm, and can't most requests that end up blocking end up
> > there?  It looks like, even if SQPOLL is not set, the mm used will
> > depend on whether the request ends up blocking and thus getting queued
> > for later completion.
> >
> > Or does some magic I missed make this a nonissue.
>
> No, you are wrong. The logic works as I described it.

Can you enlighten me?  I don't see any iov_iter_get_pages() calls or
equivalents.  If an IO is punted, how does the data end up in the
io_uring_enter() caller's mm?
