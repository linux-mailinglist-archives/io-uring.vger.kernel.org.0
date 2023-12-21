Return-Path: <io-uring+bounces-348-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 5820881BF41
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 20:51:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCC651F24051
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 19:51:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D202E651AC;
	Thu, 21 Dec 2023 19:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kCviRpgY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4A5745C5
	for <io-uring@vger.kernel.org>; Thu, 21 Dec 2023 19:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-46699fec18fso229953137.1
        for <io-uring@vger.kernel.org>; Thu, 21 Dec 2023 11:51:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703188286; x=1703793086; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=34gLZNGDneOrL80YLJTy2KL/mWwjxUIXyDqa+JQefhY=;
        b=kCviRpgY1s8l7SkjmBzrgYa1CWDBG0DVb36Ko0a64kpsENEhm7aMlsxid1Ajuxo1Pq
         AQyows/J6+4WGIJLG/fmIBI5ISUYAW82kxS6KFXNSQlyBQKlaOkwjk6e2SPncruIQnK/
         yGo2VjysTMPI0MLsE3McoPVwYv425Jjr+jF+lhhGf1CoKqhAijjwxPd8A7PVJ81b7k4T
         FrSBajp55Gk9wyb7+kDmYuY8+iGLC2ZBmVjQfJ8m2iRBdF/Mtfsw/Qbl2QQ5BdGjkF+l
         RArCn+2B5Kz/aYxHTK+kZrrrZ6xjAgFey8Lktzho5CZfWyENnGRade037nCHZaTQnu4K
         XNEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703188286; x=1703793086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=34gLZNGDneOrL80YLJTy2KL/mWwjxUIXyDqa+JQefhY=;
        b=jklWm7V3eXkoBIzMMTuu+V9AzyBgzaOjRer1VAdwI3SghQeeH/mDt/O+4svUjlOO6y
         I8eMjYWzNmOXtCgVJchsKFC5i6rzh8eckRfIoToX4Js3cOcKHInPZpbXrrdigeA/+RVD
         SR1nAZuV39NblIdOWwoGT8q39r6Kgrf8QO1e2gp2gZ1io+HU09TZEUQssdJ5So1zveUg
         0HH1+/80qwSp93PwioHTdYLMch1uHGqTsLTQAYi5iPlZsbdLu2F2NZK5NjuRSlOOu6pB
         ZerubEqt7X7eMemh+Vc8tzSGnfN/g8MBJEYkEYvziBNCMWo99KIPbhDXmn0H4/nqhIzs
         C48A==
X-Gm-Message-State: AOJu0Ywqmg7e4CSm3EWqT9wrnISaCrWKtx6CwoiM8di7s84jpGr2SRr2
	8oIlQruPX12r/PLBqtSMN3/zQrhvLjSVQNIsGOdL2u9qW4HTkGZL/BO1NP2/kQ==
X-Google-Smtp-Source: AGHT+IHROzNd3Evq3cE5OAf0hjgsWgnNTB7VyKwI8WYsM4q5q0ayArwDT+3UGbqoqOGbMUV1p2WAMZHxLHNInNYHhag=
X-Received: by 2002:a05:6102:a54:b0:466:5029:a26c with SMTP id
 i20-20020a0561020a5400b004665029a26cmr103095vss.35.1703188285588; Thu, 21 Dec
 2023 11:51:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219210357.4029713-1-dw@davidwei.uk> <20231219210357.4029713-20-dw@davidwei.uk>
In-Reply-To: <20231219210357.4029713-20-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 21 Dec 2023 11:51:09 -0800
Message-ID: <CAHS8izOjeb-DMJNAgQaqv2dJaSHsLPSAeMPNWeViLhhHVouSnw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 19/20] net: page pool: generalise ppiov dma address get
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 19, 2023 at 1:04=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> io_uring pp memory provider doesn't have contiguous dma addresses,
> implement page_pool_iov_dma_addr() via callbacks.
>
> Note: it might be better to stash dma address into struct page_pool_iov.
>

This is the approach already taken in v1 & RFC v5. I suspect you'd be
able to take advantage when you rebase.

> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/net/page_pool/helpers.h | 5 +----
>  include/net/page_pool/types.h   | 2 ++
>  io_uring/zc_rx.c                | 8 ++++++++
>  net/core/page_pool.c            | 9 +++++++++
>  4 files changed, 20 insertions(+), 4 deletions(-)
>
> diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/help=
ers.h
> index aca3a52d0e22..10dba1f2aa0c 100644
> --- a/include/net/page_pool/helpers.h
> +++ b/include/net/page_pool/helpers.h
> @@ -105,10 +105,7 @@ static inline unsigned int page_pool_iov_idx(const s=
truct page_pool_iov *ppiov)
>  static inline dma_addr_t
>  page_pool_iov_dma_addr(const struct page_pool_iov *ppiov)
>  {
> -       struct dmabuf_genpool_chunk_owner *owner =3D page_pool_iov_owner(=
ppiov);
> -
> -       return owner->base_dma_addr +
> -              ((dma_addr_t)page_pool_iov_idx(ppiov) << PAGE_SHIFT);
> +       return ppiov->pp->mp_ops->ppiov_dma_addr(ppiov);
>  }
>
>  static inline unsigned long
> diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.=
h
> index f54ee759e362..1b9266835ab6 100644
> --- a/include/net/page_pool/types.h
> +++ b/include/net/page_pool/types.h
> @@ -125,6 +125,7 @@ struct page_pool_stats {
>  #endif
>
>  struct mem_provider;
> +struct page_pool_iov;
>
>  enum pp_memory_provider_type {
>         __PP_MP_NONE, /* Use system allocator directly */
> @@ -138,6 +139,7 @@ struct pp_memory_provider_ops {
>         void (*scrub)(struct page_pool *pool);
>         struct page *(*alloc_pages)(struct page_pool *pool, gfp_t gfp);
>         bool (*release_page)(struct page_pool *pool, struct page *page);
> +       dma_addr_t (*ppiov_dma_addr)(const struct page_pool_iov *ppiov);
>  };
>
>  extern const struct pp_memory_provider_ops dmabuf_devmem_ops;
> diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
> index f7d99d569885..20fb89e6bad7 100644
> --- a/io_uring/zc_rx.c
> +++ b/io_uring/zc_rx.c
> @@ -600,12 +600,20 @@ static void io_pp_zc_destroy(struct page_pool *pp)
>         percpu_ref_put(&ifq->ctx->refs);
>  }
>
> +static dma_addr_t io_pp_zc_ppiov_dma_addr(const struct page_pool_iov *pp=
iov)
> +{
> +       struct io_zc_rx_buf *buf =3D io_iov_to_buf((struct page_pool_iov =
*)ppiov);
> +
> +       return buf->dma;
> +}
> +
>  const struct pp_memory_provider_ops io_uring_pp_zc_ops =3D {
>         .alloc_pages            =3D io_pp_zc_alloc_pages,
>         .release_page           =3D io_pp_zc_release_page,
>         .init                   =3D io_pp_zc_init,
>         .destroy                =3D io_pp_zc_destroy,
>         .scrub                  =3D io_pp_zc_scrub,
> +       .ppiov_dma_addr         =3D io_pp_zc_ppiov_dma_addr,
>  };
>  EXPORT_SYMBOL(io_uring_pp_zc_ops);
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ebf5ff009d9d..6586631ecc2e 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -1105,10 +1105,19 @@ static bool mp_dmabuf_devmem_release_page(struct =
page_pool *pool,
>         return true;
>  }
>
> +static dma_addr_t mp_dmabuf_devmem_ppiov_dma_addr(const struct page_pool=
_iov *ppiov)
> +{
> +       struct dmabuf_genpool_chunk_owner *owner =3D page_pool_iov_owner(=
ppiov);
> +
> +       return owner->base_dma_addr +
> +              ((dma_addr_t)page_pool_iov_idx(ppiov) << PAGE_SHIFT);
> +}
> +
>  const struct pp_memory_provider_ops dmabuf_devmem_ops =3D {
>         .init                   =3D mp_dmabuf_devmem_init,
>         .destroy                =3D mp_dmabuf_devmem_destroy,
>         .alloc_pages            =3D mp_dmabuf_devmem_alloc_pages,
>         .release_page           =3D mp_dmabuf_devmem_release_page,
> +       .ppiov_dma_addr         =3D mp_dmabuf_devmem_ppiov_dma_addr,
>  };
>  EXPORT_SYMBOL(dmabuf_devmem_ops);
> --
> 2.39.3
>


--=20
Thanks,
Mina

