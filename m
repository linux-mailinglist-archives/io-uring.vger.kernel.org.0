Return-Path: <io-uring+bounces-322-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C71F98194A5
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 00:36:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EA9241C210D3
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 23:36:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2206F3D3A0;
	Tue, 19 Dec 2023 23:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0YPlSrx6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41FDB3D3B7
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 23:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-40c41b43e1eso64909015e9.1
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 15:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703028959; x=1703633759; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lfxsf2aW4lAEwXghNxr0xJgKkPMekYB/QnfBQu3miCI=;
        b=0YPlSrx6ZJoQqKZeaJEa4WTQ4MuS9O1c3A4ToQcnMyz4jLHex/tY1RaRYTk4P9lDlK
         aeu4TKRmJ4+9argN8pCxFLvZJ1jDa0qPBp2CxnxSk8b4BesyfLTGH1kEYkx2NQ9GHVTw
         CkgdUVvpZLYFABdK9uTj3xNSaK1qS8K4hK2VcQbjZef+mrX/6AvWIF1HxZ1ZukEJ/3cE
         9QG+jfg2sVeGFzFYnZuTMvv89TM3nd0s4Aem4SFzhra6RhYcxHUmZy+CsLk/7zTNpB3h
         5WyvQXoQA1RMLs7D1QLWpnSVNUdTkj9Moo34pqGgV7HkXZ0e1PgbenaqLD6BNi6KROgs
         dAEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703028959; x=1703633759;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lfxsf2aW4lAEwXghNxr0xJgKkPMekYB/QnfBQu3miCI=;
        b=ukl7dgmgDxoZaSHCOkzu86PqN/4Fx4kZqQqZ6d59lfzL7b/WOS/55+cxAKk/8OGl4b
         Nve2mC8JCTupGptp++UlwsExdxzkbSGrMWJqx3hQKmTEEVXFsUo/cm6mH4MHfpAV/JO8
         l58eYfYrGIot9FUHmvGq0KlP3r37XghNT2HSv3bMWvNDDbENLMrZDBSEs1sWlFVl68uj
         CR0ONY7q0DuZIZDFD3RjkERDJyNwuKGazNpL6xVRyZ5IE7xrVaMFdGIHDGGDqr456Q7M
         B0n9TFG8Xknu+Ds31ixgMUBplEGCGpc9B/EgDP12sawe1WreTfTpnyw2napqxkzCKUhi
         rdDw==
X-Gm-Message-State: AOJu0Yy9CaXH8gpo1BUhku1W4ZCzYIQXOhGRskK028w/VGCo5ToeVe4R
	JPZ2qKiTrhCOJcxbj2f1qSYwFZrsWiDezd/GgtzU/w==
X-Google-Smtp-Source: AGHT+IF7Cz4xBYhWbimnBW9uzClxcac+PhvcyXzBdUecSYu5N6HHjmkojtRhbfIZPAmJjswVKSgvYWCHw3jLw7YY3M0=
X-Received: by 2002:a05:600c:1503:b0:40c:3555:e230 with SMTP id
 b3-20020a05600c150300b0040c3555e230mr9472805wmg.46.1703028959249; Tue, 19 Dec
 2023 15:35:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219210357.4029713-1-dw@davidwei.uk> <20231219210357.4029713-4-dw@davidwei.uk>
In-Reply-To: <20231219210357.4029713-4-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Dec 2023 15:35:47 -0800
Message-ID: <CAHS8izPqKg73ub5WUg=EBdd8ifCcAuh69LB0pBUSw6t+5NGjjQ@mail.gmail.com>
Subject: Re: [RFC PATCH v3 03/20] net: page pool: rework ppiov life cycle
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
> NOT FOR UPSTREAM
> The final version will depend on how the ppiov infra looks like
>
> Page pool is tracking how many pages were allocated and returned, which
> serves for refcounting the pool, and so every page/frag allocated should
> eventually come back to the page pool via appropriate ways, e.g. by
> calling page_pool_put_page().
>
> When it comes to normal page pools (i.e. without memory providers
> attached), it's fine to return a page when it's still refcounted by
> somewhat in the stack, in which case we'll "detach" the page from the
> pool and rely on page refcount for it to return back to the kernel.
>
> Memory providers are different, at least ppiov based ones, they need
> all their buffers to eventually return back, so apart from custom pp
> ->release handlers, we'll catch when someone puts down a ppiov and call
> its memory provider to handle it, i.e. __page_pool_iov_free().
>
> The first problem is that __page_pool_iov_free() hard coded devmem
> handling, and other providers need a flexible way to specify their own
> callbacks.
>
> The second problem is that it doesn't go through the generic page pool
> paths and so can't do the mentioned pp accounting right. And we can't
> even safely rely on page_pool_put_page() to be called somewhere before
> to do the pp refcounting, because then the page pool might get destroyed
> and ppiov->pp would point to garbage.
>
> The solution is to make the pp ->release callback to be responsible for
> properly recycling its buffers, e.g. calling what was
> __page_pool_iov_free() before in case of devmem.
> page_pool_iov_put_many() will be returning buffers to the page pool.
>

Hmm this patch is working on top of slightly outdated code. I think
the correct solution here is to transition to using pp_ref_count for
refcounting the ppiovs/niovs. Once we do that, we no longer need
special refcounting for ppiovs, they're refcounted identically to
pages, makes the pp more maintainable, gives us some unified handling
of page pool refcounting, it becomes trivial to support fragmented
pages which require a pp_ref_count, and all the code in this patch can
go away.

