Return-Path: <io-uring+bounces-2447-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id EBFB3926F49
	for <lists+io-uring@lfdr.de>; Thu,  4 Jul 2024 08:03:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 238EF1C22001
	for <lists+io-uring@lfdr.de>; Thu,  4 Jul 2024 06:03:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AEB811A071B;
	Thu,  4 Jul 2024 06:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="beHSakzf"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCE2FC0A;
	Thu,  4 Jul 2024 06:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720072939; cv=none; b=hsTpAo/C18zNu/DYU8ufRELCw+fBIwy7SeUV77BbaH9JekC9Ep5wiyzEDoJKw0EgkaaWwNrpsy08edu0iw+grkxeQmj77bPJECXnU1KTHjhZELTtC837Jvem5wNvl8fLyAVGG2Vdwqq5dY76BcVTPk7KTQ60xI0Wb9V9n5CBPQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720072939; c=relaxed/simple;
	bh=pxiPVtSBViR2jWFK0dxTXW4X3jLI07LI8Kbj7hu+PAQ=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Gsf3srNlLuv0ncQrXH3eZBhbl6hJent106MAgKTUKUXdIFUT7Np+mctlNXaVOfno/WvTJh41ESdBCnRw0rgDUynp2rFpmnb9aQxX3ZpTr7mmLdd4njGf7GOSqFvcljB5yR+VZbK7nhP7hYO46a5EzD8tBjG/N6WA/+1fNE9S/NY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=beHSakzf; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1720072936;
	bh=pxiPVtSBViR2jWFK0dxTXW4X3jLI07LI8Kbj7hu+PAQ=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=beHSakzfswp1dNuKDJeX+YOjxWEEAQ82KCxJtG7P6QxREd5AWSHayAIkNye0XOWS6
	 dMhDEUS+uV2Rrc3Eb4fZrkQ+0WL+0D/w0GsgBkLdukw1+ulZ33qVzPRaVvdLPK5jdC
	 UewGGq4EX5stvrDKH21QhJgAhh7/6N+QMnJH2dQo=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id C504F670B6;
	Thu,  4 Jul 2024 02:02:13 -0400 (EDT)
Message-ID: <3fea167cad483484616e9bbf5ec6374475c4bcc4.camel@xry111.site>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
From: Xi Ruoyao <xry111@xry111.site>
To: Florian Weimer <fweimer@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christian Brauner
	 <brauner@kernel.org>, libc-alpha@sourceware.org, "Andreas K. Huettel"
	 <dilfridge@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, Huacai Chen
	 <chenhuacai@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, Alexander Viro
	 <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	loongarch@lists.linux.dev
Date: Thu, 04 Jul 2024 14:02:11 +0800
In-Reply-To: <877ce1ya4b.fsf@oldenburg.str.redhat.com>
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
	 <877ce1ya4b.fsf@oldenburg.str.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Thu, 2024-07-04 at 07:55 +0200, Florian Weimer wrote:
> * Xi Ruoyao:
>=20
> > Also some bad news: Glibc has this:
> >=20
> > #if (__WORDSIZE =3D=3D 32 \
> > =C2=A0=C2=A0=C2=A0=C2=A0 && (!defined __SYSCALL_WORDSIZE || __SYSCALL_W=
ORDSIZE =3D=3D 32)) \
> > =C2=A0=C2=A0=C2=A0 || defined STAT_HAS_TIME32 \
> > =C2=A0=C2=A0=C2=A0 || (!defined __NR_newfstatat && !defined __NR_fstata=
t64)
> > # define FSTATAT_USE_STATX 1
> > #else
> > # define FSTATAT_USE_STATX 0
> > #endif
>=20
> These __NR_* constants come from the glibc headers, not the kernel
> headers.=C2=A0 In other words, the result of the preprocessor condition d=
oes
> not depend on the kernel header version.

Yes, I realized it in https://sourceware.org/pipermail/libc-alpha/2024-
July/157975.html and 2.40 should be fine.  But the __NR_* constants will
be there once we run update-syscall-lists.py, so we still need to handle
the issue in the Glibc 2.41 dev cycle.


--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

