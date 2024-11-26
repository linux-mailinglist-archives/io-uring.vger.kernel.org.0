Return-Path: <io-uring+bounces-5059-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 519699D9B58
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 17:24:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C682D163BEB
	for <lists+io-uring@lfdr.de>; Tue, 26 Nov 2024 16:24:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D3711D79A5;
	Tue, 26 Nov 2024 16:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bB/METiC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2CAE1D88BF;
	Tue, 26 Nov 2024 16:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732638271; cv=none; b=U9C+3fGHIax6s6zel3PTNvG6OcSOcZetY+sKQqOELoTzkgbPm+JrsDvyPJ0ucvg7fNjXseivKG4JXLTpS64LebgwggeXLZjASpYhfy+3TeglSyC1nS144VNVSVD5u03SEYAwS0iFO8YyvCGqXpjEEZmrB98LPp6UUBNlT8IMB3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732638271; c=relaxed/simple;
	bh=VTz2UQ7ausAAK2tcdveUzXDQ/SYHAuU4ohVoNjE4v9c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bJJdSlisAf80Ni+FrU5ZzTUyZ96+ho/MJAfFCVxLv8U6upqa0a7U2BQTzDoyW5jRyb0+aRrMk4r265vYfn+z39BdT7/hjT1LxfnEk0yPV7shGldT3epJGUgdjSy5bHR2S6jI89CzyTbJb+pOB3pvVsieLZlh0HF2qbjepgIWU4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bB/METiC; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-5cfd3a7e377so7553876a12.2;
        Tue, 26 Nov 2024 08:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732638268; x=1733243068; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1SSHykmofa5yR6Vyw9fXrh2uc6s5eUP4tdQH2TzvHr4=;
        b=bB/METiCT78B5X762VdeARRkHmDVNFdfGCmvLBLxM2riaBxQXSp0Nh0mf2BGwyfUim
         SW9SBNT4vhKMyuS9X4TMnEdopj2kKWeJHuplfpbvn69VpRUuf0uTKRRVXRT8wdROV5P5
         ZhgZnP3pNgHYQaAy2cU56NnCILGP+8CE5sAsqgYJiJ5imJszPL5EvZ9G2iGd/+N2p50T
         5BS6llNDUphq4yNbwHo7hBoYm3C3rZHFDtZCanLs32sdxlz4EI4z2Pqkkz1e0t0umUV+
         OTDkToHTU+2/WadPzdKfulrqSzliq5cpVSXJsx+F+8/OT8djvUdPr7U5iAuGIpbuGICJ
         Nu/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732638268; x=1733243068;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1SSHykmofa5yR6Vyw9fXrh2uc6s5eUP4tdQH2TzvHr4=;
        b=jgfY6hULbTZ9FIQwC+K8JCPqm2ZE9bVVgwYHtHEddcOgukuKnuhXHP3psdPMHYYES/
         t/67ie7vEV6u+9jhBIyiXCWxwiuTaKGZDQ9J4GTSlUuYaNsLtqw4w9a3lwIfbgHOO6fU
         Z4UP2yZWyEWbrk+wC7ab9Hb1GYlbejgBB4ICE2HQODIzbTgIE+7mSC5P/rX69GhfKO/D
         TFD7cEA0j5/yLp/ByCg0hHCWDUzxj+Twm5mfzayi0JPuHKXBnuU/zlbJNrNLZNkFjFm3
         kRMrcikfT1F5HhMBxkVRsbkh4I+9NjpvByoz94X/1i74PU5fkXh09amUzfA8hP9y/8RL
         Mn8w==
X-Forwarded-Encrypted: i=1; AJvYcCUYSTiA7jLuf0wQr8ZvN5yxHLrJqphm41BfBzmK+jFycc5Uc3lT6drG0ceqsq0QVPN/Jp5JzpMru2XUfzEdBg==@vger.kernel.org, AJvYcCUYrhZT+Qtqdd+oyDkgk/45fP9V2mKJlM2PdarVv7NEUlhp5nLdcFK96+e2gWEZIXAt8NwKvl1H1c7T9Q==@vger.kernel.org, AJvYcCV79mN3Z1VXZk4TSwKaNeRKFelcHLyguZ9yg+GXbj+PKUwXsqqYdDqCNCpRCugPI/n+0yZPJILq/opxpXo=@vger.kernel.org, AJvYcCXM6L4tjU94GHk1rLEcnU5wgdFmS6KSCHOUhWVDMX2qhu+T7+n/OGP1EdLqtvsr7bx89oKpAjrlOQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZaKavWEMsWJZgwmdz1Lney7wR6kfAT3msyRrC8wSN5YCug948
	sZ4D222TTRdfD7e5wsKMW0Ke+9yiEpDYnkAXT2K6Wf7D30CUpPtXkcD6hqkGStn/c66WTvT/HEv
	Tv6wytCBb4tt9gkDcJB0evg2ebQ==
