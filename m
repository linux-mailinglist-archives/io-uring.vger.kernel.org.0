Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB5D71281A2
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2019 18:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727438AbfLTRrt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Dec 2019 12:47:49 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:35524 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727434AbfLTRrt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Dec 2019 12:47:49 -0500
Received: by mail-io1-f65.google.com with SMTP id v18so10239880iol.2
        for <io-uring@vger.kernel.org>; Fri, 20 Dec 2019 09:47:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=oaNLtTdf4noKtM+Vdg4ICCPvPIEzonTX6YsYBYoQWgg=;
        b=GyQwIvwq64n3e4GhoWaWtwn9grPhHvYxNWSX7UCQfgnjDo+bFLTzeFQO31xb3NU/II
         ahqkhBGYRg0jtI2xdu+58/huANTXRwBdzeoJ90nno7Zrs8YnAkIL3OcUjEZFz9pPDd4F
         wvBntq+gWYaAYUozJXOZHsOIidUbTdANHKNw5lt/7hyuC/lKFh/bYSvXVZHQQ0yB6rlv
         ZLfT+xPX9QLhfnljMwxgGvrIEmnC0aRtJ4LWLqx3kRRVSbnuw4zdKgkunBX1o9yGV6eE
         XZbJJUm/MI7+vENQ/79w0r5pO3JWSRW0Ol/zJ5n/AS9bC7Q5cWzq2CM6gH2KA3k4tRVk
         O/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oaNLtTdf4noKtM+Vdg4ICCPvPIEzonTX6YsYBYoQWgg=;
        b=S3gplwSA6An9YS4ccmygBrkrmTD3Do/9D+o/xebLn7hw29ay1UWnTOf+g+GGbfswTD
         dmApxh825k9iMG9mqtVkfJ2P9cFBxvzUC28r+G1/yHKNcBh75qxtUHmlUBQPtYM/qOrn
         5MnNdpY8hbYuQ237zoHAb1dJd+BPIO/56rVU706BaiSXOEPN2wy5lOKWIpfsA6mQssCO
         JGOEqHryg/vTv9bAglI+WwsOIziW+ggTzrZn5p4g+Aq/vTzMYB7ceQU35GDK41g8e79y
         xej38K7DNH3d4cD9ODye1VcnLuJfX219sWgqFGbfjI9UZt4LD9R2KSQ0am+1FUnpOBK1
         0nsA==
X-Gm-Message-State: APjAAAWMNIlyi/ZfGsGgukifhGgxl3QLbQC/A/CpQ8ZnQeIDEXyoR8jw
        zdcPPMQTVvaBeSy6fGBGtTJdNxZnURcb6A==
X-Google-Smtp-Source: APXvYqz+8zD58at7f3FuSQ6WpQT2GKTHbrKrX+XXURLtgYEIOZU9UUWlniUzu2mz3QhUVQf1hjJ1Kg==
X-Received: by 2002:a5d:8b8d:: with SMTP id p13mr10557967iol.66.1576864068039;
        Fri, 20 Dec 2019 09:47:48 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id j88sm4969677ilf.83.2019.12.20.09.47.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Dec 2019 09:47:47 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/7] io_uring: move all prep state for IORING_OP_{SEND,RECV}_MGS to prep handler
Date:   Fri, 20 Dec 2019 10:47:39 -0700
Message-Id: <20191220174742.7449-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191220174742.7449-1-axboe@kernel.dk>
References: <20191220174742.7449-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add struct io_sr_msg in our io_kiocb per-command union, and ensure that
the send/recvmsg prep handlers have grabbed what they need from the SQE
by the time prep is done.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 64 ++++++++++++++++++++++++++-------------------------
 1 file changed, 33 insertions(+), 31 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2a173f54ec8e..89e5b19044cc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -345,6 +345,12 @@ struct io_connect {
 	int				addr_len;
 };
 
