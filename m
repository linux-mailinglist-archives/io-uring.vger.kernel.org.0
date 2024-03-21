Return-Path: <io-uring+bounces-1187-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 69AFE885B2A
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 15:48:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D33DDB2601C
	for <lists+io-uring@lfdr.de>; Thu, 21 Mar 2024 14:48:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3761F1E534;
	Thu, 21 Mar 2024 14:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="oKEgHwKZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8ED84A51
	for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 14:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711032528; cv=none; b=OhN6b3IZbbK2mgMT8l/oBg5NyI7GQGxnJxS1ON3YFa4hr0ZrnGbfmT/4UoIkVKwTdQDkCGiX7L/4v7Gu8L/k9j2X7vCGtfjW2jPXpphOvRyjhLA+M/YTvAIts9IR2QIJyQQPzTowzbnrEV//lVWjCYUuh5/goL7X4kNJbGlPhKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711032528; c=relaxed/simple;
	bh=K5JoFd7Og90ybtaBTukGSgpPfoqSN4r09nHOq3fQOsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uayqwrzIHdo8jST2mUlCF/w6r7nftI1qMaQwJ8DgjCw3FfPKGiuhIlbc+uG5sZ37YWuFZMqTWzrufpHQWrI0m+Vkj7ReN9iJ8a2D5eqsHzdD7E28wFxaCpfHs3f4dYQCsHG9peJASz6jMRZlNt9KLpuvpCFcRJDVmX9MrvWajfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=oKEgHwKZ; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7cc5e664d52so19315139f.0
        for <io-uring@vger.kernel.org>; Thu, 21 Mar 2024 07:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1711032525; x=1711637325; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uFJX6lkI8QHF+Xl/UFObgDgE/sRh1i9l9Ro++WDjOMw=;
        b=oKEgHwKZh3M6rgAy5rQy0wbks06pfMB6Sd2oLASANowXC5Dpm+/XLpY9raAJPl37Tt
         Kx8011k8silHk7PayU6y/Jdb4eJbwoWbGbMUlZ3BATNz5Ia4n5vOVPe0jG7745YbJXdf
         ena68eAlJGW1A8E0JxhtfrrkzQJDUZEM3SkERZW+qXSbILKKFhavm1JrS/bfUpn4XHNn
         4Hpj426tY8zqM9VsHqjnaAKJAsYeW9cw9KeIM9ukXvKZy/FK1E7zDXoM8Buhhbskil2+
         5VHT5seLfeLFw51GXmfKEutxQEEb0Oo/stMUxFzr67WALiE+U7mh190Bwbs0Anue1gMC
         di4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711032525; x=1711637325;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uFJX6lkI8QHF+Xl/UFObgDgE/sRh1i9l9Ro++WDjOMw=;
        b=mqsV68q+4N4/hItKGhPn6VmZZirKjNObqwSpXzHPAJJnpyfSdID6s3lrCZO2jKmGyC
         UYYGBe6Qaa6D+0DGkok9H8kZQ/oLrso3gs/O8pz7Y+rA975JPyf/yVBT0U4RflDoEQrL
         ieRRhCkjzAltevxFkztEQ/c3QdTojIt24Rb0veT01NTm6eXULR72TMtszczlUF2mWMg6
         BYLwqkWVN/7ow/kK6PsZNcEfSXXiZzo3LXnsDdQAcT77KVDfvRnfJGe7GLQ6k0rPj+f1
         xMQDd4TPALyXC2f1QvZd6sy4ijilbFtujK+FHavlXz4Qu4mKWvg/EiVp1fDDhzkX/A22
         oGaw==
X-Gm-Message-State: AOJu0YxaS64rqChsc5x3/cnnyln+3Abjn40CwA8j+oJlvVG2RFbgA3//
	tjhrWlbcf8Acf8niyQJRgAFGPNFyPG6qPadKrlN7/bH/QEnzRajuKqii91SnpG2p+fp9sC1qPqA
	P
X-Google-Smtp-Source: AGHT+IH0KExpHY07ICCnKhtxwmQmcA3hjhkVKmKI2qnWKBun/Vq7dtXCWkcBUKqPW8ucXVQBpoRvdw==
X-Received: by 2002:a6b:5108:0:b0:7ce:f407:1edf with SMTP id f8-20020a6b5108000000b007cef4071edfmr8860937iob.0.1711032524836;
        Thu, 21 Mar 2024 07:48:44 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id q20-20020a02c8d4000000b0047bed9ff286sm250835jao.31.2024.03.21.07.48.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Mar 2024 07:48:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring/kbuf: use vm_insert_pages() for mmap'ed pbuf ring
