Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 944B822873C
	for <lists+io-uring@lfdr.de>; Tue, 21 Jul 2020 19:23:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728775AbgGURXi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 21 Jul 2020 13:23:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:58574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726686AbgGURXh (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 21 Jul 2020 13:23:37 -0400
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6AB6D22C9C
        for <io-uring@vger.kernel.org>; Tue, 21 Jul 2020 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595352216;
        bh=o1VTqZy3PaEzLTyui6w9+v5TbCVASw3DdtRw6gu2BQI=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=jx74mrKpjkk5k6VOd5/kCwNOwwwf8wMs2cO4TwFtGtU593JDHKwoZZ/1yFW5DAFN3
         uEJ0ee60GMUeaOGQbp5HsrLOothM3N5kpM8hhMr4fCTVv0ji9CEdSwTHGrvG5u9zNM
         wAgsF02n2BBAlOUQUx+bQzZ5BSxQioXpjNbvHXsQ=
Received: by mail-wm1-f49.google.com with SMTP id q15so3599476wmj.2
        for <io-uring@vger.kernel.org>; Tue, 21 Jul 2020 10:23:36 -0700 (PDT)
X-Gm-Message-State: AOAM533R4x0cXipW5IpZtHSzWkLQvRx8SOa3TNk2XTYtZJ72C9DmNqIm
        SHGXQdcJ4ySQps29FflRoZwZIaX0033uTZj9nuKHXw==
X-Google-Smtp-Source: ABdhPJzs1pDydQd6AZNlTZP3zjRd99wsz0+yuH5F2e/lKdxi00sm+gxIPnvmITsfDDUdOGt0aPUsimQLPfiyTKcw794=
X-Received: by 2002:a1c:56c3:: with SMTP id k186mr3860162wmb.21.1595352214965;
 Tue, 21 Jul 2020 10:23:34 -0700 (PDT)
MIME-Version: 1.0
References: <CAJfpegu3EwbBFTSJiPhm7eMyTK2MzijLUp1gcboOo3meMF_+Qg@mail.gmail.com>
 <D9FAB37B-D059-4137-A115-616237D78640@amacapital.net> <20200715171130.GG12769@casper.infradead.org>
 <7c09f6af-653f-db3f-2378-02dca2bc07f7@gmail.com> <CAJfpegt9=p4uo5U2GXqc-rwqOESzZCWAkGMRTY1r8H6fuXx96g@mail.gmail.com>
 <48cc7eea-5b28-a584-a66c-4eed3fac5e76@gmail.com> <202007151511.2AA7718@keescook>
 <20200716131404.bnzsaarooumrp3kx@steredhat> <202007160751.ED56C55@keescook>
 <20200717080157.ezxapv7pscbqykhl@steredhat.lan> <CALCETrXSPdiVCgh3h=q7w9RyiKnp-=8jOHoFHX=an0cWqK7bzQ@mail.gmail.com>
 <39a3378a-f8f3-6706-98c8-be7017e64ddb@kernel.dk>
In-Reply-To: <39a3378a-f8f3-6706-98c8-be7017e64ddb@kernel.dk>
From:   Andy Lutomirski <luto@kernel.org>
Date:   Tue, 21 Jul 2020 10:23:22 -0700
X-Gmail-Original-Message-ID: <CALCETrXAxFzuRB5EJZR7bbgfrEcNc=9_E7wwhPaZ3YGJ1=DZ0w@mail.gmail.com>
Message-ID: <CALCETrXAxFzuRB5EJZR7bbgfrEcNc=9_E7wwhPaZ3YGJ1=DZ0w@mail.gmail.com>
Subject: Re: strace of io_uring events?
To:     Jens Axboe <axboe@kernel.dk>, Andres Freund <andres@anarazel.de>
Cc:     Andy Lutomirski <luto@kernel.org>,
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

On Tue, Jul 21, 2020 at 8:31 AM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/21/20 9:27 AM, Andy Lutomirski wrote:
> > On Fri, Jul 17, 2020 at 1:02 AM Stefano Garzarella <sgarzare@redhat.com> wrote:
> >>
> >> On Thu, Jul 16, 2020 at 08:12:35AM -0700, Kees Cook wrote:
> >>> On Thu, Jul 16, 2020 at 03:14:04PM +0200, Stefano Garzarella wrote:
> >
> >>> access (IIUC) is possible without actually calling any of the io_uring
> >>> syscalls. Is that correct? A process would receive an fd (via SCM_RIGHTS,
> >>> pidfd_getfd, or soon seccomp addfd), and then call mmap() on it to gain
> >>> access to the SQ and CQ, and off it goes? (The only glitch I see is
> >>> waking up the worker thread?)
> >>
> >> It is true only if the io_uring istance is created with SQPOLL flag (not the
> >> default behaviour and it requires CAP_SYS_ADMIN). In this case the
> >> kthread is created and you can also set an higher idle time for it, so
> >> also the waking up syscall can be avoided.
> >
> > I stared at the io_uring code for a while, and I'm wondering if we're
> > approaching this the wrong way. It seems to me that most of the
> > complications here come from the fact that io_uring SQEs don't clearly
> > belong to any particular security principle.  (We have struct creds,
> > but we don't really have a task or mm.)  But I'm also not convinced
> > that io_uring actually supports cross-mm submission except by accident
> > -- as it stands, unless a user is very careful to only submit SQEs
> > that don't use user pointers, the results will be unpredictable.
>
> How so?

Unless I've missed something, either current->mm or sqo_mm will be
used depending on which thread ends up doing the IO.  (And there might
be similar issues with threads.)  Having the user memory references
end up somewhere that is an implementation detail seems suboptimal.

>
> > Perhaps we can get away with this:
> >
> > diff --git a/fs/io_uring.c b/fs/io_uring.c
> > index 74bc4a04befa..92266f869174 100644
> > --- a/fs/io_uring.c
> > +++ b/fs/io_uring.c
> > @@ -7660,6 +7660,20 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int,
> > fd, u32, to_submit,
> >      if (!percpu_ref_tryget(&ctx->refs))
> >          goto out_fput;
> >
> > +    if (unlikely(current->mm != ctx->sqo_mm)) {
> > +        /*
> > +         * The mm used to process SQEs will be current->mm or
> > +         * ctx->sqo_mm depending on which submission path is used.
> > +         * It's also unclear who is responsible for an SQE submitted
> > +         * out-of-process from a security and auditing perspective.
> > +         *
> > +         * Until a real usecase emerges and there are clear semantics
> > +         * for out-of-process submission, disallow it.
> > +         */
> > +        ret = -EACCES;
> > +        goto out;
> > +    }
> > +
> >      /*
> >       * For SQ polling, the thread will do all submissions and completions.
> >       * Just return the requested submit count, and wake the thread if
>
> That'll break postgres that already uses this, also see:
>
> commit 73e08e711d9c1d79fae01daed4b0e1fee5f8a275
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Sun Jan 26 09:53:12 2020 -0700
>
>     Revert "io_uring: only allow submit from owning task"
>
> So no, we can't do that.
>

Yikes, I missed that.

Andres, how final is your Postgres branch?  I'm wondering if we could
get away with requiring a special flag when creating an io_uring to
indicate that you intend to submit IO from outside the creating mm.

Even if we can't make this change, we could plausibly get away with
tying seccomp-style filtering to sqo_mm.  IOW we'd look up a
hypothetical sqo_mm->io_uring_filters to filter SQEs even when
submitted from a different mm.

--Andy
