Return-Path: <io-uring+bounces-10746-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6A1BAC7E908
	for <lists+io-uring@lfdr.de>; Sun, 23 Nov 2025 23:56:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0ACD33A6DF2
	for <lists+io-uring@lfdr.de>; Sun, 23 Nov 2025 22:54:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61AED2BE02C;
	Sun, 23 Nov 2025 22:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZoisclpE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF72527BF93
	for <io-uring@vger.kernel.org>; Sun, 23 Nov 2025 22:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763938324; cv=none; b=WETlpYzGxtDF1Zw+evyQO/Yb9cI3CdjqUaMlCkf59Uf9wnM0Pk9lzxVeYgmEv9OwbSSruUzYXdndxPpScJAt0ZICK/ys8ZJOP0Xb98uXM3bRLe4GBwRqJP7bEC/lvMaQprSaQbLq9PGvIylc0omQLmXS/3zD+Cb+biJfc+vlMrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763938324; c=relaxed/simple;
	bh=8BZ+n8Zf5MA70rF0FsKoS6ud0wPoj8V1K06OCtwyg2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ktmWzgthZ8wWPMl1Ru7m2WAcvVh/rg06BxjAZcGSRgrjiEXbd4qMKuhIoK4WG+ieOqz5j/HFpK5RHV8SZisayyh6LGZgtvZDa4LBret4mfHNTobqLQ6i8pE1XwwLjRVsLHgrP8TB+dgQi8VA7iRLdyzs+7t1AcXU5szEbkZ4s+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZoisclpE; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-47775fb6c56so31520885e9.1
        for <io-uring@vger.kernel.org>; Sun, 23 Nov 2025 14:52:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763938319; x=1764543119; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iDOUZTVJgMkXOYK0w7myV3C8dq9FH3xgeb/1ORThyV0=;
        b=ZoisclpEPqMwbvYeJR7vAl5JgYNZBpN/+Fb8ZFq19Co7tvf3uA+FqEVf0llvimM4k9
         ouWkXf7Y/kwgelFIa3W3JwwVDXl0vUceXrij5CgdGaantsvOe0UTBrgjEOFipWPTyKy6
         IwX9r7ChX+Hdl3U8HYzO7RVqvLqeI9JSkBoKf6PoV/Jhy+VS2aFvX2vYDgcS+rD3Za8T
         z8c+xX+PWRKxQ3vmOBnKqWzwSQIxK6tmsSghO2MAdFztHuiP9c6uAE/Ku3lzXx2CIbgH
         AaJ7csUPK6RGrJDQjPnLKGJKJm5i3GPaIw0BrUC96Cebs3yFC/1njAYOL/XMiXF6CnRx
         e+vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763938319; x=1764543119;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iDOUZTVJgMkXOYK0w7myV3C8dq9FH3xgeb/1ORThyV0=;
        b=jaoRp1kX7sGtyLk0pRa+JrtO0Q6rjOjD3kqGXFvv+GrU93L9dUp9iNzEhiI+tU9vwH
         j0FYjDWSzK5XyjDUW3E9UtGek69IIsLR73XkTIFPhuumbdugtPbGD7HTQFgus/dKP3Zx
         vV0lGmINjZtlNcIrKHO9iLMj/QGrUm3XyB2sNBYyPaZw5gBV4wc5eAd0Ct1EN2Lo4vFC
         c9371aZL+++XpsjBsprIgQfMpe01ZBzjdMZGqFil5Alje9COY4guMttvxKEErGtLcpXq
         yoYCo8JZIZtsTmZ1zOTG3bHWba9cDlJa5JuX/IaAnO0pLvXZvW1Uf/F/6mUDUoEAIqds
         U2Jg==
X-Forwarded-Encrypted: i=1; AJvYcCWxZiRW1C90Vb97AychcAAQo3fSXKqyDkB4iD3KYHyuWBsVKIj6Xxagb3SpWQC1nta6RITcR5GQKQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YykK0lWwfjwpT2758h1J3wgJGiOQSC1gNwK4gR7Eg2FR+JKwV80
	0xdmKrN6ZA4dewwOBZ072Abe9baObhs6um920OdODs0QmkT58SE18QJA
