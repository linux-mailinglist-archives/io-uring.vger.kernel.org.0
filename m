Return-Path: <io-uring+bounces-2336-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DCB109168D0
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 15:28:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7D4EA1F231AE
	for <lists+io-uring@lfdr.de>; Tue, 25 Jun 2024 13:28:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E71415ECC8;
	Tue, 25 Jun 2024 13:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ma0ZWeIs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92DA8132111;
	Tue, 25 Jun 2024 13:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719322117; cv=none; b=EI/VeTRBslvPu1F0uKbonJRz8cO07s3pvazX7jzC+932XsbUe0Svv8kkN3leSXJXG2ykAVr6KTVYh2RvW5dQC8LdWHrUcVQNokXKvaqQs8Aekd9+0lFA2JMRqcT05TFD+n7IqR0Ek/IsLrg8RI+F23ZmsiHTOe5CXrNPwkufgg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719322117; c=relaxed/simple;
	bh=z9OmWM3s1K1ncuEuDaWGd5+40KI3CtsDflUO9C7WTmw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n3wYspH3MxbUCBXKqSmqQP2/pAC0qbhEJNuczvmDf9X/e0NFFNA+jz0iHazcqfAZeIRATbpPjFFv/+bL3hq49wdz4OVie445LGPoCt6DeLTtMpyiLdm89zHSw3IvKorv6k3yDmFdIOahbbgIHGNb0vhZTEuyso7hi9VBWoWuiCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ma0ZWeIs; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a689ad8d1f6so715861866b.2;
        Tue, 25 Jun 2024 06:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719322114; x=1719926914; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=twrq3YnBSjJhRTnvJDFrfdhu7ZaNu/NjtYoaAMWAVO0=;
        b=ma0ZWeIsHHqsCuoF1a/CB4UiKaonOpcXK8FNVcEHfKicuLPNZlGow1l3WKOjF4K3hB
         YCrWp0udo0/8GjP+kjVGN6kwb3a3QEXz1aDYQEtjBUVgC8OGxgWFuqgyTjmnrc7+BI7Y
         qW74eH7jzFxoiPY+e0FznyO8SVlqpU0CCfjRddBsVzSFfJLXi8w5gLUanjiUQvojk3HX
         NwD6cr+/nRM6lC70k29vswnlDbTO4ApinV9rKXTeYglodvkNAK2b3GAMb6hbbn4hax8z
         IcDPGZ4rwF75DN03pyno9UYuX1t2QN7iewQU7O8jPwrzyTEe3zAwx4kgLY6a4tb7kilz
         h9ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719322114; x=1719926914;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=twrq3YnBSjJhRTnvJDFrfdhu7ZaNu/NjtYoaAMWAVO0=;
        b=ONM+fs/sx8iwDkKdwYxME7cP+W8YBKYg62ExErVmYLsXaHBEc/Vv6dgsZSwaoZdZHZ
         mQX4NlMaPRYybP9uHy3q4CcOZarrpg23q1v79ozrNQgJX7bTKb5Rz/sYEeY/GDwRrr9u
         zrhucPsaDPYEwxdbXDlRIUJu2Mwc4ndJrWH+Nen4PnV180PsXrhrckLQVJ1DbJSRtsuD
         KPa4RpeINVyE2R2eBmifq3tcoW53rldqGwQ4r8FAgN0sJkvShYPQPXs1vha95B3dbgCc
         43PJo3ZBQqBF0H7okwNglWHnDrFybtmTgPqmlLkzgAUIKhrKwAa+id7dHVvESVXUrC2H
         8muQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwJRKVdzh5wMYjgbnMuXjQ3xXPx1ogUHuZsLyriBczWN/EkB5YNofnEr9AMMTmxlMEXv3A8NJd1sFbs9O/JNKWCnqkqUsLXMo0KURKtN0B4H5bqfkNJmsQvcbiNwt7p3JLcy7s1j8sUQ+0TX+a3gLTuETCSgYbfR11aPC8ZSEuq1lhGroF
X-Gm-Message-State: AOJu0YxIwAS8LQ9fGtk5w4/1yfKPT+SDPdGZcefwBue2JHkbOSqU74RW
	Zk6JZQsYmoJWzOKTKSaLs2T6YvReA8OwSqgpCiJBbqqPV5SFJxHADmE6lxscIiHPvYHaFib4gEI
	xTXWw+0ZRnEvse/98JUSjNO2KLJaqY7Wy
X-Google-Smtp-Source: AGHT+IGC9qUNP5wS0HfWpa9ydA0hwYy4dB0Lp0WzcrwuUkaDrU+VycUa7Tkz3Bvd4nc/Igdf+rsu8XiUACdnZ7+e9Gs=
X-Received: by 2002:a17:906:714c:b0:a72:40cc:22cb with SMTP id
 a640c23a62f3a-a7245ccdda4mr460752366b.21.1719322113633; Tue, 25 Jun 2024
 06:28:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625110029.606032-1-mjguzik@gmail.com> <20240625110029.606032-3-mjguzik@gmail.com>
 <fa1a8a0b01cd8c53d290cf431b9c1ffc6305ef0d.camel@xry111.site>
In-Reply-To: <fa1a8a0b01cd8c53d290cf431b9c1ffc6305ef0d.camel@xry111.site>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Tue, 25 Jun 2024 15:28:20 +0200
Message-ID: <CAGudoHHn+N2oUJH9DE86gDFxntV46CxrLtC7=B6dTOjxM4mQOA@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Xi Ruoyao <xry111@xry111.site>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, axboe@kernel.dk, torvalds@linux-foundation.org, 
	loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2024 at 3:24=E2=80=AFPM Xi Ruoyao <xry111@xry111.site> wrot=
e:
>
> On Tue, 2024-06-25 at 13:00 +0200, Mateusz Guzik wrote:
> > +     if (flags =3D=3D AT_EMPTY_PATH && vfs_empty_path(dfd, filename))
>
> Could it be
>
> if ((flags & AT_EMPTY_PATH) && vfs_empty_path(dfd, filename))
>
> instead?
>
> When fstatat is implemented with statx AT_NO_AUTOMOUNT is needed, or at
> least Glibc developers think it's needed:
>
> #if FSTATAT_USE_STATX
>
> static inline int
> fstatat64_time64_statx (int fd, const char *file, struct __stat64_t64 *bu=
f,
>             int flag)
> {
>   /* 32-bit kABI with default 64-bit time_t, e.g. arc, riscv32.   Also
>      64-bit time_t support is done through statx syscall.  */
>   struct statx tmp;
>   int r =3D INTERNAL_SYSCALL_CALL (statx, fd, file, AT_NO_AUTOMOUNT | fla=
g,
>                  STATX_BASIC_STATS, &tmp);
>
> so "flags =3D=3D AT_EMPTY_PATH" won't be true if Glibc implements fstatat
> and fstat via statx (on LoongArch and 32-bit platforms).
>
> I was just surprised when I saw a 100%+ improve for statx("",
> AT_EMPTY_PATH) but not stat on the Loongson machine.
>

It can't be like that specifically because we still need to catch
bogus AT flags.

I'm going to poke a little bit and send a v2, thanks.

--=20
Mateusz Guzik <mjguzik gmail.com>

