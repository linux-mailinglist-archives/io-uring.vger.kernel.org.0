Return-Path: <io-uring+bounces-4968-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A0379D5ACD
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 09:13:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F40BC282E6A
	for <lists+io-uring@lfdr.de>; Fri, 22 Nov 2024 08:13:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FDD018B49B;
	Fri, 22 Nov 2024 08:13:14 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A3018B473;
	Fri, 22 Nov 2024 08:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732263194; cv=none; b=aySB6VEwcLEqWhSuTzKlvGvuC/32YjTesThlLawREm5KoJzkIh1AwC4EHG6iG6oieNDijYuD5JDIASBWmptGFCcP6GqmwvsovHvbA1fsQT0nLPYzasJ7b5r3V7MoXXzrhKLfrw/T8Li7bbFLUsqu5b3aoZr5cRVoopeArNX/vls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732263194; c=relaxed/simple;
	bh=LbOLFojxcfyzAklUw5cwO4zjy2rTwk4KEoNqXm6dc4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UIApu7uUnNCOlN1ipKP01NfWt1xkqB3wVLL+fDi1J8e0N42Y0hEqRSsqOxSUeo6XoRgRx9ppDOt0kwS76JVy1xNcN/vrVyvdFyq08j1UDsShb2+D4SIMP/2Ud09kHM2ClWylWVkh6iZ3FpKtJeYtaZEGze87mWSMfDLxXqhURaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6e34339d41bso16144597b3.0;
        Fri, 22 Nov 2024 00:13:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732263190; x=1732867990;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mO9rZ5AY2OuRFdM9V5RIN4QlTmf1cSQXYB3CfBzBqgk=;
        b=Cexi3roxMzzuQ/lwzo8SPV2VTg8OkD90ovXicWgPdOia9fsSpIJMxNDVHnulQ2hv6Z
         i3gVWLB0xDEUOUvXyJddSPLwqLkRh5sFNosZKIwD4Ea3QDh0O/0ibdCM9bBwGs1S88sp
         JWoFYVJyCw8D7OAILhQJxbD5x3U3Tbbk5UMaVaoXsX/gIwkm1/YziXBvbOIKxIlcLTfj
         81t+CXa8cFdC84YAqs7oA7ek18YEsItz5utfIzqusPSzuClVmEWbotgbVxw2K3YSn8JY
         XNSfZaJeR+1Z6ak7YG6EQ9O9tz1l50lC9jn9bJSA8ZNS1m+cNae6SIJnsAKCRUMStGdv
         2f9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVm7KbZjggnNONHnIw7nlNC739TNIebxOPJchW2B7rI/ZgmPaiErC4Movswwgtee5aaSIu3Evu+d+v71g==@vger.kernel.org, AJvYcCXEMZ/bbO79PVrk2rWpVsEDMxRxI20hB8Ki0fdYaZXsz+x1i0AwpTSoKYBMMw9ZEyJZNUsSem+f6g==@vger.kernel.org, AJvYcCXQvFkI5hXEVuC2ykVE8zKkq1nCt1v8LeKwP2voeMDXvWdk1kjMIk5XquiK4tHZN8UiNEvsVuI2wPEelbzS@vger.kernel.org
X-Gm-Message-State: AOJu0YxQpVxDhXEBtDSTj863wn1cNS2mzwtjaIitfsz5yFIC0P6/y4r9
	bRVRvomK5Dlm7Ac710oUxCO/SpM4uh4+GKLl0g/TxwDBKr4iintdiDqvAipa
X-Gm-Gg: ASbGncsBgXcLI0rCk0yxdpOELM0aYopvvwii0v2ml2sCZlIFMpeTpKVeeKZ27Eh96Xz
	HxZIQQq0Xr/Bu0ushFbid8TaX0YkwH7y2ZrI5QZmRORrBAs8LpiX4ZbfrxKYlK/g9KLwfP4csit
	bYxadc8nZtze0q88YGwpEKJC1hX9ZA4ABxz2uhJSVFluRvvRWzJAOyAMCGKQRime6cqK3RBhLmx
	p4h/AMwE03YIWNhfXbHs3yqmMAbuvIsZ6bZuaveEz6yBR5dD/OcO2HjCHBEd1GqQBB5kiWxp0ep
	sCh7RSYt7YoXCiig
