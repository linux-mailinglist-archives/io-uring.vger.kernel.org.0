Return-Path: <io-uring+bounces-10415-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id C3E60C3CAD6
	for <lists+io-uring@lfdr.de>; Thu, 06 Nov 2025 18:02:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E1A2518904DA
	for <lists+io-uring@lfdr.de>; Thu,  6 Nov 2025 17:02:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD35434D4C0;
	Thu,  6 Nov 2025 17:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a3gvc4es"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 843E7334366
	for <io-uring@vger.kernel.org>; Thu,  6 Nov 2025 17:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448531; cv=none; b=rqBGTMN1eZvou1vNhUJVSAQUmKWAOwPYbGbTpNmxU5/X6bHGEVGatx3AgdPF2s9o9Tg1Xwze8kGHibW7lvdfeCoYbEqU7XBDmi3as1X2csL8/bvhVz4hHc2yl5qp5d/6XDbWZB8ctC7IGlMFtT4Bq19o+xQ8hZCZn9sEuuMHaF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448531; c=relaxed/simple;
	bh=thFzE/k6G1HCiAxGMmOqp42/kdSRemZani+1oqMtlvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kjvoXWVctf+hQVFcmINxwz3A9NQg0oDgP+F5WZe+01Emv5DoVOIqG/UKp+XaZVLAXykT1K2hIGVox4q8MfHb/sQYcXaMsevr/5uzHOmK5JIw1AacNHgpnI0iEZpuUvPAbhA79FhSf8Rw5Qi06+jnDQUjSWW4Po9IEAKWZ2Ujwv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a3gvc4es; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4774f41628bso11964815e9.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 09:02:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762448527; x=1763053327; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aa+PTsbjY7xsIsDlSAge1kJ1/fOe+GEluULowZ1UtMY=;
        b=a3gvc4esiipIqbldWCgXYHwDvL+GUv4SC99vQo0EG4+QrJbWut5/0wz/SzPcs5LEq2
         u7aDepvDrOb/jeOY742UPlqZSB9U4+8u1gZGPL27RNomab4p/f4vEWQhO+iVXJMtUKbE
         ChZjrVHtz08pz59TDXJYbU6pt00/rJsvaEq6SGxDDUwsVRQVYI0KIZuFxdCOB4cb5RRQ
         abf9piwwVs7ulSNyqi4DiXdEeFmNSd6ngGfkhjThIVrJRsrbvmHQWMHoTzfHs5MgPJb5
         HhgKkl5LCoX+pMy9GplxdpFi/VsVxqCVUb55QefS8K81LevP9iDZR2EUoiD+Yu54am+3
         Dh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762448527; x=1763053327;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=aa+PTsbjY7xsIsDlSAge1kJ1/fOe+GEluULowZ1UtMY=;
        b=U/Ifth6v7iaifQBW6TazlAKpNc7FwQAX+cu5NoZPjz9wqUOM1G3TgVr6OJRdaNysEj
         5KhpMUVnPBOiBcW1U6lHH/EVmujkB+K+LgRJX5xmFBfw3rbSkfLZ9DUyTM62CPpGCeNR
         to2NhplOulBC+iIFVJSCrSeYFjD0HrMTSQ5gbyI/uiko1/wM2+BpTKOiInjKaEgTFkih
         yoGJFJTh4KBJJdGoKkPApSmiwIK3kd+RbvFRc3uycUuzjKC5Riofk6YDdKY5GtrAPbCC
         TmGSIA9sVNqEHDjH4/3D+FHwRpquzE8idMlOoaPpiZBGVAnlepbHm5RhM+Q0RVm3HwGU
         zOgw==
X-Gm-Message-State: AOJu0Yyk9CgbOfmtkUKkoVBa5DbQLWkku8gae4SWBJX5MPb/SccWBlNT
	6zfCbXLgkkDBumLQR6Gxzu50Op1XQg9oVx7Agg6QR9NgTk05xgoM02xJYKlGSw==
