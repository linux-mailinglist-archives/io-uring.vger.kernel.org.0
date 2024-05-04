Return-Path: <io-uring+bounces-1750-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B81AF8BBA8F
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 12:44:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E2C8D1C210A1
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 10:44:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C07D61AACA;
	Sat,  4 May 2024 10:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gIVHK8rJ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8343F18C3D;
	Sat,  4 May 2024 10:44:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714819475; cv=none; b=f9FlggnLAClQYuUGve9GDh9aVbeFY/wd5AcE5/Kri/xHMqsQPDU5rpO4fHJk3F7Ei3cpKwl9q895vRz9ZAkOWN/5IlarNWYLJ+qGn32SSZbgUwEmCxqyppGNISmL9EXa10/tyJv+vGPf7TthJfFt0uvNnsMYO0OZ/ZAlziPt11o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714819475; c=relaxed/simple;
	bh=BLItYotWYbyfjyaUpV2xQFYIZr6/mKHn7Hcq1DddZd4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TemzpVE/UgkgN5DQgxQFuvb96KDELhEpvlfQdVso2SBFgj5XMQ17B+eSLWxCvl3RjepZm8TQ1/paDpdIXdeohFGFQEjeAEEk0qn+OKzDGNLYhb6r1WZF5d6iERXLreqLGcOoXLZM2WRlCCCCmKFBqnxH9xHzSJ1VatCR468qBhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gIVHK8rJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3E0C072AA;
	Sat,  4 May 2024 10:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714819475;
	bh=BLItYotWYbyfjyaUpV2xQFYIZr6/mKHn7Hcq1DddZd4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gIVHK8rJGTpZuS9PubMDG4bY2YumcGjk6TzRhJqqAh/plbNUsquxQFGCUWECGrJRE
	 EzEvSIxTo4EYaTNfUE2NBTtvQOeoS6PxKjWcxkktWj4E/WHJr8O8fAnG3sfoTBN/4+
	 G8i9tDMgpoyUa85xPHmgl+X+CQSc0wuLRN7dziptjOtID8DTpn20rQzI5uVZV/AEjb
	 4Ape1g8W24bX7M1DAREc4k2jprCEjKPolqNkqjfYm83hFYMcF9DEBJfSs+DW6g3CfW
	 1/6/xZZebHis+jmMY6X8+A/X1qDg3q6lPjUs79o8NavTNxTFe91+9fo0VupPerS0F3
	 7PiA+rIodq4lg==
Date: Sat, 4 May 2024 12:44:28 +0200
From: Christian Brauner <brauner@kernel.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, keescook@chromium.org, 
	axboe@kernel.dk, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <20240504-chatten-unbelastet-b308db41727c@brauner>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240503214531.GB2118490@ZenIV>
 <CAHk-=wgC+QpveKCJpeqsaORu7htoNNKA8mp+d9mvJEXmSKjhbw@mail.gmail.com>
 <20240503220145.GD2118490@ZenIV>
 <20240503220744.GE2118490@ZenIV>
 <CAHk-=whULchE1i5LA2Fa=ZndSAzPXGWh_e5+a=YV3qT1BEST7w@mail.gmail.com>
 <20240503233900.GG2118490@ZenIV>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240503233900.GG2118490@ZenIV>

On Sat, May 04, 2024 at 12:39:00AM +0100, Al Viro wrote:
> On Fri, May 03, 2024 at 04:16:15PM -0700, Linus Torvalds wrote:
> > On Fri, 3 May 2024 at 15:07, Al Viro <viro@zeniv.linux.org.uk> wrote:
> > >
> > > Suppose your program calls select() on a pipe and dmabuf, sees data to be read
> > > from pipe, reads it, closes both pipe and dmabuf and exits.
> > >
> > > Would you expect that dmabuf file would stick around for hell knows how long
> > > after that?  I would certainly be very surprised by running into that...
> > 
> > Why?
> > 
> > That's the _point_ of refcounts. They make the thing they refcount
> > stay around until it's no longer referenced.
> > 
> > Now, I agree that dmabuf's are a bit odd in how they use a 'struct
> > file' *as* their refcount, but hey, it's a specialty use. Unusual
> > perhaps, but not exactly wrong.
> > 
> > I suspect that if you saw a dmabuf just have its own 'refcount_t' and
> > stay around until it was done, you wouldn't bat an eye at it, and it's
> > really just the "it uses a struct file for counting" that you are
> > reacting to.
> 
> *IF* those files are on purely internal filesystem, that's probably
> OK; do that with something on something mountable (char device,
> sysfs file, etc.) and you have a problem with filesystem staying
> busy.

In this instance it is ok because dma-buf is an internal fs. I had the
exact same reaction you had initially but it doesn't matter for dma-buf
afaict as that thing can never be unmounted.

