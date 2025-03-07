Return-Path: <io-uring+bounces-7030-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 77398A57586
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 23:59:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8A0F8170904
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 22:59:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD24A2580DD;
	Fri,  7 Mar 2025 22:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OfOv1wsC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296602580C3;
	Fri,  7 Mar 2025 22:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741388345; cv=none; b=fdJped+3+3He+nY8DNGi2RBZv/FA4gOJWVqLw5j76DxmRn1uLNUCQCtqfsVGqHF5sYNycp5eCSZyrkO+mROU7n/hSitjtvaYFN0nxbDHxOABFBkti792pu0RL7zIbh+QQ+g0iAKVQ0/BX6oPUXBnXsN08T9Eelflk7Yvk9+nid4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741388345; c=relaxed/simple;
	bh=HlYncOphUK+gScOpQibhtWz3I5JVYWqT9ueOhL8vm5c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eIbynoRpXmos7halIbfCmSMFtBeBu9Uh3BtnhW8Y14pIpk9q7xMooJDsNVdDS+VocsxtgvVnfVOgYpzl+1K88u5PDAcVQWLUZOno66hpFIhyP+w10OqEmdM/iuYND+ZajXpR76mkrZd5qRhv6nuulleeR4PFhskIiLGwg55hWNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OfOv1wsC; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-abf48293ad0so379043466b.0;
        Fri, 07 Mar 2025 14:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741388342; x=1741993142; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ALyoB0KlEvFAPp+SQpsC3awxPQHvuRybFzmDW1XIvk=;
        b=OfOv1wsChShBItToBe9pKApY08HN99LFi+spuR89yNosBKCre9DoYMuOhOcaef+yA6
         WsDfc2l+ZQk5TwDewcCvfg/9tRMl9hnEtAZ2HL4/+iNuIwjeNEAUhP85DLrZfcmfR7H4
         tXMmUrdxHwZY1NnExkD92D53Yiw4h3pJanRH5C5uJqrP4I6evOIbMdTKwODhSQyr9mR+
         sLqeos2YywacKgD+/VoUrpCImHYFHl6b2gahj1DcOR20ncYUhAuzYQn+t0fvHMGjgsob
         /D+dsVVrOhTHnQ41V4iwEva1BM0pHee2Pux3UZPetSlr2mstQsBrac28+kXxyR+GxDiU
         5Oog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741388342; x=1741993142;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ALyoB0KlEvFAPp+SQpsC3awxPQHvuRybFzmDW1XIvk=;
        b=MFsv03BVsD5rtXxiDWiFxludEtRfm9DJwzZ23BNB/yCiQv8qoJQdK4APmubfPnjaJU
         7xMq6SBGCkR+CdiGtgnlL2HjZEfIhEUhKcqZJUHZwSkj3dZCWr/OYYsk3g/1yVQCqAGo
         C2VgJtpTaYlvdtpqkUH2pSdL67rAOHtwl1w33PuK9Bq52WybSez+K3p3o/yC1+GLv/ll
         uWN+mFrMCIXktlVNDNAhasuzr3EcrF0rbOVBqHCd/AlH0ACeCyeJ3UCjPZXguwitfJjA
         afPJP2lcefdwc4Tuw7nVNS9XOozvueIggXS5YCCjz1ke60hjU3DxxLodGocIT2+CplJt
         K3Uw==
X-Forwarded-Encrypted: i=1; AJvYcCUSbdtKd/sMfdc5jZOGhiGo7aQUsL22apflQwiI8TZB9fbZKify7soC6a2+L8o+VOsrVEeymeI3Rhh7f6sV+g==@vger.kernel.org, AJvYcCV9+eJ9IZYqicnzV9tVSGTcB9fqI+pyiDMluHMcVFHvYRlQVNbbnTFDQY8+OnfnyL2WImxQYW35rKM=@vger.kernel.org, AJvYcCXEToaGQbFGpu2VXS3V55p0kEYhMo9qXqXwQrBDYt96eQQ2K/XGK6KcrvJO4Nyh5QySM/ABlw==@vger.kernel.org, AJvYcCXVnvUAw8FjH2b4cLr7BiDzLFeXiWCpJZ38l7n+LsIs0oXNl3rI8U1p9N0W+YhPoMIAQXGMmjTyDB8x3Avk@vger.kernel.org
X-Gm-Message-State: AOJu0YytY8XYBJ9S4eS3ZIJhe2DhRwxU1Te2SA3CGe5r56XqMf+OLp1U
	wvLB+tRMeno9CTnjb7JwjxA8pgGIigxEWPRBjQkiskIUry7QSCH8WmYs9Uct/FHVdOGKH3ugVwr
	CLNyPgSJOd7kIdljNpdU5fZyL4bE=
