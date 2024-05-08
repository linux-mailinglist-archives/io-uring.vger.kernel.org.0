Return-Path: <io-uring+bounces-1822-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 090898BF818
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 10:06:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 994FCB2474D
	for <lists+io-uring@lfdr.de>; Wed,  8 May 2024 08:06:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAE3A46B9A;
	Wed,  8 May 2024 08:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ovjlFQ8u"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892D73D996;
	Wed,  8 May 2024 08:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715155548; cv=none; b=gUA4aRxITZd7oDEdxlBRpMxk/DmBjL4TTiUeTLKb66W58rRa7zIb360ZApW4gQzohvotrVZezzuuJ8J4Uqv/4YRHrKSc5fbwrrQLUFkoCrJMzmBV2In+9kiXI6ggI/AR4nvHDFGOdnqtIEsDcoyAG2OEtBTNnacY9Q9eErixsoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715155548; c=relaxed/simple;
	bh=hs3mKg+OQgaq+nvum86puw6d4BslQHZXpTBdAaPI+nY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOVVgRXU74IAjy6qW4BYvCmUgd2bmzblg8xvYMlT6HjnjcrGKzvNtZwJlJGl/gqvH9tRK7W8JYNTa/qH+BCtjOFCacdtZmF3M56AS9R0pr6zVynf4gHJvrlQk8jpsFNJxDReLEKaE/sBWNEAQMrjIfJxdd3NH/QYpSfK7KztlV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ovjlFQ8u; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57027C4AF18;
	Wed,  8 May 2024 08:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715155548;
	bh=hs3mKg+OQgaq+nvum86puw6d4BslQHZXpTBdAaPI+nY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ovjlFQ8ukkRvL4ghs8zz4V4Kw25gMFTaKuE5sx+j5PMt25EqkuW7RedC1pfMLWx63
	 QEOFtHNRBffi6eG8d4Mc8xu7/ZyYm2seS4ecvxSlxfPCTPsLhk5MqZ4Pugbnx9ygmJ
	 ygElqYKrHzPHkKg9gGbFrHYd8hMkQbOsVRr/ndDF8RPm+r98qt4Kj+lyRf4fsULQpg
	 HMs+r9d6EMaqu/xPzpW45mnmK24O45KOknIWxUeRCB4Cob5QR2kfh7BNtNmwrHvghE
	 yU8xCwRc7djD6gRoEWtKEOpa2BXeXhzcE5Wh5AZUeXxQ0HUevyciP88YZ8/e6YgjI2
	 tLmeOlFmOHC2Q==
Date: Wed, 8 May 2024 10:05:40 +0200
From: Christian Brauner <brauner@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Vetter <daniel@ffwll.ch>, Simon Ser <contact@emersion.fr>, 
	Pekka Paalanen <pekka.paalanen@collabora.com>, 
	Christian =?utf-8?B?S8O2bmln?= <ckoenig.leichtzumerken@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, 
	axboe@kernel.dk, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [Linaro-mm-sig] Re: [PATCH] epoll: try to be a _bit_ better
 about file lifetimes
Message-ID: <20240508-gefangen-unberechenbar-96845bd61def@brauner>
References: <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
 <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com>
 <ZjoKX4nmrRdevyxm@phenom.ffwll.local>
 <CAHk-=wgh5S-7sCCqXBxGcXHZDhe4U8cuaXpVTjtXLej2si2f3g@mail.gmail.com>
 <CAKMK7uGzhAHHkWj0N33NB3OXMFtNHv7=h=P-bdtYkw=Ja9kwHw@mail.gmail.com>
 <CAHk-=whFyOn4vp7+++MTOd1Y3wgVFxRoVdSuPmN1_b6q_Jjkxg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHk-=whFyOn4vp7+++MTOd1Y3wgVFxRoVdSuPmN1_b6q_Jjkxg@mail.gmail.com>

On Tue, May 07, 2024 at 12:07:10PM -0700, Linus Torvalds wrote:
> On Tue, 7 May 2024 at 11:04, Daniel Vetter <daniel@ffwll.ch> wrote:
> >
> > On Tue, May 07, 2024 at 09:46:31AM -0700, Linus Torvalds wrote:
> >
> > > I'd be perfectly ok with adding a generic "FISAME" VFS level ioctl
> > > too, if this is possibly a more common thing. and not just DRM wants
> > > it.
> > >
> > > Would something like that work for you?
> >
> > Yes.
> >
> > Adding Simon and Pekka as two of the usual suspects for this kind of
> > stuff. Also example code (the int return value is just so that callers know
> > when kcmp isn't available, they all only care about equality):
> >
> > https://gitlab.freedesktop.org/mesa/mesa/-/blob/main/src/util/os_file.c#L239
> 
> That example thing shows that we shouldn't make it a FISAME ioctl - we
> should make it a fcntl() instead, and it would just be a companion to
> F_DUPFD.
> 
> Doesn't that strike everybody as a *much* cleaner interface? I think

+1
See
https://github.com/systemd/systemd/blob/a4f0e0da3573a10bc5404142be8799418760b1d1/src/basic/fd-util.c#L517
that's another heavy user of this kind of functionality.

