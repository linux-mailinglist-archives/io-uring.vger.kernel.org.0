Return-Path: <io-uring+bounces-3887-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 999C49A960C
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 04:12:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AD6EE28365D
	for <lists+io-uring@lfdr.de>; Tue, 22 Oct 2024 02:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 63F6812B176;
	Tue, 22 Oct 2024 02:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="27/dbg11"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28DFA132114
	for <io-uring@vger.kernel.org>; Tue, 22 Oct 2024 02:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729563133; cv=none; b=JPau3zWicL/5x4KkmN7UsFDrmsEUH1lagJLrJ6PHWZ6iUkK3PVuIqD9H8vV0kfg8p/o+rO9KNXaG2W/eTjiTUrbjSPxphZOgjTL8scrNDHQjL06R8X2KLn/zUzXavpU/DJSpI/h0GgSkKLSSqDkyjbM2KusLnL5rocNKRyvTLdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729563133; c=relaxed/simple;
	bh=AT6C9bAkcS+mJ74Sh7lR2VhIyhVOU3KSbJOjgyqCdM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mna7m/xPBQV4JWWBIK6DAs61RoNNtVblUsnWyBb+vzTjopMWyXJWhAaZQzbXzub6rPBTLHmKlboXf2a7R2RgwQSRN3PNbxuOtPEd2HfcFPXVkFRq9oPfWQUA3mQVXV5KvGyqK3K/j/PTRcjHly5OtQkVPIrPoOm/VJEtrHTYPhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=27/dbg11; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-71e79f73aaeso3599876b3a.3
        for <io-uring@vger.kernel.org>; Mon, 21 Oct 2024 19:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729563130; x=1730167930; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rg14Ct7WiGxTZjBJ8Oh4faNSA+nGmRSrSXC7j54ZInk=;
        b=27/dbg11k37O4hw597Wxl7Ug0xhIOTWEBi9jPP84HTQxB+JwEgQOSXFJ0oCjGuWe/m
         6dhCVhndEBrb6ACHlrtKV/j2HmnssY+DsbrtrbI6GesqNGZqnQsMEKUoDfKm0agQVBLD
         vqfUPHEnQ0iaiGK445PIGJmnXAl40DiXpKe6CfXtlyardrcWDQXQ0d64rGei+dXA8VbE
         48swAiW5HHZS2Zx3m9iwLYB4pq7AZW+gEAEZoJ2rvnH8OLK1c0aPwATyc6Al4qiHoUzn
         Q3BGHkRoAceNw/5hQEwu+K5utk80WIG+VIgRUiro1wgm2G5WaUh84640AvbgSbfbaUVS
         kOQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729563130; x=1730167930;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rg14Ct7WiGxTZjBJ8Oh4faNSA+nGmRSrSXC7j54ZInk=;
        b=PWjBU3grp5JWRfHRk+ztrp0cLRFBlhPsaPICRkjxOPDoUj5EXPa7cmwUXuk4eu/HAR
         AiyvotTUJFJ5gFDvIT5JLTDdrGMVeMhAd6YVGrjW+zFkSe4cE7VbfUDObWrdkov/123I
         Uzm+Dj0GLDGCtAPRMjD6KAX9C/WCaX5+3H3/5yJP5kzHuRwjvsN2wyZfvrlAr0j9uSdw
         vHqXraV0Z/L1IdhB9gsmXxxuKiXGhMooP1IbP6vLTDHN0TEV4ov7GHs2Z//a09YlFUbV
         t/VXtdV/b5W5cGB/mC/3BjClq9jkN0znuWK9bFc+hCC6X4SYGU8ycD2eYw9X7d3Pm0HI
         R5yA==
X-Gm-Message-State: AOJu0YxqHehK8As1mbwLd/J8340lOGo8Djphv8cGK1lAEH3dkHzgZJ9a
	EfQCtgFN+lI2hT3ZIEl0WJLmCddoHJLb/jZ/6wonC0HJccFqL/JeLp0if8VEIDGApljqBAwEZYJ
	K
X-Google-Smtp-Source: AGHT+IHNEv3h3osUtHxKDjNedYthFBAB/6y0Bn3B+shh1EhI5de4WS0eyhRVmwmm8zewNkevW+PBIg==
X-Received: by 2002:a05:6a21:1693:b0:1d8:f679:ee03 with SMTP id adf61e73a8af0-1d92c5100abmr19207305637.27.1729563129845;
        Mon, 21 Oct 2024 19:12:09 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71ec131477asm3747060b3a.10.2024.10.21.19.12.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2024 19:12:08 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/register: add IORING_REGISTER_RESIZE_RINGS
Date: Mon, 21 Oct 2024 20:08:30 -0600
Message-ID: <20241022021159.820925-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241022021159.820925-1-axboe@kernel.dk>
References: <20241022021159.820925-1-axboe@kernel.dk>
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
process. Any register op holds ->uring_lock, which prevents new
submissions, and the internal mapping holds the completion lock as well
across moving CQ ring state.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |   3 +
 io_uring/register.c           | 161 ++++++++++++++++++++++++++++++++++
 2 files changed, 164 insertions(+)

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
index 52b2f9b74af8..8dfe46a1cfe4 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -29,6 +29,7 @@
 #include "napi.h"
 #include "eventfd.h"
 #include "msg_ring.h"
+#include "memmap.h"
 
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
@@ -361,6 +362,160 @@ static int io_register_clock(struct io_ring_ctx *ctx,
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
+	/* now copy entries, if any */
+	n.sq_sqes = ptr;
+	tail = ctx->rings->sq.tail;
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
@@ -549,6 +704,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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


