Return-Path: <io-uring+bounces-7801-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E248AA5E36
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 14:17:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id F13727B2499
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 12:16:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD7822A813;
	Thu,  1 May 2025 12:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JVi9NBFA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CA1F226CE6;
	Thu,  1 May 2025 12:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746101803; cv=none; b=TnIgBS6bzHkkDumhtGHQSUG9tptBcdsyXrGqjCof3SgSOBS7f2Ich/2InK9RsMUgoi2c/dLbDQZuDTr4MSHJ2J97Pu8Cf8Jmbz7sSZgBlgSKSzwkpMiIEEq+I1T8vbiMcZF0wN287di8anjxt6dc6y13Gn0bha+mCAGDkdHSb9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746101803; c=relaxed/simple;
	bh=susDE733Znb5E5KOrFKPEq4PU3V9xsBW8KW/Xp8ZCSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iVNga3xwCI4stXy9sncBHJGXX9jigP+f7tWaxZaAZnvqkdNIgUb7N2MFCWsOehGhieYT6w3gg9YwhzgTTqvO6q3DSUZa0+rY8PyoEfmTVhYSj95eUXP4GDBOPvLUk/I+AA9QVVFN4FIY3d9kB6perEAstyHXgmat3e2VObJBP5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JVi9NBFA; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5f728aeedacso1315455a12.2;
        Thu, 01 May 2025 05:16:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746101799; x=1746706599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2N+tAPE4xkV8H/oRUa0WUQSWdAXuZoxKEIoyYV36O0Y=;
        b=JVi9NBFAHymaP4BckyPW8ZeU91eSsi9J6/zk9tCAjWOZjsNhDp/sVZrbs1em+qfMb2
         dmAo0gtiG1L2h5eTcQhfKdL5qqG9zCUqgphV9PLZ+0ax0IMwTOHZn6pY8bBLTnGMEWxm
         +/JnbkjsrvZnu930UO/gLu16cI02YaGivf5jkSzVXdMKCEOso3NWBS6hM7I/5YL/0gSx
         aYDIYA7HyhuTF7zQx/4dq755U9CrFMGh1uUWPjgXx4Mjy33FfEpOA135iJSnCQrUUTjD
         ZAidL9x06L8kAIGv/dXSR9J4Jt0PZ6oMe6W9vclmRS0hePPbm0WuUbnESqH0olBZdVkP
         01FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746101799; x=1746706599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2N+tAPE4xkV8H/oRUa0WUQSWdAXuZoxKEIoyYV36O0Y=;
        b=CuNNNfWNR/+CFXYxQVs7vl7FqRAd5yKJpIOo5/0gUxeXepVmhpqFeVfUnNR9vZqH1c
         goFQKELTQUhkrJCc1ch7URAqG2VoXbiqcZGBDc8EzcA+RcIAUYU4L2nVNBIsQikeUX7n
         BD4Hxk5/YH1IOVwbRfmJMBI4riw87nMe/nni7Rk3rcnCYhgQwVK7SRKXvLhj16Q82Wh9
         3KE7XWtiBTm8YP8SxFFLMi/W5jAcKj9XqHjNNRifwH7oaeFkGNShnMgcdhoprwjJgqZF
         zjpOqgqSBoAv4H+ZvuoILfzZ7SwUbR3QeYuhpxM4k5YCOwE+rTP1AP2db4HPPlgW4zGi
         SmZg==
X-Forwarded-Encrypted: i=1; AJvYcCXw5x161ZyW4zj21tJCpf16x16a/FQWvHLdQSq5Yonc0ui40RLpe1QQ4fOZ+5qq/PqDj4GxprA=@vger.kernel.org
X-Gm-Message-State: AOJu0YzDPzpYlbZa92B1Et7lJuV0n4h1OHzzTKZbiRC7JtP3Or0DKhHJ
	HUVmjjvq76LiD2ykQiztMolY4t9+9+CQ9LezCDOB/tXb3shLDt7WAabZFQ==
