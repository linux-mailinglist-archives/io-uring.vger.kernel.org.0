Return-Path: <io-uring+bounces-521-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C309C847A52
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 21:14:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8023628D2BD
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 20:14:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37DE380611;
	Fri,  2 Feb 2024 20:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ifWm9lgg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B0B81756
	for <io-uring@vger.kernel.org>; Fri,  2 Feb 2024 20:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706904876; cv=none; b=e+u46dbo43qqbNzUy5zhUJenez2TQ8eWjQaIH2EowaA3diQPtLALbt9SAH0+WRI5PbKPF/adBTP8DLUkeqPRz2RSH9FIbCU3XZkfrMsjdMnaJRyNuo0xeCIgLiS4syit2iT2Thg1Ms6IoK20x6vuSVfwq7VVuG1CqRsvETyzp3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706904876; c=relaxed/simple;
	bh=i4N/BeV/KzAOCL/UmBx9zSfkeOp7QqTiXjHXpxHO/c0=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=Y826MmL2e6IMMD0cGcYoRpl453nHeqvPaXRL/Txs5/XvmNXpZzgPKN9q9A7Q8LvN9WGGUSnAawScMLK8CWC1SAYcKnr0NZNIdDJ+tbKpWuABfqJYg5dHKtALPbur1QkmiVGgcpoD53mLyrZRH/STffD+ls8wpQw6s3jIMQx65Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ifWm9lgg; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1d3ae9d1109so5145125ad.0
        for <io-uring@vger.kernel.org>; Fri, 02 Feb 2024 12:14:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706904872; x=1707509672; darn=vger.kernel.org;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:from:to:cc:subject:date:message-id
         :reply-to;
        bh=r+uEZbBahAwcKyHndFtR6c+NYRoYzRmqvM14GPnc/+Y=;
        b=ifWm9lggC+CkpxeYmTogmE/L8RnK7HqCkHqFCTYwFa7xxDDgWA8tXn5Krkj58NBjsp
         SjfO1CJLMeLWrv7I5dDw9a8IxiB1ugcMrwwMAEmPPomsrmdPvMoyDW6p23E5apASDqXd
         gOf2Dl0boGKM+fU2Z37DDEGj7uao45ucpzNYzSCbJQ2vT9S98Kv5cMqATvpvpA1Yjr04
         DwNTHf5Ct5rPwqpK2632XEnKnhHgyyQhsQua3Mo1/DBqPfDT6380CZyJoaB7K5M8ZeOe
         c0Lv+AIcpX57zmRL04SMGFnrhIke4K+du5PfgMiTrB5iIMYZGWIECdz8fFxLDETRlla+
         Xw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706904872; x=1707509672;
        h=to:in-reply-to:cc:references:message-id:date:subject:mime-version
         :from:content-transfer-encoding:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r+uEZbBahAwcKyHndFtR6c+NYRoYzRmqvM14GPnc/+Y=;
        b=NFps2OHyyhMTVnWigdEFpzXZBcHXju750c0qIMxWN5+tDWmQro/T/FLu4PfM2iI1hc
         O1tcAkh4SwRsn+jbsUWlWn19rqKoQgM7nKHpDz6GCypdpv7IukFGJ9kvmv13GyWfkILX
         4lR4zFfKjm7qR0HzJDUZXOVgi6LSofBXzmBLTZOz7VErC2myeZRJRJOoWjx/4Y+vxrcX
         0WIG8jIVrPhkfLd+/XC0SRCUBqjJ9NHiICH31L/CbA/7jEVSzY1UVBHFQBrjawWRiRh6
         yR6zCzyL6lJ4QbdxkcH4oJjMOGtnYZHfeWMOi2z6xagwPWhgtKQti3YuXtqPypjf4pey
         U4wA==
X-Gm-Message-State: AOJu0Yx13rBkiX/seYDeZLMDkG90K3RUBOjpzYg1WFdouoYo20/Dm/XX
	3SIJBndGq6Z/kglaJy4UR2yP/xP1DAoSniYPXbYTmj8T8o6AAw/yK6kBexHXDu8=
X-Google-Smtp-Source: AGHT+IFSHOVULABBUQSIoBYVNnvutZ9Y+CsgJc5n9+FdMhhtFA2bGYWIjYJx43N27m69qdkJqqUNrw==
X-Received: by 2002:a17:902:ec89:b0:1d9:451e:4363 with SMTP id x9-20020a170902ec8900b001d9451e4363mr7451951plg.0.1706904872102;
        Fri, 02 Feb 2024 12:14:32 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCW0219MEPoxlMOZ0642yQoefC5jIEOfZG0KCeQY+HPy8r+MmSNrHye/G5l3UgOKioeDgiLtl+9OuZLAcOYq/FDZCi6HXSXaNpAoTts7RLj/urN/yfZJQ8lM90j44zVZGifNBrUdmFM2n3xDdpbQRi994eOiN8Y=
