Return-Path: <io-uring+bounces-324-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 35F8F8194B9
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 00:44:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 27F051C252FB
	for <lists+io-uring@lfdr.de>; Tue, 19 Dec 2023 23:44:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8FC38DD1;
	Tue, 19 Dec 2023 23:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t+JpYqGg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291D03D0DB
	for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 23:44:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-553a8e67d1eso1472330a12.1
        for <io-uring@vger.kernel.org>; Tue, 19 Dec 2023 15:44:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1703029479; x=1703634279; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Efn2BKPVPbpMDZ/DN82ZFRz90BMfrcBq6mcSKCI8VM=;
        b=t+JpYqGgsT1QZbofvpeQywgL2I4i2xxJHDEuAE9QSaS5bZfH3ElQ8jicuiOke34Odn
         3JAKmKyKDCn/0732TdG7lQ0vQSqaiNqT1+NMMktRdDkoLUy7Lsj1gRRsFfLV4p4Gpg3T
         Im0Fir+jjTyYbc0HzTrvaFGVh9NU9b5qD6KvCCgOl1Vz5WXNT9rSco+JkyjQteOXs6we
         bqZN9eq/Z+y/rFE1wgdkIgfN4FNN5Vlw2bKlQ9EsKp/Q+J6aSCGeJXgXeVztehoxcbyt
         uV8c9WBlhmIqoivPJMyEU5JuFA6Mujz99ql/AB+/9x8QiVxR7+6ySb/tVhJPjrnkZ/xG
         7RZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703029479; x=1703634279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Efn2BKPVPbpMDZ/DN82ZFRz90BMfrcBq6mcSKCI8VM=;
        b=vhmwoU0X2zQ4hA8GTNr3+iD/LLIXpPdWKFbpARDJ6D/UR3U8WcIzi9QvZHdJuuG8lJ
         GqdwWTxyRNvE04/B8fQ2nu0EEkwgJMDcFQMR5RRzVi9wFevPNh6QFwvOTqb86mEnl7SD
         JZOHz/NL5HhZRArKpmPoG/o9N6BOCP2OXkwZuvBx80a/ZRzaFmMo6cu3tIfgJtsZ3egI
         G57XmsAIdSEPKhlWhHLnD1YfF234h7U6NjN28V+4SKECAl7eDM8QmXoPvDNbX6IOkocd
         mYaHdoyOfDUOvetgo2DC2882Uz/lfhvZgMIg7OwfOqOf41FcmTT0MsDgfn3PZy9xMiVV
         Hwnw==
X-Gm-Message-State: AOJu0YxM3/CXDx9zf4gkemtKe9ls4r0OlovNNHyNZ4xHRvZJ/uCA0duU
	IWMQSPptK8lLcoJDQF3PVKMEPFdvuK4VnAqBANzthg==
X-Google-Smtp-Source: AGHT+IFfZGJl3Fz7tNeAHn+3mUvEBoFYt41FySMnogjhfMBWi8OY5QdQA+LQ9Mmbiusds8MY+KSFvM4tBsjDADN3dMk=
X-Received: by 2002:a17:906:2e8d:b0:a23:386d:7ff3 with SMTP id
 o13-20020a1709062e8d00b00a23386d7ff3mr2823504eji.115.1703029479216; Tue, 19
 Dec 2023 15:44:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231219210357.4029713-1-dw@davidwei.uk> <20231219210357.4029713-14-dw@davidwei.uk>
In-Reply-To: <20231219210357.4029713-14-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Tue, 19 Dec 2023 15:44:27 -0800
Message-ID: <CAHS8izPHG5=z_x1RF3vht9bvPMG2hJ9-aTGqD3mzHwDSKHwi0g@mail.gmail.com>
Subject: Re: [RFC PATCH v3 13/20] io_uring: implement pp memory provider for
 zc rx
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
> We're adding a new pp memory provider to implement io_uring zerocopy
> receive. It'll be "registered" in pp and used in later paches.
>
> The typical life cycle of a buffer goes as follows: first it's allocated
> to a driver with the initial refcount set to 1. The drivers fills it
> with data, puts it into an skb and passes down the stack, where it gets
> queued up to a socket. Later, a zc io_uring request will be receiving
> data from the socket from a task context. At that point io_uring will
> tell the userspace that this buffer has some data by posting an
> appropriate completion. It'll also elevating the refcount by
> IO_ZC_RX_UREF, so the buffer is not recycled while userspace is reading

