Return-Path: <io-uring+bounces-7013-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 066DDA56DED
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:37:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6BED81899BE8
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:38:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A466723F292;
	Fri,  7 Mar 2025 16:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LCMm3RKU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF04221D82;
	Fri,  7 Mar 2025 16:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741365332; cv=none; b=p+NL7PTUEuQaXKJmRSplZZxexhYrkLyb7y0c/dnMTTvdhov8YMgW2rl9MrHTVECYAuTc2dhhO3QHxs1xjsHVMlsaJvYw2MAJcYGdPqdCLijxAr1qYM7RnEBHtPv0hDnKPm+hMDVyqPeZ5Z3xZQNrUdpdhbHtiRPT+wWfKll7FBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741365332; c=relaxed/simple;
	bh=hnhlE+0OQEiSQn+c+VHmtDZu7ONh/10XfgpfElJvNHY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SRLcFTqvdHbh9u3ulQBKWOuau3nfhdncgyRehS6YuHbvG0CRubXvbpjbFJ0Ax3tNtGIYy6K5zKd54YhGv01ikqXrZ4QJGLVZISSIRxFTib2zqMyukRo83Vpj8afuvG0lWjydav/soS6Y2SgZcDsCFj0fbzSLbRKm1pCPIGed5j0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LCMm3RKU; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-5e549af4927so3666244a12.2;
        Fri, 07 Mar 2025 08:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741365329; x=1741970129; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bs+apT/tQvTF+BsbilTW0J0ot+r5JZPer6N+2EIjKdk=;
        b=LCMm3RKUTB3z3rPS8uBWGhdkxUBmbgNWMZzEkZ8vsp1fj1kGKwaMdAegCkkK8IlP4f
         TDhULwmCNnt8jtO/KSc4CNNiXn1KLtV2FUeeq7ebelxqULdUmj5GMj0ueAL2OutC2JML
         QszqJAfLKj8ZzFnA72fZVuflLR2ulu7g8qnc22tFIgY6ohQVv9OvZJAUdYJ2+UcH4NRS
         yhRhRNWjhYJmxTtSc3f1E9qRQxL9AssGfcakWucYkopAAm2AmolO0aAFTzRZzgheqmC1
         lciCwWD5jYPuIoEto9J2wbr4op6kFl1BchOGTF45cLOuUV9Hv24fqh6hoGTtyADblnG6
         42Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741365329; x=1741970129;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bs+apT/tQvTF+BsbilTW0J0ot+r5JZPer6N+2EIjKdk=;
        b=m0Kl0rymhguE33FI+rPZMTspLtFhZoHmKVeRS/knqXlvbB0+dcVRTMj4liqx8pmYqB
         lveAJfTYzOv1W2x4F+oGaeBPsiFRFio08HEOjMe2KoEX8YZ3BkUWbKNdkMxgSjVGW+Yd
         HqHc4rRv/xBnUDNyYDjhNw1v1rD6mHzjBZ6+u7L7NUx1Ohvz9jZBJoI6BB87B/KCs4eX
         5PPydalu2t71dalaTRsKZxGA2TVennlGdnlZrd6BTeyy8Y0P86Gxu2J94sumyK/oqQkR
         Hp0Sat5jTbhkyOAu2oLGBqTsFP0VtZuIfCtR+nQ6GjHqG3Fx2TZRT0PGsFXxH7I0q7uX
         L17Q==
X-Forwarded-Encrypted: i=1; AJvYcCU4VKTK5ATAsmsr6R46fMU3wFxLHgR2lwkxvKQkAQSYl27SrtoZqq4XH4J6zghO71JiNjW9dYHY+zYvVCAU@vger.kernel.org, AJvYcCVKZkL7YkU8dYx373mtK+jcQeTJH9GXYytgbhEoRu1txm4IH96jceeyYSd/IGUYTIdNke79dzMyZhk=@vger.kernel.org, AJvYcCVzyxgLbLLSAlazoAkHcUw7Rs2ZtX7nIoedy72opH3hGSck1FgAMlR98c0gzzK9zRD0Un7UPi5jvhjkbvJOlQ==@vger.kernel.org, AJvYcCXJsjnHGdtplp8hz7V0uvpNAWaGnweinZrcvDTtpFf9Xn+r9muSDECipC6a3+ZclNNZZW9NeQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yylx5wucYqG1ZcrXM6CetZEHz7I79R7LvFX27C12j7RqS5szCfm
	5w1I1z/7Vl7gunUrkPwzHY7aLQWxoccwLtpB4Ub7wCXwI49I+KQSkrvYCELIeDrlczfwOLCrMkO
	P3f2OkMg+oSFEG4WWMoZMxZtUDBY=
