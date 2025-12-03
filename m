Return-Path: <io-uring+bounces-10898-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id D9F8EC9D673
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:36:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 9DA4234A29C
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3D0C1EEA5F;
	Wed,  3 Dec 2025 00:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YlgUbIn6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE01B219A71
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722195; cv=none; b=LekbW30+TWrTD3+Lb024UTIeSCov0rQ6U3zetY14tUygW0IJavU5MgHJbzM9fU2iR6hTCkhKuQxrR6+uUg5JrioapQj25Gk1DaIdZCOpxhphaXrlVDHJyYmvfwbPcVkyNvL6lGrsz2E28wo7xsplH8rMn6TTPHFS33LCoZOI28I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722195; c=relaxed/simple;
	bh=8g31npMaaLwKzx0Hua5bYHuerp1n+LRd0W9R+AxWjXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r8kcFswu22/19PEj/EcIq5vyo84qnsRcUNEcWkmCFWrke3iAPYQIhMprXtNBqh1RBskJRKRd5Zmj8cG/dX1sUpw50+G85bRKTq3AMldEXBrl2btNgFxyJlALhSBwxhs/3lnwBThV4KPnaGxFR46KMa+6emLfIQvRvrUTQJjYVLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YlgUbIn6; arc=none smtp.client-ip=209.85.214.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-298287a26c3so72607985ad.0
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722193; x=1765326993; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YQWxqzjXuaT+PexmcS2S3YXmhCj6RhyZJ7kYpjsEyqs=;
        b=YlgUbIn6NIGs5Aec00YQDMRinQiAIqd+/HTgGXRSUBgVFj5VFn3Fym1CGBnTMbQwI/
         ohNwZY0LTvEoAoNSeJjFgJGFQ/oCYLwoxReV4gwmv9UZOUmCFAeg85t15zkwFIBPvpxH
         qyiw2r+v/a1nHQ2mUCtTIO5OGu/TG6LWunMHORQBrYhSo0ZpPjgmf+CIk3hn1ThnQ+BC
         smZAM+sM5h24SODA288W+hX6HG87tvzNpSE8rcdHEAIayQ4OwXX/KsPt4uODKFcM3kny
         C2Yc/TAMbOygni8vIDnIF83WshyVInfuRDmeV/AZdICmLBB1pldj6jk8tabo0T/uj3aE
         JeMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722193; x=1765326993;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YQWxqzjXuaT+PexmcS2S3YXmhCj6RhyZJ7kYpjsEyqs=;
        b=o6IvfVYbgFw1gaWpkK/oHEp74buRJv3kaUHgcyEtVMqxwaWfIkrqErm3rNmcH9DLYt
         LNHiuS6EdZ+vlzFhk5HQRJ1W9mAXWo925ljFXX71xVwznl98A+unZP0ZVNRZSLxCeEFG
         hGqUXvVNS+hDl97VNFK2QiqaSOkIDxE2FfJszAsMTTz9meXq+V5BABvUTNZ2KeaWvr0p
         lQnwPrly0vV5aqdRXieNN33bWq+7rVjngPS7TtsqtJr+wYfcWPGVPzwv5vPfwTvufaK4
         ZxGWwQOlVqc1ovFtuftEXhMvjZYHvcZuKUr4JiQgXsE5KUiLQAeBkLXYBDjtsXDHk75b
         JjSg==
X-Forwarded-Encrypted: i=1; AJvYcCUt4EWxo8dwAR44jpmMhu9MruFgW6Bh/FEQdeGIKbjh4NXEoi9BJ8O6/3jhGWlO32zPUM8NBgSbLQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz8lRxrwLfI3vmq+TspkKjGJraoF0VHRo0QrTA3EK/7tyIube1c
	Lz/x3gx3nOhxmONvQCwPNH6WkMyGSS4LDKzDNXjlQU7pExPXPVQ9JNMi
