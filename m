Return-Path: <io-uring+bounces-6430-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 2765CA354ED
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 03:42:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BDD1118913C8
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2025 02:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DB47186E56;
	Fri, 14 Feb 2025 02:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cRM5OT4A"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F105A146D40
	for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 02:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739500898; cv=none; b=e7FfukdlYJUcV3aYqotDlIDm+lSxN//3xMLe9HGndGsfjXQ0tskrSQvfkJPaaQCmRcNYDSmGqe+LXV9OaNfgvZtAPNMkRJIl8SdKhxDlB2GxnhCqNZIzK7L0Sk0UHjFjJrrdI90sZRy7+InfkCpxKNnLoJWsQOMFz6mF7t8WPoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739500898; c=relaxed/simple;
	bh=B/z74+XCYRNQbyZA5GD1IskNrb3Zhtcw8jFYf0cdxSw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A8jG8HjBdJB039qwv4kdpxjZGPLapDbLJu/akORPHS1r2qh0uZGyvqJBpi5XhmUlPDEZduSNhXSDnyhmj2amtoBDnaXUtT36kRuRWVI69jqPEfadIc6LfSth7QeGhI4OALD/3q52ofyhJOf0j/59WsfBRQZWthElTOHX9wYYfuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cRM5OT4A; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739500894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oY3HeRC4LvJtWDgMrIv0daamLvsWqSq1vH+DEF1cFUQ=;
	b=cRM5OT4A/UqKTjvUdaMWp5t9bHX1cVRQkWbFPWx1RAr7cXv5wYrI/wFSHz1wdKo3e8KNR3
	536AR3/owTCHWieFKRhW0QP3d1ZN23+c0rdpYB9nXmZ4wIlgUEXGoRZGfMZNjn/Du+NqU6
	vTgLs6n+yX9RjhIGwVPaIyjZ+kQeEf4=
