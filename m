Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D426215E05
	for <lists+io-uring@lfdr.de>; Mon,  6 Jul 2020 20:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729740AbgGFSJw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 6 Jul 2020 14:09:52 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:34916 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729693AbgGFSJw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 6 Jul 2020 14:09:52 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EFFD660054
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 18:09:51 +0000 (UTC)
Received: from us4-mdac16-47.ut7.mdlocal (unknown [10.7.66.14])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EEF422009A
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 18:09:51 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.198])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 71EC11C004F
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 18:09:51 +0000 (UTC)
Received: from mx2.vailsys.com (mx2.vailsys.com [63.209.137.144])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 3FAC58006C
        for <io-uring@vger.kernel.org>; Mon,  6 Jul 2020 18:09:51 +0000 (UTC)
Received: from dfsmtp.vail (dfsmtp.vail [192.168.129.173])
        by mx2.vailsys.com (Postfix) with ESMTPS id 9E252C960A;
        Mon,  6 Jul 2020 14:09:50 -0400 (EDT)
Received: from sdlsip03.vail (sdlsip03.vail [172.20.152.161])
        by dfsmtp.vail (Postfix) with ESMTPS id 863C921714A;
        Mon,  6 Jul 2020 13:09:50 -0500 (CDT)
Received: by sdlsip03.vail (Postfix, from userid 1001)
        id 5290F1005C51; Mon,  6 Jul 2020 13:09:50 -0500 (CDT)
From:   Alex Nash <nash@vailsys.com>
To:     io-uring@vger.kernel.org
Cc:     Alex Nash <nash@vailsys.com>
Subject: [PATCH] io_uring: add support for sendto(2) and recvfrom(2)
Date:   Mon,  6 Jul 2020 13:09:28 -0500
Message-Id: <20200706180928.10752-1-nash@vailsys.com>
X-Mailer: git-send-email 2.18.4
X-MDID: 1594058991-j152K5GH3waO
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This adds IORING_OP_SENDTO for sendto(2) support, and IORING_OP_RECVFROM
for recvfrom(2) support.

Signed-off-by: Alex Nash <nash@vailsys.com>
---
 fs/io_uring.c                 | 67 +++++++++++++++++++++++++++++++----
 include/linux/socket.h        |  2 ++
 include/uapi/linux/io_uring.h |  6 ++++
 net/socket.c                  |  4 +--
 4 files changed, 71 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d37d7ea5ebe5..72ab7b57ee5a 100644
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
+			void __user	*recvfrom_addr_len;
+			size_t		sendto_addr_len;
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
+		.pollout		= 1,
+	},
 };
 
 static void io_wq_submit_work(struct io_wq_work **workptr);
@@ -3545,6 +3564,11 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
 
+	if (req->opcode == IORING_OP_SENDTO) {
+		sr->sr.addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+		sr->sr.sendto_addr_len = READ_ONCE(sqe->sendto_addr_len);
+		return 0;
+	}
 	if (!io || req->opcode == IORING_OP_SEND)
 		return 0;
 	/* iovec is already imported */
@@ -3620,20 +3644,29 @@ static int io_send(struct io_kiocb *req, bool force_nonblock)
 
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
@@ -3783,6 +3816,11 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
 
+	if (req->opcode == IORING_OP_RECVFROM) {
+		sr->sr.addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+		sr->sr.recvfrom_addr_len = u64_to_user_ptr(READ_ONCE(sqe->recvfrom_addr_len));
+		return 0;
+	}
 	if (!io || req->opcode == IORING_OP_RECV)
 		return 0;
 	/* iovec is already imported */
@@ -3864,8 +3902,9 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
 
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
+		struct sockaddr_storage address;
 		struct io_sr_msg *sr = &req->sr_msg;
-		void __user *buf = sr->buf;
+		void __user *buf = sr->sr.buf;
 		struct msghdr msg;
 		struct iovec iov;
 		unsigned flags;
@@ -3884,13 +3923,17 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
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
@@ -3902,6 +3945,12 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (req->opcode == IORING_OP_RECVFROM && ret >= 0 && sr->sr.addr) {
+			int err = move_addr_to_user(&address, msg.msg_namelen,
+						    sr->sr.addr, sr->sr.recvfrom_addr_len);
+			if (err < 0)
+				ret = err;
+		}
 	}
 
 	kfree(kbuf);
@@ -4997,10 +5046,12 @@ static int io_req_defer_prep(struct io_kiocb *req,
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
@@ -5205,6 +5256,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		break;
 	case IORING_OP_SENDMSG:
 	case IORING_OP_SEND:
+	case IORING_OP_SENDTO:
 		if (sqe) {
 			ret = io_sendmsg_prep(req, sqe);
 			if (ret < 0)
@@ -5217,6 +5269,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		break;
 	case IORING_OP_RECVMSG:
 	case IORING_OP_RECV:
+	case IORING_OP_RECVFROM:
 		if (sqe) {
 			ret = io_recvmsg_prep(req, sqe);
 			if (ret)
@@ -8266,6 +8319,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
+	BUILD_BUG_SQE_ELEM(48, __s32,  sendto_addr_len);
+	BUILD_BUG_SQE_ELEM(48, __s64,  recvfrom_addr_len);
 
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
index 92c22699a5a7..75bb0d27fdbc 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -55,6 +55,10 @@ struct io_uring_sqe {
 			/* personality to use, if used */
 			__u16	personality;
 			__s32	splice_fd_in;
+			union {
+				__u32	sendto_addr_len;
+				__u64	recvfrom_addr_len;
+			};
 		};
 		__u64	__pad2[3];
 	};
@@ -130,6 +134,8 @@ enum {
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

