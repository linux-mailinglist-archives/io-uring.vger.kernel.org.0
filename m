Return-Path: <io-uring+bounces-6374-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8436BA32F16
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 20:00:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BF480188B1B5
	for <lists+io-uring@lfdr.de>; Wed, 12 Feb 2025 18:59:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3782261378;
	Wed, 12 Feb 2025 18:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="zAher6st"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 579012627ED
	for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 18:59:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739386752; cv=none; b=GmaMAj39kDcLnoAKuLuZWnFZX0CzIvtQbg2RVfuYza2BjZk/gDl0hcy7qVimOmP0JO5zQz9SXkw2vFK5r+sMEb3Y3SHEMAb8ZKPUtPZmTOd+Kle1oou5idBU/AQQ+dAW8mQTq0FMJeK+HD4e+eyrJc/g2fpOJe3kxBZC0S00QGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739386752; c=relaxed/simple;
	bh=La2d554WIvdRbco+6aiE0S+APfsYY4f7vvV20WZ9OCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P4kUiw5VSGZpvn6tUR4xVQJdZBGKjzDQ1Z9HD9L01KSUF41FjwPQcK47+TQxrTVo7/QRbjL4pmpWsWLV5AfWSJTGE/mtUv9PEXt6Aq3efs457xCQ9gwerGH4wgjaIYDIsHHZoIL6MiuJDUfr4Z2aC1l0qWBUyyUEbB75XVpEZiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=zAher6st; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-21f62cc4088so92684295ad.3
        for <io-uring@vger.kernel.org>; Wed, 12 Feb 2025 10:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739386751; x=1739991551; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mrlDmtSIgjlht2CbqQZMWAO7KO8Ux0SWPg2kOLAtlYk=;
        b=zAher6sthTnLrWgfqXLRyrmEy5mprZKtruQY3kXseCRP7qd4gGU07SWJm2/W3sZ+r7
         U0nLdZgtA7CeT5wMltki0rfRmIO9em5vziwVaMDppbFvUL9opyqIsMCVsNTWJ98ybR1G
         gb7gS4uMRtEXNNjRkbr70HAz9N/+NrS/VcKJHqrw9g0NdWz8attHyEQ8VQcaV/zBS5U9
         q/kQKV/P+6Pxeowz5ymos7bANZcLJYVGjphryEYGfvNJGzOAIr6oEAfHsUoyVrtr4w1i
         V5BMuimUnoe/jiW4iSW1DJlRRyq8VC3ZBZs3D9mNHCj7n3Q8x8heTWvtKAh6W1MYnJWB
         Vq7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739386751; x=1739991551;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mrlDmtSIgjlht2CbqQZMWAO7KO8Ux0SWPg2kOLAtlYk=;
        b=utEn9dCn/syhNGXJk9+44Io06MO8ygdm7nzJnKFLcC+PZCQfTeMDUnblDPRmEaXanT
         CFI4KwcnagyvX8Nu4VAkaMqTR/TgtPvmhw30EBvfN/HmbjFGSognMcBKBH6JawQet9X+
         UaU4G74MFogK0iSFTSEhmlWa+KLFWEUtIaIvuemyu/cUGm6z53xJfTVIMyO5zojwhKZ2
         zBOUVlrjldgfO4zk0jPyCoD5cQiXt4Y55hWVyYdjJnlvLjRMTeQLR89hJkDrOP+beS7y
         ly2YsKhi1QcUY54dS7jbbmXCiaZBzo87GyMwIfnk4Av0jzmJDxe3PfhHlgHGpG4v78NU
         1a/Q==
X-Gm-Message-State: AOJu0Yz1tU3rF0u7V3TA295Ctk8FxbM/dvZlVok2rYTiSvEC+CZ5elSb
	wQqXP67WYNNISoB6keELj2vFWJmH7oLLepZhvOv2dtpZ63TsdBGpDyEIIr6dfyrobFfkSY2xRyK
	p
