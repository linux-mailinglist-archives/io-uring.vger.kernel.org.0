Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 370FE2B33F4
	for <lists+io-uring@lfdr.de>; Sun, 15 Nov 2020 11:42:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgKOKkA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 05:40:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgKOKjE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 05:39:04 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B331AC0617A6
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:39:03 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id p1so15445071wrf.12
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gQEJTQg/xi+xGBTILRshTz44xvzWMVdWW40LcKklwis=;
        b=gFrk6hlUaydFbARxyOqB0sBX8rfyt8DCJkdAsMg82L5FhLubENAJe4xbEeu6t5dq/h
         hu+oKDJpBHpBtTln/l+XCJYloatC4zirsFtkAiRYs3pVCw8arZyFa6Rr8AjGROaq4kM5
         kbHmzMUh843A1VfPdG8sJyHV2sAO2IO11fLh0UTNYKvblj4Jk9KKA7pt4nbgGj/MXev0
         Vct1VWR4SgYza74Js81b2yL3RjVxO9OrYagLBCCyk/ioHglPy9sEwpuJhlYiE9TE4jDv
         aSYGvNpf9gtvAVcC5ivGcEZC9O+/gxtGZkb2fMHOBEPv2mdH65tTMiXbXATz/wWN0Met
         cdvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gQEJTQg/xi+xGBTILRshTz44xvzWMVdWW40LcKklwis=;
        b=rLbyq2e4NSD0Oyd1ZwOqYz5xp/+v87gqfhw9vy0gSmlXAeDqZXFOL6L78QrrXce+z0
         HnS4zHiB6Ufbe/5nzqYW8YwX0WEMAs3Uh5whF7k+n2AbDXZxAkcli5Lbat05A/oAGRb8
         OouAeeUg2E2TmGBVaC7rBfne/jmFHuiWLD7Vd5/K1St2Oz5ypQdEpG/vafDI+N+tA2+V
         Jv8coPwbhZ0y2yGqbaTxqPlfqjjqSuqHI3cPyjXKrDi2eJ19nE0ZV/FZ8N2phqK6G7BQ
         CnvTJFplxy3kBgIlZnTiRt8p7isfVEzujUZqITrx2rQUn64CQH2nlzqiVETiQYek16WW
         GwSA==
X-Gm-Message-State: AOAM533rzt4vU4TVdq15idW2Dfy5p15LSfAWcv7gcf+bVfl/uXTzCRxN
        WO68qLvT8ouDoI71k1jxp9iV5Xictq8=
X-Google-Smtp-Source: ABdhPJycpwJsXMUuIG8kY7kC2iCcLReDseGXoFr/bUm4PN4yVZgEripTF0mRRqtBjOh3WPqyXHynNg==
X-Received: by 2002:adf:8307:: with SMTP id 7mr13535643wrd.261.1605436742430;
        Sun, 15 Nov 2020 02:39:02 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id b14sm17790900wrs.46.2020.11.15.02.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 02:39:02 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        v@nametag.social
Subject: [PATCH 2/5] io_uring: copy hdr consistently for send and recv
Date:   Sun, 15 Nov 2020 10:35:41 +0000
Message-Id: <b280f7e761bbc7f6fbd3c2fefb5152b38ec5698d.1605435507.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1605435507.git.asml.silence@gmail.com>
References: <cover.1605435507.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

recvmsg() goes through a custom written msg headers/iovec copying
helper, do that for sendmsg() as well. Apart from being more consistent
in general, it allows to extend it (e.g. for registered buffers) without
duplication.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 51 ++++++++++++++++++++++++---------------------------
 1 file changed, 24 insertions(+), 27 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bcd6f63af711..88daf5fc7e8e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4494,16 +4494,18 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	return -EAGAIN;
 }
 
