Return-Path: <io-uring+bounces-4113-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B9129B4DBC
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:23:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0BE881F23434
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:23:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9716B18E028;
	Tue, 29 Oct 2024 15:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ci2DUGfM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DC5194A64
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215400; cv=none; b=g74zfAcsfUONi8Qnsr78RY2Iaer5/ZSMjWN9upAc6KGjh+DRF8w8VuqsShEwUT3ztC80HGuHMPjJ+aJGFUASVFiOBNv0yuxjL/CRXcu2qWrpoDZIPf/Sq5ky1yY3RmOnfo9gc5yBiplpojIi+SoPlP/Jv0OoAzdcHgse25knSvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215400; c=relaxed/simple;
	bh=xlqUmmAAAFdpSt0oI3cj/qRICnW+M5T/Lr9Gngjg2wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NRWJYyVGXzcoeH7VzO3WBHC4R3agf+GxBoskJIV7wAfrjq7BmZhG8gwJnNuYC/VWtIRfxZCg93bpbUgkGg8WcAEOWA//5a8eU4u4lE1pMcP4hNFh9HAe+Ks9ZUnb0gu3PEY0+72UW5Wbv0QOcSLgkKuwo/q4mIVI5/0VMLSop6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ci2DUGfM; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-83a9be2c0e6so212164539f.2
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215396; x=1730820196; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ygh/OC1xh/vCMWKCfVOfQzTNBpIeWGRvL/JRac4VemA=;
        b=Ci2DUGfM/xcCZLxWEUrp1p3vIol9HT3jwR0uarKuaWNs7ignHsKZZUCLrQljiwFxlp
         QCSa+cRkrJ769y5WCqcGM6D3FOI8Q9IaeeARje9vebpibb6pdCLezRWsdfhp0ozO1S6y
         5dozztN2XoN2wg83gIjUYgk+++eblt2fDKeKicQkjGduNFjVJwOjK9SdvHD/yJNL9kdw
         UnOun3zzxR+ETMq/ZtXDa9QLxhHwHzj/vuUUXabrJmKTiUzb9dSt5J7U1DXIcZdnX2rV
         5r9Gf1K/pl059Yk+Azgpx4e5EEoejMQZ2z2fxjfUokdEMHHTgfbQF8DwtCUOOpMcw15X
         xZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215396; x=1730820196;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ygh/OC1xh/vCMWKCfVOfQzTNBpIeWGRvL/JRac4VemA=;
        b=RzU1tOHFKQbiM5BAh1Jy55uZ0L/+6jqwWaco7qUgmHtHDKjy2VB/jnkhwvaQJqV0TS
         XzDBe6oOvo8r0NQtR7iiyt1saXByAKDWB6dMuJVrmyfgDuZSVjelzPXjMEhRoKX+CGnn
         wZG22y7VtxHnoSO+jWeHrwfI+h+9Zad08hYOpesouHTutqTMCo3LRy7BrGrW1XNIVFyQ
         7cXVVcRU3RdmD0dqG5L/jN16lqF+Euq7v1cNVVoPrnvy+Oy8hRhX3LEMnsGMMtkmNMWM
         aKNgVjmNnuHWccd3toG1urzQNXwtwwU6TdsGX2bXfr+QfC/YT2drQlaC122c/qQGmlWF
         /rww==
X-Gm-Message-State: AOJu0Yw8AzCeo6BWL9FKr16XrT+zFvdMk86gfkR5ssM0Qmgc91YERaE3
	QtntzHLquoZIhrF1jwGFZ9y8z1OvrmMKXGfxKwwAeN0pKmwYaKAMiyXOrFRTaNozOnyzKpSndwD
	s
X-Google-Smtp-Source: AGHT+IF/g3S0z7eXN99M4rGt55k1nDf9+w0tJT/rb0/zEvTalFyF2UVE/rkWS6q9hpwSY3ufdrwMQw==
X-Received: by 2002:a05:6602:6002:b0:83a:a96b:8825 with SMTP id ca18e2360f4ac-83b1bcefdebmr1251718539f.0.1730215396254;
        Tue, 29 Oct 2024 08:23:16 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/14] io_uring/rsrc: add io_rsrc_node_lookup() helper
