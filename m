Return-Path: <io-uring+bounces-6460-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58108A36993
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 01:13:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F52B16A859
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2025 00:11:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00B03DF60;
	Sat, 15 Feb 2025 00:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="ARONV0OQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 573FF1422AB
	for <io-uring@vger.kernel.org>; Sat, 15 Feb 2025 00:10:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739578207; cv=none; b=K73CJiOWM5TNneKT0m0W059QsMCaJHY5pUtZxHS1bxS9RWQbObgDQZbMq1EDMZXHdDW9GeUsgqZ5ZjRjKuMs86fRgDFOuc3M9Xez2jH0pE7wa0pjZ3/y0D0tY/POw8e+GVxIwzYN7tNGBwALZEeHrdmLraQrYet6NQsxR/lpeNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739578207; c=relaxed/simple;
	bh=giWr7QZLp39SzXcwZ1dGleY3dSlDZX/Jpi5o0vExGlQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwhvAWygV5EybvkE+GM6zwZLddLLHOthjYkVVq3vO5UzuEydcMGGurlWjQETqQv04Cu0VW6pqH8qkGbiOyZJMZ5IOcx22fCO6835DBHrTS+KT0CPNKujqlnD3JxnuTvz+atWamBdezRQyT9kfrviEmPJspCVEVKrIREclM3H60o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=ARONV0OQ; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-220d28c215eso37387365ad.1
        for <io-uring@vger.kernel.org>; Fri, 14 Feb 2025 16:10:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1739578205; x=1740183005; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W1w09fUZIhM8twL945gEZguDCFzB5iap37OBCII+bFw=;
        b=ARONV0OQ/iHUb4uvioFARLG8590ta4B7jd7gISo8bXKld4VTqOqXvck00qd4xAhOiF
         gUc43JExBEbNZUbsnXCrh3M+t84GTG3vka8MO2CNrkak7hIjbeTlJSULo7pkfrQNG4dq
         ooumaphDZePpPbR+v8qtWytMZz5WH6LqrrBdsr/7F2elWRekO1cIzY6HwpslERZ7y2RG
         UsH6GPA/kCxwdV2lo+LkixWSh1j93zDEEuyXwcIcy14qLG8IL9mLVmiW+qvhmR6Hw/um
         Nwgaq0igYxIluxnEhKg3JfBmfxNM3H6k2ucnvbHxIYLqKXT8UBh2a2UAX79IP7Lbq2di
         Tzlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739578205; x=1740183005;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W1w09fUZIhM8twL945gEZguDCFzB5iap37OBCII+bFw=;
        b=kuuLd72uNP3cXIwNFeC9EWTTsf4wLMhzkd6ueRsn1sZMDXhZqHSRjry+yxErSl01kB
         CAYl1IC0dluh1y+sGJScozILHGAZTwLoeiMrtgj7f8tuAoDLInJKvYhX6+tNWPzIdC3Y
         EmQgLMK2yWWbYrE9xQciH4IptSY1tg7FVoLubjbX1jIGTpgnfqjPaiT9rk0u/+NQKDjo
         b7UHk1g1G42rqC/UA71ka0Oxm6R9jsnDk7Y32NXf5hVNJJOO3ofynMiXd1OO/D1HiD4W
         NynAfrmndXKigHA3d+7crs4CWbNd3yq1XgitXgxFsk3iXVn7LZTcp4S/WbjUUOQK+ADu
         RXuQ==
X-Gm-Message-State: AOJu0Yx+sVbkyRqBniKGFncrwtKFj+fwo4ts14TxiJOK6F/mHz87CB/2
	mvSR6m3Q5HGdny8tZ4S9fEe1v8RO6ShA0rO/uCj/5bLLt0qtv+pI7Zz6vVXd1gniuoCmw+f23PM
	8
X-Gm-Gg: ASbGncuHQTpKhTzVR5t8E/REOLWL2ErhMp0fJ2BLJ4EX9Dcw1yh+8LLxnwCgFLtL24S
	Q39ilrSXv6reLteHuoFnu6ja4vcWfPFT7kDanZr6JxUxApb+TCXVGzZUowLeaeSPtGW8qk3MicB
	ebVFaaLBmHYEw3ltPk66HjZcmK2QUIF6Jby6GPdhprKudrwpOqXcFA2hgBgkq8+h86zXTyDto4Z
	5u/29lO3bJnPYSp/udvarZPyQ7BpSu3gOx+QNLNADjMBYqK3PA6r9nIXEnadVpzeIEzFQxiKrQf
X-Google-Smtp-Source: AGHT+IEFOVk9QNBd+yOxmobpINJ/GuGuqTolBk2X3X0YiBskwBeihaEYlhV6o6r62ODmskPpuf1NDA==
X-Received: by 2002:a05:6a21:7889:b0:1ee:6567:135c with SMTP id adf61e73a8af0-1ee8cacbf33mr2682877637.6.1739578205624;
        Fri, 14 Feb 2025 16:10:05 -0800 (PST)
Received: from localhost ([2a03:2880:ff:16::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7324244d5bbsm3690796b3a.0.2025.02.14.16.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 16:10:05 -0800 (PST)
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
	Pedro Tammela <pctammela@mojatatu.com>,
	lizetao <lizetao1@huawei.com>
Subject: [PATCH v14 05/11] io_uring/zcrx: dma-map area for the device
Date: Fri, 14 Feb 2025 16:09:40 -0800
Message-ID: <20250215000947.789731-6-dw@davidwei.uk>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20250215000947.789731-1-dw@davidwei.uk>
References: <20250215000947.789731-1-dw@davidwei.uk>
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
index f9e924cfa829..9d14fdf7a568 100644
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


