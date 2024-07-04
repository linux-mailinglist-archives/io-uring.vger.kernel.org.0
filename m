Return-Path: <io-uring+bounces-2443-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2D7A7926D86
	for <lists+io-uring@lfdr.de>; Thu,  4 Jul 2024 04:38:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D799C2827AA
	for <lists+io-uring@lfdr.de>; Thu,  4 Jul 2024 02:38:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DE7E23DE;
	Thu,  4 Jul 2024 02:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MsVC5OeC"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30711FC02;
	Thu,  4 Jul 2024 02:38:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720060708; cv=none; b=BXKDhgji4YKVWvZdnnyBIDE+AqigGR8p1U1r7zVHjGdfJiW3L6bLmRYfUR55SiaiShP7yzb5AuXAhK3ODcBs/rqpzaaQ4Go3XRupj0vNa5yBygH1WhcMM2elTzl5HMQ9/jraSSXfjnkEbDkvIgyYl/VJwnpk00TlO2Ibk+POIvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720060708; c=relaxed/simple;
	bh=dqD8gcxvzGAC30RhBldzEPyXDbdO9cKPtLVlOJU46Vg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mDr2JERoVp1lqeo+SM3MGzNgc14edJpUIfw/jL1h9YaRYRX0EG5ViM/frB1SMXQvK+I7fos2dj+G0ih2kO4ChdReGFhg386hAi7vDYtTTc+EV0iI/S/Qg5dBDHBMdHXiEoYfBm3Rgpwf6QAUk6qNW2sC1+g6xsyVfbWMx4TDZdM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MsVC5OeC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C37C4AF0D;
	Thu,  4 Jul 2024 02:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720060707;
	bh=dqD8gcxvzGAC30RhBldzEPyXDbdO9cKPtLVlOJU46Vg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=MsVC5OeCkciPZE06MDGtBxxfhTBeMPlokruBgDHjXYI/zvlZjdnwVhvfoaOu0G8iC
	 Xz6XEEXBAlINrSGvNDkPIMT/r/YQXvxuaI/612dpeooZuCFyMpPhCAAa1TKz0Wwonl
	 mlCQiFJrDQy9+ybI2kT0niGErXo1xbFPO9nSa5xOk0UnxwCvPJeokqrMCa1ueykOiz
	 SQTdhafFXx1irEHPZSqOVMnGbb8Hv8e/dg/6ovKNmihP1CbPjDR+CKHM3iJlMtfYSW
	 xxlOFkkwQCJNsmaGBqQtQ8wGNos8mYtSpgV1prAp9eInwqLpX2iR3jIa5xSKM81LsM
	 0KXoCs/vn/giA==
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52cdf2c7454so193449e87.1;
        Wed, 03 Jul 2024 19:38:27 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUfWKJ9IMAAhirT1IzjMBrO1So4dPObIgQNqXBq/YN3EpDxz7kENfjkWk2I2FyCHSpbAKPxbU329yoWY3KclRR7Y+wM4YEcgFhnvRPOb9/COYng9FIz60+yI+WyU3CpeNPPPHScuqAcUzxvWRXIaYw5oOrrfYgBuyHTj+lFfWX42B5zrH65
X-Gm-Message-State: AOJu0YwhyE1iziIOy4LT5Rnq2meaMLdzkAy7J09amBlTVqmLQqNoeqws
	Q8ueM4oTcId/NmmmHOeiohxEJf3+z/FC1MXQLwAKBLooG4WcMy4d9+If6NezcNUFzkRu3/tvKL3
	C3GAE8F5mY5N2AViTRAUOj+OHA+s=
X-Google-Smtp-Source: AGHT+IGlWtVHzFafltc3+cXuNlzQZe6zYCmHq/oFgcUmqE6OhhxMZJ20wr13jLfRpSRTZFkQ3UL98v488HRHqNzmt+4=
X-Received: by 2002:a05:6512:1595:b0:52b:c33a:aa7c with SMTP id
 2adb3069b0e04-52ea06c95edmr194626e87.65.1720060705933; Wed, 03 Jul 2024
 19:38:25 -0700 (PDT)
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
 <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com> <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
In-Reply-To: <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Thu, 4 Jul 2024 10:38:12 +0800
X-Gmail-Original-Message-ID: <CAAhV-H7vJ69GD5RWOAtVVMAriGX8eVfqSTp_XadV9PTZJuoSAQ@mail.gmail.com>
Message-ID: <CAAhV-H7vJ69GD5RWOAtVVMAriGX8eVfqSTp_XadV9PTZJuoSAQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Xi Ruoyao <xry111@xry111.site>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Christian Brauner <brauner@kernel.org>, 
	libc-alpha@sourceware.org, "Andreas K. Huettel" <dilfridge@gentoo.org>, 
	Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 4, 2024 at 12:54=E2=80=AFAM Xi Ruoyao <xry111@xry111.site> wrot=
e:
>
> On Wed, 2024-07-03 at 09:31 -0700, Linus Torvalds wrote:
> > On Wed, 3 Jul 2024 at 01:46, Christian Brauner <brauner@kernel.org>
> > wrote:
> > >
> > > We've now added AT_EMPTY_PATH support with NULL names because we
> > > want to
> > > allow that generically. But I clearly remember that this was
> > > requested
> > > to make statx() work with these sandboxes. So the kernel has done
> > > its
> > > part. Now it's for the sandbox to allow statx() with NULL paths and
> > > AT_EMPTY_PATH but certainly not for the kernel to start reenabling
> > > old
> > > system calls.
> >
> > Those old system calls are still used.
> >
> > Just enable them.
> >
> > statx isn't the promised land. Existing applications matter. And there
> > is absolutely nothing wrong with plain old 'stat' (well, we call it
> > "newstat" in the kernel for historical reasons) on 64-bit
> > architectures.
> >
> > Honestly, 'statx' is disgusting. I don't understand why anybody pushes
> > that thing that nobody actually uses or cares about.
>
> Hmm why it was added in the first place then?  Why not just NAK it?  If
> someone tries to add a "seccomp sandbox" into my project I'll
> immediately NAK it anyway :).
>
> And should we add stat_time64, fstat_time64, and fstatat_time64 to stop
> using statx on 32-bit platforms too as it's disgusting?
>
> Also some bad news: Glibc has this:
>
> #if (__WORDSIZE =3D=3D 32 \
>      && (!defined __SYSCALL_WORDSIZE || __SYSCALL_WORDSIZE =3D=3D 32)) \
>     || defined STAT_HAS_TIME32 \
>     || (!defined __NR_newfstatat && !defined __NR_fstatat64)
> # define FSTATAT_USE_STATX 1
> #else
> # define FSTATAT_USE_STATX 0
> #endif
>
> So if a LoongArch Glibc is built with Linux kernel headers >=3D 6.11,
> it'll use fstatat **even configured --with-kernel=3D5.19** and fail to ru=
n
> on Linux kernel <=3D 6.10.  This will immediately blow up building Linux
> From Scratch on a host distro with an "old" kernel.
The patch which adds newstat back will CC the stable list and be
backported to old kernels.

Huacai

>
> <sarcasm>Alright, some Google project matters but Glibc does not matter
> because it uses a disgusting syscall in the first place.</sarcasm>
>
> We have to add some __ASSUME_blah_blah here now.
>
> To make things worse Glibc 2.40 is being frozen today :(.  Copying to
> libc-alpha and the RM.
>
> --
> Xi Ruoyao <xry111@xry111.site>
> School of Aerospace Science and Technology, Xidian University

