Return-Path: <io-uring+bounces-4843-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7EB779D2ECE
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 20:25:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 40128283D95
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 19:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F0518528E;
	Tue, 19 Nov 2024 19:25:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E451487E5
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 19:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732044350; cv=none; b=BH/R7WkLcRfh3F3GHkVsyjWeuUZQo8UG1MakLGSe3z2LVqTaT/fGcAJkgczB6xqhD3AURFm/RwkHo3I0XonsVDFZeLcgrwfAlh3V1OryrA6D11WG9Wobc8KJlf3wVwJMMjCm/QVa99dSBA4ciCfe7EDgY/EXyr5nnoUzPm3sglY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732044350; c=relaxed/simple;
	bh=91gCWEOlgIIYjJM+CltzTRz7uwp/mCZquj6PH9WvNws=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AU4OHmyj2VqfPw9qUCb/dfJbLpjge9NtOgMX8u8iZ2U/FP0Xn8+gljvWqbG8LfillURheYzZV9kzFG/DVCkJvQyyvnsW2fZsvPqWD9Zp0P0tMG8QPyKHa4ODkqFbeRRaSAu2Kb8aEVHIEL//rkQykMRqSroR5LZxCw68QfO6yXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-6eeb2680092so9965267b3.1
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 11:25:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732044346; x=1732649146;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tB0xtARoGk/cOv8iOCQMgtlJGJSW/ZsURIEMIMOoSSU=;
        b=Rzq2C0Gfgd4T+XetxzS51v7GZZ4555nPOhh6RtgKb14eJfybHjfmlrnXoaPiyaTr6B
         Obg9lRj7/DY8Qbi2bP0hU+9a7aDhRK2p6lXRp+DlriRyajnrMy6RTjULXgSdqrbFPOB7
         r2Nxv0THNh1UWcBUaWCm6ugTHuGKKFHHvb4kOqEV9bVCBX/xGE8s7QdGQygFrhNU90pJ
         rqz6Cb1j0Gb6A1qEmoLE5H/TbogmtxmMM6HN4Eh4AXNGimrWLenS9z+oEcqvQgkklklg
         4XqPd/gevP8vrYTRnn/NbwiXUE2I860pMZ6QzJYAgz3xA7pwiyya/JpzoB7vpWWlPT8g
         6Q8w==
X-Forwarded-Encrypted: i=1; AJvYcCWn3oD6eCbBK80ccsO6DRCBfupvF4smZtCJPjHCRGwAIikm5CG/h4i9iZoKC85DI6FHlCsKl0IcNQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxI1WJDwU4P8HRIYdkUAPuQLdaUAApcGetd7MRiUVIIlxlgujyM
	w+xWYuBiGXUDzIXmUGkc5lJcjBHq3Y8tNno+W9E8uGaCaCYyHWSQEjPGYID/
X-Google-Smtp-Source: AGHT+IF90JYM5vpLBhWHaRYrC5vAH1T7W/HkM0CheoLIX7uAF0ye6PqMNDfuYYUJNGIqstOpU9NvKw==
X-Received: by 2002:a05:690c:6c87:b0:6ee:8711:1b1a with SMTP id 00721157ae682-6eebd0e6421mr627497b3.8.1732044346545;
        Tue, 19 Nov 2024 11:25:46 -0800 (PST)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6ee7129c735sm19049077b3.35.2024.11.19.11.25.45
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 11:25:46 -0800 (PST)
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-e38b2d868c8so1752453276.1
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 11:25:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVn9C00dzNetikLrmznrN4CqVKQYBhjaGxxFcI1AuXFG0BLgMSrRlVHV2862NVVdu0gCoDPMl+3dw==@vger.kernel.org
X-Received: by 2002:a05:690c:688c:b0:6ee:988b:16d4 with SMTP id
 00721157ae682-6eebd2a5e8emr186767b3.29.1732044345388; Tue, 19 Nov 2024
 11:25:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029152249.667290-1-axboe@kernel.dk> <20241029152249.667290-4-axboe@kernel.dk>
 <37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net> <d4e5a858-1333-4427-a470-350c45b78733@kernel.dk>
 <ffc9d82d-fedf-4253-bbc1-c70c339c8b23@roeck-us.net> <CAMuHMdVAnJ8Tczm1=c=HOiWMZrNk0i_c1guUoqQbJRmdaXqPGw@mail.gmail.com>
 <5a7528c4-4391-4bd9-bbdb-a0247f3c76a9@kernel.dk> <CAMuHMdX9rHUQYn34_Hz=3TKjbFqzenoDCdwt-Mqk1qXJiG4=Zg@mail.gmail.com>
 <5851cd28-b369-4c09-876c-62c4a47c5982@kernel.dk>
