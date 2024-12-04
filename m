Return-Path: <io-uring+bounces-5224-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E6359E446C
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 20:18:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 229F5BE0CB6
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 624A6215F64;
	Wed,  4 Dec 2024 17:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="kQtfq0L9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB0E9215F4C
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332978; cv=none; b=g9+l6CZvqhnNnutsI4YMdk5QjnyDfawdp2nZUEgeQrE3OLYtr6PUt3Kxi4DHtdM4ltdJe30GHpPcGy8vpYUwkpPleRoDwkOwkvu+UUG66ScizWdx5ojlzqIuiewsIawW/HaWCgfqzLHgH241g0/OMBq/ZcVlh5Vw1OWTYkxoZBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332978; c=relaxed/simple;
	bh=7AS+9tBSgI7VlYar3ZmBNBANXy1BPT0oGmeQWHLrQmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVzwXmDmh4Tjh4FSQ3JuIUz+qLFyhvgo+yhwL6lJrBbHbRqofMf3BH2dlZWwYnxzwKZvge0ffx5l5wR0lHneQrHJS5UEn+SkmcQpi54JurKs7qEtE76xQEtO3GuvXkpmvSFGCTnqwQBRf+YHH4rjDtWFuuWqDjQKVe3uPuLSZSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=kQtfq0L9; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-725935d001cso47459b3a.2
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733332976; x=1733937776; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vFNGCB1W1eYtsSjdWKUaYilBUOhH2kRp5MrbYu76ozo=;
        b=kQtfq0L9rd6+Fgo0Jn2rmu60NX3VdlKxhB1TCwJ2sBnBoiOv9ue8Pb8oBh4gu/gJJo
         LfXz/SFPE9UghFwmrtjTL7IFP15yJQI+FmyH/nrPGT5hpnG7wVcA+DIWc40MZAvwAWnJ
         IabKYpLxA0gO96FHYAAOYsJ+QL782lVlezucAH4NHqJeAxk6x8DpLwEQ3gcxLDX8U7My
         zbANi0PMXAD6DUmB6NY6cyP1rHj33RWQA0QGYD3AlX1ejissAgtVZKqz+KtgVkhJmF0P
         BeeQgVmmgnFPmIKVnh93+22rbW8Sq2Zx36rhmNh2dfCzRI6NTSSWN6omGSjxVKMYUX47
         7+HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332976; x=1733937776;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vFNGCB1W1eYtsSjdWKUaYilBUOhH2kRp5MrbYu76ozo=;
        b=Lep77yHbNsNhB0HvOcfcUK+cnygVv7CUFMgdiWydsvZFPKc9WIyCm2CXpC6huWY8uD
         pAoo/2C50ETUUr9I8++7gQXUFZUge/43qHa6JfZsasDmABEKtYFHP4IVCO8fKKIWr0Xe
         P7qSa2STMcJHDWdyjrXjwM0oEoNyQwf8dhrXsWxabEgYQLgteSUAjYnBB7MFem5/b1qy
         JO59v/mrIQAtX7zGKT+sg/Elai6dT6Tl805JLRFusn9h/RqLnntCEV4umDwetjsvoZlx
         GgvU28u2wiH/9eEoVKsWNRquDscQVpOgsj3nyxUzmDuJRhoZe4Q604e2/NySqHaJW9SO
         anRQ==
X-Gm-Message-State: AOJu0Yz3I8vWqz4PQ3b8tAixp3KQBWsK0tbF5YOmPmyBw1SycPL7CZkB
	VuhAYcwnqFUwaGQPTJp20sJsD2ueuOD3kn4UiFPFlNcBdMT0eQutJ9hbu2j6W4jQ6IqImhJ2PTt
	2
