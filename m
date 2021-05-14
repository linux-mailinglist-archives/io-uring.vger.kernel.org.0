Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8D8C380C94
	for <lists+io-uring@lfdr.de>; Fri, 14 May 2021 17:11:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbhENPMw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 May 2021 11:12:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:60912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229524AbhENPMv (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Fri, 14 May 2021 11:12:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3AA5613E6;
        Fri, 14 May 2021 15:11:37 +0000 (UTC)
Date:   Fri, 14 May 2021 17:11:34 +0200
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] fs: make do_mkdirat() take struct filename
Message-ID: <20210514151134.tefjju5sc4fmk2fq@wittgenstein>
References: <20210330055957.3684579-1-dkadashev@gmail.com>
 <20210330055957.3684579-2-dkadashev@gmail.com>
 <20210330071700.kpjoyp5zlni7uejm@wittgenstein>
 <CAOKbgA6spFzCJO+L_uwm9nhG+5LEo_XjVt7R7D8K=B5BcWSDbA@mail.gmail.com>
 <CAOKbgA6Qrs5DoHsHgBvrSGbyzHcaiGVpP+UBS5f25CtdBx3SdA@mail.gmail.com>
 <20210415100815.edrn4a7cy26wkowe@wittgenstein>
 <20210415100928.3ukgiaui4rhspiq6@wittgenstein>
 <CAOKbgA6Tn9uLJCAWOzWfysQDmFWcPBCOT6x47D-q-+_tu9z2Hg@mail.gmail.com>
 <20210415140932.uriiqjx3klzzmluu@wittgenstein>
 <CAOKbgA7JM24D2iuCoVjRV=oC1LW8JCcUMeAWMvFr1GHxb7T57g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOKbgA7JM24D2iuCoVjRV=oC1LW8JCcUMeAWMvFr1GHxb7T57g@mail.gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 13, 2021 at 02:45:39PM +0700, Dmitry Kadashev wrote:
> On Thu, Apr 15, 2021 at 9:09 PM Christian Brauner
> <christian.brauner@ubuntu.com> wrote:
> > Hm, I get your point but if you e.g. look at fs/exec.c we already do
> > have that problem today:
> >
> >  SYSCALL_DEFINE5(execveat,
> >                 int, fd, const char __user *, filename,
> >                 const char __user *const __user *, argv,
> >                 const char __user *const __user *, envp,
> >                 int, flags)
> > {
> >         int lookup_flags = (flags & AT_EMPTY_PATH) ? LOOKUP_EMPTY : 0;
> >
> >         return do_execveat(fd,
> >                            getname_flags(filename, lookup_flags, NULL),
> >                            argv, envp, flags);
> > }
> >
> > The new simple flag helper would simplify things because right now it
> > pretends that it cares about multiple flags where it actually just cares
> > about whether or not empty pathnames are allowed and it forces callers
> > to translate between flags too.
> 
> Hi Christian,
> 
> Sorry for the long silence, I got overwhelmed by the primary job and life
> stuff. I've finally carved out some time to work on this. I left out the

No problem at all! Yeah, I can relate. :)

> "make getname_flags accept a single boolean instead of flags" bit to
> make the change smaller. If you think it's something that definitely
> should be in this patch set then let me know, I'll put it back in. I'm
> still somewhat concerned about the separation of the capability check
> and the actual logic to get the name, but I guess I'll just post what I
> have and collect comments.

Sounds good!

Christian
