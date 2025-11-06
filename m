Return-Path: <io-uring+bounces-10424-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id F10C9C3CADF
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:02:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 76AF7344BF1
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51A3022128D;
	Thu,  6 Nov 2025 17:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MctHaipr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AD4734DB74
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448541; cv=none; b=N2Tj9lGTXTfqNLr4Byxhvm/kj+iKqu7r5Lyi/fDAjHDMSRshalNvs75wbUX+ufZk1RCPNK4ZFU6jG8Yk9zmASu5k04KyHOi3ddNXodQBqocmQPd6H66INWc6CE1SIi+jhbQN/bEqwNSVjp5RSu0IwXee534IDCx/AuJ0ApVzeo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448541; c=relaxed/simple;
	bh=+bTSZPP6sdr+OzjUP9AtH9dZy9iW8oO4w6zocC1aaFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EihpIrp7q+g+XVZBQJuKyf568PN7/c1RBA1wYWQecX5L4m/klpqXkbBbR2F9L7CR9TUW4aIcxm8M7g+YXBnnKUzvAybADw/ZR69ZI8Fc9G26YQefQHEFphpL+gkJHW6OrlVsz5CXX+thJ469Rdm6MyQB+2KD5IeXCdoXq8P1qrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MctHaipr; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-429c7f4f8a2so1268253f8f.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448537; x=1763053337; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xpgEy77x0i3lqwKm7vOcKQ/M+iw9kPYiq7Ylob8IZHk=;
        b=MctHaipryyslnmxj2wmR9kuPoJDjhWqEcKvT+2Q6ko46JGM8+HIP3Ke3oiDyW04TEy
         mn4beLeaOMGTfniYVj1j9HRTDSJxzkoBMCiFnf5a+FFhRB00CV4PMigm4M4Zmi4EW68x
         IrdCeiLSiYfesdlwqv9t4u6oIw4UUm0BrSWMZaHVInGOlwU89E/woJgOloKAgqxBQimA
         3uTxxKp4m+g0QcJER0jc28JD4Z9iCY3KbywUc0OTUhCBx0d4e+sSmXrrme5vAB3W0Eyx
         HJRxHwOO9DcyBg/avk2FGl3438hDooY+i2ghfFVKpuL0W1lArY+wLnCneW+4dGbpzvZO
         cRHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448537; x=1763053337;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xpgEy77x0i3lqwKm7vOcKQ/M+iw9kPYiq7Ylob8IZHk=;
        b=sfZED2oVV8DF+YUS71mlGcNn7tcqyy8Zo+fttxYw+BTsiGjkkI4yP04lAjVeFdFOAV
         r675/NPCp3fUz/0nutQZjjh8aVcmsVS5rHPeNjl96DsvbOQQ3+unbGR0qZU/ZjdzuEEi
         Pr86M1qOjVpxhFKj5xUR7XKWZIq1gANKtdR0TcsprrZZ8kxRD+C4SwgB2BS/9oDSkLwh
         QOfKmhzZL2gIL2txIJE1qTvRMPF/EQI6mCGmV446noB26uAX/h2iJMwlcSGWjUIW2IWY
         MCMRQLrTSrxxflX7zcUiookS2oBNZXWxe/zmvMkkdC76lux6YCjnwbTPNXwGNvyV5/Sd
         E7Qw==
X-Gm-Message-State: AOJu0YwCTR/aBaOvVE7/uH7depmCwWU1nQoS3WlVfcnuMYbq4LBCeFb4
	mMFhzvwckU2RIlhmLjeYX3P/V+W02kL0gRx8XP0rpJOmrZzgkWp/WvbE5gcImw==
X-Gm-Gg: ASbGncuDi01KHaJmUn3pkn6kWW6QKY6gtPgY8XJNSLXQeMNwmDDcM1OYCLGEtFbHLMF
	FBzuLGh9p6pyq8AL+N9eSyN3HLeTWBE2paWRN1iDrMRcVtHXJB/6e5PnVA8lNtrPha7C3Zj8arX
	RYj2/pK/w6xd/CMLawAJg4mry8otp1yUICOWhQNWKzKl72FaDIU5kktet+kSKJ0+J97/0Pv6u/G
	/IhVRiQPwO2220Mw7UCi0abT6wFUb4bkYGKBMnWV5tkMQ8Y2vzLL44dFXk/aXTAVlvk0UQxZYn4
	8bwLiVUE63A/lVGv3JyU1aiOnKmc9/XLriizuVfmVR+BMPT7NQ/T88gCJpp3ZQaVJB4L6wiN4sq
	cWwGq00UGj7GocIBIwVt0G5KjSGrHTemX7D8sOS5v1uw6mukvGKT7j11U0Mq2iNAJyRFb4smBHL
	tRRKo=
