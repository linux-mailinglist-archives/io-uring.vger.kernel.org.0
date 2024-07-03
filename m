Return-Path: <io-uring+bounces-2426-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 84BC1926671
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 18:55:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E0F04B211E0
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 16:55:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB954184136;
	Wed,  3 Jul 2024 16:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="b6bNx6+a"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6941718410F;
	Wed,  3 Jul 2024 16:54:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720025693; cv=none; b=mcd+HOc6RXeYVku8xnSHTcpUCdl4k4JMZCOm1eMmuzVAYknT0rIjXS3EFQLeAxWwCBFcnoRgALFu3YKvx4U6TJ5Xu8LQai6ctu8s0kg5q7Lja/m8tfEVvDQLvc3aoZUN5laS2BdnILYpocNpuqVERXFHqDvo2NDc6QErt3At+0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720025693; c=relaxed/simple;
	bh=ytPD61FrFhwUADWR7wdjMAPmOxv/bqXPWvtuuRwDlvs=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=SBu3w02XZJCGFhqXs5N4tuZcG/T49bPBNNod2U5aRYwn9NtfVAmLRVjzKgKetMqY9M3FB8Hku/PasxnxvlRknx0T3BfolTXB2fBm5ideXaM8bIOvt2uk4QQpZwST0n1yEEKdqbluBmelOFtPUP2RuTGiNqP+YMsB4jFKjbMLcqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=b6bNx6+a; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1720025690;
	bh=ytPD61FrFhwUADWR7wdjMAPmOxv/bqXPWvtuuRwDlvs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=b6bNx6+awULwq7oXzBgaNpvxIuB3ezmNqIpxqTLdXA6b0z3tnu8olBFYfPG/dD4ZS
	 tpvsPOwpvgqvZFgxK9OCZxUkvfPF8rXmYtObTlvGoCIopnY4Shv02773MIffF+ETXH
	 gditMPVnkQjKiSrGa732UKDyPF/ACCI4azoLLRJI=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 5A0F61A409D;
	Wed,  3 Jul 2024 12:54:47 -0400 (EDT)
Message-ID: <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
From: Xi Ruoyao <xry111@xry111.site>
To: Linus Torvalds <torvalds@linux-foundation.org>, Christian Brauner
	 <brauner@kernel.org>
Cc: libc-alpha@sourceware.org, "Andreas K. Huettel" <dilfridge@gentoo.org>, 
 Arnd Bergmann <arnd@arndb.de>, Huacai Chen <chenhuacai@kernel.org>, Mateusz
 Guzik <mjguzik@gmail.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan
 Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org,  io-uring@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>,  loongarch@lists.linux.dev
Date: Thu, 04 Jul 2024 00:54:45 +0800
In-Reply-To: <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-07-03 at 09:31 -0700, Linus Torvalds wrote:
> On Wed, 3 Jul 2024 at 01:46, Christian Brauner <brauner@kernel.org>
> wrote:
> >=20
> > We've now added AT_EMPTY_PATH support with NULL names because we
> > want to
> > allow that generically. But I clearly remember that this was
> > requested
> > to make statx() work with these sandboxes. So the kernel has done
> > its
> > part. Now it's for the sandbox to allow statx() with NULL paths and
> > AT_EMPTY_PATH but certainly not for the kernel to start reenabling
> > old
> > system calls.
>=20
> Those old system calls are still used.
>=20
> Just enable them.
>=20
> statx isn't the promised land. Existing applications matter. And there
> is absolutely nothing wrong with plain old 'stat' (well, we call it
> "newstat" in the kernel for historical reasons) on 64-bit
> architectures.
>=20
> Honestly, 'statx' is disgusting. I don't understand why anybody pushes
> that thing that nobody actually uses or cares about.

Hmm why it was added in the first place then?  Why not just NAK it?  If
someone tries to add a "seccomp sandbox" into my project I'll
immediately NAK it anyway :).

And should we add stat_time64, fstat_time64, and fstatat_time64 to stop
using statx on 32-bit platforms too as it's disgusting?

Also some bad news: Glibc has this:

#if (__WORDSIZE =3D=3D 32 \
     && (!defined __SYSCALL_WORDSIZE || __SYSCALL_WORDSIZE =3D=3D 32)) \
    || defined STAT_HAS_TIME32 \
    || (!defined __NR_newfstatat && !defined __NR_fstatat64)
# define FSTATAT_USE_STATX 1
#else
# define FSTATAT_USE_STATX 0
#endif

So if a LoongArch Glibc is built with Linux kernel headers >=3D 6.11,
it'll use fstatat **even configured --with-kernel=3D5.19** and fail to run
on Linux kernel <=3D 6.10.  This will immediately blow up building Linux
From Scratch on a host distro with an "old" kernel.

<sarcasm>Alright, some Google project matters but Glibc does not matter
because it uses a disgusting syscall in the first place.</sarcasm>

We have to add some __ASSUME_blah_blah here now.

To make things worse Glibc 2.40 is being frozen today :(.  Copying to
libc-alpha and the RM.

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

