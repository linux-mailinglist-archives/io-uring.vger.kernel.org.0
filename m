Return-Path: <io-uring+bounces-1724-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2AA738BB5A6
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:26:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 569691C235B0
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 21:25:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 511575A788;
	Fri,  3 May 2024 21:24:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="lHUXrMUy"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E89450269;
	Fri,  3 May 2024 21:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714771478; cv=none; b=sXuRDx4wDCiZD3gScCVHQStj87igfW9L8l9gsrv7iCtluc2J1YvLFmzGrmR31AcELDpzhY1cZKQ2MrY1JEAE7DakBVT5ecUd5E2jeP3K6eo4XMKYX9jHr7kIAMqVCLg+MMsk/NHpbpYJKNZkqXpq/Fb0Q7n0kJB4ObtG7QV6e8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714771478; c=relaxed/simple;
	bh=rGcROCkAtzeFPWQbPlIOJyd5Za/HTzFt8UAcApDDhC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TifTnXlaJlF3PwYNfBzMzZl0g1B70rAEnRbysfiicWvpU0Qs8UJSiYlUNBwkU5v2s34Xj3XGAE37WjQTUir0KJBWF7hf9TzZF4+T9UZsp25ZlQBT+5rUs1pPQ39QAedU4qbWX58Rp0zVgwt0ek0KMfthBX1CMC5JXqowAOQIGJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=lHUXrMUy; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=vSF9CJAk18KfYQ6Yz2FBQxa3cjRXNGsVqxiFCavCXyw=; b=lHUXrMUy3szqVJFXp8ewwVyALG
	FMwhGXj/QBF2ekq73bYumwb8JvTE5PalsZ/PXPWVBB0oPorPebp2p+RIBHU5rMBlca8sRkgFVg50b
	RiQbqehih1W0n77kUD51e1Ju8d4qNoEz+iD4dDvl/i+QyYhIO47/IUPNa9b5W8RqhJdO1Zii9HJ8R
	Tu56r7I50FMejgn8K4U+56PWJ5ubJUM/djzCFRHyVI6whK4JddDTF4M5gsKpbE2ScztycM8lwTywG
	kc6isI7RHzwqBNN1wTBXvtIxbWAa7z6X7h3OsXyp1il17czzMLjeA9HwLKD9q8gTzmbf002b7rhS2
	Ho0KrFIA==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1s30OK-00B7yG-1D;
	Fri, 03 May 2024 21:24:28 +0000
Date: Fri, 3 May 2024 22:24:28 +0100
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
Message-ID: <20240503212428.GY2118490@ZenIV>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240503211129.679762-2-torvalds@linux-foundation.org>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Fri, May 03, 2024 at 02:11:30PM -0700, Linus Torvalds wrote:
> epoll is a mess, and does various invalid things in the name of
> performance.
> 
> Let's try to rein it in a bit. Something like this, perhaps?

> +/*
> + * The ffd.file pointer may be in the process of
> + * being torn down due to being closed, but we
> + * may not have finished eventpoll_release() yet.
> + *
> + * Technically, even with the atomic_long_inc_not_zero,
> + * the file may have been free'd and then gotten
> + * re-allocated to something else (since files are
> + * not RCU-delayed, they are SLAB_TYPESAFE_BY_RCU).

Can we get to ep_item_poll(epi, ...) after eventpoll_release_file()
got past __ep_remove()?  Because if we can, we have a worse problem -
epi freed under us.

If not, we couldn't possibly have reached ->release() yet, let
alone freeing anything.