X-Gm-Gg: ASbGncs7OwPUjNWF5lVKFdZgqcMFLGPfupE+0baW+/OSQY9xQmt7BfXmr0L7n/9Ycc/
	4X66z2wVge/VwzgjchKhXC9AIbevYIzBnIv6SBaT2qh7Ci9Be9gsLrK+A6Sr9FrWiLMAIOYgYsN
	PPFd58HAAQBQyiw7qBxV5BpFGWPia1Qjl/AvW2tH8s0DeRNWQVUpH5G/12XNAVtpwBRSiuMQnPU
	4GmxJQn+cmS1RYuDkzTz2BEVoiV7sGQ7AKi29bBR9zzQenqqjuzhO6evJGclmwIXZzdWHUSnyhj
	vM3fJvQ7LL64rxDt8GgmZwRu
X-Google-Smtp-Source: AGHT+IHCZ4i4wqqmB6rPnL/MEFJJdUglqjAZPmQTWpC1scJWOS5dIlmNq+DJCfNU+FyV3oJO2xwbug==
X-Received: by 2002:a05:6402:26c3:b0:5f7:f823:4bff with SMTP id 4fb4d7f45d1cf-5f91939e60cmr1849449a12.2.1746101798998;
        Thu, 01 May 2025 05:16:38 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:9c32])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f930010655sm346146a12.73.2025.05.01.05.16.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 05:16:37 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>,
	netdev@vger.kernel.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH io_uring 3/5] io_uring/zcrx: split out memory holders from area
Date: Thu,  1 May 2025 13:17:16 +0100
Message-ID: <b60fc09c76921bf69e77eb17e07eb4decedb3bf4.1746097431.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1746097431.git.asml.silence@gmail.com>
References: <cover.1746097431.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In the data path users of struct io_zcrx_area don't need to know what
kind of memory it's backed by. Only keep there generic bits in there and
and split out memory type dependent fields into a new structure. It also
logically separates the step that actually imports the memory, e.g.
pinning user pages, from the generic area initialisation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/zcrx.c | 71 ++++++++++++++++++++++++++++++++-----------------
 io_uring/zcrx.h | 11 ++++++--
 2 files changed, 56 insertions(+), 26 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index b5335dd4f5b1..8d4cfd957e38 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -26,6 +26,8 @@
 #include "zcrx.h"
 #include "rsrc.h"
 
+#define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
+
 static inline struct io_zcrx_ifq *io_pp_to_ifq(struct page_pool *pp)
 {
 	return pp->mp_priv;
@@ -42,10 +44,43 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 {
 	struct io_zcrx_area *area = io_zcrx_iov_to_area(niov);
 
-	return area->pages[net_iov_idx(niov)];
+	return area->mem.pages[net_iov_idx(niov)];
 }
 
-#define IO_DMA_ATTR (DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_WEAK_ORDERING)
+static void io_release_area_mem(struct io_zcrx_mem *mem)
+{
+	if (mem->pages) {
+		unpin_user_pages(mem->pages, mem->nr_folios);
+		kvfree(mem->pages);
+	}
+}
+
+static int io_import_area(struct io_zcrx_ifq *ifq,
+			  struct io_zcrx_mem *mem,
+			  struct io_uring_zcrx_area_reg *area_reg)
+{
+	struct page **pages;
+	int nr_pages;
+	int ret;
+
+	ret = io_validate_user_buf_range(area_reg->addr, area_reg->len);
+	if (ret)
+		return ret;
+	if (!area_reg->addr)
+		return -EFAULT;
+	if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
+		return -EINVAL;
+
+	pages = io_pin_pages((unsigned long)area_reg->addr, area_reg->len,
+				   &nr_pages);
+	if (IS_ERR(pages))
+		return PTR_ERR(pages);
+
+	mem->pages = pages;
+	mem->nr_folios = nr_pages;
+	mem->size = area_reg->len;
+	return 0;
+}
 
 static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 				 struct io_zcrx_area *area, int nr_mapped)
