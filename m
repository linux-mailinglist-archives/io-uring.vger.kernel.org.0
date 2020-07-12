Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8701121CACD
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 19:43:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729311AbgGLRnB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 13:43:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbgGLRnB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 13:43:01 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C290C061794
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 10:43:01 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id by13so9219761edb.11
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 10:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nn2HPwUKUrcUvKKC8sDMpPktopLMaXE/xGBlwQi8sdI=;
        b=r1WoPOPHQLuaoANZ1iBPLsMy6ObeRrVd/WDa+K30vq5qrVyrIXWaKH8mcuJ6G6lKMn
         8A3ghy0fo6RFI5Qd4G0hBIy4iEfSQEHM1efnzPj+S3b6G4fymXBDTUSDKypm5ENcq5ed
         4uvnrUdY/rRoMPCZ8UQNaK4fCIAhw+rG/EeRpjoIrY1wRw6ZpmT1OsiB0MfKAWwKZxPI
         ao87l5VJuR3INhEQqu2mComJRulPdqaHOw+4gh4jz7CECcr7RozWB90SJokumi4O6OOZ
         ZJc/DTAWpawkCLaESGq1JfkfCfvURHmDPITKqBQ8PycDVFZqZG1tE4xUBtZmlZ6CBXkO
         fOJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nn2HPwUKUrcUvKKC8sDMpPktopLMaXE/xGBlwQi8sdI=;
        b=cpxazc4O+LcPTa4akTiOD8fsur0YF4wGpamfrWKVixbCQffe8AhsaAe+fVQ7Bh12GA
         yEZv5jzkJuGp7G3WlX2pJKEMrJXQ3fEx5V8wYoROa5Bli+V/lVMKjhgsnU9rA9FnHjjI
         SMEw/5dAAGnvJ/RAoACV4TsXFYDbljzTu7NJExi01mco+muJCrawrPu2sxk5bOSYrOXm
         LFXZuhSchHfM5F25x3S/dhcwMITDlxiChVM3rBWBge9iiPybj2c7E21k0YgkYg7PEjXR
         lSoAM7Er4NR1LkiTAv7ZUCWbMlsti9IT+bd9RAnodHxCYFMkkKQ+YMioG0WXP78+8rhx
         31zg==
X-Gm-Message-State: AOAM532N/9FgzO0C5tFBJDJNu5O/wZ0mGWi14TyLwFZlYJYEmHY+/0on
        Yf83vOsRQOMIkk+puMSqrZGBSvuD
X-Google-Smtp-Source: ABdhPJxfsxUa+MOgHwkv4KhAbf47kNOsJxvgQnrTuoTXxdHf0LPiUc4bNYHCVpfqMipNwZzOsnEivQ==
X-Received: by 2002:a50:f01d:: with SMTP id r29mr87955881edl.158.1594575779869;
        Sun, 12 Jul 2020 10:42:59 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id q7sm7957349eja.69.2020.07.12.10.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 10:42:59 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: use more specific type in rcv/snd msg cp
Date:   Sun, 12 Jul 2020 20:41:05 +0300
Message-Id: <14658362164348e66026196832b67932dea8e20e.1594571075.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594571075.git.asml.silence@gmail.com>
References: <cover.1594571075.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

send/recv msghdr initialisation works with struct io_async_msghdr, but
pulls the whole struct io_async_ctx for no reason. That complicates it
with composite accessing, e.g. io->msg.

Use and pass the most specific type, which is struct io_async_msghdr.
It is the larget field in union io_async_ctx and doesn't save stack
space, but looks clearer.
The most of the changes are replacing "io->msg." with "iomsg->"

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 63 +++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2cfcf111f58f..b496aebd6285 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3931,7 +3931,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
-		struct io_async_ctx io;
+		struct io_async_msghdr iomsg;
 		unsigned flags;
 
 		if (req->io) {
@@ -3944,14 +3944,13 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 		} else {
 			struct io_sr_msg *sr = &req->sr_msg;
 
-			kmsg = &io.msg;
-			kmsg->msg.msg_name = &io.msg.addr;
-
-			io.msg.iov = io.msg.fast_iov;
-			ret = sendmsg_copy_msghdr(&io.msg.msg, sr->umsg,
-					sr->msg_flags, &io.msg.iov);
+			iomsg.msg.msg_name = &iomsg.addr;
+			iomsg.iov = iomsg.fast_iov;
+			ret = sendmsg_copy_msghdr(&iomsg.msg, sr->umsg,
+					sr->msg_flags, &iomsg.iov);
 			if (ret)
 				return ret;
+			kmsg = &iomsg;
 		}
 
 		flags = req->sr_msg.msg_flags;
@@ -4019,30 +4018,31 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	return 0;
 }
 
