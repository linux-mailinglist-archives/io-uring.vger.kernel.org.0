Return-Path: <io-uring+bounces-1766-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DDD28BC3B3
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 22:31:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9842B20855
	for <lists+io-uring@lfdr.de>; Sun,  5 May 2024 20:31:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68F7D36AE4;
	Sun,  5 May 2024 20:31:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="UfQ6ajUK"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 678421DA22;
	Sun,  5 May 2024 20:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714941065; cv=none; b=NKyRKWXj+eYTNhy7E4LZF2DcC0H3qCUId+UmsImsGpmlMq1xXqgJMdoVKANuvh7bPnJusLykW8n/AkONyeXpMsUqbMg/uv9+3ZWNfqV4cqskaB4Pm2awVoBNqdU6ULh3MQKF1D6o1rkVNPqp61OR3NRwRVazZLxywfhe4NklxvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714941065; c=relaxed/simple;
	bh=LsVx8cpGZ4aiXnbcdtdFjsafF8HGe3xu/guXdG44lpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dgrjE5LrKV7N+P4aq1Rnk3u1jyuG7rb/CH78HxEd3CYurbX/dndbZ9jIUxYVIQhSPX9pC6SWqa9o0A8GXcBwVOm2u91MTyMugxg/QHMT9hd6MmRkzl7e9srbyZZfJk3eBjJhRTyu3JtEtWEysFM/EuBok9n9hlfrDnDbLXBofYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=UfQ6ajUK; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5RAK72tlhDi40d79TYqG9Ma0z3H3FbbwyjJuCY2Mj0g=; b=UfQ6ajUKgstMS3HVj5tD2ob8VO
	stYeg0HZNzZNfx4cYhUE7d0Scc8SqF1+moMBwFzuODitNrdwZpJZb47uoa530T3RPHmHdvRpbYjhS
	Cv7MyQR3qW2lypos8PGtwndBWDLmiJsJnqaFLoWAH0NktoT3B1tkWoiWn2nVS28gzbs+fAo2qQTbw
	2FOep8GKGHO+SqNuP6P0z0T/KamtEJ27/kG6GtUBxlK0dlEffF4UPW7O+asyiwGvX7QqdyZ7UTYcH
	SK7bGmTeXoKeboHRTY5oplOGNkIIVSKCO7E2OSC1q5IwTKsim1m6ccbHnBYUgzQCfmpZc8gmFO9j6
	7vuGcYvA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1s3iVY-00DHdX-14;
	Sun, 05 May 2024 20:30:52 +0000
Date: Sun, 5 May 2024 21:30:52 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>, keescook@chromium.org,
	axboe@kernel.dk, christian.koenig@amd.com,
	dri-devel@lists.freedesktop.org, io-uring@vger.kernel.org,
	jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, minhquangbui99@gmail.com,
	sumit.semwal@linaro.org,
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <20240505203052.GJ2118490@ZenIV>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
 <CAHk-=whrSSNYVzTHNFDNGag_xcKuv=RaQUX8+n29kkic39DRuQ@mail.gmail.com>
 <20240505194603.GH2118490@ZenIV>
 <CAHk-=wipanX2KYbWvO5=5Zv9O3r8kA-tqBid0g3mLTCt_wt8OA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wipanX2KYbWvO5=5Zv9O3r8kA-tqBid0g3mLTCt_wt8OA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sun, May 05, 2024 at 01:03:07PM -0700, Linus Torvalds wrote:
> On Sun, 5 May 2024 at 12:46, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > I've no problem with having epoll grab a reference, but if we make that
> > a universal requirement ->poll() instances can rely upon,
> 
> Al, we're note "making that a requirement".
> 
> It always has been.

Argh.   We keep talking past each other.

0.	special-cased ->f_count rule for ->poll() is a wart and it's
better to get rid of it.

1.	fs/eventpoll.c is a steaming pile of shit and I'd be glad to see
git rm taken to it.  Short of that, by all means, let's grab reference
in there around the call of vfs_poll() (see (0)).

2. 	having ->poll() instances grab extra references to file passed
to them is not something that should be encouraged; there's a plenty
of potential problems, and "caller has it pinned, so we are fine with
grabbing extra refs" is nowhere near enough to eliminate those.

3.	dma-buf uses of get_file() are probably safe (epoll shite aside),
but they do look fishy.  That has nothing to do with epoll.

