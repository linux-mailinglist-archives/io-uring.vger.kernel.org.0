Return-Path: <io-uring+bounces-5748-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F022A04AEA
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 21:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A4CEA3A12A9
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 20:23:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD1811F63EA;
	Tue,  7 Jan 2025 20:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xQsDyF/A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5901F2384
	for <io-uring@vger.kernel.org>; Tue,  7 Jan 2025 20:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736281429; cv=none; b=UF0ToGFpkVqQ/xO38AFk1EymjCC65016kcmzL7EuP8vp3qouXZ9w6MMNrpjjns/GZlDyfqk6CYIwqHi2QxMWfqI9Ny0lc3noPXiRbUvwL7gqI6LZVuipXEeox+eFOGLaHbE/w4uxUYT2XVYU01h79BXtqV4U1aQItSMIioVw2Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736281429; c=relaxed/simple;
	bh=Jy7ufaAZxeHsIB8mgumcMJjxCY01L5Plz5SvsiGtDOs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=P3wLvqlwuCSxX5inBcds4rML9If2qtF0uAKuopSivds2FEMQMfKf0LMw3U0JNdfQbbcfO/wtEl26WpUOM8uo3pk+jCf0Tj4VfRjU/zwXMxun7kBjymEBd+Yo7KA8kpXlNB5gJoNAA9ge399wJt6oUquLDVACpdekZhePcHm6xbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xQsDyF/A; arc=none smtp.client-ip=209.85.160.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4679b5c66d0so47601cf.1
        for <io-uring@vger.kernel.org>; Tue, 07 Jan 2025 12:23:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736281425; x=1736886225; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTdZjJk5lYa4ewl/fDmVwAOtmVq6Ea5S7Ffs64kpgoo=;
        b=xQsDyF/AljtqOwWdcfijmpC8R4js6Arpflgs2oVfCyqAA5/Kn36y+pH61pfbbJaSYj
         fYXCBNv6aw+4k+GANBiTGmtl7VSE8Nx8z25STWQ58wG+SPv8N3ucMl5KYCtpBz9fmBwZ
         YhsHGW3R2+UVaUPYH5WybkamW0WT779pF0NKZY0ueBItZN9i4sAgo0QbqYeVvCxV+9o8
         FyLrHBIiOavneI4VqHbs3woyDCwjbivZKVO2St27t4ikpbCOynuN1FNjjbBXXhMtinGj
         JTb4Vd6mrR/Nw1VwIoeLw9Zca4nX6XDxKqbXauhlpkVTMSR/VCqgOiC3jvi0dCZhzrxo
         cZuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736281425; x=1736886225;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MTdZjJk5lYa4ewl/fDmVwAOtmVq6Ea5S7Ffs64kpgoo=;
        b=Hp2BGvG/3DUOh6PVHqSZiqPjGo9hPBWgQrjhgCXHvkstSQrSii3tai+OT4u2FK+3qx
         DL2Mb2T74JmPTsBP0w1E4X+YLrQhOE3PmmTTxyNrdPGO3Komei3314P4+LkFQnoO2zTl
         eZyu1Z/flmmOj9xNxe5ZrFvscrpvaSRtaCp8VzrkWnSxi2Z9v8wTZ10Vb/sYThUH9hHg
         gCtqq+UoPmYZuPUSZa7tuEBZRbH7fOgNaeNaEolfVObGHF3ok8D/VNvGWsdMYkaDVp7R
         QNuqzLAHidYSYsLKMDe7MhFc5sr/YWA/byUtwpH74F7fkHBG73junQWBg6DM0NT7V9ZB
         wwOQ==
X-Gm-Message-State: AOJu0YyWnYMximd2lvMM7qX+5QqQopyqz1r59mYpOsQFXyDC86afhEzT
	cmH1cY7yG9xNr5uF/oMR+cXbLdGJMCz/Cz3gYCxzO/ndlATcAs176wpdJ1VTv9upZ8EDmOuGsVy
	5qIj9DNauERBeN8OG+cZ3cfixAP46OybGmXNs
