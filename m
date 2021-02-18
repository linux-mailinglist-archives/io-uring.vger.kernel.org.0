Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8A631EBA5
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 16:41:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbhBRPkc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 10:40:32 -0500
Received: from hmm.wantstofly.org ([213.239.204.108]:57170 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232837AbhBRM3C (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 07:29:02 -0500
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id 258987F4BE; Thu, 18 Feb 2021 14:27:55 +0200 (EET)
Date:   Thu, 18 Feb 2021 14:27:55 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     David Laight <David.Laight@aculab.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v3 2/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <20210218122755.GC334506@wantstofly.org>
References: <20210218122640.GA334506@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210218122640.GA334506@wantstofly.org>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IORING_OP_GETDENTS behaves much like getdents64(2) and takes the same
arguments, but with a small twist: it takes an additional offset
argument, and reading from the specified directory starts at the given
offset.

For the first IORING_OP_GETDENTS call on a directory, the offset
parameter can be set to zero, and for subsequent calls, it can be
set to the ->d_off field of the last struct linux_dirent64 returned
by the previous IORING_OP_GETDENTS call.

Internally, if necessary, IORING_OP_GETDENTS will vfs_llseek() to
the right directory position before calling vfs_getdents().

IORING_OP_GETDENTS may or may not update the specified directory's
file offset, and the file offset should not be relied upon having
any particular value during or after an IORING_OP_GETDENTS call.

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
---
 fs/io_uring.c                 | 73 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 74 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 056bd4c90ade..6853bf48369a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -635,6 +635,13 @@ struct io_mkdir {
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
@@ -772,6 +779,7 @@ struct io_kiocb {
 		struct io_rename	rename;
 		struct io_unlink	unlink;
 		struct io_mkdir		mkdir;
+		struct io_getdents	getdents;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1030,6 +1038,11 @@ static const struct io_op_def io_op_defs[] = {
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
 						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
 	},
+	[IORING_OP_GETDENTS] = {
+		.needs_file		= 1,
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
+						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
+	},
 };
 
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
@@ -4677,6 +4690,61 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
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
+	bool pos_unlock = false;
+	int ret = 0;
+
+	/* getdents always requires a blocking context */
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	/* for vfs_llseek and to serialize ->iterate_shared() on this file */
+	if (file_count(req->file) > 1) {
+		pos_unlock = true;
+		mutex_lock(&req->file->f_pos_lock);
+	}
+
+	if (req->file->f_pos != getdents->pos) {
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
+	if (pos_unlock)
+		mutex_unlock(&req->file->f_pos_lock);
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
@@ -6184,6 +6252,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_unlinkat_prep(req, sqe);
 	case IORING_OP_MKDIRAT:
 		return io_mkdirat_prep(req, sqe);
+	case IORING_OP_GETDENTS:
+		return io_getdents_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6428,6 +6498,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
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
index 890edd850a9e..fe097b1fa332 100644
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
2.29.2
