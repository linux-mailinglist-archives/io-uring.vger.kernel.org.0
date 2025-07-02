Return-Path: <io-uring+bounces-8570-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C60CEAF5A65
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:02:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95D104473BE
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:01:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CEB8427D782;
	Wed,  2 Jul 2025 14:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a4ahy/Aq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D44270ED7
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751464933; cv=none; b=kEmvMUct5IXBACKYOgw6tcLIb2tXhLCeDlqw6K332j4NyKPtQrDNRFpigaL+GczEQ6VQaRbxxQk9BZyGL4xoKMlnI+ENO3neEm7pPMWw2w0cDXdrJAy/27BBFjm4Dm44U6Kx8xlqVQiFymD2+WoPbTFeBlADaJ0d/wA4m3SNndI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751464933; c=relaxed/simple;
	bh=UljhZlMSxv8RgS+FY7RwxMJ7ExrB1GveR2LYqaZ0Wio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nqp+ZEMZLDhH/bD/734CDqpg0q7AlO/nJCFI2QEVyyKkQWFopd/CxAek6zLi32e7aR3IliA33WTXm0L1SGMLW6nmH7PLWeFvcmNpsnxtfNuTh9Q/sn2OHK5WUGyrRGWp0IRtWtPyDa9AzcnxEJ9V2SExXgXvWNH2Wy6+SGiLEzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a4ahy/Aq; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-23aeac7d77aso40365595ad.3
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:02:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751464931; x=1752069731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rd/GO95B8h5uuEHv6DXycfCIM9ZV9chlU0X+eVXZJwI=;
        b=a4ahy/AqOvgDWiphXRX+zORRpQym7rQwdNP4DVYXBu/XF+boW8PKyGIUv3HE6VClPh
         mkQUGnVLT5PBXmLFwmuCdowYs4TRoGlg2qtd3mhzgKb6CLbai4CilgMpoTsD8TJEsPWi
         xU/AXqSU9o05s1eTLodj77N+H7GBXGq7xATTtBpByTdF82l9iUhoy1pm9S/EAgAv3CI5
         c2mPr8I5IPJQsI4DeTxPcIB2wmhZ5W555lc9ud6IlM/FKOhrdGRXJz7lfzlNfOLqterd
         lWtkGM50tgaKDt8oU5QOelNUO2nz+HOCkCbU2ElfA2F7+76mszT+OoBtkax/dyfV3/GD
         AyKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751464931; x=1752069731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rd/GO95B8h5uuEHv6DXycfCIM9ZV9chlU0X+eVXZJwI=;
        b=QnIynLMLdk8YY6U5DHWZH2Ck6gAcowdtgyg1J8SStbBm8Abw8xuVQj0/svMAlnZANB
         9CxAFWL6nVmU///Wy0iM98kRx7bqbJTrZMMMWxrY1ldeciAN2B/RRwVCxSXGic5JvH0J
         6S0wCSJ61psVviE85njnn57icHa5wPDsPPl+l94/1ooLAvW78WHSmGTBQfGbK4ULL2M1
         p/NP70ZuppmwZDKkVcWmv6gaYwi4755mr4nV31N5Wzx0A0hH91+PZq0ZiEfguWfppxQY
         x2d0FSMZULbRPLLRvESfBBcZWY7RwO423ISgJ1yaWIwJxyFK+LvRTN+5w/ROxadnRNja
         fToA==
X-Gm-Message-State: AOJu0YyJmLzvmNd9rDFlAqjRDyvCb1MXErUaHauq4ZGI5gPJy0/ax7rZ
	tz5XyCS73rPxnbOzl/ZkgjxUQallBcxvvDCFn3sFjbLJAiU8Gemw9SlEGUowDNYY
X-Gm-Gg: ASbGncv4yHSVgfKeC6HO4lyKiZR2b+S0ZxPGls+wvL1KPI1w1Xp7ddWWjjwySMECqFs
	TwH8Y6HkuwNpia3PoVk/zY+frrOyJByRwybXi6R4qtphmHgUIULVx3AM6LvCkqdYnMYP4htCa0h
	I3nB5Mwe1t4eEncrvw+bTcCNFIdFPHhlZ/xNg9pmz25uaxy1U2AJHMExY7uDi6iB9KF809Uzrm/
	h01ObHmtXoNUSjeq3qixOrHPxrU3i/vBJ+GUPtEyDLemL/WSzDL8cm1G+7TSpd+Q/jX/iwMHnaf
	0Tn1VcV/7TlBd7b5ieuRTxlxTjpt6fNi3w8+JCdXrHmSU0uJQnMW3YiBP/A=
X-Google-Smtp-Source: AGHT+IF/sLwaHALfRd92fFo6DE6P6arpIIbd6M/maTt+l13FZzWSJEOiudn5HK0/qrlBqvsbXmdRoA==
X-Received: by 2002:a17:903:234f:b0:234:a139:1210 with SMTP id d9443c01a7336-23c6e56157fmr57771135ad.53.1751464930683;
        Wed, 02 Jul 2025 07:02:10 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23acb3c6e14sm126828135ad.228.2025.07.02.07.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:02:10 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 4/6] io_uring/zcrx: allocate sgtable for umem areas
Date: Wed,  2 Jul 2025 15:03:24 +0100
Message-ID: <f3c15081827c1bf5427d3a2e693bc526476b87ee.1751464343.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751464343.git.asml.silence@gmail.com>
References: <cover.1751464343.git.asml.silence@gmail.com>
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


