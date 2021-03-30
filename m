Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16AB334E642
	for <lists+io-uring@lfdr.de>; Tue, 30 Mar 2021 13:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231779AbhC3LTU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Mar 2021 07:19:20 -0400
Received: from hmm.wantstofly.org ([213.239.204.108]:40440 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231622AbhC3LTD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Mar 2021 07:19:03 -0400
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id D25797F4C0; Tue, 30 Mar 2021 14:19:02 +0300 (EEST)
Date:   Tue, 30 Mar 2021 14:19:02 +0300
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     io-uring@vger.kernel.org
Subject: [PATCH v5 2/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <YGMJJira3jChpc/n@wantstofly.org>
References: <YGMIwcxAIJPAWGLu@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YGMIwcxAIJPAWGLu@wantstofly.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_GETDENTS behaves much like getdents64(2) and takes the same
arguments, but with a small twist: it takes an additional offset
argument, and reading from the specified directory starts at the given
offset.

Internally, if necessary, IORING_OP_GETDENTS will vfs_llseek() to
the right directory position before calling vfs_getdents().

For the first IORING_OP_GETDENTS call on a directory, the offset
parameter can be set to zero, and for subsequent calls, it can be
set to the ->d_off field of the last struct linux_dirent64 returned
by the previous IORING_OP_GETDENTS call.

Alternatively, specifying an offset argument of -1 will read from
the directory's current file offset (IORING_FEAT_RW_CUR_POS).

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
---
 fs/io_uring.c                 | 66 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 67 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f4ff3da821a5..90637d5a34b9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -670,6 +670,13 @@ struct io_mkdir {
 	struct filename			*filename;
 };
 
+struct io_getdents {
+	struct file			*file;
+	struct linux_dirent64 __user	*dirent;
+	unsigned int			count;
+	loff_t				pos;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -811,6 +818,7 @@ struct io_kiocb {
 		struct io_rename	rename;
 		struct io_unlink	unlink;
 		struct io_mkdir		mkdir;
+		struct io_getdents	getdents;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1025,6 +1033,9 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
 	[IORING_OP_MKDIRAT] = {},
+	[IORING_OP_GETDENTS] = {
+		.needs_file		= 1,
+	},
 };
 
 static bool io_disarm_next(struct io_kiocb *req);
@@ -4314,6 +4325,56 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_getdents_prep(struct io_kiocb *req,
+			    const struct io_uring_sqe *sqe)
+{
+	struct io_getdents *getdents = &req->getdents;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->rw_flags || sqe->buf_index)
+		return -EINVAL;
+
+	getdents->pos = READ_ONCE(sqe->off);
+	getdents->dirent = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	getdents->count = READ_ONCE(sqe->len);
+	return 0;
+}
+
+static int io_getdents(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_getdents *getdents = &req->getdents;
+	int ret = 0;
+
+	/* getdents always requires a blocking context */
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	/* for vfs_llseek and to serialize ->iterate_shared() on this file */
+	mutex_lock(&req->file->f_pos_lock);
+
+	if (getdents->pos != -1 && getdents->pos != req->file->f_pos) {
+		loff_t res = vfs_llseek(req->file, getdents->pos, SEEK_SET);
+		if (res < 0)
+			ret = res;
+	}
+
+	if (ret == 0) {
+		ret = vfs_getdents(req->file, getdents->dirent,
+				   getdents->count);
+	}
+
+	mutex_unlock(&req->file->f_pos_lock);
+
+	if (ret < 0) {
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail_links(req);
+	}
+	io_req_complete(req, ret);
+	return 0;
+}
+
 #if defined(CONFIG_NET)
 static int io_setup_async_msg(struct io_kiocb *req,
 			      struct io_async_msghdr *kmsg)
@@ -5991,6 +6052,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_unlinkat_prep(req, sqe);
 	case IORING_OP_MKDIRAT:
 		return io_mkdirat_prep(req, sqe);
+	case IORING_OP_GETDENTS:
+		return io_getdents_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6253,6 +6316,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_MKDIRAT:
 		ret = io_mkdirat(req, issue_flags);
 		break;
+	case IORING_OP_GETDENTS:
+		ret = io_getdents(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index cf26a94ab880..0693a6e4d6bb 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -138,6 +138,7 @@ enum {
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
 	IORING_OP_MKDIRAT,
+	IORING_OP_GETDENTS,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.2
