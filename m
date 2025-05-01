Return-Path: <io-uring+bounces-7803-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4045EAA5E3C
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 14:18:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5D4D09A37A9
	for <lists+io-uring@lfdr.de>; Thu,  1 May 2025 12:17:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09E7D1F426C;
	Thu,  1 May 2025 12:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BRG4YBJ1"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DB4263C7F;
	Thu,  1 May 2025 12:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746101805; cv=none; b=PTri4c68kOJe9oUvVfPUoGLYNEgD46HkKtC6UaDg8msJTsh5gyXOh7bO6pRTbvM9Y4mK9TovDus2KGoJb/7pytSY3ZkCkCtfCQCty6MaZ6zflOHdA59r73whiWyH7KZM/J90aEPWgXR5vQtj9VGZsTCzVf5YcClc0hwvaYDBIdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746101805; c=relaxed/simple;
	bh=IMuQP9SARGKuoqRLjhSofbdNbpWEhFDN/P0r3CMZVYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0vInSSBp87Dze1PRvv6/J8DT3xVLG/cwxklRwwYiTJR4ItgDUzEjKQc+O0C2mN/AuLG077ngy4EjnJ76CNifgctY4kRXbX2IBkpcs9taAOBeqslBrlwMcDlWaUsVNtUxbQn0yHp+Xn7pAdnaTxHjomE1cVeDAj4weyHfDfPykY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BRG4YBJ1; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5efe8d9ebdfso1471244a12.3;
        Thu, 01 May 2025 05:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746101802; x=1746706602; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=94Toc8wVdcQDUyoW3VJJlGoj+1RHyLQ4S7pxVKpk3Go=;
        b=BRG4YBJ17rR8NEhHhyEDrYP96KJ9weGpRDeRpxrGd88Um6pUggYeLLEBVG8uuFMFIM
         rjHbEdNIBKGHXXY1hCRMSWHsGzelFUMcXjap88zRLuRSmBggnsxEsdtgXRz+r21GGtbo
         b5hgHiZTeK0Y1Bjspi13bBNO9U/0D9SmQSum7Tnml1enHoEI533PQx0WH1XsFU06ucqP
         Akfn+CSHNeTvBnPK4HaxKYTcg5hS0PfMJF4UKNS8kuSa3LW5gb8qPbkRmMuI+flu6me8
         ysWKUaMnR31qmZ8Pa89OeUoybmpK91YObbBTU12DRnDyexat8ZDYPDlClshkOrAYAs+l
         IlTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746101802; x=1746706602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=94Toc8wVdcQDUyoW3VJJlGoj+1RHyLQ4S7pxVKpk3Go=;
        b=PP1MptBJ0B1IbEgWbqH4qHNSTefXQ0eJhIt0weTNsmhvrEFw19dfgfZqHuMYVDvj/o
         rnlHgvBNspQpAiJwpJV6xTbGjc8VEx7MJJWOKbhpHDI+xmFSVLF7h7nNFGhRI0HNWvbJ
         8hbiit/IW05mLaTy072oXmruOEu5eMTBhrazGp2HnamGV8hQudBTBnGFIcLLUaVE+ShB
         /4i2+dG4eAoFdHjz1AZg0uVQa8YTVMS09J4miSJQqS6oALqsoPRtXcSBmkbnfirc9umA
         qj8mOPevKQpBERufYOXLA1Vd68I5XZurGMojE7P1frnyyUiguXR2BGycXjfjz9tLthKk
         sYzA==
X-Forwarded-Encrypted: i=1; AJvYcCUBHVHtF5pwL8IQ3Lk1mkaSb/3vk08TUbpWGvD3mmdv1f02p6ApX2PHQxtTJ/q9Kpr34y6AYwY=@vger.kernel.org
X-Gm-Message-State: AOJu0YwmYT0Au7zxb7iS6TzGKINYoihs/basS0F/tEzw0MjPywvvfSDH
	7Uf7nsxaKdQvQmsYOtGkpnA/oXkp7YJ8P9VSqz710f1IhOPvBQH1aJIHXA==
