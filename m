Return-Path: <io-uring+bounces-10539-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 44290C52546
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 13:52:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0B7B63BE341
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 12:46:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F2BA335094;
	Wed, 12 Nov 2025 12:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ebkGkzeH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6740A3203BE
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 12:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762951580; cv=none; b=M3Q/I7XFS3Yrr5jOvH/ysE02j9Vglkg5uo+l+Dl2wpKnQ+4orOMQZW7QLmvFxM2IUtihig3VcR90POPI7iTubTSkV+Isw3sADqCRXZ0pEAfxMnHwi1VITOInX/i57FBhYoiOb8XlbiaTIjfy7DzCL/eXGxzeAbUjdxcJsAMjLH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762951580; c=relaxed/simple;
	bh=W8qTkKXLzAHqyk2bYxYJzJOhixRyNiDhSEgPbgoSlFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpeZ0Hgrfy67nDY+7/zZPM4AP5uGsRZUQkGuKRYr9aZa6Fjw5aNk+sSDKB+X4Oop+yKhxsvqKsSwskjDZuDsvIl8KrWDOmdCauqhGZN7pW+qcFBdrKSCfm2st9s+/MdULLsKn+AmLyXAkdvOIxpV/PH+yNP431IOWeUT8QLun68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ebkGkzeH; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-47774d3536dso5696325e9.0
        for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 04:46:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762951576; x=1763556376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v9flTJtbf5C7kRhIaKF6Z5bYMnus/Sq89PjFz4011D8=;
        b=ebkGkzeHa3aE/5MeQ+JeTEmi7XPai6PFkLzxoEg9RvAf3EzSn6gAS4ls32fd1fuEq+
         07/+41s0bzRZMt+mhQTmfXUc8Q89XMQAnx9ZG5K/T72J7Hp/Lf3NQ/9ZESMAE/4RZg0E
         pbgYRpjuojoJ+eFXQKXdqzsWTtstqF1XHleTDequMGXaNZkbziU5Sc6uIRntLlWmDSsp
         +H3rcBKYs+KYgOGS/jHQzJqu7q/yGxWNsdTLiOtcvciiMwE8NZFVwv4WFXSB/0CKSfrG
         xb+tGVWUzQMA7k5c9AX3NuNjsDg+M86ADHtAIXnVp8xvKO/GI1VUodxfi/Gk56tD3Hj7
         t1XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762951576; x=1763556376;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=v9flTJtbf5C7kRhIaKF6Z5bYMnus/Sq89PjFz4011D8=;
        b=jHuUi1K1qEhNe4BS2NNp5rHoRgl1hXoOOPj0sqblvVk1R9KoE7BKGM/NJ1SSThSJCx
         od7GYQbzq5qKeTy669J2LyL9cMJIO7NyZsD8s3c6N9E7DLcwlwz+iJc/DpeP5EL+ye//
         Gl/GcvhXCMeIKuBXLNy97onNIYntV3/2+XaTbLAEbSyZljr7KgB5eVZuy8duzj52TaPm
         4dkGR1Pau7QEa0QQQJflrOAU4vkPPIKW7vjKYg2dETHWpausWQbqYPwqiKGSLySMbgDl
         psxaeeUQpminHMpMckMisU/UeFC3jganPFgfxuu7knxh4B4KFj6nce1iyk8oXvr/Atrn
         zroA==
X-Gm-Message-State: AOJu0Yx2ZGxEUKJrqsOm15x4v4xEgvWF5XTiuywcMrx2olvS8rz3If30
	zEMXjd79VxP5uENuMT8DTtVrwJw6UQvcIMizjkQ8s67lvwK0dAzXTn1jsh8/KA==
