Return-Path: <io-uring+bounces-2392-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E276191CFD2
	for <lists+io-uring@lfdr.de>; Sun, 30 Jun 2024 03:40:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BA8871C20E39
	for <lists+io-uring@lfdr.de>; Sun, 30 Jun 2024 01:40:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 083C11C02;
	Sun, 30 Jun 2024 01:40:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VDRuQuBd"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE35E10FA;
	Sun, 30 Jun 2024 01:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719711621; cv=none; b=BGertlIzlXD2mVRONHHivE1ScBHnwMB8T6aZdEukvpDiaclwbIsq/raQMsmNMPHv3Oz9KNv+04EC/jaWSwHjLzqwbmyVx4CtLCD8fL0oW5pyBwYUjdQ1/RzFkvn6n9aBPazV79CGVWXKCmJC1RuVw4fRbx1rTwgVNLNcjFRUelM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719711621; c=relaxed/simple;
	bh=iNap5HBMSnlVD0KPm+mMPZ1WW6sv0UckO+oIaAFv4Es=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iRSxqOLPVJmTutAuof6Rk2IJEef07BwDGyE7B/KPH103ku6pbZtX773jb0c09lwW10qQad0yN4iyuRttPiiL7vEG6uxpxIM7ixKfS1YHXg+mpceh1Gpq0Al1Rpi/rrIjxgdmGsdlqDYF5nv5ieHxSPInLkPTMQzLbXWa9b2lVqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VDRuQuBd; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63B84C4AF0F;
	Sun, 30 Jun 2024 01:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719711621;
	bh=iNap5HBMSnlVD0KPm+mMPZ1WW6sv0UckO+oIaAFv4Es=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VDRuQuBdmWSNUG0p9TEYmwgO8vceogDlAsN/9I7djKwznIcLJKPIokfkEfj9C6hYW
	 zBJWjJJzzrxwsWNGG11M1zhtYi7eT9gDc2HDq0/6nwm9LzkaPWqpVWv8zh60KBCyHO
	 VnJft4926JpjIX4lvHtwbeURwbGBSLmrg8xUWS3chJP0XvUM4Iu6wPsXoX08nnEWDF
	 Uhu+z2adw7xUaVCeg+MaD21J4s4cyRiOqu6tvLuxMdV74GAzHCGjchubsW4JGU/N8Q
	 4z/fLEq/fnhW3rFLSxgK6D/Jly/nKD+9CDmKasFjZ1oEzQtgp72IzH8C/mFzPI2Hh9
	 M7F9GKIqZG6RQ==
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-57d07f07a27so2072803a12.3;
        Sat, 29 Jun 2024 18:40:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWM8WwwrVCM3s3EDnURhHENuGcwO+8qzEnKTruxET6NMnQXpL6f3K4zyz/bOU4iFLfDkyqT19AQ+6yqJ1lkXxn3hR6mLPJgSkLN6Vp2NTdjx9q8ZA+LjTA6R/FApjhU5424MTDca0yBVEvcVTJzbpuzFzbw66fzdCMpCKrKii10P19Ha2LS
X-Gm-Message-State: AOJu0Yxdrm1W3GK7WCwKTWv/0Uj07WmULnTwfQGogRFVcUFFWN3C8W5p
	KqGO+jXIa8/4NzgtCA88b3vfqgirypy1UjEQSIJq2peLm6LNgyFTPcUtBXczjaYvYdE/QdT3PPh
	nBbP4EKNUlZW2IuNuHHJpkfPnfmU=
X-Google-Smtp-Source: AGHT+IHELchvZkUDM0gI/T7Dy8HOavqUo6omt0Xb/fES63/IMGcpC07W29tDyBkbIxm/5hTT4NcaCWq6V+/H5dqr+9M=
X-Received: by 2002:a17:907:3f29:b0:a6f:1839:ed40 with SMTP id
 a640c23a62f3a-a7514512dfdmr160832766b.73.1719711619816; Sat, 29 Jun 2024
 18:40:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625110029.606032-1-mjguzik@gmail.com> <20240625110029.606032-3-mjguzik@gmail.com>
 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com> <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
In-Reply-To: <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Sun, 30 Jun 2024 09:40:08 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
Message-ID: <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Xi Ruoyao <xry111@xry111.site>
Cc: Mateusz Guzik <mjguzik@gmail.com>, brauner@kernel.org, viro@zeniv.linux.org.uk, 
	jack@suse.cz, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, axboe@kernel.dk, torvalds@linux-foundation.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2024 at 11:00=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> wro=
te:
>
> On Tue, 2024-06-25 at 22:09 +0800, Huacai Chen wrote:
> > On Tue, Jun 25, 2024 at 7:01=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.co=
m>
> > wrote:
> > >
> > > The newly used helper also checks for 0-sized buffers.
> > >
> > > This avoids path lookup code, lockref management, memory allocation
> > > and
> > > in case of NULL path userspace memory access (which can be quite
> > > expensive with SMAP on x86_64).
> > >
> > > statx with AT_EMPTY_PATH paired with "" or NULL argument as
> > > appropriate
> > > issued on Sapphire Rapids (ops/s):
> > > stock:     4231237
> > > 0-check:   5944063 (+40%)
> > > NULL path: 6601619 (+11%/+56%)
> > >
> > > Signed-off-by: Mateusz Guzik <mjguzik@gmail.com>
> > Hi, Ruoyao,
> >
> > I'm a bit confused. Ii this patch a replacement of your recent patch?
>
> Yes, both Linus and Christian hates introducing a new AT_ flag for this.
>
> This patch just makes statx(fd, NULL, AT_EMPTY_PATH, ...) behave like
> statx(fd, "", AT_EMPTY_PATH, ...) instead.  NULL avoids the performance
> issue and it's also audit-able by seccomp BPF.
To be honest, I still want to restore __ARCH_WANT_NEW_STAT. Because
even if statx() becomes audit-able, it is still blacklisted now.
Restoring __ARCH_WANT_NEW_STAT is a very small change that doesn't
introduce any complexity, but it makes life easier. And I think libLoL
also likes __ARCH_WANT_NEW_STAT, though it isn't an upstream
project...

Huacai

>
> --
> Xi Ruoyao <xry111@xry111.site>
> School of Aerospace Science and Technology, Xidian University
>

