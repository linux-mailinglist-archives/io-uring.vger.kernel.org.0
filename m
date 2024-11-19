Return-Path: <io-uring+bounces-4841-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CE699D2E78
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 20:02:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2E2D328230F
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 19:02:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D2BB41D0147;
	Tue, 19 Nov 2024 19:02:41 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0B98528E
	for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 19:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732042961; cv=none; b=rWtsWxFf5tY6YFDTOPP+hpJgNeXoRfMWedXD39+FffuG7KyIxDIV1r1Y3i8/n970isTci2ljA6RRJEAhGrD6lI+lEgeyrSKGh8lCt2MJ+u0zaEaKCclHIfhvupPEgMAYuqWllcGmcswmY1tjzESCbOgipnB03ztGLP9ZODoNAvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732042961; c=relaxed/simple;
	bh=y+UxJkEPesqMLF84U+t/E/lqQVamvm5QAcaft0yOS8Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cRjMFH/lIdn0d1b/nKHMiAoWYsOvFNe3H2XXe/VaoG7x/Mtx6O5qezQwj2u0HHZW5Vpei8RETWapqWLet81wdzMCOYb16eYvNGwHcpUcfVwlttnXXcHVdeYOzLTNO4B347rSC51UBFW2r52dM0lTBU5YGGwAHeerTGJYHX533E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f169.google.com with SMTP id 3f1490d57ef6-e383bbcef9dso1266556276.3
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 11:02:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732042958; x=1732647758;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m0fp0XnUxNxL7PZB7gv+woUGcpwTbov1O1u2skS2Vxo=;
        b=Z3OWF5hTmrGbILSv/tfXIuJEF4FQ5xW0D6YWptyohADIMEi8TCYPw1/CuPHqDqB7Rp
         hCl6q8stx2OF1jKxlsnILeGFx7Cc6CEO+qiOJ9o64aEP0ZfshdBW/lvC4WIfWCLFh4XO
         IEkHUT4K8LqzSFv6DX10hRkgUVFW+RspuqTXNsnTqhdKZqkrtwCCHzGjHParlnmt1qde
         cAjdMFFUV+WsyyC+iF6z9G5Cti2UyjfnK5YJ/M3UKaTMgxV3t+IHP20py4clPLdCTLga
         HzKlm7cvrRNZLrPNoVfMapBhr7osAvxV8F9mWNtUO0Mzdhnv7xu93B7hjt/vVMbYendT
         QDlw==
X-Forwarded-Encrypted: i=1; AJvYcCU1FyDoMLrSLcOtngJoy9vilkgENkeNxsG3WyhA9SxI0VNXebyfJZc4I6DCh6WcLGlvlPgFvqg2hw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxwArJUttS1kv0eMU5wiccAEbprNs6jhbzvQruJkyhji7HfRGSm
	AmCC4cv2YhVOPWOvpaxcw/o6Ozu10ZisGxg+aLjW+dRrno5XzUWq0WaU7AD0
X-Google-Smtp-Source: AGHT+IGQTzkgysPiL7jyP9/KCzjorSDHup0yEUdZcd/EdZtIgoBxXqb5Ago1OrPS2zMf8mQNszYKBw==
X-Received: by 2002:a05:6902:b20:b0:e30:d4a2:222a with SMTP id 3f1490d57ef6-e382637937amr9714371276.31.1732042958200;
        Tue, 19 Nov 2024 11:02:38 -0800 (PST)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e387e7419ffsm2632575276.22.2024.11.19.11.02.37
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Nov 2024 11:02:37 -0800 (PST)
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e383bbcef9dso1266521276.3
        for <io-uring@vger.kernel.org>; Tue, 19 Nov 2024 11:02:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXQFyfHdPDwO1AzvQZoIJnloq5b8mcf27YcfnogWBH5J4vRdF4U44hNI5DjyLotrlRee4eYiS54qg==@vger.kernel.org
X-Received: by 2002:a05:690c:6404:b0:6ee:6e8e:6f84 with SMTP id
 00721157ae682-6ee6e8e71ddmr133325447b3.12.1732042957570; Tue, 19 Nov 2024
 11:02:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029152249.667290-1-axboe@kernel.dk> <20241029152249.667290-4-axboe@kernel.dk>
 <37c588d4-2c32-4aad-a19e-642961f200d7@roeck-us.net> <d4e5a858-1333-4427-a470-350c45b78733@kernel.dk>
 <ffc9d82d-fedf-4253-bbc1-c70c339c8b23@roeck-us.net> <CAMuHMdVAnJ8Tczm1=c=HOiWMZrNk0i_c1guUoqQbJRmdaXqPGw@mail.gmail.com>
 <5a7528c4-4391-4bd9-bbdb-a0247f3c76a9@kernel.dk>
