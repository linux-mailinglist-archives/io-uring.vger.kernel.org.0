Return-Path: <io-uring+bounces-1827-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C70108BFAAE
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 12:15:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 552961F24EA9
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 10:15:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7DD481AA5;
	Wed,  8 May 2024 10:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="g1ElVR4F"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759F081AA2;
	Wed,  8 May 2024 10:09:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715162945; cv=none; b=DMufwDfTuz5VSi2fWEAEK8sQ+VGcogoDGtusoCEc6j8gr1CFq54sdexvz17giT53M1K7tYEeuRBNYwp2tiXDUlCIciJgEZElvXxNMx9WdJ3EIBlJkg/ahoHyukAq6c624wrEXzZ181Kpvh9aV4A4YPWoFmfiA5sRKP8c1Opy9jA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715162945; c=relaxed/simple;
	bh=yrabQPbPYvR+JPoitoyg+9RDRV3056ERK0Y8S6+be2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MP4Kfr7Cq8o8REf3FFAXYolEGs74xDmdSopmZ5QbiyG+fStMHonKdIhOG0xexibBfARno75xqZjqQt3Toz1EXzKm3Y2EGhNZrqfYrjLgF5pC6H/Caq0/QMuxStRA+JAkOzQhP0uhXMcIy6OLMQ/MU/vXpTJg32vdb5Do4lWzb84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=g1ElVR4F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85A84C113CC;
	Wed,  8 May 2024 10:09:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715162945;
	bh=yrabQPbPYvR+JPoitoyg+9RDRV3056ERK0Y8S6+be2M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=g1ElVR4FITT9TalGvuJbfFMESgGVWUWwPh+Jiuy91aSKwAstAfiXyTFlhWpH9rlSj
	 kfIlOoOJuqfDvOjLN8emFmJHFevm1IH96irYRz+bm+AeV/W55Qd9olPzuGmF9V5muE
	 pK/1XrE8w15gD5I30PJqCcNALy57CVi2E1HdM889nC0xP/jJoaExLQShGX7lbyi/eh
	 d+g9d5hbZklc3NXzwARwXdQTzR4cOV7VSYrk3XdlkoSZ9zHOCSHa/wS2X3cAfEkvXt
	 9fgjkNU9JXabQi2jcGskzOm9saN/97+mE1laXFfa/OtQxkb4aV/+BHhS2K0ZDaDOTM
	 mD01Fvs9jdnhQ==
Date: Wed, 8 May 2024 12:08:57 +0200
From: Christian Brauner <brauner@kernel.org>
To: Christian =?utf-8?B?S8O2bmln?= <ckoenig.leichtzumerken@gmail.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, axboe@kernel.dk, christian.koenig@amd.com, 
	dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, 
	linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [Linaro-mm-sig] Re: [PATCH] epoll: try to be a _bit_ better
 about file lifetimes
Message-ID: <20240508-risse-fehlpass-895202f594fd@brauner>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
 <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com>

