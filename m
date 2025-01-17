Return-Path: <io-uring+bounces-5981-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 05BF2A153D1
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 17:11:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0D5421885AEB
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 16:11:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA65019E82A;
	Fri, 17 Jan 2025 16:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fFxEbZYe"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F7A19CC27;
	Fri, 17 Jan 2025 16:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737130284; cv=none; b=J/mk9tkQPVMRLsYUBsx7AyH8xALxcW0qxKLN4pBxpcn2krRll0yXB7ZfJCzShynii0mlZylKuDtA1n0XbNMUx19eCiScXzO/hiBme1oH6SKVLTtCpbqlo6y+cVffPeEvLmb7cSC7YFR6EldDAVc76dUpVvwYkyP4EpBhxlZNId0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737130284; c=relaxed/simple;
	bh=KkoCFdqeGAx/jAKbeobYbpZcVxDZ8fOpp1Uvm/4UJS0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsmXaJjyMMDWyKAW9hthhhjgILrg7B/uL/Hf07h6XZ8ox45MlnoA0NuCL0ljc7jkJNaVViwmHNZmklLnwRdLq8LqFQhzZn7dfCA1I6z0GR9tqcoaN6844T4bNdiSGW+H1xiTZWJ0ejt0ec91sp/xTAsZM+gmxbEAxkugEVyumdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fFxEbZYe; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-ab39f84cbf1so37237066b.3;
        Fri, 17 Jan 2025 08:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737130281; x=1737735081; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fhVLlGQYKbTCHyiUVg4Zavq5CQp0lOKqe27gBDb4LXw=;
        b=fFxEbZYe7/bL1RZCteYtW+VlaBGBLf38kJ/jL2LE7VGbVSxfK/jz1lghuLNR0gcYtb
         5bXmSkMIRqN9Md1PdWfH0/tQGVt2e1ZePyNeEy41XZbCBr0UEDCy4vT5ABKZuJkpJFF0
         4p9/HWtxEse8tOBFCz3GSQTZSBtlKz+n0EY6d8P33yml1Zmu+302LFIJemKvRY7hTh03
         2JwspKNXk+5f1G55K/JVnvzLMbERUjbJwGWCP4SUGAnCfXqTcLmLLmkyMvB/Ogp0Ensv
         9T7c2lzIjcqSTNIW8bupdkfbNGDo+12FgYUvgJq3pjGDWQ36Ueqs3se9LxjazMKd8aQ+
         WNPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737130281; x=1737735081;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fhVLlGQYKbTCHyiUVg4Zavq5CQp0lOKqe27gBDb4LXw=;
        b=YcL9WPhmS5m1bjRd953gQb1dFWPmH+6+OnaJB0/KT4w7ZEff0omzYsooAOe8uoihpV
         C4kyda/lHP479BUDjx6o26/2krw6YT9bwcEDfw9a72QwwlF3HfrbvtFYx+Nf1m3snqOd
         oehwvPj1n8mJr2/gNaq29MJpmwxOrl3IWoRVKS/MJO7qjEhu7aQqGjsQblZsjwvCmyLn
         CsvnsL3+Ra9lGDsreKQNr5cpvSHv5BAxeIob4GqCMpuDzw4459jAm31LzuTj+u4GT7nH
         wLZEeDw7cKNf4GDqyPRvM6lZnB/pOxplKhjGMV5eOuBMn/qtd9A6jyebA+pQBnPq8MLI
         Ci3g==
X-Forwarded-Encrypted: i=1; AJvYcCXZaEmwj/2YvHSkH7c7OG7xEl1qkEfqc6qNhE2O4ugFeZhc0imbNU0nyG7uAFTioinASrPiY7Q=@vger.kernel.org
X-Gm-Message-State: AOJu0Ywuq+TqooBf5Wq4jHWd3DhFLrpjVLLbwEbKcy+5gnp+pqOupYZs
	NMrj23O4RnFdwjo5HvzeJn2XOiN59CG9lE4w+RjSo+tcsH1zzEcFd+edCQ==
X-Gm-Gg: ASbGncus00x/IRrR/wiO8ywCymQrDcwAnjgYYXwyM+aAIu5O7pbmBLvrCTFbB95HjxR
	y+rFoK7NJR5zv3EhxN0HyHdawqzMleYEMP7we6PPbGKAOJXk8+YiLCTX+0B+C7HqANNIUhZzBPn
	Dl8CIeotbuEyIod78jA5R4kTVz+EvVEPGsnvO1E3hPS02s92YylSOfDu2Xf2qVpJAy0CyUppRgu
	4mO4jNxRbP1wz2LRjNG8lJJA6KMWkhEy74qSUXb
