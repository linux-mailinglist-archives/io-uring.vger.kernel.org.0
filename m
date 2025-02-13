Return-Path: <io-uring+bounces-6424-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B5A95A34FFF
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 21:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 62FE016B03F
	for <lists+io-uring@lfdr.de>; Thu, 13 Feb 2025 20:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3554245AE0;
	Thu, 13 Feb 2025 20:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tkn1uijo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D863F28A2C0
	for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 20:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739480284; cv=none; b=M+XNTuHJaCfXudJfjUZkd12wR5fKucIok4MaKQ8Pe1+GFU7/Nx9GUsDs6yan5oLUPfkO8EiNGQ47/9NwdcCC3rLycHtq4a7AblC1TpN6/J7n5Yi1NOf3qY56aOTL/vnswMW9Kyv9XdHZg1wmCFrO/o8u8SI3JALRGt5ETn+Rdzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739480284; c=relaxed/simple;
	bh=NCoqmrmv+Es9kZrzxBJtnf+EfuEaWUHZ9R9EscGhZh8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VD7iemuze4sp7cW1v89t4BWc44+ZQWOg5m0h0Wj3GQXcJAkgu94XKL6GgHsEbLLT54aSFKN752TqvEtYH1mVggG7/EMLo4VCiiLCLwTbzcjSy7eV2yBu3mlaEMubtM7Mky0XAInUdII2fiSizZJQ0ED9Lt9A7tGaZlBWU00EMhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tkn1uijo; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-21f8c280472so6145ad.1
        for <io-uring@vger.kernel.org>; Thu, 13 Feb 2025 12:58:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739480282; x=1740085082; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sEXN0YEY1C5HMQ2737z9iX4JwrCwVZnOq8lHoKwnKXQ=;
        b=tkn1uijo5CQ5PD7F5ENtBpdxwL4Fb3ct04cA8OXNYdroxW6DM+nWXLKdRb9SrHochc
         6bx+BXMDpA4gajEoOG9f/3IPmHKStSBl6WNa8UTvWf2kEaix/oZLD4bJZa6i2jNIJdvf
         fFhVC6Jv4G5GDZ18UQT2bbvIXGS+x7Kuie+hpq4XXY8pRoQyIQKjmBzLO2JUPULb9Du2
         G9/4E44VQc8I/YvGMEQdcdO5hYBXuAiOQyZtvsJAe8cJvnq/a+CGNfXokJcebJ+VLHm4
         fZ2ht3VKleS6kZmdZxY0MIrDLFmvRvjhlA1/0grue0qq9JNzm8BIiq7io+0tbdGIvx/a
         qqag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739480282; x=1740085082;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sEXN0YEY1C5HMQ2737z9iX4JwrCwVZnOq8lHoKwnKXQ=;
        b=SABLI50jYxxu4AHCnhB99HtjeZFm4TywHeM7PcSuOgjgzuMRgd3Jr7fkIetVABeQw/
         67IY72qoogohYV+wOaNT85G5ybd1tYl2UV/K9gPGuw7M3qtWryWAyMAaYyk0sCQRY+jr
         OYtfS6MY/MUlwST64gE2Rf4oOWaerfzsqppaL4MoZw5KKkfNhbel95YwLgeJNvPZnwT/
         L1d1Omiy8cfErdkfog4aDYb8uVQntGHccMQ1NA0wG4z17GJbfUaZTxznoipBSdlywLu0
         WwmcuNpoRjh2oHZYmXU+o5q2VetucMWE9oCcoQZs7/0f9vlfnvYAxGaqNjX/1WiiScKr
         lwwg==
X-Gm-Message-State: AOJu0YxS3TRETd2QhNUw/c3THXEQ5uGpiZ6rkBgpRud0Cv1GriQjuQyo
	a4y5ZhlfJ21tcXffof7BVpW3zWEGjolx9roVV/yeLwSziTHp9DO0KAuYalQR4T7fZNulzxwse9G
	zQaeO1U2/z+rjxVDq1yDQ71S45lr1Pt6fCUPU
