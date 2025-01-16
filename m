Return-Path: <io-uring+bounces-5929-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F434A14538
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:17:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ABF633A9003
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:17:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E772242278;
	Thu, 16 Jan 2025 23:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="rNI6VMiM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D744C22CF2C
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069436; cv=none; b=WHE+j4eoq+XXLdPI7rJmIeUZBPirkaf1nPDtCMv5S9zF1eqpqPULRuE0TIcfl3dU8TIPzuezdgxkWJIHsUbrppdADDIKCL9Dazg+9yIrnF3mjLwGnkZxheZnhG7kc3K7dDpfvzPFEucXE4ION80EBuJgOaoMukKS6LhSxCaXtXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069436; c=relaxed/simple;
	bh=jcix8cTA8XcjU9cv7ZsMLrmB/iNbQuJzGglcZYJ7KpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7CBAMnx4uKbwougJ3rIw8mail8oxHlKs+0xnxjK7kj6wQNH+DcCQzta+SwBL8Nu0qRTSux0qHncE1i6LPLXTTiwwU28yFLozV7yN4U9hL4GSid3gKalGRb5809pLf2ZvTdZkWbDysf6+fKAXTtAP98LVwa4CGXQw7bZKLY4LYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=rNI6VMiM; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2164b1f05caso28308385ad.3
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069434; x=1737674234; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TJ1/x2oldCLUQ71TCzgIPzmYUprE3G9HK3SL6bSqPrg=;
        b=rNI6VMiMY2eXNhPEG48C9kfqKboEuPXX3cIwOTX2RrC2vHKtOVvnEflF5batQ1VdKS
         34fRttXEEPq7EihCO/ZPF7TJS+uEffSvfwZvTuAW1QJrdA4X+a4PBMlA0mNEDzXBESjE
         OyAeJTc3MSu91Ii/8xnZ+dVwgpngxlvCzq6p6L/xuvXp5Iq7/3RXOjDEgUjwTRVgh0rg
         4cce4HkIn9/bNRAsr6zUcnlr3Frjs+pardQM90Mcwsyfm4BQRDy2lcgVG6OENnOlG5rp
         7uU6y9wGV5dtQKagZxKqJQxNLYgxYZwf0e9zl5piiQtYYaBOzUe72ZMGmdt/qaxzhIvl
         EPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069434; x=1737674234;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TJ1/x2oldCLUQ71TCzgIPzmYUprE3G9HK3SL6bSqPrg=;
        b=a+fr35D0qo++xM6G9OCetxCd0XCXp18ydxsGevn/36aRSsA7Lh5jDlT90YOiKjVxJx
         T76DdntWs8Tgm70D64XX1v5MpZ9uibOP7FDaPATecxXKr97k9p/4EsOTYxuwsNzEdAjS
         5LnLRVKWCYgygd+j7FqfAnRv8KHuUeZ8fgc9mCG4/izyxkVKfOQGA3plu7QLnZHYX1KQ
         0Gji7ExnAMOGE3BsBXa2e9cLcF2GE+ZfwaSav5OrVUQVST9MfiJ1741I3W6I5Y6v6xxq
         gXw/kaTp35sC8yJYHoZX1uWhMJyAO5ntf7AHKFscpaXhwi4m9cu/mkmzr/GCktLT9kH+
         hOXQ==
X-Gm-Message-State: AOJu0Ywq1fqrRNh+u7UCDcQLtROGDSmzUJ9WLAMRzgkkO9QVSf3hUENz
	/jglUZHMlnkRMAUlKNgw3x/Nu3H6O5FOVteer1ZrivK+4rCqwXdazI79z5gCL8SChEIuLCKGfED
	I
X-Gm-Gg: ASbGncvqIpVgn3lw1FXw9EZCMpkuRFyxiFHisJfATvqUwLkVtUrkk+xekiRmAazQOAk
	rrvV4pdr8M/PbEWSCnQ/+ggtiXJPDqVW36XrmKNU8TVDXDMxv11aBn4PcTDpVjCv1pWfqSRFHky
	vvUWgShNFRU0fn5HYbTDHk9wEGVFKzwPB1/VDyKNKlx4rRYDLFaHMyglgSpwKxEakw+uPvRxEDT
	0ugHX34dsSPJZX+D0zMkVzc6pI0T4H2PprFEcCunQ==