Date: Tue, 29 Oct 2024 09:16:40 -0600
Message-ID: <20241029152249.667290-12-axboe@kernel.dk>
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

There are lots of spots open-coding this functionality, add a generic
helper that does the node lookup in a speculation safe way.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cancel.c    |  8 +++++---
 io_uring/filetable.c | 16 +++++++++-------
 io_uring/filetable.h |  2 +-
 io_uring/io_uring.c  |  6 +-----
 io_uring/msg_ring.c  | 31 +++++++++++++++----------------
 io_uring/net.c       |  6 ++----
 io_uring/nop.c       |  6 ++----
 io_uring/rsrc.c      | 12 +++++++-----
 io_uring/rsrc.h      |  8 ++++++++
 io_uring/rw.c        |  6 ++----
 io_uring/splice.c    |  6 +-----
 io_uring/uring_cmd.c |  9 ++++-----
 12 files changed, 57 insertions(+), 59 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 3a2996307025..bbca5cb69cb5 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -240,10 +240,12 @@ static int __io_sync_cancel(struct io_uring_task *tctx,
 	/* fixed must be grabbed every time since we drop the uring_lock */
 	if ((cd->flags & IORING_ASYNC_CANCEL_FD) &&
 	    (cd->flags & IORING_ASYNC_CANCEL_FD_FIXED)) {
-		if (unlikely(fd >= ctx->file_table.data.nr))
+		struct io_rsrc_node *node;
+
+		node = io_rsrc_node_lookup(&ctx->file_table.data, fd);
+		if (unlikely(!node))
 			return -EBADF;
-		fd = array_index_nospec(fd, ctx->file_table.data.nr);
-		cd->file = io_file_from_index(&ctx->file_table, fd);
+		cd->file = io_slot_file(node);
 		if (!cd->file)
 			return -EBADF;
 	}
diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index c1bea2d9dce2..1f22f183cdeb 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -58,7 +58,7 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 				 u32 slot_index)
 	__must_hold(&req->ctx->uring_lock)
 {
-	struct io_rsrc_node *node;
+	struct io_rsrc_node *node, *old_node;
 
 	if (io_is_uring_fops(file))
 		return -EBADF;
@@ -71,9 +71,9 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 	if (IS_ERR(node))
 		return -ENOMEM;
 
-	slot_index = array_index_nospec(slot_index, ctx->file_table.data.nr);
-	if (ctx->file_table.data.nodes[slot_index])
-		io_put_rsrc_node(ctx->file_table.data.nodes[slot_index]);
+	old_node = io_rsrc_node_lookup(&ctx->file_table.data, slot_index);
+	if (old_node)
+		io_put_rsrc_node(old_node);
 	else
 		io_file_bitmap_set(&ctx->file_table, slot_index);
 
@@ -123,15 +123,17 @@ int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
 
 int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset)
 {
+	struct io_rsrc_node *node;
+
 	if (unlikely(!ctx->file_table.data.nr))
 		return -ENXIO;
 	if (offset >= ctx->file_table.data.nr)
 		return -EINVAL;
 
-	offset = array_index_nospec(offset, ctx->file_table.data.nr);
-	if (!ctx->file_table.data.nodes[offset])
+	node = io_rsrc_node_lookup(&ctx->file_table.data, offset);
+	if (!node)
 		return -EBADF;
-	io_put_rsrc_node(ctx->file_table.data.nodes[offset]);
+	io_put_rsrc_node(node);
 	ctx->file_table.data.nodes[offset] = NULL;
 	io_file_bitmap_clear(&ctx->file_table, offset);
 	return 0;
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index 664c31502dbb..29edda0caa65 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -52,7 +52,7 @@ static inline struct file *io_slot_file(struct io_rsrc_node *node)
 static inline struct file *io_file_from_index(struct io_file_table *table,
 					      int index)
 {
-	struct io_rsrc_node *node = table->data.nodes[index];
+	struct io_rsrc_node *node = io_rsrc_node_lookup(&table->data, index);
 
 	if (node)
 		return io_slot_file(node);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 78df515fb3a7..3a535e9e8ac3 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1879,16 +1879,12 @@ inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	struct file *file = NULL;
 
 	io_ring_submit_lock(ctx, issue_flags);
-	if (unlikely((unsigned int)fd >= ctx->file_table.data.nr))
-		goto out;
-	fd = array_index_nospec(fd, ctx->file_table.data.nr);
-	node = ctx->file_table.data.nodes[fd];
+	node = io_rsrc_node_lookup(&ctx->file_table.data, fd);
 	if (node) {
 		io_req_assign_rsrc_node(req, node);
 		req->flags |= io_slot_flags(node);
 		file = io_slot_file(node);
 	}
-out:
 	io_ring_submit_unlock(ctx, issue_flags);
 	return file;
 }
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index b90ab3b8f5e0..99af39e1d0fb 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -172,22 +172,24 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 	return __io_msg_ring_data(target_ctx, msg, issue_flags);
 }
 