X-Gm-Gg: ASbGncspdLde5s2QAp7mBb8iqhvpsMdFuOTA2l9ews66eJ5vYwmWVXXQiJ5c3k1KDtA
	PLH8j8m6c87rDjVDKg9L1pb9ElsQms6uTRV+xCLVZ4r2UWKt8/5rTOc3xZ/2DEEOexN1zBvVZft
	TAtjt52CcP1/nXRDHbrgQw06bnMeE+k4vC8esRMRTwNr8ev/WfgX89qNlIdMXaqGmn9COGBZ7Tb
	tIM5gN2/FyB3VWhzvodGuJJl7OOHhddAEm5l9aQJ8lT3MOZebmQWqi1LzH6PbfNac87XFbybYMi
	gj9EERJuQbKi5xJ5tLWjPOkE
X-Google-Smtp-Source: AGHT+IEFCUdfaMZEoOgPPnwDwqCi+ycSb97DyRjDzND1euFUCXQ0+HlzXYjSqQXFfQpVMs9My71BKQ==
X-Received: by 2002:a05:6402:847:b0:5f8:6096:778a with SMTP id 4fb4d7f45d1cf-5f9124ed38fmr2221231a12.10.1746101801782;
        Thu, 01 May 2025 05:16:41 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:9c32])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5f930010655sm346146a12.73.2025.05.01.05.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 05:16:40 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	David Wei <dw@davidwei.uk>,
	netdev@vger.kernel.org,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Pedro Tammela <pctammela@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>
Subject: [PATCH io_uring 5/5] io_uring/zcrx: dmabuf backed zerocopy receive
Date: Thu,  1 May 2025 13:17:18 +0100
Message-ID: <20bb1890e60a82ec945ab36370d1fd54be414ab6.1746097431.git.asml.silence@gmail.com>
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

Add support for dmabuf backed zcrx areas. To use it, the user should
pass IORING_ZCRX_AREA_DMABUF in the struct io_uring_zcrx_area_reg flags
field and pass a dmabuf fd in the dmabuf_fd field.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |   6 +-
 io_uring/zcrx.c               | 155 ++++++++++++++++++++++++++++++----
 io_uring/zcrx.h               |   7 ++
 3 files changed, 151 insertions(+), 17 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 130f3bc71a69..5ce096090b0c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -990,12 +990,16 @@ struct io_uring_zcrx_offsets {
 	__u64	__resv[2];
 };
 
+enum io_uring_zcrx_area_flags {
+	IORING_ZCRX_AREA_DMABUF		= 1,
+};
+
 struct io_uring_zcrx_area_reg {
 	__u64	addr;
 	__u64	len;
 	__u64	rq_area_token;
 	__u32	flags;
-	__u32	__resv1;
+	__u32	dmabuf_fd;
 	__u64	__resv2[2];
 };
 
diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index 34b09beba992..fac293bcba72 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -47,30 +47,110 @@ static inline struct page *io_zcrx_iov_page(const struct net_iov *niov)
 	return area->mem.pages[net_iov_idx(niov)];
 }
 
