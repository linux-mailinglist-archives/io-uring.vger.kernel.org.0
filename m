Return-Path: <io-uring+bounces-7407-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F262A7C174
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 18:21:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F2811895344
	for <lists+io-uring@lfdr.de>; Fri,  4 Apr 2025 16:21:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D8CB620B7E1;
	Fri,  4 Apr 2025 16:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K0xZxZ7f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F395F20ADEF
	for <io-uring@vger.kernel.org>; Fri,  4 Apr 2025 16:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743783674; cv=none; b=DYxU6E+idDwLoMzTUN9MsZkJFFoF3QC7mlZkQbsFB1MwWndE5v1b/xjFbonXulfXdOFZqv8qdXTHxX3ePW12ZB5EHd5c5lOpz8OaghPiCnO6B7L2mMj4zW8VPthddB37zSFD97VWk7KNLIm0tRWaPkF2LoMJS2B/GgXkcVm5pv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743783674; c=relaxed/simple;
	bh=RcRPgE6C713ahI/WHS1q1AUMAiALW8eR5rkNPODwygU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VajmmP/u2qjAFDbhIwXNh9SHR24sFpTWDo2eQ11CbZa3XOqGetMDXe4UnwnIb884jyvmFyhTCItJo+q10RsaIt1EA17lM9pMO4wITlmNIg3rojmDKcgGBaxsaTh6aqo5FW66WE1NTCxW/73dHeLQN0fuPlIU3EeVPvGj+/3u16I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K0xZxZ7f; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-5ec9d24acfbso6069951a12.0
        for <io-uring@vger.kernel.org>; Fri, 04 Apr 2025 09:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743783671; x=1744388471; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ArU/1UqGYXmE5dL0jOxUulm9rILJXC1pvO/5ZPhgLk=;
        b=K0xZxZ7fAV4xtUhc5/UOSsCjqQRpWgYmeDxTqhaL6xNRt6Hyt3JanftgEDTfyP+XH/
         6BIEs2YnUg0hmS02iH+yAFzZ+khzj/AlbpEq6qaWzVyvHDe51VQ/tG+6WvZ6vI7FBfyP
         Bec+/+kfjMNrUFG1eqg+4qkzaLNMM6JZdw8Yw+NQB/IJDR7OasBmMAs5LesZazwhhqaR
         34oUE7RxM30zHOx2cRm52eslGNosA8wiGR+0phhAQwOw5pd1vFLR114euwn4IEjqEid+
         1hHiT7Y+OdtB/E5ddkwtHy6MNRzKp5NaQOfjDV8A4rhrOvxF/RQNRgVpdb+Ai4+SoEsZ
         VdfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743783671; x=1744388471;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ArU/1UqGYXmE5dL0jOxUulm9rILJXC1pvO/5ZPhgLk=;
        b=FXEk0iwYmYC9Jxtu2xcs3LToxGqSvVv/CAnTpqTjMYLHx7pB/BDjYHbw4dQBc7PsVw
         cduTa9VEeT5kZYPJOK7w16COtFpzKN7+OQnxFZcrxaNGm+jnuTjeTQNIWMxrM9ATIIYy
         66Mvjt56+2jfZqJ0T/pd0aXQpgb4aUoARNsxEZvBaMu5UFH3fLYWKnHwngy0E1UJftt7
         M7ZbOmW5uLWveJ8P3bUowKg4TWjbGRCHZ4nPZAYUPZRIFQGsjz2EDKSZMywKqjcz+ekU
         +fMQn4Y+kVIDJOL+CowsKkUtg8lnIONkdqLN5f88NyYuANX5Whd5mkulju+TrRni8ZrO
         MZwg==
X-Gm-Message-State: AOJu0YyFvGEwtpvqlazpe1ayFy2L1/kHxgq8Ci6bW/tODDM10yfIfPVb
	D1uFIMDqL/d2bcjgPxjzOA5H3wF5VPUXvqfQuhyATeOpGjMoqAcdCRPNjQ==
X-Gm-Gg: ASbGnctzoxc2cEJuFMTsEfUsXCDzAy27cRFnCtT40LSai5gHIEThUa60Titd5QZoiuA
	xfKEdXAMCQYQL7VU3sDAkBH1kTFU6AjEbgzIJ18Lk+fkWSLUeZGgEKbNxDRLIc7G/WxkvLgundu
	3Wjuebhew7QhvLtWG/w8pTLzDO7WkNyxKIWXxidBlSDL7M8i0UNBdmmKYVgkow+BS4XbJ5Ug9KX
	zn7xCg1eynIBX+GZ9y0FXodTK3K4t8a/CiZhf4fur3dtYjkk12fqhkHaz2C25QuU96sVEWwsM8g
	kr/9yVwWDKWUNKS9GQ+GfX4Jg2x5
