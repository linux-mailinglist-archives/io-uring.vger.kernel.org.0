Return-Path: <io-uring+bounces-4523-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 93D1E9C032A
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 12:02:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8F446B22924
	for <lists+io-uring@lfdr.de>; Thu,  7 Nov 2024 11:02:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9AA701E1C36;
	Thu,  7 Nov 2024 11:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NDvwxpqF"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74CE1F1307
	for <io-uring@vger.kernel.org>; Thu,  7 Nov 2024 11:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730977330; cv=none; b=rjjRgSIfmraBebWfK25DQ8BtpYtS1i2AJjOfBkp6LJpfJvSPaDt/YYyHdYfjZsyy2EmSV1w+NQmE3cE/zYsSS8WUOLVZ/b26YCB5OHnMFTmtKfNV4zmjCTDZO5wd/HkLuD0rDHm97KKqqjKM3lVYjT2w4AX/ulUjtUqkAIg+bAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730977330; c=relaxed/simple;
	bh=KY21aSsoFkGld7gyEg4MUjE1GyRUFEzYi83bmiL8ReI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WsbjA8CzKVfOcrSr1nB3JyZqYEmI2BX4/++mJdxfaEybve1wS5y7qEU4iX7nva6rXZLv5zFz3MBoTx8eCG5hrn0Yatnhm47VyYWDFeEqPf/nFnvzw45nR1Em0OpbxT8IfOnr3kB5g+sngfVskTSu8Ic1OIuTife8QfFcxVt8qcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NDvwxpqF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730977327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E8xUGMnZYEgZHyzVejIyogI+0ROjG4G+oQC0qzqNcP0=;
	b=NDvwxpqF7At9qLeoSWv8nnAIz9q6lMeZxL7iJ0soj4c+V/auYK9Zr2F0p2xcDZ6bDIsZLq
	Kh5HJfjLezPJqC7nJvwLcjSzBSvF33PdkhisH2oUlPR8jBt9OmLZ/wokKtv9UmIsTnZ4w0
	X3IZE4HB3V+p+XhCEXTIJt9OPj7FMCM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-294-cnZAQ5mINmSqz0u0O5NA8A-1; Thu,
 07 Nov 2024 06:02:04 -0500
X-MC-Unique: cnZAQ5mINmSqz0u0O5NA8A-1
X-Mimecast-MFC-AGG-ID: cnZAQ5mINmSqz0u0O5NA8A
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 19F4819560B1;
	Thu,  7 Nov 2024 11:02:03 +0000 (UTC)
Received: from localhost (unknown [10.72.116.54])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id C0CB51955F3D;
	Thu,  7 Nov 2024 11:02:01 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: linux-block@vger.kernel.org,
	Uday Shankar <ushankar@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 01/12] io_uring/rsrc: pass 'struct io_ring_ctx' reference to rsrc helpers
Date: Thu,  7 Nov 2024 19:01:34 +0800
Message-ID: <20241107110149.890530-2-ming.lei@redhat.com>
In-Reply-To: <20241107110149.890530-1-ming.lei@redhat.com>
References: <20241107110149.890530-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

`io_rsrc_node` instance won't be shared among different io_uring ctxs,
and its allocation 'ctx' is always same with the user's 'ctx', so it is
safe to pass user 'ctx' reference to rsrc helpers. Even in io_clone_buffers(),
`io_rsrc_node` instance is allocated actually for destination io_uring_ctx.

Then io_rsrc_node_ctx() can be removed, and the 8 bytes `ctx` pointer will be
removed from `io_rsrc_node` in the following patch.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/filetable.c | 13 +++++++------
 io_uring/filetable.h |  4 ++--
 io_uring/rsrc.c      | 24 +++++++++++-------------
 io_uring/rsrc.h      | 22 +++++++++-------------
 io_uring/splice.c    |  2 +-
 5 files changed, 30 insertions(+), 35 deletions(-)

diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 45f005f5db42..a21660e3145a 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -36,20 +36,21 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 	return -ENFILE;
 }
 
-bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
+bool io_alloc_file_tables(struct io_ring_ctx *ctx, struct io_file_table *table,
+			  unsigned nr_files)
 {
 	if (io_rsrc_data_alloc(&table->data, nr_files))
 		return false;
 	table->bitmap = bitmap_zalloc(nr_files, GFP_KERNEL_ACCOUNT);
 	if (table->bitmap)
 		return true;
-	io_rsrc_data_free(&table->data);
+	io_rsrc_data_free(ctx, &table->data);
 	return false;
 }
 
-void io_free_file_tables(struct io_file_table *table)
+void io_free_file_tables(struct io_ring_ctx *ctx, struct io_file_table *table)
 {
-	io_rsrc_data_free(&table->data);
+	io_rsrc_data_free(ctx, &table->data);
 	bitmap_free(table->bitmap);
 	table->bitmap = NULL;
 }
@@ -71,7 +72,7 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 	if (!node)
 		return -ENOMEM;
 
-	if (!io_reset_rsrc_node(&ctx->file_table.data, slot_index))
+	if (!io_reset_rsrc_node(ctx, &ctx->file_table.data, slot_index))
 		io_file_bitmap_set(&ctx->file_table, slot_index);
 
 	ctx->file_table.data.nodes[slot_index] = node;
@@ -130,7 +131,7 @@ int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset)
 	node = io_rsrc_node_lookup(&ctx->file_table.data, offset);
 	if (!node)
 		return -EBADF;
-	io_reset_rsrc_node(&ctx->file_table.data, offset);
+	io_reset_rsrc_node(ctx, &ctx->file_table.data, offset);
 	io_file_bitmap_clear(&ctx->file_table, offset);
 	return 0;
 }
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index bfacadb8d089..7717ea9efd0e 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -6,8 +6,8 @@
 #include <linux/io_uring_types.h>
 #include "rsrc.h"
 
-bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files);
-void io_free_file_tables(struct io_file_table *table);
+bool io_alloc_file_tables(struct io_ring_ctx *ctx, struct io_file_table *table, unsigned nr_files);
+void io_free_file_tables(struct io_ring_ctx *ctx, struct io_file_table *table);
 
 int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
 			struct file *file, unsigned int file_slot);
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 2fb1791d7255..d7db36a2c66e 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -130,13 +130,13 @@ struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int type)
 	return node;
 }
 
-__cold void io_rsrc_data_free(struct io_rsrc_data *data)
+__cold void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_data *data)
 {
 	if (!data->nr)
 		return;
 	while (data->nr--) {
 		if (data->nodes[data->nr])
-			io_put_rsrc_node(data->nodes[data->nr]);
+			io_put_rsrc_node(ctx, data->nodes[data->nr]);
 	}
 	kvfree(data->nodes);
 	data->nodes = NULL;
@@ -184,7 +184,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			continue;
 
 		i = up->offset + done;
-		if (io_reset_rsrc_node(&ctx->file_table.data, i))
+		if (io_reset_rsrc_node(ctx, &ctx->file_table.data, i))
 			io_file_bitmap_clear(&ctx->file_table, i);
 
 		if (fd != -1) {
@@ -266,7 +266,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			node->tag = tag;
 		}
 		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
-		io_reset_rsrc_node(&ctx->buf_table, i);
+		io_reset_rsrc_node(ctx, &ctx->buf_table, i);
 		ctx->buf_table.nodes[i] = node;
 		if (ctx->compat)
 			user_data += sizeof(struct compat_iovec);
@@ -442,10 +442,8 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-void io_free_rsrc_node(struct io_rsrc_node *node)
+void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
-	struct io_ring_ctx *ctx = io_rsrc_node_ctx(node);
-
 	lockdep_assert_held(&ctx->uring_lock);
 
 	if (node->tag)
@@ -473,7 +471,7 @@ int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 	if (!ctx->file_table.data.nr)
 		return -ENXIO;
 
-	io_free_file_tables(&ctx->file_table);
+	io_free_file_tables(ctx, &ctx->file_table);
 	io_file_table_set_alloc_range(ctx, 0, 0);
 	return 0;
 }
@@ -494,7 +492,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EMFILE;
 	if (nr_args > rlimit(RLIMIT_NOFILE))
 		return -EMFILE;
