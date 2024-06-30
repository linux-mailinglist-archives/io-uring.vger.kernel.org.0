Return-Path: <io-uring+bounces-2393-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 23D9791CFDC
	for <lists+io-uring@lfdr.de>; Sun, 30 Jun 2024 04:40:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 97A512824F8
	for <lists+io-uring@lfdr.de>; Sun, 30 Jun 2024 02:40:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87A5022094;
	Sun, 30 Jun 2024 02:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b="SkPHGBfG"
X-Original-To: io-uring@vger.kernel.org
Received: from xry111.site (xry111.site [89.208.246.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF3E5110A;
	Sun, 30 Jun 2024 02:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.208.246.23
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719715209; cv=none; b=saUKF873CfiN0CmmEqgNKBUaRkLSFraTzm/X10wHDmXxt397Kj+kp7LG2TSTP7Pk+jYAsN9NmDufeTRirKOBTk3VMQxythXErldrVDQORpMZ/GwYCUicHW4/ZR64NBAlOb1HmzXUqg6A4H4GGzVaW9cOITBPbUmSKuSaQuV8Ans=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719715209; c=relaxed/simple;
	bh=tTaUZ3gw2WIKPoFASF97Fsyku9pYLM++iEoIJI+caJg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=h6wRO5L6VAluGF8XYtyJ0flZhvIzUyc7bdMBNlLnL6srbfbTB4W+jjN5mRifi/gSGrZp2QMBDc5ZjAdZ/1aqW0Olq3X0nomm/bZXeI4TSWGyvws8iwyXwthTU3RpiGP15c2VUHtYj30WGA8TGKOfQ+fSplmaqFGTEF5woQ6ZYs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site; spf=pass smtp.mailfrom=xry111.site; dkim=pass (1024-bit key) header.d=xry111.site header.i=@xry111.site header.b=SkPHGBfG; arc=none smtp.client-ip=89.208.246.23
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=xry111.site
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=xry111.site
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=xry111.site;
	s=default; t=1719715200;
	bh=tTaUZ3gw2WIKPoFASF97Fsyku9pYLM++iEoIJI+caJg=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
	b=SkPHGBfG/KPEqzTnuf2n32UERfuZTF/SxB8Ls8HwfbIt/X5Woa2lFrb0BbPdEtDG7
	 z7oOyjPG3QQGC6uuDdm0ytxrzvmZNnCqQT9dJxVwESlZCOJnfaZ0A7VqruL+gMZGg+
	 9yrgk2GnH5duteGDkTImvKGBnaF+4eewZ5RHoxpI=
Received: from [IPv6:240e:358:118a:c500:dc73:854d:832e:2] (unknown [IPv6:240e:358:118a:c500:dc73:854d:832e:2])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-384) server-digest SHA384)
	(Client did not present a certificate)
	(Authenticated sender: xry111@xry111.site)
	by xry111.site (Postfix) with ESMTPSA id 0B0EE66A47;
	Sat, 29 Jun 2024 22:39:55 -0400 (EDT)
Message-ID: <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
From: Xi Ruoyao <xry111@xry111.site>
To: Huacai Chen <chenhuacai@kernel.org>
Cc: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org, 
	viro@zeniv.linux.org.uk, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, axboe@kernel.dk, 
	torvalds@linux-foundation.org, loongarch@lists.linux.dev
Date: Sun, 30 Jun 2024 10:39:51 +0800
In-Reply-To: <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
References: <20240625110029.606032-1-mjguzik@gmail.com>
	 <20240625110029.606032-3-mjguzik@gmail.com>
	 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
	 <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
	 <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.2 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

On Sun, 2024-06-30 at 09:40 +0800, Huacai Chen wrote:
> On Tue, Jun 25, 2024 at 11:00=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> w=
rote:
> >=20
> > On Tue, 2024-06-25 at 22:09 +0800, Huacai Chen wrote:
> > > On Tue, Jun 25, 2024 at 7:01=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.=
com>
> > > wrote:
> > > >=20
> > > > The newly used helper also checks for 0-sized buffers.
> > > >=20
> > > > This avoids path lookup code, lockref management, memory
> > > > allocation
> > > > and
> > > > in case of NULL path userspace memory access (which can be quite
> > > > expensive with SMAP on x86_64).
> > > >=20
> > > > statx with AT_EMPTY_PATH paired with "" or NULL argument as
> > > > appropriate
> > > > issued on Sapphire Rapids (ops/s):
> > > > stock:=C2=A0=C2=A0=C2=A0=C2=A0 4231237
> > > > 0-check:=C2=A0=C2=A0 5944063 (+40%)
> > > > NULL path: 6601619 (+11%/+56%)
> > > >=20
> > > > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> > > Hi, Ruoyao,
> > >=20
> > > I'm a bit confused. Ii this patch a replacement of your recent
> > > patch?
> >=20
> > Yes, both Linus and Christian hates introducing a new AT_ flag for
> > this.
> >=20
> > This patch just makes statx(fd, NULL, AT_EMPTY_PATH, ...) behave
> > like
> > statx(fd, "", AT_EMPTY_PATH, ...) instead.=C2=A0 NULL avoids the
> > performance
> > issue and it's also audit-able by seccomp BPF.
> To be honest, I still want to restore __ARCH_WANT_NEW_STAT. Because
> even if statx() becomes audit-able, it is still blacklisted now.

Then patch the sandbox to allow it.

The sandbox **must** be patched anyway or it'll be broken on all 32-bit
systems after 2037.  [Unless they'll unsupport all 32-bit systems before
2037.]

> Restoring __ARCH_WANT_NEW_STAT is a very small change that doesn't
> introduce any complexity, but it makes life easier. And I think libLoL
> also likes __ARCH_WANT_NEW_STAT, though it isn't an upstream
> project...

At least you should not restore it for 32-bit.  libLoL also has nothing
to do with 32-bit systems anyway.  Maybe conditional it with a #if
checking __BITS_PER_LONG.

And the vendors should really port their software to the upstreamed ABI
instead of relying on liblol.  <rant>Is a recompiling so difficult, or
are the programmers so stupid to invoke plenty of low-level syscalls
directly (bypassing Glibc) in their code?</rant>

--=20
Xi Ruoyao <xry111@xry111.site>
School of Aerospace Science and Technology, Xidian University