X-Gm-Gg: ASbGncv6f3lo24dX4oxyyz3wQn1cFiqLlc3cfhILk8Yh/SKZeGqmDs7QhC89v5y/NFu
	QCCVplB1EfUaJj4tj0ybYOEp9eQrReHiMF5WVnzYT0W5h7ZyMtGK0hDqs6gch2lbFenI=
X-Google-Smtp-Source: AGHT+IHkrSyB9IWEWQpzhGmKd8N4hasAGOhjefH9DlyRfnbtD5Pl4JU4/JFS2F/yBl589ldU/ugXAd3BLczB2xex3+c=
X-Received: by 2002:a05:622a:1210:b0:46a:312a:54bc with SMTP id
 d75a77b69052e-46c70ca90c1mr538511cf.24.1736281425145; Tue, 07 Jan 2025
 12:23:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241218003748.796939-1-dw@davidwei.uk> <20241218003748.796939-15-dw@davidwei.uk>
In-Reply-To: <20241218003748.796939-15-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 7 Jan 2025 12:23:32 -0800
Message-ID: <CAHS8izMKM_if=jZj3Cw0XAaKrfhX31EoqzRR9Dh+7MbiUkUS1w@mail.gmail.com>
Subject: Re: [PATCH net-next v9 14/20] io_uring/zcrx: dma-map area for the device
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

On Tue, Dec 17, 2024 at 4:38=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> Setup DMA mappings for the area into which we intend to receive data
> later on. We know the device we want to attach to even before we get a
> page pool and can pre-map in advance. All net_iov are synchronised for
> device when allocated, see page_pool_mp_return_in_cache().
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/uapi/linux/netdev.h |   1 +
>  io_uring/zcrx.c             | 320 ++++++++++++++++++++++++++++++++++++
>  io_uring/zcrx.h             |   4 +
>  3 files changed, 325 insertions(+)
>
> diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> index e4be227d3ad6..13d810a28ed6 100644
> --- a/include/uapi/linux/netdev.h
> +++ b/include/uapi/linux/netdev.h
> @@ -94,6 +94,7 @@ enum {
>         NETDEV_A_PAGE_POOL_INFLIGHT_MEM,
>         NETDEV_A_PAGE_POOL_DETACH_TIME,
>         NETDEV_A_PAGE_POOL_DMABUF,
> +       NETDEV_A_PAGE_POOL_IO_URING,
>
>         __NETDEV_A_PAGE_POOL_MAX,
>         NETDEV_A_PAGE_POOL_MAX =3D (__NETDEV_A_PAGE_POOL_MAX - 1)
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index e6cca6747148..42098bc1a60f 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> @@ -1,11 +1,18 @@
>  // SPDX-License-Identifier: GPL-2.0
>  #include <linux/kernel.h>
>  #include <linux/errno.h>
> +#include <linux/dma-map-ops.h>
>  #include <linux/mm.h>
> +#include <linux/nospec.h>
>  #include <linux/io_uring.h>
>  #include <linux/netdevice.h>
>  #include <linux/rtnetlink.h>
>
> +#include <net/page_pool/helpers.h>
> +#include <net/netlink.h>
> +
> +#include <trace/events/page_pool.h>
> +
>  #include <uapi/linux/io_uring.h>
>
>  #include "io_uring.h"
> @@ -14,8 +21,92 @@
>  #include "zcrx.h"
>  #include "rsrc.h"
>
> +#define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
> +
> +static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
> +                                struct io_zcrx_area *area, int nr_mapped=
)
> +{
> +       struct device *dev =3D ifq->dev->dev.parent;
> +       int i;
> +
> +       for (i =3D 0; i < nr_mapped; i++) {
> +               struct net_iov *niov =3D &area->nia.niovs[i];
> +               dma_addr_t dma;
> +
> +               dma =3D page_pool_get_dma_addr_netmem(net_iov_to_netmem(n=
iov));
> +               dma_unmap_page_attrs(dev, dma, PAGE_SIZE, DMA_FROM_DEVICE=
,
> +                                    IO_DMA_ATTR);
> +               page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov), 0)=
;
> +       }
> +}
> +
> +static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq, struct io_zcrx_a=
rea *area)
> +{
> +       if (area->is_mapped)
> +               __io_zcrx_unmap_area(ifq, area, area->nia.num_niovs);
> +}
> +
> +static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area=
 *area)