X-Google-Smtp-Source: AGHT+IFjK5NGlI31wsLL5C1vic4sVCSaRVNG0Y+9yLIt2jkYU9gKWkWwajSW/esvUnvDQ3c3H8PUtw==
X-Received: by 2002:a05:6000:1ac9:b0:429:c15f:806d with SMTP id ffacd0b85a97d-429eb19d765mr3993801f8f.16.1762448536073;
        Thu, 06 Nov 2025 09:02:16 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:15 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 16/16] io_uring: introduce SCQ placement
Date: Thu,  6 Nov 2025 17:01:55 +0000
Message-ID: <e63c0fadab54e7946b0e449c343c3a8fcb2d9358.1762447538.git.asml.silence@gmail.com>
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

There is a repeated problem with how io_uring manages rings.
Specifically, it creates a new memory region for each ring and places
entries together with headers. As the number of entries is always a
power of 2, it usually means that it needs to allocate an additional
page just for headers, which is wasteful. The headers structure size
is also usually small and under the cache line size, however it's
padded, which might mean additional cache bouncing.

Introduce a way for the user space to overlap SCQ headers and/or rings
onto a pre-registered memory/parameter region. Each of them has a
separate flag / offset, and they'll be attempted to be placed at the
specified offset in the region. If the user doesn't request placement
for SQ and/or CQ, io_uring will create a new memory region for them as
before.

The second goal is to be able to put all components into a single region
while knowing what's placed where. It's specifically interesting for
planned BPF work, as it makes program writing much simpler.

Note: zcrx also have the same issue, but it's left out of this series.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  14 ++++
 io_uring/io_uring.c           | 143 ++++++++++++++++++++++++----------
 io_uring/io_uring.h           |  10 ++-
 io_uring/register.c           |   4 +-
 4 files changed, 128 insertions(+), 43 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2da052bd4138..6574f0c6fc57 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -605,8 +605,22 @@ struct io_uring_params {
 	struct io_cqring_offsets cq_off;
 };
 