-	if (!io_alloc_file_tables(&ctx->file_table, nr_args))
+	if (!io_alloc_file_tables(ctx, &ctx->file_table, nr_args))
 		return -ENOMEM;
 
 	for (i = 0; i < nr_args; i++) {
@@ -551,7 +549,7 @@ int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
 	if (!ctx->buf_table.nr)
 		return -ENXIO;
-	io_rsrc_data_free(&ctx->buf_table);
+	io_rsrc_data_free(ctx, &ctx->buf_table);
 	return 0;
 }
 
@@ -788,7 +786,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (ret) {
 		kvfree(imu);
 		if (node)
-			io_put_rsrc_node(node);
+			io_put_rsrc_node(ctx, node);
 		node = ERR_PTR(ret);
 	}
 	kvfree(pages);
@@ -1018,7 +1016,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	 * old and new nodes at this point.
 	 */
 	if (arg->flags & IORING_REGISTER_DST_REPLACE)
-		io_rsrc_data_free(&ctx->buf_table);
+		io_rsrc_data_free(ctx, &ctx->buf_table);
 
 	/*
 	 * ctx->buf_table should be empty now - either the contents are being
@@ -1042,7 +1040,7 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		kfree(data.nodes[i]);
 	}
 out_unlock:
-	io_rsrc_data_free(&data);
+	io_rsrc_data_free(ctx, &data);
 	mutex_unlock(&src_ctx->uring_lock);
 	mutex_lock(&ctx->uring_lock);
 	return ret;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index bc3a863b14bb..c9057f7a06f5 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -45,8 +45,8 @@ struct io_imu_folio_data {
 };
 
 struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx, int type);
-void io_free_rsrc_node(struct io_rsrc_node *node);
-void io_rsrc_data_free(struct io_rsrc_data *data);
+void io_free_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node);
+void io_rsrc_data_free(struct io_ring_ctx *ctx, struct io_rsrc_data *data);
 int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
 int io_import_fixed(int ddir, struct iov_iter *iter,
@@ -76,19 +76,20 @@ static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data
 	return NULL;
 }
 
-static inline void io_put_rsrc_node(struct io_rsrc_node *node)
+static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
 	if (node && !--node->refs)
-		io_free_rsrc_node(node);
+		io_free_rsrc_node(ctx, node);
 }
 
-static inline bool io_reset_rsrc_node(struct io_rsrc_data *data, int index)
+static inline bool io_reset_rsrc_node(struct io_ring_ctx *ctx,
+				      struct io_rsrc_data *data, int index)
 {
 	struct io_rsrc_node *node = data->nodes[index];
 
 	if (!node)
 		return false;
-	io_put_rsrc_node(node);
+	io_put_rsrc_node(ctx, node);
 	data->nodes[index] = NULL;
 	return true;
 }
@@ -96,20 +97,15 @@ static inline bool io_reset_rsrc_node(struct io_rsrc_data *data, int index)
 static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
 {
 	if (req->file_node) {
-		io_put_rsrc_node(req->file_node);
+		io_put_rsrc_node(req->ctx, req->file_node);
 		req->file_node = NULL;
 	}
 	if (req->flags & REQ_F_BUF_NODE) {
-		io_put_rsrc_node(req->buf_node);
+		io_put_rsrc_node(req->ctx, req->buf_node);
 		req->buf_node = NULL;
 	}
 }
 
-static inline struct io_ring_ctx *io_rsrc_node_ctx(struct io_rsrc_node *node)
-{
-	return (struct io_ring_ctx *) (node->ctx_ptr & ~IORING_RSRC_TYPE_MASK);
-}
-
 static inline int io_rsrc_node_type(struct io_rsrc_node *node)
 {
 	return node->ctx_ptr & IORING_RSRC_TYPE_MASK;
diff --git a/io_uring/splice.c b/io_uring/splice.c
index e8ed15f4ea1a..5b84f1630611 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -51,7 +51,7 @@ void io_splice_cleanup(struct io_kiocb *req)
 {
 	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
 
-	io_put_rsrc_node(sp->rsrc_node);
+	io_put_rsrc_node(req->ctx, sp->rsrc_node);
 }
 
 static struct file *io_splice_get_file(struct io_kiocb *req,
-- 
2.47.0


