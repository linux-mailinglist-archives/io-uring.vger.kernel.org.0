Return-Path: <io-uring+bounces-3181-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 60F98976EE9
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 18:40:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 20FD5281611
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 16:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E98421B373C;
	Thu, 12 Sep 2024 16:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tfapbNf3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCD72199948
	for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 16:40:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726159230; cv=none; b=O3uMOC0lO20DC1a1i1Aqf8qy7gEGFvd04ADKMi9d7gH8lhSStROIWERxhCkjJWheU8lp5iB3JRlgs8V8p22XwjfGZ9nHVRWJqlBGiImg3RmS3eFJR0ShSn/2x4Ul/st0SmNGx1Cph5DkriK3ALO3Ucdo94UkhrnbKoE9ZJavlhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726159230; c=relaxed/simple;
	bh=NOCt6VHX9d33XDA6YpeHy4pPVcxD0zpGGYsSBcZGiBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiPHKuFN4OO6IcqTzILb6qmg4SWI0K/IZUY497pwNA4qhlumfidIun59eicriWRyc7XlGZVe9xHsHWdop6a/i2SlqWj31FOMNGKrwL4X9uztymR+r5NFnUCfMRn4U443USKJ4zu4jUzQ9ElC3cR6G9G9b7xxdioL7sDXSdqy7R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tfapbNf3; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-82aa7c3b498so35830639f.1
        for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 09:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726159227; x=1726764027; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QOyADvkgWX4sIZiJCtHCCmIHsnfPyrAkAiM8Xmf+8mc=;
        b=tfapbNf3nP2HHSEurBZKTwNMNOyfYMXtkNXMrmQbWXy063WJa5PlXIiozIMWSHHcRk
         PxeQxceVrYe/ZdsrXUS7L6fMB9KO1CZ17AQ232DcudNpqbDidaUxTEMHOpgLo5ivGsPl
         WeI8Ls4GHSuPTgPWBP/yhtlPY1AvM4hoGC9GWLQVJbwEgfdp1zbE1B49neDmIPO2qHiE
         iyllHK8GaS4lE/z5TSnOa6Y90P07/RviB/9x+TAHOO/fa0/haKGuXscuDRwaxxEixSnf
         dm2Z/dFBk6WrBGSwxPr2yubg2qxIUS2KHJGHyMRQOXHkamDODInoQ117M6UjEVCqymZM
         sGDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726159227; x=1726764027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QOyADvkgWX4sIZiJCtHCCmIHsnfPyrAkAiM8Xmf+8mc=;
        b=JyflKMPuPr3mQ62PQTMRhmLlcyxxIuaIL8yAHV4k12isrRNtyMW5rNSIoYD/6fkFlY
         UkG2DPnyPJ7ot217g9GWd6BybPYsvDW0pfwYxt+7elk09iDg5kyJ8t37vqXm6jHQfSLY
         DQqQ54BY+zRIyot+aHViQkHm2gCGt7UNR4il1+GLQumCHlOyd4i3+r1psr+txnoYjRwq
         6/K2PjX3MxmhqbS8GScLnzYhtD6ehLiZAkbvRiIol3WOsQeS+wVNQWbH/7YOjvPJWwo8
         fM6mpXiA27rP0grqEbFCRT/yeuHrb+7XKKIqgXbtyfeUqTi/sq2eS+8h9OqoJSsyQs6q
         Bu7A==
X-Gm-Message-State: AOJu0YzvVe38W7K4vSQ6OoeFviJk8vffAYqgAT0b/hbiN3vfKamXWHsM
	7LW/i5VJXY8zXU7dkO8u3qTWqYXY20+0cRe270PNwMwlcYHXOb0yM11OagiQ+y0R7WM+UmamyXU
	B
X-Google-Smtp-Source: AGHT+IE+TjUyvaYoIpV2L09SS5lJG+fYLjFrSrTiwyWOtxZRv1kUfn3f+gkOBJOygd46mfAr571K+Q==
X-Received: by 2002:a05:6e02:1c4c:b0:375:acd3:31b3 with SMTP id e9e14a558f8ab-3a08461c41fmr29768485ab.5.1726159227442;
        Thu, 12 Sep 2024 09:40:27 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a05901625esm32564985ab.85.2024.09.12.09.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 09:40:26 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring: add IORING_REGISTER_COPY_BUFFERS method
