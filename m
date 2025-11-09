Return-Path: <io-uring+bounces-10483-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 655A6C448EE
	for <lists+io-uring@lfdr.de>; Sun, 09 Nov 2025 23:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id E81C7345EFB
	for <lists+io-uring@lfdr.de>; Sun,  9 Nov 2025 22:18:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54D971C84DE;
	Sun,  9 Nov 2025 22:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CZTc4/BD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F05C23C4E9
	for <io-uring@vger.kernel.org>; Sun,  9 Nov 2025 22:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762726729; cv=none; b=NfJibyVYew7wkHw8bf9I5ECKX71wrZIc2kNkQ4kcqFRoXI+3v0KhqAYmSdadFN7S/O3WQ1+o7Rn56lHf4KajvGXNQuv4/2nCaA/B/X7ZaUoheoCketC/AaT9KeyF67P2inpTguVoMdDZHifFMxAJqg9W1tt1rD3UODH81OWbHaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762726729; c=relaxed/simple;
	bh=slULiQ1LSn8YdkuFl/xC8oqHmgXF0LLOx5h8vaRWxRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H3P6GyUW/6kmTYCzz/hvu8Fpt78Mm8WYyApoqyxE/6OIp6wbT2tCihs8FPgmHf2HFeMO5KDog9lPJfyGevaZPis6toSFghMJvv3UJGlGPEhIfVUZlE+sQT66x+QirIilAHQLAp25USb7ALDmCit5RXEWkO9057q+4NNhsyeK9rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CZTc4/BD; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b7260435287so360386266b.3
        for <io-uring@vger.kernel.org>; Sun, 09 Nov 2025 14:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762726726; x=1763331526; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+9yqoMpO/6oIYxh6F8d/nAhX/lmSSgeTXQGQsqpmEKQ=;
        b=CZTc4/BDF4EvwReUH8D2bdsv7NGLWE+fDuxrCZO5PqmF3NW0qe5eelDUkptzi0hohc
         lb3FsenPhLD3TyhZkXO0RVtBidEn/lBft3Kp2bFiQykRp4geYi/Us4mEutRrF6Wxdbqr
         qkvFccNFonPYvlZ2srQuNXG3wdGfNk4nyfpb0/mwuKlp9shaieJ3S+5XiSNAo8hcs/yP
         jmHQvpGD8i78AFAUlQ26ct64TkG0frpKDNYkX+Gyk9sqalF/0lbu81CHdVyFc+KMCXh9
         HPJhAm6R2xUiPq+K32r0kKSM3gz/k7X3fiL8PIk9qm4v7EMY/0f00MrA5q8/AmOG4rn2
         DO2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762726726; x=1763331526;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+9yqoMpO/6oIYxh6F8d/nAhX/lmSSgeTXQGQsqpmEKQ=;
        b=ZUqPgEqPNmlG+KBMk1uWhJlEOXQBE0YVo1JhA6tq3eKz9GUpRH4aWMqhqUudijbVP8
         HXN/EZQ1f5s1F/1a7gwgOf2S7veJk0c2jAxzITECZHerKOi5YTLOvDRYuCh1ivehap8g
         bgDfxbUvOb4sKVWr3o1MZzpUUhnzddn5+/mOzNCQQp/S0XU2gPVTJa6d025+ZxjhIVgK
         oiXlUATBbPuvqjOIy46EJNSNjrJv9YtIHEKXh51LdzaggJ/82XXQmTvlX8mU+rliNE/6
         9yxTAeLv1n8tUgalA3ONEm25VCCL6Lrz4N8Vs/mqEAkz9fsgxw3fri9Nu89uCcYDNYT4
         ugVA==
X-Forwarded-Encrypted: i=1; AJvYcCUgUnsvQmyYGnNCNSCEsDBjmJvaxQ1GjDo6JEU1KvTvzYVolwBOidf+5xkO7t55/SmshDYplZJo+w==@vger.kernel.org
X-Gm-Message-State: AOJu0YyiK9Cd09MU3sbJjFu1qVaP5JcKom70C14a51hHCs/bbRDrLt2c
	HbPzq1BqJTVCgC0eaWIegR07uqVGeNvsgEwMEmgrrN6HqWs8aQK+zMWaQSNDqEPAETpCkNod3Su
	bgMisnT7Jg3pgFy6TKZz96DtCqvkLpeM=
X-Gm-Gg: ASbGncslKKOgqrpnNfiYDF0fcfhE0yoZxVhiWXa0Y3Ndb46uL1POmWeEIqDftdz5DBW
	JSYvkqmrZzk86UR/sNhPyZiyASR7XInBqiZeYpEcjcztlHH/h+i74l86UUc8HS/VZuE9QfkrnJz
	smylCwmlzbsSUpNwPrhAz1wmxZ2tkjy9MpXLzidG12d+ac0AW2BFA3sfq49KYC3IUl8lKVCwpIm
	H+nIuIlCrw9JKdOYS2gu8PLKALD+yGDnh9JkQQqu/zSysv18Tk6r+hBdBnfdrs7KadTwid6Vjrp
	F8hYKE+ewWsH16g=
