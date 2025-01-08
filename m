Return-Path: <io-uring+bounces-5770-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id F3798A067EC
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 23:09:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7096D1886E74
	for <lists+io-uring@lfdr.de>; Wed,  8 Jan 2025 22:08:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B437C205AAC;
	Wed,  8 Jan 2025 22:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="d/5VWW91"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BFB920551F
	for <io-uring@vger.kernel.org>; Wed,  8 Jan 2025 22:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736374045; cv=none; b=GIZ11DK4AJu5lYF7kTQ3LdmTZwVOH08hUsRpq+QocM7IL4j5RMaEHz1zNCKyVXzrnJKxjMq7J7KqEks5zKfmDyr3X1zmZU+UuBqtOyT0m66JiAGQa9fJrvYoYJ8P7uG4bb5/MCcYNRc/t6eDynN46rtsboJC5C4YY9V1P7gWjok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736374045; c=relaxed/simple;
	bh=yuITOvVTI1jyxUeP1TltVKMBQAsbuKeDYQ08bxcQKnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=an5ieeEa9cgOKulqesDqnT9StIOHbhNLdrvsGanibyHEERgneillNWmDUb99k35+6z1dhahw9eGP0Q9yfKWWiNbIESI4lacPg7LTTW7kEZB47QcCcNzVpKUXTAH8j6bEgOZzNXobAJM6yyftCs0KwxY7AVW8Gqns5L/YxBBkY4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=d/5VWW91; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2efe25558ddso379945a91.2
        for <io-uring@vger.kernel.org>; Wed, 08 Jan 2025 14:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1736374043; x=1736978843; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qXCSv20CUAs31SZq5vRMJYKkS1QpcQw/HpUfxHdkGGk=;
        b=d/5VWW91iRDiLx/1NvTjzvHtLqHBR4s/wUKt9VvEOw+izUid5PmH6Rog+MueWEgbeE
         3iI3mIpoLQ4cNjz808Oi+j/Z1iN8vw6qeWkH4mU9iK5iKS0yGuv8MNwwWUYR2MYRKLfu
         Bg5l3B7bNYQQt+hPRznbJk4L4K0JcdUcAJTEAPXUuRhFXnsomGF2kLl91CF4M1jifT6l
         BPXpf4HNFjCc957NwdrCBAoIryHj1kXLRKuNDmN9cQzhPjUNwnnsB+x0vNhtTiO75NVJ
         L8wIXE4wSKquWsWDh5LXFfRmGQt5ao72CXO/FUWiMNa5FadAs05FGavvcn0Av/MW/PoE
         KyGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736374043; x=1736978843;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qXCSv20CUAs31SZq5vRMJYKkS1QpcQw/HpUfxHdkGGk=;
        b=gO8vG5eUUSWJWFoSp+X5fUHDDGj3wfEwZoDG0j3JvxTcahwk28SSH/Nsh4cJ/3KxiW
         FMbT7h3jfefj99EQftdnNAkJDaIhd8icaBXUNQ9xrhQ1AgNbLFfsjBSaIfCb7sjnnNmD
         mlySR2//+YVKGHwJ/OMWlP1kRDiykZ5xQoR/HqvKA3FNKVhQSDbZe4zCm9TVZLRVf7V8
         hsI8/POwp5Jc5YxiSliQP4jXmL2drZLuBNohgCfgnf3rGrEOkZMiidcj+oOynXQVeo++
         CVWFVm3fpINBmMQq+2GQKTybnswwnyEsIR2IPht9TEbzufVZje9JDkYacSRS6IiHi7wa
         9G6Q==
X-Gm-Message-State: AOJu0YziQw5YDTWLr7D2gt0aFjm1YjWSzrVLbQGi02Jst5SZuWcz86b5
	lg3Ftg/OoWjocK08C32DLd4zA+4vKfXw5Q4TQdsP+3mo3SgRwV0puHy+eS+ai5wfNsplfDoJ2ct
	v
X-Gm-Gg: ASbGnct5XJszkODmvwjc5CbMf4Ic5dZmrsIVQBlDnyx+Hq65nIJI885Vb2kudMn6BIC
	rK2Yair0lNvgEiRoncwy+VInpgJ8D+3zyjfjM1goxvWdnswcGd0ABCQvml2irfFpNn3qqixxiWE
	zHcy4jxh1ktoZAaYf4i4VgkJiiX1iiR61cbh98eAG7ZGMlXKGt75BTvC5Ivbd6Sos4hgX12s3v9
	vDmpdEX9kh/vCMZyPQM6xfKx7xymuLR8XNe8BeJFg==
X-Google-Smtp-Source: AGHT+IFKJUu89PWR7Fg4XdSIPhiSlLCqULnhKxNJk2G4NuluyqVlESPDGHgFeuxGcBUFOp/s+cAeug==
X-Received: by 2002:a17:90b:520e:b0:2f2:ab09:c256 with SMTP id 98e67ed59e1d1-2f548f424b1mr6405397a91.33.1736374043564;
        Wed, 08 Jan 2025 14:07:23 -0800 (PST)
