Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9939A1B55B9
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2020 09:33:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgDWHdT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Apr 2020 03:33:19 -0400
Received: from relay12.mail.gandi.net ([217.70.178.232]:58457 "EHLO
        relay12.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWHdT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Apr 2020 03:33:19 -0400
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay12.mail.gandi.net (Postfix) with ESMTPSA id 84089200011;
        Thu, 23 Apr 2020 07:33:11 +0000 (UTC)
Date:   Thu, 23 Apr 2020 00:33:10 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Michael Kerrisk <mtk.manpages@gmail.com>, io-uring@vger.kernel.org,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Aleksa Sarai <cyphar@cyphar.com>,
        linux-man <linux-man@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v5 2/3] fs: openat2: Extend open_how to allow
 userspace-selected fds
Message-ID: <20200423073310.GA169998@localhost>
References: <cover.1587531463.git.josh@joshtriplett.org>
 <9873b8bd7d14ff8cd2a5782b434b39f076679eeb.1587531463.git.josh@joshtriplett.org>
 <CAKgNAkjo3AeA78XqK-RRGqJHNy1H8SbcjQQQs7+jDwuFgq4YSg@mail.gmail.com>
 <CAJfpegt=xe-8AayW2i3AYrk3q-=Pp_A+Hctsk+=sXoMed5hFQA@mail.gmail.com>
 <20200423004807.GC161058@localhost>
 <CAJfpegtSYKsApx2Dc6VGmc5Fm4SsxtAWAP-Zs052umwK1CjJmQ@mail.gmail.com>
 <20200423044226.GH161058@localhost>
 <CAJfpeguaVYo-Lf-5Bi=EYJYWdmCfo3BqZA=kj9E5UmDb0mBc1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpeguaVYo-Lf-5Bi=EYJYWdmCfo3BqZA=kj9E5UmDb0mBc1w@mail.gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 23, 2020 at 08:04:25AM +0200, Miklos Szeredi wrote:
> On Thu, Apr 23, 2020 at 6:42 AM Josh Triplett <josh@joshtriplett.org> wrote:
> >
> > On Thu, Apr 23, 2020 at 06:24:14AM +0200, Miklos Szeredi wrote:
> > > On Thu, Apr 23, 2020 at 2:48 AM Josh Triplett <josh@joshtriplett.org> wrote:
> > > > On Wed, Apr 22, 2020 at 09:55:56AM +0200, Miklos Szeredi wrote:
> > > > > On Wed, Apr 22, 2020 at 8:06 AM Michael Kerrisk (man-pages)
> > > > > <mtk.manpages@gmail.com> wrote:
> > > > > >
> > > > > > [CC += linux-api]
> > > > > >
> > > > > > On Wed, 22 Apr 2020 at 07:20, Josh Triplett <josh@joshtriplett.org> wrote:
> > > > > > >
> > > > > > > Inspired by the X protocol's handling of XIDs, allow userspace to select
> > > > > > > the file descriptor opened by openat2, so that it can use the resulting
> > > > > > > file descriptor in subsequent system calls without waiting for the
> > > > > > > response to openat2.
> > > > > > >
> > > > > > > In io_uring, this allows sequences like openat2/read/close without
> > > > > > > waiting for the openat2 to complete. Multiple such sequences can
> > > > > > > overlap, as long as each uses a distinct file descriptor.
> > > > >
> > > > > If this is primarily an io_uring feature, then why burden the normal
> > > > > openat2 API with this?
> > > >
> > > > This feature was inspired by io_uring; it isn't exclusively of value
> > > > with io_uring. (And io_uring doesn't normally change the semantics of
> > > > syscalls.)
> > >
> > > What's the use case of O_SPECIFIC_FD beyond io_uring?
> >
> > Avoiding a call to dup2 and close, if you need something as a specific
> > file descriptor, such as when setting up to exec something, or when
> > debugging a program.
> >
> > I don't expect it to be as widely used as with io_uring, but I also
> > don't want io_uring versions of syscalls to diverge from the underlying
> > syscalls, and this would be a heavy divergence.
> 
> What are the plans for those syscalls that don't easily lend
> themselves to this modification (such as accept(2))?

accept4 has a flags argument with more flags available, so it'd be
entirely possible to cleanly extend it further without introducing a new
version. The same goes for other fd-producing syscalls that still have
flag space available.

This may or may not provide sufficient motivation on its own to
introduce a new syscall variant of a syscall that isn't currently
extensible.

> Compared to that, having a common flag for file ops to enable the use
> of fixed and private file descriptors is a clean and well contained
> interface.

"private" is not a desirable property here. See below. Even if the
userspace-specified fd mechanism were to become something only
accessible via io_uring (which I'd prefer to avoid), that's not a reason
to avoid generating real file descriptors that work anywhere a file
descriptor works.

> > > > > This would also allow Implementing a private fd table for io_uring.
> > > > > I.e. add a flag interpreted by file ops (IORING_PRIVATE_FD), including
> > > > > openat2 and freely use the private fd space without having to worry
> > > > > about interactions with other parts of the system.
> > > >
> > > > I definitely don't want to add a special kind of file descriptor that
> > > > doesn't work in normal syscalls taking file descriptors. A file
> > > > descriptor allocated via O_SPECIFIC_FD is an entirely normal file
> > > > descriptor, and works anywhere a file descriptor normally works.
> > >
> > > What's the use case of allocating a file descriptor within io_uring
> > > and using it outside of io_uring?
> >
> > Calling a syscall not provided via io_uring. Calling a library that
> > doesn't use io_uring. Passing the file descriptor via UNIX socket to
> > another program. Passing the file descriptor via exec to another
> > program. Userspace is modular, and file descriptors are widely used.
> 
> I mean, you could open the file descriptor outside of io_uring in such
> cases, no?

I would prefer to not introduce that limitation in the first place, and
instead open normal file descriptors.

> The point of O_SPECIFIC_FD is to be able to perform short
> sequences of open/dosomething/close without having to block and having
> to issue separate syscalls.

"close" is not a required component. It's entirely possible to use
io_uring to open a file descriptor, do various things with it, and then
leave it open for subsequent usage via either other io_uring chains or
standalone syscalls.

> If you're going to issue separate
> syscalls anyway, then I see no point in doing the open within
> io_uring.  Or?

io_uring is not an all-or-nothing proposition. There's value in using
io_uring for some operations without converting an entire program (and
every library it might potentially use on a file descriptor) entirely to
io_uring. Userspace is modular, and file descriptors are a common
element used by many different bits of userspace.
