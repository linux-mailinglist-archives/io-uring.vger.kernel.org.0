Return-Path: <io-uring+bounces-4856-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2345D9D3541
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 09:19:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 895EBB220E0
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 08:19:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC46B165F1D;
	Wed, 20 Nov 2024 08:19:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com [209.85.219.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A464193;
	Wed, 20 Nov 2024 08:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732090790; cv=none; b=KfgvLTbC8TUxjJyPE0K9lDnDzTsEhlvT2byKBFep1pKkIf9WTTTNsT5ZLRU2oEncEQmcaPx5HUw+Us1/uNtsyflES4Xu0AXev84g+IkGi1KvlHEsoEJreYPHohclVpEgRY1HkL0PKohRgWgq/g7J8I0FJcOrljIIAkw3WRN0Yms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732090790; c=relaxed/simple;
	bh=mEPxTwDGh+cBnGpCe4HRb5uaN5E1yXCxR7M1SGsgEPI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UYVXNG+QuoM45fEHV+W9ejjSxfubgqvANw+IR7fnL21+k5VfIfLwR+t4mv4xiv3fnGIW3DcCQ8qn6WQQJfJSBamf/vntzF95KC/71yKt2PmVV60g9QxVcN5hTWnS9ZMvyuOhhdoEx0aj/d+thnO+ahqIgo8h8h1ckkALCSOtUrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-e382661fb79so1569278276.0;
        Wed, 20 Nov 2024 00:19:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732090787; x=1732695587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zfLE3wxWqaI3cOb3+5mvfAqJSkt+0yE85CISQ1/OLRM=;
        b=gwZyx/qrhic8MoudGaXJ2aJpzA8DvFi1ruBQ6EcjJUvKDBqIWxYnBQwsj4ya9asuz4
         wKP3fqnu/5wlC7KVbmV1bCvTIokgupYBeALtoqQeoLYqwwlKoVks81BJKFciActl1vHQ
         8c0Vz2NIj79YUCdehie6aVLp/VaN+ZtG5S7bylFw/fJ+dmZDcGHtIqyLngvWbmWJ/scv
         etGgN0V8VWu2TMdOwXher8BbVFevjXGWZlMPIl5NqGn7xpuZ5/fLpjZ58WYXSR5sfPMa
         pQ5bcEazAZQLA4ulILkibnQSLYzVF1FziEopoFSWlIxxs1Nwx5c9zjQMa/bSSpysQ59f
         IbhA==
X-Forwarded-Encrypted: i=1; AJvYcCVFGkW+vkSGS9Kx2GRFkn2yNSS0xiGcEOmWn2Sw7N9FCQCfdy0GR66UrBHbKexXnk7PWQQJIJvtTg==@vger.kernel.org, AJvYcCXL6kQ+/Aq+pzxdzMmuVVvnVbJkJkoFpotbYDusQ5fjKgku0eZrwiIEkEL3gJ+KviavXuLUn9L9bvgjKwnF@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4Jbou30hzCchFH4h1RL2LL8CcCJ9EOU3gReNIlRBHFnT3j6Ni
	FrkoMiiZye+lTzkGbartB009hU7HZPhFlQtxI/BNn8sMdLeHMRCDnK6S3CpN
X-Google-Smtp-Source: AGHT+IHUlnAY7vEmz+xq2S2MFPVmCdMqFCMHYhZ7Y/rhCpU0QZQD28Sbod0QXMVorlh5GXPHMSjqHw==
X-Received: by 2002:a05:6902:12c7:b0:e38:9336:6c47 with SMTP id 3f1490d57ef6-e38cb70bc32mr1491342276.53.1732090786543;
        Wed, 20 Nov 2024 00:19:46 -0800 (PST)
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com. [209.85.128.175])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e387e806ae0sm3010374276.57.2024.11.20.00.19.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 00:19:45 -0800 (PST)
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-6eeafd42dd8so16966147b3.0;
        Wed, 20 Nov 2024 00:19:45 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUVNs+E/z3mv7+9lgY/VqQqL3V06vh/jFG2jPHTck+/A982NQASKrhP4of7j2RbNYNpSpdKEEM41A==@vger.kernel.org, AJvYcCVfNfMv+sltu1Da6Q+pde4bqYsnygtkYJACD5T2AaoVDFy0TXGZiu7/6FeyNhFe1C43x0i76CZhk5IOt/co@vger.kernel.org
