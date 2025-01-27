Return-Path: <io-uring+bounces-6134-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 462D9A1D6F2
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 14:36:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 79CA6164FE9
	for <lists+io-uring@lfdr.de>; Mon, 27 Jan 2025 13:36:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C5041FF7BB;
	Mon, 27 Jan 2025 13:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XEXvaxPH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD9E1FDA9C;
	Mon, 27 Jan 2025 13:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737984986; cv=none; b=mZhTXvy/27QHdWlZigg1lT5gN04Ss46bE4ON3/tJMFIvjh1d59mM5u+kl991dfYfwtRvYsOSvYK+DyTkyHd1zEdaqDAIB0BxIwz0i9a+Bq8l6HExgNzVfGrRLsiAy2zMiOxLC662aSUzKNiqnXGfHs1SOtp3LazGHuii1eqXNA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737984986; c=relaxed/simple;
	bh=/F2O78bKsyqpJgf4I2uHLIckmztjlBfhVY6KmE/E7PI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tQRUTa5ALeXus56a3n57hp53dYd8OGVUcJReyhVL4uooU18aXjfGhghXm91N/GFIRFhrCuE0aXG4APl2fHK4lAYeygoX8IX8ci3jltFKAqIS/WLuRWrEELn+/aKxnBT/nedfj5dstlhhNEBvns/XNxRl3JbgqRKNbJPIB5Ta3hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XEXvaxPH; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4363298fff2so2775735e9.3;
        Mon, 27 Jan 2025 05:36:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737984983; x=1738589783; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CHlG6AWWEnigDewIm8jICn9LKhM+kgmczZJmbvtFgt4=;
        b=XEXvaxPH9qisAaBu4FNZuTOHhtyimhokfop7Ex+1+lrXNI4HTJfMjT0vhWb45xovTB
         HtTT8+buIBkWS3q00Aq/w3D685PiijULRQQtxD5vL/WTQ6uu5UOYudXV6buXtRkZCbM6
         ek/dJHq7QDK9l5Y6TN1dmXv2DhcKtQqBIuw84F44mIyOep1uUISs9n0tceh8pNB1jpQl
         eo68gMXJ2BvDmJFuOyC8C7hqm/ultFF+PajOf0ggXT/jSdbbWSyAtSbfBIat8Z9BWD91
         cpY4PBDS5NfImYpvwEUuzEXYyiW7FaPmjP2j2PND+fRROsX/5QION6Ci1+3ARGJ4CuYq
         sCJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737984983; x=1738589783;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CHlG6AWWEnigDewIm8jICn9LKhM+kgmczZJmbvtFgt4=;
        b=xQJZZ72RI9ncLOpEDdltBfexcwWKC/RqtO3mzstZDWiqAwXDNmeBw6jfyJYxtsXYdx
         oJZbyvCWwr8KxN+3AYJ06aXIvNP8urLcwgNRctytVQ82tdf11TMv6IIZwa8FR2oOMels
         zULeVZkc+X2VkrwOL2u5W6CxLefEnj6oDCc34WeqXBPh7mtBTS9TtE3JSphy2cTFBdTP
         yZeQ4YnYuid5XY0Z1O4yTYvsftX7rQHBL1FZZvjm1GRKMZaM1ViI/QizCacaQizU9xAT
         3UjEWsMUfDXZqTAXLlJMDUO0CM5/Et0m4rut7cHonVrhDIi+/5ebyEd4XWYcacfqHPFK
         2gJA==