X-Gm-Gg: ASbGncunpmb96CXqeQlYq//MPUV9jpFnxrYcujxagEwZ9M7+a6OZH68cC3PUUhv/ibN
	Z3uhGuSB3YzYfqInVsG++znjS5HmrhDIcgRGCpCQYNBoiqWRQk2hgJbGrxOj7KMlZ+R1R+dosHI
	bclCIt9wmZUcLNf9xucmaNj2lqWmSMMOj5ZKeozoR6q9dXMUFda5uzdYbRBGcjcdkxfyw8y5KE5
	O8zFBYPeSG1Z0xRU3v2/QwiNPZZswlxCtOOpYYWJlztJ8CMFT8KJObD0lxfdM1IcY+cN2FSBQPU
	QTfvdOwHy2WVXGF74J6VZZ1vYUtR09zfjQOHMEGeke7+uf9G8sBdogHvcFuKQny2lPRFEkrwenT
	l1aB6oLxselO0QxGfZ+PqTtBZ7E6Avetu4c15xBdKAnLQWzWqBLqzDYS/QyY1c10jQXb9/d+IEv
	8nyCk=
X-Google-Smtp-Source: AGHT+IFdEvV/iW/iZ9LM0Cv0ce2XB6DAG1jYInTCrdJqIyhmBfgmjvBU1o3RhMmB2GzC2capwRlmyA==
X-Received: by 2002:a05:6000:dc8:b0:429:eb80:11f5 with SMTP id ffacd0b85a97d-429eb80126fmr2627554f8f.26.1762448527075;
        Thu, 06 Nov 2025 09:02:07 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42ac675caecsm124567f8f.30.2025.11.06.09.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Nov 2025 09:02:06 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 07/16] io_uring: add structure keeping ring offsets
Date: Thu,  6 Nov 2025 17:01:46 +0000
Message-ID: <b96ded3a1e0bda775291b9b989ee868a0ff6b9c3.1762447538.git.asml.silence@gmail.com>
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

Add struct io_scq_dim that keeps all offset / size / dimension
information about the rings, and let rings_size() initialise it. It
improves calculation locality and allows to dedup some code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 60 ++++++++++++++++++++++++---------------------
 io_uring/io_uring.h | 12 +++++++--
 io_uring/register.c | 19 ++++++--------
 3 files changed, 49 insertions(+), 42 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 30ba60974f1d..8166ea9140f8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2757,49 +2757,61 @@ static void io_rings_free(struct io_ring_ctx *ctx)
 	ctx->sq_sqes = NULL;
 }
 
-unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
-			 unsigned int cq_entries, size_t *sq_offset)
+int rings_size(unsigned int flags, unsigned int sq_entries,
+	       unsigned int cq_entries, struct io_scq_dim *dims)
 {
 	struct io_rings *rings;
 	size_t off, sq_array_size;
+	size_t sqe_size;
+
+	dims->sq_array_offset = SIZE_MAX;
+
+	sqe_size = sizeof(struct io_uring_sqe);
+	if (flags & IORING_SETUP_SQE128)
+		sqe_size *= 2;
+
+	dims->sq_size = array_size(sqe_size, sq_entries);
+	if (dims->sq_size == SIZE_MAX)
+		return -EOVERFLOW;
 
 	off = struct_size(rings, cqes, cq_entries);
 	if (off == SIZE_MAX)
-		return SIZE_MAX;
+		return -EOVERFLOW;
 	if (flags & IORING_SETUP_CQE32) {
 		if (check_shl_overflow(off, 1, &off))
-			return SIZE_MAX;
+			return -EOVERFLOW;
 	}
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
 
 #ifdef CONFIG_SMP
 	off = ALIGN(off, SMP_CACHE_BYTES);
 	if (off == 0)
-		return SIZE_MAX;
+		return -EOVERFLOW;
 #endif
 
 	if (flags & IORING_SETUP_NO_SQARRAY) {
-		*sq_offset = SIZE_MAX;
-		return off;
+		dims->cq_comp_size = off;
+		return 0;
 	}
 
-	*sq_offset = off;
+	dims->sq_array_offset = off;
 
 	sq_array_size = array_size(sizeof(u32), sq_entries);
 	if (sq_array_size == SIZE_MAX)
-		return SIZE_MAX;
+		return -EOVERFLOW;
 
 	if (check_add_overflow(off, sq_array_size, &off))
-		return SIZE_MAX;
+		return -EOVERFLOW;
 
-	return off;
+	dims->cq_comp_size = off;
+	return 0;
 }
 
 static __cold void __io_req_caches_free(struct io_ring_ctx *ctx)
