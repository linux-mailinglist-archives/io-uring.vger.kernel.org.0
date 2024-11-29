Return-Path: <io-uring+bounces-5142-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6DC1B9DE7AC
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2EAB6281991
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9A5E19CCEC;
	Fri, 29 Nov 2024 13:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="edU3WGXQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A5619F116
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887249; cv=none; b=bYnbVOyYRU4+optBClrZ/Tm8EPhNdKZoSUxEncqw82eD/C2AHJ8Msx2hsMV2IxftKkFs2lzXMkDh8FfyCCbB9vq+9akz2kCV366UT5p81daB44gGaMt37xly1BbnZm9pysvB2FD+XfLg4eyl8KCqPJWKNr904GdVbhij8rpUyII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887249; c=relaxed/simple;
	bh=wKX6y/XtPrvy8vACwrcBMbcIDCOZ27NZJ10UmQzz8eA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPkNN7hyQo87NFICY39oo075ZuTAMhH7xDwZZPRpv8rj6yoXx/PxOSC763CULReMwtWqcT+KQYy2nm6v17WF1FKB2yylhSGGYZrJdiNRKvFR1dMHTuqiBCcmnVLe4Kt1Nb751TaAkXn8l7GjHE//ssclPwZXWO9lY6EjKRsPpx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=edU3WGXQ; arc=none smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-2ffc76368c6so31586231fa.0
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887246; x=1733492046; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=93TwdHJhygGmeY47BMqX93X9f1o8prnSPfQiuR9K/Y0=;
        b=edU3WGXQ2w6K0xzcx9rYH4q1dBpofvrNqRMFf+qmmsqjZPscRh2QHGqBSRVjA32u+K
         84JARYZqm7UKkcfNt/IBONWC6YetLPiydW92OVKzD337cZVDxqUIyCFi9bte4eJD2Pvk
         69vEczI6B+k1ND2GBiQTsSv1GQ3+JQB2l6VLSRe3MHjlhTf5s2cq4T8EXvrm65ICv0Iv
         sP4UGFtPmqVJ0o9EfU3Tq38hIA2KGNnOIFDFgeT95Q4Pklp6HtX0tTBdYhKZxDyycIVf
         5zzyPt9YcvaPD+6dxCOOizq/Mq22xaLsqyceZMwxX7dsdMW8EpgEdh5wg8AdGOPCYi0K
         WP6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887246; x=1733492046;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=93TwdHJhygGmeY47BMqX93X9f1o8prnSPfQiuR9K/Y0=;
        b=btZBCqYp23ls/YDKwG8YBZWANU5rKq+FHZownVtYZ862U7NnnjP/EWIKulU8udl4Nj
         PJ7BXkLtk16aZYVvte9EveLv9RnHWRGTepDn7haB0hsk4L0XPCsII1PZCK4WDNKi0Vjt
         u0WSeIMB6wCDTd8QzodrE2RY7vP4e1TohmQamPVmO20cZibT/hLCw+jBqN/TXjeBSBeX
         tL5bHGEeQxONfkx4UcfqG/CcNpYazIFo2jtHfeyIKF0GWidG+Z1trFq/rjG3DYrEqaHC
         2jMDah88nlwYZZ7D40o0T8r6Aey1t3pATbPGEDHRdwTJq4gXTP1M2j5O4W7swHGDD9m6
         ZaaQ==
X-Gm-Message-State: AOJu0YyCEsd8Q5igdcaPFD5sVKFmCOYvexS9vDAqDd8Bq6+Cv1YsdYOl
	CXlgpAMZoasaNNOuT9edkbtecNSz1Ek43eZWKj2Yocuq+AgXOnyFHD9YDw==
X-Gm-Gg: ASbGncv1j5YmJDljyXpjRpGW5exXhg012Z1t4QT4TGegj0jdjZ93IkHALOOoW9YKM6b
	4x+tjBP9wsjr6Vx6Dpi+adAf52KGaqfQxJVBa2eq5oru8W+yuFywXKQHbs4Unpr4C2MLQdqafVJ
	J7U67EhcDFTpclITSGZzXPNBqP5w5oFwsAq5+xpzNJS4G+xhEnWNFsB8kyymmhcultS52VqfvPR
	SmC5XbSb5x7G1slUMh5hr7lSpZCMvifzWED1msll9suDetfIpJ3QDkRPlJm2GMU
X-Google-Smtp-Source: AGHT+IGvMwT6Bv37nnGEuqRgk7fg2Z1/vOIk53vsHxPXvbN+RssyOVM+Z0tfukRq4hnH3E+tx5zyTQ==
X-Received: by 2002:ac2:4e04:0:b0:53d:cbaa:86f5 with SMTP id 2adb3069b0e04-53df00ccbb8mr9740078e87.13.1732887245060;
        Fri, 29 Nov 2024 05:34:05 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.34.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:34:04 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 11/18] io_uring/memmap: implement mmap for regions
Date: Fri, 29 Nov 2024 13:34:32 +0000
Message-ID: <0f1212bd6af7fb39b63514b34fae8948014221d1.1732886067.git.asml.silence@gmail.com>
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
index 0908a71bf57e..9a182c8a4be1 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -275,7 +275,8 @@ static int io_region_pin_pages(struct io_ring_ctx *ctx,
 
 static int io_region_allocate_pages(struct io_ring_ctx *ctx,
 				    struct io_mapped_region *mr,
-				    struct io_uring_region_desc *reg)
+				    struct io_uring_region_desc *reg,
+				    unsigned long mmap_offset)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
 	unsigned long size = mr->nr_pages << PAGE_SHIFT;
@@ -290,8 +291,7 @@ static int io_region_allocate_pages(struct io_ring_ctx *ctx,
 	p = io_mem_alloc_compound(pages, mr->nr_pages, size, gfp);
 	if (!IS_ERR(p)) {
 		mr->flags |= IO_REGION_F_SINGLE_REF;
-		mr->pages = pages;
-		return 0;
+		goto done;
 	}
 
 	nr_allocated = alloc_pages_bulk_array_node(gfp, NUMA_NO_NODE,
@@ -302,12 +302,15 @@ static int io_region_allocate_pages(struct io_ring_ctx *ctx,
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
@@ -341,7 +344,7 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 	if (reg->flags & IORING_MEM_REGION_TYPE_USER)
 		ret = io_region_pin_pages(ctx, mr, reg);
 	else
-		ret = io_region_allocate_pages(ctx, mr, reg);
+		ret = io_region_allocate_pages(ctx, mr, reg, mmap_offset);
 	if (ret)
 		goto out_free;
 
@@ -354,6 +357,40 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
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
+	if (mr->flags & IO_REGION_F_USER_PROVIDED)
+		return ERR_PTR(-EINVAL);
+
+	return io_region_get_ptr(mr);
+}
+
 static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 					    size_t sz)
 {
@@ -389,6 +426,8 @@ static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 		io_put_bl(ctx, bl);
 		return ptr;
 		}
+	case IORING_MAP_OFF_PARAM_REGION:
+		return io_region_validate_mmap(ctx, &ctx->param_region);
 	}
 
 	return ERR_PTR(-EINVAL);
@@ -405,6 +444,16 @@ int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
 
 #ifdef CONFIG_MMU
 
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
 __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct io_ring_ctx *ctx = file->private_data;
@@ -429,6 +478,8 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
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
2.47.1


