Return-Path: <io-uring+bounces-8578-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C05BAF5B1D
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 16:27:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C5F8A4E78BE
	for <lists+io-uring@lfdr.de>; Wed,  2 Jul 2025 14:27:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 489DB28983B;
	Wed,  2 Jul 2025 14:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="V9rS0oU6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B4970810
	for <io-uring@vger.kernel.org>; Wed,  2 Jul 2025 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751466472; cv=none; b=CKfKS41jZ3KDhpfmIkR88SbFDrzYd9YqzErR731JG0EeqRfb0HK/5kENiyVESiSLbyDLgpQG7Qcw8oYFwHGNx601GkbQwUcK208ymmT02aCeUWpx8PToPP+tuqiXRaYEY3C+adHLtTTDJQhhF441zLQheHh3LVA5YbBVJtIte0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751466472; c=relaxed/simple;
	bh=UljhZlMSxv8RgS+FY7RwxMJ7ExrB1GveR2LYqaZ0Wio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AnYuQKt1GDxxyp87mNtEN+DupB/obCkQ7AYRbN6OnP9BTGNrGK17SUEAPGseiRN9b6CNkojBFFANzqBXdhoBAFvlazWImCfB3xoZQGpM5O/Uwy6XaU3jlEiJq4ImD48lJdWDLksHQVEUuD1qRtvgOZc4Gf4sYGAQihXD96zUneE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=V9rS0oU6; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b34c068faf8so7315535a12.2
        for <io-uring@vger.kernel.org>; Wed, 02 Jul 2025 07:27:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751466469; x=1752071269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rd/GO95B8h5uuEHv6DXycfCIM9ZV9chlU0X+eVXZJwI=;
        b=V9rS0oU6RwR1s8Jm2FyfUIHCi5R5EzvrjQRenLK02aTPoVJHpptgab4LQjP1KC1SeV
         XiZEP7lTz1ZGuxbrlxjMcmx60cx4r6quklnOvffTZFJAukR5LbNp79vTsQrtcWYGjq5F
         tkiyb+PUkV01ktm6ZXSeqU1HBfJjRiAZ6M0tuE+hlNZxoyKC1ml+9jfbdaYxeZ0uszdF
         +Zhg3TWcX2KpQfYzOX99ktsc6kSHLOCuexXCwE8hhVf23jgIA/R60L3AuqvR/cjyEQ79
         TeoNdCDJu5k/T1RGp3Xxuv51qgMF6+9F48TlXUx0Qr5Z7rDAE4Y9kII0hOERg5DZM14Y
         PbEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751466469; x=1752071269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rd/GO95B8h5uuEHv6DXycfCIM9ZV9chlU0X+eVXZJwI=;
        b=mGqLM9GRM/sFQg5SDAf5Cm3A0ZPffVXfu3IKiWpIy0jHLLokSLMiqnJ4d8WqfXnOYi
         TywTFU8cLAmNOvzswAF6w2DNbaHkMX/QuoEByNcWVEeUCx7GmKFRoZvqyH4VTFxMluuh
         NAarMCmU6woedy0ncV/xxPf2x+X5sd9nFHOyFEkd4g1vTL1JNAQ4t9V1+PgPCwonbGuP
         RIGd98bAQoZPELL/zJ42WfQS7BR9NA1kqvV6Oxr6O1kwENild43VecWF+9ixcGsVtGdn
         ouSrMkhfrRp+Wxg7Wdpr7EK0zLbLk+SwBDuS5PiHp9AFBeMabm6NSplo2mRzGX1vJemw
         c3QQ==
X-Gm-Message-State: AOJu0YwVvStalaJJGaaZyENbOjf09UF3Htc3XfA7SFboIDGVuDHOHIJL
	SPSlEQwn03MdYDScoqU6tljr1Ydz/KykdGxB3QGE2G9Mlpzqf4WYZ9EYDUuhP0wq
X-Gm-Gg: ASbGncv+2iRMO+4IxMdDSLUdcU55z7f3O2VM8MFTB5ZapZ7uGwq9vA3qAWE9rsbs++M
	qCKOazEU3/OZLe7pZdu3sE2AAxJl+vDPBQWnDoQc2cRer+y9Ri2wkCxgCoNqK1r9VG4QfEdBHgD
	5UNmP9XOqGsZcGJMlCWGdRqIFD0jBRk2Ylj9P+F4EGl/Q7MS826BqXA2MUPsVUvyXvhQEMlHZe3
	yKFLVlUe0V5YXe+m1833JMbKSSZHjf28Ca+c/9Qe025vW5sPxf9zvlE+dAIvxzpxOEKhEv0u6PE
	wXEd2ElAPeoG831SaAUZOp8OfyewLlLBTFlVTDhnkjrpFJfaaeG8vSTU6Bztd1lCCxeKuw==
X-Google-Smtp-Source: AGHT+IHyguB2bWclJnjuJv9Q1l2FIEcdTJ2P07siF8K1DDq9seqH6vg5ammNkgbIN6h8HYqs5YaPLw==
X-Received: by 2002:a05:6a21:4598:b0:222:d63a:249d with SMTP id adf61e73a8af0-222d7e8a231mr4895100637.20.1751466469431;
        Wed, 02 Jul 2025 07:27:49 -0700 (PDT)
Received: from 127.com ([50.230.198.98])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5409a41sm13765094b3a.29.2025.07.02.07.27.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jul 2025 07:27:49 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 4/6] io_uring/zcrx: allocate sgtable for umem areas
Date: Wed,  2 Jul 2025 15:29:07 +0100
Message-ID: <f3c15081827c1bf5427d3a2e693bc526476b87ee.1751466461.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751466461.git.asml.silence@gmail.com>
References: <cover.1751466461.git.asml.silence@gmail.com>
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


