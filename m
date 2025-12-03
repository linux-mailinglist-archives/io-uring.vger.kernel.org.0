Return-Path: <io-uring+bounces-10899-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 97657C9D679
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:36:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 1B2F334A263
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:36:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 34F681EFFB4;
	Wed,  3 Dec 2025 00:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HOz9APZb"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF021B425C
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722197; cv=none; b=Omv1vbkYQYk4KdQ5LvumliShQ/kxdgDHYtJ9VviaL6BNcola5tghNpqU0Nz+H03jljE/BsJpwaGm/CMNGVemnDmy0SK0YcqM1Q3WqgjS7jPXGGFdPoCwglpS2I4H13VDECB6ERnbtXAl39imvRYMH0mzYGYlv9JoNZnpQVOE1O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722197; c=relaxed/simple;
	bh=H5pJXYdw73uQ5PTaZNSv/4cwVivoCphGDwNbQ2xew7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NbpbmIDYlmQr2/VgRnioI0RbCgKb3jQzbnUkhPGOwOpHLF6BXA/VHvJj7gLlMf486Dso9hldwr0SlRcDfuDbalvVGXsigo4EqfZxAAXnJjMJrW7z8tuyBgdMfDP4jvw8ywCxt4odyC7y7Wocy/E0tycLPwGEfF7OD5FSz30nf+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HOz9APZb; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-343f35d0f99so4786505a91.0
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722195; x=1765326995; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7Xvljb0o7dTuqJqMJUVJlAvbjlhXpEbahfBZkU4Ln8E=;
        b=HOz9APZbg/pzqJaiRIYIvmlFY8yOZvlXZOGCFQhN4Zzv8iDYLzrauurpncRc2i4uhl
         RtPJsMGm7jjojyuQB12zSpuE1xS3UD5f8/ZIvEPq2MGO2nkBgQs07auj4KeyT+ldP62H
         ePnjhgXOJbV3wqtorYEfsTCQGh7RiL/NZnEe+LpcyUHa9lbSvXdFFinKtZQRw3uIkjUO
         hEtNRqzBzcG0n8dSaouT5VoRerVlJSpLUYVFVtq0wro21IJkH6iW7G+dxJFZ/h0Bw/FU
         z6UUtM0Sc7nEL1cSHji+Y6b1/HN7k3Z2BJ2CuIeN/suxJ+RAcwHgx/I/CRBr31U+j/s0
         REnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722195; x=1765326995;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7Xvljb0o7dTuqJqMJUVJlAvbjlhXpEbahfBZkU4Ln8E=;
        b=R+y3MFjgkZhsHGS/P55SZ3MlBXBJ74lEOSonvZPkQ62nFCuv6/adDz+zg+KhBsq2yt
         Xku33+DRqMSyW3xj03WVdOnIP5DVpcVmloMiOFTNYX/w6vpxehOCI533/N+gWlEZlHkI
         JHsqFivUsXqudqKYY6o54lBOoOFgGT7Rr21/LsWOmGnXDlm+YAbKwJ9NvG53J7I8BgQE
         NFwbDiihOGgm8R0ng5NsBJ9rb9gEcwh9KcuhdSll4ZRbc4cXVLImI6tJ8QHYOoCVKgHY
         fu2GHj/gqclY1N8Er+BQ24/04F3bNWLKza2jAYeqofGLi14A3uno06Ferx9Xu4yNzWCa
         zTIw==
X-Forwarded-Encrypted: i=1; AJvYcCWdXDG1Qu8GwcyY9WrMurrRhgMghZ6ioH5ShSEAr2d1sa/MMqDT9KQh/FIdAyGW/1PsuLKxKcS3tQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzR+egx8+J/geNbGQZ3zRVsAK9ap35D6br11abXEvCwRG5ZC3fm
	qBCacVbcnZHIqKM/JMU0NZcp4nmUOOPwwB/jL6bX525IuSOwAGVvJQVV
X-Gm-Gg: ASbGncvwqe6YNq1LBMwDxThbJOF+1eNxJsUi51WDps5YbiakG5Ujm0DyuTRW+7RQzoN
	k19cA6hPcq8QkcXL2I5o46nGos7TfWTsJGLZriev7iPb0GrQYjFvUEnG6E8A133wOzLIbcyhSMM
	9riou2vmJo4kCBM0zhUZS0bwYsBm7MoMCTALiluyPngkKzFwpkStDONAJacwnK37sTplQA7swG/
	4k2/E0K8pA6poPFuc3ETMPsseiWnQI9Obz8s/vqi+63+A04my1mxBojNHBtQLD1QqPATjORJLcl
	013kvbbZuyIBSTO06Mch4fd/1cO6ZuDUydVhfDZJsDz41xe0FNuMt7eM7pYcATTO2g+wf5fKad+
	Lq4iZOx5Eq+qkvleB6DkUOiOIeIhpS/gscozzJbyYlEu/VHS+juhIofWLZ54jgk3yP8Fy6E9+ai
	07nS40jybNQSQrHOARKw==
X-Google-Smtp-Source: AGHT+IHWZ6Ck8karVZGDo6ybg1Y6osGDql86Shy79Jo+tQo6/F4ZJJCHFP6rE1gRu9c1Tire4Kk8Rg==
X-Received: by 2002:a17:90b:28c8:b0:33e:2934:6e11 with SMTP id 98e67ed59e1d1-349125ffb46mr713689a91.11.1764722194762;
        Tue, 02 Dec 2025 16:36:34 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5c::])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34912a0af01sm124596a91.6.2025.12.02.16.36.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:34 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 04/30] io_uring/kbuf: add mmap support for kernel-managed buffer rings
Date: Tue,  2 Dec 2025 16:34:59 -0800
Message-ID: <20251203003526.2889477-5-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251203003526.2889477-1-joannelkoong@gmail.com>
References: <20251203003526.2889477-1-joannelkoong@gmail.com>
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
index 1668718ac8fd..619bba43dda3 100644
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
index a46b027882f8..1832ef923e99 100644
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


