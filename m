Return-Path: <io-uring+bounces-4055-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 320D39B1B4C
	for <lists+io-uring@lfdr.de>; Sun, 27 Oct 2024 00:24:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BCB4E2829DB
	for <lists+io-uring@lfdr.de>; Sat, 26 Oct 2024 22:24:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A75210E5;
	Sat, 26 Oct 2024 22:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="zkPqXV0Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768AF1D86C3
	for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 22:24:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729981451; cv=none; b=JtYyYgbAlM0Zpi1/ZzqaxpkZLkJOcmLxiki9TSG8HgwASzXpKYXjO2IHHs7G5cSBqeEsJ/OrrkiWAWQNzm9B3HunQZ+5e0k+daEr+gS8EZnCMO/Ut+rmWcmL/XR8twR0xzQupACLC+73VrDVH7qVdA3YukXOnvPkwBKiPwE0O7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729981451; c=relaxed/simple;
	bh=AlPwJWblqMsJYf7MuPJH5PaZbVDEreIWG+1X6R6Vlsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rg1bOeV2pAE1i2qrwFEG2LgWWaACimYmKvOifHbRbCe9ygYerFGmH17Rpu9US8bkjWEJceQDkuuB1NQl2BiNX6Wu9m1hx5MejUZzPGh7gHHLpktZ1CMkt2N/WDxqyCE/cxGAoeVFQZIMvpjOsNCJCayUuDdyG1I7Z5aiCfkhipM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=zkPqXV0Z; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20cdda5cfb6so29069395ad.3
        for <io-uring@vger.kernel.org>; Sat, 26 Oct 2024 15:24:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729981446; x=1730586246; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=axT0ZGxKlICO0uEH9qWAOOL3daynWEtn+ApVzL5Kl4g=;
        b=zkPqXV0Z1Pe5YRYoycdPJxgqlp+U3uMN0jyqOAPx2iiWn725kL/jgpfAs+VUDciOgI
         elR3qFJqllKSyS1KueyHUpRGgt8frRxy091kSTExbcbuLmBS5UOpWEYLmGQFMACjdltR
         hCaabebaSFADTsE/oNVEVry6ZaS6X6MKKwKzGi3ffb74iYr46NISxD4EJYxJOgzhiDnp
         H2Py9joe7HN8u+kWPkiaoPe4w+7X3rWVjncCzOapzNTeHQVLzwdciv0m2ru/hwF76PRv
         gRda9z0n8FuEysHnPEMg7hcIhDbiJ9tDJ7oORTkbFqP+4BCdWBOviUKvUP+CBHOXM2yl
         xKFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729981446; x=1730586246;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=axT0ZGxKlICO0uEH9qWAOOL3daynWEtn+ApVzL5Kl4g=;
        b=SQIErKk+PuVKp2ABg7X7N2xRPIMddYR+A46BxFIAs95GmYGMr8oxBK+lAt5H3Z6hX1
         aUVsCR59xQXlit0VGbHCF5DnhE72n4oYezNDJGJnRNs2rUaLd/GQ2RLw+IKggEGI17BW
         BNjgEgrUNDuWtCvEsgWI/twIYOZEkGQi9+V0vemqldUAc+berK6w+fECXKovuzDLWlRG
         KVIMaTwhmA6W9ATVsPRs6jr8doGrSi1r6oOZ2r0qv8kC2KLqwW0DMktQqHETh8bJRiwo
         IJu/+fUhe4wQv8XgnpLNhbKBNhOBknUB58FmlOFTTJmvHEYWsbuZknpEtlrfucmMJumu
         djQg==
X-Gm-Message-State: AOJu0Yz8s6lFD6T1DuIWEHOJZGiZWAjSLgJm854Q+Esfpe0qlnXmHMJ1
	JN+jkLuz1zM8CH5k7SBRwgNc6iZ8sNF8DRhnJcxZkcMnBNCwQo1NP2f6ewQjPCWgrHHNWl4mmfv
	n
X-Google-Smtp-Source: AGHT+IFdSTaS5BpkOQ1UElF9QvT0rJNTlLhMY/fqTZblI9XZ+jv0kXEhUG9M9SdFszN5c7gYiXOFFg==
X-Received: by 2002:a17:902:f78a:b0:20b:70b4:69d8 with SMTP id d9443c01a7336-210c6cd3b79mr39312175ad.37.1729981446024;
        Sat, 26 Oct 2024 15:24:06 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-210bbf44321sm28134705ad.30.2024.10.26.15.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2024 15:24:04 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/7] io_uring/rsrc: unify file and buffer resource tables
