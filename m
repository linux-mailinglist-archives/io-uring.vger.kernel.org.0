Return-Path: <io-uring+bounces-1318-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F988890E91
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 00:35:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23F3F295B50
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 23:35:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B67F445946;
	Thu, 28 Mar 2024 23:35:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="WcnfDlJo"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B5E225A8
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 23:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668913; cv=none; b=R8VWC5t6ohmKF97D6BSkiWhiN76DwginrucvhILaEJy19UIIF8l5kCepCAjy5i0RyBgLFLxJKEoLSvGrEb31UM/8X07k2yYlBfud9mgVWT3geyLeY8xuCAadsztDBpspvgSOPqTzKq7uaVLV3DGLynI6PBvGfCwuQuqYyngVvus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668913; c=relaxed/simple;
	bh=O+kS4JDASOdO5CqxGTE/lFx80kvhI11pQnz/ewuMMTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/IBWhgYLsef2L7Gxu1sNCTJVBUiDwIetv0GVjIn9fA6wbXkVLYbl2hJRaYCaRiuC+ptjRtavtHn3EX7hqWwVIo6RjdXmfJX+B0q7Z3J2/qVNagn4iA1uAUkrjaHFnMpb1+Pjajf7HzuiwiSiLwlnG6g4SThcYvDr7KQoIsHjv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=WcnfDlJo; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-29df844539bso409635a91.1
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 16:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711668909; x=1712273709; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0qg3i6J4NScNr25m5MiWnkmUy5W5kQx3QdqVHYNf+yM=;
        b=WcnfDlJoRbM1q+QvS/A54e9HAzspyxAR4che/c6cSMvM29KKPEW6Q+wXVxcaKpf7Sy
         yeF/lfxdt0G7VE+zAxo3zG6JBDfw4p0QzITYsG1GTaxBkVPd2hNGrWuW1maBkR4Eh9JY
         cBCe8C6Jz/c2zD5Nl4aMT1gwX36KYpPUN5xB+lZES2euk00A/WOnf0kTlojQZBKIYcuE
         B/43UtlbpF0wqRfMbFm4g3WTK0lTKUeOTslKe+e/Zvy0Tj3Vy/aSwJy0xZu6GyaJ4m2l
         heA7/p75wo9Xs5ByATgzbBhldY/v/HKv0Z/z5ZFYMcVt/WM4Ppd9xlk69zFoCyCyoV/m
         3vmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711668909; x=1712273709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0qg3i6J4NScNr25m5MiWnkmUy5W5kQx3QdqVHYNf+yM=;
        b=IH+OS3GzCoFPR+0++/8ZziwhuKdz3CrclIjqBWSQdvq6uDeHXKg6fP+Bt3gRI3GYG1
         8yFugICz8H5YfaJm3OTw0bix0e90jpkgXa/d09lC++wgcSSfQf1EYQy/53UcMefbJ9nZ
         KXy3kD3qiZ+n6QKcgNtTUUCfKtIGR172gz+DYH7cHqkWUPPhsysg0Wto4ErwFrQxRQ3C
         FbxaZBdRaW7zjyIgIf1EhnvofeAkh0/WZGN+i+gI/CRc3X6LVaR0+dGqbvopG7n765X3
         5eBCBq0D+fc1drQj0uC8b/jGnWgw1Q+8LZYyATi0kgCnLmzLH6gP8yWMhBg8xXvajjRB
         PZkA==
X-Gm-Message-State: AOJu0YxC5nYkr8S7bJbLkBa+aWYaa7uxcXQuNFKEvSjwF6ah3qsQmVRi
	af5pGiqW2hYbzJue6eZ7wNzZgzNszxyUNd0UC5kdt94TJ8ijR7Zrn5rEileXL6/Lt7HF2cuLrX5
	2
X-Google-Smtp-Source: AGHT+IHN8UgscSzWsLEG4Nvkd7sBZneZ8BoeCk4IYSS0kOTkknQZOWxXAp8abv5DaViRVSXpKY6YWg==
X-Received: by 2002:a17:902:aa83:b0:1dd:de68:46cf with SMTP id d3-20020a170902aa8300b001ddde6846cfmr895713plr.6.1711668908651;
        Thu, 28 Mar 2024 16:35:08 -0700 (PDT)
