Return-Path: <io-uring+bounces-4319-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BE1F29B9697
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 18:33:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0D051C20FF8
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 17:33:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 175EC1CBE8C;
	Fri,  1 Nov 2024 17:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IzElJKg7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16D6B13777F
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 17:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730482418; cv=none; b=jPSXnq8Wo6jOGLLOv0Ck9W9DGXHGo/ajCCBRUVzWuUjA8DPIEnA9YkNTEer3+CJX56bKoz5kP8PCXC5enTFmsD1qXaVe14QvYRyHc2IigXmiU754Wci+zLqkb4lNgNM8qF1Rs+aifLydg7WGMLu7APjqugU83H/pN2wlAYMzUy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730482418; c=relaxed/simple;
	bh=LDysvWVOm6YSOEXsjRcStvJV0NsFkGaOctPWske0Ux4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BP4m5SQ8pDxLQENxr/kgqEme1Hw6HTp5loSOQmB9MgnLnghyeJSN387/XL2wkpx6QXHVMLOX/eF+Fm0FfWPGRZLFiOhocbcjyroSseKZBJDC911CccoUjPg52KapCa+OALLXaNjC8Us404QV9hoe3NLZcpTXlHa7iO5CgqqODSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IzElJKg7; arc=none smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-539e66ba398so1464e87.0
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 10:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730482414; x=1731087214; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GYb80jOT633DwWNVdbDF/Z6pEUzZdJHkkuNALtPZT24=;
        b=IzElJKg7c8xCmi399w8gt+P5s4m/Q26ZiirpuDXlEWRoAFerAbOzXOQubQckYnenZE
         U5gaKMf4z7EeedP2gnIskmokkTkd4k31Uard3ErxzCqJKliS8pZeI6nuUuzxcTxms5Ks
         qpg5VGEF+jap+bxxLN/hUhOwuqzgmVeymqc7eFRIB/NuRQQSHSJbSJBSLL1b5yeb3xM3
         z9Oxa8slLGGPe2ExDmuoCqORidVg5NhKCHR+WmOGLlP+U1aUiwRfMfYS0QPRFNVTUeQ9
         nShuCeCBdGvmhr3KffRMrrlaMn6L92YNQfge//7gJyhHpIZv4/ERi3gA8itTi1P4VqdF
         Z59g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730482414; x=1731087214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GYb80jOT633DwWNVdbDF/Z6pEUzZdJHkkuNALtPZT24=;
        b=tfIYHKxZXhmXt+0l2jvwQvDdlat75sdLus4VRCeKvmAClTu80r+ATq0E3zNKRq0UEt
         ehiyZQ/0WIDGbrhZQuTOxUtRSGr59r2Q+TG6OO3l5Z7tj03OdCiLqNgk6IB0y/56kHj5
         WjOznHzGJQfufo6RJK4X34OzgfCQ0AYl+MZdbcmIc5wIojOpJDNbBvrfuMHqrkKz1ykN
         FaUAYXB7mafmhrhDaPN8XGivsTkR8340SV88wJgka37ARPcxgpeeANdJQQmGmSUH8B6d
         ND31wWw8YP0vC1KnMIbI75I4cziR1rAPArbbGda/lpXgrwGJkgN53R689ICmuyeR1gdO
         fZ7A==
X-Gm-Message-State: AOJu0YxDpeYRwUVh3wJOy2KjVGd+gNhNCxuvd5Ize3wXv/v+WFlUzCnn
	bMTG/un7F2pclURkwZuz3Pf343krrqFO7QoXPfjCcziqfjghcOBf1hGZqpV8E/Min+HA5E188CZ
	XBjYeMNwM1I0v8fqQCPmjH6vXzyOMCocroQV3
X-Gm-Gg: ASbGncuJnI1a5K4ckAF6nkgKnz/c0ed8MNnqySxuh5HqunBQaBiNMVQNHGkAfMc0Uqj
	SbN6OPy94C9E+77bpRITx3n9IwIMOG9ZOjVAozKlPLUCXhThdCkFl/ozLAPSAdg==
X-Google-Smtp-Source: AGHT+IEDTVBFLDHOfUZcw+7El1DtOhGdgLOw4zAPwk9e+2hKN/6KQynUEmx8+dP4fNJOPHD9b/MtKHMkyUasvAca9so=
X-Received: by 2002:a05:6512:469:b0:530:ae18:810e with SMTP id
 2adb3069b0e04-53c7bb8e9e1mr550819e87.5.1730482413783; Fri, 01 Nov 2024
 10:33:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029230521.2385749-1-dw@davidwei.uk> <20241029230521.2385749-7-dw@davidwei.uk>
In-Reply-To: <20241029230521.2385749-7-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 1 Nov 2024 10:33:19 -0700
Message-ID: <CAHS8izMkpisFO1Mx0z_qh0eeAkhsowbyCqKqvcV=JkzHV0Y2gQ@mail.gmail.com>
Subject: Re: [PATCH v7 06/15] net: page pool: add helper creating area from pages
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
> Add a helper that takes an array of pages and initialises passed in
> memory provider's area with them, where each net_iov takes one page.
> It's also responsible for setting up dma mappings.
>
> We keep it in page_pool.c not to leak netmem details to outside
> providers like io_uring, which don't have access to netmem_priv.h
> and other private helpers.
>

I honestly prefer leaking netmem_priv.h details into the io_uring
rather than having io_uring provider specific code in page_pool.c.

> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/net/page_pool/memory_provider.h | 10 ++++
>  net/core/page_pool.c                    | 63 ++++++++++++++++++++++++-
>  2 files changed, 71 insertions(+), 2 deletions(-)
>  create mode 100644 include/net/page_pool/memory_provider.h
>
> diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_p=
ool/memory_provider.h
> new file mode 100644
> index 000000000000..83d7eec0058d
> --- /dev/null
> +++ b/include/net/page_pool/memory_provider.h
> @@ -0,0 +1,10 @@
> +#ifndef _NET_PAGE_POOL_MEMORY_PROVIDER_H
> +#define _NET_PAGE_POOL_MEMORY_PROVIDER_H
> +
> +int page_pool_mp_init_paged_area(struct page_pool *pool,
> +                               struct net_iov_area *area,
> +                               struct page **pages);
> +void page_pool_mp_release_area(struct page_pool *pool,
> +                               struct net_iov_area *area);
> +
> +#endif
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 9a675e16e6a4..8bd4a3c80726 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -13,6 +13,7 @@
>
>  #include <net/netdev_rx_queue.h>
>  #include <net/page_pool/helpers.h>
> +#include <net/page_pool/memory_provider.h>
>  #include <net/xdp.h>
>
>  #include <linux/dma-direction.h>
> @@ -459,7 +460,8 @@ page_pool_dma_sync_for_device(const struct page_pool =
*pool,
>                 __page_pool_dma_sync_for_device(pool, netmem, dma_sync_si=
ze);
>  }
>
> -static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem)
> +static bool page_pool_dma_map_page(struct page_pool *pool, netmem_ref ne=
tmem,
> +                                  struct page *page)

I have to say this is confusing for me. Passing in both the netmem and
the page is weird. The page is the one being mapped and the
netmem->dma_addr is the one being filled with the mapping.

Netmem is meant to be an abstraction over page. Passing both makes
little sense to me. The reason you're doing this is because the
io_uring memory provider is in a bit of a weird design IMO where the
memory comes in pages but it doesn't want to use paged-backed-netmem.
Instead it uses net_iov-backed-netmem and there is an out of band page
to be managed.

I think it would make sense to use paged-backed-netmem for your use
case, or at least I don't see why it wouldn't work. Memory providers
were designed to handle the hugepage usecase where the memory
allocated by the provider is pages. Is there a reason that doesn't
work for you as well?

If you really need to use net_iov-backed-netmem, can we put this
weirdness in the provider? I don't know that we want a generic-looking
dma_map function which is a bit confusing to take a netmem and a page.

>  {
>         dma_addr_t dma;
>
> @@ -468,7 +470,7 @@ static bool page_pool_dma_map(struct page_pool *pool,=
 netmem_ref netmem)
>          * into page private data (i.e 32bit cpu with 64bit DMA caps)
>          * This mapping is kept for lifetime of page, until leaving pool.
>          */
> -       dma =3D dma_map_page_attrs(pool->p.dev, netmem_to_page(netmem), 0=
,
> +       dma =3D dma_map_page_attrs(pool->p.dev, page, 0,
>                                  (PAGE_SIZE << pool->p.order), pool->p.dm=
a_dir,
>                                  DMA_ATTR_SKIP_CPU_SYNC |
>                                          DMA_ATTR_WEAK_ORDERING);
> @@ -490,6 +492,11 @@ static bool page_pool_dma_map(struct page_pool *pool=
, netmem_ref netmem)
>         return false;
>  }
>
> +static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem)
> +{
> +       return page_pool_dma_map_page(pool, netmem, netmem_to_page(netmem=
));
> +}
> +
>  static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
>                                                  gfp_t gfp)
>  {
> @@ -1154,3 +1161,55 @@ void page_pool_update_nid(struct page_pool *pool, =
int new_nid)
>         }
>  }
>  EXPORT_SYMBOL(page_pool_update_nid);
> +
> +static void page_pool_release_page_dma(struct page_pool *pool,
> +                                      netmem_ref netmem)
> +{
> +       __page_pool_release_page_dma(pool, netmem);
> +}
> +

Is this wrapper necessary? Do you wanna rename the original function
to remove the __ instead of a adding a wrapper?

> +int page_pool_mp_init_paged_area(struct page_pool *pool,
> +                                struct net_iov_area *area,
> +                                struct page **pages)
> +{
> +       struct net_iov *niov;
> +       netmem_ref netmem;
> +       int i, ret =3D 0;
> +
> +       if (!pool->dma_map)
> +               return -EOPNOTSUPP;
> +
> +       for (i =3D 0; i < area->num_niovs; i++) {
> +               niov =3D &area->niovs[i];
> +               netmem =3D net_iov_to_netmem(niov);
> +
> +               page_pool_set_pp_info(pool, netmem);
> +               if (!page_pool_dma_map_page(pool, netmem, pages[i])) {
> +                       ret =3D -EINVAL;
> +                       goto err_unmap_dma;
> +               }
> +       }
> +       return 0;
> +
> +err_unmap_dma:
> +       while (i--) {
> +               netmem =3D net_iov_to_netmem(&area->niovs[i]);
> +               page_pool_release_page_dma(pool, netmem);
> +       }
> +       return ret;
> +}
> +
> +void page_pool_mp_release_area(struct page_pool *pool,
> +                              struct net_iov_area *area)
> +{
> +       int i;
> +
> +       if (!pool->dma_map)
> +               return;
> +
> +       for (i =3D 0; i < area->num_niovs; i++) {
> +               struct net_iov *niov =3D &area->niovs[i];
> +
> +               page_pool_release_page_dma(pool, net_iov_to_netmem(niov))=
;
> +       }
> +}

Similarly I these 2 functions belong in the provider to be honest.


--=20
Thanks,
Mina

