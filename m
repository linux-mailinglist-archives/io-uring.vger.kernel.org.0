Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DF62E8EAA
	for <lists+io-uring@lfdr.de>; Sun,  3 Jan 2021 23:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726176AbhACWWq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 17:22:46 -0500
Received: from out0.migadu.com ([94.23.1.103]:6410 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbhACWWq (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Sun, 3 Jan 2021 17:22:46 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dagur.eu; s=default;
        t=1609712522;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=/FMd5Ojx/gGgtpfnhHeipUo993Z3Jd7w6dK+7RF6vLo=;
        b=n1uJCSDrFBVeLB6Yov9tdPrhDYjJderRuSQc0BmdS7GC15yoeBfwGE1qKCwJFV4hYdPW2b
        pLhZQdGGkJ3IowDDwKwipQ1ptCsDlqDvrCsEMzqQROUwSvOvbwdqRl/sy7JxVSl/KHxK0z
        jG3zi4ffwXar/t1v//ny5LuvQvAUTWA=
From:   arni@dagur.eu
To:     io-uring@vger.kernel.org
Cc:     =?UTF-8?q?=C3=81rni=20Dagur?= <arnidg@protonmail.ch>
Subject: Questions regarding implementation of vmsplice in io_uring
Message-Id: <20210103222117.905850-1-arni@dagur.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: arni@dagur.eu
Date:   Sun, 03 Jan 2021 22:22:01 GMT
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Árni Dagur <arnidg@protonmail.ch>

Hello,

For my first stab at kernel development, I wanted to try implementing
vmsplice for io_uring. I've attached the code I've written so far. I have two
questions to ask, sorry if this is not the right place.

1. Currently I use __import_iovec directly, instead of using
io_import_iovec. That's because I've created a new "kiocb" struct
called io_vmsplice, rather than using io_rw as io_import_iovec expects.
The reason I created a new struct is so that it can hold an unsigned int
for the flags argument -- which is not present in io_rw. Im guessing that I
should find a way to use io_import_iovec instead?

One way I can think of is giving the io_vmsplice struct the same initial
fields as io_rw, and letting io_import_iovec access the union as io_rw rather
than io_vmsplice. Coming from a Rust background however, this solution
sounds like a bug waiting to happen (if one of the structs is changed
but the other is not).

2. Whenever I run the test program at
https://gist.githubusercontent.com/ArniDagur/07d87aefae93868ca1bf10766194599d/raw/dc14a63649d530e5e29f0d1288f41ed54bc6b810/main.c
I get a BADF result value. The debugger tells me that this occurs
because `file->f_op != &pipefifo_fops` in get_pipe_info() in fs/pipe.c
(neither pointer is NULL).

I give the program the file descriptor "1". Shouldn't that always be a pipe?
Is there something obvious that I'm missing?

Thanks a lot!
-- Árni

---
 fs/io_uring.c                 | 66 +++++++++++++++++++++++++++++++++++
 fs/splice.c                   | 18 ++++++----
 include/linux/splice.h        |  2 +-
 include/uapi/linux/io_uring.h |  1 +
 4 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..55dbbd4704c6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -531,6 +531,14 @@ struct io_splice {
 	unsigned int			flags;
 };
 
+struct io_vmsplice {
+	struct file			*file;
+	u64				addr;
+	u64				len;
+	unsigned int	flags;
+};
+
+
 struct io_provide_buf {
 	struct file			*file;
 	__u64				addr;
@@ -692,6 +700,7 @@ struct io_kiocb {
 		struct io_madvise	madvise;
 		struct io_epoll		epoll;
 		struct io_splice	splice;
+		struct io_vmsplice	vmsplice;
 		struct io_provide_buf	pbuf;
 		struct io_statx		statx;
 		struct io_shutdown	shutdown;
@@ -967,6 +976,11 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.work_flags		= IO_WQ_WORK_BLKCG,
 	},
+	[IORING_OP_VMSPLICE] = {
+		.needs_file = 1,
+		.hash_reg_file		= 1,
+		.unbound_nonreg_file	= 1,

I couldn't find any information regarding what the work flags do, so
I've left them empty for now.

+	},
 	[IORING_OP_PROVIDE_BUFFERS] = {},
 	[IORING_OP_REMOVE_BUFFERS] = {},
 	[IORING_OP_TEE] = {
@@ -3884,6 +3898,53 @@ static int io_splice(struct io_kiocb *req, bool force_nonblock)
 	return 0;
 }
 
+
+static int io_vmsplice_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe) {
+	struct io_vmsplice* sp = &req->vmsplice;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
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
+static int io_vmsplice(struct io_kiocb *req, bool force_nonblock) {
+	struct io_vmsplice* sp = &req->vmsplice;
+	struct file *file = sp->file;
+	int type;
+	int ret;
+
+	void __user *buf = u64_to_user_ptr(sp->addr);
+	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
+	struct iov_iter __iter, *iter = &__iter;
+
+	if (file->f_mode & FMODE_WRITE) {
+		type = WRITE;
+	} else if (file->f_mode & FMODE_READ) {
+		type = READ;
+	} else {
+		return -EBADF;
+	}
+
+	ret = __import_iovec(type, buf, sp->len, UIO_FASTIOV, &iovec, iter, req->ctx->compat);
+	if (ret < 0)
+		return ret;
+
+	ret = do_vmsplice(file, iter, sp->flags);
+	kfree(iovec);
+	return ret;
+}
+
 /*
  * IORING_OP_NOP just posts a completion event, nothing else.
  */
@@ -6009,6 +6070,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_epoll_ctl_prep(req, sqe);
 	case IORING_OP_SPLICE:
 		return io_splice_prep(req, sqe);
+	case IORING_OP_VMSPLICE:
+		return io_vmsplice_prep(req, sqe);
 	case IORING_OP_PROVIDE_BUFFERS:
 		return io_provide_buffers_prep(req, sqe);
 	case IORING_OP_REMOVE_BUFFERS:
@@ -6262,6 +6325,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_SPLICE:
 		ret = io_splice(req, force_nonblock);
 		break;
+	case IORING_OP_VMSPLICE:
+		ret = io_vmsplice(req, force_nonblock);
+		break;
 	case IORING_OP_PROVIDE_BUFFERS:
 		ret = io_provide_buffers(req, force_nonblock, cs);
 		break;
diff --git a/fs/splice.c b/fs/splice.c
index 866d5c2367b2..e9f1f27460a1 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -1270,6 +1270,17 @@ static int vmsplice_type(struct fd f, int *type)
 	return 0;
 }
 
+long do_vmsplice(struct file *file, struct iov_iter *iter, unsigned int flags) {
+	long error;
+	if (!iov_iter_count(iter))
+		error = 0;
+	else if (iov_iter_rw(iter) == WRITE)
+		error = vmsplice_to_pipe(file, iter, flags);
+	else
+		error = vmsplice_to_user(file, iter, flags);
+	return error;
+}
+
 /*
  * Note that vmsplice only really supports true splicing _from_ user memory
  * to a pipe, not the other way around. Splicing from user memory is a simple
@@ -1309,12 +1320,7 @@ SYSCALL_DEFINE4(vmsplice, int, fd, const struct iovec __user *, uiov,
 	if (error < 0)
 		goto out_fdput;
 
-	if (!iov_iter_count(&iter))
-		error = 0;
-	else if (iov_iter_rw(&iter) == WRITE)
-		error = vmsplice_to_pipe(f.file, &iter, flags);
-	else
-		error = vmsplice_to_user(f.file, &iter, flags);
+	error = do_vmsplice(f.file, &iter, flags);
 
 	kfree(iov);
 out_fdput:
diff --git a/include/linux/splice.h b/include/linux/splice.h
index a55179fd60fc..44c0e612f652 100644
--- a/include/linux/splice.h
+++ b/include/linux/splice.h
@@ -81,9 +81,9 @@ extern ssize_t splice_direct_to_actor(struct file *, struct splice_desc *,
 extern long do_splice(struct file *in, loff_t *off_in,
 		      struct file *out, loff_t *off_out,
 		      size_t len, unsigned int flags);
-
 extern long do_tee(struct file *in, struct file *out, size_t len,
 		   unsigned int flags);
+extern long do_vmsplice(struct file *file, struct iov_iter *iter, unsigned int flags);
 
 /*
  * for dynamic pipe sizing
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