X-Gm-Gg: ASbGncv8vbLd3QK/Aq2Z2sxQ4CvFWuIvBsIgMRN+XXO4Ba5rAklgMYTiI8343NEmkKb
	9Hv7rIL1CtRVPO7z7i7UqR23evAv/Tq3JKtO6G31gK1YZH4Ga+pA9zIKNR3VZxkF05TRxYF5k
X-Google-Smtp-Source: AGHT+IG/l2IBG8lXlcVfcrAwVj3spc6D1EZKMzGcetA7yqVTUXgQ9txNNqoA1++QEQuiqzGRlAwoyIC5HNFZd00G0i8=
X-Received: by 2002:a17:902:f64a:b0:220:c905:689f with SMTP id
 d9443c01a7336-220ed012efemr420945ad.25.1739480281769; Thu, 13 Feb 2025
 12:58:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250212185859.3509616-1-dw@davidwei.uk> <20250212185859.3509616-5-dw@davidwei.uk>
In-Reply-To: <20250212185859.3509616-5-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Thu, 13 Feb 2025 12:57:48 -0800
X-Gm-Features: AWEUYZlQkl_34W_2fsdL68KHCspXckpwZqaJUlyhzdNZyIrcs7TdK5JIdRS3xjA
Message-ID: <CAHS8izMOrPWx5X_i+xxjJ8XJyP0Kn-WEcgvK096-WEw1afQ75w@mail.gmail.com>
Subject: Re: [PATCH net-next v13 04/11] io_uring/zcrx: implement zerocopy
 receive pp memory provider
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

