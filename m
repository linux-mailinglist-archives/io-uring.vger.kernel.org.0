Return-Path: <io-uring+bounces-10541-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id B6D39C52537
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 13:51:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id D01344F7C7C
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 12:46:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 897AE31326C;
	Wed, 12 Nov 2025 12:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZPGCJjb5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17BB32BF31
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 12:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762951582; cv=none; b=oELIvIPWh4XvEQfQ5guI/J69oCaD6aMGKlv2h3UtmZ9+dtIHG1aFZFmkG6nR4g71+z8K41FF9mk477ObFTD+T3z49jiAFsDVx4Xo4KrwBKXOI6Pj2Jm8o+xYwBnO6JreEJ5pgp2673a0l/YKZBzygxehwRvYcjvWxL1YCCaWQ4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762951582; c=relaxed/simple;
	bh=VYT4pyHeC320qi7kTSzX9+pOEgvo5Fjyjq8D5jTw3EA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eS3UXCEqhTEZmZzQ6+C0CqzgqNVbrOCAeYzCL+wKsUbA8V2oGCvA0CXQDXIR/aps4G1uRLFpfbI7a+WFt+J3YQlt4KNS5U7d/zJ4CeMqxD0zjHbMq5mkmJ487mzHcPEyX8X5Ri4BnK7pIBglQrCXVuydGse9meFnV06e1UlmJiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZPGCJjb5; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47777000dadso5576895e9.1
        for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 04:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762951579; x=1763556379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0UjxzCssV7DuTNViezWRx7rcS3+eTs3EVxwlL7So8dU=;
        b=ZPGCJjb5oEPGgUvPV25pGjYkep84Q6oBd/TgMBDt5MttX/aHDtt9FfIoYQYk+/Q+aN
         oy036lvUiMAS3iA+qKN7X4y4pHWmTWk60CjUSdSfx2NvmTHPBSW1dA7kQmkvzqj8Rd0b
         WVf7Qf9A9p63mm7gKyhr6UAre3zu5lX1GMQnJwSjYMuKqSrf8CN7ibkTYM7z3eo4mCIZ
         RIQi9mK276mJiWBuSXzOKgL1zze8wCbIuWqEv5ptPTPR2DY8O0HRRG40dve9JJpJYyrh
         qhe7L5ys9LqQPlbSwNlCL2agfVfQPxz15l/cr4elE3I615nuDjVU+KvLh/PjMlAyS1X6
         E+qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762951579; x=1763556379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=0UjxzCssV7DuTNViezWRx7rcS3+eTs3EVxwlL7So8dU=;
        b=f31oEqJEJHCCW6MhsNoNQmfsP0qWmRiQaHTFNNB9mcp0iAbglMJqlhHH1a+PMmY61V
         IRqZvT2DayWJhN23ksivf9q5y7ir6MGawmxlG1V2R4chhk+uwIKqEvD+PVG8AupK4wSY
         F1Lg2C5Tnly8OKENYELSieKOMAa54MBHYhC3LoaytSb1Zs1qS7BH34Ruc1gkgVv5Rl6M
         SCVIf5ZipVpZDbl3Os7CJGZX7YMIia7LP+oRie2mK3RAJEWe1jLdBW1Mfao+HzynBiJH
         l+VAFaujiEek8pj/lqFXj/iwcwSu1ojVOgXkoqMmlHFH3Mdceztbly0KT020a1JKPyEq
         ib2g==
X-Gm-Message-State: AOJu0Yy6GOP5ifEj1zy2kPLiLI/+wXus/+GcBl3ALYhwu73Ic23Zubn3
	vbM3YzEypOtguqqOgs+drDe4RmbyPXSUxthO6buwqhST8yEW+GHh/mTnzG/O6A==
X-Gm-Gg: ASbGnctrM9AkJOIIIamaDQhiFrRMPRTejJOmjVKWah0dZ/6wXeRBOTtLbHizimRi2Pz
	aIJz1sxwS6ZzrB5JNWFDTKU3OBfVLcgWVOLOOA2T5kZXn6aRZyHVwjb0sDBj7jF9s0/xHmLTABV
	QwKrUOxcSYLrboZBRVYCaUC7W2H5ORYEDgSl1KbtWN0OKV9ohgMwXk4RDhrBa9Hhx58CNptBLWd
	U+M8XDUv8sCSZ+gpClvFHL7eWUev9WTgMTgUcLgIXlXLvTpMPh36eNGPeUEHOQFOQK7IFotwAFM
	F33i7nVlu86436dWF3vryljhzadkcg8q92bbVsI2Z4wcDA5ifHJ/tumnJ5nrZeYpE0J5JCCZoUm
	zf7UPRl2xiKcCmr+mz0LxlSU/0QupfBxbIxEAxHnZQhIrKXHrWxe122nwWT0=
