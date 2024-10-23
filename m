Return-Path: <io-uring+bounces-3949-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 242189ACFB8
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:06:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 81A00B25B9A
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 16:01:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3B391CB301;
	Wed, 23 Oct 2024 16:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ifGeNe4w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905961C876D
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 16:01:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729699274; cv=none; b=C+2AK3KaAL+/cxDgnRYu5JRtIMejb6jroCIwkbUUqVlU2f0q7tYqAVOGtaWt0ZLx9VT/RYSjL2uwI1wSLFVA9E0Y7XzqSrfTHkK1ZwR6b7ESx7/qRwJ1jJnqwkngsecmahHW2Mmu2HzboZcicxPYxTQxzK6azkn0j9ylSV8Exs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729699274; c=relaxed/simple;
	bh=ffn4A5dJHuChqOSlXTeXWLXPjx1oLPljZTZL7mZyx/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0PtTqAqSHwwAsOgB3S58A96lFaXuIo7beyvozVpTBW8efPI7G0IcT5QGiCtaLKym5r9IUtUOjLpdYK5nP1FCpD6/c2l5TOi5y8AAD2pxJDggS/Fgnf8eangxgF7ebRfdh9DMiCE+3aAAvgwVTTFSojimPNDcN2ZN/4xy9uMxlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ifGeNe4w; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3a3b98d8a7eso10415ab.3
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 09:01:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729699271; x=1730304071; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FRU5eQ7mI22uFLbOdbG0N7kcRcnthB8G1M5BpYo0PVE=;
        b=ifGeNe4wNf97S8e0J8sRf0v52OV1O0mZTCzdhRNDIUcZRuJm7/HFefrd7IJiZGBSFZ
         4ljRVlHEHpDJFpWbN63I8/XQQRYD53becIMtyNd1Y6AIVKy2a9t9hAopK16fBbwlxNjM
         LWLbt2IA3U+LuDTO0lo1TSJdnRhCVJFeTes47ls2ZgHaOmDD36NBwK9d0G2zhPm6dkuc
         cXbRNg9RhUVCImzs84dFbZtdodjdc9ugAqPgMziz0QvgeUFBeUtRCItR7LXqXIJuQXvY
         l/RLKeRedeeqQ0CO66E6yOMC+DIt9xVzw/o9f/rnZDPeJNYw0JIfTgY27u/BeU77tvrk
         0jzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729699271; x=1730304071;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FRU5eQ7mI22uFLbOdbG0N7kcRcnthB8G1M5BpYo0PVE=;
        b=FXc92RVZO1sT0j+DzRNbrWff5M8lVZoN7VR5cLtSkQZduWCAvlLjG6df9J0QMZ3X70
         kwlZOMw6K/2zSdDNEUMe7P3bWWa1EI/0wVUNIMPAbAKEmgMRtgNPtqU7ZytD4SD+204M
         itnFTWKpzKYYplVf78Ow2rj05WuRe7V/tDH0NP/YBeEnjTBMn8BSVWOQ/wcnA3uIAR0m
         HAU2y+pbWsxKXmS0I0/v0ynjmD7JXNmm8NVw6YZb6YUrMIcPDT05lm5nlmFMk4iJlMTD
         1EulO+rZ6yrskH76EJb4NpS+QgG5HqejDoeJrp4ePU9XGRZV4wwqlGgsm+gPWEJiXnt+
         wo5A==
X-Gm-Message-State: AOJu0YyAlirGgQZoMh94JN7fnDAa6uI6VM53kGCXUhstwvPKeooolLYC
	jTNMM/ip6WJwsF9wLbykui3hDKV8P7wvXQZAns14MNuchp2PT+WXcRr1zE9/FDQRlQA+GLQMwEy
	i
X-Google-Smtp-Source: AGHT+IH6n9GKuqJdMunw7FwklnHMksB6ak96wJOc81PYecyNBTMfVZGYFmioFXwgnOpP3o0TTkgFUQ==
X-Received: by 2002:a05:6e02:20cb:b0:3a3:96c4:29bc with SMTP id e9e14a558f8ab-3a4d59607d1mr31058395ab.11.1729699270751;
        Wed, 23 Oct 2024 09:01:10 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a6301ecsm2115191173.135.2024.10.23.09.01.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 09:01:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/register: add IORING_REGISTER_RESIZE_RINGS
