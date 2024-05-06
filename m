Return-Path: <io-uring+bounces-1778-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 751F78BD0A2
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 16:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F3A7A1F242A5
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 14:47:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDC98153811;
	Mon,  6 May 2024 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ugeRHaDQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CB9153560;
	Mon,  6 May 2024 14:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715006822; cv=none; b=AdN3JtQrb2+u3jez4V8FrP6FQlitnsyl83w+cW7Kf4DatEqz5WiOESjE72xQiVClsWZ+xMjICFmOprava1t00OdptOT1/AdSU/p1WRGOCGekP5Uvn7fHGKPnv7bIMEhqpvmyM/U9B07PaSWUFWD1kWrVt22sAjCWajIw5eyef04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715006822; c=relaxed/simple;
	bh=TkHZP7XlXFcz7qCoE1negTmOxafh0ALA2JDVAJb16QA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ni+SdlcvltWDGXUkaUJbajkNxhFvdEVxtZA0FLaw3C6qav8lMVqQaXwM6JKP0BFD9gg6wGLs3v3puTib+bhvXHwHNar5/QxRbvIk8JrUDr0AjV/AAf2mrwva5+0L0DcGRgBfhsFFFh06JlEGQh/QLrzCA9wDL1EIx2wn0g9nNdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ugeRHaDQ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25F5C116B1;
	Mon,  6 May 2024 14:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715006822;
	bh=TkHZP7XlXFcz7qCoE1negTmOxafh0ALA2JDVAJb16QA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ugeRHaDQCUFiLV5e4d8/x3N0vsSrmrK5A01rmHCu51w94by8Xy8aZWz7jObaQTgvD
	 8UrKKGVuBXjzb8mj5E0rkyY0Xg4XaNXw4RGGbS9f5jMn+6BcYy73eAfb319OPbG2d1
	 95WBugJ4GbpV0kdvqGsLTaBM47fYtSzOf3YyFJaKvSr0Vqx6H0d4SVv1yjkMSX/Uuo
	 0RZmvQ1uFmtOrGVtlXSIdipKTneUDjSQdD3Hr7CNoMSkOKTxiW8A9QkeN+FDuAXUUc
	 IXtadcOYdfzD8Cdo6oyT9DbI9yz+3gNjpTf7nG4+7XvWypQMm8f9tc7dTAglwHDYC3
	 iWq7zC5dcCWYA==
Date: Mon, 6 May 2024 16:46:54 +0200
From: Christian Brauner <brauner@kernel.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, axboe@kernel.dk, christian.koenig@amd.com, 
	dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, 
	linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-media@vger.kernel.org, minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <20240506-zweisamkeit-zinsniveau-615a2e6d7c67@brauner>
References: <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
 <CAHk-=whrSSNYVzTHNFDNGag_xcKuv=RaQUX8+n29kkic39DRuQ@mail.gmail.com>
 <20240505194603.GH2118490@ZenIV>
 <CAHk-=wipanX2KYbWvO5=5Zv9O3r8kA-tqBid0g3mLTCt_wt8OA@mail.gmail.com>
 <20240505203052.GJ2118490@ZenIV>
 <CAHk-=whFg8-WyMbVUGW5c0baurGzqmRtzFLoU-gxtRXq2nVZ+w@mail.gmail.com>
 <ZjjRWybmAmClMMI9@phenom.ffwll.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZjjRWybmAmClMMI9@phenom.ffwll.local>

