Return-Path: <io-uring+bounces-3448-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C2CD09939FB
	for <lists+io-uring@lfdr.de>; Tue,  8 Oct 2024 00:17:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C948D1C2258F
	for <lists+io-uring@lfdr.de>; Mon,  7 Oct 2024 22:17:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1405018FDAC;
	Mon,  7 Oct 2024 22:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ppftiPl4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9117D1917EC
	for <io-uring@vger.kernel.org>; Mon,  7 Oct 2024 22:16:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728339398; cv=none; b=GZwqnBTqeWU0YkaQsq32zDyPCjpqq7/xc+XxXYWgnepNESO7LetqGV5JrvVQ0sDsikX2XyqZNK6Issgqfdq+TvTRYFDmGWmfAoyXpgjVdEOwazP0E/M9tm4a+J+Y4Lo9eDmUao8zMA0+XbH0VozxYzr3pYjTx9hrKWUft6KFCa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728339398; c=relaxed/simple;
	bh=Yblnr5AMNf8RSN/GJ4PgNWOte80ZkvI1vRY4B3QrYq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F08SXW96nojCSXO+CfLBGVG6lqyIVPpR0Yj8pe13EPrNwdRItgKUuYKEO598pEBNopL5JKrt6tZc7n7DYXNDD5tnkuF9PoM3Ut4V+f/9IGva/ajfOBJs+CRUL7sRXPm3quYzwUX0PC1ownCNqRB49ouw7SWc0+y1Gu6INzN32Z8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ppftiPl4; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-71e0cd1f3b6so780184b3a.0
        for <io-uring@vger.kernel.org>; Mon, 07 Oct 2024 15:16:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1728339396; x=1728944196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KSYwmGSWU8/HOUW5E/L1560L8milEKARxaMDCraERqM=;
        b=ppftiPl4hdTfPuzyfkZQk3OYsZ0Ve+EXSi1hJpjXmncP1U+ZKT2KlTgZfWMlt2W5JH
         1oj/nDxaqHFYjfX/mA0xo70pb4ngm71iGG5ZOgBZS9+UKPjXcOjc+S6Ql4ZtBNOq7zvR
         J1bweY5OjD4WFjuiswNSdE/cAfS5VGLEFrCc3KwaTsDHOPcK5h4kU/lXIX+NNSPKtqbM
         aMojM9OXXy1dEVnIIb6p+cXfZ6U6lOGPBusi1Vy9be37gAxQm+rsQdPmvC0fbIoLSkDS
         wyvafKrYT7a8yNuZpM2VfBC//xKES/MSiXe0JHRD5oVaANNJl2X11Yo3z/UVy7ztXptk
         jX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728339396; x=1728944196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KSYwmGSWU8/HOUW5E/L1560L8milEKARxaMDCraERqM=;
        b=uZekSSaUsSvSpbsTPats8LVpK+Flj7fXeW4Vv1zSSJW94xWnW0eDozIfuOecZKBWHv
         zL7ayJCn8eCajFsDpm3UXCIpPQ8uN/aJQF3ApDBJ7y/zgmNL+0fJdGpzLCwlEeCskHrx
         zkzXwM/YxkRy1IgIVm4wFC1bClW1CqBW/YvJWPJmaaf7dQGb4APPciW5xJH6cc6KtfNR
         Oj790Z+kakuGWEpkDgANqyFJ11jnlxqQ2zkFPk5/HG9Bt7yxN6k1mQ60ORu99t+oEGAd
         wWHsGj3JfPliJ0UuRl66f7ef+WBKVXEbujnj+qqL9X0tmpYBKtidnR2X3bkr9H1NYliJ
         aBlA==
X-Gm-Message-State: AOJu0YwIChiTW0ZPHOhJJo61Sbe/t3ES5zK/jRbDbDAtyXcUC2e1BmGD
	xG0gst4derL8ilWCs9NZqNNDj8UnSKItbVGfkCJlJxNb6vfdWTGkqa6zQ0Mtmv6l/fe9EiFrtEw
	j