X-Google-Smtp-Source: AGHT+IFf1ZtqJyrB5MOuTg4/YWN68+L2rXBSEutsf5O57w31PlNv4KIPNyR1/rt/eMA363AAdWzsVunYcgFyWawwQQ8=
X-Received: by 2002:a17:907:3f9b:b0:b72:62b2:26a1 with SMTP id
 a640c23a62f3a-b72e0337345mr479536666b.19.1762726725731; Sun, 09 Nov 2025
 14:18:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251109063745.2089578-1-viro@zeniv.linux.org.uk>
 <20251109063745.2089578-11-viro@zeniv.linux.org.uk> <CAHk-=wgXvEK66gjkKfUxZ+G8n50Ms65MM6Sa9Vj9cTFg7_WAkA@mail.gmail.com>
 <CAGudoHHoSVRct8_BGwax37sadci-vwx_C=nuyCGoPn4SCAEagA@mail.gmail.com> <CAHk-=wiaGQUU5wPmmbsccUJ4zRdtfi_7YXdnZ-ig3WyPRE_wnw@mail.gmail.com>
In-Reply-To: <CAHk-=wiaGQUU5wPmmbsccUJ4zRdtfi_7YXdnZ-ig3WyPRE_wnw@mail.gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sun, 9 Nov 2025 23:18:33 +0100
X-Gm-Features: AWmQ_bldKLq5SKxMLtJgZsZW6GApk3TIsKpzw-Bqk5FLnfMtaX5q0jqoDirdRGQ
Message-ID: <CAGudoHGCkDXsFnc30k10w-thxNZ5c0B9j26kOWsCXkOV8ueeEA@mail.gmail.com>
Subject: Re: [RFC][PATCH 10/13] get rid of audit_reusename()
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, 
	brauner@kernel.org, jack@suse.cz, paul@paul-moore.com, axboe@kernel.dk, 
	audit@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 9, 2025 at 9:22=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Sun, 9 Nov 2025 at 11:55, Mateusz Guzik <mjguzik@gmail.com> wrote:
> >
> > I looked into this in the past, 64 definitely does not cut it.
>
> We could easily make it be 128 bytes, I just picked 64 at random.
>

I see I neglected to mention, the lengths I had seen were untenable
for a stack-based allocation. Going with a smaller on-stack buf means
having to retry with an extra SMAP trip which probably makes it a
no-go.

While I can't easily redo the survey on Linux, here is a taste from 10
minutes of package building on FreeBSD. A histogram of lengths with a
step of 8, rounded down.

You would need 256 bytes to cover almost all of this. Maybe 192-ish is
a bare minimum where the idea is likely a win? But even then the
people who want 8K stacks probably wont be able to use the feature to
begin with.

dtrace -n 'vfs:namei:lookup:entry { @ =3D
lquantize(strlen(stringof(arg1)), 0, 384, 8); }'

 value  ------------- Distribution ------------- count
             < 0 |                                         0
               0 |@@@@@@@@                                 18105105
               8 |@@@@@@@                                  16360012
              16 |@@@@@@@@@                                21313430
              24 |@@@@@@                                   15000426
              32 |@@@                                      6450202
              40 |@@                                       4209166
              48 |@                                        2533298
              56 |@                                        1611506
              64 |@                                        1203825
              72 |                                         1068207
              80 |                                         877158
              88 |                                         592192
              96 |                                         489958
             104 |                                         709757
             112 |                                         925775
             120 |                                         1041627
             128 |@                                        1315123
             136 |                                         664687
             144 |                                         276673
             152 |                                         150870
             160 |                                         82661
             168 |                                         40630
             176 |                                         26693
             184 |                                         15112
             192 |                                         7276
             200 |                                         5773
             208 |                                         2462
             216 |                                         1679
             224 |                                         1150
             232 |                                         1301
             240 |                                         1652
             248 |                                         659
             256 |                                         464
             264 |                                         0


> > Anyhow, given that the intent is to damage-control allocation cost, I
> > have to point out there is a patchset to replace the current kmem
> > alloc/free code with sheaves for everyone which promises better
> > performance:
>
> Oh, I'm sure sheaves will improve on the allocation path, but it's not
> going to be even remotely near what a simple stack allocation will be.
> Not just from an allocation cost standpoint, but just from D$ density.
>

I completely agree, but per the above the sizes look unwieldy for the
stack. This is something I tried to do years back and backed off due
to that reason.

> That said, I partly like my patch just because the current code in
> getname_flags() is simply disgusting for all those historical reasons.
> So even if we kept the allocation big - and didn't put it on the stack
> - I think actually using a proper 'struct filename' allocation would
> be a good change.
>

I don't know of anyone is fond of the current code. ;)

