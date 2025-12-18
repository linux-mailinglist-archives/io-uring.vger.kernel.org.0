Return-Path: <io-uring+bounces-11183-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id A6E05CCAE7E
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:35:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7A0283028C70
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E934C32E6AD;
	Thu, 18 Dec 2025 08:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mp9g9LNr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1CD2F1FD9
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046881; cv=none; b=rYVqq+6auao4NLCZ+T5yECL1aJ2ST8UKWzmuXN/2WHGFQ1RdA/GcXu+9b/NFnrx6G0io6a0mcfjoY3tVyTuSbaHr7Rk9TFrjde8jWRn39tKoSAcciHBH/TBvrNp6IpknwK3DfpSqYdJ7RyTUttIdGSDUJsKnC7oqG4tOoiXKvxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046881; c=relaxed/simple;
	bh=gA+2LUXLAJ8fqJonprYsGhabmqpdGe1i69PMxy2RBN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqemUkQERmPXr242/olN+08trvbFEt1KP5KMkANhgsSy/N99SdH5zVDdfazDhl1YZuR4rbH22ckX09ktlstlLa8GGVocMLWwY0SQgrsf3WzRck2tFoXP3KehxX9cA9+1Md0YmIMVmiTmTlTQxR90K+gv9We5p6zaEPDMn/hzLVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mp9g9LNr; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2a07fac8aa1so3933095ad.1
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:34:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046879; x=1766651679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6lCL9bZiHUdazzj/bulpFcnv/SeSIpVNFzzbqjvW2fY=;
        b=Mp9g9LNrfLaHmb+gwIFUk+XvIoo7TC2eKnohPSOX0WXsRtqbCb/Z2LikYyWn/bQIaV
         qO/mL/+KiR1Re1MdW2KqqhTKVyhcvpoa99ZkwOZy6u5D18sMX6jVY0QLt0X4wH/vxqxv
         y3xgrk7P9Kuk36JokASXtEx3gLpYs/9ll0kgjX5rezIQxm2g50HKpWbD0FvU5qyFVklP
         s+AQQsISPHA4YS0xSVtWt5Kl/bMD8jqTTS8oxs3VkFecJYWfY7ASFa7rgd8TpAsHKlnT
         gpBu/UJs2w7VQ/OzckKDqsGwnJK1gG/LTmRUk3ah5yyed5A0ldU3pxdpiceJZD1NVdyt
         RTjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046879; x=1766651679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6lCL9bZiHUdazzj/bulpFcnv/SeSIpVNFzzbqjvW2fY=;
        b=HiSEcFFkj4DKXpbbnTOddp57XmijKEZB60aV1aYvRLMT2rPkpywfdNo5RtYgeeTfH8
         qY6ZvKhTtOgzwwczOQOcWuakHZa3ouYw/S87kRCE0SB7S5XL1cEGikWspDWxBspaApqk
         +8YFNeJ8rQbWOk9KW0zwPVnE9DQCtQ5V8RlpBA0bpCCTSCNSovznpV/bv0Dh9FImjxhI
         kZTVEkCAJLGJuQvDr/8RGWf6uEPqZ3+ZjT6YMgIAK+FHk2YW1xewzbrjAPDaDZ43SLMP
         EKvqpdrG5nZxoxEc+IxrOxBLVHH6taGRtqGtN10DhPajtRPxhzKl320+kDrPN8gpUgTJ
         CIjg==
X-Forwarded-Encrypted: i=1; AJvYcCXam7rjRg+tIQ8d8lLhU6sNKaONHlYpH+9tMBBZBgZs+/qRSijiXsAO82iSGbXDAatjz7SOwCmJWA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyA/d8ivKopWT+rUTtcOkWzTsMY/Zu4A04KxYIsBmBdQzKipivO
	dEzPMtSoI88I24lJordAee1OVF9yo06Iy3vRBeMTBb0uZBdeBTfVYaaW
X-Gm-Gg: AY/fxX7ipgs+wDbbkl9ThS2ubUf+B44Z0BnuHtplBtLWvc2dveIAHIr4PHfBqMFW2MK
	V4a0L5tPHKndARGSuc2XVOghmzOLUEQYcT8esj1tYPW80XMkR5Rulyk0OonAoLPrafj/5JTqc6E
	a5JtweVlONbY9mB9DtOfYEc8sFYssjYYCHaJnU+ynWKXpXEpMKIqQZhefGeC6BDcf9FbzkILOMO
	min/0mA1K3VqNjkko81A9g9qnpqgB3cZTlR659bFWcQKG/fGhcFrZG/J7hKTgvr1tYiPit9vom/
	vfNQDn6rvDC+Y986B4vRdJ13rC3i62NhyrHD8C1+4GokBpMCQ6/2CDhizQFZQjP5baHm/9PgtAK
	T1SD253tWUWItG2KDhujGk24IBfSi1D4ZWWSr+E3ZW0OaKBB2Lhocql/iyxS2WvPZcSzJZz6IZI
	8IFwIvQELwWI980a2RKA==
X-Google-Smtp-Source: AGHT+IF+7qtlTcLgfF1g6WQHsj/wpSVoLP0Z0eOQZGNTstS5MKGpEmRra9gvuOSedJFN7jnBtIWoyQ==
X-Received: by 2002:a17:903:120e:b0:295:24ab:fb06 with SMTP id d9443c01a7336-29f23b7620amr207623025ad.22.1766046878769;
        Thu, 18 Dec 2025 00:34:38 -0800 (PST)
Received: from localhost ([2a03:2880:ff:70::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d0888e22sm17647345ad.30.2025.12.18.00.34.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:34:38 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 03/25] io_uring/kbuf: add support for kernel-managed buffer rings
Date: Thu, 18 Dec 2025 00:32:57 -0800
Message-ID: <20251218083319.3485503-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
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
index cbe477db7b86..9dff21783f68 100644
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


