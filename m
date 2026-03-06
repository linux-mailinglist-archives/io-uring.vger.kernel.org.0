Return-Path: <io-uring+bounces-12566-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id IEFGDdogqmn2LgEAu9opvQ
	(envelope-from <io-uring+bounces-12566-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 01:33:30 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 907CA219D63
	for <lists+io-uring@lfdr.de>; Fri, 06 Mar 2026 01:33:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id ECE91303E4AB
	for <lists+io-uring@lfdr.de>; Fri,  6 Mar 2026 00:33:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6A7F2BE7D1;
	Fri,  6 Mar 2026 00:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LJeZOtWz"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396742BEFEE
	for <io-uring@vger.kernel.org>; Fri,  6 Mar 2026 00:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772757187; cv=none; b=TTyZN4iPePesvwEiDwUAQjiVjgT1TYvqSEpUyObjiOIjd96//Kie/Tprj6G+tz9FogfxEydFP5cHiEUd/6deYe6g+YRQouU6yu6yYr8DpUrl6dahoO5d0bhU8nF0mfxgiYVU927Icb/J8oFvnBfAzMNes2VDHYh/oOEpbEpXTQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772757187; c=relaxed/simple;
	bh=stN532IY5ULqylRJg7iCzkM9bJ4LWQ1fCH+yj3TJt+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H23wVGOmNyPAHRoSuxJLZJvwcZahE22SArB9ZUus+LxlVfmnCQzmQWMpVJiWZQ856gk87hxBO6Qm891R3Sy/KRVPs0VcPNh4T9HiyiEITFEEGNf1rlobakeRzaUjLmra8N3vFqxfsTQlHdVvrwQEQRRD2/JEZVvdjd1QuJTsxk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LJeZOtWz; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3567e2b4159so4698551a91.0
        for <io-uring@vger.kernel.org>; Thu, 05 Mar 2026 16:33:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772757185; x=1773361985; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0zsNt2TVrv+lQZ/5o8ML1KQOYAQD1V68hUEgoco+Nb0=;
        b=LJeZOtWzCGumSKkkA2SDzzDuSalwGb0CVyOfT295HzEOR6/cm46U+KNACKzPq5T4Zd
         DOH8gi0nYPCbqh2voCRuZ0JYaEBaT0kUM9rUvEebmV1gVnAobG0/9e06PQR33wyBgDZr
         ZWka6s65qXliA6QDMiYUrfFQIt0XO2iZieYy7agiLVCA6V8HHOE3Sj4R9fsEGCQOWHQx
         lEowx+bKxVISn+iae2O7PTSlpGPsTkPICR5Qqz98Tau/gpj60y+vma4QGAlEm8vhhaBL
         a9qwcXLGCZUqo+n4cf+grhz5E9Wz6iMT6kgL0Bq/qA/q9ZwWR/BKR/SLA9qQpp+MqKgE
         uiYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772757185; x=1773361985;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0zsNt2TVrv+lQZ/5o8ML1KQOYAQD1V68hUEgoco+Nb0=;
        b=UKmN5Y9DgD0JkEEkc/r+NUcKNWtKL6VR5ZjFFMfy5XIrE8q13r+ppDzcNxfSUcavqt
         TAL++VmLMkjUYl+hKFTeU8eVNmSbwMcKZyKZPSQhnLUh28zXkz8weIzG8PoFXKwvTPDl
         JRnHH4eH5fjTfKhxY7YuoocKOAXaiGB7j/QObq/9RKdWEBGH7tkw7kUstfKEYEzsYoyz
         ZTDPCxtWmNyTYDUJbbMmoU69uC5sy91+zkJvSXHHBxr4uaFFu1GFbZk2U9dH4FN3D1p2
         /44aYNUxE8bqbXdwMlS7PBOp+Mm4HR0lj2sdxrUPJJMbyiIIPMMkCKwYrOWx8WAfjEgH
         3eIg==
X-Forwarded-Encrypted: i=1; AJvYcCXzCwOhABWGW5mrc0sIjbUbZvRT99b3RToAgfVw+ZOFiG/kkdtE/UhUmnY+sDAr+TeMchVu3a+Zgw==@vger.kernel.org
X-Gm-Message-State: AOJu0Ywn2GtFH0COxKLBWlHq2jM1FM+0BtF11f+N6dnwsBIqYbnrXkmc
	6azLpJj1uqql7aniM/Euxi1TaY/VbXbCj/UG12jrDvX2JgkX6giW1oaK
X-Gm-Gg: ATEYQzzjuW03nU1UKKWFsfzW+ovufG+FkspQUKaeUwt/ulLa54T3wn7kLlom6Ycx+xz
	B/SkPDKi1ZJEXTztQKK0I0YTKPlWTLIJBvpPNnZ10BlU3Mtt04m3CQuXYzn22i3GifjEu8PAgoB
	cWujpteDCiU0kNSgcjTubNK/DBpijioDMU7DSzLnpSPwXJRTi5C49I/Sye0Pd0kTryQv5p/uhSn
	JhwKzZr6fz7VSViTFyvezpNMSY0G7dCswcCYDCvnqvPiGqhGK2uCRibpKhAUB9Sf7Qm6fY/ZQtB
	8siFd6B1DRpKweE/d2bjWhmRp6GjUiJ7HuSQmUpD9JfFiilx4tC7/43QDNfjXuR6tWqxDyhVbEN
	yjhozQ28ALKlOsxnmLCowCAeeCZ5UtwwMqj8mb7t7LUxsLOVj/0PvzXuI6Wwv/fm2YR8d2wAK6Q
	sg9F7KmiF6wHuHoGXZ
X-Received: by 2002:a17:90b:2f8f:b0:358:dc04:a595 with SMTP id 98e67ed59e1d1-359be32bba5mr245918a91.21.1772757185413;
        Thu, 05 Mar 2026 16:33:05 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359b2d6f21fsm3994968a91.16.2026.03.05.16.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 16:33:05 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: hch@infradead.org,
	asml.silence@gmail.com,
	bernd@bsbernd.com,
	csander@purestorage.com,
	krisman@suse.de,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH v3 1/8] io_uring/kbuf: add support for kernel-managed buffer rings