Received: from localhost.localdomain ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b001e0b3c9fe60sm2216981pla.46.2024.03.28.16.35.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:35:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: hannes@cmpxchg.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/11] io_uring: move mapping/allocation helpers to a separate file
Date: Thu, 28 Mar 2024 17:31:38 -0600
Message-ID: <20240328233443.797828-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240328233443.797828-1-axboe@kernel.dk>
References: <20240328233443.797828-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the related code from io_uring.c into memmap.c. No functional
changes in this patch, just cleaning it up a bit now that the full
transition is done.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/Makefile   |   3 +-
 io_uring/io_uring.c | 324 +-----------------------------------------
 io_uring/io_uring.h |   9 --
 io_uring/kbuf.c     |   1 +
 io_uring/memmap.c   | 333 ++++++++++++++++++++++++++++++++++++++++++++
 io_uring/memmap.h   |  25 ++++
 io_uring/rsrc.c     |   1 +
 7 files changed, 364 insertions(+), 332 deletions(-)
 create mode 100644 io_uring/memmap.c
 create mode 100644 io_uring/memmap.h

diff --git a/io_uring/Makefile b/io_uring/Makefile
index bd7c692a6a7c..fc1b23c524e8 100644
--- a/io_uring/Makefile
+++ b/io_uring/Makefile
@@ -8,7 +8,8 @@ obj-$(CONFIG_IO_URING)		+= io_uring.o opdef.o kbuf.o rsrc.o notif.o \
 					xattr.o nop.o fs.o splice.o sync.o \
 					msg_ring.o advise.o openclose.o \
 					epoll.o statx.o timeout.o fdinfo.o \
-					cancel.o waitid.o register.o truncate.o
+					cancel.o waitid.o register.o \
+					truncate.o memmap.o
 obj-$(CONFIG_IO_WQ)		+= io-wq.o
 obj-$(CONFIG_FUTEX)		+= futex.o
 obj-$(CONFIG_NET_RX_BUSY_POLL) += napi.o
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 00b98e80f8ca..fddaefb9cbff 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -95,6 +95,7 @@
 #include "futex.h"
 #include "napi.h"
 #include "uring_cmd.h"
+#include "memmap.h"
 
 #include "timeout.h"
 #include "poll.h"
@@ -2591,108 +2592,6 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
 
-void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
-		    bool put_pages)
-{
-	bool do_vunmap = false;
-
-	if (put_pages && *npages) {
-		struct page **to_free = *pages;
-		int i;
-
-		/*
-		 * Only did vmap for the non-compound multiple page case.
-		 * For the compound page, we just need to put the head.
-		 */
-		if (PageCompound(to_free[0]))
-			*npages = 1;
-		else if (*npages > 1)
-			do_vunmap = true;
-		for (i = 0; i < *npages; i++)
-			put_page(to_free[i]);
-	}
-	if (do_vunmap)
-		vunmap(ptr);
-	kvfree(*pages);
-	*pages = NULL;
-	*npages = 0;
-}
-
-static void io_pages_free(struct page ***pages, int npages)
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
-struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
-{
-	unsigned long start, end, nr_pages;
-	struct page **pages;
-	int ret;
-
-	end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	start = uaddr >> PAGE_SHIFT;
-	nr_pages = end - start;
-	if (WARN_ON_ONCE(!nr_pages))
-		return ERR_PTR(-EINVAL);
-
-	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
-	if (!pages)
-		return ERR_PTR(-ENOMEM);
-
-	ret = pin_user_pages_fast(uaddr, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
-					pages);
-	/* success, mapped all pages */
-	if (ret == nr_pages) {
-		*npages = nr_pages;
-		return pages;
-	}
-
-	/* partial map, or didn't map anything */
-	if (ret >= 0) {
-		/* if we did partial map, release any pages we did get */
-		if (ret)
-			unpin_user_pages(pages, ret);
-		ret = -EFAULT;
-	}
-	kvfree(pages);
-	return ERR_PTR(ret);
-}
-
-static void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
-			    unsigned long uaddr, size_t size)
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
 static void *io_rings_map(struct io_ring_ctx *ctx, unsigned long uaddr,
 			  size_t size)
 {
@@ -2727,80 +2626,6 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 	ctx->sq_sqes = NULL;
 }
 