+enum io_uring_scq_placement_flags {
+	IORING_PLACEMENT_SCQ_HDR		= (1U << 0),
+	IORING_PLACEMENT_SQ			= (1U << 1),
+	IORING_PLACEMENT_CQ			= (1U << 2),
+};
+
+struct io_uring_scq_placement {
+	__u64 flags;
+	__u64 scq_hdr_off;
+	__u64 sq_off;
+	__u64 cq_off;
+};
+
 struct io_uring_params_ext {
 	__u64 mem_region; /* pointer to struct io_uring_mem_region_reg */
+	struct io_uring_scq_placement placement;
 };
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 908c432aaaaa..b5179e444db2 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2757,9 +2757,11 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 }
 
 int rings_size(unsigned int flags, unsigned int sq_entries,
-	       unsigned int cq_entries, struct io_scq_dim *dims)
+	       unsigned int cq_entries, struct io_scq_dim *dims,
+	       unsigned placement_flags)
 {
-	size_t cqe_size, off, sqe_size;
+	size_t cqe_size, sqe_size;
+	size_t off = 0;
 
 	if (flags & IORING_SETUP_CQE_MIXED) {
 		if (cq_entries < 2)
@@ -2787,19 +2789,25 @@ int rings_size(unsigned int flags, unsigned int sq_entries,
 	    dims->sq_array_size == SIZE_MAX)
 		return -EOVERFLOW;
 
-	off = sizeof(struct io_rings);
-	off = L1_CACHE_ALIGN(off);
-	dims->cq_offset = off;
+	if (!(placement_flags & IORING_PLACEMENT_SQ))
+		dims->sq_mr_size = dims->sq_size;
 
-	off = size_add(off, dims->cq_size);
-	if (off == SIZE_MAX)
-		return -EOVERFLOW;
+	if (!(placement_flags & IORING_PLACEMENT_SCQ_HDR)) {
+		off = sizeof(struct io_rings);
+		off = L1_CACHE_ALIGN(off);
+	}
+	dims->cq_offset = off;
 
+	if (!(placement_flags & IORING_PLACEMENT_CQ)) {
+		off = size_add(off, dims->cq_size);
+		if (off == SIZE_MAX)
+			return -EOVERFLOW;
 #ifdef CONFIG_SMP
-	off = ALIGN(off, SMP_CACHE_BYTES);
-	if (off == 0)
-		return -EOVERFLOW;
+		off = ALIGN(off, SMP_CACHE_BYTES);
+		if (off == 0)
+			return -EOVERFLOW;
 #endif
+	}
 
 	if (!(flags & IORING_SETUP_NO_SQARRAY)) {
 		dims->sq_array_offset = off;
@@ -2809,7 +2817,7 @@ int rings_size(unsigned int flags, unsigned int sq_entries,
 			return -EOVERFLOW;
 	}
 
-	dims->cq_comp_size = off;
+	dims->rings_mr_size = off;
 	return 0;
 }
 
@@ -3360,12 +3368,47 @@ bool io_is_uring_fops(struct file *file)
 	return file->f_op == &io_uring_fops;
 }
 
+static int io_create_scq_regions(struct io_ring_ctx *ctx,
+				 struct io_ctx_config *config)
+{
+	struct io_scq_dim *dims = &config->dims;
+	struct io_uring_params *p = &config->p;
+	struct io_uring_region_desc rd;
+	int ret;
+
+	if (dims->rings_mr_size) {
+		memset(&rd, 0, sizeof(rd));
+		rd.size = PAGE_ALIGN(dims->rings_mr_size);
+		if (ctx->flags & IORING_SETUP_NO_MMAP) {
+			rd.user_addr = p->cq_off.user_addr;
+			rd.flags |= IORING_MEM_REGION_TYPE_USER;
+		}
+		ret = io_create_region(ctx, &ctx->ring_region, &rd, IORING_OFF_CQ_RING);
+		if (ret)
+			return ret;
+	}
+
+	if (dims->sq_mr_size) {
+		memset(&rd, 0, sizeof(rd));
+		rd.size = PAGE_ALIGN(dims->sq_mr_size);
+		if (ctx->flags & IORING_SETUP_NO_MMAP) {
+			rd.user_addr = p->sq_off.user_addr;
+			rd.flags |= IORING_MEM_REGION_TYPE_USER;
+		}
+		ret = io_create_region(ctx, &ctx->sq_region, &rd, IORING_OFF_SQES);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 					 struct io_ctx_config *config)
 {
+	struct io_uring_scq_placement *pl = &config->ext.placement;
 	struct io_uring_params *p = &config->p;
 	struct io_scq_dim *dims = &config->dims;
-	struct io_uring_region_desc rd;
 	struct io_rings *rings;
 	int ret;
 
@@ -3373,22 +3416,39 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	ctx->sq_entries = p->sq_entries;
 	ctx->cq_entries = p->cq_entries;
 
-	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(dims->cq_comp_size);
-	if (ctx->flags & IORING_SETUP_NO_MMAP) {
-		rd.user_addr = p->cq_off.user_addr;
-		rd.flags |= IORING_MEM_REGION_TYPE_USER;
-	}
-	ret = io_create_region(ctx, &ctx->ring_region, &rd, IORING_OFF_CQ_RING);
+	ret = io_create_scq_regions(ctx, config);
 	if (ret)
 		return ret;
 
-	ctx->rings = io_region_slice(&ctx->ring_region, 0, sizeof(struct io_rings));
-	ctx->cqes = io_region_slice(&ctx->ring_region, dims->cq_offset, dims->cq_size);
-	if (!ctx->rings || !ctx->cqes)
-		return -EFAULT;
+	if (pl->flags & IORING_PLACEMENT_SQ) {
+		ctx->sq_sqes = io_region_slice(&ctx->param_region,
+						pl->sq_off, dims->sq_size);
+	} else {
+		ctx->sq_sqes = io_region_slice(&ctx->sq_region,
+						0, dims->sq_size);
+	}
+
+	if (pl->flags & IORING_PLACEMENT_SCQ_HDR) {
+		ctx->rings = io_region_slice(&ctx->param_region,
+					     pl->scq_hdr_off,
+					     sizeof(struct io_rings));
+	} else {
+		ctx->rings = io_region_slice(&ctx->ring_region,
+					     0, sizeof(struct io_rings));
+	}
+
+	if (pl->flags & IORING_PLACEMENT_CQ) {
+		ctx->cqes = io_region_slice(&ctx->param_region,
+					    pl->cq_off, dims->cq_size);
+	} else {
+		ctx->cqes = io_region_slice(&ctx->ring_region,
+					    dims->cq_offset, dims->cq_size);
+	}
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY)) {
+		if (WARN_ON_ONCE(pl->flags & IORING_PLACEMENT_CQ))
+			return -EFAULT;
+
 		ctx->sq_array = io_region_slice(&ctx->ring_region,
 						dims->sq_array_offset,
 						dims->sq_array_size);
@@ -3396,20 +3456,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 			return -EFAULT;
 	}
 
-	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(dims->sq_size);
-	if (ctx->flags & IORING_SETUP_NO_MMAP) {
-		rd.user_addr = p->sq_off.user_addr;
-		rd.flags |= IORING_MEM_REGION_TYPE_USER;
-	}
-	ret = io_create_region(ctx, &ctx->sq_region, &rd, IORING_OFF_SQES);
-	if (ret) {
-		io_rings_free(ctx);
-		return ret;
-	}
-
-	ctx->sq_sqes = io_region_slice(&ctx->sq_region, 0, dims->sq_size);
-	if (!ctx->sq_sqes)
+	if (!ctx->sq_sqes || !ctx->cqes || !ctx->rings)
 		return -EFAULT;
 
 	rings = ctx->rings;
@@ -3575,6 +3622,8 @@ static int io_prepare_config(struct io_ctx_config *config)
 {
 	struct io_uring_params *p = &config->p;
 	struct io_uring_params_ext __user *ext_user;
+	struct io_uring_params_ext *e = &config->ext;
+	struct io_uring_scq_placement *pl = &e->placement;
 	int ret;
 
 	ext_user = u64_to_user_ptr(config->p.params_ext);
@@ -3589,10 +3638,26 @@ static int io_prepare_config(struct io_ctx_config *config)
 	if (ret)
 		return ret;
 
-	ret = rings_size(p->flags, p->sq_entries, p->cq_entries, &config->dims);
+	ret = rings_size(p->flags, p->sq_entries, p->cq_entries, &config->dims,
+			 pl->flags);
 	if (ret)
 		return ret;
 
+	if (pl->flags) {
+		if (pl->flags & ~IORING_PLACEMENT_MASK)
+			return -EOPNOTSUPP;
+		/* requires a registered memory region */
+		if (!e->mem_region)
+			return -EINVAL;
+		/* SQ arrays are not supported for simplicity */
+		if (!(p->flags & IORING_SETUP_NO_SQARRAY))
+			return -EINVAL;
+		/* don't allow creating a new region with just for headers */
+		if ((pl->flags & IORING_PLACEMENT_CQ) &&
+		     !(pl->flags & IORING_PLACEMENT_SCQ_HDR))
+			return -EINVAL;
+	}
+
 	io_fill_scq_offsets(p, &config->dims);
 	return 0;
 }
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index c883017b11d3..307710464cc4 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -25,7 +25,8 @@ struct io_scq_dim {
 	size_t cq_size;
 
 	/* Compound array mmap'ed together with CQ. */
-	size_t cq_comp_size;
+	size_t rings_mr_size;
+	size_t sq_mr_size;
 };
 
 struct io_ctx_config {
@@ -35,6 +36,10 @@ struct io_ctx_config {
 	struct io_uring_params __user *uptr;
 };
 
+#define IORING_PLACEMENT_MASK (IORING_PLACEMENT_SCQ_HDR |\
+				IORING_PLACEMENT_SQ |\
+				IORING_PLACEMENT_CQ)
+
 #define IORING_FEAT_FLAGS (IORING_FEAT_SINGLE_MMAP |\
 			IORING_FEAT_NODROP |\
 			IORING_FEAT_SUBMIT_STABLE |\
@@ -153,7 +158,8 @@ static inline bool io_should_wake(struct io_wait_queue *iowq)
 #define IORING_MAX_CQ_ENTRIES	(2 * IORING_MAX_ENTRIES)
 
 int rings_size(unsigned int flags, unsigned int sq_entries,
-	       unsigned int cq_entries, struct io_scq_dim *dims);
+	       unsigned int cq_entries, struct io_scq_dim *dims,
+	       unsigned placement_flags);
 int io_uring_fill_params(struct io_uring_params *p);
 void io_fill_scq_offsets(struct io_uring_params *p, struct io_scq_dim *dims);
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32);
diff --git a/io_uring/register.c b/io_uring/register.c
index 4affabc416aa..bbcb5a79a35f 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -423,12 +423,12 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	ret = io_uring_fill_params(&p);
 	if (unlikely(ret))
 		return ret;
-	ret = rings_size(p.flags, p.sq_entries, p.cq_entries, &dims);
+	ret = rings_size(p.flags, p.sq_entries, p.cq_entries, &dims, 0);
 	if (ret)
 		return ret;
 	io_fill_scq_offsets(&p, &dims);
 
-	size = dims.cq_comp_size;
+	size = dims.rings_mr_size;
 	sq_array_offset = dims.sq_array_offset;
 
 	memset(&rd, 0, sizeof(rd));
-- 
2.49.0