X-Gm-Gg: ASbGncsThArmVOy9TW+66P1SNZEoFzbQG6TLqCbNRC2XzebTPDoAfdryyKChP2cfC5i
	0rOiIW2h2prU4+P7t2Fp0zErrmztNAJVZ951u6dHdUrko4A/AjYUR3DYw1zQ0/pJsw4+4K+4UE/
	vLYAPVDgt7QRkFH2wC2XifEFnC2A==
X-Google-Smtp-Source: AGHT+IEihscYizM8NaBKVgZobWKOR2h/cfILGw+7AJBNzL9suSvFIcK5GQAP0Jw187BKOcYel7wqCk4TsjWFtR+TmAQ=
X-Received: by 2002:a17:906:dc8b:b0:ab7:6fa9:b0a9 with SMTP id
 a640c23a62f3a-ac2525e0417mr581474066b.11.1741388342270; Fri, 07 Mar 2025
 14:59:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250307161155.760949-1-mjguzik@gmail.com> <20250307164216.GI2023217@ZenIV>
 <CAGudoHGwaoCMnpFyF3Zxm4BxLqyYD8TiRtpdTyfjJspVa=Re9A@mail.gmail.com>
In-Reply-To: <CAGudoHGwaoCMnpFyF3Zxm4BxLqyYD8TiRtpdTyfjJspVa=Re9A@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 7 Mar 2025 23:58:50 +0100
X-Gm-Features: AQ5f1JpqEqIz2mVVbaZO-Aa9fh9ukY9RzK2Rqy_i9kZ-m73UGmKAXQmsDmSY6mI
Message-ID: <CAGudoHE+VQUtxqtc3v38XFGVojTLqiYXoBU==PFvj=A5kmMMHw@mail.gmail.com>
Subject: Re: [PATCH] fs: support filename refcount without atomics
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: brauner@kernel.org, jack@suse.cz, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	audit@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 7, 2025 at 5:44=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> wr=
ote:
>
> On Fri, Mar 7, 2025 at 5:42=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> > Not a good way to handle that, IMO.
> >
> > Atomics do hurt there, but they are only plastering over the real
> > problem - names formed in one thread, inserted into audit context
> > there and operation involving them happening in a different thread.
> >
> > Refcounting avoids an instant memory corruption, but the real PITA
> > is in audit users of that stuff.
> >
> > IMO we should *NOT* grab an audit names slot at getname() time -
> > that ought to be done explicitly at later points.
> >

I was looking at doing that, but the code is kind of a mess and I bailed.

> > The obstacle is that currently there still are several retry loop
> > with getname() done in it; I've most of that dealt with, need to
> > finish that series.
> >
> > And yes, refcount becomes non-atomic as the result.
>
> Well yes, it was audit which caused the appearance of atomics in the
> first place. I was looking for an easy way out.
>
> If you have something which gets rid of the underlying problem and it
> is going to land in the foreseeable future, I wont be defending this
> approach.
>

It is unclear to me if you are NAKing the patch, or merely pointing
out this can be done in a better way (which I agree with)

Some time ago I posted a much simpler patch to merely dodge the last
decrement [1], which already accomplishes what I was looking for.

Christian did not like it and wanted something which only deals with
atomics when audit is enabled.

I should have done that patch slightly differently, but bottom line is
the following in putname():

        refcnt =3D atomic_read(&name->refcnt);
        if (refcnt !=3D 1) {
                if (WARN_ON_ONCE(!refcnt))
                        return;

                if (!atomic_dec_and_test(&name->refcnt))
                        return;
        }

So if you are NAKing the regular -> atomic switch patch, how about the
above as a quick hack until the issue gets resolved? It is trivial to
reason about (refcnt =3D=3D 1 means nobody can do anything) and guarantees
to dodge one atomic (which in case of no audit means all consumers). I
can repost touched up if you are OK with it (the original posting
issues atomic_read twice).

As for the bigger patch posted here, Jens wants the io_uring bits done
differently and offered to handle them in the upcoming week. I think a
clear statement if the patch is a no-go would be appreciated.

Link 1: https://lore.kernel.org/linux-fsdevel/20240604132448.101183-1-mjguz=
ik@gmail.com/

--=20
Mateusz Guzik <mjguzik gmail.com>

