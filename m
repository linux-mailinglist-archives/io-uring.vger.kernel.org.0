Return-Path: <io-uring+bounces-8506-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id C48A3AEBB28
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:10:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 392867A7846
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 15:09:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55E642E9EC0;
	Fri, 27 Jun 2025 15:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gBw54bPy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691782E88A7;
	Fri, 27 Jun 2025 15:09:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036974; cv=none; b=lHWz6pnYGp+lKd3hKFWRsgIDdtltI20fZasW2CA3IDS75qyHNyRqQduVLtCiKqzDh6b0kqGjQMybF5MzaB3F1JUcJcoyEbNu6onZufK/tq1cPdNBHrAQCF0QDc1JKLGyXuYYA9gT/vyj7zix0zFZZS57g3mdveyGAA6YYWRKyJc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036974; c=relaxed/simple;
	bh=VRX/wAS2m28AxONh1ADP07Jwpfxktut5dJSazGg9k2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OQexx+rh3ytdoXNqanymzJe6MzKSq+WpzXQGA2L3UiweuQa7it6WZYtfJFFwJ7nVSFXHz9uBNdsG2KpXPGylitw0pquSQrtTRIYewTzsjzMd8YxLNntbActPTnHACdF6leRHoCtzBBVTRG9PT+16HazzOn3B9FaZVZPmncz6jJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gBw54bPy; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ad883afdf0cso439643366b.0;
        Fri, 27 Jun 2025 08:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751036970; x=1751641770; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b6K4ICGJi7vg8mrghmwBGB30DHKQkSgsdxVP0aH+0Cg=;
        b=gBw54bPydsEUGGQOmpq5y2RjX/N8fI47vPEsmp6U7Isjukeg2cJJnDhkNWRXG9T4Ny
         I+o75cBPqyJQzJcmCoxBZxGHpmYnApGYH37yD2V8bw2R6wnEPSBzIqt3Y9tX1ziVABDh
         GesgHt2xxctr9LhJQmCSdlhpMXm7xqppNyal10fzZLbJuJbv67LA5BudQxfg9huqERF3
         B1vKYaMPrrJHMg5VfSxVcLrasZsjgIOZNepDOQphWqn7o8E5bx8ZlVP5rFzrMw6QJiG2
         yoAhTG9HC2sWGjAFoFpa0f6tIj1phtwcnhj7wMd89lta4bq7Co4siNyXjehjO+Abrkmu
         sC3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036970; x=1751641770;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b6K4ICGJi7vg8mrghmwBGB30DHKQkSgsdxVP0aH+0Cg=;
        b=CaYp4rLjlhydxro7ZeKaFRjUtTQYjZbiGShTf6TqKGtxh36YKIS+A57ibGfd0sSaPI
         LspXCMAwUjB5BYCXkNhepDqqgcunc0kUOlJZkvAbsZ+xho2iAUAJVcv+/P8CBEQZpVeB
         JM5DH2EUunVR+zC6+EAzm7kJHGXFXvpE1NBGFLcR7FYmaRvA3DvOAqqQxK34RHM16pHa
         jLhNlW2jFunt4PLuMt3kuUaYlsc5g986sO/jo9j6g55O4VF+NtaOPEf4vDIfMh4kZ/2f
         s8f341XWBArpe1WwAb1MWkSU7PhEXDu4UA7dShpVYgPEYHasbPIJWUOqf26M2WA088hr
         UOlg==
X-Forwarded-Encrypted: i=1; AJvYcCXouBaBkfXhyUDzt/eEqdVaLKlAV4/O0hT7UuIY7TRFeDpwzLEf+SHB1PPDrPs44siTLBOWu+iiqcf9lA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxBlkIkNL93y7L5Isf6G8PIsTem0suDzIYi7A45wSA1bEG65EWg
	1WzD/emA2zLRX9FmLomCAttQBOUwnLKkXXLJ5CLYS8tCiHFHpoJNc8l0mDydgg==
X-Gm-Gg: ASbGncvUT6EJU9jHGxHK525eRuiA+6Dw667lZ2hjgd2InakcsxUUd430PNUZkNkcfwp
	IOeEy6QgwuHj14HqVPZgsBka0O0XSm10GnnPxekjWapoL9nHpdmsWniiYEiwbMVXcYDB3Lu9k2M
	nFp907v5dIeRdEd66MxSNQhioXfEu5EFlFPnqogRX+zcjAAuvSCIvWSAAFv2uH+9zSIUGT0n4rW
	48XZcR6wkXnHMUEAO4taLsOJgmB3/pMFCzNVV4NP4eJudTbQlcOIiojmHT8Vz3E/F+GnFiCFUBW
	EN9yPLsqmxxMFw09zF7ggBLobCnFIXqBEUwo0dgrT+XnAhTixwflBDD23Mx55XD9gJRTDmPIRXD
	ponElFtI6muk=