Date: Thu, 12 Sep 2024 10:38:23 -0600
Message-ID: <20240912164019.634560-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240912164019.634560-1-axboe@kernel.dk>
References: <20240912164019.634560-1-axboe@kernel.dk>
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
 include/uapi/linux/io_uring.h | 13 +++++
 io_uring/register.c           |  6 +++
 io_uring/rsrc.c               | 91 +++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h               |  1 +
 4 files changed, 111 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index a275f91d2ac0..9dc5bb428c8a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -609,6 +609,9 @@ enum io_uring_register_op {
 
 	IORING_REGISTER_CLOCK			= 29,
 
+	/* copy registered buffers from source ring to current ring */
+	IORING_REGISTER_COPY_BUFFERS		= 30,
+
 	/* this goes last */
 	IORING_REGISTER_LAST,
 
@@ -694,6 +697,16 @@ struct io_uring_clock_register {
 	__u32	__resv[3];
 };
 
+enum {
+	IORING_REGISTER_SRC_REGISTERED = 1,
+};
+
+struct io_uring_copy_buffers {
+	__u32	src_fd;
+	__u32	flags;
+	__u32	pad[6];
+};
+
 struct io_uring_buf {
 	__u64	addr;
 	__u32	len;
diff --git a/io_uring/register.c b/io_uring/register.c
index d90159478045..dab0f8024ddf 100644
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
index 28f98de3c304..40696a395f0a 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -17,6 +17,7 @@
 #include "openclose.h"
 #include "rsrc.h"
 #include "memmap.h"
+#include "register.h"
 
 struct io_rsrc_update {
 	struct file			*file;
@@ -1137,3 +1138,93 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
 	return 0;
 }
+
+static int io_copy_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
+{
+	struct io_mapped_ubuf **user_bufs;
+	struct io_rsrc_data *data;
+	int i, ret, nbufs;
+
+	/*
+	 * Drop our own lock here. We'll setup the data we need and reference
+	 * the source buffers, then re-grab, check, and assign at the end.
+	 */
+	mutex_unlock(&ctx->uring_lock);
+
+	mutex_lock(&src_ctx->uring_lock);
+	ret = -ENXIO;
+	nbufs = src_ctx->nr_user_bufs;
+	if (!nbufs)
+		goto out_unlock;
+	ret = io_rsrc_data_alloc(ctx, IORING_RSRC_BUFFER, NULL, nbufs, &data);
+	if (ret)
+		goto out_unlock;
+
+	ret = -ENOMEM;
+	user_bufs = kcalloc(nbufs, sizeof(*ctx->user_bufs), GFP_KERNEL);
+	if (!user_bufs)
+		goto out_free_data;
+
+	for (i = 0; i < nbufs; i++) {
+		struct io_mapped_ubuf *src = src_ctx->user_bufs[i];
+
+		refcount_inc(&src->refs);
+		user_bufs[i] = src;
+	}
+
+	/* Have a ref on the bufs now, drop src lock and re-grab our own lock */
+	mutex_unlock(&src_ctx->uring_lock);
+	mutex_lock(&ctx->uring_lock);
+	if (!ctx->user_bufs) {
+		ctx->user_bufs = user_bufs;
+		ctx->buf_data = data;
+		ctx->nr_user_bufs = nbufs;
+		return 0;
+	}
+
+	/* someone raced setting up buffers, dump ours */
+	for (i = 0; i < nbufs; i++)
+		io_buffer_unmap(ctx, &user_bufs[i]);
+	io_rsrc_data_free(data);
+	kfree(user_bufs);
+	return -EBUSY;
+out_free_data:
+	io_rsrc_data_free(data);
+out_unlock:
+	mutex_unlock(&src_ctx->uring_lock);
+	mutex_lock(&ctx->uring_lock);
+	return ret;
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
+	bool registered_src;
+	struct file *file;
+	int ret;
+
+	if (ctx->user_bufs || ctx->nr_user_bufs)
+		return -EBUSY;
+	if (copy_from_user(&buf, arg, sizeof(buf)))
+		return -EFAULT;
+	if (buf.flags & ~IORING_REGISTER_SRC_REGISTERED)
+		return -EINVAL;
+	if (memchr_inv(buf.pad, 0, sizeof(buf.pad)))
+		return -EINVAL;
+
+	registered_src = (buf.flags & IORING_REGISTER_SRC_REGISTERED) != 0;
+	file = io_uring_register_get_file(buf.src_fd, registered_src);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+	ret = io_copy_buffers(ctx, file->private_data);
+	if (!registered_src)
+		fput(file);
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