X-Received: by 2002:a05:690c:620f:b0:6ea:90b6:ab49 with SMTP id
 00721157ae682-6eebd0d4c0emr18828777b3.5.1732090785516; Wed, 20 Nov 2024
 00:19:45 -0800 (PST)
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
 <5851cd28-b369-4c09-876c-62c4a47c5982@kernel.dk> <CAMuHMdX3iOVLN-rJSqvKSjrjTTf++PJ4e-wPsEX-3QJR3=eWOA@mail.gmail.com>
 <358710e8-a826-46df-9846-5a9e0f7c6851@kernel.dk> <CAMuHMdUsj9FsX=_rHwYjiXT8RehP6HW5hUL9LMvE0pt7Z8kc8w@mail.gmail.com>
 <82b97543-ad01-4e42-b79c-12d97c1df194@kernel.dk> <4623f30c-a12e-4ba6-ad99-835764611c67@kernel.dk>
 <47a16a83-52c7-4779-9ed3-f16ea547b9f0@roeck-us.net> <6c3d73a5-b5ef-455f-92db-e6b96ef22fba@kernel.dk>
In-Reply-To: <6c3d73a5-b5ef-455f-92db-e6b96ef22fba@kernel.dk>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 20 Nov 2024 09:19:33 +0100
X-Gmail-Original-Message-ID: <CAMuHMdVpaxVPy3Tyx-kc0FRqqPGkcDwQPS4deO9SLdY7wCPthA@mail.gmail.com>
Message-ID: <CAMuHMdVpaxVPy3Tyx-kc0FRqqPGkcDwQPS4deO9SLdY7wCPthA@mail.gmail.com>
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
To: Jens Axboe <axboe@kernel.dk>
Cc: Guenter Roeck <linux@roeck-us.net>, io-uring@vger.kernel.org, 
	linux-m68k <linux-m68k@lists.linux-m68k.org>, Christian Brauner <brauner@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Linux MM <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Jens,

CC Christian (who added the check)
CC Vlastimil (who suggested the check)

On Tue, Nov 19, 2024 at 11:30=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
> On 11/19/24 2:46 PM, Guenter Roeck wrote:
> > On 11/19/24 11:49, Jens Axboe wrote:
> >> On 11/19/24 12:44 PM, Jens Axboe wrote:
> >>>> On Tue, Nov 19, 2024 at 8:30?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>> On 11/19/24 12:25 PM, Geert Uytterhoeven wrote:
> >>>>>> On Tue, Nov 19, 2024 at 8:10?PM Jens Axboe <axboe@kernel.dk> wrote=
:
> >>>>>>> On 11/19/24 12:02 PM, Geert Uytterhoeven wrote:
> >>>>>>>> On Tue, Nov 19, 2024 at 8:00?PM Jens Axboe <axboe@kernel.dk> wro=
te:
> >>>>>>>>> On 11/19/24 10:49 AM, Geert Uytterhoeven wrote:
> >>>>>>>>>> On Tue, Nov 19, 2024 at 5:21?PM Guenter Roeck <linux@roeck-us.=
net> wrote:
> >>>>>>>>>>> On 11/19/24 08:02, Jens Axboe wrote:
> >>>>>>>>>>>> On 11/19/24 8:36 AM, Guenter Roeck wrote:
> >>>>>>>>>>>>> On Tue, Oct 29, 2024 at 09:16:32AM -0600, Jens Axboe wrote:
> >>>>>>>>>>>>>> Doesn't matter right now as there's still some bytes left =
for it, but
> >>>>>>>>>>>>>> let's prepare for the io_kiocb potentially growing and add=
 a specific
