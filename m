Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2310A21CACE
	for <lists+io-uring@lfdr.de>; Sun, 12 Jul 2020 19:43:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgGLRnC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Jul 2020 13:43:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728882AbgGLRnB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Jul 2020 13:43:01 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B004C08C5DB
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 10:43:01 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id bm28so7260669edb.2
        for <io-uring@vger.kernel.org>; Sun, 12 Jul 2020 10:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tSsLE8uAL+vqf/qk4m7aqo+UZald5576zaDQNejHLYY=;
        b=UgNCjvfh7zWO4VDrHtBJ9rYRP5opzoEllX7aI+IqXixFquwILi9F2zKGXLZpM0nHYV
         +ySwO1hZqfR8FItgidm9pWHCioTBSHBoqvc5nOsMEmwc2rFTc6WlvoLGvZG08X426KsW
         nfb132N7JkIEf9yg4HDFEUYkSauD8G7dhek8eTU5uD+/CPWx6KzxT1xY4yDNT/C9N/6U
         P9g3DY1dzjY3zHsYmQOefVdQZ7j4IoeX0rzZJTKmCHv2FsUn+soHSdigAbZNR7VRBFdS
         jKfmpKmreVhpe4uVS5a89VOMqTUz2BLz3VuBobR3bfBlFI+qTpJOvqxk+Hr6a5D7xdsa
         HlhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tSsLE8uAL+vqf/qk4m7aqo+UZald5576zaDQNejHLYY=;
        b=UONuUrjdOZKfdSJi6UQjS1RYizNqhYtqPFwXxnetWzSte22X5DO36tQc2CDcuzpYCe
         /5QJZkxEqfs6F/jRTx0L6X6WsTIKF1G2/FweGCyj2jFWj7IVvT67fOIiMCI6XCEzT9hB
         Lf9OHgGteZP8j4Qb5W1Ez3yPqtMw8uRQrAUlkiRTofWYlR5mfX84hD+v8AIlB/J1buri
         hGWbEccIW+XN/QbBYgG7gbSur6j7i+OuxG+aHwC2HluXnsuW/3ocVivEvQYhkq7k36MD
         OnA9A2mzfI9cOe8IpaiSk6AZm0nJPkDItpw1ykXKlq+czgIwzPMWuyvGAYYcABn6VuNZ
         vuHA==
X-Gm-Message-State: AOAM532xSrJgD0WGQfa4BZIlTVaUvK85qI356S7LkfEEsWcsbsg0BkZu
        1uvHrFQUeiwizMQdKP7I7gLE51/u
X-Google-Smtp-Source: ABdhPJwHmHqj4bfixJg6rIyhgFYCuuSenD8sSquIOspn7kbuQXtpMH19jtN8IpYe02JtMNz35dYDHA==
X-Received: by 2002:a50:8d5a:: with SMTP id t26mr92264892edt.282.1594575778734;
        Sun, 12 Jul 2020 10:42:58 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id q7sm7957349eja.69.2020.07.12.10.42.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2020 10:42:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: rename sr->msg into umsg
Date:   Sun, 12 Jul 2020 20:41:04 +0300
Message-Id: <8662a169a78ea40d673270c78a7f45edd05bb25e.1594571075.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594571075.git.asml.silence@gmail.com>
References: <cover.1594571075.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Every second field in send/recv is called msg, make it a bit more
understandable by renaming ->msg, which is a user provided ptr,
to ->umsg.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c03e953751cc..2cfcf111f58f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -414,7 +414,7 @@ struct io_connect {
 struct io_sr_msg {
 	struct file			*file;
 	union {
-		struct user_msghdr __user *msg;
+		struct user_msghdr __user *umsg;
 		void __user		*buf;
 	};
 	int				msg_flags;
@@ -3899,7 +3899,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return -EINVAL;
 
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
-	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 
 #ifdef CONFIG_COMPAT
@@ -3915,7 +3915,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	io->msg.msg.msg_name = &io->msg.addr;
 	io->msg.iov = io->msg.fast_iov;
-	ret = sendmsg_copy_msghdr(&io->msg.msg, sr->msg, sr->msg_flags,
+	ret = sendmsg_copy_msghdr(&io->msg.msg, sr->umsg, sr->msg_flags,
 					&io->msg.iov);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
@@ -3948,7 +3948,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 			kmsg->msg.msg_name = &io.msg.addr;
 
 			io.msg.iov = io.msg.fast_iov;
-			ret = sendmsg_copy_msghdr(&io.msg.msg, sr->msg,
+			ret = sendmsg_copy_msghdr(&io.msg.msg, sr->umsg,
 					sr->msg_flags, &io.msg.iov);
 			if (ret)
 				return ret;
@@ -4026,8 +4026,8 @@ static int __io_recvmsg_copy_hdr(struct io_kiocb *req, struct io_async_ctx *io)
 	size_t iov_len;
 	int ret;
 
-	ret = __copy_msghdr_from_user(&io->msg.msg, sr->msg, &io->msg.uaddr,
-					&uiov, &iov_len);
+	ret = __copy_msghdr_from_user(&io->msg.msg, sr->umsg,
+					&io->msg.uaddr, &uiov, &iov_len);
 	if (ret)
 		return ret;
 
@@ -4061,7 +4061,7 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 	compat_size_t len;
 	int ret;
 
-	msg_compat = (struct compat_msghdr __user *) sr->msg;
+	msg_compat = (struct compat_msghdr __user *) sr->umsg;
 	ret = __get_compat_msghdr(&io->msg.msg, msg_compat, &io->msg.uaddr,
 					&ptr, &len);
 	if (ret)
@@ -4138,7 +4138,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 		return -EINVAL;
 
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
-	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 	sr->bgid = READ_ONCE(sqe->buf_group);
 
@@ -4203,7 +4203,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 		else if (force_nonblock)
 			flags |= MSG_DONTWAIT;
 
-		ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.msg,
+		ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
 						kmsg->uaddr, flags);
 		if (force_nonblock && ret == -EAGAIN)
 			return io_setup_async_msg(req, kmsg);
-- 
2.24.0