Date: Thu, 21 Mar 2024 08:45:01 -0600
Message-ID: <20240321144831.58602-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240321144831.58602-1-axboe@kernel.dk>
References: <20240321144831.58602-1-axboe@kernel.dk>
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
 io_uring/io_uring.c            |  30 ++----
 io_uring/io_uring.h            |   3 -
 io_uring/kbuf.c                | 178 +++++++++++++--------------------
 io_uring/kbuf.h                |   4 +-
 5 files changed, 82 insertions(+), 136 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c9a1952a383a..f37caff64d05 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -370,9 +370,6 @@ struct io_ring_ctx {
 
 	struct list_head	io_buffers_cache;
 
-	/* deferred free list, protected by ->uring_lock */
-	struct hlist_head	io_buf_list;
-
 	/* Keep this last, we don't need it for the fast path */
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5b80849fbb85..8ce36c5a37c4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -303,7 +303,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->sqd_list);
 	INIT_LIST_HEAD(&ctx->cq_overflow_list);
 	INIT_LIST_HEAD(&ctx->io_buffers_cache);
-	INIT_HLIST_HEAD(&ctx->io_buf_list);
 	io_alloc_cache_init(&ctx->rsrc_node_cache, IO_NODE_ALLOC_CACHE_MAX,
 			    sizeof(struct io_rsrc_node));
 	io_alloc_cache_init(&ctx->apoll_cache, IO_ALLOC_CACHE_MAX,
@@ -2615,7 +2614,7 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
 	return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
 }
 
-void io_mem_free(void *ptr)
+static void io_mem_free(void *ptr)
 {
 	if (!ptr)
 		return;
@@ -2728,7 +2727,7 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 	ctx->sq_sqes = NULL;
 }
 
-void *io_mem_alloc(size_t size)
+static void *io_mem_alloc(size_t size)
 {
 	gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
 	void *ret;
@@ -2838,7 +2837,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		ctx->mm_account = NULL;
 	}
 	io_rings_free(ctx);
-	io_kbuf_mmap_list_free(ctx);
 
 	percpu_ref_exit(&ctx->refs);
 	free_uid(ctx->user);