Received: from smtpclient.apple ([2600:380:7774:298d:793b:f0fe:fe73:2ad3])
        by smtp.gmail.com with ESMTPSA id v11-20020a170902d08b00b001d8f6b95dcbsm2010128plv.20.2024.02.02.12.14.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Feb 2024 12:14:31 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Jens Axboe <axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH v9 1/4] liburing: add api to set napi busy poll settings
Date: Fri, 2 Feb 2024 13:14:20 -0700
Message-Id: <07EEF558-8000-436B-B9BD-0E0BAC40C2C3@kernel.dk>
References: <3b32446d8b259219d69bff81a6ef51c1ad0b64e3.camel@trillion01.com>
Cc: Stefan Roesch <shr@devkernel.io>, io-uring@vger.kernel.org,
 kernel-team@fb.com, ammarfaizi2@gnuweeb.org
In-Reply-To: <3b32446d8b259219d69bff81a6ef51c1ad0b64e3.camel@trillion01.com>
To: Olivier Langlois <olivier@trillion01.com>
X-Mailer: iPhone Mail (21D50)

On Feb 2, 2024, at 1:11=E2=80=AFPM, Olivier Langlois <olivier@trillion01.com=
> wrote:
>=20
> =EF=BB=BFOn Fri, 2024-02-02 at 10:48 -0700, Jens Axboe wrote:
>>> On Feb 2, 2024, at 10:41=E2=80=AFAM, Olivier Langlois
>>> <olivier@trillion01.com> wrote:
>>>=20
>>> =EF=BB=BFOn Fri, 2024-02-02 at 09:42 -0700, Jens Axboe wrote:
>>>>> On 2/2/24 9:41 AM, Olivier Langlois wrote:
>>>>> On Tue, 2023-04-25 at 11:20 -0700, Stefan Roesch wrote:
>>>>>> +
>>>>>> +int io_uring_register_napi(struct io_uring *ring, struct
>>>>>> io_uring_napi *napi)
>>>>>> +{
>>>>>> +    return __sys_io_uring_register(ring->ring_fd,
>>>>>> +                IORING_REGISTER_NAPI, napi, 0);
>>>>>> +}
>>>>>> +
>>>>>> +int io_uring_unregister_napi(struct io_uring *ring, struct
>>>>>> io_uring_napi *napi)
>>>>>> +{
>>>>>> +    return __sys_io_uring_register(ring->ring_fd,
>>>>>> +                IORING_UNREGISTER_NAPI, napi,
>>>>>> 0);
>>>>>> +}
>>>>>=20
>>>>> my apologies if this is not the latest version of the patch but
>>>>> I
>>>>> think
>>>>> that it is...
>>>>>=20
>>>>> nr_args should be 1 to match what __io_uring_register() in the
>>>>> current
>>>>> corresponding kernel patch expects:
>>>>>=20
>>>>> https://git.kernel.dk/cgit/linux/commit/?h=3Dio_uring-napi&id=3D787d81=
d3132aaf4eb4a4a5f24ff949e350e537d0
>>>>=20
>>>> Can you send a patch I can fold in?
>>>>=20
>>> Jens,
>>>=20
>>> I am unsure of what you are asking me.
>>>=20
>>> You would like me to send a patch to fix a liburing patch that has
>>> never been applied AFAIK?
>>>=20
>>> if the v9 patch has never been applied. Wouldn't just editing
>>> Stefan
>>> patch by replacing the nr_args param from 0 to 1 directly do it?
>>=20
>> The current version is what is in that branch you referenced. If you
>> see anything in there that needs changing, send a patch for that.
>>=20
>> I can send out the series again if needed.
>>=20
> AFAIK, the kernel patch is fine.
>=20
> my comment was referring the liburing patch that is calling
> __sys_io_uring_register() by passing a nr_args value of 0.
>=20
> This is problematic because on the kernel side, io_uring_register()
> returns -EINVAL if nr_args is not 1.

Ah gotcha, yeah that=E2=80=99s odd and could not ever have worked. I wonder h=
ow that was tested=E2=80=A6

I=E2=80=99ll setup a liburing branch as well.


=E2=80=94=20
Jens Axboe


