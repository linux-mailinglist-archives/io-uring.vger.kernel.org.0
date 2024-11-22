Return-Path: <io-uring+bounces-4967-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 07FCB9D5A78
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 08:56:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A6CAF1F217CF
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 07:56:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D56C5176FD2;
	Fri, 22 Nov 2024 07:55:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yb1-f170.google.com (mail-yb1-f170.google.com [209.85.219.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB86166F26;
	Fri, 22 Nov 2024 07:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732262157; cv=none; b=m24HrTeWB2Uhxu1B5DTSUtNUOjXOZh5W2KfjnM+xHlsRajRj6Dqb2X11Ur9TcVhmPQDjo6DXwXkKoNRlXP813qOiXC28Ug+YB2ULnUlD2X3UIYFwjwOTQy3w8NQGMyzz2fbT3fWITSZYCO6MJTWSQNQr51W4bFOHo0Xj9k1gmRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732262157; c=relaxed/simple;
	bh=E6XN3WybVfKWKJRQPJ5MNXJpNAvgN5BlD/2FWxJAndk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dfDvC63/Z+ZJozKrT8kWg4GSlUaxhLCG82+gpkxO4uWn3avQwFueiN1tmLEO3VcN7pT3VUULJYRr0tVxNXv3Ekniw5ak4uwUcX7uRNoE8ed94Hcdx+X9YmuSghXfOcBsIdt9Wm0cGlIuAdq3mqjqm/FfxSyi0D37KeJNzQkJhiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.219.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e388503c0d7so1566305276.0;
        Thu, 21 Nov 2024 23:55:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732262154; x=1732866954;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EVhLm7NWxBppx3IfHYH1TmEaGrU/HiyCgYSRO2+1hPA=;
        b=eLBRjKAM58jrtlra4Xy8ayM+xq3SktmUiM/QR7N6Ve/3CiHfiyc5HksTS1phxNbshU
         1aswtRARLoHLMEMDr3DT0ahjYF/A9YFRJ2Zp8A3b8COtkoa2aDzdy2QZ9bDALiGFWq6n
         IbbAB/s22XkBPbJmMXvPQLaVWdQYiRrQInin45GBvKTl1F4/Qxn+dqZ473RWg/gCQEaz
         YTsnnspZnvEzCx3Y77p2XFW5Mnh2CdrQB06Zt9VykCvLOv1+2ExDGkm50o8oCC8nFTdr
         zAdBit3bMpsGPPKqn1Se4J5DnActbl40og+6p0r2a28Nmuv9t9juXve2gBsEh1iw4Pb/
         rUSA==
X-Forwarded-Encrypted: i=1; AJvYcCV01QP29s9Q4/SlnJ0ogUIt30cyYzzp2ceVIZtxAbCB1ggHLNdt2FtBzTR2bszAqLI40tllVkFvd6P6YA==@vger.kernel.org, AJvYcCW3u3tLG79ndVV8yA1iKMORHpTc/BFxVuJXA2uGpwc+/L7nQSvTk7peaCnJpNUtCzSJvznWHlkfWA==@vger.kernel.org, AJvYcCXtBx6UyTdXARSdmBqZZY8y75YVyGglMtWuuSy59PoK8eGbqn8dRVXL69VVbHhMMpPj05SSTvyjMHJzR+SC@vger.kernel.org
X-Gm-Message-State: AOJu0Yxndc3jsesDBAPlDXfKo3/f2gv9BuNZutb4v4EFZdJFkApB536N
	FDc0fSYRF6AsLZ2MKBGRCHJj/Pcf0lB1/edmuFFV546IfVh09SaXti0xzDzv
X-Gm-Gg: ASbGnctzi2u+aqKdfCeNr3hpXVccgUXfVPostWPoXrdXTig8i4cqCyHOqt5TP14mAju
	ylHkddIn9g4UNKDDmcQ+DT8/vh84iWGnfubcfp432fHjZsVm8yCxeh0ZUxTDOiyRKtZZXHQL6V9
	zPrfXoUCXH1sR5YqNrbDz9w2URDfdiMANGTcssXrxMZxgy8yMuXypJOGefKYfwZqK8+H4OmAljb
	JHhwwGpZLWCpQl5e264RNuVS0xEL7bwwEhmbOSjQ0k8MjoZvUK/mzGiQX6/gsIyNQpfSxRTRagh
	Kv3lPEzKHVbGwy78
X-Google-Smtp-Source: AGHT+IHAaw8BiaVDG1QASW5T+kDcdQHvBeKkIQ4shBG+H212FzxkJuGahXjR3VH24z1pOhcWMOJe5Q==
X-Received: by 2002:a05:6902:1824:b0:e38:8646:45e3 with SMTP id 3f1490d57ef6-e38f8bfe500mr1281299276.48.1732262153801;
        Thu, 21 Nov 2024 23:55:53 -0800 (PST)
Received: from mail-yw1-f180.google.com (mail-yw1-f180.google.com. [209.85.128.180])
        by smtp.gmail.com with ESMTPSA id 3f1490d57ef6-e38f608ea41sm452194276.30.2024.11.21.23.55.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 23:55:50 -0800 (PST)
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-6ee676b4e20so19079517b3.3;
        Thu, 21 Nov 2024 23:55:50 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUrWMGyupW6v+flijHQnywWJ2KgopqxbJIxTpZzAiftfiadD7XdXsGnIejP+Vw0J2l7mawU4BITvg==@vger.kernel.org, AJvYcCVRCJr79eOQzWr7kbuBeBe+gC0SkYSm9uDn2//S0hnYaxm9Z5d1h8FWkaWo5497d3sk9ssdBogGjuGoRlNo@vger.kernel.org, AJvYcCWioLNpqSV+jr6c4ZjHbuW4vOMQ2H/n7TlubhDXRVxVN8w6o49Lv4Ry+zckyOARPjSrYRhebH6Rs6FGLA==@vger.kernel.org
X-Received: by 2002:a0d:c2c1:0:b0:6ee:9052:8e18 with SMTP id
 00721157ae682-6eee087b79amr17540997b3.6.1732262149807; Thu, 21 Nov 2024
 23:55:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <d0d818bb9635d43bde2331864733504f6f7a3635.camel@physik.fu-berlin.de> <dcf5f09a-6c68-4391-2b88-cceac7ff462f@linux-m68k.org>
In-Reply-To: <dcf5f09a-6c68-4391-2b88-cceac7ff462f@linux-m68k.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 22 Nov 2024 08:55:37 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWvmwvtA3F3vuYxiDf94Mn2o7TTQ9G-erv-ZfNVjMZrRg@mail.gmail.com>
Message-ID: <CAMuHMdWvmwvtA3F3vuYxiDf94Mn2o7TTQ9G-erv-ZfNVjMZrRg@mail.gmail.com>
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
To: Finn Thain <fthain@linux-m68k.org>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>, Christoph Lameter <cl@linux.com>, 
	Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Mike@rox.of.borg, Rapoport@rox.of.borg, 
	Christian Brauner <brauner@kernel.org>, Guenter Roeck <linux@roeck-us.net>, 
	Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	io-uring@vger.kernel.org, linux-m68k@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 22, 2024 at 3:11=E2=80=AFAM Finn Thain <fthain@linux-m68k.org> =
wrote:
> On Thu, 21 Nov 2024, John Paul Adrian Glaubitz wrote:
> > On Wed, 2024-11-20 at 13:46 +0100, Geert Uytterhoeven wrote:
> > > On m68k, where the minimum alignment of unsigned long is 2 bytes:
> >
> > Well, well, well, my old friend strikes again ;-).
> >
> > These will always come up until we fix the alignment issue on m68k.
>
> Hmmm. That patch you're replying too. Does it make the kernel source code
> better or worse?

Touch=C3=A9 ;-)

The same can be said about commit d811ac148f0afd2f ("virtchnl: fix
m68k build."): if you rely on a specific alignment, make sure to use
__aligned__ and/or struct padding.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