-static int __io_recvmsg_copy_hdr(struct io_kiocb *req, struct io_async_ctx *io)
+static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
+				 struct io_async_msghdr *iomsg)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct iovec __user *uiov;
 	size_t iov_len;
 	int ret;
 
-	ret = __copy_msghdr_from_user(&io->msg.msg, sr->umsg,
-					&io->msg.uaddr, &uiov, &iov_len);
+	ret = __copy_msghdr_from_user(&iomsg->msg, sr->umsg,
+					&iomsg->uaddr, &uiov, &iov_len);
 	if (ret)
 		return ret;
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		if (iov_len > 1)
 			return -EINVAL;
-		if (copy_from_user(io->msg.iov, uiov, sizeof(*uiov)))
+		if (copy_from_user(iomsg->iov, uiov, sizeof(*uiov)))
 			return -EFAULT;
-		sr->len = io->msg.iov[0].iov_len;
-		iov_iter_init(&io->msg.msg.msg_iter, READ, io->msg.iov, 1,
+		sr->len = iomsg->iov[0].iov_len;
+		iov_iter_init(&iomsg->msg.msg_iter, READ, iomsg->iov, 1,
 				sr->len);
-		io->msg.iov = NULL;
+		iomsg->iov = NULL;
 	} else {
 		ret = import_iovec(READ, uiov, iov_len, UIO_FASTIOV,
-					&io->msg.iov, &io->msg.msg.msg_iter);
+					&iomsg->iov, &iomsg->msg.msg_iter);
 		if (ret > 0)
 			ret = 0;
 	}
@@ -4052,7 +4052,7 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req, struct io_async_ctx *io)
 
 #ifdef CONFIG_COMPAT
 static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
-					struct io_async_ctx *io)
+					struct io_async_msghdr *iomsg)
 {
 	struct compat_msghdr __user *msg_compat;
 	struct io_sr_msg *sr = &req->sr_msg;
@@ -4062,7 +4062,7 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 	int ret;
 
 	msg_compat = (struct compat_msghdr __user *) sr->umsg;
-	ret = __get_compat_msghdr(&io->msg.msg, msg_compat, &io->msg.uaddr,
+	ret = __get_compat_msghdr(&iomsg->msg, msg_compat, &iomsg->uaddr,
 					&ptr, &len);
 	if (ret)
 		return ret;
@@ -4079,12 +4079,12 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 			return -EFAULT;
 		if (clen < 0)
 			return -EINVAL;
-		sr->len = io->msg.iov[0].iov_len;
-		io->msg.iov = NULL;
+		sr->len = iomsg->iov[0].iov_len;
+		iomsg->iov = NULL;
 	} else {
 		ret = compat_import_iovec(READ, uiov, len, UIO_FASTIOV,
-						&io->msg.iov,
-						&io->msg.msg.msg_iter);
+						&iomsg->iov,
+						&iomsg->msg.msg_iter);
 		if (ret < 0)
 			return ret;
 	}
@@ -4093,17 +4093,18 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 }
 #endif
 
-static int io_recvmsg_copy_hdr(struct io_kiocb *req, struct io_async_ctx *io)
+static int io_recvmsg_copy_hdr(struct io_kiocb *req,
+			       struct io_async_msghdr *iomsg)
 {
-	io->msg.msg.msg_name = &io->msg.addr;
-	io->msg.iov = io->msg.fast_iov;
+	iomsg->msg.msg_name = &iomsg->addr;
+	iomsg->iov = iomsg->fast_iov;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
-		return __io_compat_recvmsg_copy_hdr(req, io);
+		return __io_compat_recvmsg_copy_hdr(req, iomsg);
 #endif
 
-	return __io_recvmsg_copy_hdr(req, io);
+	return __io_recvmsg_copy_hdr(req, iomsg);
 }
 
 static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
@@ -4153,7 +4154,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
 
-	ret = io_recvmsg_copy_hdr(req, io);
+	ret = io_recvmsg_copy_hdr(req, &io->msg);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
@@ -4169,7 +4170,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct io_buffer *kbuf;
-		struct io_async_ctx io;
+		struct io_async_msghdr iomsg;
 		unsigned flags;
 
 		if (req->io) {
@@ -4180,12 +4181,10 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 				kmsg->iov = kmsg->fast_iov;
 			kmsg->msg.msg_iter.iov = kmsg->iov;
 		} else {
-			kmsg = &io.msg;
-			kmsg->msg.msg_name = &io.msg.addr;
-
-			ret = io_recvmsg_copy_hdr(req, &io);
+			ret = io_recvmsg_copy_hdr(req, &iomsg);
 			if (ret)
 				return ret;
+			kmsg = &iomsg;
 		}
 
 		kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
-- 
2.24.0

