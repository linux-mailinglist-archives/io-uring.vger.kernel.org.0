Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 905962C7C8B
	for <lists+io-uring@lfdr.de>; Mon, 30 Nov 2020 02:51:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgK3BvC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 29 Nov 2020 20:51:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726299AbgK3BvC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 29 Nov 2020 20:51:02 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2236C0613CF
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 17:50:21 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id 64so13529964wra.11
        for <io-uring@vger.kernel.org>; Sun, 29 Nov 2020 17:50:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ofcBDpJ0b0+vxzirZAXF2LRp3pt9TQnBwkk4e9Ty2II=;
        b=MrrG589euu+4d+NJ0HOG+A+FkIop3h/iHGO9sI73KiKILvYqLqeCWN3SWBu1OV3pU+
         yJFWSULTZKo4sYTuBBimsllNKAuqTXY0SeU7SVRY5HTh4NzW9n8wK0Nom6vjcrb7qqzQ
         F/cX/kzpAfh53YzYgRQ928JQr2dFVlzbTx0kaJ7mKSxg8MGDGQ+Qe6qLVgMC55sY9uov
         M2yP/pPiadYf2YzqlMmMWLwWXgDSmGm/mAnXiYHitJY9tvmkYAO4+Zl0AlaY2OPayDo7
         wLo42aaR+FmpqDMgcrZg8yXKWZqg1tzYFnQ+zrLJcjiq4BnyG1PfqVn01ChA3ueyAJUf
         i4bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ofcBDpJ0b0+vxzirZAXF2LRp3pt9TQnBwkk4e9Ty2II=;
        b=clWQjZub4A8At3mToDrdLeuvLhsOvKCIXL+ChnWWS8Tx6xgGRySnZoYaZeFDnzYQMt
         RBof/aneDM04ww2KJ8R6sqbafBsXa1FMSc7WaPEBnSUtMskqDEjaY/MDfFxuOZ1dxwez
         uP4v2bcZpeQdsN1RcKDG0Q42YNdzIGD45zBGg296uMfPHgkgGVO4Dq+miEIdvChssUAC
         xTMPbmxGX3Gliq/dMoY/SHuI9SzU2r/fV218AEwR2q/Ks7sPeYtOHXwvx48uURrR7fp0
         YFjYMvxJawB5Dd79JBSJVv5MgsEM63Qn5pemZjDpzc7ssAWMk8ph4j6rgdaebNMkdvM3
         a5hA==
X-Gm-Message-State: AOAM530GSx+Bf46JVi7s8/KXvk9/TYYwsxEkFHa6wbrzQZ2dP/I/lnL9
        NUgpe640mS36gt2QHDGWTOU=
X-Google-Smtp-Source: ABdhPJwGjzGkfusCud2bkFoc8lDRUQ6YxtjLfg44RsJ2n8CGcyPU0jZVnfRwzv/NAhweUzHl1xL+iQ==
X-Received: by 2002:adf:dc83:: with SMTP id r3mr24373142wrj.223.1606701020590;
        Sun, 29 Nov 2020 17:50:20 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id d2sm25198062wrn.43.2020.11.29.17.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 17:50:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5.11] io_uring: refactor send/recv msg and iov managing
