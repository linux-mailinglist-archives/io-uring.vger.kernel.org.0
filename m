Return-Path: <io-uring+bounces-1256-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E333088EF10
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:19:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 71ED71F2FDA0
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 19:19:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E82D7152164;
	Wed, 27 Mar 2024 19:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VfbwFr7b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A56412E1F6
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 19:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567182; cv=none; b=NCRIOWfbgZxS2fN4o44sAadXJnZ3zlmYt3xjCWHeQI+cyPQr2YPq282eI89JtvEbeZZ0T2HQoaCIMgLOKai3R9+gkrBuFZeu+itQ9O4p5TAmwYLknwzuyksOQOBd5PZDw/M5FGp0WyFVxck3L3I4CIgpC/R5CA/tsOhDcmaWH78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567182; c=relaxed/simple;
	bh=i0gg2I8Wvze9K+4XovDNf37+pVA0JTmeTXyZpCy7Rc4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j7UxYptz0jgZ7uR0iPPcVnb6jDbYZQwDstRdMaw4EZSdFfJWJLpsjh7ZIeoOD0qYDRlT0KubfouyA8iyLcrjgUL/2YyDm6DIHUny754AOXd/B5st2rGr8SUaL5PhAvSM3QJ9aaKPR59uMVxAwN7kI0y9YnaVKnndsr+YaJGam+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VfbwFr7b; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e6c38be762so41806b3a.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 12:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711567179; x=1712171979; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uuOe3XlWJv29sqx0Tp2SbJ3PRazdewWUbq1djwJUsNw=;
        b=VfbwFr7bzucR7XjdEAyVE3lCYVmdkbwimKfZWdbIaE2VpkpOyyc6HW2YJlom/6zfT7
         N0Hv7NXNMhYVGc3uVM/ZrBcZ+3x9UTRBJ4AZ6lNI3cBmRBevSljM1O/7fSCj0lkNlL0Q
         9f48GXYfaM+S7cUe7noe8rlTnd8Y5sdo6TPWV8m/+yqgSOf9tpOqq34DERZE0ZhJrsVw
         +Zk2bRm8dD55VQ3eKgjgcJ2N9hB887UBvnpGgSURiU0k0zK0RCekRycvjTk+/u1drJnY
         JLznPaeZsexJKHFIvxyGmVrnp+0tO+qqeHqIy2Oi7gQpMWJTRrHGP5ib6LILeKftSwt5
         klRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711567179; x=1712171979;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uuOe3XlWJv29sqx0Tp2SbJ3PRazdewWUbq1djwJUsNw=;
        b=wjUh4jrGCMNLIEtvjreLseXtohkhzgxdQIS4ajocveE2dqk1qfkVsfmxsT0IY2jWLp
         i9t8b5+jCUyYVc+k9uY02FqC4R5rqmkUGpHtLfuT+Rnk3n0hCmnxTr6A3v1REv/YMNeb
         ZVCkpUQ/Jgu+QqssYReS2srfIgVTrIwSfOldeBXPNIbNKBNFEhqvZTbX/QmiZKu9IZ8U
         ogazsy3oeAHzQaxcVo8Vp9q8ZVf/DfWU/o2l2VhsTDaLMOWCtV9Txyez0JifysCiFnXN
         aKx+Cz7XHvTQhGBkhQy/z3cSRlrPpSrxozeGCMBmG5eXhxWD7G3vICNSdAd6mb77NPUH
         Jvag==
X-Gm-Message-State: AOJu0YwW8cfy7MGPzhc+zfm/NvePYSLIwAcDED1SYw6KGSVy1H3CCiCW
	qJM3HSSiilwbzSwwN734P6VEBD8/xTy+Hbrir63v3/uZJl4qppuPasKYOmNi/2GShJrW63x+YKO
	X
X-Google-Smtp-Source: AGHT+IE3yfaYbrwpWzllfExSPt6tkMj/aItR55D/Qqo/XaZDjoygbDahSWMzk2J7Xwf8355nOOvTpw==
X-Received: by 2002:a05:6a20:3ca1:b0:1a3:b0a8:fbe9 with SMTP id b33-20020a056a203ca100b001a3b0a8fbe9mr1034935pzj.1.1711567179057;
        Wed, 27 Mar 2024 12:19:39 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79842000000b006e6c3753786sm8278882pfq.41.2024.03.27.12.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 12:19:38 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/10] io_uring: get rid of remap_pfn_range() for mapping rings/sqes
Date: Wed, 27 Mar 2024 13:13:37 -0600
Message-ID: <20240327191933.607220-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240327191933.607220-1-axboe@kernel.dk>
References: <20240327191933.607220-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than use remap_pfn_range() for this and manually free later,
switch to using vm_insert_pages() and have it Just Work.

If possible, allocate a single compound page that covers the range that
is needed. If that works, then we can just use page_address() on that
page. If we fail to get a compound page, allocate single pages and use
vmap() to map them into the kernel virtual address space.