Received: from mail-vs1-f71.google.com (mail-vs1-f71.google.com
 [209.85.217.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-315-3_YoviJwPRmc1UnIcWZ4cw-1; Thu, 13 Feb 2025 21:41:33 -0500
X-MC-Unique: 3_YoviJwPRmc1UnIcWZ4cw-1
X-Mimecast-MFC-AGG-ID: 3_YoviJwPRmc1UnIcWZ4cw_1739500892
Received: by mail-vs1-f71.google.com with SMTP id ada2fe7eead31-4bbedac7565so1178984137.0
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 18:41:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739500892; x=1740105692;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oY3HeRC4LvJtWDgMrIv0daamLvsWqSq1vH+DEF1cFUQ=;
        b=BSUN9oSBRrnFCDBtakZWUWJyKsOGXtV/ieJuYuqyOWYTADHyRro1M6VzRuT+SuNPB4
         N9V2rBdjuM51K4h9sx+cmXFYpyomkHkp0XJCO155BVLroM6RPp9DCWuHkvoYkGn15Pu2
         y6IA/UoPsm/ZDoB8Ej7fR4HuPYgBpQism97GO9t/Vah2z8gSyJDJkrYnyor+STvHDbwL
         7PPQM6NwVNW8lEgR4BSIAt7HJYW6Ym+pkFSUyvljk6KfSwR3bCfSLg0GriKHktUmLF5u
         E42DLLOoVLyzAhqjrI2Otn6pvsH1ln6OIkEEcgMwsECIKF4C67ZiW0uOiQf/Hg1VOyVM
         1KsQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCmpGb6IGntsQobUcHb9e3bHgPrCOPxFO+TdKYA/yhBXP95m2J840LHuOTePV+7LeqnzzvOF5l/A==@vger.kernel.org
X-Gm-Message-State: AOJu0YwpXQ+8VgAg+eG1HHiYoEvJyBy5AzkKosfFu0PbLu/9vKUj/VQ9
	gNPH0Eo8j9IlDklMm4fFODgI9E/4En/vouK9kZQ9nXoDr11EDhV8wAjN4djBS0OxlTme9rmIMMi
	9Lkx6WA7dUiuMBxE8BzAr3mwii2S3Z+4ENaz6NDm9lwVb80Oaqy5pM1R3YEAeUP9ztNiO80pECU
	NsVHQH9o/5K3on8plgn5OpjMnbqj6Cb7E=
X-Gm-Gg: ASbGncvspn8jdVjAJAdDAMggW09x2lPo5lz0bq0QlB2NOFJK8qi8kMe1vvO1JnFkK5K
	KjYJsfxugggabR1YQqxYBga/iPVHe4bh092plWnwqT1xexjUD6e/Jm2uF56lpkno=
X-Received: by 2002:a05:6102:511f:b0:4bb:ccf5:c24b with SMTP id ada2fe7eead31-4bc04dc08famr4123142137.2.1739500892621;
        Thu, 13 Feb 2025 18:41:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFlNknd1odJ3/aDqkcB+NlCwCd/A7Xq8InqQVQjew8lmX/zxP61iX3HDd604OiofEfsGsQUFKskXo/4atdBjLI=
X-Received: by 2002:a05:6102:511f:b0:4bb:ccf5:c24b with SMTP id
 ada2fe7eead31-4bc04dc08famr4123134137.2.1739500892354; Thu, 13 Feb 2025
 18:41:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250211005646.222452-1-kbusch@meta.com> <83fd69a8aa77450093acb1ada05c188f@huawei.com>
In-Reply-To: <83fd69a8aa77450093acb1ada05c188f@huawei.com>
From: Ming Lei <ming.lei@redhat.com>
Date: Fri, 14 Feb 2025 10:41:21 +0800
X-Gm-Features: AWEUYZmSqHsDWT3Jaz6ZPfcYJH5T0A8PbBnrqR6yS_4yzqCxtudX-fY6ocDczAs
Message-ID: <CAFj5m9JF9RcR4RmbuLB+Hh0NLM1JppGiVvZpmuDce+coQP73-Q@mail.gmail.com>
Subject: Re: [PATCHv2 0/6] ublk zero-copy support
To: lizetao <lizetao1@huawei.com>
Cc: Keith Busch <kbusch@meta.com>, "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>, 
	"axboe@kernel.dk" <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2025 at 11:24=E2=80=AFPM lizetao <lizetao1@huawei.com> wrot=
e:
>
> Hi,
>
> > -----Original Message-----
> > From: Keith Busch <kbusch@meta.com>
> > Sent: Tuesday, February 11, 2025 8:57 AM
> > To: ming.lei@redhat.com; asml.silence@gmail.com; axboe@kernel.dk; linux=
-
> > block@vger.kernel.org; io-uring@vger.kernel.org
> > Cc: bernd@bsbernd.com; Keith Busch <kbusch@kernel.org>
> > Subject: [PATCHv2 0/6] ublk zero-copy support
> >
> > From: Keith Busch <kbusch@kernel.org>
> >
> > Previous version was discussed here:
> >
> >   https://lore.kernel.org/linux-block/20250203154517.937623-1-
> > kbusch@meta.com/
> >
> > The same ublksrv reference code in that link was used to test the kerne=
l side
> > changes.
> >
> > Before listing what has changed, I want to mention what is the same: th=
e
> > reliance on the ring ctx lock to serialize the register ahead of any us=
e. I'm not
> > ignoring the feedback; I just don't have a solid answer right now, and =
want to
> > progress on the other fronts in the meantime.
> >
> > Here's what's different from the previous:
> >
> >  - Introduced an optional 'release' callback when the resource node is
> >    no longer referenced. The callback addresses any buggy applications
> >    that may complete their request and unregister their index while IO
> >    is in flight. This obviates any need to take extra page references
> >    since it prevents the request from completing.
> >
> >  - Removed peeking into the io_cache element size and instead use a
> >    more intuitive bvec segment count limit to decide if we're caching
> >    the imu (suggested by Pavel).
> >
> >  - Dropped the const request changes; it's not needed.
>
> I tested this patch set. When I use null as the device, the test results =
are like your v1.
> When the bs is 4k, there is a slight improvement; when the bs is 64k, the=
re is a significant improvement.

Yes,  the improvement is usually more obvious with a big IO size(>=3D 64K).

> However, when I used loop as the device, I found that there was no improv=
ement, whether using 4k or 64k. As follow:
>
>   ublk add -t loop -f ./ublk-loop.img
>   ublk add -t loop -f ./ublk-loop-zerocopy.img
>
>   fio -filename=3D/dev/ublkb0 -direct=3D1 -rw=3Dread -iodepth=3D1 -ioengi=
ne=3Dio_uring -bs=3D128k -size=3D5G
>     read: IOPS=3D2015, BW=3D126MiB/s (132MB/s)(1260MiB/10005msec)
>
>   fio -filename=3D/dev/ublkb1 -direct=3D1 -rw=3Dread -iodepth=3D1 -ioengi=
ne=3Dio_uring -bs=3D128k -size=3D5G
>     read: IOPS=3D1998, BW=3D125MiB/s (131MB/s)(1250MiB/10005msec)
>
>
> So, this patch set is optimized for null type devices? Or if I've missed =
any key information, please let me know.

Latency may have decreased a bit.

System sources can't be saturated in single queue depth, please run
the same test with
high queue depth per Keith's suggestion:

        --iodepth=3D128 --iodepth_batch_submit=3D16 --iodepth_batch_complet=
e_min=3D16

Also if you set up the backing file as ramfs image, the improvement
should be pretty
obvious, I observed IOPS doubled in this way.


Thanks,
Ming


