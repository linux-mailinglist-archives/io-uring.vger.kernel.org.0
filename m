Return-Path: <io-uring+bounces-4076-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 41D159B3454
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:05:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 010BE281150
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:05:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6B3F1DE2B5;
	Mon, 28 Oct 2024 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DYgZhT3a"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E251DD894
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 15:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127896; cv=none; b=cgs6zmyMgG5IsMIfwXHXr99RDvidh/gIUMrBmeopl/sD9fkhguM12GuafvZQYH3tvNVKY3uujQN8i6lmjFiuD6XCoRJpPU2tRJwtv5IcU+JeGkRROCSIWR31f5AcD2i1YX+oo23R5ywFBsg7k7GnJjaKkCLlKOMqBIwQntn4Pss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127896; c=relaxed/simple;
	bh=J9Bqst/kwlzUhBvdftqt01lWwWoE1NQ1Zq+4lTD9fck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UW3DB0I4BYS/Nkh/yihws9a1vHvn7Nk4XgG00VXjq5LsDvjC8rIGBmBxXM545g9ZL1qt7tdOLPCYljcXlJxIZ+tgLCPX8hpWzVGKJMhDVHz4QMYxbRjNUD9WsjePCryUFoQltqrylIHoxenZDZPjRx0k0z7+Ucby77gGZVXvDrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DYgZhT3a; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-83ab00438acso123568539f.0
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730127892; x=1730732692; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wPZlXwAr3l63Q1issR7TuoyIsfSx3r6dCl3WpbSrH2o=;
        b=DYgZhT3aVWuUG9B+vjivUGCL8/HFYkVeUzYyMYpXp38f5VI+Yg6IOSiIYifEyxs1xg
         qu3xmnEzLG25vH+A0g47LjO6Xn59hyGGLHWgHPECKArmlR9IW4kMSl7lwAYCn/ymDzgB
         PdfEml8SdwtlX++JTncMPle76uNm2YCTMwunTQEjL16+pZNrfELAS7UBX8IL5N/ZzkJD
         dR47nnvS+5D7zh54OgNArbp0ClOtKj7nI4Wjpa6J+Lk5HmsI8h7bQMQ0/WZmSW66WfW2
         qWWyZmIwIdiNe/yNTwr+U4DAdPBofgNTyAJ1oeSN0hQsWr5gGXHDahnpk2q8700Txeyp
         WfKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127892; x=1730732692;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wPZlXwAr3l63Q1issR7TuoyIsfSx3r6dCl3WpbSrH2o=;
        b=isCgqej08cNIs+QvWE4Mdd5HtES8gFtCOMl3Xn2GZD/YyRq0Ml4O1QTpvUmzLW4bn9
         /J5sztM0qg9iJuSNFfFT2+EP9PGihr2hNZ/4WRSN1P7JgInaMwjowoXnPOGF+kYYFTUv
         vDopjVyDgUkmjWIn2KG/tcnAE2BvPL3Wp7UxjeS79tu+gNLIRjmch6y8LplA3aFTUUKL
         /dJmxL/9GWQzqqGyyyamoHtQVdC9gCXJTi5J8Sn2MW0WU/IJX4b6A9vs4aNQrmwKO0FL
         rVbePEVBQeAX3Mh8JBJRcsLFfqf4q9M4B3VPP/VkU3RFxzxlJ4/wMYKTOkJuReNRsTpO
         SZtA==
X-Gm-Message-State: AOJu0YwWyF/JhT5uDVSLWURCDHCtuTxJzvwJ9cTPH3hiUjYp9a9MbWUU
	qg9cltf4AfJUa9T8mjKv5lJTYm7/xJKMijWdRINtjwOSnQqxyOZtHx6LbnoWR32RMhXUMtPDpLt
	j
