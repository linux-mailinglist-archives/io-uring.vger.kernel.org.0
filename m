Return-Path: <io-uring+bounces-4112-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 31F4B9B4DBD
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:23:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 55515B21B64
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:23:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3376A193062;
	Tue, 29 Oct 2024 15:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1+nEl7tH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5EA192D73
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215398; cv=none; b=OJBKDXbjdqjinZWCh0un3grMDknyoXsEr99IWcoC7ipDhmkkCkeTVEuPf38iSsBcFRuvVveAK3hA+McIEz2zy1JGP8zHFOh33n/qC9QO2UxL04NG0pLembZLqCXlhGLHqwlrJRsZ2hsTXauvrUhSotkSAEtCti+xL4kAp9rx6V0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215398; c=relaxed/simple;
	bh=rrYc8QxJZjtACr3rDws3gOPUbamqv8LDvlTGAhmYsJM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bQDZj3iN5P1ulOERUOB+d6XNJvBc7omKNj+Txmut2uMBcLqhtDEQW4eLp3/kGqLAxuPbpVsJ/OgXC9oKoJX86eEN/a/80DcJsR9zFzOCpYmnn0CFm8MFE3+Y11MIoP+OwlQID0jJIZM1Jbad1d6RxfQyuARFbbaU4/LytvLEl7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1+nEl7tH; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-83ac05206f6so220053039f.2
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215391; x=1730820191; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zP8PSO9nDyVeha6FI/vDMeHO48afNlfSXRjIEo17AVg=;
        b=1+nEl7tHuM3K5NHbkOtEZowDLubnfmDnVmgLsnQmgWlID+W9qpdHj20e9deEoXHOzs
         EJKQ3KVN+pUord4jYWX+RE8EAhE5mZkeWpz5Jv+WnHUji4MGwbMpOPuJ5scL3TBly/Pd
         HHJLEUWc7hVoJHKPIDdNPzP1FWLy9oFa77IUuHGkHoEj27fKeKkZfNPetzE4akwKK1tv
         7KnwnaAFGCB17SoqP52LHu3hZR8ifYBhpvwcvW0yceEsZQmcsJpN2wNAPn7A6DCcymQ1
         9RaBbvVczTvPYPZrtvvIkv/pi0o5XqymDs00wMfWNEh+giYMUl4VsZliYGsoVzC21ELj
         hwgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215391; x=1730820191;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zP8PSO9nDyVeha6FI/vDMeHO48afNlfSXRjIEo17AVg=;
        b=iYDk4SOWJeqlwPz+o30DuupHvTIF7XBTl7+5o7LEuOKoT1loeTIEo2W3IEeqMlqlvN
         5kd5zJ/0+hZ9i3EVV18lqDmcURqk91BRBwWuqsI7v0c+u0o3Lg3f4Gtdprr5DlgP/pay
         +9A63Q1SObsv8i5KTTA/Og4rxY7sk49vMAmE5JcLstyoddLQyJhrcqsXiC1gbsLTzESL
         +C85i1cL05XVLt7/ExezEDl3+nDUJ6eWfYO6B9wJ7y7lAAKF6znsC0xy1s7k7vBcgWBK
         3cG0A3qpvU6jSg+kLMADR3aN2DAP/0bUEiDHJ+Vb9xi3Pw8duKg7+1qCuTyN1Ju5VJeq
         tfXg==
X-Gm-Message-State: AOJu0YyBwrR95znuR76erJPbVtuYZaOu6T9uPA/sAoWKKk9/U7yooSYi
	jBdJKIVD11XBpYvONg0ZWw+Sx1yVa70yqrcK6avwC8MBinteRubQV1f0ozd/Meo5IMeS8ucZ0Pg
	h
X-Google-Smtp-Source: AGHT+IGVLFwpQie4rZ5VXIXhUFNRIi2k/w/H9ra4ToQljl+/Lyv3Achw7epttx2Gh33Zw/Z5mWYnSQ==
X-Received: by 2002:a05:6602:1402:b0:837:6dae:207b with SMTP id ca18e2360f4ac-83b1c5fa56fmr1220330839f.16.1730215390574;
        Tue, 29 Oct 2024 08:23:10 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/14] io_uring/rsrc: get rid of per-ring io_rsrc_node list
Date: Tue, 29 Oct 2024 09:16:35 -0600
Message-ID: <20241029152249.667290-7-axboe@kernel.dk>
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

Work in progress, but get rid of the per-ring serialization of resource
nodes, like registered buffers and files. Main issue here is that one
node can otherwise hold up a bunch of other nodes from getting freed,
which is especially a problem for file resource nodes and networked
workloads where some descriptors may not see activity in a long time.

As an example, instantiate an io_uring ring fd and create a sparse
registered file table. Even 2 will do. Then create a socket and register
it as fixed file 0, F0. The number of open files in the app is now 5,
with 0/1/2 being the usual stdin/out/err, 3 being the ring fd, and 4
being the socket. Register this socket (eg "the listener") in slot 0 of
the registered file table. Now add an operation on the socket that uses
slot 0. Finally, loop N times, where each loop creates a new socket,
registers said socket as a file, then unregisters the socket, and
finally closes the socket. This is roughly similar to what a basic
accept loop would look like.

At the end of this loop, it's not unreasonable to expect that there
would still be 5 open files. Each socket created and registered in the
loop is also unregistered and closed. But since the listener socket
registered first still has references to its resource node due to still
being active, each subsequent socket unregistration is stuck behind it
for reclaim. Hence 5 + N files are still open at that point, where N is
awaiting the final put held up by the listener socket.

Rewrite the io_rsrc_node handling to NOT rely on serialization. Struct
io_kiocb now gets explicit resource nodes assigned, with each holding a
reference to the parent node. A parent node is either of type FILE or
BUFFER, which are the two types of nodes that exist. A request can have
two nodes assigned, if it's using both registered files and buffers.
Since request issue and task_work completion is both under the ring
private lock, no atomics are needed to handle these references. It's a
simple unlocked inc/dec. As before, the registered buffer or file table
each hold a reference as well to the registered nodes. Final put of the
node will remove the node and free the underlying resource, eg unmap the
buffer or put the file.

Outside of removing the stall in resource reclaim described above, it
has the following advantages:

1) It's a lot simpler than the previous scheme, and easier to follow.
   No need to specific quiesce handling anymore.

2) There are no resource node allocations in the fast path, all of that
   happens at resource registration time.

3) The structs related to resource handling can all get simplified
   quite a bit, like io_rsrc_node and io_rsrc_data. io_rsrc_put can
   go away completely.

4) Handling of resource tags is much simpler, and doesn't require
   persistent storage as it can simply get assigned up front at
   registration time. Just copy them in one-by-one at registration time
   and assign to the resource node.

The only real downside is that a request is now explicitly limited to
pinning 2 resources, one file and one buffer, where before just
assigning a resource node to a request would pin all of them. The upside
is that it's easier to follow now, as an individual resource is
explicitly referenced and assigned to the request.

With this in place, the above mentioned example will be using exactly 5
files at the end of the loop, not N.

