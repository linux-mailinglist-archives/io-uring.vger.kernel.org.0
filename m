Return-Path: <io-uring+bounces-5021-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A28A9D7841
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF1D4281D5E
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8482A15FD13;
	Sun, 24 Nov 2024 21:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DhjVJrUF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C946163
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482742; cv=none; b=GleTxjcn8/pmfAv0eIYLBfQDEHS681JAUlhV4oRPeXZSSlHAt104mQjgdplfN7KvVklD9Mjx+BpAvuNULDqHDc3861Dbr+ix8/AMw0mowO7xj7dlxbicAc6FvhSM6ukbsGd9KmTDNk9hE2g8xPMJezaHNNAKu01YsuNO89Qz4+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482742; c=relaxed/simple;
	bh=qunIwsik9CJrbGOX0b2lyFAD0nodsGoh4Aek47k9Smw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xa17B9P5GmLPgzQli1IfZLX+EBIfVgWaYpxT8oqnbZEef9+RQOEptPQVg2a9LtPv42JSmJaUcbhBGH7sFsGkPNkcB9zLj9pgZlkKgh9w+f2mCTmQJBcT59a8CCAY8inOlnIFQ0S7Wc2J0iixGpuDxsmjA8p+rC7krj56camNXPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DhjVJrUF; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-382588b7a5cso2429666f8f.3
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482738; x=1733087538; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BSQND+9XVUkAsmMkZ/9UPwxAYa30YwMjtyKoN9vzpOY=;
        b=DhjVJrUFEuo7ZnQnSpOzAzdLER7vcNcLMhHvrOWt6Ich3sTDl+y67HqpYrUrmO+VOE
         vuTZtEH/lpgtf9TzswPfC5luD1oH33fZpyyNhH57d/dM8WlRNlBREbWOcmLcnDKS2bjN
         8KtrTrDMbrc6c/cZZ1BAV8TCcYDSW3QNpXxNbTj5sOtarNm+Pn1B3gHcbv01gIuXhIPP
         8+PrhkDmiN7pwxJSZ4fl/2kk7M5SjPNpuPQL/oFdUzSt5Hv9gBYgfhsVfhtNLeZE6VkE
         eJiiLONYlO941wjR1COseEZUyq/VouuQ0mzIwIovu1OPZus9W5bFWZrxXF7Hry0Z3V1E
         2SAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482738; x=1733087538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BSQND+9XVUkAsmMkZ/9UPwxAYa30YwMjtyKoN9vzpOY=;
        b=aI4MaBCOQQt1gbiwDmGrydkC9mpeqc9bjc9i9n8wkTNEpxjdx+suJNruUMpLFmhOY2
         OefqWWkk71AmYuUWlG7a1ti0yJM+PiHZuDuiY/bus8bg7qHxxG5E2dBWKtSRKUo/bBrE
         phd4+PK3StV8r+tuk6gCLcmWNfJUbk1hH+jWS0vv33Ry22rXSa1ngFa3jR/oihN21Eaw
         uWQMpf4VC6uSZe3D/GdC6DE9eUOM2cjgJMLeU8auCisgy5G/wjh9YC97epdbAXb7CwQl
         UIjYBYK5WLNjRtc/UYnoJ4u+kjxAGDVb4d82OWSxpCY63hAAg/aqNRmI1OFE6xE2hLAu
         yzPA==
X-Gm-Message-State: AOJu0Yy0GHyuM/oxFtg2uGvhag9/hqykR4aRX4Pwl+dZR0RempydB+fV
	DFzi1NWV3/tMNG74975qcNws8W7HtImiGjryHooe1YOrWbEXdmDZJYQOEA==
X-Gm-Gg: ASbGnctsapGkhI4qxtMuhiG7MrlI0fEK507NsgL5APGAfsSuHpUufca+PTJGFIe2x83
	1Jy1vMmFFSNxo95KRBfC9s6ttD44C9VLBDbGH95b1FvEIoTYjpZeHhKhGwYaaGK6qOjuUGz/Exr
	tqwO2FaeQ4n5+1887aHUT/dlgakEVJvqZDaz484uZDDyGc0FB7Z4plA5s3nG0qfU17bMh0DfXiG
	wcgxIFEy4Elpg7vxL2KY4G/nC7xKV8Uc4YE8zzDKiGNtfpHiBiGlckkrqD6Clg=
X-Google-Smtp-Source: AGHT+IE6FdhDbY37LYSDxMZ2H98HUCqBgPSJcqB5Iq+AWlY8RWtD9hL8JqWCaPAUMNyofrEKbiC8ig==
X-Received: by 2002:a5d:5f53:0:b0:382:4bb8:e1d with SMTP id ffacd0b85a97d-38260b4d616mr8587174f8f.1.1732482738491;
        Sun, 24 Nov 2024 13:12:18 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:18 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 14/18] io_uring: use region api for CQ