On Wed, Feb 12, 2025 at 10:59=E2=80=AFAM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> Implement a page pool memory provider for io_uring to receieve in a
> zero copy fashion. For that, the provider allocates user pages wrapped
> around into struct net_iovs, that are stored in a previously registered
> struct net_iov_area.
>
> Unlike the traditional receive, that frees pages and returns them back
> to the page pool right after data was copied to the user, e.g. inside
> recv(2), we extend the lifetime until the user space confirms that it's
> done processing the data. That's done by taking a net_iov reference.
> When the user is done with the buffer, it must return it back to the
> kernel by posting an entry into the refill ring, which is usually polled
> off the io_uring memory provider callback in the page pool's netmem
> allocation path.
>
> There is also a separate set of per net_iov "user" references accounting
> whether a buffer is currently given to the user (including possible
> fragmentation).
>
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  io_uring/zcrx.c | 272 ++++++++++++++++++++++++++++++++++++++++++++++++
>  io_uring/zcrx.h |   3 +
>  2 files changed, 275 insertions(+)
>
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 435cd634f91c..9d5c0479a285 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -2,10 +2,16 @@
>  #include <linux/kernel.h>
>  #include <linux/errno.h>
>  #include <linux/mm.h>
> +#include <linux/nospec.h>
>  #include <linux/io_uring.h>
>  #include <linux/netdevice.h>
>  #include <linux/rtnetlink.h>
>
> +#include <net/page_pool/helpers.h>
> +#include <net/page_pool/memory_provider.h>
> +#include <net/netdev_rx_queue.h>
> +#include <net/netlink.h>
> +
>  #include <uapi/linux/io_uring.h>
>
>  #include "io_uring.h"
> @@ -16,6 +22,33 @@
>
>  #define IO_RQ_MAX_ENTRIES              32768
>
> +__maybe_unused
> +static const struct memory_provider_ops io_uring_pp_zc_ops;
> +
> +static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_=
iov *niov)
> +{
> +       struct net_iov_area *owner =3D net_iov_owner(niov);
> +
> +       return container_of(owner, struct io_zcrx_area, nia);
> +}
> +
> +static inline atomic_t *io_get_user_counter(struct net_iov *niov)
> +{
> +       struct io_zcrx_area *area =3D io_zcrx_iov_to_area(niov);
> +
> +       return &area->user_refs[net_iov_idx(niov)];
> +}
> +
> +static bool io_zcrx_put_niov_uref(struct net_iov *niov)
> +{
> +       atomic_t *uref =3D io_get_user_counter(niov);
> +
> +       if (unlikely(!atomic_read(uref)))
> +               return false;
> +       atomic_dec(uref);
> +       return true;
> +}
> +
>  static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
>                                  struct io_uring_zcrx_ifq_reg *reg,
>                                  struct io_uring_region_desc *rd)
> @@ -51,6 +84,7 @@ static void io_zcrx_free_area(struct io_zcrx_area *area=
)
>  {
>         kvfree(area->freelist);
>         kvfree(area->nia.niovs);
> +       kvfree(area->user_refs);
>         if (area->pages) {
>                 unpin_user_pages(area->pages, area->nia.num_niovs);
>                 kvfree(area->pages);
> @@ -106,6 +140,19 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *i=
fq,
>         for (i =3D 0; i < nr_pages; i++)
>                 area->freelist[i] =3D i;
>
> +       area->user_refs =3D kvmalloc_array(nr_pages, sizeof(area->user_re=
fs[0]),
> +                                       GFP_KERNEL | __GFP_ZERO);
> +       if (!area->user_refs)
> +               goto err;
> +
> +       for (i =3D 0; i < nr_pages; i++) {
> +               struct net_iov *niov =3D &area->nia.niovs[i];
> +
> +               niov->owner =3D &area->nia;
> +               area->freelist[i] =3D i;
> +               atomic_set(&area->user_refs[i], 0);
> +       }
> +
>         area->free_count =3D nr_pages;
>         area->ifq =3D ifq;
>         /* we're only supporting one area per ifq for now */
> @@ -131,6 +178,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct i=
o_ring_ctx *ctx)
>         ifq->if_rxq =3D -1;
>         ifq->ctx =3D ctx;
>         spin_lock_init(&ifq->lock);
> +       spin_lock_init(&ifq->rq_lock);
>         return ifq;
>  }
>
> @@ -251,12 +299,236 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *c=
tx)
>
>         if (!ifq)
>                 return;
> +       if (WARN_ON_ONCE(ifq->area &&
> +                        ifq->area->free_count !=3D ifq->area->nia.num_ni=
ovs))
>
>         ctx->ifq =3D NULL;
>         io_zcrx_ifq_free(ifq);
>  }
>
> +static struct net_iov *__io_zcrx_get_free_niov(struct io_zcrx_area *area=
)
> +{
> +       unsigned niov_idx;
> +
> +       lockdep_assert_held(&area->freelist_lock);
> +
> +       niov_idx =3D area->freelist[--area->free_count];
> +       return &area->nia.niovs[niov_idx];
> +}
> +
> +static void io_zcrx_return_niov_freelist(struct net_iov *niov)
> +{
> +       struct io_zcrx_area *area =3D io_zcrx_iov_to_area(niov);
> +
> +       spin_lock_bh(&area->freelist_lock);
> +       area->freelist[area->free_count++] =3D net_iov_idx(niov);
> +       spin_unlock_bh(&area->freelist_lock);
> +}
> +
> +static void io_zcrx_return_niov(struct net_iov *niov)
> +{
> +       netmem_ref netmem =3D net_iov_to_netmem(niov);
> +
> +       page_pool_put_unrefed_netmem(niov->pp, netmem, -1, false);
> +}
> +
> +static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
> +{
> +       struct io_zcrx_area *area =3D ifq->area;
> +       int i;
> +
> +       if (!area)
> +               return;
> +
> +       /* Reclaim back all buffers given to the user space. */
> +       for (i =3D 0; i < area->nia.num_niovs; i++) {
> +               struct net_iov *niov =3D &area->nia.niovs[i];
> +               int nr;
> +
> +               if (!atomic_read(io_get_user_counter(niov)))
> +                       continue;
> +               nr =3D atomic_xchg(io_get_user_counter(niov), 0);
> +               if (nr && !page_pool_unref_netmem(net_iov_to_netmem(niov)=
, nr))
> +                       io_zcrx_return_niov(niov);

I assume nr can be > 1? If it's always 1, then page_pool_put_netmem()
does the page_pool_unref_netmem() + page_pool_put_unrefed_netmem() a
bit more succinctly.

> +       }
> +}
> +
>  void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
>  {
>         lockdep_assert_held(&ctx->uring_lock);
> +
> +       if (ctx->ifq)
> +               io_zcrx_scrub(ctx->ifq);
> +}
> +
> +static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
> +{
> +       u32 entries;
> +
> +       entries =3D smp_load_acquire(&ifq->rq_ring->tail) - ifq->cached_r=
q_head;
> +       return min(entries, ifq->rq_entries);
>  }
> +
> +static struct io_uring_zcrx_rqe *io_zcrx_get_rqe(struct io_zcrx_ifq *ifq=
,
> +                                                unsigned mask)
> +{
> +       unsigned int idx =3D ifq->cached_rq_head++ & mask;
> +
> +       return &ifq->rqes[idx];
> +}
> +
> +static void io_zcrx_ring_refill(struct page_pool *pp,
> +                               struct io_zcrx_ifq *ifq)
> +{
> +       unsigned int mask =3D ifq->rq_entries - 1;
> +       unsigned int entries;
> +       netmem_ref netmem;
> +
> +       spin_lock_bh(&ifq->rq_lock);
> +
> +       entries =3D io_zcrx_rqring_entries(ifq);
> +       entries =3D min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL - pp->=
alloc.count);
> +       if (unlikely(!entries)) {
> +               spin_unlock_bh(&ifq->rq_lock);
> +               return;
> +       }
> +
> +       do {
> +               struct io_uring_zcrx_rqe *rqe =3D io_zcrx_get_rqe(ifq, ma=
sk);
> +               struct io_zcrx_area *area;
> +               struct net_iov *niov;
> +               unsigned niov_idx, area_idx;
> +
> +               area_idx =3D rqe->off >> IORING_ZCRX_AREA_SHIFT;
> +               niov_idx =3D (rqe->off & ~IORING_ZCRX_AREA_MASK) >> PAGE_=
SHIFT;
> +
> +               if (unlikely(rqe->__pad || area_idx))
> +                       continue;

nit: I believe a lot of the unlikely in the file are redundant. AFAIU
the compiler always treats the condition inside the if as unlikely by
default if there is no else statement.

> +               area =3D ifq->area;
> +
> +               if (unlikely(niov_idx >=3D area->nia.num_niovs))
> +                       continue;
> +               niov_idx =3D array_index_nospec(niov_idx, area->nia.num_n=
iovs);
> +
> +               niov =3D &area->nia.niovs[niov_idx];
> +               if (!io_zcrx_put_niov_uref(niov))
> +                       continue;
> +
> +               netmem =3D net_iov_to_netmem(niov);
> +               if (page_pool_unref_netmem(netmem, 1) !=3D 0)
> +                       continue;
> +
> +               if (unlikely(niov->pp !=3D pp)) {
> +                       io_zcrx_return_niov(niov);
> +                       continue;
> +               }
> +
> +               net_mp_netmem_place_in_cache(pp, netmem);
> +       } while (--entries);
> +
> +       smp_store_release(&ifq->rq_ring->head, ifq->cached_rq_head);
> +       spin_unlock_bh(&ifq->rq_lock);
> +}
> +
> +static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq=
 *ifq)
