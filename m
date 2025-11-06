Return-Path: <io-uring+bounces-10421-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF502C3CAEB
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:02:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EF484188DB55
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:03:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9DE3B34D4FC;
	Thu,  6 Nov 2025 17:02:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BWn+L6hb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4812834D916
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448537; cv=none; b=YGgHkQn2eDFo7NnmDX0xvIXVUEKGHyrIh98p0PLJyjVSe21CvKsp5RjjsOyBNcy1oskMAJBSiC7MbOn2qst4GJnlnha2CwdHQZP/DBYumAAkZQpHybjFydIyNkMHh3TYJu6Sgl733IObu1Ci3rIOpF3I4LXM5a2d4rO0SGVTaxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448537; c=relaxed/simple;
	bh=F5PWeoEAXinqy5C+ELz+y3tNQCB+Sfw+t4p5dNr9aZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Aq28PGd15yN4vYhRwSlKvXQClR5M2P5Cta+Fx/pkZOB/YB7rvt537NKahsRSmu/wYiD+2WGhtGzzh+z6ws9lucDsC/QekH3M+jOxLq9BFL1bOeXdvR5q8M5/3EewMdUFsOzPi+hEE6+BVgIKV3Qab1v9RPjLlv3tqTdSteBRJNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BWn+L6hb; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-4298b49f103so509030f8f.2
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448532; x=1763053332; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kWS+8gc2OtvVwoeSoaogTSTwXwmZYqF3A5FxncBt1MU=;
        b=BWn+L6hb/d2Zev4ghQuGHHpDbtMHlD4NGeQCnHCXlCzCEJ9qE+MMXuupC7SPnm1FeD
         JRFW3Lguo6As6Uyxu559DtKNJTXGy9LwJfTYvsndl3ju/sDkWR8OW3Oklh3F/zcoBvAn
         B+pX/4LYymAR9mGFv95dXcDnk9KUfdOCCpWhm8nPDYczSOIha7CNRBQh4FGMy/0AEKyx
         NkzRTiDc43VqaqVs5Mruv//0ARNdXBuXqokqEQs1QahXMgQwCL1vCpiuY3vaF+t0RDe4
         CJ4o7c0L/nIxn51CTrjpXpj6uUEpYB7cl9a3arg30H9WqrgBdM6TyvO2k+Yow7wRNa4x
         3gzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448532; x=1763053332;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kWS+8gc2OtvVwoeSoaogTSTwXwmZYqF3A5FxncBt1MU=;
        b=o1j6bm7U8cdYwMxGOEXFKi2sMM5bO07n7tC6xYxWtygxEvOxchCQ/LNM4wDkSGxrfu
         lTziGXCtVwPmYvRwjz+l8hQZsUA7//TSXUfutes+FjBCrjpyMxHwDD+OecmlnoLuxTAA
         PzfpsGbo0MLYFAydMN/jUGY14FHMG4smjHTd3YCaXR4x6LdU9uP4AXNEfM7bFZf+FISX
         vPQu9bRNGxv1QxTLQ2MrsRQNOH1W61M8TPrD1u5wPrzgXSAebdE44fRZlk9hDFOgLwoI
         JvrNZk4LD3aDizd1l0dt75OaWweaSZTPMrudyLvEuPKqq/Zxbqoz1SR4G+iSjmOhoc2y
         SQeA==
X-Gm-Message-State: AOJu0YyMuzjhOWVLhRpMMnn2WP78UIVCnFvJT+2GW+Eonc8oV/sDlABD
	1dTnUbU0rmzmjN9ZlwS54RSvIaJ2dq6mUHucy02S/gRm2bBUgt47+cfdDmA4lg==
X-Gm-Gg: ASbGncvneVbKDRZwCAJC5XJp4K4JOzx9AvUF4ong88CueEYKVHtMHH0BCzJV0GhvMEG
	PR2Eio9ufkTYgqIcngyLXPv3Z4ZJPclzvIZvKkIV6XA8NU9+dpq3tJMZyXqKSNSiF6HhYWi+ubK
	q4YFkpsz5D8JoKKUlGITCzGwiDlZ1WzbtyLANJG/8teD46sM5oyUybuzeSTEPjyuf+jJzV5CG6H
	/20wLjbM/zTR9M7A4dp8cFGCNAXKZyyzCRUNUBveKRMlfZ9+w+dEq39+yoUAlnheX7ZFkk6ONag
	JiEEE1hF1BTbQqIiQRyEY4RW9o0jY4yu8M/5fHPff9IbjtHF09U8K0bt4bz4AtV9E1Qwix7RZaQ
	8BFrHBr2uObXiV1dfFan/zQMCP9TlvdPeFyuDdJq3plRJfsBaA5Nc427ShopfLVGWJLIumi8JSW
	cETNA=
X-Google-Smtp-Source: AGHT+IEydVIFOZY7xxeiaPZjSr0LipP+ahWtzfzQ2edju190Z+D9qWisf4cRLAk6eMc86a/K8ypbGg==
X-Received: by 2002:a05:6000:220d:b0:429:d19f:d926 with SMTP id ffacd0b85a97d-429e32c8201mr7811314f8f.11.1762448531826;
        Thu, 06 Nov 2025 09:02:11 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:11 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 12/16] io_uring: convert pointer init to io_region_slice
