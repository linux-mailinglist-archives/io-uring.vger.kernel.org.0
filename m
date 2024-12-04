Return-Path: <io-uring+bounces-5219-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F68E9E441D
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 20:07:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 56077BE0816
	for <lists+io-uring@lfdr.de>; Wed,  4 Dec 2024 17:57:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6972214A6D;
	Wed,  4 Dec 2024 17:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="OxZni3Gl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FEC0214A60
	for <io-uring@vger.kernel.org>; Wed,  4 Dec 2024 17:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733332971; cv=none; b=JlmcDjpXDcgCQFIT6c5L8TazxHDcE61KyJAk7ysWzbI6cEuFyzpk/KBiVvdrYfKvkDYpW1l57w14H2XRZ2tetMjF2VrvBAY+tdRvi8ZebJqJ8AmNxnPvmVhWdJsMwIDDmxK4oqlPPALjLnSuYutok2aNNTZZW6dpWm3z1j04Un4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733332971; c=relaxed/simple;
	bh=2Ly0e5Yijxu/LfGPalbYYW0IDXn2bJJLdjQ35I/F9lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/fhlgTEbR1ywtrpALnyJMKWwhU71zTM8avnBKZHWOZtw2IRY+mq22IZGgX+fYK+13PEda6r09ojKpUwmOFui2TuXr/QKmVtbEtWmm5WeP15RLm6ST/768lG6hK4E5fX722J4D0PMV/Rw4evH+QvcH6vxUquypm4XGHwfzvnodc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=OxZni3Gl; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2eecc01b5ebso58311a91.1
        for <io-uring@vger.kernel.org>; Wed, 04 Dec 2024 09:22:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1733332970; x=1733937770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vVA+/b4qCsGeF/r3+y87HajxoHUhHCxTyMRpyjDTudI=;
        b=OxZni3GluqnhCSfAC2Z1Kc277FqzUyf6VKnVMYqXM5rI+eZLuiG2nwAgKSVosuAVg0
         WbLkVx3S4Suk0nPcbyKvIrKi/N2K8wUtox1nKDXYbwWcBl72lsg2CQoILEUfTpJMmjdF
         2nhR64Cuo3WYDKBiNaJvpH2hUoDq81Y0/3bYyk5Ciqge0q8jFjLOD/VLGRq9j+nFjeaq
         Oo1lSWhNl8zPQyH8WrsgdXN/H0erUEvhyTPc12oRFE7XzRQ7MvWTaBVX09eXEY7+5pai
         naeM+5sorHse8Mjucwp2kvtSBIvhJ5LMGTHEnlpiPcmqm5Q7EJ7N6+qWXbKd/DR7ivZ3
         V+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733332970; x=1733937770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vVA+/b4qCsGeF/r3+y87HajxoHUhHCxTyMRpyjDTudI=;
        b=e2USXPmteRb8VjwEEuHTmjSnik2IG1K6EzLJSKx33+njMJw//blcjFdAH0I8ScDybL
         JFtsOzqs7qObNqq7pOguSDgLDs58W761lJglcMcMRKXln85ehqolhuhOFZDncz4IGmOx
         n0s4DBGTX2ZUGlD4TCyTy1dj90aYH3S++hX/g6nTgn/NWmESaG3RhHLAR3+r6gbf5t56
         cvUZYEt1C32YtKduDgY3PFrb/9icY929IKtyG+HjhBFBxxRSpBguCbazM8jMSzfOhy4g
         mAeADdDhVhsNutGoOUUk59nMJJwMULCfGrn+ct73qS/cdnnXAZxt4Qs31t0uf54Fiw91
         9y2A==
X-Gm-Message-State: AOJu0YwoDiy8NrMmFC8BzFNtQjH2ZM7ti2ye6YrawDiaPX71RmAEITyP
	0xRXX0U9V+xvXCCPORRvIUQ//GSqA7nqXuJGmzeX/i87HfjDiCToSrWhssBijcoUBTREeuMkTLo
	2
X-Gm-Gg: ASbGncvzViqOpOO0OGsUzgetPvUlyt+RDuBzNL4KeBJIlPEJjZtfMlnjV9MK23n8hTc
	KWBHbsGlb1cpeE2GTB/ySaF74J+j8gaK4s/qaZAZnX2gXe11no3wKV+waJjvXjmLpJdrvKKDxTw
	XVOCZZpGpUgB5zuT1pCERkqKHo5/MfjZ7J4L4QLpn0KZ4Qa5tuAhRDALAoaQqZv/jHqWCIkAvFG
	J0ZA2lCSQLxwgstYwUQzWEopxw3njIRml0=
X-Google-Smtp-Source: AGHT+IEuhl76LZuTMA9l7NFby+dpNqNLOXPZPUIKpzVvQ3cP55eSMyTH71gxdXUKQ8wKcIyAwFFBwA==
X-Received: by 2002:a17:90b:2547:b0:2ee:fa3f:4740 with SMTP id 98e67ed59e1d1-2ef012759b6mr11280221a91.35.1733332969694;
        Wed, 04 Dec 2024 09:22:49 -0800 (PST)
