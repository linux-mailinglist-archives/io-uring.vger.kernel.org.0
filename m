Return-Path: <io-uring+bounces-9180-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3FD99B3014A
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 19:42:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7A45BB61C44
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 17:40:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA59333EAF2;
	Thu, 21 Aug 2025 17:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="Ak2dYf8l"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6E633CEAF
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 17:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755798124; cv=none; b=t0P/vU1GebcDeA4Q/CvqxGOCahIayGFvPY58g5kmCVzOm/e2Qhw1tVsEnA+PATg/9DeyqBvpNoIQpDXvKk9oM97fXUuIooLcZyjaiJyEa7i4HPzr3PVg++KQWMR1LT9HbJpPZGBih9jpIi2b1esMjJ+X+RRfxa6rUFxoDJ2DDOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755798124; c=relaxed/simple;
	bh=lpJQSBv7bNbtgTmRgceJhzssjaee6MRHatUR8Ea3XRo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AqxaNJAbTP547Wo6ZzITZV6RuOh3aGVw514XsyqUIDN0p+5I5qEMprC9A00MvRB8C2vDQmSIaUYEBEE+XVg9N9JGPSSIG7ejhjgwuSfJ25gEM8N2SJKh3Ec8Vuwd4ukn6oNhwBQA46I0GwUy6+WLgChKhS7Z+qnJKu8YoMCFuGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=Ak2dYf8l; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-24498e93b8fso2140545ad.3
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 10:42:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1755798122; x=1756402922; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lpJQSBv7bNbtgTmRgceJhzssjaee6MRHatUR8Ea3XRo=;
        b=Ak2dYf8lAxEVXzQlNrbSYSwOWKe8Pdse+y7Xa+7/nzqZ7lSc7mQywpqKkE+JO9rojN
         Y7N8qSIwp8iTfjU3Uc2Tm+XTi6Kex2S6VnOe+/PITGcJVrt5IZ683snP2IHYfH/3D5Mc
         Ogw8t1+wOidx6U8GpDizkbB5sPShYNpxUXicuI0TQnGex4w7pz6mR5lgwioDOr2XAr05
         IjoNfsihrNBf+i2/VjFjsjyLo0Li5BW4MKwQuWmkQB+D4H26R9etEfAYuJyNA6PeXcNa
         yfEmnqXHwNUEQz2XaXuqrmwEG1p3FbfcEN23BfvgGeAV/UuwDY0TpSyTWflNhumSjNA4
         Y2nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755798122; x=1756402922;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lpJQSBv7bNbtgTmRgceJhzssjaee6MRHatUR8Ea3XRo=;
        b=Z20gBhnTYP3hewIIBnJB09s8A0CLdRgVFiSYnSwSM/jgROY2zAEVfsTyvChrh/JulQ
         8Q2ZEKQoHfqgZW7yKOXaW8EgozIF4o3TsOKXnZiPNWnp/kT1tV++5//p/QbajPZwx+Rd
         IZNqU9AoB9f+B3PauQK/MbDa0VtEGMpDIx4vEa4PPZdQVy2XM4NkASuW+M6B2yv331rD
         znmnBP7U0bagcy99n3Ehxs6Lq+rAnz/MRagP2DITD1iOQRJkG5FiWnu7KIDOnYE8bgeH
         1AVTk/V6uZDGpvO3UaWQgA8cOcTvaHwwiYzQ3p3noulEKNbhy3ydO+njDRRDVP2KtjGW
         vvtw==
X-Gm-Message-State: AOJu0YypsHYVBXN07wjpQmt1Kl3I7ifHKzMTlknijW0TmWg2oJiMBEOg
	piTlOT9lFAVteevFFZKo74ri1Vp3Vo8ecfCccznbGf7CFpqfk4BBp3/rVOJU7AnmSCIrwAKl1D+
	IC3VScNi3GaQS1PPeSwPcWir7Q0Con98vNKFpXmv7sV20bw6PYIXRttg=
X-Gm-Gg: ASbGncvxPlRS+LVeWGJV+p4V9QJjOoB/6vIU+iqUt1eEmBzqP/5taMTqzWIee2kLavm
	t2PErROhe8hERta3c/Q/O83MSukkPJJWT0dleC2Pf4YhHr7EKGBpmOhdNzjHOL1rQPnnLnFhJuX
	Eh3nC0MtCb4FZUBDDBx9l0gHav1AZMRdPoDJ0E5uJ/ggYTB0QBd9Vymit8fryK3v+B+6YPFqzMr
	DEpuvmh
