Return-Path: <io-uring+bounces-4251-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F3369B7236
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 02:49:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F21112864B2
	for <lists+io-uring@lfdr.de>; Thu, 31 Oct 2024 01:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5759881E;
	Thu, 31 Oct 2024 01:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SYxke/hT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F66E347C7
	for <io-uring@vger.kernel.org>; Thu, 31 Oct 2024 01:46:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730339197; cv=none; b=spg4FlSkgnbM9AOSHXYz5ss80v0hJyXrTolvpVIqOc27QkOi4sJxEfdUi2SjQ9JH2HeKoci2jQTyfBNjD4GHWt0eszgxAmyXs/iAlTVJ1O+vEKUGDDyBRujpKpULWEk6otvkmo2vdyLvh1bS6sCpoVimiUHa97wsx0HVQ0eqzVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730339197; c=relaxed/simple;
	bh=PbH1j+fZaPdDtkkmbuVnZPa6xzqSUyInpSFBa9a3dEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j4JLyZ3pL2guQc881QBHIynwP1n7RXpT9neJu8vGBaBzFvZXEknvtV3YMrhdRGRLsmELdCV0npx/ihvRoxrzi1T1EYtd6V0cz6uv3WkW4g85jTf1NcuI8VSXaFbgk9FSJhb79WPsNbyURW4wA2INhYyUA/EiWOUuVD3ZpXxFmJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SYxke/hT; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-7db54269325so370606a12.2
        for <io-uring@vger.kernel.org>; Wed, 30 Oct 2024 18:46:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730339194; x=1730943994; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jceATRRhfvFKaozUeKEnWqCrQKui6P7HwDJln3J5Tvs=;
        b=SYxke/hTS9iDxgqD6C1JANclYr4kmc/gnKqRG9bf/2Hrb2lIelSzyrQOmi61addv3F
         k8qOZelqbo9e95tb2IjxavGbGMS0+QX6XmgVgnTRpNBFv1Wk+6CsNhhk4PgHmMWcMl77
         uwzfAHuIAbYo1i+wCKdVMhi0la6C7058DJwZiOV1l4ln9F6XqIB/sk+26fCzVBcNIKcE
         VY7/Dvk59iiZwf770FaSteCIfmeZvQOh08oXfAIEKdw2djouIRlW5YsChypjGC7wxlqz
         tKN+OgzubyIXshis+5WTjyAe+IY7Xlg6+Ij+e1ouWo5Y0b61C2MX0pFPiaRFGPN29cW9
         H0xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730339194; x=1730943994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jceATRRhfvFKaozUeKEnWqCrQKui6P7HwDJln3J5Tvs=;
        b=QyydR+5884XpQNQuyjeFoyeyAzxIgfg9LHxOhbCTX3NQ2BmrQjl3AUp7HPm6fEM+0m
         61h8QAppp1vJAPC65L3dNkUwS2QH/sF3BplAS5qLTyhONL8vxF4u+eqmHuNXqZgQDP3I
         n0Xk1+4ulI1HdDJuqRGIYTJavk6YktjWH3ZpLwVv/ZnIRM9kCER7gsJWifPkr/eQ+3oA
         uayYD40nZWswyYC2hKe4+MTHafiZSC1DaQjFSemwqeRk/CFeL6S9Fs8P1VXmG2jhrczO
         HVLYQAZGZrZSylfZuwLATrO0poeSWt44zTPt8/Kok6tqF9HZX8U/+hIPNLcca+Jb0E2R
         o3lg==
X-Gm-Message-State: AOJu0YzkEiST2QdThID6q/CP9WCWZ2W69549iAfQvqgMVkSE9UGP+l+a
	DzaZRLfmxK/k0+sBwA/zBN4AjvQmfkMYMtG7cm/pvkzVs19eNbhvryNO7RBCc9svsZOrS2G9JTm
	AgGk=
X-Google-Smtp-Source: AGHT+IEM7PxCP1F+ukJ7LRONyp9RMG6/nFUvp3I7jy85gHxx+UM1ekwTFgxNiUTvtnaFGiu0WnXv7Q==
X-Received: by 2002:a05:6a21:2d8c:b0:1d9:a785:6487 with SMTP id adf61e73a8af0-1d9a83ab032mr23620760637.1.1730339194428;
        Wed, 30 Oct 2024 18:46:34 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-720bc315aafsm285872b3a.197.2024.10.30.18.46.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Oct 2024 18:46:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring/rsrc: allow cloning at an offset
Date: Wed, 30 Oct 2024 19:44:55 -0600
Message-ID: <20241031014629.206573-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241031014629.206573-1-axboe@kernel.dk>
References: <20241031014629.206573-1-axboe@kernel.dk>
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
 io_uring/rsrc.c               | 32 ++++++++++++++++++++++++++------
 2 files changed, 30 insertions(+), 7 deletions(-)

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
index af60d9f597be..d00870128bb9 100644
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
@@ -940,11 +941,29 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
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
+	off = arg->dst_off;
+	i = arg->src_off;
+	nr = arg->nr;
+	while (nr--) {
 		struct io_rsrc_node *dst_node, *src_node;
 
 		src_node = io_rsrc_node_lookup(&src_ctx->buf_table, i);
@@ -960,7 +979,8 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 			refcount_inc(&src_node->buf->refs);
 			dst_node->buf = src_node->buf;
 		}
-		data.nodes[i] = dst_node;
+		data.nodes[off++] = dst_node;
+		i++;
 	}
 
 	/* Have a ref on the bufs now, drop src lock and re-grab our own lock */
@@ -1015,7 +1035,7 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
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


