Return-Path: <io-uring+bounces-11772-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id DC14AD38A15
	for <lists+io-uring@lfdr.de>; Sat, 17 Jan 2026 00:31:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 8185630619E4
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A6F43164C3;
	Fri, 16 Jan 2026 23:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iZPduNwk"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27AB2D8364
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 23:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768606271; cv=none; b=jVwQfmZACVHNGT7AOFYxMITFIbaZYdU9k+ZlI4wNwb7Sw9KYMgURcUCFdG6VUIDCTIjGmOWFNn3HgSIeXSW3IN/loBAPe3A7ygK17NowNCohIDtK0UYyzOktpwwVxDA3GSvO3MsINzx1HxzqE/gLvULsW041nl0xFZwa3ryO0VY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768606271; c=relaxed/simple;
	bh=+mH2WxpE8SjctEikEFNkdsJhqIUv71jMqjQ1H+776E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OByOg/YnxdmaueOCFGd30QxQPpg/Vnjv8c4ZOGOtgLncBWV/3QP6Xv/MkJRBRpVNcIehxZMA6luz4BOZEx4lAyaWEiMm0ef5eFoeFWb4OWk62rp4bWzEJgzoj1iyXCUfh926UOX/FYjfnCfaA6QfJGbzWm+/i1FbZe6NEDj8FTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iZPduNwk; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-81f3fcdb556so1284213b3a.2
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 15:31:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768606269; x=1769211069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xzgn3Z5o/B9R4A++0u+qjgSQaMcCY23ZrEHlAfJl+/I=;
        b=iZPduNwkyJSxA2BNnBNhRHEybYK2U5qoEFkcmXf/uj9FqmpotXeVKDvSqaeZVQug1v
         WVsYs/cqKpN1XZ/zjhBB4UTfGEN9XkDNoUyNHI9aV8UM65MQKIkT4LUvAXX5A293ajHm
         uMPCax+zVEFy+SHBMSjAxoS4npmFh4xKV8jqLWjZBh7BA9I0OLRLB6R4edUrgtaBVnz0
         ZzWOKlEmot5RV7udWoKmf74aSoKbWSKRmRE48Obs1ZdVfyfV7wklcRY7ntJDXivVWsGS
         +OoLOFqdHlypD8KQ55Xo2HHUSQQIiY6tvx5G+ZSAKeK8SRuig2utKasS7n6cbT0+4+dg
         2QOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768606269; x=1769211069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xzgn3Z5o/B9R4A++0u+qjgSQaMcCY23ZrEHlAfJl+/I=;
        b=LvINeyp3g0lJMV+4Z0vLJv4xjQZlISTAIyqsOenmIgcPOyy/wElxbqfzY4Jme1xhK/
         sIJ4PNtp3kno/90vHpD6eaDLMetiVVhe7yvfMfxe0FLYEP3/Vgdr6DCCXB4bATAGIA8k
         0tAWMc0QrEKilQ3TvS7mM+Z5cr1PXDDdZ437exDtYepfHfo4DjQNBLDMckY8nHZs43RP
         UAvHUVSk9htppgxfg/ohQCgQqEnK0nxQvO6SPz6wQk9BGRmKV50mYJ4eF1u3AjJGoWdY
         QE6YlpeMTSpTOEiQWgslu5CDBVBeCz1T2iZ35zdDAbsswmnzdrU+tjcgxHX/7LAGBZPe
         Je4Q==
X-Forwarded-Encrypted: i=1; AJvYcCXB4NugL8plCnLYuCBLL8vcP9YC7t8aSNYir6Llx56n19qF2DmtcDAReZMdIgI47+8DEQ1QhM317w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxA1ThqSUFZiGlFE3t/vcD/XAVoyMpuGei1SJAN9T3wU3eIZbNe
	KKxk6YexMF40t/8JOh+yAfzGFqpQ0uZsBbLmHroh/qrYSPN6+5E1tn3E
X-Gm-Gg: AY/fxX6LqMYQk3ZIVlOYeG59CvRoppSJWEi1HKOL+1kFeAvZwtaHOwjmbhezzbg9Eiw
	WxKiexZNJolH3k9Tp5pUB0472HwCD5IYN00cQv+Ns8tJfgYpv+A54Rs6xDgXxcFjCw1Fb1xn4m9
	fN6lArIV5OmqL2Q584kGUXoW1zJKMmzfi4DevAvx7LgftNWJ1ZEFKLFizcTNLwuv6uFWQ068+t6
	rSGEUlT5vgBcq4SkXbveBYmxwlgi0iF0y100/9t3uTc8joFGGU98ikWK/vNhTIBhaRm5C2apw72
	65FEv7GN58u4XRfP0SBdWuiWfROgIJA64D2ua2DWkgR3k3gnO3+gBdYYbDgvknMJrRcccBoQfv7
	8lpzKxxqLS9Av/GT+nI5rPcF4QRoS0Zf8NZzbuorOER5wQ/8oBweW0rjBWOO3op4FdLk8aqtWQj
	FOYN4aVA==
