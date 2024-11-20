Return-Path: <io-uring+bounces-4898-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 778E39D448D
	for <lists+io-uring@lfdr.de>; Thu, 21 Nov 2024 00:33:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F2D0C1F22000
	for <lists+io-uring@lfdr.de>; Wed, 20 Nov 2024 23:33:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 127EE146593;
	Wed, 20 Nov 2024 23:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bGUy9B2y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120D61BDA8A
	for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 23:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732145600; cv=none; b=d+YE+mjMZe4kZsxmaWYCn0zDYU4I4llen3f0KfImzofNlGDiNoZcb+EfykehCcHGGaxVT+om4QMm/kE4XhsokDvhb9Beb+WZ8mOn4iaGYsivt5I0vHIvK+Gj9E6MaK1Fj1rRvOHSIAaEOwMNGxy6klasqlqnR4M59McH9TeCEcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732145600; c=relaxed/simple;
	bh=n3OStU6FcBGysp3Pci4+yNu5CjV7dxL2Qx1q/VYalHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PitiwP2XHgBqoijkdx38M+ogMgL8uQc8bZlxYMuroQNlcjebCa+Lmb4xw19ySlw3qgP3DYk0/rJasGlClBpRlV9hi1tmsahT1wSQ1OhoPAcr4QjnIh9tgvx/Aoo8psLzoGftyUnwNUu8NkxaeSAW5QH+jpwPrXQooSjdhnKOAJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bGUy9B2y; arc=none smtp.client-ip=209.85.218.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-a9eb3794a04so31278666b.3
        for <io-uring@vger.kernel.org>; Wed, 20 Nov 2024 15:33:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732145596; x=1732750396; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=304V2YUK9klc+k7M6AeMClL+WGzyroOEloK7wWLTT48=;
        b=bGUy9B2yLl7C+6Qa+aFb3Q7DREketPhejAAt9i/CF5iYnSLevL0E1WCzCNzdxEs3Ke
         8Qt+coojC2IqYtS+t7OdCop/d9KqNm2tF2V0ukJVrVkIxKAV/9RJpI89QaxqLZEoGjZQ
         ysr8UH2pi+NO/ybK+6gepmu9PMnRJAKUSaMtP601pThxVeGq9dlRqRntWXSS6tcvg0P5
         i1Nk1he+b8tv3dxEViBxC4xW2Q0oxAoCQ21ePVaehSRNFWTUGih1QH7Sh4yfvzjx6yWa
         ctJKKPnGvdZPipYtZrrLB3ElampBqf8jPXz7l3FEBzixpjv+yq+cnrK88vBd/npPtGFM
         wdPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732145596; x=1732750396;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=304V2YUK9klc+k7M6AeMClL+WGzyroOEloK7wWLTT48=;
        b=T3dX2U7JULvhufcprw9SUwhoCM6806wvuS55WsEEwsTmjIh9qnJPUnJshp0J1k7jLH
         XwBV9xM9fhbEfR0TjNZGUwNcX6V0AfTRRzyqmiaYizkF9ZnjvYBd7YETGTT7iHiEa+cH
         Vx0kr6M44IORIrb9mhZfYM2txtti+Gdvt6gadkUUZibKAHhWiLQyOH2bFzDeLrKsl7BM
         rUPTYNMD2u7V7qvaN/GkLGqZgR8LIT8ojlS98TVuYdZ0StOVFzyRbwlLb65JqRJs6OCp
         zxQ5GzEIN6wm1tKdxFKv8BMREGKPUvP5eb6SCNR+UHEEN1FeUOJxc563r1W9UnAIcOI2
         MQfQ==
X-Gm-Message-State: AOJu0YwGHyUSptVXROXLbHwmx/eAOsD5gCOzYQMIl/i5SSs1BKe8RKHN
	SO9La+/Mg4ArS4ypbfpcJMESMthgPAUl+Ji+kHWbcLJQsKp8O6np0xndtg==