X-Google-Smtp-Source: AGHT+IFniYWNPN+8mcNe7yckcEafkcrp2VyFKI7PCA7fqDb6yhPHxmixUldj16eAhWFieB+CcI2xwg==
X-Received: by 2002:a17:907:1b03:b0:ae3:6744:3677 with SMTP id a640c23a62f3a-ae367443a46mr38239666b.32.1751036969574;
        Fri, 27 Jun 2025 08:09:29 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c014fbsm135802866b.86.2025.06.27.08.09.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 08:09:28 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	asml.silence@gmail.com
Subject: [RFC 07/12] io_uring/rsrc: extended reg buffer registration
Date: Fri, 27 Jun 2025 16:10:34 +0100
Message-ID: <99fe7ef408aaf60ea064d574735f6d4f89f6de28.1751035820.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751035820.git.asml.silence@gmail.com>
References: <cover.1751035820.git.asml.silence@gmail.com>
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
index cfd17e382082..596cb71bd214 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -725,15 +725,26 @@ struct io_uring_rsrc_update {
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
index c592ceace97d..21f4932ecafa 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -26,7 +26,8 @@ struct io_rsrc_update {
 	u32				offset;
 };
 
-static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
+static struct io_rsrc_node *
+io_sqe_buffer_register(struct io_ring_ctx *ctx, struct io_uring_reg_buffer *rb,
 			struct iovec *iov, struct page **last_hpage);
 
 /* only define max */
@@ -226,6 +227,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 
 	if (!ctx->file_table.data.nr)
 		return -ENXIO;
+	if (up->flags)
+		return -EINVAL;
 	if (up->offset + nr_args > ctx->file_table.data.nr)
 		return -EINVAL;
 
@@ -280,10 +283,18 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
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
@@ -294,14 +305,32 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 
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
@@ -314,7 +343,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		err = io_buffer_validate(iov);
 		if (err)
 			break;
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		node = io_sqe_buffer_register(ctx, &rb, iov, &last_hpage);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
@@ -329,10 +358,6 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
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
@@ -367,7 +392,7 @@ int io_register_files_update(struct io_ring_ctx *ctx, void __user *arg,
 	memset(&up, 0, sizeof(up));
 	if (copy_from_user(&up, arg, sizeof(struct io_uring_rsrc_update)))
 		return -EFAULT;
-	if (up.resv || up.resv2)
+	if (up.resv2)
 		return -EINVAL;
 	return __io_register_rsrc_update(ctx, IORING_RSRC_FILE, &up, nr_args);
 }
@@ -381,7 +406,7 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 		return -EINVAL;
 	if (copy_from_user(&up, arg, sizeof(up)))
 		return -EFAULT;
-	if (!up.nr || up.resv || up.resv2)
+	if (!up.nr || up.resv2)
 		return -EINVAL;
 	return __io_register_rsrc_update(ctx, type, &up, up.nr);
 }
@@ -485,7 +510,7 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	up2.data = up->arg;
 	up2.nr = 0;
 	up2.tags = 0;
-	up2.resv = 0;
+	up2.flags = 0;
 	up2.resv2 = 0;
 
 	if (up->offset == IORING_FILE_INDEX_ALLOC) {
@@ -769,6 +794,7 @@ bool io_check_coalesce_buffer(struct page **page_array, int nr_pages,
 }
 
 static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
+						   struct io_uring_reg_buffer *rb,
 						   struct iovec *iov,
 						   struct page **last_hpage)
 {
@@ -781,6 +807,9 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	struct io_imu_folio_data data;
 	bool coalesced = false;
 
+	if (rb->dmabuf_fd != -1 || rb->target_fd != -1)
+		return NULL;
+
 	if (!iov->iov_base)
 		return NULL;
 
@@ -872,6 +901,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		memset(iov, 0, sizeof(*iov));
 
 	for (i = 0; i < nr_args; i++) {
+		struct io_uring_reg_buffer rb;
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
@@ -898,7 +928,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			}
 		}
 
-		node = io_sqe_buffer_register(ctx, iov, &last_hpage);
+		io_default_reg_buf(&rb);
+		node = io_sqe_buffer_register(ctx, &rb, iov, &last_hpage);
 		if (IS_ERR(node)) {
 			ret = PTR_ERR(node);
 			break;
-- 
2.49.0


