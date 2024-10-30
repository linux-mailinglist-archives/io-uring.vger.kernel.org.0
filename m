Return-Path: <io-uring+bounces-4216-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E3959B6A23
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 18:06:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A754E1C24379
	for <lists+io-uring@lfdr.de>; Wed, 30 Oct 2024 17:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A45722144CA;
	Wed, 30 Oct 2024 16:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="sjInozAr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79064216DF4
	for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 16:56:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730307365; cv=none; b=GBeFpG9XJM6abs81kOPe4PGxM+m/SWHy9U789fRJQOjwv+YKNi0y3nnzeW7xZacrUJrtqTg5KzcM/CYz4fKWsG39s4dlmgRffPnCxTRF6aQUG/1eZ0Rd9p0o8BTwxMeqar11ywhPQBYIkptGwAT1TExkLpkgUgWAsj3gLtWGnQQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730307365; c=relaxed/simple;
	bh=lcGdlJ+3vLsvMeLLoZ9QUn/wXitDr6CVaNPwpzL4eIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rTsQ6hE87XZr3Eciv2+eYv0CvwknJ9eZz7aeo70oWu7+lb+SAWT0ps0YmlQLW/l5lTK+4qKS+E4ifeEF/LI4IUP1T/bGxNSzi2adAaLUc6IsDq2DzNBNFVxVrMvjz2nRMPGsFWNThEwYUTGQYimsHbTB358Te+Kft6kzL9gE/JU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=sjInozAr; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-83abe7fc77eso496939f.0
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 09:56:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730307361; x=1730912161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=blxrd0FPf8Rf/M17PamX1CjchvMtlhApoYVKVRAkJZM=;
        b=sjInozArN3HC2B26UWDcVg6kCZw7+vWiHXxeTRyEcSCXkQIGW3s+h37YCiQ/XyNZ25
         JuvpRdPVjITQhZ5XxLhJlsop5/ITNEr/mMkoDqAlgjEKJHsPjWOUaTOrU7mqDOAw5Gw4
         cB/r3OLAyVBK+Mzd3NX7Iq61IZYGPwPeqkoo7UG9OHfc2/yuMF+JGnuvJeFqAu2Mgc7F
         QIvoBDGEq0n/gQ0gUf6Zucr3Jc44NaxYfx+VkcspLA9TdnGwA5Bkzb5nhA1ZAAiLHPJB
         e4p9xSmSHnuJ4VjRafGDS9sUy8JpUown5ISfacsjMTJ+qZ29V5u5WKy40RGz6PpmwbbU
         ltvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730307361; x=1730912161;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=blxrd0FPf8Rf/M17PamX1CjchvMtlhApoYVKVRAkJZM=;
        b=NHksszIpjLavcIosCn5cYZEEA1Y+doUf4ur4grC9SbgyiuTG7BP+CvyZ9z8DFTvEZj
         iacojkPChkNXc5qzKBl3gSX7DYDGr8RghL0Nc8Bqy2N+MsazSogqK7IuNk+NL3mj4B8X
         7PsuwuFTvtmU0MmL0F24yJkKevIRdtZVE8OowvBUyfcdFre7OtWicm6UlNjAQuLI3ia3
         Tzx9iviY+sxOpjId5MqoqzBieg4qwx0eEHA7/KZR4JP+5gqiDzA79grFhljG+LusqvNc
         JPmbtUTDjlk+lVbhBBdmMsDln9fqHQwJ6TBnuFxeM9oPR+WqdLaxnDch2kti2OSxnCkG
         7txg==
X-Gm-Message-State: AOJu0YyECIfUf5zKlDaz73hCyeVnVbFHdkGY1TJmTK84YMtnuZUEnhKL
	PZXjbci1GtrKHWKfMx43QIFaDgZ0QM+1BkADDxisOB01SUYoqD55UA3dncVRbL2pCGj9yivIy5Z
	cUjo=
