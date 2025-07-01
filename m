Return-Path: <io-uring+bounces-8554-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 20D94AEFA8B
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 15:30:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3780C165F5C
	for <lists+io-uring@lfdr.de>; Tue,  1 Jul 2025 13:28:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B88E0275B16;
	Tue,  1 Jul 2025 13:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O343WpkL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5C1275B1B
	for <io-uring@vger.kernel.org>; Tue,  1 Jul 2025 13:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751376381; cv=none; b=hxfVslo+urrPrpcLhwcKRyMv/TiSoFheOw7lBtTJNWWvZmyJSNfNtHZiFK0pSpKsQ2jlNhdwDpggtDjD6VNVNXXCkPQRLayetuzQ9dy6UewfxwS0Sd1BppB1YpJSSlc+4V9POoD95oHQoGcb+Y8dVZ0pfKiSFXCTQryOgkkrSSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751376381; c=relaxed/simple;
	bh=UljhZlMSxv8RgS+FY7RwxMJ7ExrB1GveR2LYqaZ0Wio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gP1mb0l52YFvuGhixlw8hEXJdsCDRy39DvEyW6agdUclOaJCAB/0uPYNl+f/fwaM5EsVYKxvU4a2HRKXNh+FMPdfJzSJDHbmyX7WPTV9FZt3Bir0XlAnywZIy3sjs0i46XobtrvqC71fwX+mrpFuKvbanPdw7WrductDd6k+ZS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O343WpkL; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-74af4af04fdso4075022b3a.1
        for <io-uring@vger.kernel.org>; Tue, 01 Jul 2025 06:26:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751376379; x=1751981179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rd/GO95B8h5uuEHv6DXycfCIM9ZV9chlU0X+eVXZJwI=;
        b=O343WpkLCVskCrumyIlHB+g2Vh7nHOZdEcVqBkOFXG8+kIJV3cO3cmAp0KgDwee5do
         sAYVnASRa57k8UOpVI/iLp/p6N9Ch4icGe58iOSHWtnLbFJN5P5NxPcYI3vC3lQVHljD
         lW7W824Qu6V2SMTpu6L1++KYfmL2pj6uHGsWMZ9Q2t8HTbq29PJy87eyC/1tU7Nhyz/s
         KIfGGdtY4sJ1eRrFdaN7f6/F2TnwMDsyOtvv1dGGDYjEwaz5sl2CgPBhtW9DpjC2sxPe
         /QET7JYG9drybZTnMqoAHpVOgReGdyb20eIsfVyWBVEteo3VOAHV0Li0EPrDfxP3Ldxr
         ogDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751376379; x=1751981179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rd/GO95B8h5uuEHv6DXycfCIM9ZV9chlU0X+eVXZJwI=;
        b=JFEpGECI5Z7YplA+i7bA4zoOfh3igE+Sd6zqGzlT2dhh33qrZ8tZ9CdULU0lwABlqy
         tNvC8/h31l8ZlaJtjaKi0MSX4TX5JAxvVA4dh3jEMqBDuWWxksfLKxp9yY3tzwbIHl3C
         FO9QgO6CCh5rFY0MhlcvgX1MdiArqRGN8wiO3pPxGx4cBDq9nw+Fatp+fDDkFBwn7eKV
         QbM7wFrXRmyukwGfchAO5Qjntlkvo1VTK63HV/sMe/vEz3sr1FocVBuDRIjQrnVkgVKn
         bjSMteM6jFcF1NDDM9UJ4mvZMxKgzy7Kfew7NndT33STSNVan1bjP9Z4F+9qknIMqFEJ
         Q7Pg==
X-Gm-Message-State: AOJu0Yyk41tIZfYsgzDdqfR8V1JRa8fyX3CZsiL7jg/KBgOAzX6Q++V7
	8vG/QCxyLiRE+vNqwLMLottfzUA/D6rBM2gqfnOgLHa1PbeNGu6u+6gpOVwfbzeD
X-Gm-Gg: ASbGncvGoqssotH5rBjooJAUFyKdgmrhwpsX/AuQYBu4jX7W1mbzdGup2fiTZ7DAx/4
	AiMKjPQYLR2mBbZCbjy/+XDT9tuppkRLNbXbBer5KQyNHk5wc2PrxeGKlLPyr8/Y8vPT5RZg+1u
	94yNw2Dxn/+EhFOcDpOWFLZ9qObfOSetHAkEAKKWY+Yc+hYs/3bcoIZWqwdNtgfvF/T+A6x21R3
	6YrJQkKo7K9SNc9MZVa8J2AyzIkBdMMfHbcFn/oBcmuyCFLn5csAPVZDlGoBGFBnPg1h5yW9qFA
	DykbhVeCkc0DqhogOxq5U3wXD86L7wjQ1JRvfX1qyMhPdwxFjlocxXSnFDM=
X-Google-Smtp-Source: AGHT+IEX/77iofyT2tFh264WnF/2J17TfLe6epYnStIS+sUeJR5S7S4FYAxdnlQOx9+B/e5tcBnZlg==
X-Received: by 2002:a05:6300:2404:b0:222:d9e:c5f6 with SMTP id adf61e73a8af0-222c9964a77mr3748442637.2.1751376378709;
        Tue, 01 Jul 2025 06:26:18 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af557439csm11788025b3a.80.2025.07.01.06.26.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 06:26:18 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 4/6] io_uring/zcrx: allocate sgtable for umem areas