Date: Wed, 23 Oct 2024 09:59:53 -0600
Message-ID: <20241023160105.1125315-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023160105.1125315-1-axboe@kernel.dk>
References: <20241023160105.1125315-1-axboe@kernel.dk>
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
 io_uring/register.c           | 177 ++++++++++++++++++++++++++++++++++
 2 files changed, 180 insertions(+)

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
index 52b2f9b74af8..e38d83c8bbf1 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -29,6 +29,7 @@
 #include "napi.h"
 #include "eventfd.h"
 #include "msg_ring.h"
+#include "memmap.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -361,6 +362,176 @@ static int io_register_clock(struct io_ring_ctx *ctx,
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
+	struct io_ring_ctx_rings o = { }, n = { };
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
+	/* nothing to do */
+	if (p.sq_entries == ctx->sq_entries && p.cq_entries == ctx->cq_entries)
+		return 0;
+	/* properties that are always inherited */
+	p.flags |= (ctx->flags & COPY_FLAGS);
+
+	ret = io_uring_fill_params(p.sq_entries, &p);
+	if (unlikely(ret))
+		return ret;
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
+	 * Now copy SQ and CQ entries, if any. If either of the destination
+	 * rings can't hold what is already there, then fail the operation.
+	 */
+	n.sq_sqes = ptr;
+	tail = ctx->rings->sq.tail;
+	if (tail - ctx->rings->sq.head > p.sq_entries) {
+		io_register_free_rings(&p, &n);
+		return -EOVERFLOW;
+	}
+	for (i = ctx->rings->sq.head; i < tail; i++) {
+		unsigned src_head = i & (ctx->sq_entries - 1);
+		unsigned dst_head = i & n.rings->sq_ring_mask;
+
+		n.sq_sqes[dst_head] = ctx->sq_sqes[src_head];
+	}
+	n.rings->sq.head = ctx->rings->sq.head;
+	n.rings->sq.tail = ctx->rings->sq.tail;
+
+	spin_lock(&ctx->completion_lock);
+	tail = ctx->rings->cq.tail;
+	if (tail - ctx->rings->cq.head > p.cq_entries) {
+		spin_unlock(&ctx->completion_lock);
+		io_register_free_rings(&p, &n);
+		return -EOVERFLOW;
+	}
+	for (i = ctx->rings->cq.head; i < tail; i++) {
+		unsigned src_head = i & (ctx->cq_entries - 1);
+		unsigned dst_head = i & n.rings->cq_ring_mask;
+
+		n.rings->cqes[dst_head] = ctx->rings->cqes[src_head];
+	}
+	n.rings->cq.head = ctx->rings->cq.head;
+	n.rings->cq.tail = ctx->rings->cq.tail;
+	/* invalidate cached cqe refill */
+	ctx->cqe_cached = ctx->cqe_sentinel = NULL;
+
+	n.rings->sq_dropped = ctx->rings->sq_dropped;
+	n.rings->sq_flags = ctx->rings->sq_flags;
+	n.rings->cq_flags = ctx->rings->cq_flags;
+	n.rings->cq_overflow = ctx->rings->cq_overflow;
+
+	/* all done, store old pointers and assign new ones */
+	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
+		ctx->sq_array = (u32 *)((char *)n.rings + sq_array_offset);
+
+	ctx->sq_entries = p.sq_entries;
+	ctx->cq_entries = p.cq_entries;
+
+	swap_old(ctx, o, n, rings);
+	swap_old(ctx, o, n, n_ring_pages);
+	swap_old(ctx, o, n, n_sqe_pages);
+	swap_old(ctx, o, n, ring_pages);
+	swap_old(ctx, o, n, sqe_pages);
+	swap_old(ctx, o, n, sq_sqes);
+	spin_unlock(&ctx->completion_lock);
+
+	io_register_free_rings(&p, &o);
+	return 0;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -549,6 +720,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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


