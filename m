Return-Path: <io-uring+bounces-2441-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 59C21926928
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 21:52:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1C463286812
	for <lists+io-uring@lfdr.de>; Wed,  3 Jul 2024 19:52:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42BF418E746;
	Wed,  3 Jul 2024 19:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="SZ0BHx4I"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476C1181D18
	for <io-uring@vger.kernel.org>; Wed,  3 Jul 2024 19:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720036371; cv=none; b=D9rqYjJqOc5b573GcAFinQWNWP8lE05TPcvCLgd+UVOT3NdyfFLzfSiWte9wqifVI7X6rT6QpSYZetW6yjoWu/xLlwxJXfZTAJLMnri7bskh1+nH5+rU1BOf9H8/Ssf633dVLE7P/2zOo5H6S4M5mJltAmJctwSRw2Yrlhy4RsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720036371; c=relaxed/simple;
	bh=LLTX7iSgEsmjeaKJZDhgJQFLarTCP8xjpF1SCz02LfA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rYh+959VbINE4m3WNnv74VKb1l8MWMnTfM3l9zX7ojgJNFl+4J6lTDioNMcx9YYvxs9JD4M6tIQ+jXgzrg4qMI6VsOGQNlHy/pDdH6/NYXCUwpAgmk4nxyfzldSTGyAhEqiBefHjjUh+kkq/tgmnpGGiDEabu9tUIn/43sTmTIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=SZ0BHx4I; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-58b447c513aso3337166a12.2
        for <io-uring@vger.kernel.org>; Wed, 03 Jul 2024 12:52:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1720036367; x=1720641167; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FRtKeRwASst4Njswx8SNkBJ3T6bOEI9xkykNSRHU6CM=;
        b=SZ0BHx4IDCTI7I5cQFWaX85To6EIEpBd8G5y52797lTBgPauACrfUvIrDhW8Z99v0z
         IIQP1URqnpSwbgy7Ofjhi69c0c+qQSs3R66yrX3+q7DZERdSGdrjoP7PlMRfgNOHR1J5
         hr/SyGGJ4OQn/jPGmK2tLcbSfGpWehF4RFgWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720036367; x=1720641167;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FRtKeRwASst4Njswx8SNkBJ3T6bOEI9xkykNSRHU6CM=;
        b=s1EuXnonHumk9rsQRPtEOgWffuaL9L6IJiF6/871kahgdkPGFZk11xsiosx1/7Y/FQ
         WFA8bmdYBL6ac+Y9+I9nnKzeOcWwSIj9rBhhwQPXu9IcAqoMw8kcdfH/xnd5Bpovc0PN
         uENomzoMqQ2mklaY7oUX7i86TsojPe0btQDipsCQMYZScuw5eM+13mz6HuHBgDR/hWBc
         ndBSwH4ba02cNObubFl9takf0NIl2EEAsUR4qEOjt7YC00S8aEovPcu9y7Ntkvt0BKCk
         SybfVydHm0Zbr5cx+9KLzdxD8zCqhUlPqV+XwruSSsWWFqwLRgvRk4ImK2fWpxrC5I2H
         hobw==
X-Forwarded-Encrypted: i=1; AJvYcCXY2mCoHZ1rG/UcDXZI3oWOZnzApPETyXNRpzxtMAYfgEfDjdX1ByBQ2VyWU4zuHdF/YwK/bbllkbFXeYeDzHDgzrkwa+MNcnE=
X-Gm-Message-State: AOJu0YxnX4lnBZpj/6LdI+Kphh5R62t6PsGtyWNsskbGjAqsqAU9PvHm
	rZ+a8BNQFDwREdrEeOghckEt6LxcK8b4RMQmphj5J3hNK5snrAd+SVSdJG116vcZ3/cvfAP/YQ4
	M/cCqag==
