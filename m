Return-Path: <io-uring+bounces-4330-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 777479B9925
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 21:06:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F0C421F22453
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 20:06:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80F111D47CB;
	Fri,  1 Nov 2024 20:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lWSF/fzi"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9A01D27A0
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 20:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730491583; cv=none; b=lMnxiUDl5t/ODeTfwwn2I9iGdjESM0wxYSnAG9kTBoYdAGpNv85qxcVkSFyUpYGnMrTuY6/urF8gXpXpxmssjWzhaSW0d557jdb4ApwkF4SgjK2Esz8F7Pm7shGcraMWQ80agoEHPHYnuqVYmbbwv77m4U8mQOW9kAKgPmQrIqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730491583; c=relaxed/simple;
	bh=eDvBd0RJmlf64vWUqIjHYo2mGRkX+gu6CWsdP4uXYTI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZJE6Tj9/AUXw3Gy7Fd0z9pA4sxhP0CwqQMgsxhnzOuZl3Ew8PwmncJ/bwB5kHo/6S4dbed3JkdqaIbWNGqSKRFNcxEC5PP5UrZZNb4Yt7jgtDgjsWIMiyDZRM2otGASBm1S9d4KSRuL/ABaBv5MQHyZJFyMa4qTu5CKzVLDkIvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lWSF/fzi; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4608dddaa35so74141cf.0
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 13:06:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730491580; x=1731096380; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aBX89yKJ2HqWZ/CCS0a/BYUjLVu16MLWxRK1UVwLzC0=;
        b=lWSF/fziEB9rielSGPQvevKNZgwQz4//5IAUsIor3a5qWxuvPlOODULmY5rhCTqHL3
         dYcuZ0DRjrctTgCX+e36kmqwTj9Pbi+gpWQ/0P1fs0zShFGD3joQAH1TkwmJtNfSBqOn
         9lu3KTkBNxHk9s2OeD65W0TQRJLBvAACJvcvs8CxQflmQdPj2JLm/AdeOaKk9wXvLDhG
         aZ5poZMawWruK86b2i6VITKPw4Unl7FtU/rHcoHIvXUCMIDgow6qp98/SQwPj3jOQLLs
         BwDKCPW+xSeJuTLZbbhmjcN/At9+7x/rlWy+xkvdr+gh6xkQPWjZ+W7wp5mIdYg5lyky
         RzhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730491580; x=1731096380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aBX89yKJ2HqWZ/CCS0a/BYUjLVu16MLWxRK1UVwLzC0=;
        b=ath2GG6CVE94ZKVr547u3C5OY5JWBcrDpm9+C/02F3+lkNEt+ybFoYH4Y9k6iaJQRA
         BrGDOCMLdpc+r5BkPGR6dQ4hrzmMze7rRfvmR8iEiWAKXklPOQ4VBEcBjSGc+xpFbFfO
         AC2MlFI0ApgnmXADOY3v0kUNg1slPc/5Z6plHNAltomTjy4RrIJo1tprEiDtL0+mkU/K
         EGRclfnUy7R2Q7rLeHHh7d/dZOtyH9cGpbf96PvZGLJ6uOPFGwYLGuKHJyebrp16/4vs
         t+9ruF8PuVQGg8nitCXu/d9zZFNgib/pEAl6WUxDPzi5ouG78ue//Tu7j+ywfP9IUGSr
         7r5A==
X-Gm-Message-State: AOJu0YyvYUNqLozl5wt5oMFVhdbiAyo028IUyDjolGizi0lBu2EIwP7u
	1QXqKIZTMbxz6resq0d56S02pSqrn5b5qgAvJBK+t1ssnUvXupGZZH3qF9+QY7ENe31GcNTKddy
	ULIzf7C1gNb+aJmKWIh66QKovii8xNth3KhOE
X-Gm-Gg: ASbGncstnK4BRzTS29nVwGBD28UObjUPxcuoAZYhaqruDkoyMq6ui5/frxBpqdJFtfQ
	MjsV004mMyITe/I/SGZ2Ljc7VKUehGK3CsLIXkch3tcqX+tec4TUJgNWwVsN5iw==
X-Google-Smtp-Source: AGHT+IHwnlNkeYa9/b9+eO71X2wEjzfQJjxWhWPCctBiL+ioqeUZvFNlWt+35CbcgACdxK3StDimp9sE1nirM6vKv6o=
X-Received: by 2002:ac8:5945:0:b0:461:4150:b835 with SMTP id
 d75a77b69052e-462c5ed22a2mr662271cf.6.1730491579843; Fri, 01 Nov 2024
 13:06:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029230521.2385749-1-dw@davidwei.uk> <20241029230521.2385749-12-dw@davidwei.uk>
