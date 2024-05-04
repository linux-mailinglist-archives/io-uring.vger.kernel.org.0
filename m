Return-Path: <io-uring+bounces-1749-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0739A8BBA69
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 11:59:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B60BF282D7D
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 09:59:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E4517999;
	Sat,  4 May 2024 09:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aRV49p2k"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B11D717556;
	Sat,  4 May 2024 09:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714816756; cv=none; b=mLbUJ6Eb92hCMM11l5WKjkWL/+ozr2BARdK/60EfEUqPvxXclbxACrUbLGA/GojBldqpRfcVoH/9HhP6LbjJTvkoYNrQlYyVOmGSId/ZvSQlinDYZxGXn3zwiaZ56hUWI7tvrtBnruZ0SnM6bGBdToSrSEFII97NniT6QvZQyzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714816756; c=relaxed/simple;
	bh=3eAFHKCZTttF0x3ER2rv6cp3C35EVzmnYui996ngcl4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=imaH0NQIwX1MHA2YyZ+3fAG+/QyK1Kggp9EYLeUELBw9mr3kksy31wDB3PkLpl1IBKhXN88YY7YiJNHG/4DJ9Mkk5rvARQNRhrX6Q+sYbD0u6E9XmtPypMx1S4IxSeAPVxeijIBeLTei5AD0AFWGLOerWvuqfslNB4UV1HMcoKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aRV49p2k; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B45BC072AA;
	Sat,  4 May 2024 09:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714816756;
	bh=3eAFHKCZTttF0x3ER2rv6cp3C35EVzmnYui996ngcl4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aRV49p2kxe5ltj/B9peDkbgJgfXfbYtKd1XRfmyWXgwH7ZTSIh5ErUDb4K7kvzduA
	 szU81/XNWqirbrNe7B/5nzcj36srk+gSP8sacvtTA6V5UVmkEkYohniuRLu/ceZ6yS
	 Ai6X1rLcpuzAI0amzfcW6XivashfnZxmgqPz7ePjHg/jInw+OeXA57XdjY0rhsBPWz
	 8Go9hjLJOFf3/OHnz+1VhQEGYl2QOjEEAEUxhQRtix7b2rJS/k9SkLHqZtVUaTpbP5
	 Pnk4L1u/jXW6LA6fliX548c2RO+mrS4ZfSTLIe5o9blOHsFEvZuhv8Fmt4TapnuuWD
	 DehmZcVkWqZxQ==
Date: Sat, 4 May 2024 11:59:09 +0200
From: Christian Brauner <brauner@kernel.org>
To: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, 
	Bui Quang Minh <minhquangbui99@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, 
	syzbot <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>, io-uring@vger.kernel.org, jack@suse.cz, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com, 
	Sumit Semwal <sumit.semwal@linaro.org>, Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	Laura Abbott <laura@labbott.name>
Subject: Re: get_file() unsafe under epoll (was Re: [syzbot] [fs?]
 [io-uring?] general protection fault in __ep_remove)
Message-ID: <20240504-irrsinn-sinnlich-83cf0890c7dc@brauner>
References: <0000000000002d631f0615918f1e@google.com>
 <7c41cf3c-2a71-4dbb-8f34-0337890906fc@gmail.com>
 <202405031110.6F47982593@keescook>
 <64b51cc5-9f5b-4160-83f2-6d62175418a2@kernel.dk>
 <202405031207.9D62DA4973@keescook>
 <d6285f19-01aa-49c8-8fef-4b5842136215@kernel.dk>
 <202405031237.B6B8379@keescook>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202405031237.B6B8379@keescook>

On Fri, May 03, 2024 at 12:59:52PM -0700, Kees Cook wrote:
> On Fri, May 03, 2024 at 01:35:09PM -0600, Jens Axboe wrote:
> > On 5/3/24 1:22 PM, Kees Cook wrote:
> > > On Fri, May 03, 2024 at 12:49:11PM -0600, Jens Axboe wrote:
> > >> On 5/3/24 12:26 PM, Kees Cook wrote:
> > >>> Thanks for doing this analysis! I suspect at least a start of a fix
> > >>> would be this:
> > >>>
> > >>> diff --git a/drivers/dma-buf/dma-buf.c b/drivers/dma-buf/dma-buf.c
> > >>> index 8fe5aa67b167..15e8f74ee0f2 100644
> > >>> --- a/drivers/dma-buf/dma-buf.c
> > >>> +++ b/drivers/dma-buf/dma-buf.c
> > >>> @@ -267,9 +267,8 @@ static __poll_t dma_buf_poll(struct file *file, poll_table *poll)
> > >>>  
> > >>>  		if (events & EPOLLOUT) {
> > >>>  			/* Paired with fput in dma_buf_poll_cb */
> > >>> -			get_file(dmabuf->file);
> > >>> -
> > >>> -			if (!dma_buf_poll_add_cb(resv, true, dcb))
> > >>> +			if (!atomic_long_inc_not_zero(&dmabuf->file) &&
> > >>> +			    !dma_buf_poll_add_cb(resv, true, dcb))
> > >>>  				/* No callback queued, wake up any other waiters */
> > >>
> > >> Don't think this is sane at all. I'm assuming you meant:
> > >>
> > >> 	atomic_long_inc_not_zero(&dmabuf->file->f_count);
> > > 
> > > Oops, yes, sorry. I was typed from memory instead of copy/paste.
> > 
> > Figured :-)
> > 
> > >> but won't fly as you're not under RCU in the first place. And what
> > >> protects it from being long gone before you attempt this anyway? This is
> > >> sane way to attempt to fix it, it's completely opposite of what sane ref
> > >> handling should look like.
> > >>
> > >> Not sure what the best fix is here, seems like dma-buf should hold an
> > >> actual reference to the file upfront rather than just stash a pointer
> > >> and then later _hope_ that it can just grab a reference. That seems
> > >> pretty horrible, and the real source of the issue.
> > > 
> > > AFAICT, epoll just doesn't hold any references at all. It depends,
> > > I think, on eventpoll_release() (really eventpoll_release_file())
> > > synchronizing with epoll_wait() (but I don't see how this happens, and
> > > the race seems to be against ep_item_poll() ...?)
> > >
> > > I'm really confused about how eventpoll manages the lifetime of polled
> > > fds.
> > 
> > epoll doesn't hold any references, and it's got some ugly callback to
> > deal with that. It's not ideal, nor pretty, but that's how it currently
> > works. See eventpoll_release() and how it's called. This means that
> > epoll itself is supposedly safe from the file going away, even though it
> > doesn't hold a reference to it.
> 
> Right -- what remains unclear to me is how struct file lifetime is
> expected to work in the struct file_operations::poll callbacks. Because
> using get_file() there looks clearly unsafe...

If you're in ->poll() you're holding the epoll mutex and
eventpoll_release_file() needs to acquire ep->mtx as well. So if you're
in ->poll() then you know that eventpoll_release_file() can't progress
and therefore eventpoll_release() can't make progress. So
f_op->release() won't be able to be called as it happens after
eventpoll_release() in __fput(). But f_count being able to go to zero is
expected.

