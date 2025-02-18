Return-Path: <io-uring+bounces-6519-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DA824A3AA2B
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 21:58:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F2417165478
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 20:56:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A5921DE8B0;
	Tue, 18 Feb 2025 20:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ZlJUPENh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FE441F2BA9
	for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 20:42:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739911353; cv=none; b=NJl9ZDygE6Cm0mP9DwgimLNoIrPH5CIdLwA0IuDaRZcpecEhwGsJVW0eXgxBSPapGS8j4Xit1aJWjn7vGSOwckLL6HAqf88Xje8ignFXsN762+PcLoQ2IPPCfm76kRO9q4CaIfr26FqVGDjSJZozAeZ1YnaKlW2uR0HksabNyVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739911353; c=relaxed/simple;
	bh=iM69Sq4EwizlkemOzCEOYImo2uRAkRmz1v8bJzzMirA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jadrL7n5F6i2USh7HrCQh5vGuKMY1Qfi0/B8fSAQi4yF2EkdV6bXuT+49+OnU2+hDRv7LvtevGcn0JUqOtlwy22DMgd44sEc1FjjQAYY4fcGV09ghydXZ/Mr6G70l4Z2M0nt29TLJybhuQ1KVJAx3ZW+cLwnp2bNQUkgEj+VXfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ZlJUPENh; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-2fc8482c62dso518504a91.3
        for <io-uring@vger.kernel.org>; Tue, 18 Feb 2025 12:42:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1739911350; x=1740516150; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D2knz9CJQIa2pL92LuX+mUCXVfehtSkHITIk/Cvm9PI=;
        b=ZlJUPENhekVQuI8QT3qlpchi9uDcRTKkNpmNAJo+vFXw8FXs1DH66hcPNe+VCqRK+5
         UrVkLRiyX9MV/7Ji1DZYef5QYzRlby3gP6eC9oqZJ7+a5oWb4Xc3JiTDnSEZhYSWYksA
         rkRJxYUVN0YGl8mkTogqkUO6hmKUa0srVF6SO9UTgbcvXcLc2w8VAqs32K8MZuHcFlEi
         jbVVh1OHZLiiZCEvuJ6+wGtnxXIsEU5XeMEyoK0nDP7TIhaR3FHS5yJD+tj+v70lUmIK
         Qv7Ua2Xb5okgRxuqbTajJwgpC++6HjV2UfEREdDqB9lK5/1t5wJPrvugYszTqpWfEZtC
         c8LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739911350; x=1740516150;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D2knz9CJQIa2pL92LuX+mUCXVfehtSkHITIk/Cvm9PI=;
        b=MA5vr4xaoLC4FPF5aHZaF7xIsif65p1r86gFUmaw6/7FuPMJZsVK5ZEhFNSRWqwthd
         avLyRhHVnWFOQuIGWwY+MTHns2NX5834iKslPGNFIGVTEvD+bG6jPOMn0xXmM66AOLa+
         6SCXMiQrJHXoPFZoFQxaGk5vZOmjOj4kuiftTLrD7GW0XiH9JgSOrz9eyzLtJm+uI9tb
         giFtf9EYBn0llI0RpRdopKdOiWGvKXzeRVdKldfr8b14xHs9qY4XvhG0ZDHxF9B4+aeU
         oV6u3NfWMrjIk6sxZIBkNDbMdQLBotLX3o2yrMnsU/bLxEcLbSOqrd6LO2LLRi9wlYPQ
         40zg==
X-Forwarded-Encrypted: i=1; AJvYcCXxlA1zBvPEhCHd+HrM2jU6Pgj0MkWss2Ma1n8xtySKWHIzYWCplV3GENkgwFW3+gM4zXM6BUJuKw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwXegYcsmHoa66pTqdtcP+aM1v6q8BtgL0O0zVtnawFAfgKvdlg
	ztZpIRTVRDFmCDY7W1+0jCpO7nH0/6XQZhVA52oOFECic67mp1w+ZjIopevQed4vxyvGhS6LVA3
	r4AcXHS+toiiW/Xd/HyjgwyMO14cctBS6LqNXkg==