+struct io_sr_msg {
+	struct file			*file;
+	struct user_msghdr __user	*msg;
+	int				msg_flags;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -389,6 +395,7 @@ struct io_kiocb {
 		struct io_cancel	cancel;
 		struct io_timeout	timeout;
 		struct io_connect	connect;
+		struct io_sr_msg	sr_msg;
 	};
 
 	const struct io_uring_sqe	*sqe;
@@ -2164,15 +2171,15 @@ static int io_sendmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
 {
 #if defined(CONFIG_NET)
 	const struct io_uring_sqe *sqe = req->sqe;
-	struct user_msghdr __user *msg;
-	unsigned flags;
+	struct io_sr_msg *sr = &req->sr_msg;
 
-	flags = READ_ONCE(sqe->msg_flags);
-	msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	sr->msg_flags = READ_ONCE(sqe->msg_flags);
+	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	io->msg.iov = io->msg.fast_iov;
-	return sendmsg_copy_msghdr(&io->msg.msg, msg, flags, &io->msg.iov);
+	return sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
+					&io->msg.iov);
 #else
-	return 0;
+	return -EOPNOTSUPP;
 #endif
 }
 
@@ -2180,7 +2187,6 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 		      bool force_nonblock)
 {
 #if defined(CONFIG_NET)
-	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
 	int ret;
@@ -2194,12 +2200,6 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 		struct sockaddr_storage addr;
 		unsigned flags;
 
-		flags = READ_ONCE(sqe->msg_flags);
-		if (flags & MSG_DONTWAIT)
-			req->flags |= REQ_F_NOWAIT;
-		else if (force_nonblock)
-			flags |= MSG_DONTWAIT;
-
 		if (req->io) {
 			kmsg = &req->io->msg;
 			kmsg->msg.msg_name = &addr;
@@ -2215,6 +2215,12 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 				goto out;
 		}
 
+		flags = req->sr_msg.msg_flags;
+		if (flags & MSG_DONTWAIT)
+			req->flags |= REQ_F_NOWAIT;
+		else if (force_nonblock)
+			flags |= MSG_DONTWAIT;
+
 		ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 		if (force_nonblock && ret == -EAGAIN) {
 			if (req->io)
@@ -2245,17 +2251,15 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 static int io_recvmsg_prep(struct io_kiocb *req, struct io_async_ctx *io)
 {
 #if defined(CONFIG_NET)
-	const struct io_uring_sqe *sqe = req->sqe;
-	struct user_msghdr __user *msg;
-	unsigned flags;
+	struct io_sr_msg *sr = &req->sr_msg;
 
-	flags = READ_ONCE(sqe->msg_flags);
-	msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	sr->msg_flags = READ_ONCE(req->sqe->msg_flags);
+	sr->msg = u64_to_user_ptr(READ_ONCE(req->sqe->addr));
 	io->msg.iov = io->msg.fast_iov;
-	return recvmsg_copy_msghdr(&io->msg.msg, msg, flags, &io->msg.uaddr,
-					&io->msg.iov);
+	return recvmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
+					&io->msg.uaddr, &io->msg.iov);
 #else
-	return 0;
+	return -EOPNOTSUPP;
 #endif
 }
 
@@ -2263,7 +2267,6 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 		      bool force_nonblock)
 {
 #if defined(CONFIG_NET)
-	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
 	int ret;
@@ -2273,18 +2276,10 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
-		struct user_msghdr __user *msg;
 		struct io_async_ctx io;
 		struct sockaddr_storage addr;
 		unsigned flags;
 
-		flags = READ_ONCE(sqe->msg_flags);
-		if (flags & MSG_DONTWAIT)
-			req->flags |= REQ_F_NOWAIT;
-		else if (force_nonblock)
-			flags |= MSG_DONTWAIT;
-
-		msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 		if (req->io) {
 			kmsg = &req->io->msg;
 			kmsg->msg.msg_name = &addr;
@@ -2300,7 +2295,14 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 				goto out;
 		}
 
-		ret = __sys_recvmsg_sock(sock, &kmsg->msg, msg, kmsg->uaddr, flags);
+		flags = req->sr_msg.msg_flags;
+		if (flags & MSG_DONTWAIT)
+			req->flags |= REQ_F_NOWAIT;
+		else if (force_nonblock)
+			flags |= MSG_DONTWAIT;
+
+		ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.msg,
+						kmsg->uaddr, flags);
 		if (force_nonblock && ret == -EAGAIN) {
 			if (req->io)
 				return -EAGAIN;
-- 
2.24.1