X-Google-Smtp-Source: AGHT+IHjKqUF9hjd1+x0V5abJME8VVwecEDlONvrqbXSk0GA/blExfqBJhN42M4Rc06ATM/ddc7mQQ==
X-Received: by 2002:a17:907:3f9d:b0:a99:403e:2578 with SMTP id a640c23a62f3a-aa4dd53e1a0mr454775566b.5.1732145595983;
        Wed, 20 Nov 2024 15:33:15 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.141.165])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa4f415372bsm12166066b.13.2024.11.20.15.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Nov 2024 15:33:15 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 11/11] io_uring/memmap: implement mmap for regions
Date: Wed, 20 Nov 2024 23:33:34 +0000
Message-ID: <461a81aac8d96a14c3054585faef7b3bdaa2a759.1732144783.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1732144783.git.asml.silence@gmail.com>
References: <cover.1732144783.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The patch implements mmap for the param region and enables the kernel
allocation mode. Internally it uses a fixed mmap offset, however the
user has to use the offset returned in
struct io_uring_region_desc::mmap_offset.

Note, mmap doesn't and can't take ->uring_lock and the region / ring
lookup is protected by ->mmap_lock, and it's directly peeking at
ctx->param_region. We can't protect io_create_region() with the
mmap_lock as it'd deadlock, which is why io_create_region_mmap_safe()
initialises it for us in a temporary variable and then publishes it
with the lock taken. It's intentionally decoupled from main region
helpers, and in the future we might want to have a list of active
regions, which then could be protected by the ->mmap_lock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/memmap.c   | 61 +++++++++++++++++++++++++++++++++++++++++----
 io_uring/memmap.h   | 10 +++++++-
 io_uring/register.c |  6 ++---
 3 files changed, 67 insertions(+), 10 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 8598770bc385..5d971ba33d5a 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -265,7 +265,8 @@ static int io_region_pin_pages(struct io_ring_ctx *ctx,
 
 static int io_region_allocate_pages(struct io_ring_ctx *ctx,
 				    struct io_mapped_region *mr,
-				    struct io_uring_region_desc *reg)
+				    struct io_uring_region_desc *reg,
+				    unsigned long mmap_offset)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
 	unsigned long size = mr->nr_pages << PAGE_SHIFT;
@@ -280,8 +281,7 @@ static int io_region_allocate_pages(struct io_ring_ctx *ctx,
 	p = io_mem_alloc_compound(pages, mr->nr_pages, size, gfp);
 	if (!IS_ERR(p)) {
 		mr->flags |= IO_REGION_F_SINGLE_REF;
-		mr->pages = pages;
-		return 0;
+		goto done;
 	}
 
 	nr_allocated = alloc_pages_bulk_noprof(gfp, numa_node_id(), NULL,
@@ -292,12 +292,15 @@ static int io_region_allocate_pages(struct io_ring_ctx *ctx,
 		kvfree(pages);
 		return -ENOMEM;
 	}
+done:
+	reg->mmap_offset = mmap_offset;
 	mr->pages = pages;
 	return 0;
 }
 
 int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
-		     struct io_uring_region_desc *reg)
+		     struct io_uring_region_desc *reg,
+		     unsigned long mmap_offset)
 {
 	int nr_pages, ret;
 	u64 end;
@@ -331,7 +334,7 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	if (reg->flags & IORING_MEM_REGION_TYPE_USER)
 		ret = io_region_pin_pages(ctx, mr, reg);
 	else
-		ret = io_region_allocate_pages(ctx, mr, reg);
+		ret = io_region_allocate_pages(ctx, mr, reg, mmap_offset);
 	if (ret)
 		goto out_free;
 
@@ -344,6 +347,50 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	return ret;
 }
 
