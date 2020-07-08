Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5F721899A
	for <lists+io-uring@lfdr.de>; Wed,  8 Jul 2020 15:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgGHN7c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Jul 2020 09:59:32 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:56714 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729595AbgGHN7c (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Jul 2020 09:59:32 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 32102200A5
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 13:59:31 +0000 (UTC)
Received: from us4-mdac16-68.at1.mdlocal (unknown [10.110.50.185])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 311AE8009B
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 13:59:31 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.30])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BFB5D40079
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 13:59:30 +0000 (UTC)
Received: from mx2.vailsys.com (mx2.vailsys.com [63.209.137.144])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A9473140096
        for <io-uring@vger.kernel.org>; Wed,  8 Jul 2020 13:59:30 +0000 (UTC)
Received: from dfsmtp.vail (dfsmtp.vail [192.168.129.173])
        by mx2.vailsys.com (Postfix) with ESMTPS id 69F7CC960D;
        Wed,  8 Jul 2020 09:59:30 -0400 (EDT)
Received: from sdlsip03.vail (sdlsip03.vail [172.20.152.161])
        by dfsmtp.vail (Postfix) with ESMTPS id 5215021714B;
        Wed,  8 Jul 2020 08:59:30 -0500 (CDT)
Received: by sdlsip03.vail (Postfix, from userid 1001)
        id 1A56A1005C51; Wed,  8 Jul 2020 08:59:30 -0500 (CDT)
From:   Alex Nash <nash@vailsys.com>
To:     io-uring@vger.kernel.org
Cc:     Alex Nash <nash@vailsys.com>
Subject: [PATCH] io_uring: add support for sendto(2) and recvfrom(2)
Date:   Wed,  8 Jul 2020 08:59:28 -0500
Message-Id: <20200708135928.24475-1-nash@vailsys.com>
X-Mailer: git-send-email 2.18.4
In-Reply-To: <a2399c89-2c45-375c-7395-b5caf556ec3d@kernel.dk>
References: <a2399c89-2c45-375c-7395-b5caf556ec3d@kernel.dk>
X-MDID: 1594216771-tigZO_CxBO7b
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds IORING_OP_SENDTO for sendto(2) support, and IORING_OP_RECVFROM
for recvfrom(2) support.

Signed-off-by: Alex Nash <nash@vailsys.com>
---
 fs/io_uring.c                 | 89 +++++++++++++++++++++++++++++++----
 include/linux/socket.h        |  2 +
 include/uapi/linux/io_uring.h |  3 ++
 net/socket.c                  |  4 +-
 4 files changed, 86 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d37d7ea5ebe5..7fa4ddd2f364 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -414,7 +414,14 @@ struct io_sr_msg {
 	struct file			*file;
 	union {
 		struct user_msghdr __user *msg;
-		void __user		*buf;
+		struct {
+			void __user	*buf;
+			struct sockaddr __user *addr;
+			union {
+				void __user	*recvfrom_addr_len;
+				size_t		sendto_addr_len;
+			};
+		} sr;
 	};
 	int				msg_flags;
 	int				bgid;
@@ -878,6 +885,18 @@ static const struct io_op_def io_op_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 	},
+	[IORING_OP_SENDTO] = {
+		.needs_mm		= 1,
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+	},
+	[IORING_OP_RECVFROM] = {
+		.needs_mm		= 1,
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollin			= 1,
+	},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -3545,8 +3564,18 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
 
-	if (!io || req->opcode == IORING_OP_SEND)
+	switch (req->opcode) {
+	case IORING_OP_SENDMSG:
+		if (!io)
+			return 0;
+		break;
+	case IORING_OP_SEND:
+		return 0;
+	case IORING_OP_SENDTO:
+		sr->sr.addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+		sr->sr.sendto_addr_len = READ_ONCE(sqe->addr3);
 		return 0;
+	}
 	/* iovec is already imported */
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
@@ -3620,20 +3649,29 @@ static int io_send(struct io_kiocb *req, bool force_nonblock)
 
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
+		struct sockaddr_storage address;
 		struct io_sr_msg *sr = &req->sr_msg;
 		struct msghdr msg;
 		struct iovec iov;
 		unsigned flags;
 
-		ret = import_single_range(WRITE, sr->buf, sr->len, &iov,
+		ret = import_single_range(WRITE, sr->sr.buf, sr->len, &iov,
 						&msg.msg_iter);
 		if (ret)
 			return ret;
 
-		msg.msg_name = NULL;
+		if (req->opcode == IORING_OP_SEND || sr->sr.addr == NULL) {
+			msg.msg_name = NULL;
+			msg.msg_namelen = 0;
+		} else {
+			ret = move_addr_to_kernel(sr->sr.addr, sr->sr.sendto_addr_len, &address);
+			if (ret)
+				return ret;
+			msg.msg_name = (struct sockaddr *)&address;
+			msg.msg_namelen = sr->sr.sendto_addr_len;
+		}
 		msg.msg_control = NULL;
 		msg.msg_controllen = 0;
-		msg.msg_namelen = 0;
 
 		flags = req->sr_msg.msg_flags;
 		if (flags & MSG_DONTWAIT)
@@ -3783,8 +3821,18 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
 
-	if (!io || req->opcode == IORING_OP_RECV)
+	switch (req->opcode) {
+	case IORING_OP_RECVMSG:
+		if (!io)
+			return 0;
+		break;
+	case IORING_OP_RECV:
+		return 0;
+	case IORING_OP_RECVFROM:
+		sr->sr.addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+		sr->sr.recvfrom_addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr3));
 		return 0;