After you rebase to the latest RFC, you will want to elevante the
[pp|n]iov->pp_ref_count, rather than the non-existent ppiov->refcount.
I do the same thing for devmem TCP.

> the data. When the userspace is done with the buffer it should return it
> back to io_uring by adding an entry to the buffer refill ring. When
> necessary io_uring will poll the refill ring, compare references
> including IO_ZC_RX_UREF and reuse the buffer.
>
> Initally, all buffers are placed in a spinlock protected ->freelist.
> It's a slow path stash, where buffers are considered to be unallocated
> and not exposed to core page pool. On allocation, pp will first try
> all its caches, and the ->alloc_pages callback if everything else
> failed.
>
> The hot path for io_pp_zc_alloc_pages() is to grab pages from the refill
> ring. The consumption from the ring is always done in the attached napi
> context, so no additional synchronisation required. If that fails we'll
> be getting buffers from the ->freelist.
>
> Note: only ->freelist are considered unallocated for page pool, so we
> only add pages_state_hold_cnt when allocating from there. Subsequently,
> as page_pool_return_page() and others bump the ->pages_state_release_cnt
> counter, io_pp_zc_release_page() can only use ->freelist, which is not a
> problem as it's not a slow path.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>  include/linux/io_uring/net.h |   5 +
>  io_uring/zc_rx.c             | 204 +++++++++++++++++++++++++++++++++++
>  io_uring/zc_rx.h             |   6 ++
>  3 files changed, 215 insertions(+)
>
> diff --git a/include/linux/io_uring/net.h b/include/linux/io_uring/net.h
> index d994d26116d0..13244ae5fc4a 100644
> --- a/include/linux/io_uring/net.h
> +++ b/include/linux/io_uring/net.h
> @@ -13,6 +13,11 @@ struct io_zc_rx_buf {
>  };
>
>  #if defined(CONFIG_IO_URING)
> +
> +#if defined(CONFIG_PAGE_POOL)
> +extern const struct pp_memory_provider_ops io_uring_pp_zc_ops;
> +#endif
> +
>  int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags=
);
>
>  #else
> diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
> index 1e656b481725..ff1dac24ac40 100644
> --- a/io_uring/zc_rx.c
> +++ b/io_uring/zc_rx.c
> @@ -6,6 +6,7 @@
>  #include <linux/io_uring.h>
>  #include <linux/netdevice.h>
>  #include <linux/nospec.h>
> +#include <trace/events/page_pool.h>
>
>  #include <uapi/linux/io_uring.h>
>
> @@ -387,4 +388,207 @@ int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
>         return 0;
>  }
>
> +static inline struct io_zc_rx_buf *io_iov_to_buf(struct page_pool_iov *i=
ov)
> +{
> +       return container_of(iov, struct io_zc_rx_buf, ppiov);
> +}
> +
> +static inline unsigned io_buf_pgid(struct io_zc_rx_pool *pool,
> +                                  struct io_zc_rx_buf *buf)
> +{
> +       return buf - pool->bufs;
> +}
> +
> +static __maybe_unused void io_zc_rx_get_buf_uref(struct io_zc_rx_buf *bu=
f)
> +{
> +       refcount_add(IO_ZC_RX_UREF, &buf->ppiov.refcount);
> +}
> +
> +static bool io_zc_rx_put_buf_uref(struct io_zc_rx_buf *buf)
> +{
> +       if (page_pool_iov_refcount(&buf->ppiov) < IO_ZC_RX_UREF)
> +               return false;
> +
> +       return page_pool_iov_sub_and_test(&buf->ppiov, IO_ZC_RX_UREF);
> +}
> +
> +static inline struct page *io_zc_buf_to_pp_page(struct io_zc_rx_buf *buf=
)
> +{
> +       return page_pool_mangle_ppiov(&buf->ppiov);
> +}
> +
> +static inline void io_zc_add_pp_cache(struct page_pool *pp,
> +                                     struct io_zc_rx_buf *buf)
> +{
> +       refcount_set(&buf->ppiov.refcount, 1);
> +       pp->alloc.cache[pp->alloc.count++] =3D io_zc_buf_to_pp_page(buf);
> +}
> +
> +static inline u32 io_zc_rx_rqring_entries(struct io_zc_rx_ifq *ifq)
> +{
> +       struct io_rbuf_ring *ring =3D ifq->ring;
> +       u32 entries;
> +
> +       entries =3D smp_load_acquire(&ring->rq.tail) - ifq->cached_rq_hea=
d;
> +       return min(entries, ifq->rq_entries);
> +}
> +
> +static void io_zc_rx_ring_refill(struct page_pool *pp,
> +                                struct io_zc_rx_ifq *ifq)
> +{
> +       unsigned int entries =3D io_zc_rx_rqring_entries(ifq);
> +       unsigned int mask =3D ifq->rq_entries - 1;
> +       struct io_zc_rx_pool *pool =3D ifq->pool;
> +
> +       if (unlikely(!entries))
> +               return;
> +
> +       while (entries--) {
> +               unsigned int rq_idx =3D ifq->cached_rq_head++ & mask;
> +               struct io_uring_rbuf_rqe *rqe =3D &ifq->rqes[rq_idx];
> +               u32 pgid =3D rqe->off / PAGE_SIZE;
> +               struct io_zc_rx_buf *buf =3D &pool->bufs[pgid];
> +
> +               if (!io_zc_rx_put_buf_uref(buf))
> +                       continue;
> +               io_zc_add_pp_cache(pp, buf);
> +               if (pp->alloc.count >=3D PP_ALLOC_CACHE_REFILL)
> +                       break;
> +       }
> +       smp_store_release(&ifq->ring->rq.head, ifq->cached_rq_head);
> +}
> +
> +static void io_zc_rx_refill_slow(struct page_pool *pp, struct io_zc_rx_i=
fq *ifq)
> +{
> +       struct io_zc_rx_pool *pool =3D ifq->pool;
> +
> +       spin_lock_bh(&pool->freelist_lock);
> +       while (pool->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFIL=
L) {
> +               struct io_zc_rx_buf *buf;
> +               u32 pgid;
> +
> +               pgid =3D pool->freelist[--pool->free_count];
> +               buf =3D &pool->bufs[pgid];
> +
> +               io_zc_add_pp_cache(pp, buf);
> +               pp->pages_state_hold_cnt++;
> +               trace_page_pool_state_hold(pp, io_zc_buf_to_pp_page(buf),
> +                                          pp->pages_state_hold_cnt);
> +       }
> +       spin_unlock_bh(&pool->freelist_lock);
> +}
> +
> +static void io_zc_rx_recycle_buf(struct io_zc_rx_pool *pool,
> +                                struct io_zc_rx_buf *buf)
> +{
> +       spin_lock_bh(&pool->freelist_lock);
> +       pool->freelist[pool->free_count++] =3D io_buf_pgid(pool, buf);
> +       spin_unlock_bh(&pool->freelist_lock);
> +}
> +
> +static struct page *io_pp_zc_alloc_pages(struct page_pool *pp, gfp_t gfp=
)
> +{
> +       struct io_zc_rx_ifq *ifq =3D pp->mp_priv;
> +
> +       /* pp should already be ensuring that */
> +       if (unlikely(pp->alloc.count))
> +               goto out_return;
> +
> +       io_zc_rx_ring_refill(pp, ifq);
> +       if (likely(pp->alloc.count))
> +               goto out_return;
> +
> +       io_zc_rx_refill_slow(pp, ifq);
> +       if (!pp->alloc.count)
> +               return NULL;
> +out_return:
> +       return pp->alloc.cache[--pp->alloc.count];
> +}
> +
> +static bool io_pp_zc_release_page(struct page_pool *pp, struct page *pag=
e)
> +{
> +       struct io_zc_rx_ifq *ifq =3D pp->mp_priv;
> +       struct page_pool_iov *ppiov;
> +
> +       if (WARN_ON_ONCE(!page_is_page_pool_iov(page)))
> +               return false;
> +
> +       ppiov =3D page_to_page_pool_iov(page);
> +
> +       if (!page_pool_iov_sub_and_test(ppiov, 1))
> +               return false;
> +
> +       io_zc_rx_recycle_buf(ifq->pool, io_iov_to_buf(ppiov));
> +       return true;
> +}
> +
> +static void io_pp_zc_scrub(struct page_pool *pp)
> +{
> +       struct io_zc_rx_ifq *ifq =3D pp->mp_priv;
> +       struct io_zc_rx_pool *pool =3D ifq->pool;
> +       struct io_zc_rx_buf *buf;
> +       int i;
> +
> +       for (i =3D 0; i < pool->nr_bufs; i++) {
> +               buf =3D &pool->bufs[i];
> +
> +               if (io_zc_rx_put_buf_uref(buf)) {
> +                       /* just return it to the page pool, it'll clean i=
t up */
> +                       refcount_set(&buf->ppiov.refcount, 1);
> +                       page_pool_iov_put_many(&buf->ppiov, 1);
> +               }
> +       }
> +}
> +

