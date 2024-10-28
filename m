Return-Path: <io-uring+bounces-4078-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4CAAF9B3457
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:05:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C90E2814CF
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:05:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 429581DD0DB;
	Mon, 28 Oct 2024 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Gy+8Sl/p"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 513B418FDB0
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 15:04:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127900; cv=none; b=kszmi56N5hoqk4GcOYRgHX3lJs3QK1incT6CK97UlamvbIshhhgIB+SwSu9cA6s/vyaJ4NnjOJwjGQWNLfGuMUzmrYwOHPSaPA9fJbZTFdSkr49w6XpgJ+CNhux7KXoUpHfBGgYhbDHr+FnPY+Ohbjtk/HW7bieqymNqbSb4/3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127900; c=relaxed/simple;
	bh=Y/5ecBE1jL3xh3QKH+3W783u8h2aWPU7wFOADYD1rkw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WhDJUaTzDCuViEF3aTamPB7c4ghi3dF1aIZdkPMVamEOqDaSu49jxbvREX46iIOYhyuhDe9VDLI3oz95C5GKUTS8X5c1Fa8+tr83dAITAmQ9G7mdJFpPB7pX83JVXcWYBJxsvodlE5UlKOJYDyB9LzYw3vVv/52doZCtpDxc5MM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Gy+8Sl/p; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-83ac05206f6so172907839f.2
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:04:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730127896; x=1730732696; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RwY82xqK1igH3RTsjaPKoZuhmLqEqFBjzQh0nVw9IyA=;
        b=Gy+8Sl/pKu6x/2KSDu6MPecssJwbXSVynx9BKXojj0bW3GRbrr6xSUTqJq6YlCuXp2
         Kru6T6FIH6GVnM1zCXPourhgJx5AKgw4gza6MLplgn6vyXLL983143YVyMa36/qMePs8
         MqpP3S2l8q/bQZzyS+9Cnnp7i3i9f3zIBkGPYGPYgyI7MCQJBSNWGs2nlhKRntjR94GM
         EiiA176OxTz/qrLGx4+zdTv3koVSssg076S6awnRS0cLEss16v2r7okt8gQH9MRikP7p
         GSRyQBDws1eX4AI7p4nep22YjeBNgMh4XUsiEIM15ickm35Axh/AQ/h8iHOeWgJGKO9+
         63Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127896; x=1730732696;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RwY82xqK1igH3RTsjaPKoZuhmLqEqFBjzQh0nVw9IyA=;
        b=AqFbqnACT97o2l4qCXbUzuT7vjxF6jzRViLZnCoxbMOBvz/G18kbJUR3WM+gReY6zl
         MB6xxwNFAokyUAd4tjPJdf44abAxpm7BZW+KGDAbajBz25FCLeetDuHb0ZJnIDTzMUdH
         T1NPx9K6iBL2GX2qIu9q20X+MD5U9MvOwK5BoStemDdJRKv+HqgT2lSKptS2zJg9HwVm
         KJgjnTpamPoTqX+PpkWIceFR6uqrVZwqlIL6ZMOBL+bzV2Rtx/0iAYUgakfyUxdhocnD
         UuYfeLX89QmGwk5rlLyuvLiUilNvoe2p1YMQ/B3eOfVIC0KYj9tOCdaQFWCsXMISK6sD
         1vvw==
X-Gm-Message-State: AOJu0Yzv5w6/oa70v/yMWvYjVYnYV5x/a5XYGQenmQIX2GZgr4KDh1nI
	UwGboswjlthyJGRe+AVVLhdk77uHb7gNVH1RcQK/tbCeh9FGuY6xe+VEqnaHcxKBnXsqpMHm2+8
	h
X-Google-Smtp-Source: AGHT+IFYzwXOqYQk3hyoLvd3o/mb3AnZXSTR8b9Ir0GT5mOjdVxfRIFBEaae/Y57sBBoOxCfh4EM7g==
X-Received: by 2002:a05:6e02:16c7:b0:3a0:8edc:d133 with SMTP id e9e14a558f8ab-3a4ed28f225mr69881875ab.9.1730127895959;
        Mon, 28 Oct 2024 08:04:55 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7261c7e3sm1721616173.72.2024.10.28.08.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 08:04:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/13] io_uring/rsrc: use io_rsrc_node_lookup() consistently
