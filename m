Return-Path: <io-uring+bounces-4079-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FDF69B3458
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 16:05:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9256C1C21D52
	for <lists+io-uring@lfdr.de>; Mon, 28 Oct 2024 15:05:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D49ED18FDB0;
	Mon, 28 Oct 2024 15:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="QCnnT6/Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F04091DE3A4
	for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 15:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730127900; cv=none; b=GCIT5ce68YqHddUV+upXhueizj+p0S6C1ax5M3sD6pDsOiM1rqvuQTsxfcPmZQp5zWSilSOSaYHuPLtg6Cof5gJnKFGnFxLoDItQY4Dj3inSrG4JUzUNeOetmseA8d08B+Sakip+xEf0cSGpB8EnKITxN7WHgqVxbiBp3GA1x+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730127900; c=relaxed/simple;
	bh=0BnyqkamtuUuQn4QJVLoOghGjVWM62N0LYqrMKR2z2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CiKrvvrKflQKvwbrdtUlvVHnJ39iBdFvsKhfrkg8lFWor/5J8hkmYPMbNBMEpTES6mzII7XSF5pYFrsFEY797dIMUzIUrnLEq4WRvsIrireP+8H1iLaQEhzzgsgYZ2I01Jn/s4NCzPAHaQJb7eVUljub5nA0tUqzTUj3HWXrBsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=QCnnT6/Y; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7180a5ba498so2204504a34.2
        for <io-uring@vger.kernel.org>; Mon, 28 Oct 2024 08:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730127895; x=1730732695; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1BS+W7w4HDWk3Ej95MgpffIdqXXe0wni3SuXIa6yK7c=;
        b=QCnnT6/YWO1wPU3XaheW3H/FVi7Hq7B5wKRuVTZDl4ObGjxQaprgrKi+yD3l5t8ZAr
         zIAnybH8bBWttjLc0M4kTC11r1/QpTb0a4VVocX6wql4D4BENGdjrFov/zKlqoj+tm+X
         /bVIqYSJGlsP6g/eQ2uJ7eld6yr+jj1KETTGKfWSK3hlikQ2/IzQKK9LBKtc/EaJ3N99
         eisC5hTR2qIWMvlkIu7NYvA5FL1m38Y94EUbfrGtZHaey/DEYRv+yjOyj65+n/fuxhl1
         1z5uSjsE8Nah/Taf5kz/+vftBOvQeUQzexMhKqma6/YXByIlYSnUSmtgWJuxN5MAUR9O
         IjvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730127895; x=1730732695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1BS+W7w4HDWk3Ej95MgpffIdqXXe0wni3SuXIa6yK7c=;
        b=Lhr0SawWIywaTaplt8VpCeTHxPlVWOguqV2Mw0NF3v7JHbsoiMQ72/CQ7HJEvB9Y7z
         mhTRwiSzhY9zExhqNE/dLRGT3c/U14U/0ZUd15jWJ3W3f6DqxgirJwM6ErT2RrxNIGKB
         NE8rqpoMNm9o5HFfeccn4FQyoywloy7AijidA/vcwGV8hz1mJtWACg8Za5AdpyaRbuZR
         5zaGaOb3c0fUY4UjBN+Cq7P86tM/IEww7y0KjEEJz8rOQvFaX+4ZiHLMfhi/Ku8FncQm
         BLAZtpvQXQQFeZdB2rNEbTjXg/Xn6OOoSLHjmyrak2YKYqaT3E7eIQ2UfHt60YRHCaxO
         9fIw==
X-Gm-Message-State: AOJu0YyAG8+ct2wIYc6jxYAgrFb7XQKRgmc2dOtBCHfRcSXGShhffTpm
	01PATuifcBVk+tmnqrIZzgLEltpIBhFBVg3658LqGXpAYrb82VwV/1HqZj5t4oREl16LWBkZZxa
	D
X-Google-Smtp-Source: AGHT+IHnOV6xaqEJSWOXHTJZ7zKxWgNQM+3boCY1wjVjbFtMwiS2VgNWVeQMEsXhyy5ZM3IDD/IaoQ==
X-Received: by 2002:a05:6830:610a:b0:717:f7b9:e408 with SMTP id 46e09a7af769-7186829a607mr9788883a34.28.1730127895159;
        Mon, 28 Oct 2024 08:04:55 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc7261c7e3sm1721616173.72.2024.10.28.08.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2024 08:04:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/13] io_uring/rsrc: unify file and buffer resource tables
Date: Mon, 28 Oct 2024 08:52:40 -0600
Message-ID: <20241028150437.387667-11-axboe@kernel.dk>
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
 io_uring/nop.c                 |   6 +-
 io_uring/register.c            |   3 +-
 io_uring/rsrc.c                | 212 ++++++++++-----------------------
 io_uring/rsrc.h                |  17 ++-
 io_uring/rw.c                  |   6 +-
 io_uring/splice.c              |   6 +-
 io_uring/uring_cmd.c           |   6 +-
 15 files changed, 131 insertions(+), 220 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 696f2a05a98b..77fd508d043a 100644
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
 
