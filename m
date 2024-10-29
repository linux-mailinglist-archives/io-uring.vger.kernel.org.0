Return-Path: <io-uring+bounces-4111-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 539489B4DBB
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:23:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 18D0F2818DF
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:23:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2926192D84;
	Tue, 29 Oct 2024 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="LNk3sETZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16ABF195985
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215397; cv=none; b=qW+wePBN3Rde6D4/G7xh4xBhX9fKaVyqXcscvzdUD6sBa6UpRlbHzm7tM43bK78Z+ACHNKjCH80C806MByKERFy0zVAhdQs6hrtKatyRrzw4TrA6kzuv3lgztwI5tZ5TP0LMZbP0hX/OVct5+ENRBuZSwqAye0f2CWT7CdiC88o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215397; c=relaxed/simple;
	bh=kdk/9SZ0lTDWh9ZbsRQQr7p0FUeglW/esSWNH1dFO1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T9K7ysmDAJSWMK8+nsqSP7+mz6gYmMEjVtmZLZmCx6trYm7lQbAa6Yzjuvd681jnZwuvjSjnsjWFp7gNOAYzjrWKA30xtiJqOuRu7sFsSKBtX4Zo8PkV0oqbgd+8ZJjqMREhr24mPxPAloNDZsPWUb7zXX0G0HrRZAYYPagFcpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=LNk3sETZ; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-83abcfb9f37so219900139f.1
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215393; x=1730820193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YOe3sTWaIirEpBGKzV9oeCe6wFtUn4hw4nwiG1m0gT0=;
        b=LNk3sETZ4x/2wI5Twi9OzplYk5BbLwB/1xxc2U4KOW8WEGQ8e6/NISK53piDu4w2q/
         ka1QH7ahazMd3tcZ5Lq1U26RKaEm8xUqeL5bvPkF3eda7HZU/AsN+aBrHjORmiWPa+Cr
         Gh7f5thXgjseOxX/KlU08xzeP8wj0quVmr+xBgxN1/HCkSc88rMipY+dC5qsRFkuVtrS
         x0+qVSn3vnuNGNf2HUtbAjPlpg8f079DI1/8d4Yenv5U1Pw0jwvnmX0dUOFocGc8pdb4
         o8jQi/7NToISINoofG54mwUGPi9/uByIsFd8452dZcXSPqX2OYkYkfIywIU4fyGmlPDF
         1sGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215393; x=1730820193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YOe3sTWaIirEpBGKzV9oeCe6wFtUn4hw4nwiG1m0gT0=;
        b=nuKJxnK/quxlmpXjl1oZRX7aTetI4Snd7vEATNG7icrk8QMtA1/yp0MG88V+szPRNI
         iV9ITYRcM/a8lUa1a7YT25v3rer+NKg5He7NzbReAJiZh1IfsfwENovLmLG0k8vXcjEo
         41YXEudM87lrJkMqKFUBYEJ0oRFL8BwO/Ueu9zKqZMC36A+OT3Pyz3UV7ttranPdvzw2
         PHzPjFxMrME0BV4ZFJPBLNHFky+FcpsYytA+JfrFNPq95zJAESUhQ8wFKrBBBNuduZrw
         ourUKqt7ghwWlBrrK36bD58dzXbwNO3RfhwnpdDnLex2gqpz+qjgwPSvTB/jTyeq8Uwh
         RniQ==
X-Gm-Message-State: AOJu0YyEhhlc3H7JPyj5FW0IG3+81uC7MIBKnysTfo6mIaPcQ+CDb4wz
	M25Qbxtkk9O/6XF1XHQGnTdOwqHwqXXPGFBfQ0xRWoVbWijtazILabTiYICZaaYyfg+IdlDOpcF
	M
X-Google-Smtp-Source: AGHT+IHi67Gi0RDfvGOuVqfVCCymVUd+0YkCTuuzoHKHTDQoBECUKN4+o0aMWbkIo+NVNeEk2aiDNg==
X-Received: by 2002:a05:6602:1589:b0:837:7d54:acf1 with SMTP id ca18e2360f4ac-83b1c3b7c50mr1150305239f.2.1730215392801;
        Tue, 29 Oct 2024 08:23:12 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:11 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/14] io_uring/rsrc: add an empty io_rsrc_node for sparse buffer entries
Date: Tue, 29 Oct 2024 09:16:37 -0600
Message-ID: <20241029152249.667290-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241029152249.667290-1-axboe@kernel.dk>
References: <20241029152249.667290-1-axboe@kernel.dk>
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
 io_uring/rsrc.c     | 49 ++++++++++++++++++++++++++-------------------
 io_uring/rsrc.h     | 11 +++++++---
 io_uring/splice.c   |  2 +-
 5 files changed, 41 insertions(+), 29 deletions(-)

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
index 16e769ebca87..b1729cbdc749 100644
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
@@ -145,7 +150,8 @@ static void io_rsrc_data_free(struct io_rsrc_data *data)
 	for (i = 0; i < data->nr; i++) {
 		struct io_rsrc_node *node = data->nodes[i];
 
-		io_put_rsrc_node(node);
+		if (node)
+			io_put_rsrc_node(node);
 	}
 	kvfree(data->nodes);
 	kfree(data);
@@ -230,7 +236,8 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				break;
 			}
 			ctx->file_table.nodes[i] = node;
-			node->tag = tag;
+			if (tag)
+				node->tag = tag;
 			io_fixed_file_set(node, file);
 			io_file_bitmap_set(&ctx->file_table, i);
 		}
@@ -282,10 +289,12 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
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
@@ -601,8 +610,10 @@ static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
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
@@ -800,11 +811,6 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
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
@@ -928,7 +934,8 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			ret = PTR_ERR(node);
 			break;
 		}
-		node->tag = tag;
+		if (tag)
+			node->tag = tag;
 		ctx->user_bufs[i] = node;
 	}
 
@@ -1029,18 +1036,18 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		goto out_free_data;
 
 	for (i = 0; i < nbufs; i++) {
-		struct io_mapped_ubuf *imu = src_ctx->user_bufs[i]->buf;
+		struct io_rsrc_node *src_node = src_ctx->user_bufs[i];
 		struct io_rsrc_node *dst_node;
 
-		dst_node = io_rsrc_node_alloc(ctx, data, IORING_RSRC_BUFFER);
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
+			dst_node = io_rsrc_node_alloc(ctx, data, IORING_RSRC_BUFFER);
+			if (!dst_node)
+				goto out_put_free;
+
+			refcount_inc(&src_node->buf->refs);
+			dst_node->buf = src_node->buf;
 		}
 		user_bufs[i] = dst_node;
 	}
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 9797dcc2a7b5..db04d04d4799 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -71,9 +71,12 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 			unsigned int size, unsigned int type);
 
+extern const struct io_rsrc_node empty_node;
+#define rsrc_empty_node	(struct io_rsrc_node *) &empty_node
+
 static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 {
-	if (node && !--node->refs)
+	if (node != rsrc_empty_node && !--node->refs)
 		io_free_rsrc_node(node);
 }
 
@@ -86,8 +89,10 @@ static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
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