I'm unsure if this patch is just because you haven't rebased to my
latest RFC (which is completely fine by me), or if you actually think
using pp_ref_count for refcounting is wrong and want us to go back to
the older model which required some custom handling for ppiov and
disabled frag support. I'm guessing it's the former, but please
correct if I'm wrong.

[1] https://patchwork.kernel.org/project/netdevbpf/patch/20231218024024.351=
6870-8-almasrymina@google.com/

> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/net/page_pool/helpers.h | 15 ++++++++---
>  net/core/page_pool.c            | 46 +++++++++++++++++----------------
>  2 files changed, 35 insertions(+), 26 deletions(-)
>
> diff --git a/include/net/page_pool/helpers.h b/include/net/page_pool/help=
ers.h
> index 92804c499833..ef380ee8f205 100644
> --- a/include/net/page_pool/helpers.h
> +++ b/include/net/page_pool/helpers.h
> @@ -137,15 +137,22 @@ static inline void page_pool_iov_get_many(struct pa=
ge_pool_iov *ppiov,
>         refcount_add(count, &ppiov->refcount);
>  }
>
> -void __page_pool_iov_free(struct page_pool_iov *ppiov);
> +static inline bool page_pool_iov_sub_and_test(struct page_pool_iov *ppio=
v,
> +                                             unsigned int count)
> +{
> +       return refcount_sub_and_test(count, &ppiov->refcount);
> +}
>
>  static inline void page_pool_iov_put_many(struct page_pool_iov *ppiov,
>                                           unsigned int count)
>  {
> -       if (!refcount_sub_and_test(count, &ppiov->refcount))
> -               return;
> +       if (count > 1)
> +               WARN_ON_ONCE(page_pool_iov_sub_and_test(ppiov, count - 1)=
);
>
> -       __page_pool_iov_free(ppiov);
> +#ifdef CONFIG_PAGE_POOL
> +       page_pool_put_defragged_page(ppiov->pp, page_pool_mangle_ppiov(pp=
iov),
> +                                    -1, false);
> +#endif
>  }
>
>  /* page pool mm helpers */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 38eff947f679..ecf90a1ccabe 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -599,6 +599,16 @@ void __page_pool_release_page_dma(struct page_pool *=
pool, struct page *page)
>         page_pool_set_dma_addr(page, 0);
>  }
>
> +static void page_pool_return_provider(struct page_pool *pool, struct pag=
e *page)
> +{
> +       int count;
> +
> +       if (pool->mp_ops->release_page(pool, page)) {
> +               count =3D atomic_inc_return_relaxed(&pool->pages_state_re=
lease_cnt);
> +               trace_page_pool_state_release(pool, page, count);
> +       }
> +}
> +
>  /* Disconnects a page (from a page_pool).  API users can have a need
>   * to disconnect a page (from a page_pool), to allow it to be used as
>   * a regular page (that will eventually be returned to the normal
> @@ -607,13 +617,13 @@ void __page_pool_release_page_dma(struct page_pool =
*pool, struct page *page)
>  void page_pool_return_page(struct page_pool *pool, struct page *page)
>  {
>         int count;
> -       bool put;
>
> -       put =3D true;
> -       if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_=
ops)
> -               put =3D pool->mp_ops->release_page(pool, page);
> -       else
> -               __page_pool_release_page_dma(pool, page);
> +       if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_=
ops) {
> +               page_pool_return_provider(pool, page);
> +               return;
> +       }
> +
> +       __page_pool_release_page_dma(pool, page);
>
>         /* This may be the last page returned, releasing the pool, so
>          * it is not safe to reference pool afterwards.
> @@ -621,10 +631,8 @@ void page_pool_return_page(struct page_pool *pool, s=
truct page *page)
>         count =3D atomic_inc_return_relaxed(&pool->pages_state_release_cn=
t);
>         trace_page_pool_state_release(pool, page, count);
>
> -       if (put) {
> -               page_pool_clear_pp_info(page);
> -               put_page(page);
> -       }
> +       page_pool_clear_pp_info(page);
> +       put_page(page);
>         /* An optimization would be to call __free_pages(page, pool->p.or=
der)
>          * knowing page is not part of page-cache (thus avoiding a
>          * __page_cache_release() call).
> @@ -1034,15 +1042,6 @@ void page_pool_update_nid(struct page_pool *pool, =
int new_nid)
>  }
>  EXPORT_SYMBOL(page_pool_update_nid);
>
> -void __page_pool_iov_free(struct page_pool_iov *ppiov)
> -{
> -       if (ppiov->pp->mp_ops !=3D &dmabuf_devmem_ops)
> -               return;
> -
> -       netdev_free_devmem(ppiov);
> -}
> -EXPORT_SYMBOL_GPL(__page_pool_iov_free);
> -
>  /*** "Dmabuf devmem memory provider" ***/
>
>  static int mp_dmabuf_devmem_init(struct page_pool *pool)
> @@ -1093,9 +1092,12 @@ static bool mp_dmabuf_devmem_release_page(struct p=
age_pool *pool,
>                 return false;
>
>         ppiov =3D page_to_page_pool_iov(page);
> -       page_pool_iov_put_many(ppiov, 1);
> -       /* We don't want the page pool put_page()ing our page_pool_iovs. =
*/
> -       return false;
> +
> +       if (!page_pool_iov_sub_and_test(ppiov, 1))
> +               return false;
> +       netdev_free_devmem(ppiov);
> +       /* tell page_pool that the ppiov is released */
> +       return true;
>  }
>
>  const struct pp_memory_provider_ops dmabuf_devmem_ops =3D {
> --
> 2.39.3
>


--=20
Thanks,
Mina

