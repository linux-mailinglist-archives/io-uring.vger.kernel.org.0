Return-Path: <io-uring+bounces-5024-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 053CF9D7845
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 87FC3162C3D
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93CA913FD72;
	Sun, 24 Nov 2024 21:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Jdsuv699"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5804514F136
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482745; cv=none; b=Q+ikWWM+2pj0AG7RqFu62NxPWN9j+eb6mqNzJZ1cubNjNZVrfijp7QME6+VZciSIVtPCeO3npjLJooy+1QnfANWhjQuT2NGlAHCUtnjN57Zy5QUBQdDhBEeJ+CDmiwz1PgtZRv7X1pFrp76Yn09QMvXqVY8OzBvud57YCCbhxQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482745; c=relaxed/simple;
	bh=oWkcdYZp8ZG7s5K/XtQzMBNvRindXxCIGzLjVKo/FmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m8kqq5eM7Z7IEV9myVkAjV3kUs5o/pdKNiTbRhrd67XFwumbwvcxtVu0sNKDuLO4cdPyuf+rhDRC9i2IVNTEM++knNL67+nm4bj3LBdRqtbdV9fODZVJT+4CZ7+HM/R/0NFO8zPRh/dexUipVuhgMCC1RUrKUNffC70siCVpYyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Jdsuv699; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-43162cf1eaaso48598295e9.0
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482741; x=1733087541; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZC2XeEP04JXajrKNiQ8haKEqXQM2GqxNCdByjG6tFAM=;
        b=Jdsuv69922BeCb96VYP3KUCktwiIegYE7Am4C1gLb1dQG2A5tZBYd8wD8C5DRKAr9V
         gDtmOKaatASR0QTpS0TrPkQ6fhoL13CM1uqgG47DtU5sHyFWF/90sDPlNRLe1Guln2KI
         OiMT8qSICmPUN98QuiS9mXwCNOrVrSqiHPHlwjDNshNdLgP5M3mj0vxFZShnIqbRE82i
         BblxM8yWqAfcNiEdFkm536bP57V/n5DNd8c6vafUpF1sw8C2dHiTLqbJC6TKAZGVmtrX
         aABrpG8+hdREfvg5JBRIXqOuv0E6cYUx6Pov5OilmZB2lYYr81HiA8x5qW9nU1/Ac1Qf
         qz7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482741; x=1733087541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZC2XeEP04JXajrKNiQ8haKEqXQM2GqxNCdByjG6tFAM=;
        b=eGK4nadSPx80jRnVonM75fuxGDCyLaJ5xTGda1fWpVB+wBLF/rS1+EgcGhISCQmJbh
         st/fgy9cnbNwOhLqA6RLmMdh4LxMtZOZckTFr/fHaIIuybvnPm63W+2QU7z3VTGIjUH1
         8gIgO+oNik+V1hObW41kQIokbiZEivZkAEPbs1lI80sbP1B0g5EXFL1DyvFP/DLosI4Y
         3ZtShm5DyNIZ7KmogYk2GEW55aoNuz9Tyfwr8ErqFxvxa3pjKepX9bL5KimLnzAlWphI
         ob+thBz+pY1ARnmr7fauH+ngGZ+eHxWmSJ7z4hO3KzLfpar/M9dQtEuM+LXIvVRQve1T
         y1nA==
X-Gm-Message-State: AOJu0YxCud2M+FDYu/mckcPGxuFU5ttbrOjxZsS/Eg74dsao2QAX+Bm2
	WZLrwp95gPrIUKMUnGODMSpTGUO+PaghzdUCoHnfEohNY8hXen8ufZk2Fw==
X-Gm-Gg: ASbGncuK1RLVHnyf0kmzNF0ZqTUXFzSQjDJeiXpj42qMnWpqikzWNReyQ11aSthH9yN
	XvFR6e6GFGk84sIWN/870x1UywPDGT5FBv/kRKCoxzFvL0ngHzU67rzDy8CcCSRoPC88g4yXX0P
	sgO6VaTtQRtm0C5gRId75RU9gFzguzN87AUNr+PE+uPD6AGSaCtSaP7X/FKanbkv0G65hvloy+s
	eazEtyM+QfFHlWIL5Q2XnaZXVFW8K5S4GFU9sGD6GWocLJ9RZ+QbDaLn9kIgAk=
X-Google-Smtp-Source: AGHT+IHddRzkkirMHWqvrgVVt5KAhexHpC/M/ZdqKlTjYfwIo44BKGhIsq6/evpYcW5A0IpCf8BMxw==
X-Received: by 2002:a05:600c:138c:b0:431:562a:54be with SMTP id 5b1f17b1804b1-433ce41ce64mr116533755e9.9.1732482741276;
        Sun, 24 Nov 2024 13:12:21 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:20 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 17/18] io_uring/kbuf: use region api for pbuf rings
