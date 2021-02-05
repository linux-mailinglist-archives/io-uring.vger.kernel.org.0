Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DFD310207
	for <lists+io-uring@lfdr.de>; Fri,  5 Feb 2021 02:03:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232542AbhBEBDE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Feb 2021 20:03:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbhBEBCh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Feb 2021 20:02:37 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0662C06178B
        for <io-uring@vger.kernel.org>; Thu,  4 Feb 2021 17:01:56 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id b3so5746448wrj.5
        for <io-uring@vger.kernel.org>; Thu, 04 Feb 2021 17:01:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nWcudyxv8U5GRdnkcYuoMSglXMJdmtLweUXevTHSpoc=;
        b=ADyorhdbqomzB4Di0eer0yo217CuVsnuabWLtnkZlkRADlh5zBLvByGoY4A0zvteMb
         OhIS3diuvXpaDSoQ+r2+FRKU6f5ogaKePx5OSZ97bWLXIGg7pwItUAQBoGCwJOD51URA
         kXvXN90h2AzVKMPLjybbPqrJp3tFuzMMiCpbZlectAAwmkil+RO4bn+Z9M/5WZ00DDoj
         z1hmJ9eBXfQv/qJGWvFS79bru7KKoyVoOkO/tlZTpxUvBtQGV2rtAFRIF/450ExZFEiJ
         oXf4Cads5qeeQivUARzcn2B+ejtdZZNK/WdF4Z4MX4PN/n18GAwgfUkT4H/36i/GjBLq
         Wq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nWcudyxv8U5GRdnkcYuoMSglXMJdmtLweUXevTHSpoc=;
        b=kCO21kXRYGMwRdAJL0x7xTzAqHwidaCDECgSAmjrAzaM9e9fsFNpzz4vhD37qM4PeX
         MDUK4pOxk/ePrwAqZfvVWJFUGDr4+gbhE3NELuhfhbiDenxV4gKbRKCIJoWE5X5giBJy
         GnQSqRXqgviBe2C/EVL3KC78OYIGZlLqrqR+x8fRYzaAD+tvATGqHpozdx5aIRGL3grn
         ST0oHUZ6+er4amf2Hhw67YCkZnlR8PteO4KGPQP605SIB1zo6QGKJy2ot0u/fAV1mviw
         4hYZ/sJ6apftv1qqyv9mV9tHgFLbSHQifxkcB1ojBj/AFG5C4QjPHkKViBQQeXHbLrlR
         hSIw==
X-Gm-Message-State: AOAM532ctPjfLLdU6dTEqI8RyHUFgOXrkgoxYgHsCovBI1kOzZg7PV/Y
        w24ddi8FslqXk7Sm6IcnuJ8=
X-Google-Smtp-Source: ABdhPJz9h5i6drKneoFPD168fBHcmvzLUYpcqPaveAeUyoJOaVgWlaIpRbGIi8sGgEPJsLZPNwaxxg==
X-Received: by 2002:a05:6000:108b:: with SMTP id y11mr1979975wrw.379.1612486915540;
        Thu, 04 Feb 2021 17:01:55 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.145])
        by smtp.gmail.com with ESMTPSA id i18sm10853199wrn.29.2021.02.04.17.01.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 17:01:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/3] io_uring: refactor sendmsg/recvmsg iov managing
Date:   Fri,  5 Feb 2021 00:58:00 +0000
Message-Id: <ac7dc756e811000751c9cc8fba5d03cc73da314a.1612486458.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612486458.git.asml.silence@gmail.com>
References: <cover.1612486458.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Current iov handling with recvmsg/sendmsg may be confusing. First make a
rule for msg->iov: either it points to an allocated iov that have to be
kfree()'d later, or it's NULL and we use fast_iov. That's much better
than current 3-state (also can point to fast_iov). And rename it into
free_iov for uniformity with read/write.

