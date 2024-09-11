Return-Path: <io-uring+bounces-3150-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CE462975B59
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 22:07:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5BD981F237DA
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 20:07:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E613A1BB69B;
	Wed, 11 Sep 2024 20:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="BkRhxO6O"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E60A1BB68A
	for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 20:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726085238; cv=none; b=JVXgcp2cUMMCdxnwWRtCJByV86gZif2Bh0ZRXkDiMLVi1MysqOyBby7xX4uZl4+poN+1VVVUan8bHNDfSVq8ePvOLsAgTG48XFXiWwdB8I9t+I43pXXWcy+QdQnpA6PPcMsQxGBy3SoWVNxaB1TFAhT+H68tNCfSMpwbfoHxNvI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726085238; c=relaxed/simple;
	bh=1IENyLVxBbf275YJepuPuoTyGijjBxXH9nbHfeHWVMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GsSBVcoNavkqJGtlj6Pt8V0k8LZ26mWiAMjosghOT5XubBnR0cFWo0yLdTAvR5jMUP1g6HX9a/IbMMuiuJhcLcKoix/CrSsChpH8Dm2czp38/+W0fAq/uulaWZKvEbQ3S0HeEKmco8WNuCYDoW+N0z4cstczwWt66R6D441hU3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=BkRhxO6O; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-82ce603d8daso8414439f.0
        for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 13:07:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726085235; x=1726690035; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i4tU7LEUGPDS044ZxK5FLvvmyHLd9d6Z6C5FQWmHWJs=;
        b=BkRhxO6O/939c40OzApXS6bfoEPzWavdE/ziYL4k2Mn1cHG4CJoys0BZVvrjwOly+K
         pzymGY8+kyuIux8g3Aj22If6eBE/PlmTuqW/kG/RzIzbGO2aDA2r5w70elh8odZRGXcF
         Z7ECDW0XgdkyXCw1G9I9Zpp2wRoNnchwtAppuLkW//7ssKwQQQeFtufdZ9clOQr7bi8r
         YdZIVIz5Xf2k32KcgxqK+uBOC6IN0ESM7cWq3MIlpiwespuIDi+iTCsO/5VBc7fU/WjS
         PxXOfPovM2pQXSIEyJCd5dQ9SqgQTisMUiensCB/z9Up9muglwwcCtwXrakZ/FuDLrH1
         9e3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726085235; x=1726690035;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i4tU7LEUGPDS044ZxK5FLvvmyHLd9d6Z6C5FQWmHWJs=;
        b=KozrtbwLFf0j3ytLq8uZ83Lny/ssIGzMzDt32TOCpaQ2SKUbEqxTrp2eIqyGPn1z1X
         r8DhOlBcEPdYFrpV/Dhz7qPCjPVcFwnLdwqpu7M+ScvweHuS830j2p1qOdqRmGcWSiHC
         J8ynitHFOF/2bTiJm3ugaO3aPAVaDaOeBOlcSgcuT3IJvQ+QYMJvT2kLSllk4zr9X3af
         u/9RcOPlJIIyAu+SEXLcHsVVzinA5TYqCy1x1gDqUXryw76OMHG4E0bUyCpOuFd93Irm
         zTI30EapD6lmx3bp3KTNa15e7mIKIpQT3fjKCxT+CYloZrSHdLQH+7hJgMSNLXLP/Niy
         Ep4A==
X-Gm-Message-State: AOJu0YxubGcjusCoGWiJYDqn95up7nYkC4BPk8vBihPGS1PaOibcjHNu
	N1KcI1kToC/xDFFYV2/4AlvxkaZ81MT+dNDfv6C6v9ApUiL3/U40cgfzIRYUjs9lrvFJDvKp9ba
	yaNo=
X-Google-Smtp-Source: AGHT+IE/2kUyRiKN6qmX5o0uWGKNPSvAD7bHBxG89jbjj7qab2dcKChIVkc+Qr2NetAzvLMz7qj8RA==
X-Received: by 2002:a05:6602:6d01:b0:82d:949:ff8b with SMTP id ca18e2360f4ac-82d1f8cc470mr100977639f.6.1726085235039;
        Wed, 11 Sep 2024 13:07:15 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82aa733a1d6sm289860239f.1.2024.09.11.13.07.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 13:07:13 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: add IORING_REGISTER_COPY_BUFFERS method
Date: Wed, 11 Sep 2024 14:03:54 -0600
Message-ID: <20240911200705.392343-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240911200705.392343-1-axboe@kernel.dk>
References: <20240911200705.392343-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Buffers can get registered with io_uring, which allows to skip the
repeated pin_pages, unpin/unref pages for each O_DIRECT operation. This
reduces the overhead of O_DIRECT IO.

However, registrering buffers can take some time. Normally this isn't an
issue as it's done at initialization time (and hence less critical), but
for cases where rings can be created and destroyed as part of an IO
thread pool, registering the same buffers for multiple rings become a
more time sensitive proposition. As an example, let's say an application
has an IO memory pool of 500G. Initial registration takes:

