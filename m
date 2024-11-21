Return-Path: <io-uring+bounces-4914-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD4129D489D
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 09:16:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7360628315C
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 08:16:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2FB71ADFE8;
	Thu, 21 Nov 2024 08:15:57 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B32A1AC420;
	Thu, 21 Nov 2024 08:15:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732176957; cv=none; b=UJHy0RP0FlGNXB2s2bSP652y6MCqWnlF1DenGn7ejCOyFpPAIBuLAp284ugqnbV1wG01yd4EN9wCehE+8xRf5Ije5GQxpKj5QRzbIEJ6PQdvGeeSaBkm6cNn85LHtiFpXKzBZKk/B7zLpucqQ2XYM/M1uTrzC1VQaZ1n2LKYdzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732176957; c=relaxed/simple;
	bh=9o2/CH4id7fZ663DryZCUjiGj2CBRaiKI71WozjFFpM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HTXmXdmiI46vRRT4iLL0AyVl5ay9PAjTbG+xPx+loLxAX39l0LQsr3bG4PEMcKWDLoUVtx+4ittt+Gj5SVDU4RVes+tojoAMWSz3d7mCJC+Ni1MGkWzaBRTU2kQ97u7Rcll8+kT0jGZ5KNO/s4x9D7D8Z1HOkzDhZ/Uw0FamVaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6eebc318242so5529837b3.3;
        Thu, 21 Nov 2024 00:15:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732176953; x=1732781753;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fa1bafhgnf4UjyHiSsOg5v1diyDhD3E0RXZDuNixLkQ=;
        b=mw1RKNUwy8tZW8U0tbx1lVhrqMMnwXG9ZO8kK50fly97i34fri/arLi6cERj/A8jaP
         DBti9E7qt12BKWRki1+UB1FAJcKWcCgVmDc4Bq2ZLoiQe2W4XO84ETPcv+vpHN++wXuR
         AT1ltkxLh2Dd/QwrVctWxeVKZwn7UCn97k68KNgRGi2qGy0xYn2yyY+E6iIQaI1Ia/u7
         IJP3eSS/kqBR1kceY8g2kZobhYGM7nT86gWQTbdFcx37kMa6qce++GQznyyyHbEuIl4e
         mE8qZWF1CKmkTH9c9Kpl6/RmMKNo7GWIHIY6Ygt1+THKsIG1PLCj9nM8NzH90DzUFPaJ
         cy/Q==
X-Forwarded-Encrypted: i=1; AJvYcCWen/YNkpCg0RU6xCH2mOeNTUmK7G1qi0YFPA9Eg7dk2biBBtetJ1k2RSLGoS5ETTZg9KTfiNus1A==@vger.kernel.org, AJvYcCXFFWPl3Q5cgpoeff00QtjlQc6Iv/obPpoNOPE4Ye80NFSQZEdZ+S2XJL0ypKMoyG1LgRhQYWMYxxJQD1dZ@vger.kernel.org, AJvYcCXnvSApmPnuB7igXKffYyPEfpijiOq+PAxQ2d5YKqTgHtui11bYlxLaKukxOqfNN3fYuA9J48S4wggRrg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxpNi/K1MbjzDVyJJdInaUwZ80SCel+7ceDLF8vfLFUvlv6xklB
	uxgKrD3D2wGBNeXz/WNRZVhN/XyVRBHd1eCitBGNx4H7tqgJiIUnPRfG1A+o
X-Google-Smtp-Source: AGHT+IFNs9xzqjSTuoDKG/VbsgjHOTZpoSVmWKXyFN2pv8oz/YTJqZcinuLSTo9hr4iYI0MUEmrekQ==
X-Received: by 2002:a05:690c:23c4:b0:6ee:ac2f:c6fa with SMTP id 00721157ae682-6eebd13026emr74713127b3.24.1732176953261;
        Thu, 21 Nov 2024 00:15:53 -0800 (PST)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6ee7137f6aasm26001927b3.124.2024.11.21.00.15.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Nov 2024 00:15:51 -0800 (PST)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-6eeb31b10ceso5985737b3.1;
        Thu, 21 Nov 2024 00:15:49 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWJT/DQApNPYjF6m+UesPut5zsBstHjgZklD9PrMvfNlqLr7TiggXr8QcKS0Yhfcm3H4/xdB2wYF8hmR91z@vger.kernel.org, AJvYcCWpuFM/FtqzAd0CKT6wognT+F3YSYG5iYdsBcNEyL5RCQXUo6wmkbTImVw6+d7GBUEv07aVUqnzyU6+Wg==@vger.kernel.org, AJvYcCXw1AyxCxFVBrKFGVMxir0S5huU42jVkky6guNNJGqV4LGF7nQJH6uiD0SG3rboi6zH5nRYcAWsXw==@vger.kernel.org
X-Received: by 2002:a05:690c:7209:b0:6e2:fcb5:52ea with SMTP id
 00721157ae682-6eebd2ae56emr67688777b3.29.1732176948950; Thu, 21 Nov 2024
 00:15:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz> <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
In-Reply-To: <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 21 Nov 2024 09:15:37 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
Message-ID: <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Pekka Enberg <penberg@kernel.org>, 
	David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Hyeonggon Yoo <42.hyeyoo@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Mike Rapoport <rppt@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Guenter Roeck <linux@roeck-us.net>, 
	Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, linux-mm@kvack.org, 
	io-uring@vger.kernel.org, linux-m68k@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Wed, Nov 20, 2024 at 6:50=E2=80=AFPM Christoph Lameter (Ampere)
<cl@gentwo.org> wrote:
> On Wed, 20 Nov 2024, Vlastimil Babka wrote:
> > > Fixes: aaa736b186239b7d ("io_uring: specify freeptr usage for SLAB_TY=
PESAFE_BY_RCU io_kiocb cache")
> > > Fixes: d345bd2e9834e2da ("mm: add kmem_cache_create_rcu()")
> > > Reported-by: Guenter Roeck <linux@roeck-us.net>
> > > Closes: https://lore.kernel.org/37c588d4-2c32-4aad-a19e-642961f200d7@=
roeck-us.net
> > > Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> >
> > Thanks, will add it to slab pull for 6.13.
>
> Note that there are widespread assumptions in kernel code that the
> alignment of scalars is the "natural alignment". Other portions of the
> kernel may break. The compiler actually goes along with this??

Linux has supported m68k since last century.
Any new such assumptions are fixed quickly (at least in the kernel).
If you need a specific alignment, make sure to use __aligned and/or
appropriate padding in structures.
And yes, the compiler knows, and provides __alignof__.

> How do you deal with torn reads/writes in such a scenario? Is this UP
> only?

Linux does not support (rate) SMP m68k machines.

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