X-Gm-Gg: ASbGncvvBJBrJeenqlhgMhsYvuG+tM0iiVug1Za263TZYmBgShrqYEvviDjsTag9tx4
	eLhUTH2FuzHZMPDjbxN9USBrobt1VU3q8unA/IeMqxB4HMHmkeVOyIhCgI3N3jHTWMbvJAsa26w
	yhE4+fvgSE2pae4vhqTwfi47mtvAd8O8Wic8eI6g2EngsTOcEBo5l2Otjx9FVLmjJLFHx4SRdSP
	QZAT/Q1YzYa+iZjDpeNW7D71Ge3bCUkLITv2DSAefEinVE9bV+/ywMv9ZLlZI/7b9aFAndCDuJb
	ZSGZmo48wKaL9K1zJw2u2ln6H7XjvcW3SOEnBhRXrozFz8ZYbUdL9BT1VLDgPd/mOPDtQ7gP4kj
	R9ZfB5o5fyYHQ1v6mM5egR0PoxZEw7AzfnCVUuMt940L2YzMq1X5g+CoV5yQ=
X-Google-Smtp-Source: AGHT+IFbjN5WrGNyTA8lG8oRijKxX/NhmWFz5bsqLgJPZE3SQPek5z3tr3ynjCoDIrt4wyRyWlo9cA==
X-Received: by 2002:a05:600c:1989:b0:475:ddad:c3a9 with SMTP id 5b1f17b1804b1-4778732a909mr26100305e9.13.1762951576370;
        Wed, 12 Nov 2025 04:46:16 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2601])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e58501sm33846795e9.10.2025.11.12.04.46.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 04:46:15 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 3/7] io_uring: convert params to pointer in ring reisze
Date: Wed, 12 Nov 2025 12:45:55 +0000
Message-ID: <dc9b2fe38d0e80014e41f1c2f828873247631545.1762947814.git.asml.silence@gmail.com>
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

The parameters in io_register_resize_rings() will be moved into another
structure in a later patch. In preparation to that, convert the params
variable it to a pointer, but still store the data on stack.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/register.c | 48 ++++++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 24 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index afb924ceb9b6..f6b7b1c1be48 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -402,33 +402,33 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	struct io_ring_ctx_rings o = { }, n = { }, *to_free = NULL;
 	size_t size, sq_array_offset;
 	unsigned i, tail, old_head;
-	struct io_uring_params p;
+	struct io_uring_params __p, *p = &__p;
 	int ret;
 
 	/* limited to DEFER_TASKRUN for now */
 	if (!(ctx->flags & IORING_SETUP_DEFER_TASKRUN))
 		return -EINVAL;
-	if (copy_from_user(&p, arg, sizeof(p)))
+	if (copy_from_user(p, arg, sizeof(*p)))
 		return -EFAULT;
-	if (p.flags & ~RESIZE_FLAGS)
+	if (p->flags & ~RESIZE_FLAGS)
 		return -EINVAL;
 
 	/* properties that are always inherited */
-	p.flags |= (ctx->flags & COPY_FLAGS);
+	p->flags |= (ctx->flags & COPY_FLAGS);
 
-	ret = io_uring_fill_params(&p);
+	ret = io_uring_fill_params(p);
 	if (unlikely(ret))
 		return ret;
 
