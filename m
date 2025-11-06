Return-Path: <io-uring+bounces-10418-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 263F8C3CB97
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:09:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B71B9625FA3
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 702E534D918;
	Thu,  6 Nov 2025 17:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dsCl6WFs"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5EF34D4D7
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448534; cv=none; b=FWhK9f6fMTK/NdOSY7SlWZBcJv3d78jN4rfTxIy9X0z5XWJLr1dPXLCOVdvspGoQLO2tvLSEg/hDwELqZloULYfWZFUs1QGgCo+3trfgt4XXV4Vn5YXB0L8xaRI+BbMw36gnqE2o69ctcqEYpGeAhpBasjEYW17V5GKFgUoNYFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448534; c=relaxed/simple;
	bh=duuIc1BCFQF7Fsvrc5tYSnPHC1qOBQ+Qi90SZBBPLx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f7R3mIJ7LkshxEllPng/SljXVBXYD8Wj0ROKgt5/UoCy68to6LnMF5ro4+0bNxUPGFmM+QPL5yd5EfPr+9jS5pTjE+q+wphhjThvg2q4DU7L6eAtRMhdW6y9iFRuOlIo+RUvycRqpE1+5Oujaot3KMXayD2IneLSQjpc8z/8Za8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dsCl6WFs; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-429ce7e79f8so908858f8f.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448530; x=1763053330; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YqhEu4B2wrxBf225xqExvZEtK32xJHKL5rAJ3bm5HD0=;
        b=dsCl6WFsH1Rz4/gDPs1+wJFdqiSTkRn1lfDEpEZb68nfI5xsTtpR2aFPwbmWat5fFK
         fLwYClECeyvZe8vBCnA5UhgkFltkYpxfFYQcrAmgE+0t0wxRJhtpeJJaASTHc0i/qcYS
         0BXvFIfiL7Nv7ltCL0bshwFcc3UIWkLrYKUKrw3ChGFrq476c9n7726qBL9tMDrefg1A
         l7M0l5zCRGcDVYrHnWSttQf638rUxsVI8iOyoU8aJ8T32peVpSef9r2DLi2b+ZXBsKWV
         6EJaVzQIR5RnHNBrJ7PaEHtT350erxhitroiUOdiNYE5eW1rD/PfIBnxWoEU35CJ4ScS
         yx/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448530; x=1763053330;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YqhEu4B2wrxBf225xqExvZEtK32xJHKL5rAJ3bm5HD0=;
        b=tyOdKB5Tdrurbt9Ow5bTnVXXxeZ84wTc/t1hco2j7EwmoYCNI0Ra1HTN2ioHu4BLWD
         sH5oaDKaJD4acizvVaJWHof8XlIUpd/dgCk4xyXi8Q5SDJ6R2/7jBXv3tYqEeOxxrYby
         8IAsDhfFMVLiRa8hBrohbVNPjpO6NTjUHYU0CzTrt6pdMXZItRzUjJcOCjs4m0H2sOrF
         3gkYvkL3d4aaI/E1Thaz6SCBnHx59Sz1OAOrgGsE+9BB614gYdgaD2SGdUddbarsYJ5J
         3HPSLYj5fpudAygugDEG/RV7agb/Npz86Ep1mlHzfuV9whTR15XSxEHlR+LZRD0h1A4F
         U9vw==
X-Gm-Message-State: AOJu0YyFd7xVUX4qtFGJE9poZDsOiqbH4TUY+l4iBjfXv3lnYZkc9lB2
	Bv0xd0jS1Zr3Vazue9B268X5zwZFW6muENaK0a3BsuGbw/0TPHtvTmdh9SQE8A==
X-Gm-Gg: ASbGncvaYJJuQczzG6VWO7sPquLo4GJ/DT0Ic/huceyugilxenSwSu62bydEmQX8WVS
	0p81803TuUjHRdXDKEMpwWHpSgR7Hs7VBs2fEXqvt5NLfsdsIZXf4yULJNhfPl6rRAo95oNHgYn
	XY1uChUvDPkSiXUr2fRopPJ2/IMnhBw6HNJOSjn7PMRiwRekr6sa2MicZf/9XJkNzgE9yH0X+RT
	QF5EgW9WpRGBPR0CkMFhaN7PWJYl+2fQjFXoJ7un2O/pwy88kchGepwVYge0ASvII6JtU1SZLDi
	23M/SWWENM7XZYF3VSV/Nxetz3oKcCxWHuGP/f6f82F0ZAY7QcukqrpS1Y+qHh1k/mOE/RMMQct
	t8kVBQowq23ZfvkLI4QI+xAx/C7Goxk+64Bon17fpwFiX3NTz/FaA1OuqLDUlXjhwjLEYD7I0Uf
	hTejpmrDwBnqVd8Q==