X-Received: by 2002:a05:6a00:600b:b0:81f:852b:a934 with SMTP id d2e1a72fcca58-81f9f6ac890mr3990798b3a.24.1768606269380;
        Fri, 16 Jan 2026 15:31:09 -0800 (PST)
Received: from localhost ([2a03:2880:ff:59::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81fa127875esm2947351b3a.35.2026.01.16.15.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 15:31:09 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk,
	miklos@szeredi.hu
Cc: bschubert@ddn.com,
	csander@purestorage.com,
	krisman@suse.de,
	io-uring@vger.kernel.org,
	asml.silence@gmail.com,
	xiaobing.li@samsung.com,
	safinaskar@gmail.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v4 04/25] io_uring/kbuf: add mmap support for kernel-managed buffer rings
Date: Fri, 16 Jan 2026 15:30:23 -0800
Message-ID: <20260116233044.1532965-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260116233044.1532965-1-joannelkoong@gmail.com>
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for mmapping kernel-managed buffer rings (kmbuf) to
userspace, allowing applications to access the kernel-allocated buffers.

Similar to application-provided buffer rings (pbuf), kmbuf rings use the
buffer group ID encoded in the mmap offset to identify which buffer ring
to map. The implementation follows the same pattern as pbuf rings.

New mmap offset constants are introduced:
  - IORING_OFF_KMBUF_RING (0x88000000): Base offset for kmbuf mappings
  - IORING_OFF_KMBUF_SHIFT (16): Shift value to encode buffer group ID

The mmap offset is calculated during registration, encoding the bgid
shifted by IORING_OFF_KMBUF_SHIFT. The io_buf_get_region() helper
retrieves the appropriate region.

This allows userspace to mmap the kernel-allocated buffer region and
access the buffers directly.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/kbuf.c               | 11 +++++++++--
 io_uring/kbuf.h               |  5 +++--
 io_uring/memmap.c             |  5 ++++-
 4 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 589755a4e2b4..96e936503ef6 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -533,6 +533,8 @@ struct io_uring_cqe {
 #define IORING_OFF_SQES			0x10000000ULL
 #define IORING_OFF_PBUF_RING		0x80000000ULL
 #define IORING_OFF_PBUF_SHIFT		16
+#define IORING_OFF_KMBUF_RING		0x88000000ULL
+#define IORING_OFF_KMBUF_SHIFT		16
 #define IORING_OFF_MMAP_MASK		0xf8000000ULL
 
 /*
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 8d253724754e..68469efe5552 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -766,16 +766,23 @@ int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
 }
 
-struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
-					    unsigned int bgid)
+struct io_mapped_region *io_buf_get_region(struct io_ring_ctx *ctx,
+					   unsigned int bgid,
+					   bool kernel_managed)
 {
 	struct io_buffer_list *bl;
+	bool is_kernel_managed;
 
 	lockdep_assert_held(&ctx->mmap_lock);
 
 	bl = xa_load(&ctx->io_bl_xa, bgid);
 	if (!bl || !(bl->flags & IOBL_BUF_RING))
 		return NULL;
+
+	is_kernel_managed = !!(bl->flags & IOBL_KERNEL_MANAGED);
+	if (is_kernel_managed != kernel_managed)
+		return NULL;
+
 	return &bl->region;
 }
 
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 62c80a1ebf03..11d165888b8e 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -88,8 +88,9 @@ unsigned int __io_put_kbufs(struct io_kiocb *req, struct io_buffer_list *bl,
 bool io_kbuf_commit(struct io_kiocb *req,
 		    struct io_buffer_list *bl, int len, int nr);
 
-struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
-					    unsigned int bgid);
+struct io_mapped_region *io_buf_get_region(struct io_ring_ctx *ctx,
+					   unsigned int bgid,
+					   bool kernel_managed);
 
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req,
 					struct io_buffer_list *bl)
diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 6ecb6f1da59c..861038c1df49 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -357,7 +357,10 @@ static struct io_mapped_region *io_mmap_get_region(struct io_ring_ctx *ctx,
 		return &ctx->sq_region;
 	case IORING_OFF_PBUF_RING:
 		id = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_PBUF_SHIFT;
-		return io_pbuf_get_region(ctx, id);
+		return io_buf_get_region(ctx, id, false);
+	case IORING_OFF_KMBUF_RING:
+		id = (offset & ~IORING_OFF_MMAP_MASK) >> IORING_OFF_KMBUF_SHIFT;
+		return io_buf_get_region(ctx, id, true);
 	case IORING_MAP_OFF_PARAM_REGION:
 		return &ctx->param_region;
 	case IORING_MAP_OFF_ZCRX_REGION:
-- 
2.47.3


