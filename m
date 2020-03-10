Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE7A180119
	for <lists+io-uring@lfdr.de>; Tue, 10 Mar 2020 16:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727876AbgCJPEp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Mar 2020 11:04:45 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46717 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727875AbgCJPEo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Mar 2020 11:04:44 -0400
Received: by mail-io1-f67.google.com with SMTP id v3so7022309iom.13
        for <io-uring@vger.kernel.org>; Tue, 10 Mar 2020 08:04:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XZRx5Vds4MtJnauJvVIQ/N9oU8O7MnPnnghFsz+Xzcg=;
        b=0NNCdORAbrA9pOr1Njz7E7QvIEsS30r4+6enQT6w+WQHqZT4mZMFbIYZqS3lXv6ExF
         IkHSJAak8kT9+vGncx/s9hauLGjAovLbEGxLYomrArZBG4CSACq2n4CKa7dMdFydn8d3
         zXL8N3HX8bQeaz7xVmYKndJHtNVnfDqFqDtkcpxvdXyFXUzQKIb3JqL3Bo65HIJoh2Yh
         JMSUhnXLmb49NO/yFqpKNTlYKVeAR5JTGv/nifnWMmlOmY8ukuoaXSRpkdQi0Js8OHVa
         B69ud2nhBmU0l68PVlCmlOGvnPvkJ2Xsh6B5G4ePDNXXnKibw8aILRWkP0EH6N3Q3U7I
         DXWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XZRx5Vds4MtJnauJvVIQ/N9oU8O7MnPnnghFsz+Xzcg=;
        b=GoBLHC5GBflhfix5kMgL2pDuoegIsMv+1FffR1CN2HKI+DcsZPvugbVPSUDrnWmAhD
         PDGwzgrkbctiQMuc3R1iA7vTq2hCtnvN/Q33Nz2roCOeRupswuXU4gTM6OJRogHxhXye
         i/ZDu51OL9CuYSSO2dcn9tTi1jp+j6CvQz92+ZVJL798SN/0WuQ+eHCKY081S4R55D+4
         ksnE9++eskcy+FcVyKvClFEB3x/zH9MIa5DDuMparHuA0XRgYWIti6v6L0kxPHA7c3xr
         lWwe2aBHHir2BriY44FYVnjEhPahpdZCl+j84HoNiptTFpY3FRrh7fTR6L97g399NxmL
         MUxA==
X-Gm-Message-State: ANhLgQ15m1sVQtxILu0AlvyMDZd5WcC9BCX3+HGnO2sXVS8vwndThh7M
        UPAztjdqC0lwXWO5g4D+H/Aj6RQbAgbVIA==
X-Google-Smtp-Source: ADFU+vvpA/6Zaez+4UnKt1NC699CWS+Nbddm2nYhQwzOkm2EXCu/IR4RSJZAkbubfGYIyc4nrEsIWw==
X-Received: by 2002:a02:7b13:: with SMTP id q19mr20601775jac.73.1583852681544;
        Tue, 10 Mar 2020 08:04:41 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id e16sm4684750ioh.7.2020.03.10.08.04.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 08:04:41 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, YueHaibing <yuehaibing@huawei.com>,
        Hulk Robot <hulkci@huawei.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 9/9] io_uring: Fix unused function warnings
Date:   Tue, 10 Mar 2020 09:04:26 -0600
Message-Id: <20200310150427.28489-10-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310150427.28489-1-axboe@kernel.dk>
References: <20200310150427.28489-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>

If CONFIG_NET is not set, gcc warns:

fs/io_uring.c:3110:12: warning: io_setup_async_msg defined but not used [-Wunused-function]
 static int io_setup_async_msg(struct io_kiocb *req,
            ^~~~~~~~~~~~~~~~~~

There are many funcions wraped by CONFIG_NET, move them
together to simplify code, also fix this warning.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Minor tweaks.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 94 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 52 insertions(+), 42 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f8a3f6843698..83439cf9f5e7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3485,6 +3485,7 @@ static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
 	return 0;
 }
 