> >>>>>>>>>>>>>> freeptr offset for it.
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> This patch triggers:
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Kernel panic - not syncing: __kmem_cache_create_args: Faile=
d to create slab 'io_kiocb'. Error -22
> >>>>>>>>>>>>> CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-mac-0=
0971-g158f238aa69d #1
> >>>>>>>>>>>>> Stack from 00c63e5c:
> >>>>>>>>>>>>>           00c63e5c 00612c1c 00612c1c 00000300 00000001 005f=
3ce6 004b9044 00612c1c
> >>>>>>>>>>>>>           004ae21e 00000310 000000b6 005f3ce6 005f3ce6 ffff=
ffea ffffffea 00797244
> >>>>>>>>>>>>>           00c63f20 000c6974 005ee588 004c9051 005f3ce6 ffff=
ffea 000000a5 00c614a0
> >>>>>>>>>>>>>           004a72c2 0002cb62 000c675e 004adb58 0076f28a 005f=
3ce6 000000b6 00c63ef4
> >>>>>>>>>>>>>           00000310 00c63ef4 00000000 00000016 0076f23e 00c6=
3f4c 00000010 00000004
> >>>>>>>>>>>>>           00000038 0000009a 01000000 00000000 00000000 0000=
0000 000020e0 0076f23e
> >>>>>>>>>>>>> Call Trace: [<004b9044>] dump_stack+0xc/0x10
> >>>>>>>>>>>>>    [<004ae21e>] panic+0xc4/0x252
> >>>>>>>>>>>>>    [<000c6974>] __kmem_cache_create_args+0x216/0x26c
> >>>>>>>>>>>>>    [<004a72c2>] strcpy+0x0/0x1c
> >>>>>>>>>>>>>    [<0002cb62>] parse_args+0x0/0x1f2
> >>>>>>>>>>>>>    [<000c675e>] __kmem_cache_create_args+0x0/0x26c
> >>>>>>>>>>>>>    [<004adb58>] memset+0x0/0x8c
> >>>>>>>>>>>>>    [<0076f28a>] io_uring_init+0x4c/0xca
> >>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
> >>>>>>>>>>>>>    [<000020e0>] do_one_initcall+0x32/0x192
> >>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
> >>>>>>>>>>>>>    [<0000211c>] do_one_initcall+0x6e/0x192
> >>>>>>>>>>>>>    [<004a72c2>] strcpy+0x0/0x1c
> >>>>>>>>>>>>>    [<0002cb62>] parse_args+0x0/0x1f2
> >>>>>>>>>>>>>    [<000020ae>] do_one_initcall+0x0/0x192
> >>>>>>>>>>>>>    [<0075c4e2>] kernel_init_freeable+0x1a0/0x1a4
> >>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
> >>>>>>>>>>>>>    [<004b911a>] kernel_init+0x0/0xec
> >>>>>>>>>>>>>    [<004b912e>] kernel_init+0x14/0xec
> >>>>>>>>>>>>>    [<004b911a>] kernel_init+0x0/0xec
> >>>>>>>>>>>>>    [<0000252c>] ret_from_kernel_thread+0xc/0x14
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> when trying to boot the m68k:q800 machine in qemu.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> An added debug message in create_cache() shows the reason:
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> #### freeptr_offset=3D154 object_size=3D182 flags=3D0x310 a=
ligned=3D0 sizeof(freeptr_t)=3D4
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> freeptr_offset would need to be 4-byte aligned but that is =
not the
> >>>>>>>>>>>>> case on m68k.
> >>>>>>>>>>>>
> >>>>>>>>>>>> Why is ->work 2-byte aligned to begin with on m68k?!
> >>>>>>>>>>>
> >>>>>>>>>>> My understanding is that m68k does not align pointers.
> >>>>>>>>>>
> >>>>>>>>>> The minimum alignment for multi-byte integral values on m68k i=
s
> >>>>>>>>>> 2 bytes.
> >>>>>>>>>>
> >>>>>>>>>> See also the comment at
> >>>>>>>>>> https://elixir.bootlin.com/linux/v6.12/source/include/linux/ma=
ple_tree.h#L46
> >>>>>>>>>
> >>>>>>>>> Maybe it's time we put m68k to bed? :-)
> >>>>>>>>>
> >>>>>>>>> We can add a forced alignment ->work to be 4 bytes, won't chang=
e
> >>>>>>>>> anything on anything remotely current. But does feel pretty hac=
ky to
> >>>>>>>>> need to align based on some ancient thing.
> >>>>>>>>
> >>>>>>>> Why does freeptr_offset need to be 4-byte aligned?
> >>>>>>>
> >>>>>>> Didn't check, but it's slab/slub complaining using a 2-byte align=
ed
> >>>>>>> address for the free pointer offset. It's explicitly checking:
> >>>>>>>
> >>>>>>>          /* If a custom freelist pointer is requested make sure i=
t's sane. */
> >>>>>>>          err =3D -EINVAL;
> >>>>>>>          if (args->use_freeptr_offset &&
> >>>>>>>              (args->freeptr_offset >=3D object_size ||
> >>>>>>>               !(flags & SLAB_TYPESAFE_BY_RCU) ||
> >>>>>>>               !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t)=
)))
                                                          ^^^^^^

