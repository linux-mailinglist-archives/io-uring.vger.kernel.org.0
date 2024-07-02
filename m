Return-Path: <io-uring+bounces-2414-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DC737924285
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 17:37:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A9FB1C21092
	for <lists+io-uring@lfdr.de>; Tue,  2 Jul 2024 15:37:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D08CB1BC062;
	Tue,  2 Jul 2024 15:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IsAWtP/5"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A8D1BBBF7;
	Tue,  2 Jul 2024 15:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719934624; cv=none; b=eUBPLUmIvqa//154zDuBlHHv3QyANVdjZAiI0MDkDY+OLRPcWuUCyCDsm2iIINnlqRumNEiDG1m3CnjXNQrUfujZzRkBxcKHr2fAtMbWipIAn4gTfvWjp0/9I/sBnRuAiljpHCvqwNXF4wLcY//mpb4sVtAuwtqMpo83O4qfxrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719934624; c=relaxed/simple;
	bh=WTGvOz3HRhLyyqq4Zh1ZbWhG2m2SzbOevLYrkdYK0Ac=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AEGpQwFeFge0kf/r6gcobrxHVsc7991C2sonuDYo/Y2L0CmqpNyStzgAhmKX/ca7Qntp3qV7Le317wz3sa6qufvA66yrgl1PEkMiem5kZHE5RXhLtAMYFrc2irQ9OTaHmXb35SfggXFm1HUkDRrQUlPgC9n0Ufw6dqNB1REbH1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IsAWtP/5; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30631C4AF07;
	Tue,  2 Jul 2024 15:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719934624;
	bh=WTGvOz3HRhLyyqq4Zh1ZbWhG2m2SzbOevLYrkdYK0Ac=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IsAWtP/5sywxnJ3K4GhdvT0CoKl6Wx7LlTBWBtriyGsqNoyMg7IhVmk61VqdXFky0
	 T1tgw6GnFa/6AW67rk6Zv5of+0v/ZWvtFtybMOJo5nr9OjNIvvWiphf6h6o1wCpwW3
	 fDnjF7GyUgnYd+W69xW1jKWfQ6lbEv/iYecBfpwh0q2GEG0xqRMlfmxaXx6EBVFOky
	 KLswnROVOBB+nkybbNu8+0OjcDlue3n+kDKRk4zehl49xBfWElFENxsVl2reH2kWvQ
	 ghJ7NPLIAls8pIe2zFxf/JYmZFhJ2pwBw5gp4rJ+xfb3RkpRumMpOS1c1QFHGYSaBW
	 vlP8gw1m8b9MA==
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a754746f3easo84863466b.0;
        Tue, 02 Jul 2024 08:37:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWHrx04RCxaQCulqu03/KMyZg+ucrhs7rGOWL48R4HmxZDhBXqhYx35ATCBSJQvP87dC1OO0HXxfui/7sAp1p1IwGLuqsU6JjmFn3fyB7ZWN+2YVV9/K6XghzPXmQOIYNM3NeTL1Z0jv/fcpS+x9wa8a6TW6jSHJesmP9Adwb5kOmFx4N/H
X-Gm-Message-State: AOJu0Yy+WUbNJoRVJbJvOMaqFwS9d/W8XINWd6jBOtDjUky4LuOptxww
	qFYin6g2OoAq2+7hkFtPLKCOvZW69NoR4Tv2y3//QwH8NdhaEOHKJGW4LUCodTmY4gtBZGP6RyY
	P7nQhP2D2OXk3+MPMNYyvNkJAvW4=
X-Google-Smtp-Source: AGHT+IHbRwTQFTOsGOu8dsXrAJCptQY1MXaOy1rNd3Y3lFjz+6X1PC/qmnx2H22UI1+PZJ+qeXsVVq8MLpI02IBHqk0=
X-Received: by 2002:a17:907:86a0:b0:a5c:eafb:5288 with SMTP id
 a640c23a62f3a-a751448a596mr822072466b.31.1719934622768; Tue, 02 Jul 2024
 08:37:02 -0700 (PDT)
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
 <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site> <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com>
In-Reply-To: <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com>
From: Huacai Chen <chenhuacai@kernel.org>
Date: Tue, 2 Jul 2024 23:36:50 +0800
X-Gmail-Original-Message-ID: <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
Message-ID: <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Arnd Bergmann <arnd@arndb.de>
Cc: Xi Ruoyao <xry111@xry111.site>, Mateusz Guzik <mjguzik@gmail.com>, 
	Christian Brauner <brauner@kernel.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, 
	Linus Torvalds <torvalds@linux-foundation.org>, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi, Arnd,

On Mon, Jul 1, 2024 at 7:59=E2=80=AFPM Arnd Bergmann <arnd@arndb.de> wrote:
>
> On Sun, Jun 30, 2024, at 04:39, Xi Ruoyao wrote:
> > On Sun, 2024-06-30 at 09:40 +0800, Huacai Chen wrote:
> >> >
> >> > Yes, both Linus and Christian hates introducing a new AT_ flag for
> >> > this.
> >> >
> >> > This patch just makes statx(fd, NULL, AT_EMPTY_PATH, ...) behave
> >> > like
> >> > statx(fd, "", AT_EMPTY_PATH, ...) instead.  NULL avoids the
> >> > performance
> >> > issue and it's also audit-able by seccomp BPF.
> >> To be honest, I still want to restore __ARCH_WANT_NEW_STAT. Because
> >> even if statx() becomes audit-able, it is still blacklisted now.
> >
> > Then patch the sandbox to allow it.
> >
> > The sandbox **must** be patched anyway or it'll be broken on all 32-bit
> > systems after 2037.  [Unless they'll unsupport all 32-bit systems befor=
e
> > 2037.]
>
> More importantly, the sandbox won't be able to support any 32-bit
> targets that support running after 2037, regardless of how long
> the sandbox supports them: if you turn off COMPAT_32BIT_TIME today
> in order to be sure those don't get called by accident, the
> fallback is immediately broken.
Would you mind if I restore newstat for LoongArch64 even if this patch exis=
t?

Huacai

>
>       Arnd