X-Google-Smtp-Source: AGHT+IETIoeJnGYR3eGQuMug+TMoWNgDpE1uopseE3IWnBKre9KB9DxN+xPmoyxwdkGLbJFWY4rxaQ==
X-Received: by 2002:a17:907:7fa2:b0:aa6:96ad:f903 with SMTP id a640c23a62f3a-ab38b1bc6a1mr335351366b.31.1737130280885;
        Fri, 17 Jan 2025 08:11:20 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:56de])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab384f23007sm193716366b.96.2025.01.17.08.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jan 2025 08:11:20 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Mina Almasry <almasrymina@google.com>,
	Stanislav Fomichev <stfomichev@gmail.com>,
	Joe Damato <jdamato@fastly.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	David Wei <dw@davidwei.uk>
Subject: [PATCH net-next v12 04/10] net: page_pool: create hooks for custom memory providers
Date: Fri, 17 Jan 2025 16:11:42 +0000
Message-ID: <f2609fa45df88881bdbe9635af337a1a962ae1a1.1737129699.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1737129699.git.asml.silence@gmail.com>
References: <cover.1737129699.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A spin off from the original page pool memory providers patch by Jakub,
which allows extending page pools with custom allocators. One of such
providers is devmem TCP, and the other is io_uring zerocopy added in
following patches.

Link: https://lore.kernel.org/netdev/20230707183935.997267-7-kuba@kernel.org/
Co-developed-by: Jakub Kicinski <kuba@kernel.org> # initial mp proposal
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/net/page_pool/memory_provider.h | 15 +++++++++++++++
 include/net/page_pool/types.h           |  4 ++++
 net/core/devmem.c                       | 15 ++++++++++++++-
 net/core/page_pool.c                    | 23 +++++++++++++++--------
 4 files changed, 48 insertions(+), 9 deletions(-)
 create mode 100644 include/net/page_pool/memory_provider.h

diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
new file mode 100644
index 000000000000..e49d0a52629d
--- /dev/null
+++ b/include/net/page_pool/memory_provider.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _NET_PAGE_POOL_MEMORY_PROVIDER_H
+#define _NET_PAGE_POOL_MEMORY_PROVIDER_H
+
+#include <net/netmem.h>
+#include <net/page_pool/types.h>
+
+struct memory_provider_ops {
+	netmem_ref (*alloc_netmems)(struct page_pool *pool, gfp_t gfp);
+	bool (*release_netmem)(struct page_pool *pool, netmem_ref netmem);
+	int (*init)(struct page_pool *pool);
+	void (*destroy)(struct page_pool *pool);
+};
+
+#endif
diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index ed4cd114180a..88f65c3e2ad9 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -152,8 +152,11 @@ struct page_pool_stats {
  */
 #define PAGE_POOL_FRAG_GROUP_ALIGN	(4 * sizeof(long))
 
+struct memory_provider_ops;
+
 struct pp_memory_provider_params {
 	void *mp_priv;
+	const struct memory_provider_ops *mp_ops;
 };
 
 struct page_pool {
@@ -216,6 +219,7 @@ struct page_pool {
 	struct ptr_ring ring;
 
 	void *mp_priv;
+	const struct memory_provider_ops *mp_ops;
 
 #ifdef CONFIG_PAGE_POOL_STATS
 	/* recycle stats are per-cpu to avoid locking */
diff --git a/net/core/devmem.c b/net/core/devmem.c
index 3d91fba2bd26..1a88ab6faf06 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -16,6 +16,7 @@
 #include <net/netdev_queues.h>
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
 #include <trace/events/page_pool.h>
 
 #include "devmem.h"
@@ -27,6 +28,8 @@
 /* Protected by rtnl_lock() */
 static DEFINE_XARRAY_FLAGS(net_devmem_dmabuf_bindings, XA_FLAGS_ALLOC1);
 
+static const struct memory_provider_ops dmabuf_devmem_ops;
+
 static void net_devmem_dmabuf_free_chunk_owner(struct gen_pool *genpool,
 					       struct gen_pool_chunk *chunk,
 					       void *not_used)
@@ -118,6 +121,7 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
 		WARN_ON(rxq->mp_params.mp_priv != binding);
 
 		rxq->mp_params.mp_priv = NULL;
+		rxq->mp_params.mp_ops = NULL;
 
 		rxq_idx = get_netdev_rx_queue_index(rxq);
 
@@ -153,7 +157,7 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 	}
 
 	rxq = __netif_get_rx_queue(dev, rxq_idx);
-	if (rxq->mp_params.mp_priv) {
+	if (rxq->mp_params.mp_ops) {
 		NL_SET_ERR_MSG(extack, "designated queue already memory provider bound");
 		return -EEXIST;
 	}
@@ -171,6 +175,7 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 		return err;
 
 	rxq->mp_params.mp_priv = binding;
+	rxq->mp_params.mp_ops = &dmabuf_devmem_ops;
 
 	err = netdev_rx_queue_restart(dev, rxq_idx);
 	if (err)
@@ -180,6 +185,7 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 
 err_xa_erase:
 	rxq->mp_params.mp_priv = NULL;
+	rxq->mp_params.mp_ops = NULL;
 	xa_erase(&binding->bound_rxqs, xa_idx);
 
 	return err;
@@ -399,3 +405,10 @@ bool mp_dmabuf_devmem_release_page(struct page_pool *pool, netmem_ref netmem)
 	/* We don't want the page pool put_page()ing our net_iovs. */
 	return false;
 }
+
+static const struct memory_provider_ops dmabuf_devmem_ops = {
+	.init			= mp_dmabuf_devmem_init,
+	.destroy		= mp_dmabuf_devmem_destroy,
+	.alloc_netmems		= mp_dmabuf_devmem_alloc_netmems,
+	.release_netmem		= mp_dmabuf_devmem_release_page,
+};
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index a3de752c5178..199564b03533 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -13,6 +13,7 @@
 
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
 #include <net/xdp.h>
 
 #include <linux/dma-direction.h>
@@ -285,13 +286,19 @@ static int page_pool_init(struct page_pool *pool,
 		rxq = __netif_get_rx_queue(pool->slow.netdev,
 					   pool->slow.queue_idx);
 		pool->mp_priv = rxq->mp_params.mp_priv;
+		pool->mp_ops = rxq->mp_params.mp_ops;
 	}
 
-	if (pool->mp_priv) {
+	if (pool->mp_ops) {
 		if (!pool->dma_map || !pool->dma_sync)
 			return -EOPNOTSUPP;
 
-		err = mp_dmabuf_devmem_init(pool);
+		if (WARN_ON(!is_kernel_rodata((unsigned long)pool->mp_ops))) {
+			err = -EFAULT;
+			goto free_ptr_ring;
+		}
+
+		err = pool->mp_ops->init(pool);
 		if (err) {
 			pr_warn("%s() mem-provider init failed %d\n", __func__,
 				err);
@@ -588,8 +595,8 @@ netmem_ref page_pool_alloc_netmems(struct page_pool *pool, gfp_t gfp)
 		return netmem;
 
 	/* Slow-path: cache empty, do real allocation */
-	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_priv)
-		netmem = mp_dmabuf_devmem_alloc_netmems(pool, gfp);
+	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_ops)
+		netmem = pool->mp_ops->alloc_netmems(pool, gfp);
 	else
 		netmem = __page_pool_alloc_pages_slow(pool, gfp);
 	return netmem;
@@ -680,8 +687,8 @@ void page_pool_return_page(struct page_pool *pool, netmem_ref netmem)
 	bool put;
 
 	put = true;
-	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_priv)
-		put = mp_dmabuf_devmem_release_page(pool, netmem);
+	if (static_branch_unlikely(&page_pool_mem_providers) && pool->mp_ops)
+		put = pool->mp_ops->release_netmem(pool, netmem);
 	else
 		__page_pool_release_page_dma(pool, netmem);
 
@@ -1049,8 +1056,8 @@ static void __page_pool_destroy(struct page_pool *pool)
 	page_pool_unlist(pool);
 	page_pool_uninit(pool);
 
-	if (pool->mp_priv) {
-		mp_dmabuf_devmem_destroy(pool);
+	if (pool->mp_ops) {
+		pool->mp_ops->destroy(pool);
 		static_branch_dec(&page_pool_mem_providers);
 	}
 
-- 
2.47.1