In-Reply-To: <5851cd28-b369-4c09-876c-62c4a47c5982@kernel.dk>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 19 Nov 2024 20:25:33 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX3iOVLN-rJSqvKSjrjTTf++PJ4e-wPsEX-3QJR3=eWOA@mail.gmail.com>
Message-ID: <CAMuHMdX3iOVLN-rJSqvKSjrjTTf++PJ4e-wPsEX-3QJR3=eWOA@mail.gmail.com>
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
To: Jens Axboe <axboe@kernel.dk>
Cc: Guenter Roeck <linux@roeck-us.net>, io-uring@vger.kernel.org, 
	linux-m68k <linux-m68k@lists.linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jens,

On Tue, Nov 19, 2024 at 8:10=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> On 11/19/24 12:02 PM, Geert Uytterhoeven wrote:
> > On Tue, Nov 19, 2024 at 8:00?PM Jens Axboe <axboe@kernel.dk> wrote:
> >> On 11/19/24 10:49 AM, Geert Uytterhoeven wrote:
> >>> On Tue, Nov 19, 2024 at 5:21?PM Guenter Roeck <linux@roeck-us.net> wr=
ote:
> >>>> On 11/19/24 08:02, Jens Axboe wrote:
> >>>>> On 11/19/24 8:36 AM, Guenter Roeck wrote:
> >>>>>> On Tue, Oct 29, 2024 at 09:16:32AM -0600, Jens Axboe wrote:
> >>>>>>> Doesn't matter right now as there's still some bytes left for it,=
 but
