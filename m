Return-Path: <io-uring+bounces-4368-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7946F9BA76B
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 19:33:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 00BBAB21220
	for <lists+io-uring@lfdr.de>; Sun,  3 Nov 2024 18:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8453FAD2D;
	Sun,  3 Nov 2024 18:32:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="NwJ7M4wS"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F5B29A0;
	Sun,  3 Nov 2024 18:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730658775; cv=none; b=P/8vj7RjorqgTmivR7Mhu5x1AvXhijjhmucKyGa79qHYXVFGvCMZTGOPgjHaYq7elTqLobTdBxAol51c9fxo3ZeaIDtXjBcWlfh64XjjKBDLQC2nIQGprFlqkoL0/+P9Io+Z+FisjG3duE+yWyk+wEWgo30X0VOdkaprkXCDH0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730658775; c=relaxed/simple;
	bh=3KD6eaKuf3XilOsEx4jvD5d+n7WW2+ezBH2GGGu/XXU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gm/Zllo3GiZX0LDJhCLXVkwleMoyC2qdmbpYs7UPzzyYr0bncfMd2Yzt7Rqt1KRqZ897UgLYSwk7OjXYB8/rM1sk4ASkBgR4LgJGpBiLmlTz80d3jjumxAz0Zez3qnMDpMOh5uKJRrdZBifCnmYV9BP82bL80SKuBH0D6GoXxyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=NwJ7M4wS; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=S09L9I0l0uhvMCgbKe7ooblBiG64V3WJebF5I6KG5BE=; b=NwJ7M4wSyPZFAxwqErPtFAa6NO
	fu6lp+Q4SuFOyY6WHF2Zp3UQMTo73lS18LiMQJBHOPH4RiSOJ0VcdrA/vnlKaVWp8OEdclvGr0cFW
	XJCgVqTNBWVt6qGB2k+l6FErx0zrpQQqrxjXcIjcfly/JNqqnXFCPawrkbA6DiS2fGfMlE9wCuPpd
	px2KgsvfkbtlBgaTVyMW6ZbXcL8UeDUV1hkgKksD/hlXIoaAUAI1mNP55ylpI/aaHFiAbh1JmoOT+
	rcDWbljU2POSZiyNZlKeRPNGkdq+U/DWxde3tU2zvG4WfVVKtWG9cdvIyzEP3XQTwZek1eXWplQii
	TGxcRpSA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.98 #2 (Red Hat Linux))
	id 1t7fP7-0000000AlOD-2fx0;
	Sun, 03 Nov 2024 18:32:49 +0000
Date: Sun, 3 Nov 2024 18:32:49 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>, io-uring@vger.kernel.org,
	Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>
Subject: Re: [RFC][PATCHES v2] xattr stuff and interactions with io_uring
Message-ID: <20241103183249.GT1350452@ZenIV>
References: <20241002011011.GB4017910@ZenIV>
 <20241102072834.GQ1350452@ZenIV>
 <2a01f70e-111c-4981-9165-5f5170242a8c@kernel.dk>
 <20241103065156.GS1350452@ZenIV>
 <a8081b55-c770-4709-aa9e-f55c85d78cdb@app.fastmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8081b55-c770-4709-aa9e-f55c85d78cdb@app.fastmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Sun, Nov 03, 2024 at 02:57:14PM +0100, Arnd Bergmann wrote:
> On Sun, Nov 3, 2024, at 07:51, Al Viro wrote:
> > On Sat, Nov 02, 2024 at 08:43:31AM -0600, Jens Axboe wrote:
> >> Tested on arm64, fwiw I get these:
> >> 
> >> <stdin>:1603:2: warning: #warning syscall setxattrat not implemented [-Wcpp]
> >> <stdin>:1606:2: warning: #warning syscall getxattrat not implemented [-Wcpp]
> >> <stdin>:1609:2: warning: #warning syscall listxattrat not implemented [-Wcpp]
> >> <stdin>:1612:2: warning: #warning syscall removexattrat not implemented [-Wcpp]
> >
> > arch/arm64/tools/syscall*.tbl bits are missing (as well as
> > arch/sparc/kernel/syscall_32.tbl ones, but that's less of an
> > issue).
> >
> > AFAICS, the following should be the right incremental.  Objections, anyone?
> 
> Looks fine to me.
> 
> I have a patch to convert s390 to use the exact same format
> as the others, and I should push that patch, but it slightly
> conflict with this one.
> 
> We can also remove the old include/uapi/asm-generic/unistd.h
> that is no longer used.

I'd suggest starting with Documentation/process/adding-syscalls.rst, then...