X-Gm-Gg: ASbGncs4oKNV5t8a0Nqz4MoJ07K8oJdaX2KQMtOHhl/B6MUEO7BnQWmsbbh+Ys8X0XQ
	Gug/qpkIkq+Og921K1ZTs/fG1dSU/3HDCwM+T0lC+Y5rAH+2jmND9EmXSgD9f8Q==
X-Google-Smtp-Source: AGHT+IEh+egU5r+E38GEVvMrAItGqOuNyV0IAyzdCyASKTwVbSpUev9AcXCnHID80AFjxWCtKJHJF+gu99Vy1r/Grt0=
X-Received: by 2002:a17:906:d511:b0:a9a:1437:3175 with SMTP id
 a640c23a62f3a-aa509d6c7cfmr1244797866b.51.1732638267654; Tue, 26 Nov 2024
 08:24:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241125070633.8042-1-anuj20.g@samsung.com> <CGME20241125071502epcas5p46c373574219a958b565f20732797893f@epcas5p4.samsung.com>
 <20241125070633.8042-7-anuj20.g@samsung.com> <2cbbe4eb-6969-499e-87b5-02d19f53258f@gmail.com>
 <20241126135423.GB22537@green245> <a9d500a4-2609-4dd6-a687-713ae1472a88@gmail.com>
In-Reply-To: <a9d500a4-2609-4dd6-a687-713ae1472a88@gmail.com>
From: Anuj gupta <anuj1072538@gmail.com>
Date: Tue, 26 Nov 2024 21:53:50 +0530
Message-ID: <CACzX3AtBc-Vio1H28MM2tRvcLzTYBTFJt8CKgF5NeGTniKFUbQ@mail.gmail.com>
Subject: Re: [PATCH v10 06/10] io_uring: introduce attributes for read/write
 and PI support
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: Anuj Gupta <anuj20.g@samsung.com>, axboe@kernel.dk, hch@lst.de, kbusch@kernel.org, 
	martin.petersen@oracle.com, brauner@kernel.org, jack@suse.cz, 
	viro@zeniv.linux.org.uk, io-uring@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, 
	gost.dev@samsung.com, linux-scsi@vger.kernel.org, vishak.g@samsung.com, 
	linux-fsdevel@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 26, 2024 at 9:14=E2=80=AFPM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> On 11/26/24 13:54, Anuj Gupta wrote:
> > On Tue, Nov 26, 2024 at 01:01:03PM +0000, Pavel Begunkov wrote:
> >> On 11/25/24 07:06, Anuj Gupta wrote:
> >> ...
> >>> +   /* type specific struct here */
> >>> +   struct io_uring_attr_pi pi;
> >>> +};
> >>
> >> This also looks PI specific but with a generic name. Or are
> >> attribute structures are supposed to be unionised?
> >
> > Yes, attribute structures would be unionised here. This is done so that
> > "attr_type" always remains at the top. When there are multiple attribut=
es
> > this structure would look something like this:
> >
> > /* attribute information along with type */
> > struct io_uring_attr {
> >       enum io_uring_attr_type attr_type;
> >       /* type specific struct here */
> >       union {
> >               struct io_uring_attr_pi pi;
> >               struct io_uring_attr_x  x;
> >               struct io_uring_attr_y  y;
> >       };
> > };
> >
> > And then on the application side for sending attribute x, one would do:
> >
> > io_uring_attr attr;
> > attr.type =3D TYPE_X;
> > prepare_attr(&attr.x);
>
> Hmm, I have doubts it's going to work well because the union
> members have different sizes. Adding a new type could grow
> struct io_uring_attr, which is already bad for uapi. And it
> can't be stacked:
>
> io_uring_attr attrs[2] =3D {..., ...}
> sqe->attr_ptr =3D &attrs;
> ...
>
> This example would be incorrect. Even if it's just one attribute
> the user would be wasting space on stack. The only use for it I
> see is having ephemeral pointers during parsing, ala
>
> void parse(voud *attributes, offset) {
>         struct io_uring_attr *attr =3D attributes + offset;
>
>         if (attr->type =3D=3D PI) {
>                 process_pi(&attr->pi);
>                 // or potentially fill_pi() in userspace
>         }
> }
>
> But I don't think it's worth it. I'd say, if you're leaving
> the structure, let's rename it to struct io_uring_attr_type_pi
> or something similar. We can always add a new one later, it
> doesn't change the ABI.
>

In that case I can just drop the io_uring_attr_pi structure then. We can
keep the mask version where we won't need the type and attributes would go
in the array in order of their types as you suggested here [1]. Does that
sound fine?

[1] https://lore.kernel.org/io-uring/37ba07f6-27a5-45bc-86c4-df9c63908ef9@g=
mail.com/

