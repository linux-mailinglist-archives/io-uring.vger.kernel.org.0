Return-Path: <io-uring+bounces-10486-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 5023DC4494E
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 23:40:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id C040B3432A8
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 22:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E31E5258EE0;
	Sun,  9 Nov 2025 22:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hm/ZXnqL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FEE1A840A
	for <io-uring@vger.kernel.org>; Sun,  9 Nov 2025 22:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762728008; cv=none; b=DgcZWJr532LlMp9AFCQN+o+tKmTQdnkKqfoycnCG48OMzVgZ5gsMGTjp1IO2Ght84l0+iWJFSgW+Su5X3WYE7q6qyuMtRuwLEjIc8e8zDnBurDYq0o0AVIaiaeve9bMFoL6dv5+McGinyQPGhGqbJUIMrUJ5sz1iPqQcn9+e5Tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762728008; c=relaxed/simple;
	bh=Zz/RLnXj/ZlmR8T7NF7hLX/IgWqO3vnZx7+cRUL2HaQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t3crVnEqQezy40j+Sh9qzyIl39ue4JH/rUSOIaJ/h7mYCZRxdpKvz8L5y4jUW19XqG2Z9kquLB7kTeOi50dOgF9FjVHbXbnyLOjNMEgvAIm1Rce+HQBGWFYB3fBpkAR5EYTPFMopTEgfnh7ymCujmwBuZvG5kZivrad2SS4Va1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hm/ZXnqL; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-640e9f5951aso3739398a12.1
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 14:40:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762728005; x=1763332805; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zz/RLnXj/ZlmR8T7NF7hLX/IgWqO3vnZx7+cRUL2HaQ=;
        b=hm/ZXnqLeWIkLRXqpmqqqjAVkNtWvpAoYc4xya6uI0mJrk2a7gM9QAerILpH6Mu6Li
         dOxlReETQNYnRRfRwXVpcVvRq1hi8WfKyi4ny4mrkxpqwLcX3qEZQbdkTj6RSASb5lao
         fCc/aDC8H0owkjusWW4nDlpBl2nyvw2IQBvC1+5mZ4b+0ifon9Nx6CPpxJ3JtHK79Tsq
         jHjWzP2ppXQC6g1b2kUDW55NuOu5fHsTcnrsnJ7yjC4rsioE8r7Wye+GXj7ChtrpFbO9
         7inDbkRVthpXWyZqk3ySGO9dDL3F0/j/MTmpFLsQwoWWv29LCg9znLefrV88a2kaTcCr
         jEuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762728005; x=1763332805;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zz/RLnXj/ZlmR8T7NF7hLX/IgWqO3vnZx7+cRUL2HaQ=;
        b=l0HJ3RHpq5t0DwowFVgEk7dgQfCXlKBOa9SUgbTaT57SrfRoQi2Ozet2f/a8AU49eC
         uoqbvASjXbai6X6Jy6l2o0sfxMKXQa7bnXyPNQP/HDOC56qFTIbUokb9IfEA0UhT49Ud
         CIMNpML2hZd/lkBpFoQGMqkfkW3E6hn2EzJPTvQ72mpgF6QuvndhpNegxbazgu0JH/Py
         ZrwMyzzCgUfQjY2ModJvS27jBeQ1s9koUkBUndFB1rIbXfRT6y8omGsJ6M0EbT7IIxGM
         rxxRrdHK5/bpzi2KiiyRDHOgZTmz+JgU2+vG+2n37HO0Oo5qBF9UwLgRzk5IhZravAQk
         HXHg==
X-Forwarded-Encrypted: i=1; AJvYcCXgXHddUhIrh0EffFRK/SpO+bVT9S5gE/W88CQuB5LxIpYSVB7PdrpYFzNwbsbi2QvjBuDgQvbLQQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxBFjBlgo+E1PeCvoZLRimobWLwmWO8RZNqx0dwiCrJpuLcG9xX
	+Z0NabBrhjKfsOmycjsDEEBzbAD+fkQw8M4+XryrPk0HKI/UtXPHup5iQsDdO1WIOhIVftRN1Os
	k8NhwAg2gOZ90idF19ZeUMNRo/EO0TDQ=
