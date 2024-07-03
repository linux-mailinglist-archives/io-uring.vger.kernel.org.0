Return-Path: <io-uring+bounces-2420-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D28479255BA
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 10:46:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E3EF285ED0
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 08:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9673D13BAE2;
	Wed,  3 Jul 2024 08:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kE8GJLEk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6324113B5B6;
	Wed,  3 Jul 2024 08:46:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719996366; cv=none; b=LcUF0Vmto2h0rtB/E2HfYtbRhGMdMIr8+7UYGs7G7nUwwfkg50e9p9EJg9aTPdPX1m5gwjK8uJKTMDkP9/f6wNIxtazuV/N9WmefSy6r2QJyV7/zYQ4ti1Zie6RHoRPnPsO5CHHwXuclsvlnLKGRAQ4W6PIKgXTDD9lmpIsv1KU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719996366; c=relaxed/simple;
	bh=8tTWBbIfp4RYs5ggHus8UpXXenBA9tpsSLsvXgNGsZQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DDZab4N8U4S2dPIlys643h6hvQ87nXQTElAr9w7cdTuwVbk2VwALwgujvX1TLaeXDl8AvNgcq76VFiV42xjvC8OMFSevC/X2J+vaT3v01YbdjojS2L0E3E0BIR4rqgdDMBkOPLqt2HDC2rstcEBCiDuTVbTwNIFP4IRzVHUs9ZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kE8GJLEk; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B96C32781;
	Wed,  3 Jul 2024 08:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719996366;
	bh=8tTWBbIfp4RYs5ggHus8UpXXenBA9tpsSLsvXgNGsZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kE8GJLEkwyiU5152Sq7Jpo1DYYerGfjeXJWRpgzMb4/alcXywnbLHoRK5OgfNpXvi
	 G1xd8DjWipYSfC+3LxEwSUc1cCUzxfB19fZ3FU81vf6Er1duJ1jVyH17rj1jnfILpg
	 K9AAQMcJK8FC0I+iU7VodNwBvzCmvo3ircRgo9nmU3c6UlDocCEJJkF7Sjxu8ck6pn
	 e8M2XE6lcSogOTBmKiIbfHPlxrUbZdhQz48DyLvUmgSxnvyeZ6jS18za2WiRyPVXKj
	 NX2md3uunssvvPgsUMnm/SyXSTnr/AN0bVLlUsjWVtRZ6ga12XfLXH7QGgNq2FTLw8
	 PL3o3v+43P/6Q==
Date: Wed, 3 Jul 2024 10:45:57 +0200
From: Christian Brauner <brauner@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Huacai Chen <chenhuacai@kernel.org>, Xi Ruoyao <xry111@xry111.site>, 
	Mateusz Guzik <mjguzik@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Linus Torvalds <torvalds@linux-foundation.org>, loongarch@lists.linux.dev
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
Message-ID: <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
References: <20240625110029.606032-1-mjguzik@gmail.com>
 <20240625110029.606032-3-mjguzik@gmail.com>
 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
 <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
 <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
 <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
 <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com>
 <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
 <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com>

On Tue, Jul 02, 2024 at 07:06:53PM GMT, Arnd Bergmann wrote:
> On Tue, Jul 2, 2024, at 17:36, Huacai Chen wrote:
> > On Mon, Jul 1, 2024 at 7:59 PM Arnd Bergmann <arnd@arndb.de> wrote:
> >> On Sun, Jun 30, 2024, at 04:39, Xi Ruoyao wrote:
> >> > On Sun, 2024-06-30 at 09:40 +0800, Huacai Chen wrote:
> >> >> >
> >> >> > Yes, both Linus and Christian hates introducing a new AT_ flag for
> >> >> > this.
> >> >> >
> >> >> > This patch just makes statx(fd, NULL, AT_EMPTY_PATH, ...) behave
> >> >> > like
> >> >> > statx(fd, "", AT_EMPTY_PATH, ...) instead.  NULL avoids the
> >> >> > performance
> >> >> > issue and it's also audit-able by seccomp BPF.
> >> >> To be honest, I still want to restore __ARCH_WANT_NEW_STAT. Because
> >> >> even if statx() becomes audit-able, it is still blacklisted now.
> >> >
> >> > Then patch the sandbox to allow it.
> >> >
> >> > The sandbox **must** be patched anyway or it'll be broken on all 32-bit
> >> > systems after 2037.  [Unless they'll unsupport all 32-bit systems before
> >> > 2037.]
> >>
> >> More importantly, the sandbox won't be able to support any 32-bit
> >> targets that support running after 2037, regardless of how long
> >> the sandbox supports them: if you turn off COMPAT_32BIT_TIME today
> >> in order to be sure those don't get called by accident, the
> >> fallback is immediately broken.
> > Would you mind if I restore newstat for LoongArch64 even if this patch exist?
> 
> I still prefer not add newstat back: it's easier to
> get applications to correctly implement the statx() code
> path if there are more architectures that only have that.

I agree.

We've now added AT_EMPTY_PATH support with NULL names because we want to
allow that generically. But I clearly remember that this was requested
to make statx() work with these sandboxes. So the kernel has done its
part. Now it's for the sandbox to allow statx() with NULL paths and
AT_EMPTY_PATH but certainly not for the kernel to start reenabling old
system calls.

