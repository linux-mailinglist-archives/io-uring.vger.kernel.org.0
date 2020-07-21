Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6E12287B1
	for <lists+io-uring@lfdr.de>; Tue, 21 Jul 2020 19:44:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728147AbgGURoV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jul 2020 13:44:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:34726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbgGURoU (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 21 Jul 2020 13:44:20 -0400
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8052422BEF
        for <io-uring@vger.kernel.org>; Tue, 21 Jul 2020 17:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595353459;
        bh=gYTjerPTWBvpkmXJUEmFBruEPYyHY4CF/NS96p+Wb7M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=PleDaNYGo1smV+pCthyI/QWptt1yZVIBTtSkgWIiDfM8HeUn7OYOxsssqU4y3ZDEV
         HZfVcvjzM0pJOhr4pa9zZ9OOJJwwT76i/Y3qIwx7lWHXX1q/ius9er4RI1Pv1jq7Fg
         VBEK+pjhZCxweqT4ixFqP/SQa5eVUK1f43MA40js=
Received: by mail-wm1-f51.google.com with SMTP id 9so254602wmj.5
        for <io-uring@vger.kernel.org>; Tue, 21 Jul 2020 10:44:19 -0700 (PDT)
X-Gm-Message-State: AOAM533dqNVKA+OO2UicUbB1AMZCvDqRS5bc1712fNIgiXieMHHNg7nj
        +r1J2tRRYLpsgm2Ye5gZrxmZEIXlwmg0WUH5Y0B08A==
X-Google-Smtp-Source: ABdhPJzSQXCla1i91gwY9Qh3+Y68Zb9GDpPH8iLV1F2Pg9CpACcpFlI0Frb/clH/rRMHVn/nECoXMbwElZOZ/5GE7B8=
X-Received: by 2002:a7b:c09a:: with SMTP id r26mr4941339wmh.176.1595353458123;
 Tue, 21 Jul 2020 10:44:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegu3EwbBFTSJiPhm7eMyTK2MzijLUp1gcboOo3meMF_+Qg@mail.gmail.com>
 <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net> <20200715171130.GG12769@casper.infradead.org>
 <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com> <CAJfpegt9=p4uo5U2GXqc-rwqOESzZCWAkGMRTY1r8H6fuXx96g@mail.gmail.com>
 <48cc7eea-5b28-a584-a66c-4eed3fac5e76@gmail.com> <202007151511.2AA7718@keescook>
 <20200716131404.bnzsaarooumrp3kx@steredhat> <202007160751.ED56C55@keescook>
 <20200717080157.ezxapv7pscbqykhl@steredhat.lan> <CALCETrXSPdiVCgh3h=q7w9RyiKnp-=8jOHoFHX=an0cWqK7bzQ@mail.gmail.com>
 <39a3378a-f8f3-6706-98c8-be7017e64ddb@kernel.dk> <CALCETrXAxFzuRB5EJZR7bbgfrEcNc=9_E7wwhPaZ3YGJ1=DZ0w@mail.gmail.com>
 <ba989463-c627-8af7-9234-4dc8ac4eea0e@kernel.dk>
In-Reply-To: <ba989463-c627-8af7-9234-4dc8ac4eea0e@kernel.dk>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 21 Jul 2020 10:44:06 -0700
X-Gmail-Original-Message-ID: <CALCETrUvOuKZWiQeZhf9DXyjS4OQdyW+s1YMh+vwe605jBS3LQ@mail.gmail.com>
Message-ID: <CALCETrUvOuKZWiQeZhf9DXyjS4OQdyW+s1YMh+vwe605jBS3LQ@mail.gmail.com>
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

On Tue, Jul 21, 2020 at 10:30 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/21/20 11:23 AM, Andy Lutomirski wrote:
> > On Tue, Jul 21, 2020 at 8:31 AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 7/21/20 9:27 AM, Andy Lutomirski wrote:
> >>> On Fri, Jul 17, 2020 at 1:02 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >>>>
> >>>> On Thu, Jul 16, 2020 at 08:12:35AM -0700, Kees Cook wrote:
> >>>>> On Thu, Jul 16, 2020 at 03:14:04PM +0200, Stefano Garzarella wrote:
> >>>
> >>>>> access (IIUC) is possible without actually calling any of the io_uring
> >>>>> syscalls. Is that correct? A process would receive an fd (via SCM_RIGHTS,
> >>>>> pidfd_getfd, or soon seccomp addfd), and then call mmap() on it to gain
> >>>>> access to the SQ and CQ, and off it goes? (The only glitch I see is
> >>>>> waking up the worker thread?)
> >>>>
> >>>> It is true only if the io_uring istance is created with SQPOLL flag (not the
> >>>> default behaviour and it requires CAP_SYS_ADMIN). In this case the
> >>>> kthread is created and you can also set an higher idle time for it, so
> >>>> also the waking up syscall can be avoided.
> >>>
> >>> I stared at the io_uring code for a while, and I'm wondering if we're
> >>> approaching this the wrong way. It seems to me that most of the
> >>> complications here come from the fact that io_uring SQEs don't clearly
> >>> belong to any particular security principle.  (We have struct creds,
> >>> but we don't really have a task or mm.)  But I'm also not convinced
> >>> that io_uring actually supports cross-mm submission except by accident
> >>> -- as it stands, unless a user is very careful to only submit SQEs
> >>> that don't use user pointers, the results will be unpredictable.
> >>
> >> How so?
> >
> > Unless I've missed something, either current->mm or sqo_mm will be
> > used depending on which thread ends up doing the IO.  (And there might
> > be similar issues with threads.)  Having the user memory references
> > end up somewhere that is an implementation detail seems suboptimal.
>
> current->mm is always used from the entering task - obviously if done
> synchronously, but also if it needs to go async. The only exception is a
> setup with SQPOLL, in which case ctx->sqo_mm is the task that set up the
> ring. SQPOLL requires root privileges to setup, and there's no task
> entering the io_uring at all necessarily. It'll just submit sqes with
> the credentials that are registered with the ring.

Really?  I admit I haven't fully followed how the code works, but it
looks like anything that goes through the io_queue_async_work() path
will use sqo_mm, and can't most requests that end up blocking end up
there?  It looks like, even if SQPOLL is not set, the mm used will
depend on whether the request ends up blocking and thus getting queued
for later completion.

Or does some magic I missed make this a nonissue.


>
> This is just one known use case, there may very well be others. Outside
> of SQPOLL, which is special, I don't see a reason to restrict this.
> Given that you may have a fuller understanding of it after the above
> explanation, please clearly state what problem you're seeing that
> warrants a change.

I see two fundamental issues:

1. The above.  This may be less of an issue than it seems to me, but,
if you submit io from outside sqo_mm, the mm that ends up being used
depends on whether the IO is completed from io_uring_enter() or from
the workqueue.  For something like Postgres, I guess this is okay
because the memory is MAP_ANONYMOUS | MAP_SHARED and the pointers all
point the same place regardless.

2. If you create an io_uring and io_uring_enter() it from a different
mm, it's unclear what seccomp is supposed to do.  (Or audit, for that
matter.)  Which task did the IO?  Which mm did the IO?  Whose sandbox
is supposed to be applied?

--Andy