-static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_flags)
+static int io_msg_grab_file(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct io_ring_ctx *ctx = req->ctx;
-	struct file *file = NULL;
-	int idx = msg->src_fd;
+	struct io_rsrc_node *node;
+	int ret = -EBADF;
 
 	io_ring_submit_lock(ctx, issue_flags);
-	if (likely(idx < ctx->file_table.data.nr)) {
-		idx = array_index_nospec(idx, ctx->file_table.data.nr);
-		file = io_file_from_index(&ctx->file_table, idx);
-		if (file)
-			get_file(file);
+	node = io_rsrc_node_lookup(&ctx->file_table.data, msg->src_fd);
+	if (node) {
+		msg->src_file = io_slot_file(node);
+		if (msg->src_file)
+			get_file(msg->src_file);
+		req->flags |= REQ_F_NEED_CLEANUP;
+		ret = 0;
 	}
 	io_ring_submit_unlock(ctx, issue_flags);
-	return file;
+	return ret;
 }
 
 static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flags)
@@ -256,7 +258,6 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct io_ring_ctx *ctx = req->ctx;
-	struct file *src_file = msg->src_file;
 
 	if (msg->len)
 		return -EINVAL;
@@ -264,12 +265,10 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 		return -EINVAL;
 	if (target_ctx->flags & IORING_SETUP_R_DISABLED)
 		return -EBADFD;
