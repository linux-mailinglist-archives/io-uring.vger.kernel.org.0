Return-Path: <io-uring+bounces-4245-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 651DD9B6E55
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 22:02:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0A61D2825C6
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 21:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93177214424;
	Wed, 30 Oct 2024 21:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FZHhEUJk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E67A1E1A23
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 21:02:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730322139; cv=none; b=DDCN+eZLFkSnBSBsmUlNocGlKQKngxnOWHUBeodNarDD3AUt/4qQvMXb0BV67RTav2wWW4AbpU3hxqJou98gpKgxYSapUI8HK0CQyAsF3Ao3q9UV2Evz7TDKlZmUYYxSyTDmmml8Qu+4waGoDitMTlYlEWRiTmbUSVBLqEH66Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730322139; c=relaxed/simple;
	bh=1zv225TPBxG7gQ/j80/0J3HP5DtoFMwaFca/BXjRwcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wtt7dj+nFv1pRNdzgddE79mwP+mk5+oe9LBMyL4KYCGNwXlmCS2TkyED3vyQhX3tALv8XmTXHLz+9sH6109Khn3fmiIOu1FDzsI5msC3O4EhLWDE2M+33wDyA2bOdN1ilafaVMDjbaCi6tCxrtEmOsfJBX02gjP5C72n+/3fbzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FZHhEUJk; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4315a8cff85so32525e9.0
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 14:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730322135; x=1730926935; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c1UKyN+LWjqlqihQSedAnBg3Va1N0+wJzuEwAa9RXbM=;
        b=FZHhEUJk7PTyVNO33Tm6v6siAzIp8e/KvIlq1mMsZ1uAg9gSY9WAAgC6r+PE1aph/f
         GSwvmmWfzO+qmh1VWEDAbMjqU0fYbyqnfkeFMg1WyxpB0COs1K5Ni5MxphCHlAZrDQef
         n3fXidxCwTSsnpTiRDUOH9j+wZJ7/ZE64rKtw2U1IMnQ2lpM63aRqA/lpuN35gRHd762
         Gfs7x+NWOSXwd/8HfX/pEggfwwmLeullJ0nx29/AgLveB/j/54ggOHIkPm3riJF+JSIR
         jXD50aj9eMThxwBw+PkQkMcZ3WaqzXhzYPbClFdMT2tZJD8GBC9YJeyHhPGvh7TaE8vM
         zbRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730322135; x=1730926935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c1UKyN+LWjqlqihQSedAnBg3Va1N0+wJzuEwAa9RXbM=;
        b=Vaf9ZjaAqYmIOkLGl6HoqSdGlwgtrI5XMUe0MauLdXT/exnp58jN1fpoQOh6M811tF
         enrKqrnwx7HAX68AEyYnCrW62m4Heu+XzIMJVBZCJo1bEh4ijATNFEk+kY2/do4AxRST
         MFcxsjwrabNZiZu0G1hOben+2j+zw3loLeI0CbuYL0otONt1LZU8hYTL09bo4Dk+Ew1t
         N7HKxrv1O5PhECylr4PpyNaaCJu2uwdUJxCp+g2dEhWJdbgEFcNPij1Xy6+1eYVhOA+K
         9tU1+euRbEEi2BBAR7TT3CmBBlWzImqu/jjUk9Yzj9IaE3IRiqxN8BzBU4m3lHbpDf7R
         6hsw==
X-Gm-Message-State: AOJu0Yy3HVGhBpFFxgzUWldqg1DOsOqQab9lixN1UmZkTXFhsEIZ/Qnn
	GmQXiY4BkPJoa6h+c9VerBtpFG4VRkwmtvkH8Nz5bpZq096wdvF08a2tjfsnT65usRjdH/MMV79
	jkIfHdlUScsPc13M6t3u1YUp4lk+K5/tkp3XO
X-Gm-Gg: ASbGncvC5Ut/LwYkJhv3JiOrbsIxri8aBF4EuRq4zvdzLFyj+n1PKt1XaA4x9jypkRV
	O4SESrv48ASs80mTrn6VyZYBAG4DbKnS27z0Bsjqy9jfZGIFyHfRHiUByg5A=
