Return-Path: <io-uring+bounces-327-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2B24A8195D4
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 01:45:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EAC04B2227C
	for <lists+io-uring@lfdr.de>; Wed, 20 Dec 2023 00:45:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A6081C26;
	Wed, 20 Dec 2023 00:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="T5wzHn7q"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C7823B4;
	Wed, 20 Dec 2023 00:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-54ba86ae133so4649857a12.2;
        Tue, 19 Dec 2023 16:44:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703033092; x=1703637892; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lgan2V7aoiXDzvZ0FwaWQZrEqU73V1JxdP21e0WlPcM=;
        b=T5wzHn7qw9FNRZH2u8Zh9H2UDVZst71PPkZvkzVpk7qwrHwrqF2SikOgm6eKrXDDr1
         +nEE9HvKFFmWu12xWtwVFP+se/luh6mw/2fF2FImTCyBIzWFrV1P1zvf1VaUxQ6Udq+H
         eForfg77I7QFsBDWrZQYKV8XJRnq6muUCMM+7HCofj3GCQHgAEz0PWaGHrGwHmfUGhl6
         2Bsa7UcsOh93e6fwRaVfF+ZxwEu3HYFdlnE/kFR2DUw8DcDj0Jhh3wH5L9gVTjVW5AFo
         DVfMFWg6Tv0uZYneKg+O3XffoZHuWowrOaNAtkT+mrcnMwui82L2AyxngFY35mo1tYdv
         z68w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703033092; x=1703637892;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lgan2V7aoiXDzvZ0FwaWQZrEqU73V1JxdP21e0WlPcM=;
        b=RCIV2jrP0v9ShV1XX7xog629Bx5hlCqOOBqZzxQwwCyH86AbOgaGXkVgQbyL6m7PSt
         ic2n0S/8lfkHQwbOhnIHDoNWT7wo3x3SGgtBrSjYOYzHF142nwrzFUuxks3SzJifi109
         aoOXVvE+RIgAa7ZNksXNnC1OBpgNAs9brH/PHnSCCzVfaSMs8PJ2hyTYJ5FebqhWvaBD
         VS8NExH6qoAJcagGolhNRQoFwwz3zmbXNGpkEM23oj1VmRU4T5nfaq8dsU4KzwZSG0QZ
         rxxdhUL8VoRF16PNBJGyBl0OC9NzDC+R2j/suIhunrQmuyN+qWMt0oSrl4oNNcfP69e4
         sd5A==
X-Gm-Message-State: AOJu0YzVgMcm31yiKxsx3cYK/mAkyC3k2wuT9nWyJKdBEsPSANnP+TkL
	oH8JHYEkXVRT3XIy+KWRtNs=
X-Google-Smtp-Source: AGHT+IHOh6SEWTSLDqCmPjxK7HgJDioig/wy7NQYhcLQzVf/LPC4mj0hLVV+2FkVc7pH8xb8V7aDpA==
X-Received: by 2002:a50:99c4:0:b0:552:2852:cb1 with SMTP id n4-20020a5099c4000000b0055228520cb1mr6360314edb.47.1703033092160;
        Tue, 19 Dec 2023 16:44:52 -0800 (PST)
Received: from [192.168.8.100] ([85.255.233.166])
        by smtp.gmail.com with ESMTPSA id ds12-20020a0564021ccc00b00552a6a19ed0sm5192638edb.9.2023.12.19.16.44.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Dec 2023 16:44:51 -0800 (PST)
Message-ID: <40c25c71-2db9-4f2e-87e1-6108db0c0b69@gmail.com>
Date: Wed, 20 Dec 2023 00:39:47 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 13/20] io_uring: implement pp memory provider for
 zc rx
Content-Language: en-US
To: Mina Almasry <almasrymina@google.com>, David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-14-dw@davidwei.uk>
 <CAHS8izPHG5=z_x1RF3vht9bvPMG2hJ9-aTGqD3mzHwDSKHwi0g@mail.gmail.com>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHS8izPHG5=z_x1RF3vht9bvPMG2hJ9-aTGqD3mzHwDSKHwi0g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/19/23 23:44, Mina Almasry wrote:
> On Tue, Dec 19, 2023 at 1:04 PM David Wei <dw@davidwei.uk> wrote:
>>
>> From: Pavel Begunkov <asml.silence@gmail.com>
>>
>> We're adding a new pp memory provider to implement io_uring zerocopy
>> receive. It'll be "registered" in pp and used in later paches.
>>
>> The typical life cycle of a buffer goes as follows: first it's allocated
>> to a driver with the initial refcount set to 1. The drivers fills it
>> with data, puts it into an skb and passes down the stack, where it gets
>> queued up to a socket. Later, a zc io_uring request will be receiving
>> data from the socket from a task context. At that point io_uring will
>> tell the userspace that this buffer has some data by posting an
>> appropriate completion. It'll also elevating the refcount by
>> IO_ZC_RX_UREF, so the buffer is not recycled while userspace is reading
> 
> After you rebase to the latest RFC, you will want to elevante the
> [pp|n]iov->pp_ref_count, rather than the non-existent ppiov->refcount.
> I do the same thing for devmem TCP.
> 
>> the data. When the userspace is done with the buffer it should return it
>> back to io_uring by adding an entry to the buffer refill ring. When
>> necessary io_uring will poll the refill ring, compare references
>> including IO_ZC_RX_UREF and reuse the buffer.
>>
>> Initally, all buffers are placed in a spinlock protected ->freelist.
>> It's a slow path stash, where buffers are considered to be unallocated
>> and not exposed to core page pool. On allocation, pp will first try
>> all its caches, and the ->alloc_pages callback if everything else
>> failed.
>>
>> The hot path for io_pp_zc_alloc_pages() is to grab pages from the refill
>> ring. The consumption from the ring is always done in the attached napi
>> context, so no additional synchronisation required. If that fails we'll
>> be getting buffers from the ->freelist.
>>
>> Note: only ->freelist are considered unallocated for page pool, so we
>> only add pages_state_hold_cnt when allocating from there. Subsequently,
>> as page_pool_return_page() and others bump the ->pages_state_release_cnt
>> counter, io_pp_zc_release_page() can only use ->freelist, which is not a
>> problem as it's not a slow path.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> Signed-off-by: David Wei <dw@davidwei.uk>
>> ---
>>   include/linux/io_uring/net.h |   5 +
>>   io_uring/zc_rx.c             | 204 +++++++++++++++++++++++++++++++++++
>>   io_uring/zc_rx.h             |   6 ++
>>   3 files changed, 215 insertions(+)
>>
>> diff --git a/include/linux/io_uring/net.h b/include/linux/io_uring/net.h
>> index d994d26116d0..13244ae5fc4a 100644
>> --- a/include/linux/io_uring/net.h
>> +++ b/include/linux/io_uring/net.h
>> @@ -13,6 +13,11 @@ struct io_zc_rx_buf {
>>   };
>>
>>   #if defined(CONFIG_IO_URING)
>> +
>> +#if defined(CONFIG_PAGE_POOL)
>> +extern const struct pp_memory_provider_ops io_uring_pp_zc_ops;
>> +#endif
>> +
>>   int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
>>
>>   #else
>> diff --git a/io_uring/zc_rx.c b/io_uring/zc_rx.c
>> index 1e656b481725..ff1dac24ac40 100644
>> --- a/io_uring/zc_rx.c
>> +++ b/io_uring/zc_rx.c
>> @@ -6,6 +6,7 @@
>>   #include <linux/io_uring.h>
>>   #include <linux/netdevice.h>
>>   #include <linux/nospec.h>
>> +#include <trace/events/page_pool.h>
>>
>>   #include <uapi/linux/io_uring.h>
>>
>> @@ -387,4 +388,207 @@ int io_register_zc_rx_sock(struct io_ring_ctx *ctx,
>>          return 0;
>>   }
>>
>> +static inline struct io_zc_rx_buf *io_iov_to_buf(struct page_pool_iov *iov)
>> +{
>> +       return container_of(iov, struct io_zc_rx_buf, ppiov);
>> +}
>> +
>> +static inline unsigned io_buf_pgid(struct io_zc_rx_pool *pool,
>> +                                  struct io_zc_rx_buf *buf)
>> +{
>> +       return buf - pool->bufs;
>> +}
>> +
>> +static __maybe_unused void io_zc_rx_get_buf_uref(struct io_zc_rx_buf *buf)
>> +{
>> +       refcount_add(IO_ZC_RX_UREF, &buf->ppiov.refcount);
>> +}
>> +
>> +static bool io_zc_rx_put_buf_uref(struct io_zc_rx_buf *buf)
>> +{
>> +       if (page_pool_iov_refcount(&buf->ppiov) < IO_ZC_RX_UREF)
>> +               return false;
>> +
>> +       return page_pool_iov_sub_and_test(&buf->ppiov, IO_ZC_RX_UREF);
>> +}
>> +
>> +static inline struct page *io_zc_buf_to_pp_page(struct io_zc_rx_buf *buf)
>> +{
>> +       return page_pool_mangle_ppiov(&buf->ppiov);
>> +}
>> +
>> +static inline void io_zc_add_pp_cache(struct page_pool *pp,
>> +                                     struct io_zc_rx_buf *buf)
>> +{
>> +       refcount_set(&buf->ppiov.refcount, 1);
>> +       pp->alloc.cache[pp->alloc.count++] = io_zc_buf_to_pp_page(buf);
>> +}
>> +
>> +static inline u32 io_zc_rx_rqring_entries(struct io_zc_rx_ifq *ifq)
>> +{
>> +       struct io_rbuf_ring *ring = ifq->ring;
>> +       u32 entries;
>> +
>> +       entries = smp_load_acquire(&ring->rq.tail) - ifq->cached_rq_head;
>> +       return min(entries, ifq->rq_entries);
>> +}
>> +
>> +static void io_zc_rx_ring_refill(struct page_pool *pp,
>> +                                struct io_zc_rx_ifq *ifq)
>> +{
>> +       unsigned int entries = io_zc_rx_rqring_entries(ifq);
>> +       unsigned int mask = ifq->rq_entries - 1;
>> +       struct io_zc_rx_pool *pool = ifq->pool;
>> +
>> +       if (unlikely(!entries))
>> +               return;
>> +
>> +       while (entries--) {
>> +               unsigned int rq_idx = ifq->cached_rq_head++ & mask;
>> +               struct io_uring_rbuf_rqe *rqe = &ifq->rqes[rq_idx];
>> +               u32 pgid = rqe->off / PAGE_SIZE;
>> +               struct io_zc_rx_buf *buf = &pool->bufs[pgid];
>> +
>> +               if (!io_zc_rx_put_buf_uref(buf))
>> +                       continue;
>> +               io_zc_add_pp_cache(pp, buf);
>> +               if (pp->alloc.count >= PP_ALLOC_CACHE_REFILL)
>> +                       break;
>> +       }
>> +       smp_store_release(&ifq->ring->rq.head, ifq->cached_rq_head);
>> +}
>> +
>> +static void io_zc_rx_refill_slow(struct page_pool *pp, struct io_zc_rx_ifq *ifq)
>> +{
>> +       struct io_zc_rx_pool *pool = ifq->pool;
>> +
>> +       spin_lock_bh(&pool->freelist_lock);
>> +       while (pool->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
>> +               struct io_zc_rx_buf *buf;
>> +               u32 pgid;
>> +
>> +               pgid = pool->freelist[--pool->free_count];
>> +               buf = &pool->bufs[pgid];
>> +
>> +               io_zc_add_pp_cache(pp, buf);
>> +               pp->pages_state_hold_cnt++;
>> +               trace_page_pool_state_hold(pp, io_zc_buf_to_pp_page(buf),
>> +                                          pp->pages_state_hold_cnt);
>> +       }
>> +       spin_unlock_bh(&pool->freelist_lock);
>> +}
>> +
>> +static void io_zc_rx_recycle_buf(struct io_zc_rx_pool *pool,
>> +                                struct io_zc_rx_buf *buf)
>> +{
>> +       spin_lock_bh(&pool->freelist_lock);
>> +       pool->freelist[pool->free_count++] = io_buf_pgid(pool, buf);
>> +       spin_unlock_bh(&pool->freelist_lock);
>> +}
>> +
>> +static struct page *io_pp_zc_alloc_pages(struct page_pool *pp, gfp_t gfp)
>> +{
>> +       struct io_zc_rx_ifq *ifq = pp->mp_priv;
>> +
>> +       /* pp should already be ensuring that */
>> +       if (unlikely(pp->alloc.count))
>> +               goto out_return;
>> +
>> +       io_zc_rx_ring_refill(pp, ifq);
>> +       if (likely(pp->alloc.count))
>> +               goto out_return;
>> +
>> +       io_zc_rx_refill_slow(pp, ifq);
>> +       if (!pp->alloc.count)
>> +               return NULL;
>> +out_return:
>> +       return pp->alloc.cache[--pp->alloc.count];
>> +}
>> +
>> +static bool io_pp_zc_release_page(struct page_pool *pp, struct page *page)
>> +{
>> +       struct io_zc_rx_ifq *ifq = pp->mp_priv;
>> +       struct page_pool_iov *ppiov;
>> +
>> +       if (WARN_ON_ONCE(!page_is_page_pool_iov(page)))
>> +               return false;
>> +
>> +       ppiov = page_to_page_pool_iov(page);
>> +
>> +       if (!page_pool_iov_sub_and_test(ppiov, 1))
>> +               return false;
>> +
>> +       io_zc_rx_recycle_buf(ifq->pool, io_iov_to_buf(ppiov));
>> +       return true;
>> +}
>> +
>> +static void io_pp_zc_scrub(struct page_pool *pp)
>> +{
>> +       struct io_zc_rx_ifq *ifq = pp->mp_priv;
>> +       struct io_zc_rx_pool *pool = ifq->pool;
>> +       struct io_zc_rx_buf *buf;
>> +       int i;
>> +
>> +       for (i = 0; i < pool->nr_bufs; i++) {
>> +               buf = &pool->bufs[i];
>> +
>> +               if (io_zc_rx_put_buf_uref(buf)) {
>> +                       /* just return it to the page pool, it'll clean it up */
>> +                       refcount_set(&buf->ppiov.refcount, 1);
>> +                       page_pool_iov_put_many(&buf->ppiov, 1);
>> +               }
>> +       }
>> +}
>> +
> 
> I'm unsure about this. So scrub forcibly frees the pending data? Why
> does this work? Can't the application want to read this data even
> though the page_pool is destroyed?

It only affects buffers that were given back to the userspace
and are still there. Even if it scrubs like that, the completions are
still visible to the user, there are pointing to correct buffers,
which are still supposed to be mapped well. Yes, we return them earlier
to the kernel, but since reallocation should not be possible at that
point the data in the buffers would stay correct. There might be
problems with copy fallback, but it'll need to improve anyway,
I'm keeping an eye on it

In any case, I'd say if page pool is destroyed while we're still
using it, I'd say something is going really wrong and the user should
terminate all of it, but that raises a question in what valid cases
the kernel might decide to reallocate pp (device reconfiguration),
and what the application is supposed to do about it.


> AFAIK the page_pool being destroyed doesn't mean we can free the
> pages/niovs in it. The niovs that were in it can be waiting on the
> receive queue for the application to call recvmsg() on it. Does
> io_uring work differently such that you're able to force-free the
> ppiovs/niovs?

If a buffer is used by the stack, the stack will hold a reference.
We're not just blindly freeing them here, only dropping the userspace
reference. An analogy for devmem would to remove all involved buffers
from dont_need xarrays (also dropping a reference IIRC).

-- 
Pavel Begunkov