> +{
> +       struct device *dev =3D ifq->dev->dev.parent;
> +       int i;
> +
> +       if (!dev)
> +               return -EINVAL;
> +
> +       for (i =3D 0; i < area->nia.num_niovs; i++) {
> +               struct net_iov *niov =3D &area->nia.niovs[i];
> +               dma_addr_t dma;
> +
> +               dma =3D dma_map_page_attrs(dev, area->pages[i], 0, PAGE_S=
IZE,
> +                                        DMA_FROM_DEVICE, IO_DMA_ATTR);
> +               if (dma_mapping_error(dev, dma))
> +                       break;
> +               if (page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov)=
, dma)) {
> +                       dma_unmap_page_attrs(dev, dma, PAGE_SIZE,
> +                                            DMA_FROM_DEVICE, IO_DMA_ATTR=
);
> +                       break;
> +               }
> +       }
> +
> +       if (i !=3D area->nia.num_niovs) {
> +               __io_zcrx_unmap_area(ifq, area, i);
> +               return -EINVAL;
> +       }
> +
> +       area->is_mapped =3D true;
> +       return 0;
> +}
> +
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
> @@ -49,8 +140,11 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq=
)
>
>  static void io_zcrx_free_area(struct io_zcrx_area *area)
>  {
> +       io_zcrx_unmap_area(area->ifq, area);
> +
>         kvfree(area->freelist);
>         kvfree(area->nia.niovs);
> +       kvfree(area->user_refs);
>         if (area->pages) {
>                 unpin_user_pages(area->pages, area->nia.num_niovs);
>                 kvfree(area->pages);
> @@ -106,6 +200,19 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *i=
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
> @@ -130,6 +237,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct i=
o_ring_ctx *ctx)
>
>         ifq->if_rxq =3D -1;
>         ifq->ctx =3D ctx;
> +       spin_lock_init(&ifq->rq_lock);
>         return ifq;
>  }
>
> @@ -205,6 +313,10 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
>         if (!ifq->dev)
>                 goto err;
>
> +       ret =3D io_zcrx_map_area(ifq, ifq->area);
> +       if (ret)
> +               goto err;
> +
>         reg.offsets.rqes =3D sizeof(struct io_uring);
>         reg.offsets.head =3D offsetof(struct io_uring, head);
>         reg.offsets.tail =3D offsetof(struct io_uring, tail);
> @@ -238,7 +350,215 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ct=
x)
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

I have a suspicion that uref is now redundant in this series, although
I'm not 100% sure. You seem to acquire a uref and pp_ref in tandem in
io_zcrx_recv_frag and drop both in tandem in this function, which
makes me think the uref maybe is redundant now.

io_zcrx_copy_chunk acquires a uref but not a pp_ref. I wonder if
copy_chunk can do a page_pool_ref_netmem() instead of a uref, maybe
you would be able to make do without urefs at all. I have not looked
at the copy fallback code closely.

> +
> +               netmem =3D net_iov_to_netmem(niov);
> +               if (page_pool_unref_netmem(netmem, 1) !=3D 0)
> +                       continue;
> +
> +               if (unlikely(niov->pp !=3D pp)) {

From niov->pp !=3D pp I surmise in this iteration one io_zcrx_area can
serve niovs to multiple RX queues?

> +                       io_zcrx_return_niov(niov);

The last 5 lines or so is basically doing  what page_pool_put_netmem()
does, except there is a pp !=3D niov->pp check in the middle. Can we
call page_pool_put_netmem() directly if pp !=3D niov->pp? It would just
reduce the code duplication a bit and reduce the amount of custom
reffing code we need to add for this mp.

> +                       continue;
> +               }
> +
> +               page_pool_mp_return_in_cache(pp, netmem);

So if niov->pp !=3D pp, we end up basically doing a
page_pool_put_netmem(), which is the 'correct' way to return a netmem
to the page_pool, or at least is the way to return a netmem that all
the other devmem/pages memory types uses. However if niov->pp =3D=3D pp,
we end up page_pool_mp_return_in_cache(), which is basically the same
as page_pool_put_unrefed_netmem but skips the ptr_ring, so it's
slightly faster and less overhead.