X-Google-Smtp-Source: AGHT+IHvQV63gqcznecAKYSKlUuABKms1H72zXxSw2m7wHNvLxXzNNUXOP9hVkl8iTLIxyYaXAIMmA==
X-Received: by 2002:a05:690c:690b:b0:6dd:bba1:b86d with SMTP id 00721157ae682-6eee089ef75mr26851067b3.10.1732263190596;
        Fri, 22 Nov 2024 00:13:10 -0800 (PST)
Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com. [209.85.128.174])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-6eedfe4664csm3510037b3.55.2024.11.22.00.13.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Nov 2024 00:13:08 -0800 (PST)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-6ea0b25695dso15951407b3.2;
        Fri, 22 Nov 2024 00:13:08 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWSautDizF2dkcq5dksg9FqoB0QG+UeWhuDvOkolZG9nCTrEG3/WpcCfBNPhkVEb6p8fMgfxe2ETA==@vger.kernel.org, AJvYcCWkLJtnBHUoF3V8ea9YnUsOrfS5rU0mWsN/F0A6yS6HwmsbcyHH8gBjhRS0lzoTEpfoG3C0G7f1180D9Q==@vger.kernel.org, AJvYcCWpsH/h+Ahv01zLJHUc3GnDyKwL8YIDQSZhHJvWtf2SmEKZe41VX8DpsZ3GjqffBPi3zmDmyWf9sA1VgMJF@vger.kernel.org
X-Received: by 2002:a0d:c2c1:0:b0:6ee:9052:8e18 with SMTP id
 00721157ae682-6eee087b79amr17900327b3.6.1732263187815; Fri, 22 Nov 2024
 00:13:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <80c767a5d5927c099aea5178fbf2c897b459fa90.1732106544.git.geert@linux-m68k.org>
 <4f70f8d3-4ba5-43dc-af1c-f8e207d27e9f@suse.cz> <2e704ffc-2e79-27f7-159e-8fe167d5a450@gentwo.org>
 <CAMuHMdWQisrjqaPPd0xLgtSAxRwnxCPdsqnWSncMiPYLnre2MA@mail.gmail.com>
 <693a6243-b2bd-7f2b-2b69-c7e2308d0f58@gentwo.org> <f602e322-af21-4bb3-86d4-52795a581354@roeck-us.net>
 <858dbafa-6320-4603-82b9-38f586f18249@kernel.org>
In-Reply-To: <858dbafa-6320-4603-82b9-38f586f18249@kernel.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 22 Nov 2024 09:12:55 +0100
X-Gmail-Original-Message-ID: <CAMuHMdX-wGB6QvYpUb+Qur85pnScyxo_aaQFxe6BSOEg+Eeogg@mail.gmail.com>
Message-ID: <CAMuHMdX-wGB6QvYpUb+Qur85pnScyxo_aaQFxe6BSOEg+Eeogg@mail.gmail.com>
Subject: Re: [PATCH] slab: Fix too strict alignment check in create_cache()
To: Greg Ungerer <gerg@kernel.org>
Cc: Guenter Roeck <linux@roeck-us.net>, "Christoph Lameter (Ampere)" <cl@gentwo.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, 
	Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hyeonggon Yoo <42.hyeyoo@gmail.com>, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, Christian Brauner <brauner@kernel.org>, Kees Cook <keescook@chromium.org>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, io-uring@vger.kernel.org, 
	linux-m68k@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 22, 2024 at 1:23=E2=80=AFAM Greg Ungerer <gerg@kernel.org> wrot=
e:
> On 22/11/24 04:30, Guenter Roeck wrote:
> > Do we really need to continue supporting nommu machines ? Is anyone
> > but me even boot testing those ?
>
> Yes. Across many architectures. And yes on every release, and for m68k bu=
ilding
> and testing on every rc for nommu at a minimum.
>
> I rarely hit build or testing problems on nonmmu targets. At least every =
kernel
> release I build and test armnommu (including thumb2 on cortex), m68k, RIS=
C-V and
> xtensa. They are all easy, qemu targets for them all. Thats just me. So I=
 would
> guess there are others building and testing too.

FTR, I do regular boot tests on K210 (SiPEED MAiX BiT RISC-V nommu).
Getting harder, as 8 MiB of RAM is not much...

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

