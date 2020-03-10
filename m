Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05BB9180116
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 16:04:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgCJPEk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 11:04:40 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:36200 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727849AbgCJPEj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 11:04:39 -0400
Received: by mail-io1-f68.google.com with SMTP id d15so13093465iog.3
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2020 08:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CZBl5Sq1yzeQp+xVmzfdVkPj8H5uCYt+VQREhNAkBtM=;
        b=s1XXKPjcx81Rtsvl/AF2/+7y7jApmD0bzcO4eGCkqy+k1kd93G3n1tRjsVlXe155i/
         BIdRYGtzCsj9SDM/Xgw4NuwihW5P8XnnIkY4FKZIC+FFw2K86ut2qyi9nriGO8o+ezvx
         cWhw3XwY1z4Hm8DRi28Ra3QKE2l0ITKKxF2oREFcwS+7i2lEQ54zGTmPOoXAs6KxhUlH
         MjIw+OpDRc+d47/zO0sp7lOPSZl1yfpCN7pKb7NrH/1wbFSH7qTi/Jt3pB8O7VuDjkSd
         yAYfPMf82TCw303ni8/xFgMhkg6dR1aHaB44+cnGmNxcW0a9K76Tdqcm+3TAQC5GXBDP
         WSkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CZBl5Sq1yzeQp+xVmzfdVkPj8H5uCYt+VQREhNAkBtM=;
        b=H6RbAWFy3aLdCKaZL1i3VvRMQZMfF/4k6IA81ZmKkJV2Oac6HrlqB3dm28YhtZTHES
         3D5cKmhJeJ/14DbZ9pH87IJuuBz4Bi+Rlqm5oBWvM4PPXeIC6vamwKkD0dbi/+oFZ1W7
         QGfUdnRvll1sh6xu1GdXBqaBiDQhrOVAX1MNgkejAZ2csA4ODYXWZfEciIJgD/R/alXR
         vN8nJED0EmG4LKERuawmrwmNrrX9tPN4IbW0N2sl4ITtm/NzkD6tXgckgboQzSLUXnPQ
         3Ql3M1Rxn5V3WDJRUiaHouApfzkf5vlY5KWnkF0cI2zETeehqt8qj5z7xR5YtOLXYlwk
         mrSg==
X-Gm-Message-State: ANhLgQ0bQrCC3c8gNBuVaBFZ7mjLp0KnHnFV/pabsPlN65QHngdeTe4s
        CBUGq0q4BlULf3TuQrRCf3TEn3KS66YeGQ==
X-Google-Smtp-Source: ADFU+vsT6AqnCn+JhyKFEuqv+SJ8/vFJxr35PZ3sYjUOFOCcQ8AkjMAnaOQYhu7y+6EW63F7F/QWzA==
X-Received: by 2002:a6b:f118:: with SMTP id e24mr7278131iog.54.1583852678612;
        Tue, 10 Mar 2020 08:04:38 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e16sm4684750ioh.7.2020.03.10.08.04.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:04:37 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/9] io_uring: add IOSQE_BUFFER_SELECT support for IORING_OP_RECVMSG
Date:   Tue, 10 Mar 2020 09:04:23 -0600
Message-Id: <20200310150427.28489-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310150427.28489-1-axboe@kernel.dk>
References: <20200310150427.28489-1-axboe@kernel.dk>
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
 fs/io_uring.c | 118 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 106 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b02272d08870..ed898fb24612 100644
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
@@ -3577,6 +3579,92 @@ static int io_send(struct io_kiocb *req, bool force_nonblock)
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
+	if (ret)
+		return ret;
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
+		if (ret < 0)
+			return ret;
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
@@ -3622,9 +3710,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
-	io->msg.iov = io->msg.fast_iov;
-	ret = recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
-					&io->msg.uaddr, &io->msg.iov);
+	ret = io_recvmsg_copy_hdr(req, io);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
@@ -3638,13 +3724,14 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
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
 
@@ -3656,19 +3743,23 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
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
@@ -3686,7 +3777,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	io_cqring_add_event(req, ret);
+	__io_cqring_add_event(req, ret, cflags);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_put_req(req);
@@ -4797,8 +4888,11 @@ static void io_cleanup_req(struct io_kiocb *req)
 		if (io->rw.iov != io->rw.fast_iov)
 			kfree(io->rw.iov);
 		break;
-	case IORING_OP_SENDMSG:
 	case IORING_OP_RECVMSG:
+		if (req->flags & REQ_F_BUFFER_SELECTED)
+			kfree(req->sr_msg.kbuf);
+		/* fallthrough */
+	case IORING_OP_SENDMSG:
 		if (io->msg.iov != io->msg.fast_iov)
 			kfree(io->msg.iov);
 		break;
-- 
2.25.1