-	if (!src_file) {
-		src_file = io_msg_grab_file(req, issue_flags);
-		if (!src_file)
-			return -EBADF;
-		msg->src_file = src_file;
-		req->flags |= REQ_F_NEED_CLEANUP;
+	if (!msg->src_file) {
+		int ret = io_msg_grab_file(req, issue_flags);
+		if (unlikely(ret))
+			return ret;
 	}
 
 	if (io_msg_need_remote(target_ctx))
diff --git a/io_uring/net.c b/io_uring/net.c
index 3e1f31574abb..2f7b334ed708 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1343,13 +1343,11 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
 	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
 		struct io_ring_ctx *ctx = req->ctx;
 		struct io_rsrc_node *node;
-		int idx;
 
 		ret = -EFAULT;
 		io_ring_submit_lock(ctx, issue_flags);
-		if (sr->buf_index < ctx->buf_table.nr) {
-			idx = array_index_nospec(sr->buf_index, ctx->buf_table.nr);
-			node = ctx->buf_table.nodes[idx];
+		node = io_rsrc_node_lookup(&ctx->buf_table, sr->buf_index);
+		if (node) {
 			io_req_assign_rsrc_node(sr->notif, node);
 			ret = 0;
 		}
diff --git a/io_uring/nop.c b/io_uring/nop.c
index 0dac01127de5..149dbdc53607 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -62,13 +62,11 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	if (nop->flags & IORING_NOP_FIXED_BUFFER) {
 		struct io_ring_ctx *ctx = req->ctx;
 		struct io_rsrc_node *node;
-		int idx;
 
 		ret = -EFAULT;
 		io_ring_submit_lock(ctx, issue_flags);
-		if (nop->buffer < ctx->buf_table.nr) {
-			idx = array_index_nospec(nop->buffer, ctx->buf_table.nr);
-			node = READ_ONCE(ctx->buf_table.nodes[idx]);
+		node = io_rsrc_node_lookup(&ctx->buf_table, nop->buffer);
+		if (node) {
 			io_req_assign_rsrc_node(req, node);
 			ret = 0;
 		}
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 902e003704a9..0924c53dd954 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -182,6 +182,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
+		struct io_rsrc_node *node;
 		u64 tag = 0;
 
 		if ((tags && copy_from_user(&tag, &tags[done], sizeof(tag))) ||
@@ -196,9 +197,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		if (fd == IORING_REGISTER_FILES_SKIP)
 			continue;
 
-		i = array_index_nospec(up->offset + done, ctx->file_table.data.nr);
-		if (ctx->file_table.data.nodes[i]) {
-			io_put_rsrc_node(ctx->file_table.data.nodes[i]);
+		i = up->offset + done;
+		node = io_rsrc_node_lookup(&ctx->file_table.data, i);
+		if (node) {
+			io_put_rsrc_node(node);
 			ctx->file_table.data.nodes[i] = NULL;
 			io_file_bitmap_clear(&ctx->file_table, i);
 		}
@@ -961,9 +963,9 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		goto out_unlock;
 
 	for (i = 0; i < nbufs; i++) {
-		struct io_rsrc_node *src_node = src_ctx->buf_table.nodes[i];
-		struct io_rsrc_node *dst_node;
+		struct io_rsrc_node *dst_node, *src_node;
 
+		src_node = io_rsrc_node_lookup(&src_ctx->buf_table, i);
 		if (src_node == rsrc_empty_node) {
 			dst_node = rsrc_empty_node;
 		} else {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 438e0ac6abf7..6952fb45f57a 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -71,6 +71,14 @@ int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 extern const struct io_rsrc_node empty_node;
 #define rsrc_empty_node	(struct io_rsrc_node *) &empty_node
 
+static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data,
+						       int index)
+{
+	if (index < data->nr)
+		return data->nodes[array_index_nospec(index, data->nr)];
+	return NULL;
+}
+
 static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 {
 	if (node != rsrc_empty_node && !--node->refs)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 28fff18ebb19..30448f343c7f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -332,17 +332,15 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_rsrc_node *node;
 	struct io_async_rw *io;
-	u16 index;
 	int ret;
 
 	ret = io_prep_rw(req, sqe, ddir, false);
 	if (unlikely(ret))
 		return ret;
 
-	if (unlikely(req->buf_index >= ctx->buf_table.nr))
+	node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
+	if (!node)
 		return -EFAULT;
-	index = array_index_nospec(req->buf_index, ctx->buf_table.nr);
-	node = ctx->buf_table.nodes[index];
 	io_req_assign_rsrc_node(req, node);
 
 	io = req->async_data;
diff --git a/io_uring/splice.c b/io_uring/splice.c
index aaaddb66e90a..deeb8bb18651 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -66,17 +66,13 @@ static struct file *io_splice_get_file(struct io_kiocb *req,
 		return io_file_get_normal(req, sp->splice_fd_in);
 
 	io_ring_submit_lock(ctx, issue_flags);
-	if (unlikely(sp->splice_fd_in >= ctx->file_table.data.nr))
-		goto out;
-	sp->splice_fd_in = array_index_nospec(sp->splice_fd_in, ctx->file_table.data.nr);
-	node = ctx->file_table.data.nodes[sp->splice_fd_in];
+	node = io_rsrc_node_lookup(&ctx->file_table.data, sp->splice_fd_in);
 	if (node) {
 		node->refs++;
 		sp->rsrc_node = node;
 		file = io_slot_file(node);
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
-out:
 	io_ring_submit_unlock(ctx, issue_flags);
 	return file;
 }
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 17d5f5004702..535909a38e76 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -209,18 +209,17 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
 		struct io_ring_ctx *ctx = req->ctx;
-		u16 index;
+		struct io_rsrc_node *node;
 
-		index = READ_ONCE(sqe->buf_index);
-		if (unlikely(index >= ctx->buf_table.nr))
+		node = io_rsrc_node_lookup(&ctx->buf_table, req->buf_index);
+		if (unlikely(!node))
 			return -EFAULT;
-		req->buf_index = array_index_nospec(index, ctx->buf_table.nr);
 		/*
 		 * Pi node upfront, prior to io_uring_cmd_import_fixed()
 		 * being called. This prevents destruction of the mapped buffer
 		 * we'll need at actual import time.
 		 */
-		io_req_assign_rsrc_node(req, ctx->buf_table.nodes[req->buf_index]);
+		io_req_assign_rsrc_node(req, node);
 	}
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 
-- 
2.45.2


