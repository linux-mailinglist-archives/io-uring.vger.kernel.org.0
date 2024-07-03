Return-Path: <io-uring+bounces-2436-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0D34B926891
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 20:49:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3F3A61C228F1
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 18:49:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0078518C334;
	Wed,  3 Jul 2024 18:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="BBQhst6x"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE85188CD1;
	Wed,  3 Jul 2024 18:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720032528; cv=none; b=VNMMTcthECs+6ybaId/ttg5WVSfzqsMExYV2NpDiNCNSvB+YeYa6LKFjSsCjr2qOWzD2t0Ghrfk3UTub3f1ds0zn+lTgkIX9rcrgFSbYMUj5lW+3MicBn4nHTDRGV0tcaM0m54g97w21Id59X/VT6xYv1uMbMhUhmItI+Cr6OWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720032528; c=relaxed/simple;
	bh=1UeOixBnqwCS2PCW7+/Bxiux1FjH7BQbeXhlLcGA6t8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=KjKMMqFvRZKBJn2l5D37WXg9fE6F9V9Di27B7a6vXFs8feKwAmtkUprNatUP7i1ftiEB5CYgHDvc3hUwqjv4B4PMySoDjRI6GI3b70uzJp6OofkhWfF/iZmBM5HZszkMyCWUQjxuqRn+0P0t7BcBzy5zNUdxhW2VIId6PdwAPRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=BBQhst6x; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1720032523;
	bh=1UeOixBnqwCS2PCW7+/Bxiux1FjH7BQbeXhlLcGA6t8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=BBQhst6xCRvTKTbLholr9TJQWBj3kLOJ1AxcoFJT3cfa6FvU6GHmfbaWtddmGSvqv
	 3C1snKtnd4kekwFxQoGWyNXWbOSIWlokN6UNupwu2YwbZ0uoLjuJMOOZqZ670wNAy4
	 g5Wn2tYubk1vjXGtpQyjHZprFNFQbQdUDIu+dhpI=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 8751A1A40D4;
	Wed,  3 Jul 2024 14:48:41 -0400 (EDT)
Message-ID: <e40b8edeea1d3747fe79a4f9f932ea4a8d891db0.camel@xry111.site>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
From: Xi Ruoyao <xry111@xry111.site>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>, libc-alpha@sourceware.org, 
 "Andreas K. Huettel"
	 <dilfridge@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, Huacai Chen
	 <chenhuacai@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, Alexander Viro
	 <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	loongarch@lists.linux.dev
Date: Thu, 04 Jul 2024 02:48:40 +0800
In-Reply-To: <CAHk-=wii3qyMW+Ni=S6=cV=ddoWTX+qEkO6Ooxe0Ef2_rvo+kg@mail.gmail.com>
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
	 <CAHk-=wif5KJEdvZZfTVX=WjOOK7OqoPwYng6n-uu=VeYUpZysQ@mail.gmail.com>
	 <b60a61b8c9171a6106d50346ecd7fba1cfc4dcb0.camel@xry111.site>
	 <CAHk-=wjH3F1jTVfADgo0tAnYStuaUZLvz+1NkmtM-TqiuubWcw@mail.gmail.com>
	 <CAHk-=wii3qyMW+Ni=S6=cV=ddoWTX+qEkO6Ooxe0Ef2_rvo+kg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-07-03 at 10:54 -0700, Linus Torvalds wrote:
> On Wed, 3 Jul 2024 at 10:40, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >=20
> > Oh wow. Shows just *how* long ago that was - and how long ago I
> > looked
> > at 32-bit code. Because clearly, I was wrong.
>=20
> Ok, so clearly any *new* 32-bit architecture should use 'struct statx'
> as 'struct stat', and at least avoid the conversion pain.
>=20
> Of course, if using <asm-generic/stat.h> like loongarch does, that is
> very much not what happens. You get those old models with just 'long'.

Fortunately LoongArch ILP32 ABI is not finalized yet (there's no 32-bit
kernel and 64-bit kernel does not support 32-bit userspace yet) so we
can still make it happen to use struct statx as (userspace) struct
stat...


--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

