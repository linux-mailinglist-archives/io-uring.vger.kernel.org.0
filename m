Return-Path: <io-uring+bounces-4674-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A6569C81D2
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 05:14:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BE607284679
	for <lists+io-uring@lfdr.de>; Thu, 14 Nov 2024 04:14:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812EE1E7C16;
	Thu, 14 Nov 2024 04:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hpNy1ax5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1A511DF72E
	for <io-uring@vger.kernel.org>; Thu, 14 Nov 2024 04:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731557646; cv=none; b=HEXIRfIo5CL83mqhjmhaK+qNaCPj89KNl+iyhcdDZva2vnhBLgJAcgtW2yM+k5NwMmoirzK6KHrAfXMQNg7clWyWri0HR0aFUxFHKAkqj6Qpamtm/jNWI5M9B6wkv/OQo1WMD/j+4ORis9ytHnzAjFFGNJgxzEgq/BrJYYfi1/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731557646; c=relaxed/simple;
	bh=XGNR0R9bVnjdyjqTCXAwbp0v04eZfBEsyas4/N/tT50=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rSzc3QylE2XxaSLxKMgAr1V2EQnODBS9vPatzvYpu0f7gSIe73Q62UfkVJAbLOxVc1FxM28wudyYCfe0ONvUCHpMYY6VfZUplKppXTAidPCcGjGNO5MlnayAcbpbMdxmMSELrH38dnfOs9jme+NIi9w6uEO73x/Wj8X7Hjr67xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hpNy1ax5; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-382171fe8b1so175713f8f.1
        for <io-uring@vger.kernel.org>; Wed, 13 Nov 2024 20:14:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731557643; x=1732162443; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QevZ2XM/oLWl+9z9+p8K4+bD59erMc6Ct/g8gJjyWoY=;
        b=hpNy1ax5ekraWGDxFSrEwZgKqu1lgzFajUOoW96ePdoIR4ey1xkgFTG/gOgFceZ1gu
         mY2/Mawgz2trT8grZX+3whkqj6MS43tNx2OIeGvZUNv8YtE2R26TehiCpA2yzkr/2pmQ
         xiEpO59TDkOq9qNXRbtqRKizWaURov4nGBgxZg6YFSnU+Ei8MXeJBy4I1YDgjxeRRDFI
         0Qb3Oq/A5FRU4ZF0Dp+PsHUxbkVXWNAcEQVuaLjr/q5KKGN5CGaoYDs4VyK3YCWuCmjH
         MKb/qCN1HR29jq7U+Di98nJHNvztUzMhvj4K8zkkvFRMpISyJYcFjuSdUKQ+sTkc8C/G
         Py4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731557643; x=1732162443;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QevZ2XM/oLWl+9z9+p8K4+bD59erMc6Ct/g8gJjyWoY=;
        b=ARicuM2N6m+SXGy9o/FdH3GR4DPl3vnHZRMA/HAkWeha2IdC4uE+oxmbkRfzc8DutD
         vtk2cXZEzOqxIi3CDr3kXNZarD2OeVpqjgnL+hzxkihdmt1nCY+a4lQkQtGEsx3opWEc
         7VUNzDq1+9jcbVcwbsIrffHJRa7gh1XGhYj4937Eg8WuW5ih912/bskbxVP3SsmfXaUP
         AlVBoU+ne3HlxtM8IbTpmqBgKdzaRDPoGgaeUB+pbmRVw0vteiU3vf746OGxJpLxzk2p
         O8CD4UjBsYOng4RMlHBWxLSpVpy3iYAjf1yIZwy5O8u4B5iSxLauJXglvcaoBpIuOIrM
         9WTA==
X-Gm-Message-State: AOJu0YyyCH4xlvP6/xSmOmJFC7WULlKEi8s/RKVKc80xLKLuJK0jwWy5
	xaETX7t8lO3r1b8NjDg/YL3iEJ4sMoKk7a9DtRKDFiu70u54RayR3mejcQ==
X-Google-Smtp-Source: AGHT+IF7PNOJCpu6HZRqcfBPV7OvKg5sSIv9Ho53jENvP7WjPzPxMr4yoKYkjxjtzp1cIXNPyNCDKQ==
X-Received: by 2002:a05:6000:1568:b0:374:cd3c:db6d with SMTP id ffacd0b85a97d-38213fe958bmr1379505f8f.6.1731557642774;
        Wed, 13 Nov 2024 20:14:02 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae311fbsm251936f8f.95.2024.11.13.20.14.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2024 20:14:02 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/6] io_uring: introduce memory regions
Date: Thu, 14 Nov 2024 04:14:23 +0000
Message-ID: <cd8e0927651ecdb99776503e50aa3554573b9a61.1731556844.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731556844.git.asml.silence@gmail.com>
References: <cover.1731556844.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We've got a good number of mappings we share with the userspace, that
includes the main rings, provided buffer rings and at least a couple
more types. And all of them duplicate some of the code for page pinning,
mmap'ing and attempts to optimise it with huge pages.

Introduce a notion of regions. For userspace it's just a new structure
called struct io_uring_region_desc which supposed to parameterise all
such mapping / queues creations. It either represents a user provided
memory, in which case the user_addr field should point to it, or a
request to the kernel to creating the memory, in which case the user is
supposed to mmap it after using the offset returned in the mmap_offset
field. With uniform userspace API we can avoid additional boiler plate
code and when we'd be adding some optimisation it'll be applied to all
mapping types.

Internally, there is a new structure struct io_mapped_region holding all
relevant runtime information and some helpers to work with it. This
patch limits it to user provided regions, which will be extended as a
follow up work.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  6 ++++
 include/uapi/linux/io_uring.h  | 13 +++++++
 io_uring/memmap.c              | 65 ++++++++++++++++++++++++++++++++++
 io_uring/memmap.h              | 14 ++++++++
 4 files changed, 98 insertions(+)

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
index 132f5db3d4e8..7ceeccbbf4cb 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -647,6 +647,19 @@ struct io_uring_files_update {
 	__aligned_u64 /* __s32 * */ fds;
 };
 
+enum {
+	/* initialise with user memory pointed by user_addr */
+	IORING_REGION_USER_MEM			= 1,
+};
+
+struct io_uring_region_desc {
+	__u64 user_addr;
+	__u64 size;
+	__u64 flags;
+	__u64 mmap_offset;
+	__u64 __resv[4];
+};
+
 /*
  * Register a fully sparse file space, rather than pass in an array of all
  * -1 file descriptors.
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 6ab59c60dfd0..6b03f5641ef3 100644
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
+	if (reg->flags != IORING_REGION_USER_MEM)
+		return -EINVAL;
+	if (!reg->user_addr)
+		return -EFAULT;
+	if (!reg->size || reg->mmap_offset)
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


