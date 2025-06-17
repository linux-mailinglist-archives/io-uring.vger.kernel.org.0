Return-Path: <io-uring+bounces-8394-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C6DDDADD06C
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 16:50:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4F9DF16549A
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:47:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AA201DE8BE;
	Tue, 17 Jun 2025 14:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DLkKsxB1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C2C20E71E
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 14:47:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750171647; cv=none; b=BIr0ztpVIwXQfP+QeQZwaltZHHuDLYv0ogD9zvb4Or8oxCpndFr99JWtEMjqhDiu8+hTOgqDRzViR+YXlBG/U/AE50oX7/hqipDr1hhx+ORwwdLBqciSSsnGg4mLYWv2fVxToCswhdofTlpxotzgu1Ubqg6yHA5fnP8je7cJ2HY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750171647; c=relaxed/simple;
	bh=6ainh/9to1D0EzB/E56beW9pbTwEgOOVwcuC07SRhSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oT2M96aC07SRXHp2JahI/snnl53Q8YeRaFgH3yU7BVSt3lKdu/gP2WrW//f3n4iMDDm3haC+mgSxiqIGtidbZpJ4WeXKUvG2zjFOISIms0p/XrBveS0mPV2urTYJpZ//AtKci7nZaNciXG3J+SQ69IRX/Aet7nuhECnZJSD8658=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DLkKsxB1; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-607ea238c37so12296002a12.2
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 07:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750171643; x=1750776443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5i4dfwVxnoKPrdS1NEs4MApSmDJhvBE19mF3RjeHJRY=;
        b=DLkKsxB1grbyGliBRuRbWwWNHykr7xs94kCesBXF6SQKzPIItgLmAnWO/GnSJKRTE+
         8QgGU4F4tXmeVcGv4Z6JgEYLR/TEUqQowZf7wQ+/Vpxd8cLFYAsHM55/NFIQXBeYpfmV
         Pb5U3l7cYgblNxzG5K7LEQdrJmQLZbM1o4KDmFjRsk2NJEUa57FW8j39n+pHMjv0stk4
         S3NNA0MYye+sIulWOe+hfWqOIoSB90ljcG+DvoTKclB4XhRg4kE5Nzu+Ri1X0sxdEti5
         ovyL8kbK2PspFda0lyQkFDeuJne8auwZRrBwEuFMBBEO0y/0WC/cFcmJFEnHmmYicBe+
         MNEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750171643; x=1750776443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5i4dfwVxnoKPrdS1NEs4MApSmDJhvBE19mF3RjeHJRY=;
        b=qxgsT+gQJQza+Zmjj1JdZeCPzOk9k1QPGHyhMfDhBFbcRc3tJvKTeGH3mMRt7qMUC2
         3W2jK5BGJnhMNE5OikQt+wvNaDyCd7hxzyr4NaDtDTzZ5oSjJzdjrq1EJ3J5ZaliCt0Q
         LBw/nw9N9aFWfBW9vxaI0p+IeyLYX89brcazEqWheDGx+lcZ0/WmmbzSMUMcDfXZy4J6
         DFNf9d8DxhIFL5E+N2irtKz+CJ8INNHox8oXzlyZc8R/WSno+r6lEWiBTM4U1jJO9lI6
         WYiKMLqFQByP8ki1cxnyQVK/xwlrXObRti2wwXu0qozqTq6DZc9tODMKzGhoCdwhA+R1
         1r9Q==
X-Gm-Message-State: AOJu0YzyjU6j/dwyNa1ac6FJPGM01QktFmS7JYGuAEhxy6Oq8dpKnILV
	dOLfphQdEoPoBo/pEt9iKhkTQTrqc7+4TYz1SNsvkQhPbmT1gqbKs/Fmmw4QsQ==
X-Gm-Gg: ASbGnctWRvwLi5szeHGp3ZsxVlcq6lmbx0pnAlWJauz/4GT41FuA+CZP7D6otWDh8KS
	GuN9AAheDnscYVCImuwwr9sgrctRg7y/KIuMyz/d10a1HEBobpKc+Mw7UFGVSIFq/iqBEiIDcqN
	UUAPbP9BWtwO2vvfkEQOoznd1hRvtZNSwE+KNsQ+vO6Vk++cvYSilZKtaNvm2eTCKJATsYcIoCs
	Aql84HAU1IxXpmco0g/WN1yVCRa8oz2z5rjXoyWIdjbbdt7ItGbAblOjwpGIUn7YsexEJdqQbGl
	azad+p1VVoEXQRnbbk2yEQ96cOkCvXatDbeqrlQj6/6DFw==
X-Google-Smtp-Source: AGHT+IF26oQM2ZGX4HZyQYggqta+BosG/+Kq2V7h/n5EcDoNNPmtxdG5LrXCVRSh/d1dxSEQNquZgA==
X-Received: by 2002:a05:6402:2686:b0:607:35d8:4cf4 with SMTP id 4fb4d7f45d1cf-608d097966cmr12758154a12.25.1750171643356;
        Tue, 17 Jun 2025 07:47:23 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:b491])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-608b4a9288csm7951040a12.57.2025.06.17.07.47.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 07:47:22 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>
Subject: [PATCH 3/8] io_uring/zcrx: allocate sgtable for umem areas
Date: Tue, 17 Jun 2025 15:48:21 +0100
Message-ID: <32f2a8766ac8b9489239701c18016f18083e861f.1750171297.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750171297.git.asml.silence@gmail.com>
References: <cover.1750171297.git.asml.silence@gmail.com>
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
 io_uring/zcrx.c | 80 ++++++++++++++++++-------------------------------
 io_uring/zcrx.h |  1 +
 2 files changed, 30 insertions(+), 51 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 2b82fda6d934..91e795e6ae1a 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -158,8 +158,10 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 			  struct io_zcrx_mem *mem,
 			  struct io_uring_zcrx_area_reg *area_reg)
 {
+	struct scatterlist *sgl;
 	struct page **pages;
-	int nr_pages;
+	int nr_pages, ret;
+	unsigned i = 0;
 
 	if (area_reg->dmabuf_fd)
 		return -EINVAL;
@@ -170,6 +172,12 @@ static int io_import_umem(struct io_zcrx_ifq *ifq,
 	if (IS_ERR(pages))
 		return PTR_ERR(pages);
 
+	ret = sg_alloc_table(&mem->page_sg_table, nr_pages, GFP_KERNEL_ACCOUNT);
+	if (ret)
+		return ret;
+	for_each_sg(mem->page_sg_table.sgl, sgl, nr_pages, i)
+		sg_set_page(sgl, pages[i], PAGE_SIZE, 0);
+
 	mem->pages = pages;
 	mem->nr_folios = nr_pages;
 	mem->size = area_reg->len;
@@ -184,6 +192,7 @@ static void io_release_area_mem(struct io_zcrx_mem *mem)
 	}
 	if (mem->pages) {
 		unpin_user_pages(mem->pages, mem->nr_folios);
+		sg_free_table(&mem->page_sg_table);
 		kvfree(mem->pages);
 	}
 }
@@ -205,67 +214,36 @@ static int io_import_area(struct io_zcrx_ifq *ifq,
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