Date: Thu,  6 Nov 2025 17:01:51 +0000
Message-ID: <a98d764a5883e116f1f6a3166800db2ba1623b0d.1762447538.git.asml.silence@gmail.com>
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

Use io_region_slice() to initialise ctx ring pointers. The helper
performs bound checks and other sanitisation, which is safer and will be
especially helpful when ring placement gets more complicated in coming
patches. It also extends struct io_scq_dim with all intermediate offsets
and sizes to fully describe rings.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 47 ++++++++++++++++++++++++---------------------
 io_uring/io_uring.h |  2 ++
 2 files changed, 27 insertions(+), 22 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9aef41f6ce23..4f38a0b587fd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2759,9 +2759,7 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 int rings_size(unsigned int flags, unsigned int sq_entries,
 	       unsigned int cq_entries, struct io_scq_dim *dims)
 {
-	size_t off, sq_array_size;
-	size_t cq_size, cqe_size;
-	size_t sqe_size;
+	size_t cqe_size, off, sqe_size;
 
 	dims->sq_array_offset = SIZE_MAX;
 
@@ -2773,18 +2771,18 @@ int rings_size(unsigned int flags, unsigned int sq_entries,
 		cqe_size *= 2;
 
 	dims->sq_size = array_size(sqe_size, sq_entries);
-	if (dims->sq_size == SIZE_MAX)
+	dims->sq_array_size = array_size(sizeof(u32), sq_entries);
+	dims->cq_size = array_size(cqe_size, cq_entries);
+
+	if (dims->sq_size == SIZE_MAX || dims->cq_size == SIZE_MAX ||
+	    dims->sq_array_size == SIZE_MAX)
 		return -EOVERFLOW;
 
 	off = sizeof(struct io_rings);
 	off = L1_CACHE_ALIGN(off);
 	dims->cq_offset = off;
 
-	cq_size = array_size(cqe_size, cq_entries);
-	if (cq_size == SIZE_MAX)
-		return -EOVERFLOW;
-
-	off = size_add(off, cq_size);
+	off = size_add(off, dims->cq_size);
 	if (off == SIZE_MAX)
 		return -EOVERFLOW;
 
@@ -2809,12 +2807,7 @@ int rings_size(unsigned int flags, unsigned int sq_entries,
 	}
 
 	dims->sq_array_offset = off;
-
-	sq_array_size = array_size(sizeof(u32), sq_entries);
-	if (sq_array_size == SIZE_MAX)
-		return -EOVERFLOW;
-
-	if (check_add_overflow(off, sq_array_size, &off))
+	if (check_add_overflow(off, dims->sq_array_size, &off))
 		return -EOVERFLOW;
 
 	dims->cq_comp_size = off;
@@ -3375,7 +3368,6 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	struct io_scq_dim *dims = &config->dims;
 	struct io_uring_region_desc rd;
 	struct io_rings *rings;
-	void *ptr;
 	int ret;
 
 	/* make sure these are sane, as we already accounted them */
@@ -3391,12 +3383,19 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	ret = io_create_region(ctx, &ctx->ring_region, &rd, IORING_OFF_CQ_RING);
 	if (ret)
 		return ret;
-	ptr = io_region_get_ptr(&ctx->ring_region);
-	ctx->rings = rings = ptr;
-	ctx->cqes = ptr + config->dims.cq_offset;
 
-	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		ctx->sq_array = ptr + dims->sq_array_offset;
+	ctx->rings = io_region_slice(&ctx->ring_region, 0, sizeof(struct io_rings));
+	ctx->cqes = io_region_slice(&ctx->ring_region, dims->cq_offset, dims->cq_size);
+	if (!ctx->rings || !ctx->cqes)
+		return -EFAULT;
+
+	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY)) {
+		ctx->sq_array = io_region_slice(&ctx->ring_region,
+						dims->sq_array_offset,
+						dims->sq_array_size);
+		if (!ctx->sq_array)
+			return -EFAULT;
+	}
 
 	memset(&rd, 0, sizeof(rd));
 	rd.size = PAGE_ALIGN(dims->sq_size);
@@ -3409,8 +3408,12 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 		io_rings_free(ctx);
 		return ret;
 	}
-	ctx->sq_sqes = io_region_get_ptr(&ctx->sq_region);
 
+	ctx->sq_sqes = io_region_slice(&ctx->sq_region, 0, dims->sq_size);
+	if (!ctx->sq_sqes)
+		return -EFAULT;
+
+	rings = ctx->rings;
 	memset(rings, 0, sizeof(*rings));
 	WRITE_ONCE(rings->sq_ring_mask, ctx->sq_entries - 1);
 	WRITE_ONCE(rings->cq_ring_mask, ctx->cq_entries - 1);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 80228c5a843c..ed57ab4161db 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -19,8 +19,10 @@
 
 struct io_scq_dim {
 	size_t sq_array_offset;
+	size_t sq_array_size;
 	size_t sq_size;
 	size_t cq_offset;
+	size_t cq_size;
 
 	/* Compound array mmap'ed together with CQ. */
 	size_t cq_comp_size;
-- 
2.49.0