Date: Tue,  1 Jul 2025 14:27:30 +0100
Message-ID: <f3c15081827c1bf5427d3a2e693bc526476b87ee.1751376214.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751376214.git.asml.silence@gmail.com>
References: <cover.1751376214.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently, dma addresses for umem areas are stored directly in niovs.
It's memory efficient but inconvenient. I need a better format 1) to
share code with dmabuf areas, and 2) for disentangling page, folio and
niov sizes. dmabuf already provides sg_table, create one for user memory
as well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 78 +++++++++++++++++--------------------------------
 io_uring/zcrx.h |  1 +
 2 files changed, 28 insertions(+), 51 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index cef0763010a0..fbcec06a1fb0 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -159,7 +159,7 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 			  struct io_uring_zcrx_area_reg *area_reg)
 {
 	struct page **pages;
-	int nr_pages;
+	int nr_pages, ret;
 
 	if (area_reg->dmabuf_fd)
 		return -EINVAL;
@@ -170,6 +170,12 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
+	ret = sg_alloc_table_from_pages(&mem->page_sg_table, pages, nr_pages,
+					0, nr_pages << PAGE_SHIFT,
+					GFP_KERNEL_ACCOUNT);
+	if (ret)
+		return ret;
+
 	mem->pages = pages;
 	mem->nr_folios = nr_pages;
 	mem->size = area_reg->len;
@@ -184,6 +190,7 @@ static void io_release_area_mem(struct io_zcrx_mem *mem)
 	}
 	if (mem->pages) {
 		unpin_user_pages(mem->pages, mem->nr_folios);
+		sg_free_table(&mem->page_sg_table);
 		kvfree(mem->pages);
 	}
 }
@@ -205,67 +212,36 @@ static int io_import_area(struct io_zcrx_ifq *ifq,
 	return io_import_umem(ifq, mem, area_reg);
 }
 
-static void io_zcrx_unmap_umem(struct io_zcrx_ifq *ifq,
-				struct io_zcrx_area *area, int nr_mapped)
-{
-	int i;
-
-	for (i = 0; i < nr_mapped; i++) {
-		netmem_ref netmem = net_iov_to_netmem(&area->nia.niovs[i]);
-		dma_addr_t dma = page_pool_get_dma_addr_netmem(netmem);
-
-		dma_unmap_page_attrs(ifq->dev, dma, PAGE_SIZE,
-				     DMA_FROM_DEVICE, IO_DMA_ATTR);
-	}
-}
-
-static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
-				 struct io_zcrx_area *area, int nr_mapped)
+static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
+				struct io_zcrx_area *area)
 {
 	int i;
 
-	if (area->mem.is_dmabuf)
-		io_release_dmabuf(&area->mem);
-	else
-		io_zcrx_unmap_umem(ifq, area, nr_mapped);
+	guard(mutex)(&ifq->dma_lock);
+	if (!area->is_mapped)
+		return;
+	area->is_mapped = false;
 
 	for (i = 0; i < area->nia.num_niovs; i++)
 		net_mp_niov_set_dma_addr(&area->nia.niovs[i], 0);
-}
-
-static void io_zcrx_unmap_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
-{
-	guard(mutex)(&ifq->dma_lock);
 
-	if (area->is_mapped)
-		__io_zcrx_unmap_area(ifq, area, area->nia.num_niovs);
-	area->is_mapped = false;
+	if (area->mem.is_dmabuf) {
+		io_release_dmabuf(&area->mem);
+	} else {
+		dma_unmap_sgtable(ifq->dev, &area->mem.page_sg_table,
+				  DMA_FROM_DEVICE, IO_DMA_ATTR);
+	}
 }
 
-static int io_zcrx_map_area_umem(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
+static unsigned io_zcrx_map_area_umem(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 {
-	int i;
-
-	for (i = 0; i < area->nia.num_niovs; i++) {
-		struct net_iov *niov = &area->nia.niovs[i];
-		dma_addr_t dma;
-
-		dma = dma_map_page_attrs(ifq->dev, area->mem.pages[i], 0,
-					 PAGE_SIZE, DMA_FROM_DEVICE, IO_DMA_ATTR);
-		if (dma_mapping_error(ifq->dev, dma))
-			break;
-		if (net_mp_niov_set_dma_addr(niov, dma)) {
-			dma_unmap_page_attrs(ifq->dev, dma, PAGE_SIZE,
-					     DMA_FROM_DEVICE, IO_DMA_ATTR);
-			break;
-		}
-	}
+	int ret;
 
-	if (i != area->nia.num_niovs) {
-		__io_zcrx_unmap_area(ifq, area, i);
-		return -EINVAL;
-	}
-	return 0;
+	ret = dma_map_sgtable(ifq->dev, &area->mem.page_sg_table,
+				DMA_FROM_DEVICE, IO_DMA_ATTR);
+	if (ret < 0)
+		return ret;
+	return io_populate_area_dma(ifq, area, &area->mem.page_sg_table, 0);
 }
 
 static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 2f5e26389f22..89015b923911 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -14,6 +14,7 @@ struct io_zcrx_mem {
 
 	struct page			**pages;
 	unsigned long			nr_folios;
+	struct sg_table			page_sg_table;
 
 	struct dma_buf_attachment	*attach;
 	struct dma_buf			*dmabuf;
-- 
2.49.0