-static void io_release_area_mem(struct io_zcrx_mem *mem)
+static void io_release_dmabuf(struct io_zcrx_mem *mem)
 {
-	if (mem->pages) {
-		unpin_user_pages(mem->pages, mem->nr_folios);
-		kvfree(mem->pages);
+	if (mem->sgt)
+		dma_buf_unmap_attachment_unlocked(mem->attach, mem->sgt,
+						  DMA_FROM_DEVICE);
+	if (mem->attach)
+		dma_buf_detach(mem->dmabuf, mem->attach);
+	if (mem->dmabuf)
+		dma_buf_put(mem->dmabuf);
+
+	mem->sgt = NULL;
+	mem->attach = NULL;
+	mem->dmabuf = NULL;
+}
+
+static int io_import_dmabuf(struct io_zcrx_ifq *ifq,
+			    struct io_zcrx_mem *mem,
+			    struct io_uring_zcrx_area_reg *area_reg)
+{
+	unsigned long off = (unsigned long)area_reg->addr;
+	unsigned long len = (unsigned long)area_reg->len;
+	unsigned long total_size = 0;
+	struct scatterlist *sg;
+	int dmabuf_fd = area_reg->dmabuf_fd;
+	int i, ret;
+
+	if (WARN_ON_ONCE(!ifq->dev))
+		return -EFAULT;
+
+	mem->is_dmabuf = true;
+	mem->dmabuf = dma_buf_get(dmabuf_fd);
+	if (IS_ERR(mem->dmabuf)) {
+		ret = PTR_ERR(mem->dmabuf);
+		mem->dmabuf = NULL;
+		goto err;
+	}
+
+	mem->attach = dma_buf_attach(mem->dmabuf, ifq->dev);
+	if (IS_ERR(mem->attach)) {
+		ret = PTR_ERR(mem->attach);
+		mem->attach = NULL;
+		goto err;
+	}
+
+	mem->sgt = dma_buf_map_attachment_unlocked(mem->attach, DMA_FROM_DEVICE);
+	if (IS_ERR(mem->sgt)) {
+		ret = PTR_ERR(mem->sgt);
+		mem->sgt = NULL;
+		goto err;
 	}
+
+	for_each_sgtable_dma_sg(mem->sgt, sg, i)
+		total_size += sg_dma_len(sg);
+
+	if (total_size < off + len)
+		return -EINVAL;
+
+	mem->dmabuf_offset = off;
+	mem->size = len;
+	return 0;
+err:
+	io_release_dmabuf(mem);
+	return ret;
 }
 
-static int io_import_area(struct io_zcrx_ifq *ifq,
+static int io_zcrx_map_area_dmabuf(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
+{
+	unsigned long off = area->mem.dmabuf_offset;
+	struct scatterlist *sg;
+	unsigned i, niov_idx = 0;
+
+	for_each_sgtable_dma_sg(area->mem.sgt, sg, i) {
+		dma_addr_t dma = sg_dma_address(sg);
+		unsigned long sg_len = sg_dma_len(sg);
+		unsigned long sg_off = min(sg_len, off);
+
+		off -= sg_off;
+		sg_len -= sg_off;
+		dma += sg_off;
+
+		while (sg_len && niov_idx < area->nia.num_niovs) {
+			struct net_iov *niov = &area->nia.niovs[niov_idx];
+
+			if (net_mp_niov_set_dma_addr(niov, dma))
+				return 0;
+			sg_len -= PAGE_SIZE;
+			dma += PAGE_SIZE;
+			niov_idx++;
+		}
+	}
+	return niov_idx;
+}
+
+static int io_import_umem(struct io_zcrx_ifq *ifq,
 			  struct io_zcrx_mem *mem,
 			  struct io_uring_zcrx_area_reg *area_reg)
 {
 	struct page **pages;
 	int nr_pages;
-	int ret;
 
-	ret = io_validate_user_buf_range(area_reg->addr, area_reg->len);
-	if (ret)
-		return ret;
+	if (area_reg->dmabuf_fd)
+		return -EINVAL;
 	if (!area_reg->addr)
 		return -EFAULT;
-	if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
-		return -EINVAL;
-
 	pages = io_pin_pages((unsigned long)area_reg->addr, area_reg->len,
 				   &nr_pages);
 	if (IS_ERR(pages))
@@ -82,6 +162,35 @@ static int io_import_area(struct io_zcrx_ifq *ifq,
 	return 0;
 }
 
+static void io_release_area_mem(struct io_zcrx_mem *mem)
+{
+	if (mem->is_dmabuf) {
+		io_release_dmabuf(mem);
+		return;
+	}
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
+	int ret;
+
+	ret = io_validate_user_buf_range(area_reg->addr, area_reg->len);
+	if (ret)
+		return ret;
+	if (area_reg->addr & ~PAGE_MASK || area_reg->len & ~PAGE_MASK)
+		return -EINVAL;
+
+	if (area_reg->flags & IORING_ZCRX_AREA_DMABUF)
+		return io_import_dmabuf(ifq, mem, area_reg);
+	return io_import_umem(ifq, mem, area_reg);
+}
+
 static void io_zcrx_unmap_umem(struct io_zcrx_ifq *ifq,
 				struct io_zcrx_area *area, int nr_mapped)
 {
@@ -101,7 +210,10 @@ static void __io_zcrx_unmap_area(struct io_zcrx_ifq *ifq,
 {
 	int i;
 
-	io_zcrx_unmap_umem(ifq, area, nr_mapped);
+	if (area->mem.is_dmabuf)
+		io_release_dmabuf(&area->mem);
+	else
+		io_zcrx_unmap_umem(ifq, area, nr_mapped);
 
 	for (i = 0; i < area->nia.num_niovs; i++)
 		net_mp_niov_set_dma_addr(&area->nia.niovs[i], 0);
@@ -145,7 +257,11 @@ static int io_zcrx_map_area(struct io_zcrx_ifq *ifq, struct io_zcrx_area *area)
 	if (area->is_mapped)
 		return 0;
 
-	nr = io_zcrx_map_area_umem(ifq, area);
+	if (area->mem.is_dmabuf)
+		nr = io_zcrx_map_area_dmabuf(ifq, area);
+	else
+		nr = io_zcrx_map_area_umem(ifq, area);
+
 	if (nr != area->nia.num_niovs) {
 		__io_zcrx_unmap_area(ifq, area, nr);
 		return -EINVAL;
@@ -251,6 +367,8 @@ static void io_zcrx_free_area(struct io_zcrx_area *area)
 	kfree(area);
 }
 
+#define IO_ZCRX_AREA_SUPPORTED_FLAGS	(IORING_ZCRX_AREA_DMABUF)
+
 static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 			       struct io_zcrx_area **res,
 			       struct io_uring_zcrx_area_reg *area_reg)
@@ -259,9 +377,11 @@ static int io_zcrx_create_area(struct io_zcrx_ifq *ifq,
 	unsigned nr_iovs;
 	int i, ret;
 
-	if (area_reg->flags || area_reg->rq_area_token)
+	if (area_reg->flags & ~IO_ZCRX_AREA_SUPPORTED_FLAGS)
+		return -EINVAL;
+	if (area_reg->rq_area_token)
 		return -EINVAL;
-	if (area_reg->__resv1 || area_reg->__resv2[0] || area_reg->__resv2[1])
+	if (area_reg->__resv2[0] || area_reg->__resv2[1])
 		return -EINVAL;
 
 	ret = -ENOMEM;
@@ -819,6 +939,9 @@ static ssize_t io_zcrx_copy_chunk(struct io_kiocb *req, struct io_zcrx_ifq *ifq,
 	size_t copied = 0;
 	int ret = 0;
 
+	if (area->mem.is_dmabuf)
+		return -EFAULT;
+
 	while (len) {
 		size_t copy_size = min_t(size_t, PAGE_SIZE, len);
 		const int dst_off = 0;
diff --git a/io_uring/zcrx.h b/io_uring/zcrx.h
index 9c22807af807..2f5e26389f22 100644
--- a/io_uring/zcrx.h
+++ b/io_uring/zcrx.h
@@ -3,15 +3,22 @@
 #define IOU_ZC_RX_H
 
 #include <linux/io_uring_types.h>
+#include <linux/dma-buf.h>
 #include <linux/socket.h>
 #include <net/page_pool/types.h>
 #include <net/net_trackers.h>
 
 struct io_zcrx_mem {
 	unsigned long			size;
+	bool				is_dmabuf;
 
 	struct page			**pages;
 	unsigned long			nr_folios;
+
+	struct dma_buf_attachment	*attach;
+	struct dma_buf			*dmabuf;
+	struct sg_table			*sgt;
+	unsigned long			dmabuf_offset;
 };
 
 struct io_zcrx_area {
-- 
2.48.1


