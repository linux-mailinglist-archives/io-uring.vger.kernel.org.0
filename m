Return-Path: <io-uring+bounces-4837-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 815BD9D2DCA
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 19:20:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BD51FB2C6DA
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 17:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A11D1D1F63;
	Tue, 19 Nov 2024 17:50:06 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD491D221A
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 17:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732038606; cv=none; b=g2BN3FqU5vLbm1p0hf4Ftxm4mtbt5G4b3lMYIP3EUhaBI4koYolS6WsokspEhwJm0yEXHYN+1k9I17QtD9oz0YDbxRCbFK2KJlcPtE592M4k/IH0H23RsR7kkYYtbVO8Ak5Rslgl735UE1vTjgcGEAgYYzpAGF0hLLhOJmE7NQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732038606; c=relaxed/simple;
	bh=YuLffPjlkzolbbvK7oUaJDFsKE7I3vrI4tMnIV1pJvg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MmSGV5CXI7V4t2ioyHcav5ycCNjU4eJr7kq8IJTsmsw4Ha4YYWl7G3FMNtpNvkn4n/sMvc8o5UwiPnJLJJG05Dco3iK0iNG7HDUuKnwcEaqN2bFKOJMmx+y+veRGothEHMvluWkiDNbZR7+DqZnP9JCUkwzgeC36HW0LtGObcXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6e9ed5e57a7so35776727b3.1
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 09:50:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732038602; x=1732643402;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=u3/wxsaO5NHGCRTRgvGDqKWCMtaMq/jjMwK+TkxQyxA=;
        b=mhlYAAgFuk8Gej3cVxzw47uhPKYs2klDGzN9D+YtKVoidgCnZDlwNyS9BTHArXwtZW
         gMN4iymT4RWY8EqOln2LKNqEHPG5YPaWbR1B1RVp0+m5M5tw0pPe8GXZkHJpfRVhy2Hg
         rlL+EVQhaYQYBm5/h4P/yPbbdhP7WhXKOeQ1r7Sr8pzs+V4vsNN5uwPQghQ430MzUbVB
         d/7m1DCxDbPjCnNi9bXSG0pIE/wWmP1BXL2g9+pE+fhsYlhO/ZxcvD0nOZEpGmBnV8Ej
         Uzw/2s1FCBj/S/YGCtWCi0gmX5zY6tBV6muQ3eP4TQP7ALeq3pMHJFoGppCakWIOC/yO
         mC0A==
X-Forwarded-Encrypted: i=1; AJvYcCV75tb6HghMKn5vNz4JU/tIBu9Cc4AYWhTR/MiD//Lw1RkmYggDOwXq9S7Hes/U+MhfwDDmsHDlAQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwMWw6YQ4Yd9hf9KE6nbm3xrxbClFNPdMPVx1tzKo0XxPXjbno8
	AOpbk3kcnEULB8lnGuoUQmXEVQj9cIECqNptRVw7qLj0jQ/XkvY+p/A0CQth
X-Google-Smtp-Source: AGHT+IFA5VwncAD00uTnGJk5aJGTtzaftvy5EUY863fq8FFd2bWtOcTWwm4ItrbcQd2Ixx4up4DxYg==
X-Received: by 2002:a05:690c:4c02:b0:6ea:4d3f:df7c with SMTP id 00721157ae682-6ee55a2f4f4mr174889407b3.9.1732038602121;
        Tue, 19 Nov 2024 09:50:02 -0800 (PST)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com. [209.85.128.180])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6ee712c2948sm18084217b3.51.2024.11.19.09.50.01
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 09:50:01 -0800 (PST)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6ee6a2ae6ecso37868257b3.3
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 09:50:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXQ8AhAzIGnPFWZJRd+Sd+CRTmFI9t2+xACnFeCMarP3U3R36miYBtfbwJHDAzUohU+7cOVnnXWhw==@vger.kernel.org
X-Received: by 2002:a05:690c:4:b0:6e0:447:f257 with SMTP id
 00721157ae682-6ee55b7abe8mr171234157b3.22.1732038601182; Tue, 19 Nov 2024
 09:50:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029152249.667290-1-axboe@kernel.dk> <20241029152249.667290-4-axboe@kernel.dk>
 <37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net> <d4e5a858-1333-4427-a470-350c45b78733@kernel.dk>
 <ffc9d82d-fedf-4253-bbc1-c70c339c8b23@roeck-us.net>