@@ -3354,27 +3366,19 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 {
 	struct io_uring_region_desc rd;
 	struct io_rings *rings;
-	size_t sq_array_offset;
-	size_t sq_size, cq_size, sqe_size;
+	struct io_scq_dim dims;
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
+	ret = rings_size(ctx->flags, p->sq_entries, p->cq_entries, &dims);
+	if (ret)
+		return ret;
 
 	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(cq_size);
+	rd.size = PAGE_ALIGN(dims.cq_comp_size);
 	if (ctx->flags & IORING_SETUP_NO_MMAP) {
 		rd.user_addr = p->cq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
@@ -3385,10 +3389,10 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
 	ctx->rings = rings = io_region_get_ptr(&ctx->ring_region);
 
 	if (!(ctx->flags & IORING_SETUP_NO_SQARRAY))
-		ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
+		ctx->sq_array = (u32 *)((char *)rings + dims.sq_array_offset);
 
 	memset(&rd, 0, sizeof(rd));
-	rd.size = PAGE_ALIGN(sq_size);
+	rd.size = PAGE_ALIGN(dims.sq_size);
 	if (ctx->flags & IORING_SETUP_NO_MMAP) {
 		rd.user_addr = p->sq_off.user_addr;
 		rd.flags |= IORING_MEM_REGION_TYPE_USER;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index c4d47ad7777c..29464be9733c 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -17,6 +17,14 @@
 #include <trace/events/io_uring.h>
 #endif
 
+struct io_scq_dim {
+	size_t sq_array_offset;
+	size_t sq_size;
+
+	/* Compound array mmap'ed together with CQ. */
+	size_t cq_comp_size;
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
+	       unsigned int cq_entries, struct io_scq_dim *dims);
 int io_uring_fill_params(struct io_uring_params *p);
 bool io_cqe_cache_refill(struct io_ring_ctx *ctx, bool overflow, bool cqe32);
 int io_run_task_work_sig(struct io_ring_ctx *ctx);
diff --git a/io_uring/register.c b/io_uring/register.c
index 0d70696468f6..85814f983dde 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -402,6 +402,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	struct io_ring_ctx_rings o = { }, n = { }, *to_free = NULL;
 	size_t size, sq_array_offset;
 	unsigned i, tail, old_head;
+	struct io_scq_dim dims;
 	struct io_uring_params p;
 	int ret;
 
@@ -419,11 +420,12 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	ret = io_uring_fill_params(&p);
 	if (unlikely(ret))
 		return ret;
+	ret = rings_size(p.flags, p.sq_entries, p.cq_entries, &dims);
+	if (ret)
+		return ret;
 
-	size = rings_size(p.flags, p.sq_entries, p.cq_entries,
-				&sq_array_offset);
-	if (size == SIZE_MAX)
-		return -EOVERFLOW;
+	size = dims.cq_comp_size;
+	sq_array_offset = dims.sq_array_offset;
 
 	memset(&rd, 0, sizeof(rd));
 	rd.size = PAGE_ALIGN(size);
@@ -455,14 +457,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		return -EFAULT;
 	}
 
-	if (p.flags & IORING_SETUP_SQE128)
-		size = array_size(2 * sizeof(struct io_uring_sqe), p.sq_entries);
-	else
-		size = array_size(sizeof(struct io_uring_sqe), p.sq_entries);
-	if (size == SIZE_MAX) {
-		io_register_free_rings(ctx, &n);
-		return -EOVERFLOW;
-	}
+	size = dims.sq_size;
 
 	memset(&rd, 0, sizeof(rd));
 	rd.size = PAGE_ALIGN(size);
-- 
2.49.0