X-Google-Smtp-Source: AGHT+IFcbJHs45sS+9Xvy4JwIrJ1eut9tKp+0CbdXcRg+snaemQgrSDo0z0cwi84eQ1NC0vOevjOfA==
X-Received: by 2002:a05:6a00:21ca:b0:727:3fd5:b530 with SMTP id d2e1a72fcca58-72dafb36d75mr802226b3a.15.1737069434152;
        Thu, 16 Jan 2025 15:17:14 -0800 (PST)
Received: from localhost ([2a03:2880:ff:16::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72dabacdb13sm525506b3a.168.2025.01.16.15.17.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:13 -0800 (PST)
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
Subject: [PATCH net-next v11 04/21] net: page_pool: create hooks for custom memory providers
Date: Thu, 16 Jan 2025 15:16:46 -0800
Message-ID: <20250116231704.2402455-5-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250116231704.2402455-1-dw@davidwei.uk>
References: <20250116231704.2402455-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Pavel Begunkov <asml.silence@gmail.com>

A spin off from the original page pool memory providers patch by Jakub,
which allows extending page pools with custom allocators. One of such
providers is devmem TCP, and the other is io_uring zerocopy added in
following patches.

Co-developed-by: Jakub Kicinski <kuba@kernel.org> # initial mp proposal
Link: https://lore.kernel.org/netdev/20230707183935.997267-7-kuba@kernel.org/
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
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
index c250db6993d3..48833c1dcbd4 100644
--- a/net/core/devmem.c
+++ b/net/core/devmem.c
@@ -15,6 +15,7 @@
 #include <net/netdev_queues.h>
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
 #include <trace/events/page_pool.h>
 
 #include "devmem.h"
@@ -26,6 +27,8 @@
 /* Protected by rtnl_lock() */
 static DEFINE_XARRAY_FLAGS(net_devmem_dmabuf_bindings, XA_FLAGS_ALLOC1);
 
+static const struct memory_provider_ops dmabuf_devmem_ops;
+
 static void net_devmem_dmabuf_free_chunk_owner(struct gen_pool *genpool,
 					       struct gen_pool_chunk *chunk,
 					       void *not_used)
@@ -117,6 +120,7 @@ void net_devmem_unbind_dmabuf(struct net_devmem_dmabuf_binding *binding)
 		WARN_ON(rxq->mp_params.mp_priv != binding);
 
 		rxq->mp_params.mp_priv = NULL;
+		rxq->mp_params.mp_ops = NULL;
 
 		rxq_idx = get_netdev_rx_queue_index(rxq);
 
@@ -142,7 +146,7 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 	}
 
 	rxq = __netif_get_rx_queue(dev, rxq_idx);
-	if (rxq->mp_params.mp_priv) {
+	if (rxq->mp_params.mp_ops) {
 		NL_SET_ERR_MSG(extack, "designated queue already memory provider bound");
 		return -EEXIST;
 	}
@@ -160,6 +164,7 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 		return err;
 
 	rxq->mp_params.mp_priv = binding;
+	rxq->mp_params.mp_ops = &dmabuf_devmem_ops;
 
 	err = netdev_rx_queue_restart(dev, rxq_idx);
 	if (err)
@@ -169,6 +174,7 @@ int net_devmem_bind_dmabuf_to_queue(struct net_device *dev, u32 rxq_idx,
 
 err_xa_erase:
 	rxq->mp_params.mp_priv = NULL;
+	rxq->mp_params.mp_ops = NULL;
 	xa_erase(&binding->bound_rxqs, xa_idx);
 
 	return err;
@@ -388,3 +394,10 @@ bool mp_dmabuf_devmem_release_page(struct page_pool *pool, netmem_ref netmem)
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
index 9733206d6406..24e2e2efb1eb 100644
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
2.43.5