-static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
-				   size_t size, gfp_t gfp)
-{
-	struct page *page;
-	int i, order;
-
-	order = get_order(size);
-	if (order > MAX_PAGE_ORDER)
-		return NULL;
-	else if (order)
-		gfp |= __GFP_COMP;
-
-	page = alloc_pages(gfp, order);
-	if (!page)
-		return NULL;
-
-	for (i = 0; i < nr_pages; i++)
-		pages[i] = page + i;
-
-	return page_address(page);
-}
-
-static void *io_mem_alloc_single(struct page **pages, int nr_pages, size_t size,
-				 gfp_t gfp)
-{
-	void *ret;
-	int i;
-
-	for (i = 0; i < nr_pages; i++) {
-		pages[i] = alloc_page(gfp);
-		if (!pages[i])
-			goto err;
-	}
-
-	ret = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
-	if (ret)
-		return ret;
-err:
-	while (i--)
-		put_page(pages[i]);
-	return ERR_PTR(-ENOMEM);
-}
-
-void *io_pages_map(struct page ***out_pages, unsigned short *npages,
-		   size_t size)
-{
-	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
-	struct page **pages;
-	int nr_pages;
-	void *ret;
-
-	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	pages = kvmalloc_array(nr_pages, sizeof(struct page *), gfp);
-	if (!pages)
-		return ERR_PTR(-ENOMEM);
-
-	ret = io_mem_alloc_compound(pages, nr_pages, size, gfp);
-	if (ret)
-		goto done;
-
-	ret = io_mem_alloc_single(pages, nr_pages, size, gfp);
-	if (ret) {
-done:
-		*out_pages = pages;
-		*npages = nr_pages;
-		return ret;
-	}
-
-	kvfree(pages);
-	*out_pages = NULL;
-	*npages = 0;
-	return ERR_PTR(-ENOMEM);
-}
-
 static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries,
 				unsigned int cq_entries, size_t *sq_offset)
 {
@@ -3361,149 +3186,6 @@ void __io_uring_cancel(bool cancel_all)
 	io_uring_cancel_generic(cancel_all, NULL);
 }
 