In-Reply-To: <5a7528c4-4391-4bd9-bbdb-a0247f3c76a9@kernel.dk>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 19 Nov 2024 20:02:25 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX9rHUQYn34_Hz=3TKjbFqzenoDCdwt-Mqk1qXJiG4=Zg@mail.gmail.com>
Message-ID: <CAMuHMdX9rHUQYn34_Hz=3TKjbFqzenoDCdwt-Mqk1qXJiG4=Zg@mail.gmail.com>
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
To: Jens Axboe <axboe@kernel.dk>
Cc: Guenter Roeck <linux@roeck-us.net>, io-uring@vger.kernel.org, 
	linux-m68k <linux-m68k@lists.linux-m68k.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jens.

On Tue, Nov 19, 2024 at 8:00=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> On 11/19/24 10:49 AM, Geert Uytterhoeven wrote:
> > On Tue, Nov 19, 2024 at 5:21?PM Guenter Roeck <linux@roeck-us.net> wrot=
e:
> >> On 11/19/24 08:02, Jens Axboe wrote:
> >>> On 11/19/24 8:36 AM, Guenter Roeck wrote:
> >>>> On Tue, Oct 29, 2024 at 09:16:32AM -0600, Jens Axboe wrote:
> >>>>> Doesn't matter right now as there's still some bytes left for it, b=
ut
> >>>>> let's prepare for the io_kiocb potentially growing and add a specif=
ic
> >>>>> freeptr offset for it.
> >>>>>
> >>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>
> >>>> This patch triggers:
> >>>>
> >>>> Kernel panic - not syncing: __kmem_cache_create_args: Failed to crea=
te slab 'io_kiocb'. Error -22
> >>>> CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-mac-00971-g158=
f238aa69d #1
> >>>> Stack from 00c63e5c:
> >>>>          00c63e5c 00612c1c 00612c1c 00000300 00000001 005f3ce6 004b9=
044 00612c1c
> >>>>          004ae21e 00000310 000000b6 005f3ce6 005f3ce6 ffffffea fffff=
fea 00797244
> >>>>          00c63f20 000c6974 005ee588 004c9051 005f3ce6 ffffffea 00000=
0a5 00c614a0
> >>>>          004a72c2 0002cb62 000c675e 004adb58 0076f28a 005f3ce6 00000=
0b6 00c63ef4
> >>>>          00000310 00c63ef4 00000000 00000016 0076f23e 00c63f4c 00000=
010 00000004
> >>>>          00000038 0000009a 01000000 00000000 00000000 00000000 00002=
0e0 0076f23e
> >>>> Call Trace: [<004b9044>] dump_stack+0xc/0x10
> >>>>   [<004ae21e>] panic+0xc4/0x252
> >>>>   [<000c6974>] __kmem_cache_create_args+0x216/0x26c
> >>>>   [<004a72c2>] strcpy+0x0/0x1c
> >>>>   [<0002cb62>] parse_args+0x0/0x1f2
> >>>>   [<000c675e>] __kmem_cache_create_args+0x0/0x26c
> >>>>   [<004adb58>] memset+0x0/0x8c
> >>>>   [<0076f28a>] io_uring_init+0x4c/0xca
> >>>>   [<0076f23e>] io_uring_init+0x0/0xca
> >>>>   [<000020e0>] do_one_initcall+0x32/0x192
> >>>>   [<0076f23e>] io_uring_init+0x0/0xca
> >>>>   [<0000211c>] do_one_initcall+0x6e/0x192
> >>>>   [<004a72c2>] strcpy+0x0/0x1c
> >>>>   [<0002cb62>] parse_args+0x0/0x1f2
> >>>>   [<000020ae>] do_one_initcall+0x0/0x192
> >>>>   [<0075c4e2>] kernel_init_freeable+0x1a0/0x1a4
> >>>>   [<0076f23e>] io_uring_init+0x0/0xca
> >>>>   [<004b911a>] kernel_init+0x0/0xec
> >>>>   [<004b912e>] kernel_init+0x14/0xec
> >>>>   [<004b911a>] kernel_init+0x0/0xec
> >>>>   [<0000252c>] ret_from_kernel_thread+0xc/0x14
> >>>>
> >>>> when trying to boot the m68k:q800 machine in qemu.
> >>>>
> >>>> An added debug message in create_cache() shows the reason:
> >>>>
> >>>> #### freeptr_offset=3D154 object_size=3D182 flags=3D0x310 aligned=3D=
0 sizeof(freeptr_t)=3D4
> >>>>
> >>>> freeptr_offset would need to be 4-byte aligned but that is not the
> >>>> case on m68k.
> >>>
> >>> Why is ->work 2-byte aligned to begin with on m68k?!
> >>
> >> My understanding is that m68k does not align pointers.
> >
> > The minimum alignment for multi-byte integral values on m68k is
> > 2 bytes.
> >
> > See also the comment at
> > https://elixir.bootlin.com/linux/v6.12/source/include/linux/maple_tree.=
h#L46
>
> Maybe it's time we put m68k to bed? :-)
>
> We can add a forced alignment ->work to be 4 bytes, won't change
> anything on anything remotely current. But does feel pretty hacky to
> need to align based on some ancient thing.

Why does freeptr_offset need to be 4-byte aligned?

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

