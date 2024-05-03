Return-Path: <io-uring+bounces-1741-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE3E78BB857
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 01:39:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EEDCC1C21447
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:39:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59A7682D68;
	Fri,  3 May 2024 23:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="q9II9mXc"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AF0280038;
	Fri,  3 May 2024 23:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714779551; cv=none; b=WsHWaFaan2lXuEcx+XJ6V9xQtOoJjRxP2FJPt7XDHOxj2OiOr+2uhK1MrwZgkIQTlkrxq4OX4V+pDLXqk24xXCMx5r5NpnwenXT4SXnbQzGd4/1AVa6HQ4LCjtyrGDgwHThYNnkK7yri84CnYL+qkUs7nekdrf+jnyOMIbVj7XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714779551; c=relaxed/simple;
	bh=6bbQiD7Gb4UlTZVxIV+PWj8d+j+sms0A1F+r6wyCi14=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nRZSmgsao134fqp165DU6tpQTY+MH1x/htJ+ZUXQ0HR8xi1yiRSfytoZZjghHN2cmd2O4Nl5NAuO7wylS0JpOasIw5txF6vtK0AOzOFXxHOI+5ptRx+/94EYe5vafnxEpAPeGdvtWAsfiyLn8o/9zidEe0WtsF3JFlAwECcAyIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=q9II9mXc; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WAsHHyyLON6bH8kMNcqPvKu+nLtQfBaFyUzhN8/fmXI=; b=q9II9mXcxby6lVXHsG0JVrkTJT
	TbnocjCJurqmvStTQbv944nSP6uYVmbtKY8TuAIqJWuFuYMBM6uSKLCHaXf7YAJTamWF8AZlFwhBd
	DdsNEgsrfspvlmCfg4xJufBuXxSVe9MpcRIvGsC9KG0PLWPnWS1+PDRTYHiOYD6STZ8q1UBLB4u0D
	uS3Sm/j31Dc0E4LJEai6HSyOQqGvvpgo6kBBURsydLKEF5K4A5j7XCAClx9B9/J6zWoohYOKVzV1h
	WhiylI9wqnNhkDsYA9X7ophPs2Yf0JPspgd4a3QjJkdSGwQlQpe81inObgOvhP4wK099OCZRkf9SW
	1dBGEOkg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1s32UW-00BGUG-0X;
	Fri, 03 May 2024 23:39:00 +0000
Date: Sat, 4 May 2024 00:39:00 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: keescook@chromium.org, axboe@kernel.dk, brauner@kernel.org,
	christian.koenig@amd.com, dri-devel@lists.freedesktop.org,
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name,
	linaro-mm-sig@lists.linaro.org, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
	minhquangbui99@gmail.com, sumit.semwal@linaro.org,
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <20240503233900.GG2118490@ZenIV>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240503214531.GB2118490@ZenIV>
 <CAHk-=wgC+QpveKCJpeqsaORu7htoNNKA8mp+d9mvJEXmSKjhbw@mail.gmail.com>
 <20240503220145.GD2118490@ZenIV>
 <20240503220744.GE2118490@ZenIV>
 <CAHk-=whULchE1i5LA2Fa=ZndSAzPXGWh_e5+a=YV3qT1BEST7w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=whULchE1i5LA2Fa=ZndSAzPXGWh_e5+a=YV3qT1BEST7w@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Fri, May 03, 2024 at 04:16:15PM -0700, Linus Torvalds wrote:
> On Fri, 3 May 2024 at 15:07, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Suppose your program calls select() on a pipe and dmabuf, sees data to be read
> > from pipe, reads it, closes both pipe and dmabuf and exits.
> >
> > Would you expect that dmabuf file would stick around for hell knows how long
> > after that?  I would certainly be very surprised by running into that...
> 
> Why?
> 
> That's the _point_ of refcounts. They make the thing they refcount
> stay around until it's no longer referenced.
> 
> Now, I agree that dmabuf's are a bit odd in how they use a 'struct
> file' *as* their refcount, but hey, it's a specialty use. Unusual
> perhaps, but not exactly wrong.
> 
> I suspect that if you saw a dmabuf just have its own 'refcount_t' and
> stay around until it was done, you wouldn't bat an eye at it, and it's
> really just the "it uses a struct file for counting" that you are
> reacting to.

*IF* those files are on purely internal filesystem, that's probably
OK; do that with something on something mountable (char device,
sysfs file, etc.) and you have a problem with filesystem staying
busy.

I'm really unfamiliar with the subsystem; it might be OK with all
objects that use that for ->poll(), but that's definitely not a good
thing to see in ->poll() instance in general.  And code gets copied,
so there really should be a big fat comment about the reasons why
it's OK in this particular case.

Said that, it seems that a better approach might be to have
their ->release() cancel callbacks and drop fence references.
Note that they *do* have refcounts - on fences.  The file
(well, dmabuf, really) is pinned only to protect against the
situation when pending callback is still around.  And Kees'
observation about multiple fences is also interesting - we don't
get extra fput(), but only because we get events only from one
fence, which does look fishy...

