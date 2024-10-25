Return-Path: <io-uring+bounces-4033-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 900AC9B0505
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 16:05:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B36521C20F6C
	for <lists+io-uring@lfdr.de>; Fri, 25 Oct 2024 14:05:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E74213B584;
	Fri, 25 Oct 2024 14:05:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FlBV/2bl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE44A13A879
	for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 14:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729865127; cv=none; b=ECI+SlQedoub2i/4pL4BogpRmAkM50kuOYHmopuRF/8LEveUh68aQfFwyFVMIx5pkVNzB1mcmrbzDkHDd7C5alxGK/mkSVHdnIozSBZGNLnbXV2rbqdp993embpLb7vMV+gsz92So+qUgUkD+p2poh29n2YZEWQzlpSeCL4y12g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729865127; c=relaxed/simple;
	bh=891HBwKYlzea2RyDtcpfuoXgFIq50iRIU6B5ZJTWEwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=frWF6jE+ZEeIZorh+D9XX7rBkmRLh908EY4LsZN31kPbVYI95zWFH4sK+ILx69GHQsGT9SGBHWJcehk3r3gf9WV2jp1qf1gkSGOQsn90VwnGCQCGlXNPEZKaPCq0kXsw4CEBXSqqe3cYzz2ZebBQRQ8D6y6rC/5YP3LivrHu6js=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FlBV/2bl; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3a4e474983fso3961265ab.1
        for <io-uring@vger.kernel.org>; Fri, 25 Oct 2024 07:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729865122; x=1730469922; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2IFhJrPJWY5NJkIvQAJNqeYBlsK7wOF+sVFG9Yzl+2c=;
        b=FlBV/2bl2bxlohLpY84clC+d7eU1ARvl1cJbeyIiCY6X4ffYs6O0PPufjG6KStf/WN
         VTWDliTxEnTY/5bhpRlPpWIXTNU17FmIET6vqlCdmGIb5dEwtcaWXaXYV3A+LL+oz7ae
         0X/yKWPI5eg/f8A7FZEUfFB78r/IMfwpt7qr3IylKR9KtmKFFZsibZMOO43AZYGAp38Y
         zvXPi/YEh6pXWxXkrieHYw8g3vbR8mjvJW8pCd04MhVDcY0JKdx4IOmyuO1/AE08hAm9
         JPVuzj3B8vJHFLc4DE5edVXd8jHw3JchIDsVMJO6u7PfT7s94JNrDDzerPYSG+cdJ+ya
         Ap0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729865122; x=1730469922;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2IFhJrPJWY5NJkIvQAJNqeYBlsK7wOF+sVFG9Yzl+2c=;
        b=IBUb/pH58iYwTo6CEhyxfvTJ/IaeT/YioHvgOBfSmmpXawG+yMBOTS2wdte6rmpX2b
         m0Ee8hWQOwZLHotAJrhWOSLqM0RXMFF94wl6N4zV1I5NxYaiGryds11mBb3sEhUCRBra
         PuA9SSUWawgA+eOCE3dDL6cMppakxFuL2VWE6WFcwvI0S4KRuRWBfaeem2ENqKUo+7Sc
         32x/9/MWTD+clvabC0siXIh9dB2+SDAR89N0nwFevKxYdLLhsVypnfZ01aQNwhiG6PSW
         vMRa1f+834NNjxHOCqxve288qF6MXvuWnuX9cztyw9SiklHWTOpUFVxVoQ6mt3jNl6nB
         vNyQ==
X-Gm-Message-State: AOJu0YxuJ01xeXnY3QgHOaxSH448d6bQgGAut4mOh/l98pGMjNArrIGQ
	JRYP1KrjBqPZcBFJyoBF70ik4Bjh0GbC2YE9JXpq3BmmPOTEgTGHcQ2TTMrJcnimCkK7+Kvt8a0
	N
X-Google-Smtp-Source: AGHT+IFftJsbe7Z2GSUTM+MZ6690stU+l0qcKkhi26rV7bhR0KtEmma8Kr7Y8upN2Qd54IKMP+c5PQ==
X-Received: by 2002:a05:6e02:2142:b0:3a0:90c7:f1b with SMTP id e9e14a558f8ab-3a4d595f1fcmr118840945ab.12.1729865122312;
        Fri, 25 Oct 2024 07:05:22 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a4e6e56641sm2924635ab.65.2024.10.25.07.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2024 07:05:20 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring/register: add IORING_REGISTER_RESIZE_RINGS