Date: Mon, 28 Oct 2024 08:52:41 -0600
Message-ID: <20241028150437.387667-12-axboe@kernel.dk>
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

Various spots open code this helper, use the provided one. The helper
now returns the adjusted, if needed, index into the array, for the cases
where the caller needs that.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cancel.c    |  8 +++++---
 io_uring/filetable.c | 24 +++++++++++++-----------
 io_uring/filetable.h |  9 +++++----
 io_uring/io_uring.c  |  2 +-
 io_uring/msg_ring.c  | 33 ++++++++++++++++-----------------
 io_uring/net.c       |  7 +++----
 io_uring/nop.c       |  6 ++----
 io_uring/rsrc.c      | 15 +++++++++------
 io_uring/rsrc.h      |  8 ++++----
 io_uring/rw.c        |  9 ++++-----
 io_uring/splice.c    |  2 +-
 io_uring/uring_cmd.c | 10 +++++-----
 12 files changed, 68 insertions(+), 65 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 3a2996307025..cc2cd16832ef 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -240,10 +240,12 @@ static int __io_sync_cancel(struct io_uring_task *tctx,
 	/* fixed must be grabbed every time since we drop the uring_lock */
 	if ((cd->flags & IORING_ASYNC_CANCEL_FD) &&
 	    (cd->flags & IORING_ASYNC_CANCEL_FD_FIXED)) {
-		if (unlikely(fd >= ctx->file_table.data.nr))
+		struct io_rsrc_node *node;
+
+		node = io_rsrc_node_lookup(&ctx->file_table.data, &fd);
+		if (unlikely(!node))
 			return -EBADF;
-		fd = array_index_nospec(fd, ctx->file_table.data.nr);
-		cd->file = io_file_from_index(&ctx->file_table, fd);
+		cd->file = io_slot_file(node);
 		if (!cd->file)
 			return -EBADF;
 	}
diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index c4c31f8b4f5d..7b6e4df7cef9 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -55,10 +55,10 @@ void io_free_file_tables(struct io_file_table *table)
 }
 
 static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
-				 u32 slot_index)
+				 int slot_index)
 	__must_hold(&req->ctx->uring_lock)
 {
-	struct io_rsrc_node *node;
+	struct io_rsrc_node *node, *old_node;
 
 	if (io_is_uring_fops(file))
 		return -EBADF;
@@ -72,9 +72,9 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 	if (IS_ERR(node))
 		return -ENOMEM;
 
-	slot_index = array_index_nospec(slot_index, ctx->file_table.data.nr);
-	if (ctx->file_table.data.nodes[slot_index])
-		io_put_rsrc_node(ctx->file_table.data.nodes[slot_index]);
+	old_node = io_rsrc_node_lookup(&ctx->file_table.data, &slot_index);
+	if (old_node)
+		io_put_rsrc_node(old_node);
 	else
 		io_file_bitmap_set(&ctx->file_table, slot_index);
 
@@ -84,7 +84,7 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 }
 
 int __io_fixed_fd_install(struct io_ring_ctx *ctx, struct file *file,
-			  unsigned int file_slot)
+			  int file_slot)
 {
 	bool alloc_slot = file_slot == IORING_FILE_INDEX_ALLOC;
 	int ret;
@@ -108,7 +108,7 @@ int __io_fixed_fd_install(struct io_ring_ctx *ctx, struct file *file,
  * fput() is called correspondingly.
  */
 int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
-			struct file *file, unsigned int file_slot)
+			struct file *file, int file_slot)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
@@ -122,17 +122,19 @@ int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
 	return ret;
 }
 
