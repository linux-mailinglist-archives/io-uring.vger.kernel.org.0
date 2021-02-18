Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA2731EEFC
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 19:54:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhBRSwY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 13:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbhBRSgg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 13:36:36 -0500
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C5CCC061356
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:53 -0800 (PST)
Received: by mail-wr1-x42f.google.com with SMTP id 7so4101221wrz.0
        for <io-uring@vger.kernel.org>; Thu, 18 Feb 2021 10:33:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=8+9Tt58vct4ZD5pqPIIsNa3vriuW2qqO4EjIB4+G0Ug=;
        b=cELCIifOOvnnq7dG2Zboryw5UGnB5UVsw88KCsj2v3TaIdSK3uorCcUdv+2s+HfmE+
         2B4PjtCuQ69MZGcLcaJfLC/B0vsZG1aOPNL5iubkAUrS5Z4kGljdqZFBgygmAY5PrjFp
         g1cC5wHk+b07yFs6HeFkBiq6c1d8RJgUBuCwvVOM3qO7SK7poE0W0BZaL60ycC44Oyxb
         J7HmNIsrwR+aXqW3w3xsqVDHZMRFAgo+VHI7rov0rNobGsYheKxtXTmN3E0RMuEx6oMf
         u18NdS9DSYXjbxaxoiW2jR/1EPfbkVbmkzqWMkzPLgn/ggO9JjJlXGyqWHjNUXorznHT
         AyhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8+9Tt58vct4ZD5pqPIIsNa3vriuW2qqO4EjIB4+G0Ug=;
        b=dPAavT5q7yq4Ek3DR6lYZhtBs9rrIIfhDf19ZNovOjX2XyiC3+ZS7r+sZoBhyM+dhr
         FLh7BHLFwesN8w4w6cQcfrNiwpDAhVcyx23ZdlT8cNKd1NklNLcNdI6T0JfSmfHRAe9Z
         FBkB1ku3DupGZuZwoMjaJEnil8YMrh32DVFvtFAoGjo7nlhy0lriaXuLtvRuiRFkULNT
         EPMV/FKJzf2AuTrlIiKhn2dl90iLmdZqCYAnGr25O43O+T+uMa1TwOTmIPGp8o8RJTQT
         +fMjBo/OAa59stb1ThQeqrSY2uuo0vbQ1i6UCqpEO+RcsY9Zo8jAF3M3nl+Kk8QyxVFJ
         ZDNA==
X-Gm-Message-State: AOAM531e0h6tsn8mzwm0Za+KVVxtT8itFVvlc1EYCY5orfjBzRnSISju
        tntLwGkVtAQNIHYOLWEVubw3oj2uSDduSg==
X-Google-Smtp-Source: ABdhPJxjztpuBKXLB6qhemPW/hQVXaibdCSqBvrYRQRbOCrec1l/Jo15BZMZ0hhheXJux+78kBz0bA==
X-Received: by 2002:a5d:4046:: with SMTP id w6mr5346724wrp.223.1613673232207;
        Thu, 18 Feb 2021 10:33:52 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.139])
        by smtp.gmail.com with ESMTPSA id 36sm4034459wrh.94.2021.02.18.10.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Feb 2021 10:33:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/11] io_uring: split sqe-prep and async setup
Date:   Thu, 18 Feb 2021 18:29:44 +0000
Message-Id: <3884a8ce6e607b095397685b06dbb3493758119b.1613671791.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613671791.git.asml.silence@gmail.com>
References: <cover.1613671791.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are two kinds of opcode-specific preparations we do. The first is
just initialising req with what is always needed for an opcode and
reading all non-generic SQE fields. And the second is copying some of
the stuff like iovec preparing to punt a request to somewhere async,
e.g. to io-wq or for draining. For requests that have tried an inline
execution but still needing to be punted, the second prep type is done
by the opcode handler itself.

Currently, we don't explicitly split those preparation steps, but
combining both of them into io_*_prep(), altering the behaviour by
allocating ->async_data. That's pretty messy and hard to follow and also
gets in the way of some optimisations.

Split the steps, leave the first type as where it is now, and put the
second into a new io_req_prep_async() helper. It may make us to do opcode
switch twice, but it's worth it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 120 +++++++++++++++++++++++++++++---------------------
 1 file changed, 70 insertions(+), 50 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 62688866357c..987cfd8db213 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3472,19 +3472,9 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 
 static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	ssize_t ret;
-
-	ret = io_prep_rw(req, sqe);
-	if (ret)
-		return ret;
-
 	if (unlikely(!(req->file->f_mode & FMODE_READ)))
 		return -EBADF;