> +{
> +       struct io_zcrx_area *area =3D ifq->area;
> +
> +       spin_lock_bh(&area->freelist_lock);
> +       while (area->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFIL=
L) {
> +               struct net_iov *niov =3D __io_zcrx_get_free_niov(area);
> +               netmem_ref netmem =3D net_iov_to_netmem(niov);
> +
> +               net_mp_niov_set_page_pool(pp, niov);
> +               net_mp_netmem_place_in_cache(pp, netmem);
> +       }
> +       spin_unlock_bh(&area->freelist_lock);
> +}
> +
> +static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp=
)
> +{
> +       struct io_zcrx_ifq *ifq =3D pp->mp_priv;
> +
> +       /* pp should already be ensuring that */
> +       if (unlikely(pp->alloc.count))
> +               goto out_return;
> +

As the comment notes, this is a very defensive check that can be
removed. We pp should never invoke alloc_netmems if it has items in
the cache.

> +       io_zcrx_ring_refill(pp, ifq);
> +       if (likely(pp->alloc.count))
> +               goto out_return;
> +
> +       io_zcrx_refill_slow(pp, ifq);
> +       if (!pp->alloc.count)
> +               return 0;
> +out_return:
> +       return pp->alloc.cache[--pp->alloc.count];
> +}
> +
> +static bool io_pp_zc_release_netmem(struct page_pool *pp, netmem_ref net=
mem)
> +{
> +       struct net_iov *niov;
> +
> +       if (WARN_ON_ONCE(!netmem_is_net_iov(netmem)))
> +               return false;
> +

Also a very defensive check that can be removed. There should be no
way for the pp to release a netmem to the provider that didn't come
from this provider. netmem should be guaranteed to be a net_iov, and
also an io_uring net_iov (not dma-buf one), and specifically be a
net_iov from this particular memory provider.

> +       niov =3D netmem_to_net_iov(netmem);
> +       net_mp_niov_clear_page_pool(niov);
> +       io_zcrx_return_niov_freelist(niov);
> +       return false;
> +}
> +
> +static int io_pp_zc_init(struct page_pool *pp)
> +{
> +       struct io_zcrx_ifq *ifq =3D pp->mp_priv;
> +
> +       if (WARN_ON_ONCE(!ifq))
> +               return -EINVAL;
> +       if (pp->dma_map)
> +               return -EOPNOTSUPP;

This condition should be flipped actually. pp->dma_map should be true,
otherwise the provider isn't supported.

From the netmem.rst docs we require that netmem page_pools are
configured with PP_FLAG_DMA_MAP.

And we actually check that pp->dma_map =3D=3D true before invoking
mp_ops->init(). This code shouldn't be working unless I missed
something.

Also arguably this check is defensive. The pp should confirm that
pp->dma_map is true before invoking any memory provider, you should
assume it is true here (and the devmem provider doesn't check it
IIRU).

> +       if (pp->p.order !=3D 0)
> +               return -EOPNOTSUPP;
> +
> +       percpu_ref_get(&ifq->ctx->refs);
> +       return 0;
> +}
> +
> +static void io_pp_zc_destroy(struct page_pool *pp)
> +{
> +       struct io_zcrx_ifq *ifq =3D pp->mp_priv;
> +
> +       percpu_ref_put(&ifq->ctx->refs);
> +}
> +
> +static int io_pp_nl_fill(void *mp_priv, struct sk_buff *rsp,
> +                        struct netdev_rx_queue *rxq)
> +{
> +       struct nlattr *nest;
> +       int type;
> +
> +       type =3D rxq ? NETDEV_A_QUEUE_IO_URING : NETDEV_A_PAGE_POOL_IO_UR=
ING;
> +       nest =3D nla_nest_start(rsp, type);
> +       if (!nest)
> +               return -EMSGSIZE;
> +       nla_nest_end(rsp, nest);
> +
> +       return 0;
> +}
> +
> +static void io_pp_uninstall(void *mp_priv, struct netdev_rx_queue *rxq)
> +{
> +       struct pp_memory_provider_params *p =3D &rxq->mp_params;
> +       struct io_zcrx_ifq *ifq =3D mp_priv;
> +
> +       io_zcrx_drop_netdev(ifq);
> +       p->mp_ops =3D NULL;
> +       p->mp_priv =3D NULL;
> +}
> +
> +static const struct memory_provider_ops io_uring_pp_zc_ops =3D {
> +       .alloc_netmems          =3D io_pp_zc_alloc_netmems,
> +       .release_netmem         =3D io_pp_zc_release_netmem,
> +       .init                   =3D io_pp_zc_init,
> +       .destroy                =3D io_pp_zc_destroy,
> +       .nl_fill                =3D io_pp_nl_fill,
> +       .uninstall              =3D io_pp_uninstall,
> +};
> diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
> index 595bca0001d2..6c808240ac91 100644
> --- a/io_uring/zcrx.h
> +++ b/io_uring/zcrx.h
> @@ -9,6 +9,7 @@
>  struct io_zcrx_area {
>         struct net_iov_area     nia;
>         struct io_zcrx_ifq      *ifq;
> +       atomic_t                *user_refs;
>
>         u16                     area_id;
>         struct page             **pages;
> @@ -26,6 +27,8 @@ struct io_zcrx_ifq {
>         struct io_uring                 *rq_ring;
>         struct io_uring_zcrx_rqe        *rqes;
>         u32                             rq_entries;
> +       u32                             cached_rq_head;
> +       spinlock_t                      rq_lock;
>
>         u32                             if_rxq;
>         struct device                   *dev;
> --
> 2.43.5
>


--=20
Thanks,
Mina