X-Google-Smtp-Source: AGHT+IG4OvlE88BiqvXUKAY50p1yLhmQck/l8VF9DLnnn7eVAvpOl88sGkDZf3QF95pch9CVl6NCFQ==
X-Received: by 2002:a05:600c:4753:b0:477:f1f:5c65 with SMTP id 5b1f17b1804b1-477870862d5mr23344215e9.23.1762951578297;
        Wed, 12 Nov 2025 04:46:18 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2601])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e58501sm33846795e9.10.2025.11.12.04.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 04:46:17 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 5/7] io_uring: keep ring laoyut in a structure
Date: Wed, 12 Nov 2025 12:45:57 +0000
Message-ID: <9033e77c3fc31f2c82efdf1fbf57b7549ea2b934.1762947814.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762947814.git.asml.silence@gmail.com>
References: <cover.1762947814.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a structure keeping SQ/CQ sizes and offsets. For now it only records
data previously returned from rings_size and the SQ size.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 54 +++++++++++++++++++++++----------------------
 io_uring/io_uring.h | 12 ++++++++--
 io_uring/register.c | 24 ++++++--------------
 3 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index f039e293582a..1dfd0a8a7270 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2757,47 +2757,57 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 	ctx->sq_sqes = NULL;
 }
 
-unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
-			 unsigned int cq_entries, size_t *sq_offset)
+int rings_size(unsigned int flags, unsigned int sq_entries,
+		unsigned int cq_entries, struct io_rings_layout *rl)
 {
 	struct io_rings *rings;
+	size_t sqe_size;
 	size_t off;
 
-	*sq_offset = SIZE_MAX;
-
 	if (flags & IORING_SETUP_CQE_MIXED) {
 		if (cq_entries < 2)
-			return SIZE_MAX;
+			return -EOVERFLOW;
 	}
 	if (flags & IORING_SETUP_SQE_MIXED) {
 		if (sq_entries < 2)
-			return SIZE_MAX;
+			return -EOVERFLOW;
 	}
 
+	rl->sq_array_offset = SIZE_MAX;
+
+	sqe_size = sizeof(struct io_uring_sqe);
+	if (flags & IORING_SETUP_SQE128)
+		sqe_size *= 2;
+
+	rl->sq_size = array_size(sqe_size, sq_entries);
+	if (rl->sq_size == SIZE_MAX)
+		return -EOVERFLOW;
+
 	off = struct_size(rings, cqes, cq_entries);
 	if (flags & IORING_SETUP_CQE32)
 		off = size_mul(off, 2);
 	if (off == SIZE_MAX)
-		return SIZE_MAX;
+		return -EOVERFLOW;
 
 #ifdef CONFIG_SMP
 	off = ALIGN(off, SMP_CACHE_BYTES);
 	if (off == 0)
-		return SIZE_MAX;
+		return -EOVERFLOW;
 #endif
 
 	if (!(flags & IORING_SETUP_NO_SQARRAY)) {
 		size_t sq_array_size;
 
-		*sq_offset = off;
+		rl->sq_array_offset = off;
 
 		sq_array_size = array_size(sizeof(u32), sq_entries);
 		off = size_add(off, sq_array_size);
 		if (off == SIZE_MAX)
-			return SIZE_MAX;
+			return -EOVERFLOW;
 	}
 
-	return off;
+	rl->rings_size = off;
+	return 0;
 }
 
 static __cold void __io_req_caches_free(struct io_ring_ctx *ctx)
