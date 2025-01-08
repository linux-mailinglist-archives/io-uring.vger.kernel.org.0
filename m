Return-Path: <io-uring+bounces-5769-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EBF1A067E9
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:08:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A728C167DF8
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:08:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D565D2046A9;
	Wed,  8 Jan 2025 22:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="y/1Bubcv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B2F205514
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374044; cv=none; b=byVYhnq1Zdr6arqdxMlFlndK2x1aV3lEL1JkYRvkySKqG8ouArvZnMLcpuHPCldVK3PTgPxlSo9EfFH50S7b1soEcGzc/CW/wM0cqqHCqt+HGH2/IaWfvL1NK4a8nxl5HsYS7FW8D63a/pKSEyEt1ZMJ899ECs8gdEEYegrsWx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374044; c=relaxed/simple;
	bh=fRUByEwg0FvgkNn2bCixfrj0Uwn+Ak02MnYWq8R24a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aXAyvhezuBJH8OnSr1TIOgngMf+2d87HzDpt/wMQDTjG+btE0BFSRMy25km/73t3t9PBjekdEosRFylfNaGMrsqCaSxgAbqx3VbdUbEpJtdEeRu285z9IG1x9LonMw+PtfoSLcu7a2JX15RoIOND5s6x3ldv/S/d3UECDN6qXxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=y/1Bubcv; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ee709715d9so401943a91.3
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374042; x=1736978842; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rWzIMoqTgS/gdRC23WX/R1zHF1HLYqQL2tgeCd7UOH8=;
        b=y/1BubcvFchG3uhgqZ/yu7xGKMMVk4wd3NQrBEm3uqak9+51O84G+8I/zii0qwzZ9f
         5J99OCa00voNn7fYwwrbDH/GpZ/OFgXysduVv81TUdx/w1XO5mViXcmdhDPy2ALlVJu4
         iM3nMIrmItPMO3cIvaxUdHFb0tv+YxKhVAmX9khwUeiNyxluoFDkLFMIhjYlZXzj2eOq
         LEUgzjxx9bR/hz8XiqlXms28xkFcGtstoarFOItqD892UqPFpnLQ2tlKXvEpML9KUzEt
         2xU27yxsSJX5HZAhS8EnfDxwnc6t4/6sd2zZtRvK7ByGGlAunb61YIm2BmXiK8z970um
         Siaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374042; x=1736978842;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rWzIMoqTgS/gdRC23WX/R1zHF1HLYqQL2tgeCd7UOH8=;
        b=Rbs5X1IKAlR0mWx4n+yxJerkh8OaJlURFjNMBQzJDLy9dnjjR8hUGfcbyBNUYJzLGR
         upxse18wLrV6R0awXPs04t9+aAdlyoLH8WRXzUA04Gc0D6XdVdO3aWHYnUiIVyKicwEb
         M9GUMUNidzi8t5Ie+A0/JWOEyWQk6rARVAa1l7crUC8YMkED7D0KyRV3AUk+4qQDsXhV
         XwQJaPN07kRz7i6p1dt6gLEFJeVXBcbsB7eSlH/EO59XJoYPfNHyzOVwhWcsNbUj1Iwa
         RqjPeMzqJIaY5dWQraz2P+a7051t6OdzdU8ZgRG7XjukRRiv688XvCbGPeKW5SSFU0Ou
         76iQ==
X-Gm-Message-State: AOJu0YwRqzNiDVfhbzOSJY0JlEDBkVyH4PDtRz4U/CWOiq/NDXFAcDSQ
	d8Q2UpFq6QTmaKJM++iP6YL5pzSP/YLA86+FIqhjhFWxNnfe4l2jQ6uNrD2aCsLGtOMu7VJ1WNz
	r
X-Gm-Gg: ASbGnctuz3w6rgg2OGU7/ESoWQFloAuKwlW7hPRbhTdGLQf/koIu8LGXK6/njI08oZp
	kg9vMXrjndhn6+bw5jXj1CtI0SN5H5L31X6mrLcIbawaMS8gSHOkydftLJ0W91uceEVfYB38z6S
	2SSk+h4NJsoPss/XCBDCjhq/FgItgT29BqTzofx6mcYMQMPzw2YoSfFmETo5tmcf2tD+BFpvKTH
	ihW+TTRXfP/5d5uMpAsY8KFHMGdTlp+P/567tgg
X-Google-Smtp-Source: AGHT+IFGo1ai17kfmPc4xM8AQJAuJI3a1b3noZBe7w57FWCh3ssBWrV48bCLJPmFNFRotfW3wbu5mg==
X-Received: by 2002:a17:90b:280a:b0:2ee:d186:fe48 with SMTP id 98e67ed59e1d1-2f548f1b5cfmr5977765a91.28.1736374042331;
        Wed, 08 Jan 2025 14:07:22 -0800 (PST)
