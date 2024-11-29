Return-Path: <io-uring+bounces-5144-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FED49DE7AF
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 14:34:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 316E92816C3
	for <lists+io-uring@lfdr.de>; Fri, 29 Nov 2024 13:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 75A5819D091;
	Fri, 29 Nov 2024 13:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lbjQISo+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F98219CC27
	for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 13:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732887250; cv=none; b=g6PCvcBzaMShjytio5tpw/2I+X7Lez18r/3xCLiHCsZljotva643Ru0f5CGgACY5ABAXKcFOwhx7c0OjZdiAlbbOT7q6xmCahL6/hJhDQQX+T6377sKd0yePTB3RLxVmf33IdanKYLXy31O42bdt3peP04IPsPmH3Yp4zP1RYwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732887250; c=relaxed/simple;
	bh=wjljwNcWRvSitxAgtefrem368alAIQN9NIxmnK6T4Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YkRBSwW7Zm3myYCr9xz8fFoOa8ZJ1QeM7mKY4J91yDzbilvMc9uoVytCrseIX1hxFfHB4cHh6qrTc4JEjEz2objqCEh1NRns4cCekMDVzpbKWzNp+NCmm9db5eiPQWtTvIY/abshIVJAfWm9SG1vlL+IGtgdzb4bS3hBNOX0t04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lbjQISo+; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a9a0ef5179dso248276266b.1
        for <io-uring@vger.kernel.org>; Fri, 29 Nov 2024 05:34:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732887247; x=1733492047; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uRWpj51Ng8QyzFNY/AhbXswUEoPBYVhTvkzXhDGFp3Y=;
        b=lbjQISo+mzmrYKrv0/FTP3LgDvFH41n1+QNaHTHi0E1rFslI4B/OyKvXNC7G169T63
         knuFvxJSiJsGLceWEl9ppYu54kzT3eaPlUnKOCuJ+tMS/5KT0DNMbW0H/aAhcO3AGjDV
         czW9NYHnwZKmCLXBBE0AoTZHA7YbEiFEsdNNwKMOvZTUd4oeawRMalEv7T3LPKDUROgv
         Uvq8h6So38PZQ/v/syys5G5mlVQxr+TP9C80YI2ejDRrv1xqM95zPToItVgLk38ACYcW
         bLlNyhp/3BCieyCy3VbtVNQVgs1JvK8swyuMrMWK1GSkj3/pzk8I8HqP/MpIv03kCpZ2
         JQ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732887247; x=1733492047;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uRWpj51Ng8QyzFNY/AhbXswUEoPBYVhTvkzXhDGFp3Y=;
        b=kG9rBkpZPG/dXDxo3LVoaaWN2fO95pRRLTPVMKaY4oH8W4P3AFUzxO17pRWoVeyort
         N4Vz2EPhiBPStdztWi5VcljgFyTGQP6yZF8g9VZTU9rX6FH4uqsW/IxzVKmG8OD3Ohun
         8edIxW1JBAjAxIIkWqjGyVCVL1OwjW2UBoBn2Hj8nbKi6loIfSYM+ssUDDyuElK29VKw
         HEWm5mmiL1/FKEQV1AwEakxwXwamR3Pfw7mF4dxiuIJfxKiWHSCd+ShQzdXPYtZS5n83
         kRMf1ATFZqC6sDrCmg33ZA4AX/EQ2gVcjBN0/vg9IukV5MJ7IyahaKFsn7lC749pIs7O
         bNlQ==
X-Gm-Message-State: AOJu0Yxv0CCl/+WLaITDaOy+FGl+fr2v3iqG85ZuvEdvtp+vIVcPSqaL
	ztSxhvNjaLmnilzgzuP5nKWfAIxaoBpJZMSJ1VaL/qWlWy/CcKi3nS93pw==
X-Gm-Gg: ASbGncuwOwXIfKNZsZDHk6RUunLn9aVQcxDMEtTkuLyOFLIG/K6wD++rCigGAPR22Op
	/gJq57dq40gXLOPBzB7YqKdzyhppXE9LHCyphrniMN1afXZyWFwxoM5lrO05xn0duwB32sswF+Z
	iKU0Q0q0R4hCqfl18XVpprgrxmuCoee+HEQslvANK435jYzacqPMhyDT9O+EKYujdbQAkvv37pY
	sRAnb5NZqTuBmzT28XWtNQQARBIzuBUW+1n8QLdneCiWrZCd6heGMcckD7ooYCi