@@ -3346,28 +3356,20 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 					 struct io_uring_params *p)
 {
 	struct io_uring_region_desc rd;
+	struct io_rings_layout __rl, *rl = &__rl;
 	struct io_rings *rings;
-	size_t sq_array_offset;
-	size_t sq_size, cq_size, sqe_size;
 	int ret;
 
 	/* make sure these are sane, as we already accounted them */
 	ctx->sq_entries = p->sq_entries;
 	ctx->cq_entries = p->cq_entries;
 
-	sqe_size = sizeof(struct io_uring_sqe);
-	if (p->flags & IORING_SETUP_SQE128)
-		sqe_size *= 2;
-	sq_size = array_size(sqe_size, p->sq_entries);
-	if (sq_size == SIZE_MAX)
-		return -EOVERFLOW;
-	cq_size = rings_size(ctx->flags, p->sq_entries, p->cq_entries,
-			  &sq_array_offset);
-	if (cq_size == SIZE_MAX)
-		return -EOVERFLOW;
+	ret = rings_size(ctx->flags, p->sq_entries, p->cq_entries, rl);
+	if (ret)
+		return ret;
 
 	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(cq_size);
+	rd.size = PAGE_ALIGN(rl->rings_size);
 	if (ctx->flags & IORING_SETUP_NO_MMAP) {
 		rd.user_addr = p->cq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
@@ -3378,10 +3380,10 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	ctx->rings = rings = io_region_get_ptr(&ctx->ring_region);
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
+		ctx->sq_array = (u32 *)((char *)rings + rl->sq_array_offset);
 
 	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(sq_size);
+	rd.size = PAGE_ALIGN(rl->sq_size);
 	if (ctx->flags & IORING_SETUP_NO_MMAP) {
 		rd.user_addr = p->sq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index d8bc44acb9fa..5e544c2d27c8 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -17,6 +17,14 @@
 #include <trace/events/io_uring.h>
 #endif
 
+struct io_rings_layout {
+	/* size of CQ + headers + SQ offset array */
+	size_t rings_size;
+	size_t sq_size;
+
+	size_t sq_array_offset;
+};
+
 struct io_ctx_config {
 	struct io_uring_params p;
 	struct io_uring_params __user *uptr;
@@ -139,8 +147,8 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 #define IORING_MAX_ENTRIES	32768
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
 
-unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
-			 unsigned int cq_entries, size_t *sq_offset);
+int rings_size(unsigned int flags, unsigned int sq_entries,
+		unsigned int cq_entries, struct io_rings_layout *rl);
 int io_prepare_config(struct io_ctx_config *config);
 
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32);
diff --git a/io_uring/register.c b/io_uring/register.c
index 13385ac0f85a..98693021edbe 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -401,9 +401,9 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	struct io_ctx_config config;
 	struct io_uring_region_desc rd;
 	struct io_ring_ctx_rings o = { }, n = { }, *to_free = NULL;
-	size_t size, sq_array_offset;
 	unsigned i, tail, old_head;
 	struct io_uring_params *p = &config.p;
+	struct io_rings_layout __rl, *rl = &__rl;
 	int ret;
 
 	memset(&config, 0, sizeof(config));
@@ -423,13 +423,12 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (unlikely(ret))
 		return ret;
 
-	size = rings_size(p->flags, p->sq_entries, p->cq_entries,
-				&sq_array_offset);
-	if (size == SIZE_MAX)
-		return -EOVERFLOW;
+	ret = rings_size(p->flags, p->sq_entries, p->cq_entries, rl);
+	if (ret)
+		return ret;
 
 	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(size);
+	rd.size = PAGE_ALIGN(rl->rings_size);
 	if (p->flags & IORING_SETUP_NO_MMAP) {
 		rd.user_addr = p->cq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
@@ -458,17 +457,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		return -EFAULT;
 	}
 
-	if (p->flags & IORING_SETUP_SQE128)
-		size = array_size(2 * sizeof(struct io_uring_sqe), p->sq_entries);
-	else
-		size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
-	if (size == SIZE_MAX) {
-		io_register_free_rings(ctx, &n);
-		return -EOVERFLOW;
-	}
-
 	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(size);
+	rd.size = PAGE_ALIGN(rl->sq_size);
 	if (p->flags & IORING_SETUP_NO_MMAP) {
 		rd.user_addr = p->sq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
@@ -551,7 +541,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 
 	/* all done, store old pointers and assign new ones */
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		ctx->sq_array = (u32 *)((char *)n.rings + sq_array_offset);
+		ctx->sq_array = (u32 *)((char *)n.rings + rl->sq_array_offset);
 
 	ctx->sq_entries = p->sq_entries;
 	ctx->cq_entries = p->cq_entries;
-- 
2.49.0


