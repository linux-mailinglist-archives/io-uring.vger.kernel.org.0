Return-Path: <io-uring+bounces-1264-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6115E88EF19
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 20:19:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 08E6429C2A0
	for <lists+io-uring@lfdr.de>; Wed, 27 Mar 2024 19:19:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EA8B150999;
	Wed, 27 Mar 2024 19:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Vkufz5Gy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4957152167
	for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 19:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711567196; cv=none; b=iUhmOVyEKSibG1/Hp3Z/ntP5zSfFOy0tkRnkn7jGKIqgyWhZpFLieGEK5DtmWb6i43J63UQy1ZmKRXR2VMZQ1XwWOn2wdcglVtUV4bKdeFy/fDZkNe2m4CPR9zZLpGHNXXZMLiegId5eMy0wQePtkSElqdUYjP4jSsdmgtrBNQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711567196; c=relaxed/simple;
	bh=qumXygsVJxKhTf+P9KS4IvjYsrW7eBf6PGZhXbAIdSI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/M3Z/PUnGE94NQzn3wYqgZ4c9Oz/L9j5veyGoYSaL7HlLfMwfcmc/GN2nbedI4a0a9XA0IxsMxdC+Z05aVVeQ/eku5Ne9DqzGvFfeduTo+oA23AFKQEtJ72rfP/xhsOIB8WXab+LHVjAMlvAU27eUrw+1Zbbe3uqaFNYZsBtj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Vkufz5Gy; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-6ea729f2e38so54228b3a.1
        for <io-uring@vger.kernel.org>; Wed, 27 Mar 2024 12:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711567192; x=1712171992; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Idr8nNiULEqhe+F7HvoO4bBSwsnHb0chrJlG9XWOXcQ=;
        b=Vkufz5GyCMJcQc7jOvcHbYlc3lICXnDBb7G9s8gayKTsD+yzcMD0Lc18jS0Qc+3+2C
         7XufcEHKGWDOe2Xm6FWjUhuEGZgBP5dOH2mtu2+h9U4KZXN3X+kbMfJnpwSkxMgPMUkm
         zqetikbmNoriOR7LumiXGrCNnQXV4SabtIRQxXghawJzA9cnidPqk16NsdNs1DZfdnvO
         nI+A/la1SR2As8BUtf6fe4jnRc8MyRQJMQYx52u6zOTBuYKf8ke3+LKJSO3BWqRqSjpz
         uFa9KcZ5rHZTSaGBabJFedE0k++AB8Hf4QWqaM4ROzd0IiHRUosssMJ6Y0Y00mLnC2Uo
         4tug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711567192; x=1712171992;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Idr8nNiULEqhe+F7HvoO4bBSwsnHb0chrJlG9XWOXcQ=;
        b=phl47oHBhfpKLXnWH+C6zBSYs0UKtWzxKIjaehffMarCq7x+hO8aOTuUuem5SRXvMY
         MvwB6eoc7b5u+TXqoxzLMbkRJhkg6AKkzz+ww6Z6SjsQOlXDs81FzyV6Uqt4LAA06zD/
         WLSCfB3tGb0dj+k548Mn+nV2qHbdsS6pfXcEqdKPJPSxFDYmHuJct+tSrvSJ5saYk12+
         9GqdT+jZMypPhqz964XbhWbQ0HQkJjF5uJkFdXvuhNDc/hvNmI3Es37nRG6mh1XIa8/N
         2ZVPuaB545ngaBOm6By3MsSq9mOii7ryQUP0qKRnfX2ZllDjdmv5xXExJpI3o2TYfmNi
         lJDQ==
X-Gm-Message-State: AOJu0YxRuYeglbbr007dmG36+MZ6ktPAKQ6EX7Mnlcdlo91pk3ynkM5I
	YhodRN1u0hTLeQGktmvjIkajoH4vix9/kJizjDW4sqfOaaJyO4OYhjEp3mXxSq6Blt9vPpEQ27l
	3
X-Google-Smtp-Source: AGHT+IGX1iFPvZPftF/HlMieTtWp16JXUDDiJberAZ5KhmkbucT67ji5bIQRz1YCmN7aUtwoH9bD/Q==
X-Received: by 2002:a05:6a21:7881:b0:1a3:6c0a:4f9b with SMTP id bf1-20020a056a21788100b001a36c0a4f9bmr1113282pzc.2.1711567192103;
        Wed, 27 Mar 2024 12:19:52 -0700 (PDT)
