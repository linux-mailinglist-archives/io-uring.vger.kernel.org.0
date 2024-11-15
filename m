Return-Path: <io-uring+bounces-4728-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 117E59CF22E
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 17:54:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C638D28784A
	for <lists+io-uring@lfdr.de>; Fri, 15 Nov 2024 16:54:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 573741D54D6;
	Fri, 15 Nov 2024 16:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XIg5kEHb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DDF1D54E1
	for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731689648; cv=none; b=J+eoyMKV3GyBL1Ed5a2Ly86RriKjoIZn1dE9+G4gSr5I6BYhZNlo4AiSvEOxuL80bxRgTzeUDM9K9EJfU4/8RgAOKbGnIrTYHCfntduFZrkRmcplTAN7AS3YChcncy8vy5xrHLKoBAhrKxN1KvMcnmXS0vZndRMwlRXvOxZYlOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731689648; c=relaxed/simple;
	bh=S7FIFrrAnR1l2CAz1yIA+wGLQfUPglkyF7eAhPGoa+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nSu47yr2Uv5T5ShXTZid8qrmNUv5lQ4uGy0JFKjTcSsP6vndQGZsNDrgncAv3KO0hPArEZOGhSzPj53ZN1iRrHKu2rWDZBOeWDhNa9DE+/hguqnRUjWusbKtXBbISUIaxsfF6Eq5eD3U9WKmTTjG5wsg69aCb2e/nMCb0xa19pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XIg5kEHb; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-382026ba43eso1312345f8f.1
        for <io-uring@vger.kernel.org>; Fri, 15 Nov 2024 08:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731689644; x=1732294444; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LsSdE7BYFAxX84ZY5hZZZzIv0Nnc53OMZhgH+/OhoB8=;
        b=XIg5kEHbdn8A9Oam8/9u2/3ZNkBc3YB2OmM4vxOa+vrkJurPlApsQiPxatro36iMbD
         aMdWjZnmVCHZusfSXzVcewnD4+5gu8wjRDNQPDuvG6kcodXCxy668J5e99Oslh+Uzjpa
         rO75AtPyJaTyac1uWhLeK/5mJhjFfIWGAqQm/SZ6E+RGR2E8qw6MeJyK4BY+PHdv0CLG
         hpl6gCetW6CLDMUOMWtx0hFGUACPM383xoBZiLWEx75qWKJyaf9ipGwPP/vGe99+yl67
         hlGP3Qht/cSC0OM8kLf0GE/qUTo/r3cJkHtFyWbcDm8zkkf284fy9qzi80Zu+VZw7vsb
         PNyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731689644; x=1732294444;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LsSdE7BYFAxX84ZY5hZZZzIv0Nnc53OMZhgH+/OhoB8=;
        b=e9hXEI+cbExK4NMny489565xbzx9zZxkKbuIVzhAlQvJ748o0oEMzo1WmtRvLObZoQ
         6lwKZqI4Wtggv6Xtnqlm1mK/w+/9QiShisRh+/4jw8PPVoJxu9x8N7sc+Xr0IvWERwqK
         7yms7+pU9z82kTtIwKI+9/SeSU7l2vOStTrx5x0T0uQUqiDuGcPpnI8Gu0bHYvDxFPhI
         I6iAAxnd/ZUaI0qK9C1IJvIHSw0uzFbXtuvJ2v+JYItrahrgTZ/0D2Y4k9CXOHK0Zo35
         I1wagDGh40vfSFR70JJrnQ/GYjZVAZ2R6zP76JdZYd5wtdQv8wKSGRBAPz7Hu8YkcNdU
         LNtw==
X-Gm-Message-State: AOJu0Yy9jrXcczLWrB2cP+vGVPGdAF1YQrSGzXHHVwhW1yHNT2M6VyTH
	L0F2kBNEfWuC9CNM4yueY6H45uPLkZdifEWHd/eSg3DixISb6suscrDfoQ==
X-Google-Smtp-Source: AGHT+IH5lOm4cYkIgL7fjOqZ/k9rlVzFE4J4TlIszv3K8JfzdkW/lY2o6Q6ddzEJNi23oha4jMe+jA==
X-Received: by 2002:a05:6000:1868:b0:37d:3735:8fe7 with SMTP id ffacd0b85a97d-38225a295b5mr3170429f8f.32.1731689643845;
        Fri, 15 Nov 2024 08:54:03 -0800 (PST)
Received: from 127.0.0.1localhost ([148.252.132.111])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3821ae2f651sm5011895f8f.87.2024.11.15.08.54.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Nov 2024 08:54:02 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 4/6] io_uring: introduce concept of memory regions
Date: Fri, 15 Nov 2024 16:54:41 +0000
Message-ID: <0e6fe25818dfbaebd1bd90b870a6cac503fe1a24.1731689588.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1731689588.git.asml.silence@gmail.com>
References: <cover.1731689588.git.asml.silence@gmail.com>
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
 include/linux/io_uring_types.h |  6 +++
 include/uapi/linux/io_uring.h  | 14 +++++++
 io_uring/memmap.c              | 67 ++++++++++++++++++++++++++++++++++
 io_uring/memmap.h              | 14 +++++++
 4 files changed, 101 insertions(+)

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
index 6ab59c60dfd0..bbd9569a0120 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -12,6 +12,7 @@
 
 #include "memmap.h"
 #include "kbuf.h"
+#include "rsrc.h"
 
 static void *io_mem_alloc_compound(struct page **pages, int nr_pages,
 				   size_t size, gfp_t gfp)
@@ -194,6 +195,72 @@ void *__io_uaddr_map(struct page ***pages, unsigned short *npages,
 	return ERR_PTR(-ENOMEM);
 }
 
+void io_free_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr)
+{
+	if (mr->pages) {
+		unpin_user_pages(mr->pages, mr->nr_pages);
+		kvfree(mr->pages);
+	}
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


