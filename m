Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC7BF222CD0
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbgGPUaE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPUaD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:30:03 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 235EFC061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:03 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id o2so12923022wmh.2
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HyagEYbzFsiRr+4XRvoxvow0BlS7pl9BHEde2LLl5SY=;
        b=PqmWpQwxF9i//k7RN6PvWaAZyCEBlynf2vT8JnZpI1cPtXnj+NtZN7/7PU1vknzbiu
         raoaIJkVoevgbSLk+SCelI8huZS84dQNtmovXZ83E1bGscmowvPh5d9hjdwm6boiJxQq
         2bHRk8dKAQQwdFsGDrUkSsENgwMyuKfeQnT+6nlXZubyd3QDgeocnBfuSpCJXZWQacCE
         a/BUv+lIXUQWeQv75eq7OTNXhIW4QNbzgOWy2H3wn2ByHpPUT2TUImZ0hLcJVr92u3WK
         yb3PNt8Vfsnk1ZIGqDkZdSYXA8FA6fPWn4Qtnsvf19VH8n9PfSW6mxV5G4HnXy8nTto+
         X18w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HyagEYbzFsiRr+4XRvoxvow0BlS7pl9BHEde2LLl5SY=;
        b=jlOYkfnt7c/ilO/tr+ugh0MJaGLpzPICKs1cAY6l4O/z+FLR2K3lTScKACPAgBJ/uC
         weGfsnNnk8PM4H7Q0pv7INSzE38ILUyF4+YsR3cesXzps67LK9cdORFzh5IclO3aQHBg
         4o4r+NSA2+Ew5xhpF/jLAqs6AKsXq8IKX4CV2EOVAudXyZ+QiE69aTFGrr1jZV7/Gc+s
         /h1kWDGcIffYW8Vf6unu6XdQ9mouDu9QoTP7A+btoLEa4DjUqGbqPf3g6m7M0jcD/wH5
         WCvFFKs9snEQfev9N/Lo0XSYBRWfwjXHEUheDhokeGuW6fuEe7QVvaLjIgtEqSuWj/fc
         K1jA==
X-Gm-Message-State: AOAM531+fyPwPMXpkhpyHvdWdZmj8V95tXtRQeTctOyn5C7U+2MI9DWT
        5O9g2apiB+0MkNl3RctUeNw=
X-Google-Smtp-Source: ABdhPJw4vNBuswnml5x+g5sh2pAMqc77SxBNQyJuY7dU75zi957VJofYHmwbGi0npNC1W9UdIzVPmA==
X-Received: by 2002:a1c:bb03:: with SMTP id l3mr5621416wmf.24.1594931401700;
        Thu, 16 Jul 2020 13:30:01 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id v5sm9939823wmh.12.2020.07.16.13.30.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:30:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/7] io_uring: indent left {send,recv}[msg]()