X-Google-Smtp-Source: AGHT+IG2l6hIYRJvgPkMiIPAzbzVr9pOEr09iiyjUWYg2xV9DbvWJXYWNaF/UtMpSLVeMSFYlaiXAQ==
X-Received: by 2002:a17:907:6e8e:b0:ac2:d5d3:2b77 with SMTP id a640c23a62f3a-ac7d2e1b9c5mr418107066b.8.1743783670715;
        Fri, 04 Apr 2025 09:21:10 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:ce28])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c0184865sm273316066b.124.2025.04.04.09.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Apr 2025 09:21:09 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 4/4] io_uring: reuse buffer updates for registration
Date: Fri,  4 Apr 2025 17:22:17 +0100
Message-ID: <8996ffd533db8bd12c84cdc2ccef1fddbbb3da27.1743783348.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1743783348.git.asml.silence@gmail.com>
References: <cover.1743783348.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

After registering an empty buffer table, we can reuse the code for
buffer updates to actually register buffers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rsrc.c | 85 +++++++++++++++++++------------------------------
 1 file changed, 32 insertions(+), 53 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 958eee7b4a47..6b5ec1504dcd 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -277,9 +277,11 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	return done ? done : err;
 }
 
-static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
-				   struct io_uring_rsrc_update2 *up,
-				   unsigned int nr_args)
+static int io_buffer_table_update(struct io_ring_ctx *ctx,
+				  struct io_rsrc_data *buf_table,
+				  struct io_uring_rsrc_update2 *up,
+				  unsigned int nr_args,
+				  unsigned *last_error)
 {
 	u64 __user *tags = u64_to_user_ptr(up->tags);
 	struct iovec fast_iov, *iov;
@@ -289,9 +291,9 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 	__u32 done;
 	int i, err;
 
-	if (!ctx->buf_table.nr)
+	if (!buf_table->nr)
 		return -ENXIO;
-	if (up->offset + nr_args > ctx->buf_table.nr)
+	if (up->offset + nr_args > buf_table->nr)
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
@@ -316,17 +318,26 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			err = PTR_ERR(node);
 			break;
 		}
-		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
-		io_reset_rsrc_node(ctx, &ctx->buf_table, i);
-		ctx->buf_table.nodes[i] = node;
+		i = array_index_nospec(up->offset + done, buf_table->nr);
+		io_reset_rsrc_node(ctx, buf_table, i);
+		buf_table->nodes[i] = node;
 		if (ctx->compat)
 			user_data += sizeof(struct compat_iovec);
 		else
 			user_data += sizeof(struct iovec);
 	}
+	if (last_error)
+		*last_error = err;
 	return done ? done : err;
 }
 
+static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
+				   struct io_uring_rsrc_update2 *up,
+				   unsigned int nr_args)
+{
+	return io_buffer_table_update(ctx, &ctx->buf_table, up, nr_args, NULL);
+}
+
 static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
 				     struct io_uring_rsrc_update2 *up,
 				     unsigned nr_args)
@@ -851,11 +862,8 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned int nr_args, u64 __user *tags)
 {
-	struct page *last_hpage = NULL;
 	struct io_rsrc_data data;
-	struct iovec fast_iov, *iov = &fast_iov;
-	const struct iovec __user *uvec;
-	int i, ret;
+	int ret, err;
 
 	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
 
@@ -867,51 +875,22 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 	if (ret)
 		return ret;
 
-	if (!arg) {
-		ctx->buf_table = data;
-		return 0;
-	}
-
-	for (i = 0; i < nr_args; i++) {
-		struct io_rsrc_node *node;
-		u64 tag = 0;
-
-		uvec = (struct iovec __user *) arg;
-		iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
-		if (IS_ERR(iov)) {
-			ret = PTR_ERR(iov);
-			break;
-		}
-		ret = io_buffer_validate(iov);
-		if (ret)
-			break;
-		if (ctx->compat)
-			arg += sizeof(struct compat_iovec);
-		else
-			arg += sizeof(struct iovec);
-
-		if (tags) {
-			if (copy_from_user(&tag, &tags[i], sizeof(tag))) {
-				ret = -EFAULT;
-				break;
-			}
-		}
+	if (arg) {
+		struct io_uring_rsrc_update2 update_arg = {
+			.tags = (u64)(unsigned long)tags,
+			.data = (u64)(unsigned long)arg,
+			.offset = 0,
+		};
 
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage, tag);
-		if (IS_ERR(node)) {
-			ret = PTR_ERR(node);
-			break;
+		ret = io_buffer_table_update(ctx, &data, &update_arg, nr_args, &err);
+		if (ret != nr_args) {
+			io_clear_table_tags(&data);
+			io_rsrc_data_free(ctx, &data);
+			return err;
 		}
-		data.nodes[i] = node;
-	}
-
-	if (ret) {
-		io_clear_table_tags(&data);
-		io_rsrc_data_free(ctx, &data);
-		return ret;
 	}
 	ctx->buf_table = data;
-	return ret;
+	return 0;
 }
 
 int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
-- 
2.48.1