X-Forwarded-Encrypted: i=1; AJvYcCUmRnQBgLbQyo6izapzY8BjQOjELiOIHLaN9pyn9SBLXVwfDMLBbdQWdUVzy1x6taeEoZegDswX3w==@vger.kernel.org, AJvYcCVgpjN5LwqQUbHOd2roOPoDVwgSZKfOPzjACJJKxMDhv5+Y1rFyvuHLJ1pA3104D8ps1AkVuPeE@vger.kernel.org, AJvYcCW2uNCA5C+mU8D/9TgfIQGvdrjVkZkDEa3NnMn6XYXWrCXYFSWESNXd9ryxxFJhXdLeawHQOQln@vger.kernel.org, AJvYcCXjncwo/lCk6UyNCel7xvpdtEDWOK+oS/CNAm+BOV8FXvbYPe/lczz7RJ/Xk82yeMAh2EzuKrCBXwzDZgy+@vger.kernel.org
X-Gm-Message-State: AOJu0YyZSQsLC/JZeJu3+vPANEEDe07wnqu5FlTOLAaGjqlRuF+dca0y
	QiAZNs/MCJaWlwM/sum1xW2YNKg2sRzZGgadFm66xDgXEZs+1yVn2F0hamnVhR9rcln6qVvYnmZ
	ZBKcZOvTsVvLnS6gWro+VSozn4vI=
X-Gm-Gg: ASbGncvJp41ME5nAByuNAMuFU7sVUaOZTHUTsf4UrwsLUy1DcwR/Aq7FeUCceYERGRZ
	LTTYoCgPGcHwDm+gr9zInIvqM9OC8ui+8jomQL0azb7tDCIIzqJWqyXSfOcen83q7xVdIFO01J7
	pMI4BoND8QTJm5XtqA
X-Google-Smtp-Source: AGHT+IEwQVGDIO9MKpdkIIvrOhuXW1o8nFtUK6gztIT8hZx4gsH6RlXtlNX/S1wokPE91HdAIbcgS9rbkhD0dmLxJcM=
X-Received: by 2002:a05:6000:4022:b0:385:ef39:6ce3 with SMTP id
 ffacd0b85a97d-38c1a7d087cmr7134980f8f.0.1737984982791; Mon, 27 Jan 2025
 05:36:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAPAsAGwzBeGXbVtWtZKhbUDbD4b4PtgAS9MJYU2kkiNHgyKpfQ@mail.gmail.com>
 <20250122160645.28926-1-ryabinin.a.a@gmail.com> <CA+fCnZdU2GdAw4eUk9b3Ox8_nLXv-s4isxdoTXePU2J6x5pcGw@mail.gmail.com>
In-Reply-To: <CA+fCnZdU2GdAw4eUk9b3Ox8_nLXv-s4isxdoTXePU2J6x5pcGw@mail.gmail.com>
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
Date: Mon, 27 Jan 2025 14:35:03 +0100
X-Gm-Features: AWEUYZlL-o4Q2NjgFkTgV84l7QgdO4LRWJbYKyDVa5jE4weNS1kRLZqv5Yt4eEU
Message-ID: <CAPAsAGy8HBMFpeV900thoXUr8QC6V5sCzRh65+NNbYGpJpYgHg@mail.gmail.com>
Subject: Re: [PATCH] kasan, mempool: don't store free stacktrace in
 io_alloc_cache objects.
To: Andrey Konovalov <andreyknvl@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, kasan-dev@googlegroups.com, 
	io-uring@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	linux-kernel@vger.kernel.org, juntong.deng@outlook.com, lizetao1@huawei.com, 
	stable@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jan 25, 2025 at 1:03=E2=80=AFAM Andrey Konovalov <andreyknvl@gmail.=
com> wrote:
>
> On Wed, Jan 22, 2025 at 5:07=E2=80=AFPM Andrey Ryabinin <ryabinin.a.a@gma=
il.com> wrote:

> > @@ -261,7 +262,7 @@ bool __kasan_slab_free(struct kmem_cache *cache, vo=
id *object, bool init,
> >         if (!kasan_arch_is_ready() || is_kfence_address(object))
> >                 return false;
> >
> > -       poison_slab_object(cache, object, init, still_accessible);
> > +       poison_slab_object(cache, object, init, still_accessible, true)=
;
>
> Should notrack be false here?
>

Yep.

