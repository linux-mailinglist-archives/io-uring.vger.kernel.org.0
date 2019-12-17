Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 141CD123A4C
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2019 23:54:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbfLQWyv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 17:54:51 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44088 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLQWyv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 17:54:51 -0500
Received: by mail-pg1-f193.google.com with SMTP id x7so103132pgl.11
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 14:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CIDhRFx911RXCOCxlh1g5dx1iD+gfY13tbr6vP+V9Qo=;
        b=SmDkeFVpVQkALA9JSKud49+bjTYjKOMAbnRISylGXvQQwzVQ7Bylvo8JXLYlCe7igj
         wd57jBKATvASYsYcYr+IlI5gxFp1EX4zFaua+mK8aLTWhGacEEnjoGwpuxvUrmEwkT0o
         fxvuS8al2MaBwRGxI7ycLtAkxtsH6OoVkw74kr86b7ElBYs6n2CSmIOLbipHfNTZTW0Y
         nzILWosXG6kJB7Fn+zlsQBATue2kNaVg4fIZoV2/qDF4fWFVIOzBk1Mqtw2rd+cNH4U4
         TeJAViQyA/ZX6zcX0hliUrQUSbHDj8KqvjJBGdj8Sbe9jjdkFyuktXfDagfVIq6JqKEv
         kiig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CIDhRFx911RXCOCxlh1g5dx1iD+gfY13tbr6vP+V9Qo=;
        b=SWWta+ep6PAyGBHdX+YDh137LfV3SM1L2r83gfO1KImM+6DvOIqRhIZWB/8O0HYMkn
         JIBvSytd/+HZFcGbHefJ79R33bSNWIb/RDh4+nqDig6cL/dO3/Kb2T/wVne8IlS82v/c
         +blEDYhYhsN8vCLliNkqH1yiNvgAQQAOg6bQevhBDwKSeLsMTLAHxS6lFTAb0gDi8fmp
         TBwuTtF5qyjSH4lZfXiVfnl2ILNOtsQ7ZJaaLlMsSLK94SNFhGxfU79cSFdYDrxJJDlj
         EOwa1tIoxZ/FsTJoOjkRiMwseB1rlqPdGf+k++3nlzS7+LeymNv4sLOUgowwH2VvjAB0
         m2oQ==
X-Gm-Message-State: APjAAAUWbdTCsa/GsODxYiRxnSP6BTDwF2uZna7S1bUqsI8Y0JmJbcMH
        5x6GPNtYw0YXJ3ofecZsP8dl5f0quR2uiA==
X-Google-Smtp-Source: APXvYqyVMOMH9cKbKVMF1XF32LEB7jX5BkfP86DretsuUFOWwmtRKMywC+4PNt5v2yomMJsil3jSVQ==
X-Received: by 2002:a63:1106:: with SMTP id g6mr27879151pgl.13.1576623290075;
        Tue, 17 Dec 2019 14:54:50 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e188sm59320pfe.113.2019.12.17.14.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 14:54:49 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        =?UTF-8?q?=E6=9D=8E=E9=80=9A=E6=B4=B2?= <carter.li@eoitek.com>
Subject: [PATCH 2/7] io_uring: fix sporadic -EFAULT from IORING_OP_RECVMSG
Date:   Tue, 17 Dec 2019 15:54:40 -0700
Message-Id: <20191217225445.10739-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191217225445.10739-1-axboe@kernel.dk>
References: <20191217225445.10739-1-axboe@kernel.dk>
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

