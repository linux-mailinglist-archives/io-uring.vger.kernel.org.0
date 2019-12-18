Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0720B124EEA
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbfLRRSq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:46 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:36690 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:46 -0500
Received: by mail-io1-f66.google.com with SMTP id r13so2793756ioa.3
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CIDhRFx911RXCOCxlh1g5dx1iD+gfY13tbr6vP+V9Qo=;
        b=fUiE9F6Y+6XRffzLhFmQwIMQrtgHDP0I+6zsE9TNAXGYvgV8L4c2sdFLPnTy8f5MdS
         IxoF9Qp2Nha88gerEKK1tHQfPsTKmlixUd52JNbJx2ZaUhAkEIFfRfSTN66S0rPwL+DM
         rDLiVGdznzpcX0lkG9IzsqgKFHqlgV6JpSIuV5X56C5DKoYqLHQHQYzTeQx0PEHrbP2J
         BB5KHkYTbYUZsgx8Gixq6SCh8DzpZtMSTKl796sTVvyANNHWXVo+uPTjH3YpB5JI76gO
         46yIJVwtmLutIEciXy+5FjdX5223DP9VRSjC+6G/fYdSMWfjRKubF5NMC8suack4OGtb
         c8Ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CIDhRFx911RXCOCxlh1g5dx1iD+gfY13tbr6vP+V9Qo=;
        b=TL7Ei5viBUn/9WWZtwRxCeGyvVTpWDwASfHWhr/SJF+qdp3IF/diMcfx1vYSl5SG3X
         Mzn9G3nKV9OhzQAb1+6SgWH6syX7A7el1S2xCuKC6CilZCV/Oj8TGykA4LKO2TZ3vY2X
         yq8G6QppPMocxi9ISCQsldP2KzKSMPseckekcp9z0M1iO4QpQ0I8myPWD1s5yM6UXH8P
         dPiYNEH9yDd7JGeVDC2rBiFv1mWM3ojAycPXfyNe+SDC1PPCGikIfIGibh+JNxGzpGaZ
         yhYUwprVhiufrq7zMFqMTiO2PiA+7hGUIA3+xXS6n+bWjAG7ISohXBh7sV5zD7OUA1kY
         rdaA==
X-Gm-Message-State: APjAAAWwpcytDofOadk1+dOpqQbxgl+2wdwQdg9Y3ejI9DPPihcfGi0P
        tNuOomz6IGlDrmcbw5NDJ1GwrOzIppFOWA==
X-Google-Smtp-Source: APXvYqxdYZp5la3i96GtDZk7yEFsg4UQPaIFIdWov5H+WGIRxEIUyOBKEp4/gikEIiRsPWvx0Kv1iw==
X-Received: by 2002:a5e:dd08:: with SMTP id t8mr2469076iop.151.1576689524838;
        Wed, 18 Dec 2019 09:18:44 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:44 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?q?=E6=9D=8E=E9=80=9A=E6=B4=B2?= <carter.li@eoitek.com>
Subject: [PATCH 02/13] io_uring: fix sporadic -EFAULT from IORING_OP_RECVMSG
Date:   Wed, 18 Dec 2019 10:18:24 -0700
Message-Id: <20191218171835.13315-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218171835.13315-1-axboe@kernel.dk>
References: <20191218171835.13315-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we have to punt the recvmsg to async context, we copy all the
context.  But since the iovec used can be either on-stack (if small) or
dynamically allocated, if it's on-stack, then we need to ensure we reset
the iov pointer. If we don't, then we're reusing old stack data, and
that can lead to -EFAULTs if things get overwritten.

Ensure we retain the right pointers for the iov, and free it as well if
we end up having to go beyond UIO_FASTIOV number of vectors.

Fixes: 03b1230ca12a ("io_uring: ensure async punted sendmsg/recvmsg requests copy data")
Reported-by: 李通洲 <carter.li@eoitek.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 04cff3870b3b..0e01cdc8a120 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2041,6 +2041,7 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		      struct io_kiocb **nxt, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
+	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
 	int ret;
 
