Return-Path: <io-uring+bounces-2422-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA1969257E4
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 12:07:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 085A41C255C5
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 10:07:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22DA3142654;
	Wed,  3 Jul 2024 10:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="Tk9vJapg"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE7B13DDA1;
	Wed,  3 Jul 2024 10:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720001263; cv=none; b=Z+zaRmKGtxu0c9hL1jeA6mzA+kdrmJmGonGfJPA5SddfsU8HwffFC367EK2avlyWnExALZH/yMMAKIiPlAGOwltYtEzonWllHuvFSW8ambARUH8BjKsYDZqsuWtzZMcTN+UTI20wleeo+NNSUUwXFrgvDc+fuL5Q++Vs1oTEV+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720001263; c=relaxed/simple;
	bh=7UlRlKdygRNW81tvq9O33mJTHGWQhr7TMDY7lvxWSss=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=O3WNFmpheTzDTfMk21hhTBokh7W4jaeUZBrK6ruhusnL9Tuju2HANh74y33wLbohP3UIFVG4txLlYpme6ABIyq3kYMdElYP5s44SQGAKbw2IZytiGMGfEIsRJ2xlaW6Vq6BoC4tU+CdqGJ75AjzT3C1S7wdq53pDi26EKOMC+Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=Tk9vJapg; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1720001254;
	bh=7UlRlKdygRNW81tvq9O33mJTHGWQhr7TMDY7lvxWSss=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=Tk9vJapgRxntpsBHFDGKhfQ45A48E7GRfvSsx8EzZRPkZx25sjEzTz4GgaAu+6rHC
	 pH0VjHxqnK2ky0RFv9T2Uq7jCcutwFpbpdbSxlf7BCknq71q6QaYVSgn41z2sqfuVK
	 haU6BIyc9pQ7BSmu09jzeTD8IBn76zwcigS3y0+E=
Received: from [127.0.0.1] (unknown [IPv6:2001:470:683e::1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id B6A7B6760C;
	Wed,  3 Jul 2024 06:07:31 -0400 (EDT)
Message-ID: <8b4cfe608a23100fee4b227a2610ab662d51d810.camel@xry111.site>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
From: Xi Ruoyao <xry111@xry111.site>
To: Huacai Chen <chenhuacai@kernel.org>, Christian Brauner
 <brauner@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
 linux-kernel@vger.kernel.org,  linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Linus Torvalds
 <torvalds@linux-foundation.org>,  loongarch@lists.linux.dev
Date: Wed, 03 Jul 2024 18:07:29 +0800
In-Reply-To: <CAAhV-H73GpnD4hTGXDdWYBmo+Hs=088tSaVum69=4UyhZoKtOw@mail.gmail.com>
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
	 <CAAhV-H73GpnD4hTGXDdWYBmo+Hs=088tSaVum69=4UyhZoKtOw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Wed, 2024-07-03 at 17:35 +0800, Huacai Chen wrote:
> Hi, Christian,
>=20
> On Wed, Jul 3, 2024 at 4:46=E2=80=AFPM Christian Brauner <brauner@kernel.=
org> wrote:
> >=20
> > On Tue, Jul 02, 2024 at 07:06:53PM GMT, Arnd Bergmann wrote:
> > > On Tue, Jul 2, 2024, at 17:36, Huacai Chen wrote:
> > > > On Mon, Jul 1, 2024 at 7:59=E2=80=AFPM Arnd Bergmann <arnd@arndb.de=
> wrote:
> > > > > On Sun, Jun 30, 2024, at 04:39, Xi Ruoyao wrote:
> > > > > > On Sun, 2024-06-30 at 09:40 +0800, Huacai Chen wrote:
> > > > > > > >=20
> > > > > > > > Yes, both Linus and Christian hates introducing a new AT_ f=
lag for
> > > > > > > > this.
> > > > > > > >=20
> > > > > > > > This patch just makes statx(fd, NULL, AT_EMPTY_PATH, ...) b=
ehave
> > > > > > > > like
> > > > > > > > statx(fd, "", AT_EMPTY_PATH, ...) instead.=C2=A0 NULL avoid=
s the
> > > > > > > > performance
> > > > > > > > issue and it's also audit-able by seccomp BPF.
> > > > > > > To be honest, I still want to restore __ARCH_WANT_NEW_STAT. B=
ecause
> > > > > > > even if statx() becomes audit-able, it is still blacklisted n=
ow.
> > > > > >=20
> > > > > > Then patch the sandbox to allow it.
> > > > > >=20
> > > > > > The sandbox **must** be patched anyway or it'll be broken on al=
l 32-bit
> > > > > > systems after 2037.=C2=A0 [Unless they'll unsupport all 32-bit =
systems before
> > > > > > 2037.]
> > > > >=20
> > > > > More importantly, the sandbox won't be able to support any 32-bit
> > > > > targets that support running after 2037, regardless of how long
> > > > > the sandbox supports them: if you turn off COMPAT_32BIT_TIME toda=
y
> > > > > in order to be sure those don't get called by accident, the
> > > > > fallback is immediately broken.
> > > > Would you mind if I restore newstat for LoongArch64 even if this pa=
tch exist?
> > >=20
> > > I still prefer not add newstat back: it's easier to
> > > get applications to correctly implement the statx() code
> > > path if there are more architectures that only have that.
> >=20
> > I agree.
> >=20
> > We've now added AT_EMPTY_PATH support with NULL names because we want t=
o
> > allow that generically. But I clearly remember that this was requested
> > to make statx() work with these sandboxes. So the kernel has done its
> > part. Now it's for the sandbox to allow statx() with NULL paths and
> > AT_EMPTY_PATH but certainly not for the kernel to start reenabling old
> > system calls.
> Linux distributions don't use latest applications, so they still need
> an out-of-tree kernel patch to restore newstat. Of course they can
> also patch their applications, but patching the kernel is
> significantly easier.
>=20
> So in my opinion LoongArch has completed its task to drive statx()
> improvement

It'll only be finished once the apps are adapted, or they'll stop to
work after 2037 anyway.

I've informed Firefox at
https://bugzilla.mozilla.org/show_bug.cgi?id=3D1673771.  For Google
products I guess someone else will have to do (I'm really unfamiliar
with their things, and they often block my proxy server despite I've
never used the proxy to attack them).

> now restoring newstat is a double-insurance for compatibility.

It may also introduce incompatibility: consider a seccomp sandbox which
does not handle fstat on LoongArch because __NR_fstat is not defined in
the UAPI header.  Now the kernel is updated to provide fstat the sandbox
will be broken: a blocklist sandbox will fail to block fstat and leave a
security hole; a whitelist sandbox will fail to allow fstat and blow up
the app if some runtime library is updated to "take the advantage" of
fstat.

My preference (most preferable to least preferable):

1. Not to add them back at all.  Just let the downstream to patch the
kernel if they must support a broken userspace.
2. Add them back with a configurable option (depending on CONFIG_EXPERT:
the distros are already enabling this anyway), make them documented
clearly as only intended to support a broken userspace and removable in
the future.
3. Add it back only for 64-bit.  Add a #if **now** for ruling it out for
32-bit despite we don't have 32-bit support, to make it clear we'll not
flatter broken userspace anymore when we make the 32-bit port.
<rant>4. Remove seccomp.  Personally I really wish to put this on the
top.</rant>

BTW has anyone tried to use Landlock for those browser sandboxes
instead?


--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