Received: from localhost ([2a03:2880:ff:21::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9f6951sm332840325ad.171.2025.01.08.14.07.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jan 2025 14:07:23 -0800 (PST)
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
Subject: [PATCH net-next v10 16/22] io_uring/zcrx: dma-map area for the device
Date: Wed,  8 Jan 2025 14:06:37 -0800
Message-ID: <20250108220644.3528845-17-dw@davidwei.uk>
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

Setup DMA mappings for the area into which we intend to receive data
later on. We know the device we want to attach to even before we get a
page pool and can pre-map in advance. All net_iov are synchronised for
device when allocated, see page_pool_mp_return_in_cache().

Reviewed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/zcrx.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++-
 io_uring/zcrx.h |  1 +
 2 files changed, 91 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 64e86d14acc7..273bad4d86a2 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 #include <linux/kernel.h>
 #include <linux/errno.h>
+#include <linux/dma-map-ops.h>
 #include <linux/mm.h>
 #include <linux/nospec.h>
 #include <linux/io_uring.h>
@@ -21,6 +22,82 @@
 #include "zcrx.h"
 #include "rsrc.h"
 
+#define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
+
+static struct device *io_zcrx_get_device(struct io_zcrx_ifq *ifq)
+{
+	return ifq->dev->dev.parent;
+}
+
+static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
+				 struct io_zcrx_area *area, int nr_mapped)
+{
+	int i;
+
+	for (i = 0; i < nr_mapped; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+		dma_addr_t dma;
+
+		dma = page_pool_get_dma_addr_netmem(net_iov_to_netmem(niov));
+		dma_unmap_page_attrs(io_zcrx_get_device(ifq), dma, PAGE_SIZE,
+				     DMA_FROM_DEVICE, IO_DMA_ATTR);
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
+	struct device *dev = io_zcrx_get_device(ifq);
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
+static void io_zcrx_sync_for_device(const struct page_pool *pool,
+				    struct net_iov *niov)
+{
+#if defined(CONFIG_HAS_DMA) && defined(CONFIG_DMA_NEED_SYNC)
+	dma_addr_t dma_addr;
+
+	if (!dma_dev_need_sync(pool->p.dev))
+		return;
+
+	dma_addr = page_pool_get_dma_addr_netmem(net_iov_to_netmem(niov));
+	__dma_sync_single_for_device(pool->p.dev, dma_addr + pool->p.offset,
+				     PAGE_SIZE, pool->p.dma_dir);
+#endif
+}
+
 #define IO_RQ_MAX_ENTRIES		32768
 
 __maybe_unused
@@ -83,6 +160,8 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 
 static void io_zcrx_free_area(struct io_zcrx_area *area)
 {
+	io_zcrx_unmap_area(area->ifq, area);
+
 	kvfree(area->freelist);
 	kvfree(area->nia.niovs);
 	kvfree(area->user_refs);
@@ -254,6 +333,10 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 	if (!ifq->dev)
 		goto err;
 
+	ret = io_zcrx_map_area(ifq, ifq->area);
+	if (ret)
+		goto err;
+
 	reg.offsets.rqes = sizeof(struct io_uring);
 	reg.offsets.head = offsetof(struct io_uring, head);
 	reg.offsets.tail = offsetof(struct io_uring, tail);
@@ -404,6 +487,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 			continue;
 		}
 
+		io_zcrx_sync_for_device(pp, niov);
 		net_mp_netmem_place_in_cache(pp, netmem);
 	} while (--entries);
 
@@ -421,6 +505,7 @@ static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
 		netmem_ref netmem = net_iov_to_netmem(niov);
 
 		net_mp_niov_set_page_pool(pp, niov);
+		io_zcrx_sync_for_device(pp, niov);
 		net_mp_netmem_place_in_cache(pp, netmem);
 	}
 	spin_unlock_bh(&area->freelist_lock);
@@ -466,10 +551,14 @@ static int io_pp_zc_init(struct page_pool *pp)
 		return -EINVAL;
 	if (WARN_ON_ONCE(ifq->dev != pp->slow.netdev))
 		return -EINVAL;
-	if (pp->dma_map)
+	if (WARN_ON_ONCE(io_zcrx_get_device(ifq) != pp->p.dev))
+		return -EINVAL;
+	if (WARN_ON_ONCE(!pp->dma_map))
 		return -EOPNOTSUPP;
 	if (pp->p.order != 0)
 		return -EOPNOTSUPP;
+	if (pp->p.dma_dir != DMA_FROM_DEVICE)
+		return -EOPNOTSUPP;
 
 	percpu_ref_get(&ifq->ctx->refs);
 	return 0;
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index f31c8006ca9c..beacf1ea6380 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -11,6 +11,7 @@ struct io_zcrx_area {
 	struct io_zcrx_ifq	*ifq;
 	atomic_t		*user_refs;
 
+	bool			is_mapped;
 	u16			area_id;
 	struct page		**pages;
 
-- 
2.43.5


