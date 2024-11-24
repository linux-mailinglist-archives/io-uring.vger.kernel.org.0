Return-Path: <io-uring+bounces-5020-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6B899D7843
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 22:12:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4B464B2230C
	for <lists+io-uring@lfdr.de>; Sun, 24 Nov 2024 21:12:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD39313FD72;
	Sun, 24 Nov 2024 21:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QRbEM1Tq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD04156960
	for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 21:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732482740; cv=none; b=Q+zFOWZMu+YuxH12HZrWQJSl+sAnQ/fzYd8Fb5/RY7YjAZyPjGXsfFAz1llx3JGi5gOfyIoSON/Oq3Dd3DJomOwYRfOcOXhuixIaw7H4CzfaL9K0LHBnAy50JqvccD9pFK4bukmMDgxtgGI7+M+q6uiSrGPQnaVSRZEKBGpkR2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732482740; c=relaxed/simple;
	bh=7SPNydoRvUkf5XyAMfTHZ15KufbLOiwBoh4vK3N7Os0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioXoLCaqnrII7vPfdfZhS1d3AawkyW9yRZN2HRqXk8dp1N85Yf9vjiKap7C04M+glFtQyki794NvnzZDqJxc9Gh6YiJTL4mB52leKOhbtP09lk805bMkvYIw5ljjSHpL1RVPD3zL2K27wjAkMe9Dm/HQ/aN6U0xzmUGGJ7GHgmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QRbEM1Tq; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4314fa33a35so33371075e9.1
        for <io-uring@vger.kernel.org>; Sun, 24 Nov 2024 13:12:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1732482737; x=1733087537; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6Wvr3o9uNStf39InzwsOAPQ7rRYdvVvlqZ6yOr6JckQ=;
        b=QRbEM1TqjeoQMi3oUIO4mMHfaG8xIllldExzT7khbszsPJf75yU6bfQEjmQ44OTmPI
         z9vPNhZumDmUratPUL8PuyA0FrE1XZPqlN4ZD6v0JmlF2YGqWevsAyrfARIJebBE4Cbu
         x6oFKZaDIwctkoN7xz/GwWDAyDhJM73Ph44sLwgBXLZzikB5ql4vftYFmmeVfCHKnlj/
         0RxiomUsg7KalY5uc8GEkw3RvEUN/cDMt1N7KRXyhNT63tdSOvGWdgmppu1IF6BB0A3j
         dO9DUPnMFkk2bwK6m9MXO/PMDue1kWqnAjsVRRoaIofw2+XGFdGPZsAHW9SvN6cYVdUV
         v40A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732482737; x=1733087537;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6Wvr3o9uNStf39InzwsOAPQ7rRYdvVvlqZ6yOr6JckQ=;
        b=rA2C0MIP4WyF0OzleLQaEaTfOvtEo5rswsCMI5t+tKvpZvuGK10sem1H6s9eEb9wbW
         UDaqafcpTVK6K8Zj8k+30NqIce13qkmUmv8CWu9vMv+rPeihAhevkvpnntexytfEtthU
         Dowm8fPEAa3B4X9qLiYmMs2BNXka8ze2/T99oITDxoXEMpOAbQXCHg294KTos5poLJCP
         BCf00Lw/yFMpSSlssr+Id8WQRJhx/RN4KwduOlWCW3S1kQKeY9So63QhOH9k6uTrcZD+
         FXj3CzUJ2Hms/T98BYMCOfQIMKkEKRN6t6D2eudq/SvhGuJ5peDVCnRd4asTGm0uuFfJ
         8/4Q==
X-Gm-Message-State: AOJu0YyC4ndqqLDa4OYrJfjcLjh+NIh+wrBU1dJ73n6X2A1YrPa1kyHf
	RT49X4i3w5WxulDiTut6koDbzlCm7FEryJik6zBh9vyANDP/RMxrqxRL2w==
X-Gm-Gg: ASbGncsLdCzF9Ew1RGPnl9VYvmcBsz7EUmQfY4Hc4bziU26i/x5OfXiXg4Rul8GRIAX
	wNBak06+W9XoQRwpgv7m1HnozJn/e1PPq+h4+vKpN6ssDlblvqZqMpuFPDoKtTycOFsbwg+D6C8
	X7lSDPXjBOT4b8bxJF9G1QVhPpe1ueGOB/UHAQmryz2NAP+frvMzOOy2Q+wnhegsoVBklVqA/Py
	3OTtqYzM5/k7OpVXmJ6FvfZSjIY9WuVPZqH8fT2q4qQBiE7/NbrXGYvQQn11tg=
X-Google-Smtp-Source: AGHT+IGqoWWD9AK+T8U7StDPyBVwYbDd9ZDsh1V5noeYDrkyuX6hk8DjVPL7e7LeOJGK4aQ1KBtXjQ==
X-Received: by 2002:a05:600c:1da6:b0:434:9e17:18e5 with SMTP id 5b1f17b1804b1-4349e171d04mr19786475e9.0.1732482737272;
        Sun, 24 Nov 2024 13:12:17 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.235.224])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432f643b299sm132733745e9.0.2024.11.24.13.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Nov 2024 13:12:16 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v2 13/18] io_uring: use region api for SQ
Date: Sun, 24 Nov 2024 21:12:30 +0000
Message-ID: <0b85236173823848fa6207110e74914e5dba47e8.1732481694.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1732481694.git.asml.silence@gmail.com>
References: <cover.1732481694.git.asml.silence@gmail.com>
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
index fee3b7f50176..a1dca7bce54a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2633,29 +2633,19 @@ static void *io_rings_map(struct io_ring_ctx *ctx, unsigned long uaddr,
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
@@ -3472,9 +3462,10 @@ bool io_is_uring_fops(struct file *file)
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
@@ -3510,17 +3501,18 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
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
index 5d971ba33d5a..0a2d03bd312b 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -464,8 +464,7 @@ __cold int io_uring_mmap(struct file *file, struct vm_area_struct *vma)
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
2.46.0