X-Gm-Gg: ASbGncsxg/j2GOdW2WQne4TjpGGGRPmIyREHJksuyLZGtCFe9f5HiI4wfkq2SrLsXMl
	nRJxqvKTKjRuoY5zLsg5aeAtPuAKW59w1sl3XahWqoPZfrBQ2K5Jjs4689hx3/6Iox672IgVhNM
	MnmPYPSy1+Z0Il3Vmi9EihHGQ17jWXCK/7+f98M9YfaOHOcOWSceNCaXe9pJRmCPPVO1dLDFXlh
	e016hebBkxO2mi9v2TrZg+qVlX1NXFQx7CgpiFjXgy28TI2i4YroKLXi5Ssl/7OVfIJ3YmCFz0S
	J8NtZbl9VK2XcE/A97b7Gjq0SaUIdLfYI6Z5DKS6a2f2xGyvnAwlRzbCcIxCKkfQraHs6OHXyXj
	eI1N+el0I4xOt/z3Tyi/aqKGiKVNA/0A05oOHv1EDXuTzrwkArWKaNre19MqmfiV0wkMp+h3Kmf
	nIzY31jROV7WSm5Q==
X-Google-Smtp-Source: AGHT+IEVGZmbP6f6xRHNG0YOhugv/nk9aBAFhUarY2FYYdxDanQ12tfVqCx9OnxuzVxk1JyVJaIagQ==
X-Received: by 2002:a5d:588c:0:b0:42b:4069:428a with SMTP id ffacd0b85a97d-42cc1cd5d0bmr10157686f8f.12.1763938319012;
        Sun, 23 Nov 2025 14:51:59 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42cb7fb9190sm24849064f8f.33.2025.11.23.14.51.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Nov 2025 14:51:58 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: linux-block@vger.kernel.org,
	io-uring@vger.kernel.org
Cc: Vishal Verma <vishal1.verma@intel.com>,
	tushar.gohad@intel.com,
	Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Subject: [RFC v2 09/11] io_uring/rsrc: extended reg buffer registration
Date: Sun, 23 Nov 2025 22:51:29 +0000
Message-ID: <f2f71704fd54b6063d66ff7da24630b3788e722e.1763725388.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <cover.1763725387.git.asml.silence@gmail.com>
References: <cover.1763725387.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We'll need to pass extra information for buffer registration apart from
iovec, add a flag to struct io_uring_rsrc_update2 that tells that its
data fields points to an extended registration structure, i.e.
struct io_uring_reg_buffer. To do normal registration the user has to
set target_fd and dmabuf_fd fields to -1, and any other combination is
currently rejected.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 13 ++++++++-
 io_uring/rsrc.c               | 53 +++++++++++++++++++++++++++--------
 2 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index deb772222b6d..f64d1f246b93 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -765,15 +765,26 @@ struct io_uring_rsrc_update {
 	__aligned_u64 data;
 };
 
+/* struct io_uring_rsrc_update2::flags */
+enum io_uring_rsrc_reg_flags {
+	IORING_RSRC_F_EXTENDED_UPDATE		= 1,
+};
+
 struct io_uring_rsrc_update2 {
 	__u32 offset;
-	__u32 resv;
+	__u32 flags;
 	__aligned_u64 data;
 	__aligned_u64 tags;
 	__u32 nr;
 	__u32 resv2;
 };
 
+struct io_uring_reg_buffer {
+	__aligned_u64		iov_uaddr;
+	__s32			target_fd;
+	__s32			dmabuf_fd;
+};
+
 /* Skip updating fd indexes set to this value in the fd table */
 #define IORING_REGISTER_FILES_SKIP	(-2)
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 21548942e80d..691f9645d04c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -27,7 +27,8 @@ struct io_rsrc_update {
 	u32				offset;
 };
 
-static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
+static struct io_rsrc_node *
+io_sqe_buffer_register(struct io_ring_ctx *ctx, struct io_uring_reg_buffer *rb,
 			struct iovec *iov, struct page **last_hpage);
 
 /* only define max */
@@ -234,6 +235,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (!ctx->file_table.data.nr)
 		return -ENXIO;
