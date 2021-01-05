Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0FC72EB5E3
	for <lists+io-uring@lfdr.de>; Wed,  6 Jan 2021 00:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725952AbhAEXJE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jan 2021 18:09:04 -0500
Received: from out1.migadu.com ([91.121.223.63]:19772 "EHLO out1.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726264AbhAEXJD (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Tue, 5 Jan 2021 18:09:03 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dagur.eu; s=default;
        t=1609887615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KDuEz3+AwReulugoYcHYwrUfKGfLQsxnQo+gc+BHLRU=;
        b=l4zZUi9V1WDdsOxeBAkRXUOI8pQotxcLVP6oMicas6UgrKwFBOKIApdaoHM63pobZTlgsD
        r/XO8KWGA7w27vHQBULWPXmpd8OSxXtOt3NNRllwxuZmjYAU5qAhcXPv8Ag7zJSiBbtlga
        gKzYjJqD2MgVCXU1zWt4jnwONfDVF/I=
From:   arni@dagur.eu
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, =?UTF-8?q?=C3=81rni=20Dagur?= <arni@dagur.eu>
Subject: [PATCH 2/2] io_uring: Add vmsplice support
Message-Id: <20210105225932.1249603-3-arni@dagur.eu>
In-Reply-To: <20210105225932.1249603-1-arni@dagur.eu>
References: <20210105225932.1249603-1-arni@dagur.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: arni@dagur.eu
Date:   Tue, 05 Jan 2021 23:00:15 GMT
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Árni Dagur <arni@dagur.eu>

* The `sqe->splice_flags` field is used to hold flags.
* We return -EAGAIN if force_nonblock is set.

Signed-off-by: Árni Dagur <arni@dagur.eu>
---
 fs/io_uring.c                 | 76 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 77 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..a99a89798386 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -531,6 +531,13 @@ struct io_splice {
 	unsigned int			flags;
 };
 
+struct io_vmsplice {
+	struct file			*file;
+	u64				addr;
+	u64				len;
+	unsigned int			flags;
+};
+
 struct io_provide_buf {
 	struct file			*file;
 	__u64				addr;
@@ -692,6 +699,7 @@ struct io_kiocb {
 		struct io_madvise	madvise;
 		struct io_epoll		epoll;
 		struct io_splice	splice;
+		struct io_vmsplice	vmsplice;
 		struct io_provide_buf	pbuf;
 		struct io_statx		statx;
 		struct io_shutdown	shutdown;
@@ -967,6 +975,12 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
+	[IORING_OP_VMSPLICE] = {
+		.needs_file = 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.work_flags		= IO_WQ_WORK_MM,
+	},
 	[IORING_OP_PROVIDE_BUFFERS] = {},
 	[IORING_OP_REMOVE_BUFFERS] = {},
 	[IORING_OP_TEE] = {
@@ -3884,6 +3898,63 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
 	return 0;
 }
 
+static int io_vmsplice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_vmsplice *sp = &req->vmsplice;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (unlikely(READ_ONCE(sqe->off)))
+		return -EINVAL;
+
+	sp->addr = READ_ONCE(sqe->addr);
+	sp->len = READ_ONCE(sqe->len);
+	sp->flags = READ_ONCE(sqe->splice_flags);
+
+	if (sp->flags & ~SPLICE_F_ALL)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int io_vmsplice(struct io_kiocb *req, bool force_nonblock)
+{
+	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct io_vmsplice *sp = &req->vmsplice;
+	void __user *buf = u64_to_user_ptr(sp->addr);
+	struct iov_iter __iter, *iter = &__iter;
+	struct file *file = sp->file;
+	ssize_t io_size;
+	int type, ret;
+
+	if (force_nonblock)
+		return -EAGAIN;
+
+	if (file->f_mode & FMODE_WRITE)
+		type = WRITE;
+	else if (file->f_mode & FMODE_READ)
+		type = READ;
+	else {
+		ret = -EBADF;
+		goto err;
+	}
+
+	ret = __import_iovec(type, buf, sp->len, UIO_FASTIOV, &iovec, iter,
+				req->ctx->compat);
+	if (ret < 0)
+		goto err;
+	io_size = iov_iter_count(iter);
+
+	ret = do_vmsplice(file, iter, sp->flags);
+	if (ret != io_size) {
+err:
+		req_set_fail_links(req);
+	}
+	io_req_complete(req, ret);
+	kfree(iovec);
+	return 0;
+}
+
 /*
  * IORING_OP_NOP just posts a completion event, nothing else.
  */
@@ -6009,6 +6080,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_epoll_ctl_prep(req, sqe);
 	case IORING_OP_SPLICE:
 		return io_splice_prep(req, sqe);
+	case IORING_OP_VMSPLICE:
+		return io_vmsplice_prep(req, sqe);
 	case IORING_OP_PROVIDE_BUFFERS:
 		return io_provide_buffers_prep(req, sqe);
 	case IORING_OP_REMOVE_BUFFERS:
@@ -6262,6 +6335,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_SPLICE:
 		ret = io_splice(req, force_nonblock);
 		break;
+	case IORING_OP_VMSPLICE:
+		ret = io_vmsplice(req, force_nonblock);
+		break;
 	case IORING_OP_PROVIDE_BUFFERS:
 		ret = io_provide_buffers(req, force_nonblock, cs);
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d31a2a1e8ef9..6bc79f9bb123 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -137,6 +137,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_VMSPLICE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.0

