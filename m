Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 699AA1740F7
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 21:31:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726400AbgB1UbF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 15:31:05 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:46359 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726287AbgB1UbF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 15:31:05 -0500
Received: by mail-il1-f195.google.com with SMTP id t17so3852811ilm.13
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 12:31:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BP56q9onFy0f8OClpNzleqTUtQEUXNMGbU2lrqE+ArI=;
        b=gsHfgaj2QPOBs4PXnUGaqp6sN5y06qDgiQY7lmliljJqGGYGCsuvS7yd6PnUKKZHrs
         HvjnrxHUDpJ4G7+XceGI/2ydDSLoYjFp9uRj8tIOxHKnh4dZGJBCQ+3/9o8aPReXI2zK
         JVtAivxbvsue7Sj7lvwbFi4EEF4Wq+HxbiPut74azF6wlDzXq1HsxQsV3GDLMtXIEFfT
         SgfNANC2xOh6VTvEXNyd7d7dBZqIbBlgLOzzY1IRdB2cWIqdfY/eVL2yKvYCLjFRADwH
         C013pu7XBIW3n0zFQB5JqAB/6lglfxJOmNkkxAWwYQBZv8AHt94YhW0uoa/rlALST2S9
         j5nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BP56q9onFy0f8OClpNzleqTUtQEUXNMGbU2lrqE+ArI=;
        b=E5W6tRRPAOuRKCE5Z5UBiha5Kp7bPfUMJUHg/+c7rweNMn5U1Z5C9RXLGI4rALONrF
         VDOsMOa3r6U7SKSAAHd8eybALwaqlnpCMdop00FJr1TMvwKM6nOHWfI7QwlC35erLQsT
         58LhfTJb1/re8Zs+xpYteRI2J5lFZl+XdRYiYtGLoapZoNDcitaLx8ct1owNXwbAHpIR
         Dt86Em/S5lnkxcKK3O9lSAtKpS3Ao7xLPDxhLNrt4D+qN067Z64AJF8MlVuPetkea/PC
         gu+J9wtnJQbfZIfnUxK4n5XZ2+7VtEuXmD+fOLsAIinRkzvYbzKSqZb71fZ8HQZLfr7L
         zfSw==
X-Gm-Message-State: APjAAAVjWDhkNlDOmOsOdOCL8McnDJ9fcwIoOu+f43BMO2CIfS8jo44b
        342iXzirkT2aNnvCAuwHG4NfnXquh0Y=
X-Google-Smtp-Source: APXvYqyme8wVC4dzWmSgsc6H1b0UZIrl6+aO96h8ULykDsTVf0eJCZ/S3jZx4g/O0MbyErXe7KisQA==
X-Received: by 2002:a92:b749:: with SMTP id c9mr5864813ilm.143.1582921862448;
        Fri, 28 Feb 2020 12:31:02 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t15sm3397611ili.50.2020.02.28.12.31.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 12:31:01 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/6] io_uring: add IOSQE_BUFFER_SELECT support for IORING_OP_RECVMSG
Date:   Fri, 28 Feb 2020 13:30:53 -0700
Message-Id: <20200228203053.25023-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200228203053.25023-1-axboe@kernel.dk>
References: <20200228203053.25023-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Like IORING_OP_READV, this is limited to supporting just a single
segment in the iovec passed in.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 115 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 103 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 561120460422..fadffe21d4da 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -44,6 +44,7 @@
 #include <linux/errno.h>
 #include <linux/syscalls.h>
 #include <linux/compat.h>
+#include <net/compat.h>
 #include <linux/refcount.h>
 #include <linux/uio.h>
 #include <linux/bits.h>
@@ -729,6 +730,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.needs_fs		= 1,
 		.pollin			= 1,
+		.buffer_select		= 1,
 	},
 	[IORING_OP_TIMEOUT] = {
 		.async_ctx		= 1,
@@ -3582,6 +3584,90 @@ static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
 #endif
 }
 
