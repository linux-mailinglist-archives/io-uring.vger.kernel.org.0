Return-Path: <io-uring+bounces-1776-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 57F438BCFFF
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 16:22:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 861D1B25216
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 14:22:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6B47813D2A2;
	Mon,  6 May 2024 14:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XQUTHXDJ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3660313D297;
	Mon,  6 May 2024 14:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715005154; cv=none; b=MM+5V3nQ/pqO5pLAYWW2K0yman1OueOO6+V0xldP7/JEESE91g5TJQN4AJXBHjmUF5MMktkGWdxmyOQ3H/0nw90w58zXH2Mu2LGqTVeuq6KkKboH8ASsWUjgc8pcPL5jlB7puo/mOWvzhqmv37LvQLwUKxR+xYCLMVlJSci72L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715005154; c=relaxed/simple;
	bh=l39k6V0I7wZACUt8VAIAhxRDJ0/vIbV1E6k1IrSGtK0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uMgSkPAzvWeK575Mo97/8lGiY4YKM9tLOxGWR4t1/IUWgiEzBc1YMK19Me8eVsUw7XSdyfDtz1Q9yxjyO467xC6pYrWbwmVh3L+AujLm1j3riOE3QdDXy/oCFK5fMnA8qCWMZ3TQEd9wExKfwZ8P5V4SOAShdU3kXyhUQKPz9rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XQUTHXDJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FA1C116B1;
	Mon,  6 May 2024 14:19:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715005153;
	bh=l39k6V0I7wZACUt8VAIAhxRDJ0/vIbV1E6k1IrSGtK0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XQUTHXDJ6U4b3MW5pJhdFcgCJ8GRlt0WUo07V6/eFe4FkmlpEPSUBRp9vzJif66tz
	 48bynhPLwPbGqNMjPjj6OCh966S+vS0L+TkmKifUTt5sqDR6RUpnaGxjEj7U0EF0V9
	 qXKKSVwP8jp/jZeB3jCnG0uVdSbcj857lvLjY9a3itUWr2kcoFj+c6vnZ8m+ECCUAz
	 kbUkpPgsM/Pww3u4arhcLXvQW5lj1M6fvyJbgQYolNLKm2LesyooMdJvsfHZae8613
	 tNt1E2bagVx7r2Gbuqaow7JCziJ74q3PJGx+P71AqPMmgTbDhK1CamdAE2gqEK620F
	 lC4wZIfMVgufQ==
Date: Mon, 6 May 2024 16:19:06 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, 
	axboe@kernel.dk, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <20240506-zerbrach-zehnkampf-80281b1452c8@brauner>
References: <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
 <20240505-gelehnt-anfahren-8250b487da2c@brauner>
 <CAHk-=wgMzzfPwKc=8yBdXwSkxoZMZroTCiLZTYESYD3BC_7rhQ@mail.gmail.com>
 <20240506-injizieren-administration-f5900157566a@brauner>
 <20240506-zweibeinig-mahnen-daa579a233db@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240506-zweibeinig-mahnen-daa579a233db@brauner>

On Mon, May 06, 2024 at 11:27:04AM +0200, Christian Brauner wrote:
> On Mon, May 06, 2024 at 10:45:35AM +0200, Christian Brauner wrote:
> > > The fact is, it's not dma-buf that is violating any rules. It's epoll.
> > 
> > I agree that epoll() not taking a reference on the file is at least
> > unexpected and contradicts the usual code patterns for the sake of
> > performance and that it very likely is the case that most callers of
> > f_op->poll() don't know this.
> > 
> > Note, I cleary wrote upthread that I'm ok to do it like you suggested
> > but raised two concerns a) there's currently only one instance of
> > prolonged @file lifetime in f_op->poll() afaict and b) that there's
> > possibly going to be some performance impact on epoll().
> > 
> > So it's at least worth discussing what's more important because epoll()
> > is very widely used and it's not that we haven't favored performance
> > before.
> > 
> > But you've already said that you aren't concerned with performance on
> > epoll() upthread. So afaict then there's really not a lot more to
> > discuss other than take the patch and see whether we get any complaints.
> 
> Two closing thoughts:
> 
> (1) I wonder if this won't cause userspace regressions for the semantics
>     of epoll because dying files are now silently ignored whereas before
>     they'd generated events.
> 
> (2) The other part is that this seems to me that epoll() will now
>     temporarly pin filesystems opening up the possibility for spurious
>     EBUSY errors.
> 
>     If you register a file descriptor in an epoll instance and then
>     close it and umount the filesystem but epoll managed to do an fget()
>     on that fd before that close() call then epoll will pin that
>     filesystem.
> 
>     If the f_op->poll() method does something that can take a while
>     (blocks on a shared mutex of that subsystem) that umount is very
>     likely going to return EBUSY suddenly.
> 
>     Afaict, before that this wouldn't have been an issue at all and is
>     likely more serious than performance.
> 
>     (One option would be to only do epi_fget() for stuff like
>     dma-buf that's never unmounted. That'll cover nearly every
>     driver out there. Only "real" filesystems would have to contend with
>     @file count going to zero but honestly they also deal with dentry
>     lookup under RCU which is way more adventurous than this.)
> 
>     Maybe I'm barking up the wrong tree though.

Sorry, had to step out for an appointment.

Under the assumption that I'm not entirely off with this - and I really
could be ofc - then one possibility would be that we enable persistence
of files from f_op->poll() for SB_NOUSER filesystems.

That'll catch everything that's relying on anonymous inodes (drm and all
drivers) and init_pseudo() so everything that isn't actually unmountable
(pipefs, pidfs, sockfs, etc.).

So something like the _completely untested_ diff on top of your proposal
above:

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index a3f0f868adc4..95968a462544 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1018,8 +1018,24 @@ static struct file *epi_fget(const struct epitem *epi)
 static __poll_t ep_item_poll(const struct epitem *epi, poll_table *pt,
                                 int depth)
 {
-       struct file *file = epi_fget(epi);
+       struct file *file = epi->ffd.file;
        __poll_t res;
+       bool unrefd = false;
+
+       /*
+        * Taking a reference for anything that isn't mountable is fine
+        * because we don't have to worry about spurious EBUSY warnings
+        * from umount().
+        *
+        * File count might go to zero in f_op->poll() for mountable
+        * filesystems.
+        */
+       if (file->f_inode->i_sb->s_flags & SB_NOUSER) {
+               unrefd = true;
+               file = epi_fget(epi);
+       } else if (file_count(file) == 0) {
+               file = NULL;
+       }

        /*
         * We could return EPOLLERR | EPOLLHUP or something,
@@ -1034,7 +1050,9 @@ static __poll_t ep_item_poll(const struct epitem *epi, poll_table *pt,
                res = vfs_poll(file, pt);
        else
                res = __ep_eventpoll_poll(file, pt, depth);
-       fput(file);
+
+       if (unrefd)
+               fput(file);
        return res & epi->event.events;
 }

Basically, my worry is that we end up with really annoying to debug
EBUSYs caused by epoll(). I'd really like to avoid that. But again, I
might be wrong and this isn't an issue.