Date: Sun, 24 Nov 2024 21:12:34 +0000
Message-ID: <981856b77fd6144508747550cb2c2c26666184d6.1732481694.git.asml.silence@gmail.com>
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

Convert internal parts of the provided buffer ring managment to the
region API. It's the last non-region mapped ring we have, so it also
kills a bunch of now unused memmap.c helpers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/kbuf.c   | 170 ++++++++++++++--------------------------------
 io_uring/kbuf.h   |  18 ++---
 io_uring/memmap.c | 116 +++++--------------------------
 io_uring/memmap.h |   7 --
 4 files changed, 73 insertions(+), 238 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 644f61445ec9..f77d14e4d598 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -351,17 +351,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 
 	if (bl->flags & IOBL_BUF_RING) {
 		i = bl->buf_ring->tail - bl->head;
-		if (bl->buf_nr_pages) {
-			int j;
-
-			if (!(bl->flags & IOBL_MMAP)) {
-				for (j = 0; j < bl->buf_nr_pages; j++)
-					unpin_user_page(bl->buf_pages[j]);
-			}
-			io_pages_unmap(bl->buf_ring, &bl->buf_pages,
-					&bl->buf_nr_pages, bl->flags & IOBL_MMAP);
-			bl->flags &= ~IOBL_MMAP;
-		}
+		io_free_region(ctx, &bl->region);
 		/* make sure it's seen as empty */
 		INIT_LIST_HEAD(&bl->buf_list);
 		bl->flags &= ~IOBL_BUF_RING;
@@ -614,75 +604,14 @@ int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
-			    struct io_buffer_list *bl)
-{
-	struct io_uring_buf_ring *br = NULL;
-	struct page **pages;
-	int nr_pages, ret;
-
-	pages = io_pin_pages(reg->ring_addr,
-			     flex_array_size(br, bufs, reg->ring_entries),
-			     &nr_pages);
-	if (IS_ERR(pages))
-		return PTR_ERR(pages);
-
-	br = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
-	if (!br) {
-		ret = -ENOMEM;
-		goto error_unpin;
-	}
-
-#ifdef SHM_COLOUR
-	/*
-	 * On platforms that have specific aliasing requirements, SHM_COLOUR
-	 * is set and we must guarantee that the kernel and user side align
-	 * nicely. We cannot do that if IOU_PBUF_RING_MMAP isn't set and
-	 * the application mmap's the provided ring buffer. Fail the request
-	 * if we, by chance, don't end up with aligned addresses. The app
-	 * should use IOU_PBUF_RING_MMAP instead, and liburing will handle
-	 * this transparently.
-	 */
-	if ((reg->ring_addr | (unsigned long) br) & (SHM_COLOUR - 1)) {
-		ret = -EINVAL;
-		goto error_unpin;
-	}
-#endif
-	bl->buf_pages = pages;
-	bl->buf_nr_pages = nr_pages;
-	bl->buf_ring = br;
-	bl->flags |= IOBL_BUF_RING;
-	bl->flags &= ~IOBL_MMAP;
-	return 0;
-error_unpin:
-	unpin_user_pages(pages, nr_pages);
-	kvfree(pages);
-	vunmap(br);
-	return ret;
-}
-
-static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
-			      struct io_uring_buf_reg *reg,
-			      struct io_buffer_list *bl)
-{
-	size_t ring_size;
-
-	ring_size = reg->ring_entries * sizeof(struct io_uring_buf_ring);
-
-	bl->buf_ring = io_pages_map(&bl->buf_pages, &bl->buf_nr_pages, ring_size);
-	if (IS_ERR(bl->buf_ring)) {
-		bl->buf_ring = NULL;
-		return -ENOMEM;
-	}
-
-	bl->flags |= (IOBL_BUF_RING | IOBL_MMAP);
-	return 0;
-}
-
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_uring_buf_reg reg;
 	struct io_buffer_list *bl, *free_bl = NULL;
+	struct io_uring_region_desc rd;
+	struct io_uring_buf_ring *br;
+	unsigned long mmap_offset;
+	unsigned long ring_size;
 	int ret;
 
 	lockdep_assert_held(&ctx->uring_lock);
@@ -694,19 +623,8 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		return -EINVAL;
 	if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
 		return -EINVAL;