> >>>>>>>                  goto out;
> >>>>>>
> >>>>>> It is not guaranteed that alignof(freeptr_t) >=3D sizeof(freeptr_t=
)
> >>>>>> (free_ptr is sort of a long). If freeptr_offset must be a multiple=
 of
> >>>>>> 4 or 8 bytes,
> >>>>>> the code that assigns it must make sure that is true.
> >>>>>
> >>>>> Right, this is what the email is about...
> >>>>>
> >>>>>> I guess this is the code in fs/file_table.c:
> >>>>>>
> >>>>>>      .freeptr_offset =3D offsetof(struct file, f_freeptr),
> >>>>>>
> >>>>>> which references:
> >>>>>>
> >>>>>>      include/linux/fs.h:           freeptr_t               f_freep=
tr;
> >>>>>>
> >>>>>> I guess the simplest solution is to add an __aligned(sizeof(freept=
r_t))
> >>>>>> (or __aligned(sizeof(long)) to the definition of freeptr_t:
> >>>>>>
> >>>>>>      include/linux/slab.h:typedef struct { unsigned long v; } free=
ptr_t;
> >>>>>
> >>>>> It's not, it's struct io_kiocb->work, as per the stack trace in thi=
s
> >>>>> email.
> >>>>
> >>>> Sorry, I was falling out of thin air into this thread...
> >>>>
> >>>> linux-next/master:io_uring/io_uring.c:          .freeptr_offset =3D
> >>>> offsetof(struct io_kiocb, work),
> >>>> linux-next/master:io_uring/io_uring.c:          .use_freeptr_offset =
=3D true,
> >>>>
> >>>> Apparently io_kiocb.work is of type struct io_wq_work, not freeptr_t=
?
> >>>> Isn't that a bit error-prone, as the slab core code expects a freept=
r_t?
> >>>
> >>> It just needs the space, should not matter otherwise. But may as well
> >>> just add the union and align the freeptr so it stop complaining on m6=
8k.
> >>
> >> Ala the below, perhaps alignment takes care of itself then?
> >
> > No, that doesn't work (I tried), at least not on its own, because the p=
ointer
> > is still unaligned on m68k.
>
> Yeah we'll likely need to force it. The below should work, I pressume?
> Feels pretty odd to have to align it to the size of it, when that should
> naturally occur... Crusty legacy archs.
>
> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_type=
s.h
> index 593c10a02144..8ed9c6923668 100644
> --- a/include/linux/io_uring_types.h
> +++ b/include/linux/io_uring_types.h
> @@ -674,7 +674,11 @@ struct io_kiocb {
>         struct io_kiocb                 *link;
>         /* custom credentials, valid IFF REQ_F_CREDS is set */
>         const struct cred               *creds;
> -       struct io_wq_work               work;
> +
> +       union {
> +               struct io_wq_work       work;
> +               freeptr_t               freeptr __aligned(sizeof(freeptr_=
t));

I'd rather add the __aligned() to the definition of freeptr_t, so it
applies to all (future) users.

But my main question stays: why is the slab code checking
IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t)?
Perhaps that was just intended to be __alignof__ instead of sizeof()?

> +       };
>
>         struct {
>                 u64                     extra1;
> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> index 73af59863300..86ac7df2a601 100644
> --- a/io_uring/io_uring.c
> +++ b/io_uring/io_uring.c
> @@ -3812,7 +3812,7 @@ static int __init io_uring_init(void)
>         struct kmem_cache_args kmem_args =3D {
>                 .useroffset =3D offsetof(struct io_kiocb, cmd.data),
>                 .usersize =3D sizeof_field(struct io_kiocb, cmd.data),
> -               .freeptr_offset =3D offsetof(struct io_kiocb, work),
> +               .freeptr_offset =3D offsetof(struct io_kiocb, freeptr),
>                 .use_freeptr_offset =3D true,
>         };

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

