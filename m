Return-Path: <io-uring+bounces-2419-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 92A4692524E
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 06:30:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 12CC01F231F7
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 04:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2C742260C;
	Wed,  3 Jul 2024 04:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CayMUGTL"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836641863F;
	Wed,  3 Jul 2024 04:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719981020; cv=none; b=ViwAzOhVyH9D7Sqxs+RN7cktEM6b4kfGYz14zpYHDZZy+YKtv2TnZxqtFYH3OxubArgzjsFbFaelEzSz36SVU0D6ROPegzeHaeU2eyVpMyk99f/pfy4vZ94OIxqGfKPIN3D/1Ct/hY4osxNrDdHsDG3dkuRzA6AgFN/ybaDcL8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719981020; c=relaxed/simple;
	bh=2GKTIpADWW0/pDL96WDokG2gG49SMgT/xmRpLpMnRDY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ECccSkASobapAZtIXuOBz8tWp+oZ/lvGezlX6QCCdfGQX3+tjOUIe7P+Wps6RwTdNqE9pBPGon2ypMe7x4S35wG6UoxVmeHECXgidyObQZvUdU19HrmckOutPYkCVscUNxpVI2VJr/+ybo1CvtDK3gk/x3zWA59cakomM/shT+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CayMUGTL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE12C4AF0E;
	Wed,  3 Jul 2024 04:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719981020;
	bh=2GKTIpADWW0/pDL96WDokG2gG49SMgT/xmRpLpMnRDY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=CayMUGTLU1i1ROVcvt5KpmQQwruF+enT8ZTnXHZtajN3U5UmZgqpXr7WDzAuRtAZt
	 uP2GU6OpTGGO6GHAU+5sIlPvMBxf6tFX3J5UOsoM52UZDddtc3Jeqw+OeZl4U2ierS
	 c6CGmHATYvDK+XX2nXe2ef4wa00z/pUr4C6OCj0d8WqDpR8MK69Ou23/XYMaLNvEM7
	 GoH5RWJF/rDcLLFWQZvhBCcbUSxgQusTPOglHJlHsP1kIFmr7fNPDt1LpWoI/g0jfF
	 jGxY/NvBhZroRaVCg4VBOt3KgMK9r7dux0ZzI86aWoU1xyR5Er6rlFoVTPVegs/Nnf
	 fmOsYxCeuQEgA==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a7241b2fe79so538352566b.1;
        Tue, 02 Jul 2024 21:30:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXVy69laUqtKZZesHGgVz7FGYagIKIU3dpIl0OxhTQv0YmLssiIZGBxQtoKr9Y7Xx0nBKkHlwwnn6UaiX1JhEgWRu42fqFTQOKlnuk8N7b8OH8joqmrf3XPgiyOCUb0TA4vApaQMxH34BsjdlYt1qOZ/CsMbnx11oYjfwK++z6P1VTAL4Qj
X-Gm-Message-State: AOJu0Ywseed8t+91haM1SWBpRkWTCGvKOVNb+scXDWCaxmJyvP50xGfu
	K3uG8a1RfXLZ2xPhn0JSTEK+NhZQyQ/kmsuVzdtk1GgZcq8QU8eHrt4qNFwmDqTi5czJPAAT5/3
	1BQ/34dnp6UAjsJmczn0k5/rC9tg=
X-Google-Smtp-Source: AGHT+IFeHMEPJPUo7fR+P58Lug7AIm6CszZI8bK6+5jFh43ov7CVbuKnr6u7wq/pWCfOZMagNaZ95cTwMd8UQq17QmU=
X-Received: by 2002:a17:906:fccc:b0:a72:548a:6f42 with SMTP id
 a640c23a62f3a-a751445451dmr664805266b.18.1719981018671; Tue, 02 Jul 2024
 21:30:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625110029.606032-1-mjguzik@gmail.com> <20240625110029.606032-3-mjguzik@gmail.com>
 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
 <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
 <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
 <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
 <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com> <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
 <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com>
In-Reply-To: <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 3 Jul 2024 12:30:06 +0800
X-Gmail-Original-Message-ID: <CAAhV-H5n-6AjPuMj6sH0T2uSy97LMy3qkimUT13S2Fi-p-6Nug@mail.gmail.com>
Message-ID: <CAAhV-H5n-6AjPuMj6sH0T2uSy97LMy3qkimUT13S2Fi-p-6Nug@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Arnd Bergmann <arnd@arndb.de>
Cc: Xi Ruoyao <xry111@xry111.site>, Mateusz Guzik <mjguzik@gmail.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Linus Torvalds <torvalds@linux-foundation.org>, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 3, 2024 at 1:07=E2=80=AFAM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Tue, Jul 2, 2024, at 17:36, Huacai Chen wrote:
> > On Mon, Jul 1, 2024 at 7:59=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wr=
ote:
> >> On Sun, Jun 30, 2024, at 04:39, Xi Ruoyao wrote:
> >> > On Sun, 2024-06-30 at 09:40 +0800, Huacai Chen wrote:
> >> >> >
> >> >> > Yes, both Linus and Christian hates introducing a new AT_ flag fo=
r
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
> >> > The sandbox **must** be patched anyway or it'll be broken on all 32-=
bit
> >> > systems after 2037.  [Unless they'll unsupport all 32-bit systems be=
fore
> >> > 2037.]
> >>
> >> More importantly, the sandbox won't be able to support any 32-bit
> >> targets that support running after 2037, regardless of how long
> >> the sandbox supports them: if you turn off COMPAT_32BIT_TIME today
> >> in order to be sure those don't get called by accident, the
> >> fallback is immediately broken.
> > Would you mind if I restore newstat for LoongArch64 even if this patch =
exist?
>
> I still prefer not add newstat back: it's easier to
> get applications to correctly implement the statx() code
> path if there are more architectures that only have that.
Yes, we need statx-only architecures to improve statx(), and so this
patch got upstream. But I'm considering bidirectional compatibility,
which means the kernel should work with future patched and existing
un-patched sandboxes. So I think now is the correct time to add
newstat back for LoongArch --- statx() has been improved, and existing
applications want to work on LoongArch.

Huacai

>
>        Arnd

