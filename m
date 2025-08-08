Return-Path: <io-uring+bounces-8908-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9A15B1E9A6
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 15:55:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA7F35A171D
	for <lists+io-uring@lfdr.de>; Fri,  8 Aug 2025 13:55:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEBFD1420DD;
	Fri,  8 Aug 2025 13:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="K2Mzkubw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E81181732
	for <io-uring@vger.kernel.org>; Fri,  8 Aug 2025 13:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754661337; cv=none; b=E+IXDA2xpP422VhUD2Nnv7tFrWGXNkH/SgpRCjsx91MNiT8tsYkk+f4HOfXnlEE3z4mkmIQ42hyZB25MppqiMPXDNdGUVj1My89MMAhmquKnt6/ssJpIuIzk3JGO/oCaJlDXRIWsPjL/SQUjbM5FBaU4/V9OUS6qKyTr9aspz/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754661337; c=relaxed/simple;
	bh=Zquk4fZlqugpMITqeHfl1rKNFO7IlOev+ik/svkOUIE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NSU4FiBE2tmtrcG2z1k86gimR4o2L1n2nyFddvZyGDiGxdfT/qOM2m8dMGx5XjZzqsYKL+IatRLG7Sa/RNaehcjFm3RkYkmOH3ye6HuQqtmidDTGFUcNMhQwJ+NYXyOW6Mpu0Gzv6kSb2ZwFavCCkkfKoUc3zA2v9tDSGjdO5qo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=K2Mzkubw; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-240240f1478so3458015ad.1
        for <io-uring@vger.kernel.org>; Fri, 08 Aug 2025 06:55:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1754661335; x=1755266135; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kQqhwMu97JOF+Dnp4Yu6k+ZMIJjBNPmuuiSPr14eUoY=;
        b=K2MzkubwRH2EvE2i8PEaTpBdJwSCEMaG3fpUbCChQxi2Yh0ccANvO5FjQND0N7s+i9
         j2i3PHRd0Ls9MrDoGGe484n1BYDb31MM0n1kuMAJ5Cz2K4Vnm3MziHN1Vl1ZB5BVFsIP
         qRQph51Qvi3SBVYtv2WjcA48fw6ztPuy4iiu8Gg7n1skjCv73vxQSsv8KLxfDvxjkmWK
         HajajFYoA4JPcJXvKfWq07R894HiqXQqkzkJs2V3Rj8RLDFTsqshXxgHND7jqJzPhkqp
         0ErG5j/Bt3rNlSDO486PT8CjiyEDrDdpucWqxsu6S1LSpoGWI4upqixVE8eOFbZwkSfq
         3Kxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754661335; x=1755266135;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kQqhwMu97JOF+Dnp4Yu6k+ZMIJjBNPmuuiSPr14eUoY=;
        b=rngB79z3pFWHYz38XV1Pl5zNgObyICq0FTn37yu0B+bxLL4jDwJRVs9rP7d+Mqmgzs
         AC1U7r7inSycGAuzTUoSv/Uf/PG8AEOyvkpDhjOPfdCrOTLSlOYoaeHB1s29CJ9cG280
         erFiadYXwZp5m/CQcx/ud27QNzVPItiAJwppRktJwSxz8+8pKFNpzfN39/+ayM0COo3C
         UASuTF5cSI1xzCU+TCLTDBrmdRixHXYTqlIPmbiKAo2Use6WL9U6D8C6XkBbosFKfWjs
         QwqTNXx8S49N71/CAWK38nN7G7mjK1wqKbwBXuzHka39Cw6fcebj9Xrk+KthtyJaOtnv
         bFtQ==
X-Forwarded-Encrypted: i=1; AJvYcCV82RtMsFQOs3ASiJ421Hd60kq5L0RJ7DmWUL/2z5LkbgJbzYr0ZOLwKRj4aGO2S8O0Gsw5RiMFvw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzkpRtQ0qTrkygTg82BVJuHV1D6yswOsjUPRL1qnmvePy3O5ePK
	jo7dHTZdNrrW9urtayPiDhf6vmj9PbNdn6sQxMkTfva4K1vFKQMBWF1mwHT9ZN08tTm1OHVMSrO
	taVi3X4fVbUypwZAbzdAMhvkh7bhRa8JhvYYllq6+rw==
X-Gm-Gg: ASbGncu1xcDCudyKw0CNbsHWGW3RWV/4A6bf8SulqaYtHxCQaRghTULNeftiWsVqwgv
	y+yEQTdRJTqvxnMEe6TJYCjjUgfXxrEmKB0izDBLh/87ht8GhpKzApKrEG5m7q1CUMTB8IhiCLf
	Abk1qr9oWQMA1RY2mGgeMrW6ogYT6gM0Wa1HrEPnu2uo1edzrK2JS7Y0f72Jf88udnLIt3vZxnO
	QJK0Q==
