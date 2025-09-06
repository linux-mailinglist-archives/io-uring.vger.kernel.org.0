Return-Path: <io-uring+bounces-9624-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 36A9BB47211
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 17:32:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 1EDA31BC4DB4
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 15:32:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E7EB1DE8BE;
	Sat,  6 Sep 2025 15:32:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="hqclO7ZC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 828E0131E2D
	for <io-uring@vger.kernel.org>; Sat,  6 Sep 2025 15:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757172742; cv=none; b=bppxCYcTPn8LhyMAddBFuqg46xMa95wMxR/BkBOE8O1hOR53iS4T/uw2L712LQHa1INRO1Qh/7ZUVQusyBDPtu984LjidfAImdO+BEKNTyTHIugKS6sVKrQf27JknBDfoyjz6aJUQSN/nEr61FpLSjyuusBUfZhyhiU2RU9H5BQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757172742; c=relaxed/simple;
	bh=xKkl3DI8ulz4vlyTXEnWSAZzTPv6U0YxG+xFkiOc4Jw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KkMw1Urr8s6dB3CTgDzUziyvtVdapn+4XDbUS154OVcBiFl5uO0rPtDc+DyVA/Ssir60y5qPXQZOF2cSpLNYSqmGvlp2nqkXpYyGQVsll3T2S4kLcr3kWRD4jd+m+WzCdfOreJLS5PrWl40ll7MpB0hhr1YUemxSrHQosbbxPUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=hqclO7ZC; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b04ba3de760so48688366b.0
        for <io-uring@vger.kernel.org>; Sat, 06 Sep 2025 08:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1757172739; x=1757777539; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lncXm2cx4UB0yoqFu06gxrKnTE2tWicGtIvZ9ZZAkv4=;
        b=hqclO7ZChyCQfVbSPdNG46eGB+VvoFW7XRixCEayUQnoyOr74+FlpbNgqUJUpegvZF
         8lDBetmWNc4oIHma1+lj7xN2YEjtPEbeW83CwHNMj76962BQAfMpwAO2wEX7Deg1gaCY
         WjhzY+P4HCdPngSvmv2/8kNO87t+oAeF2Buac=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757172739; x=1757777539;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lncXm2cx4UB0yoqFu06gxrKnTE2tWicGtIvZ9ZZAkv4=;
        b=rQ4OvYmx/7wkKHB/ZlnLR2pNtzBGrkAJTlGXbA90sxs1DNniC2+TuKo/8aeZn+937E
         ygNNb4oBj+FHwx/hMU8WQnlPthphEigt4aLMB5mUt0nyPHU8wL9GXRhdNVWoN6nLAmIT
         B5N3kKYjQop0jBU2DZP40v/cGrqndkQtASxSQ1VzdEK7PXImy4dU0LJ6IFl+z0hq0AiW
         u0fZfNqAMRQXSJFVQ+K275l3qsYtN+aKoD2j+K7LA0/tWtTNfF+4eiIIdViyQd2KjuoG
         vFjTUGmmk4m1x86JyqJoiCX1RbKjpzEFNo1lCxBYnD5Of9Nye0DuW/VD7pYjc68ec5wt
         F5Vw==
X-Forwarded-Encrypted: i=1; AJvYcCXit77Fhj5P229zopAhSG9kIl3aDLcCyXUBDx/LJvgMSDaLiLEQApSQTz8bthVUZ15Q1OYzUOtD4w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyFI7bRHbeCG5nJxNP4UiN5S4gQsM11z88DzHXdzblq0dY/5Sau
	bG3HwScynL9hEY7dOMlVK2Q5S88T5Yr/EuuV7uwwvHFwEoghVnjgaV2EDSins4fk8KQVrUy4500
	KBqS/do4=
X-Gm-Gg: ASbGnctLj3NfhMlgOeewX/XZfUaNcnYG5nN/TyH2P2N7EHXl8H7f/cyyd7+73hgT7bn
	ZRoYrLhZzVQvOvJgtUlmeCAuZwWYHiqIYgtHko+dZWTFzU7a3+T6b6HRugdZhUyGDU4S9zkcaGr
	8kOHALBYJor3o71H86M9RKaAFoYHeUf3CCpcHnJp7c1Zov2I2NSa6nbVyT5GRiVUv+rGpy2Cx6v
	GMSAQaMBGwSst6cDUFVltXFXzjFPZUN/Bjy5XITAPG5sdhW/3p/L2BXMMlnCgQFP6nove6e241T
	6pnPy4m9aPzsZizmg7nKMifMvSc8U1Rc9bZnBzFg1sQtjtLds+N/yGtJg0RMH+Bu1EmVPT3xqHS
	bCRuwSp3VZJHaQC/m1vQZGvyRId5t0FBYUxjYZ/dGVbNZyJvBDAWrdV6AdFOsexYpnDz2ptKeVJ
	+3kTqw2R4=