Needs to get broken up a bit and there are certainly rough edges, but
that's why it's a work in progress... But it does remove a ton more code
than it adds, and passes the liburing tests.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  10 +-
 io_uring/fdinfo.c              |   2 +-
 io_uring/filetable.c           |  52 ++--
 io_uring/filetable.h           |  25 +-
 io_uring/io_uring.c            |  38 +--
 io_uring/net.c                 |  11 +-
 io_uring/nop.c                 |   6 +-
 io_uring/notif.c               |   3 +-
 io_uring/rsrc.c                | 482 ++++++++++++---------------------
 io_uring/rsrc.h                |  72 ++---
 io_uring/rw.c                  |   8 +-
 io_uring/splice.c              |  16 +-
 io_uring/uring_cmd.c           |  12 +-
 13 files changed, 272 insertions(+), 465 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d4ba4ae480d6..42c5f2c992c4 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -56,7 +56,7 @@ struct io_wq_work {
 };
 
 struct io_file_table {
-	struct io_fixed_file *files;
+	struct io_rsrc_node **nodes;
 	unsigned long *bitmap;
 	unsigned int alloc_hint;
 };
@@ -264,7 +264,6 @@ struct io_ring_ctx {
 		 * Fixed resources fast path, should be accessed only under
 		 * uring_lock, and updated through io_uring_register(2)
 		 */
-		struct io_rsrc_node	*rsrc_node;
 		atomic_t		cancel_seq;
 
 		/*
@@ -277,7 +276,7 @@ struct io_ring_ctx {
 		struct io_wq_work_list	iopoll_list;
 
 		struct io_file_table	file_table;
-		struct io_mapped_ubuf	**user_bufs;
+		struct io_rsrc_node	**user_bufs;
 		unsigned		nr_user_files;
 		unsigned		nr_user_bufs;
 
@@ -372,10 +371,7 @@ struct io_ring_ctx {
 	struct io_rsrc_data		*buf_data;
 
 	/* protected by ->uring_lock */
-	struct list_head		rsrc_ref_list;
 	struct io_alloc_cache		rsrc_node_cache;
-	struct wait_queue_head		rsrc_quiesce_wq;
-	unsigned			rsrc_quiesce;
 
 	u32			pers_next;
 	struct xarray		personalities;
@@ -642,7 +638,7 @@ struct io_kiocb {
 		__poll_t apoll_events;
 	};
 
-	struct io_rsrc_node		*rsrc_node;
+	struct io_rsrc_node		*rsrc_nodes[2];
 
 	atomic_t			refs;
 	bool				cancel_seq_set;
diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index a6bac533edbe..064a79475c5f 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -176,7 +176,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *file)
 	}
 	seq_printf(m, "UserBufs:\t%u\n", ctx->nr_user_bufs);
 	for (i = 0; has_lock && i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *buf = ctx->user_bufs[i];
+		struct io_mapped_ubuf *buf = ctx->user_bufs[i]->buf;
 
 		seq_printf(m, "%5u: 0x%llx/%u\n", i, buf->ubuf, buf->len);
 	}