Date:   Mon, 30 Nov 2020 01:47:00 +0000
Message-Id: <136e474beffa8c70e1fc67b10a0c76db3096c67d.1606700781.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After copying a send/recv msg header, fix up all the fields right away
instead of delaying it. Keeping it in one place makes it easier. Also
replace msg->iov with free_iov, that either keeps NULL or an iov to be
freed, and kmsg->msg.msg_iter holding the right iov. That's more aligned
with how rw handles it and easier to follow.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 68 +++++++++++++++++++++++----------------------------
 1 file changed, 31 insertions(+), 37 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bb46e8543c39..a86bd986456b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -578,7 +578,7 @@ struct io_async_connect {
 
 struct io_async_msghdr {
 	struct iovec			fast_iov[UIO_FASTIOV];
-	struct iovec			*iov;
+	struct iovec			*free_iov;
 	struct sockaddr __user		*uaddr;
 	struct msghdr			msg;
 	struct sockaddr_storage		addr;
@@ -4506,23 +4506,26 @@ static int io_setup_async_msg(struct io_kiocb *req,
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
+	async_msg->msg.msg_name = &async_msg->addr;
+	/* if free_iov is not set, it uses fast_iov */
+	if (!async_msg->free_iov)
+		async_msg->msg.msg_iter.iov = async_msg->fast_iov;
 	return -EAGAIN;
 }
 
 static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 			       struct io_async_msghdr *iomsg)
 {
-	iomsg->iov = iomsg->fast_iov;
+	iomsg->free_iov = iomsg->fast_iov;
 	iomsg->msg.msg_name = &iomsg->addr;
 	return sendmsg_copy_msghdr(&iomsg->msg, req->sr_msg.umsg,
-				   req->sr_msg.msg_flags, &iomsg->iov);
+				   req->sr_msg.msg_flags, &iomsg->free_iov);
 }
 
 static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
@@ -4563,14 +4566,8 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	if (unlikely(!sock))
 		return ret;
 
-	if (req->async_data) {
-		kmsg = req->async_data;
-		kmsg->msg.msg_name = &kmsg->addr;
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
@@ -4589,8 +4586,9 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
-	if (kmsg->iov != kmsg->fast_iov)
-		kfree(kmsg->iov);
+	/* it's reportedly faster to check for null here */
+	if (kmsg->free_iov)
+		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -4656,15 +4654,16 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
 	if (req->flags & REQ_F_BUFFER_SELECT) {
 		if (iov_len > 1)
 			return -EINVAL;
-		if (copy_from_user(iomsg->iov, uiov, sizeof(*uiov)))
+		if (copy_from_user(iomsg->fast_iov, uiov, sizeof(*uiov)))
 			return -EFAULT;
-		sr->len = iomsg->iov[0].iov_len;
-		iov_iter_init(&iomsg->msg.msg_iter, READ, iomsg->iov, 1,
+		sr->len = iomsg->fast_iov[0].iov_len;
+		iov_iter_init(&iomsg->msg.msg_iter, READ, iomsg->fast_iov, 1,
 				sr->len);
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
@@ -4703,11 +4702,12 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 		if (clen < 0)
 			return -EINVAL;
 		sr->len = clen;
-		iomsg->iov[0].iov_len = clen;
-		iomsg->iov = NULL;
+		iomsg->fast_iov[0].iov_len = clen;
+		iomsg->free_iov = NULL;
 	} else {
+		iomsg->free_iov = iomsg->fast_iov;
 		ret = __import_iovec(READ, (struct iovec __user *)uiov, len,
-				   UIO_FASTIOV, &iomsg->iov,
+				   UIO_FASTIOV, &iomsg->free_iov,
 				   &iomsg->msg.msg_iter, true);
 		if (ret < 0)
 			return ret;
@@ -4721,7 +4721,6 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 			       struct io_async_msghdr *iomsg)
 {
 	iomsg->msg.msg_name = &iomsg->addr;
-	iomsg->iov = iomsg->fast_iov;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -4792,14 +4791,8 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	if (unlikely(!sock))
 		return ret;
 
-	if (req->async_data) {
-		kmsg = req->async_data;
-		kmsg->msg.msg_name = &kmsg->addr;
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
@@ -4811,7 +4804,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 		if (IS_ERR(kbuf))
 			return PTR_ERR(kbuf);
 		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
-		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->iov,
+		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov,
 				1, req->sr_msg.len);
 	}
 
@@ -4830,8 +4823,9 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
-	if (kmsg->iov != kmsg->fast_iov)
-		kfree(kmsg->iov);
+	/* it's reportedly faster to check for null here */
+	if (kmsg->free_iov)
+		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -6106,8 +6100,8 @@ static void __io_clean_op(struct io_kiocb *req)
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