In-Reply-To: <20241029230521.2385749-12-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 1 Nov 2024 13:06:08 -0700
Message-ID: <CAHS8izNbNCAmecRDCL_rRjMU0Spnqo_BY5pyG1EhF2rZFx+y0A@mail.gmail.com>
Subject: Re: [PATCH v7 11/15] io_uring/zcrx: implement zerocopy receive pp
 memory provider
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
> Implement a page pool memory provider for io_uring to receieve in a
> zero copy fashion. For that, the provider allocates user pages wrapped
> around into struct net_iovs, that are stored in a previously registered
> struct net_iov_area.
>
> Unlike with traditional receives, for which pages from a page pool can
> be deallocated right after the user receives data, e.g. via recv(2),
> we extend the lifetime by recycling buffers only after the user space
> acknowledges that it's done processing the data via the refill queue.
> Before handing buffers to the user, we mark them by bumping the refcount
> by a bias value IO_ZC_RX_UREF, which will be checked when the buffer is
> returned back. When the corresponding io_uring instance and/or page pool
> are destroyed, we'll force back all buffers that are currently in the
> user space in ->io_pp_zc_scrub by clearing the bias.
>
> Refcounting and lifetime:
>
> Initially, all buffers are considered unallocated and stored in
> ->freelist, at which point they are not yet directly exposed to the core
> page pool code and not accounted to page pool's pages_state_hold_cnt.
> The ->alloc_netmems callback will allocate them by placing into the
> page pool's cache, setting the refcount to 1 as usual and adjusting
> pages_state_hold_cnt.
>
> Then, either the buffer is dropped and returns back to the page pool
> into the ->freelist via io_pp_zc_release_netmem, in which case the page
> pool will match hold_cnt for us with ->pages_state_release_cnt. Or more
> likely the buffer will go through the network/protocol stacks and end up
> in the corresponding socket's receive queue. From there the user can get
> it via an new io_uring request implemented in following patches. As
> mentioned above, before giving a buffer to the user we bump the refcount
> by IO_ZC_RX_UREF.
>
> Once the user is done with the buffer processing, it must return it back
> via the refill queue, from where our ->alloc_netmems implementation can
> grab it, check references, put IO_ZC_RX_UREF, and recycle the buffer if
> there are no more users left. As we place such buffers right back into
> the page pools fast cache and they didn't go through the normal pp
> release path, they are still considered "allocated" and no pp hold_cnt
> is required. For the same reason we dma sync buffers for the device
> in io_zc_add_pp_cache().
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  io_uring/zcrx.c | 215 ++++++++++++++++++++++++++++++++++++++++++++++++
>  io_uring/zcrx.h |   5 ++
>  2 files changed, 220 insertions(+)
>
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index a276572fe953..aad35676207e 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -2,7 +2,12 @@
>  #include <linux/kernel.h>
>  #include <linux/errno.h>
>  #include <linux/mm.h>
> +#include <linux/nospec.h>
> +#include <linux/netdevice.h>
>  #include <linux/io_uring.h>
> +#include <net/page_pool/helpers.h>
> +#include <net/page_pool/memory_provider.h>
> +#include <trace/events/page_pool.h>
>
>  #include <uapi/linux/io_uring.h>
>
> @@ -14,6 +19,16 @@
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

We discussed this before I disappeared on vacation but I'm not too
convinced to be honest, sorry.

It's invalid to call io_zcrx_iov_to_area on a devmem niov and vice
versa, right? So current and future code has to be very careful to
call the right helpers on the right niovs.

At the very least there needs to be a comment above all these
container_of helpers:

/* caller must have verified that this niov is devmem/io_zcrx */.

However I feel like even a comment is extremely error prone. These
container_of's are inside of the call stack of some helpers. I would
say we need a check. If we're concerned about performance, the check
can be behind DEBUG_NET_WARN_ON(), although even that is a bit iffy,
but could be fine. Doing this without a check seems too risky to me.