diff --git a/io_uring/filetable.c b/io_uring/filetable.c
index 997c56d32ee6..a01be324ac15 100644
--- a/io_uring/filetable.c
+++ b/io_uring/filetable.c
@@ -38,14 +38,14 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
 
 bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
 {
-	table->files = kvcalloc(nr_files, sizeof(table->files[0]),
-				GFP_KERNEL_ACCOUNT);
-	if (unlikely(!table->files))
+	table->nodes = kvmalloc_array(nr_files, sizeof(struct io_src_node *),
+					GFP_KERNEL_ACCOUNT | __GFP_ZERO);
+	if (unlikely(!table->nodes))
 		return false;
 
 	table->bitmap = bitmap_zalloc(nr_files, GFP_KERNEL_ACCOUNT);
 	if (unlikely(!table->bitmap)) {
-		kvfree(table->files);
+		kvfree(table->nodes);
 		return false;
 	}
 
@@ -54,9 +54,9 @@ bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
 
 void io_free_file_tables(struct io_file_table *table)
 {
-	kvfree(table->files);
+	kvfree(table->nodes);
 	bitmap_free(table->bitmap);
-	table->files = NULL;
+	table->nodes = NULL;
 	table->bitmap = NULL;
 }
 
@@ -64,8 +64,7 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 				 u32 slot_index)
 	__must_hold(&req->ctx->uring_lock)
 {
-	struct io_fixed_file *file_slot;
-	int ret;
+	struct io_rsrc_node *node;
 
 	if (io_is_uring_fops(file))
 		return -EBADF;
@@ -74,22 +73,18 @@ static int io_install_fixed_file(struct io_ring_ctx *ctx, struct file *file,
 	if (slot_index >= ctx->nr_user_files)
 		return -EINVAL;
 
-	slot_index = array_index_nospec(slot_index, ctx->nr_user_files);
-	file_slot = io_fixed_file_slot(&ctx->file_table, slot_index);
-
-	if (file_slot->file_ptr) {
-		ret = io_queue_rsrc_removal(ctx->file_data, slot_index,
-					    io_slot_file(file_slot));
-		if (ret)
-			return ret;
+	node = io_rsrc_node_alloc(ctx, ctx->file_data, IORING_RSRC_FILE);
+	if (IS_ERR(node))
+		return -ENOMEM;
 
-		file_slot->file_ptr = 0;
-	} else {
+	slot_index = array_index_nospec(slot_index, ctx->nr_user_files);
+	if (ctx->file_table.nodes[slot_index])
+		io_put_rsrc_node(ctx->file_table.nodes[slot_index]);
+	else
 		io_file_bitmap_set(&ctx->file_table, slot_index);
-	}
 
-	*io_get_tag_slot(ctx->file_data, slot_index) = 0;
-	io_fixed_file_set(file_slot, file);
+	ctx->file_table.nodes[slot_index] = node;
+	io_fixed_file_set(node, file);
 	return 0;
 }
 
@@ -134,25 +129,16 @@ int io_fixed_fd_install(struct io_kiocb *req, unsigned int issue_flags,
 
 int io_fixed_fd_remove(struct io_ring_ctx *ctx, unsigned int offset)
 {
-	struct io_fixed_file *file_slot;
-	int ret;
-
 	if (unlikely(!ctx->file_data))
 		return -ENXIO;
 	if (offset >= ctx->nr_user_files)
 		return -EINVAL;
 
 	offset = array_index_nospec(offset, ctx->nr_user_files);
-	file_slot = io_fixed_file_slot(&ctx->file_table, offset);
-	if (!file_slot->file_ptr)
+	if (!ctx->file_table.nodes[offset])
 		return -EBADF;
-
-	ret = io_queue_rsrc_removal(ctx->file_data, offset,
-				    io_slot_file(file_slot));
-	if (ret)
-		return ret;
-
-	file_slot->file_ptr = 0;
+	io_put_rsrc_node(ctx->file_table.nodes[offset]);
+	ctx->file_table.nodes[offset] = NULL;
 	io_file_bitmap_clear(&ctx->file_table, offset);
 	return 0;
 }
diff --git a/io_uring/filetable.h b/io_uring/filetable.h
index c027ed4ad68d..47616079abaa 100644
--- a/io_uring/filetable.h
+++ b/io_uring/filetable.h
@@ -34,36 +34,35 @@ static inline void io_file_bitmap_set(struct io_file_table *table, int bit)
 	table->alloc_hint = bit + 1;
 }
 
-static inline struct io_fixed_file *
-io_fixed_file_slot(struct io_file_table *table, unsigned i)
-{
-	return &table->files[i];
-}
-
 #define FFS_NOWAIT		0x1UL
 #define FFS_ISREG		0x2UL
 #define FFS_MASK		~(FFS_NOWAIT|FFS_ISREG)
 
-static inline unsigned int io_slot_flags(struct io_fixed_file *slot)
+static inline unsigned int io_slot_flags(struct io_rsrc_node *node)
 {
-	return (slot->file_ptr & ~FFS_MASK) << REQ_F_SUPPORT_NOWAIT_BIT;
+
+	return (node->file_ptr & ~FFS_MASK) << REQ_F_SUPPORT_NOWAIT_BIT;
 }
 
-static inline struct file *io_slot_file(struct io_fixed_file *slot)
+static inline struct file *io_slot_file(struct io_rsrc_node *node)
 {
-	return (struct file *)(slot->file_ptr & FFS_MASK);
+	return (struct file *)(node->file_ptr & FFS_MASK);
 }
 
 static inline struct file *io_file_from_index(struct io_file_table *table,
 					      int index)
 {
-	return io_slot_file(io_fixed_file_slot(table, index));
+	struct io_rsrc_node *node = table->nodes[index];
+
+	if (node)
+		return io_slot_file(node);
+	return NULL;
 }
 
-static inline void io_fixed_file_set(struct io_fixed_file *file_slot,
+static inline void io_fixed_file_set(struct io_rsrc_node *node,
 				     struct file *file)
 {
-	file_slot->file_ptr = (unsigned long)file |
+	node->file_ptr = (unsigned long)file |
 		(io_file_get_flags(file) >> REQ_F_SUPPORT_NOWAIT_BIT);
 }
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a09c67b38c1b..0876aa74c739 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -333,7 +333,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	mutex_init(&ctx->uring_lock);
 	init_waitqueue_head(&ctx->cq_wait);
 	init_waitqueue_head(&ctx->poll_wq);
-	init_waitqueue_head(&ctx->rsrc_quiesce_wq);
 	spin_lock_init(&ctx->completion_lock);
 	spin_lock_init(&ctx->timeout_lock);
 	INIT_WQ_LIST(&ctx->iopoll_list);
@@ -341,7 +340,6 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 	INIT_LIST_HEAD(&ctx->defer_list);
 	INIT_LIST_HEAD(&ctx->timeout_list);
 	INIT_LIST_HEAD(&ctx->ltimeout_list);
-	INIT_LIST_HEAD(&ctx->rsrc_ref_list);
 	init_llist_head(&ctx->work_llist);
 	INIT_LIST_HEAD(&ctx->tctx_list);
 	ctx->submit_state.free_list.next = NULL;
@@ -1415,7 +1413,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 				io_clean_op(req);
 		}
 		io_put_file(req);
-		io_put_rsrc_node(ctx, req->rsrc_node);
+		io_req_put_rsrc_nodes(req);
 		io_put_task(req->task);
 
 		node = req->comp_list.next;
@@ -1878,7 +1876,7 @@ inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 				      unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_fixed_file *slot;
+	struct io_rsrc_node *node;
 	struct file *file = NULL;
 
 	io_ring_submit_lock(ctx, issue_flags);
@@ -1886,11 +1884,12 @@ inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 	if (unlikely((unsigned int)fd >= ctx->nr_user_files))
 		goto out;
 	fd = array_index_nospec(fd, ctx->nr_user_files);
-	slot = io_fixed_file_slot(&ctx->file_table, fd);
-	if (!req->rsrc_node)
-		__io_req_set_rsrc_node(req, ctx);
-	req->flags |= io_slot_flags(slot);
-	file = io_slot_file(slot);
+	node = ctx->file_table.nodes[fd];
+	if (node) {
+		io_req_assign_rsrc_node(req, node);
+		req->flags |= io_slot_flags(node);
+		file = io_slot_file(node);
+	}
 out:
 	io_ring_submit_unlock(ctx, issue_flags);
 	return file;
@@ -2036,7 +2035,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->flags = (__force io_req_flags_t) sqe_flags;
 	req->cqe.user_data = READ_ONCE(sqe->user_data);
 	req->file = NULL;
-	req->rsrc_node = NULL;
+	req->rsrc_nodes[IORING_RSRC_FILE] = NULL;
+	req->rsrc_nodes[IORING_RSRC_BUFFER] = NULL;
 	req->task = current;
 	req->cancel_seq_set = false;
 
@@ -2718,15 +2718,10 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
 	io_sq_thread_finish(ctx);
-	/* __io_rsrc_put_work() may need uring_lock to progress, wait w/o it */
-	if (WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list)))
-		return;
 
 	mutex_lock(&ctx->uring_lock);
-	if (ctx->buf_data)
-		__io_sqe_buffers_unregister(ctx);
-	if (ctx->file_data)
-		__io_sqe_files_unregister(ctx);
+	io_sqe_buffers_unregister(ctx);
+	io_sqe_files_unregister(ctx);
 	io_cqring_overflow_kill(ctx);
 	io_eventfd_unregister(ctx);
 	io_alloc_cache_free(&ctx->apoll_cache, kfree);
@@ -2743,11 +2738,6 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	if (ctx->submitter_task)
 		put_task_struct(ctx->submitter_task);
 
-	/* there are no registered resources left, nobody uses it */
-	if (ctx->rsrc_node)
-		io_rsrc_node_destroy(ctx, ctx->rsrc_node);
-
-	WARN_ON_ONCE(!list_empty(&ctx->rsrc_ref_list));
 	WARN_ON_ONCE(!list_empty(&ctx->ltimeout_list));
 
 	io_alloc_cache_free(&ctx->rsrc_node_cache, kfree);
@@ -3729,10 +3719,6 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	if (ret)
 		goto err;
 
-	ret = io_rsrc_init(ctx);
-	if (ret)
-		goto err;
-
 	p->features = IORING_FEAT_SINGLE_MMAP | IORING_FEAT_NODROP |
 			IORING_FEAT_SUBMIT_STABLE | IORING_FEAT_RW_CUR_POS |
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
diff --git a/io_uring/net.c b/io_uring/net.c
index 2040195e33ab..ce1156551d10 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -1342,15 +1342,15 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
 		struct io_ring_ctx *ctx = req->ctx;
-		struct io_mapped_ubuf *imu;
+		struct io_rsrc_node *node;
 		int idx;
 
 		ret = -EFAULT;
 		io_ring_submit_lock(ctx, issue_flags);
 		if (sr->buf_index < ctx->nr_user_bufs) {
 			idx = array_index_nospec(sr->buf_index, ctx->nr_user_bufs);
-			imu = READ_ONCE(ctx->user_bufs[idx]);
-			io_req_set_rsrc_node(sr->notif, ctx);
+			node = ctx->user_bufs[idx];
+			io_req_assign_rsrc_node(sr->notif, node);
 			ret = 0;
 		}
 		io_ring_submit_unlock(ctx, issue_flags);
