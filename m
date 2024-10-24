Return-Path: <io-uring+bounces-3993-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C25B89AED33
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 19:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id A9BBAB2351B
	for <lists+io-uring@lfdr.de>; Thu, 24 Oct 2024 17:08:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B40E3167DAC;
	Thu, 24 Oct 2024 17:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cLDksPDX"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CF319DF7A
	for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 17:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729789725; cv=none; b=bRONeApwed5h44U/d23LkINzqwVB9CDYJelQIgTLR5aecBdfs6ZXzzjrU7PgEsSE9Rn9/4YsWTq5NT7GmvcxSt+Qxy8fZcLFkAnZXKpPibYwoqXwJruainHonYIEhXvCyQ3FQe2CXqmH2dROI2vLKs1Oi6C3uenSHHeQrELp7B8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729789725; c=relaxed/simple;
	bh=koXgoU2Bb8svwTSLtxM/QVGMSZAaJ3IvVzIJmcPAGwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IduPbwF5lj6r4ZO5ofpl6E0FaDJfmMpvf7NroSYewO7xi4BsomvtWwfjYcjKvgE9ooLmVHwUIVtaGo8CLf5/KKHnG/0S7mjPv+JMNY9aN9UoWwzRJnS0Cxefr/VF7tFYilHEsHSBX+Bq5RWbcHb5BnG8vR5VoOnhh1pSuZRlZX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cLDksPDX; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a4d1633df9so4668495ab.2
        for <io-uring@vger.kernel.org>; Thu, 24 Oct 2024 10:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729789721; x=1730394521; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NaQjZr9Vw/7x5N6M9zv4XaxVTX09HoMSr/vVr4eXl+g=;
        b=cLDksPDXQQdBVvMW9+4Q6/+6eK6A+GZIYz4RnnN9tSUCU5QiGPJkqN46e8DKmK66/G
         fSwpAZ6nAvaqJKDJea8/8VfCN1MAoJ0kFEuDlqHGtQ5lawu7lZWD3DF5fHXGVS8fPvwE
         ZZFX9k1R5N4OKDMZoK7vRulNOs6l3H7HGLxPxC0pfN/7+8RVuJCRDkQdp3FYNq0AiNG2
         FjPrYfwisQyXeQj7G7Wlww97YiOAMq4bzKcwIlruUO1upeSvAnsBkN05/3PJTPcpbOPi
         mxVHiFtUHiwLjJq3k9u6CWUd9QqwQjDwDWn82dAM+pfH0hOGQ8yl7dQWytHU+HFtwvL1
         QziA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729789721; x=1730394521;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NaQjZr9Vw/7x5N6M9zv4XaxVTX09HoMSr/vVr4eXl+g=;
        b=Dib+YvWudZ0Bt2lJ/+ts2sP65sbvt7HyYkjeNRkERa96dQwR0oVB/yaVg8lHLHojB0
         mSC6mVspcdvcIIFXOPqN01nF3eoI1W+6vU5UbMxQTGJtTgPsDyC8oZI8YcEj0xcP9cAV
         yND1JU5ZeTcD/S1b9W5fhzsb/9f3nioGNYklcwsJkwu8qYTh5VSWUptGj5HthmKDc5+X
         Tf3Q2BnXs/JWJ5s4WQCrF7wq6Zk3riNjv1QRHWHAGb+KSuBAAlJofMdEQfjEIfwcx3ZP
         OhGZEaoyF6eaXqpUIkzGYZIGeAFO8OHt+7EG7duwo+RN5P+dlwLzA9tn3YiXOINwZiAT
         5FPA==
X-Gm-Message-State: AOJu0YzUy1yNeDdOsr8+YGXiHrpQ/X2M81qWowQqk1NK865fhALrrsQw
	g88/6pRllDcIC3nQqtJ/BPMVHKa78cnljOsxfso2c3ow9AoWxqxK3CzPfym7iNZj7G2x75zCWlD
	C
X-Google-Smtp-Source: AGHT+IHMttldOxIdCJTVAvDC2yLkmpbqf+mxtExBalXxVWLIY+DbKYHOPMk8QMNTEbxLcMSI2ZjJIw==
X-Received: by 2002:a05:6e02:1aa8:b0:3a0:92e5:af68 with SMTP id e9e14a558f8ab-3a4d597b60emr80843095ab.15.1729789721424;
        Thu, 24 Oct 2024 10:08:41 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a400b63981sm31368045ab.67.2024.10.24.10.08.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Oct 2024 10:08:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring/register: add IORING_REGISTER_RESIZE_RINGS
Date: Thu, 24 Oct 2024 11:07:39 -0600
Message-ID: <20241024170829.1266002-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241024170829.1266002-1-axboe@kernel.dk>
References: <20241024170829.1266002-1-axboe@kernel.dk>
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

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |   3 +
 io_uring/register.c           | 214 ++++++++++++++++++++++++++++++++++
 2 files changed, 217 insertions(+)

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
 
diff --git a/io_uring/register.c b/io_uring/register.c
index 52b2f9b74af8..911242f63704 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -29,6 +29,7 @@
 #include "napi.h"
 #include "eventfd.h"
 #include "msg_ring.h"
+#include "memmap.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -361,6 +362,213 @@ static int io_register_clock(struct io_ring_ctx *ctx,
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
+	 * We'll do the swap. Clear out existing mappings to prevent mmap
+	 * from seeing them, as we'll unmap them. Any attempt to mmap existing
+	 * rings beyond this point will fail. Not that it could proceed at this
+	 * point anyway, as we'll hold the mmap_sem until we've done the swap.
+	 * Likewise, hold the completion * lock over the duration of the actual
+	 * swap.
+	 */
+	mmap_write_lock(current->mm);
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
+	mmap_write_unlock(current->mm);
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
@@ -549,6 +757,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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


