Return-Path: <io-uring+bounces-4701-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 850779C90E9
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 18:38:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 160F01F23D43
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 17:38:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEF4C18C32C;
	Thu, 14 Nov 2024 17:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jclxtTfh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9915262A3
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 17:38:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731605892; cv=none; b=q32siBL1DNzDDgnyoqmb3ZcBVeXnCUmwZ12g0cDyYYkO1TXUVo69eiOAYVD9IekaC2Xwfunh49/mIRfZx0Lg+6GU9jXwAkqrg6d7TUvefxELBEu1DEzzqnpP2ihC0zeUuF+HBu3/eTvuUoyBENRvNFmFO4QqnCor2vOnFwhLEPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731605892; c=relaxed/simple;
	bh=LEHVOqA/wu7bv9R8jRp4rql8nU3eWpbddqLIkmuBjZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ipAu6v83nu5pKiv6aJhI9LAXi756xWUN+XRh56bMT3gYQu1GzGJu/nTkTR/RdDykQ2cJneeZWvBTrGwpcVbEFqHPvUJEh9+BlECxUQm+3nNYey9iZyhpJkwVZA0K8j7QT5jFRGUKtNjLluDXq4q+gLHDfIR10NjX5bkVN4riBVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jclxtTfh; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9aa8895facso163605666b.2
        for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 09:38:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731605889; x=1732210689; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sbQAXiI9Dzu9Ee3eEwZ7D/5xWLvxvnaf/SprirDiKHE=;
        b=jclxtTfhy7vgww5NvZiq7rl5WUMhBM1OCD+4vfsxtqiTeWN+zWq1ljeplEsHBMTm0G
         9U3lN1NGXFq/2lFNsMzwzCdDo6NLIL/PCokw2dNmqXho0+4Kqf6rHBKu0uatnCXBeehL
         czuwool33/4EWrerNfiLVOBw9hNIMZSPuSb1XKO6QXiaxTswWHPqvn9LzOFl3238CZkR
         lz1dmDUHCW9oItB0lqCF7mzbAWrdLXUCp9jIcfl9zSY/F8wyRE+api/UMjNpAaGRufRk
         /QWVEM/Tx7qQ3l2hfvPeE9xP3A5QVa6ZyU1aAtTZ7xMZ0dLRe6r2Aab41BzUFWmYUFyt
         oobw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731605889; x=1732210689;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sbQAXiI9Dzu9Ee3eEwZ7D/5xWLvxvnaf/SprirDiKHE=;
        b=gXhtAsrqAUmF6OSz+s1Yc7a2IO8rZi5QchT5RyE/MRanK6j0G+7UoblGqR6gzV0r1U
         TQ9mfHhqjiMd7WJvVyenoBpC8/ZhvodVUvradgjUcovjdq93fB9ZWJqlscevDVgohYKp
         YRbuGzvMqBd5JwEViOOqSaLSNPJRw6h8S9kpm9GZqA67/rGq+VJP2cP5Gs0x9TT8tEOU
         QfwWJMiILTMw6yA8+ikEM/Enmo5X34HNXPIHi+QilhpMz5EGuHTlJJqOUtVfnYSk3iLO
         wq77crzg/FgegtjHcEeGAHjS3xuvCeqIFpiMBnxFVYpvaRRP++psmatleFWcAIt3x0YH
         ny9Q==
X-Gm-Message-State: AOJu0Yx9U13KH8q/iUqpaAYzGT3zQJSEeMzPc08wuRH9N3y4PhN0zwHG
	hyeKEFWWanU7JzheI0b3zWey4EDThazPUjDNxoCqzOKFJxeL0C80kvbzbA==
X-Google-Smtp-Source: AGHT+IFTnlkZZxDCmqv7y9hd3PD8IiI5ITAKlqKPm4rwfnu7bXEOoC142XCQjaYr5uf8NI4BzOnR6Q==
X-Received: by 2002:a17:907:2dab:b0:a99:f975:2e6 with SMTP id a640c23a62f3a-a9eeff3772amr2457757266b.35.1731605888823;
        Thu, 14 Nov 2024 09:38:08 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa20df56b31sm85799966b.72.2024.11.14.09.38.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Nov 2024 09:38:06 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 4/6] io_uring: introduce concept of memory regions