This just covers the rings/sqes, the other remaining user of the mmap
remap_pfn_range() user will be converted separately. Once that is done,
we can kill the old alloc/free code.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 134 +++++++++++++++++++++++++++++++++++++++++---
 io_uring/io_uring.h |   2 +
 2 files changed, 128 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 585fbc363eaf..29d0c1764aab 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2601,6 +2601,27 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
 
+static void io_pages_unmap(void *ptr, struct page ***pages,
+			   unsigned short *npages)
+{
+	bool do_vunmap = false;
+
+	if (*npages) {
+		struct page **to_free = *pages;
+		int i;
+
+		/* only did vmap for non-compound and multiple pages */
+		do_vunmap = !PageCompound(to_free[0]) && *npages > 1;
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
 void io_mem_free(void *ptr)
 {
 	if (!ptr)
@@ -2701,8 +2722,8 @@ static void *io_sqes_map(struct io_ring_ctx *ctx, unsigned long uaddr,
 static void io_rings_free(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP)) {
-		io_mem_free(ctx->rings);
-		io_mem_free(ctx->sq_sqes);
+		io_pages_unmap(ctx->rings, &ctx->ring_pages, &ctx->n_ring_pages);
+		io_pages_unmap(ctx->sq_sqes, &ctx->sqe_pages, &ctx->n_sqe_pages);
 	} else {
 		io_pages_free(&ctx->ring_pages, ctx->n_ring_pages);
 		ctx->n_ring_pages = 0;
@@ -2714,6 +2735,84 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 	ctx->sq_sqes = NULL;
 }
 
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
+	/* add pages, grab a ref to tail pages */
+	for (i = 0; i < nr_pages; i++) {
+		pages[i] = page + i;
+		if (i)
+			get_page(pages[i]);
+	}
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
+	ret = vmap(pages, nr_pages, VM_MAP | VM_ALLOW_HUGE_VMAP, PAGE_KERNEL);
+	if (ret)
+		return ret;
+err:
+	while (i--)
+		put_page(pages[i]);
+	return ERR_PTR(-ENOMEM);
+}
+
+static void *io_pages_map(struct page ***out_pages, unsigned short *npages,
+			  size_t size)
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
 void *io_mem_alloc(size_t size)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
@@ -3301,14 +3400,12 @@ static void *io_uring_validate_mmap_request(struct file *file,
 		/* Don't allow mmap if the ring was setup without it */
 		if (ctx->flags & IORING_SETUP_NO_MMAP)
 			return ERR_PTR(-EINVAL);
-		ptr = ctx->rings;
-		break;
+		return ctx->rings;
 	case IORING_OFF_SQES:
 		/* Don't allow mmap if the ring was setup without it */
 		if (ctx->flags & IORING_SETUP_NO_MMAP)
 			return ERR_PTR(-EINVAL);
-		ptr = ctx->sq_sqes;
-		break;
+		return ctx->sq_sqes;
 	case IORING_OFF_PBUF_RING: {
 		unsigned int bgid;
 
@@ -3331,11 +3428,22 @@ static void *io_uring_validate_mmap_request(struct file *file,
 	return ptr;
 }
 
+int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
+			struct page **pages, int npages)
+{
+	unsigned long nr_pages = npages;
+
+	vm_flags_set(vma, VM_DONTEXPAND);
+	return vm_insert_pages(vma, vma->vm_start, pages, &nr_pages);
+}
+
 #ifdef CONFIG_MMU
 
 static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct io_ring_ctx *ctx = file->private_data;
 	size_t sz = vma->vm_end - vma->vm_start;
+	long offset = vma->vm_pgoff << PAGE_SHIFT;
 	unsigned long pfn;
 	void *ptr;
 
@@ -3343,6 +3451,16 @@ static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
 
+	switch (offset & IORING_OFF_MMAP_MASK) {
+	case IORING_OFF_SQ_RING:
+	case IORING_OFF_CQ_RING:
+		return io_uring_mmap_pages(ctx, vma, ctx->ring_pages,
+						ctx->n_ring_pages);
+	case IORING_OFF_SQES:
+		return io_uring_mmap_pages(ctx, vma, ctx->sqe_pages,
+						ctx->n_sqe_pages);
+	}
+
 	pfn = virt_to_phys(ptr) >> PAGE_SHIFT;
 	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
 }
@@ -3632,7 +3750,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 		return -EOVERFLOW;
 
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
-		rings = io_mem_alloc(size);
+		rings = io_pages_map(&ctx->ring_pages, &ctx->n_ring_pages, size);
 	else
 		rings = io_rings_map(ctx, p->cq_off.user_addr, size);
 
@@ -3657,7 +3775,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	}
 
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
-		ptr = io_mem_alloc(size);
+		ptr = io_pages_map(&ctx->sqe_pages, &ctx->n_sqe_pages, size);
 	else
 		ptr = io_sqes_map(ctx, p->sq_off.user_addr, size);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 7654dfb34c2e..ac2a84542417 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -70,6 +70,8 @@ bool io_req_post_cqe(struct io_kiocb *req, s32 res, u32 cflags);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
 
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
+int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
+			struct page **pages, int npages);
 
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
-- 
2.43.0


