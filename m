Return-Path: <io-uring+bounces-1733-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F71D8BB6D4
	for <lists+io-uring@lfdr.de>; Sat,  4 May 2024 00:02:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C31F71F215F2
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 22:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16FA558AA7;
	Fri,  3 May 2024 22:01:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="ixw6Zn2z"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450E617C66;
	Fri,  3 May 2024 22:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714773716; cv=none; b=no9orNom3m1jqrFS+8M1FUCdfzO1kHiF4LT7EZiDrcAIyKGk8NSJq9Qo0ZGr/v+Mnz1MaJ1liLMLGdUvr0bOQ6wrcWF0xHf70G97YfSXdvkHGNuZkr4pmgdnBRU8imG54VOpqgrNg5KxfvBLjj+zhaFx1MXgpxkIv8+Kio9zdao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714773716; c=relaxed/simple;
	bh=s8vVwtQRVxNI/I/AfduomXJRnXJ45uenWrtYjSca3AA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cvvywWBY8SfXuLNeDziaaOvPgv5QHGHlsNZVC8ONpmQQVwt7wgoxD1mhTYgVEwtutKBAegBhjjLh7nyWYFmm0iYsddJNRQQ4AV57A1SrKUcs3q5vkra23kDUEGZ7f1TwHg0P6PJmlk2GULYr9rwx+xYgkBFyCqah5WVF8ImOfRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=ixw6Zn2z; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=e9Q+lbqOogW8HNifFtsIP7Map61/HL1nsdMCnQKDqeg=; b=ixw6Zn2z08k8IXQn2UeXsg+bKm
	YT3mHFmtdAxGr/T71cJoTeAIJ9cybNhYjA10uBoNjdruajFBVfshWTS99mzQn2BmAvL0djycRGaQz
	xO/QjrzDFf9tqc5QzRG6rzZrX99A81BgK3nEiL9esE/1qEfd7lk3nh6DcYI/Av3A3MXZLD1vmsqZY
	wCSMQDHzhg4C+aMRUsopmDTuohWXXzzBH1hOQUtkVRzh2Ep1hwz+1DIcC0xxSOjGPRTETMXEaoTk3
	zQkG2/bCiipFfKanmwEaPpVtxOzrxyksfbooWWc39v4tytCwFwZSumInNvhBsO7Uj9Re0lt+ZNJ5O
	6A9rw/Iw==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1s30yP-00BAPg-2r;
	Fri, 03 May 2024 22:01:46 +0000
Date: Fri, 3 May 2024 23:01:45 +0100
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
Message-ID: <20240503220145.GD2118490@ZenIV>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240503214531.GB2118490@ZenIV>
 <CAHk-=wgC+QpveKCJpeqsaORu7htoNNKA8mp+d9mvJEXmSKjhbw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgC+QpveKCJpeqsaORu7htoNNKA8mp+d9mvJEXmSKjhbw@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Fri, May 03, 2024 at 02:52:38PM -0700, Linus Torvalds wrote:
> On Fri, 3 May 2024 at 14:45, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > How do you get through eventpoll_release_file() while someone
> > has entered ep_item_poll()?
> 
> Doesn't matter.
> 
> Look, it's enough that the file count has gone down to zero. You may
> not even have gotten to eventpoll_release_file() yet - the important
> part is that you're on your *way* to it.
> 
> That means that the file will be released - and it means that you have
> violated all the refcounting rules for poll().
> 
> So I think you're barking up the wrong tree.

IMO there are several things in that mess (aside of epoll being what it is).

Trying to grab refcount as you do is fine; the comment is seriously
misleading, though - we *are* guaranteed that struct file hasn't hit ->release(),
let alone getting freed and reused.

Having pollwait callback grab references is fine - and the callback belongs
to whoever's calling ->poll().

Having ->poll() instance itself grab reference is really asking for problem,
even on the boxen that have CONFIG_EPOLL turned off.  select(2) is enough;
it will take care of references grabbed by __pollwait(), but it doesn't
know anything about the references driver has stashed hell knows where for
hell knows how long.