Date: Sat, 26 Oct 2024 16:08:32 -0600
Message-ID: <20241026222348.90331-8-axboe@kernel.dk>
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

For files, there's nr_user_files/file_table/file_data, and buffers have
nr_user_bufs/user_bufs/buf_data. There's no reason why file_table and
file_data can't be the same thing, and ditto for the buffer side. That
gets rid of more io_ring_ctx state that's in two spots rather than just
being in one spot, as it should be. Put all the registered file data in
one locations, and ditto on the buffer front.

This also avoids having both io_rsrc_data->nodes being an allocated
array, and ->user_bufs[] or ->file_table.nodes. There's no reason to
have this information duplicated. Keep it in one spot, io_rsrc_data,
along with how many resources are available.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  15 ++-
 io_uring/cancel.c              |   4 +-
 io_uring/fdinfo.c              |  10 +-
 io_uring/filetable.c           |  47 ++++----
 io_uring/filetable.h           |   2 +-
 io_uring/io_uring.c            |   7 +-
 io_uring/msg_ring.c            |   4 +-
 io_uring/net.c                 |   6 +-
 io_uring/opdef.c               |   2 +
 io_uring/register.c            |   3 +-
 io_uring/rsrc.c                | 214 ++++++++++-----------------------
 io_uring/rsrc.h                |  17 ++-
 io_uring/rw.c                  |   6 +-
 io_uring/splice.c              |  42 +++++--
 io_uring/splice.h              |   1 +
 io_uring/uring_cmd.c           |   6 +-
 16 files changed, 165 insertions(+), 221 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 60541da6b875..e8d702b3757f 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -55,8 +55,13 @@ struct io_wq_work {
 	int cancel_seq;
 };
 
+struct io_rsrc_data {
+	unsigned int			nr;
+	struct io_rsrc_node		**nodes;
+};
+
 struct io_file_table {
-	struct io_rsrc_node **nodes;
+	struct io_rsrc_data data;
 	unsigned long *bitmap;
 	unsigned int alloc_hint;
 };