@@ -366,10 +369,6 @@ struct io_ring_ctx {
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
index 60c947114fa3..3a535e9e8ac3 100644
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
diff --git a/io_uring/nop.c b/io_uring/nop.c
index de91600a3bc6..0dac01127de5 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -66,9 +66,9 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 
 		ret = -EFAULT;
 		io_ring_submit_lock(ctx, issue_flags);
-		if (nop->buffer < ctx->nr_user_bufs) {
-			idx = array_index_nospec(nop->buffer, ctx->nr_user_bufs);
-			node = READ_ONCE(ctx->user_bufs[idx]);
+		if (nop->buffer < ctx->buf_table.nr) {
+			idx = array_index_nospec(nop->buffer, ctx->buf_table.nr);
+			node = READ_ONCE(ctx->buf_table.nodes[idx]);
 			io_req_assign_rsrc_node(req, node);
 			ret = 0;
 		}
diff --git a/io_uring/register.c b/io_uring/register.c
index 1eb686eaa310..45edfc57963a 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -937,7 +937,8 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
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
index 08c57332c783..108c94428e7c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -147,39 +147,28 @@ struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx,
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
@@ -191,9 +180,9 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 	int fd, i, err = 0;
 	unsigned int done;
 
-	if (!ctx->file_data)
+	if (!ctx->file_table.data.nr)
 		return -ENXIO;
-	if (up->offset + nr_args > ctx->nr_user_files)
+	if (up->offset + nr_args > ctx->file_table.data.nr)
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
@@ -211,10 +200,10 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
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
@@ -233,13 +222,14 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
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
@@ -261,9 +251,9 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 	__u32 done;
 	int i, err;
 
-	if (!ctx->buf_data)
+	if (!ctx->buf_table.nr)
 		return -ENXIO;
-	if (up->offset + nr_args > ctx->nr_user_bufs)
+	if (up->offset + nr_args > ctx->buf_table.nr)
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
@@ -287,16 +277,16 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
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
@@ -414,7 +404,7 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 	struct file *file;
 	int ret, fd;
 
-	if (!req->ctx->file_data)
+	if (!req->ctx->file_table.data.nr)
 		return -ENXIO;
 
 	for (done = 0; done < up->nr_args; done++) {
@@ -499,35 +489,13 @@ void io_free_rsrc_node(struct io_rsrc_node *node)
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
 
@@ -539,7 +507,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	int fd, ret;
 	unsigned i;
 
-	if (ctx->file_data)
+	if (ctx->file_table.data.nr)
 		return -EBUSY;
 	if (!nr_args)
 		return -EINVAL;
@@ -547,17 +515,10 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
 
@@ -587,51 +548,32 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
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
 
@@ -658,8 +600,8 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
 	}
 
 	/* check previously registered pages */
-	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		struct io_rsrc_node *node = ctx->user_bufs[i];
+	for (i = 0; i < ctx->buf_table.nr; i++) {
+		struct io_rsrc_node *node = ctx->buf_table.nodes[i];
 		struct io_mapped_ubuf *imu = node->buf;
 
 		for (j = 0; j < imu->nr_bvecs; j++) {
@@ -814,7 +756,7 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
 	if (!iov->iov_base)
 		return rsrc_empty_node;
 
-	node = io_rsrc_node_alloc(ctx, ctx->buf_data, index, IORING_RSRC_BUFFER);
+	node = io_rsrc_node_alloc(ctx, &ctx->buf_table, index, IORING_RSRC_BUFFER);
 	if (!node)
 		return ERR_PTR(-ENOMEM);
 
@@ -872,40 +814,29 @@ static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
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
 
@@ -943,14 +874,12 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
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
 
@@ -1017,8 +946,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
 static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
 {
-	struct io_rsrc_node **user_bufs;
-	struct io_rsrc_data *data;
+	struct io_rsrc_data data;
 	int i, ret, nbufs;
 
 	/*
@@ -1029,43 +957,35 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 
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
-					GFP_KERNEL | __GFP_ZERO);
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
 
@@ -1076,12 +996,10 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
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
@@ -1102,7 +1020,7 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	struct file *file;
 	int ret;
 
-	if (ctx->user_bufs || ctx->nr_user_bufs)
+	if (ctx->buf_table.nr)
 		return -EBUSY;
 	if (copy_from_user(&buf, arg, sizeof(buf)))
 		return -EFAULT;
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 53907e142ae0..dcc1fb185035 100644
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
@@ -54,6 +49,8 @@ struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx,
 					struct io_rsrc_data *data, int index,
 					int type);
 void io_free_rsrc_node(struct io_rsrc_node *node);
+void io_rsrc_data_free(struct io_rsrc_data *data);
+int io_rsrc_data_alloc(struct io_rsrc_data *data, unsigned nr);
 
 int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
@@ -77,6 +74,16 @@ int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
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
index f78afb575ae6..deeb8bb18651 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -66,17 +66,13 @@ static struct file *io_splice_get_file(struct io_kiocb *req,
 		return io_file_get_normal(req, sp->splice_fd_in);
 
 	io_ring_submit_lock(ctx, issue_flags);
-	if (unlikely(sp->splice_fd_in >= ctx->nr_user_files))
-		goto out;
-	sp->splice_fd_in = array_index_nospec(sp->splice_fd_in, ctx->nr_user_files);
-	node = ctx->file_table.nodes[sp->splice_fd_in];
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


