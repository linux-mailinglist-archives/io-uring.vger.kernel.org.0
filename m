Return-Path: <io-uring+bounces-1726-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A8358BB5BB
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:31:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E139FB2372B
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 21:31:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B32151037;
	Fri,  3 May 2024 21:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="P9w/mUac"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D3723B784;
	Fri,  3 May 2024 21:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714771857; cv=none; b=HZr6BErTXbbIUJvuaFofxx8rekzxFrz3j+6ry8eNHRfucdVUae0uKX9Lno5Hin/h+vE3VGP9BHMfvUXvaIDmY3UZwZnIhP1QRk+2I1QF9w95ZGfVSKZpC5yGvKUiTbqeuOgvOJpVa8ynK6+k79W++A3AwJYQb7Nwf6MHU6y3W6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714771857; c=relaxed/simple;
	bh=ddHrsucgvv+PPmNefwZT1NfXllrzsdMz+holdrpCqzo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=f3wFFesZY+H+61zCJpIsN7q2XGkSTWqCdGxBAgMcyk0e/pUVXFpLx3rZiNv5ZWLYiP4r3sbONXKqulv5cxqY9AsWhzrHwFGOGvdKoorhSujc+wXwZYp7JIWIUw2PH8mepJJyknPqlVyKUOPJX0okLoVz2pS3nUfwzvfl40ZiFlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=P9w/mUac; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OiaUBtTuclMlyYQB7Fm5pzFgIS7kDnUnoaLbaf/9epI=; b=P9w/mUacfd3afMUuHY0uTarqWo
	ANH8+bLd2GdqLqcg+YRliVnpFLB7gZ0AQvYL3vBCrr1dc8N+oEnPRGuZy7z3s7YwRmcjmbIwr34ad
	BoUlmbLBJdE5UQgNX7CI7C/CvZwYxm/BR6s4Ht8V/8UB3apgh2ViaoFLj75NIU/QQYkoV/USue2Ev
	XuLSpSzwt3Ji1M4Z1D/AfowaMkYbNMVG8efWCYUgPDOmIENfSL5/5u+K6riCSFR3NPspw2mP//YyO
	GaMi7JHbRvXKtkSAIpmXII8e0ipWCDUL1cn1AzUJMX6NMZybixhP4Sd1ayeNuCdhecJF2dZT7yrZP
	jyK4i+bg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1s30US-00B8QM-2L;
	Fri, 03 May 2024 21:30:48 +0000
Date: Fri, 3 May 2024 22:30:48 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>,
	Bui Quang Minh <minhquangbui99@gmail.com>,
	Christian Brauner <brauner@kernel.org>,
	syzbot <syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com>,
	io-uring@vger.kernel.org, jack@suse.cz,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, Laura Abbott <laura@labbott.name>
Subject: Re: get_file() unsafe under epoll (was Re: [syzbot] [fs?]
 [io-uring?] general protection fault in __ep_remove)
Message-ID: <20240503213048.GZ2118490@ZenIV>
References: <0000000000002d631f0615918f1e@google.com>
 <7c41cf3c-2a71-4dbb-8f34-0337890906fc@gmail.com>
 <202405031110.6F47982593@keescook>
 <64b51cc5-9f5b-4160-83f2-6d62175418a2@kernel.dk>
 <202405031207.9D62DA4973@keescook>
 <d6285f19-01aa-49c8-8fef-4b5842136215@kernel.dk>
 <202405031237.B6B8379@keescook>
 <202405031325.B8979870B@keescook>
 <20240503211109.GX2118490@ZenIV>
 <CAHk-=wj0de-P2Q=Gz2uyrWBHagT25arLbN0Lyg=U6fT7psKnQA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj0de-P2Q=Gz2uyrWBHagT25arLbN0Lyg=U6fT7psKnQA@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Fri, May 03, 2024 at 02:24:45PM -0700, Linus Torvalds wrote:
> Because even with perfectly normal "->poll()", and even with the
> ep_item_poll() happening *before* eventpoll_release_file(), you have
> this trivial race:
> 
>   ep_item_poll()
>      ->poll()
> 
> and *between* those two operations, another CPU does "close()", and
> that causes eventpoll_release_file() to be called, and now f_count
> goes down to zero while ->poll() is running.
> 
> So you do need to increment the file count around the ->poll() call, I feel.
> 
> Or, alternatively, you'd need to serialize with
> eventpoll_release_file(), but that would need to be some sleeping lock
> held over the ->poll() call.
> 
> > As it is, dma_buf ->poll() is very suspicious regardless of that
> > mess - it can grab reference to file for unspecified interval.
> 
> I think that's actually much preferable to what epoll does, which is
> to keep using files without having reference counts to them (and then
> relying on magically not racing with eventpoll_release_file().

eventpoll_release_file() calling __ep_remove() while ep_item_poll()
is something we need to avoid anyway - having epi freed under
ep_item_poll() would be a problem regardless of struct file
lifetime issues.

