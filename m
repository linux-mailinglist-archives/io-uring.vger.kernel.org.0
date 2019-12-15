Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8869411FA37
	for <lists+io-uring@lfdr.de>; Sun, 15 Dec 2019 18:57:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726462AbfLOR51 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Dec 2019 12:57:27 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:46378 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbfLOR51 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Dec 2019 12:57:27 -0500
Received: by mail-pl1-f196.google.com with SMTP id k20so3442797pll.13
        for <io-uring@vger.kernel.org>; Sun, 15 Dec 2019 09:57:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=xd6vfRkbZFmt69Uugb7eY2nTE2q/25IjTrsgzh56UAQ=;
        b=YisB5zoYDBWMhkwn7ltJtubN3eqZUyLD9Xb7DGpL7CWxHwk6rsDGdWlg1h077JU5AG
         ZZGnlQNgv+2B9iG981RMg7ditgEujg/l0dIYeM9BoinXFgljKWuUmrNY6Hl2cvMCBS9P
         kDH5ivBGZz7URhYlk3SZWiTEjRep5GybeZ5RoWJlP3G09ZpaoREjlJpXqqkeE0ByFknv
         L6OvLNSqOJ+F4Qb4m8ESLnub+VAA6RoFouhWKVFnXz90Wdbh+ecFEIqOsI597Gpo5vcO
         uj7E7jP4UzT4V2FZhY+F7E08/VEzZ9CW8CCXuC5auVqhK7xrz/UBRMwK9y66SOzjnC0g
         w+6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=xd6vfRkbZFmt69Uugb7eY2nTE2q/25IjTrsgzh56UAQ=;
        b=riqd5Mni6RnXTOQzTolChI+LH4ghC/UybCbf7hGLun5KuwYGaOOD3ZAL+hoBSwT+7u
         a5d/QLfOsNOdjk+iTiOiU81RJhKTnvgeqNKl3wkMGvwOC9ODpRNwuhZw8d1OCze/Af8l
         zGWIghpQoXIwp0Fn+m/SDpHjuEfnqQTkuoUBECt0hiUpehMVmQXNjPcCVSw55yTur8ff
         skUOqRB66HV3I56kjPtWY64HuAevM3FHDSvsjoCRgGo8vCH6QxDtYFMvI+5yyyRbt8XU
         e1AxGFdzhFx1c16+zlRnadiiFgGTfe3OzV+H3eOLxBVkDqQqrZJgtixzclaJFDAUlehW
         3WlA==
X-Gm-Message-State: APjAAAXnxwTCLCw/jufOINnvH6XQ3wHGstW73XX0w5qiF8N/87etocaU
        pqNYZ24i5sseRJLOkTtqetH/OoHLHgQRcg==
X-Google-Smtp-Source: APXvYqwBXfN/Cb00/fjNPnJttyASo5xxqf2xupkQE8ObuMtR51uLfgTMwcnkTsRONnaBCFRS69nfZA==
X-Received: by 2002:a17:902:b40b:: with SMTP id x11mr11636456plr.26.1576432646509;
        Sun, 15 Dec 2019 09:57:26 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id e23sm16305884pjt.23.2019.12.15.09.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Dec 2019 09:57:25 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
Cc:     =?UTF-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix sporadic -EFAULT from IORING_OP_RECMSG
Message-ID: <b07ded3f-161d-1377-565f-634211857d58@kernel.dk>
Date:   Sun, 15 Dec 2019 10:57:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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


diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2fff83a3878f..4424c5d7a3a1 100644
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
+			if (!req->io->msg.iov)
+				req->io->msg.iov = req->io->msg.fast_iov;
+			kmsg->msg.msg_iter.iov = req->io->msg.iov;
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
@@ -2089,6 +2093,8 @@ static int io_sendmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
+			if (!req->io->msg.iov)
+				req->io->msg.iov = req->io->msg.fast_iov;
+			kmsg->msg.msg_iter.iov = req->io->msg.iov;
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
@@ -2171,6 +2181,8 @@ static int io_recvmsg(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	}
 
 out:
+	if (kmsg && kmsg->iov != kmsg->fast_iov)
+		kfree(kmsg->iov);
 	io_cqring_add_event(req, ret);
 	if (ret < 0)
 		req_set_fail_links(req);

-- 
Jens Axboe

				