Date:   Thu, 16 Jul 2020 23:27:59 +0300
Message-Id: <26c5c6238c8415e94b87b2f27510c5c99b1ef888.1594930020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594930020.git.asml.silence@gmail.com>
References: <cover.1594930020.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Flip over "if (sock)" condition with return on error, the upper layer
will take care. That change will be handy later, but already removes
an extra jump from hot path.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 263 +++++++++++++++++++++++++-------------------------
 1 file changed, 130 insertions(+), 133 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 44998257625b..ae857e16aa6d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3919,41 +3919,40 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 		      struct io_comp_state *cs)
 {
-	struct io_async_msghdr *kmsg = NULL;
+	struct io_async_msghdr iomsg, *kmsg = NULL;
 	struct socket *sock;
+	unsigned flags;
 	int ret;
 
 	sock = sock_from_file(req->file, &ret);
-	if (sock) {
-		struct io_async_msghdr iomsg;
-		unsigned flags;
+	if (unlikely(!sock))
+		return ret;
 
-		if (req->io) {
-			kmsg = &req->io->msg;
-			kmsg->msg.msg_name = &req->io->msg.addr;
-			/* if iov is set, it's allocated already */
-			if (!kmsg->iov)
-				kmsg->iov = kmsg->fast_iov;
-			kmsg->msg.msg_iter.iov = kmsg->iov;
-		} else {
-			ret = io_sendmsg_copy_hdr(req, &iomsg);
-			if (ret)
-				return ret;
-			kmsg = &iomsg;
-		}
+	if (req->io) {
+		kmsg = &req->io->msg;
+		kmsg->msg.msg_name = &req->io->msg.addr;
+		/* if iov is set, it's allocated already */
+		if (!kmsg->iov)
+			kmsg->iov = kmsg->fast_iov;
+		kmsg->msg.msg_iter.iov = kmsg->iov;
+	} else {
+		ret = io_sendmsg_copy_hdr(req, &iomsg);
+		if (ret)
+			return ret;
+		kmsg = &iomsg;
+	}
 
-		flags = req->sr_msg.msg_flags;
-		if (flags & MSG_DONTWAIT)
-			req->flags |= REQ_F_NOWAIT;
-		else if (force_nonblock)
-			flags |= MSG_DONTWAIT;
+	flags = req->sr_msg.msg_flags;
+	if (flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
+	else if (force_nonblock)
+		flags |= MSG_DONTWAIT;
 
-		ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
-		if (force_nonblock && ret == -EAGAIN)
-			return io_setup_async_msg(req, kmsg);
-		if (ret == -ERESTARTSYS)
-			ret = -EINTR;
-	}
+	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
+	if (force_nonblock && ret == -EAGAIN)
+		return io_setup_async_msg(req, kmsg);
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
 
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
@@ -3967,39 +3966,38 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 static int io_send(struct io_kiocb *req, bool force_nonblock,
 		   struct io_comp_state *cs)
 {
+	struct io_sr_msg *sr = &req->sr_msg;
+	struct msghdr msg;
+	struct iovec iov;
 	struct socket *sock;
+	unsigned flags;
 	int ret;
 
 	sock = sock_from_file(req->file, &ret);
-	if (sock) {
-		struct io_sr_msg *sr = &req->sr_msg;
-		struct msghdr msg;
-		struct iovec iov;
-		unsigned flags;
+	if (unlikely(!sock))
+		return ret;
 
-		ret = import_single_range(WRITE, sr->buf, sr->len, &iov,
-						&msg.msg_iter);
-		if (ret)
-			return ret;
+	ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
+	if (unlikely(ret))
+		return ret;
 
-		msg.msg_name = NULL;
-		msg.msg_control = NULL;
-		msg.msg_controllen = 0;
-		msg.msg_namelen = 0;
+	msg.msg_name = NULL;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_namelen = 0;
 
-		flags = req->sr_msg.msg_flags;
-		if (flags & MSG_DONTWAIT)
-			req->flags |= REQ_F_NOWAIT;
-		else if (force_nonblock)
-			flags |= MSG_DONTWAIT;
+	flags = req->sr_msg.msg_flags;
+	if (flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
+	else if (force_nonblock)
+		flags |= MSG_DONTWAIT;
 
-		msg.msg_flags = flags;
-		ret = sock_sendmsg(sock, &msg);
-		if (force_nonblock && ret == -EAGAIN)
-			return -EAGAIN;
-		if (ret == -ERESTARTSYS)
-			ret = -EINTR;
-	}
+	msg.msg_flags = flags;
+	ret = sock_sendmsg(sock, &msg);
+	if (force_nonblock && ret == -EAGAIN)
+		return -EAGAIN;
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
 
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -4152,62 +4150,62 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 		      struct io_comp_state *cs)
 {
-	struct io_async_msghdr *kmsg = NULL;
+	struct io_async_msghdr iomsg, *kmsg = NULL;
 	struct socket *sock;
+	struct io_buffer *kbuf;
+	unsigned flags;
 	int ret, cflags = 0;
 
 	sock = sock_from_file(req->file, &ret);
-	if (sock) {
-		struct io_buffer *kbuf;
-		struct io_async_msghdr iomsg;
-		unsigned flags;
-
-		if (req->io) {
-			kmsg = &req->io->msg;
-			kmsg->msg.msg_name = &req->io->msg.addr;
-			/* if iov is set, it's allocated already */
-			if (!kmsg->iov)
-				kmsg->iov = kmsg->fast_iov;
-			kmsg->msg.msg_iter.iov = kmsg->iov;
-		} else {
-			ret = io_recvmsg_copy_hdr(req, &iomsg);
-			if (ret)
-				return ret;
-			kmsg = &iomsg;
-		}
+	if (unlikely(!sock))
+		return ret;
 
-		kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
-		if (IS_ERR(kbuf)) {
-			return PTR_ERR(kbuf);
-		} else if (kbuf) {
-			kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
-			iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->iov,
-					1, req->sr_msg.len);
-		}
+	if (req->io) {
+		kmsg = &req->io->msg;
+		kmsg->msg.msg_name = &req->io->msg.addr;
+		/* if iov is set, it's allocated already */
+		if (!kmsg->iov)
+			kmsg->iov = kmsg->fast_iov;
+		kmsg->msg.msg_iter.iov = kmsg->iov;
+	} else {
+		ret = io_recvmsg_copy_hdr(req, &iomsg);
+		if (ret)
+			return ret;
+		kmsg = &iomsg;
+	}
 
-		flags = req->sr_msg.msg_flags;
-		if (flags & MSG_DONTWAIT)
-			req->flags |= REQ_F_NOWAIT;
-		else if (force_nonblock)
-			flags |= MSG_DONTWAIT;
+	kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
+	if (IS_ERR(kbuf)) {
+		return PTR_ERR(kbuf);
+	} else if (kbuf) {
+		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
+		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->iov,
+				1, req->sr_msg.len);
+	}
 
-		ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
-						kmsg->uaddr, flags);
-		if (force_nonblock && ret == -EAGAIN) {
-			ret = io_setup_async_msg(req, kmsg);
-			if (ret != -EAGAIN)
-				kfree(kbuf);
-			return ret;
-		}
-		if (ret == -ERESTARTSYS)
-			ret = -EINTR;
-		if (kbuf)
+	flags = req->sr_msg.msg_flags;
+	if (flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
+	else if (force_nonblock)
+		flags |= MSG_DONTWAIT;
+
+	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
+					kmsg->uaddr, flags);
+	if (force_nonblock && ret == -EAGAIN) {
+		ret = io_setup_async_msg(req, kmsg);
+		if (ret != -EAGAIN)
 			kfree(kbuf);
+		return ret;
 	}
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
+	if (kbuf)
+		kfree(kbuf);
 
 	if (kmsg && kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
+
 	if (ret < 0)
 		req_set_fail_links(req);
 	__io_req_complete(req, ret, cflags, cs);
@@ -4218,51 +4216,50 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 		   struct io_comp_state *cs)
 {
 	struct io_buffer *kbuf = NULL;
+	struct io_sr_msg *sr = &req->sr_msg;
+	struct msghdr msg;
+	void __user *buf = sr->buf;
 	struct socket *sock;
+	struct iovec iov;
+	unsigned flags;
 	int ret, cflags = 0;
 
 	sock = sock_from_file(req->file, &ret);
-	if (sock) {
-		struct io_sr_msg *sr = &req->sr_msg;
-		void __user *buf = sr->buf;
-		struct msghdr msg;
-		struct iovec iov;
-		unsigned flags;
-
-		kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
-		if (IS_ERR(kbuf))
-			return PTR_ERR(kbuf);
-		else if (kbuf)
-			buf = u64_to_user_ptr(kbuf->addr);
+	if (unlikely(!sock))
+		return ret;
 
-		ret = import_single_range(READ, buf, sr->len, &iov,
-						&msg.msg_iter);
-		if (ret) {
-			kfree(kbuf);
-			return ret;
-		}
+	kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
+	if (IS_ERR(kbuf))
+		return PTR_ERR(kbuf);
+	else if (kbuf)
+		buf = u64_to_user_ptr(kbuf->addr);
 
-		req->flags |= REQ_F_NEED_CLEANUP;
-		msg.msg_name = NULL;
-		msg.msg_control = NULL;
-		msg.msg_controllen = 0;
-		msg.msg_namelen = 0;
-		msg.msg_iocb = NULL;
-		msg.msg_flags = 0;
-
-		flags = req->sr_msg.msg_flags;
-		if (flags & MSG_DONTWAIT)
-			req->flags |= REQ_F_NOWAIT;
-		else if (force_nonblock)
-			flags |= MSG_DONTWAIT;
-
-		ret = sock_recvmsg(sock, &msg, flags);
-		if (force_nonblock && ret == -EAGAIN)
-			return -EAGAIN;
-		if (ret == -ERESTARTSYS)
-			ret = -EINTR;
+	ret = import_single_range(READ, buf, sr->len, &iov, &msg.msg_iter);
+	if (unlikely(ret)) {
+		kfree(kbuf);
+		return ret;
 	}
 
+	req->flags |= REQ_F_NEED_CLEANUP;
+	msg.msg_name = NULL;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_namelen = 0;
+	msg.msg_iocb = NULL;
+	msg.msg_flags = 0;
+
+	flags = req->sr_msg.msg_flags;
+	if (flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
+	else if (force_nonblock)
+		flags |= MSG_DONTWAIT;
+
+	ret = sock_recvmsg(sock, &msg, flags);
+	if (force_nonblock && ret == -EAGAIN)
+		return -EAGAIN;
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
+
 	kfree(kbuf);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
-- 
2.24.0

