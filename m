Return-Path: <io-uring+bounces-1722-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD84C8BB545
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:11:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD1561C20B61
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 21:11:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 335E4482EE;
	Fri,  3 May 2024 21:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="Rs9B3xI+"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A5341746;
	Fri,  3 May 2024 21:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714770681; cv=none; b=hYSoo5VppYtLtSnFe0b5JYEbsOzi0YpdGota5peXEnsoDee0BS1ARUTrZiBPWGxI2CAIEUrdYkP1MtNlg2hH6Ttmu/DoSRsXA2fXwd2AOoAnQlLzCyACIXvoExA1gNjEfQhW1XPB/ifd2Yt9vBn1kRcEsVfVxD9Q1h0Ch44Jc9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714770681; c=relaxed/simple;
	bh=ir4jVAwHqZZPJB/DE9uWzxgHlCj8HSje/nWd9XFDyhY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l/2br5Z+mvgfi+nJgRC8/+n6F3fzgUJOBSVgagc1/SC0AhUuP7gHGeDjW9TIl2OIDUyIiRxx0owzJdTEJStOCyyJfkif54BA5xaxAZEUYiR/mHnQIX4lzzd52/Pb4IjuylT4lfppqkvE5IcmymX6ciw3G/lDMf+tlQRnqe/0/dA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=Rs9B3xI+; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NY7dpnWNXhQQKVFdAJPJlG4e4ZXMaDmQRQbDTVWLCeE=; b=Rs9B3xI+XdmJK5vPYQK8J22QKS
	EgQQjCflBDYUtxW7SIX67RGaVIh3sQxNGH90bxispPeYAm3Rch22e5sDAaxhSEmNW2ySJllWffdb5
	a4oV0hJkK1wMLB0wsYYYxmpIJp7sPoevLWMdPWdjnwETEp1S5NfsIj1h0wJX1d3jNqehubjWUYPn+
	7uDmwbVMNILcV4WyvLYqHObXMuav53kC37sidi15Uw1VLUrj5+Sngx5+0djz5feXF5HjHfmThe2Wn
	SpKgjexjGpBfd+US1tn2T08npPs/aGPCeX21rEsxXS0Wot3Ugzg/2Yns9RIFdjTU5nMXuJMK+yyG7
	QAAoXHQQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1s30BR-00B72n-1X;
	Fri, 03 May 2024 21:11:09 +0000
Date: Fri, 3 May 2024 22:11:09 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Kees Cook <keescook@chromium.org>
Cc: Jens Axboe <axboe@kernel.dk>, Bui Quang Minh <minhquangbui99@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	syzbot <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>,
	io-uring@vger.kernel.org, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, Laura Abbott <laura@labbott.name>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: get_file() unsafe under epoll (was Re: [syzbot] [fs?]
 [io-uring?] general protection fault in __ep_remove)
Message-ID: <20240503211109.GX2118490@ZenIV>
References: <0000000000002d631f0615918f1e@google.com>
 <7c41cf3c-2a71-4dbb-8f34-0337890906fc@gmail.com>
 <202405031110.6F47982593@keescook>
 <64b51cc5-9f5b-4160-83f2-6d62175418a2@kernel.dk>
 <202405031207.9D62DA4973@keescook>
 <d6285f19-01aa-49c8-8fef-4b5842136215@kernel.dk>
 <202405031237.B6B8379@keescook>
 <202405031325.B8979870B@keescook>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202405031325.B8979870B@keescook>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Fri, May 03, 2024 at 01:28:37PM -0700, Kees Cook wrote:
> 
> Is this the right approach? It still feels to me like get_file() needs
> to happen much earlier...

I don't believe it needs to happen at all.  The problem is not that
->release() can be called during ->poll() - it can't and it doesn't.
It's that this instance of ->poll() is trying to extend the lifetime
of that struct file, when it might very well be past the point of no
return.

What we need is
	* promise that ep_item_poll() won't happen after eventpoll_release_file().
AFAICS, we do have that.
	* ->poll() not playing silly buggers.

As it is, dma_buf ->poll() is very suspicious regardless of that
mess - it can grab reference to file for unspecified interval.
Have that happen shortly before reboot and you are asking for failing
umount.

->poll() must be refcount-neutral wrt file passed to it.  I'm seriously
tempted to make ->poll() take const struct file * and see if there's
anything else that would fall out.