X-Google-Smtp-Source: AGHT+IH6i8pwbSF76o202g9n8Ayzg8ljXADVkH6qS2J6d8EpJ+XjEE3I/gsFtWrcMKPFyPsMJ689xA==
X-Received: by 2002:a05:6e02:214a:b0:3a3:dadc:12f7 with SMTP id e9e14a558f8ab-3a50896d7e6mr1214355ab.3.1730127892224;
        Mon, 28 Oct 2024 08:04:52 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7261c7e3sm1721616173.72.2024.10.28.08.04.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 08:04:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/13] io_uring/rsrc: add an empty io_rsrc_node for sparse buffer entries
Date: Mon, 28 Oct 2024 08:52:38 -0600
Message-ID: <20241028150437.387667-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241028150437.387667-1-axboe@kernel.dk>
References: <20241028150437.387667-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than allocate an io_rsrc_node for an empty/sparse buffer entry,
add a const entry that can be used for that. This just needs checking
for writing the tag, and the put check needs to check for that sparse
node rather than NULL for validity.

This avoids allocating rsrc nodes for sparse buffer entries.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c |  4 ++--
 io_uring/notif.c    |  4 ++--
 io_uring/rsrc.c     | 52 +++++++++++++++++++++++++++------------------
 io_uring/rsrc.h     | 11 +++++++---
 io_uring/splice.c   |  2 +-
 5 files changed, 44 insertions(+), 29 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 094788cca47f..9282d5fa45d3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2032,8 +2032,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->flags = (__force io_req_flags_t) sqe_flags;
 	req->cqe.user_data = READ_ONCE(sqe->user_data);
 	req->file = NULL;
-	req->rsrc_nodes[IORING_RSRC_FILE] = NULL;
-	req->rsrc_nodes[IORING_RSRC_BUFFER] = NULL;
+	req->rsrc_nodes[IORING_RSRC_FILE] = rsrc_empty_node;
+	req->rsrc_nodes[IORING_RSRC_BUFFER] = rsrc_empty_node;
 	req->task = current;
 	req->cancel_seq_set = false;
 
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 4f02e969cf08..44bf21c0f810 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -117,8 +117,8 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	notif->file = NULL;
 	notif->task = current;
 	io_get_task_refs(1);
-	notif->rsrc_nodes[IORING_RSRC_FILE] = NULL;
-	notif->rsrc_nodes[IORING_RSRC_BUFFER] = NULL;
+	notif->rsrc_nodes[IORING_RSRC_FILE] = rsrc_empty_node;
+	notif->rsrc_nodes[IORING_RSRC_BUFFER] = rsrc_empty_node;
 
 	nd = io_notif_to_data(notif);
 	nd->zc_report = false;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 1ba7f3e55947..08c57332c783 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -38,6 +38,11 @@ static const struct io_mapped_ubuf dummy_ubuf = {
 	.len = UINT_MAX,
 };
 
+const struct io_rsrc_node empty_node = {
+	.type = IORING_RSRC_BUFFER,
+	.buf = (struct io_mapped_ubuf *) &dummy_ubuf,
+};
+
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages)
 {
 	unsigned long page_limit, cur_pages, new_pages;
@@ -149,7 +154,8 @@ static void io_rsrc_data_free(struct io_rsrc_data *data)
 	for (i = 0; i < data->nr; i++) {
 		struct io_rsrc_node *node = data->nodes[i];
 
-		io_put_rsrc_node(node);
+		if (node)
+			io_put_rsrc_node(node);
 	}
 	kvfree(data->nodes);
 	kfree(data);
@@ -234,7 +240,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				break;
 			}
 			ctx->file_table.nodes[i] = node;
-			node->tag = tag;
+			if (tag)
+				node->tag = tag;
 			io_fixed_file_set(node, file);
 			io_file_bitmap_set(&ctx->file_table, i);
 		}
@@ -286,10 +293,12 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			err = PTR_ERR(node);
 			break;
 		}
-		io_put_rsrc_node(ctx->user_bufs[i]);
+		if (ctx->user_bufs[i])
+			io_put_rsrc_node(ctx->user_bufs[i]);
 
 		ctx->user_bufs[i] = node;