@@ -2051,7 +2052,6 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (sock) {
 		struct io_async_ctx io, *copy;
 		struct sockaddr_storage addr;
-		struct msghdr *kmsg;
 		unsigned flags;
 
 		flags = READ_ONCE(sqe->msg_flags);
@@ -2061,17 +2061,21 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			flags |= MSG_DONTWAIT;
 
 		if (req->io) {
-			kmsg = &req->io->msg.msg;
-			kmsg->msg_name = &addr;
+			kmsg = &req->io->msg;
+			kmsg->msg.msg_name = &addr;
+			/* if iov is set, it's allocated already */
+			if (!kmsg->iov)
+				kmsg->iov = kmsg->fast_iov;
+			kmsg->msg.msg_iter.iov = kmsg->iov;
 		} else {
-			kmsg = &io.msg.msg;
-			kmsg->msg_name = &addr;
+			kmsg = &io.msg;
+			kmsg->msg.msg_name = &addr;
 			ret = io_sendmsg_prep(req, &io);
 			if (ret)
 				goto out;
 		}
 
-		ret = __sys_sendmsg_sock(sock, kmsg, flags);
+		ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
 		if (force_nonblock && ret == -EAGAIN) {
 			copy = kmalloc(sizeof(*copy), GFP_KERNEL);
 			if (!copy) {
@@ -2082,13 +2086,15 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			req->io = copy;
 			memcpy(&req->io->sqe, req->sqe, sizeof(*req->sqe));
 			req->sqe = &req->io->sqe;
-			return ret;
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 	}
 
 out:
+	if (kmsg && kmsg->iov != kmsg->fast_iov)
+		kfree(kmsg->iov);
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -2120,6 +2126,7 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		      struct io_kiocb **nxt, bool force_nonblock)
 {
 #if defined(CONFIG_NET)
+	struct io_async_msghdr *kmsg = NULL;
 	struct socket *sock;
 	int ret;
 
@@ -2131,7 +2138,6 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		struct user_msghdr __user *msg;
 		struct io_async_ctx io, *copy;
 		struct sockaddr_storage addr;
-		struct msghdr *kmsg;
 		unsigned flags;
 
 		flags = READ_ONCE(sqe->msg_flags);
@@ -2143,17 +2149,21 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		msg = (struct user_msghdr __user *) (unsigned long)
 			READ_ONCE(sqe->addr);
 		if (req->io) {
-			kmsg = &req->io->msg.msg;
-			kmsg->msg_name = &addr;
+			kmsg = &req->io->msg;
+			kmsg->msg.msg_name = &addr;
+			/* if iov is set, it's allocated already */
+			if (!kmsg->iov)
+				kmsg->iov = kmsg->fast_iov;
+			kmsg->msg.msg_iter.iov = kmsg->iov;
 		} else {
-			kmsg = &io.msg.msg;
-			kmsg->msg_name = &addr;
+			kmsg = &io.msg;
+			kmsg->msg.msg_name = &addr;
 			ret = io_recvmsg_prep(req, &io);
 			if (ret)
 				goto out;
 		}
 
-		ret = __sys_recvmsg_sock(sock, kmsg, msg, io.msg.uaddr, flags);
+		ret = __sys_recvmsg_sock(sock, &kmsg->msg, msg, kmsg->uaddr, flags);
 		if (force_nonblock && ret == -EAGAIN) {
 			copy = kmalloc(sizeof(*copy), GFP_KERNEL);
 			if (!copy) {
@@ -2164,13 +2174,15 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			req->io = copy;
 			memcpy(&req->io->sqe, req->sqe, sizeof(*req->sqe));
 			req->sqe = &req->io->sqe;
-			return ret;
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 	}
 
 out:
+	if (kmsg && kmsg->iov != kmsg->fast_iov)
+		kfree(kmsg->iov);
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);
-- 
2.24.1

