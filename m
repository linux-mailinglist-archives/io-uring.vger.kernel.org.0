Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88CF1178BFD
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 08:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728659AbgCDHyK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 02:54:10 -0500
Received: from szxga04-in.huawei.com ([45.249.212.190]:11143 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728319AbgCDHyK (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Wed, 4 Mar 2020 02:54:10 -0500
Received: from DGGEMS403-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 2A2BEB725D2ADD41E334;
        Wed,  4 Mar 2020 15:54:03 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS403-HUB.china.huawei.com
 (10.3.19.203) with Microsoft SMTP Server id 14.3.439.0; Wed, 4 Mar 2020
 15:53:56 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <axboe@kernel.dk>, <viro@zeniv.linux.org.uk>
CC:     <io-uring@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH -next] io_uring: Fix unused function warnings
Date:   Wed, 4 Mar 2020 15:53:52 +0800
Message-ID: <20200304075352.31132-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If CONFIG_NET is not set, gcc warns:

fs/io_uring.c:3110:12: warning: io_setup_async_msg defined but not used [-Wunused-function]
 static int io_setup_async_msg(struct io_kiocb *req,
            ^~~~~~~~~~~~~~~~~~

There are many funcions wraped by CONFIG_NET, move them
together to simplify code, also fix this warning.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 fs/io_uring.c | 98 ++++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 57 insertions(+), 41 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b7c178f9..89cdc6e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3420,6 +3420,7 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 	return 0;
 }
 
+#if defined(CONFIG_NET)
 static int io_setup_async_msg(struct io_kiocb *req,
 			      struct io_async_msghdr *kmsg)
 {
@@ -3437,7 +3438,6 @@ static int io_setup_async_msg(struct io_kiocb *req,
 
 static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-#if defined(CONFIG_NET)
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct io_async_ctx *io = req->io;
 	int ret;
@@ -3463,15 +3463,11 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 		      bool force_nonblock)
 {
-#if defined(CONFIG_NET)
 	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
 	int ret;
@@ -3525,15 +3521,11 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
 	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
 		   bool force_nonblock)
 {
-#if defined(CONFIG_NET)
 	struct socket *sock;
 	int ret;
 
@@ -3576,9 +3568,6 @@ static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
 		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
 	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int __io_recvmsg_copy_hdr(struct io_kiocb *req, struct io_async_ctx *io)
@@ -3691,7 +3680,6 @@ static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
 static int io_recvmsg_prep(struct io_kiocb *req,
 			   const struct io_uring_sqe *sqe)
 {
-#if defined(CONFIG_NET)
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct io_async_ctx *io = req->io;
 	int ret;
@@ -3716,15 +3704,11 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 		      bool force_nonblock)
 {
-#if defined(CONFIG_NET)
 	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
 	int ret, cflags = 0;
@@ -3785,15 +3769,11 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
 	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 		   bool force_nonblock)
 {
-#if defined(CONFIG_NET)
 	struct io_buffer *kbuf = NULL;
 	struct socket *sock;
 	int ret, cflags = 0;
@@ -3850,15 +3830,10 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
 	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
-
 static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-#if defined(CONFIG_NET)
 	struct io_accept *accept = &req->accept;
 
 	if (unlikely(req->ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
@@ -3870,12 +3845,8 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
-#if defined(CONFIG_NET)
 static int __io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 		       bool force_nonblock)
 {
@@ -3910,12 +3881,10 @@ static void io_accept_finish(struct io_wq_work **workptr)
 	if (nxt)
 		io_wq_assign_next(workptr, nxt);
 }
-#endif
 
 static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 		     bool force_nonblock)
 {
-#if defined(CONFIG_NET)
 	int ret;
 
 	ret = __io_accept(req, nxt, force_nonblock);
@@ -3924,14 +3893,10 @@ static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 		return -EAGAIN;
 	}
 	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-#if defined(CONFIG_NET)
 	struct io_connect *conn = &req->connect;
 	struct io_async_ctx *io = req->io;
 
@@ -3948,15 +3913,11 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	return move_addr_to_kernel(conn->addr, conn->addr_len,
 					&io->connect.address);
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
 		      bool force_nonblock)
 {
-#if defined(CONFIG_NET)
 	struct io_async_ctx __io, *io;
 	unsigned file_flags;
 	int ret;
@@ -3994,11 +3955,66 @@ static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
 	io_cqring_add_event(req, ret);
 	io_put_req_find_next(req, nxt);
 	return 0;
+}
 #else
+static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
+		      bool force_nonblock)
+{
 	return -EOPNOTSUPP;
-#endif
 }
 
+static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
+		   bool force_nonblock)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_recvmsg_prep(struct io_kiocb *req,
+			   const struct io_uring_sqe *sqe)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
+		      bool force_nonblock)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
+		   bool force_nonblock)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
+		     bool force_nonblock)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_connect(struct io_kiocb *req, struct io_kiocb **nxt,
+		      bool force_nonblock)
+{
+	return -EOPNOTSUPP;
+}
+#endif
+
 struct io_poll_table {
 	struct poll_table_struct pt;
 	struct io_kiocb *req;
-- 
2.7.4