-		node->tag = tag;
+		if (tag)
+			node->tag = tag;
 		if (ctx->compat)
 			user_data += sizeof(struct compat_iovec);
 		else
@@ -605,8 +614,10 @@ static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 	lockdep_assert_held(&ctx->uring_lock);
 
 	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		io_put_rsrc_node(ctx->user_bufs[i]);
-		ctx->user_bufs[i] = NULL;
+		if (ctx->user_bufs[i]) {
+			io_put_rsrc_node(ctx->user_bufs[i]);
+			ctx->user_bufs[i] = NULL;
+		}
 	}
 	kvfree(ctx->user_bufs);
 	ctx->user_bufs = NULL;
@@ -800,15 +811,13 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	struct io_imu_folio_data data;
 	bool coalesced;
 
+	if (!iov->iov_base)
+		return rsrc_empty_node;
+
 	node = io_rsrc_node_alloc(ctx, ctx->buf_data, index, IORING_RSRC_BUFFER);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
 
-	if (!iov->iov_base) {
-		node->buf = (struct io_mapped_ubuf *) &dummy_ubuf;
-		return node;
-	}
-
 	ret = -ENOMEM;
 	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
 				&nr_pages);
@@ -932,7 +941,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			ret = PTR_ERR(node);
 			break;
 		}
-		node->tag = tag;
+		if (tag)
+			node->tag = tag;
 		ctx->user_bufs[i] = node;
 	}
 
@@ -1033,18 +1043,18 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		goto out_free_data;
 
 	for (i = 0; i < nbufs; i++) {
-		struct io_mapped_ubuf *imu = src_ctx->user_bufs[i]->buf;
+		struct io_rsrc_node *src_node = src_ctx->user_bufs[i];
 		struct io_rsrc_node *dst_node;
 
-		dst_node = io_rsrc_node_alloc(ctx, data, i, IORING_RSRC_BUFFER);
-		if (!dst_node)
-			goto out_put_free;
-
-		if (imu == &dummy_ubuf) {
-			dst_node->buf = (struct io_mapped_ubuf *) &dummy_ubuf;
+		if (src_node == rsrc_empty_node) {
+			dst_node = rsrc_empty_node;
 		} else {
-			refcount_inc(&imu->refs);
-			dst_node->buf = imu;
+			dst_node = io_rsrc_node_alloc(ctx, data, i, IORING_RSRC_BUFFER);
+			if (!dst_node)
+				goto out_put_free;
+
+			refcount_inc(&src_node->buf->refs);
+			dst_node->buf = src_node->buf;
 		}
 		user_bufs[i] = dst_node;
 	}
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 37de08d34b78..fb86f080ae5c 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -74,9 +74,12 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 			unsigned int size, unsigned int type);
 
+extern const struct io_rsrc_node empty_node;
+#define rsrc_empty_node	(struct io_rsrc_node *) &empty_node
+
 static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 {
-	if (node && !--node->refs)
+	if (node != &empty_node && !--node->refs)
 		io_free_rsrc_node(node);
 }
 
@@ -89,8 +92,10 @@ static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
 static inline void io_req_assign_rsrc_node(struct io_kiocb *req,
 					   struct io_rsrc_node *node)
 {
-	node->refs++;
-	req->rsrc_nodes[node->type] = node;
+	if (node != rsrc_empty_node) {
+		node->refs++;
+		req->rsrc_nodes[node->type] = node;
+	}
 }
 
 int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
diff --git a/io_uring/splice.c b/io_uring/splice.c
index a0b4e0435b8b..f78afb575ae6 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -35,7 +35,7 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
 	sp->splice_fd_in = READ_ONCE(sqe->splice_fd_in);
-	sp->rsrc_node = NULL;
+	sp->rsrc_node = rsrc_empty_node;
 	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
-- 
2.45.2