I would honestly elect to page_pool_put_netmem() regardless of
niov->pp/pp check. Sure it would be a bit more overhead than the code
here, but it would reduce the custom pp refing code we need to add for
this mp and it will replenish the ptr_ring in both cases, which may be
even faster by reducing the number of times we need to replenish. We
can always add micro optimizations like skipping the ptr_ring for
slightly faster code if there is evidence there is significant perf
improvement.

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

I assume if you have 1 area serving many rx queues then you start
contending on this lock, no? If you find it so in the future, genpool
may help.

> +       while (area->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFIL=
L) {
> +               struct net_iov *niov =3D __io_zcrx_get_free_niov(area);
> +               netmem_ref netmem =3D net_iov_to_netmem(niov);
> +
> +               page_pool_set_pp_info(pp, netmem);
> +               page_pool_mp_return_in_cache(pp, netmem);
> +
> +               pp->pages_state_hold_cnt++;
> +               trace_page_pool_state_hold(pp, netmem, pp->pages_state_ho=
ld_cnt);
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
> +       if (WARN_ON_ONCE(!netmem_is_net_iov(netmem)))
> +               return false;
> +
> +       if (page_pool_unref_netmem(netmem, 1) =3D=3D 0)

Check is redundant, AFAICT. pp would never release a netmem unless the
pp refcount is 1.

> +               io_zcrx_return_niov_freelist(netmem_to_net_iov(netmem));
> +       return false;
>  }
> +
> +static int io_pp_zc_init(struct page_pool *pp)
> +{
> +       struct io_zcrx_ifq *ifq =3D pp->mp_priv;
> +
> +       if (WARN_ON_ONCE(!ifq))
> +               return -EINVAL;
> +       if (WARN_ON_ONCE(ifq->dev !=3D pp->slow.netdev))
> +               return -EINVAL;
> +       if (pp->dma_map)
> +               return -EOPNOTSUPP;
> +       if (pp->p.order !=3D 0)
> +               return -EOPNOTSUPP;
> +       if (pp->p.dma_dir !=3D DMA_FROM_DEVICE)
> +               return -EOPNOTSUPP;
> +
> +       percpu_ref_get(&ifq->ctx->refs);
> +       return 0;
> +}
> +
> +static void io_pp_zc_destroy(struct page_pool *pp)
> +{
> +       struct io_zcrx_ifq *ifq =3D pp->mp_priv;
> +       struct io_zcrx_area *area =3D ifq->area;
> +
> +       if (WARN_ON_ONCE(area->free_count !=3D area->nia.num_niovs))
> +               return;
> +       percpu_ref_put(&ifq->ctx->refs);
> +}
> +
> +static int io_pp_nl_report(const struct page_pool *pool, struct sk_buff =
*rsp)
> +{
> +       return nla_put_u32(rsp, NETDEV_A_PAGE_POOL_IO_URING, 0);
> +}
> +
> +static const struct memory_provider_ops io_uring_pp_zc_ops =3D {
> +       .alloc_netmems          =3D io_pp_zc_alloc_netmems,
> +       .release_netmem         =3D io_pp_zc_release_netmem,
> +       .init                   =3D io_pp_zc_init,
> +       .destroy                =3D io_pp_zc_destroy,
> +       .nl_report              =3D io_pp_nl_report,
> +};
> diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
> index 46988a1dbd54..beacf1ea6380 100644
> --- a/io_uring/zcrx.h
> +++ b/io_uring/zcrx.h
> @@ -9,7 +9,9 @@
>  struct io_zcrx_area {
>         struct net_iov_area     nia;
>         struct io_zcrx_ifq      *ifq;
> +       atomic_t                *user_refs;
>
> +       bool                    is_mapped;
>         u16                     area_id;
>         struct page             **pages;
>
> @@ -26,6 +28,8 @@ struct io_zcrx_ifq {
>         struct io_uring                 *rq_ring;
>         struct io_uring_zcrx_rqe        *rqes;
>         u32                             rq_entries;
> +       u32                             cached_rq_head;
> +       spinlock_t                      rq_lock;
>
>         u32                             if_rxq;
>         struct net_device               *dev;
> --
> 2.43.5
>


--
Thanks,
Mina

