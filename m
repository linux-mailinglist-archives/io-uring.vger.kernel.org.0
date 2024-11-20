Return-Path: <io-uring+bounces-4858-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF90F9D366C
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 10:08:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7669F1F2179F
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 09:08:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 506C218A6DB;
	Wed, 20 Nov 2024 09:07:58 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38206175D50;
	Wed, 20 Nov 2024 09:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732093678; cv=none; b=Mfynz/Bs0CJX86HaYUjtqh4ust9MV04+mjo34DthHXOtKK82iM9Q0fC2xyjtioHnzQsLfY/XoJUbrMxTeePlCRzvCoZLxrsQDWfOByUyOebV9urZ4JWgd3romvszPRSQyoeMETwhiMNZ8lBkNCFI5aPZlHxPAEoNJxEdLli/jSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732093678; c=relaxed/simple;
	bh=xWq6mp64tJCFhXksajcG/a5QVbg8ZhkSMUQ9zI/U//U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PLFLloDgGdahrgRqGEKDmTHB1HfStx6vPwgDGFssCCMbSR0PjYHu+NKr4Ol903K/Jdaxe8yDXIjyLwiXP4DrEChhdrqrtGvLPZYSHkQNrvTRShuLPXh3PwBtxijgtMKjIghEy8w169JCKXj7fm9EG6AsLFUqqidEttF0J/Z9/wc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-e388c39b2d0so556440276.0;
        Wed, 20 Nov 2024 01:07:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732093674; x=1732698474;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tsS8bF/F5AUqhK7npUVaqAml3lEEVVg4X1ZZTc5yMtU=;
        b=Vxly4Rm+0O4R7vcmB3w41k/eG6+I560/5/HgTuCSO72QOQK6FH+xsdNXmSbqVQ48I1
         RzdhHMrvizCFvaC1dFhg6mNsCGM9AAWBVCpI2tF/L8o09uNXwZiMmXPJBuSjho7/tx3M
         Ccmde5NfQY0mOhKWosqBitiLrCTEItJHMz9JsSSZ6Aach1ulJyu+0wplTt8LsxUgb1+c
         /cx7kCrEAIujfHgeZnOR0YWnd9PLOHNJUvSthZtKQe2hi/wtXUdBMZmLvjHNmyUCW8j2
         Lj3PC/yd2+b8tnJeLr6uv6hzA+vV3k83jMO/SC2cn5RpM6Ok1OeRFJc1nGujxprmqR9M
         zU5w==
X-Forwarded-Encrypted: i=1; AJvYcCUv8/v55AKBrziMcjeS31L1/h2jLZn1mInme7ifA7scmNjVBGmO8jgi6UFeevOp+Yzefgpl5lDvmnwsHTAx@vger.kernel.org, AJvYcCWUL37Pqhelox/wKAp1hUjnNKy2LuA+iSNjCHz+VWvwTJc4g/W1cwmlpUBaZEq0OWltZZsz9JclfA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwJ8Hfef5SOiLa8fG8DCWX19VSuL/wMCXgVAj44/8SHYMHKC6p0
	f2G2WRJ7G+hck4Z3qu/0eNF174ZhCsNTYkVF9geiXAdc1hXiH6zCKCP+ztPN
X-Google-Smtp-Source: AGHT+IGdiUlG0fZg/AIKfO+j8c6CeAR0dCz6NRrD5diw2TN5I3wlGus0/10NWJm1QPWbkOJsKLJiug==
X-Received: by 2002:a25:c503:0:b0:e38:86ea:eff8 with SMTP id 3f1490d57ef6-e38b725b0f0mr5347342276.0.1732093674147;
        Wed, 20 Nov 2024 01:07:54 -0800 (PST)
Received: from mail-yw1-f178.google.com (mail-yw1-f178.google.com. [209.85.128.178])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e387e75edcdsm2927901276.31.2024.11.20.01.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 01:07:52 -0800 (PST)
Received: by mail-yw1-f178.google.com with SMTP id 00721157ae682-6ee745e3b2bso5005627b3.0;
        Wed, 20 Nov 2024 01:07:52 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCW+rlQmlVdKTUGNGcY4GXuiORYbKN5Kox7mYjE3h/NChhJ5D977cdU0SVLxaw6ud40mZ3LRTGe2/NY0aYxd@vger.kernel.org, AJvYcCX0ie+Hyvj748e+NCeHVRoUgtcFGM//zol5mNau4uwc5FKTjo4muXJqdChUXNTOaLsT1feqRmKolQ==@vger.kernel.org
X-Received: by 2002:a05:690c:d09:b0:6ea:86ae:cbc with SMTP id
 00721157ae682-6eebc43e770mr16301717b3.13.1732093671951; Wed, 20 Nov 2024
 01:07:51 -0800 (PST)
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
 <CAMuHMdVpaxVPy3Tyx-kc0FRqqPGkcDwQPS4deO9SLdY7wCPthA@mail.gmail.com> <8b95a694-ecd4-4b6d-8032-049894dec2c1@suse.cz>