Date: Thu,  5 Mar 2026 16:32:17 -0800
Message-ID: <20260306003224.3620942-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260306003224.3620942-1-joannelkoong@gmail.com>
References: <20260306003224.3620942-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 907CA219D63
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FROM_HAS_DN(0.00)[];
	TAGGED_FROM(0.00)[bounces-12566-lists,io-uring=lfdr.de];
	TO_DN_NONE(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[infradead.org,gmail.com,bsbernd.com,purestorage.com,suse.de,vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Action: no action

Add support for kernel-managed buffer rings (kmbuf rings), which allow
the kernel to allocate and manage the backing buffers for a buffer
ring, rather than requiring the application to provide and manage them.

Internally, the IOBL_KERNEL_MANAGED flag marks buffer lists as
kernel-managed for appropriate handling in the I/O path.

At the uapi level, kernel-managed buffer rings are created through the
pbuf interface with the IOU_PBUF_RING_KERNEL_MANAGED flag set. The
io_uring_buf_reg struct is modified to allow taking in a buf_size
instead of a ring_addr. To create a kernel-managed buffer ring, the
caller must set the IOU_PBUF_RING_MMAP flag as well to indicate that the
kernel will allocate the memory for the ring. When the caller mmaps
the ring, they will get back a virtual mapping to the buffer memory.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/uapi/linux/io_uring.h |  16 ++++-
 io_uring/kbuf.c               |  97 ++++++++++++++++++++++++-----
 io_uring/kbuf.h               |   6 +-
 io_uring/memmap.c             | 111 ++++++++++++++++++++++++++++++++++
 io_uring/memmap.h             |   4 ++
 5 files changed, 215 insertions(+), 19 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 23eaeb1fc8d9..81dddf0ba0eb 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -892,15 +892,29 @@ struct io_uring_buf_ring {
  *			use of it will consume only as much as it needs. This
  *			requires that both the kernel and application keep
  *			track of where the current read/recv index is at.
+ * IOU_PBUF_RING_KERNEL_MANAGED: If set, kernel allocates and manages the memory
+ *                      for the ring and its buffers. The application must set
+ *                      the buffer size through reg->buf_size and the size must
+ *                      be page-aligned. When the application subsequently calls
+ *                      mmap(2) with
+ *                      IORING_OFF_PBUF_RING | (bgid << IORING_OFF_PBUF_SHIFT),
+ *                      the virtual mapping returned is a contiguous mapping of
+ *                      the buffers. If set, IOU_PBUF_RING_MMAP must be set as
+ *                      well.
  */
 enum io_uring_register_pbuf_ring_flags {
 	IOU_PBUF_RING_MMAP	= 1,
 	IOU_PBUF_RING_INC	= 2,
+	IOU_PBUF_RING_KERNEL_MANAGED = 4,
 };
 
 /* argument for IORING_(UN)REGISTER_PBUF_RING */
 struct io_uring_buf_reg {
-	__u64	ring_addr;
+	union {
+		__u64	ring_addr;
+		/* used if reg->flags & IOU_PBUF_RING_KERNEL_MANAGED */
+		__u32   buf_size;
+	};
 	__u32	ring_entries;
 	__u16	bgid;
 	__u16	flags;
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 2ffa95b1c601..0e42c8f602e1 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -427,10 +427,13 @@ static int io_remove_buffers_legacy(struct io_ring_ctx *ctx,
 
 static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
-	if (bl->flags & IOBL_BUF_RING)
+	if (bl->flags & IOBL_BUF_RING) {
 		io_free_region(ctx->user, &bl->region);
-	else
+		if (bl->flags & IOBL_KERNEL_MANAGED)
+			kfree(bl->buf_ring);
+	} else {
 		io_remove_buffers_legacy(ctx, bl, -1U);
+	}
 
 	kfree(bl);
 }
@@ -596,14 +599,53 @@ int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_COMPLETE;
 }
 
+static int io_setup_kmbuf_ring(struct io_ring_ctx *ctx,
+			       struct io_buffer_list *bl,
+			       const struct io_uring_buf_reg *reg)
+{
+	struct io_uring_buf_ring *ring;
+	unsigned long ring_size;
+	void *buf_region;
+	unsigned int i;
+	int ret;
+
+	/* allocate pages for the ring structure */
+	ring_size = flex_array_size(ring, bufs, reg->ring_entries);
+	ring = kzalloc(ring_size, GFP_KERNEL_ACCOUNT);
+	if (!ring)
+		return -ENOMEM;
+
+	ret = io_create_region_multi_buf(ctx, &bl->region, reg->ring_entries,
+					 reg->buf_size);
+	if (ret) {
+		kfree(ring);
+		return ret;
+	}
+
+	/* initialize ring buf entries to point to the buffers */
+	buf_region = bl->region.ptr;
+	for (i = 0; i < reg->ring_entries; i++) {
+		struct io_uring_buf *buf = &ring->bufs[i];
+
+		buf->addr = (u64)(uintptr_t)buf_region;
+		buf->len = reg->buf_size;
+		buf->bid = i;
+
+		buf_region += reg->buf_size;
+	}
+	ring->tail = reg->ring_entries;
+
+	bl->buf_ring = ring;
+	bl->flags |= IOBL_KERNEL_MANAGED;
+
+	return 0;
+}
+
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_uring_buf_reg reg;
 	struct io_buffer_list *bl;
-	struct io_uring_region_desc rd;
 	struct io_uring_buf_ring *br;
-	unsigned long mmap_offset;
-	unsigned long ring_size;
 	int ret;
 
 	lockdep_assert_held(&ctx->uring_lock);
@@ -612,7 +654,8 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		return -EFAULT;
 	if (!mem_is_zero(reg.resv, sizeof(reg.resv)))
 		return -EINVAL;
-	if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
+	if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC |
+			  IOU_PBUF_RING_KERNEL_MANAGED))
 		return -EINVAL;
 	if (!is_power_of_2(reg.ring_entries))
 		return -EINVAL;
@@ -620,6 +663,16 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (reg.ring_entries >= 65536)
 		return -EINVAL;
 
+	if (reg.flags & IOU_PBUF_RING_KERNEL_MANAGED) {
+		if (!(reg.flags & IOU_PBUF_RING_MMAP))
+			return -EINVAL;
+		/* not yet supported */
+		if (reg.flags & IOU_PBUF_RING_INC)
+			return -EINVAL;
+		if (!reg.buf_size || !PAGE_ALIGNED(reg.buf_size))
+			return -EINVAL;
+	}
+
 	bl = io_buffer_get_list(ctx, reg.bgid);
 	if (bl) {
 		/* if mapped buffer ring OR classic exists, don't allow */
@@ -632,19 +685,30 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (!bl)
 		return -ENOMEM;
 
-	mmap_offset = (unsigned long)reg.bgid << IORING_OFF_PBUF_SHIFT;
-	ring_size = flex_array_size(br, bufs, reg.ring_entries);
+	if (!(reg.flags & IOU_PBUF_RING_KERNEL_MANAGED)) {
+		struct io_uring_region_desc rd;
+		unsigned long mmap_offset;
+		unsigned long ring_size;
+
+		mmap_offset = (unsigned long)reg.bgid << IORING_OFF_PBUF_SHIFT;
+		ring_size = flex_array_size(br, bufs, reg.ring_entries);
 
-	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(ring_size);
-	if (!(reg.flags & IOU_PBUF_RING_MMAP)) {
-		rd.user_addr = reg.ring_addr;
-		rd.flags |= IORING_MEM_REGION_TYPE_USER;
+		memset(&rd, 0, sizeof(rd));
+		rd.size = PAGE_ALIGN(ring_size);
+		if (!(reg.flags & IOU_PBUF_RING_MMAP)) {
+			rd.user_addr = reg.ring_addr;
+			rd.flags |= IORING_MEM_REGION_TYPE_USER;
+		}
+		ret = io_create_region(ctx, &bl->region, &rd, mmap_offset);
+		if (!ret)
+			bl->buf_ring = io_region_get_ptr(&bl->region);
+	} else {
+		ret = io_setup_kmbuf_ring(ctx, bl, &reg);
 	}
-	ret = io_create_region(ctx, &bl->region, &rd, mmap_offset);
 	if (ret)
 		goto fail;
-	br = io_region_get_ptr(&bl->region);
+
+	br = bl->buf_ring;
 
 #ifdef SHM_COLOUR
 	/*
@@ -666,7 +730,6 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	bl->nr_entries = reg.ring_entries;
 	bl->mask = reg.ring_entries - 1;
 	bl->flags |= IOBL_BUF_RING;
-	bl->buf_ring = br;
 	if (reg.flags & IOU_PBUF_RING_INC)
 		bl->flags |= IOBL_INC;
 	ret = io_buffer_add_list(ctx, bl, reg.bgid);
@@ -674,6 +737,8 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		return 0;
 fail:
 	io_free_region(ctx->user, &bl->region);
+	if (bl->flags & IOBL_KERNEL_MANAGED)
+		kfree(bl->buf_ring);
 	kfree(bl);
 	return ret;
 }
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index bf15e26520d3..38dd5fe6716e 100644
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
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index e6958968975a..4979cbbfa27c 100644
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
+	gfp_t gfp = GFP_USER | __GFP_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
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
@@ -181,6 +255,43 @@ static int io_region_allocate_pages(struct io_mapped_region *mr,
 	return 0;
 }
 
+int io_create_region_multi_buf(struct io_ring_ctx *ctx,
+			       struct io_mapped_region *mr,
+			       unsigned int nr_bufs, unsigned int buf_size)
+{
+	unsigned int nr_pages;
+	int ret;
+
+	if (WARN_ON_ONCE(mr->pages || mr->ptr || mr->nr_pages))
+		return -EFAULT;
+
+	if (WARN_ON_ONCE(!nr_bufs || !buf_size || !PAGE_ALIGNED(buf_size)))
+		return -EINVAL;
+
+	if (check_mul_overflow(buf_size >> PAGE_SHIFT, nr_bufs, &nr_pages))
+		return -EINVAL;
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
index f4cfbb6b9a1f..3aa1167462ae 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -22,6 +22,10 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg,
 		     unsigned long mmap_offset);
 
+int io_create_region_multi_buf(struct io_ring_ctx *ctx,
+			       struct io_mapped_region *mr,
+			       unsigned int nr_bufs, unsigned int buf_size);
+
 static inline void *io_region_get_ptr(struct io_mapped_region *mr)
 {
 	return mr->ptr;
-- 
2.47.3


