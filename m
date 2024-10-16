Return-Path: <io-uring+bounces-3745-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A42DC9A11F2
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 20:53:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D4BB283B42
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 18:53:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF71C215F52;
	Wed, 16 Oct 2024 18:53:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="3cWxXEZI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C19215030
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 18:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729104790; cv=none; b=RD2uOkQ3+zflD0+/Nf4MZcXyT6HqtC4L5fPQzp2s4wLm6K/UitRJkneS70maMJ6umbc7+nlyXF3uP8hQJXo8NA4zVjpsa4c2fmIhQTfnAfTl9Zew5hKeY0TUCmOyB4RQM36eyXmQY9X/W7hKps4FlyRti+613p7JgRkn9+BIh4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729104790; c=relaxed/simple;
	bh=89Bp0oZ2BOmf5uCIKFKyoWYm/7ULInna3cvf7XCxcog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGQT2aO2ezRIWp1PayjCV1xGCO+bLjmgzl2DUKjeYzvjm6To9CRQE6s+w25P2lwZ72eWb0HIE5mHPAIn+bEJrXc67//H8QpZ2GgzJac6E2PveIUveVew0FuMj8hgliMyo5J5sKdlU0njcorSs+si5rxunmdLKuFUeu3o81ygfzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=3cWxXEZI; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7ea784aea63so80297a12.3
        for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 11:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1729104789; x=1729709589; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQ+z4LZe+3hLij7urnws1Z9lmMZkjsHwRtyYTTLmPFQ=;
        b=3cWxXEZIeijrrqDZDoEgU2sGeKvjJj88h+ZBDOM6SvQBXh5S28NEOVlBxG5fx5SbjT
         Vx5qyJVVIsVQhbpPAhyoqQTMy1nOKo7YVD4jiD6C+yvbuc+hDUPi2FQko4mqOF/17mAf
         aekn45lVawyfLfxfzLe0olDsZdOWKlUd/cW9WqTEF3MR3SXJeX6TKBhqs0ORwNbd2zwl
         AYD4kXkzHd9jEMx6BmraMeqbS9DmZxxJqo9Khubq4KTQE6wSOp2pmylPvIxoOShrsGyV
         F4sUgupH0yyfb+qV0G4zYIH3GfKh6cuDXh79Gk3+Jy+bz/w7HXXEofRU45OL+fF2lA9l
         BPrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729104789; x=1729709589;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQ+z4LZe+3hLij7urnws1Z9lmMZkjsHwRtyYTTLmPFQ=;
        b=MTTPpFn3gr1mVh/bdSaD4sN2KQsZ32rG/XuArFecS5mHNuFM1vD5VnLB3HHYPb3ZOQ
         HGyboGHK7gFE6u5N1ji8ADOg8iGn6M3CJt0u3HSwDhhTnT8ZeqTsP9I6G9dgoKkZo9YA
         sMkO42qJOmjsP3kdkr4/kXezng/B/y4/cBA0nE7EgHPBpc+vCz4/k/usIaiHRHxP5Wad
         B2Sxx6EKnT2FNeWyJARAx8ae7FW4p5B4qaVF5ERAN2fwDERcBA4RVg2ljPXiu3sfJMHa
         PAVAEix/U+P34Qp22zYMmKU1+Y9pCTbeKYcbL/oJ4GmR1hb8MS6p+7GxN30dLaO9Mn16
         l5wg==
X-Gm-Message-State: AOJu0YwWz+8Hzk1Zc8UinGZD82r1QvjlVNEkOTcZPdGRqcnTpjRlw+bO
	eFbYpLfGiygPiOv2SN13a9BVqVq0WLTdlm9hA2lN3rvNeV+KL4+bVnkPcx1MD13K8NT2JZKRyWa
	P
X-Google-Smtp-Source: AGHT+IFzkiZAp9Acg3DgIEWGxEJph/8lSDTB21GH6rjxRmEXJn+agzFg/+B8FoO//iyFTbUWbbQgbg==
X-Received: by 2002:a05:6a20:c89c:b0:1cc:e14b:cf3b with SMTP id adf61e73a8af0-1d905f115f8mr5394950637.27.1729104788636;
        Wed, 16 Oct 2024 11:53:08 -0700 (PDT)
Received: from localhost (fwdproxy-prn-039.fbsv.net. [2a03:2880:ff:27::face:b00c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e773a2ee0sm3410024b3a.76.2024.10.16.11.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Oct 2024 11:53:08 -0700 (PDT)
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
Subject: [PATCH v6 06/15] net: page pool: add helper creating area from pages
Date: Wed, 16 Oct 2024 11:52:43 -0700
Message-ID: <20241016185252.3746190-7-dw@davidwei.uk>
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
index 9a675e16e6a4..8bd4a3c80726 100644
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