In-Reply-To: <8b95a694-ecd4-4b6d-8032-049894dec2c1@suse.cz>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 20 Nov 2024 10:07:40 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWU=69MtTxYXKGm2xZOyTvbUuxsqBWRSyMcp_H8VNEJ0g@mail.gmail.com>
Message-ID: <CAMuHMdWU=69MtTxYXKGm2xZOyTvbUuxsqBWRSyMcp_H8VNEJ0g@mail.gmail.com>
Subject: Re: [PATCH 03/14] io_uring: specify freeptr usage for
 SLAB_TYPESAFE_BY_RCU io_kiocb cache
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Jens Axboe <axboe@kernel.dk>, Jann Horn <jannh@google.com>, 
	Guenter Roeck <linux@roeck-us.net>, io-uring@vger.kernel.org, 
	linux-m68k <linux-m68k@lists.linux-m68k.org>, Christian Brauner <brauner@kernel.org>, 
	Linux MM <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Vlastimil,

On Wed, Nov 20, 2024 at 9:47=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wr=
ote:
> On 11/20/24 09:19, Geert Uytterhoeven wrote:
> > On Tue, Nov 19, 2024 at 11:30=E2=80=AFPM Jens Axboe <axboe@kernel.dk> w=
rote:
> >> On 11/19/24 2:46 PM, Guenter Roeck wrote:
> >> > On 11/19/24 11:49, Jens Axboe wrote:
> >> >> On 11/19/24 12:44 PM, Jens Axboe wrote:
> >> >>>> On Tue, Nov 19, 2024 at 8:30?PM Jens Axboe <axboe@kernel.dk> wrot=
e:
> >> >>>>> On 11/19/24 12:25 PM, Geert Uytterhoeven wrote:
> >> >>>>>> On Tue, Nov 19, 2024 at 8:10?PM Jens Axboe <axboe@kernel.dk> wr=
ote:
> >> >>>>>>> On 11/19/24 12:02 PM, Geert Uytterhoeven wrote:
> >> >>>>>>>> On Tue, Nov 19, 2024 at 8:00?PM Jens Axboe <axboe@kernel.dk> =
wrote:
> >> >>>>>>>>> On 11/19/24 10:49 AM, Geert Uytterhoeven wrote:
> >> >>>>>>>>>> On Tue, Nov 19, 2024 at 5:21?PM Guenter Roeck <linux@roeck-=
us.net> wrote:
> >> >>>>>>>>>>> On 11/19/24 08:02, Jens Axboe wrote:
> >> >>>>>>>>>>>> On 11/19/24 8:36 AM, Guenter Roeck wrote:
> >> >>>>>>>>>>>>> On Tue, Oct 29, 2024 at 09:16:32AM -0600, Jens Axboe wro=
te:
> >> >>>>>>>>>>>>>> Doesn't matter right now as there's still some bytes le=
ft for it, but
> >> >>>>>>>>>>>>>> let's prepare for the io_kiocb potentially growing and =
add a specific
> >> >>>>>>>>>>>>>> freeptr offset for it.
> >> >>>>>>>>>>>>>>
> >> >>>>>>>>>>>>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> >> >>>>>>>>>>>>>
> >> >>>>>>>>>>>>> This patch triggers:
> >> >>>>>>>>>>>>>
> >> >>>>>>>>>>>>> Kernel panic - not syncing: __kmem_cache_create_args: Fa=
iled to create slab 'io_kiocb'. Error -22
> >> >>>>>>>>>>>>> CPU: 0 UID: 0 PID: 1 Comm: swapper Not tainted 6.12.0-ma=
c-00971-g158f238aa69d #1
> >> >>>>>>>>>>>>> Stack from 00c63e5c:
> >> >>>>>>>>>>>>>           00c63e5c 00612c1c 00612c1c 00000300 00000001 0=
05f3ce6 004b9044 00612c1c
> >> >>>>>>>>>>>>>           004ae21e 00000310 000000b6 005f3ce6 005f3ce6 f=
fffffea ffffffea 00797244
> >> >>>>>>>>>>>>>           00c63f20 000c6974 005ee588 004c9051 005f3ce6 f=
fffffea 000000a5 00c614a0
> >> >>>>>>>>>>>>>           004a72c2 0002cb62 000c675e 004adb58 0076f28a 0=
05f3ce6 000000b6 00c63ef4
> >> >>>>>>>>>>>>>           00000310 00c63ef4 00000000 00000016 0076f23e 0=
0c63f4c 00000010 00000004
> >> >>>>>>>>>>>>>           00000038 0000009a 01000000 00000000 00000000 0=
0000000 000020e0 0076f23e
> >> >>>>>>>>>>>>> Call Trace: [<004b9044>] dump_stack+0xc/0x10
> >> >>>>>>>>>>>>>    [<004ae21e>] panic+0xc4/0x252
> >> >>>>>>>>>>>>>    [<000c6974>] __kmem_cache_create_args+0x216/0x26c
> >> >>>>>>>>>>>>>    [<004a72c2>] strcpy+0x0/0x1c
> >> >>>>>>>>>>>>>    [<0002cb62>] parse_args+0x0/0x1f2
> >> >>>>>>>>>>>>>    [<000c675e>] __kmem_cache_create_args+0x0/0x26c
> >> >>>>>>>>>>>>>    [<004adb58>] memset+0x0/0x8c
> >> >>>>>>>>>>>>>    [<0076f28a>] io_uring_init+0x4c/0xca
> >> >>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
> >> >>>>>>>>>>>>>    [<000020e0>] do_one_initcall+0x32/0x192
> >> >>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
> >> >>>>>>>>>>>>>    [<0000211c>] do_one_initcall+0x6e/0x192
> >> >>>>>>>>>>>>>    [<004a72c2>] strcpy+0x0/0x1c
> >> >>>>>>>>>>>>>    [<0002cb62>] parse_args+0x0/0x1f2
> >> >>>>>>>>>>>>>    [<000020ae>] do_one_initcall+0x0/0x192
> >> >>>>>>>>>>>>>    [<0075c4e2>] kernel_init_freeable+0x1a0/0x1a4
> >> >>>>>>>>>>>>>    [<0076f23e>] io_uring_init+0x0/0xca
> >> >>>>>>>>>>>>>    [<004b911a>] kernel_init+0x0/0xec
> >> >>>>>>>>>>>>>    [<004b912e>] kernel_init+0x14/0xec
> >> >>>>>>>>>>>>>    [<004b911a>] kernel_init+0x0/0xec
> >> >>>>>>>>>>>>>    [<0000252c>] ret_from_kernel_thread+0xc/0x14
> >> >>>>>>>>>>>>>
> >> >>>>>>>>>>>>> when trying to boot the m68k:q800 machine in qemu.
> >> >>>>>>>>>>>>>
> >> >>>>>>>>>>>>> An added debug message in create_cache() shows the reaso=
n:
> >> >>>>>>>>>>>>>
> >> >>>>>>>>>>>>> #### freeptr_offset=3D154 object_size=3D182 flags=3D0x31=
0 aligned=3D0 sizeof(freeptr_t)=3D4
> >> >>>>>>>>>>>>>
> >> >>>>>>>>>>>>> freeptr_offset would need to be 4-byte aligned but that =
is not the
> >> >>>>>>>>>>>>> case on m68k.
> >> >>>>>>>>>>>>
> >> >>>>>>>>>>>> Why is ->work 2-byte aligned to begin with on m68k?!
> >> >>>>>>>>>>>
> >> >>>>>>>>>>> My understanding is that m68k does not align pointers.
> >> >>>>>>>>>>
> >> >>>>>>>>>> The minimum alignment for multi-byte integral values on m68=
k is
> >> >>>>>>>>>> 2 bytes.
> >> >>>>>>>>>>
> >> >>>>>>>>>> See also the comment at
> >> >>>>>>>>>> https://elixir.bootlin.com/linux/v6.12/source/include/linux=
/maple_tree.h#L46
> >> >>>>>>>>>
> >> >>>>>>>>> Maybe it's time we put m68k to bed? :-)
> >> >>>>>>>>>
> >> >>>>>>>>> We can add a forced alignment ->work to be 4 bytes, won't ch=
ange
> >> >>>>>>>>> anything on anything remotely current. But does feel pretty =
hacky to
> >> >>>>>>>>> need to align based on some ancient thing.
> >> >>>>>>>>
> >> >>>>>>>> Why does freeptr_offset need to be 4-byte aligned?
> >> >>>>>>>
> >> >>>>>>> Didn't check, but it's slab/slub complaining using a 2-byte al=
igned
> >> >>>>>>> address for the free pointer offset. It's explicitly checking:
> >> >>>>>>>
> >> >>>>>>>          /* If a custom freelist pointer is requested make sur=
e it's sane. */
> >> >>>>>>>          err =3D -EINVAL;
> >> >>>>>>>          if (args->use_freeptr_offset &&
> >> >>>>>>>              (args->freeptr_offset >=3D object_size ||
> >> >>>>>>>               !(flags & SLAB_TYPESAFE_BY_RCU) ||
> >> >>>>>>>               !IS_ALIGNED(args->freeptr_offset, sizeof(freeptr=
_t))))
> >                                                           ^^^^^^
> >
> >> >>>>>>>                  goto out;
> >> >>>>>>
> >> >>>>>> It is not guaranteed that alignof(freeptr_t) >=3D sizeof(freept=
r_t)
> >> >>>>>> (free_ptr is sort of a long). If freeptr_offset must be a multi=
ple of
> >> >>>>>> 4 or 8 bytes,
> >> >>>>>> the code that assigns it must make sure that is true.
> >> >>>>>
> >> >>>>> Right, this is what the email is about...
> >> >>>>>
> >> >>>>>> I guess this is the code in fs/file_table.c:
> >> >>>>>>
> >> >>>>>>      .freeptr_offset =3D offsetof(struct file, f_freeptr),
> >> >>>>>>
> >> >>>>>> which references:
> >> >>>>>>
> >> >>>>>>      include/linux/fs.h:           freeptr_t               f_fr=
eeptr;
> >> >>>>>>
> >> >>>>>> I guess the simplest solution is to add an __aligned(sizeof(fre=
eptr_t))
> >> >>>>>> (or __aligned(sizeof(long)) to the definition of freeptr_t:
> >> >>>>>>
> >> >>>>>>      include/linux/slab.h:typedef struct { unsigned long v; } f=
reeptr_t;
> >> >>>>>
> >> >>>>> It's not, it's struct io_kiocb->work, as per the stack trace in =
this
> >> >>>>> email.
> >> >>>>
> >> >>>> Sorry, I was falling out of thin air into this thread...
> >> >>>>
> >> >>>> linux-next/master:io_uring/io_uring.c:          .freeptr_offset =
=3D
> >> >>>> offsetof(struct io_kiocb, work),
> >> >>>> linux-next/master:io_uring/io_uring.c:          .use_freeptr_offs=
et =3D true,
> >> >>>>
> >> >>>> Apparently io_kiocb.work is of type struct io_wq_work, not freept=
r_t?
> >> >>>> Isn't that a bit error-prone, as the slab core code expects a fre=
eptr_t?
> >> >>>
> >> >>> It just needs the space, should not matter otherwise. But may as w=
ell
> >> >>> just add the union and align the freeptr so it stop complaining on=
 m68k.
> >> >>
> >> >> Ala the below, perhaps alignment takes care of itself then?
> >> >
> >> > No, that doesn't work (I tried), at least not on its own, because th=
e pointer
> >> > is still unaligned on m68k.
> >>
> >> Yeah we'll likely need to force it. The below should work, I pressume?
> >> Feels pretty odd to have to align it to the size of it, when that shou=
ld
> >> naturally occur... Crusty legacy archs.
> >>
> >> diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_t=
ypes.h
> >> index 593c10a02144..8ed9c6923668 100644
> >> --- a/include/linux/io_uring_types.h
> >> +++ b/include/linux/io_uring_types.h
> >> @@ -674,7 +674,11 @@ struct io_kiocb {
> >>         struct io_kiocb                 *link;
> >>         /* custom credentials, valid IFF REQ_F_CREDS is set */
> >>         const struct cred               *creds;
> >> -       struct io_wq_work               work;
> >> +
> >> +       union {
> >> +               struct io_wq_work       work;
> >> +               freeptr_t               freeptr __aligned(sizeof(freep=
tr_t));
> >
> > I'd rather add the __aligned() to the definition of freeptr_t, so it
> > applies to all (future) users.
> >
> > But my main question stays: why is the slab code checking
> > IS_ALIGNED(args->freeptr_offset, sizeof(freeptr_t)?
>
> I believe it's to match how SLUB normally calculates the offset if no
> explicit one is given, in calculate_sizes():
>
> s->offset =3D ALIGN_DOWN(s->object_size / 2, sizeof(void *));
>
> Yes there's a sizeof(void *) because freepointer used to be just that and=
 we
> forgot to update this place when freepointer_t was introduced (by Jann in
> 44f6a42d49350) for handling CONFIG_SLAB_FREELIST_HARDENED. In
> get_freepointer() you can see how there's a cast to a pointer eventually.
>
> Does m68k have different alignment for pointer and unsigned long or both =
are
> 2 bytes? Or any other arch, i.e. should get_freepointer be a union with
> unsigned long and void * instead? (or it doesn't matter?)

The default alignment for int, long, and pointer is 2 on m68k.
On CRIS (no longer supported by Linux), it was 1, IIRC.
So the union won't make a difference.

> > Perhaps that was just intended to be __alignof__ instead of sizeof()?
>
> Would it do the right thing everywhere, given the explanation above?

It depends. Does anything rely on the offset being a multiple of (at
least) 4?
E.g. does anything counts in multiples of longs (hi BCPL! ;-), or are
the 2 LSB used for a special purpose? (cfr. maple_tree, which uses
bit 0 (https://elixir.bootlin.com/linux/v6.12/source/include/linux/maple_tr=
ee.h#L46)?

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

