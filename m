Return-Path: <io-uring+bounces-2394-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D1A591D1C1
	for <lists+io-uring@lfdr.de>; Sun, 30 Jun 2024 15:18:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 79E26B217DB
	for <lists+io-uring@lfdr.de>; Sun, 30 Jun 2024 13:18:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C50F613D880;
	Sun, 30 Jun 2024 13:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hWUgOO+g"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93722200C1;
	Sun, 30 Jun 2024 13:18:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719753521; cv=none; b=joX0v7Rm/x/zPetw6H63GdWYfI9YB+ymumxpuBv7SOnrVxHJNy84EtsSJ2N6CIh+5oCdUc5/7KVJAsPEV5kqzuU/pymHE9QfXSAytlj51fjE2qn26XItMOhFVH0vP8U4eqwDNbAjXgFJmuSvKjUP+Z275ILYmOhBIdE+0tnsQ+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719753521; c=relaxed/simple;
	bh=FJRs+QLA3UuXw3IDsXaaAJ3YUQhbqBMN2G3niJbLHIY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O+1OWBNY3JP0ZoTswONoqRxNmbaodOZgFiyj8J44N6mUjOHRzSVCJxyKtPmXsf3MOrX8XL9PuiRvwTc5qQV/vVpaIVPG8mt+YIKb3eKhw/oBb8jmhslb9mjInuZYU7R5160Bh1PeCDbv7XknzSy6oz6NTv4/xsbuLTNQZqdFUuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hWUgOO+g; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FF5C4AF10;
	Sun, 30 Jun 2024 13:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719753521;
	bh=FJRs+QLA3UuXw3IDsXaaAJ3YUQhbqBMN2G3niJbLHIY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=hWUgOO+g+CSTSlofd7fxbXimU+gLIhXJ1OxAKnpgYbIJ4KY2VaiBiZvbiz8RcbxEq
	 ue8RXYdlG3iIiDtL5TmQR/aFaB8ddlRYC76gupN69TcIywGHb84ep9kpILvwCaSM+I
	 34npRLTu315+Vrnnu+vV0iTxK8G96j8+SncA1PPjLxlqGjpMKX60vMT9gK1fOUAr8S
	 /8CbQg5Yvw4+jjgb3me3i0T0qX43hFWd0IsWDvofEoIN2n9EospIor44YFaL9/t41U
	 YPjVdr8yTVTydQhHbY05u8oUVxT2TVBqcVhEa7rldBd8CqoKab/tNHf5s16Zjunp7U
	 mSXbdthfxLknQ==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-57d26a4ee65so2290748a12.2;
        Sun, 30 Jun 2024 06:18:41 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUYRnaV6aF6r/nnYoEq45qZwexc8Ks5oBX0k3Odiz/XRaCpNyPzpgW18hGJueaUkSlyJpB10TmwWLCQ02DjhhcSCPTbFMEQVFTHOViurONQniOYzrt715/EAcL3Om0S4pYCEaCAlEpc+yMBrytTGKBq6WCCPZZkdqMuOZ5Hzy3a6k5EpZwW
X-Gm-Message-State: AOJu0Yy9gK4VTyIi4jE9RnLYqdGigjII5TGvVEBhUQ/4+Rwr7ZBjPs7K
	GB5E0CWp0JH4OBskPPMs9RrJViM+jXyc4cjRE2IpZwthKb0+45tyHvH2dm4OciCPhBYmkS2gkC6
	SNWZpt/DERLrdZCkvQleAbS2iB+M=
X-Google-Smtp-Source: AGHT+IF3lBKPMxzpHBsJqqcYva7QkzTBDP5ZLA0nE5KiBAVuajy50fWI+fi4TbLxsA0iEv6rlMrNiPsotAnuqtkQYKc=
X-Received: by 2002:a17:906:40d7:b0:a72:5d75:6337 with SMTP id
 a640c23a62f3a-a751447bb1cmr174658766b.53.1719753519682; Sun, 30 Jun 2024
 06:18:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625110029.606032-1-mjguzik@gmail.com> <20240625110029.606032-3-mjguzik@gmail.com>
 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
 <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
 <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com> <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