+	}
 	/* iovec is already imported */
 	if (req->flags & REQ_F_NEED_CLEANUP)
 		return 0;
@@ -3864,8 +3912,9 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
 
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
+		struct sockaddr_storage address;
 		struct io_sr_msg *sr = &req->sr_msg;
-		void __user *buf = sr->buf;
+		void __user *buf = sr->sr.buf;
 		struct msghdr msg;
 		struct iovec iov;
 		unsigned flags;
@@ -3884,13 +3933,17 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
 		}
 
 		req->flags |= REQ_F_NEED_CLEANUP;
-		msg.msg_name = NULL;
 		msg.msg_control = NULL;
 		msg.msg_controllen = 0;
 		msg.msg_namelen = 0;
 		msg.msg_iocb = NULL;
 		msg.msg_flags = 0;
 
+		if (req->opcode == IORING_OP_RECV)
+			msg.msg_name = NULL;
+		else
+			msg.msg_name = (struct sockaddr *)&address;
+
 		flags = req->sr_msg.msg_flags;
 		if (flags & MSG_DONTWAIT)
 			req->flags |= REQ_F_NOWAIT;
@@ -3900,10 +3953,20 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
 		ret = sock_recvmsg(sock, &msg, flags);
 		if (force_nonblock && ret == -EAGAIN)
 			return -EAGAIN;
-		if (ret == -ERESTARTSYS)
-			ret = -EINTR;
+		if (unlikely(ret < 0)) {
+			if (ret == -ERESTARTSYS)
+				ret = -EINTR;
+			goto out;
+		}
+		if (req->opcode == IORING_OP_RECVFROM && sr->sr.addr) {
+			int err = move_addr_to_user(&address, msg.msg_namelen,
+						    sr->sr.addr, sr->sr.recvfrom_addr_len);
+			if (err < 0)
+				ret = err;
+		}
 	}
 
+out:
 	kfree(kbuf);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	__io_cqring_add_event(req, ret, cflags);
@@ -4997,10 +5060,12 @@ static int io_req_defer_prep(struct io_kiocb *req,
 		break;
 	case IORING_OP_SENDMSG:
 	case IORING_OP_SEND:
+	case IORING_OP_SENDTO:
 		ret = io_sendmsg_prep(req, sqe);
 		break;
 	case IORING_OP_RECVMSG:
 	case IORING_OP_RECV:
+	case IORING_OP_RECVFROM:
 		ret = io_recvmsg_prep(req, sqe);
 		break;
 	case IORING_OP_CONNECT:
@@ -5125,6 +5190,7 @@ static void io_cleanup_req(struct io_kiocb *req)
 			kfree(io->msg.iov);
 		break;
 	case IORING_OP_RECV:
+	case IORING_OP_RECVFROM:
 		if (req->flags & REQ_F_BUFFER_SELECTED)
 			kfree(req->sr_msg.kbuf);
 		break;
@@ -5205,6 +5271,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		break;
 	case IORING_OP_SENDMSG:
 	case IORING_OP_SEND:
+	case IORING_OP_SENDTO:
 		if (sqe) {
 			ret = io_sendmsg_prep(req, sqe);
 			if (ret < 0)
@@ -5217,6 +5284,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		break;
 	case IORING_OP_RECVMSG:
 	case IORING_OP_RECV:
+	case IORING_OP_RECVFROM:
 		if (sqe) {
 			ret = io_recvmsg_prep(req, sqe);
 			if (ret)
@@ -8266,6 +8334,7 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
+	BUILD_BUG_SQE_ELEM(48, __s64,  addr3);
 
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
diff --git a/include/linux/socket.h b/include/linux/socket.h
index 04d2bc97f497..92c4a269a80d 100644
--- a/include/linux/socket.h
+++ b/include/linux/socket.h
@@ -364,6 +364,8 @@ struct ucred {
 #define IPX_TYPE	1
 
 extern int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *kaddr);
+extern int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
+			     void __user *uaddr, int __user *ulen);
 extern int put_cmsg(struct msghdr*, int level, int type, int len, void *data);
 
 struct timespec64;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 92c22699a5a7..c52658393a1c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -55,6 +55,7 @@ struct io_uring_sqe {
 			/* personality to use, if used */
 			__u16	personality;
 			__s32	splice_fd_in;
+			__u64	addr3;
 		};
 		__u64	__pad2[3];
 	};
@@ -130,6 +131,8 @@ enum {
 	IORING_OP_PROVIDE_BUFFERS,
 	IORING_OP_REMOVE_BUFFERS,
 	IORING_OP_TEE,
+	IORING_OP_SENDTO,
+	IORING_OP_RECVFROM,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/net/socket.c b/net/socket.c
index 976426d03f09..f3609e64cec9 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -217,8 +217,8 @@ int move_addr_to_kernel(void __user *uaddr, int ulen, struct sockaddr_storage *k
  *	specified. Zero is returned for a success.
  */
 
-static int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
-			     void __user *uaddr, int __user *ulen)
+int move_addr_to_user(struct sockaddr_storage *kaddr, int klen,
+		      void __user *uaddr, int __user *ulen)
 {
 	int err;
 	int len;
-- 
2.18.4

