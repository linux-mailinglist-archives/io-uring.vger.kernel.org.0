Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415DF123DE9
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 04:28:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726609AbfLRD2H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 22:28:07 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:40962 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbfLRD2G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 22:28:06 -0500
Received: by mail-pf1-f194.google.com with SMTP id w62so399628pfw.8
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 19:28:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CIDhRFx911RXCOCxlh1g5dx1iD+gfY13tbr6vP+V9Qo=;
        b=JfGEmHnXZkGBFldCBdJV0o/LlhMsJAwo/mT1ezWnp0LyQPuihmrOvtbp7UoGPK4hy9
         ZhwcqY0WQ8rysrEz940/ALbABHkXaZfUbIfPPnYhcvt63Hw4MeZIauBeGq/8MtsnJdOl
         kqmgPTC9s3ZCGdR7YExqaKAYG0R5DW81849+DfYQfgeltXmF8UXSwslYX2kbbSKxu0Vt
         RFinfekXvMAoWS/VIHQKVNvXqjhwUj4YF50w1nN6/p9PW46sd9t50aay0574Qvx4Qz1o
         aaSeinGaCZEf6FSoh6+XgHJas2vchztvLJDEtEnTdeaEEL9NofViltW8yybaFBTnq7Nq
         7p4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CIDhRFx911RXCOCxlh1g5dx1iD+gfY13tbr6vP+V9Qo=;
        b=ufwcT7rR1u8tjHQ0qOk4GQDMU9pMUn/CBqZCburr6FB5OBk8ieHKEYhUhAlYPysMkC
         Xu/kbqVCDZyLkF/OETxVxd20tX9jQtxOYLZE1AV0lWGNnE2NZTbCmiPN7gDkoaSMA6wU
         2AkF1ax/ph9aYJ5LrWpnrFJD2c3ynQjt/w6qfX2Vue/Orh90w+FbRIm3d4wQoDZnAZcE
         Zq7H99mVIScFvxjdBna8uGRbX94qLWyQsyEolNNGZGZKKX9Yu4mj60FGWCLJ4zrhD8hD
         u11TU4ufXb6xHY1KwQz/E3nkn4G0MLFvFF1/k7jb4oOgmWBRhTvWMgZSXvOkNlSwvqhk
         EwwQ==
X-Gm-Message-State: APjAAAUqnFrvQThgZQmvTVKgvyuuJnid20lTIuS6UszBEIY29Sbu1dOY
        Yv7myLpB98FjWBBdVJ68iuA9LaM2wp92sQ==
X-Google-Smtp-Source: APXvYqwgYiarKlyhT+bfzSsmFrMlQVDQUaNu7YCnJ1rxUlIo9Q8LX4tVZqTSyy7w23gH/CvHFWWcDQ==
X-Received: by 2002:a63:b642:: with SMTP id v2mr383992pgt.126.1576639685224;
        Tue, 17 Dec 2019 19:28:05 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g17sm596323pfb.180.2019.12.17.19.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:28:04 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?q?=E6=9D=8E=E9=80=9A=E6=B4=B2?= <carter.li@eoitek.com>
Subject: [PATCH 02/11] io_uring: fix sporadic -EFAULT from IORING_OP_RECVMSG
Date:   Tue, 17 Dec 2019 20:27:50 -0700
Message-Id: <20191218032759.13587-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218032759.13587-1-axboe@kernel.dk>
References: <20191218032759.13587-1-axboe@kernel.dk>
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