Date: Thu, 14 Nov 2024 17:38:34 +0000
Message-ID: <069d94bca26aac066771574756ca007d0b68989a.1731604990.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731604990.git.asml.silence@gmail.com>
References: <cover.1731604990.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We've got a good number of mappings we share with the userspace, that
includes the main rings, provided buffer rings, upcoming rings for
zerocopy rx and more. All of them duplicate user argument parsing and
some internal details as well (page pinnning, huge page optimisations,
mmap'ing, etc.)

Introduce a notion of regions. For userspace for now it's just a new
structure called struct io_uring_region_desc which is supposed to
parameterise all such mapping / queue creations. A region either
represents a user provided chunk of memory, in which case the user_addr
field should point to it, or a request for the kernel to allocate the
memory, in which case the user would need to mmap it after using the
offset returned in the mmap_offset field. With a uniform userspace API
we can avoid additional boiler plate code and apply future optimisation
to all of them at once.

Internally, there is a new structure struct io_mapped_region holding all
relevant runtime information and some helpers to work with it. This
patch limits it to user provided regions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  6 ++++
 include/uapi/linux/io_uring.h  | 14 ++++++++
 io_uring/memmap.c              | 65 ++++++++++++++++++++++++++++++++++
 io_uring/memmap.h              | 14 ++++++++
 4 files changed, 99 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 52a5da99a205..1d3a37234ace 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -75,6 +75,12 @@ struct io_hash_table {
 	unsigned		hash_bits;
 };
 
+struct io_mapped_region {
+	struct page		**pages;
+	void			*vmap_ptr;
+	size_t			nr_pages;
+};
+
 /*
  * Arbitrary limit, can be raised if need be
  */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 132f5db3d4e8..5cbfd330c688 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -647,6 +647,20 @@ struct io_uring_files_update {
 	__aligned_u64 /* __s32 * */ fds;
 };
 
+enum {
+	/* initialise with user provided memory pointed by user_addr */
+	IORING_MEM_REGION_TYPE_USER		= 1,
+};
+
+struct io_uring_region_desc {
+	__u64 user_addr;
+	__u64 size;
+	__u32 flags;
+	__u32 id;
+	__u64 mmap_offset;
+	__u64 __resv[4];
+};
+
 /*
  * Register a fully sparse file space, rather than pass in an array of all
  * -1 file descriptors.
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 6ab59c60dfd0..510c75b88a07 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -12,6 +12,7 @@
 
 #include "memmap.h"
 #include "kbuf.h"
+#include "rsrc.h"
 
 static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
 				   size_t size, gfp_t gfp)
@@ -194,6 +195,70 @@ void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 	return ERR_PTR(-ENOMEM);
 }
 
+void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
+{
+	if (mr->pages)
+		unpin_user_pages(mr->pages, mr->nr_pages);
+	if (mr->vmap_ptr)
+		vunmap(mr->vmap_ptr);
+	if (mr->nr_pages && ctx->user)
+		__io_unaccount_mem(ctx->user, mr->nr_pages);
+
+	memset(mr, 0, sizeof(*mr));
+}
+
+int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
+		     struct io_uring_region_desc *reg)
+{
+	int pages_accounted = 0;
+	struct page **pages;
+	int nr_pages, ret;
+	void *vptr;
+	u64 end;
+
+	if (WARN_ON_ONCE(mr->pages || mr->vmap_ptr || mr->nr_pages))
+		return -EFAULT;
+	if (memchr_inv(&reg->__resv, 0, sizeof(reg->__resv)))
+		return -EINVAL;
+	if (reg->flags != IORING_MEM_REGION_TYPE_USER)
+		return -EINVAL;
+	if (!reg->user_addr)
+		return -EFAULT;
+	if (!reg->size || reg->mmap_offset || reg->id)
+		return -EINVAL;
+	if ((reg->size >> PAGE_SHIFT) > INT_MAX)
+		return E2BIG;
+	if ((reg->user_addr | reg->size) & ~PAGE_MASK)
+		return -EINVAL;
+	if (check_add_overflow(reg->user_addr, reg->size, &end))
+		return -EOVERFLOW;
+
+	pages = io_pin_pages(reg->user_addr, reg->size, &nr_pages);
+	if (IS_ERR(pages))
+		return PTR_ERR(pages);
+
+	if (ctx->user) {
+		ret = __io_account_mem(ctx->user, nr_pages);
+		if (ret)
+			goto out_free;
+		pages_accounted = nr_pages;
+	}
+
+	vptr = vmap(pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (!vptr)
+		goto out_free;
+
+	mr->pages = pages;
+	mr->vmap_ptr = vptr;
+	mr->nr_pages = nr_pages;
+	return 0;
+out_free:
+	if (pages_accounted)
+		__io_unaccount_mem(ctx->user, pages_accounted);
+	io_pages_free(&pages, nr_pages);
+	return ret;
+}
+
 static void *io_uring_validate_mmap_request(struct file *file, loff_t pgoff,
 					    size_t sz)
 {
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index 5cec5b7ac49a..f361a635b6c7 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -22,4 +22,18 @@ unsigned long io_uring_get_unmapped_area(struct file *file, unsigned long addr,
 					 unsigned long flags);
 int io_uring_mmap(struct file *file, struct vm_area_struct *vma);
 
+void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr);
+int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
+		     struct io_uring_region_desc *reg);
+
+static inline void *io_region_get_ptr(struct io_mapped_region *mr)
+{
+	return mr->vmap_ptr;
+}
+
+static inline bool io_region_is_set(struct io_mapped_region *mr)
+{
+	return !!mr->nr_pages;
+}
+
 #endif
-- 
2.46.0


