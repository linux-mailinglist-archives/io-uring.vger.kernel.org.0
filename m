Return-Path: <io-uring+bounces-2431-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2681692674F
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 19:41:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B58C1B21A21
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 17:41:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBCE618509E;
	Wed,  3 Jul 2024 17:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="KfRfMCrW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B8D1862A6
	for <io-uring@vger.kernel.org>; Wed,  3 Jul 2024 17:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720028455; cv=none; b=Z+NGWbVhL2ohXVHmisz11O5H4ailOl7pxVcdnPC3g3LgW8J72dZGVjo/S2x2lDfjmWNv2V26ZHHZltibSbVci/GLqWHKUdhzoQ70aEE3e6r4yuwC7ZlTHALEGZRvp8yQp1j4XVEMatP3yYTo+8cJljRBA3BqXN+X0hPzITNRrpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720028455; c=relaxed/simple;
	bh=OmJgZmMNMA+vqsqmuMadaQXQgXYtB0kLJuTl566s2uI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TROwmX7QnqwpoEOzZyJeHz2WMcmxkJMR97vQ4UmXpUIVJwz7jeLLLS7O3i1zw+nRHo5bhXvF+94VA/KsG+FoTjHEe5dDcREu1wkkIdQZdM7qhnAlwzP1KvOGHGZ2raMAYxR7dkK8mc5Djp2uFaBxWHlM7IrNdnO5aQVEnRheuro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=KfRfMCrW; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ec4eefbaf1so61289181fa.1
        for <io-uring@vger.kernel.org>; Wed, 03 Jul 2024 10:40:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720028452; x=1720633252; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kNRq2xwEntheuQ6TeaPDnSkqCd5DNGo6bKIeeb/W6x4=;
        b=KfRfMCrW/RT0k7BDjpX1YrU8T0D09rsK7HwOqK2wGXgNygr+Yy1JBoD2NLZpWBdJOi
         e3p5mGB9O9wcBq7KSPodPecmUOYsdaMWBCHVORuxpiC6Gn9FQkqTq3KTEW9SS5pCpX5t
         d9mzgjGYUACSj+AMxwm5vMlhdSQi2nnrXGKVo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720028452; x=1720633252;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kNRq2xwEntheuQ6TeaPDnSkqCd5DNGo6bKIeeb/W6x4=;
        b=GK889LdJbnz2s47X2LiT7RzQbajmBfpKHbeeIfnJQZr8r8bIPLjaEBtE2ikZlhxSw+
         aZKGECA9FPPw0h6O6TiWqiNwvf9phlL23rkFLG/D2RGtBsxV6lArCZpbEkLMvcA0m65d
         So7NehWxrFRWlqXz37BiwKO2T7Izabydroog+5d+sZJvdf9tTxrgDwgM9aAeh13FQ/tH
         pmDqQriXfXyyf5BAsFrKhoKXaFwpzyW4+cHsLsYEqRiYxFl0L3AfKzmf1MivRaIjEqKm
         dlm/cmURThvlfbH1UcphcBA3BbkuYCCWe/cvPLSZu5qukYmutp/vG9FKhHP5I9kLAyjF
         zVWA==
X-Forwarded-Encrypted: i=1; AJvYcCVLTRri1ueyeoh7d7GFT/sROwLHx8V0xY51E8S+DfmCL5pDLpgY/tUyCCaBA0UtwA9EblNuRPAe9v8Gw92LLu6FyjnAFdaCjYI=
X-Gm-Message-State: AOJu0Yz/HTWYv1MdST1EGuz+2uUHMBg9GKcoW6nQBiRC4OgRce8o7utx
	dhDPUNv4gLs//sY3YSjO1e46vwvCm8hKNiPj5KbGMSLVOY5W/tT1BZdkcEPxY3xZSnIdWoADtW5
	8MTYyWA==
X-Google-Smtp-Source: AGHT+IEbpzZ644e14O7pFjdWLsAEmhlZUmLoE96Pyg1sxzFWHAOwQazNN3tMclygUQ5VaGyCcJEb7g==
X-Received: by 2002:a05:6512:1384:b0:52c:896c:c10f with SMTP id 2adb3069b0e04-52e82701380mr9249095e87.53.1720028451867;
        Wed, 03 Jul 2024 10:40:51 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com. [209.85.167.50])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-52e7ab1068bsm2243842e87.105.2024.07.03.10.40.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 10:40:51 -0700 (PDT)
Received: by mail-lf1-f50.google.com with SMTP id 2adb3069b0e04-52e992a24a1so990669e87.0
        for <io-uring@vger.kernel.org>; Wed, 03 Jul 2024 10:40:51 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVZpzK1JIsbtDOjRwHTNswq31VR7hO0q55N6Ba1tFwuugVOv8rFNb2Tu+He6/0KRoRDnjP8vbQb4er7sfEiyoKn4igd4wcMlsE=
X-Received: by 2002:a05:6512:ac6:b0:52c:d90d:d482 with SMTP id
 2adb3069b0e04-52e827459a3mr8256135e87.66.1720028450692; Wed, 03 Jul 2024
 10:40:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240625110029.606032-1-mjguzik@gmail.com> <20240625110029.606032-3-mjguzik@gmail.com>
 <CAAhV-H47NiQ2c+7NynVxduJK-yGkgoEnXuXGQvGFG59XOBAqeg@mail.gmail.com>
 <e8db013bf06d2170dc48a8252c7049c6d1ee277a.camel@xry111.site>
 <CAAhV-H7iKyQBvV+J9T1ekxh9OF8h=F9zp_QMyuhFBrFXGHHmTg@mail.gmail.com>
 <30907b42d5eee6d71f40b9fc3d32ae31406fe899.camel@xry111.site>
 <1b5d0840-766b-4c3b-8579-3c2c892c4d74@app.fastmail.com> <CAAhV-H4Z_BCWRJoCOh4Cei3eFCn_wvFWxA7AzWfNxYtNqUwBPA@mail.gmail.com>
 <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com> <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner>
 <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
 <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
 <CAHk-=wif5KJEdvZZfTVX=WjOOK7OqoPwYng6n-uu=VeYUpZysQ@mail.gmail.com> <b60a61b8c9171a6106d50346ecd7fba1cfc4dcb0.camel@xry111.site>
In-Reply-To: <b60a61b8c9171a6106d50346ecd7fba1cfc4dcb0.camel@xry111.site>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jul 2024 10:40:34 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjH3F1jTVfADgo0tAnYStuaUZLvz+1NkmtM-TqiuubWcw@mail.gmail.com>
Message-ID: <CAHk-=wjH3F1jTVfADgo0tAnYStuaUZLvz+1NkmtM-TqiuubWcw@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Xi Ruoyao <xry111@xry111.site>
Cc: Christian Brauner <brauner@kernel.org>, libc-alpha@sourceware.org, 
	"Andreas K. Huettel" <dilfridge@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, 
	Huacai Chen <chenhuacai@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jul 2024 at 10:30, Xi Ruoyao <xry111@xry111.site> wrote:
>
> struct stat64 {
>
> // ...
>
>     int     st_atime;   /* Time of last access.  */

Oh wow. Shows just *how* long ago that was - and how long ago I looked
at 32-bit code. Because clearly, I was wrong.

I guess it shows how nobody actually cares about 32-bit any more, at
least in the 2037 sense.

The point stands, though - statx isn't a replacement for existing binaries.

             Linus

