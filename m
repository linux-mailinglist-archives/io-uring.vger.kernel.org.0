Return-Path: <io-uring+bounces-11188-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 94AE0CCAF47
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:41:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0311C30E4E2D
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:35:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 420E3185955;
	Thu, 18 Dec 2025 08:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GaUJ/Fg9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755023314B7
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046889; cv=none; b=KSoosQyPDq3s+mlD31fSD3Kmsd9CE9p1Cal27Eo18n6ITJKWTaBxxZzFmuVMdySNqpsPnMdVOiy8zGF/dFgYcXcHkXer/feYLECmo5ypQ04dITtT+7UlaI7H5lsap8S4xuTO5mgPhtzTLsQBfaF4yWT6z/psb2H7PZ8jSsp1QF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046889; c=relaxed/simple;
	bh=9kYMGOrHb3wl/0cEqDb01/TiX6ovIKjmJdmUpX+3jZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eQ2DoovedPjHVtgdluelFH+iO6YANOMmFaqvr2dHBD0xTKldHBr2FOreqtSxX29DnrLeHcpGfwBJrWrF1cdGPmlLS3SQxBOc5G0p4l8XffxhiczM2vFg0s4q1qJF25AmxiOlROjbca/+/QxS/kkAZZKMKoXXXTF0Ma9SupAPUQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GaUJ/Fg9; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a09757004cso4308395ad.3
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:34:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046887; x=1766651687; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ck2Q1qPyrUc/Jo+wdlrTe48UP28F3NhBZmyq0UwZoeM=;
        b=GaUJ/Fg9fnYqnRKVFodBLHgJv5R8JajMUTKbaPE9cZ8Y0JfjzhoVZeJa/jXZGD8gLW
         fVe1LZs1QBa1TiI5B6uv5G/u2xwfh51sNOKwQyii99f7WXixkqjJvSn0ieD1UB0kirbM
         nnIDKZEj9SVQLpODfoL9yxB5o8oglBjeTQCmY1k4hUxwRFi3uhgPST997b+3hb2fXnv+
         4X2y+beKVuUEsjAy/CZ6yZr1QW0s7JFj3KOQMAiN5piDodV9WXm03Q3S7WO0T7dPyf8o
         ozigWFmrJfo4Ik0ta9JAvYfZXthXQi3VDfRt++IYjUT6sjghLvxRnT0NB0i4aRqF+xn8
         lFrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046887; x=1766651687;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ck2Q1qPyrUc/Jo+wdlrTe48UP28F3NhBZmyq0UwZoeM=;
        b=YSU6jC6PxH4eEkuZUh+BFZwWiQaIQPEmLLgBMxZ1xLytQXCy4GfSrZ/M9lERhsLvAY
         2K+JxND13CTeOg9tE1thNey4otEkQcXrQ6f9pnmhJ2mDoB26h1RttWyCl2RFI7HSIpwq
         pW8qetXF7yndxyv9Jy/2JW5OK40+Z0QXj2uM3qlng7vKmRHJO79XoPU0AAPkzIEZIdUp
         uzhDWYmPxzgLpOGX5pXCOcyS7HEXWfir72Bt4vbGIegOEPiW2luFJn9t+mClsxUGaXrX
         jBvqyLIY1R08l0Kh/YBLxyVHnzg1skr4tKAvz5jBVrXovb10LqbeSCkHoSgXV0cXDuac
         qmwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUmS3Nw89iZ0bkf68GJLi0BWtK87aE3XLfBO60S8/q2GZi515J5oKpRBuzdFWLTnTRnsZsWU+MMg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8Py2+FXF5MLBc+vulFNL8x45u/vgrmUuHXbzpQsu2Js2PC4Jj
	P1lE6xcRwE3FtI0qIkbenI0BLW60bXWRcIuOsJf40d1JeIgxrtz06K+W
X-Gm-Gg: AY/fxX4umNZqGN85vXb4MBMnd9ebJDgncCLLcIrW5+0pyDdNIja7pdXLspAiCzSjrIq
	DsMDfmdZMbreFmPYVjH7neb1faffXcZFFuvo7I9tXAka6gWm/3Q/BiGKdy/VjK6sUSmlz5lCkI5
	2K+6RFbu0FlUaSszqveZ7FRs4E8Ws0wsPUnSBRAA7Wx3iOVZah6viNxmQWKiR2/xiP2c+zkjoLH
	LN5U3JQ/xPI18pNp4EYslmRohbWEURANqW7TGgzvVA6t75a+RP43AkDOyZEjJdSLz6FNhy5yQBx
	SixgRseuoZmxy078uRtDaaiI+YdgnKv7x0PMOJo4MhVFLJ9t2uCFj8DmNr4UIMQZhRWZcvNInOM
	LRrqbw3wLXG8bAnNhTcgwxdDlIJxRNOOR0CsJWYSAh4qexGVcODRkYhQaqYQImJz5dfhw01xtuo
	aa8h+A+cg3iKSYn2O3kw==
X-Google-Smtp-Source: AGHT+IFAcDH9zelRJ4OI8gmQ4uQVVRSRZtjPNZnV1lVmffwN2Pd8oW34JwjR0mVqgVQ+yPlJJgoNhg==
X-Received: by 2002:a17:903:40cb:b0:2a1:3ade:c351 with SMTP id d9443c01a7336-2a13adec455mr94347995ad.2.1766046886896;
        Thu, 18 Dec 2025 00:34:46 -0800 (PST)
