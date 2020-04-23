Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC3F01B56EC
	for <lists+io-uring@lfdr.de>; Thu, 23 Apr 2020 10:07:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgDWIGx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Apr 2020 04:06:53 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:52927 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725863AbgDWIGx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Apr 2020 04:06:53 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 97775C000C;
        Thu, 23 Apr 2020 08:06:46 +0000 (UTC)
Date:   Thu, 23 Apr 2020 01:06:44 -0700
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
Message-ID: <20200423080644.GA171696@localhost>
References: <cover.1587531463.git.josh@joshtriplett.org>
 <9873b8bd7d14ff8cd2a5782b434b39f076679eeb.1587531463.git.josh@joshtriplett.org>
 <CAKgNAkjo3AeA78XqK-RRGqJHNy1H8SbcjQQQs7+jDwuFgq4YSg@mail.gmail.com>
 <CAJfpegt=xe-8AayW2i3AYrk3q-=Pp_A+Hctsk+=sXoMed5hFQA@mail.gmail.com>
 <20200423004807.GC161058@localhost>
 <CAJfpegtSYKsApx2Dc6VGmc5Fm4SsxtAWAP-Zs052umwK1CjJmQ@mail.gmail.com>
 <20200423044226.GH161058@localhost>
 <CAJfpeguaVYo-Lf-5Bi=EYJYWdmCfo3BqZA=kj9E5UmDb0mBc1w@mail.gmail.com>
 <20200423073310.GA169998@localhost>
 <CAJfpegtXj4bSbhpx+=z=R0_ZT8uPEJAAev0O+DVg3AX242e=-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegtXj4bSbhpx+=z=R0_ZT8uPEJAAev0O+DVg3AX242e=-g@mail.gmail.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Apr 23, 2020 at 09:45:45AM +0200, Miklos Szeredi wrote:
> On Thu, Apr 23, 2020 at 9:33 AM Josh Triplett <josh@joshtriplett.org> wrote:
> > > What are the plans for those syscalls that don't easily lend
> > > themselves to this modification (such as accept(2))?
> >
> > accept4 has a flags argument with more flags available, so it'd be
> > entirely possible to cleanly extend it further without introducing a new
> > version.
>
> Variable argument syscalls, you are thinking?

That or repurposing an existing pointer-sized argument as an
open_how-style struct, yes. But in any case, I'm not proposing that; I'm
proposing changes to the existing highly extensible openat2 syscall.

> > > I mean, you could open the file descriptor outside of io_uring in such
> > > cases, no?
> >
> > I would prefer to not introduce that limitation in the first place, and
> > instead open normal file descriptors.
> >
> > > The point of O_SPECIFIC_FD is to be able to perform short
> > > sequences of open/dosomething/close without having to block and having
> > > to issue separate syscalls.
> >
> > "close" is not a required component. It's entirely possible to use
> > io_uring to open a file descriptor, do various things with it, and then
> > leave it open for subsequent usage via either other io_uring chains or
> > standalone syscalls.
> 
> If this use case arraises,

This wasn't a hypothetical "someone might want this". I'm stating that
this is a requirement I'm seeking to meet with this patch series, and
one I intend to use. The primary use case is interoperability with
other code using file descriptors and not using io_uring.