X-Gm-Gg: ASbGnctDu/n42gnJL9y1xy+2WpM+szUm1kbiCvxYM6Wu3+DPO3RhhFNDnZlPGDRSY2C
	9DIYQ/UcneoOfBDRhkW1hTPb/DNK1WOSeNS0ZQd6SR31LAtsa0reRUn4jnhQ4u3/M/tSCdhzfyD
	ptD6CBduGyks/Kb3vMw01gmmEuCpGoaYC7IC0262x0WTN8jzqV5RaaPFtbMMcuCLjjmuCXAPEeI
	n5Ccq1xedif13XPjOa0MyOUleWh2PYEEUmWVys42M5vn8EhwCj4T13e9HgTEvEu5qdMg3+5qNo=
X-Google-Smtp-Source: AGHT+IEZJusJL1G3pK2f3od/jlvu2y3vpzU5BWhs9T8/VJOaDxw/kjsspjK/5SVrYO0RQw2aL69W6A==
X-Received: by 2002:a05:6a20:748e:b0:1e0:c56f:7db4 with SMTP id adf61e73a8af0-1ee6b2e1dacmr945796637.2.1739386750709;
        Wed, 12 Feb 2025 10:59:10 -0800 (PST)
Received: from localhost ([2a03:2880:ff:2::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73048bf1421sm11755460b3a.101.2025.02.12.10.59.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Feb 2025 10:59:10 -0800 (PST)
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
Subject: [PATCH net-next v13 05/11] io_uring/zcrx: dma-map area for the device
Date: Wed, 12 Feb 2025 10:57:55 -0800
Message-ID: <20250212185859.3509616-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250212185859.3509616-1-dw@davidwei.uk>
References: <20250212185859.3509616-1-dw@davidwei.uk>
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
 io_uring/zcrx.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++-
 io_uring/zcrx.h |  1 +
 2 files changed, 82 insertions(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 9d5c0479a285..4f7767980000 100644
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
@@ -20,6 +21,73 @@
 #include "zcrx.h"
 #include "rsrc.h"
 
+#define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
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
+		dma_unmap_page_attrs(ifq->dev, dma, PAGE_SIZE,
+				     DMA_FROM_DEVICE, IO_DMA_ATTR);
+		net_mp_niov_set_dma_addr(niov, 0);
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
+	int i;
+
+	for (i = 0; i < area->nia.num_niovs; i++) {
+		struct net_iov *niov = &area->nia.niovs[i];
+		dma_addr_t dma;
+
+		dma = dma_map_page_attrs(ifq->dev, area->pages[i], 0, PAGE_SIZE,
+					 DMA_FROM_DEVICE, IO_DMA_ATTR);
+		if (dma_mapping_error(ifq->dev, dma))
+			break;
+		if (net_mp_niov_set_dma_addr(niov, dma)) {
+			dma_unmap_page_attrs(ifq->dev, dma, PAGE_SIZE,
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
@@ -82,6 +150,8 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 
 static void io_zcrx_free_area(struct io_zcrx_area *area)
 {
+	io_zcrx_unmap_area(area->ifq, area);
+
 	kvfree(area->freelist);
 	kvfree(area->nia.niovs);
 	kvfree(area->user_refs);
@@ -271,6 +341,10 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EOPNOTSUPP;
 	get_device(ifq->dev);
 
+	ret = io_zcrx_map_area(ifq, ifq->area);
+	if (ret)
+		goto err;
+
 	reg.offsets.rqes = sizeof(struct io_uring);
 	reg.offsets.head = offsetof(struct io_uring, head);
 	reg.offsets.tail = offsetof(struct io_uring, tail);
@@ -423,6 +497,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 			continue;
 		}
 
+		io_zcrx_sync_for_device(pp, niov);
 		net_mp_netmem_place_in_cache(pp, netmem);
 	} while (--entries);
 
@@ -440,6 +515,7 @@ static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
 		netmem_ref netmem = net_iov_to_netmem(niov);
 
 		net_mp_niov_set_page_pool(pp, niov);
+		io_zcrx_sync_for_device(pp, niov);
 		net_mp_netmem_place_in_cache(pp, netmem);
 	}
 	spin_unlock_bh(&area->freelist_lock);
@@ -483,10 +559,14 @@ static int io_pp_zc_init(struct page_pool *pp)
 
 	if (WARN_ON_ONCE(!ifq))
 		return -EINVAL;
-	if (pp->dma_map)
+	if (WARN_ON_ONCE(ifq->dev != pp->p.dev))
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
index 6c808240ac91..1b6363591f72 100644
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