X-Google-Smtp-Source: AGHT+IEvTRGuSdb6pbkCKd1y4iUXYP9fAjyHlvC+AqT0WWCcjOtTZnbw9hq9BOfJC/3n9bkUYLQYUhb4M8CKh0KADFU=
X-Received: by 2002:a17:903:8d0:b0:240:764e:afab with SMTP id
 d9443c01a7336-242c22135a5mr22357765ad.6.1754661335094; Fri, 08 Aug 2025
 06:55:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250727150329.27433-1-sidong.yang@furiosa.ai>
 <20250727150329.27433-3-sidong.yang@furiosa.ai> <D6CDE1A5-879F-49B1-9E10-2998D04B678F@collabora.com>
 <DBRVVTJ5LDV2.2NHTJ4S490N8@kernel.org> <949A27C5-1535-48D1-BE7E-F7E366A49A52@collabora.com>
 <DBVDWWHX8UY7.TG5OHXBZM2OX@kernel.org> <aJWfl87T3wehIviV@sidongui-MacBookPro.local>
In-Reply-To: <aJWfl87T3wehIviV@sidongui-MacBookPro.local>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Fri, 8 Aug 2025 09:55:22 -0400
X-Gm-Features: Ac12FXxoKSbsPg1hWv0cG4s-zPj6j-EgqHK_XsFPK4Xy1_Cr-9q7QSTYWD8saXY
Message-ID: <CADUfDZrWMrECM_LSh-nsurRBadskq_Z9wh_7nO1FUUxvOVHmKg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 2/4] rust: io_uring: introduce rust abstraction for
 io-uring cmd
To: Sidong Yang <sidong.yang@furiosa.ai>
Cc: Benno Lossin <lossin@kernel.org>, Daniel Almeida <daniel.almeida@collabora.com>, 
	Miguel Ojeda <ojeda@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rust-for-linux@vger.kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 8, 2025 at 2:56=E2=80=AFAM Sidong Yang <sidong.yang@furiosa.ai>=
 wrote:
>
> On Wed, Aug 06, 2025 at 03:38:24PM +0200, Benno Lossin wrote:
> > On Wed Aug 6, 2025 at 2:38 PM CEST, Daniel Almeida wrote:
> > > Hi Benno,
> > >
> > >> On 2 Aug 2025, at 07:52, Benno Lossin <lossin@kernel.org> wrote:
> > >>
> > >> On Fri Aug 1, 2025 at 3:48 PM CEST, Daniel Almeida wrote:
> > >>>> On 27 Jul 2025, at 12:03, Sidong Yang <sidong.yang@furiosa.ai> wro=
te:
> > >>>> +    #[inline]
> > >>>> +    pub fn pdu(&mut self) -> &mut MaybeUninit<[u8; 32]> {
> > >>>
> > >>> Why MaybeUninit? Also, this is a question for others, but I don=C2=
=B4t think
> > >>> that `u8`s can ever be uninitialized as all byte values are valid f=
or `u8`.
> > >>
> > >> `u8` can be uninitialized. Uninitialized doesn't just mean "can take=
 any
> > >> bit pattern", but also "is known to the compiler as being
> > >> uninitialized". The docs of `MaybeUninit` explain it like this:
> > >>
> > >>    Moreover, uninitialized memory is special in that it does not hav=
e a
> > >>    fixed value ("fixed" meaning "it won=C2=B4t change without being =
written
> > >>    to"). Reading the same uninitialized byte multiple times can give
> > >>    different results.
> > >>
> > >> But the return type probably should be `&mut [MaybeUninit<u8>; 32]`
> > >> instead.
> > >
> > >
> > > Right, but I guess the question then is why would we ever need to use
> > > MaybeUninit here anyways.
> > >
> > > It's a reference to a C array. Just treat that as initialized.
> >
> > AFAIK C uninitialized memory also is considered uninitialized in Rust.
> > So if this array is not properly initialized on the C side, this would
> > be the correct type. If it is initialized, then just use `&mut [u8; 32]=
`.
>
> pdu field is memory chunk for driver can use it freely. The driver usuall=
y
> saves a private data and read or modify it on the other context. using
> just `&mut [u8;32]` would be simple and easy to use.

MaybeUninit is correct. The io_uring/uring_cmd layer doesn't
initialize the pdu field. struct io_uring_cmd is overlaid with struct
io_kiocb's cmd field. struct io_kiocb's are allocated using
kmem_cache_alloc(_bulk)() in __io_alloc_req_refill(). io_preinit_req()
is called to initialize each struct io_kiocb but doesn't initialize
the cmd field. As Sidong said, it's uninitialized memory for the
->uring_cmd() implementation to use however it wants for the duration
of the command.

Best,
Caleb