Received: from m2max.thefacebook.com ([2620:10d:c090:600::1:bb1e])
        by smtp.gmail.com with ESMTPSA id n2-20020aa79842000000b006e6c3753786sm8278882pfq.41.2024.03.27.12.19.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Mar 2024 12:19:50 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/10] io_uring/kbuf: use vm_insert_pages() for mmap'ed pbuf ring
Date: Wed, 27 Mar 2024 13:13:44 -0600
Message-ID: <20240327191933.607220-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240327191933.607220-1-axboe@kernel.dk>
References: <20240327191933.607220-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than use remap_pfn_range() for this and manually free later,
switch to using vm_insert_page() and have it Just Work.

This requires a bit of effort on the mmap lookup side, as the ctx
uring_lock isn't held, which  otherwise protects buffer_lists from being
torn down, and it's not safe to grab from mmap context that would
introduce an ABBA deadlock between the mmap lock and the ctx uring_lock.
Instead, lookup the buffer_list under RCU, as the the list is RCU freed
already. Use the existing reference count to determine whether it's
possible to safely grab a reference to it (eg if it's not zero already),
and drop that reference when done with the mapping. If the mmap
reference is the last one, the buffer_list and the associated memory can
go away, since the vma insertion has references to the inserted pages at
that point.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   3 -
 io_uring/io_uring.c            |  69 +++++--------
 io_uring/io_uring.h            |   6 +-
 io_uring/kbuf.c                | 171 +++++++++++----------------------
 io_uring/kbuf.h                |   7 +-
 5 files changed, 85 insertions(+), 171 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 8c64c303dee8..aeb4639785b5 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -372,9 +372,6 @@ struct io_ring_ctx {
 
 	struct list_head	io_buffers_cache;
 
-	/* deferred free list, protected by ->uring_lock */
-	struct hlist_head	io_buf_list;
-
 	/* Keep this last, we don't need it for the fast path */
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 31b686c5cb23..ff7276699a2c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -303,7 +303,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
-	INIT_HLIST_HEAD(&ctx->io_buf_list);
 	ret = io_alloc_cache_init(&ctx->rsrc_node_cache, IO_NODE_ALLOC_CACHE_MAX,
 			    sizeof(struct io_rsrc_node));
 	ret |= io_alloc_cache_init(&ctx->apoll_cache, IO_POLL_ALLOC_CACHE_MAX,
@@ -2599,12 +2598,12 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
 
-static void io_pages_unmap(void *ptr, struct page ***pages,
-			   unsigned short *npages)
+void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
+		    bool put_pages)
 {
 	bool do_vunmap = false;
 
-	if (*npages) {
+	if (put_pages && *npages) {
 		struct page **to_free = *pages;
 		int i;
 
@@ -2620,14 +2619,6 @@ static void io_pages_unmap(void *ptr, struct page ***pages,
 	*npages = 0;
 }
 
-void io_mem_free(void *ptr)
-{
-	if (!ptr)
-		return;
-
-	folio_put(virt_to_folio(ptr));
-}
-
 static void io_pages_free(struct page ***pages, int npages)
 {
 	struct page **page_array = *pages;
@@ -2721,8 +2712,10 @@ static void *io_sqes_map(struct io_ring_ctx *ctx, unsigned long uaddr,
 static void io_rings_free(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP)) {
-		io_pages_unmap(ctx->rings, &ctx->ring_pages, &ctx->n_ring_pages);
-		io_pages_unmap(ctx->sq_sqes, &ctx->sqe_pages, &ctx->n_sqe_pages);
+		io_pages_unmap(ctx->rings, &ctx->ring_pages, &ctx->n_ring_pages,
+				true);
+		io_pages_unmap(ctx->sq_sqes, &ctx->sqe_pages, &ctx->n_sqe_pages,
+				true);
 	} else {
 		io_pages_free(&ctx->ring_pages, ctx->n_ring_pages);
 		ctx->n_ring_pages = 0;
@@ -2783,8 +2776,8 @@ static void *io_mem_alloc_single(struct page **pages, int nr_pages, size_t size,
 	return ERR_PTR(-ENOMEM);
 }
 
-static void *io_pages_map(struct page ***out_pages, unsigned short *npages,
-			  size_t size)
+void *io_pages_map(struct page ***out_pages, unsigned short *npages,
+		   size_t size)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN;
 	struct page **pages;
@@ -2814,17 +2807,6 @@ static void *io_pages_map(struct page ***out_pages, unsigned short *npages,
 	return ERR_PTR(-ENOMEM);
 }
 
-void *io_mem_alloc(size_t size)
-{
-	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
-	void *ret;
-
-	ret = (void *) __get_free_pages(gfp, get_order(size));
-	if (ret)
-		return ret;
-	return ERR_PTR(-ENOMEM);
-}
-
 static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries,
 				unsigned int cq_entries, size_t *sq_offset)
 {
@@ -2921,7 +2903,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		ctx->mm_account = NULL;
 	}
 	io_rings_free(ctx);
-	io_kbuf_mmap_list_free(ctx);
 
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
@@ -3391,10 +3372,8 @@ static void *io_uring_validate_mmap_request(struct file *file,
 {
 	struct io_ring_ctx *ctx = file->private_data;
 	loff_t offset = pgoff << PAGE_SHIFT;
-	struct page *page;
-	void *ptr;
 
-	switch (offset & IORING_OFF_MMAP_MASK) {
+	switch ((pgoff << PAGE_SHIFT) & IORING_OFF_MMAP_MASK) {
 	case IORING_OFF_SQ_RING:
 	case IORING_OFF_CQ_RING:
 		/* Don't allow mmap if the ring was setup without it */
@@ -3407,25 +3386,21 @@ static void *io_uring_validate_mmap_request(struct file *file,
 			return ERR_PTR(-EINVAL);
 		return ctx->sq_sqes;
 	case IORING_OFF_PBUF_RING: {
+		struct io_buffer_list *bl;
 		unsigned int bgid;
+		void *ret;
 
 		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
-		rcu_read_lock();
-		ptr = io_pbuf_get_address(ctx, bgid);
-		rcu_read_unlock();
-		if (!ptr)
-			return ERR_PTR(-EINVAL);
-		break;
+		bl = io_pbuf_get_bl(ctx, bgid);
+		if (IS_ERR(bl))
+			return bl;
+		ret = bl->buf_ring;
+		io_put_bl(ctx, bl);
+		return ret;
 		}
-	default:
-		return ERR_PTR(-EINVAL);
 	}
 
-	page = virt_to_head_page(ptr);
-	if (sz > page_size(page))
-		return ERR_PTR(-EINVAL);
-
-	return ptr;
+	return ERR_PTR(-EINVAL);
 }
 
 int io_uring_mmap_pages(struct io_ring_ctx *ctx, struct vm_area_struct *vma,
@@ -3444,7 +3419,6 @@ static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	struct io_ring_ctx *ctx = file->private_data;
 	size_t sz = vma->vm_end - vma->vm_start;
 	long offset = vma->vm_pgoff << PAGE_SHIFT;
-	unsigned long pfn;
 	void *ptr;
 
 	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff, sz);
@@ -3459,10 +3433,11 @@ static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	case IORING_OFF_SQES:
 		return io_uring_mmap_pages(ctx, vma, ctx->sqe_pages,
 						ctx->n_sqe_pages);
+	case IORING_OFF_PBUF_RING:
+		return io_pbuf_mmap(file, vma);
 	}
 
-	pfn = virt_to_phys(ptr) >> PAGE_SHIFT;
-	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
+	return -EINVAL;
 }
 
 static unsigned long io_uring_mmu_get_unmapped_area(struct file *filp,
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index ac2a84542417..23106dd06309 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -109,8 +109,10 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
 
-void *io_mem_alloc(size_t size);
-void io_mem_free(void *ptr);
+void *io_pages_map(struct page ***out_pages, unsigned short *npages,
+		   size_t size);
+void io_pages_unmap(void *ptr, struct page ***pages, unsigned short *npages,
+		    bool put_pages);
 
 enum {
 	IO_EVENTFD_OP_SIGNAL_BIT,
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 206f4d352e15..99b349930a1a 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -32,25 +32,12 @@ struct io_provide_buf {
 	__u16				bid;
 };
 
-struct io_buf_free {
-	struct hlist_node		list;
-	void				*mem;
-	size_t				size;
-	int				inuse;
-};
-
-static inline struct io_buffer_list *__io_buffer_get_list(struct io_ring_ctx *ctx,
-							  unsigned int bgid)
-{
-	return xa_load(&ctx->io_bl_xa, bgid);
-}
-
 static inline struct io_buffer_list *io_buffer_get_list(struct io_ring_ctx *ctx,
 							unsigned int bgid)
 {
 	lockdep_assert_held(&ctx->uring_lock);
 
-	return __io_buffer_get_list(ctx, bgid);
+	return xa_load(&ctx->io_bl_xa, bgid);
 }
 
 static int io_buffer_add_list(struct io_ring_ctx *ctx,
@@ -191,24 +178,6 @@ void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	return ret;
 }
 
-/*
- * Mark the given mapped range as free for reuse
- */
-static void io_kbuf_mark_free(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
-{
-	struct io_buf_free *ibf;
-
-	hlist_for_each_entry(ibf, &ctx->io_buf_list, list) {
-		if (bl->buf_ring == ibf->mem) {
-			ibf->inuse = 0;
-			return;
-		}
-	}
-
-	/* can't happen... */
-	WARN_ON_ONCE(1);
-}
-
 static int __io_remove_buffers(struct io_ring_ctx *ctx,
 			       struct io_buffer_list *bl, unsigned nbufs)
 {
@@ -220,23 +189,18 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 
 	if (bl->is_buf_ring) {
 		i = bl->buf_ring->tail - bl->head;
-		if (bl->is_mmap) {
-			/*
-			 * io_kbuf_list_free() will free the page(s) at
-			 * ->release() time.
-			 */
-			io_kbuf_mark_free(ctx, bl);
-			bl->buf_ring = NULL;
-			bl->is_mmap = 0;
-		} else if (bl->buf_nr_pages) {
+		if (bl->buf_nr_pages) {
 			int j;
 
-			for (j = 0; j < bl->buf_nr_pages; j++)
-				unpin_user_page(bl->buf_pages[j]);
-			kvfree(bl->buf_pages);
-			vunmap(bl->buf_ring);
-			bl->buf_pages = NULL;
-			bl->buf_nr_pages = 0;
+			for (j = 0; j < bl->buf_nr_pages; j++) {
+				if (bl->is_mmap)
+					put_page(bl->buf_pages[j]);
+				else
+					unpin_user_page(bl->buf_pages[j]);
+			}
+			io_pages_unmap(bl->buf_ring, &bl->buf_pages,
+					&bl->buf_nr_pages, false);
+			bl->is_mmap = 0;
 		}
 		/* make sure it's seen as empty */
 		INIT_LIST_HEAD(&bl->buf_list);
@@ -260,7 +224,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 	return i;
 }
 
-static void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
+void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl)
 {
 	if (atomic_dec_and_test(&bl->refs)) {
 		__io_remove_buffers(ctx, bl, -1U);
@@ -537,63 +501,18 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	return ret;
 }
 
-/*
- * See if we have a suitable region that we can reuse, rather than allocate
- * both a new io_buf_free and mem region again. We leave it on the list as
- * even a reused entry will need freeing at ring release.
- */
-static struct io_buf_free *io_lookup_buf_free_entry(struct io_ring_ctx *ctx,
-						    size_t ring_size)
-{
-	struct io_buf_free *ibf, *best = NULL;
-	size_t best_dist;
-
-	hlist_for_each_entry(ibf, &ctx->io_buf_list, list) {
-		size_t dist;
-
-		if (ibf->inuse || ibf->size < ring_size)
-			continue;
-		dist = ibf->size - ring_size;
-		if (!best || dist < best_dist) {
-			best = ibf;
-			if (!dist)
-				break;
-			best_dist = dist;
-		}
-	}
-
-	return best;
-}
-
 static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
 			      struct io_uring_buf_reg *reg,
 			      struct io_buffer_list *bl)
 {
-	struct io_buf_free *ibf;
 	size_t ring_size;
-	void *ptr;
 
 	ring_size = reg->ring_entries * sizeof(struct io_uring_buf_ring);
 
-	/* Reuse existing entry, if we can */
-	ibf = io_lookup_buf_free_entry(ctx, ring_size);
-	if (!ibf) {
-		ptr = io_mem_alloc(ring_size);
-		if (IS_ERR(ptr))
-			return PTR_ERR(ptr);
-
-		/* Allocate and store deferred free entry */
-		ibf = kmalloc(sizeof(*ibf), GFP_KERNEL_ACCOUNT);
-		if (!ibf) {
-			io_mem_free(ptr);
-			return -ENOMEM;
-		}
-		ibf->mem = ptr;
-		ibf->size = ring_size;
-		hlist_add_head(&ibf->list, &ctx->io_buf_list);
-	}
-	ibf->inuse = 1;
-	bl->buf_ring = ibf->mem;
+	bl->buf_ring = io_pages_map(&bl->buf_pages, &bl->buf_nr_pages, ring_size);
+	if (!bl->buf_ring)
+		return -ENOMEM;
+
 	bl->is_buf_ring = 1;
 	bl->is_mmap = 1;
 	return 0;
@@ -710,30 +629,50 @@ int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
 }
 
-void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
+struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
+				      unsigned long bgid)
 {
 	struct io_buffer_list *bl;
+	int ret;
 
-	bl = __io_buffer_get_list(ctx, bgid);
-
-	if (!bl || !bl->is_mmap)
-		return NULL;
-
-	return bl->buf_ring;
+	/*
+	 * We have to be a bit careful here - we're inside mmap and cannot
+	 * grab the uring_lock. This means the buffer_list could be
+	 * simultaneously going away, if someone is trying to be sneaky.
+	 * Look it up under rcu so we now it's not going away, and attempt
+	 * to grab a reference to it. If the ref is already zero, then fail
+	 * the mapping. If successful, we'll drop the reference at at the end.
+	 * This may then safely free the buffer_list (and drop the pages) at
+	 * that point, vm_insert_pages() would've already grabbed the
+	 * necessary vma references.
+	  */
+	rcu_read_lock();
+	bl = xa_load(&ctx->io_bl_xa, bgid);
+	/* must be a mmap'able buffer ring and have pages */
+	if (bl && bl->is_mmap && bl->buf_nr_pages)
+		ret = atomic_inc_not_zero(&bl->refs);
+	rcu_read_unlock();
+
+	if (!ret)
+		return ERR_PTR(-EINVAL);
+
+	return bl;
 }
 
-/*
- * Called at or after ->release(), free the mmap'ed buffers that we used
- * for memory mapped provided buffer rings.
- */
-void io_kbuf_mmap_list_free(struct io_ring_ctx *ctx)
+int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	struct io_buf_free *ibf;
-	struct hlist_node *tmp;
+	struct io_ring_ctx *ctx = file->private_data;
+	loff_t pgoff = vma->vm_pgoff << PAGE_SHIFT;
+	struct io_buffer_list *bl;
+	int bgid, ret;
 
-	hlist_for_each_entry_safe(ibf, tmp, &ctx->io_buf_list, list) {
-		hlist_del(&ibf->list);
-		io_mem_free(ibf->mem);
-		kfree(ibf);
-	}
+	bgid = (pgoff & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
+
+	bl = io_pbuf_get_bl(ctx, bgid);
+	if (IS_ERR(bl))
+		return PTR_ERR(bl);
+
+	ret = io_uring_mmap_pages(ctx, vma, bl->buf_pages, bl->buf_nr_pages);
+	io_put_bl(ctx, bl);
+	return ret;
 }
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 8b868a1744e2..53c141d9a8b2 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -55,13 +55,14 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
-void io_kbuf_mmap_list_free(struct io_ring_ctx *ctx);
-
 void __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
-void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid);
+void io_put_bl(struct io_ring_ctx *ctx, struct io_buffer_list *bl);
+struct io_buffer_list *io_pbuf_get_bl(struct io_ring_ctx *ctx,
+				      unsigned long bgid);
+int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
 
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 {
-- 
2.43.0