On Mon, May 06, 2024 at 02:47:23PM +0200, Daniel Vetter wrote:
> On Sun, May 05, 2024 at 01:53:48PM -0700, Linus Torvalds wrote:
> > On Sun, 5 May 2024 at 13:30, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > 0.      special-cased ->f_count rule for ->poll() is a wart and it's
> > > better to get rid of it.
> > >
> > > 1.      fs/eventpoll.c is a steaming pile of shit and I'd be glad to see
> > > git rm taken to it.  Short of that, by all means, let's grab reference
> > > in there around the call of vfs_poll() (see (0)).
> > 
> > Agreed on 0/1.
> > 
> > > 2.      having ->poll() instances grab extra references to file passed
> > > to them is not something that should be encouraged; there's a plenty
> > > of potential problems, and "caller has it pinned, so we are fine with
> > > grabbing extra refs" is nowhere near enough to eliminate those.
> > 
> > So it's not clear why you hate it so much, since those extra
> > references are totally normal in all the other VFS paths.
> > 
> > I mean, they are perhaps not the *common* case, but we have a lot of
> > random get_file() calls sprinkled around in various places when you
> > end up passing a file descriptor off to some asynchronous operation
> > thing.
> > 
> > Yeah, I think most of them tend to be special operations (eg the tty
> > TIOCCONS ioctl to redirect the console), but it's not like vfs_ioctl()
> > is *that* different from vfs_poll. Different operation, not somehow
> > "one is more special than the other".
> > 
> > cachefiles and backing-file does it for regular IO, and drop it at IO
> > completion - not that different from what dma-buf does. It's in
> > ->read_iter() rather than ->poll(), but again: different operations,
> > but not "one of them is somehow fundamentally different".
> > 
> > > 3.      dma-buf uses of get_file() are probably safe (epoll shite aside),
> > > but they do look fishy.  That has nothing to do with epoll.
> > 
> > Now, what dma-buf basically seems to do is to avoid ref-counting its
> > own fundamental data structure, and replaces that by refcounting the
> > 'struct file' that *points* to it instead.
> > 
> > And it is a bit odd, but it actually makes some amount of sense,
> > because then what it passes around is that file pointer (and it allows
> > passing it around from user space *as* that file).
> > 
> > And honestly, if you look at why it then needs to add its refcount to
> > it all, it actually makes sense.  dma-bufs have this notion of
> > "fences" that are basically completion points for the asynchronous
> > DMA. Doing a "poll()" operation will add a note to the fence to get
> > that wakeup when it's done.
> > 
> > And yes, logically it takes a ref to the "struct dma_buf", but because
> > of how the lifetime of the dma_buf is associated with the lifetime of
> > the 'struct file', that then turns into taking a ref on the file.
> > 
> > Unusual? Yes. But not illogical. Not obviously broken. Tying the
> > lifetime of the dma_buf to the lifetime of a file that is passed along
> > makes _sense_ for that use.
> > 
> > I'm sure dma-bufs could add another level of refcounting on the
> > 'struct dma_buf' itself, and not make it be 1:1 with the file, but
> > it's not clear to me what the advantage would really be, or why it
> > would be wrong to re-use a refcount that is already there.
> 
> So there is generally another refcount, because dma_buf is just the
> cross-driver interface to some kind of real underlying buffer object from
> the various graphics related subsystems we have.
> 
> And since it's a pure file based api thing that ceases to serve any
> function once the fd/file is gone we tied all the dma_buf refcounting to
> the refcount struct file already maintains. But the underlying buffer
> object can easily outlive the dma_buf, and over the lifetime of an
> underlying buffer object you might actually end up creating different
> dma_buf api wrappers for it (but at least in drm we guarantee there's at
> most one, hence why vmwgfx does the atomic_inc_unless_zero trick, which I
> don't particularly like and isn't really needed).
> 
> But we could add another refcount, it just means we have 3 of those then
> when only really 2 are needed.

Fwiw, the TTM thing described upthread and in the other thread really
tries hard to work around the dma_buf == file lifetime choice by hooking
into the dma-buf specific release function so it can access the dmabuf
and then the file. All that seems like a pretty error prone thing to me.
So a separate refcount for dma_buf wouldn't be the worst as that would
allow that TTM thing to benefit and remove that nasty hacking into your
generic dma_buf ops. But maybe I'm the only one who sees it that way and
I'm certainly not familiar enough with dma-buf.