X-Google-Smtp-Source: AGHT+IFNx87notWmFat7BB2ag4wPbQrXYjFoBbrRzLi6WLQVYiVypcpFMrXJDdS81ZnrkScJotjqvw==
X-Received: by 2002:a05:6602:1603:b0:83a:f443:875 with SMTP id ca18e2360f4ac-83b1c5cd7bdmr1123032839f.15.1730307360896;
        Wed, 30 Oct 2024 09:56:00 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc727505fdsm2980035173.120.2024.10.30.09.55.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 09:55:59 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/rsrc: allow cloning at an offset
Date: Wed, 30 Oct 2024 10:54:14 -0600
Message-ID: <20241030165556.64918-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241030165556.64918-1-axboe@kernel.dk>
References: <20241030165556.64918-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Right now buffer cloning is an all-or-nothing kind of thing - either the
whole table is cloned from a source to a destination ring, or nothing at
all.

However, it's not always desired to clone the whole thing. Allow for
the application to specify a source and destination offset, and a
number of buffers to clone. If the destination offset is non-zero, then
allocate sparse nodes upfront.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  5 ++++-
 io_uring/rsrc.c               | 36 +++++++++++++++++++++++++++++------
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 024745283783..cc8dbe78c126 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -719,7 +719,10 @@ enum {
 struct io_uring_clone_buffers {
 	__u32	src_fd;
 	__u32	flags;
-	__u32	pad[6];
+	__u32	src_off;
+	__u32	dst_off;
+	__u32	nr;
+	__u32	pad[3];
 };
 
 struct io_uring_buf {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index af60d9f597be..4c149dc42fd7 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -924,10 +924,11 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 	return 0;
 }
 
-static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
+static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx,
+			    struct io_uring_clone_buffers *arg)
 {
+	int i, ret, nbufs, off, nr;
 	struct io_rsrc_data data;
-	int i, ret, nbufs;
 
 	/*
 	 * Drop our own lock here. We'll setup the data we need and reference
@@ -940,11 +941,33 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	nbufs = src_ctx->buf_table.nr;
 	if (!nbufs)
 		goto out_unlock;
-	ret = io_rsrc_data_alloc(&data, nbufs);
+	ret = -EINVAL;
+	if (!arg->nr)
+		arg->nr = nbufs;
+	else if (arg->nr > nbufs)
+		goto out_unlock;
+	ret = -EOVERFLOW;
+	if (check_add_overflow(arg->nr, arg->src_off, &off))
+		goto out_unlock;
+	if (off > nbufs)
+		goto out_unlock;
+	if (check_add_overflow(arg->nr, arg->dst_off, &off))
+		goto out_unlock;
+	ret = -EINVAL;
+	if (off > IORING_MAX_REG_BUFFERS)
+		goto out_unlock;
+	ret = io_rsrc_data_alloc(&data, off);
 	if (ret)
 		goto out_unlock;
 
-	for (i = 0; i < nbufs; i++) {
+	/* fill empty/sparse nodes, if needed */
+	for (i = 0; i < arg->dst_off; i++)
+		data.nodes[i] = rsrc_empty_node;
+
+	off = arg->dst_off;
+	i = arg->src_off;
+	nr = arg->nr;
+	while (nr--) {
 		struct io_rsrc_node *dst_node, *src_node;
 
 		src_node = io_rsrc_node_lookup(&src_ctx->buf_table, i);
@@ -960,7 +983,8 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 			refcount_inc(&src_node->buf->refs);
 			dst_node->buf = src_node->buf;
 		}
-		data.nodes[i] = dst_node;
+		data.nodes[off++] = dst_node;
+		i++;
 	}
 
 	/* Have a ref on the bufs now, drop src lock and re-grab our own lock */
@@ -1015,7 +1039,7 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	file = io_uring_register_get_file(buf.src_fd, registered_src);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
-	ret = io_clone_buffers(ctx, file->private_data);
+	ret = io_clone_buffers(ctx, file->private_data, &buf);
 	if (!registered_src)
 		fput(file);
 	return ret;
-- 
2.45.2


