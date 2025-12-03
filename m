Return-Path: <io-uring+bounces-10901-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E2FAEC9D685
	for <lists+io-uring@lfdr.de>; Wed, 03 Dec 2025 01:37:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 3A58634A64F
	for <lists+io-uring@lfdr.de>; Wed,  3 Dec 2025 00:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F0DC226541;
	Wed,  3 Dec 2025 00:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YVLyI5Qm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56DA221FBA
	for <io-uring@vger.kernel.org>; Wed,  3 Dec 2025 00:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764722200; cv=none; b=Y9Vdv/xt65izqgDgiYOrVaVmF1Zi0RL7vHFRKoisheJmsNEawdNqCu+hyHg7BSaf3RcXhXdgLDfEEIyIIi1l66CP3eEH8qDtQMg4zCo7NEzDpNHL/IvAeGAYpz+riLba9hzUxk0Pt/JP7+hFPmVNZMh34nPl3stzTuncc1xSBJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764722200; c=relaxed/simple;
	bh=AHTn61fBmrmRmi9FoGK4ms2rCTBJw6qzcd7TRkLtpeg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AfIJ6xXzDEo3hiSADvbDyBAEEaoih3hvU1eT6sYPy+spU9lreR7VdNwEpQlqDxb2YYlnhB0kBdTghPqoOWKeEXlrpQFQY80F032nBcVHN18WImYG3Xqf1UnTvX6S0hsHsHLMa/O9PN0cFFn4b5r24idHFPZ8UvhCGCgsDFck4Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YVLyI5Qm; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7ba55660769so5220771b3a.1
        for <io-uring@vger.kernel.org>; Tue, 02 Dec 2025 16:36:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764722198; x=1765326998; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GjhbYsI9c7Tu1t4+LNuuFKc04qJ6bp8LwmpkuMD/Kpg=;
        b=YVLyI5QmMowh8TQnuBu/l1DRtUAvMlXXGqi0fr8gWiMsRK//33yC8o64TQzOVeUhYL
         2fGJlPLXP6+ShtxCs7wemKKS4lsIei1EFyNm8XfBvZgXuYR90C6EHryicFMXbm3pBXsK
         TexekHIh1SRGC6aGU2Mv98JceCkmcVOc0BuC1RUIqKKZ000kCfKMO0BXUGjfNRRqpodm
         MZSO4xaKrn2GAtjABz3n6xoSKXSBKAmAnLw3XePpEX1EyYrQcGRTXWEysDs29XCegaNb
         v46N1W7TEsd58UpHxTlfjk6Nrjq385BDhkvHrgYYxMW+C8abGV/qF9Hb/f5I2rNqEX5e
         HiRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764722198; x=1765326998;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GjhbYsI9c7Tu1t4+LNuuFKc04qJ6bp8LwmpkuMD/Kpg=;
        b=cWT+1e0vT8qrcuIuJu7zr/ww+AWrPHaDM9bTo46RvowLMlMOHVrxIt2aC7tBB7riZR
         x7EID2PEX2BdLg0g6kOQJC/57+0eJ6uyQ3Ahjmp/IaJsWGqq0OEze/qMfJYI7LgITnkh
         Zuql+/15BricZihZkL4auHT3nepVEZzgKsSholEwomFrcEIRvUbY5vOPBjQ5gROjU8Np
         /1nnSsJran9nTXrHI5Gt3sfXTETjGWqtcdfXP+Ir/kPJPvjw3FdrB5htBA2Ukp9SKt/D
         vdkvbZffOQz5U72GbeXqROj2BqeP+ucz42R9QT8TNP54W/WFscU04yID3K2DOeFRZZ5F
         622g==
X-Forwarded-Encrypted: i=1; AJvYcCVmTTdR3SGb6FVkw6JchZrHq+IGAQ9a9snNrbGiDkuKXfYChsek54PgY7JW5TD5hNTjWdCmXN0pRw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKIqcqZKlFW/DgO4+ULfHhB9MrnqlF6/Ri9/zh0MpM3+4MPU6G
	CDDnqhhDia/0gh3VI8R4eU15rzPb92FfUSFQb4UJssP/3S27qdNMaTdt
X-Gm-Gg: ASbGnctcutdBl/BeyC3qneMRH2xZ45iDy+7FYbwY5qSrh3kisT5xInK6+V0YvUbPs5t
	PbDy9fik/urRB3SV8L2zi624Ql+NK8fSkbpha3rRB+NywjhGk6FDW4Zeok+VC7dTfcp7C3tKa2g
	LawFIvXYs+z4chk8495Aod3zT8srFYQe7AFiFGtDYFqhdz0eyucCkWan/CP+kECFz2w+SL/VLh1
	tnqrImg1bIIwCsZfdv/IZjFXPLj0XOtKfu31dnLNekQP/F05Gxi2vEDhrL2D25YBD3/+OTwNhVH
	DyvIVEN5zcJl7Wtay1vqmdy6gJJNvavkKALJyG/sNVY8BuNDfnRfcIJzQQzp7QCmJBIHbpbyCnm
	xW632KkoATcmTr5sTLw/8QLbkQPiOi0gGDdJyP3DMlvx4N69w5HlZoLhPc3d4z0KXIZ0WlSqRQd
	9E8PzT/oKTiCBMccqbV6VCYb0ApWo=
X-Google-Smtp-Source: AGHT+IHjCyBLsyEAF1TNXCKsD3GUhZ9eHW+S01q0eV4HFNoK5aXIPp3uNTkhtz837SfgIHDuwAd2WA==
X-Received: by 2002:a05:6a21:3296:b0:35f:b96d:af11 with SMTP id adf61e73a8af0-363f5cf42a9mr724089637.5.1764722198146;
        Tue, 02 Dec 2025 16:36:38 -0800 (PST)