X-Google-Smtp-Source: AGHT+IEk0vk/C/k0iAB037yaIMsdyanrFtjgnetnI1GsPnxJOtHCJ1jqRhc6lw0h4uzmnFhs/i0yyQ==
X-Received: by 2002:a17:907:3e8c:b0:b04:522c:e0f7 with SMTP id a640c23a62f3a-b04b16bf0fcmr207334666b.47.1757172738524;
        Sat, 06 Sep 2025 08:32:18 -0700 (PDT)
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com. [209.85.208.43])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b0444252c2dsm1250536066b.81.2025.09.06.08.32.17
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Sep 2025 08:32:17 -0700 (PDT)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6188b72b7caso3554118a12.2
        for <io-uring@vger.kernel.org>; Sat, 06 Sep 2025 08:32:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXek01JvAyspqwHfexcNmRkIRsWNKY2y5uM8cTkRQTuoUdLi61uRX8I2tYrB7g6ASQ4KVVhBfIayA==@vger.kernel.org
X-Received: by 2002:a05:6402:2682:b0:624:591d:42b7 with SMTP id
 4fb4d7f45d1cf-624591d47e4mr1934878a12.21.1757172736702; Sat, 06 Sep 2025
 08:32:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <9ef87524-d15c-4b2c-9f86-00417dad9c48@kernel.dk>
 <CAHk-=wjamixjqNwrr4+UEAwitMOd6Y8-_9p4oUZdcjrv7fsayQ@mail.gmail.com>
 <20250905-lovely-prehistoric-goldfish-04e1c3@lemur> <CAHk-=wg30HTF+zWrh7xP1yFRsRQW-ptiJ+U4+ABHpJORQw=Mug@mail.gmail.com>
 <20250905-sparkling-stalwart-galago-8a87e0@lemur> <2025090614-busily-upright-444d@gregkh>
 <20250906-almond-tench-of-aurora-3431ee@lemur>
In-Reply-To: <20250906-almond-tench-of-aurora-3431ee@lemur>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 6 Sep 2025 08:31:59 -0700
X-Gmail-Original-Message-ID: <CAHk-=wh8hvhtgg+DhyXeJSyZ=SrUYE85kAFRYiKBRp6u2YwvgA@mail.gmail.com>
X-Gm-Features: AS18NWBgyVz1-mW-WIhIbKz5dg1cwF2msJfKl3srmWO6iJRnqem-dLPENbf07RA
Message-ID: <CAHk-=wh8hvhtgg+DhyXeJSyZ=SrUYE85kAFRYiKBRp6u2YwvgA@mail.gmail.com>
Subject: Re: Link trailers revisited (was Re: [GIT PULL] io_uring fix for 6.17-rc5)
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jens Axboe <axboe@kernel.dk>, 
	Caleb Sander Mateos <csander@purestorage.com>, io-uring <io-uring@vger.kernel.org>, 
	workflows@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 6 Sept 2025 at 06:51, Konstantin Ryabitsev
<konstantin@linuxfoundation.org> wrote:
>
> Unfortunately, `shazam -M` is not perfect, because we do need to know the
> base-commit, and there's still way too many series sent without this info.

No, no. You're thinking about it wrong.

An emailed patch series is *not* a git pull. If you want actual real
git history, just use git. Using a patch series and shazam for that
would be *bad*. It's actively worse than just using git, with zero
upside.

No, the upside of a patch series is that it's *not* fixed in stone yet
- not in history, not in acks, not in actual code. So do *not*
encourage people to think of it as some second-rate "git history"
model. It's not, and it would be *BAD* at it.

Instead, embrace the "it's a patch series". You should *not* strive to
make "b4 shazam" think it should recreate the original git tree. not
at all.

Instead, it should be a "here's a patch series with a cover letter,
make a pretty history of it, delineate it with a merge, and save the
relevant information from the cover letter in the merge message".

Look, we already have subsystems that do that. I don't know if they
use b4 shazam - maybe they do, maybe they don't - but the end result
is what matters.

For example, the networking people use this model for small series of
patches, and you can see it in patterns like this (I picked a random
area, this is meant to illustrate the point, the commits themselves
are not relevant):

    gitk d2644cbc736f..f63e7c8a8389

and look at the kind of "pseudo-linear" history, where small series
are delineated with that separate branch and merge, but this is *not*
some kind of global history where people tried to keep original commit
bases around etc.

That kind of global history would be *worse* for the whole "send
patches by email" model.

So don't strive to replicate git - badly. Strive to do a *good* job.

Your comment about how you want to know the base commit makes me think
you are missing the point.

git is git.

And emailed patch series are a different thing entirely, and trying
for some 1:1 thing only makes things objectively worse.

                  Linus

