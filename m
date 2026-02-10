Return-Path: <io-uring+bounces-12117-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MAcYBpZ8imk4LAAAu9opvQ
	(envelope-from <io-uring+bounces-12117-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:32:22 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id AAF21115A13
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 01:32:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7C1FC301C155
	for <lists+io-uring@lfdr.de>; Tue, 10 Feb 2026 00:31:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16E59186E58;
	Tue, 10 Feb 2026 00:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nFzeKKqT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBB31C8603
	for <io-uring@vger.kernel.org>; Tue, 10 Feb 2026 00:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770683506; cv=none; b=P6i0qSId2KNTBFJCqChV8SWHvYSKnauz0Y1B50ILXCA/fYJOe+qHlxNYqx+CdBzDAnoj1Eh+f0COLMUg/5JkweF51X6SEX5JnreDff0Z2AhCf72oqrmYD+pkKIph4BzEQM5JL3Ycdhw1PdXf9NrSYekRy8Rm6YzfPDeJGB+8y18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770683506; c=relaxed/simple;
	bh=T9UiWkNKG3cAE/F1exDvFIy1P3oxtPbbJuw6LQyFBsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZSyBiD5xsi9Gh8yCDfHKevMrUv1ZmQMoQGRv/X4CH0mHj6Q62jtyDwfvMovcgc9+HTJdxCyNl/NLXFZ+1glxCU48CZUu8ePC4pbqP2zoayHAHzlJc/+9B8wPwRG9rBdwj2OqWugkbzj3GIAtxImlLcjChIy3uy4ZJ94y9DR34c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nFzeKKqT; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a79ded11a2so1573455ad.3
        for <io-uring@vger.kernel.org>; Mon, 09 Feb 2026 16:31:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770683504; x=1771288304; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vm0HPm6f+F7Sy0UqSXcD0A8qUU3GcvmG8JKd9f8lPOg=;
        b=nFzeKKqT881FVx//q8cwkW9z991t1hkv1ItI+2zwYyzKJPhQzfRMM7kLcsCiV5OSHe
         4bdn1Gj13ZTvUe+sxwWbVJhsCh6UUzkHlyxmiQriwLHKTLzXXfdz9UIDpWXkQHC6nh1Z
         XKCeFQqXNiZ5OzkGwe4unooWPx7Tgaig6i3eNduLOLocRx/lpwIB+JyUDQMUz0E3VtXY
         a3CxCO+FptkLvDIyM9oaOFeXryPF8CZT4TrGOHFmVhM+hTInrtHu1g82RLgOlVRZ4mVi
         DK+1fRcwERXEdIeN6yzktCkfVkJEcAkMgiFqr4TeCNwzFZQuVNu/xoXvJ0DNRGtdt+yw
         LmFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770683504; x=1771288304;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vm0HPm6f+F7Sy0UqSXcD0A8qUU3GcvmG8JKd9f8lPOg=;
        b=mXvCbELGmWWUIgqCfC2Zh1BlyjK/hMnA6dz+qhR1hihfvfiNWfFp2zsPrmF/3dNl13
         x/BVdn0oCHfuzIGsFyslfNWzh/FHCotk9GkTc6mgw+FwWHba//1PzmkRhWMsePFuBf7X
         5kPDmp3nQLXCZKUA0nR/fxfS4UC1ebJrhqlriKY0oVyk//waIG22RyuFdYXy00z52vTg
         o8SspthKhdpjyIpXXmwg1vNkB2H6QS6vvjwvnQA4xN/rGIYggkn24bsNVa+3pZzilN1J
         cwIZcAwAJEu+hR8mbUA9vlvMD07Y+7CTNa3BNQjnzH5SkCvYb6EW9JTVZpqY2Npv0XbG
         cRnQ==
X-Forwarded-Encrypted: i=1; AJvYcCVw5A04glbDjpfDe6xtEIZXzEHmWNfRj89Jo8kzTXll/DClhVnEG0fr2ptNF1aki3Fiq0cZnXlcMg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd40WU0a82yC+EtbWWAmfRtE8hgtw/h1cxMgVhW7BVxW/lsNOr
	kJ3r8ec/kElnlCBfZ22EstvIRSW67ZAEnu3S8dXHIRb0T6Gv0S7MBuZc
X-Gm-Gg: AZuq6aJ+Z6YLL6Px4lJf94lixBvTrJDWDbpTAZPtVWCRHT8A9J/TVZFk5SwTnR1KNHz
	6NkCV53MPVWe5+Ds8itbhfUWhTTHvlf5JWMuRtRTdwlKY3JJvvSKtkbZrh6vfhVrmu9GMtBfcMt
	EG93qZX2qVaJNsDvHJouD4AbT/Kav3U/Gmf3dR9OdDn2ALa29UrkxGDWth5RyNqpyE3kPLXFFG/
	WSmmUL1ILCxzn6AjRipQCNsBrSnHSaHRR+/s4pKF07pChhqPnxTLujC5gARN/y/OwOUSANuHugm
	vkLBDklIdtVL9nkHreDEB8BKb0zRRpv1Qk7exrAxjHS2HLYn97Ag0UpLna/KvmHZbrRpgqfQx8x
	0FE9IMrlzCRvSe/JTbqiFyJ2yxbUQV4vM8Qv8YhkLAvCekL7z61RMAjJuu0xwxRlVgkJDee/Ltp
	icpHpm8kU6BM+IzVbbdg==
X-Received: by 2002:a17:902:d4c2:b0:2aa:e6c1:cea1 with SMTP id d9443c01a7336-2aae6c1d148mr56779845ad.17.1770683503859;
        Mon, 09 Feb 2026 16:31:43 -0800 (PST)
Received: from localhost ([2a03:2880:ff:71::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a951a64ebesm121250285ad.2.2026.02.09.16.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 16:31:43 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	krisman@suse.de,
	bernd@bsbernd.com,
	hch@infradead.org,
	asml.silence@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 03/11] io_uring/kbuf: add support for kernel-managed buffer rings
Date: Mon,  9 Feb 2026 16:28:44 -0800
Message-ID: <20260210002852.1394504-4-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260210002852.1394504-1-joannelkoong@gmail.com>
References: <20260210002852.1394504-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[purestorage.com,suse.de,bsbernd.com,infradead.org,gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12117-lists,io-uring=lfdr.de];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_NONE(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: AAF21115A13
X-Rspamd-Action: no action

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
 io_uring/kbuf.c               |  81 ++++++++++++++++++++++++-
 io_uring/kbuf.h               |   7 ++-
 io_uring/memmap.c             | 111 ++++++++++++++++++++++++++++++++++
 io_uring/memmap.h             |   4 ++
 io_uring/register.c           |   7 +++
 6 files changed, 219 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index fc473af6feb4..a0889c1744bd 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -715,6 +715,10 @@ enum io_uring_register_op {
 	/* register bpf filtering programs */
 	IORING_REGISTER_BPF_FILTER		= 37,
 
+	/* register/unregister kernel-managed ring buffer group */
+	IORING_REGISTER_KMBUF_RING		= 38,
+	IORING_UNREGISTER_KMBUF_RING		= 39,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -891,9 +895,16 @@ enum io_uring_register_pbuf_ring_flags {
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
index aa9b70b72db4..9bc36451d083 100644
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
@@ -779,3 +782,77 @@ struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
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
+	bl->flags |= IOBL_KERNEL_MANAGED;
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
+	ret = io_copy_and_validate_buf_reg(arg, &reg, 0);
+	if (ret)
+		return ret;
+
+	if (!reg.buf_size || !PAGE_ALIGNED(reg.buf_size))
+		return -EINVAL;
+
+	bl = io_alloc_new_buffer_list(ctx, &reg);
+	if (IS_ERR(bl))
+		return PTR_ERR(bl);
+
+	ret = io_setup_kmbuf_ring(ctx, bl, &reg);
+	if (ret) {
+		kfree(bl);
+		return ret;
+	}
+
+	ret = io_buffer_add_list(ctx, bl, reg.bgid);
+	if (ret)
+		io_put_bl(ctx, bl);
+
+	return ret;
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
index 89f56609e50a..8d37e93c0433 100644
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
diff --git a/io_uring/register.c b/io_uring/register.c
index 0882cb34f851..2db8daaf8fde 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -837,7 +837,14 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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