Date: Fri, 25 Oct 2024 08:02:31 -0600
Message-ID: <20241025140502.167623-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241025140502.167623-2-axboe@kernel.dk>
References: <20241025140502.167623-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Once a ring has been created, the size of the CQ and SQ rings are fixed.
Usually this isn't a problem on the SQ ring side, as it merely controls
the available number of requests that can be submitted in a single
system call, and there's rarely a need to change that.

For the CQ ring, it's a different story. For most efficient use of
io_uring, it's important that the CQ ring never overflows. This means
that applications must size it for the worst case scenario, which can
be wasteful.

Add IORING_REGISTER_RESIZE_RINGS, which allows an application to resize
the existing rings. It takes a struct io_uring_params argument, the same
one which is used to setup the ring initially, and resizes rings
according to the sizes given.

Certain properties are always inherited from the original ring setup,
like SQE128/CQE32 and other setup options. The implementation only
allows flag associated with how the CQ ring is sized and clamped.

Existing unconsumed SQE and CQE entries are copied as part of the
process. If either the SQ or CQ resized destination ring cannot hold the
entries already present in the source rings, then the operation is failed
with -EOVERFLOW. Any register op holds ->uring_lock, which prevents new
submissions, and the internal mapping holds the completion lock as well
across moving CQ ring state.