In-Reply-To: <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 30 Jun 2024 21:18:26 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4XZCb_Yr=5yONmPKuCywGEP0Ncqjy9WEeQqzU31ssMhQ@mail.gmail.com>
Message-ID: <CAAhV-H4XZCb_Yr=5yONmPKuCywGEP0Ncqjy9WEeQqzU31ssMhQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Xi Ruoyao <xry111@xry111.site>, Arnd Bergmann <arnd@arndb.de>
Cc: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org, viro@zeniv.linux.org.uk, 
	jack@suse.cz, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, axboe@kernel.dk, torvalds@linux-foundation.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 30, 2024 at 10:40=E2=80=AFAM Xi Ruoyao <xry111@xry111.site> wro=
te:
>
> On Sun, 2024-06-30 at 09:40 +0800, Huacai Chen wrote:
> > On Tue, Jun 25, 2024 at 11:00=E2=80=AFPM Xi Ruoyao <xry111@xry111.site>=
 wrote:
> > >
> > > On Tue, 2024-06-25 at 22:09 +0800, Huacai Chen wrote:
> > > > On Tue, Jun 25, 2024 at 7:01=E2=80=AFPM Mateusz Guzik <mjguzik@gmai=
l.com>
> > > > wrote:
> > > > >
> > > > > The newly used helper also checks for 0-sized buffers.
> > > > >
> > > > > This avoids path lookup code, lockref management, memory
> > > > > allocation
> > > > > and
> > > > > in case of NULL path userspace memory access (which can be quite
> > > > > expensive with SMAP on x86_64).
> > > > >
> > > > > statx with AT_EMPTY_PATH paired with "" or NULL argument as
> > > > > appropriate
> > > > > issued on Sapphire Rapids (ops/s):
> > > > > stock:     4231237
> > > > > 0-check:   5944063 (+40%)
> > > > > NULL path: 6601619 (+11%/+56%)
> > > > >
> > > > > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> > > > Hi, Ruoyao,
> > > >
> > > > I'm a bit confused. Ii this patch a replacement of your recent
> > > > patch?
> > >
> > > Yes, both Linus and Christian hates introducing a new AT_ flag for
> > > this.
> > >
> > > This patch just makes statx(fd, NULL, AT_EMPTY_PATH, ...) behave
> > > like
> > > statx(fd, "", AT_EMPTY_PATH, ...) instead.  NULL avoids the
> > > performance
> > > issue and it's also audit-able by seccomp BPF.
> > To be honest, I still want to restore __ARCH_WANT_NEW_STAT. Because
> > even if statx() becomes audit-able, it is still blacklisted now.
>
> Then patch the sandbox to allow it.
>
> The sandbox **must** be patched anyway or it'll be broken on all 32-bit
> systems after 2037.  [Unless they'll unsupport all 32-bit systems before
> 2037.]
Yes, but it will not happen immediately.

>
> > Restoring __ARCH_WANT_NEW_STAT is a very small change that doesn't
> > introduce any complexity, but it makes life easier. And I think libLoL
> > also likes __ARCH_WANT_NEW_STAT, though it isn't an upstream
> > project...
>
> At least you should not restore it for 32-bit.  libLoL also has nothing
> to do with 32-bit systems anyway.  Maybe conditional it with a #if
> checking __BITS_PER_LONG.
Agree, but currently LoongArch only support 64bit, so we don't need
#ifdef now (Many Kconfig options also need to depend on 64bit, but
dependencies are removed when LoongArch get upstream).

>
> And the vendors should really port their software to the upstreamed ABI
> instead of relying on liblol.  <rant>Is a recompiling so difficult, or
> are the programmers so stupid to invoke plenty of low-level syscalls
> directly (bypassing Glibc) in their code?</rant>
Unfortunately, libLoL may exist for a very long time. Recompiling
isn't difficult, the real problem is "I have already ported to
LoongArch, why should I port again?".

Huacai

>
> --
> Xi Ruoyao <xry111@xry111.site>
> School of Aerospace Science and Technology, Xidian University
>