X-Google-Smtp-Source: AGHT+IF8PaWyOJ2JGgd0BCsuRVK8boR8FJwj5cGR1LFt4jGRKRq9q8iVqw3O2Sd7v3e9jHt5m824Y+iic3xBHkWcd/c=
X-Received: by 2002:a17:903:2448:b0:240:63bd:2701 with SMTP id
 d9443c01a7336-2462ef0831fmr1562125ad.6.1755798122307; Thu, 21 Aug 2025
 10:42:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250821141957.680570-1-axboe@kernel.dk> <CADUfDZragMLiHkkw0Y+HAeEWZX8vBpPpWjgwdai8SjCuiLw0gQ@mail.gmail.com>
 <6145c373-d764-480b-a887-57ad60f872e7@kernel.dk>
In-Reply-To: <6145c373-d764-480b-a887-57ad60f872e7@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 21 Aug 2025 10:41:50 -0700
X-Gm-Features: Ac12FXye6vek-TDWEFXmlXvF0iPC5qxAk2kt_sWg_uw-pwjMi3Uhez03WOY2fM4
Message-ID: <CADUfDZpPP2FR1X9hVSkhbtQs=2wtXkeXRBjPDXA9ShSCU0PM2w@mail.gmail.com>
Subject: Re: [PATCHSET v2 0/8] Add support for mixed sized CQEs
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org, Keith Busch <kbusch@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 10:12=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 8/21/25 11:02 AM, Caleb Sander Mateos wrote:
> > On Thu, Aug 21, 2025 at 7:28?AM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> Hi,
> >>
> >> Currently io_uring supports two modes for CQEs:
> >>
> >> 1) The standard mode, where 16b CQEs are used
> >> 2) Setting IORING_SETUP_CQE32, which makes all CQEs posted 32b
> >>
> >> Certain features need to pass more information back than just a single
> >> 32-bit res field, and hence mandate the use of CQE32 to be able to wor=
k.
> >> Examples of that include passthrough or other uses of ->uring_cmd() li=
ke
> >> socket option getting and setting, including timestamps.
> >>
> >> This patchset adds support for IORING_SETUP_CQE_MIXED, which allows
> >> posting both 16b and 32b CQEs on the same CQ ring. The idea here is th=
at
> >> we need not waste twice the space for CQ rings, or use twice the space
> >> per CQE posted, if only some of the CQEs posted require the use of 32b
> >> CQEs. On a ring setup in CQE mixed mode, 32b posted CQEs will have
> >> IORING_CQE_F_32 set in cqe->flags to tell the application (or liburing=
)
> >> about this fact.
> >
> > This makes a lot of sense. Have you considered something analogous for
> > SQEs? Requiring all SQEs to be 128 bytes when an io_uring is used for
> > a mix of 64-byte and 128-byte SQEs also wastes memory, probably even
> > more since SQEs are 4x larger than CQEs.
>
> Adding Keith, as he and I literally just talked about that. My answer
> was that the case is a bit different in that 32b CQEs can be useful in
> cases that are predominately 16b in the first place. For example,
> networking workload doing send/recv/etc and the occassional
> get/setsockopt kind of thing. Or maybe a mix of normal recv and zero
> copy rx.
>
> For the SQE case, I think it's a bit different. At least the cases I
> know of, it's mostly 100% 64b SQEs or 128b SQEs. I'm certainly willing
> to be told otherwise! Because that is kind of the key question that
> needs answering before even thinking about doing that kind of work.

We certainly have a use case that mixes the two on the same io_uring:
ublk commit/buffer register/unregister commands (64 byte SQEs) and
NVMe passthru commands (128 byte SQEs). I could also imagine an
application issuing both normal read/write commands and NVMe passthru
commands. But you're probably right that this isn't a super common use
case.

>
> But yes, it could be supported, and Keith (kind of) signed himself up to
> do that. One oddity I see on that side is that while with CQE32 the
> kernel can manage the potential wrap-around gap, for SQEs that's
> obviously on the application to do. That could just be a NOP or
> something like that, but you do need something to fill/skip that space.
> I guess that could be as simple as having an opcode that is simply "skip
> me", so on the kernel side it'd be easy as it'd just drop it on the
> floor. You still need to app side to fill one, however, and then deal
> with "oops SQ ring is now full" too.

Sure, of course userspace would need to handle a misaligned big SQE at
the end of the SQ analogously to mixed CQE sizes. I assume liburing
should be able to do that mostly transparently, that logic could all
be encapsulated by io_uring_get_sqe().

Best,
Caleb

>
> Probably won't be too bad at all, however.
>
> --
> Jens Axboe