X-Gm-Gg: ASbGncts9wKIw62pJRw78U6DWcTO4Q+dY5uDwFlWNa9Kg5+G/NO6FMzi6oN6XCHkH5p
	ywFLOKsZscW1zJAEWa2rhkSbJ56As4hn1GeX30swkSsMoMSTEopdaN1r5/EKXwRjF8iBsj4IGUk
	yJdG3xbu2+/BfSX9EOqe6L9BEpvWmiGHvqCTMkH1+i+6zyT/dOuuDUz7kNVqYHX66BP0YvxdmFu
	HncS8rS3NviJHQYMs0fZwhAgnMe82B8fP5Y3wp0dZ9SdTFtYMWxXqaApQBIHnrn777EAG6S3E/m
	oISLvE9lyTosVA6ivC960mKaYgwE7Os3XER1/cGixXycfe0zma5/idVM13WI7vMUEUf2vSAK+ph
	Mr/exNwiPdDaheE+UCxRuG5lwsJ4zSWI7aaKApxvjxHvNt/0zvL31fyvF4ddtkKmsHBEYZfc2Wh
	44WDzS5tYx54VzJmop
X-Google-Smtp-Source: AGHT+IFCQF/mH5UAYnD9Yov5GRGWsV6Ig2sVyH6plUV3rEzIJKlzrNdKDB+lLeyUEijeKlZd0/6UHA==
X-Received: by 2002:a17:903:2407:b0:294:ec7d:969c with SMTP id d9443c01a7336-29d6848f26dmr5813095ad.49.1764722193150;
        Tue, 02 Dec 2025 16:36:33 -0800 (PST)
