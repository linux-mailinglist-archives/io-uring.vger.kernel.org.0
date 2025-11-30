Return-Path: <io-uring+bounces-10858-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D98C94B78
	for <lists+io-uring@lfdr.de>; Sun, 30 Nov 2025 05:38:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C5E04344EEC
	for <lists+io-uring@lfdr.de>; Sun, 30 Nov 2025 04:38:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2A6B2264B8;
	Sun, 30 Nov 2025 04:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h0csajpk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFA5B21578D
	for <io-uring@vger.kernel.org>; Sun, 30 Nov 2025 04:38:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764477513; cv=none; b=mw4wv9CCfKQ4zor8PUYxviYAvm3Pwchf2aVZ90AwQLDxTbvFL1BiHXA3iZ6ciLgOvL2WEdJxhZFTuPDy8DN4bn/OP+Iohbm+BcW/vO4mRf4r+NQD+Zn/5QZ+47rExEQLpF2cKqa+XY24dz4s1Y0OsTOGifdB+kj1l3Jl1IdY1bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764477513; c=relaxed/simple;
	bh=WQ94DebAPuz3wOX1RNLK86K8LFdn0rFvCp8UOMGIZLc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OuKyVWF2TmuBe6BwMFK0MkfaFtNLxY/Vs1N8N6CS5VXARBNrqOthEW19Wv695NfhHj1D2nAcf5YqNwtjSZ0E+VwPjKh9GdZlXJt4jQWGH8WXOZeuGD8ONbRxMpdVyYoera4CwiiVdNiavILm8AJJFZRZB9nve1szNbsid70jUvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h0csajpk; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b76b5afdf04so546483766b.1
        for <io-uring@vger.kernel.org>; Sat, 29 Nov 2025 20:38:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764477510; x=1765082310; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wm2qs060enFDQ6DOh1yWGpw1oXM6AX8D1bOSCPnDDdI=;
        b=h0csajpk1Xo7dlNkjPrjrTQkECKOAAMbOjM2eW7Un94pSngiL4FAIITuTXgGIXvFHX
         hwfa8oCJkSpaLDLJmstitETOcxC8qaCpbo1zwYqYb+55fAnhTP6B8Hx5g6Nphi+2fjq/
         9VG6U4qcJoqe8Gp2wZu1Dzvhr0tH5T/XoYLabAEMpMLl24bo8C9BbU7C+aJui4Pdw17w
         ppTYg34CLnGY/mtWXy+NlqSbZ9+fNd8Oemd1FaQEuPVkih3fvB/4DROzpG9szFbRm2zd
         DJZ5eLSzYXJi3DnGe8DO4VhbbejFtyuhevAKvq21q56h9wPAByDx0rOE2Sv8PExGCtlB
         D4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764477510; x=1765082310;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wm2qs060enFDQ6DOh1yWGpw1oXM6AX8D1bOSCPnDDdI=;
        b=eqn1evjs5w4UwMeeZDlZiGsV9O++MsTq/rth8DO6H6+yNGdi+fhChVZvU23Mu3SKrU
         +nkD0NVeAIjwT1tMVUewK057ex3yfnD5ykEuIfF9sZ+opfZWVGGXhA3d/sirHxcaNVYi
         OOa8xgVTfnm7Cua+3h6IZSpLboBpJ2OjaGC02klrF3X5Ddk8pJkKB+AXgs3OyzQI7w16
         GEr15XLSfMWTszyVrL4otWetcCCijUikjmfenmGfxsgPqwWFXltC0Q3+eYVQdqTjUdLS
         7C+2MuwEPR1NjC8Elq1qxQu7oRfQWClO2JFom7lybwPCo7s12KZnQE1VjFeRyjXLLQyg
         JV8w==
X-Forwarded-Encrypted: i=1; AJvYcCWpbq5sNyjOPbFwcEGjX43eWRTwvJsIwwKplwJeoIT0cNt1+MHhbe4m+VaqvzaOpO6k2dkBhABU+A==@vger.kernel.org
X-Gm-Message-State: AOJu0YzsQVSCB3aCKWKy0/y1yTBZ151Kr82MiXkCH25Lq75DFIleGjTO
	komu6g4Rr9T2kVnWHZKEftgyU0zV+aUevDRQYwOZ33Lx8x2MvbTiZG45IsHEDaeAefEkjKFccko
	Yyg+sxloVGQfvxosop8ixAUB5oh9hFE8=
X-Gm-Gg: ASbGncscHHz8jO20KlNQFfCF4QvxwaxZWUouBzlGcAzaFepYj0rhk5LEqswtrAUDXDC
	p81phdPQ3Nu8AgSehqSjd/w5E7r4mn5MlBBuC2wEnh9hM8PYcp6aqPQVnn7UYwBGamkHE+/miMc
	gugTLRaDC82Dh+ZY6Gk0yJlkcJ0Odko8ZjoooZixtNBHPwgeGuHEEf6657ci5T+6sx90pxQcVVH
	ucr6tG66A4Q7KWYfZapD8VcpFDMNtkrHdb2wq4NNQDHhQ9MHvoBYHjIBTMDpCW+bUZDGVY873L8
	lP0XR05xfpA6D5/HWtZTlGBe2A==