+#if defined(CONFIG_NET)
 static int io_setup_async_msg(struct io_kiocb *req,
 			      struct io_async_msghdr *kmsg)
 {
@@ -3502,7 +3503,6 @@ static int io_setup_async_msg(struct io_kiocb *req,
 
 static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
-#if defined(CONFIG_NET)
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct io_async_ctx *io = req->io;
 	int ret;
@@ -3528,14 +3528,10 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 {
-#if defined(CONFIG_NET)
 	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
 	int ret;
@@ -3589,14 +3585,10 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 		req_set_fail_links(req);
 	io_put_req(req);
 	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int io_send(struct io_kiocb *req, bool force_nonblock)
 {
-#if defined(CONFIG_NET)
 	struct socket *sock;
 	int ret;
 
@@ -3639,9 +3631,6 @@ static int io_send(struct io_kiocb *req, bool force_nonblock)
 		req_set_fail_links(req);
 	io_put_req(req);
 	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int __io_recvmsg_copy_hdr(struct io_kiocb *req, struct io_async_ctx *io)
@@ -3754,7 +3743,6 @@ static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
 static int io_recvmsg_prep(struct io_kiocb *req,
 			   const struct io_uring_sqe *sqe)
 {
-#if defined(CONFIG_NET)
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct io_async_ctx *io = req->io;
 	int ret;
@@ -3779,14 +3767,10 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 {
-#if defined(CONFIG_NET)
 	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
 	int ret, cflags = 0;
@@ -3847,14 +3831,10 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 		req_set_fail_links(req);
 	io_put_req(req);
 	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int io_recv(struct io_kiocb *req, bool force_nonblock)
 {
-#if defined(CONFIG_NET)
 	struct io_buffer *kbuf = NULL;
 	struct socket *sock;
 	int ret, cflags = 0;
@@ -3911,15 +3891,10 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
 		req_set_fail_links(req);
 	io_put_req(req);
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
@@ -3931,12 +3906,8 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	return 0;
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
-#if defined(CONFIG_NET)
 static int __io_accept(struct io_kiocb *req, bool force_nonblock)
 {
 	struct io_accept *accept = &req->accept;
@@ -3966,11 +3937,9 @@ static void io_accept_finish(struct io_wq_work **workptr)
 	__io_accept(req, false);
 	io_steal_work(req, workptr);
 }
-#endif
 
 static int io_accept(struct io_kiocb *req, bool force_nonblock)
 {
-#if defined(CONFIG_NET)
 	int ret;
 
 	ret = __io_accept(req, force_nonblock);
@@ -3979,14 +3948,10 @@ static int io_accept(struct io_kiocb *req, bool force_nonblock)
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
 
@@ -4003,14 +3968,10 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	return move_addr_to_kernel(conn->addr, conn->addr_len,
 					&io->connect.address);
-#else
-	return -EOPNOTSUPP;
-#endif
 }
 
 static int io_connect(struct io_kiocb *req, bool force_nonblock)
 {
-#if defined(CONFIG_NET)
 	struct io_async_ctx __io, *io;
 	unsigned file_flags;
 	int ret;
@@ -4048,10 +4009,59 @@ static int io_connect(struct io_kiocb *req, bool force_nonblock)
 	io_cqring_add_event(req, ret);
 	io_put_req(req);
 	return 0;
-#else
+}
+#else /* !CONFIG_NET */
+static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_send(struct io_kiocb *req, bool force_nonblock)
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
+static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_recv(struct io_kiocb *req, bool force_nonblock)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_accept(struct io_kiocb *req, bool force_nonblock)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	return -EOPNOTSUPP;
+}
+
+static int io_connect(struct io_kiocb *req, bool force_nonblock)
+{
 	return -EOPNOTSUPP;
-#endif
 }
+#endif /* CONFIG_NET */
 
 struct io_poll_table {
 	struct poll_table_struct pt;
-- 
2.25.1