I'm unsure about this. So scrub forcibly frees the pending data? Why
does this work? Can't the application want to read this data even
though the page_pool is destroyed?

AFAIK the page_pool being destroyed doesn't mean we can free the
pages/niovs in it. The niovs that were in it can be waiting on the
receive queue for the application to call recvmsg() on it. Does
io_uring work differently such that you're able to force-free the
ppiovs/niovs?

> +static void io_zc_rx_init_pool(struct io_zc_rx_pool *pool,
> +                              struct page_pool *pp)
> +{
> +       struct io_zc_rx_buf *buf;
> +       int i;
> +
> +       for (i =3D 0; i < pool->nr_bufs; i++) {
> +               buf =3D &pool->bufs[i];
> +               buf->ppiov.pp =3D pp;
> +       }
> +}
> +
> +static int io_pp_zc_init(struct page_pool *pp)
> +{
> +       struct io_zc_rx_ifq *ifq =3D pp->mp_priv;
> +
> +       if (!ifq)
> +               return -EINVAL;
> +       if (pp->p.order !=3D 0)
> +               return -EINVAL;
> +       if (!pp->p.napi)
> +               return -EINVAL;
> +
> +       io_zc_rx_init_pool(ifq->pool, pp);
> +       percpu_ref_get(&ifq->ctx->refs);
> +       ifq->pp =3D pp;
> +       return 0;
> +}
> +
> +static void io_pp_zc_destroy(struct page_pool *pp)
> +{
> +       struct io_zc_rx_ifq *ifq =3D pp->mp_priv;
> +       struct io_zc_rx_pool *pool =3D ifq->pool;
> +
> +       ifq->pp =3D NULL;
> +
> +       if (WARN_ON_ONCE(pool->free_count !=3D pool->nr_bufs))
> +               return;
> +       percpu_ref_put(&ifq->ctx->refs);
> +}
> +
> +const struct pp_memory_provider_ops io_uring_pp_zc_ops =3D {
> +       .alloc_pages            =3D io_pp_zc_alloc_pages,
> +       .release_page           =3D io_pp_zc_release_page,
> +       .init                   =3D io_pp_zc_init,
> +       .destroy                =3D io_pp_zc_destroy,
> +       .scrub                  =3D io_pp_zc_scrub,
> +};
> +EXPORT_SYMBOL(io_uring_pp_zc_ops);
> +
> +
>  #endif
> diff --git a/io_uring/zc_rx.h b/io_uring/zc_rx.h
> index af1d865525d2..00d864700c67 100644
> --- a/io_uring/zc_rx.h
> +++ b/io_uring/zc_rx.h
> @@ -10,6 +10,9 @@
>  #define IO_ZC_IFQ_IDX_OFFSET           16
>  #define IO_ZC_IFQ_IDX_MASK             ((1U << IO_ZC_IFQ_IDX_OFFSET) - 1=
)
>
> +#define IO_ZC_RX_UREF                  0x10000
> +#define IO_ZC_RX_KREF_MASK             (IO_ZC_RX_UREF - 1)
> +
>  struct io_zc_rx_pool {
>         struct io_zc_rx_ifq     *ifq;
>         struct io_zc_rx_buf     *bufs;
> @@ -26,12 +29,15 @@ struct io_zc_rx_ifq {
>         struct io_ring_ctx              *ctx;
>         struct net_device               *dev;
>         struct io_zc_rx_pool            *pool;
> +       struct page_pool                *pp;
>
>         struct io_rbuf_ring             *ring;
>         struct io_uring_rbuf_rqe        *rqes;
>         struct io_uring_rbuf_cqe        *cqes;
>         u32                             rq_entries;
>         u32                             cq_entries;
> +       u32                             cached_rq_head;
> +       u32                             cached_cq_tail;
>
>         /* hw rx descriptor ring id */
>         u32                             if_rxq_id;
> --
> 2.39.3
>


--=20
Thanks,
Mina