X-Google-Smtp-Source: AGHT+IGakSGT28IqgddBpFfiv2arqQ15X75SJu5oJsjIUhtfkReu8taQKMVBuaz563rd3q/tRWUEouzb0ElqA3RJ+IA=
X-Received: by 2002:a05:600c:4e45:b0:431:3baa:2508 with SMTP id
 5b1f17b1804b1-4327d9039cemr259155e9.3.1730322135044; Wed, 30 Oct 2024
 14:02:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <db316d73-cb32-4f7f-beb0-68f253f5e0c5@kernel.dk>
 <CAG48ez1291n=0yi3PvT0V0YXxwtP9rUbXMghYsFdkia1Op8Mzw@mail.gmail.com> <eb449a55-f1de-4bab-a068-0cbfdd84267c@kernel.dk>
In-Reply-To: <eb449a55-f1de-4bab-a068-0cbfdd84267c@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Wed, 30 Oct 2024 22:01:37 +0100
Message-ID: <CAG48ez3W+dkCerwioHNiZCWKJkuf9aL1s6SxN8X=yJ=JbGMB9Q@mail.gmail.com>
Subject: Re: [PATCH RFC] io_uring/rsrc: add last-lookup cache hit to io_rsrc_node_lookup()
To: Jens Axboe <axboe@kernel.dk>, Robin Murphy <robin.murphy@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>, 
	Catalin Marinas <catalin.marinas@arm.com>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 9:25=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
> On 10/30/24 11:20 AM, Jann Horn wrote:
> > On Wed, Oct 30, 2024 at 5:58?PM Jens Axboe <axboe@kernel.dk> wrote:
> >> This avoids array_index_nospec() for repeated lookups on the same node=
,
> >> which can be quite common (and costly). If a cached node is removed fr=
om
> >
> > You're saying array_index_nospec() can be quite costly - which
> > architecture is this on? Is this the cost of the compare+subtract+and
> > making the critical path longer?
>
> Tested this on arm64, in a vm to be specific. Let me try and generate
> some numbers/profiles on x86-64 as well. It's noticeable there as well,
> though not quite as bad as the below example. For arm64, with the patch,
> we get roughly 8.7% of the time spent getting a resource - without it's
> 66% of the time. This is just doing a microbenchmark, but it clearly
> shows that anything following the barrier on arm64 is very costly:
>
>   0.98 =E2=94=82       ldr   x21, [x0, #96]
>        =E2=94=82     =E2=86=93 tbnz  w2, #1, b8
>   1.04 =E2=94=82       ldr   w1, [x21, #144]
>        =E2=94=82       cmp   w1, w19
>        =E2=94=82     =E2=86=93 b.ls  a0
>        =E2=94=82 30:   mov   w1, w1
>        =E2=94=82       sxtw  x0, w19
>        =E2=94=82       cmp   x0, x1
>        =E2=94=82       ngc   x0, xzr
>        =E2=94=82       csdb
>        =E2=94=82       ldr   x1, [x21, #160]
>        =E2=94=82       and   w19, w19, w0
>  93.98 =E2=94=82       ldr   x19, [x1, w19, sxtw #3]
>
> and accounts for most of that 66% of the total cost of the micro bench,
> even though it's doing a ton more stuff than simple getting this node
> via a lookup.

Ah, actually... a difference between x86 and arm64 is that arm64 does
an extra Speculative Data Barrier here, while x86 just does some
arithmetic. Which I think is to work around "data value predictions",
in which case my idea of using bitwise AND probably isn't valid.

https://developer.arm.com/documentation/102816/0205/ section "Software
Mitigations" says "Such code sequences are based around specific data
processing operations (for example conditional select or conditional
move) and a new barrier instruction (CSDB). The combination of both a
conditional select/conditional move and the new barrier are sufficient
to address this problem on ALL Arm implementations, both current and
future".