Received: from localhost ([2a03:2880:ff:d::])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-be6ec21e044sm13468927a12.12.2025.12.02.16.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 16:36:37 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v1 06/30] io_uring/kbuf: add buffer ring pinning/unpinning
Date: Tue,  2 Dec 2025 16:35:01 -0800
Message-ID: <20251203003526.2889477-7-joannelkoong@gmail.com>
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

Add kernel APIs to pin and unpin buffer rings, preventing userspace from
unregistering a buffer ring while it is pinned by the kernel.

This provides a mechanism for kernel subsystems to safely access buffer
ring contents while ensuring the buffer ring remains valid. A pinned
buffer ring cannot be unregistered until explicitly unpinned. On the
userspace side, trying to unregister a pinned buffer will return -EBUSY.
Pinning an already-pinned bufring is acceptable and returns 0.

The API accepts a "struct io_ring_ctx *ctx" rather than a cmd pointer,
as the buffer ring may need to be unpinned in contexts where a cmd is
not readily available.

This is a preparatory change for upcoming fuse usage of kernel-managed
buffer rings. It is necessary for fuse to pin the buffer ring because
fuse may need to select a buffer in atomic contexts, which it can only
do so by using the underlying buffer list pointer.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/buf.h | 28 +++++++++++++++++++++++
 io_uring/kbuf.c              | 43 ++++++++++++++++++++++++++++++++++++
 io_uring/kbuf.h              |  5 +++++
 3 files changed, 76 insertions(+)
 create mode 100644 include/linux/io_uring/buf.h

diff --git a/include/linux/io_uring/buf.h b/include/linux/io_uring/buf.h
new file mode 100644
index 000000000000..7a1cf197434d
--- /dev/null
+++ b/include/linux/io_uring/buf.h
@@ -0,0 +1,28 @@
+/* SPDX-License-Identifier: GPL-2.0-or-later */
+#ifndef _LINUX_IO_URING_BUF_H
+#define _LINUX_IO_URING_BUF_H
+
+#include <linux/io_uring_types.h>
+
+#if defined(CONFIG_IO_URING)
+int io_uring_buf_ring_pin(struct io_ring_ctx *ctx, unsigned buf_group,
+			  unsigned issue_flags, struct io_buffer_list **bl);
+int io_uring_buf_ring_unpin(struct io_ring_ctx *ctx, unsigned buf_group,
+			    unsigned issue_flags);
+#else
+static inline int io_uring_buf_ring_pin(struct io_ring_ctx *ctx,
+					unsigned buf_group,
+					unsigned issue_flags,
+					struct io_buffer_list **bl);
+{
+	return -EOPNOTSUPP;
+}
+static inline int io_uring_buf_ring_unpin(struct io_ring_ctx *ctx,
+					  unsigned buf_group,
+					  unsigned issue_flags)
+{
+	return -EOPNOTSUPP;
+}
+#endif /* CONFIG_IO_URING */
+
+#endif /* _LINUX_IO_URING_BUF_H */
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 00ab17a034b5..ddda1338e652 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -9,6 +9,7 @@
 #include <linux/poll.h>
 #include <linux/vmalloc.h>
 #include <linux/io_uring.h>
+#include <linux/io_uring/buf.h>
 
 #include <uapi/linux/io_uring.h>
 
@@ -237,6 +238,46 @@ struct io_br_sel io_buffer_select(struct io_kiocb *req, size_t *len,
 	return sel;
 }
 
+int io_uring_buf_ring_pin(struct io_ring_ctx *ctx, unsigned buf_group,
+			  unsigned issue_flags, struct io_buffer_list **bl)
+{
+	struct io_buffer_list *buffer_list;
+	int ret = -EINVAL;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	buffer_list = io_buffer_get_list(ctx, buf_group);
+	if (likely(buffer_list) && (buffer_list->flags & IOBL_BUF_RING)) {
+		buffer_list->flags |= IOBL_PINNED;
+		ret = 0;
+		*bl = buffer_list;
+	}
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_uring_buf_ring_pin);
+
+int io_uring_buf_ring_unpin(struct io_ring_ctx *ctx, unsigned buf_group,
+			    unsigned issue_flags)
+{
+	struct io_buffer_list *bl;
+	int ret = -EINVAL;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	bl = io_buffer_get_list(ctx, buf_group);
+	if (likely(bl) && (bl->flags & IOBL_BUF_RING) &&
+	    (bl->flags & IOBL_PINNED)) {
+		bl->flags &= ~IOBL_PINNED;
+		ret = 0;
+	}
+
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(io_uring_buf_ring_unpin);
+
 /* cap it at a reasonable 256, will be one page even for 4K */
 #define PEEK_MAX_IMPORT		256
 
@@ -743,6 +784,8 @@ int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg)
 		return -ENOENT;
 	if (!(bl->flags & IOBL_BUF_RING))
 		return -EINVAL;
+	if (bl->flags & IOBL_PINNED)
+		return -EBUSY;
 
 	scoped_guard(mutex, &ctx->mmap_lock)
 		xa_erase(&ctx->io_bl_xa, bl->bgid);
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 11d165888b8e..781630c2cc10 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -12,6 +12,11 @@ enum {
 	IOBL_INC		= 2,
 	/* buffers are kernel managed */
 	IOBL_KERNEL_MANAGED	= 4,
+	/*
+	 * buffer ring is pinned and cannot be unregistered by userspace until
+	 * it has been unpinned
+	 */
+	IOBL_PINNED		= 8,
 };
 
 struct io_buffer_list {
-- 
2.47.3


