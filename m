Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCDB21FF9B
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 23:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgGNVId (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jul 2020 17:08:33 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:37303 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726750AbgGNVId (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jul 2020 17:08:33 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id E582A60002;
        Tue, 14 Jul 2020 21:08:28 +0000 (UTC)
Date:   Tue, 14 Jul 2020 14:08:26 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [WIP PATCH] io_uring: Support opening a file into the fixed-file
 table
Message-ID: <5e04f8fc6b0a2e218ace517bc9acf0d44530c430.1594759879.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a new operation IORING_OP_OPENAT2_FIXED_FILE, which opens a file
into the fixed-file table rather than installing a file descriptor.
Using a new operation avoids having an IOSQE flag that almost all
operations will need to ignore; io_openat2_fixed_file also has
substantially different control-flow than io_openat2, and it can avoid
requiring the file table if not needed for the dirfd.

(This intentionally does not use the IOSQE_FIXED_FILE flag, because
semantically, IOSQE_FIXED_FILE for openat2 should mean to interpret the
dirfd as a fixed-file-table index, and that would be useful future
behavior for both IORING_OP_OPENAT2 and IORING_OP_OPENAT2_FIXED_FILE.)

Create a new io_sqe_files_add_new function to add a single new file to
the fixed-file table. This function returns -EBUSY if attempting to
overwrite an existing file.

Provide a new field to pass along the fixed-file-table index for an
open-like operation; future operations such as
IORING_OP_ACCEPT_FIXED_FILE can use the same index.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

(Should this check for and reject open flags like O_CLOEXEC that only
affect the file descriptor?)

I've tested this (and I'll send my liburing patch momentarily), and it
works fine if you do the open in one batch and operate on the fixed-file
in another batch. As discussed via Twitter, opening and operating on a
file in the same batch will require changing other operations to obtain
their fixed-file entries later, post-prep.

It might make sense to do and test that for one operation at a time, and
add a .late_fixed_file flag to the operation definition for operations
that support that.

It might also make sense to have the prep for
IORING_OP_OPENAT2_FIXED_FILE stick an indication in the fixed-file table
that there *will* be a file there later, perhaps an
ERR_PTR(-EINPROGRESS), and make sure there isn't one already, to detect
potential errors earlier and to let the prep for other operations
confirm that there *will* be a file; on the other hand, that would mean
there's an invalid non-NULL file pointer in the fixed file table, which
seems potentially error-prone if any operation ever forgets that.

The other next step would be to add an IORING_OP_CLOSE_FIXED_FILE
(separate from the existing CLOSE op) that removes an entry currently in
the fixed file table and calls fput on it. (With some care, that
*should* be possible even for an entry that was originally registered
from a file descriptor.)

And finally, we should have an IORING_OP_FIXED_FILE_TO_FD operation,
which calls get_unused_fd_flags (with specified flags to allow for
O_CLOEXEC) and then fd_install. That allows opening a file via io_uring,
operating on it via the ring, but then also operating on it via other
syscalls (or inheriting it or anything else you can do with a file
descriptor).

 fs/io_uring.c                 | 90 ++++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |  6 ++-
 2 files changed, 94 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9fd7e69696c3..df6f017ef8e8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -425,6 +425,7 @@ struct io_sr_msg {
 struct io_open {
 	struct file			*file;
 	int				dfd;
+	u32				open_fixed_idx;
 	struct filename			*filename;
 	struct open_how			how;
 	unsigned long			nofile;
@@ -878,6 +879,10 @@ static const struct io_op_def io_op_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
+	[IORING_OP_OPENAT2_FIXED_FILE] = {
+		.file_table		= 1,
+		.needs_fs		= 1,
+	},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -886,6 +891,9 @@ static void io_put_req(struct io_kiocb *req);
 static void __io_double_put_req(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
+static int io_sqe_files_add_new(struct io_ring_ctx *ctx,
+				u32 index,
+				struct file *file);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *ip,
 				 unsigned nr_args);
@@ -3060,10 +3068,48 @@ static int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 					len);
 	if (ret)
 		return ret;
+	req->open.open_fixed_idx = READ_ONCE(sqe->open_fixed_idx);
 
 	return __io_openat_prep(req, sqe);
 }
 
+static int io_openat2_fixed_file(struct io_kiocb *req, bool force_nonblock)
+{
+	struct io_open *open = &req->open;
+	struct open_flags op;
+	struct file *file;
+	int ret;
+
+	if (force_nonblock) {
+		/* only need file table for an actual valid fd */
+		if (open->dfd == -1 || open->dfd == AT_FDCWD)
+			req->flags |= REQ_F_NO_FILE_TABLE;
+		return -EAGAIN;
+	}
+
+	ret = build_open_flags(&open->how, &op);
+	if (ret)
+		goto err;
+
+	file = do_filp_open(open->dfd, open->filename, &op);
+	if (IS_ERR(file)) {
+		ret = PTR_ERR(file);
+	} else {
+		fsnotify_open(file);
+		ret = io_sqe_files_add_new(req->ctx, open->open_fixed_idx, file);
+		if (ret)
+			fput(file);
+	}
+err:
+	putname(open->filename);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_cqring_add_event(req, ret);
+	io_put_req(req);
+	return 0;
+}
+
 static int io_openat2(struct io_kiocb *req, bool force_nonblock)
 {
 	struct open_flags op;
@@ -5048,6 +5094,7 @@ static int io_req_defer_prep(struct io_kiocb *req,
 		ret = io_madvise_prep(req, sqe);
 		break;
 	case IORING_OP_OPENAT2:
+	case IORING_OP_OPENAT2_FIXED_FILE:
 		ret = io_openat2_prep(req, sqe);
 		break;
 	case IORING_OP_EPOLL_CTL:
@@ -5135,6 +5182,7 @@ static void io_cleanup_req(struct io_kiocb *req)
 		break;
 	case IORING_OP_OPENAT:
 	case IORING_OP_OPENAT2:
+	case IORING_OP_OPENAT2_FIXED_FILE:
 		break;
 	case IORING_OP_SPLICE:
 	case IORING_OP_TEE:
@@ -5329,12 +5377,17 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		ret = io_madvise(req, force_nonblock);
 		break;
 	case IORING_OP_OPENAT2:
+	case IORING_OP_OPENAT2_FIXED_FILE:
 		if (sqe) {
 			ret = io_openat2_prep(req, sqe);
 			if (ret)
 				break;
 		}
-		ret = io_openat2(req, force_nonblock);
+		if (req->opcode == IORING_OP_OPENAT2) {
+			ret = io_openat2(req, force_nonblock);
+		} else {
+			ret = io_openat2_fixed_file(req, force_nonblock);
+		}
 		break;
 	case IORING_OP_EPOLL_CTL:
 		if (sqe) {
@@ -6791,6 +6844,41 @@ static int io_queue_file_removal(struct fixed_file_data *data,
 	return 0;
 }
 
+/*
+ * Add a single new file in an empty entry of the fixed file table. Does not
+ * allow overwriting an existing entry; returns -EBUSY in that case.
+ */
+static int io_sqe_files_add_new(struct io_ring_ctx *ctx,
+				u32 index,
+				struct file *file)
+{
+	struct fixed_file_table *table;
+	u32 i;
+	int err;
+
+	if (unlikely(index > ctx->nr_user_files))
+		return -EINVAL;
+	i = array_index_nospec(index, ctx->nr_user_files);
+	table = &ctx->file_data->table[i >> IORING_FILE_TABLE_SHIFT];
+	index = i & IORING_FILE_TABLE_MASK;
+	if (unlikely(table->files[index]))
+		return -EBUSY;
+	/*
+	 * Don't allow io_uring instances to be registered. If UNIX isn't
+	 * enabled, then this causes a reference cycle and this instance can
+	 * never get freed. If UNIX is enabled we'll handle it just fine, but
+	 * there's still no point in allowing a ring fd as it doesn't support
+	 * regular read/write anyway.
+	 */
+	if (unlikely(file->f_op == &io_uring_fops))
+		return -EBADF;
+	err = io_sqe_file_register(ctx, file, i);
+	if (err)
+		return err;
+	table->files[index] = file;
+	return 0;
+}
+
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *up,
 				 unsigned nr_args)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7843742b8b74..95f107e6f65e 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -54,7 +54,10 @@ struct io_uring_sqe {
 			} __attribute__((packed));
 			/* personality to use, if used */
 			__u16	personality;
-			__s32	splice_fd_in;
+			union {
+				__s32	splice_fd_in;
+				__s32	open_fixed_idx;
+			};
 		};
 		__u64	__pad2[3];
 	};
@@ -130,6 +133,7 @@ enum {
 	IORING_OP_PROVIDE_BUFFERS,
 	IORING_OP_REMOVE_BUFFERS,
 	IORING_OP_TEE,
+	IORING_OP_OPENAT2_FIXED_FILE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.28.0.rc0