-	size = rings_size(p.flags, p.sq_entries, p.cq_entries,
+	size = rings_size(p->flags, p->sq_entries, p->cq_entries,
 				&sq_array_offset);
 	if (size == SIZE_MAX)
 		return -EOVERFLOW;
 
 	memset(&rd, 0, sizeof(rd));
 	rd.size = PAGE_ALIGN(size);
-	if (p.flags & IORING_SETUP_NO_MMAP) {
-		rd.user_addr = p.cq_off.user_addr;
+	if (p->flags & IORING_SETUP_NO_MMAP) {
+		rd.user_addr = p->cq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
 	}
 	ret = io_create_region(ctx, &n.ring_region, &rd, IORING_OFF_CQ_RING);
@@ -445,20 +445,20 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	 * intent... Use read/write once helpers from here on to indicate the
 	 * shared nature of it.
 	 */
-	WRITE_ONCE(n.rings->sq_ring_mask, p.sq_entries - 1);
-	WRITE_ONCE(n.rings->cq_ring_mask, p.cq_entries - 1);
-	WRITE_ONCE(n.rings->sq_ring_entries, p.sq_entries);
-	WRITE_ONCE(n.rings->cq_ring_entries, p.cq_entries);
+	WRITE_ONCE(n.rings->sq_ring_mask, p->sq_entries - 1);
+	WRITE_ONCE(n.rings->cq_ring_mask, p->cq_entries - 1);
+	WRITE_ONCE(n.rings->sq_ring_entries, p->sq_entries);
+	WRITE_ONCE(n.rings->cq_ring_entries, p->cq_entries);
 
-	if (copy_to_user(arg, &p, sizeof(p))) {
+	if (copy_to_user(arg, p, sizeof(*p))) {
 		io_register_free_rings(ctx, &n);
 		return -EFAULT;
 	}
 
-	if (p.flags & IORING_SETUP_SQE128)
-		size = array_size(2 * sizeof(struct io_uring_sqe), p.sq_entries);
+	if (p->flags & IORING_SETUP_SQE128)
+		size = array_size(2 * sizeof(struct io_uring_sqe), p->sq_entries);
 	else
-		size = array_size(sizeof(struct io_uring_sqe), p.sq_entries);
+		size = array_size(sizeof(struct io_uring_sqe), p->sq_entries);
 	if (size == SIZE_MAX) {
 		io_register_free_rings(ctx, &n);
 		return -EOVERFLOW;
@@ -466,8 +466,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 
 	memset(&rd, 0, sizeof(rd));
 	rd.size = PAGE_ALIGN(size);
-	if (p.flags & IORING_SETUP_NO_MMAP) {
-		rd.user_addr = p.sq_off.user_addr;
+	if (p->flags & IORING_SETUP_NO_MMAP) {
+		rd.user_addr = p->sq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
 	}
 	ret = io_create_region(ctx, &n.sq_region, &rd, IORING_OFF_SQES);
@@ -508,11 +508,11 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	 */
 	tail = READ_ONCE(o.rings->sq.tail);
 	old_head = READ_ONCE(o.rings->sq.head);
-	if (tail - old_head > p.sq_entries)
+	if (tail - old_head > p->sq_entries)
 		goto overflow;
 	for (i = old_head; i < tail; i++) {
 		unsigned src_head = i & (ctx->sq_entries - 1);
-		unsigned dst_head = i & (p.sq_entries - 1);
+		unsigned dst_head = i & (p->sq_entries - 1);
 
 		n.sq_sqes[dst_head] = o.sq_sqes[src_head];
 	}
@@ -521,7 +521,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 
 	tail = READ_ONCE(o.rings->cq.tail);
 	old_head = READ_ONCE(o.rings->cq.head);
-	if (tail - old_head > p.cq_entries) {
+	if (tail - old_head > p->cq_entries) {
 overflow:
 		/* restore old rings, and return -EOVERFLOW via cleanup path */
 		ctx->rings = o.rings;
@@ -532,7 +532,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	}
 	for (i = old_head; i < tail; i++) {
 		unsigned src_head = i & (ctx->cq_entries - 1);
-		unsigned dst_head = i & (p.cq_entries - 1);
+		unsigned dst_head = i & (p->cq_entries - 1);
 
 		n.rings->cqes[dst_head] = o.rings->cqes[src_head];
 	}
@@ -550,8 +550,8 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
 		ctx->sq_array = (u32 *)((char *)n.rings + sq_array_offset);
 
-	ctx->sq_entries = p.sq_entries;
-	ctx->cq_entries = p.cq_entries;
+	ctx->sq_entries = p->sq_entries;
+	ctx->cq_entries = p->cq_entries;
 
 	ctx->rings = n.rings;
 	ctx->sq_sqes = n.sq_sqes;
-- 
2.49.0