@@ -1358,8 +1358,9 @@ static int io_send_zc_import(struct io_kiocb *req, unsigned int issue_flags)
 		if (unlikely(ret))
 			return ret;
 
-		ret = io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter, imu,
-					(u64)(uintptr_t)sr->buf, sr->len);
+		ret = io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter,
+					node->buf, (u64)(uintptr_t)sr->buf,
+					sr->len);
 		if (unlikely(ret))
 			return ret;
 		kmsg->msg.sg_from_iter = io_sg_from_iter;
diff --git a/io_uring/nop.c b/io_uring/nop.c
index 2c7a22ba4053..de91600a3bc6 100644
--- a/io_uring/nop.c
+++ b/io_uring/nop.c
@@ -61,15 +61,15 @@ int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 	}
 	if (nop->flags & IORING_NOP_FIXED_BUFFER) {
 		struct io_ring_ctx *ctx = req->ctx;
-		struct io_mapped_ubuf *imu;
+		struct io_rsrc_node *node;
 		int idx;
 
 		ret = -EFAULT;
 		io_ring_submit_lock(ctx, issue_flags);
 		if (nop->buffer < ctx->nr_user_bufs) {
 			idx = array_index_nospec(nop->buffer, ctx->nr_user_bufs);
-			imu = READ_ONCE(ctx->user_bufs[idx]);
-			io_req_set_rsrc_node(req, ctx);
+			node = READ_ONCE(ctx->user_bufs[idx]);
+			io_req_assign_rsrc_node(req, node);
 			ret = 0;
 		}
 		io_ring_submit_unlock(ctx, issue_flags);
diff --git a/io_uring/notif.c b/io_uring/notif.c
index 28859ae3ee6e..4f02e969cf08 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -117,7 +117,8 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	notif->file = NULL;
 	notif->task = current;
 	io_get_task_refs(1);
-	notif->rsrc_node = NULL;
+	notif->rsrc_nodes[IORING_RSRC_FILE] = NULL;
+	notif->rsrc_nodes[IORING_RSRC_BUFFER] = NULL;
 
 	nd = io_notif_to_data(notif);
 	nd->zc_report = false;
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index ca2ec8a018be..e32c4d1bef86 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -26,10 +26,8 @@ struct io_rsrc_update {
 	u32				offset;
 };
 
-static void io_rsrc_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc);
-static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
-				  struct io_mapped_ubuf **pimu,
-				  struct page **last_hpage);
+static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
+			struct iovec *iov, int index, struct page **last_hpage);
 
 /* only define max */
 #define IORING_MAX_FIXED_FILES	(1U << 20)
@@ -110,13 +108,13 @@ static int io_buffer_validate(struct iovec *iov)
 	return 0;
 }
 
-static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slot)
+static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
 {
-	struct io_mapped_ubuf *imu = *slot;
 	unsigned int i;
 
-	*slot = NULL;
-	if (imu != &dummy_ubuf) {
+	if (node->buf != &dummy_ubuf) {
+		struct io_mapped_ubuf *imu = node->buf;
+
 		if (!refcount_dec_and_test(&imu->refs))
 			return;
 		for (i = 0; i < imu->nr_bvecs; i++)
@@ -127,205 +125,56 @@ static void io_buffer_unmap(struct io_ring_ctx *ctx, struct io_mapped_ubuf **slo
 	}
 }
 
-static void io_rsrc_put_work(struct io_rsrc_node *node)
+struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx,
+					struct io_rsrc_data *data, int type)
 {
-	struct io_rsrc_put *prsrc = &node->item;
-
-	if (prsrc->tag)
-		io_post_aux_cqe(node->ctx, prsrc->tag, 0, 0);
-
-	switch (node->type) {
-	case IORING_RSRC_FILE:
-		fput(prsrc->file);
-		break;
-	case IORING_RSRC_BUFFER:
-		io_rsrc_buf_put(node->ctx, prsrc);
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		break;
-	}
-}
-
-void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
-{
-	if (!io_alloc_cache_put(&ctx->rsrc_node_cache, node))
-		kfree(node);
-}
-
-void io_rsrc_node_ref_zero(struct io_rsrc_node *node)
-	__must_hold(&node->ctx->uring_lock)
-{
-	struct io_ring_ctx *ctx = node->ctx;
+	struct io_rsrc_node *node;
 
-	while (!list_empty(&ctx->rsrc_ref_list)) {
-		node = list_first_entry(&ctx->rsrc_ref_list,
-					    struct io_rsrc_node, node);
-		/* recycle ref nodes in order */
-		if (node->refs)
-			break;
-		list_del(&node->node);
-
-		if (likely(!node->empty))
-			io_rsrc_put_work(node);
-		io_rsrc_node_destroy(ctx, node);
-	}
-	if (list_empty(&ctx->rsrc_ref_list) && unlikely(ctx->rsrc_quiesce))
-		wake_up_all(&ctx->rsrc_quiesce_wq);
-}
-
-struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx)
-{
-	struct io_rsrc_node *ref_node;
-
-	ref_node = io_alloc_cache_get(&ctx->rsrc_node_cache);
-	if (!ref_node) {
-		ref_node = kzalloc(sizeof(*ref_node), GFP_KERNEL);
-		if (!ref_node)
+	node = io_alloc_cache_get(&ctx->rsrc_node_cache);
+	if (!node) {
+		node = kzalloc(sizeof(*node), GFP_KERNEL);
+		if (!node)
 			return NULL;
 	}
 
-	ref_node->ctx = ctx;
-	ref_node->empty = 0;
-	ref_node->refs = 1;
-	return ref_node;
-}
-
-__cold static int io_rsrc_ref_quiesce(struct io_rsrc_data *data,
-				      struct io_ring_ctx *ctx)
-{
-	struct io_rsrc_node *backup;
-	DEFINE_WAIT(we);
-	int ret;
-
-	/* As We may drop ->uring_lock, other task may have started quiesce */
-	if (data->quiesce)
-		return -ENXIO;
-
-	backup = io_rsrc_node_alloc(ctx);
-	if (!backup)
-		return -ENOMEM;
-	ctx->rsrc_node->empty = true;
-	ctx->rsrc_node->type = -1;
-	list_add_tail(&ctx->rsrc_node->node, &ctx->rsrc_ref_list);
-	io_put_rsrc_node(ctx, ctx->rsrc_node);
-	ctx->rsrc_node = backup;
-
-	if (list_empty(&ctx->rsrc_ref_list))
-		return 0;
-
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-		atomic_set(&ctx->cq_wait_nr, 1);
-		smp_mb();
-	}
-
-	ctx->rsrc_quiesce++;
-	data->quiesce = true;
-	do {
-		prepare_to_wait(&ctx->rsrc_quiesce_wq, &we, TASK_INTERRUPTIBLE);
-		mutex_unlock(&ctx->uring_lock);
-
-		ret = io_run_task_work_sig(ctx);
-		if (ret < 0) {
-			finish_wait(&ctx->rsrc_quiesce_wq, &we);
-			mutex_lock(&ctx->uring_lock);
-			if (list_empty(&ctx->rsrc_ref_list))
-				ret = 0;
-			break;
-		}
-
-		schedule();
-		mutex_lock(&ctx->uring_lock);
-		ret = 0;
-	} while (!list_empty(&ctx->rsrc_ref_list));
-
-	finish_wait(&ctx->rsrc_quiesce_wq, &we);
-	data->quiesce = false;
-	ctx->rsrc_quiesce--;
-
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
-		atomic_set(&ctx->cq_wait_nr, 0);
-		smp_mb();
-	}
-	return ret;
-}
-
-static void io_free_page_table(void **table, size_t size)
-{
-	unsigned i, nr_tables = DIV_ROUND_UP(size, PAGE_SIZE);
-
-	for (i = 0; i < nr_tables; i++)
-		kfree(table[i]);
-	kfree(table);
+	node->ctx = ctx;
+	node->refs = 1;
+	node->type = type;
+	return node;
 }
 
 static void io_rsrc_data_free(struct io_rsrc_data *data)
 {
-	size_t size = data->nr * sizeof(data->tags[0][0]);
-
-	if (data->tags)
-		io_free_page_table((void **)data->tags, size);
-	kfree(data);
-}
-
-static __cold void **io_alloc_page_table(size_t size)
-{
-	unsigned i, nr_tables = DIV_ROUND_UP(size, PAGE_SIZE);
-	size_t init_size = size;
-	void **table;
-
-	table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL_ACCOUNT);
-	if (!table)
-		return NULL;
+	int i;
 