Date: Sun, 24 Nov 2024 21:12:31 +0000
Message-ID: <42b3eda88aed4b3542534747cb0ce22744042d98.1732481694.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1732481694.git.asml.silence@gmail.com>
References: <cover.1732481694.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert internal parts of the CQ/SQ array managment to the region API.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  8 +----
 io_uring/io_uring.c            | 36 +++++++---------------
 io_uring/memmap.c              | 55 +++++-----------------------------
 io_uring/memmap.h              |  4 ---
 io_uring/register.c            | 35 ++++++++++------------
 5 files changed, 36 insertions(+), 102 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3f353f269c6e..2db252841509 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -426,14 +426,8 @@ struct io_ring_ctx {
 	 */
 	struct mutex			mmap_lock;
 
-	/*
-	 * If IORING_SETUP_NO_MMAP is used, then the below holds
-	 * the gup'ed pages for the two rings, and the sqes.
-	 */
-	unsigned short			n_ring_pages;
-	struct page			**ring_pages;
-
 	struct io_mapped_region		sq_region;
+	struct io_mapped_region		ring_region;
 	/* used for optimised request parameter and wait argument passing  */
 	struct io_mapped_region		param_region;
 };
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a1dca7bce54a..b346a1f5f353 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2626,26 +2626,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
 
-static void *io_rings_map(struct io_ring_ctx *ctx, unsigned long uaddr,
-			  size_t size)
-{
-	return __io_uaddr_map(&ctx->ring_pages, &ctx->n_ring_pages, uaddr,
-				size);
-}
-
 static void io_rings_free(struct io_ring_ctx *ctx)
 {
-	if (!(ctx->flags & IORING_SETUP_NO_MMAP)) {
-		io_pages_unmap(ctx->rings, &ctx->ring_pages, &ctx->n_ring_pages,
-				true);
-	} else {
-		io_pages_free(&ctx->ring_pages, ctx->n_ring_pages);
-		ctx->n_ring_pages = 0;
-		vunmap(ctx->rings);
-	}
-
 	io_free_region(ctx, &ctx->sq_region);
-
+	io_free_region(ctx, &ctx->ring_region);
 	ctx->rings = NULL;
 	ctx->sq_sqes = NULL;
 }
@@ -3476,15 +3460,17 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	if (size == SIZE_MAX)
 		return -EOVERFLOW;
 
-	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
-		rings = io_pages_map(&ctx->ring_pages, &ctx->n_ring_pages, size);
-	else
-		rings = io_rings_map(ctx, p->cq_off.user_addr, size);
-
-	if (IS_ERR(rings))
-		return PTR_ERR(rings);
+	memset(&rd, 0, sizeof(rd));
+	rd.size = PAGE_ALIGN(size);
+	if (ctx->flags & IORING_SETUP_NO_MMAP) {
+		rd.user_addr = p->cq_off.user_addr;
+		rd.flags |= IORING_MEM_REGION_TYPE_USER;
+	}
+	ret = io_create_region(ctx, &ctx->ring_region, &rd, IORING_OFF_CQ_RING);
+	if (ret)
+		return ret;
+	ctx->rings = rings = io_region_get_ptr(&ctx->ring_region);
 
-	ctx->rings = rings;
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
 		ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
 	rings->sq_ring_mask = p->sq_entries - 1;
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 0a2d03bd312b..52afe0576be6 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -118,18 +118,6 @@ void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
 	*npages = 0;
 }
 
-void io_pages_free(struct page ***pages, int npages)
-{
-	struct page **page_array = *pages;
-
-	if (!page_array)
-		return;
-
-	unpin_user_pages(page_array, npages);
-	kvfree(page_array);
-	*pages = NULL;
-}
-
 struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 {
 	unsigned long start, end, nr_pages;
@@ -167,34 +155,6 @@ struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 	return ERR_PTR(ret);
 }
 