+int io_create_region_mmap_safe(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
+				struct io_uring_region_desc *reg,
+				unsigned long mmap_offset)
+{
+	struct io_mapped_region tmp_mr;
+	int ret;
+
+	memcpy(&tmp_mr, mr, sizeof(tmp_mr));
+	ret = io_create_region(ctx, &tmp_mr, reg, mmap_offset);
+	if (ret)
+		return ret;
+
+	/*
+	 * Once published mmap can find it without holding only the ->mmap_lock
+	 * and not ->uring_lock.
+	 */
+	guard(mutex)(&ctx->mmap_lock);
+	memcpy(mr, &tmp_mr, sizeof(tmp_mr));
+	return 0;
+}
+
+static void *io_region_validate_mmap(struct io_ring_ctx *ctx,
+				     struct io_mapped_region *mr)
+{
+	lockdep_assert_held(&ctx->mmap_lock);
+
+	if (!io_region_is_set(mr))
+		return ERR_PTR(-EINVAL);
+	if (mr->flags & IO_REGION_F_USER_PINNED)
+		return ERR_PTR(-EINVAL);
+
+	return io_region_get_ptr(mr);
+}
+
+static int io_region_mmap(struct io_ring_ctx *ctx,
+			  struct io_mapped_region *mr,
+			  struct vm_area_struct *vma)
+{
+	unsigned long nr_pages = mr->nr_pages;
+
+	vm_flags_set(vma, VM_DONTEXPAND);
+	return vm_insert_pages(vma, vma->vm_start, mr->pages, &nr_pages);
+}
+
 static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 					    size_t sz)
 {
@@ -379,6 +426,8 @@ static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 		io_put_bl(ctx, bl);
 		return ptr;
 		}
+	case IORING_MAP_OFF_PARAM_REGION:
+		return io_region_validate_mmap(ctx, &ctx->param_region);
 	}
 
 	return ERR_PTR(-EINVAL);
@@ -419,6 +468,8 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 						ctx->n_sqe_pages);
 	case IORING_OFF_PBUF_RING:
 		return io_pbuf_mmap(file, vma);
+	case IORING_MAP_OFF_PARAM_REGION:
+		return io_region_mmap(ctx, &ctx->param_region, vma);
 	}
 
 	return -EINVAL;
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index 2096a8427277..2402bca3d700 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -1,6 +1,8 @@
 #ifndef IO_URING_MEMMAP_H
 #define IO_URING_MEMMAP_H
 
+#define IORING_MAP_OFF_PARAM_REGION		0x20000000ULL
+
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
 void io_pages_free(struct page ***pages, int npages);
 int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
@@ -24,7 +26,13 @@ int io_uring_mmap(struct file *file, struct vm_area_struct *vma);
 
 void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr);
 int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
-		     struct io_uring_region_desc *reg);
+		     struct io_uring_region_desc *reg,
+		     unsigned long mmap_offset);
+
+int io_create_region_mmap_safe(struct io_ring_ctx *ctx,
+				struct io_mapped_region *mr,
+				struct io_uring_region_desc *reg,
+				unsigned long mmap_offset);
 
 static inline void *io_region_get_ptr(struct io_mapped_region *mr)
 {
diff --git a/io_uring/register.c b/io_uring/register.c
index f043d3f6b026..5b099ec36d00 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -585,9 +585,6 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 	rd_uptr = u64_to_user_ptr(reg.region_uptr);
 	if (copy_from_user(&rd, rd_uptr, sizeof(rd)))
 		return -EFAULT;
-
-	if (!(rd.flags & IORING_MEM_REGION_TYPE_USER))
-		return -EINVAL;
 	if (memchr_inv(&reg.__resv, 0, sizeof(reg.__resv)))
 		return -EINVAL;
 	if (reg.flags & ~IORING_MEM_REGION_REG_WAIT_ARG)
@@ -602,7 +599,8 @@ static int io_register_mem_region(struct io_ring_ctx *ctx, void __user *uarg)
 	    !(ctx->flags & IORING_SETUP_R_DISABLED))
 		return -EINVAL;
 
-	ret = io_create_region(ctx, &ctx->param_region, &rd);
+	ret = io_create_region_mmap_safe(ctx, &ctx->param_region, &rd,
+					 IORING_MAP_OFF_PARAM_REGION);
 	if (ret)
 		return ret;
 	if (copy_to_user(rd_uptr, &rd, sizeof(rd))) {
-- 
2.46.0