>  static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
>                                  struct io_uring_zcrx_ifq_reg *reg)
>  {
> @@ -99,6 +114,9 @@ static int io_zcrx_create_area(struct io_ring_ctx *ctx=
,
>                 goto err;
>
>         for (i =3D 0; i < nr_pages; i++) {
> +               struct net_iov *niov =3D &area->nia.niovs[i];
> +
> +               niov->owner =3D &area->nia;
>                 area->freelist[i] =3D i;
>         }
>
> @@ -230,3 +248,200 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
>  {
>         lockdep_assert_held(&ctx->uring_lock);
>  }
> +
> +static bool io_zcrx_niov_put(struct net_iov *niov, int nr)
> +{
> +       return atomic_long_sub_and_test(nr, &niov->pp_ref_count);
> +}
> +
> +static bool io_zcrx_put_niov_uref(struct net_iov *niov)
> +{
> +       if (atomic_long_read(&niov->pp_ref_count) < IO_ZC_RX_UREF)
> +               return false;
> +
> +       return io_zcrx_niov_put(niov, IO_ZC_RX_UREF);
> +}
> +

Sorry, I have to push back a bit against this. The refcounting of
netmem is already complicated. the paged netmem has 2 refcounts and
care needs to be taken when acquiring and dropping refcounts. net_iov
inherited the pp_ref_count but not the paged refcount, and again need
some special handling. skb_frag_unref takes very special care checking
pp->recycle, is_pp_netmem, and others to figure out the correct
refcount to put based on the type of the netmem and skb flag.

This code ignores all these generic code
skb_frag_unref/napi_pp_put_page/etc paths and uses raw access to
niv->pp_ref_count. If this is merged as-is, for posterity any changes
in netmem refcounting need to also account for this use case opting
out of these generic code paths that handle all other skb reffing
including devmem.

Additionally since you're opting out of the generic unreffing paths
you're also (as mentioned before) bypassing the pp recycling. AFAICT
that may be hurting your performance. IIUC you refill
PP_ALLOC_CACHE_REFILL (64) entries everytime _alloc_netmems is
entered, and you don't recycle netmem any other way, so your slow path
is entered 1/64 of the page_pool_alloc calls? That should be much
worse than what the normal pp recycling does, which returns all freed
netmem into its alloc.cache or the ptr_ring and hits *_alloc_netmems
much more rarely. There are also regular perf improvements and testing
to the generic pool recycling paths you're also opting out of.

I see a lot of downsides to opting out of the generic use cases. Is
there any reason the normal freeing paths are not applicable to your
use case?

> +static inline void io_zc_add_pp_cache(struct page_pool *pp,
> +                                     struct net_iov *niov)
> +{
> +}
> +

Looks unused/empty.

> +static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
> +{
> +       u32 entries;
> +
> +       entries =3D smp_load_acquire(&ifq->rq_ring->tail) - ifq->cached_r=
q_head;
> +       return min(entries, ifq->rq_entries);
> +}
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
> +       unsigned int entries =3D io_zcrx_rqring_entries(ifq);
> +       unsigned int mask =3D ifq->rq_entries - 1;
> +
> +       entries =3D min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL - pp->=
alloc.count);
> +       if (unlikely(!entries))
> +               return;
> +
> +       do {
> +               struct io_uring_zcrx_rqe *rqe =3D io_zcrx_get_rqe(ifq, ma=
sk);
> +               struct io_zcrx_area *area;
> +               struct net_iov *niov;
> +               unsigned niov_idx, area_idx;
> +
> +               area_idx =3D rqe->off >> IORING_ZCRX_AREA_SHIFT;
> +               niov_idx =3D (rqe->off & ~IORING_ZCRX_AREA_MASK) / PAGE_S=
IZE;
> +
> +               if (unlikely(rqe->__pad || area_idx))
> +                       continue;
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
> +               page_pool_mp_return_in_cache(pp, net_iov_to_netmem(niov))=
;

I'm sorry I pushed back against the provider filling the pp cache in
earlier iterations. That was very wrong.

*_alloc_netmems was meant to be a mirror of
__page_pool_alloc_pages_slow. Since the latter fills the pp->cache,
the former should also fill the pp->cache. The dmabuf mp is actually
deficient in this regard. I'll look into fixing it. This part is more
than fine for me.

I'm still unsure about opting out of the generic freeing paths as I
mentioned above though.

> +       } while (--entries);
> +
> +       smp_store_release(&ifq->rq_ring->head, ifq->cached_rq_head);
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
> +               struct net_iov *niov;
> +               u32 pgid;
> +
> +               pgid =3D area->freelist[--area->free_count];
> +               niov =3D &area->nia.niovs[pgid];
> +
> +               page_pool_mp_return_in_cache(pp, net_iov_to_netmem(niov))=
;
> +
> +               pp->pages_state_hold_cnt++;
> +               trace_page_pool_state_hold(pp, net_iov_to_netmem(niov),
> +                                          pp->pages_state_hold_cnt);
> +       }
> +       spin_unlock_bh(&area->freelist_lock);
> +}
> +
> +static void io_zcrx_recycle_niov(struct net_iov *niov)
> +{
> +       struct io_zcrx_area *area =3D io_zcrx_iov_to_area(niov);
> +
> +       spin_lock_bh(&area->freelist_lock);
> +       area->freelist[area->free_count++] =3D net_iov_idx(niov);
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
> +       niov =3D netmem_to_net_iov(netmem);
> +
> +       if (io_zcrx_niov_put(niov, 1))
> +               io_zcrx_recycle_niov(niov);
> +       return false;
> +}
> +
> +static void io_pp_zc_scrub(struct page_pool *pp)
> +{
> +       struct io_zcrx_ifq *ifq =3D pp->mp_priv;
> +       struct io_zcrx_area *area =3D ifq->area;
> +       int i;
> +
> +       /* Reclaim back all buffers given to the user space. */
> +       for (i =3D 0; i < area->nia.num_niovs; i++) {
> +               struct net_iov *niov =3D &area->nia.niovs[i];
> +               int count;
> +
> +               if (!io_zcrx_put_niov_uref(niov))
> +                       continue;
> +               io_zcrx_recycle_niov(niov);
> +
> +               count =3D atomic_inc_return_relaxed(&pp->pages_state_rele=
ase_cnt);
> +               trace_page_pool_state_release(pp, net_iov_to_netmem(niov)=
, count);
> +       }
> +}
> +
> +static int io_pp_zc_init(struct page_pool *pp)
> +{
> +       struct io_zcrx_ifq *ifq =3D pp->mp_priv;
> +       struct io_zcrx_area *area =3D ifq->area;
> +       int ret;
> +
> +       if (!ifq)
> +               return -EINVAL;
> +       if (pp->p.order !=3D 0)
> +               return -EINVAL;
> +       if (!pp->p.napi)
> +               return -EINVAL;
> +
> +       ret =3D page_pool_mp_init_paged_area(pp, &area->nia, area->pages)=
;
> +       if (ret)
> +               return ret;
> +
> +       percpu_ref_get(&ifq->ctx->refs);
> +       ifq->pp =3D pp;
> +       return 0;
> +}
> +
> +static void io_pp_zc_destroy(struct page_pool *pp)
> +{
> +       struct io_zcrx_ifq *ifq =3D pp->mp_priv;
> +       struct io_zcrx_area *area =3D ifq->area;
> +
> +       page_pool_mp_release_area(pp, &ifq->area->nia);
> +
> +       ifq->pp =3D NULL;
> +
> +       if (WARN_ON_ONCE(area->free_count !=3D area->nia.num_niovs))
> +               return;
> +       percpu_ref_put(&ifq->ctx->refs);
> +}
> +
> +static const struct memory_provider_ops io_uring_pp_zc_ops =3D {
> +       .alloc_netmems          =3D io_pp_zc_alloc_netmems,
> +       .release_netmem         =3D io_pp_zc_release_netmem,
> +       .init                   =3D io_pp_zc_init,
> +       .destroy                =3D io_pp_zc_destroy,
> +       .scrub                  =3D io_pp_zc_scrub,
> +};
> diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
> index a8db61498c67..464b4bd89b64 100644
> --- a/io_uring/zcrx.h
> +++ b/io_uring/zcrx.h
> @@ -5,6 +5,9 @@
>  #include <linux/io_uring_types.h>
>  #include <net/page_pool/types.h>
>
> +#define IO_ZC_RX_UREF                  0x10000
> +#define IO_ZC_RX_KREF_MASK             (IO_ZC_RX_UREF - 1)
> +
>  struct io_zcrx_area {
>         struct net_iov_area     nia;
>         struct io_zcrx_ifq      *ifq;
> @@ -22,10 +25,12 @@ struct io_zcrx_ifq {
>         struct io_ring_ctx              *ctx;
>         struct net_device               *dev;
>         struct io_zcrx_area             *area;
> +       struct page_pool                *pp;
>
>         struct io_uring                 *rq_ring;
>         struct io_uring_zcrx_rqe        *rqes;
>         u32                             rq_entries;
> +       u32                             cached_rq_head;
>
>         unsigned short                  n_rqe_pages;
>         struct page                     **rqe_pages;
> --
> 2.43.5
>


--
Thanks,
Mina