@@ -276,9 +281,7 @@ struct io_ring_ctx {
 		struct io_wq_work_list	iopoll_list;
 
 		struct io_file_table	file_table;
-		struct io_rsrc_node	**user_bufs;
-		unsigned		nr_user_files;
-		unsigned		nr_user_bufs;
+		struct io_rsrc_data	buf_table;
 
 		struct io_submit_state	submit_state;
 
@@ -358,10 +361,6 @@ struct io_ring_ctx {
 	struct wait_queue_head		poll_wq;
 	struct io_restriction		restrictions;
 
-	/* slow path rsrc auxilary data, used by update/register */
-	struct io_rsrc_data		*file_data;
-	struct io_rsrc_data		*buf_data;
-
 	u32			pers_next;
 	struct xarray		personalities;
 
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index cc3475b22ae5..3a2996307025 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -240,9 +240,9 @@ static int __io_sync_cancel(struct io_uring_task *tctx,
 	/* fixed must be grabbed every time since we drop the uring_lock */
 	if ((cd->flags & IORING_ASYNC_CANCEL_FD) &&
 	    (cd->flags & IORING_ASYNC_CANCEL_FD_FIXED)) {
-		if (unlikely(fd >= ctx->nr_user_files))
+		if (unlikely(fd >= ctx->file_table.data.nr))
 			return -EBADF;
-		fd = array_index_nospec(fd, ctx->nr_user_files);
+		fd = array_index_nospec(fd, ctx->file_table.data.nr);
 		cd->file = io_file_from_index(&ctx->file_table, fd);
 		if (!cd->file)
 			return -EBADF;
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 064a79475c5f..e3f5e9fe5562 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -165,8 +165,8 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
 	seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
 	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
-	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
-	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
+	seq_printf(m, "UserFiles:\t%u\n", ctx->file_table.data.nr);
+	for (i = 0; has_lock && i < ctx->file_table.data.nr; i++) {
 		struct file *f = io_file_from_index(&ctx->file_table, i);
 
 		if (f)
@@ -174,9 +174,9 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 		else
 			seq_printf(m, "%5u: <none>\n", i);
 	}
-	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
-	for (i = 0; has_lock && i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *buf = ctx->user_bufs[i]->buf;
+	seq_printf(m, "UserBufs:\t%u\n", ctx->buf_table.nr);
+	for (i = 0; has_lock && i < ctx->buf_table.nr; i++) {
+		struct io_mapped_ubuf *buf = ctx->buf_table.nodes[i]->buf;
 
 		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, buf->len);
 	}
diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index c18e37b495a1..c4c31f8b4f5d 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -38,25 +38,19 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 
 bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
 {
-	table->nodes = kvmalloc_array(nr_files, sizeof(struct io_src_node *),
-					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
-	if (unlikely(!table->nodes))
+	if (io_rsrc_data_alloc(&table->data, nr_files))
 		return false;
-
 	table->bitmap = bitmap_zalloc(nr_files, GFP_KERNEL_ACCOUNT);
-	if (unlikely(!table->bitmap)) {
-		kvfree(table->nodes);
-		return false;
-	}
-
-	return true;
+	if (table->bitmap)
+		return true;
+	io_rsrc_data_free(&table->data);
+	return false;
 }
 
 void io_free_file_tables(struct io_file_table *table)
 {
-	kvfree(table->nodes);
+	io_rsrc_data_free(&table->data);
 	bitmap_free(table->bitmap);
-	table->nodes = NULL;
 	table->bitmap = NULL;
 }
 
@@ -68,22 +62,23 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 
 	if (io_is_uring_fops(file))
 		return -EBADF;
-	if (!ctx->file_data)
+	if (!ctx->file_table.data.nr)
 		return -ENXIO;
-	if (slot_index >= ctx->nr_user_files)
+	if (slot_index >= ctx->file_table.data.nr)
 		return -EINVAL;
 
-	node = io_rsrc_node_alloc(ctx, ctx->file_data, slot_index, IORING_RSRC_FILE);
+	node = io_rsrc_node_alloc(ctx, &ctx->file_table.data, slot_index,
+				  IORING_RSRC_FILE);
 	if (IS_ERR(node))
 		return -ENOMEM;
 
-	slot_index = array_index_nospec(slot_index, ctx->nr_user_files);
-	if (ctx->file_table.nodes[slot_index])
-		io_put_rsrc_node(ctx->file_table.nodes[slot_index]);
+	slot_index = array_index_nospec(slot_index, ctx->file_table.data.nr);
+	if (ctx->file_table.data.nodes[slot_index])
+		io_put_rsrc_node(ctx->file_table.data.nodes[slot_index]);
 	else
 		io_file_bitmap_set(&ctx->file_table, slot_index);
 
-	ctx->file_table.nodes[slot_index] = node;
+	ctx->file_table.data.nodes[slot_index] = node;
 	io_fixed_file_set(node, file);
 	return 0;
 }
@@ -129,16 +124,16 @@ int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
 
 int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset)
 {
-	if (unlikely(!ctx->file_data))
+	if (unlikely(!ctx->file_table.data.nr))
 		return -ENXIO;
-	if (offset >= ctx->nr_user_files)
+	if (offset >= ctx->file_table.data.nr)
 		return -EINVAL;
 
-	offset = array_index_nospec(offset, ctx->nr_user_files);
-	if (!ctx->file_table.nodes[offset])
+	offset = array_index_nospec(offset, ctx->file_table.data.nr);
+	if (!ctx->file_table.data.nodes[offset])
 		return -EBADF;
-	io_put_rsrc_node(ctx->file_table.nodes[offset]);
-	ctx->file_table.nodes[offset] = NULL;
+	io_put_rsrc_node(ctx->file_table.data.nodes[offset]);
+	ctx->file_table.data.nodes[offset] = NULL;
 	io_file_bitmap_clear(&ctx->file_table, offset);
 	return 0;
 }
@@ -153,7 +148,7 @@ int io_register_file_alloc_range(struct io_ring_ctx *ctx,
 		return -EFAULT;
 	if (check_add_overflow(range.off, range.len, &end))
 		return -EOVERFLOW;
-	if (range.resv || end > ctx->nr_user_files)
+	if (range.resv || end > ctx->file_table.data.nr)
 		return -EINVAL;
 
 	io_file_table_set_alloc_range(ctx, range.off, range.len);
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index 47616079abaa..664c31502dbb 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -52,7 +52,7 @@ static inline struct file *io_slot_file(struct io_rsrc_node *node)
 static inline struct file *io_file_from_index(struct io_file_table *table,
 					      int index)
 {
-	struct io_rsrc_node *node = table->nodes[index];
+	struct io_rsrc_node *node = table->data.nodes[index];
 
 	if (node)
 		return io_slot_file(node);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0956401acd26..5842f27d5bdf 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1879,17 +1879,12 @@ inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	struct file *file = NULL;
 
 	io_ring_submit_lock(ctx, issue_flags);
-
-	if (unlikely((unsigned int)fd >= ctx->nr_user_files))
-		goto out;
-	fd = array_index_nospec(fd, ctx->nr_user_files);
-	node = ctx->file_table.nodes[fd];
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
index edea1ffd501c..b90ab3b8f5e0 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -180,8 +180,8 @@ static struct file *io_msg_grab_file(struct io_kiocb *req, unsigned int issue_fl
 	int idx = msg->src_fd;
 
 	io_ring_submit_lock(ctx, issue_flags);
-	if (likely(idx < ctx->nr_user_files)) {
-		idx = array_index_nospec(idx, ctx->nr_user_files);
+	if (likely(idx < ctx->file_table.data.nr)) {
+		idx = array_index_nospec(idx, ctx->file_table.data.nr);
 		file = io_file_from_index(&ctx->file_table, idx);
 		if (file)
 			get_file(file);
diff --git a/io_uring/net.c b/io_uring/net.c
index ce1156551d10..3e1f31574abb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1347,9 +1347,9 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
 
 		ret = -EFAULT;
 		io_ring_submit_lock(ctx, issue_flags);
-		if (sr->buf_index < ctx->nr_user_bufs) {
-			idx = array_index_nospec(sr->buf_index, ctx->nr_user_bufs);
-			node = ctx->user_bufs[idx];
+		if (sr->buf_index < ctx->buf_table.nr) {
+			idx = array_index_nospec(sr->buf_index, ctx->buf_table.nr);
+			node = ctx->buf_table.nodes[idx];
 			io_req_assign_rsrc_node(sr->notif, node);
 			ret = 0;
 		}
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index a2be3bbca5ff..3de75eca1c92 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -641,6 +641,7 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_SPLICE] = {
 		.name			= "SPLICE",
+		.cleanup		= io_splice_cleanup,
 	},
 	[IORING_OP_PROVIDE_BUFFERS] = {
 		.name			= "PROVIDE_BUFFERS",
@@ -650,6 +651,7 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_TEE] = {
 		.name			= "TEE",
+		.cleanup		= io_splice_cleanup,
 	},
 	[IORING_OP_SHUTDOWN] = {
 		.name			= "SHUTDOWN",
diff --git a/io_uring/register.c b/io_uring/register.c
index fc6c94d694b2..3c5a3cfb186b 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -855,7 +855,8 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	mutex_lock(&ctx->uring_lock);
 	ret = __io_uring_register(ctx, opcode, arg, nr_args);
 	mutex_unlock(&ctx->uring_lock);
-	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs, ret);
+	trace_io_uring_register(ctx, opcode, ctx->file_table.data.nr,
+				ctx->buf_table.nr, ret);
 	if (!use_registered_ring)
 		fput(file);
 	return ret;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 255618335b4f..20f110877e9c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -148,39 +148,28 @@ struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx,
 	return node;
 }
 
-static void io_rsrc_data_free(struct io_rsrc_data *data)
+__cold void io_rsrc_data_free(struct io_rsrc_data *data)
 {
-	int i;
-
-	for (i = 0; i < data->nr; i++) {
-		struct io_rsrc_node *node = data->nodes[i];
-
-		if (node)
-			io_put_rsrc_node(node);
+	if (!data->nr)
+		return;
+	while (data->nr--) {
+		if (data->nodes[data->nr])
+			io_put_rsrc_node(data->nodes[data->nr]);
 	}
 	kvfree(data->nodes);
-	kfree(data);
+	data->nodes = NULL;
+	data->nr = 0;
 }
 
-__cold static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, unsigned nr,
-				     struct io_rsrc_data **pdata)
+__cold int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr)
 {
-	struct io_rsrc_data *data;
-
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
 	data->nodes = kvmalloc_array(nr, sizeof(struct io_rsrc_node *),
-					GFP_KERNEL | __GFP_ZERO);
-	if (!data->nodes) {
-		io_rsrc_data_free(data);
-		return -ENOMEM;
+					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (data->nodes) {
+		data->nr = nr;
+		return 0;
 	}
-
-	data->nr = nr;
-	*pdata = data;
-	return 0;
+	return -ENOMEM;
 }
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
@@ -192,9 +181,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	int fd, i, err = 0;
 	unsigned int done;
 
-	if (!ctx->file_data)
+	if (!ctx->file_table.data.nr)
 		return -ENXIO;
-	if (up->offset + nr_args > ctx->nr_user_files)
+	if (up->offset + nr_args > ctx->file_table.data.nr)
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
@@ -212,10 +201,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 		if (fd == IORING_REGISTER_FILES_SKIP)
 			continue;
 
-		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
-		if (ctx->file_table.nodes[i]) {
-			io_put_rsrc_node(ctx->file_table.nodes[i]);
-			ctx->file_table.nodes[i] = NULL;
+		i = array_index_nospec(up->offset + done, ctx->file_table.data.nr);
+		if (ctx->file_table.data.nodes[i]) {
+			io_put_rsrc_node(ctx->file_table.data.nodes[i]);
+			ctx->file_table.data.nodes[i] = NULL;
 			io_file_bitmap_clear(&ctx->file_table, i);
 		}
 		if (fd != -1) {
@@ -234,13 +223,14 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
-			node = io_rsrc_node_alloc(ctx, ctx->file_data, i, IORING_RSRC_FILE);
+			node = io_rsrc_node_alloc(ctx, &ctx->file_table.data, i,
+						  IORING_RSRC_FILE);
 			if (!node) {
 				err = -ENOMEM;
 				fput(file);
 				break;
 			}
-			ctx->file_table.nodes[i] = node;
+			ctx->file_table.data.nodes[i] = node;
 			if (tag)
 				node->tag = tag;
 			io_fixed_file_set(node, file);
@@ -262,9 +252,9 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 	__u32 done;
 	int i, err;
 
-	if (!ctx->buf_data)
+	if (!ctx->buf_table.nr)
 		return -ENXIO;
-	if (up->offset + nr_args > ctx->nr_user_bufs)
+	if (up->offset + nr_args > ctx->buf_table.nr)
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
@@ -288,16 +278,16 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			err = -EINVAL;
 			break;
 		}
-		i = array_index_nospec(up->offset + done, ctx->nr_user_bufs);
+		i = array_index_nospec(up->offset + done, ctx->buf_table.nr);
 		node = io_sqe_buffer_register(ctx, iov, i, &last_hpage);
 		if (IS_ERR(node)) {
 			err = PTR_ERR(node);
 			break;
 		}
-		if (ctx->user_bufs[i])
-			io_put_rsrc_node(ctx->user_bufs[i]);
+		if (ctx->buf_table.nodes[i])
+			io_put_rsrc_node(ctx->buf_table.nodes[i]);
 
-		ctx->user_bufs[i] = node;
+		ctx->buf_table.nodes[i] = node;
 		if (tag)
 			node->tag = tag;
 		if (ctx->compat)
@@ -415,7 +405,7 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 	struct file *file;
 	int ret, fd;
 
-	if (!req->ctx->file_data)
+	if (!req->ctx->file_table.data.nr)
 		return -ENXIO;
 
 	for (done = 0; done < up->nr_args; done++) {
@@ -500,35 +490,13 @@ void io_free_rsrc_node(struct io_rsrc_node *node)
 	kfree(node);
 }
 
-static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
-{
-	int i;
-
-	lockdep_assert_held(&ctx->uring_lock);
-
-	for (i = 0; i < ctx->nr_user_files; i++) {
-		struct io_rsrc_node *node = ctx->file_table.nodes[i];
-
-		if (node) {
-			io_put_rsrc_node(node);
-			io_file_bitmap_clear(&ctx->file_table, i);
-			ctx->file_table.nodes[i] = NULL;
-		}
-	}
-
-	io_free_file_tables(&ctx->file_table);
-	io_file_table_set_alloc_range(ctx, 0, 0);
-	io_rsrc_data_free(ctx->file_data);
-	ctx->file_data = NULL;
-	ctx->nr_user_files = 0;
-}
-
 int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
-	if (!ctx->file_data)
+	if (!ctx->file_table.data.nr)
 		return -ENXIO;
 
-	__io_sqe_files_unregister(ctx);
+	io_free_file_tables(&ctx->file_table);
+	io_file_table_set_alloc_range(ctx, 0, 0);
 	return 0;
 }
 
@@ -540,7 +508,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	int fd, ret;
 	unsigned i;
 
-	if (ctx->file_data)
+	if (ctx->file_table.data.nr)
 		return -EBUSY;
 	if (!nr_args)
 		return -EINVAL;
@@ -548,17 +516,10 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EMFILE;
 	if (nr_args > rlimit(RLIMIT_NOFILE))
 		return -EMFILE;
-	ret = io_rsrc_data_alloc(ctx, nr_args, &ctx->file_data);
-	if (ret)
-		return ret;
-
-	if (!io_alloc_file_tables(&ctx->file_table, nr_args)) {
-		io_rsrc_data_free(ctx->file_data);
-		ctx->file_data = NULL;
+	if (!io_alloc_file_tables(&ctx->file_table, nr_args))
 		return -ENOMEM;
-	}
 
-	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
+	for (i = 0; i < nr_args; i++) {
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
@@ -572,7 +533,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			ret = -EINVAL;
 			if (tag)
 				goto fail;
-			ctx->file_table.nodes[i] = NULL;
+			ctx->file_table.data.nodes[i] = NULL;
 			continue;
 		}
 
@@ -589,51 +550,32 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			goto fail;
 		}
 		ret = -ENOMEM;
-		node = io_rsrc_node_alloc(ctx, ctx->file_data, i, IORING_RSRC_FILE);
+		node = io_rsrc_node_alloc(ctx, &ctx->file_table.data, i,
+					  IORING_RSRC_FILE);
 		if (!node) {
 			fput(file);
 			goto fail;
 		}
 		if (tag)
 			node->tag = tag;
-		ctx->file_table.nodes[i] = node;
+		ctx->file_table.data.nodes[i] = node;
 		io_fixed_file_set(node, file);
 		io_file_bitmap_set(&ctx->file_table, i);
 	}
 
 	/* default it to the whole table */
-	io_file_table_set_alloc_range(ctx, 0, ctx->nr_user_files);
+	io_file_table_set_alloc_range(ctx, 0, ctx->file_table.data.nr);
 	return 0;
 fail:
-	__io_sqe_files_unregister(ctx);
+	io_sqe_files_unregister(ctx);
 	return ret;
 }
 
-static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
-{
-	unsigned int i;
-
-	lockdep_assert_held(&ctx->uring_lock);
-
-	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		if (ctx->user_bufs[i]) {
-			io_put_rsrc_node(ctx->user_bufs[i]);
-			ctx->user_bufs[i] = NULL;
-		}
-	}
-	kvfree(ctx->user_bufs);
-	ctx->user_bufs = NULL;
-	io_rsrc_data_free(ctx->buf_data);
-	ctx->buf_data = NULL;
-	ctx->nr_user_bufs = 0;
-}
-
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
-	if (!ctx->buf_data)
+	if (!ctx->buf_table.nr)
 		return -ENXIO;
-
-	__io_sqe_buffers_unregister(ctx);
+	io_rsrc_data_free(&ctx->buf_table);
 	return 0;
 }
 
@@ -660,8 +602,8 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
 	}
 
 	/* check previously registered pages */
-	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		struct io_rsrc_node *node = ctx->user_bufs[i];
+	for (i = 0; i < ctx->buf_table.nr; i++) {
+		struct io_rsrc_node *node = ctx->buf_table.nodes[i];
 		struct io_mapped_ubuf *imu = node->buf;
 
 		for (j = 0; j < imu->nr_bvecs; j++) {
@@ -816,7 +758,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (!iov->iov_base)
 		return rsrc_empty_node;
 
-	node = io_rsrc_node_alloc(ctx, ctx->buf_data, index, IORING_RSRC_BUFFER);
+	node = io_rsrc_node_alloc(ctx, &ctx->buf_table, index, IORING_RSRC_BUFFER);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
 
@@ -874,40 +816,29 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	return node;
 }
 
-static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
-{
-	ctx->user_bufs = kcalloc(nr_args, sizeof(*ctx->user_bufs), GFP_KERNEL);
-	return ctx->user_bufs ? 0 : -ENOMEM;
-}
-
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned int nr_args, u64 __user *tags)
 {
 	struct page *last_hpage = NULL;
-	struct io_rsrc_data *data;
+	struct io_rsrc_data data;
 	struct iovec fast_iov, *iov = &fast_iov;
 	const struct iovec __user *uvec;
 	int i, ret;
 
 	BUILD_BUG_ON(IORING_MAX_REG_BUFFERS >= (1u << 16));
 
-	if (ctx->user_bufs)
+	if (ctx->buf_table.nr)
 		return -EBUSY;
 	if (!nr_args || nr_args > IORING_MAX_REG_BUFFERS)
 		return -EINVAL;
-	ret = io_rsrc_data_alloc(ctx, nr_args, &data);
+	ret = io_rsrc_data_alloc(&data, nr_args);
 	if (ret)
 		return ret;
-	ret = io_buffers_map_alloc(ctx, nr_args);
-	if (ret) {
-		io_rsrc_data_free(data);
-		return ret;
-	}
 
 	if (!arg)
 		memset(iov, 0, sizeof(*iov));
 
-	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
+	for (i = 0; i < nr_args; i++) {
 		struct io_rsrc_node *node;
 		u64 tag = 0;
 
@@ -945,14 +876,12 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		}
 		if (tag)
 			node->tag = tag;
-		ctx->user_bufs[i] = node;
+		data.nodes[i] = node;
 	}
 
-	WARN_ON_ONCE(ctx->buf_data);
-
-	ctx->buf_data = data;
+	ctx->buf_table = data;
 	if (ret)
-		__io_sqe_buffers_unregister(ctx);
+		io_sqe_buffers_unregister(ctx);
 	return ret;
 }
 