-void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
-		     unsigned long uaddr, size_t size)
-{
-	struct page **page_array;
-	unsigned int nr_pages;
-	void *page_addr;
-
-	*npages = 0;
-
-	if (uaddr & (PAGE_SIZE - 1) || !size)
-		return ERR_PTR(-EINVAL);
-
-	nr_pages = 0;
-	page_array = io_pin_pages(uaddr, size, &nr_pages);
-	if (IS_ERR(page_array))
-		return page_array;
-
-	page_addr = vmap(page_array, nr_pages, VM_MAP, PAGE_KERNEL);
-	if (page_addr) {
-		*pages = page_array;
-		*npages = nr_pages;
-		return page_addr;
-	}
-
-	io_pages_free(&page_array, nr_pages);
-	return ERR_PTR(-ENOMEM);
-}
-
 enum {
 	IO_REGION_F_VMAP			= 1,
 	IO_REGION_F_USER_PINNED			= 2,
@@ -383,9 +343,10 @@ static void *io_region_validate_mmap(struct io_ring_ctx *ctx,
 
 static int io_region_mmap(struct io_ring_ctx *ctx,
 			  struct io_mapped_region *mr,
-			  struct vm_area_struct *vma)
+			  struct vm_area_struct *vma,
+			  unsigned max_pages)
 {
-	unsigned long nr_pages = mr->nr_pages;
+	unsigned long nr_pages = min(mr->nr_pages, max_pages);
 
 	vm_flags_set(vma, VM_DONTEXPAND);
 	return vm_insert_pages(vma, vma->vm_start, mr->pages, &nr_pages);
@@ -449,7 +410,7 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	struct io_ring_ctx *ctx = file->private_data;
 	size_t sz = vma->vm_end - vma->vm_start;
 	long offset = vma->vm_pgoff << PAGE_SHIFT;
-	unsigned int npages;
+	unsigned int page_limit;
 	void *ptr;
 
 	guard(mutex)(&ctx->mmap_lock);
@@ -461,14 +422,14 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	switch (offset & IORING_OFF_MMAP_MASK) {
 	case IORING_OFF_SQ_RING:
 	case IORING_OFF_CQ_RING:
-		npages = min(ctx->n_ring_pages, (sz + PAGE_SIZE - 1) >> PAGE_SHIFT);
-		return io_uring_mmap_pages(ctx, vma, ctx->ring_pages, npages);
+		page_limit = (sz + PAGE_SIZE - 1) >> PAGE_SHIFT;
+		return io_region_mmap(ctx, &ctx->ring_region, vma, page_limit);
 	case IORING_OFF_SQES:
-		return io_region_mmap(ctx, &ctx->sq_region, vma);
+		return io_region_mmap(ctx, &ctx->sq_region, vma, UINT_MAX);
 	case IORING_OFF_PBUF_RING:
 		return io_pbuf_mmap(file, vma);
 	case IORING_MAP_OFF_PARAM_REGION:
-		return io_region_mmap(ctx, &ctx->param_region, vma);
+		return io_region_mmap(ctx, &ctx->param_region, vma, UINT_MAX);
 	}
 
 	return -EINVAL;
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index 2402bca3d700..7395996eb353 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -4,7 +4,6 @@
 #define IORING_MAP_OFF_PARAM_REGION		0x20000000ULL
 
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
-void io_pages_free(struct page ***pages, int npages);
 int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
 			struct page **pages, int npages);
 
@@ -13,9 +12,6 @@ void *io_pages_map(struct page ***out_pages, unsigned short *npages,
 void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
 		    bool put_pages);
 
-void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
-		     unsigned long uaddr, size_t size);
-
 #ifndef CONFIG_MMU
 unsigned int io_uring_nommu_mmap_capabilities(struct file *file);
 #endif
diff --git a/io_uring/register.c b/io_uring/register.c
index 44cd64923d31..f1698c18c7cb 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -367,26 +367,19 @@ static int io_register_clock(struct io_ring_ctx *ctx,
  * either mapping or freeing.
  */
 struct io_ring_ctx_rings {
-	unsigned short n_ring_pages;
-	struct page **ring_pages;
 	struct io_rings *rings;
-
 	struct io_uring_sqe *sq_sqes;
+
 	struct io_mapped_region sq_region;
+	struct io_mapped_region ring_region;
 };
 
 static void io_register_free_rings(struct io_ring_ctx *ctx,
 				   struct io_uring_params *p,
 				   struct io_ring_ctx_rings *r)
 {
-	if (!(p->flags & IORING_SETUP_NO_MMAP)) {
-		io_pages_unmap(r->rings, &r->ring_pages, &r->n_ring_pages,
-				true);
-	} else {
-		io_pages_free(&r->ring_pages, r->n_ring_pages);
-		vunmap(r->rings);
-	}
 	io_free_region(ctx, &r->sq_region);
+	io_free_region(ctx, &r->ring_region);
 }
 
 #define swap_old(ctx, o, n, field)		\
@@ -436,13 +429,18 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (size == SIZE_MAX)
 		return -EOVERFLOW;
 
-	if (!(p.flags & IORING_SETUP_NO_MMAP))
-		n.rings = io_pages_map(&n.ring_pages, &n.n_ring_pages, size);
-	else
-		n.rings = __io_uaddr_map(&n.ring_pages, &n.n_ring_pages,
-						p.cq_off.user_addr, size);
-	if (IS_ERR(n.rings))
-		return PTR_ERR(n.rings);
+	memset(&rd, 0, sizeof(rd));
+	rd.size = PAGE_ALIGN(size);
+	if (p.flags & IORING_SETUP_NO_MMAP) {
+		rd.user_addr = p.cq_off.user_addr;
+		rd.flags |= IORING_MEM_REGION_TYPE_USER;
+	}
+	ret = io_create_region_mmap_safe(ctx, &n.ring_region, &rd, IORING_OFF_CQ_RING);
+	if (ret) {
+		io_register_free_rings(ctx, &p, &n);
+		return ret;
+	}
+	n.rings = io_region_get_ptr(&n.ring_region);
 
 	n.rings->sq_ring_mask = p.sq_entries - 1;
 	n.rings->cq_ring_mask = p.cq_entries - 1;
@@ -552,8 +550,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 
 	ctx->rings = n.rings;
 	ctx->sq_sqes = n.sq_sqes;
-	swap_old(ctx, o, n, n_ring_pages);
-	swap_old(ctx, o, n, ring_pages);
+	swap_old(ctx, o, n, ring_region);
 	swap_old(ctx, o, n, sq_region);
 	to_free = &o;
 	ret = 0;
-- 
2.46.0