-	for (i = 0; i < nr_tables; i++) {
-		unsigned int this_size = min_t(size_t, size, PAGE_SIZE);
+	for (i = 0; i < data->nr; i++) {
+		struct io_rsrc_node *node = data->nodes[i];
 
-		table[i] = kzalloc(this_size, GFP_KERNEL_ACCOUNT);
-		if (!table[i]) {
-			io_free_page_table(table, init_size);
-			return NULL;
-		}
-		size -= this_size;
+		io_put_rsrc_node(node);
 	}
-	return table;
+	kvfree(data->nodes);
+	kfree(data);
 }
 
-__cold static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, int type,
-				     u64 __user *utags,
-				     unsigned nr, struct io_rsrc_data **pdata)
+__cold static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, unsigned nr,
+				     struct io_rsrc_data **pdata)
 {
 	struct io_rsrc_data *data;
-	int ret = 0;
-	unsigned i;
 
 	data = kzalloc(sizeof(*data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
-	data->tags = (u64 **)io_alloc_page_table(nr * sizeof(data->tags[0][0]));
-	if (!data->tags) {
+
+	data->nodes = kvmalloc_array(nr, sizeof(struct io_rsrc_node *),
+					GFP_KERNEL | __GFP_ZERO);
+	if (!data->nodes) {
 		kfree(data);
 		return -ENOMEM;
 	}
 
 	data->nr = nr;
-	data->ctx = ctx;
-	data->rsrc_type = type;
-	if (utags) {
-		ret = -EFAULT;
-		for (i = 0; i < nr; i++) {
-			u64 *tag_slot = io_get_tag_slot(data, i);
-
-			if (copy_from_user(tag_slot, &utags[i],
-					   sizeof(*tag_slot)))
-				goto fail;
-		}
-	}
 	*pdata = data;
 	return 0;
-fail:
-	io_rsrc_data_free(data);
-	return ret;
 }
 
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
@@ -334,8 +183,6 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 {
 	u64 __user *tags = u64_to_user_ptr(up->tags);
 	__s32 __user *fds = u64_to_user_ptr(up->data);
-	struct io_rsrc_data *data = ctx->file_data;
-	struct io_fixed_file *file_slot;
 	int fd, i, err = 0;
 	unsigned int done;
 
@@ -360,18 +207,14 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 			continue;
 
 		i = array_index_nospec(up->offset + done, ctx->nr_user_files);
-		file_slot = io_fixed_file_slot(&ctx->file_table, i);
-
-		if (file_slot->file_ptr) {
-			err = io_queue_rsrc_removal(data, i,
-						    io_slot_file(file_slot));
-			if (err)
-				break;
-			file_slot->file_ptr = 0;
+		if (ctx->file_table.nodes[i]) {
+			io_put_rsrc_node(ctx->file_table.nodes[i]);
+			ctx->file_table.nodes[i] = NULL;
 			io_file_bitmap_clear(&ctx->file_table, i);
 		}
 		if (fd != -1) {
 			struct file *file = fget(fd);
+			struct io_rsrc_node *node;
 
 			if (!file) {
 				err = -EBADF;
@@ -385,8 +228,15 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				err = -EBADF;
 				break;
 			}
-			*io_get_tag_slot(data, i) = tag;
-			io_fixed_file_set(file_slot, file);
+			node = io_rsrc_node_alloc(ctx, ctx->file_data, IORING_RSRC_FILE);
+			if (!node) {
+				err = -ENOMEM;
+				fput(file);
+				break;
+			}
+			ctx->file_table.nodes[i] = node;
+			node->tag = tag;
+			io_fixed_file_set(node, file);
 			io_file_bitmap_set(&ctx->file_table, i);
 		}
 	}
@@ -411,7 +261,7 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 		return -EINVAL;
 
 	for (done = 0; done < nr_args; done++) {
-		struct io_mapped_ubuf *imu;
+		struct io_rsrc_node *node;
 		u64 tag = 0;
 
 		uvec = u64_to_user_ptr(user_data);
@@ -431,23 +281,16 @@ static int __io_sqe_buffers_update(struct io_ring_ctx *ctx,
 			err = -EINVAL;
 			break;
 		}
-		err = io_sqe_buffer_register(ctx, iov, &imu, &last_hpage);
-		if (err)
-			break;
-
 		i = array_index_nospec(up->offset + done, ctx->nr_user_bufs);
-		if (ctx->user_bufs[i] != &dummy_ubuf) {
-			err = io_queue_rsrc_removal(ctx->buf_data, i,
-						    ctx->user_bufs[i]);
-			if (unlikely(err)) {
-				io_buffer_unmap(ctx, &imu);
-				break;
-			}
-			ctx->user_bufs[i] = (struct io_mapped_ubuf *)&dummy_ubuf;
+		node = io_sqe_buffer_register(ctx, iov, i, &last_hpage);
+		if (IS_ERR(node)) {
+			err = PTR_ERR(node);
+			break;
 		}
+		io_put_rsrc_node(ctx->user_bufs[i]);
 
-		ctx->user_bufs[i] = imu;
-		*io_get_tag_slot(ctx->buf_data, i) = tag;
+		ctx->user_bufs[i] = node;
+		node->tag = tag;
 		if (ctx->compat)
 			user_data += sizeof(struct compat_iovec);
 		else
@@ -622,38 +465,47 @@ int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx, void *rsrc)
+void io_free_rsrc_node(struct io_rsrc_node *node)
 {
-	struct io_ring_ctx *ctx = data->ctx;
-	struct io_rsrc_node *node = ctx->rsrc_node;
-	u64 *tag_slot = io_get_tag_slot(data, idx);
+	struct io_ring_ctx *ctx = node->ctx;
 
-	ctx->rsrc_node = io_rsrc_node_alloc(ctx);
-	if (unlikely(!ctx->rsrc_node)) {
-		ctx->rsrc_node = node;
-		return -ENOMEM;
+	lockdep_assert_held(&ctx->uring_lock);
+
+	if (node->tag)
+		io_post_aux_cqe(node->ctx, node->tag, 0, 0);
+
+	switch (node->type) {
+	case IORING_RSRC_FILE:
+		if (io_slot_file(node))
+			fput(io_slot_file(node));
+		break;
+	case IORING_RSRC_BUFFER:
+		if (node->buf)
+			io_buffer_unmap(node->ctx, node);
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
 	}
 
-	node->item.rsrc = rsrc;
-	node->type = data->rsrc_type;
-	node->item.tag = *tag_slot;
-	*tag_slot = 0;
-	list_add_tail(&node->node, &ctx->rsrc_ref_list);
-	io_put_rsrc_node(ctx, node);
-	return 0;
+	if (!io_alloc_cache_put(&ctx->rsrc_node_cache, node))
+		kfree(node);
 }
 
-void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
+static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
 	int i;
 
+	lockdep_assert_held(&ctx->uring_lock);
+
 	for (i = 0; i < ctx->nr_user_files; i++) {
-		struct file *file = io_file_from_index(&ctx->file_table, i);
+		struct io_rsrc_node *node = ctx->file_table.nodes[i];
 
-		if (!file)
-			continue;
-		io_file_bitmap_clear(&ctx->file_table, i);
-		fput(file);
+		if (node) {
+			io_put_rsrc_node(node);
+			io_file_bitmap_clear(&ctx->file_table, i);
+			ctx->file_table.nodes[i] = NULL;
+		}
 	}
 
 	io_free_file_tables(&ctx->file_table);
@@ -665,22 +517,11 @@ void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
 
 int io_sqe_files_unregister(struct io_ring_ctx *ctx)
 {
-	unsigned nr = ctx->nr_user_files;
-	int ret;
-
 	if (!ctx->file_data)
 		return -ENXIO;
 
-	/*
-	 * Quiesce may unlock ->uring_lock, and while it's not held
-	 * prevent new requests using the table.
-	 */
-	ctx->nr_user_files = 0;
-	ret = io_rsrc_ref_quiesce(ctx->file_data, ctx);
-	ctx->nr_user_files = nr;
-	if (!ret)
-		__io_sqe_files_unregister(ctx);
-	return ret;
+	__io_sqe_files_unregister(ctx);
+	return 0;
 }
 
 int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
@@ -699,8 +540,7 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EMFILE;
 	if (nr_args > rlimit(RLIMIT_NOFILE))
 		return -EMFILE;
-	ret = io_rsrc_data_alloc(ctx, IORING_RSRC_FILE, tags, nr_args,
-				 &ctx->file_data);
+	ret = io_rsrc_data_alloc(ctx, nr_args, &ctx->file_data);
 	if (ret)
 		return ret;
 
@@ -711,16 +551,18 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	}
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_files++) {
-		struct io_fixed_file *file_slot;
+		struct io_rsrc_node *node;
+		u64 tag = 0;
 
-		if (fds && copy_from_user(&fd, &fds[i], sizeof(fd))) {
-			ret = -EFAULT;
+		ret = -EFAULT;
+		if (tags && copy_from_user(&tag, &tags[i], sizeof(tag)))
+			goto fail;
+		if (fds && copy_from_user(&fd, &fds[i], sizeof(fd)))
 			goto fail;
-		}
 		/* allow sparse sets */
 		if (!fds || fd == -1) {
 			ret = -EINVAL;
-			if (unlikely(*io_get_tag_slot(ctx->file_data, i)))
+			if (tag)
 				goto fail;
 			continue;
 		}
@@ -737,8 +579,16 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			fput(file);
 			goto fail;
 		}
-		file_slot = io_fixed_file_slot(&ctx->file_table, i);
-		io_fixed_file_set(file_slot, file);
+		ret = -ENOMEM;
+		node = io_rsrc_node_alloc(ctx, ctx->file_data, IORING_RSRC_FILE);
+		if (!node) {
+			fput(file);
+			goto fail;
+		}
+		if (tag)
+			node->tag = tag;
+		ctx->file_table.nodes[i] = node;
+		io_fixed_file_set(node, file);
 		io_file_bitmap_set(&ctx->file_table, i);
 	}
 
@@ -750,43 +600,30 @@ int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 	return ret;
 }
 
-static void io_rsrc_buf_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
-{
-	io_buffer_unmap(ctx, &prsrc->buf);
-	prsrc->buf = NULL;
-}
-
-void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
+static void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
 	unsigned int i;
 
-	for (i = 0; i < ctx->nr_user_bufs; i++)
-		io_buffer_unmap(ctx, &ctx->user_bufs[i]);
-	kfree(ctx->user_bufs);
-	io_rsrc_data_free(ctx->buf_data);
+	lockdep_assert_held(&ctx->uring_lock);
+
+	for (i = 0; i < ctx->nr_user_bufs; i++) {
+		io_put_rsrc_node(ctx->user_bufs[i]);
+		ctx->user_bufs[i] = NULL;
+	}
+	kvfree(ctx->user_bufs);
 	ctx->user_bufs = NULL;
+	io_rsrc_data_free(ctx->buf_data);
 	ctx->buf_data = NULL;
 	ctx->nr_user_bufs = 0;
 }
 
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 {
-	unsigned nr = ctx->nr_user_bufs;
-	int ret;
-
 	if (!ctx->buf_data)
 		return -ENXIO;
 
-	/*
-	 * Quiesce may unlock ->uring_lock, and while it's not held
-	 * prevent new requests using the table.
-	 */
-	ctx->nr_user_bufs = 0;
-	ret = io_rsrc_ref_quiesce(ctx->buf_data, ctx);
-	ctx->nr_user_bufs = nr;
-	if (!ret)
-		__io_sqe_buffers_unregister(ctx);
-	return ret;
+	__io_sqe_buffers_unregister(ctx);
+	return 0;
 }
 
 /*
@@ -813,7 +650,8 @@ static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
 
 	/* check previously registered pages */
 	for (i = 0; i < ctx->nr_user_bufs; i++) {
-		struct io_mapped_ubuf *imu = ctx->user_bufs[i];
+		struct io_rsrc_node *node = ctx->user_bufs[i];
+		struct io_mapped_ubuf *imu = node->buf;
 
 		for (j = 0; j < imu->nr_bvecs; j++) {
 			if (!PageCompound(imu->bvec[j].bv_page))
@@ -950,21 +788,28 @@ static bool io_try_coalesce_buffer(struct page ***pages, int *nr_pages,
 	return io_do_coalesce_buffer(pages, nr_pages, data, nr_folios);
 }
 
-static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
-				  struct io_mapped_ubuf **pimu,
-				  struct page **last_hpage)
+static struct io_rsrc_node *io_sqe_buffer_register(struct io_ring_ctx *ctx,
+						   struct iovec *iov,
+						   int index,
+						   struct page **last_hpage)
 {
 	struct io_mapped_ubuf *imu = NULL;
 	struct page **pages = NULL;
+	struct io_rsrc_node *node;
 	unsigned long off;
 	size_t size;
 	int ret, nr_pages, i;
 	struct io_imu_folio_data data;
 	bool coalesced;
 
-	*pimu = (struct io_mapped_ubuf *)&dummy_ubuf;
-	if (!iov->iov_base)
-		return 0;
+	node = io_rsrc_node_alloc(ctx, ctx->buf_data, IORING_RSRC_BUFFER);
+	if (!node)
+		return ERR_PTR(-ENOMEM);
+
+	if (!iov->iov_base) {
+		node->buf = (struct io_mapped_ubuf *) &dummy_ubuf;
+		return node;
+	}
 
 	ret = -ENOMEM;
 	pages = io_pin_pages((unsigned long) iov->iov_base, iov->iov_len,
@@ -998,7 +843,7 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		imu->folio_shift = data.folio_shift;
 	refcount_set(&imu->refs, 1);
 	off = (unsigned long) iov->iov_base & ((1UL << imu->folio_shift) - 1);
-	*pimu = imu;
+	node->buf = imu;
 	ret = 0;
 
 	for (i = 0; i < nr_pages; i++) {
@@ -1010,10 +855,14 @@ static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
 		size -= vec_len;
 	}
 done:
-	if (ret)
+	if (ret) {
 		kvfree(imu);
+		if (node)
+			io_put_rsrc_node(node);
+		node = ERR_PTR(ret);
+	}
 	kvfree(pages);
-	return ret;
+	return node;
 }
 
 static int io_buffers_map_alloc(struct io_ring_ctx *ctx, unsigned int nr_args)
@@ -1037,7 +886,7 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		return -EBUSY;
 	if (!nr_args || nr_args > IORING_MAX_REG_BUFFERS)
 		return -EINVAL;
-	ret = io_rsrc_data_alloc(ctx, IORING_RSRC_BUFFER, tags, nr_args, &data);
+	ret = io_rsrc_data_alloc(ctx, nr_args, &data);
 	if (ret)
 		return ret;
 	ret = io_buffers_map_alloc(ctx, nr_args);
@@ -1050,6 +899,9 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 		memset(iov, 0, sizeof(*iov));
 
 	for (i = 0; i < nr_args; i++, ctx->nr_user_bufs++) {
+		struct io_rsrc_node *node;
+		u64 tag = 0;
+
 		if (arg) {
 			uvec = (struct iovec __user *) arg;
 			iov = iovec_from_user(uvec, 1, 1, &fast_iov, ctx->compat);
@@ -1066,15 +918,24 @@ int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 				arg += sizeof(struct iovec);
 		}
 
-		if (!iov->iov_base && *io_get_tag_slot(data, i)) {
-			ret = -EINVAL;
-			break;
+		if (tags) {
+			if (copy_from_user(&tag, &tags[i], sizeof(tag))) {
+				ret = -EFAULT;
+				break;
+			}
+			if (tag && !iov->iov_base) {
+				ret = -EINVAL;
+				break;
+			}
 		}
 
-		ret = io_sqe_buffer_register(ctx, iov, &ctx->user_bufs[i],
-					     &last_hpage);
-		if (ret)
+		node = io_sqe_buffer_register(ctx, iov, i, &last_hpage);
+		if (IS_ERR(node)) {
+			ret = PTR_ERR(node);
 			break;
+		}
+		node->tag = tag;
+		ctx->user_bufs[i] = node;
 	}
 
 	WARN_ON_ONCE(ctx->buf_data);
@@ -1148,7 +1009,7 @@ int io_import_fixed(int ddir, struct iov_iter *iter,
 
 static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx)
 {
-	struct io_mapped_ubuf **user_bufs;
+	struct io_rsrc_node **user_bufs;
 	struct io_rsrc_data *data;
 	int i, ret, nbufs;
 
@@ -1163,21 +1024,31 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 	nbufs = src_ctx->nr_user_bufs;
 	if (!nbufs)
 		goto out_unlock;
-	ret = io_rsrc_data_alloc(ctx, IORING_RSRC_BUFFER, NULL, nbufs, &data);
+	ret = io_rsrc_data_alloc(ctx, nbufs, &data);
 	if (ret)
 		goto out_unlock;
 
 	ret = -ENOMEM;
-	user_bufs = kcalloc(nbufs, sizeof(*ctx->user_bufs), GFP_KERNEL);
+	user_bufs = kvmalloc_array(nbufs, sizeof(struct io_rsrc_node *),
+					GFP_KERNEL | __GFP_ZERO);
 	if (!user_bufs)
 		goto out_free_data;
 
 	for (i = 0; i < nbufs; i++) {
-		struct io_mapped_ubuf *src = src_ctx->user_bufs[i];
+		struct io_mapped_ubuf *imu = src_ctx->user_bufs[i]->buf;
+		struct io_rsrc_node *dst_node;
 
-		if (src != &dummy_ubuf)
-			refcount_inc(&src->refs);
-		user_bufs[i] = src;
+		dst_node = io_rsrc_node_alloc(ctx, data, IORING_RSRC_BUFFER);
+		if (!dst_node)
+			goto out_put_free;
+
+		if (imu == &dummy_ubuf) {
+			dst_node->buf = (struct io_mapped_ubuf *) &dummy_ubuf;
+		} else {
+			refcount_inc(&imu->refs);
+			dst_node->buf = imu;
+		}
+		user_bufs[i] = dst_node;
 	}
 
 	/* Have a ref on the bufs now, drop src lock and re-grab our own lock */
@@ -1190,12 +1061,17 @@ static int io_clone_buffers(struct io_ring_ctx *ctx, struct io_ring_ctx *src_ctx
 		return 0;
 	}
 
+	mutex_unlock(&ctx->uring_lock);
+	mutex_lock(&src_ctx->uring_lock);
 	/* someone raced setting up buffers, dump ours */
-	for (i = 0; i < nbufs; i++)
-		io_buffer_unmap(ctx, &user_bufs[i]);
-	io_rsrc_data_free(data);
-	kfree(user_bufs);
-	return -EBUSY;
+	ret = -EBUSY;
+	i = nbufs;
+out_put_free:
+	while (i--) {
+		io_buffer_unmap(src_ctx, user_bufs[i]);
+		kfree(user_bufs[i]);
+	}
+	kvfree(user_bufs);
 out_free_data:
 	io_rsrc_data_free(data);
 out_unlock:
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index 1589c9740083..9797dcc2a7b5 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -13,36 +13,21 @@ enum {
 	IORING_RSRC_BUFFER		= 1,
 };
 
-struct io_rsrc_put {
-	u64 tag;
-	union {
-		void *rsrc;
-		struct file *file;
-		struct io_mapped_ubuf *buf;
-	};
-};
-
 struct io_rsrc_data {
-	struct io_ring_ctx		*ctx;
-
-	u64				**tags;
 	unsigned int			nr;
-	u16				rsrc_type;
-	bool				quiesce;
+	struct io_rsrc_node		**nodes;
 };
 
 struct io_rsrc_node {
 	struct io_ring_ctx		*ctx;
 	int				refs;
-	bool				empty;
 	u16				type;
-	struct list_head		node;
-	struct io_rsrc_put		item;
-};
 
-struct io_fixed_file {
-	/* file * with additional FFS_* flags */
-	unsigned long file_ptr;
+	u64 tag;
+	union {
+		unsigned long file_ptr;
+		struct io_mapped_ubuf *buf;
+	};
 };
 
 struct io_mapped_ubuf {
@@ -63,21 +48,18 @@ struct io_imu_folio_data {
 	unsigned int	folio_shift;
 };
 
-void io_rsrc_node_ref_zero(struct io_rsrc_node *node);
-void io_rsrc_node_destroy(struct io_ring_ctx *ctx, struct io_rsrc_node *ref_node);
-struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx);
-int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx, void *rsrc);
+struct io_rsrc_node *io_rsrc_node_alloc(struct io_ring_ctx *ctx,
+					struct io_rsrc_data *data, int type);
+void io_free_rsrc_node(struct io_rsrc_node *node);
 
 int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
 			   u64 buf_addr, size_t len);
 
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
-void __io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
 			    unsigned int nr_args, u64 __user *tags);
-void __io_sqe_files_unregister(struct io_ring_ctx *ctx);
 int io_sqe_files_unregister(struct io_ring_ctx *ctx);
 int io_sqe_files_register(struct io_ring_ctx *ctx, void __user *arg,
 			  unsigned nr_args, u64 __user *tags);
@@ -89,41 +71,23 @@ int io_register_rsrc_update(struct io_ring_ctx *ctx, void __user *arg,
 int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 			unsigned int size, unsigned int type);
 
-static inline void io_put_rsrc_node(struct io_ring_ctx *ctx, struct io_rsrc_node *node)
+static inline void io_put_rsrc_node(struct io_rsrc_node *node)
 {
-	lockdep_assert_held(&ctx->uring_lock);
-
 	if (node && !--node->refs)
-		io_rsrc_node_ref_zero(node);
-}
-
-static inline void __io_req_set_rsrc_node(struct io_kiocb *req,
-					  struct io_ring_ctx *ctx)
-{
-	lockdep_assert_held(&ctx->uring_lock);
-	req->rsrc_node = ctx->rsrc_node;
-	ctx->rsrc_node->refs++;
+		io_free_rsrc_node(node);
 }
 
-static inline void io_req_set_rsrc_node(struct io_kiocb *req,
-					struct io_ring_ctx *ctx)
+static inline void io_req_put_rsrc_nodes(struct io_kiocb *req)
 {
-	if (!req->rsrc_node)
-		__io_req_set_rsrc_node(req, ctx);
-}
-
-static inline u64 *io_get_tag_slot(struct io_rsrc_data *data, unsigned int idx)
-{
-	unsigned int off = idx & IO_RSRC_TAG_TABLE_MASK;
-	unsigned int table_idx = idx >> IO_RSRC_TAG_TABLE_SHIFT;
-
-	return &data->tags[table_idx][off];
+	io_put_rsrc_node(req->rsrc_nodes[IORING_RSRC_FILE]);
+	io_put_rsrc_node(req->rsrc_nodes[IORING_RSRC_BUFFER]);
 }
 
-static inline int io_rsrc_init(struct io_ring_ctx *ctx)
+static inline void io_req_assign_rsrc_node(struct io_kiocb *req,
+					   struct io_rsrc_node *node)
 {
-	ctx->rsrc_node = io_rsrc_node_alloc(ctx);
-	return ctx->rsrc_node ? 0 : -ENOMEM;
+	node->refs++;
+	req->rsrc_nodes[node->type] = node;
 }
 
 int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 8080ffd6d571..65491f4f2c7e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -330,7 +330,7 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_mapped_ubuf *imu;
+	struct io_rsrc_node *node;
 	struct io_async_rw *io;
 	u16 index;
 	int ret;
@@ -342,11 +342,11 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	if (unlikely(req->buf_index >= ctx->nr_user_bufs))
 		return -EFAULT;
 	index = array_index_nospec(req->buf_index, ctx->nr_user_bufs);
-	imu = ctx->user_bufs[index];
-	io_req_set_rsrc_node(req, ctx);
+	node = ctx->user_bufs[index];
+	io_req_assign_rsrc_node(req, node);
 
 	io = req->async_data;
-	ret = io_import_fixed(ddir, &io->iter, imu, rw->addr, rw->len);
+	ret = io_import_fixed(ddir, &io->iter, node->buf, rw->addr, rw->len);
 	iov_iter_save_state(&io->iter, &io->iter_state);
 	return ret;
 }
diff --git a/io_uring/splice.c b/io_uring/splice.c
index e62bc6497a94..a0b4e0435b8b 100644
--- a/io_uring/splice.c
+++ b/io_uring/splice.c
@@ -51,7 +51,7 @@ void io_splice_cleanup(struct io_kiocb *req)
 {
 	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
 
-	io_put_rsrc_node(req->ctx, sp->rsrc_node);
+	io_put_rsrc_node(sp->rsrc_node);
 }
 
 static struct file *io_splice_get_file(struct io_kiocb *req,
@@ -59,7 +59,7 @@ static struct file *io_splice_get_file(struct io_kiocb *req,
 {
 	struct io_splice *sp = io_kiocb_to_cmd(req, struct io_splice);
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_fixed_file *slot;
+	struct io_rsrc_node *node;
 	struct file *file = NULL;
 
 	if (!(sp->flags & SPLICE_F_FD_IN_FIXED))
@@ -69,11 +69,13 @@ static struct file *io_splice_get_file(struct io_kiocb *req,
 	if (unlikely(sp->splice_fd_in >= ctx->nr_user_files))
 		goto out;
 	sp->splice_fd_in = array_index_nospec(sp->splice_fd_in, ctx->nr_user_files);
-	slot = &ctx->file_table.files[sp->splice_fd_in];
-	if (!req->rsrc_node)
-		__io_req_set_rsrc_node(req, ctx);
-	file = io_slot_file(slot);
-	req->flags |= REQ_F_NEED_CLEANUP;
+	node = ctx->file_table.nodes[sp->splice_fd_in];
+	if (node) {
+		node->refs++;
+		sp->rsrc_node = node;
+		file = io_slot_file(node);
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
 out:
 	io_ring_submit_unlock(ctx, issue_flags);
 	return file;
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 6994f60d7ec7..0899c71008ae 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -220,7 +220,7 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		 * being called. This prevents destruction of the mapped buffer
 		 * we'll need at actual import time.
 		 */
-		io_req_set_rsrc_node(req, ctx);
+		io_req_assign_rsrc_node(req, ctx->user_bufs[req->buf_index]);
 	}
 	ioucmd->cmd_op = READ_ONCE(sqe->cmd_op);
 
@@ -276,15 +276,11 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter, void *ioucmd)
 {
 	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
-	struct io_ring_ctx *ctx = req->ctx;
+	struct io_rsrc_node *node = req->rsrc_nodes[IORING_RSRC_BUFFER];
 
 	/* Must have had rsrc_node assigned at prep time */
-	if (req->rsrc_node) {
-		struct io_mapped_ubuf *imu;
-
-		imu = READ_ONCE(ctx->user_bufs[req->buf_index]);
-		return io_import_fixed(rw, iter, imu, ubuf, len);
-	}
+	if (node)
+		return io_import_fixed(rw, iter, node->buf, ubuf, len);
 
 	return -EFAULT;
 }
-- 
2.45.2