-static void *io_uring_validate_mmap_request(struct file *file,
-					    loff_t pgoff, size_t sz)
-{
-	struct io_ring_ctx *ctx = file->private_data;
-	loff_t offset = pgoff << PAGE_SHIFT;
-
-	switch ((pgoff << PAGE_SHIFT) & IORING_OFF_MMAP_MASK) {
-	case IORING_OFF_SQ_RING:
-	case IORING_OFF_CQ_RING:
-		/* Don't allow mmap if the ring was setup without it */
-		if (ctx->flags & IORING_SETUP_NO_MMAP)
-			return ERR_PTR(-EINVAL);
-		return ctx->rings;
-	case IORING_OFF_SQES:
-		/* Don't allow mmap if the ring was setup without it */
-		if (ctx->flags & IORING_SETUP_NO_MMAP)
-			return ERR_PTR(-EINVAL);
-		return ctx->sq_sqes;
-	case IORING_OFF_PBUF_RING: {
-		struct io_buffer_list *bl;
-		unsigned int bgid;
-		void *ret;
-
-		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
-		bl = io_pbuf_get_bl(ctx, bgid);
-		if (IS_ERR(bl))
-			return bl;
-		ret = bl->buf_ring;
-		io_put_bl(ctx, bl);
-		return ret;
-		}
-	}
-
-	return ERR_PTR(-EINVAL);
-}
-
-int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
-			struct page **pages, int npages)
-{
-	unsigned long nr_pages = npages;
-
-	vm_flags_set(vma, VM_DONTEXPAND);
-	return vm_insert_pages(vma, vma->vm_start, pages, &nr_pages);
-}
-
-#ifdef CONFIG_MMU
-
-static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	struct io_ring_ctx *ctx = file->private_data;
-	size_t sz = vma->vm_end - vma->vm_start;
-	long offset = vma->vm_pgoff << PAGE_SHIFT;
-	void *ptr;
-
-	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff, sz);
-	if (IS_ERR(ptr))
-		return PTR_ERR(ptr);
-
-	switch (offset & IORING_OFF_MMAP_MASK) {
-	case IORING_OFF_SQ_RING:
-	case IORING_OFF_CQ_RING:
-		return io_uring_mmap_pages(ctx, vma, ctx->ring_pages,
-						ctx->n_ring_pages);
-	case IORING_OFF_SQES:
-		return io_uring_mmap_pages(ctx, vma, ctx->sqe_pages,
-						ctx->n_sqe_pages);
-	case IORING_OFF_PBUF_RING:
-		return io_pbuf_mmap(file, vma);
-	}
-
-	return -EINVAL;
-}
-
-static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
-			unsigned long addr, unsigned long len,
-			unsigned long pgoff, unsigned long flags)
-{
-	void *ptr;
-
-	/*
-	 * Do not allow to map to user-provided address to avoid breaking the
-	 * aliasing rules. Userspace is not able to guess the offset address of
-	 * kernel kmalloc()ed memory area.
-	 */
-	if (addr)
-		return -EINVAL;
-
-	ptr = io_uring_validate_mmap_request(filp, pgoff, len);
-	if (IS_ERR(ptr))
-		return -ENOMEM;
-
-	/*
-	 * Some architectures have strong cache aliasing requirements.
-	 * For such architectures we need a coherent mapping which aliases
-	 * kernel memory *and* userspace memory. To achieve that:
-	 * - use a NULL file pointer to reference physical memory, and
-	 * - use the kernel virtual address of the shared io_uring context
-	 *   (instead of the userspace-provided address, which has to be 0UL
-	 *   anyway).
-	 * - use the same pgoff which the get_unmapped_area() uses to
-	 *   calculate the page colouring.
-	 * For architectures without such aliasing requirements, the
-	 * architecture will return any suitable mapping because addr is 0.
-	 */
-	filp = NULL;
-	flags |= MAP_SHARED;
-	pgoff = 0;	/* has been translated to ptr above */
-#ifdef SHM_COLOUR
-	addr = (uintptr_t) ptr;
-	pgoff = addr >> PAGE_SHIFT;
-#else
-	addr = 0UL;
-#endif
-	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
-}
-
-#else /* !CONFIG_MMU */
-
-static int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
-{
-	return is_nommu_shared_mapping(vma->vm_flags) ? 0 : -EINVAL;
-}
-
-static unsigned int io_uring_nommu_mmap_capabilities(struct file *file)
-{
-	return NOMMU_MAP_DIRECT | NOMMU_MAP_READ | NOMMU_MAP_WRITE;
-}
-
-static unsigned long io_uring_nommu_get_unmapped_area(struct file *file,
-	unsigned long addr, unsigned long len,
-	unsigned long pgoff, unsigned long flags)
-{
-	void *ptr;
-
-	ptr = io_uring_validate_mmap_request(file, pgoff, len);
-	if (IS_ERR(ptr))
-		return PTR_ERR(ptr);
-
-	return (unsigned long) ptr;
-}
-
-#endif /* !CONFIG_MMU */
-
 static int io_validate_ext_arg(unsigned flags, const void __user *argp, size_t argsz)
 {
 	if (flags & IORING_ENTER_EXT_ARG) {
@@ -3686,11 +3368,9 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 static const struct file_operations io_uring_fops = {
 	.release	= io_uring_release,
 	.mmap		= io_uring_mmap,
+	.get_unmapped_area = io_uring_get_unmapped_area,
 #ifndef CONFIG_MMU
-	.get_unmapped_area = io_uring_nommu_get_unmapped_area,
 	.mmap_capabilities = io_uring_nommu_mmap_capabilities,
-#else
-	.get_unmapped_area = io_uring_mmu_get_unmapped_area,
 #endif
 	.poll		= io_uring_poll,
 #ifdef CONFIG_PROC_FS
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index dec996a1c789..1eb65324792a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -69,10 +69,6 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
-struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
-int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
-			struct page **pages, int npages);
-
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
@@ -109,11 +105,6 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
 
-void *io_pages_map(struct page ***out_pages, unsigned short *npages,
-		   size_t size);
-void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
-		    bool put_pages);
-
 enum {
 	IO_EVENTFD_OP_SIGNAL_BIT,
 	IO_EVENTFD_OP_FREE_BIT,
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3ba576ccb1d9..96dd8d05c754 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -15,6 +15,7 @@
 #include "io_uring.h"
 #include "opdef.h"
 #include "kbuf.h"
+#include "memmap.h"
 
 #define IO_BUFFER_LIST_BUF_PER_PAGE (PAGE_SIZE / sizeof(struct io_uring_buf))
 
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
new file mode 100644
index 000000000000..acf5e8ca6b28
--- /dev/null
+++ b/io_uring/memmap.c
@@ -0,0 +1,333 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/errno.h>
+#include <linux/mm.h>
+#include <linux/mman.h>
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/io_uring.h>
+#include <linux/io_uring_types.h>
+#include <asm/shmparam.h>
+
+#include "memmap.h"
+#include "kbuf.h"
+
+static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
+				   size_t size, gfp_t gfp)
+{
+	struct page *page;
+	int i, order;
+
+	order = get_order(size);
+	if (order > MAX_PAGE_ORDER)
+		return NULL;
+	else if (order)
+		gfp |= __GFP_COMP;
+
+	page = alloc_pages(gfp, order);
+	if (!page)
+		return NULL;
+
+	for (i = 0; i < nr_pages; i++)
+		pages[i] = page + i;
+
+	return page_address(page);
+}
+
+static void *io_mem_alloc_single(struct page **pages, int nr_pages, size_t size,
+				 gfp_t gfp)
+{
+	void *ret;
+	int i;
+
+	for (i = 0; i < nr_pages; i++) {
+		pages[i] = alloc_page(gfp);
+		if (!pages[i])
+			goto err;
+	}
+
+	ret = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (ret)
+		return ret;
+err:
+	while (i--)
+		put_page(pages[i]);
+	return ERR_PTR(-ENOMEM);
+}
+
+void *io_pages_map(struct page ***out_pages, unsigned short *npages,
+		   size_t size)
+{
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
+	struct page **pages;
+	int nr_pages;
+	void *ret;
+
+	nr_pages = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	pages = kvmalloc_array(nr_pages, sizeof(struct page *), gfp);
+	if (!pages)
+		return ERR_PTR(-ENOMEM);
+
+	ret = io_mem_alloc_compound(pages, nr_pages, size, gfp);
+	if (ret)
+		goto done;
+
+	ret = io_mem_alloc_single(pages, nr_pages, size, gfp);
+	if (ret) {
+done:
+		*out_pages = pages;
+		*npages = nr_pages;
+		return ret;
+	}
+
+	kvfree(pages);
+	*out_pages = NULL;
+	*npages = 0;
+	return ERR_PTR(-ENOMEM);
+}
+
+void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
+		    bool put_pages)
+{
+	bool do_vunmap = false;
+
+	if (put_pages && *npages) {
+		struct page **to_free = *pages;
+		int i;
+
+		/*
+		 * Only did vmap for the non-compound multiple page case.
+		 * For the compound page, we just need to put the head.
+		 */
+		if (PageCompound(to_free[0]))
+			*npages = 1;
+		else if (*npages > 1)
+			do_vunmap = true;
+		for (i = 0; i < *npages; i++)
+			put_page(to_free[i]);
+	}
+	if (do_vunmap)
+		vunmap(ptr);
+	kvfree(*pages);
+	*pages = NULL;
+	*npages = 0;
+}
+
+void io_pages_free(struct page ***pages, int npages)
+{
+	struct page **page_array = *pages;
+
+	if (!page_array)
+		return;
+
+	unpin_user_pages(page_array, npages);
+	kvfree(page_array);
+	*pages = NULL;
+}
+
+struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
+{
+	unsigned long start, end, nr_pages;
+	struct page **pages;
+	int ret;
+
+	end = (uaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	start = uaddr >> PAGE_SHIFT;
+	nr_pages = end - start;
+	if (WARN_ON_ONCE(!nr_pages))
+		return ERR_PTR(-EINVAL);
+
+	pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
+	if (!pages)
+		return ERR_PTR(-ENOMEM);
+
+	ret = pin_user_pages_fast(uaddr, nr_pages, FOLL_WRITE | FOLL_LONGTERM,
+					pages);
+	/* success, mapped all pages */
+	if (ret == nr_pages) {
+		*npages = nr_pages;
+		return pages;
+	}
+
+	/* partial map, or didn't map anything */
+	if (ret >= 0) {
+		/* if we did partial map, release any pages we did get */
+		if (ret)
+			unpin_user_pages(pages, ret);
+		ret = -EFAULT;
+	}
+	kvfree(pages);
+	return ERR_PTR(ret);
+}
+
+void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
+		     unsigned long uaddr, size_t size)
+{
+	struct page **page_array;
+	unsigned int nr_pages;
+	void *page_addr;
+
+	*npages = 0;
+
+	if (uaddr & (PAGE_SIZE - 1) || !size)
+		return ERR_PTR(-EINVAL);
+
+	nr_pages = 0;
+	page_array = io_pin_pages(uaddr, size, &nr_pages);
+	if (IS_ERR(page_array))
+		return page_array;
+
+	page_addr = vmap(page_array, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (page_addr) {
+		*pages = page_array;
+		*npages = nr_pages;
+		return page_addr;
+	}
+
+	io_pages_free(&page_array, nr_pages);
+	return ERR_PTR(-ENOMEM);
+}
+
+static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
+					    size_t sz)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+	loff_t offset = pgoff << PAGE_SHIFT;
+
+	switch ((pgoff << PAGE_SHIFT) & IORING_OFF_MMAP_MASK) {
+	case IORING_OFF_SQ_RING:
+	case IORING_OFF_CQ_RING:
+		/* Don't allow mmap if the ring was setup without it */
+		if (ctx->flags & IORING_SETUP_NO_MMAP)
+			return ERR_PTR(-EINVAL);
+		return ctx->rings;
+	case IORING_OFF_SQES:
+		/* Don't allow mmap if the ring was setup without it */
+		if (ctx->flags & IORING_SETUP_NO_MMAP)
+			return ERR_PTR(-EINVAL);
+		return ctx->sq_sqes;
+	case IORING_OFF_PBUF_RING: {
+		struct io_buffer_list *bl;
+		unsigned int bgid;
+		void *ret;
+
+		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
+		bl = io_pbuf_get_bl(ctx, bgid);
+		if (IS_ERR(bl))
+			return bl;
+		ret = bl->buf_ring;
+		io_put_bl(ctx, bl);
+		return ret;
+		}
+	}
+
+	return ERR_PTR(-EINVAL);
+}
+
+int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
+			struct page **pages, int npages)
+{
+	unsigned long nr_pages = npages;
+
+	vm_flags_set(vma, VM_DONTEXPAND);
+	return vm_insert_pages(vma, vma->vm_start, pages, &nr_pages);
+}
+
+#ifdef CONFIG_MMU
+
+__cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct io_ring_ctx *ctx = file->private_data;
+	size_t sz = vma->vm_end - vma->vm_start;
+	long offset = vma->vm_pgoff << PAGE_SHIFT;
+	void *ptr;
+
+	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff, sz);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	switch (offset & IORING_OFF_MMAP_MASK) {
+	case IORING_OFF_SQ_RING:
+	case IORING_OFF_CQ_RING:
+		return io_uring_mmap_pages(ctx, vma, ctx->ring_pages,
+						ctx->n_ring_pages);
+	case IORING_OFF_SQES:
+		return io_uring_mmap_pages(ctx, vma, ctx->sqe_pages,
+						ctx->n_sqe_pages);
+	case IORING_OFF_PBUF_RING:
+		return io_pbuf_mmap(file, vma);
+	}
+
+	return -EINVAL;
+}
+
+unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
+					 unsigned long len, unsigned long pgoff,
+					 unsigned long flags)
+{
+	void *ptr;
+
+	/*
+	 * Do not allow to map to user-provided address to avoid breaking the
+	 * aliasing rules. Userspace is not able to guess the offset address of
+	 * kernel kmalloc()ed memory area.
+	 */
+	if (addr)
+		return -EINVAL;
+
+	ptr = io_uring_validate_mmap_request(filp, pgoff, len);
+	if (IS_ERR(ptr))
+		return -ENOMEM;
+
+	/*
+	 * Some architectures have strong cache aliasing requirements.
+	 * For such architectures we need a coherent mapping which aliases
+	 * kernel memory *and* userspace memory. To achieve that:
+	 * - use a NULL file pointer to reference physical memory, and
+	 * - use the kernel virtual address of the shared io_uring context
+	 *   (instead of the userspace-provided address, which has to be 0UL
+	 *   anyway).
+	 * - use the same pgoff which the get_unmapped_area() uses to
+	 *   calculate the page colouring.
+	 * For architectures without such aliasing requirements, the
+	 * architecture will return any suitable mapping because addr is 0.
+	 */
+	filp = NULL;
+	flags |= MAP_SHARED;
+	pgoff = 0;	/* has been translated to ptr above */
+#ifdef SHM_COLOUR
+	addr = (uintptr_t) ptr;
+	pgoff = addr >> PAGE_SHIFT;
+#else
+	addr = 0UL;
+#endif
+	return current->mm->get_unmapped_area(filp, addr, len, pgoff, flags);
+}
+
+#else /* !CONFIG_MMU */
+
+int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	return is_nommu_shared_mapping(vma->vm_flags) ? 0 : -EINVAL;
+}
+
+unsigned int io_uring_nommu_mmap_capabilities(struct file *file)
+{
+	return NOMMU_MAP_DIRECT | NOMMU_MAP_READ | NOMMU_MAP_WRITE;
+}
+
+unsigned long io_uring_get_unmapped_area(struct file *file, unsigned long addr,
+					 unsigned long len, unsigned long pgoff,
+					 unsigned long flags)
+{
+	void *ptr;
+
+	ptr = io_uring_validate_mmap_request(file, pgoff, len);
+	if (IS_ERR(ptr))
+		return PTR_ERR(ptr);
+
+	return (unsigned long) ptr;
+}
+
+#endif /* !CONFIG_MMU */
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
new file mode 100644
index 000000000000..5cec5b7ac49a
--- /dev/null
+++ b/io_uring/memmap.h
@@ -0,0 +1,25 @@
+#ifndef IO_URING_MEMMAP_H
+#define IO_URING_MEMMAP_H
+
+struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
+void io_pages_free(struct page ***pages, int npages);
+int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
+			struct page **pages, int npages);
+
+void *io_pages_map(struct page ***out_pages, unsigned short *npages,
+		   size_t size);
+void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
+		    bool put_pages);
+
+void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
+		     unsigned long uaddr, size_t size);
+
+#ifndef CONFIG_MMU
+unsigned int io_uring_nommu_mmap_capabilities(struct file *file);
+#endif
+unsigned long io_uring_get_unmapped_area(struct file *file, unsigned long addr,
+					 unsigned long len, unsigned long pgoff,
+					 unsigned long flags);
+int io_uring_mmap(struct file *file, struct vm_area_struct *vma);
+
+#endif
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 8a34181c97ab..65417c9553b1 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -16,6 +16,7 @@
 #include "alloc_cache.h"
 #include "openclose.h"
 #include "rsrc.h"
+#include "memmap.h"
 
 struct io_rsrc_update {
 	struct file			*file;
-- 
2.43.0


