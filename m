Return-Path: <io-uring+bounces-2442-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C0E6692692D
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 21:55:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 698FD1F23AD9
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 19:55:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76E6618E746;
	Wed,  3 Jul 2024 19:55:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K5yCwFlP"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4609517DA39;
	Wed,  3 Jul 2024 19:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720036511; cv=none; b=H+L9ZMfcVl5VKAQkpDe1/EydvS2a9kYVTi4Sw+UnmV/1ZwDyx7C+YO1D89+Z0S2lQXHnNon6yu2sqEXlAJM9A1oIedIwm8iXHrO8dq/tSyyHgiy9yTVLal7m9sQcRzaZFaawxJB6yk1mYSwNCkwF5pBbGFarzRVHg2wcrCsG+Go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720036511; c=relaxed/simple;
	bh=3+KFKcrbRO4keOpt+JOi00B7hn3XwKfZiZ7l4BeJAs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ss9lhwRa6BsxWA69GuYmFg7R4rGPc6UvdBh+qgItvCDray8GYsdDF2eBYRnBkZusWTZYV/UdbFnRNBwe+o0/YpW41MUT44SpD6Ime51DDRTMA60KRtSdKlRFMgSgqxluF9sRJjgTgONPk6/lU+j5QvxUpn81mvuGpDlFNWSDKec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K5yCwFlP; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90EC7C2BD10;
	Wed,  3 Jul 2024 19:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720036510;
	bh=3+KFKcrbRO4keOpt+JOi00B7hn3XwKfZiZ7l4BeJAs0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K5yCwFlP1evFYpDwXK3vVXxP/IgzwHvR2q7ZairTUXyPqRIGJwVdgOBMZFi+Kq+IY
	 /fldO1PlBPChuRfQgILgfeTwFBKI6i0RDUUapFIsUi/RcA3KReuEsUe7TDZ98a4Tmc
	 uf5FQK6xGcEcHy/G+oMB/KKSUpJv+o+Wv/zWSSaMkamf/nWndPExiIKMw4/aI1McN7
	 9Z75B2chyCgl28NM2JbATXCndxwD+PGu1B3q0fI6MVe8ND00RT7/Ke8Tk9V5G5clRv
	 iCjKw0k9i655alQwxKCyQ57mRdH8dMLvD6La5xOmO8sG50oEU+2tlwE+mmivQgK3N6
	 JeTWutncFRupg==
Date: Wed, 3 Jul 2024 21:55:00 +0200
From: Christian Brauner <brauner@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, 
	Xi Ruoyao <xry111@xry111.site>, Xi Ruoyao <libc-alpha@sourceware.org>, 
	Andreas K Huettel <dilfridge@gentoo.org>, Huacai Chen <chenhuacai@kernel.org>, 
	Mateusz Guzik <mjguzik@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, loongarch@lists.linux.dev
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
Message-ID: <20240703-eckdaten-ganzheit-3b6ca8d71aed@brauner>
References: <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com>
 <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
 <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com>
 <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
 <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
 <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
 <CAHk-=wif5KJEdvZZfTVX=WjOOK7OqoPwYng6n-uu=VeYUpZysQ@mail.gmail.com>
 <b60a61b8c9171a6106d50346ecd7fba1cfc4dcb0.camel@xry111.site>
 <CAHk-=wjH3F1jTVfADgo0tAnYStuaUZLvz+1NkmtM-TqiuubWcw@mail.gmail.com>
 <a30ac1fe-07ac-4b09-9ede-c9360a34a103@app.fastmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <a30ac1fe-07ac-4b09-9ede-c9360a34a103@app.fastmail.com>

On Wed, Jul 03, 2024 at 08:44:50PM GMT, Arnd Bergmann wrote:
> On Wed, Jul 3, 2024, at 19:40, Linus Torvalds wrote:
> > On Wed, 3 Jul 2024 at 10:30, Xi Ruoyao <xry111@xry111.site> wrote:
> >>
> >> struct stat64 {
> >>
> >> // ...
> >>
> >>     int     st_atime;   /* Time of last access.  */
> >
> > Oh wow. Shows just *how* long ago that was - and how long ago I looked
> > at 32-bit code. Because clearly, I was wrong.
> >
> > I guess it shows how nobody actually cares about 32-bit any more, at
> > least in the 2037 sense.
> >
> > The point stands, though - statx isn't a replacement for existing binaries.
> 
> We had long discussions about adding another stat()/fstat()
> variant with 64-bit timestamps from 2012 to 2017, the result
> was that we mandated that a libc implementation with 64-bit
> time_t must only use statx() and not fall back to the time32
> syscalls on kernels that are new enough to have statx().
> This is both for architectures that were introduced after
> time64 support was added (riscv32 and the glibc port for
> arc), and for userspace builds that are explicitly using
> time64 syscalls only.
> 
> That may have been a mistake in hindsight, or it may have
> been the right choice, but the thing is that if we now decide
> that 32-bit userspace can not rely on statx() to be available,
> then we need to introduce one or two new system calls.

I'm not sure we need to now pull the rug out from everyone now and I
don't think this was where the discussion was going. Any new
architecture will implement statx(). And for 32bit I think that's
entirely fine and we don't need to add even more variants just for this
case. I don't think we need to add newnewstat_promiseitsthelastone().

