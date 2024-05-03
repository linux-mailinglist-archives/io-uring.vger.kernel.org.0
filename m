Return-Path: <io-uring+bounces-1732-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DC1268BB670
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 23:53:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 91ED21F2380E
	for <lists+io-uring@lfdr.de>; Fri,  3 May 2024 21:53:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9876956B76;
	Fri,  3 May 2024 21:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b="uPPrhUlI"
X-Original-To: io-uring@vger.kernel.org
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44AB38DDD;
	Fri,  3 May 2024 21:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.89.141.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714773190; cv=none; b=TQpakMVC6d4j/V/LPw1MmoM2KdL68pxrhOZI8smIwX84ossTyYExGI0NJ8qjVDps5IfWXVuO0o+8p/arXjsfwXJS8VIxe/sjcQlfuPfKaz0TZvgM4BppE1F8/urab75OoIrsda0MqDTnNaHQmHtbtFNY8nnDWSFSEdSD6Pk9ibo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714773190; c=relaxed/simple;
	bh=bExJpdyXIdMIq8/+qTePccS+7WON3s7AOlpfVjopwp0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RrWZA2BdPJbt7ImYcqGUdbfqtfE1jT0jnBr1yDqsiB9reCNvlRnnC2HwKSHF0YxTWvOr20u8PFFRAlpfQRKO/yxr1OWve71XcSZVW1r1bAxtm9rXEZCs5UrWhbBJngmvLQ51Nu2NFNlnFf3yN6SDi43YeEgDLO7sd5m2V2vuPJ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk; spf=none smtp.mailfrom=ftp.linux.org.uk; dkim=pass (2048-bit key) header.d=linux.org.uk header.i=@linux.org.uk header.b=uPPrhUlI; arc=none smtp.client-ip=62.89.141.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=zeniv.linux.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=ftp.linux.org.uk
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=RM0gQuvw5vrpD7I8AUwAP4n456JHvifrZgveaZJKmdE=; b=uPPrhUlILbBbJfo6/OhWVeAbu8
	vvKn1CG9kgelugjtObY1dI4pNbQXkZIW6pXr2dc0D6qKypOtbaQBml/wdQDHlIMzvfUJmoVwYGsJn
	fA4PaeOD3BaZTDGM8djdR0WoP8j8VEVDIDkDDcul8gNfa9TPQLlGSTmYPCfcwv2C87YIgZA0ttd+k
	tSChqsyTaVKQu+LGbkHrPMYX+EIi3msdOV9A/Hdh5A1JnJUuZmQln8p/PoX4NkCiWVsNMbqpyA56c
	g4JUV2/tw5QhQBueA3SbOHD/TX9duqmuzKywCDUhAdOVdAfgznrbJmMOmACfYGqm098yFnGkundvY
	KnSQcN+Q==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.96 #2 (Red Hat Linux))
	id 1s30pz-00B9qR-1v;
	Fri, 03 May 2024 21:53:03 +0000
Date: Fri, 3 May 2024 22:53:03 +0100
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
Message-ID: <20240503215303.GC2118490@ZenIV>
References: <7c41cf3c-2a71-4dbb-8f34-0337890906fc@gmail.com>
 <202405031110.6F47982593@keescook>
 <64b51cc5-9f5b-4160-83f2-6d62175418a2@kernel.dk>
 <202405031207.9D62DA4973@keescook>
 <d6285f19-01aa-49c8-8fef-4b5842136215@kernel.dk>
 <202405031237.B6B8379@keescook>
 <202405031325.B8979870B@keescook>
 <20240503211109.GX2118490@ZenIV>
 <20240503213625.GA2118490@ZenIV>
 <CAHk-=wgRphONC5NBagypZpgriCUtztU7LCC9BzGZDEjWQbSVWQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgRphONC5NBagypZpgriCUtztU7LCC9BzGZDEjWQbSVWQ@mail.gmail.com>
Sender: Al Viro <viro@ftp.linux.org.uk>

On Fri, May 03, 2024 at 02:42:22PM -0700, Linus Torvalds wrote:
> On Fri, 3 May 2024 at 14:36, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > ... the last part is no-go - poll_wait() must be able to grab a reference
> > (well, the callback in it must)
> 
> Yeah. I really think that *poll* itself is doing everything right. It
> knows that it's called with a file pointer with a reference, and it
> adds its own references as needed.

Not really.  Note that select's __pollwait() does *NOT* leave a reference
at the mercy of driver - it's stuck into poll_table_entry->filp and
the poll_freewait() knows how to take those out.


dmabuf does something very different - it grabs the damn thing into
its private data structures and for all we know it could keep it for
a few hours, until some even materializes.

