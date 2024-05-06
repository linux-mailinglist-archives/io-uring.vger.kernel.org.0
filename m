Return-Path: <io-uring+bounces-1768-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F95A8BC9D6
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 10:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B0C2D1C2190B
	for <lists+io-uring@lfdr.de>; Mon,  6 May 2024 08:45:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0FB14198A;
	Mon,  6 May 2024 08:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WiQEaAXK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B35C6CDAC;
	Mon,  6 May 2024 08:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714985135; cv=none; b=lCIbM550VK17YX4egchPYfRsw9cQXAIsl5eFKxsZTALPxKYfGlS5k1c8IIZa1mQZZRSY2b3cbB8MHtHFu3p2rYFwTbIFtKKgqaIxoo/io0orZFAQU2lI+1GXFdMvue6sd4iRalZt6F+0nbi34V8aHImnzzZdbOF2q8A4fDZ0Ato=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714985135; c=relaxed/simple;
	bh=dJ9zuyrdQMElrOzde31P4H08+N2W3DV9j7dWCbVqR4k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pn0glFOlCOoWG/hthTj35BPtSPdxAb3AHtVAW5MMWdN0kmrCKQuFQ3HMdgy/5SYgu17es+2jzMYz1g9Pjj5+qVYB1YiQ4N0t/Q1oaMc24LqZi2gI0tSiLVsw6pdvgqX2RSOTSR9RFpvjfEanoMRpPNeSIJ/VH7+DsNyXBxrC/oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WiQEaAXK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E24BC116B1;
	Mon,  6 May 2024 08:45:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714985135;
	bh=dJ9zuyrdQMElrOzde31P4H08+N2W3DV9j7dWCbVqR4k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WiQEaAXK+d3VZO4xZnfaaIE7Sfh/pbjnMpO2gmWdDzHwWYp4rCrmzMwXPbAuSq2D8
	 fH+uA4HbPL5yqyI2GI4Xc1nJoimiQWf+O2OZbhl4eYWFSaH6g9e91opm+dSgDUUjAo
	 cG3n3hq8hLlCm6ZsuoLuvkOvcM+NPydIKO2b4EhgiC3t07V0qaT/mPyvfrKo2du0XH
	 JKiCZbDEcy7JnFsbVJDyor6eEcRM3VC21/p2XQujBcHzxcTTufWj4iOIv1ZXu3TpfD
	 Gedh6JD88bRDWqWtwfa4IVCiDN3PyGp/pVOTPWZ2724+lohSOjT706b6NsDbMz5iyb
	 wPCurUHMEdlsw==
Date: Mon, 6 May 2024 10:45:27 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, 
	axboe@kernel.dk, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] epoll: try to be a _bit_ better about file lifetimes
Message-ID: <20240506-injizieren-administration-f5900157566a@brauner>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wirxPSQgRV1u7t4qS1t4ED7w7OeehdUSC-LYZXspqa49w@mail.gmail.com>
 <20240505-gelehnt-anfahren-8250b487da2c@brauner>
 <CAHk-=wgMzzfPwKc=8yBdXwSkxoZMZroTCiLZTYESYD3BC_7rhQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=wgMzzfPwKc=8yBdXwSkxoZMZroTCiLZTYESYD3BC_7rhQ@mail.gmail.com>

> The fact is, it's not dma-buf that is violating any rules. It's epoll.

I agree that epoll() not taking a reference on the file is at least
unexpected and contradicts the usual code patterns for the sake of
performance and that it very likely is the case that most callers of
f_op->poll() don't know this.

Note, I cleary wrote upthread that I'm ok to do it like you suggested
but raised two concerns a) there's currently only one instance of
prolonged @file lifetime in f_op->poll() afaict and b) that there's
possibly going to be some performance impact on epoll().

So it's at least worth discussing what's more important because epoll()
is very widely used and it's not that we haven't favored performance
before.

But you've already said that you aren't concerned with performance on
epoll() upthread. So afaict then there's really not a lot more to
discuss other than take the patch and see whether we get any complaints.