Received: from localhost ([2a03:2880:ff:5d::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d1926d2esm17280575ad.70.2025.12.18.00.34.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:34:46 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 08/25] io_uring: add io_uring_cmd_fixed_index_get() and io_uring_cmd_fixed_index_put()
Date: Thu, 18 Dec 2025 00:33:02 -0800
Message-ID: <20251218083319.3485503-9-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add two new helpers, io_uring_cmd_fixed_index_get() and
io_uring_cmd_fixed_index_put(). io_uring_cmd_fixed_index_get()
constructs an iter for a fixed buffer at a given index and acquires a
refcount on the underlying node. io_uring_cmd_fixed_index_put()
decrements this refcount. The caller is responsible for ensuring
io_uring_cmd_fixed_index_put() is properly called for releasing the
refcount after it is done using the iter it obtained through
io_uring_cmd_fixed_index_get().

This is a preparatory patch needed for fuse-over-io-uring support, as
the metadata for fuse requests will be stored at the last index, which
will be different from the buf index set on the sqe.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h | 20 +++++++++++
 io_uring/rsrc.c              | 65 ++++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h              |  5 +++
 io_uring/uring_cmd.c         | 21 ++++++++++++
 4 files changed, 111 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 7169a2a9a744..2988592e045c 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -44,6 +44,12 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 				  size_t uvec_segs,
 				  int ddir, struct iov_iter *iter,
 				  unsigned issue_flags);
+int io_uring_cmd_fixed_index_get(struct io_uring_cmd *ioucmd, u16 buf_index,
+				 unsigned int off, size_t len, int ddir,
+				 struct iov_iter *iter,
+				 unsigned int issue_flags);
+int io_uring_cmd_fixed_index_put(struct io_uring_cmd *ioucmd, u16 buf_index,
+				 unsigned int issue_flags);
 
 /*
  * Completes the request, i.e. posts an io_uring CQE and deallocates @ioucmd
@@ -109,6 +115,20 @@ static inline int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 {
 	return -EOPNOTSUPP;
 }
+static inline int io_uring_cmd_fixed_index_get(struct io_uring_cmd *ioucmd,
+					       u16 buf_index, unsigned int off,
+					       size_t len, int ddir,
+					       struct iov_iter *iter,
+					       unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
+static inline int io_uring_cmd_fixed_index_put(struct io_uring_cmd *ioucmd,
+					       u16 buf_index,
+					       unsigned int issue_flags)
+{
+	return -EOPNOTSUPP;
+}
 static inline void __io_uring_cmd_done(struct io_uring_cmd *cmd, s32 ret,
 		u64 ret2, unsigned issue_flags, bool is_cqe32)
 {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index a63474b331bf..a141aaeb099d 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1151,6 +1151,71 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
 }
 
+int io_reg_buf_index_get(struct io_kiocb *req, struct iov_iter *iter,
+			 u16 buf_index, unsigned int off, size_t len,
+			 int ddir, unsigned issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_rsrc_node *node;
+	struct io_mapped_ubuf *imu;
+	u64 addr;
+	int err;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	node = io_rsrc_node_lookup(&ctx->buf_table, buf_index);
+	if (!node) {
+		io_ring_submit_unlock(ctx, issue_flags);
+		return -EINVAL;
+	}
+
+	node->refs++;
+
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	imu = node->buf;
+	if (!imu) {
+		err = -EFAULT;
+		goto error;
+	}
+
+	if (check_add_overflow(imu->ubuf, off, &addr)) {
+		err = -EINVAL;
+		goto error;
+	}
+
+	err = io_import_fixed(ddir, iter, imu, addr, len);
+	if (err)
+		goto error;
+
+	return 0;
+
+error:
+	io_reg_buf_index_put(req, buf_index, issue_flags);
+	return err;
+}
+
+int io_reg_buf_index_put(struct io_kiocb *req, u16 buf_index,
+			 unsigned issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_rsrc_node *node;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	node = io_rsrc_node_lookup(&ctx->buf_table, buf_index);
+	if (WARN_ON_ONCE(!node)) {
+		io_ring_submit_unlock(ctx, issue_flags);
+		return -EFAULT;
+	}
+
+	io_put_rsrc_node(ctx, node);
+
+	io_ring_submit_unlock(ctx, issue_flags);
+
+	return 0;
+}
+
 /* Lock two rings at once. The rings must be different! */
 static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index d603f6a47f5e..16f4bab9582b 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -64,6 +64,11 @@ struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
 			unsigned issue_flags);
+int io_reg_buf_index_get(struct io_kiocb *req, struct iov_iter *iter,
+			 u16 buf_index, unsigned int off, size_t len,
+			 int ddir, unsigned issue_flags);
+int io_reg_buf_index_put(struct io_kiocb *req, u16 buf_index,
+			 unsigned issue_flags);
 int io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
 			unsigned nr_iovs, unsigned issue_flags);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index b6b675010bfd..ee95d1102505 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -314,6 +314,27 @@ int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_vec);
 
+int io_uring_cmd_fixed_index_get(struct io_uring_cmd *ioucmd, u16 buf_index,
+				 unsigned int off, size_t len, int ddir,
+				 struct iov_iter *iter,
+				 unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	return io_reg_buf_index_get(req, iter, buf_index, off, len, ddir,
+				    issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_fixed_index_get);
+
+int io_uring_cmd_fixed_index_put(struct io_uring_cmd *ioucmd, u16 buf_index,
+				 unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	return io_reg_buf_index_put(req, buf_index, issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_fixed_index_put);
+
 void io_uring_cmd_issue_blocking(struct io_uring_cmd *ioucmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
-- 
2.47.3