X-Gm-Gg: ASbGncu0yVbDp6CTeNocNmTuRqwz+P/4T6NLOc9LAhu7xUq6Fncyow9TGLNLod6wJ4H
	7JkWBgl0e+0AnQWMNZNb7RK6ggbmzvPyVYMClvfA0dq91ctnhvQhnY1xtJX+UfExcP1c6/rZVrn
	5BU+8PghUd9ZerB3et39NeIVsR8g==
X-Google-Smtp-Source: AGHT+IGC+vUtpkwJbi1H/qX2S6udJgTLOnCRZMIUxrJQaMNfKycHXMyLZ25+JBQNJkrAQTu6X9gnoGzr8gIi8K/oG0o=
X-Received: by 2002:a17:906:794f:b0:ac1:509:79b1 with SMTP id
 a640c23a62f3a-ac25260a76bmr450748366b.20.1741365328818; Fri, 07 Mar 2025
 08:35:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250307161155.760949-1-mjguzik@gmail.com> <fa3bbf2c-8079-4bdf-b106-a0641069080b@kernel.dk>
 <CAGudoHGina_OHsbP_oz5UAtXKoKQqhv-tB6Ok63rRQHThPuy+Q@mail.gmail.com> <5a0ddd31-8df1-40d7-8104-30aa89a35286@kernel.dk>
In-Reply-To: <5a0ddd31-8df1-40d7-8104-30aa89a35286@kernel.dk>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 7 Mar 2025 17:35:15 +0100
X-Gm-Features: AQ5f1Jpq5_KCzV2s1j_YwgdELUYwTtdvzKji8S2zAocaDna5x7cWeftRslkEy08
Message-ID: <CAGudoHFE8D4itzs=DC14cJpRo-SNqJTz7J4g5B0VsjrNuE0_pA@mail.gmail.com>
Subject: Re: [PATCH] fs: support filename refcount without atomics
To: Jens Axboe <axboe@kernel.dk>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	io-uring@vger.kernel.org, audit@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 7, 2025 at 5:32=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 3/7/25 9:25 AM, Mateusz Guzik wrote:
> > On Fri, Mar 7, 2025 at 5:18?PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >>> +static inline void makeatomicname(struct filename *name)
> >>> +{
> >>> +     VFS_BUG_ON(IS_ERR_OR_NULL(name));
> >>> +     /*
> >>> +      * The name can legitimately already be atomic if it was cached=
 by audit.
> >>> +      * If switching the refcount to atomic, we need not to know we =
are the
> >>> +      * only non-atomic user.
> >>> +      */
> >>> +     VFS_BUG_ON(name->owner !=3D current && !name->is_atomic);
> >>> +     /*
> >>> +      * Don't bother branching, this is a store to an already dirtie=
d cacheline.
> >>> +      */
> >>> +     name->is_atomic =3D true;
> >>> +}
> >>
> >> Should this not depend on audit being enabled? io_uring without audit =
is
> >> fine.
> >>
> >
> > I thought about it, but then I got worried about transitions from
> > disabled to enabled -- will they suddenly start looking here? Should
> > this test for audit_enabled, audit_dummy_context() or something else?
> > I did not want to bother analyzing this.
>
> Let me take a look at it, the markings for when to switch atomic are not
> accurate - it only really needs to happen for offload situations only,
> and if audit is enabled and tracking. So I think we can great improve
> upon this patch.
>

I aimed for this to be a NOP for io_uring, so to speak, specifically
because I could not be arsed to deal with audit.

> > I'll note though this would be an optimization on top of the current
> > code, so I don't think it *blocks* the patch.
>
> Let's not go with something half-done if we can get it right the first
> time.
>

Since you volunteered to sort this out, I'll be happy to wait.
--=20
Mateusz Guzik <mjguzik gmail.com>

