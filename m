Return-Path: <io-uring+bounces-2421-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BB499256E7
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 11:35:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 112CC1F23730
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 09:35:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28F4A13B592;
	Wed,  3 Jul 2024 09:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TGSJE6xa"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05E942A80;
	Wed,  3 Jul 2024 09:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719999320; cv=none; b=Gi7CDEkvkHwbuAZkA5fr+GXqNt1WYMPyg9jFz/4KRv3P1rxKvAqt0vilheEMChpxrfpnxPZ8xODgRV7TjkT1l3+0JtPPJkGpjcdx5chMFZyhT4Sr81G1yP6A5YlpjDx5TVCwnN+GgiSjYpBOTuRhG1gNdxav959Vuc36nzol5MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719999320; c=relaxed/simple;
	bh=9utyNDGxSSJAzHnDo95VfUPSqycOFlqwoCow/1ruUBg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U2ghCdfUp+zMEPbVdr4GJ4Gfs7suEhEwW6bVn91RMuCFS7u1VgpT4RXaN6zt2daiu9cmTjJcK8ngyq3atuJw3vMJ/LzhzqFgwkpAtNRm4AHs05hqdbCKJk3dW1a1l6WSB0wbfajak7OEclCoqLVVKbmijD/LZtUzYp6siOBA1RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TGSJE6xa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7568EC4AF0C;
	Wed,  3 Jul 2024 09:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719999319;
	bh=9utyNDGxSSJAzHnDo95VfUPSqycOFlqwoCow/1ruUBg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TGSJE6xazNzu4YpmkQG9Tkl0T4uAWjzZ00r+ukCKE4ii8SJGuCLnCBQzrDO/txVuO
	 3mseN9DNglmRQxTPL7j2sYd7UGzxYp2wA3V3qpT9jK4GMRz3XcFEPgyt4FNpn7491L
	 ULlbFjTAHv9u2ATzatUXeiqyahRujdba8E3zIINtRs5mXj6uYWQfqWvJlOMNX7xLlh
	 +khhf0XE0afqqq8nfbgieGHihD1UZexNGYFG3Xq1cwJ4/qtDlcNjIn4GC4CSaDOUxf
	 NbP1oaFDsewGZL8sJRe8zntscjhu3d/DI5EqAELP7vrsUTZk3EAsQ0dxEVI9VBQOtO
	 +kZufJyUx48Tg==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-52e97e5a84bso660010e87.2;
        Wed, 03 Jul 2024 02:35:19 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU310/BTdsvjfbeXsdoZUlfvr7qG6gB1Lt3d2Hr6mphfd+3bkoR9bd9owYyxPeDwqaQQ3UuwEozVDWAfQfXl0y2RkSdftQ/6fKLEbBizamVKmQwBghuthk1MFTPkv5sdbfclaPEuH8BmFwNdIGuZ4dqKddPCROnV2ODh16hiFDJ+FqSYDjt
X-Gm-Message-State: AOJu0Yxyr2+qlpDtmxc9fkzxjo0WzxnBe9thsRHeJdlWVWgqJUiBRxgH
	UbilZNYm3wb+amBQsNMs2no5/GRjuUGI+RLgomDIzKW+AOpUxcUgQ7dIV/ZZlvrlVnY852mfxo1
	9AZiPkfKglw/dGovrALCzA27qG2c=
X-Google-Smtp-Source: AGHT+IG0AFZwyGyDveaDQTUgnKi0E5E+y3L7KaoYEFwYlS5KxpppR/H6s1N33wMo5ptrPX9ww1kvMxVmCmMfQiREiTs=
X-Received: by 2002:a05:6512:b9c:b0:52c:dbf9:7e54 with SMTP id
 2adb3069b0e04-52e826892b8mr11809721e87.41.1719999317815; Wed, 03 Jul 2024
 02:35:17 -0700 (PDT)
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
 <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com> <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
In-Reply-To: <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Wed, 3 Jul 2024 17:35:05 +0800
X-Gmail-Original-Message-ID: <CAAhV-H73GpnD4hTGXDdWYBmo+Hs=088tSaVum69=4UyhZoKtOw@mail.gmail.com>
Message-ID: <CAAhV-H73GpnD4hTGXDdWYBmo+Hs=088tSaVum69=4UyhZoKtOw@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Christian Brauner <brauner@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Xi Ruoyao <xry111@xry111.site>, Mateusz Guzik <mjguzik@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Linus Torvalds <torvalds@linux-foundation.org>, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Christian,

On Wed, Jul 3, 2024 at 4:46=E2=80=AFPM Christian Brauner <brauner@kernel.or=
g> wrote:
>
> On Tue, Jul 02, 2024 at 07:06:53PM GMT, Arnd Bergmann wrote:
> > On Tue, Jul 2, 2024, at 17:36, Huacai Chen wrote:
> > > On Mon, Jul 1, 2024 at 7:59=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> =
wrote:
> > >> On Sun, Jun 30, 2024, at 04:39, Xi Ruoyao wrote:
> > >> > On Sun, 2024-06-30 at 09:40 +0800, Huacai Chen wrote:
> > >> >> >
> > >> >> > Yes, both Linus and Christian hates introducing a new AT_ flag =
for
> > >> >> > this.
> > >> >> >
> > >> >> > This patch just makes statx(fd, NULL, AT_EMPTY_PATH, ...) behav=
e
> > >> >> > like
> > >> >> > statx(fd, "", AT_EMPTY_PATH, ...) instead.  NULL avoids the
> > >> >> > performance
> > >> >> > issue and it's also audit-able by seccomp BPF.
> > >> >> To be honest, I still want to restore __ARCH_WANT_NEW_STAT. Becau=
se
> > >> >> even if statx() becomes audit-able, it is still blacklisted now.
> > >> >
> > >> > Then patch the sandbox to allow it.
> > >> >
> > >> > The sandbox **must** be patched anyway or it'll be broken on all 3=
2-bit
> > >> > systems after 2037.  [Unless they'll unsupport all 32-bit systems =
before
> > >> > 2037.]
> > >>
> > >> More importantly, the sandbox won't be able to support any 32-bit
> > >> targets that support running after 2037, regardless of how long
> > >> the sandbox supports them: if you turn off COMPAT_32BIT_TIME today
> > >> in order to be sure those don't get called by accident, the
> > >> fallback is immediately broken.
> > > Would you mind if I restore newstat for LoongArch64 even if this patc=
h exist?
> >
> > I still prefer not add newstat back: it's easier to
> > get applications to correctly implement the statx() code
> > path if there are more architectures that only have that.
>
> I agree.
>
> We've now added AT_EMPTY_PATH support with NULL names because we want to
> allow that generically. But I clearly remember that this was requested
> to make statx() work with these sandboxes. So the kernel has done its
> part. Now it's for the sandbox to allow statx() with NULL paths and
> AT_EMPTY_PATH but certainly not for the kernel to start reenabling old
> system calls.
Linux distributions don't use latest applications, so they still need
an out-of-tree kernel patch to restore newstat. Of course they can
also patch their applications, but patching the kernel is
significantly easier.

So in my opinion LoongArch has completed its task to drive statx()
improvement, now restoring newstat is a double-insurance for
compatibility.

Huacai

