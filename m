Return-Path: <io-uring+bounces-4161-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC139B5666
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 00:06:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F29A91F23E6A
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 23:06:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E29BD20C03F;
	Tue, 29 Oct 2024 23:06:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="zxg9JZv+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00A820C026
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 23:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730243168; cv=none; b=OBCgB1ysmMAM3Tr3t2KbxrsCN2940hvXiFmkR/eZM9n6DNv+gs4QCrc37b/WEO3oUMJWcoNrExDkOUgH514eDlPVTgWYPoaEx/kd85OSU9hPpwybER65UfxyVOLFrPZudlt/oIvR7VUrZEompD8aDO7W4ohJ7fMA6B1Q78sOkw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730243168; c=relaxed/simple;
	bh=89Bp0oZ2BOmf5uCIKFKyoWYm/7ULInna3cvf7XCxcog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=crsYjPYeAmm7VvSuY1cYYsfUB+FuT0oJLZF7H0ZM/5xShRtTS2Cy2mAxX6v0KoCeVQkVyAhTaD/oAv4QYfraQA1fRF5fcGI/rVnm9jmoRSC7m7c9lvMn0akG/ChsBgLasuhTfRVuKUO6oe+ooLW+55WhutT2+OtsQ4kqOePBgcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=zxg9JZv+; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-20cbca51687so56400775ad.1
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 16:06:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1730243166; x=1730847966; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZQ+z4LZe+3hLij7urnws1Z9lmMZkjsHwRtyYTTLmPFQ=;
        b=zxg9JZv+6dZ+5cXq5Kn+6F5+zpR4uW15J5bIZPBT2LYKuMUQ/JHc1DszI5LDSaoKxz
         G41QqmFluirgfENzZL2qtmID4zidiX1tt5uRbg++cDw6u4ub0r3VCrxyXPvduTEwU97A
         UVqJA5sXtQyFuVfDVU+Ty4NFzUeZSP0DKGT8zEPQsUJujC9jIpoRPhz3+lGJS2kQ8Nmv
         1CTU+W7DCPmxiyXb45a7WPAoO6YQGquFGhTHv1F2javZVwej6owzhv4ubfrkIJwempX9
         xOOoWsZnFcG/h488NTcpBrUOYADI7QNLrHpYDr354QsWvM5EJScz8DgBJT9Y9Xv6IswL
         HOYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730243166; x=1730847966;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQ+z4LZe+3hLij7urnws1Z9lmMZkjsHwRtyYTTLmPFQ=;
        b=XKkTAjUfCuMkT8W7m4qp0ItrYNGxsTbjote2v4xOEP6N6YBpwnbnljSdLOCzF3RZ22
         AhYziG30NMdH/wq3vEahVORVhgpZvIMZ++pA+OjP/gPeY4MrUOvuEsY+IDAt1FyQoDM2
         GeTEzOTrRZc9qmfYr+ro6FPzlxjrGOJzBghJIuDg4Ic3AmO6TfubUAu3UYbwtDssJwHU
         li0xPMlpULoR+twr442r3AsQrTxuFqOSedE0YOeBuUMftXyf0VYbHMsYnOeT2hEDNryt
         XDV/cUo8Ktci4oumgRP0INATMAhtbc8/bctj2IR5673vUV8nGMW87jg2HrWR2VBuy+/i
         q9XQ==
X-Gm-Message-State: AOJu0YyRWnjnQlhoF21XccdBcOA1a71W38zZri6JQ/nOo4APzTcF/Hno
	CZfOkmISR4jrvgIJ6N2bNkgGhJC3WU1/bS9KrjU0qRIWWjkUxRdRFWbsEgHfn6y98DLsMYnTF2v
	w93U=
X-Google-Smtp-Source: AGHT+IHjuANZAW3TvhtdD6oXCsd9MFh33Q9JELmAs4hrgwPZUyadFVAGtfNtElEXcxMaxIFjJEuTCw==
X-Received: by 2002:a17:903:2284:b0:20c:8907:902 with SMTP id d9443c01a7336-210c6c92159mr141610155ad.49.1730243166167;
        Tue, 29 Oct 2024 16:06:06 -0700 (PDT)
Received: from localhost (fwdproxy-prn-019.fbsv.net. [2a03:2880:ff:13::face:b00c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210f0bee05asm14002455ad.250.2024.10.29.16.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 16:06:05 -0700 (PDT)
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
Subject: [PATCH v7 06/15] net: page pool: add helper creating area from pages
Date: Tue, 29 Oct 2024 16:05:09 -0700
Message-ID: <20241029230521.2385749-7-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20241029230521.2385749-1-dw@davidwei.uk>
References: <20241029230521.2385749-1-dw@davidwei.uk>
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