-static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
-				 struct io_async_msghdr *iomsg)
+static int __io_msg_copy_hdr(struct io_kiocb *req,
+			     struct io_async_msghdr *iomsg, int rw)
 {
+	struct sockaddr __user **save_addr;
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct iovec __user *uiov;
 	size_t iov_len;
 	int ret;
 
-	ret = __copy_msghdr_from_user(&iomsg->msg, sr->umsg,
-					&iomsg->uaddr, &uiov, &iov_len);
+	save_addr = (rw == READ) ? &iomsg->uaddr : NULL;
+	ret = __copy_msghdr_from_user(&iomsg->msg, sr->umsg, save_addr,
+				      &uiov, &iov_len);
 	if (ret)
 		return ret;
 
@@ -4517,7 +4519,7 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
 				sr->len);
 		iomsg->iov = NULL;
 	} else {
-		ret = __import_iovec(READ, uiov, iov_len, UIO_FASTIOV,
+		ret = __import_iovec(rw, uiov, iov_len, UIO_FASTIOV,
 				     &iomsg->iov, &iomsg->msg.msg_iter,
 				     false);
 		if (ret > 0)
@@ -4528,9 +4530,10 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
 }
 
 #ifdef CONFIG_COMPAT
-static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
-					struct io_async_msghdr *iomsg)
+static int __io_compat_msg_copy_hdr(struct io_kiocb *req,
+				    struct io_async_msghdr *iomsg, int rw)
 {
+	struct sockaddr __user **save_addr;
 	struct compat_msghdr __user *msg_compat;
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct compat_iovec __user *uiov;
@@ -4539,8 +4542,9 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 	int ret;
 
 	msg_compat = (struct compat_msghdr __user *) sr->umsg;
-	ret = __get_compat_msghdr(&iomsg->msg, msg_compat, &iomsg->uaddr,
-					&ptr, &len);
+	save_addr = (rw == READ) ? &iomsg->uaddr : NULL;
+	ret = __get_compat_msghdr(&iomsg->msg, msg_compat, save_addr,
+				  &ptr, &len);
 	if (ret)
 		return ret;
 
@@ -4559,7 +4563,7 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 		sr->len = iomsg->iov[0].iov_len;
 		iomsg->iov = NULL;
 	} else {
-		ret = __import_iovec(READ, (struct iovec __user *)uiov, len,
+		ret = __import_iovec(rw, (struct iovec __user *)uiov, len,
 				   UIO_FASTIOV, &iomsg->iov,
 				   &iomsg->msg.msg_iter, true);
 		if (ret < 0)
@@ -4585,8 +4589,8 @@ static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
 	return kbuf;
 }
 
-static int io_recvmsg_copy_hdr(struct io_kiocb *req,
-			       struct io_async_msghdr *iomsg)
+static int io_import_msg(struct io_kiocb *req, struct io_async_msghdr *iomsg,
+			 int rw)
 {
 	struct io_buffer *kbuf;
 	int ret;
@@ -4595,14 +4599,16 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	iomsg->iov = iomsg->fast_iov;
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
-		ret = __io_compat_recvmsg_copy_hdr(req, iomsg);
+		ret = __io_compat_msg_copy_hdr(req, iomsg, rw);
 	else
 #endif
-		ret = __io_recvmsg_copy_hdr(req, iomsg);
+		ret = __io_msg_copy_hdr(req, iomsg, rw);
 	if (ret < 0)
 		return ret;
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
+		if (rw != READ)
+			return -EINVAL;
 		/* init is always done with uring_lock held */
 		kbuf = io_recv_buffer_select(req, false);
 		if (IS_ERR(kbuf))
@@ -4614,15 +4620,6 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_sendmsg_copy_hdr(struct io_kiocb *req,
-			       struct io_async_msghdr *iomsg)
-{
-	iomsg->iov = iomsg->fast_iov;
-	iomsg->msg.msg_name = &iomsg->addr;
-	return sendmsg_copy_msghdr(&iomsg->msg, req->sr_msg.umsg,
-				   req->sr_msg.msg_flags, &iomsg->iov);
-}
-
 static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_async_msghdr *async_msg = req->async_data;
@@ -4643,7 +4640,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (!async_msg || !io_op_defs[req->opcode].needs_async_data)
 		return 0;
-	ret = io_sendmsg_copy_hdr(req, async_msg);
+	ret = io_import_msg(req, async_msg, WRITE);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
@@ -4663,7 +4660,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 
 	kmsg = req->async_data;
 	if (!kmsg) {
-		ret = io_sendmsg_copy_hdr(req, &iomsg);
+		ret = io_import_msg(req, &iomsg, WRITE);
 		if (ret)
 			return ret;
 		kmsg = &iomsg;
@@ -4760,7 +4757,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 
 	if (!async_msg || !io_op_defs[req->opcode].needs_async_data)
 		return 0;
-	ret = io_recvmsg_copy_hdr(req, async_msg);
+	ret = io_import_msg(req, async_msg, READ);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
@@ -4780,7 +4777,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 
 	kmsg = req->async_data;
 	if (!kmsg) {
-		ret = io_recvmsg_copy_hdr(req, &iomsg);
+		ret = io_import_msg(req, &iomsg, READ);
 		if (ret)
 			return ret;
 		kmsg = &iomsg;
-- 
2.24.0

