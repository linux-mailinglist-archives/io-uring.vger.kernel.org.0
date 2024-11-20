Return-Path: <io-uring+bounces-4862-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 90D059D3B14
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 13:49:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E0261F26465
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 12:49:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A761A0AEA;
	Wed, 20 Nov 2024 12:48:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21F91A4E9D;
	Wed, 20 Nov 2024 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732106904; cv=none; b=Y2gg4fFJ9tXDPi4Xd05wMlRGm2uKp99NvZ6FVXOWs7h/Bl5HzbwOd51X3HKg0lFjNZgPry1r41+9ijQreD9ZzFjP4xnjvJh7z0dK+m28YL5LhG046OThigXm8FPzAZHib6v9ALC2MYWTShph8NF28VF4gSI/uwDAD20YkFkpGaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732106904; c=relaxed/simple;
	bh=PkiNUIlmf4+IlrYzOyjSOvZnWhclC/pG3mLOkDNQvU4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QjmCmE66nLmon1Suxe30Poh9a1ZvDocPorMplxt/LJOWQMzDBiyZd2umEr7seHbkMBggQKoDHhaPDvmsIXTwDD4m7BfZz8jmoPPzYS3tMmzjcgsmLHCusfTQWdmLLZKUpx0d8At39dhH2BS+hmevdFCriUGO4G4Vaw2e+mrssno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6e377e4aea3so33062277b3.3;
        Wed, 20 Nov 2024 04:48:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732106900; x=1732711700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2E0lxeHc7zWSGry84JM/MNKrxDd/HDpJgzw+Kihiymw=;
        b=VuQoQ6NJhXkksyTGmLftbKOxlohZ+4ipxfDcYfov+HUTOidgp9yjv02xvz51Sj29p+
         LPzpjhsYr0+q2yn59rqYQD+t+VhkHIiPjMRhaLCH0x7C/M6l09xkFT82ct40GFrRE2+Y
         WnWvj5CFyjU1Rk8oVmjVnNgilhv8JjP3Cqhe6ncZ8/c+QD/+MC9qLPeUAXJ7ORbDMIUD
         7xwTX8hkvvOLdI9WZBp9r0rHtL1hAORFY+MVYiEL73b9zJIGHlpMtxonUOa5Fo5pOXHl
         94l/Xjwodq3XS6kCQh34UrVSqHwJOwWoeVpLxQWpHxAXjih9DMRmCbVvm5Dj40kO7Gj/
         o3sg==
X-Forwarded-Encrypted: i=1; AJvYcCWBaiMIpGY6mEZrseTwdVuTZifcaktykw5/5VdjLPror1LbJHZyOUiQD6Q5C5vyyHZkRfgLdauZeg==@vger.kernel.org, AJvYcCWZJArU1JCuIlemv54st86jMoqAV/nHaFo2uPtQtfqTKOOdulsbgcOuMsqSyAyLRdHXSNkcaJKg8nwGuQL7@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6P4xGwZdFm2KUwbjUl+ntVUQKmAH0Wkx29+UpoUKHjpDMWdpd
	pgsQfuywcxCH/YhB5yuBHrwEswkIYX63dWJ2+y6VQRpj0YGuPZHLnX92aHei
X-Google-Smtp-Source: AGHT+IH8bQUHwDFDD+At9abflw/yci1ICrgqo60dhu0+n8qmAL52CLjPE1zxNwtDf2qnElGP9+bn8A==
X-Received: by 2002:a05:690c:6a04:b0:6ee:baf1:d255 with SMTP id 00721157ae682-6eebd2e54d9mr27580727b3.42.1732106900009;
        Wed, 20 Nov 2024 04:48:20 -0800 (PST)
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com. [209.85.128.178])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6ee71364debsm22123157b3.103.2024.11.20.04.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 04:48:19 -0800 (PST)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-6e377e4aea3so33061857b3.3;
        Wed, 20 Nov 2024 04:48:18 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXPavBp1HPPQMAEG2vcqhf72UK6vi2Z2LeQWLdczvShd3XeOuNWyScgLZqLeJUkgiTdrKEkD/LL1A==@vger.kernel.org, AJvYcCXlJjHaRKbqFhbQ9uVfQYMwdmgh7tEt7mwCM21wuKldj5Y3uG2ySI5my+vy9TfvRXwM8cWGGZbJgLCjPjZz@vger.kernel.org