X-Gm-Gg: ASbGncuDdXL3/gnqXKZMV1LATT6yxBEZZDKQx4T2dphdqUg6pDckVi3Pi2+z87fvpZV
	ROMoG9srccMPUSiUUxBVEfgOHQTSDdu7nxUvIJ1uat3PVI3+DGJZeVPIOy90v1LwzrHsgZ2IfqV
	ZNvE6s8XOLs7nCJ5tWRfyu6/5m3ysWl5wi3rFWS/Edoy/y+B2u9HMgptLU0kjYpKQ5B/3M1C36u
	QHi+a2yXYcOfaHifCdlFa+dg9rg5Rd49TU=
X-Google-Smtp-Source: AGHT+IHXMTCe9fSw087F9KP0KOqX3ZWi1P+qCuGplly4whE2VZQOUGlCdN1Pc1/M3OWxIUx0yDY52Q==
X-Received: by 2002:a17:902:cf0c:b0:215:8809:b3b7 with SMTP id d9443c01a7336-215bcfc4d64mr94562985ad.7.1733332976086;
        Wed, 04 Dec 2024 09:22:56 -0800 (PST)
Received: from localhost ([2a03:2880:ff:1b::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21521905f2bsm115331265ad.93.2024.12.04.09.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 09:22:55 -0800 (PST)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH net-next v8 11/17] io_uring/zcrx: implement zerocopy receive pp memory provider
Date: Wed,  4 Dec 2024 09:21:50 -0800
Message-ID: <20241204172204.4180482-12-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241204172204.4180482-1-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Implement a page pool memory provider for io_uring to receieve in a
zero copy fashion. For that, the provider allocates user pages wrapped
around into struct net_iovs, that are stored in a previously registered
struct net_iov_area.

Unlike with traditional receives, for which pages from a page pool can
be deallocated right after the user receives data, e.g. via recv(2),
we extend the lifetime by recycling buffers only after the user space
acknowledges that it's done processing the data via the refill queue.
Before handing buffers to the user, we mark them by bumping the refcount
by a bias value IO_ZC_RX_UREF, which will be checked when the buffer is
returned back. When the corresponding io_uring instance and/or page pool
are destroyed, we'll force back all buffers that are currently in the
user space in ->io_pp_zc_scrub by clearing the bias.

Refcounting and lifetime:

Initially, all buffers are considered unallocated and stored in
->freelist, at which point they are not yet directly exposed to the core
page pool code and not accounted to page pool's pages_state_hold_cnt.
The ->alloc_netmems callback will allocate them by placing into the
page pool's cache, setting the refcount to 1 as usual and adjusting
pages_state_hold_cnt.

Then, either the buffer is dropped and returns back to the page pool
into the ->freelist via io_pp_zc_release_netmem, in which case the page
pool will match hold_cnt for us with ->pages_state_release_cnt. Or more
likely the buffer will go through the network/protocol stacks and end up
in the corresponding socket's receive queue. From there the user can get
it via an new io_uring request implemented in following patches. As
mentioned above, before giving a buffer to the user we bump the refcount
by IO_ZC_RX_UREF.

Once the user is done with the buffer processing, it must return it back
via the refill queue, from where our ->alloc_netmems implementation can
grab it, check references, put IO_ZC_RX_UREF, and recycle the buffer if
there are no more users left. As we place such buffers right back into
the page pools fast cache and they didn't go through the normal pp
release path, they are still considered "allocated" and no pp hold_cnt
is required. For the same reason we dma sync buffers for the device
in io_zc_add_pp_cache().

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 215 ++++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/zcrx.h |   5 ++
 2 files changed, 220 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 8f838add94a4..7919f5e52c73 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -2,7 +2,12 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/nospec.h>
+#include <linux/netdevice.h>
 #include <linux/io_uring.h>
+#include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
+#include <trace/events/page_pool.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -14,6 +19,16 @@
 
 #define IO_RQ_MAX_ENTRIES		32768
 
+__maybe_unused
+static const struct memory_provider_ops io_uring_pp_zc_ops;
+
+static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
+{
+	struct net_iov_area *owner = net_iov_owner(niov);
+
+	return container_of(owner, struct io_zcrx_area, nia);
+}
+
 static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg,
 				 struct io_uring_region_desc *rd)
