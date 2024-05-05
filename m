Return-Path: <io-uring+bounces-1755-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E108BC01F
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 12:50:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E30C61F2141A
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 10:50:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF621173F;
	Sun,  5 May 2024 10:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e5L3jU3F"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696ED6FBE;
	Sun,  5 May 2024 10:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714906229; cv=none; b=soJMdOjZaGwMhR4aqiM5629NXU4eYLHED5bodNQIz69nUENirRuyO0dFVxwgwiijGeJggsyXG5kK4K2/uCuFO//+2bHVSt2w+YFphrPY33Mw2nZOuhycEAAWaeg1KN4QFZI2qS9ql2PKdHZscKenKgE2p7wsJLUWjbCLHAw/gBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714906229; c=relaxed/simple;
	bh=A0pA9gFmx/KX+0Pa4DEPpSZCbQRPr/bicmqz+Fp/D+U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vn6SduIsAEwIq2fkHskltkNzBVbzydb3invgGkOlo0yOJYb2GIMcBpODNVNi4YjD8xHoYzY4Z9vuuJpo9Ukzpj0MNi3Hzoc9F4lmXF6U11YQSvJDlX4yB/KW8mlcRBaMb79Gnv00ljRD1/9hX/JqFREx+m7thY9FFHnatZYaCSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e5L3jU3F; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B1EC113CC;
	Sun,  5 May 2024 10:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714906228;
	bh=A0pA9gFmx/KX+0Pa4DEPpSZCbQRPr/bicmqz+Fp/D+U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e5L3jU3FZTdPXwhW7v4hVB9ximQhq8UCZ0c9TGS4U1UkDy9SoEAFc5NcwjdpsIkoS
	 y5500oXQvODSiP70b98akmj6jmj+4sIElipq9Sppz0r6ueMZ5+eoTun24p+V22Tcsc
	 HaEAjxcM6qfbfzwdvMKKH0Bzaupg7FpgBHRmFAtU8wyAoJkMIQ+EcEkI2ftcOlZkWI
	 aYekeYbhJGpP03mC0HcdhmtZ5hdyxwJFb24ZNgDWJ/rfxASaSIkLf4OS9WJJBKMSOh
	 qzzyyX+Lq+QiMQ+t6jgW/KeVXyFOY4AUvFgw8NNBYWWqzu+JmgCOPLMaezQ+o0HooC
	 CPk8Qe18RVxwQ==
Date: Sun, 5 May 2024 12:50:21 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, 
	axboe@kernel.dk, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <20240505-gelehnt-anfahren-8250b487da2c@brauner>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>

On Sat, May 04, 2024 at 08:40:25AM -0700, Linus Torvalds wrote:
> On Sat, 4 May 2024 at 08:32, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Now, during this TOTALLY INNOCENT sock_poll(), in another thread, the
> > file closing completes, eventpoll_release() finishes [..]
> 
> Actually, Al is right that ep_item_poll() should be holding the
> ep->mtx, so eventpoll_release() -> eventpoll_release_file_file() ->
> mutex_lock(&ep->mtx) should block and the file doesn't actually get
> released.

So I know you've seen it yourself but for my own peace of mind I've said
that in the other mail and in the other thread already that all callers
of ep_item_poll() do already hold the ep->mtx:

do_epoll_ctl()
-> epoll_mutex_lock(&ep->mtx)
-> ep_insert()
   -> ep_item_poll()

do_epoll_ctl()
-> epoll_mutex_lock(&ep->mtx)
-> ep_modify()
   -> ep_item_poll()

ep_send_events()
-> mutex_lock(&ep->mtx)
-> ep_item_poll()

/* nested; and all callers of ep_item_poll() already hold ep->mtx */
__ep_eventpoll_poll()
-> mutex_lock_nested(&ep->mtx, wait)
-> ep_item_poll()

So it's simply not possible to end up with a UAF in f_op->poll() because
eventpoll_release_file_file() serializes on ep->mtx as well:

__fput()
-> eventpoll_release()
   -> eventpoll_release_file()
      {
              // @file->f_count is zero _but file is not freed_
              // so taking file->f_lock is absolutely fine
              spin_lock(&file->f_lock);
              // mark as dying

              // serialzed on ep->mtx
              mutex_lock(&ep->mtx);
              __ep_rmove(ep, epi);
              ...

      }
      -> mutex_lock(&ep->mtx)

-> f_op->release()
-> kfree(file)

So afaict it's simply not possible to end up with a UAF in f_op->poll().

And I agree with you that for some instances it's valid to take another
reference to a file from f_op->poll() but then they need to use
get_file_active() imho and simply handle the case where f_count is zero.
And we need to document that in Documentation/filesystems/file.rst or
locking.rst.

But if it's simply just dma buf that cares about that long-term
reference then really we should just force them to take the reference
like I suggested but don't penalize everyone else. When I took a glance
at all f_op->poll() implementations I didn't spot one that did take
extra references.

But if you absolutely want to have epoll take the reference before it
calls into f_op->poll() that's fine with me as well. But we might end up
forcing epoll to do a lot of final fput()s which I'm not sure is all
that desirable.

