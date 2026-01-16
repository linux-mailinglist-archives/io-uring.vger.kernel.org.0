Return-Path: <io-uring+bounces-11771-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 40835D38A13
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:31:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7E474305BA6C
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 166A03002D8;
	Fri, 16 Jan 2026 23:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l8wy85HK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB23326939
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606269; cv=none; b=l3HwjbwLZ5k42JbVA/FTjIMFA9A4WxJzAr+Iej5fD/URYvEqNaQNleQoIqlzUuiR6ocJxjFj76rMZAUl3TYYMImp5O7POO0xBT89gRSA43p1NtLErMZfAPZNSvVYdoAZRTADhRBMwV7JV/Q5YSVqcx/BWEUZkcneTPDrKYK289g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606269; c=relaxed/simple;
	bh=S/P/Pi7k9+GMO8/wtdtvvTOClXkF5cDnEuvjji111Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lEwRYt0udysmproZnaqkfpvLEkrJn88h9Bfxye6Uxp0XFe9DhtHvjRkfOKhkb7Vjv05nmdLgRS8kFQcOmXB8Cg0nP1HtPe9uhsSvTiqI9X15GYOdL9I2SDQIOIroJGK4ONKrT32m5V+cG+yUDmAUU3EGHNjyGm6b3whMovTBWOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l8wy85HK; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-81345800791so1578815b3a.0
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606268; x=1769211068; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xTBjbYKufpuiVlN0nHMkvq4zvqL3yG3wJhOu9kguX8s=;
        b=l8wy85HKeFi7tSG7Enj3GBvbJOqrXNvAbWrjvGI7Bj8ydouFnS56/SCinudDDdUJ+r
         JXIyhggsGKuwHVWx46klBRWxkrotqp3sKE567d/8jsfqKudZMEE4tJjbOU5Z69o6BkGJ
         cGci2s593KKXEISybzMxjSitK+hGhpljRRSIdNlubVNWGoPbgKW1sWDNj9SzRSkrSIKU
         BESa8K8c5C/blEl09O4eQzUqcNLm22RAxvoH5d8kl1q21pIhfQ0DNnavXZUSotdDWzPH
         EHcMdfF2BI6CkVy8N1EesTTuFjDeaPETEbDDlaMONvhoXYWOKeo6znpq/A/GdtrDYK4c
         3eXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606268; x=1769211068;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xTBjbYKufpuiVlN0nHMkvq4zvqL3yG3wJhOu9kguX8s=;
        b=XHGPv2YWBDZ82VsR52sJOZP3LTNy4W6/vef9cUgrFAot4GUH0tHFxvxnU05iLIJblp
         +quIFj9qbLjQOD+LhD0mJ8I6cZAUIZpy2edtyJDN1UWdOpwCZPN70Bhgl6T/Liwz2Jc7
         VmC4et0woC5ob9WhEtZLWyyqsUNogr7SlfPHkpaemyRg2YeUaO9OO//aKsNTyTcSTBHX
         Wy5bxzRD1vmLi+B6cElo5njCED2gLs9dQlNQCWatraCGvSEHdeojstCysWTO3F/I376R
         0VuyrxMdknQKgZC0ecHEj+8LSXH5GrG6zAMwLMrG3mi03qZRdfnP9zhg70vc7zIeNxmb
         4O9w==
X-Forwarded-Encrypted: i=1; AJvYcCXgLnO/zSmPywkNSdKtukCiXiRDK9dTHn9JZiBTpmzYOO9eW/py7Q5b3FMjQEGCpARWsg7egjhxVA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yww9K+gSCERbRZUrgXzuuQTZZye+3UNZDWvkq+ArKNaRhKBxoBQ
	I3PGzuqhqH8GCk/NwKWbV3fKtCg75Mhb+ERvT5p2qjsa5w8DiQMMyVocjUAwDg==
X-Gm-Gg: AY/fxX7fNKWoAciYGSI2W9eOvBRECRQWmFlLZFKfIBEpuutkvvwz+hKsAlx8FoWVS7U
	G76m4BkhvrHWx7w8jyhcrL3Mnbuz6BgRUexfhcsnzAGDVwOaxUgYU1AS4nvThXHJeNHcbcinUSg
	B9zp+8yKw+NrztheuFhziWK3wTfBZKs+vR8UzXDMYJD6wocrKkQyPaNXVkqJSTxqKFLY+fw0kqw
	ibYX/3yXIwjD4Lfq4kNF3KVOAOP7ofgoiknJqtXpJp7uh9JajV63Disg5fpf4rOb1f1oXUD4YPV
	jWV90EzqakHM+pmDBxcX5DAa+3yVHrrLcfxPoDdZg1O7BltHkJRbBobPI30yOHCcWj2vmcYRfO2
	iyg/R0nAALl0lIa2YlF0jX3Ifd3jTjlpcojZ5ndbUH63L7zD1nt5q6opIWTMfpH1H6SSvrr8kJT
	mof2Pf
X-Received: by 2002:a05:6a00:14c2:b0:81f:9986:c238 with SMTP id d2e1a72fcca58-81fa178095dmr3275587b3a.5.1768606267555;
        Fri, 16 Jan 2026 15:31:07 -0800 (PST)
Received: from localhost ([2a03:2880:ff:e::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa10bdafdsm2922537b3a.15.2026.01.16.15.31.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:07 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 03/25] io_uring/kbuf: add support for kernel-managed buffer rings
Date: Fri, 16 Jan 2026 15:30:22 -0800
Message-ID: <20260116233044.1532965-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
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
index cbe477db7b86..8d253724754e 100644
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
+		buf->addr = (u64)(uintptr_t)buf_region;
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
index 7d3c5eb58480..6ecb6f1da59c 100644
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
index 888c8172818f..7f51b44b0e1d 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -748,7 +748,14 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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


