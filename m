Return-Path: <io-uring+bounces-5940-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D72A1454F
	for <lists+io-uring@lfdr.de>; Fri, 17 Jan 2025 00:19:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 62885188960D
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 23:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 07FA92459D8;
	Thu, 16 Jan 2025 23:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="n1/9xm6J"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CE5E2419FB
	for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 23:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737069446; cv=none; b=op3OgVBBM0PaVA4vDvueshwj9o1AcTfABCslofTFjiACdargVWClgGfkhbd0MrBlHGQz12nIlahjpV1s0SL7m7ix48ywmJAgjoqRIhtp/OLgEV1a+L8Ljd15rYX0RbE6pq3yBhzhr8ohVVl56/3MMUxmxQ1uQq8fYCcxJc3st34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737069446; c=relaxed/simple;
	bh=vJpTlHMNIuxJ3ldJNi4xVGXAD0rwjweUR5uvfqKVMO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Irok3OQESPqzyZoeSFHdtkJfj5L/Szp7aJlCJS9FiE3vapPuyRH3v91jrE10tK1URPVKIXvir2b3SLVuyzsCuoC42B3eH/sNDB6wpAVBsRGC9NFqruAemKSH0AAEeoyligaiUUb6J3wmCLfxjjSg65gLqe8+3FZE9P8y1kyZmC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=n1/9xm6J; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2163dc5155fso27789755ad.0
        for <io-uring@vger.kernel.org>; Thu, 16 Jan 2025 15:17:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1737069444; x=1737674244; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9hHqgHd4813KMrHlOnuFkhcaf4unu6qC0dc3ADAOeZA=;
        b=n1/9xm6J891k+RKwfFnY+ru8271XikQq8m5ptDK48KFrHjj5yuaRX62HiEIBFAhSGm
         IggNArpv2ZcEcKw3zNFnZDGxsmx3BCSolsEw58s/wH3WGUdjgGQV+9DJBKHMOK5dxSdR
         Yu5czFRrqomZdDzPWMlzyN9/NNWtPsdRwP2dCY/8KRcOn/wEpyys9B39/Aj621Xgh3Gn
         35iFAsQEdfJuJKZ+dnETM4O1MvV7tud52jIjCYQ1Rrh4yy4lBaoYVZCtrqqcHkCWHMJb
         tMZqVtVXCVdPiUBdwI7i5E1RUOexoPr2XmnOzfVZumhGIm6/dxvJt9G0ggZHXDvn9BZO
         jjlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737069444; x=1737674244;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9hHqgHd4813KMrHlOnuFkhcaf4unu6qC0dc3ADAOeZA=;
        b=cdihV96DvlXAM2GJpQVK81v7QRqGBIOm2Mqan22JyUSvvQKLD2WU9cWh4efqHVsCSH
         WXpgNY9rhf27VkvEEqvd+sIH4bhKle02H5J3bmNuWNXPb9qoqa8OH6cU1c6cBJoZdAo/
         BlnyU79Kki08CNo3op1eMWXV4l8fIXKokque5azEvlhFlOSS6a7FoF3rO5M4HCPofRRt
         hO5IaePEHvHh8U+g3sRwiLoN2GUqiovXfm+P6thpRrVp3lTyxONLhT2Xp9FWjhUBxTPB
         6AGIX9os/LLgjbdkLeC5a4QnCd+8h6qVI7fU62IEvSO2rU2P3HtRmXCBBqr3APiW2/Fv
         Ih6A==
X-Gm-Message-State: AOJu0YzF4BmrinZqorAtsc4nmxabK9Ig+O2VAR6B94UBuSoWqvdFTYsD
	KEaMOzKe+U6hKqR10CE/9ESg71u75Z+znJGVZ1+RGm2x6Vxy+Lao5TyFAvmP2cQTTJ2mW6T/1C3
	z
X-Gm-Gg: ASbGnctcC196QlQprkRY5+v0YEKjZL9vY8EG7nFEtyXlV2XVbIbbNOSlXSEus8G9XkL
	kZEesazpt9fDG05jYdjtwPeYM7SdmHFcOZHmGXnoMnd+aenRXFsCPxXkhsDkgdkPaGns07e1GZE
	mcQyzDKjEvDFatyzYMwdwndyZK0UMbPE4foL9S59+glzzvc8kfMuLuSSDJjFDVIkjbTwIEp1Q0n
	i6A2We6PfUjlMZgS6W3ZRKS0GmiWC+unB/QrsPrxg==
X-Google-Smtp-Source: AGHT+IGYL9qSwTG5WFtyJZZT72HUZNX7KCOAdE9lPam5LWd1uo68XTkIcze3pOsK0r2tMQkw8mMVwA==
X-Received: by 2002:a05:6a21:9990:b0:1e5:f930:c6e8 with SMTP id adf61e73a8af0-1eb2144d51emr752025637.4.1737069444625;
        Thu, 16 Jan 2025 15:17:24 -0800 (PST)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a9bcdcf7c87sm490532a12.43.2025.01.16.15.17.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2025 15:17:24 -0800 (PST)
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
Subject: [PATCH net-next v11 15/21] io_uring/zcrx: dma-map area for the device
Date: Thu, 16 Jan 2025 15:16:57 -0800
Message-ID: <20250116231704.2402455-16-dw@davidwei.uk>
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
index c007ff80b325..2b668f09b55f 100644
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
@@ -21,6 +22,73 @@
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
@@ -83,6 +151,8 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 
 static void io_zcrx_free_area(struct io_zcrx_area *area)
 {
+	io_zcrx_unmap_area(area->ifq, area);
+
 	kvfree(area->freelist);
 	kvfree(area->nia.niovs);
 	kvfree(area->user_refs);
@@ -272,6 +342,10 @@ int io_register_zcrx_ifq(struct io_ring_ctx *ctx,
 		return -EOPNOTSUPP;
 	get_device(ifq->dev);
 
+	ret = io_zcrx_map_area(ifq, ifq->area);
+	if (ret)
+		goto err;
+
 	reg.offsets.rqes = sizeof(struct io_uring);
 	reg.offsets.head = offsetof(struct io_uring, head);
 	reg.offsets.tail = offsetof(struct io_uring, tail);
@@ -422,6 +496,7 @@ static void io_zcrx_ring_refill(struct page_pool *pp,
 			continue;
 		}
 
+		io_zcrx_sync_for_device(pp, niov);
 		net_mp_netmem_place_in_cache(pp, netmem);
 	} while (--entries);
 
@@ -439,6 +514,7 @@ static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
 		netmem_ref netmem = net_iov_to_netmem(niov);
 
 		net_mp_niov_set_page_pool(pp, niov);
+		io_zcrx_sync_for_device(pp, niov);
 		net_mp_netmem_place_in_cache(pp, netmem);
 	}
 	spin_unlock_bh(&area->freelist_lock);
@@ -482,10 +558,14 @@ static int io_pp_zc_init(struct page_pool *pp)
 
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


