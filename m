Return-Path: <io-uring+bounces-1309-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 965EC890E88
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 00:34:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DFE629AB96
	for <lists+io-uring@lfdr.de>; Thu, 28 Mar 2024 23:34:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A19C21369AA;
	Thu, 28 Mar 2024 23:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0VfMq8fY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED653225A8
	for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 23:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711668893; cv=none; b=legSf87Zc5o1jOEy8r2OYwrShWuDeq/9IwBNLhZXpzlTdmo4OcVTGRNVtpZe4cC74bZTshWMmS8836LhzHBIjFCYS2FjdJJ7QVEX336zilGufWbcDbmHP4L7eIQabeGundB117W3KaZXAzr7z5fqExhx2RqKA/W2Dt00Rn9uZhU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711668893; c=relaxed/simple;
	bh=XUkl/+i7OtHZUwnqDrEzH8BtHEvc59M13YnBnBSirLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pgBzBR8LTTJthlbnNAMtgycWLGSAOHqgn7ozgFE7rKXiNrsNQGORsf9TduNwgYlex+ZJ6wf05feY5QbnppNPKaURAsFfk7HwTjcUXnOWhfguCW5i94mAjT2RKK7iGBIVjt2ADl9wqArKx3BdmYrp6T8q2WR51Tm9YKa2ycMQRT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0VfMq8fY; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-29f8ae4eae5so413299a91.0
        for <io-uring@vger.kernel.org>; Thu, 28 Mar 2024 16:34:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711668891; x=1712273691; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6rxmMF0ZC/HoWcm93GNcGMXq+P4YsNv0RJNPeAouMcs=;
        b=0VfMq8fY3JdChLhXnhqDx98XUr5LZbDxIEK3k9W4d+5xKqm3lP7oOjKjfaYs66Uf/W
         jKvvPfkK2TAn8xssWxVsyei1sCyaV5PArEDT2ItWCIusa7dZQsrkYNGqT81oxwMuCsJp
         ibo5qkf6W/Jitzmm0cjhZ8EIkTSFfmi5uXEly7MItBM+k/sexjcLk37BiqXzo/cAt57K
         U7yTdzkgK7hXWaTvT7eoWRjaXRngQJqd8sqqGsDfJJY4otIbuW26ZP6mGTuCey7lhgZf
         ZCBqcNLfAsNN+3EtmKkCsMm5/FLtyq1GadWEBFjCxxkiTbIKCuRsmkVTKppqaiG3Fj+Y
         iuGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711668891; x=1712273691;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6rxmMF0ZC/HoWcm93GNcGMXq+P4YsNv0RJNPeAouMcs=;
        b=oUXx/9SCyyeFl/V7jUC2/Od/MXSfJZ5XGHaS+dCO0l1qZAUbGORkElM/KBXkZjbc2d
         0CPNCd8WHJABLlRZdsuW9RLAxH1e0bH0h13ZbPkoDr0MGcCzFC5e4JOovCYlQk5h0SQd
         OEwXBF4s9SGmQnguODSlHTn9jkIy1YuI/N/Q1Xn7sNAqorVi2TugH/eB+F8GSIDKj0P+
         xTH5PHnmM52lljZR0veYrI9zpRSpwy6iYhGvE83+J6FDQfVoBelq3yecTlFDuog51J2e
         s+q3v7Pn6Rj2gv9OzyyhwamvxTmRHfwrY/CpYp6V1I9DMsMzSP751LVSXh7fzBenF6jj
         Mszg==
X-Gm-Message-State: AOJu0YzJD+1PeFmSrNfDVIIblOBSz0trc/It3/mL+9yBDJf8oh28kOCN
	kcTzKOURObSB4lNkpk7PxVv7plm3B/ikKqfI7Z4XFpYwHvSrAhOPlXbwVRpceZ6ffRus3gsTPOs
	i
X-Google-Smtp-Source: AGHT+IGGb+uxJqvDXip4mf6BB1ldp1ADLQLpaP3Rwmi8/nzQ2460aJrh/P5rU3huBzYzGXledHRe/A==
X-Received: by 2002:a17:902:bb91:b0:1e0:99b2:8a91 with SMTP id m17-20020a170902bb9100b001e099b28a91mr918073pls.4.1711668890676;
        Thu, 28 Mar 2024 16:34:50 -0700 (PDT)
Received: from localhost.localdomain ([50.234.116.5])
        by smtp.gmail.com with ESMTPSA id i6-20020a170902c94600b001e0b3c9fe60sm2216981pla.46.2024.03.28.16.34.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Mar 2024 16:34:49 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: hannes@cmpxchg.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/11] io_uring: get rid of remap_pfn_range() for mapping rings/sqes
Date: Thu, 28 Mar 2024 17:31:29 -0600
Message-ID: <20240328233443.797828-3-axboe@kernel.dk>
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
 io_uring/io_uring.c | 136 +++++++++++++++++++++++++++++++++++++++++---
 io_uring/io_uring.h |   2 +
 2 files changed, 130 insertions(+), 8 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 104899522bc5..982545ca23f9 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2594,6 +2594,33 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
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
 void io_mem_free(void *ptr)
 {
 	if (!ptr)
@@ -2694,8 +2721,8 @@ static void *io_sqes_map(struct io_ring_ctx *ctx, unsigned long uaddr,
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
@@ -2707,6 +2734,80 @@ static void io_rings_free(struct io_ring_ctx *ctx)
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
@@ -3294,14 +3395,12 @@ static void *io_uring_validate_mmap_request(struct file *file,
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
 
@@ -3324,11 +3423,22 @@ static void *io_uring_validate_mmap_request(struct file *file,
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
 
@@ -3336,6 +3446,16 @@ static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
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
@@ -3625,7 +3745,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 		return -EOVERFLOW;
 
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
-		rings = io_mem_alloc(size);
+		rings = io_pages_map(&ctx->ring_pages, &ctx->n_ring_pages, size);
 	else
 		rings = io_rings_map(ctx, p->cq_off.user_addr, size);
 
@@ -3650,7 +3770,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	}
 
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
-		ptr = io_mem_alloc(size);
+		ptr = io_pages_map(&ctx->sqe_pages, &ctx->n_sqe_pages, size);
 	else
 		ptr = io_sqes_map(ctx, p->sq_off.user_addr, size);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index dbd9a2b870eb..75230d914007 100644
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


