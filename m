Return-Path: <io-uring+bounces-11365-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 65E9ECF5205
	for <lists+io-uring@lfdr.de>; Mon, 05 Jan 2026 18:59:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 190AA3122E0B
	for <lists+io-uring@lfdr.de>; Mon,  5 Jan 2026 17:54:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA22930BB86;
	Mon,  5 Jan 2026 17:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PH3dzfp3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C202E65D
	for <io-uring@vger.kernel.org>; Mon,  5 Jan 2026 17:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767635649; cv=none; b=D3PaoSXE28V/f22ZSTYcIv1IZeYRneNkS/wqF61NB/WCNVdobIvBJCUnpxw6BhCAhSYszHLnGYtUilrNyq61nNQx0YvokDk9F2NUv4c6oOk0MaZm1WTbjPk4NR+raeiF8ZO/c3XhXl6AEIswVA6cvVlrN+06POyBY3wNIRLSfEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767635649; c=relaxed/simple;
	bh=lnIwyu0MGK/s4uvDRLhmBYt/m+M5sex8Pl6trKfYk5k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EhcPXjNnqTRd6+kkqtlN4mPNtihzzPvQqqxY2XUH3ozAqVR4V+syfLOCrv+7pdbxj6oU9UHj+C8Aem/H328Ai0jwedylI8uunSCMxwbWGUuiPxIkn1+x/kqffhdb3BVUtWQfwi1bZo6fTp4CIe5MBcBTZ72h3MVNP8Cv+RwVk48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PH3dzfp3; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-455dc1cf59aso128227b6e.0
        for <io-uring@vger.kernel.org>; Mon, 05 Jan 2026 09:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767635645; x=1768240445; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lnIwyu0MGK/s4uvDRLhmBYt/m+M5sex8Pl6trKfYk5k=;
        b=PH3dzfp3z5bKHJZohxzX4ktBKuwYQ4wWPGIqxDm6g/JOIxs0sxNo7yTjm7MTPFilJT
         8SD3akNdZC86nzUsKJ+0jmbvo68vG0dRKsByCudLv1kyPazkhcWracfBO9oJGyvtrkJw
         h7yMl5FpmffA61xKxoF9moTOkpKsRIei0nRdcEGQYR2bE5cWxcPOA9L/axQvS+7kCOOS
         dhO/wqZZ0+x2Z3NJeHzYCLXxq9LNCrAlikDkc/MUsUg0EqAhz00tnlZbp5VTzjQWNpED
         NtaQIxgL0JzvOXL2iXYSaJqX4sWTEj4fIFDwAzk2R/xpkH5SrR5jQPTYPgh1uiwmLBTG
         mXNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767635645; x=1768240445;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lnIwyu0MGK/s4uvDRLhmBYt/m+M5sex8Pl6trKfYk5k=;
        b=waQty8glTu6vZpWVYZw5iMX0avBDW+o9CpfeQRUrcMcaOWl1cisOaMy4CmUlKYnD0y
         RF823FxXvYwDu1s1P8NIiaJF1peqhVvSRp/XHsJS4b0Wq97DbFmE50DtzVM8EHtrtw9N
         ++c1Gt7f1LXuTuMpcdEprKQRb/7uRxLcALm2Ae7dwb/cD1pen/1TAR+uqeqMmD6wWCqG
         WyFlFJ3ORtjAMMApSyvpc3gw1UZHtSuKJF004BnZ9KUuaIpNNSuk9SVKtGUGxAMBuvQ2
         eiU+xbZfM5tW16+CKa6sNXQQMpnaSQ+LoSA6QgDhH9I1kxUiQNuL7EpSJijkKH9u5q4b
         VttA==
X-Gm-Message-State: AOJu0Yxdad0i3xAKuGGHr/1OTkk/rD1UBVZr1p8zEaYTr5MEQVaGHsBH
	VvZK8nrSPOi4CAVqeTxTnrVDzW7gY5VLGGsZN7XIkRb05H7ML1d+k1gmvKQ8kuoYhRkdB3Uoq6k
	lZWHWVTC3BEuuJ3auEnKCydWkknjNpH4=
X-Gm-Gg: AY/fxX57Yv5juyQ9IbN4rx3q/g5X92sPtJIn0qRFEHJ/uOkrro7BZK8F6RK2lV9G5gr
	38ETqiNEShNIlR987gI/lodp7CUj/HpQEocU52/Vu17U/rFSwMAymdL4lDoN6g8KaFTMaHtPhfQ
	PD1iywH0ORRNoamnLhBo4BVB4aasMEaQGGcgQ9fHqVH8OYYEnYA+DfUXjmM0jkv6wah9FIkND9H
	VZstreuXVeodvjAg7bl9N8pjo8sSu/CYapWQuqv5yYPBHYpQKuD7Tq4WnPhjLIvxKChCSE=
X-Google-Smtp-Source: AGHT+IH9uLSBzCG1ZtZw56d0yhMQJONe0pg6LmyC4SVlewTWDP/4rBBF3d9E1FUpFnrO3DB9Ab4ewnQqCD+0+tt9MUI=
X-Received: by 2002:a05:6808:1316:b0:453:7530:8adb with SMTP id
 5614622812f47-45a5b027033mr257028b6e.20.1767635645051; Mon, 05 Jan 2026
 09:54:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <79dbdfd9-636d-426c-8299-7becb588b19b@kernel.dk>
 <01086100-4629-4037-b084-a9534d315d9c@kernel.dk> <CAAZOf259y2HOVrCaqMvvegowp9fFgZSx2hqeP=ZfHJ2D9GyUUg@mail.gmail.com>
 <621ecabe-9d60-482f-a02b-accfd3c48966@kernel.dk> <CAAZOf25R3eg0YzyWAyT0hhqe-mngcESKrweoyVcuR6n+7L1Usg@mail.gmail.com>
In-Reply-To: <CAAZOf25R3eg0YzyWAyT0hhqe-mngcESKrweoyVcuR6n+7L1Usg@mail.gmail.com>
From: David Kahurani <k.kahurani@gmail.com>
Date: Mon, 5 Jan 2026 20:59:49 +0300
X-Gm-Features: AQt7F2pee7glxa5GY2ffHvG3V2sD_8Nf6We7F8cLaZWn7HSMCTu3lKHjLIuo0Es
Message-ID: <CAAZOf27yy0Zny-W5WeCGUsN6z3VEg+=Z1Vrx2KSbgT2wr4x3kQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring/io-wq: ensure workers are woken when io-wq
 context is exited
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring <io-uring@vger.kernel.org>, Max Kellermann <max.kellermann@ionos.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Wire that up!

On Mon, Jan 5, 2026 at 8:52=E2=80=AFPM David Kahurani <k.kahurani@gmail.com=
> wrote:
>
> In what case I will,....
>
> Assume a legal protocol.
>
> On Mon, Jan 5, 2026 at 6:54=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
>>
>> On 1/5/26 8:55 AM, David Kahurani wrote:
>> >
>> > work-queue has a bug but I don't know who to report to.
>>
>> Ok that's enough of your random and useless emails. Welcome to
>> the block list. Though that just solves the problem for me,
>> please just go away and stop responding to list emails all
>> together or I'll get you blocked from lore as well.
>>
>> --
>> Jens Axboe
>>