-
-	/* either don't need iovec imported or already have it */
-	if (!req->async_data)
-		return 0;
-	return io_rw_prep_async(req, READ);
+	return io_prep_rw(req, sqe);
 }
 
 /*
@@ -3669,19 +3659,9 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	ssize_t ret;
-
-	ret = io_prep_rw(req, sqe);
-	if (ret)
-		return ret;
-
 	if (unlikely(!(req->file->f_mode & FMODE_WRITE)))
 		return -EBADF;
-
-	/* either don't need iovec imported or already have it */
-	if (!req->async_data)
-		return 0;
-	return io_rw_prep_async(req, WRITE);
+	return io_prep_rw(req, sqe);
 }
 
 static int io_write(struct io_kiocb *req, unsigned int issue_flags)
@@ -4668,11 +4648,21 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 				   req->sr_msg.msg_flags, &iomsg->free_iov);
 }
 
+static int io_sendmsg_prep_async(struct io_kiocb *req)
+{
+	int ret;
+
+	if (!io_op_defs[req->opcode].needs_async_data)
+		return 0;
+	ret = io_sendmsg_copy_hdr(req, req->async_data);
+	if (!ret)
+		req->flags |= REQ_F_NEED_CLEANUP;
+	return ret;
+}
+
 static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-	struct io_async_msghdr *async_msg = req->async_data;
 	struct io_sr_msg *sr = &req->sr_msg;
-	int ret;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -4685,13 +4675,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
-
-	if (!async_msg || !io_op_defs[req->opcode].needs_async_data)
-		return 0;
-	ret = io_sendmsg_copy_hdr(req, async_msg);
-	if (!ret)
-		req->flags |= REQ_F_NEED_CLEANUP;
-	return ret;
+	return 0;
 }
 
 static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
@@ -4885,13 +4869,22 @@ static inline unsigned int io_put_recv_kbuf(struct io_kiocb *req)
 	return io_put_kbuf(req, req->sr_msg.kbuf);
 }
 
-static int io_recvmsg_prep(struct io_kiocb *req,
-			   const struct io_uring_sqe *sqe)
+static int io_recvmsg_prep_async(struct io_kiocb *req)
 {
-	struct io_async_msghdr *async_msg = req->async_data;
-	struct io_sr_msg *sr = &req->sr_msg;
 	int ret;
 
+	if (!io_op_defs[req->opcode].needs_async_data)
+		return 0;
+	ret = io_recvmsg_copy_hdr(req, req->async_data);
+	if (!ret)
+		req->flags |= REQ_F_NEED_CLEANUP;
+	return ret;
+}
+
+static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_sr_msg *sr = &req->sr_msg;
+
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
@@ -4904,13 +4897,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
-
-	if (!async_msg || !io_op_defs[req->opcode].needs_async_data)
-		return 0;
-	ret = io_recvmsg_copy_hdr(req, async_msg);
-	if (!ret)
-		req->flags |= REQ_F_NEED_CLEANUP;
-	return ret;
+	return 0;
 }
 
 static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
@@ -5063,10 +5050,17 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+static int io_connect_prep_async(struct io_kiocb *req)
+{
+	struct io_async_connect *io = req->async_data;
+	struct io_connect *conn = &req->connect;
+
+	return move_addr_to_kernel(conn->addr, conn->addr_len, &io->address);
+}
+
 static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_connect *conn = &req->connect;
-	struct io_async_connect *io = req->async_data;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -5075,12 +5069,7 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	conn->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	conn->addr_len =  READ_ONCE(sqe->addr2);
-
-	if (!io)
-		return 0;
-
-	return move_addr_to_kernel(conn->addr, conn->addr_len,
-					&io->address);
+	return 0;
 }
 
 static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
@@ -6148,14 +6137,45 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return-EINVAL;
 }
 
+static int io_req_prep_async(struct io_kiocb *req)
+{
+	switch (req->opcode) {
+	case IORING_OP_READV:
+	case IORING_OP_READ_FIXED:
+	case IORING_OP_READ:
+		return io_rw_prep_async(req, READ);
+	case IORING_OP_WRITEV:
+	case IORING_OP_WRITE_FIXED:
+	case IORING_OP_WRITE:
+		return io_rw_prep_async(req, WRITE);
+	case IORING_OP_SENDMSG:
+	case IORING_OP_SEND:
+		return io_sendmsg_prep_async(req);
+	case IORING_OP_RECVMSG:
+	case IORING_OP_RECV:
+		return io_recvmsg_prep_async(req);
+	case IORING_OP_CONNECT:
+		return io_connect_prep_async(req);
+	}
+	return 0;
+}
+
 static int io_req_defer_prep(struct io_kiocb *req,
 			     const struct io_uring_sqe *sqe)
 {
+	int ret;
+
 	if (!sqe)
 		return 0;
 	if (io_alloc_async_data(req))
 		return -EAGAIN;
-	return io_req_prep(req, sqe);
+	ret = io_req_prep(req, sqe);
+	if (ret)
+		return ret;
+	if (req->async_data)
+		return io_req_prep_async(req);
+	return 0;
+
 }
 
 static u32 io_get_sequence(struct io_kiocb *req)
-- 
2.24.0