On Mon, May 06, 2024 at 04:29:44PM +0200, Christian König wrote:
> Am 04.05.24 um 20:20 schrieb Linus Torvalds:
> > On Sat, 4 May 2024 at 08:32, Linus Torvalds
> > <torvalds@linux-foundation.org> wrote:
> > > Lookie here, the fundamental issue is that epoll can call '->poll()'
> > > on a file descriptor that is being closed concurrently.
> > Thinking some more about this, and replying to myself...
> > 
> > Actually, I wonder if we could *really* fix this by simply moving the
> > eventpoll_release() to where it really belongs.
> > 
> > If we did it in file_close_fd_locked(),  it would actually make a
> > *lot* more sense. Particularly since eventpoll actually uses this:
> > 
> >      struct epoll_filefd {
> >          struct file *file;
> >          int fd;
> >      } __packed;
> > 
> > ie it doesn't just use the 'struct file *', it uses the 'fd' itself
> > (for ep_find()).
> > 
> > (Strictly speaking, it should also have a pointer to the 'struct
> > files_struct' to make the 'int fd' be meaningful).
> 
> While I completely agree on this I unfortunately have to ruin the idea.
> 
> Before we had KCMP some people relied on the strange behavior of eventpoll
> to compare struct files when the fd is the same.
> 
> I just recently suggested that solution to somebody at AMD as a workaround
> when KCMP is disabled because of security hardening and I'm pretty sure I've
> seen it somewhere else as well.
> 
> So when we change that it would break (undocumented?) UAPI behavior.

I've worked on that a bit yesterday and I learned new things about epoll
and ran into some limitations.

Like, what happens if process P1 has a file descriptor registered in an
epoll instance and now P1 forks and creates P2. So every file that P1
maintains gets copied into a new file descriptor table for P2. And the
same file descriptors refer to the same files for both P1 and P2.

So there's two interesting cases here:

(1) P2 explicitly removes the file descriptor from the epoll instance
    via epoll_ctl(EPOLL_CTL_DEL). That removal affects both P1 and P2
    since the <fd, file> pair is only registered once and it isn't
    marked whether it belongs to P1 and P2 fdtable.

    So effectively fork()ing with epoll creates a weird shared state
    where removal of file descriptors that were registered before the
    fork() affects both child and parent.

    I found that surprising even though I've worked with epoll quite
    extensively in low-level userspace.

(2) P2 doesn't close it's file descriptors. It just exits. Since removal
    of the file descriptor from the epoll instance isn't done during
    close() but during last fput() P1's epoll state remains unaffected
    by P2's sloppy exit because P1 still holds references to all files
    in its fdtable.

    (Sidenote, if one ends up adding every more duped-fds into epoll
    instance that one doesn't explicitly close and all of them refer to
    the same file wouldn't one just be allocating new epitems that
    are kept around for a really long time?)

So if the removal of the fd would now be done during close() or during
exit_files() when we call close_files() and since there's currently no
way of differentiating whether P1 or P2 own that fd it would mean that
(2) collapses into (1) and we'd always alter (1)'s epoll state. That
would be a UAPI break.

So say we record the fdtable to get ownership of that file descriptor so
P2 doesn't close anything in (2) that really belongs to P1 to fix that
problem.

But afaict, that would break another possible use-case. Namely, where P1
creates an epoll instance and registeres fds and then fork()s to create
P2. Now P1 can exit and P2 takes over the epoll loop of P1. This
wouldn't work anymore because P1 would deregister all fds it owns in
that epoll instance during exit. I didn't see an immediate nice way of
fixing that issue.

But note that taking over an epoll loop from the parent doesn't work
reliably for some file descriptors. Consider man signalfd(2):

   epoll(7) semantics
       If a process adds (via epoll_ctl(2)) a signalfd file descriptor to an epoll(7) instance,
       then epoll_wait(2) returns events only for signals sent to that process.  In particular,
       if  the process then uses fork(2) to create a child process, then the child will be able
       to read(2) signals that  are  sent  to  it  using  the  signalfd  file  descriptor,  but
       epoll_wait(2)  will  not  indicate  that the signalfd file descriptor is ready.  In this
       scenario, a possible workaround is that after the fork(2), the child process  can  close
       the  signalfd  file descriptor that it inherited from the parent process and then create
       another signalfd file descriptor and add it to the epoll instance.   Alternatively,  the
       parent and the child could delay creating their (separate) signalfd file descriptors and
       adding them to the epoll instance until after the call to fork(2).

So effectively P1 opens a signalfd and registers it in an epoll
instance. Then it fork()s and creates P2. Now both P1 and P2 call
epoll_wait(). Since signalfds are always relative to the caller and P1
did call signalfd_poll() to register the callback only P1 can get
events. So P2 can't take over signalfds in that epoll loop.

Honestly, the inheritance semantics of epoll across fork() seem pretty
wonky and it would've been better if an epoll fd inherited across
would've returned ESTALE or EINVAL or something. And if that inheritance
of epoll instances would really be a big use-case there'd be some
explicit way to enable this.