+	if (up->flags)
+		return -EINVAL;
 	if (up->offset + nr_args > ctx->file_table.data.nr)
 		return -EINVAL;
 
@@ -288,10 +291,18 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	return done ? done : err;
 }
 
+static inline void io_default_reg_buf(struct io_uring_reg_buffer *rb)
+{
+	memset(rb, 0, sizeof(*rb));
+	rb->target_fd = -1;
+	rb->dmabuf_fd = -1;
+}
+
 static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 				   struct io_uring_rsrc_update2 *up,
 				   unsigned int nr_args)
 {
+	bool extended_entry = up->flags & IORING_RSRC_F_EXTENDED_UPDATE;
 	u64 __user *tags = u64_to_user_ptr(up->tags);
 	struct iovec fast_iov, *iov;
 	struct page *last_hpage = NULL;
@@ -302,14 +313,32 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 
 	if (!ctx->buf_table.nr)
 		return -ENXIO;
+	if (up->flags & ~IORING_RSRC_F_EXTENDED_UPDATE)
+		return -EINVAL;
 	if (up->offset + nr_args > ctx->buf_table.nr)
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
+		struct io_uring_reg_buffer rb;
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
-		uvec = u64_to_user_ptr(user_data);
+		if (extended_entry) {
+			if (copy_from_user(&rb, u64_to_user_ptr(user_data),
+					   sizeof(rb)))
+				return -EFAULT;
+			user_data += sizeof(rb);
+		} else {
+			io_default_reg_buf(&rb);
+			rb.iov_uaddr = user_data;
+
+			if (ctx->compat)
+				user_data += sizeof(struct compat_iovec);
+			else
+				user_data += sizeof(struct iovec);
+		}
+
+		uvec = u64_to_user_ptr(rb.iov_uaddr);
 		iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
 		if (IS_ERR(iov)) {
 			err = PTR_ERR(iov);
@@ -322,7 +351,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		err = io_buffer_validate(iov);
 		if (err)
 			break;
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		node = io_sqe_buffer_register(ctx, &rb, iov, &last_hpage);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
@@ -337,10 +366,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
 		io_reset_rsrc_node(ctx, &ctx->buf_table, i);
 		ctx->buf_table.nodes[i] = node;
-		if (ctx->compat)
-			user_data += sizeof(struct compat_iovec);
-		else
-			user_data += sizeof(struct iovec);
 	}
 	return done ? done : err;
 }
@@ -375,7 +400,7 @@ int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
 	memset(&up, 0, sizeof(up));
 	if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
 		return -EFAULT;
-	if (up.resv || up.resv2)
+	if (up.resv2)
 		return -EINVAL;
 	return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
 }
@@ -389,7 +414,7 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (copy_from_user(&up, arg, sizeof(up)))
 		return -EFAULT;
-	if (!up.nr || up.resv || up.resv2)
+	if (!up.nr || up.resv2)
 		return -EINVAL;
 	return __io_register_rsrc_update(ctx, type, &up, up.nr);
 }
@@ -493,7 +518,7 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	up2.data = up->arg;
 	up2.nr = 0;
 	up2.tags = 0;
-	up2.resv = 0;
+	up2.flags = 0;
 	up2.resv2 = 0;
 
 	if (up->offset == IORING_FILE_INDEX_ALLOC) {
@@ -778,6 +803,7 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 }
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
+						   struct io_uring_reg_buffer *rb,
 						   struct iovec *iov,
 						   struct page **last_hpage)
 {
@@ -790,6 +816,9 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	struct io_imu_folio_data data;
 	bool coalesced = false;
 
+	if (rb->dmabuf_fd != -1 || rb->target_fd != -1)
+		return NULL;
+
 	if (!iov->iov_base)
 		return NULL;
 
@@ -887,6 +916,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		memset(iov, 0, sizeof(*iov));
 
 	for (i = 0; i < nr_args; i++) {
+		struct io_uring_reg_buffer rb;
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
@@ -913,7 +943,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			}
 		}
 
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		io_default_reg_buf(&rb);
+		node = io_sqe_buffer_register(ctx, &rb, iov, &last_hpage);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
 			break;
-- 
2.52.0