-	if (!(reg.flags & IOU_PBUF_RING_MMAP)) {
-		if (!reg.ring_addr)
-			return -EFAULT;
-		if (reg.ring_addr & ~PAGE_MASK)
-			return -EINVAL;
-	} else {
-		if (reg.ring_addr)
-			return -EINVAL;
-	}
-
 	if (!is_power_of_2(reg.ring_entries))
 		return -EINVAL;
-
 	/* cannot disambiguate full vs empty due to head/tail size */
 	if (reg.ring_entries >= 65536)
 		return -EINVAL;
@@ -722,21 +640,47 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 			return -ENOMEM;
 	}
 
-	if (!(reg.flags & IOU_PBUF_RING_MMAP))
-		ret = io_pin_pbuf_ring(&reg, bl);
-	else
-		ret = io_alloc_pbuf_ring(ctx, &reg, bl);
+	mmap_offset = reg.bgid << IORING_OFF_PBUF_SHIFT;
+	ring_size = flex_array_size(br, bufs, reg.ring_entries);
 
-	if (!ret) {
-		bl->nr_entries = reg.ring_entries;
-		bl->mask = reg.ring_entries - 1;
-		if (reg.flags & IOU_PBUF_RING_INC)
-			bl->flags |= IOBL_INC;
+	memset(&rd, 0, sizeof(rd));
+	rd.size = PAGE_ALIGN(ring_size);
+	if (!(reg.flags & IOU_PBUF_RING_MMAP)) {
+		rd.user_addr = reg.ring_addr;
+		rd.flags |= IORING_MEM_REGION_TYPE_USER;
+	}
+	ret = io_create_region_mmap_safe(ctx, &bl->region, &rd, mmap_offset);
+	if (ret)
+		goto fail;
+	br = io_region_get_ptr(&bl->region);
 
-		io_buffer_add_list(ctx, bl, reg.bgid);
-		return 0;
+#ifdef SHM_COLOUR
+	/*
+	 * On platforms that have specific aliasing requirements, SHM_COLOUR
+	 * is set and we must guarantee that the kernel and user side align
+	 * nicely. We cannot do that if IOU_PBUF_RING_MMAP isn't set and
+	 * the application mmap's the provided ring buffer. Fail the request
+	 * if we, by chance, don't end up with aligned addresses. The app
+	 * should use IOU_PBUF_RING_MMAP instead, and liburing will handle
+	 * this transparently.
+	 */
+	if (!(reg.flags & IOU_PBUF_RING_MMAP) &&
+	    ((reg->ring_addr | (unsigned long)br) & (SHM_COLOUR - 1))) {
+		ret = -EINVAL;
+		goto fail;
 	}
+#endif
 
+	bl->nr_entries = reg.ring_entries;
+	bl->mask = reg.ring_entries - 1;
+	bl->flags |= IOBL_BUF_RING;
+	bl->buf_ring = br;
+	if (reg.flags & IOU_PBUF_RING_INC)
+		bl->flags |= IOBL_INC;
+	io_buffer_add_list(ctx, bl, reg.bgid);
+	return 0;
+fail:
+	io_free_region(ctx, &bl->region);
 	kfree(free_bl);
 	return ret;
 }
@@ -794,32 +738,18 @@ int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
 }
 
-struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
-				      unsigned long bgid)
-{
-	struct io_buffer_list *bl;
-
-	bl = xa_load(&ctx->io_bl_xa, bgid);
-	/* must be a mmap'able buffer ring and have pages */
-	if (bl && bl->flags & IOBL_MMAP)
-		return bl;
-
-	return ERR_PTR(-EINVAL);
-}
-
-int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma)
+struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
+					    unsigned int bgid)
 {
-	struct io_ring_ctx *ctx = file->private_data;
-	loff_t pgoff = vma->vm_pgoff << PAGE_SHIFT;
 	struct io_buffer_list *bl;
-	int bgid;
 
 	lockdep_assert_held(&ctx->mmap_lock);
 
-	bgid = (pgoff & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
-	bl = io_pbuf_get_bl(ctx, bgid);
-	if (IS_ERR(bl))
-		return PTR_ERR(bl);
+	bl = xa_load(&ctx->io_bl_xa, bgid);
+	if (!bl || !(bl->flags & IOBL_BUF_RING))
+		return NULL;
+	if (WARN_ON_ONCE(!io_region_is_set(&bl->region)))
+		return NULL;
 
-	return io_uring_mmap_pages(ctx, vma, bl->buf_pages, bl->buf_nr_pages);
+	return &bl->region;
 }
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index dff7444026a6..bd80c44c5af1 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -3,15 +3,13 @@
 #define IOU_KBUF_H
 
 #include <uapi/linux/io_uring.h>
+#include <linux/io_uring_types.h>
 
 enum {
 	/* ring mapped provided buffers */
 	IOBL_BUF_RING	= 1,
-	/* ring mapped provided buffers, but mmap'ed by application */
-	IOBL_MMAP	= 2,
 	/* buffers are consumed incrementally rather than always fully */
-	IOBL_INC	= 4,
-
+	IOBL_INC	= 2,
 };
 
 struct io_buffer_list {
@@ -21,10 +19,7 @@ struct io_buffer_list {
 	 */
 	union {
 		struct list_head buf_list;
-		struct {
-			struct page **buf_pages;
-			struct io_uring_buf_ring *buf_ring;
-		};
+		struct io_uring_buf_ring *buf_ring;
 	};
 	__u16 bgid;
 
@@ -35,6 +30,8 @@ struct io_buffer_list {
 	__u16 mask;
 
 	__u16 flags;
+
+	struct io_mapped_region region;
 };
 
 struct io_buffer {
@@ -81,9 +78,8 @@ void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
-struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
-				      unsigned long bgid);
-int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
+struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
+					    unsigned int bgid);
 
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 {
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 88428a8dc3bc..22c3a20bd52b 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -36,88 +36,6 @@ static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
 	return page_address(page);
 }
 
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
-	if (!IS_ERR(ret))
-		goto done;
-
-	ret = io_mem_alloc_single(pages, nr_pages, size, gfp);
-	if (!IS_ERR(ret)) {
-done:
-		*out_pages = pages;
-		*npages = nr_pages;
-		return ret;
-	}
-
-	kvfree(pages);
-	*out_pages = NULL;
-	*npages = 0;
-	return ret;
-}
-
-void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
-		    bool put_pages)
-{
-	bool do_vunmap = false;
-
-	if (!ptr)
-		return;
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
 struct page **io_pin_pages(unsigned long uaddr, unsigned long len, int *npages)
 {
 	unsigned long start, end, nr_pages;
@@ -375,16 +293,14 @@ static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 			return ERR_PTR(-EFAULT);
 		return ctx->sq_sqes;
 	case IORING_OFF_PBUF_RING: {
-		struct io_buffer_list *bl;
+		struct io_mapped_region *region;
 		unsigned int bgid;
-		void *ptr;
 
 		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
-		bl = io_pbuf_get_bl(ctx, bgid);
-		if (IS_ERR(bl))
-			return bl;
-		ptr = bl->buf_ring;
-		return ptr;
+		region = io_pbuf_get_region(ctx, bgid);
+		if (!region)
+			return ERR_PTR(-EINVAL);
+		return io_region_validate_mmap(ctx, region);
 		}
 	case IORING_MAP_OFF_PARAM_REGION:
 		return io_region_validate_mmap(ctx, &ctx->param_region);
@@ -393,15 +309,6 @@ static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 	return ERR_PTR(-EINVAL);
 }
 
-int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
-			struct page **pages, int npages)
-{
-	unsigned long nr_pages = npages;
-
-	vm_flags_set(vma, VM_DONTEXPAND);
-	return vm_insert_pages(vma, vma->vm_start, pages, &nr_pages);
-}
-
 #ifdef CONFIG_MMU
 
 __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
@@ -425,8 +332,17 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 		return io_region_mmap(ctx, &ctx->ring_region, vma, page_limit);
 	case IORING_OFF_SQES:
 		return io_region_mmap(ctx, &ctx->sq_region, vma, UINT_MAX);
-	case IORING_OFF_PBUF_RING:
-		return io_pbuf_mmap(file, vma);
+	case IORING_OFF_PBUF_RING: {
+		struct io_mapped_region *region;
+		unsigned int bgid;
+
+		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
+		region = io_pbuf_get_region(ctx, bgid);
+		if (!region)
+			return -EINVAL;
+
+		return io_region_mmap(ctx, region, vma, UINT_MAX);
+	}
 	case IORING_MAP_OFF_PARAM_REGION:
 		return io_region_mmap(ctx, &ctx->param_region, vma, UINT_MAX);
 	}
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index 7395996eb353..c898dcba2b4e 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -4,13 +4,6 @@
 #define IORING_MAP_OFF_PARAM_REGION		0x20000000ULL
 
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
-int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
-			struct page **pages, int npages);
-
-void *io_pages_map(struct page ***out_pages, unsigned short *npages,
-		   size_t size);
-void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
-		    bool put_pages);
 
 #ifndef CONFIG_MMU
 unsigned int io_uring_nommu_mmap_capabilities(struct file *file);
-- 
2.46.0