@@ -104,6 +119,9 @@ static int io_zcrx_create_area(struct io_ring_ctx *ctx,
 		goto err;
 
 	for (i = 0; i < nr_pages; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+
+		niov->owner = &area->nia;
 		area->freelist[i] = i;
 	}
 
@@ -238,3 +256,200 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	lockdep_assert_held(&ctx->uring_lock);
 }
+
+static bool io_zcrx_niov_put(struct net_iov *niov, int nr)
+{
+	return atomic_long_sub_and_test(nr, &niov->pp_ref_count);
+}
+
+static bool io_zcrx_put_niov_uref(struct net_iov *niov)
+{
+	if (atomic_long_read(&niov->pp_ref_count) < IO_ZC_RX_UREF)
+		return false;
+
+	return io_zcrx_niov_put(niov, IO_ZC_RX_UREF);
+}
+
+static inline void io_zc_add_pp_cache(struct page_pool *pp,
+				      struct net_iov *niov)
+{
+}
+
+static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)
+{
+	u32 entries;
+
+	entries = smp_load_acquire(&ifq->rq_ring->tail) - ifq->cached_rq_head;
+	return min(entries, ifq->rq_entries);
+}
+
+static struct io_uring_zcrx_rqe *io_zcrx_get_rqe(struct io_zcrx_ifq *ifq,
+						 unsigned mask)
+{
+	unsigned int idx = ifq->cached_rq_head++ & mask;
+
+	return &ifq->rqes[idx];
+}
+
+static void io_zcrx_ring_refill(struct page_pool *pp,
+				struct io_zcrx_ifq *ifq)
+{
+	unsigned int entries = io_zcrx_rqring_entries(ifq);
+	unsigned int mask = ifq->rq_entries - 1;
+
+	entries = min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL - pp->alloc.count);
+	if (unlikely(!entries))
+		return;
+
+	do {
+		struct io_uring_zcrx_rqe *rqe = io_zcrx_get_rqe(ifq, mask);
+		struct io_zcrx_area *area;
+		struct net_iov *niov;
+		unsigned niov_idx, area_idx;
+
+		area_idx = rqe->off >> IORING_ZCRX_AREA_SHIFT;
+		niov_idx = (rqe->off & ~IORING_ZCRX_AREA_MASK) / PAGE_SIZE;
+
+		if (unlikely(rqe->__pad || area_idx))
+			continue;
+		area = ifq->area;
+
+		if (unlikely(niov_idx >= area->nia.num_niovs))
+			continue;
+		niov_idx = array_index_nospec(niov_idx, area->nia.num_niovs);
+
+		niov = &area->nia.niovs[niov_idx];
+		if (!io_zcrx_put_niov_uref(niov))
+			continue;
+		page_pool_mp_return_in_cache(pp, net_iov_to_netmem(niov));
+	} while (--entries);
+
+	smp_store_release(&ifq->rq_ring->head, ifq->cached_rq_head);
+}
+
+static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
+{
+	struct io_zcrx_area *area = ifq->area;
+
+	spin_lock_bh(&area->freelist_lock);
+	while (area->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
+		struct net_iov *niov;
+		u32 pgid;
+
+		pgid = area->freelist[--area->free_count];
+		niov = &area->nia.niovs[pgid];
+
+		page_pool_mp_return_in_cache(pp, net_iov_to_netmem(niov));
+
+		pp->pages_state_hold_cnt++;
+		trace_page_pool_state_hold(pp, net_iov_to_netmem(niov),
+					   pp->pages_state_hold_cnt);
+	}
+	spin_unlock_bh(&area->freelist_lock);
+}
+
+static void io_zcrx_recycle_niov(struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	spin_lock_bh(&area->freelist_lock);
+	area->freelist[area->free_count++] = net_iov_idx(niov);
+	spin_unlock_bh(&area->freelist_lock);
+}
+
+static netmem_ref io_pp_zc_alloc_netmems(struct page_pool *pp, gfp_t gfp)
+{
+	struct io_zcrx_ifq *ifq = pp->mp_priv;
+
+	/* pp should already be ensuring that */
+	if (unlikely(pp->alloc.count))
+		goto out_return;
+
+	io_zcrx_ring_refill(pp, ifq);
+	if (likely(pp->alloc.count))
+		goto out_return;
+
+	io_zcrx_refill_slow(pp, ifq);
+	if (!pp->alloc.count)
+		return 0;
+out_return:
+	return pp->alloc.cache[--pp->alloc.count];
+}
+
+static bool io_pp_zc_release_netmem(struct page_pool *pp, netmem_ref netmem)
+{
+	struct net_iov *niov;
+
+	if (WARN_ON_ONCE(!netmem_is_net_iov(netmem)))
+		return false;
+
+	niov = netmem_to_net_iov(netmem);
+
+	if (io_zcrx_niov_put(niov, 1))
+		io_zcrx_recycle_niov(niov);
+	return false;
+}
+
+static void io_pp_zc_scrub(struct page_pool *pp)
+{
+	struct io_zcrx_ifq *ifq = pp->mp_priv;
+	struct io_zcrx_area *area = ifq->area;
+	int i;
+
+	/* Reclaim back all buffers given to the user space. */
+	for (i = 0; i < area->nia.num_niovs; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+		int count;
+
+		if (!io_zcrx_put_niov_uref(niov))
+			continue;
+		io_zcrx_recycle_niov(niov);
+
+		count = atomic_inc_return_relaxed(&pp->pages_state_release_cnt);
+		trace_page_pool_state_release(pp, net_iov_to_netmem(niov), count);
+	}
+}
+
+static int io_pp_zc_init(struct page_pool *pp)
+{
+	struct io_zcrx_ifq *ifq = pp->mp_priv;
+	struct io_zcrx_area *area = ifq->area;
+	int ret;
+
+	if (!ifq)
+		return -EINVAL;
+	if (pp->p.order != 0)
+		return -EINVAL;
+	if (!pp->p.napi)
+		return -EINVAL;
+
+	ret = page_pool_mp_init_paged_area(pp, &area->nia, area->pages);
+	if (ret)
+		return ret;
+
+	percpu_ref_get(&ifq->ctx->refs);
+	ifq->pp = pp;
+	return 0;
+}
+
+static void io_pp_zc_destroy(struct page_pool *pp)
+{
+	struct io_zcrx_ifq *ifq = pp->mp_priv;
+	struct io_zcrx_area *area = ifq->area;
+
+	page_pool_mp_release_area(pp, &ifq->area->nia);
+
+	ifq->pp = NULL;
+
+	if (WARN_ON_ONCE(area->free_count != area->nia.num_niovs))
+		return;
+	percpu_ref_put(&ifq->ctx->refs);
+}
+
+static const struct memory_provider_ops io_uring_pp_zc_ops = {
+	.alloc_netmems		= io_pp_zc_alloc_netmems,
+	.release_netmem		= io_pp_zc_release_netmem,
+	.init			= io_pp_zc_init,
+	.destroy		= io_pp_zc_destroy,
+	.scrub			= io_pp_zc_scrub,
+};
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 07742c0cfcf3..8515cde78a2c 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -5,6 +5,9 @@
 #include <linux/io_uring_types.h>
 #include <net/page_pool/types.h>
 
+#define IO_ZC_RX_UREF			0x10000
+#define IO_ZC_RX_KREF_MASK		(IO_ZC_RX_UREF - 1)
+
 struct io_zcrx_area {
 	struct net_iov_area	nia;
 	struct io_zcrx_ifq	*ifq;
@@ -22,10 +25,12 @@ struct io_zcrx_ifq {
 	struct io_ring_ctx		*ctx;
 	struct net_device		*dev;
 	struct io_zcrx_area		*area;
+	struct page_pool		*pp;
 
 	struct io_uring			*rq_ring;
 	struct io_uring_zcrx_rqe 	*rqes;
 	u32				rq_entries;
+	u32				cached_rq_head;
 
 	u32				if_rxq;
 
-- 
2.43.5


