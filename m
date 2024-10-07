Return-Path: <io-uring+bounces-3453-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7DE84993A04
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:17:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 31B8028584A
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:17:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93E1818CC17;
	Mon,  7 Oct 2024 22:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="z7jpZelP"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DD719340A
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339403; cv=none; b=gMGOxxjBmfn72dX6lF2sTf4FOK1u9NYsaj/BQn4RXAXr/uMPqABN06yZ9QdiKjRSr49VI+KFCpm1zdrW6PZxSzTqd80WhZgNWlwH6MvFKWsVPon24lVR4ZuGxAVxHf/LV39HnXDy3b6P5UWMsnzv5c/vv9QyhV3tQgHsEsp8L80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339403; c=relaxed/simple;
	bh=ylDZLEz8geNgtOLThiFGfRQCFI9rwkwD2KrflKGTq5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kq2Zxf6rczqwiCpA3e7Bb0p3Gzxz22G0CyUzkwbrJYZKlcbp9qml0UJiy+ECPI9pcUpeB8gxkOmzJqX4DWKosrJhWr8DM4x+BBKzVY2vncZRijLZ5c6P0NneHveOBZBPII8ECvRMNBFNIZz5D0iDztxsedBHPi0Taxax49+knT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=z7jpZelP; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-20b64584fd4so46960725ad.1
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339401; x=1728944201; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tQt2snHeeCUl2wmuoSme0YVWbdUzaN506EVWMGFosjk=;
        b=z7jpZelPEy03YeI2RZJRd6qcF7FcyvKXuwPzeatfbiavX9PVeWbcxo5GmNhxuZzqqY
         Rz+dD4M87/Hcq2mDfQsYY5SFtH/X+PRezrKFwg8X7agc8EIcpnIb7XdeYxUZq1QMuAG2
         FRKAMybapMKm0H9+Qf0UV3RwhtjmxAxmRK7r4n0Q1JBM5rItYXY5LJ/glY04h9frXkJm
         w95bVtL5jt1CYDLV8X6xMiJtvCndcUb9sNOj6iq5hPowGT/wlVTh8xbcRKfK/uYWbBl8
         dWpDIL9r04SHLBej1NJob4eQT5iepndgR6sHgyoroGG4sQWslXzLZ94mFxchcUfmsqT/
         WbwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339401; x=1728944201;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tQt2snHeeCUl2wmuoSme0YVWbdUzaN506EVWMGFosjk=;
        b=AVZc7FVLMHXMaWQkHQ6Dag3pV0Kp9XYDtL/n3xK6sq7pLG+LmUsa9NgI8dq2pFPCSB
         oO/wh2blPGy/tbmJVgZPVe4EJzBzdPObWv4EtywrxUYeJZ3gJ4NW1ETeb2D9+KIqVy+N
         sHqkqCx5i4q0m2VULd1J+AOm7IpDfabkiKieKLsELiVmvdt60uJUKCSKRELIO/QoED3E
         LsCkuwfTObOXPAdqf6i7Qz5V2nDfDtMbk9ZFMdniIDB0Dy3LrsaGK31nmNSm2yhGFMY/
         n0QBSh0cbt7xIADIHvA3SMQJlD9/WrWMvWgAQ2c7RM6Lg75gvFUPjoCC08LDPQfk/MAC
         aM3g==
X-Gm-Message-State: AOJu0Yyq6wejDf/+336IeUE2RU0YI1XVOcGOao3R1QnCv2Xh14DJFg8t
	K9lr6ok77HCKf5QiA024ysCshbUJxasVtUhrz4J2nGYMz3FChpkmRaxSKEr0JJHNmcs5jmCEElB
	d
X-Google-Smtp-Source: AGHT+IFoaIh1llAgQrmo/PzVebBGvOzgjnBwWIYt06hJ4MGa6qg+e/TY3zmCQmbl8EIBVbLnZBEGRQ==
X-Received: by 2002:a17:902:e745:b0:20b:c1e4:2d70 with SMTP id d9443c01a7336-20bfe294c52mr204002135ad.23.1728339401120;
        Mon, 07 Oct 2024 15:16:41 -0700 (PDT)
