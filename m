Return-Path: <io-uring+bounces-5552-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 88F109F5BD1
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 01:41:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7CB0E1896BF5
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2024 00:40:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 216BD136671;
	Wed, 18 Dec 2024 00:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="HETCjp6A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B42A13DDD3
	for <io-uring@vger.kernel.org>; Wed, 18 Dec 2024 00:38:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734482295; cv=none; b=p2Sf5sgVc1eADtn84B/2GucS4KfanHC851xIwm47CXuNiIKc8Y1aVBCcPpuZ5pWwkIMpkBJF2+oG7c6MutUTMIk9auZ+1Dx5nga1Kh4xwhwqfZ3Iyg4IH4RtywqK+aafDNBwUUQNAQKOFRgQlI0xSZ9oMNQPTqAuu4dahiFl/R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734482295; c=relaxed/simple;
	bh=ayZO1p/xdCKMs+Fe9n0Jxpv0eY9Egs/CfQ+ZAezZ7So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHS/jHeS0pDNwXUXVO+MSdPSmtbeWKNwtEVjHIvENRtRGxsWwzdu4Hq2CCtNuDbaR9+BrAIjvfJl4UcXsNlciqRv5AXRn1GHo7mLe6/WFFj/NrLChyhdYlQHRt4Uw6D/jkxKHnQPCtpEqLmf4iJK8ifIsb4SwoEdTRK/hxFGFr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=HETCjp6A; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2164b662090so47543895ad.1
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 16:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1734482293; x=1735087093; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hFDW8/jDpFissyoMjOJTF6aMSnlKbLXD4WQxy4V2rHU=;
        b=HETCjp6AzLJyCRvoF5llJBcRGxryj6zJgPPpAjARtTfo2OXx1z91ajSzhSt/0ljp50
         SEkhl7vqtKYieK6rFRzKmdWIjDcUsHel6OOxdz3pta+EOKWhHO1g/wra1DJyL31G8h/E
         aEmof9lngno8wYlO3MQHN1j06V2uL0+FfrDqU6U3Y5yhBS16ViptiEfbf8DZkn2Gto/1
         DcBF/cvTkK/d7LHnVMPOsBNiEQpUvoFNBeO+JQKShzk3C6ZgiDbemEdmMEJ9shIoItI/
         a0JIxL94oUu9Jku0pgf+w23hX0HMDgreGC1+s+uKPJzBqs24zg4by+mzzzfFj33RbLzM
         J/oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734482293; x=1735087093;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hFDW8/jDpFissyoMjOJTF6aMSnlKbLXD4WQxy4V2rHU=;
        b=pZ+tD36SmkCVpIU/EPCbj/20R3xRbYmNvVg1qp6iK4/ZbTgFYVsTOAFGHC1bDg1IZL
         D8uRtDS8MMKguTEklC+NAzY874X1MwCjFBcIiP0LY0XzG9r7fT1n9MGyZYwMjYoBrblm
         COADGuA9kZSt3jIscpGF/SXgzTbpaPMwE4iwuQjgE/NyZi/WXZMj9PxhrmVFxUFvnWVK
         OrR4B5bkwd1QvOgfvoVgrjNVCYROnw66wnDW4cNDrttYtAOnBsN8oR2YjhMOZ7/DxaeR
         IRsKIcPmpa032IcJ9mDr4BGftTVpYzH9tp+/WE5pZk1x/0Wv0CwbhddzzabGHhS3ReTh
         ZhLg==
X-Gm-Message-State: AOJu0YwUNmowM/SEY8bk94P20gj2V8czumNtfYYrLzHAEk0wIF6ah437
	HptrIEFKChY7AH4r8d92mjPqoIBKlarys7wykVhYcIRXbuNgIMR7/4BkEpGLxZoTghk2xApkQaA
	A