@@ -3307,11 +3305,9 @@ static void *io_uring_validate_mmap_request(struct file *file,
 					    loff_t pgoff, size_t sz)
 {
 	struct io_ring_ctx *ctx = file->private_data;
-	loff_t offset = pgoff << PAGE_SHIFT;
-	struct page *page;
 	void *ptr;
 
-	switch (offset & IORING_OFF_MMAP_MASK) {
+	switch ((pgoff << PAGE_SHIFT) & IORING_OFF_MMAP_MASK) {
 	case IORING_OFF_SQ_RING:
 	case IORING_OFF_CQ_RING:
 		/* Don't allow mmap if the ring was setup without it */
@@ -3325,23 +3321,13 @@ static void *io_uring_validate_mmap_request(struct file *file,
 			return ERR_PTR(-EINVAL);
 		ptr = ctx->sq_sqes;
 		break;
-	case IORING_OFF_PBUF_RING: {
-		unsigned int bgid;
-
-		bgid = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
-		rcu_read_lock();
-		ptr = io_pbuf_get_address(ctx, bgid);
-		rcu_read_unlock();
-		if (!ptr)
-			return ERR_PTR(-EINVAL);
-		break;
-		}
+	case IORING_OFF_PBUF_RING:
+		return 0;
 	default:
 		return ERR_PTR(-EINVAL);
 	}
 
-	page = virt_to_head_page(ptr);
-	if (sz > page_size(page))
+	if (sz > page_size(virt_to_head_page(ptr)))
 		return ERR_PTR(-EINVAL);
 
 	return ptr;
@@ -3352,6 +3338,7 @@ static void *io_uring_validate_mmap_request(struct file *file,
 static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	size_t sz = vma->vm_end - vma->vm_start;
+	long offset = vma->vm_pgoff << PAGE_SHIFT;
 	unsigned long pfn;
 	void *ptr;
 
@@ -3359,6 +3346,9 @@ static __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
 
+	if ((offset & IORING_OFF_MMAP_MASK) == IORING_OFF_PBUF_RING)
+		return io_pbuf_mmap(file, vma);
+
 	pfn = virt_to_phys(ptr) >> PAGE_SHIFT;
 	return remap_pfn_range(vma, vma->vm_start, pfn, sz, vma->vm_page_prot);
 }
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index bae8c1e937c1..050efc3e7973 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -108,9 +108,6 @@ bool __io_alloc_req_refill(struct io_ring_ctx *ctx);
 bool io_match_task_safe(struct io_kiocb *head, struct task_struct *task,
 			bool cancel_all);
 
-void *io_mem_alloc(size_t size);
-void io_mem_free(void *ptr);
-
 enum {
 	IO_EVENTFD_OP_SIGNAL_BIT,
 	IO_EVENTFD_OP_FREE_BIT,
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 206f4d352e15..52210772da2f 100644
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
@@ -220,23 +189,20 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 
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
+			for (j = 0; j < bl->buf_nr_pages; j++) {
+				if (bl->is_mmap)
+					put_page(bl->buf_pages[j]);
+				else
+					unpin_user_page(bl->buf_pages[j]);
+			}
 			kvfree(bl->buf_pages);
 			vunmap(bl->buf_ring);
 			bl->buf_pages = NULL;
 			bl->buf_nr_pages = 0;
+			bl->is_mmap = 0;
 		}
 		/* make sure it's seen as empty */
 		INIT_LIST_HEAD(&bl->buf_list);
@@ -537,63 +503,48 @@ static int io_pin_pbuf_ring(struct io_uring_buf_reg *reg,
 	return ret;
 }
 
-/*
- * See if we have a suitable region that we can reuse, rather than allocate
- * both a new io_buf_free and mem region again. We leave it on the list as
- * even a reused entry will need freeing at ring release.
- */
-static struct io_buf_free *io_lookup_buf_free_entry(struct io_ring_ctx *ctx,
-						    size_t ring_size)
+static int io_alloc_map_pages(struct io_buffer_list *bl, size_t ring_size)
 {
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
+	int i, nr_pages;
+
+	nr_pages = (ring_size + PAGE_SIZE - 1) >> PAGE_SHIFT;
+	bl->buf_pages = kvmalloc_array(nr_pages, sizeof(struct page *), GFP_KERNEL);
+	if (!bl->buf_pages)
+		return -ENOMEM;
+
+	for (i = 0; i < nr_pages; i++) {
+		bl->buf_pages[i] = alloc_page(GFP_KERNEL);
+		if (!bl->buf_pages[i])
+			goto out_free;
 	}
 
-	return best;
+	bl->buf_ring = vmap(bl->buf_pages, nr_pages, VM_MAP, PAGE_KERNEL);
+	if (bl->buf_ring) {
+		bl->buf_nr_pages = nr_pages;
+		return 0;
+	}
+out_free:
+	while (i--)
+		put_page(bl->buf_pages[i]);
+	kvfree(bl->buf_pages);
+	bl->buf_pages = NULL;
+	bl->buf_nr_pages = 0;
+	return -ENOMEM;
 }
 
 static int io_alloc_pbuf_ring(struct io_ring_ctx *ctx,
 			      struct io_uring_buf_reg *reg,
 			      struct io_buffer_list *bl)
 {
-	struct io_buf_free *ibf;
 	size_t ring_size;
-	void *ptr;
+	int ret;
 
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
+	ret = io_alloc_map_pages(bl, ring_size);
+	if (ret)
+		return ret;
+
 	bl->is_buf_ring = 1;
 	bl->is_mmap = 1;
 	return 0;
@@ -710,30 +661,43 @@ int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
 }
 
-void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid)
+int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma)
 {
+	struct io_ring_ctx *ctx = file->private_data;
+	loff_t pgoff = vma->vm_pgoff << PAGE_SHIFT;
 	struct io_buffer_list *bl;
+	unsigned long npages;
+	int bgid, ret;
 
-	bl = __io_buffer_get_list(ctx, bgid);
+	bgid = (pgoff & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
 
-	if (!bl || !bl->is_mmap)
-		return NULL;
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
+	ret = 0;
+	rcu_read_lock();
+	bl = xa_load(&ctx->io_bl_xa, bgid);
+	/* must be a mmap'able buffer ring and have pages */
+	if (bl && bl->is_mmap && bl->buf_nr_pages)
+		ret = atomic_inc_not_zero(&bl->refs);
+	rcu_read_unlock();
+
+	/* buffer list is invalid or being torn down, fail the mapping */
+	if (!ret)
+		return -EINVAL;
 
-	return bl->buf_ring;
-}
+	vm_flags_set(vma, VM_DONTEXPAND);
 
-/*
- * Called at or after ->release(), free the mmap'ed buffers that we used
- * for memory mapped provided buffer rings.
- */
-void io_kbuf_mmap_list_free(struct io_ring_ctx *ctx)
-{
-	struct io_buf_free *ibf;
-	struct hlist_node *tmp;
-
-	hlist_for_each_entry_safe(ibf, tmp, &ctx->io_buf_list, list) {
-		hlist_del(&ibf->list);
-		io_mem_free(ibf->mem);
-		kfree(ibf);
-	}
+	npages = bl->buf_nr_pages;
+	ret = vm_insert_pages(vma, vma->vm_start, bl->buf_pages, &npages);
+	io_put_bl(ctx, bl);
+	return ret;
 }
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 8b868a1744e2..0723a6ffe731 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -55,13 +55,11 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
-void io_kbuf_mmap_list_free(struct io_ring_ctx *ctx);
-
 void __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
-void *io_pbuf_get_address(struct io_ring_ctx *ctx, unsigned long bgid);
+int io_pbuf_mmap(struct file *file, struct vm_area_struct *vma);
 
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 {
-- 
2.43.0