Also, instead of after struct io_async_msghdr copy fixing up of
msg.msg_iter.iov has been happening in io_recvmsg()/io_sendmsg(). Move
it into io_setup_async_msg(), that's the right place.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 55 +++++++++++++++++++++++----------------------------
 1 file changed, 25 insertions(+), 30 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e07a7fa15cfa..7008e0c7e05d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -594,7 +594,8 @@ struct io_async_connect {
 
 struct io_async_msghdr {
 	struct iovec			fast_iov[UIO_FASTIOV];
-	struct iovec			*iov;
+	/* points to an allocated iov, if NULL we use fast_iov instead */
+	struct iovec			*free_iov;
 	struct sockaddr __user		*uaddr;
 	struct msghdr			msg;
 	struct sockaddr_storage		addr;
@@ -4551,24 +4552,27 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	if (async_msg)
 		return -EAGAIN;
 	if (io_alloc_async_data(req)) {
-		if (kmsg->iov != kmsg->fast_iov)
-			kfree(kmsg->iov);
+		kfree(kmsg->free_iov);
 		return -ENOMEM;
 	}
 	async_msg = req->async_data;
 	req->flags |= REQ_F_NEED_CLEANUP;
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
 	async_msg->msg.msg_name = &async_msg->addr;
+	/* if were using fast_iov, set it to the new one */
+	if (!async_msg->free_iov)
+		async_msg->msg.msg_iter.iov = async_msg->fast_iov;
+
 	return -EAGAIN;
 }
 
 static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 			       struct io_async_msghdr *iomsg)
 {
-	iomsg->iov = iomsg->fast_iov;
 	iomsg->msg.msg_name = &iomsg->addr;
+	iomsg->free_iov = iomsg->fast_iov;
 	return sendmsg_copy_msghdr(&iomsg->msg, req->sr_msg.umsg,
-				   req->sr_msg.msg_flags, &iomsg->iov);
+				   req->sr_msg.msg_flags, &iomsg->free_iov);
 }
 
 static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -4609,13 +4613,8 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	if (req->async_data) {
-		kmsg = req->async_data;
-		/* if iov is set, it's allocated already */
-		if (!kmsg->iov)
-			kmsg->iov = kmsg->fast_iov;
-		kmsg->msg.msg_iter.iov = kmsg->iov;
-	} else {
+	kmsg = req->async_data;
+	if (!kmsg) {
 		ret = io_sendmsg_copy_hdr(req, &iomsg);
 		if (ret)
 			return ret;
@@ -4634,8 +4633,8 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
-	if (kmsg->iov != kmsg->fast_iov)
-		kfree(kmsg->iov);
+	if (kmsg->free_iov)
+		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -4704,10 +4703,11 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
 		if (copy_from_user(iomsg->fast_iov, uiov, sizeof(*uiov)))
 			return -EFAULT;
 		sr->len = iomsg->fast_iov[0].iov_len;
-		iomsg->iov = NULL;
+		iomsg->free_iov = NULL;
 	} else {
+		iomsg->free_iov = iomsg->fast_iov;
 		ret = __import_iovec(READ, uiov, iov_len, UIO_FASTIOV,
-				     &iomsg->iov, &iomsg->msg.msg_iter,
+				     &iomsg->free_iov, &iomsg->msg.msg_iter,
 				     false);
 		if (ret > 0)
 			ret = 0;
@@ -4746,10 +4746,11 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 		if (clen < 0)
 			return -EINVAL;
 		sr->len = clen;
-		iomsg->iov = NULL;
+		iomsg->free_iov = NULL;
 	} else {
+		iomsg->free_iov = iomsg->fast_iov;
 		ret = __import_iovec(READ, (struct iovec __user *)uiov, len,
-				   UIO_FASTIOV, &iomsg->iov,
+				   UIO_FASTIOV, &iomsg->free_iov,
 				   &iomsg->msg.msg_iter, true);
 		if (ret < 0)
 			return ret;
@@ -4763,7 +4764,6 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 			       struct io_async_msghdr *iomsg)
 {
 	iomsg->msg.msg_name = &iomsg->addr;
-	iomsg->iov = iomsg->fast_iov;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -4834,13 +4834,8 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	if (req->async_data) {
-		kmsg = req->async_data;
-		/* if iov is set, it's allocated already */
-		if (!kmsg->iov)
-			kmsg->iov = kmsg->fast_iov;
-		kmsg->msg.msg_iter.iov = kmsg->iov;
-	} else {
+	kmsg = req->async_data;
+	if (!kmsg) {
 		ret = io_recvmsg_copy_hdr(req, &iomsg);
 		if (ret)
 			return ret;
@@ -4872,8 +4867,8 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
-	if (kmsg->iov != kmsg->fast_iov)
-		kfree(kmsg->iov);
+	if (kmsg->free_iov)
+		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -6166,8 +6161,8 @@ static void __io_clean_op(struct io_kiocb *req)
 		case IORING_OP_RECVMSG:
 		case IORING_OP_SENDMSG: {
 			struct io_async_msghdr *io = req->async_data;
-			if (io->iov != io->fast_iov)
-				kfree(io->iov);
+
+			kfree(io->free_iov);
 			break;
 			}
 		case IORING_OP_SPLICE:
-- 
2.24.0