X-Received: by 2002:a05:690c:688c:b0:6e7:e3b1:8cc7 with SMTP id
 00721157ae682-6eebd17fe40mr29088887b3.22.1732106898570; Wed, 20 Nov 2024
 04:48:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029152249.667290-1-axboe@kernel.dk> <d4e5a858-1333-4427-a470-350c45b78733@kernel.dk>
 <ffc9d82d-fedf-4253-bbc1-c70c339c8b23@roeck-us.net> <CAMuHMdVAnJ8Tczm1=c=HOiWMZrNk0i_c1guUoqQbJRmdaXqPGw@mail.gmail.com>
 <5a7528c4-4391-4bd9-bbdb-a0247f3c76a9@kernel.dk> <CAMuHMdX9rHUQYn34_Hz=3TKjbFqzenoDCdwt-Mqk1qXJiG4=Zg@mail.gmail.com>
 <5851cd28-b369-4c09-876c-62c4a47c5982@kernel.dk> <CAMuHMdX3iOVLN-rJSqvKSjrjTTf++PJ4e-wPsEX-3QJR3=eWOA@mail.gmail.com>
 <358710e8-a826-46df-9846-5a9e0f7c6851@kernel.dk> <CAMuHMdUsj9FsX=_rHwYjiXT8RehP6HW5hUL9LMvE0pt7Z8kc8w@mail.gmail.com>
 <82b97543-ad01-4e42-b79c-12d97c1df194@kernel.dk> <4623f30c-a12e-4ba6-ad99-835764611c67@kernel.dk>
 <47a16a83-52c7-4779-9ed3-f16ea547b9f0@roeck-us.net> <6c3d73a5-b5ef-455f-92db-e6b96ef22fba@kernel.dk>
 <CAMuHMdVpaxVPy3Tyx-kc0FRqqPGkcDwQPS4deO9SLdY7wCPthA@mail.gmail.com>
 <8b95a694-ecd4-4b6d-8032-049894dec2c1@suse.cz> <CAMuHMdWU=69MtTxYXKGm2xZOyTvbUuxsqBWRSyMcp_H8VNEJ0g@mail.gmail.com>
 <a99c14c2-6351-4449-ac7c-b1cf9bb2c4ff@suse.cz>
In-Reply-To: <a99c14c2-6351-4449-ac7c-b1cf9bb2c4ff@suse.cz>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 20 Nov 2024 13:48:06 +0100
X-Gmail-Original-Message-ID: <CAMuHMdXGsHs=i19+4UJ2Nv=Po4aXxcJb3b=houmRN=cuWQHoCw@mail.gmail.com>
Message-ID: <CAMuHMdXGsHs=i19+4UJ2Nv=Po4aXxcJb3b=houmRN=cuWQHoCw@mail.gmail.com>
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Kees Cook <keescook@chromium.org>, Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>, 
	Guenter Roeck <linux@roeck-us.net>, io-uring@vger.kernel.org, 
	linux-m68k <linux-m68k@lists.linux-m68k.org>, Christian Brauner <brauner@kernel.org>, 
	Linux MM <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vlastimil,

On Wed, Nov 20, 2024 at 10:37=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> w=
rote:
> On 11/20/24 10:07, Geert Uytterhoeven wrote:
> >> >> diff --git a/include/linux/io_uring_types.h b/include/linux/io_urin=
g_types.h
> >> >> index 593c10a02144..8ed9c6923668 100644
> >> >> --- a/include/linux/io_uring_types.h
> >> >> +++ b/include/linux/io_uring_types.h
> >> >> @@ -674,7 +674,11 @@ struct io_kiocb {
> >> >>         struct io_kiocb                 *link;
> >> >>         /* custom credentials, valid IFF REQ_F_CREDS is set */
> >> >>         const struct cred               *creds;
> >> >> -       struct io_wq_work               work;
> >> >> +
> >> >> +       union {
> >> >> +               struct io_wq_work       work;
> >> >> +               freeptr_t               freeptr __aligned(sizeof(fr=
eeptr_t));
> >> >
> >> > I'd rather add the __aligned() to the definition of freeptr_t, so it
> >> > applies to all (future) users.
> >> >
> >> > But my main question stays: why is the slab code checking
> >> > IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t)?
> >>
> >> I believe it's to match how SLUB normally calculates the offset if no
> >> explicit one is given, in calculate_sizes():
> >>
> >> s->offset =3D ALIGN_DOWN(s->object_size / 2, sizeof(void *));
> >>
> >> Yes there's a sizeof(void *) because freepointer used to be just that =
and we
> >> forgot to update this place when freepointer_t was introduced (by Jann=
 in
> >> 44f6a42d49350) for handling CONFIG_SLAB_FREELIST_HARDENED. In
> >> get_freepointer() you can see how there's a cast to a pointer eventual=
ly.
> >>
> >> Does m68k have different alignment for pointer and unsigned long or bo=
th are
> >> 2 bytes? Or any other arch, i.e. should get_freepointer be a union wit=
h
> >> unsigned long and void * instead? (or it doesn't matter?)
> >
> > The default alignment for int, long, and pointer is 2 on m68k.
> > On CRIS (no longer supported by Linux), it was 1, IIRC.
> > So the union won't make a difference.
> >
> >> > Perhaps that was just intended to be __alignof__ instead of sizeof()=
?
> >>
> >> Would it do the right thing everywhere, given the explanation above?
> >
> > It depends. Does anything rely on the offset being a multiple of (at
> > least) 4?
> > E.g. does anything counts in multiples of longs (hi BCPL! ;-), or are
> > the 2 LSB used for a special purpose? (cfr. maple_tree, which uses
> > bit 0 (https://elixir.bootlin.com/linux/v6.12/source/include/linux/mapl=
e_tree.h#L46)?
>
> AFAIK no, the goal was just to prevent misaligned accesses. Kees added th=
e:
>
> s->offset =3D ALIGN_DOWN(s->object_size / 2, sizeof(void *));
>
> so maybe he had something else in mind. But I suspect it was just because
> the code already used it elsewhere.
>
> So we might want something like this? But that would be safer for 6.14 so
> I'd suggest the io_uring specific fix meanwhile. Or maybe just add the un=
ion
> with freeptr_t but without __aligned plus the part below that changes
> mm/slab_common.c only, as the 6.13 io_uring fix?

As it seems to work fine with s/sizeof/__alignof/, I have submitted
a patch to just make that change
https://lore.kernel.org/80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544=
.git.geert@linux-m68k.org

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