Received: from localhost ([2a03:2880:ff:16::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2ef2701d9a2sm1681179a91.28.2024.12.04.09.22.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Dec 2024 09:22:49 -0800 (PST)
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
Subject: [PATCH net-next v8 06/17] net: page pool: add helper creating area from pages
Date: Wed,  4 Dec 2024 09:21:45 -0800
Message-ID: <20241204172204.4180482-7-dw@davidwei.uk>
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

Add a helper that takes an array of pages and initialises passed in
memory provider's area with them, where each net_iov takes one page.
It's also responsible for setting up dma mappings.

We keep it in page_pool.c not to leak netmem details to outside
providers like io_uring, which don't have access to netmem_priv.h
and other private helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/memory_provider.h | 10 ++++
 net/core/page_pool.c                    | 63 ++++++++++++++++++++++++-
 2 files changed, 71 insertions(+), 2 deletions(-)
 create mode 100644 include/net/page_pool/memory_provider.h

diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
new file mode 100644
index 000000000000..83d7eec0058d
--- /dev/null
+++ b/include/net/page_pool/memory_provider.h
@@ -0,0 +1,10 @@
+#ifndef _NET_PAGE_POOL_MEMORY_PROVIDER_H
+#define _NET_PAGE_POOL_MEMORY_PROVIDER_H
+
+int page_pool_mp_init_paged_area(struct page_pool *pool,
+				struct net_iov_area *area,
+				struct page **pages);
+void page_pool_mp_release_area(struct page_pool *pool,
+				struct net_iov_area *area);
+
+#endif
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 13f1a4a63760..d17e536ba8b8 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -13,6 +13,7 @@
 
 #include <net/netdev_rx_queue.h>
 #include <net/page_pool/helpers.h>
+#include <net/page_pool/memory_provider.h>
 #include <net/xdp.h>
 
 #include <linux/dma-direction.h>
@@ -459,7 +460,8 @@ page_pool_dma_sync_for_device(const struct page_pool *pool,
 		__page_pool_dma_sync_for_device(pool, netmem, dma_sync_size);
 }
 
-static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem)
+static bool page_pool_dma_map_page(struct page_pool *pool, netmem_ref netmem,
+				   struct page *page)
 {
 	dma_addr_t dma;
 
@@ -468,7 +470,7 @@ static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem)
 	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
 	 * This mapping is kept for lifetime of page, until leaving pool.
 	 */
-	dma = dma_map_page_attrs(pool->p.dev, netmem_to_page(netmem), 0,
+	dma = dma_map_page_attrs(pool->p.dev, page, 0,
 				 (PAGE_SIZE << pool->p.order), pool->p.dma_dir,
 				 DMA_ATTR_SKIP_CPU_SYNC |
 					 DMA_ATTR_WEAK_ORDERING);
@@ -490,6 +492,11 @@ static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem)
 	return false;
 }
 
+static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem)
+{
+	return page_pool_dma_map_page(pool, netmem, netmem_to_page(netmem));
+}
+
 static struct page *__page_pool_alloc_page_order(struct page_pool *pool,
 						 gfp_t gfp)
 {
@@ -1154,3 +1161,55 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
 	}
 }
 EXPORT_SYMBOL(page_pool_update_nid);
+
+static void page_pool_release_page_dma(struct page_pool *pool,
+				       netmem_ref netmem)
+{
+	__page_pool_release_page_dma(pool, netmem);
+}
+
+int page_pool_mp_init_paged_area(struct page_pool *pool,
+				 struct net_iov_area *area,
+				 struct page **pages)
+{
+	struct net_iov *niov;
+	netmem_ref netmem;
+	int i, ret = 0;
+
+	if (!pool->dma_map)
+		return -EOPNOTSUPP;
+
+	for (i = 0; i < area->num_niovs; i++) {
+		niov = &area->niovs[i];
+		netmem = net_iov_to_netmem(niov);
+
+		page_pool_set_pp_info(pool, netmem);
+		if (!page_pool_dma_map_page(pool, netmem, pages[i])) {
+			ret = -EINVAL;
+			goto err_unmap_dma;
+		}
+	}
+	return 0;
+
+err_unmap_dma:
+	while (i--) {
+		netmem = net_iov_to_netmem(&area->niovs[i]);
+		page_pool_release_page_dma(pool, netmem);
+	}
+	return ret;
+}
+
+void page_pool_mp_release_area(struct page_pool *pool,
+			       struct net_iov_area *area)
+{
+	int i;
+
+	if (!pool->dma_map)
+		return;
+
+	for (i = 0; i < area->num_niovs; i++) {
+		struct net_iov *niov = &area->niovs[i];
+
+		page_pool_release_page_dma(pool, net_iov_to_netmem(niov));
+	}
+}
-- 
2.43.5


