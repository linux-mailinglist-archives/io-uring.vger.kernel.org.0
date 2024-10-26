Return-Path: <io-uring+bounces-4053-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 661B99B1B4A
	for <lists+io-uring@lfdr.de>; Sun, 27 Oct 2024 00:24:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1782282900
	for <lists+io-uring@lfdr.de>; Sat, 26 Oct 2024 22:24:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5505242AB1;
	Sat, 26 Oct 2024 22:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="q4tXs60x"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C42146013
	for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 22:24:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729981446; cv=none; b=pcBTGa1dFe20rWtbLpkOgQf/OZBlqIXoagiN4c+VCAj/2JwRGUJ4ZxzVIptTZyTTGp61DSZz0CHmPUIlFQfvN6zcM3Xkk1AJWy6PSPEVwyEV5D+I/Uy59mQlfWVDOOWzZNBk0piS7YWXEN9L3VlQGLS0TKy/TE9ozRMhseA/vSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729981446; c=relaxed/simple;
	bh=VDYifqCk0ipg93tPU3mBOhFEfpj5LZgdY2LvbPerBDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oSSQVHahB+9nwhxlMYhFZbu/OgK8ou6psXBm20ivBJCHwYGLpYtXimwj8EsBKIeQ+RIYhIHgGpawGbypPSDAftgAtO6CYBFIHCwi0FNFxt2HFb3fT2lPIdwXNVKGqgcBXhmDDrdOjj0ugoIrqzqPxJAS7ofOyYBASYsIFVwcwCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=q4tXs60x; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-20cdb889222so29153245ad.3
        for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 15:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729981442; x=1730586242; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JBRwY6ouz20EYxF9IRnXXUNz+wDhcc0tq154Wvig08I=;
        b=q4tXs60xr/dS9CggKYsjrAUFzRRMttJ82V4E2NhGjSAGOAs1+dr3SRO3yEW/weQ5XP
         OYqPV/XPVHYSdLRsipZVACZInuPls0g5HVPhzyijwb/Iu+PEURlDwEhAYZL9eD/z6vXT
         igTgH/mn3JO4/fXx+H+3JzaiSzBk3iPaI0F7faJTXojYc9wweVFaKPqp7623Kt2lEuyU
         UE9auY78Xw6Hdpw0XQaBUmM33bBgjsYwbA/oxnlZQyRvawDyrR6aJiDjjtmVqrcR3Nff
         V4lAVUTPTaqcv5UQ/34wM8l+ypvLzuGUDM8rgNZAqA0+BETqmziC6gAuwRtvwVDfshra
         hUCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729981442; x=1730586242;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JBRwY6ouz20EYxF9IRnXXUNz+wDhcc0tq154Wvig08I=;
        b=l85amiBRATgz80FKE3HKUqRNjTxBIA3VeeCp7bKEf29RAG+y+lR87G2AybOJt26q8p
         cpkzvdcZ5+uSxCMvuVOivqCbKV7a4bpSt8KWi9jhAWoxtVYuW8W5NDPULJjlN3BLfmzH
         Q9W+RUBjSrnKfHj1Gw8KCW7199HCSmE1+LhGtckcqlOhwuP1wyRi+DUT0IWr5hO0JElR
         +ZViVEJDSOvisvGp3jWRpEjpy/bSrfMIBScqacbfADjPIJ8df1mnyFKpQYhbjoSZKXlI
         Y2my14wyOuadYQDs3ZPzNKZzi+qjNZ4JWYgVqP0TLg80pv1gDIFh4IWRfyUzXczif3w9
         2UOA==
X-Gm-Message-State: AOJu0YxSOVMsIk0cVqNMtDCgQcfx3XN+AGuYpNJiqNphEJLWYmdq6Ugq
	viLj6cLL2xB2oMe3uP+T+N0rwkJEDnVg/gdltEubYXudbtwkGwRdfNSfQ+tag4V66emWiAnBf75
	O
X-Google-Smtp-Source: AGHT+IFMhkMjE0uLfKbUvWNxtqYKC/1zPZ1aCdVm1qYfvL3OXf4dwjKWweBa9Zq8mLeNf7PaTg1+Uw==
X-Received: by 2002:a17:902:db0b:b0:20b:5645:d860 with SMTP id d9443c01a7336-210c6c1ff52mr54193185ad.36.1729981442481;
        Sat, 26 Oct 2024 15:24:02 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bbf44321sm28134705ad.30.2024.10.26.15.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 15:24:01 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/7] io_uring/rsrc: add an empty io_rsrc_node for sparse buffer entries
Date: Sat, 26 Oct 2024 16:08:30 -0600
Message-ID: <20241026222348.90331-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241026222348.90331-1-axboe@kernel.dk>
References: <20241026222348.90331-1-axboe@kernel.dk>
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
 4 files changed, 43 insertions(+), 28 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 8e24373c1c98..603fd51d170f 100644
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
index 322749c7dee9..255618335b4f 100644
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
@@ -150,7 +155,8 @@ static void io_rsrc_data_free(struct io_rsrc_data *data)
 	for (i = 0; i < data->nr; i++) {
 		struct io_rsrc_node *node = data->nodes[i];
 
-		io_put_rsrc_node(node);
+		if (node)
+			io_put_rsrc_node(node);
 	}
 	kvfree(data->nodes);
 	kfree(data);
@@ -235,7 +241,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				break;
 			}
 			ctx->file_table.nodes[i] = node;
-			node->tag = tag;
+			if (tag)
+				node->tag = tag;
 			io_fixed_file_set(node, file);
 			io_file_bitmap_set(&ctx->file_table, i);
 		}
@@ -287,10 +294,12 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
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
@@ -607,8 +616,10 @@ static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
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
@@ -802,15 +813,13 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
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
@@ -934,7 +943,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			ret = PTR_ERR(node);
 			break;
 		}
-		node->tag = tag;
+		if (tag)
+			node->tag = tag;
 		ctx->user_bufs[i] = node;
 	}
 
@@ -1035,18 +1045,18 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
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
index 22285169c178..69d4111d5f07 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -75,9 +75,12 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
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
 
@@ -90,8 +93,10 @@ static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
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
-- 
2.45.2