In-Reply-To: <ffc9d82d-fedf-4253-bbc1-c70c339c8b23@roeck-us.net>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 19 Nov 2024 18:49:49 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVAnJ8Tczm1=c=HOiWMZrNk0i_c1guUoqQbJRmdaXqPGw@mail.gmail.com>
Message-ID: <CAMuHMdVAnJ8Tczm1=c=HOiWMZrNk0i_c1guUoqQbJRmdaXqPGw@mail.gmail.com>
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
To: Guenter Roeck <linux@roeck-us.net>
Cc: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org, 
	linux-m68k <linux-m68k@lists.linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 19, 2024 at 5:21=E2=80=AFPM Guenter Roeck <linux@roeck-us.net> =
wrote:
> On 11/19/24 08:02, Jens Axboe wrote:
> > On 11/19/24 8:36 AM, Guenter Roeck wrote:
> >> On Tue, Oct 29, 2024 at 09:16:32AM -0600, Jens Axboe wrote:
> >>> Doesn't matter right now as there's still some bytes left for it, but
> >>> let's prepare for the io_kiocb potentially growing and add a specific
> >>> freeptr offset for it.
> >>>
> >>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>
> >> This patch triggers:
> >>
> >> Kernel panic - not syncing: __kmem_cache_create_args: Failed to create=
 slab 'io_kiocb'. Error -22
> >> CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-mac-00971-g158f2=
38aa69d #1
> >> Stack from 00c63e5c:
> >>          00c63e5c 00612c1c 00612c1c 00000300 00000001 005f3ce6 004b904=
4 00612c1c
> >>          004ae21e 00000310 000000b6 005f3ce6 005f3ce6 ffffffea ffffffe=
a 00797244
> >>          00c63f20 000c6974 005ee588 004c9051 005f3ce6 ffffffea 000000a=
5 00c614a0
> >>          004a72c2 0002cb62 000c675e 004adb58 0076f28a 005f3ce6 000000b=
6 00c63ef4
> >>          00000310 00c63ef4 00000000 00000016 0076f23e 00c63f4c 0000001=
0 00000004
> >>          00000038 0000009a 01000000 00000000 00000000 00000000 000020e=
0 0076f23e
> >> Call Trace: [<004b9044>] dump_stack+0xc/0x10
> >>   [<004ae21e>] panic+0xc4/0x252
> >>   [<000c6974>] __kmem_cache_create_args+0x216/0x26c
> >>   [<004a72c2>] strcpy+0x0/0x1c
> >>   [<0002cb62>] parse_args+0x0/0x1f2
> >>   [<000c675e>] __kmem_cache_create_args+0x0/0x26c
> >>   [<004adb58>] memset+0x0/0x8c
> >>   [<0076f28a>] io_uring_init+0x4c/0xca
> >>   [<0076f23e>] io_uring_init+0x0/0xca
> >>   [<000020e0>] do_one_initcall+0x32/0x192
> >>   [<0076f23e>] io_uring_init+0x0/0xca
> >>   [<0000211c>] do_one_initcall+0x6e/0x192
> >>   [<004a72c2>] strcpy+0x0/0x1c
> >>   [<0002cb62>] parse_args+0x0/0x1f2
> >>   [<000020ae>] do_one_initcall+0x0/0x192
> >>   [<0075c4e2>] kernel_init_freeable+0x1a0/0x1a4
> >>   [<0076f23e>] io_uring_init+0x0/0xca
> >>   [<004b911a>] kernel_init+0x0/0xec
> >>   [<004b912e>] kernel_init+0x14/0xec
> >>   [<004b911a>] kernel_init+0x0/0xec
> >>   [<0000252c>] ret_from_kernel_thread+0xc/0x14
> >>
> >> when trying to boot the m68k:q800 machine in qemu.
> >>
> >> An added debug message in create_cache() shows the reason:
> >>
> >> #### freeptr_offset=3D154 object_size=3D182 flags=3D0x310 aligned=3D0 =
sizeof(freeptr_t)=3D4
> >>
> >> freeptr_offset would need to be 4-byte aligned but that is not the
> >> case on m68k.
> >
> > Why is ->work 2-byte aligned to begin with on m68k?!
>
> My understanding is that m68k does not align pointers.

The minimum alignment for multi-byte integral values on m68k is
2 bytes.

See also the comment at
https://elixir.bootlin.com/linux/v6.12/source/include/linux/maple_tree.h#L4=
6

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