Received: from localhost ([2a03:2880:ff:c::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9706c3sm332664485ad.83.2025.01.08.14.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:21 -0800 (PST)
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
Subject: [PATCH net-next v10 15/22] io_uring/zcrx: implement zerocopy receive pp memory provider
Date: Wed,  8 Jan 2025 14:06:36 -0800
Message-ID: <20250108220644.3528845-16-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250108220644.3528845-1-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
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

Unlike the traditional receive, that frees pages and returns them back
to the page pool right after data was copied to the user, e.g. inside
recv(2), we extend the lifetime until the user space confirms that it's
done processing the data. That's done by taking a net_iov reference.
When the user is done with the buffer, it must return it back to the
kernel by posting an entry into the refill ring, which is usually polled
off the io_uring memory provider callback in the page pool's netmem
allocation path.

There is also a separate set of per net_iov "user" references accounting
whether a buffer is currently given to the user (including possible
fragmentation).

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 263 ++++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/zcrx.h |   3 +
 2 files changed, 266 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e6cca6747148..64e86d14acc7 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -2,10 +2,17 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/nospec.h>
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 
+#include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
+#include <net/netlink.h>
+
+#include <trace/events/page_pool.h>
+
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
@@ -16,6 +23,33 @@
 
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
+static inline atomic_t *io_get_user_counter(struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	return &area->user_refs[net_iov_idx(niov)];
+}
+
+static bool io_zcrx_put_niov_uref(struct net_iov *niov)
+{
+	atomic_t *uref = io_get_user_counter(niov);
+
+	if (unlikely(!atomic_read(uref)))
+		return false;
+	atomic_dec(uref);
+	return true;
+}
+
 static int io_allocate_rbuf_ring(struct io_zcrx_ifq *ifq,
 				 struct io_uring_zcrx_ifq_reg *reg,
 				 struct io_uring_region_desc *rd)
@@ -51,6 +85,7 @@ static void io_zcrx_free_area(struct io_zcrx_area *area)
 {
 	kvfree(area->freelist);
 	kvfree(area->nia.niovs);
+	kvfree(area->user_refs);
 	if (area->pages) {
 		unpin_user_pages(area->pages, area->nia.num_niovs);
 		kvfree(area->pages);
@@ -106,6 +141,19 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	for (i = 0; i < nr_pages; i++)
 		area->freelist[i] = i;
 
+	area->user_refs = kvmalloc_array(nr_pages, sizeof(area->user_refs[0]),
+					GFP_KERNEL | __GFP_ZERO);
+	if (!area->user_refs)
+		goto err;
+
+	for (i = 0; i < nr_pages; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+
+		niov->owner = &area->nia;
+		area->freelist[i] = i;
+		atomic_set(&area->user_refs[i], 0);
+	}
+
 	area->free_count = nr_pages;
 	area->ifq = ifq;
 	/* we're only supporting one area per ifq for now */
@@ -130,6 +178,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 	ifq->if_rxq = -1;
 	ifq->ctx = ctx;
+	spin_lock_init(&ifq->rq_lock);
 	return ifq;
 }
 
@@ -238,7 +287,221 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
 	io_zcrx_ifq_free(ifq);
 }
 
+static struct net_iov *__io_zcrx_get_free_niov(struct io_zcrx_area *area)
+{
+	unsigned niov_idx;
+
+	lockdep_assert_held(&area->freelist_lock);
+
+	niov_idx = area->freelist[--area->free_count];
+	return &area->nia.niovs[niov_idx];
+}
+
+static void io_zcrx_return_niov_freelist(struct net_iov *niov)
+{
+	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
+
+	spin_lock_bh(&area->freelist_lock);
+	area->freelist[area->free_count++] = net_iov_idx(niov);
+	spin_unlock_bh(&area->freelist_lock);
+}
+
+static void io_zcrx_return_niov(struct net_iov *niov)
+{
+	netmem_ref netmem = net_iov_to_netmem(niov);
+
+	page_pool_put_unrefed_netmem(niov->pp, netmem, -1, false);
+}
+
+static void io_zcrx_scrub(struct io_zcrx_ifq *ifq)
+{
+	struct io_zcrx_area *area = ifq->area;
+	int i;
+
+	if (!area)
+		return;
+
+	/* Reclaim back all buffers given to the user space. */
+	for (i = 0; i < area->nia.num_niovs; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+		int nr;
+
+		if (!atomic_read(io_get_user_counter(niov)))
+			continue;
+		nr = atomic_xchg(io_get_user_counter(niov), 0);
+		if (nr && !page_pool_unref_netmem(net_iov_to_netmem(niov), nr))
+			io_zcrx_return_niov(niov);
+	}
+}
+
 void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
 {
 	lockdep_assert_held(&ctx->uring_lock);
+
+	if (ctx->ifq)
+		io_zcrx_scrub(ctx->ifq);
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
 }
+
+static void io_zcrx_ring_refill(struct page_pool *pp,
+				struct io_zcrx_ifq *ifq)
+{
+	unsigned int mask = ifq->rq_entries - 1;
+	unsigned int entries;
+	netmem_ref netmem;
+
+	spin_lock_bh(&ifq->rq_lock);
+
+	entries = io_zcrx_rqring_entries(ifq);
+	entries = min_t(unsigned, entries, PP_ALLOC_CACHE_REFILL - pp->alloc.count);
+	if (unlikely(!entries)) {
+		spin_unlock_bh(&ifq->rq_lock);
+		return;
+	}
+
+	do {
+		struct io_uring_zcrx_rqe *rqe = io_zcrx_get_rqe(ifq, mask);
+		struct io_zcrx_area *area;
+		struct net_iov *niov;
+		unsigned niov_idx, area_idx;
+
+		area_idx = rqe->off >> IORING_ZCRX_AREA_SHIFT;
+		niov_idx = (rqe->off & ~IORING_ZCRX_AREA_MASK) >> PAGE_SHIFT;
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
+
+		netmem = net_iov_to_netmem(niov);
+		if (page_pool_unref_netmem(netmem, 1) != 0)
+			continue;
+
+		if (unlikely(niov->pp != pp)) {
+			io_zcrx_return_niov(niov);
+			continue;
+		}
+
+		net_mp_netmem_place_in_cache(pp, netmem);
+	} while (--entries);
+
+	smp_store_release(&ifq->rq_ring->head, ifq->cached_rq_head);
+	spin_unlock_bh(&ifq->rq_lock);
+}
+
+static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
+{
+	struct io_zcrx_area *area = ifq->area;
+
+	spin_lock_bh(&area->freelist_lock);
+	while (area->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
+		struct net_iov *niov = __io_zcrx_get_free_niov(area);
+		netmem_ref netmem = net_iov_to_netmem(niov);
+
+		net_mp_niov_set_page_pool(pp, niov);
+		net_mp_netmem_place_in_cache(pp, netmem);
+	}
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
+	net_mp_niov_clear_page_pool(niov);
+	io_zcrx_return_niov_freelist(niov);
+	return false;
+}
+
+static int io_pp_zc_init(struct page_pool *pp)
+{
+	struct io_zcrx_ifq *ifq = pp->mp_priv;
+
+	if (WARN_ON_ONCE(!ifq))
+		return -EINVAL;
+	if (WARN_ON_ONCE(ifq->dev != pp->slow.netdev))
+		return -EINVAL;
+	if (pp->dma_map)
+		return -EOPNOTSUPP;
+	if (pp->p.order != 0)
+		return -EOPNOTSUPP;
+
+	percpu_ref_get(&ifq->ctx->refs);
+	return 0;
+}
+
+static void io_pp_zc_destroy(struct page_pool *pp)
+{
+	struct io_zcrx_ifq *ifq = pp->mp_priv;
+	struct io_zcrx_area *area = ifq->area;
+
+	if (WARN_ON_ONCE(area->free_count != area->nia.num_niovs))
+		return;
+	percpu_ref_put(&ifq->ctx->refs);
+}
+
+static int io_pp_nl_fill(void *mp_priv, struct sk_buff *rsp,
+			 struct netdev_rx_queue *rxq)
+{
+	struct nlattr *nest;
+	int type;
+
+	type = rxq ? NETDEV_A_QUEUE_IO_URING : NETDEV_A_PAGE_POOL_IO_URING;
+	nest = nla_nest_start(rsp, type);
+	nla_nest_end(rsp, nest);
+
+	return 0;
+}
+
+static const struct memory_provider_ops io_uring_pp_zc_ops = {
+	.alloc_netmems		= io_pp_zc_alloc_netmems,
+	.release_netmem		= io_pp_zc_release_netmem,
+	.init			= io_pp_zc_init,
+	.destroy		= io_pp_zc_destroy,
+	.nl_fill		= io_pp_nl_fill,
+};
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 46988a1dbd54..f31c8006ca9c 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -9,6 +9,7 @@
 struct io_zcrx_area {
 	struct net_iov_area	nia;
 	struct io_zcrx_ifq	*ifq;
+	atomic_t		*user_refs;
 
 	u16			area_id;
 	struct page		**pages;
@@ -26,6 +27,8 @@ struct io_zcrx_ifq {
 	struct io_uring			*rq_ring;
 	struct io_uring_zcrx_rqe	*rqes;
 	u32				rq_entries;
+	u32				cached_rq_head;
+	spinlock_t			rq_lock;
 
 	u32				if_rxq;
 	struct net_device		*dev;
-- 
2.43.5