Got 500 huge pages (each 1024MB)
Registered 500 pages in 409 msec

or about 0.4 seconds. If we go higher to 900 1GB huge pages being
registered:

Registered 900 pages in 738 msec

which is, as expected, a fully linear scaling.

Rather than have each ring pin/map/register the same buffer pool,
provide an io_uring_register(2) opcode to simply duplicate the buffers
that are registered with another ring. Adding the same 900GB of
registered buffers to the target ring can then be accomplished in:

Copied 900 pages in 17 usec

While timing differs a bit, this provides around a 25,000-40,000x
speedup for this use case.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  8 ++++
 io_uring/register.c           |  6 +++
 io_uring/rsrc.c               | 84 +++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h               |  1 +
 4 files changed, 99 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a275f91d2ac0..7b15216a3d7f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -609,6 +609,9 @@ enum io_uring_register_op {
 
 	IORING_REGISTER_CLOCK			= 29,
 
+	/* copy registered buffers from source ring to current ring */
+	IORING_REGISTER_COPY_BUFFERS		= 30,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -694,6 +697,11 @@ struct io_uring_clock_register {
 	__u32	__resv[3];
 };
 
+struct io_uring_copy_buffers {
+	__u32	src_fd;
+	__u32	pad[7];
+};
+
 struct io_uring_buf {
 	__u64	addr;
 	__u32	len;
diff --git a/io_uring/register.c b/io_uring/register.c
index 57cb85c42526..c8670de33343 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -542,6 +542,12 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			break;
 		ret = io_register_clock(ctx, arg);
 		break;
+	case IORING_REGISTER_COPY_BUFFERS:
+		ret = -EINVAL;
+		if (!arg || nr_args != 1)
+			break;
+		ret = io_register_copy_buffers(ctx, arg);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 28f98de3c304..457492c6a329 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1137,3 +1137,87 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
 	return 0;
 }
+
+/*
+ * Return with both ctx and src_ctx locked, locking the lowest valued ctx
+ * first to prevent deadlocks for the same operation with ctxs switched.
+ */
+static int lock_src_ctx(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
+{
+	if (ctx == src_ctx) {
+		return -EINVAL;
+	} else if (ctx > src_ctx) {
+		mutex_unlock(&ctx->uring_lock);
+		mutex_lock(&src_ctx->uring_lock);
+		mutex_lock(&ctx->uring_lock);
+	} else {
+		mutex_lock(&src_ctx->uring_lock);
+	}
+
+	return 0;
+}
+
+static int io_copy_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
+{
+	struct io_rsrc_data *data;
+	int i, ret, nbufs;
+
+	nbufs = src_ctx->nr_user_bufs;
+	if (!nbufs)
+		return -ENXIO;
+	ret = io_rsrc_data_alloc(ctx, IORING_RSRC_BUFFER, NULL, nbufs, &data);
+	if (ret)
+		return ret;
+	ret = io_buffers_map_alloc(ctx, nbufs);
+	if (ret) {
+		io_rsrc_data_free(data);
+		return ret;
+	}
+
+	for (i = 0; i < nbufs; i++) {
+		struct io_mapped_ubuf *src = src_ctx->user_bufs[i];
+
+		refcount_inc(&src->refs);
+		ctx->user_bufs[i] = src;
+	}
+	ctx->buf_data = data;
+	ctx->nr_user_bufs = nbufs;
+	return 0;
+}
+
+/*
+ * Copy the registered buffers from the source ring whose file descriptor
+ * is given in the src_fd to the current ring. This is identical to registering
+ * the buffers with ctx, except faster as mappings already exist.
+ *
+ * Since the memory is already accounted once, don't account it again.
+ */
+int io_register_copy_buffers(struct io_ring_ctx *ctx, void __user *arg)
+{
+	struct io_uring_copy_buffers buf;
+	struct io_ring_ctx *src_ctx;
+	struct fd f;
+	int ret;
+
+	if (ctx->user_bufs || ctx->nr_user_bufs)
+		return -EBUSY;
+	if (copy_from_user(&buf, arg, sizeof(buf)))
+		return -EFAULT;
+	if (memchr_inv(buf.pad, 0, sizeof(buf.pad)))
+		return -EINVAL;
+
+	f = fdget(buf.src_fd);
+	if (!f.file)
+		return -EBADF;
+	if (!io_is_uring_fops(f.file)) {
+		fdput(f);
+		return -EBADF;
+	}
+
+	src_ctx = f.file->private_data;
+	ret = lock_src_ctx(ctx, src_ctx);
+	if (!ret)
+		ret = io_copy_buffers(ctx, src_ctx);
+	mutex_unlock(&src_ctx->uring_lock);
+	return ret;
+}
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 98a253172c27..93546ab337a6 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -68,6 +68,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len);
 
+int io_register_copy_buffers(struct io_ring_ctx *ctx, void __user *arg);
 void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
-- 
2.45.2