> >>>>>>> let's prepare for the io_kiocb potentially growing and add a spec=
ific
> >>>>>>> freeptr offset for it.
> >>>>>>>
> >>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>>>
> >>>>>> This patch triggers:
> >>>>>>
> >>>>>> Kernel panic - not syncing: __kmem_cache_create_args: Failed to cr=
eate slab 'io_kiocb'. Error -22
> >>>>>> CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-mac-00971-g1=
58f238aa69d #1
> >>>>>> Stack from 00c63e5c:
> >>>>>>          00c63e5c 00612c1c 00612c1c 00000300 00000001 005f3ce6 004=
b9044 00612c1c
> >>>>>>          004ae21e 00000310 000000b6 005f3ce6 005f3ce6 ffffffea fff=
fffea 00797244
> >>>>>>          00c63f20 000c6974 005ee588 004c9051 005f3ce6 ffffffea 000=
000a5 00c614a0
> >>>>>>          004a72c2 0002cb62 000c675e 004adb58 0076f28a 005f3ce6 000=
000b6 00c63ef4
> >>>>>>          00000310 00c63ef4 00000000 00000016 0076f23e 00c63f4c 000=
00010 00000004
> >>>>>>          00000038 0000009a 01000000 00000000 00000000 00000000 000=
020e0 0076f23e
> >>>>>> Call Trace: [<004b9044>] dump_stack+0xc/0x10
> >>>>>>   [<004ae21e>] panic+0xc4/0x252
> >>>>>>   [<000c6974>] __kmem_cache_create_args+0x216/0x26c
> >>>>>>   [<004a72c2>] strcpy+0x0/0x1c
> >>>>>>   [<0002cb62>] parse_args+0x0/0x1f2
> >>>>>>   [<000c675e>] __kmem_cache_create_args+0x0/0x26c
> >>>>>>   [<004adb58>] memset+0x0/0x8c
> >>>>>>   [<0076f28a>] io_uring_init+0x4c/0xca
> >>>>>>   [<0076f23e>] io_uring_init+0x0/0xca
> >>>>>>   [<000020e0>] do_one_initcall+0x32/0x192
> >>>>>>   [<0076f23e>] io_uring_init+0x0/0xca
> >>>>>>   [<0000211c>] do_one_initcall+0x6e/0x192
> >>>>>>   [<004a72c2>] strcpy+0x0/0x1c
> >>>>>>   [<0002cb62>] parse_args+0x0/0x1f2
> >>>>>>   [<000020ae>] do_one_initcall+0x0/0x192
> >>>>>>   [<0075c4e2>] kernel_init_freeable+0x1a0/0x1a4
> >>>>>>   [<0076f23e>] io_uring_init+0x0/0xca
> >>>>>>   [<004b911a>] kernel_init+0x0/0xec
> >>>>>>   [<004b912e>] kernel_init+0x14/0xec
> >>>>>>   [<004b911a>] kernel_init+0x0/0xec
> >>>>>>   [<0000252c>] ret_from_kernel_thread+0xc/0x14
> >>>>>>
> >>>>>> when trying to boot the m68k:q800 machine in qemu.
> >>>>>>
> >>>>>> An added debug message in create_cache() shows the reason:
> >>>>>>
> >>>>>> #### freeptr_offset=3D154 object_size=3D182 flags=3D0x310 aligned=
=3D0 sizeof(freeptr_t)=3D4
> >>>>>>
> >>>>>> freeptr_offset would need to be 4-byte aligned but that is not the
> >>>>>> case on m68k.
> >>>>>
> >>>>> Why is ->work 2-byte aligned to begin with on m68k?!
> >>>>
> >>>> My understanding is that m68k does not align pointers.
> >>>
> >>> The minimum alignment for multi-byte integral values on m68k is
> >>> 2 bytes.
> >>>
> >>> See also the comment at
> >>> https://elixir.bootlin.com/linux/v6.12/source/include/linux/maple_tre=
e.h#L46
> >>
> >> Maybe it's time we put m68k to bed? :-)
> >>
> >> We can add a forced alignment ->work to be 4 bytes, won't change
> >> anything on anything remotely current. But does feel pretty hacky to
> >> need to align based on some ancient thing.
> >
> > Why does freeptr_offset need to be 4-byte aligned?
>
> Didn't check, but it's slab/slub complaining using a 2-byte aligned
> address for the free pointer offset. It's explicitly checking:
>
>         /* If a custom freelist pointer is requested make sure it's sane.=
 */
>         err =3D -EINVAL;
>         if (args->use_freeptr_offset &&
>             (args->freeptr_offset >=3D object_size ||
>              !(flags & SLAB_TYPESAFE_BY_RCU) ||
>              !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t))))
>                 goto out;

It is not guaranteed that alignof(freeptr_t) >=3D sizeof(freeptr_t)
(free_ptr is sort of a long). If freeptr_offset must be a multiple of
4 or 8 bytes,
the code that assigns it must make sure that is true.

I guess this is the code in fs/file_table.c:

    .freeptr_offset =3D offsetof(struct file, f_freeptr),

which references:

    include/linux/fs.h:           freeptr_t               f_freeptr;

I guess the simplest solution is to add an __aligned(sizeof(freeptr_t))
(or __aligned(sizeof(long)) to the definition of freeptr_t:

    include/linux/slab.h:typedef struct { unsigned long v; } freeptr_t;

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

