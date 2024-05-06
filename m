Return-Path: <io-uring+bounces-1771-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E3A58BCAA0
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 11:27:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 07DDB283EBA
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 09:27:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 779E91422D4;
	Mon,  6 May 2024 09:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZJyv7ou5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454BF6CDCE;
	Mon,  6 May 2024 09:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714987624; cv=none; b=ktOuPd/KLIu9lZ2VPjmkWsUYA9KDdnb8WRsJtTtulXzu4YJfLEhxu5subJgLw8s9yTM16Q2peXkwsycHrZGvH+3ucFlqx38Iq0eF8SkAt0ywRSQ+Ugqf3zb7wq/47YpPJnglk5wArt6dc/MzESc/o0IcxzAUeYA/PQ7JnhoD3EI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714987624; c=relaxed/simple;
	bh=r9PFC5bu7lmiF9aq5BTi6CEcKoYDbUpyNGKVlEmMpec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YVC7NVBhQXkC3+29OTzGxNfz/g9ZcoH9JQ3r3aXeKZG0qp4KwWw+YERDu8NgYCEI8s1oXPfyFUijOBk64XnJPSDTxlcq1Bw/I36e/S8XOWBw85T5tx+nc2dtOfJcCPCTDLwocVDQIPrBu/JRaso9RIlJ49i5Sz2SOnsnkQjz3IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZJyv7ou5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE85C116B1;
	Mon,  6 May 2024 09:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714987624;
	bh=r9PFC5bu7lmiF9aq5BTi6CEcKoYDbUpyNGKVlEmMpec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZJyv7ou5pxTVr+uFQiaUFaf141/cP0PUE3Qwy8Uxt7ca6tziSJAncFT6YoShaa4kG
	 XcNFv5jUbDNutMUtLFyD7kfwlU3CfLN1mvCWn65w7ZdzuayS3fTQKBSkFuatUdwbGQ
	 o/AvZTj0GH9CXRl6SIrwcNGc6i63LilJlhGYbJUl6F9jYP0waycKJzZ9bmasukbKf1
	 U934NoMGZc9+AnQG7WtQzww5nuRY3YSb5P5wGwhZxLA3G14RLSmkpfQLk0ohnNX1HW
	 w9L7ZrTsbC7mzuhQMjM8CQEhVGab8383AUyX/Xjb9b4SvXj2xQqapcbWmPtO5didMN
	 H7A9F0KS1jCxw==
Date: Mon, 6 May 2024 11:26:57 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, 
	axboe@kernel.dk, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <20240506-zweibeinig-mahnen-daa579a233db@brauner>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
 <20240505-gelehnt-anfahren-8250b487da2c@brauner>
 <CAHk-=wgMzzfPwKc=8yBdXwSkxoZMZroTCiLZTYESYD3BC_7rhQ@mail.gmail.com>
 <20240506-injizieren-administration-f5900157566a@brauner>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240506-injizieren-administration-f5900157566a@brauner>

On Mon, May 06, 2024 at 10:45:35AM +0200, Christian Brauner wrote:
> > The fact is, it's not dma-buf that is violating any rules. It's epoll.
> 
> I agree that epoll() not taking a reference on the file is at least
> unexpected and contradicts the usual code patterns for the sake of
> performance and that it very likely is the case that most callers of
> f_op->poll() don't know this.
> 
> Note, I cleary wrote upthread that I'm ok to do it like you suggested
> but raised two concerns a) there's currently only one instance of
> prolonged @file lifetime in f_op->poll() afaict and b) that there's
> possibly going to be some performance impact on epoll().
> 
> So it's at least worth discussing what's more important because epoll()
> is very widely used and it's not that we haven't favored performance
> before.
> 
> But you've already said that you aren't concerned with performance on
> epoll() upthread. So afaict then there's really not a lot more to
> discuss other than take the patch and see whether we get any complaints.

Two closing thoughts:

(1) I wonder if this won't cause userspace regressions for the semantics
    of epoll because dying files are now silently ignored whereas before
    they'd generated events.

(2) The other part is that this seems to me that epoll() will now
    temporarly pin filesystems opening up the possibility for spurious
    EBUSY errors.

    If you register a file descriptor in an epoll instance and then
    close it and umount the filesystem but epoll managed to do an fget()
    on that fd before that close() call then epoll will pin that
    filesystem.

    If the f_op->poll() method does something that can take a while
    (blocks on a shared mutex of that subsystem) that umount is very
    likely going to return EBUSY suddenly.

    Afaict, before that this wouldn't have been an issue at all and is
    likely more serious than performance.

    (One option would be to only do epi_fget() for stuff like
    dma-buf that's never unmounted. That'll cover nearly every
    driver out there. Only "real" filesystems would have to contend with
    @file count going to zero but honestly they also deal with dentry
    lookup under RCU which is way more adventurous than this.)

    Maybe I'm barking up the wrong tree though.