X-Google-Smtp-Source: AGHT+IFCNaN3JqYqvbgecS2606nBJXTaCQu5GmNf5qpAFC/nyigPf9jigAbo6kSMRMkF7Otk+kcWJA==
X-Received: by 2002:a17:906:3d72:b0:a6f:6126:18aa with SMTP id a640c23a62f3a-a75144a7c4emr679471566b.67.1720036367453;
        Wed, 03 Jul 2024 12:52:47 -0700 (PDT)
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com. [209.85.218.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a72aaf633desm536947166b.73.2024.07.03.12.52.46
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 12:52:46 -0700 (PDT)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-a7194ce90afso655449966b.2
        for <io-uring@vger.kernel.org>; Wed, 03 Jul 2024 12:52:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXtd/lh2tqIeAQRswYEFRHc4mAIuLIsoxZpGRWfjZoJN28iUCLyTd4E9COe3RBCumUAv6cmhm1jvwE0nrr9Kezud/17/GtC5lY=
X-Received: by 2002:a17:907:7ea3:b0:a6f:6aa3:e378 with SMTP id
 a640c23a62f3a-a751443872emr1062386666b.38.1720036366168; Wed, 03 Jul 2024
 12:52:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <8f2d356d-9cd6-4b06-8e20-941e187cab43@app.fastmail.com>
 <20240703-bergwacht-sitzung-ef4f2e63cd70@brauner> <CAHk-=wi0ejJ=PCZfCmMKvsFmzvVzAYYt1K9vtwke4=arfHiAdg@mail.gmail.com>
 <8b6d59ffc9baa57fee0f9fa97e72121fd88cf0e4.camel@xry111.site>
 <CAHk-=wif5KJEdvZZfTVX=WjOOK7OqoPwYng6n-uu=VeYUpZysQ@mail.gmail.com>
 <b60a61b8c9171a6106d50346ecd7fba1cfc4dcb0.camel@xry111.site>
 <CAHk-=wjH3F1jTVfADgo0tAnYStuaUZLvz+1NkmtM-TqiuubWcw@mail.gmail.com>
 <CAHk-=wii3qyMW+Ni=S6=cV=ddoWTX+qEkO6Ooxe0Ef2_rvo+kg@mail.gmail.com>
 <e40b8edeea1d3747fe79a4f9f932ea4a8d891db0.camel@xry111.site>
 <CAHk-=wiJh1egNXJN7AsqpE76D4LCkUQTj+RboO7O=3AFeLGesw@mail.gmail.com> <20240703-hobel-benachbarten-c475d3eb589b@brauner>
In-Reply-To: <20240703-hobel-benachbarten-c475d3eb589b@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Jul 2024 12:52:27 -0700
X-Gmail-Original-Message-ID: <CAHk-=whZwUuYP08JF-kyBmr7w45S2z17dJKaWCFE_cfFw_T9Vg@mail.gmail.com>
Message-ID: <CAHk-=whZwUuYP08JF-kyBmr7w45S2z17dJKaWCFE_cfFw_T9Vg@mail.gmail.com>
Subject: Re: [PATCH 2/2] vfs: support statx(..., NULL, AT_EMPTY_PATH, ...)
To: Christian Brauner <brauner@kernel.org>
Cc: Xi Ruoyao <xry111@xry111.site>, libc-alpha@sourceware.org, 
	"Andreas K. Huettel" <dilfridge@gentoo.org>, Arnd Bergmann <arnd@arndb.de>, 
	Huacai Chen <chenhuacai@kernel.org>, Mateusz Guzik <mjguzik@gmail.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, loongarch@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Jul 2024 at 12:33, Christian Brauner <brauner@kernel.org> wrote:
>
> Fwiw, that's why I prefer structs versioned by size which we added clean
> handling for via copy_struct_from_user()

That works very well for the kernel interface for new things, but it
actually doesn't solve the issue for user space library versioning.

If you are something like 'glibc', you don't have the option of saying
"pass in struct and size". You are kind of stuck with the API rules,
and the rules are that you expose a 'struct stat' that has a fixed
size.

So I don't disagree that copy_struct_from_user() is a good model, but
what would happen is just that then glibc says "I will need to make a
decision", and would pick a size that is bigger than the current size
it uses, so that glibc later could do those extensions without
breaking the ABI.

And yes, it would pass that larger size to the kernel,. because it
would want the kernel to zero out the unused tail of the struct.

So the 'struct and extensible size' thing really only works when
everybody agrees on using it, and users pass the size end-to-end.

Side note: this is our original i386 'stat64':

        unsigned long   st_blocks;      /* Number 512-byte blocks allocated. */
        unsigned long   __pad4;         /* future possible st_blocks
high bits */

        unsigned long   st_atime;
        unsigned long   __pad5;

        unsigned long   st_mtime;
        unsigned long   __pad6;

        unsigned long   st_ctime;
        unsigned long   __pad7;         /* will be high 32 bits of
ctime someday */

which is kind of sad. The code was literally designed to extend the
time range, had a comment to that effect and all, and then we screwed
it up.

On little-endian, we could literally have done it as

        unsigned long long  st_ctime:44, st_ctime_usec:20;

without losin gbinary compatibility. But it's sadly not what we did.
Instead we gave the full 32-bit padding to the nsec field.

And yes, I had to go back a long time to find this screw-up. It
happened back in 2002.

Oh well. Not the first time we've royally screwed up, and it most
definitely won't be the last time either.

           Linus

