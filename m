Return-Path: <io-uring+bounces-3155-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4A915975BC2
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 22:30:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 078AE287520
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 20:30:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7C62F1B150F;
	Wed, 11 Sep 2024 20:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZueaWWoW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8414D7DA9C
	for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 20:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726086631; cv=none; b=hL/Z8fcQ3v7H57S/AKNwCsh7jd25EmFmKipIDEGSpZKRjD5zzLvdkilyrAbNHPO4EOKCf5i/lfe3g1JrctoXCcQ/PeUDlfuilNcN7bH7m3IMEdYzLywD3JnK6Vq+Q+ec2kM89HXdxBV42gQ+1PuLoWFmRS1hChEpTHzaj5cx1Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726086631; c=relaxed/simple;
	bh=J0gjB2X7/k+nBqFg6DA6HRhFcTFOnlZDK8jzIkKCBsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TwpSGyQQl2tkP0iGHqH4BCUnBbuDhelzwlIT8NFNMXrBHKxYz5SsAold9o6dxYWlnPjSQTnBqF9lUBGX9f/WmxqCCe9E7zwq9aPK2wrPQ9OZAHuNaqUbNrp1PRMEip8zcvUurTx2/sJWJNzr2Jf7q69EPmn8+Pxsmea7blgXbEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZueaWWoW; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-82aa3f65864so8790739f.2
        for <io-uring@vger.kernel.org>; Wed, 11 Sep 2024 13:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726086628; x=1726691428; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SBbgqLjwU1cfqThy8NlSSBjOLmfIDQJ7BLoWNPWdLms=;
        b=ZueaWWoW54yK/zzBxYGbMXFWnF1Jm+1VszL/fA2RNe20nWb0+3a7a/m4WFLJ8TYJlG
         sNTZph+wQfr8znwCEjGH/LkfU9XxN0HGZxR00zdQUEvrCEs8X11CZ+gp6jMobW1UzuwO
         t65Lnnd59W314tsBxHXdbvHZD1Rkv1vMjuQyEJErNUGjCr34Y4paiMcOhJWDctG52qGS
         jw8zL6GR8MLMib9PNxlhevfbCSUMXLixy6oj+8MaA+RdYdlzfCPM8gFbt8RNDs0ZCI51
         NFxshOSDHUeYfPv7i56a54WFo5fw3vjiiDS8MeTMcX2NquFT/uA0Hl6IIFQPcM2yi9Qx
         5hCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726086628; x=1726691428;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SBbgqLjwU1cfqThy8NlSSBjOLmfIDQJ7BLoWNPWdLms=;
        b=PtOwwQ4NUmvadZOad6YaCsdRbqUNwKFUMiPKg+zoU2hyC5Cuu39hRr42Ox+4+HNgwa
         GdBbecW2wGVS0OtQe8iNCSN2jfzGuk9k1Y46Xpt5LwNjkAURZGfEIi2MOTk6fzqviSe9
         s9REj7OR7LSzkFviOm8G/GHVRRnkC6Wy247/0hQs/whcKAZSg0OTBJJBZeyrhyEi3S5L
         smcgEVYk2yK2Go4AsYm62DT1d77IPFq4BUNMtASM9AEpIFZm4pwYZx9Visyd0MFBBYeK
         lRgFH0GcbCrPCmbzMVTEDTl/hil4V2wLzvMV9Ub/CumfZeeDzJqZD6muEgz2nCee+QPI
         w1ag==
X-Gm-Message-State: AOJu0YyMKm28MCcdpEDjK5ZqTLvRBWXAq5Qy8DpjEqEI921tx7SshjOJ
	TuUvaP9eJeNS0RT6mFASIobRji5oF06bUE70V71n/mecdT76Jm+nPwBkcissRrUHaKSIjU1vCjg
	Gb+g=
X-Google-Smtp-Source: AGHT+IGULWhy/fc7PHkx/GD50PpGWAIgN9lusGKymfd92uT46AgW7C5fSTm3RaePDONUQZKopGUa4w==
X-Received: by 2002:a05:6602:1344:b0:825:bdf:aecf with SMTP id ca18e2360f4ac-82d1f93f6femr96095739f.11.1726086628198;
        Wed, 11 Sep 2024 13:30:28 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d35f433d60sm185173173.26.2024.09.11.13.30.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 13:30:27 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: add IORING_REGISTER_COPY_BUFFERS method
Date: Wed, 11 Sep 2024 14:29:41 -0600
Message-ID: <20240911203021.416244-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240911203021.416244-1-axboe@kernel.dk>
References: <20240911203021.416244-1-axboe@kernel.dk>
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
 io_uring/rsrc.c               | 90 +++++++++++++++++++++++++++++++++++
 io_uring/rsrc.h               |  1 +
 4 files changed, 105 insertions(+)

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
index 28f98de3c304..e94b6ab6e749 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1137,3 +1137,93 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
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
+	ret = io_copy_buffers(ctx, f.file->private_data);
+	fdput(f);
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