@@ -1019,8 +948,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
 static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
 {
-	struct io_rsrc_node **user_bufs;
-	struct io_rsrc_data *data;
+	struct io_rsrc_data data;
 	int i, ret, nbufs;
 
 	/*
@@ -1031,43 +959,35 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 
 	mutex_lock(&src_ctx->uring_lock);
 	ret = -ENXIO;
-	nbufs = src_ctx->nr_user_bufs;
+	nbufs = src_ctx->buf_table.nr;
 	if (!nbufs)
 		goto out_unlock;
-	ret = io_rsrc_data_alloc(ctx, nbufs, &data);
+	ret = io_rsrc_data_alloc(&data, nbufs);
 	if (ret)
 		goto out_unlock;
 
-	ret = -ENOMEM;
-	user_bufs = kvmalloc_array(nbufs, sizeof(struct io_rsrc_node *),
-					GFP_KERNEL);
-	if (!user_bufs)
-		goto out_free_data;
-
 	for (i = 0; i < nbufs; i++) {
-		struct io_rsrc_node *src_node = src_ctx->user_bufs[i];
+		struct io_rsrc_node *src_node = src_ctx->buf_table.nodes[i];
 		struct io_rsrc_node *dst_node;
 
 		if (src_node == rsrc_empty_node) {
 			dst_node = rsrc_empty_node;
 		} else {
-			dst_node = io_rsrc_node_alloc(ctx, data, i, IORING_RSRC_BUFFER);
+			dst_node = io_rsrc_node_alloc(ctx, &data, i, IORING_RSRC_BUFFER);
 			if (!dst_node)
 				goto out_put_free;
 
 			refcount_inc(&src_node->buf->refs);
 			dst_node->buf = src_node->buf;
 		}
-		user_bufs[i] = dst_node;
+		data.nodes[i] = dst_node;
 	}
 
 	/* Have a ref on the bufs now, drop src lock and re-grab our own lock */
 	mutex_unlock(&src_ctx->uring_lock);
 	mutex_lock(&ctx->uring_lock);
-	if (!ctx->user_bufs) {
-		ctx->user_bufs = user_bufs;
-		ctx->buf_data = data;
-		ctx->nr_user_bufs = nbufs;
+	if (!ctx->buf_table.nr) {
+		ctx->buf_table = data;
 		return 0;
 	}
 
@@ -1078,12 +998,10 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	i = nbufs;
 out_put_free:
 	while (i--) {
-		io_buffer_unmap(src_ctx, user_bufs[i]);
-		kfree(user_bufs[i]);
+		io_buffer_unmap(src_ctx, data.nodes[i]);
+		kfree(data.nodes[i]);
 	}
-	kvfree(user_bufs);
-out_free_data:
-	io_rsrc_data_free(data);
+	io_rsrc_data_free(&data);
 out_unlock:
 	mutex_unlock(&src_ctx->uring_lock);
 	mutex_lock(&ctx->uring_lock);
@@ -1104,7 +1022,7 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	struct file *file;
 	int ret;
 
-	if (ctx->user_bufs || ctx->nr_user_bufs)
+	if (ctx->buf_table.nr)
 		return -EBUSY;
 	if (copy_from_user(&buf, arg, sizeof(buf)))
 		return -EFAULT;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index d62d086331d2..f9f2b254b0c6 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -14,11 +14,6 @@ enum {
 	IORING_RSRC_INVALID		= 2,
 };
 
-struct io_rsrc_data {
-	unsigned int			nr;
-	struct io_rsrc_node		**nodes;
-};
-
 struct io_rsrc_node {
 	struct io_ring_ctx		*ctx;
 	int				refs;
@@ -55,6 +50,8 @@ struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx,
 					struct io_rsrc_data *data, int index,
 					int type);
 void io_free_rsrc_node(struct io_rsrc_node *node);
+void io_rsrc_data_free(struct io_rsrc_data *data);
+int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
 int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
@@ -78,6 +75,16 @@ int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 extern const struct io_rsrc_node empty_node;
 #define rsrc_empty_node	(struct io_rsrc_node *) &empty_node
 
+static inline struct io_rsrc_node *io_rsrc_node_lookup(struct io_rsrc_data *data,
+						       int index)
+{
+	if (index < data->nr) {
+		index = array_index_nospec(index, data->nr);
+		return data->nodes[index];
+	}
+	return NULL;
+}
+
 static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 {
 	if (node != &empty_node && !--node->refs)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 65491f4f2c7e..28fff18ebb19 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -339,10 +339,10 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	if (unlikely(ret))
 		return ret;
 
-	if (unlikely(req->buf_index >= ctx->nr_user_bufs))
+	if (unlikely(req->buf_index >= ctx->buf_table.nr))
 		return -EFAULT;
-	index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
-	node = ctx->user_bufs[index];
+	index = array_index_nospec(req->buf_index, ctx->buf_table.nr);
+	node = ctx->buf_table.nodes[index];
 	io_req_assign_rsrc_node(req, node);
 
 	io = req->async_data;
diff --git a/io_uring/splice.c b/io_uring/splice.c
index 3b659cd23e9d..deeb8bb18651 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -21,6 +21,7 @@ struct io_splice {
 	u64				len;
 	int				splice_fd_in;
 	unsigned int			flags;
+	struct io_rsrc_node		*rsrc_node;
 };
 
 static int __io_splice_prep(struct io_kiocb *req,
@@ -34,6 +35,7 @@ static int __io_splice_prep(struct io_kiocb *req,
 	if (unlikely(sp->flags & ~valid_flags))
 		return -EINVAL;
 	sp->splice_fd_in = READ_ONCE(sqe->splice_fd_in);
+	sp->rsrc_node = rsrc_empty_node;
 	req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;
 }
@@ -45,6 +47,36 @@ int io_tee_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return __io_splice_prep(req, sqe);
 }
 
+void io_splice_cleanup(struct io_kiocb *req)
+{
+	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
+
+	io_put_rsrc_node(sp->rsrc_node);
+}
+
+static struct file *io_splice_get_file(struct io_kiocb *req,
+				       unsigned int issue_flags)
+{
+	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_rsrc_node *node;
+	struct file *file = NULL;
+
+	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
+		return io_file_get_normal(req, sp->splice_fd_in);
+
+	io_ring_submit_lock(ctx, issue_flags);
+	node = io_rsrc_node_lookup(&ctx->file_table.data, sp->splice_fd_in);
+	if (node) {
+		node->refs++;
+		sp->rsrc_node = node;
+		file = io_slot_file(node);
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+	io_ring_submit_unlock(ctx, issue_flags);
+	return file;
+}
+
 int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
@@ -55,10 +87,7 @@ int io_tee(struct io_kiocb *req, unsigned int issue_flags)
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	if (sp->flags & SPLICE_F_FD_IN_FIXED)
-		in = io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
-	else
-		in = io_file_get_normal(req, sp->splice_fd_in);
+	in = io_splice_get_file(req, issue_flags);
 	if (!in) {
 		ret = -EBADF;
 		goto done;
@@ -96,10 +125,7 @@ int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 
 	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
 
-	if (sp->flags & SPLICE_F_FD_IN_FIXED)
-		in = io_file_get_fixed(req, sp->splice_fd_in, issue_flags);
-	else
-		in = io_file_get_normal(req, sp->splice_fd_in);
+	in = io_splice_get_file(req, issue_flags);
 	if (!in) {
 		ret = -EBADF;
 		goto done;
diff --git a/io_uring/splice.h b/io_uring/splice.h
index 542f94168ad3..b9b2848327fb 100644
--- a/io_uring/splice.h
+++ b/io_uring/splice.h
@@ -3,5 +3,6 @@
 int io_tee_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_tee(struct io_kiocb *req, unsigned int issue_flags);
 
+void io_splice_cleanup(struct io_kiocb *req);
 int io_splice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_splice(struct io_kiocb *req, unsigned int issue_flags);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 0899c71008ae..17d5f5004702 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -212,15 +212,15 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		u16 index;
 
 		index = READ_ONCE(sqe->buf_index);
-		if (unlikely(index >= ctx->nr_user_bufs))
+		if (unlikely(index >= ctx->buf_table.nr))
 			return -EFAULT;
-		req->buf_index = array_index_nospec(index, ctx->nr_user_bufs);
+		req->buf_index = array_index_nospec(index, ctx->buf_table.nr);
 		/*
 		 * Pi node upfront, prior to io_uring_cmd_import_fixed()
 		 * being called. This prevents destruction of the mapped buffer
 		 * we'll need at actual import time.
 		 */
-		io_req_assign_rsrc_node(req, ctx->user_bufs[req->buf_index]);
+		io_req_assign_rsrc_node(req, ctx->buf_table.nodes[req->buf_index]);
 	}
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 
-- 
2.45.2