X-Gm-Gg: ASbGncu8xbbQ5pMbzGvneblCcAqH7U+1bQFbcSefPxR1HiT2VpxdMZ8IHQC02w8t8dM
	ntB99/7882z9vRwdeCM3wOVDHpQQJNzEXTTQFB9Lbjp1/NGgVR9voZ3GqZOn46rw3mOsfVL0=
X-Google-Smtp-Source: AGHT+IFan/miZiad/qwZ2C19pxW/4XvVVUBhBNZlqk0pS27lbXaO2J9WHXZfVKaerNgUUDgaqnT1kJAwPmh/ZS8WCgI=
X-Received: by 2002:a17:90b:4cc3:b0:2ee:c059:7de6 with SMTP id
 98e67ed59e1d1-2fc40d12454mr9053183a91.2.1739911350385; Tue, 18 Feb 2025
 12:42:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250214154348.2952692-1-kbusch@meta.com> <20250214154348.2952692-6-kbusch@meta.com>
 <CADUfDZpM-TXBYQy0B4xRnKjT=-OfX+AYo+6HGA7e7pyT39LxEA@mail.gmail.com> <Z7TpEEEubC5a5t6K@kbusch-mbp>
In-Reply-To: <Z7TpEEEubC5a5t6K@kbusch-mbp>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 18 Feb 2025 12:42:19 -0800
X-Gm-Features: AWEUYZkgk1bjVjv6uCgcaPbYdiR8HF4EkCSuklvR8ZfmHAAVegnvKIcg4u3DTgQ
Message-ID: <CADUfDZqb-55yAJU1GbDF3tqW=6DhNP+SV3Msx+Sv5GPRHt+s0w@mail.gmail.com>
Subject: Re: [PATCHv3 5/5] io_uring: cache nodes and mapped buffers
To: Keith Busch <kbusch@kernel.org>
Cc: Keith Busch <kbusch@meta.com>, ming.lei@redhat.com, asml.silence@gmail.com, 
	axboe@kernel.dk, linux-block@vger.kernel.org, io-uring@vger.kernel.org, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 18, 2025 at 12:09=E2=80=AFPM Keith Busch <kbusch@kernel.org> wr=
ote:
>
> On Fri, Feb 14, 2025 at 06:22:09PM -0800, Caleb Sander Mateos wrote:
> > > +static struct io_mapped_ubuf *io_alloc_imu(struct io_ring_ctx *ctx,
> > > +                                          int nr_bvecs)
> > > +{
> > > +       if (nr_bvecs <=3D IO_CACHED_BVECS_SEGS)
> > > +               return io_cache_alloc(&ctx->buf_table.imu_cache, GFP_=
KERNEL);
> >
> > If there is no entry available in the cache, this will heap-allocate
> > one with enough space for all IO_CACHED_BVECS_SEGS bvecs.
>
> The cache can only have fixed size objects in them, so we have to pick
> some kind of trade off. The cache starts off empty and fills up on
> demand, so whatever we allocate needs to be of that cache's element
> size.
>
> > Consider
> > using io_alloc_cache_get() instead of io_cache_alloc(), so the
> > heap-allocated fallback uses the minimal size.
>
> We wouldn't be able to fill the cache with the new dynamic object if we
> did that.

Right, that's a good point that there's a tradeoff. I think always
allocating space for IO_CACHED_BVECS_SEGS bvecs is reasonable. Maybe
IO_CACHED_BVECS_SEGS should be slightly smaller so the allocation fits
nicely in a power of 2? Currently it looks to take up 560 bytes:
>>> 48 + 16 * 32
560

Using IO_CACHED_BVECS_SEGS =3D 29 instead would make it 512 bytes:
>>> 48 + 16 * 29
512

Best,
Caleb

>
> > Also, where are these allocations returned to the imu_cache? Looks
> > like kvfree(imu) in io_buffer_unmap() and io_sqe_buffer_register()
> > needs to try io_alloc_cache_put() first.
>
> Oops. I kind of rushed this series last Friday as I needed to shut down
> very early in the day.
>
> Thanks for the comments. Will take my time for the next version.

