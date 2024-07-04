Return-Path: <io-uring+bounces-2445-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 83B5B926E41
	for <lists+io-uring@lfdr.de>; Thu,  4 Jul 2024 06:14:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A83251C21E5E
	for <lists+io-uring@lfdr.de>; Thu,  4 Jul 2024 04:14:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 759B11B960;
	Thu,  4 Jul 2024 04:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="BNGleD3w"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0444C39FC1;
	Thu,  4 Jul 2024 04:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720066477; cv=none; b=Ss+xGm9Z8Rl8APajMCBr7dzXQrCCkTuK0HPazczf1rdri9mXB99CViRCnIrnfoJZlkdUkxQcVRpw+iWucGjpFBn3BNmgVFpeRcuOFgdD3nhnoablbfg9zJZg8F9h6WZsnLXREZc/uhGyVmx7cLzBqYl/v3vMLrKcHVYlDowYJpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720066477; c=relaxed/simple;
	bh=MMbdbqBdI2pUHSkgjQ90kbkNA4/1ZWRXGW9IOSOqpuE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Ez/6hwRuHEkGoI1FBB3TQJGJZJin5MWbG8ShEBp53q0o9AY9KOrNTgfAB6FGfgRZLMGRPIf+LsZlOnz3f62d0T6715uCvLD8R+svL0VbhV/KHVhv0ppuvV/syRApNXWicSjllO/xVd6dbPTMvvdn0u67QFg7dwhdaisXaXldFd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=BNGleD3w; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1720066474;
	bh=MMbdbqBdI2pUHSkgjQ90kbkNA4/1ZWRXGW9IOSOqpuE=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=BNGleD3wewzsZaJsbcfyeU4nRIScLDiNLIgehJqUNdKdL4YUhov4ZzoMGEQU/XYOS
	 lzp1gXy+BKK1EIE2lTsR228bEU0D+s0Yw7xLdFZFG6LCtIpiUugloF13/+KZP5+7gT
	 B/WRQMgBoRi745yGnx13YJJClubjstlnuR11kI1k=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id ACD1766D42;
	Thu,  4 Jul 2024 00:14:31 -0400 (EDT)
Message-ID: <f5b84b6f59f1f35f7d8e7464229b4956b8724968.camel@xry111.site>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
From: Xi Ruoyao <xry111@xry111.site>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christian Brauner
 <brauner@kernel.org>, libc-alpha@sourceware.org, "Andreas K. Huettel"
 <dilfridge@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik
 <mjguzik@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara
 <jack@suse.cz>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,  io-uring@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>,  loongarch@lists.linux.dev
Date: Thu, 04 Jul 2024 12:14:29 +0800
In-Reply-To: <ae7309e4fe38896402c282b87b6a2b6c21ff12f2.camel@xry111.site>
References: <20240625110029.606032-1-mjguzik@gmail.com>
	 <20240625110029.606032-3-mjguzik@gmail.com>
	 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
	 <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
	 <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
	 <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
	 <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com>
	 <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
	 <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com>
	 <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
	 <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
	 <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
	 <CAAhV-H7vJ69GD5RWOAtVVMAriGX8eVfqSTp_XadV9PTZJuoSAQ@mail.gmail.com>
	 <ae7309e4fe38896402c282b87b6a2b6c21ff12f2.camel@xry111.site>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-07-04 at 11:23 +0800, Xi Ruoyao wrote:
> On Thu, 2024-07-04 at 10:38 +0800, Huacai Chen wrote:
> > > So if a LoongArch Glibc is built with Linux kernel headers >=3D 6.11,
> > > it'll use fstatat **even configured --with-kernel=3D5.19** and fail t=
o run
> > > on Linux kernel <=3D 6.10.=C2=A0 This will immediately blow up buildi=
ng Linux
> > > From Scratch on a host distro with an "old" kernel.
> > The patch which adds newstat back will CC the stable list and be
> > backported to old kernels.
>=20
> AFAIK in Glibc --enable-kernel=3Dx.y (not with, I was too sleepy
> yesterday) means it'll work with even x.y.0.=C2=A0 And even if we "re-
> purpose" x.y to mean "the latest x.y patch release" people can still
> explicitly spell the patch level, like --enable-kernel=3D5.19.0.
>=20
> Thus we still need to handle this in Glibc.
>=20
> And the backport will raise another question: assume 6.6.40 gets the
> backport, what should we do with --enable-kernel=3D6.6.40?=C2=A0 Maybe we
> should we assume newfstatat is available but then people will start to
> complain "hey 6.9.7 > 6.6.40 but my Glibc configured with --enable-
> kernel=3D6.6.40 does not work on 6.9.7"...
>=20
> To me the only rational way seems only assuming 6.11 or later

Or the first 6.10.x which will get the backport.

> has newfstatat on LoongArch.


--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