To prevent races between mmap and ring resizing, add a mutex that's
solely used to serialize ring resize and mmap. mmap_sem can't be used
here, as as fork'ed process may be doing mmaps on the ring as well.
The ctx->resize_lock is held across mmap operations, and the resize
will grab it before swapping out the already mapped new data.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   7 ++
 include/uapi/linux/io_uring.h  |   3 +
 io_uring/io_uring.c            |   1 +
 io_uring/memmap.c              |   8 ++
 io_uring/register.c            | 215 +++++++++++++++++++++++++++++++++
 5 files changed, 234 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 6d3ee71bd832..841579dcdae9 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -415,6 +415,13 @@ struct io_ring_ctx {
 	/* protected by ->completion_lock */
 	unsigned			evfd_last_cq_tail;
 
+	/*
+	 * Protection for resize vs mmap races - both the mmap and resize
+	 * side will need to grab this lock, to prevent either side from
+	 * being run concurrently with the other.
+	 */
+	struct mutex			resize_lock;
+
 	/*
 	 * If IORING_SETUP_NO_MMAP is used, then the below holds
 	 * the gup'ed pages for the two rings, and the sqes.
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 86cb385fe0b5..c4737892c7cd 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -615,6 +615,9 @@ enum io_uring_register_op {
 	/* send MSG_RING without having a ring */
 	IORING_REGISTER_SEND_MSG_RING		= 31,
 
+	/* resize CQ ring */
+	IORING_REGISTER_RESIZE_RINGS		= 33,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b5974bdad48b..140cd47fbdb3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -353,6 +353,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_WQ_LIST(&ctx->submit_state.compl_reqs);
 	INIT_HLIST_HEAD(&ctx->cancelable_uring_cmd);
 	io_napi_init(ctx);
+	mutex_init(&ctx->resize_lock);
 
 	return ctx;
 
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index d614824e17bd..85c66fa54956 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -251,6 +251,8 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 	unsigned int npages;
 	void *ptr;
 
+	guard(mutex)(&ctx->resize_lock);
+
 	ptr = io_uring_validate_mmap_request(file, vma->vm_pgoff, sz);
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
@@ -274,6 +276,7 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 					 unsigned long len, unsigned long pgoff,
 					 unsigned long flags)
 {
+	struct io_ring_ctx *ctx = filp->private_data;
 	void *ptr;
 
 	/*
@@ -284,6 +287,8 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 	if (addr)
 		return -EINVAL;
 
+	guard(mutex)(&ctx->resize_lock);
+
 	ptr = io_uring_validate_mmap_request(filp, pgoff, len);
 	if (IS_ERR(ptr))
 		return -ENOMEM;
@@ -329,8 +334,11 @@ unsigned long io_uring_get_unmapped_area(struct file *file, unsigned long addr,
 					 unsigned long len, unsigned long pgoff,
 					 unsigned long flags)
 {
+	struct io_ring_ctx *ctx = file->private_data;
 	void *ptr;
 
+	guard(mutex)(&ctx->resize_lock);
+
 	ptr = io_uring_validate_mmap_request(file, pgoff, len);
 	if (IS_ERR(ptr))
 		return PTR_ERR(ptr);
diff --git a/io_uring/register.c b/io_uring/register.c
index 52b2f9b74af8..fc6c94d694b2 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -29,6 +29,7 @@
 #include "napi.h"
 #include "eventfd.h"
 #include "msg_ring.h"
+#include "memmap.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -361,6 +362,214 @@ static int io_register_clock(struct io_ring_ctx *ctx,
 	return 0;
 }
 
+/*
+ * State to maintain until we can swap. Both new and old state, used for
+ * either mapping or freeing.
+ */
+struct io_ring_ctx_rings {
+	unsigned short n_ring_pages;
+	unsigned short n_sqe_pages;
+	struct page **ring_pages;
+	struct page **sqe_pages;
+	struct io_uring_sqe *sq_sqes;
+	struct io_rings *rings;
+};
+
+static void io_register_free_rings(struct io_uring_params *p,
+				   struct io_ring_ctx_rings *r)
+{
+	if (!(p->flags & IORING_SETUP_NO_MMAP)) {
+		io_pages_unmap(r->rings, &r->ring_pages, &r->n_ring_pages,
+				true);
+		io_pages_unmap(r->sq_sqes, &r->sqe_pages, &r->n_sqe_pages,
+				true);
+	} else {
+		io_pages_free(&r->ring_pages, r->n_ring_pages);
+		io_pages_free(&r->sqe_pages, r->n_sqe_pages);
+		vunmap(r->rings);
+		vunmap(r->sq_sqes);
+	}
+}
+
+#define swap_old(ctx, o, n, field)		\
+	do {					\
+		(o).field = (ctx)->field;	\
+		(ctx)->field = (n).field;	\
+	} while (0)
+
+#define RESIZE_FLAGS	(IORING_SETUP_CQSIZE | IORING_SETUP_CLAMP)
+#define COPY_FLAGS	(IORING_SETUP_NO_SQARRAY | IORING_SETUP_SQE128 | \
+			 IORING_SETUP_CQE32 | IORING_SETUP_NO_MMAP)
+
+static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
+{
+	struct io_ring_ctx_rings o = { }, n = { }, *to_free = NULL;
+	size_t size, sq_array_offset;
+	struct io_uring_params p;
+	unsigned i, tail;
+	void *ptr;
+	int ret;
+
+	/* for single issuer, must be owner resizing */
+	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER &&
+	    current != ctx->submitter_task)
+		return -EEXIST;
+	if (copy_from_user(&p, arg, sizeof(p)))
+		return -EFAULT;
+	if (p.flags & ~RESIZE_FLAGS)
+		return -EINVAL;
+
+	/* properties that are always inherited */
+	p.flags |= (ctx->flags & COPY_FLAGS);
+
+	ret = io_uring_fill_params(p.sq_entries, &p);
+	if (unlikely(ret))
+		return ret;
+
+	/* nothing to do, but copy params back */
+	if (p.sq_entries == ctx->sq_entries && p.cq_entries == ctx->cq_entries) {
+		if (copy_to_user(arg, &p, sizeof(p)))
+			return -EFAULT;
+		return 0;
+	}
+
+	size = rings_size(p.flags, p.sq_entries, p.cq_entries,
+				&sq_array_offset);
+	if (size == SIZE_MAX)
+		return -EOVERFLOW;
+
+	if (!(p.flags & IORING_SETUP_NO_MMAP))
+		n.rings = io_pages_map(&n.ring_pages, &n.n_ring_pages, size);
+	else
+		n.rings = __io_uaddr_map(&n.ring_pages, &n.n_ring_pages,
+						p.cq_off.user_addr, size);
+	if (IS_ERR(n.rings))
+		return PTR_ERR(n.rings);
+
+	n.rings->sq_ring_mask = p.sq_entries - 1;
+	n.rings->cq_ring_mask = p.cq_entries - 1;
+	n.rings->sq_ring_entries = p.sq_entries;
+	n.rings->cq_ring_entries = p.cq_entries;
+
+	if (copy_to_user(arg, &p, sizeof(p))) {
+		io_register_free_rings(&p, &n);
+		return -EFAULT;
+	}
+
+	if (p.flags & IORING_SETUP_SQE128)
+		size = array_size(2 * sizeof(struct io_uring_sqe), p.sq_entries);
+	else
+		size = array_size(sizeof(struct io_uring_sqe), p.sq_entries);
+	if (size == SIZE_MAX) {
+		io_register_free_rings(&p, &n);
+		return -EOVERFLOW;
+	}
+
+	if (!(p.flags & IORING_SETUP_NO_MMAP))
+		ptr = io_pages_map(&n.sqe_pages, &n.n_sqe_pages, size);
+	else
+		ptr = __io_uaddr_map(&n.sqe_pages, &n.n_sqe_pages,
+					p.sq_off.user_addr,
+					size);
+	if (IS_ERR(ptr)) {
+		io_register_free_rings(&p, &n);
+		return PTR_ERR(ptr);
+	}
+
+	/*
+	 * If using SQPOLL, park the thread
+	 */
+	if (ctx->sq_data) {
+		mutex_unlock(&ctx->uring_lock);
+		io_sq_thread_park(ctx->sq_data);
+		mutex_lock(&ctx->uring_lock);
+	}
+
+	/*
+	 * We'll do the swap. Grab the ctx->resize_lock, which will exclude
+	 * any new mmap's on the ring fd. Clear out existing mappings to prevent
+	 * mmap from seeing them, as we'll unmap them. Any attempt to mmap
+	 * existing rings beyond this point will fail. Not that it could proceed
+	 * at this point anyway, as the io_uring mmap side needs go grab the
+	 * ctx->resize_lock as well. Likewise, hold the completion lock over the
+	 * duration of the actual swap.
+	 */
+	mutex_lock(&ctx->resize_lock);
+	spin_lock(&ctx->completion_lock);
+	o.rings = ctx->rings;
+	ctx->rings = NULL;
+	o.sq_sqes = ctx->sq_sqes;
+	ctx->sq_sqes = NULL;
+
+	/*
+	 * Now copy SQ and CQ entries, if any. If either of the destination
+	 * rings can't hold what is already there, then fail the operation.
+	 */
+	n.sq_sqes = ptr;
+	tail = o.rings->sq.tail;
+	if (tail - o.rings->sq.head > p.sq_entries)
+		goto overflow;
+	for (i = o.rings->sq.head; i < tail; i++) {
+		unsigned src_head = i & (ctx->sq_entries - 1);
+		unsigned dst_head = i & n.rings->sq_ring_mask;
+
+		n.sq_sqes[dst_head] = o.sq_sqes[src_head];
+	}
+	n.rings->sq.head = o.rings->sq.head;
+	n.rings->sq.tail = o.rings->sq.tail;
+
+	tail = o.rings->cq.tail;
+	if (tail - o.rings->cq.head > p.cq_entries) {
+overflow:
+		/* restore old rings, and return -EOVERFLOW via cleanup path */
+		ctx->rings = o.rings;
+		ctx->sq_sqes = o.sq_sqes;
+		to_free = &n;
+		ret = -EOVERFLOW;
+		goto out;
+	}
+	for (i = o.rings->cq.head; i < tail; i++) {
+		unsigned src_head = i & (ctx->cq_entries - 1);
+		unsigned dst_head = i & n.rings->cq_ring_mask;
+
+		n.rings->cqes[dst_head] = o.rings->cqes[src_head];
+	}
+	n.rings->cq.head = o.rings->cq.head;
+	n.rings->cq.tail = o.rings->cq.tail;
+	/* invalidate cached cqe refill */
+	ctx->cqe_cached = ctx->cqe_sentinel = NULL;
+
+	n.rings->sq_dropped = o.rings->sq_dropped;
+	n.rings->sq_flags = o.rings->sq_flags;
+	n.rings->cq_flags = o.rings->cq_flags;
+	n.rings->cq_overflow = o.rings->cq_overflow;
+
+	/* all done, store old pointers and assign new ones */
+	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
+		ctx->sq_array = (u32 *)((char *)n.rings + sq_array_offset);
+
+	ctx->sq_entries = p.sq_entries;
+	ctx->cq_entries = p.cq_entries;
+
+	ctx->rings = n.rings;
+	ctx->sq_sqes = n.sq_sqes;
+	swap_old(ctx, o, n, n_ring_pages);
+	swap_old(ctx, o, n, n_sqe_pages);
+	swap_old(ctx, o, n, ring_pages);
+	swap_old(ctx, o, n, sqe_pages);
+	to_free = &o;
+	ret = 0;
+out:
+	spin_unlock(&ctx->completion_lock);
+	mutex_unlock(&ctx->resize_lock);
+	io_register_free_rings(&p, to_free);
+
+	if (ctx->sq_data)
+		io_sq_thread_unpark(ctx->sq_data);
+
+	return ret;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -549,6 +758,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_clone_buffers(ctx, arg);
 		break;
+	case IORING_REGISTER_RESIZE_RINGS:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_resize_rings(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
-- 
2.45.2