-int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset)
+int io_fixed_fd_remove(struct io_ring_ctx *ctx, int offset)
 {
+	struct io_rsrc_node *node;
+
 	if (unlikely(!ctx->file_table.data.nr))
 		return -ENXIO;
 	if (offset >= ctx->file_table.data.nr)
 		return -EINVAL;
 
-	offset = array_index_nospec(offset, ctx->file_table.data.nr);
-	if (!ctx->file_table.data.nodes[offset])
+	node = io_rsrc_node_lookup(&ctx->file_table.data, &offset);
+	if (!node)
 		return -EBADF;
-	io_put_rsrc_node(ctx->file_table.data.nodes[offset]);
+	io_put_rsrc_node(node);
 	ctx->file_table.data.nodes[offset] = NULL;
 	io_file_bitmap_clear(&ctx->file_table, offset);
 	return 0;
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index 664c31502dbb..f68ffc24061c 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -10,10 +10,10 @@ bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files);
 void io_free_file_tables(struct io_file_table *table);
 
 int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
-			struct file *file, unsigned int file_slot);
+			struct file *file, int file_slot);
 int __io_fixed_fd_install(struct io_ring_ctx *ctx, struct file *file,
-				unsigned int file_slot);
-int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset);
+				int file_slot);
+int io_fixed_fd_remove(struct io_ring_ctx *ctx, int offset);
 
 int io_register_file_alloc_range(struct io_ring_ctx *ctx,
 				 struct io_uring_file_index_range __user *arg);