X-Google-Smtp-Source: AGHT+IEm8p2qPvBFIX4bh+EYeSvSMUWxtpYdXEm3Zx1e+E0qlZPXmOVLeqxFa9R+4uO8xZX0aqTLSg==
X-Received: by 2002:a05:6000:22c8:b0:429:c774:dbff with SMTP id ffacd0b85a97d-429e32c94e2mr7325828f8f.12.1762448529895;
        Thu, 06 Nov 2025 09:02:09 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:09 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 10/16] io_uring: separate cqe array from headers
Date: Thu,  6 Nov 2025 17:01:49 +0000
Message-ID: <274184bd22b625f4420232540ea8801ba4faf98f.1762447538.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762447538.git.asml.silence@gmail.com>
References: <cover.1762447538.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Keep a pointer to the CQ separate from SCQ headers, it'll be used
shortly in next patches. Also, don't overestimate the CQ size for
SETUP_CQE32, which not only doubles memory for CQ entries but also the
headers as well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h | 17 +++++++++--------
 io_uring/fdinfo.c              |  2 +-
 io_uring/io_uring.c            | 35 ++++++++++++++++++++++------------
 io_uring/io_uring.h            |  1 +
 io_uring/register.c            |  8 +++++++-
 5 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 92780764d5fa..91ded559a147 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -209,14 +209,6 @@ struct io_rings {
 	 * ordered with any other data.
 	 */
 	u32			cq_overflow;
-	/*
-	 * Ring buffer of completion events.
-	 *
-	 * The kernel writes completion events fresh every time they are
-	 * produced, so the application is allowed to modify pending
-	 * entries.
-	 */
-	struct io_uring_cqe	cqes[] ____cacheline_aligned_in_smp;
 };
 
 struct io_restriction {
@@ -274,6 +266,15 @@ struct io_ring_ctx {
 
 		struct task_struct	*submitter_task;
 		struct io_rings		*rings;
+		/*
+		 * Ring buffer of completion events.
+		 *
+		 * The kernel writes completion events fresh every time they are
+		 * produced, so the application is allowed to modify pending
+		 * entries.
+		 */
+		struct io_uring_cqe	*cqes;
+
 		struct percpu_ref	refs;
 
 		clockid_t		clockid;
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index ac6e7edc7027..eae13ac9b1a9 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -153,7 +153,7 @@ static void __io_uring_show_fdinfo(struct io_ring_ctx *ctx, struct seq_file *m)
 		struct io_uring_cqe *cqe;
 		bool cqe32 = false;
 
-		cqe = &r->cqes[(cq_head & cq_mask)];
+		cqe = &ctx->cqes[(cq_head & cq_mask)];
 		if (cqe->flags & IORING_CQE_F_32 || ctx->flags & IORING_SETUP_CQE32)
 			cqe32 = true;
 		seq_printf(m, "%5u: user_data:%llu, res:%d, flag:%x",
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index be866a8e94bf..9aef41f6ce23 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -745,7 +745,7 @@ static struct io_overflow_cqe *io_alloc_ocqe(struct io_ring_ctx *ctx,
 static bool io_fill_nop_cqe(struct io_ring_ctx *ctx, unsigned int off)
 {
 	if (__io_cqring_events(ctx) < ctx->cq_entries) {
-		struct io_uring_cqe *cqe = &ctx->rings->cqes[off];
+		struct io_uring_cqe *cqe = &ctx->cqes[off];
 
 		cqe->user_data = 0;
 		cqe->res = 0;
@@ -763,7 +763,6 @@ static bool io_fill_nop_cqe(struct io_ring_ctx *ctx, unsigned int off)
  */
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32)
 {
-	struct io_rings *rings = ctx->rings;
 	unsigned int off = ctx->cached_cq_tail & (ctx->cq_entries - 1);
 	unsigned int free, queued, len;
 
@@ -798,7 +797,7 @@ bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32)
 		len <<= 1;
 	}
 
-	ctx->cqe_cached = &rings->cqes[off];
+	ctx->cqe_cached = &ctx->cqes[off];
 	ctx->cqe_sentinel = ctx->cqe_cached + len;
 	return true;
 }
@@ -2760,8 +2759,8 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 int rings_size(unsigned int flags, unsigned int sq_entries,
 	       unsigned int cq_entries, struct io_scq_dim *dims)
 {
-	struct io_rings *rings;
 	size_t off, sq_array_size;
+	size_t cq_size, cqe_size;
 	size_t sqe_size;
 
 	dims->sq_array_offset = SIZE_MAX;
@@ -2769,18 +2768,26 @@ int rings_size(unsigned int flags, unsigned int sq_entries,
 	sqe_size = sizeof(struct io_uring_sqe);
 	if (flags & IORING_SETUP_SQE128)
 		sqe_size *= 2;
+	cqe_size = sizeof(struct io_uring_cqe);
+	if (flags & IORING_SETUP_CQE32)
+		cqe_size *= 2;
 
 	dims->sq_size = array_size(sqe_size, sq_entries);
 	if (dims->sq_size == SIZE_MAX)
 		return -EOVERFLOW;
 
-	off = struct_size(rings, cqes, cq_entries);
+	off = sizeof(struct io_rings);
+	off = L1_CACHE_ALIGN(off);
+	dims->cq_offset = off;
+
+	cq_size = array_size(cqe_size, cq_entries);
+	if (cq_size == SIZE_MAX)
+		return -EOVERFLOW;
+
+	off = size_add(off, cq_size);
 	if (off == SIZE_MAX)
 		return -EOVERFLOW;
-	if (flags & IORING_SETUP_CQE32) {
-		if (check_shl_overflow(off, 1, &off))
-			return -EOVERFLOW;
-	}
+
 	if (flags & IORING_SETUP_CQE_MIXED) {
 		if (cq_entries < 2)
 			return -EOVERFLOW;
@@ -3368,6 +3375,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	struct io_scq_dim *dims = &config->dims;
 	struct io_uring_region_desc rd;
 	struct io_rings *rings;
+	void *ptr;
 	int ret;
 
 	/* make sure these are sane, as we already accounted them */
@@ -3383,9 +3391,12 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	ret = io_create_region(ctx, &ctx->ring_region, &rd, IORING_OFF_CQ_RING);
 	if (ret)
 		return ret;
-	ctx->rings = rings = io_region_get_ptr(&ctx->ring_region);
+	ptr = io_region_get_ptr(&ctx->ring_region);
+	ctx->rings = rings = ptr;
+	ctx->cqes = ptr + config->dims.cq_offset;
+
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		ctx->sq_array = (u32 *)((char *)rings + dims->sq_array_offset);
+		ctx->sq_array = ptr + dims->sq_array_offset;
 
 	memset(&rd, 0, sizeof(rd));
 	rd.size = PAGE_ALIGN(dims->sq_size);
@@ -3504,7 +3515,7 @@ void io_fill_scq_offsets(struct io_uring_params *p, struct io_scq_dim *dims)
 	p->cq_off.ring_mask = offsetof(struct io_rings, cq_ring_mask);
 	p->cq_off.ring_entries = offsetof(struct io_rings, cq_ring_entries);
 	p->cq_off.overflow = offsetof(struct io_rings, cq_overflow);
-	p->cq_off.cqes = offsetof(struct io_rings, cqes);
+	p->cq_off.cqes = dims->cq_offset;
 	p->cq_off.flags = offsetof(struct io_rings, cq_flags);
 	p->cq_off.resv1 = 0;
 	if (!(p->flags & IORING_SETUP_NO_MMAP))
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index f6c4b141a33d..80228c5a843c 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -20,6 +20,7 @@
 struct io_scq_dim {
 	size_t sq_array_offset;
 	size_t sq_size;
+	size_t cq_offset;
 
 	/* Compound array mmap'ed together with CQ. */
 	size_t cq_comp_size;
diff --git a/io_uring/register.c b/io_uring/register.c
index da804f925622..b43a121e2974 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -373,6 +373,7 @@ static int io_register_clock(struct io_ring_ctx *ctx,
 struct io_ring_ctx_rings {
 	struct io_rings *rings;
 	struct io_uring_sqe *sq_sqes;
+	struct io_uring_cqe *cqes;
 
 	struct io_mapped_region sq_region;
 	struct io_mapped_region ring_region;
@@ -439,6 +440,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		return ret;
 
 	n.rings = io_region_get_ptr(&n.ring_region);
+	n.cqes = io_region_get_ptr(&n.ring_region) + dims.cq_offset;
 
 	/*
 	 * At this point n.rings is shared with userspace, just like o.rings
@@ -497,6 +499,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	ctx->rings = NULL;
 	o.sq_sqes = ctx->sq_sqes;
 	ctx->sq_sqes = NULL;
+	o.cqes = ctx->cqes;
+	ctx->cqes = NULL;
 
 	/*
 	 * Now copy SQ and CQ entries, if any. If either of the destination
@@ -522,6 +526,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		/* restore old rings, and return -EOVERFLOW via cleanup path */
 		ctx->rings = o.rings;
 		ctx->sq_sqes = o.sq_sqes;
+		ctx->cqes = o.cqes;
 		to_free = &n;
 		ret = -EOVERFLOW;
 		goto out;
@@ -530,7 +535,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		unsigned src_head = i & (ctx->cq_entries - 1);
 		unsigned dst_head = i & (p.cq_entries - 1);
 
-		n.rings->cqes[dst_head] = o.rings->cqes[src_head];
+		n.cqes[dst_head] = o.cqes[src_head];
 	}
 	WRITE_ONCE(n.rings->cq.head, old_head);
 	WRITE_ONCE(n.rings->cq.tail, tail);
@@ -551,6 +556,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 
 	ctx->rings = n.rings;
 	ctx->sq_sqes = n.sq_sqes;
+	ctx->cqes = n.cqes;
 	swap_old(ctx, o, n, ring_region);
 	swap_old(ctx, o, n, sq_region);
 	to_free = &o;
-- 
2.49.0