@@ -84,8 +119,8 @@ static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 		struct net_iov *niov = &area->nia.niovs[i];
 		dma_addr_t dma;
 
-		dma = dma_map_page_attrs(ifq->dev, area->pages[i], 0, PAGE_SIZE,
-					 DMA_FROM_DEVICE, IO_DMA_ATTR);
+		dma = dma_map_page_attrs(ifq->dev, area->mem.pages[i], 0,
+					 PAGE_SIZE, DMA_FROM_DEVICE, IO_DMA_ATTR);
 		if (dma_mapping_error(ifq->dev, dma))
 			break;
 		if (net_mp_niov_set_dma_addr(niov, dma)) {
@@ -192,14 +227,11 @@ static void io_free_rbuf_ring(struct io_zcrx_ifq *ifq)
 static void io_zcrx_free_area(struct io_zcrx_area *area)
 {
 	io_zcrx_unmap_area(area->ifq, area);
+	io_release_area_mem(&area->mem);
 
 	kvfree(area->freelist);
 	kvfree(area->nia.niovs);
 	kvfree(area->user_refs);
-	if (area->pages) {
-		unpin_user_pages(area->pages, area->nr_folios);
-		kvfree(area->pages);
-	}
 	kfree(area);
 }
 
@@ -208,36 +240,27 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 			       struct io_uring_zcrx_area_reg *area_reg)
 {
 	struct io_zcrx_area *area;
-	int i, ret, nr_pages, nr_iovs;
+	unsigned nr_iovs;
+	int i, ret;
 
 	if (area_reg->flags || area_reg->rq_area_token)
 		return -EINVAL;
 	if (area_reg->__resv1 || area_reg->__resv2[0] || area_reg->__resv2[1])
 		return -EINVAL;
-	if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
-		return -EINVAL;
-
-	ret = io_validate_user_buf_range(area_reg->addr, area_reg->len);
-	if (ret)
-		return ret;
-	if (!area_reg->addr)
-		return -EFAULT;
 
 	ret = -ENOMEM;
 	area = kzalloc(sizeof(*area), GFP_KERNEL);
 	if (!area)
 		goto err;
 
-	area->pages = io_pin_pages((unsigned long)area_reg->addr, area_reg->len,
-				   &nr_pages);
-	if (IS_ERR(area->pages)) {
-		ret = PTR_ERR(area->pages);
-		area->pages = NULL;
+	ret = io_import_area(ifq, &area->mem, area_reg);
+	if (ret)
 		goto err;
-	}
-	area->nr_folios = nr_iovs = nr_pages;
+
+	nr_iovs = area->mem.size >> PAGE_SHIFT;
 	area->nia.num_niovs = nr_iovs;
 
+	ret = -ENOMEM;
 	area->nia.niovs = kvmalloc_array(nr_iovs, sizeof(area->nia.niovs[0]),
 					 GFP_KERNEL | __GFP_ZERO);
 	if (!area->nia.niovs)
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index e3c7c4e647f1..9c22807af807 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -7,6 +7,13 @@
 #include <net/page_pool/types.h>
 #include <net/net_trackers.h>
 
+struct io_zcrx_mem {
+	unsigned long			size;
+
+	struct page			**pages;
+	unsigned long			nr_folios;
+};
+
 struct io_zcrx_area {
 	struct net_iov_area	nia;
 	struct io_zcrx_ifq	*ifq;
@@ -14,13 +21,13 @@ struct io_zcrx_area {
 
 	bool			is_mapped;
 	u16			area_id;
-	struct page		**pages;
-	unsigned long		nr_folios;
 
 	/* freelist */
 	spinlock_t		freelist_lock ____cacheline_aligned_in_smp;
 	u32			free_count;
 	u32			*freelist;
+
+	struct io_zcrx_mem	mem;
 };
 
 struct io_zcrx_ifq {
-- 
2.48.1


