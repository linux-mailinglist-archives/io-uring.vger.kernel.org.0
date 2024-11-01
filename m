Return-Path: <io-uring+bounces-4329-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A0AD29B9922
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 21:05:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2A4E1C20DCD
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 20:05:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 433761D2B11;
	Fri,  1 Nov 2024 20:05:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KUgHC6pK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A691D2707
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 20:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730491524; cv=none; b=qtd4y1nLEc3ZQg9LKZJSCPPs6gxa4b0u5DsfzTd/uQjxDc8L67XeSpvYD8Mxm8ukiqw/2oSTHSq0zPARjBioayrNZRNTOr7OufQoXdlqFW0YppfqDjqNCuw6XRJYrCzmiO5Ql/EGOHmG2Mf/vjWHugyE8qeRFPBVN9SbBhkjHDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730491524; c=relaxed/simple;
	bh=AaGW44UTjh6x8/mUP4pvI+rRwYG8PVkkJTtPUdDd96M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FwfhpLkC0RVeFjqyrYX1KYBjmrcy/FQQrj8ryw3qAzqeFGgzAbJAX3AHyzqLaLH97fe8sG+rcP4+cipUs4hdS+sFYaVjZ3CTuM0YMJBjpbv7HTSGMOm5IfQB/uNWJzEDw9QhIogaw8cnynHSM2oRsi1/eWPzqsj1tjHVzAKXnzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KUgHC6pK; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-460a8d1a9b7so11611cf.1
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 13:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730491521; x=1731096321; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pXnF9jl7kiZzHTEpKEhH6cOfeayws++4rC861g07ang=;
        b=KUgHC6pK77jwV/AEL9BE4d+0inwtv839a9cOgolZonJdL5PuvuXOHD0WiKSAJ2AYLD
         4Tn3tT46oUiC+E+ViCp3Aa74+V+VxlZDGQ/FZed5yfESTHaQ8vcJ5gqBDSXriRKocjzz
         ujgMb1FwPqaX2Rv5IJM9kr+BDYLz6g6a182spUI2E/LA4pHs5xjeOHXPJi4S4ck7oLp0
         VsUqqNjFYf7sCvC1DQrDEbrjOKB+QOCZScFoAJVhc581vMRX16yOD72qvEPDgiuonasx
         01yxZvdfZtmZ1HHpQruhtIj31XDQoG7hXJzqAoi270ebP6KVBL/CRbNu4ZEZU+wyyQBD
         0haw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730491521; x=1731096321;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pXnF9jl7kiZzHTEpKEhH6cOfeayws++4rC861g07ang=;
        b=C4LrALmUlmjBW2ZSXqvnE23dg6i2mWawAaCE4JSHQG2oAS++Bso1fcPW2DZUoDgKwX
         r2zmBl2c1V6c2PsfbZOLxnveI6H8d1619mJ1aGYpsWNMpWtegzd7IItnFZN+KfMhyukt
         S18DGHyk/Gkspuh0u0BfCPrGe5iAu4/bfQmwwS8KuODdKpriLeubz9GRJM+a7srpa5DP
         gWprq+lvtO3dPF93VYz1kfc8yLEMuvuhf92jnEh3Q4BEBz8XuRMy4YCqqclUSfAA+opg
         e5HLCw/cCcLJ6IKWrewGvzoiGw5FMNtF45Zm6LSMaTJqkegVyncqeppMAnzqH+tkvN/8
         E7Rg==
X-Gm-Message-State: AOJu0YwMQjdL8Y7TwBIxTmmGwrJQNhAyqJh3Pgq6agTuNFdsqXYFeMnB
	ky3J2Tk7WQlgzQIsvwxKptrGA1VeJUWN4ZYOJDG+gbBAEg1zEiCLjm6Zfgq6gIPHerAdoLzuDYU
	EUSIhM6UnnRUVPEELtkOTzSZVjuAc5RZzbv5b
X-Gm-Gg: ASbGnct7rYkRmOiVXiUFEIKtG3fLAjWHN1S+nmwRCR2R93fBmvigUN4p6GPLfhcCGQ6
	JRUUgP85wgxvNnz00pfK+xuk9TKa4M4ln5GnHKfPIoMNZPr5VWktsS0R06nYaJQ==
X-Google-Smtp-Source: AGHT+IGP+w+GZy8oZN6j8zeEb35Urc4YyYJuFVR9qm0AJYu9NzEkM9+WMGI9qxAVUcfxCFMsXPirMNVdsX8GbUXEnf4=
X-Received: by 2002:a05:622a:cc:b0:461:31b8:d203 with SMTP id
 d75a77b69052e-462c61dd586mr607371cf.3.1730491521338; Fri, 01 Nov 2024
 13:05:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029230521.2385749-1-dw@davidwei.uk> <20241029230521.2385749-8-dw@davidwei.uk>
In-Reply-To: <20241029230521.2385749-8-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 1 Nov 2024 13:05:09 -0700
Message-ID: <CAHS8izPRvrCA9Ffg8KpZ0NtW8mv3GB=if=JZ4tYHK9c2zU++Ow@mail.gmail.com>
Subject: Re: [PATCH v7 07/15] net: page_pool: introduce page_pool_mp_return_in_cache
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2024 at 4:06=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> Add a helper that allows a page pool memory provider to efficiently
> return a netmem off the allocation callback.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/net/page_pool/memory_provider.h |  4 ++++
>  net/core/page_pool.c                    | 19 +++++++++++++++++++
>  2 files changed, 23 insertions(+)
>
> diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_p=
ool/memory_provider.h
> index 83d7eec0058d..352b3a35d31c 100644
> --- a/include/net/page_pool/memory_provider.h
> +++ b/include/net/page_pool/memory_provider.h
> @@ -1,3 +1,5 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +
>  #ifndef _NET_PAGE_POOL_MEMORY_PROVIDER_H
>  #define _NET_PAGE_POOL_MEMORY_PROVIDER_H
>
> @@ -7,4 +9,6 @@ int page_pool_mp_init_paged_area(struct page_pool *pool,
>  void page_pool_mp_release_area(struct page_pool *pool,
>                                 struct net_iov_area *area);
>
> +void page_pool_mp_return_in_cache(struct page_pool *pool, netmem_ref net=
mem);
> +
>  #endif
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 8bd4a3c80726..9078107c906d 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -1213,3 +1213,22 @@ void page_pool_mp_release_area(struct page_pool *p=
ool,
>                 page_pool_release_page_dma(pool, net_iov_to_netmem(niov))=
;
>         }
>  }
> +
> +/*
> + * page_pool_mp_return_in_cache() - return a netmem to the allocation ca=
che.
> + * @pool:      pool from which pages were allocated
> + * @netmem:    netmem to return
> + *
> + * Return already allocated and accounted netmem to the page pool's allo=
cation
> + * cache. The function doesn't provide synchronisation and must only be =
called
> + * from the napi context.

Maybe add:

/* Caller must verify that there is room in the cache */

> + */
> +void page_pool_mp_return_in_cache(struct page_pool *pool, netmem_ref net=
mem)
> +{
> +       if (WARN_ON_ONCE(pool->alloc.count >=3D PP_ALLOC_CACHE_REFILL))
> +               return;

The caller must verify this anyway, right? so maybe this WARN_ON_ONCE
is too defensive.

> +
> +       page_pool_dma_sync_for_device(pool, netmem, -1);
> +       page_pool_fragment_netmem(netmem, 1);
> +       pool->alloc.cache[pool->alloc.count++] =3D netmem;
> +}
> --
> 2.43.5
>


--=20
Thanks,
Mina