Received: from localhost (fwdproxy-prn-054.fbsv.net. [2a03:2880:ff:36::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20c1398b868sm44342415ad.244.2024.10.07.15.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:40 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: David Wei <dw@davidwei.uk>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>
Subject: [PATCH v1 11/15] io_uring/zcrx: implement zerocopy receive pp memory provider
Date: Mon,  7 Oct 2024 15:15:59 -0700
Message-ID: <20241007221603.1703699-12-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241007221603.1703699-1-dw@davidwei.uk>
References: <20241007221603.1703699-1-dw@davidwei.uk>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/linux/io_uring/net.h |   5 +
 io_uring/zcrx.c              | 229 +++++++++++++++++++++++++++++++++++
 io_uring/zcrx.h              |   6 +
 3 files changed, 240 insertions(+)

diff --git a/include/linux/io_uring/net.h b/include/linux/io_uring/net.h
index b58f39fed4d5..610b35b451fd 100644
--- a/include/linux/io_uring/net.h
+++ b/include/linux/io_uring/net.h
@@ -5,6 +5,11 @@
 struct io_uring_cmd;
 
 #if defined(CONFIG_IO_URING)
+
+#if defined(CONFIG_PAGE_POOL)
+extern const struct memory_provider_ops io_uring_pp_zc_ops;
+#endif
+
 int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags);
 
 #else
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 8382129402ac..6cd3dee8b90a 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -2,7 +2,11 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/nospec.h>
+#include <linux/netdevice.h>
 #include <linux/io_uring.h>
+#include <net/page_pool/helpers.h>
+#include <trace/events/page_pool.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -16,6 +20,13 @@
 
 #if defined(CONFIG_PAGE_POOL) && defined(CONFIG_INET)
 
+static inline struct io_zcrx_area *io_zcrx_iov_to_area(const struct net_iov *niov)
+{
+	struct net_iov_area *owner = net_iov_owner(niov);
+
+	return container_of(owner, struct io_zcrx_area, nia);
+}
+
 static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg)
 {
@@ -101,6 +112,9 @@ static int io_zcrx_create_area(struct io_ring_ctx *ctx,
 		goto err;
 
 	for (i = 0; i < nr_pages; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+
+		niov->owner = &area->nia;
 		area->freelist[i] = i;
 	}
 
@@ -233,4 +247,219 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 	lockdep_assert_held(&ctx->uring_lock);
 }
 
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
+	netmem_ref netmem = net_iov_to_netmem(niov);
+
+#if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
+	if (pp->dma_sync && dma_dev_need_sync(pp->p.dev)) {
+		dma_addr_t dma_addr = page_pool_get_dma_addr_netmem(netmem);
+
+		dma_sync_single_range_for_device(pp->p.dev, dma_addr,
+						 pp->p.offset, pp->p.max_len,
+						 pp->p.dma_dir);
+	}
+#endif
+
+	page_pool_fragment_netmem(netmem, 1);
+	pp->alloc.cache[pp->alloc.count++] = netmem;
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
+		io_zc_add_pp_cache(pp, niov);
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
+		io_zc_add_pp_cache(pp, niov);
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
+	if (!pp->p.napi->napi_id)
+		return -EINVAL;
+
+	ret = page_pool_init_paged_area(pp, &area->nia, area->pages);
+	if (ret)
+		return ret;
+
+	ifq->napi_id = pp->p.napi->napi_id;
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
+	page_pool_release_area(pp, &ifq->area->nia);
+
+	ifq->pp = NULL;
+	ifq->napi_id = 0;
+
+	if (WARN_ON_ONCE(area->free_count != area->nia.num_niovs))
+		return;
+	percpu_ref_put(&ifq->ctx->refs);
+}
+
+const struct memory_provider_ops io_uring_pp_zc_ops = {
+	.alloc_netmems		= io_pp_zc_alloc_netmems,
+	.release_netmem		= io_pp_zc_release_netmem,
+	.init			= io_pp_zc_init,
+	.destroy		= io_pp_zc_destroy,
+	.scrub			= io_pp_zc_scrub,
+};
+
 #endif
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 2fcbeb3d5501..67512fc69cc4 100644
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
@@ -22,15 +25,18 @@ struct io_zcrx_ifq {
 	struct io_ring_ctx		*ctx;
 	struct net_device		*dev;
 	struct io_zcrx_area		*area;
+	struct page_pool		*pp;
 
 	struct io_uring			*rq_ring;
 	struct io_uring_zcrx_rqe 	*rqes;
 	u32				rq_entries;
+	u32				cached_rq_head;
 
 	unsigned short			n_rqe_pages;
 	struct page			**rqe_pages;
 
 	u32				if_rxq;
+	unsigned			napi_id;
 };
 
 #if defined(CONFIG_PAGE_POOL) && defined(CONFIG_INET)
-- 
2.43.5