X-Google-Smtp-Source: AGHT+IHbYJJh4P+1boLJ9Cb2u+xppWb2pzCo2jr/G5F8t7wwa3JYRi6C75RfispLRGk3OreB5sokjTdCHuJDPIxemp0=
X-Received: by 2002:a17:907:2da8:b0:b72:d8da:7aac with SMTP id
 a640c23a62f3a-b7671a2a2f4mr3812556666b.56.1764477510024; Sat, 29 Nov 2025
 20:38:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251129170142.150639-1-viro@zeniv.linux.org.uk>
 <20251129170142.150639-16-viro@zeniv.linux.org.uk> <CAGudoHFjycOW1ROqsm1_8j47AGawjXC3kVctvWURFvSDvhq2jg@mail.gmail.com>
 <20251130040622.GO3538@ZenIV>
In-Reply-To: <20251130040622.GO3538@ZenIV>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sun, 30 Nov 2025 05:38:18 +0100
X-Gm-Features: AWmQ_blWc7hF27o9Yq5vPwV7AFjbnDQnKuyJsgBujIsM5G8K8ZPMeeXZ2v6eirg
Message-ID: <CAGudoHEMjWCOLEp+TdKLjuguHEKn9+e+aZwfKyK_sYpTZY8HRg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 15/18] struct filename: saner handling of long names
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, torvalds@linux-foundation.org, 
	brauner@kernel.org, jack@suse.cz, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 30, 2025 at 5:06=E2=80=AFAM Al Viro <viro@zeniv.linux.org.uk> w=
rote:
>
> On Sat, Nov 29, 2025 at 06:33:22PM +0100, Mateusz Guzik wrote:
>
> > This makes sizeof struct filename 152 bytes. At the same time because
> > of the SLAB_HWCACHE_ALIGN flag, the obj is going to take 192 bytes.
> >
> > I don't know what would be the nice way to handle this in Linux, but
> > as is this is just failing to take advantage of memory which is going
> > to get allocated anyway.
> >
> > Perhaps the macro could be bumped to 168 and the size checked with a
> > static assert on 64 bit platforms?
>
> Could be done, even though I wonder how much would that really save.
>

By any chance are you angling for that idea to keep struct filename on
the stack and that's why the size is 128?

With struct nameidata already on the stack and taking 240 bytes,
adding the 152 bytes would result in 392 bytes in total. I would argue
that's prohibitive, at the same time lowering the length to something
like 64 already makes gcc not fit with some of its lookups.

Anyway, I did look into something like this way back and some programs
really liked their *long* paths (way past 128).

Some stats I recently collected on FreeBSD while building packages:
dtrace -n 'vfs:namei:lookup:entry { @ =3D
lquantize(strlen(stringof(arg1)), 0, 384, 8); }'

 value  ------------- Distribution ------------- count
             < 0 |                                         0
               0 |@@@@@@@@                                 18105105
               8 |@@@@@@@                                  16360012
              16 |@@@@@@@@@                                21313430
              24 |@@@@@@                                   15000426
              32 |@@@                                      6450202
              40 |@@                                       4209166
              48 |@                                        2533298
              56 |@                                        1611506
              64 |@                                        1203825
              72 |                                         1068207
              80 |                                         877158
              88 |                                         592192
              96 |                                         489958
             104 |                                         709757
             112 |                                         925775
             120 |                                         1041627
             128 |@                                        1315123
             136 |                                         664687
             144 |                                         276673
             152 |                                         150870
             160 |                                         82661
             168 |                                         40630
             176 |                                         26693
             184 |                                         15112
             192 |                                         7276
             200 |                                         5773
             208 |                                         2462
             216 |                                         1679
             224 |                                         1150
             232 |                                         1301
             240 |                                         1652
             248 |                                         659
             256 |                                         464
             264 |                                         0

> > Or some magic based on reported
> > cache line size.
>
> No comments.  At least, none suitable for polite company.
>
> BTW, one thing that might make sense is storing the name length in there.=
..

(gdb) ptype /o struct filename
/* offset      |    size */  type =3D struct filename {
/*      0      |       8 */    const char *name;
/*      8      |       8 */    const char *uptr;
/*     16      |       4 */    atomic_t refcnt;
/* XXX  4-byte hole      */
/*     24      |       8 */    struct audit_names *aname;
/*     32      |       0 */    const char iname[];

                               /* total size (bytes):   32 */
                             }

If the length start getting stored it can presumably go into the hole.

Otherwise is there a reason to not rearrange this? The array could be
only aligned to 4 bytes, on archs which are fine with misaligned
access anyway. That's 4 extra bytes recovered.

All that said, now that I look at it, assuming struct filename will
keep being allocated from slub, why not make it 256 bytes? This gives
232 bytes for the name buffer (covering almost all of the looups I ran
into anyway), archs with 128 byte cacheline are sorted out and one can
trivially unconditionally static assert on the total size being 256
bytes, all while not having space which is never going to be used.

