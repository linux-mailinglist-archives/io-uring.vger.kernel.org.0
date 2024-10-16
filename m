Return-Path: <io-uring+bounces-3750-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45AA99A11FC
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 20:54:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C5BA71F24EDD
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 18:54:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D57BE213EE9;
	Wed, 16 Oct 2024 18:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="0SbvdF3k"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41141216A1D
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 18:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729104797; cv=none; b=smemiK9KSfd7hDk8bUV94dt84FMl2NW3CqAJ5KDhoEGWSwrGBUZonfiQQ/8LJ2hScKq69X08kJEJX8474jES+0wnlrTPcTMNqpL9Z0or3xJxQJNtSAA1Qr9Pyy57J2Cy1rJqQ6ziNi8DbCGf4QIIM8bzh8WL4lFX8UX/hZEpyaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729104797; c=relaxed/simple;
	bh=SpI7Zbj19Gy/EtvrfQmkoPEnLfihjJOPaTKZTrAxJXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kkbBy61FkZBn7piTBIuV6J7xLikhdYM3hsZFdvsjX/r5YMZMVF6nWfA/n4xrpqIZ3mqWRAcupgEmvzn0O3/2NW9ilTnaYpqn5QUyX5TQ2fVKp6nyndOKPQcO+mBBlJsT7EGNlurCjSqsE94OUvR839OHosbNeGYi2LqX4hfkrFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=0SbvdF3k; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2e2a999b287so118680a91.0
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 11:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729104795; x=1729709595; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gbfoCUYOd98zkFy23A6SaPZzHs8neEBMKAyCLztJErg=;
        b=0SbvdF3kS2amYOb1FXbidHzGWNdxBabzYXbEfpB83CjD0nF/Z1Zhi+t016adnYy5Sf
         OtGTWFf55QsL1PbjuuBmXLK92iytB+3r7PoigPJ4gsrZjSdejNiW6QFZu+Hl9BMO0wI6
         x4sW2AvuahATBrKZs46P86oJK8aj+eb58y0oCn8WMGPAxS+20GiEMld0gILiFZlD6Rck
         GA81kearZXcHnSQGyPCAJBUbgV4EkXCN0HVaSs5KbioYIVoWTD+sk16Tw7VFZutCOUq1
         /CzAfczRpZaaTk+MDnRKHh2O6lag1hk31Og3fLmRtS2HiHd8ec+MxBx28h3mHMC6ytWT
         YkMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729104795; x=1729709595;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gbfoCUYOd98zkFy23A6SaPZzHs8neEBMKAyCLztJErg=;
        b=SMOQQev98S0KsqLxTwDXhdGwTLOu3hGd2H1bWllvyWN6MrpMXQRoBbXND+0qpvoOu7
         jtBZ8PupMntT4S+SFiE2Twwrj9e8wrlNA0vKh4gVpICoNJ0KoqtFvPe0WYTNFan1IHGY
         +6Bj+XrNTgiOP37N7Ke4CGEWw3vgq/SOleTrDEsVmDNqwECYhhfpE7+l7nTKP2/MIgpf
         6gWovpzIKf/AnisnaUYDMRNk8CjPLN30hPtnoZMzs5ApcP8t7ka6IRIry6Dvmn/OcX7D
         QDLLIwXrtpUYsaypf22HvwwrhefhoFAt+rabAoyXbd6y1aQTU9+aHS/Ew1UhD2CggMNQ
         F3aQ==
X-Gm-Message-State: AOJu0Yykw832lbRTg+UfSu9haCJU6lgF47ErTIZzHLYqSYgs3qMZrn8+
	sINEnS3JDaLYWZ3TjDthFm75ThXTLcIw07O8M3BcqgX93j5Iy8slUTxZeZPi7rL6avKQ6YJToyP
	j
X-Google-Smtp-Source: AGHT+IEj/idN9IhMGd1wlSUgDAwrSEfk45xsIMSlOEE04Wgw9vpeSwe3lNWSU/Ws5LTOQ1Ol45Ovmw==
X-Received: by 2002:a17:90b:3701:b0:2e2:cd79:ec06 with SMTP id 98e67ed59e1d1-2e2f0abb916mr23041497a91.10.1729104795516;
        Wed, 16 Oct 2024 11:53:15 -0700 (PDT)
Received: from localhost (fwdproxy-prn-035.fbsv.net. [2a03:2880:ff:23::face:b00c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e3e08c1d0bsm129707a91.19.2024.10.16.11.53.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 11:53:15 -0700 (PDT)
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
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>
Subject: [PATCH v6 11/15] io_uring/zcrx: implement zerocopy receive pp memory provider
Date: Wed, 16 Oct 2024 11:52:48 -0700
Message-ID: <20241016185252.3746190-12-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241016185252.3746190-1-dw@davidwei.uk>
References: <20241016185252.3746190-1-dw@davidwei.uk>
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
 io_uring/zcrx.c | 215 ++++++++++++++++++++++++++++++++++++++++++++++++
 io_uring/zcrx.h |   5 ++
 2 files changed, 220 insertions(+)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index a276572fe953..aad35676207e 100644
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
 				 struct io_uring_zcrx_ifq_reg *reg)
 {
@@ -99,6 +114,9 @@ static int io_zcrx_create_area(struct io_ring_ctx *ctx,
 		goto err;
 
 	for (i = 0; i < nr_pages; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+
+		niov->owner = &area->nia;
 		area->freelist[i] = i;
 	}
 
@@ -230,3 +248,200 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
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
index a8db61498c67..464b4bd89b64 100644
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
 
 	unsigned short			n_rqe_pages;
 	struct page			**rqe_pages;
-- 
2.43.5