X-Gm-Gg: ASbGncuN9/Ncp+pFc2MHAy+EGXMmrSz7sMlKjHBM4nHXOepBaWXzlq8T2/VrJ35/JWt
	x7UVhl/4869vFz0Qec5vcyOBTMUkWQI7x9fIiwG+YdkuW5avUXPjDtNji28xTpbRiF1Zupjs0ia
	EhDLqsXFJw6su8REwpLM9g2qvSV9IvHOMltNXlf6vCd2c8n317mLpJMLCteCIlaJKao1EkdqJ8B
	94d1pj7RmVfCB00xgNGyhI4/YKx2EDblBN60cRgLhHxqK4L4sRC2/jaq+fpX9MM97ceNGw9C1Sb
	11s24lPY/lO0dJ8=
X-Google-Smtp-Source: AGHT+IEf2G3FM0i2bVmOUG7+vPY37y6f5todMu8F9N/qNHio4HbRPNWL68hqLfVk+zbwZK2GIQZm3Q4XqlDpU7RXT50=
X-Received: by 2002:a17:907:60d6:b0:b6d:545e:44f6 with SMTP id
 a640c23a62f3a-b72d0954176mr884727066b.12.1762728005401; Sun, 09 Nov 2025
 14:40:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk> <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAGudoHHoSVRct8_BGwax37sadci-vwx_C=nuyCGoPn4SCAEagA@mail.gmail.com>
 <CAHk-=wiaGQUU5wPmmbsccUJ4zRdtfi_7YXdnZ-ig3WyPRE_wnw@mail.gmail.com>
 <CAGudoHGCkDXsFnc30k10w-thxNZ5c0B9j26kOWsCXkOV8ueeEA@mail.gmail.com>
 <CAHk-=whxKKnh=rtO9sq0uUL76YGLB3YTb98DVBub_84_nO6txA@mail.gmail.com> <CAGudoHHA_dDXMZFh1=U=AjPsqK9PRUGq3fQ_GjOdebUBK-sn3g@mail.gmail.com>
In-Reply-To: <CAGudoHHA_dDXMZFh1=U=AjPsqK9PRUGq3fQ_GjOdebUBK-sn3g@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sun, 9 Nov 2025 23:39:53 +0100
X-Gm-Features: AWmQ_bm4fdxC6v1rOIJ15dLgNbIpqHp2QfAR172JK6y5Y6KlspYKYyOefkgBoCA
Message-ID: <CAGudoHHMgY0NnN0FX_OQnV578Wu1e03VjO8+3tUA8XDxwy_Smg@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	brauner@kernel.org, jack@suse.cz, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 9, 2025 at 11:33=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> w=
rote:
>
> On Sun, Nov 9, 2025 at 11:29=E2=80=AFPM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > On Sun, 9 Nov 2025 at 14:18, Mateusz Guzik <mjguzik@gmail.com> wrote:
> > >
> > > You would need 256 bytes to cover almost all of this.
> >
> > Why would you care to cover all of that?
> >
> > Your very numbers show that 128 bytes covers 97+% of all cases (and
> > 160 bytes is at 99.8%)
> >
> > The other cases need to be *correct*, of course, but not necessarily
> > optimized for.
> >
> > If we can do 97% of all filenames with a simple on-stack allocation,
> > that would be a huge win.
> >
> > (In fact, 64 bytes covers 90% of the cases according to your numbers).
> >
>
> The programs which pass in these "too long" names just keep doing it,
> meaning with a stack-based scheme which forces an extra SMAP trip
> means they are permanently shafted. It's not that only a small % of
> their lookups is penalized.
>
> However, now that I wrote, I figured one could create a trivial
> heuristic: if a given process had too many long names in a row, switch
> to go directly to kmem going forward? Reset the flag on exec.

Geez, that was rather poorly stated. Let me try again:

1. The programs which pass long names just keep doing for majority of
their lookups, meaning the extra overhead from failing to fit on the
stack will be there for most of their syscalls.

2. I noted a heuristic could be added to detect these wankers and go
straight to kmem in their case. One trivial idea is to bump a counter
task_struct for every long name and dec for every short name, keep it
bounded. If it goes past a threshold for long names, skip stack
allocs. Then indeed a smaller on-stack buffer would be a great win
overall.