@@ -52,8 +52,9 @@ static inline struct file *io_slot_file(struct io_rsrc_node *node)
 static inline struct file *io_file_from_index(struct io_file_table *table,
 					      int index)
 {
-	struct io_rsrc_node *node = table->data.nodes[index];
+	struct io_rsrc_node *node;
 
+	node = io_rsrc_node_lookup(&table->data, &index);
 	if (node)
 		return io_slot_file(node);
 	return NULL;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3a535e9e8ac3..4514644fdf52 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1879,7 +1879,7 @@ inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	struct file *file = NULL;
 
 	io_ring_submit_lock(ctx, issue_flags);
-	node = io_rsrc_node_lookup(&ctx->file_table.data, fd);
+	node = io_rsrc_node_lookup(&ctx->file_table.data, &fd);
 	if (node) {
 		io_req_assign_rsrc_node(req, node);
 		req->flags |= io_slot_flags(node);
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index b90ab3b8f5e0..8e783aa75064 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -25,7 +25,7 @@ struct io_msg {
 	u64 user_data;
 	u32 len;
 	u32 cmd;
-	u32 src_fd;
+	int src_fd;
 	union {
 		u32 dst_fd;
 		u32 cqe_flags;
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
+	node = io_rsrc_node_lookup(&ctx->file_table.data, &msg->src_fd);
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
index 3e1f31574abb..87b9ae07d647 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1343,13 +1343,12 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
 	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
 		struct io_ring_ctx *ctx = req->ctx;
 		struct io_rsrc_node *node;
-		int idx;
+		int idx = sr->buf_index;
 
 		ret = -EFAULT;
 		io_ring_submit_lock(ctx, issue_flags);
-		if (sr->buf_index < ctx->buf_table.nr) {
-			idx = array_index_nospec(sr->buf_index, ctx->buf_table.nr);
-			node = ctx->buf_table.nodes[idx];
+		node = io_rsrc_node_lookup(&ctx->buf_table, &idx);
+		if (node) {
 			io_req_assign_rsrc_node(sr->notif, node);
 			ret = 0;
 		}
diff --git a/io_uring/nop.c b/io_uring/nop.c
index 0dac01127de5..97150c0e6c25 100644
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
+		node = io_rsrc_node_lookup(&ctx->buf_table, &nop->buffer);
+		if (node) {
 			io_req_assign_rsrc_node(req, node);
 			ret = 0;
 		}
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 108c94428e7c..c3251a80d4c9 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -186,6 +186,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
+		struct io_rsrc_node *node;
 		u64 tag = 0;
 
 		if ((tags && copy_from_user(&tag, &tags[done], sizeof(tag))) ||
@@ -200,9 +201,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		if (fd == IORING_REGISTER_FILES_SKIP)
 			continue;
 
-		i = array_index_nospec(up->offset + done, ctx->file_table.data.nr);
-		if (ctx->file_table.data.nodes[i]) {
-			io_put_rsrc_node(ctx->file_table.data.nodes[i]);
+		i = up->offset + done;
+		node = io_rsrc_node_lookup(&ctx->file_table.data, &i);
+		if (node) {
+			io_put_rsrc_node(node);
 			ctx->file_table.data.nodes[i] = NULL;
 			io_file_bitmap_clear(&ctx->file_table, i);
 		}
@@ -965,13 +967,14 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		goto out_unlock;
 
 	for (i = 0; i < nbufs; i++) {
-		struct io_rsrc_node *src_node = src_ctx->buf_table.nodes[i];
-		struct io_rsrc_node *dst_node;
+		struct io_rsrc_node *dst_node, *src_node;
+		int index = i;
 
+		src_node = io_rsrc_node_lookup(&src_ctx->buf_table, &index);
 		if (src_node == rsrc_empty_node) {
 			dst_node = rsrc_empty_node;
 		} else {
-			dst_node = io_rsrc_node_alloc(ctx, &data, i, IORING_RSRC_BUFFER);
+			dst_node = io_rsrc_node_alloc(ctx, &data, index, IORING_RSRC_BUFFER);
 			if (!dst_node)
 				goto out_put_free;
 
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index dcc1fb185035..5897306bcc35 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -75,11 +75,11 @@ extern const struct io_rsrc_node empty_node;
 #define rsrc_empty_node	(struct io_rsrc_node *) &empty_node
 
 static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data,
-						       int index)
+						       int *index)
 {
-	if (index < data->nr) {
-		index = array_index_nospec(index, data->nr);
-		return data->nodes[index];
+	if (*index < data->nr) {
+		*index = array_index_nospec(*index, data->nr);
+		return data->nodes[*index];
 	}
 	return NULL;
 }
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 28fff18ebb19..7ce1cbc048fa 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -332,17 +332,16 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_rsrc_node *node;
 	struct io_async_rw *io;
-	u16 index;
-	int ret;
+	int index, ret;
 
 	ret = io_prep_rw(req, sqe, ddir, false);
 	if (unlikely(ret))
 		return ret;
 
-	if (unlikely(req->buf_index >= ctx->buf_table.nr))
+	index = req->buf_index;
+	node = io_rsrc_node_lookup(&ctx->buf_table, &index);
+	if (!node)
 		return -EFAULT;
-	index = array_index_nospec(req->buf_index, ctx->buf_table.nr);
-	node = ctx->buf_table.nodes[index];
 	io_req_assign_rsrc_node(req, node);
 
 	io = req->async_data;
diff --git a/io_uring/splice.c b/io_uring/splice.c
index deeb8bb18651..dfc84896da8a 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -66,7 +66,7 @@ static struct file *io_splice_get_file(struct io_kiocb *req,
 		return io_file_get_normal(req, sp->splice_fd_in);
 
 	io_ring_submit_lock(ctx, issue_flags);
-	node = io_rsrc_node_lookup(&ctx->file_table.data, sp->splice_fd_in);
+	node = io_rsrc_node_lookup(&ctx->file_table.data, &sp->splice_fd_in);
 	if (node) {
 		node->refs++;
 		sp->rsrc_node = node;
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 17d5f5004702..6bbf2b603765 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -209,18 +209,18 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (ioucmd->flags & IORING_URING_CMD_FIXED) {
 		struct io_ring_ctx *ctx = req->ctx;
-		u16 index;
+		int index = req->buf_index;
+		struct io_rsrc_node *node;
 
-		index = READ_ONCE(sqe->buf_index);
-		if (unlikely(index >= ctx->buf_table.nr))
+		node = io_rsrc_node_lookup(&ctx->buf_table, &index);
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


