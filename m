Return-Path: <io-uring+bounces-1855-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 273FC8C2292
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 12:55:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCEF71F229A1
	for <lists+io-uring@lfdr.de>; Fri, 10 May 2024 10:55:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3601916D317;
	Fri, 10 May 2024 10:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IZ16glye"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B1816C873;
	Fri, 10 May 2024 10:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715338516; cv=none; b=oFW/2uqlF31qhqaTAVzLSV3zXhA7nB51FUe+hd+Zio44ILnmnA6GycruOXbL3GPxsCLbAPLsxILspB4OY1tkWF7INY0D/Qt6MzZdaRs+64V4grlSDRe6ZKP9sFTSiO1m45g+v8tC73Qg5pY/ubl8oTG3gA6BtUpJTKHtRpwPbe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715338516; c=relaxed/simple;
	bh=Yg72rzmx+bcTPUq2wGuL/cZ1uSAABSmBZuLsh72n3GA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WJ6niPS+Eq0pQiIUq74vSRKqb0qeL404ZcAOFD2jb+VrQuSsKA2pYtJQekpwhvB3nrKhzWF/mG5MaHYirs/MybyFRdh7qVBQwWS6reoAyFwBYCtrIYEbbkrmcCd2AwDGytkLENRg4+H9MqnvoZWtU3ilkpDWiDDTSnY2lNoceJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IZ16glye; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6CBC113CC;
	Fri, 10 May 2024 10:55:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715338514;
	bh=Yg72rzmx+bcTPUq2wGuL/cZ1uSAABSmBZuLsh72n3GA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IZ16glyeUoEcw9bvLXvZyE6xpgHtADMx321GfnN0BHALFchlZSBq/fK4KF9b5Vq7h
	 MN1lPeoAgCcojfCacXEZ3oUgkHjP6AqL7aJIiKfq7nArCv1Sqzay+3peXRW7zvHLED
	 uBTZDCEcefInuP73Npox6kTo4di4WbMnD/NRY9011QMdLz34aE3feX0I2oQs+3g0h+
	 m5kSagyGxw5VAGQdLCVlWKPi99HWJrGP46LMxQdj2jdhdDOctRZFpDeEzSulU05vzm
	 V5x9L3RjmbW0zGRujXz0ojFm3N/C5Yh7q5TejagGWpEkhrrJhRtOpwxw/cmKQW7iqG
	 9vrh1c5+2TFVw==
Date: Fri, 10 May 2024 12:55:07 +0200
From: Christian Brauner <brauner@kernel.org>
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Christian =?utf-8?B?S8O2bmln?= <ckoenig.leichtzumerken@gmail.com>, 
	Linus Torvalds <torvalds@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, keescook@chromium.org, 
	axboe@kernel.dk, christian.koenig@amd.com, dri-devel@lists.freedesktop.org, 
	io-uring@vger.kernel.org, jack@suse.cz, laura@labbott.name, linaro-mm-sig@lists.linaro.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-media@vger.kernel.org, 
	minhquangbui99@gmail.com, sumit.semwal@linaro.org, 
	syzbot+045b454ab35fd82a35fb@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Subject: Re: [Linaro-mm-sig] Re: [PATCH] epoll: try to be a _bit_ better
 about file lifetimes
Message-ID: <20240510-duzen-uhrmacher-141c9331f1bf@brauner>
References: <202405031110.6F47982593@keescook>
 <20240503211129.679762-2-torvalds@linux-foundation.org>
 <20240503212428.GY2118490@ZenIV>
 <CAHk-=wjpsTEkHgo1uev3xGJ2bQXYShaRf3GPEqDWNgUuKx0JFw@mail.gmail.com>
 <20240504-wohngebiet-restwert-6c3c94fddbdd@brauner>
 <CAHk-=wj_Fu1FkMFrjivQ=MGkwkKXZBuh0f4BEhcZHD5WCvHesw@mail.gmail.com>
 <CAHk-=wj6XL9MGCd_nUzRj6SaKeN0TsyTTZDFpGdW34R+zMZaSg@mail.gmail.com>
 <b1728d20-047c-4e28-8458-bf3206a1c97c@gmail.com>
 <20240508-risse-fehlpass-895202f594fd@brauner>
 <ZjueITUy0K8TP1WO@phenom.ffwll.local>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZjueITUy0K8TP1WO@phenom.ffwll.local>

> For the uapi issue you describe below my take would be that we should just
> try, and hope that everyone's been dutifully using O_CLOEXEC. But maybe
> I'm biased from the gpu world, where we've been hammering it in that
> "O_CLOEXEC or bust" mantra since well over a decade. Really the only valid

Oh, we're very much on the same page. All new file descriptor types that
I've added over the years are O_CLOEXEC by default. IOW, you need to
remove O_CLOEXEC explicitly (see pidfd as an example). And imho, any new
fd type that's added should just be O_CLOEXEC by default.