X-Gm-Gg: ASbGncsCD6xiBvbL6LRUrBYGw6cpbu4EUGxUYfi42Zo7yn4iiDVFQS6ilCivH4mZOG2
	8q/FI8ucQQgzOk5E0RKj6IDoZka7vqfbLIcV7+xKtsuEATx47Hr844AWFtScI7mu+n9+GXaDWJr
	WpodOF4YTXC35IlS4SDI5j/POdoRnwwJU4te3qAygVvnuZEMZfV5R6mhGWdGh8EucSqetrJImhJ
	PXXZ2VJU3H8GLoXYTczfMXFndidWTI9jUXDqw9O
X-Google-Smtp-Source: AGHT+IEZxdWvw9DF77b/0R+5QvSxNjbMl61C+f+Zcul99UQRWHgdhC+BURHFRDgerMUTC9sWt2Tmlg==
X-Received: by 2002:a17:902:eccd:b0:215:7b06:90ca with SMTP id d9443c01a7336-218d70d9630mr12054035ad.17.1734482292413;
        Tue, 17 Dec 2024 16:38:12 -0800 (PST)
Received: from localhost ([2a03:2880:ff:3::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-218a1e5cf5asm65456855ad.178.2024.12.17.16.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2024 16:38:11 -0800 (PST)
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
Subject: [PATCH net-next v9 14/20] io_uring/zcrx: dma-map area for the device
Date: Tue, 17 Dec 2024 16:37:40 -0800
Message-ID: <20241218003748.796939-15-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241218003748.796939-1-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

Setup DMA mappings for the area into which we intend to receive data
later on. We know the device we want to attach to even before we get a
page pool and can pre-map in advance. All net_iov are synchronised for
device when allocated, see page_pool_mp_return_in_cache().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/uapi/linux/netdev.h |   1 +
 io_uring/zcrx.c             | 320 ++++++++++++++++++++++++++++++++++++
 io_uring/zcrx.h             |   4 +
 3 files changed, 325 insertions(+)

diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
index e4be227d3ad6..13d810a28ed6 100644
--- a/include/uapi/linux/netdev.h
+++ b/include/uapi/linux/netdev.h
@@ -94,6 +94,7 @@ enum {
 	NETDEV_A_PAGE_POOL_INFLIGHT_MEM,
 	NETDEV_A_PAGE_POOL_DETACH_TIME,
 	NETDEV_A_PAGE_POOL_DMABUF,
+	NETDEV_A_PAGE_POOL_IO_URING,
 
 	__NETDEV_A_PAGE_POOL_MAX,
 	NETDEV_A_PAGE_POOL_MAX = (__NETDEV_A_PAGE_POOL_MAX - 1)
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e6cca6747148..42098bc1a60f 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1,11 +1,18 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/dma-map-ops.h>
 #include <linux/mm.h>
+#include <linux/nospec.h>
 #include <linux/io_uring.h>
 #include <linux/netdevice.h>
 #include <linux/rtnetlink.h>
 
+#include <net/page_pool/helpers.h>
+#include <net/netlink.h>
+
+#include <trace/events/page_pool.h>
+
 #include <uapi/linux/io_uring.h>
 
 #include "io_uring.h"
@@ -14,8 +21,92 @@
 #include "zcrx.h"
 #include "rsrc.h"
 
+#define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
+
+static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
+				 struct io_zcrx_area *area, int nr_mapped)
+{
+	struct device *dev = ifq->dev->dev.parent;
+	int i;
+
+	for (i = 0; i < nr_mapped; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+		dma_addr_t dma;
+
+		dma = page_pool_get_dma_addr_netmem(net_iov_to_netmem(niov));
+		dma_unmap_page_attrs(dev, dma, PAGE_SIZE, DMA_FROM_DEVICE,
+				     IO_DMA_ATTR);
+		page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov), 0);
+	}
+}
+
+static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
+{
+	if (area->is_mapped)
+		__io_zcrx_unmap_area(ifq, area, area->nia.num_niovs);
+}
+
+static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
+{
+	struct device *dev = ifq->dev->dev.parent;
+	int i;
+
+	if (!dev)
+		return -EINVAL;
+
+	for (i = 0; i < area->nia.num_niovs; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+		dma_addr_t dma;
+
+		dma = dma_map_page_attrs(dev, area->pages[i], 0, PAGE_SIZE,
+					 DMA_FROM_DEVICE, IO_DMA_ATTR);
+		if (dma_mapping_error(dev, dma))
+			break;
+		if (page_pool_set_dma_addr_netmem(net_iov_to_netmem(niov), dma)) {
+			dma_unmap_page_attrs(dev, dma, PAGE_SIZE,
+					     DMA_FROM_DEVICE, IO_DMA_ATTR);
+			break;
+		}
+	}
+
+	if (i != area->nia.num_niovs) {
+		__io_zcrx_unmap_area(ifq, area, i);
+		return -EINVAL;
+	}
+
+	area->is_mapped = true;
+	return 0;
+}
+
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
@@ -49,8 +140,11 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 
 static void io_zcrx_free_area(struct io_zcrx_area *area)
 {
+	io_zcrx_unmap_area(area->ifq, area);
+
 	kvfree(area->freelist);
 	kvfree(area->nia.niovs);
+	kvfree(area->user_refs);
 	if (area->pages) {
 		unpin_user_pages(area->pages, area->nia.num_niovs);
 		kvfree(area->pages);
@@ -106,6 +200,19 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
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
@@ -130,6 +237,7 @@ static struct io_zcrx_ifq *io_zcrx_ifq_alloc(struct io_ring_ctx *ctx)
 
 	ifq->if_rxq = -1;
 	ifq->ctx = ctx;
+	spin_lock_init(&ifq->rq_lock);
 	return ifq;
 }
 
@@ -205,6 +313,10 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (!ifq->dev)
 		goto err;
 
+	ret = io_zcrx_map_area(ifq, ifq->area);
+	if (ret)
+		goto err;
+
 	reg.offsets.rqes = sizeof(struct io_uring);
 	reg.offsets.head = offsetof(struct io_uring, head);
 	reg.offsets.tail = offsetof(struct io_uring, tail);
@@ -238,7 +350,215 @@ void io_unregister_zcrx_ifqs(struct io_ring_ctx *ctx)
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
+}
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
+		page_pool_mp_return_in_cache(pp, netmem);
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
+		page_pool_set_pp_info(pp, netmem);
+		page_pool_mp_return_in_cache(pp, netmem);
+
+		pp->pages_state_hold_cnt++;
+		trace_page_pool_state_hold(pp, netmem, pp->pages_state_hold_cnt);
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
+	if (WARN_ON_ONCE(!netmem_is_net_iov(netmem)))
+		return false;
+
+	if (page_pool_unref_netmem(netmem, 1) == 0)
+		io_zcrx_return_niov_freelist(netmem_to_net_iov(netmem));
+	return false;
 }
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
+	if (pp->p.dma_dir != DMA_FROM_DEVICE)
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
+static int io_pp_nl_report(const struct page_pool *pool, struct sk_buff *rsp)
+{
+	return nla_put_u32(rsp, NETDEV_A_PAGE_POOL_IO_URING, 0);
+}
+
+static const struct memory_provider_ops io_uring_pp_zc_ops = {
+	.alloc_netmems		= io_pp_zc_alloc_netmems,
+	.release_netmem		= io_pp_zc_release_netmem,
+	.init			= io_pp_zc_init,
+	.destroy		= io_pp_zc_destroy,
+	.nl_report		= io_pp_nl_report,
+};
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 46988a1dbd54..beacf1ea6380 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -9,7 +9,9 @@
 struct io_zcrx_area {
 	struct net_iov_area	nia;
 	struct io_zcrx_ifq	*ifq;
+	atomic_t		*user_refs;
 
+	bool			is_mapped;
 	u16			area_id;
 	struct page		**pages;
 
@@ -26,6 +28,8 @@ struct io_zcrx_ifq {
 	struct io_uring			*rq_ring;
 	struct io_uring_zcrx_rqe	*rqes;
 	u32				rq_entries;
+	u32				cached_rq_head;
+	spinlock_t			rq_lock;
 
 	u32				if_rxq;
 	struct net_device		*dev;
-- 
2.43.5


