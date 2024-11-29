Return-Path: <io-uring+bounces-5145-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AD37A9DE7B1
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6EAA3281741
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C641D19CC3F;
	Fri, 29 Nov 2024 13:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cOq4I7my"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com [209.85.167.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADBEC19E99A
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887251; cv=none; b=bVQvCWtv8x3vkqJZVN2Hov8GfEGpTp9jCUib2NOlsf7FExpES+YFsO2xCCyjWnGonSuh3PRLMR5u7KELImXCN/rWXDxGaITfOTpZmyN20czDhYC5gwWg87nto89KCpw1c8ioc8VQKm4XzHPGX5bW8EEqvuZqZ9p+GjevkBCxdQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887251; c=relaxed/simple;
	bh=Z1JNsz7s9fM29IKe+kETGMzNtjoeevXqbsgA5LxWCyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MygTGYjA+4pChx6YMc3R89XtcZ4kmhyJqFdK0qmN4I1HV3N9xFG/QYBBq7LXEL+6oi/XsVgEifOXh0cegQAeK7Mr6jGCnX9cU9XefK4uvFlAVUiF8Q+gkOTkGjN9RBZfgRycqiaescmM0zvdYODGiUQtEN4UkGnb2cfjVap/zHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cOq4I7my; arc=none smtp.client-ip=209.85.167.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f47.google.com with SMTP id 2adb3069b0e04-53dd2fdcebcso2251929e87.0
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887247; x=1733492047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pUrcV/+245WYhaI60GoMPB6fD2CLfdvaS+bPhyo8mxE=;
        b=cOq4I7myvmCsKi/lWeH6JSr3SV55lCzUt7dkhswr3hbTnr1ZfNrdcTPZAb2vInE7Ly
         5CsRD3mQCGpkdQTn3fft+MGkwqHBqhKAxR/klM9ndq+F1+PUl2bFomNbrR95m0g3H7Ro
         3gQGG1TKXcTKG+RH/PiXd6sOXX46e+Gfjl9xG4Xh5v3VO9Bk4Bjn7fs8cTukVe0sTHR7
         3WWm9jtxqe9vJuHhvnTp9tMZc7KWuYiC2HM4Iqh8wPeaTRZ7x8uojcKgZl4Y59Yo47do
         rG1VG8d/2v62i8R5nH/lwl+s/Ofo29iLAYLMIcx48kdNZfQofi5U8t1vcMR+5pKYKqJY
         Z5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887247; x=1733492047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pUrcV/+245WYhaI60GoMPB6fD2CLfdvaS+bPhyo8mxE=;
        b=T3QgQQDdPUMv1HqHOJOedxin9OpAD8ZcvJeEa9leuItEKN3jMep+j/aNe2R7AdqNTu
         CY9wBNu68sut74YeFAznwhe/yPFvmuTtkkgkg+3g/a02532T+qzo6O8Hg8io4zU1t6Pm
         im+0uBothgXUM93Sm5jv2miHGTi7WaOti/+wzKtqZ9hEPAoow9UuAWf0Ez5HMOmHhP3l
         9OwUq6p2JLUAMgdrPDr90gXQkHKlwWn3CQqQDh2aTQzTNgbiSFwanE5TQFzoo1678WPG
         qHdxxXNjAb8vJO4OMkNivERMDUsjCoUdHxxnC9KSl3C6uG2sISMC9x6a0YwwnEv5KLQe
         J1Cg==
X-Gm-Message-State: AOJu0YzPvHJT7T/DMbWOv1az0xzzMUcYS6zFvJS/kPu3oQh+HimeLiyR
	P38By/NzFrAYtERkgqTLnco1p2IaYpTwlrIlS5P3ptxMpJzGuCRKpIG/8A==
X-Gm-Gg: ASbGncvhM5opqMdnJ69+gNl3rLbfwQ5EtcWbsXhBitr3XwAxper4Gt4sPLlAdvcF0fq
	Du0f0P1OkM8Fddh5FbsqYqQlhXjfzbrErRNtNFQUArKowEPOX7T4asVtqpX67bXpjbRK75DaBM+
	1RB/FrEm3fxIy2atvmUFP4+lSQtdSuP68ZhKys/KC7CWRRRyQZ/GbJxiKtLWNg4cLDA52+NyDxW
	eXOjc7zm/8gWOxbxyv0wgbf9gDFOqNn9cszDyVLOi6yMKi4I9YMy/O6lS2+F3XU
X-Google-Smtp-Source: AGHT+IE2kX/SQASdXVk7VG0DWiGp8aeNi26RUtj8fzQwqOsNg0BBiKVXgapXfM1D5onVOMQ73oCMVA==
X-Received: by 2002:a05:6512:3a8e:b0:53d:ede4:35ff with SMTP id 2adb3069b0e04-53df00ff716mr7721731e87.38.1732887247285;
        Fri, 29 Nov 2024 05:34:07 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.34.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:34:06 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 14/18] io_uring: use region api for CQ
Date: Fri, 29 Nov 2024 13:34:35 +0000
Message-ID: <46fc3c801290d6b1ac16023d78f6b8e685c87fd6.1732886067.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1732886067.git.asml.silence@gmail.com>
References: <cover.1732886067.git.asml.silence@gmail.com>
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
index 2ac80b4d4016..bc0ab2bb7ae2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2630,26 +2630,10 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events, u32 flags,
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
@@ -3480,15 +3464,17 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
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
index b9aaa25182a5..668b1c3579a2 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -120,18 +120,6 @@ void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
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
@@ -174,34 +162,6 @@ struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
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
 	/* memory was vmap'ed for the kernel, freeing the region vunmap's it */
 	IO_REGION_F_VMAP			= 1,
@@ -446,9 +406,10 @@ int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
 
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
@@ -459,7 +420,7 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	struct io_ring_ctx *ctx = file->private_data;
 	size_t sz = vma->vm_end - vma->vm_start;
 	long offset = vma->vm_pgoff << PAGE_SHIFT;
-	unsigned int npages;
+	unsigned int page_limit;
 	void *ptr;
 
 	guard(mutex)(&ctx->mmap_lock);
@@ -471,14 +432,14 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
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
2.47.1