X-Google-Smtp-Source: AGHT+IFYS20YLqPiN5HXdavcMN+ruNsnj7H1ngcSjFAPTMZuJpWAwhaxW8b3D18IakZqH5ezMp3/Fw==
X-Received: by 2002:a17:906:32d7:b0:aa5:30a6:13d3 with SMTP id a640c23a62f3a-aa580f35501mr867463766b.27.1732887246367;
        Fri, 29 Nov 2024 05:34:06 -0800 (PST)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aa5996c2471sm173996866b.13.2024.11.29.05.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Nov 2024 05:34:05 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 13/18] io_uring: use region api for SQ
Date: Fri, 29 Nov 2024 13:34:34 +0000
Message-ID: <1fb73ced6b835cb319ab0fe1dc0b2e982a9a5650.1732886067.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <cover.1732886067.git.asml.silence@gmail.com>
References: <cover.1732886067.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Convert internal parts of the SQ managment to the region API.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |  3 +--
 io_uring/io_uring.c            | 36 +++++++++++++---------------------
 io_uring/memmap.c              |  3 +--
 io_uring/register.c            | 35 +++++++++++++++------------------
 4 files changed, 32 insertions(+), 45 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 4cee414080fd..3f353f269c6e 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -431,10 +431,9 @@ struct io_ring_ctx {
 	 * the gup'ed pages for the two rings, and the sqes.
 	 */
 	unsigned short			n_ring_pages;
-	unsigned short			n_sqe_pages;
 	struct page			**ring_pages;
-	struct page			**sqe_pages;
 
+	struct io_mapped_region		sq_region;
 	/* used for optimised request parameter and wait argument passing  */
 	struct io_mapped_region		param_region;
 };
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index c713ef35447b..2ac80b4d4016 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2637,29 +2637,19 @@ static void *io_rings_map(struct io_ring_ctx *ctx, unsigned long uaddr,
 				size);
 }
 
-static void *io_sqes_map(struct io_ring_ctx *ctx, unsigned long uaddr,
-			 size_t size)
-{
-	return __io_uaddr_map(&ctx->sqe_pages, &ctx->n_sqe_pages, uaddr,
-				size);
-}
-
 static void io_rings_free(struct io_ring_ctx *ctx)
 {
 	if (!(ctx->flags & IORING_SETUP_NO_MMAP)) {
 		io_pages_unmap(ctx->rings, &ctx->ring_pages, &ctx->n_ring_pages,
 				true);
-		io_pages_unmap(ctx->sq_sqes, &ctx->sqe_pages, &ctx->n_sqe_pages,
-				true);
 	} else {
 		io_pages_free(&ctx->ring_pages, ctx->n_ring_pages);
 		ctx->n_ring_pages = 0;
-		io_pages_free(&ctx->sqe_pages, ctx->n_sqe_pages);
-		ctx->n_sqe_pages = 0;
 		vunmap(ctx->rings);
-		vunmap(ctx->sq_sqes);
 	}
 
+	io_free_region(ctx, &ctx->sq_region);
+
 	ctx->rings = NULL;
 	ctx->sq_sqes = NULL;
 }
@@ -3476,9 +3466,10 @@ bool io_is_uring_fops(struct file *file)
 static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 					 struct io_uring_params *p)
 {
+	struct io_uring_region_desc rd;
 	struct io_rings *rings;
 	size_t size, sq_array_offset;
-	void *ptr;
+	int ret;
 
 	/* make sure these are sane, as we already accounted them */
 	ctx->sq_entries = p->sq_entries;
@@ -3514,17 +3505,18 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 		return -EOVERFLOW;
 	}
 
-	if (!(ctx->flags & IORING_SETUP_NO_MMAP))
-		ptr = io_pages_map(&ctx->sqe_pages, &ctx->n_sqe_pages, size);
-	else
-		ptr = io_sqes_map(ctx, p->sq_off.user_addr, size);
-
-	if (IS_ERR(ptr)) {
+	memset(&rd, 0, sizeof(rd));
+	rd.size = PAGE_ALIGN(size);
+	if (ctx->flags & IORING_SETUP_NO_MMAP) {
+		rd.user_addr = p->sq_off.user_addr;
+		rd.flags |= IORING_MEM_REGION_TYPE_USER;
+	}
+	ret = io_create_region(ctx, &ctx->sq_region, &rd, IORING_OFF_SQES);
+	if (ret) {
 		io_rings_free(ctx);
-		return PTR_ERR(ptr);
+		return ret;
 	}
-
-	ctx->sq_sqes = ptr;
+	ctx->sq_sqes = io_region_get_ptr(&ctx->sq_region);
 	return 0;
 }
 
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 9a182c8a4be1..b9aaa25182a5 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -474,8 +474,7 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
 		npages = min(ctx->n_ring_pages, (sz + PAGE_SIZE - 1) >> PAGE_SHIFT);
 		return io_uring_mmap_pages(ctx, vma, ctx->ring_pages, npages);
 	case IORING_OFF_SQES:
-		return io_uring_mmap_pages(ctx, vma, ctx->sqe_pages,
-						ctx->n_sqe_pages);
+		return io_region_mmap(ctx, &ctx->sq_region, vma);
 	case IORING_OFF_PBUF_RING:
 		return io_pbuf_mmap(file, vma);
 	case IORING_MAP_OFF_PARAM_REGION:
diff --git a/io_uring/register.c b/io_uring/register.c
index 5e07205fb071..44cd64923d31 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -368,11 +368,11 @@ static int io_register_clock(struct io_ring_ctx *ctx,
  */
 struct io_ring_ctx_rings {
 	unsigned short n_ring_pages;
-	unsigned short n_sqe_pages;
 	struct page **ring_pages;
-	struct page **sqe_pages;
-	struct io_uring_sqe *sq_sqes;
 	struct io_rings *rings;
+
+	struct io_uring_sqe *sq_sqes;
+	struct io_mapped_region sq_region;
 };
 
 static void io_register_free_rings(struct io_ring_ctx *ctx,
@@ -382,14 +382,11 @@ static void io_register_free_rings(struct io_ring_ctx *ctx,
 	if (!(p->flags & IORING_SETUP_NO_MMAP)) {
 		io_pages_unmap(r->rings, &r->ring_pages, &r->n_ring_pages,
 				true);
-		io_pages_unmap(r->sq_sqes, &r->sqe_pages, &r->n_sqe_pages,
-				true);
 	} else {
 		io_pages_free(&r->ring_pages, r->n_ring_pages);
-		io_pages_free(&r->sqe_pages, r->n_sqe_pages);
 		vunmap(r->rings);
-		vunmap(r->sq_sqes);
 	}
+	io_free_region(ctx, &r->sq_region);
 }
 
 #define swap_old(ctx, o, n, field)		\
@@ -404,11 +401,11 @@ static void io_register_free_rings(struct io_ring_ctx *ctx,
 
 static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 {
+	struct io_uring_region_desc rd;
 	struct io_ring_ctx_rings o = { }, n = { }, *to_free = NULL;
 	size_t size, sq_array_offset;
 	struct io_uring_params p;
 	unsigned i, tail;
-	void *ptr;
 	int ret;
 
 	/* for single issuer, must be owner resizing */
@@ -466,16 +463,18 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		return -EOVERFLOW;
 	}
 
-	if (!(p.flags & IORING_SETUP_NO_MMAP))
-		ptr = io_pages_map(&n.sqe_pages, &n.n_sqe_pages, size);
-	else
-		ptr = __io_uaddr_map(&n.sqe_pages, &n.n_sqe_pages,
-					p.sq_off.user_addr,
-					size);
-	if (IS_ERR(ptr)) {
+	memset(&rd, 0, sizeof(rd));
+	rd.size = PAGE_ALIGN(size);
+	if (p.flags & IORING_SETUP_NO_MMAP) {
+		rd.user_addr = p.sq_off.user_addr;
+		rd.flags |= IORING_MEM_REGION_TYPE_USER;
+	}
+	ret = io_create_region_mmap_safe(ctx, &n.sq_region, &rd, IORING_OFF_SQES);
+	if (ret) {
 		io_register_free_rings(ctx, &p, &n);
-		return PTR_ERR(ptr);
+		return ret;
 	}
+	n.sq_sqes = io_region_get_ptr(&n.sq_region);
 
 	/*
 	 * If using SQPOLL, park the thread
@@ -506,7 +505,6 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	 * Now copy SQ and CQ entries, if any. If either of the destination
 	 * rings can't hold what is already there, then fail the operation.
 	 */
-	n.sq_sqes = ptr;
 	tail = o.rings->sq.tail;
 	if (tail - o.rings->sq.head > p.sq_entries)
 		goto overflow;
@@ -555,9 +553,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	ctx->rings = n.rings;
 	ctx->sq_sqes = n.sq_sqes;
 	swap_old(ctx, o, n, n_ring_pages);
-	swap_old(ctx, o, n, n_sqe_pages);
 	swap_old(ctx, o, n, ring_pages);
-	swap_old(ctx, o, n, sqe_pages);
+	swap_old(ctx, o, n, sq_region);
 	to_free = &o;
 	ret = 0;
 out:
-- 
2.47.1