Received: from localhost ([2a03:2880:ff:9::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29bce46ca9bsm168431915ad.38.2025.12.02.16.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:32 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 03/30] io_uring/kbuf: add support for kernel-managed buffer rings
Date: Tue,  2 Dec 2025 16:34:58 -0800
Message-ID: <20251203003526.2889477-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for kernel-managed buffer rings (kmbuf rings), which allow
the kernel to allocate and manage the backing buffers for a buffer
ring, rather than requiring the application to provide and manage them.

This introduces two new registration opcodes:
- IORING_REGISTER_KMBUF_RING: Register a kernel-managed buffer ring
- IORING_UNREGISTER_KMBUF_RING: Unregister a kernel-managed buffer ring

The existing io_uring_buf_reg structure is extended with a union to
support both application-provided buffer rings (pbuf) and kernel-managed
buffer rings (kmbuf):
- For pbuf rings: ring_addr specifies the user-provided ring address
- For kmbuf rings: buf_size specifies the size of each buffer. buf_size
  must be non-zero and page-aligned.

The implementation follows the same pattern as pbuf ring registration,
reusing the validation and buffer list allocation helpers introduced in
earlier refactoring. The IOBL_KERNEL_MANAGED flag marks buffer lists as
kernel-managed for appropriate handling in the I/O path.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/uapi/linux/io_uring.h |  15 ++++-
 io_uring/kbuf.c               |  76 +++++++++++++++++++++++
 io_uring/kbuf.h               |   7 ++-
 io_uring/memmap.c             | 112 ++++++++++++++++++++++++++++++++++
 io_uring/memmap.h             |   4 ++
 io_uring/register.c           |   7 +++
 6 files changed, 217 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b5b23c0d5283..589755a4e2b4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -700,6 +700,10 @@ enum io_uring_register_op {
 	/* auxiliary zcrx configuration, see enum zcrx_ctrl_op */
 	IORING_REGISTER_ZCRX_CTRL		= 36,
 
+	/* register/unregister kernel-managed ring buffer group */
+	IORING_REGISTER_KMBUF_RING		= 37,
+	IORING_UNREGISTER_KMBUF_RING		= 38,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -869,9 +873,16 @@ enum io_uring_register_pbuf_ring_flags {
 	IOU_PBUF_RING_INC	= 2,
 };
 
-/* argument for IORING_(UN)REGISTER_PBUF_RING */
+/* argument for IORING_(UN)REGISTER_PBUF_RING and
+ * IORING_(UN)REGISTER_KMBUF_RING
+ */
 struct io_uring_buf_reg {
-	__u64	ring_addr;
+	union {
+		/* used for pbuf rings */
+		__u64	ring_addr;
+		/* used for kmbuf rings */
+		__u32   buf_size;
+	};
 	__u32	ring_entries;
 	__u16	bgid;
 	__u16	flags;
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 8f7ec4ebd990..1668718ac8fd 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -778,3 +778,79 @@ struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
 		return NULL;
 	return &bl->region;
 }
+
+static int io_setup_kmbuf_ring(struct io_ring_ctx *ctx,
+			       struct io_buffer_list *bl,
+			       struct io_uring_buf_reg *reg)
+{
+	struct io_uring_buf_ring *ring;
+	unsigned long ring_size;
+	void *buf_region;
+	unsigned int i;
+	int ret;
+
+	/* allocate pages for the ring structure */
+	ring_size = flex_array_size(ring, bufs, bl->nr_entries);
+	ring = kzalloc(ring_size, GFP_KERNEL_ACCOUNT);
+	if (!ring)
+		return -ENOMEM;
+
+	ret = io_create_region_multi_buf(ctx, &bl->region, bl->nr_entries,
+					 reg->buf_size);
+	if (ret) {
+		kfree(ring);
+		return ret;
+	}
+
+	/* initialize ring buf entries to point to the buffers */
+	buf_region = bl->region.ptr;
+	for (i = 0; i < bl->nr_entries; i++) {
+		struct io_uring_buf *buf = &ring->bufs[i];
+
+		buf->addr = (u64)buf_region;
+		buf->len = reg->buf_size;
+		buf->bid = i;
+
+		buf_region += reg->buf_size;
+	}
+	ring->tail = bl->nr_entries;
+
+	bl->buf_ring = ring;
+
+	return 0;
+}
+
+int io_register_kmbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
+{
+	struct io_uring_buf_reg reg;
+	struct io_buffer_list *bl;
+	int ret;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	if (copy_from_user(&reg, arg, sizeof(reg)))
+		return -EFAULT;
+
+	ret = io_validate_buf_reg(&reg, 0);
+	if (ret)
+		return ret;
+
+	if (!reg.buf_size || !PAGE_ALIGNED(reg.buf_size))
+		return -EINVAL;
+
+	ret = io_alloc_new_buffer_list(ctx, &reg, &bl);
+	if (ret)
+		return ret;
+
+	ret = io_setup_kmbuf_ring(ctx, bl, &reg);
+	if (ret) {
+		kfree(bl);
+		return ret;
+	}
+
+	bl->flags |= IOBL_KERNEL_MANAGED;
+
+	io_buffer_add_list(ctx, bl, reg.bgid);
+
+	return 0;
+}
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 40b44f4fdb15..62c80a1ebf03 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -7,9 +7,11 @@
 
 enum {
 	/* ring mapped provided buffers */
-	IOBL_BUF_RING	= 1,
+	IOBL_BUF_RING		= 1,
 	/* buffers are consumed incrementally rather than always fully */
-	IOBL_INC	= 2,
+	IOBL_INC		= 2,
+	/* buffers are kernel managed */
+	IOBL_KERNEL_MANAGED	= 4,
 };
 
 struct io_buffer_list {
@@ -74,6 +76,7 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
+int io_register_kmbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index dc4bfc5b6fb8..a46b027882f8 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -15,6 +15,28 @@
 #include "rsrc.h"
 #include "zcrx.h"
 
+static void release_multi_buf_pages(struct page **pages, unsigned long nr_pages)
+{
+	struct page *page;
+	unsigned int nr, i = 0;
+
+	while (nr_pages) {
+		page = pages[i];
+
+		if (!page || WARN_ON_ONCE(page != compound_head(page)))
+			return;
+
+		nr = compound_nr(page);
+		put_page(page);
+
+		if (WARN_ON_ONCE(nr > nr_pages))
+			return;
+
+		i += nr;
+		nr_pages -= nr;
+	}
+}
+
 static bool io_mem_alloc_compound(struct page **pages, int nr_pages,
 				  size_t size, gfp_t gfp)
 {
@@ -86,6 +108,8 @@ enum {
 	IO_REGION_F_USER_PROVIDED		= 2,
 	/* only the first page in the array is ref'ed */
 	IO_REGION_F_SINGLE_REF			= 4,
+	/* pages in the array belong to multiple discrete allocations */
+	IO_REGION_F_MULTI_BUF			= 8,
 };
 
 void io_free_region(struct user_struct *user, struct io_mapped_region *mr)
@@ -98,6 +122,8 @@ void io_free_region(struct user_struct *user, struct io_mapped_region *mr)
 
 		if (mr->flags & IO_REGION_F_USER_PROVIDED)
 			unpin_user_pages(mr->pages, nr_refs);
+		else if (mr->flags & IO_REGION_F_MULTI_BUF)
+			release_multi_buf_pages(mr->pages, nr_refs);
 		else
 			release_pages(mr->pages, nr_refs);
 
@@ -149,6 +175,54 @@ static int io_region_pin_pages(struct io_mapped_region *mr,
 	return 0;
 }
 
+static int io_region_allocate_pages_multi_buf(struct io_mapped_region *mr,
+					      unsigned int nr_bufs,
+					      unsigned int buf_size)
+{
+	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
+	struct page **pages, **cur_pages;
+	unsigned int nr_allocated;
+	unsigned int buf_pages;
+	unsigned int i;
+
+	if (!PAGE_ALIGNED(buf_size))
+		return -EINVAL;
+
+	buf_pages = buf_size >> PAGE_SHIFT;
+
+	pages = kvmalloc_array(mr->nr_pages, sizeof(*pages), gfp);
+	if (!pages)
+		return -ENOMEM;
+
+	cur_pages = pages;
+
+	for (i = 0; i < nr_bufs; i++) {
+		if (io_mem_alloc_compound(cur_pages, buf_pages, buf_size,
+					  gfp)) {
+			cur_pages += buf_pages;
+			continue;
+		}
+
+		nr_allocated = alloc_pages_bulk_node(gfp, NUMA_NO_NODE,
+						     buf_pages, cur_pages);
+		if (nr_allocated != buf_pages) {
+			unsigned int total =
+				(cur_pages - pages) + nr_allocated;
+
+			release_multi_buf_pages(pages, total);
+			kvfree(pages);
+			return -ENOMEM;
+		}
+
+		cur_pages += buf_pages;
+	}
+
+	mr->flags |= IO_REGION_F_MULTI_BUF;
+	mr->pages = pages;
+
+	return 0;
+}
+
 static int io_region_allocate_pages(struct io_mapped_region *mr,
 				    struct io_uring_region_desc *reg,
 				    unsigned long mmap_offset)
@@ -181,6 +255,44 @@ static int io_region_allocate_pages(struct io_mapped_region *mr,
 	return 0;
 }
 
+int io_create_region_multi_buf(struct io_ring_ctx *ctx,
+			       struct io_mapped_region *mr,
+			       unsigned int nr_bufs, unsigned int buf_size)
+{
+	unsigned long nr_pages;
+	int ret;
+
+	if (WARN_ON_ONCE(mr->pages || mr->ptr || mr->nr_pages))
+		return -EFAULT;
+
+	if (WARN_ON_ONCE(!nr_bufs || !buf_size))
+		return -EINVAL;
+
+	nr_pages = ((size_t)buf_size * nr_bufs) >> PAGE_SHIFT;
+	if (nr_pages > UINT_MAX)
+		return -E2BIG;
+
+	if (ctx->user) {
+		ret = __io_account_mem(ctx->user, nr_pages);
+		if (ret)
+			return ret;
+	}
+	mr->nr_pages = nr_pages;
+
+	ret = io_region_allocate_pages_multi_buf(mr, nr_bufs, buf_size);
+	if (ret)
+		goto out_free;
+
+	ret = io_region_init_ptr(mr);
+	if (ret)
+		goto out_free;
+
+	return 0;
+out_free:
+	io_free_region(ctx->user, mr);
+	return ret;
+}
+
 int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg,
 		     unsigned long mmap_offset)
diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index a39d9e518905..b09fc34d5eb9 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -21,6 +21,10 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg,
 		     unsigned long mmap_offset);
 
+int io_create_region_multi_buf(struct io_ring_ctx *ctx,
+			       struct io_mapped_region *mr,
+			       unsigned int nr_bufs, unsigned int buf_size);
+
 static inline void *io_region_get_ptr(struct io_mapped_region *mr)
 {
 	return mr->ptr;
diff --git a/io_uring/register.c b/io_uring/register.c
index 4c6879698844..4aabf6e44083 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -746,7 +746,14 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_pbuf_ring(ctx, arg);
 		break;
+	case IORING_REGISTER_KMBUF_RING:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_kmbuf_ring(ctx, arg);
+		break;
 	case IORING_UNREGISTER_PBUF_RING:
+	case IORING_UNREGISTER_KMBUF_RING:
 		ret = -EINVAL;
 		if (!arg || nr_args != 1)
 			break;
-- 
2.47.3