+static int __io_recvmsg_copy_hdr(struct io_kiocb *req, struct io_async_ctx *io)
+{
+	struct io_sr_msg *sr = &req->sr_msg;
+	struct iovec __user *uiov;
+	size_t iov_len;
+	int ret;
+
+	ret = __copy_msghdr_from_user(&io->msg.msg, sr->msg, &io->msg.uaddr,
+					&uiov, &iov_len);
+	if (ret)
+		return ret;
+
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		if (iov_len > 1)
+			return -EINVAL;
+		if (copy_from_user(io->msg.iov, uiov, sizeof(*uiov)))
+			return -EFAULT;
+		sr->len = io->msg.iov[0].iov_len;
+		iov_iter_init(&io->msg.msg.msg_iter, READ, io->msg.iov, 1,
+				sr->len);
+		io->msg.iov = NULL;
+	} else {
+		ret = import_iovec(READ, uiov, iov_len, UIO_FASTIOV,
+					&io->msg.iov, &io->msg.msg.msg_iter);
+		if (ret > 0)
+			ret = 0;
+	}
+
+	return ret;
+}
+
+#ifdef CONFIG_COMPAT
+static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
+					struct io_async_ctx *io)
+{
+	struct compat_msghdr __user *msg_compat;
+	struct io_sr_msg *sr = &req->sr_msg;
+	struct compat_iovec __user *uiov;
+	compat_uptr_t ptr;
+	compat_size_t len;
+	int ret;
+
+	msg_compat = (struct compat_msghdr __user *) sr->msg;
+	ret = __get_compat_msghdr(&io->msg.msg, msg_compat, &io->msg.uaddr,
+					&ptr, &len);
+
+	uiov = compat_ptr(ptr);
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		compat_ssize_t clen;
+
+		if (len > 1)
+			return -EINVAL;
+		if (!access_ok(uiov, sizeof(*uiov)))
+			return -EFAULT;
+		if (__get_user(clen, &uiov->iov_len))
+			return -EFAULT;
+		if (clen < 0)
+			return -EINVAL;
+		sr->len = io->msg.iov[0].iov_len;
+		io->msg.iov = NULL;
+	} else {
+		ret = compat_import_iovec(READ, uiov, len, UIO_FASTIOV,
+						&io->msg.iov,
+						&io->msg.msg.msg_iter);
+		if (ret > 0)
+			ret = 0;
+	}
+
+	return 0;
+}
+#endif
+
+static int io_recvmsg_copy_hdr(struct io_kiocb *req, struct io_async_ctx *io)
+{
+	io->msg.iov = io->msg.fast_iov;
+
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		return __io_compat_recvmsg_copy_hdr(req, io);
+#endif
+
+	return __io_recvmsg_copy_hdr(req, io);
+}
+
 static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
 					       int *cflags, bool needs_lock)
 {
@@ -3629,9 +3715,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
-	io->msg.iov = io->msg.fast_iov;
-	ret = recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
-					&io->msg.uaddr, &io->msg.iov);
+	ret = io_recvmsg_copy_hdr(req, io);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
@@ -3646,13 +3730,14 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 #if defined(CONFIG_NET)
 	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
-	int ret;
+	int ret, cflags = 0;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
+		struct io_buffer *kbuf;
 		struct io_async_ctx io;
 		unsigned flags;
 
@@ -3664,19 +3749,23 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 				kmsg->iov = kmsg->fast_iov;
 			kmsg->msg.msg_iter.iov = kmsg->iov;
 		} else {
-			struct io_sr_msg *sr = &req->sr_msg;
-
 			kmsg = &io.msg;
 			kmsg->msg.msg_name = &io.msg.addr;
 
-			io.msg.iov = io.msg.fast_iov;
-			ret = recvmsg_copy_msghdr(&io.msg.msg, sr->msg,
-					sr->msg_flags, &io.msg.uaddr,
-					&io.msg.iov);
+			ret = io_recvmsg_copy_hdr(req, &io);
 			if (ret)
 				return ret;
 		}
 
+		kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
+		if (IS_ERR(kbuf)) {
+			return PTR_ERR(kbuf);
+		} else if (kbuf) {
+			kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
+			iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->iov,
+					1, req->sr_msg.len);
+		}
+
 		flags = req->sr_msg.msg_flags;
 		if (flags & MSG_DONTWAIT)
 			req->flags |= REQ_F_NOWAIT;
@@ -3694,7 +3783,7 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	io_cqring_add_event(req, ret);
+	__io_cqring_add_event(req, ret, cflags);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
@@ -4806,8 +4895,10 @@ static void io_cleanup_req(struct io_kiocb *req)
 		if (io->rw.iov != io->rw.fast_iov)
 			kfree(io->rw.iov);
 		break;
-	case IORING_OP_SENDMSG:
 	case IORING_OP_RECVMSG:
+		if (req->flags & REQ_F_BUFFER_SELECTED)
+			kfree(req->sr_msg.kbuf);
+	case IORING_OP_SENDMSG:
 		if (io->msg.iov != io->msg.fast_iov)
 			kfree(io->msg.iov);
 		break;
-- 
2.25.1