X-Google-Smtp-Source: AGHT+IF/ExXILoxc9I6iabRffL3xjpaSDIYhIvzLL5wAq4E+cSysf3izJGWwISFwqNSIWYASOBriaA==
X-Received: by 2002:a05:6a00:b42:b0:71e:48b:6422 with SMTP id d2e1a72fcca58-71e048b6681mr7200675b3a.2.1728339396016;
        Mon, 07 Oct 2024 15:16:36 -0700 (PDT)
Received: from localhost (fwdproxy-prn-116.fbsv.net. [2a03:2880:ff:74::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d451cesm4909496b3a.110.2024.10.07.15.16.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Oct 2024 15:16:35 -0700 (PDT)
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
Subject: [PATCH v1 07/15] net: page pool: add helper creating area from pages
Date: Mon,  7 Oct 2024 15:15:55 -0700
Message-ID: <20241007221603.1703699-8-dw@davidwei.uk>
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

Add a helper that takes an array of pages and initialises passed in
memory provider's area with them, where each net_iov takes one page.
It's also responsible for setting up dma mappings.

We keep it in page_pool.c not to leak netmem details to outside
providers like io_uring, which don't have access to netmem_priv.h
and other private helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 include/net/page_pool/types.h | 17 ++++++++++
 net/core/page_pool.c          | 61 +++++++++++++++++++++++++++++++++--
 2 files changed, 76 insertions(+), 2 deletions(-)

diff --git a/include/net/page_pool/types.h b/include/net/page_pool/types.h
index fd0376ad0d26..1180ad07423c 100644
--- a/include/net/page_pool/types.h
+++ b/include/net/page_pool/types.h
@@ -271,6 +271,11 @@ void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *),
 			   const struct xdp_mem_info *mem);
 void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 			     int count);
+
+int page_pool_init_paged_area(struct page_pool *pool,
+			      struct net_iov_area *area, struct page **pages);
+void page_pool_release_area(struct page_pool *pool,
+			    struct net_iov_area *area);
 #else
 static inline void page_pool_destroy(struct page_pool *pool)
 {
@@ -286,6 +291,18 @@ static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
 					   int count)
 {
 }
+
+static inline int page_pool_init_paged_area(struct page_pool *pool,
+					    struct net_iov_area *area,
+					    struct page **pages)
+{
+	return -EOPNOTSUPP;
+}
+
+static inline void page_pool_release_area(struct page_pool *pool,
+					  struct net_iov_area *area)
+{
+}
 #endif
 
 void page_pool_put_unrefed_netmem(struct page_pool *pool, netmem_ref netmem,
diff --git a/net/core/page_pool.c b/net/core/page_pool.c
index 9a675e16e6a4..112b6fe4b7ff 100644
--- a/net/core/page_pool.c
+++ b/net/core/page_pool.c
@@ -459,7 +459,8 @@ page_pool_dma_sync_for_device(const struct page_pool *pool,
 		__page_pool_dma_sync_for_device(pool, netmem, dma_sync_size);
 }
 
-static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem)
+static bool page_pool_dma_map_page(struct page_pool *pool, netmem_ref netmem,
+				   struct page *page)
 {
 	dma_addr_t dma;
 
@@ -468,7 +469,7 @@ static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem)
 	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
 	 * This mapping is kept for lifetime of page, until leaving pool.
 	 */
-	dma = dma_map_page_attrs(pool->p.dev, netmem_to_page(netmem), 0,
+	dma = dma_map_page_attrs(pool->p.dev, page, 0,
 				 (PAGE_SIZE << pool->p.order), pool->p.dma_dir,
 				 DMA_ATTR_SKIP_CPU_SYNC |
 					 DMA_ATTR_WEAK_ORDERING);
@@ -490,6 +491,11 @@ static bool page_pool_dma_map(struct page_pool *pool, netmem_ref netmem)
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
@@ -1154,3 +1160,54 @@ void page_pool_update_nid(struct page_pool *pool, int new_nid)
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
+int page_pool_init_paged_area(struct page_pool *pool,
+			      struct net_iov_area *area, struct page **pages)
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
+void page_pool_release_area(struct page_pool *pool,
+			    struct net_iov_area *area)
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


