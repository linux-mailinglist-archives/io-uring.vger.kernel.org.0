Return-Path: <io-uring+bounces-11254-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4E8FCCD77EE
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 01:36:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id ACDC3301C3EE
	for <lists+io-uring@lfdr.de>; Tue, 23 Dec 2025 00:36:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C696E1F3B87;
	Tue, 23 Dec 2025 00:36:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TrQYx07S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FDD1F5842
	for <io-uring@vger.kernel.org>; Tue, 23 Dec 2025 00:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766450192; cv=none; b=IHcs1owaruT9CCTF23BST1pLZZVFMWe7BACq4GYjHLweDf8eB3yWX6M009VmCQ8EqXRy/t+Ab6uNOg1dr3Xoi5dbILIfKDSz8Yqe3xcaBYtSkG4G0E9lf0BvIotJtrEQmgXSU2VJfnaM66/SGJ5MPYSI5HvzmF4/E68uVtFVMHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766450192; c=relaxed/simple;
	bh=rFBSfztDD4YAtd3VG+b2Z391yCEo1vGXv7QyTGqgki0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYqmW0Fh+43IjY1CJ2QoOUVACM61I+xrsxcPgMTCFZTztWfUvkFLowhinBTu0EIVqOgw1MJRge8A+ZY7IpIAJGGTTZYnpZl83mXm1egWDvyqS27WOKxqyCN4zwC8B+BYBs/GElJX56a9F/5GzDn4fIEsU3s4j3RhzHlmZgBpTug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TrQYx07S; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8035e31d834so1881396b3a.2
        for <io-uring@vger.kernel.org>; Mon, 22 Dec 2025 16:36:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766450190; x=1767054990; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2rIzbkSKYHSvAm1BBJUTqyYSLgGtxZfO74BL5z2UFQo=;
        b=TrQYx07STs/M/AtnkVWi5w+GkzOge6XAjhpdMQ0HSquqffcvddA1ZoFiKvqTF37qzH
         lDb+URiGr3T6wGL1AkhXIcz3ylwF/+7s4k7FnGuhNorgNKSSMo5y7SWy3ofRvk+Cesmj
         GDiM1EM3Btxlv1o7TlyNDab/2sNNtCo6uXNeQRSoHTEJEWOKVCFO9Oy2Ka+5iVdPQ2Hx
         WNWAudCJicg0ZujqKyBP5efiJv1ih4W4gsYxrcMv476QfYaQKmXaNtHgDxwX0PTaEGyh
         sX4Denj8OOxTSwJPG8Fns2HFFtw7lMdRE1I/8VgSswdUWIwOh5dC1469W+iJ8tg3ixdw
         RnOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766450190; x=1767054990;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2rIzbkSKYHSvAm1BBJUTqyYSLgGtxZfO74BL5z2UFQo=;
        b=ioYJpbPHmPVGrPU+Nv6wTPAgnZzWVWnR/LzeOitpjdwqfYt+MUrtpVmlLD56xG+LtG
         lQqOMC7wGLtRp3pzQp8cH9xilHZuIWo0un5CBRBa8s+UrABGcPloHcF5mQcE1rEA3kyF
         8laZ02KMxpNy/YivsmJtwVytAyMXM1kXpiaUrnuJKpcWiqmXAZvV667Bu1pAK/A9DySA
         U3auo2Iriyg4j6cQ9H8ckJKfoSiSmYUFrWREp0rlSLTs9UsF0+wBvtMLVMD8/SOftHpr
         1GZxNtYXRERypuMe1IBctVV4UDX7CnzK+XQZE+Vl0dpLjaTeIXVwaHRtN1Ni2renrraZ
         tnqg==
X-Forwarded-Encrypted: i=1; AJvYcCVoumkv9mrvkojxYfuqzqNvy5ouv4URx9mNFSylZb/9QrbMWIUZccGcVnMH86dORzEyY6WYBrN62g==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy4LvTQlgwPen0hA2AIWAJKXBu+7XunQ/lk9a+48lvANlVRnkrO
	fDkNS7FWziDxxMBEk464KPnZjsfUOMMANnjPtEpfzUfZybyTXGzqouBw
X-Gm-Gg: AY/fxX5vdjRxKiRe2mOuDOF5HqecVT/GzKAVToEYZurUFh6kqDp6J7piuNnyQJo1S4K
	PPupdR8VJlgrn4432QNTh5hzFQBt6EnvAxA/Iza3e3DWVbZnogMuEILjH6NSaCS8ARRq/Bu92qP
	Sw4IsN+3YgJuzoSc/M8OngDUI6AcPM8Z3wyCfkGHPUOlbW9ckz/B+ebYu8lA2hnFlQJi6fNtJML
	GqJ8y5rCHIilP945KeUFkQeNKbQveKM7HU+86GwoAgZFEeem3iMWPw7kXV85vQXGA80EQxs+3Am
	CohJrgo47KG9xSjVIi+wnlbcBumwpk64A+kyMo7An5zTGhJOqHLXWcRV62r/C6jdcp9FXNxGygD
	VG5ZnH/Hc8ha1zIy/j4LkOfL2zLxm0Kd78yljNfX6ypHAE7srogONQ8L+W76ULr7q2FzJu8rPEo
	Nres5/SI9lxn4UW3P+
X-Google-Smtp-Source: AGHT+IH9S8s7lr8CNR7OCzvG6ca5NGx+Smo82+C+SgpFIRLPw+ccvdPfSjmL2oQrCR4TfcJbGdI/Gg==
X-Received: by 2002:a05:6a00:8007:b0:7e8:43f5:bd2a with SMTP id d2e1a72fcca58-7ff6795af19mr12127548b3a.63.1766450190126;
        Mon, 22 Dec 2025 16:36:30 -0800 (PST)
Received: from localhost ([2a03:2880:ff:8::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e48f26asm11418251b3a.52.2025.12.22.16.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Dec 2025 16:36:29 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v3 03/25] io_uring/kbuf: add support for kernel-managed buffer rings
Date: Mon, 22 Dec 2025 16:35:00 -0800
Message-ID: <20251223003522.3055912-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251223003522.3055912-1-joannelkoong@gmail.com>
References: <20251223003522.3055912-1-joannelkoong@gmail.com>
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
index 18e574776ef6..4573eed3b072 100644
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


