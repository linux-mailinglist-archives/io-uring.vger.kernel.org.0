Return-Path: <io-uring+bounces-5018-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 7FAD89D7840
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D88A9B2204D
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82305163;
	Sun, 24 Nov 2024 21:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cMA/6BBV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B865156960
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482738; cv=none; b=k8xV/kmO8smcN9aSoPNGacg3t6dCGo/+hfi5T49zvjrUTKLuGYqIh7r+kFhybj9TDnxR7TzM6G9bOiSkK6cmaxjNrlnwbcsJnlL4V76KzUF5x0e1xEIIuc6cnQeRXE68rlfJ6+YdR2zt9itzaw7AmJGFUuPqUQwZy7CSEgl69Z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482738; c=relaxed/simple;
	bh=n3OStU6FcBGysp3Pci4+yNu5CjV7dxL2Qx1q/VYalHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hgXv0xkViKw/mUUdi2i/ILe/kLBHJvLxJaSXNX/R0nw8CcrhH+lnogaUWXJK5LQ4GzBICoQPa0xoqYv8iHub/DZSou9tusi6LZd0pIp79ad3aDLsSqvk86G1UYIKeL5LrpF+/OfEW0JBs+TMWCdOptp04LOMarB8FjlcvuLBCf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cMA/6BBV; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43152b79d25so34027035e9.1
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482735; x=1733087535; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=304V2YUK9klc+k7M6AeMClL+WGzyroOEloK7wWLTT48=;
        b=cMA/6BBVpyWJ3koLN/6MYjvnROqi0dZPgXf/Lo7Y6FNi1FwjdVpaR/PsMhqdkJTMyr
         7kCG04cz0kVPeNrnt4JndErsnren90jzwRCYhtgL5poBlTRWppxHH1jHXR70gHinVXmu
         lN8e6Gpox+tLCjTWczynXZBPETaKzD6yg+sUVbcj7Fvmq376Jw9yhjU3geNv6IO1Ths2
         Q1DAzZvqRda/kVRmqb3vp/C/oXByjWoRpVuoUI67R2pKpXB3jYBBBOY3dhWeX+YBGGtL
         wrhQWezpUPeDM7sqad/hBjLT9OnXn4RIybNDagBu8kaZPkg9Q4KIlE1MwPvmvl/dltBa
         cd+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482735; x=1733087535;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=304V2YUK9klc+k7M6AeMClL+WGzyroOEloK7wWLTT48=;
        b=qcH0ZTTT8QvTHnaHATaNP/ZUFu1WbjHAyWF+4kjefY5I1LOSIhXtM9c2tavc2oyaQ8
         9cCMFYzCPHZNPdVb5NeXIIjuOClIzcRHb8L1E6CIAyui6RA2VQ+QNQ5aqzTrLqLP4gvh
         3TmQYhgn1AdTarq2Q4B+np6bvbgvqmdTNcLYMKncEHjpeTfwFz89silKkBYDdDaA0DSI
         eObgkTF9S/nffKZyhkkvbjOkz/rlyi5OZrb9XiJdiq7FeRgRDF6Cj6GBE3875+YSWFl0
         cWrUpwYMoi1o23HNeuzO1/W8IWv/ddq/4698nglTeSu+RwC1PpHbYgJ+ajLTKT20T+k1
         3kvw==
X-Gm-Message-State: AOJu0YyCoWm7O1E3P6yJcfdwd+Yq47A3WVjLnPaCE5jT7D61IKyJr+pG
	0AiynZMn6K7KhITQY6KrwsiaNBJcMNe1mVwOn9ls7654wEdi8T73Tw+9rQ==
X-Gm-Gg: ASbGncsFwZKGLVgxcgqXLHzI4gwMXPNOKYc3DxuYciD1bwAPE2FCrdFxAyBb0XtLHQ1
	/lsauIXecRBHm6zc8guD6TEh+FzhiXakssjGMfJKYyTa2zp798GQ7VOkPy5U9NJAq7/LRNe9MrL
	7T0QFmSFXEmtx06WdTDajAFZQLqvib88C3qOs23nIsPZBIMF/pXdat+LXe1BJgowbtGr6v0FDG+
	17LytO/otff439lC+f/Is1yi6pg/7S+wWYVVjiiNDV1b37KRM2l0iPXcjHNOXk=
X-Google-Smtp-Source: AGHT+IFGr0NARd5uhvzSz3qATcINtrjS2yg3pgA6tYvaNhfIG6LUj5HZiVDams2fqUAccjDTQBrCOQ==
X-Received: by 2002:a05:600c:5254:b0:431:58b3:affa with SMTP id 5b1f17b1804b1-433ce42488fmr96086725e9.9.1732482734447;
        Sun, 24 Nov 2024 13:12:14 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:14 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 11/18] io_uring/memmap: implement mmap for regions
Date: Sun, 24 Nov 2024 21:12:28 +0000
Message-ID: <367482d02a9a78861c9da43be8373a26b585eac6.1732481694.git.asml.silence@gmail.com>
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


