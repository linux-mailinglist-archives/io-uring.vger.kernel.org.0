Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D444F1731DF
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 08:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgB1Hhj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 02:37:39 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53289 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgB1Hhj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 02:37:39 -0500
Received: by mail-wm1-f67.google.com with SMTP id f15so2106153wml.3
        for <io-uring@vger.kernel.org>; Thu, 27 Feb 2020 23:37:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gTJq2R+RPdOK0unduC0Zj1wjuF/VAgjU3f6PFOI+S+c=;
        b=qKxclnpUT6SzMk/mqtpQ4wu4Gm3mfRCES4PWdwqJd3/YYjdpAhaVt1frbD8Usvv4Hc
         H/mf7pk1S7Lwg5VRaJfqQ+AjpZkd4wZTBaspsLSYkOHGxgYuKEKz0HIjjOLd0vJBqazk
         o38JOIz2wwcyx2jyKQSI//o9y6g3xKuj5jRMfG6UkzE9pg0bIjzl8zFjS8GPvFlnC9mt
         pWQyt/VbDuds+ca9bA7m9XxXH1ooqUUVnXExve6Fn6t/elmYKMBI7wP56sEBqM+XWm4r
         TRRRy6bBaelz1aTNutdrgbecHVGVZHXXdL7L5xP/l2a2coUBpnzKdLabZv0yl1Ho3qeF
         YgEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gTJq2R+RPdOK0unduC0Zj1wjuF/VAgjU3f6PFOI+S+c=;
        b=fk4y7zwUZfnY4m5w9LlXPJgwa0Ya1F/8gjJ+Rzvrtqn9hkzvwu26fknyOHHbS79uZV
         A1syp1MjPBstM5HGkOhD8R0smmnZOeFDulu+KAjk5s4RgVLkXvMKvgLzaLb1pkDyaxgE
         CRZLdis+NjOo0hqQfHwIlJ2KchokWLl+omqukDdAzmLRTjY75pryRbe/XtFRlIHGqNlv
         J9WnC1ZghUEzF6+NTHQFQAYOmS35NFWrOxSonRc99BzRWl/NuhYF3e44ZsiHXkmuShrY
         7Zjh6dXca0BMxoMXjg2F316CFDLYXDtDtfH2fFnQ5WuMD1942Yq4Nfs/1iuh1a05mq3u
         Byxw==
X-Gm-Message-State: APjAAAUc4Z/FQDoiYSBBXGp9hX2xANp0W+o+5wxRBCkVbqrVXVDc+5j9
        CKrFdCkDFGsTNyV1w+QKGGJ3Dgb0
X-Google-Smtp-Source: APXvYqzICY2LJCTlTQK/bi+vy9yZqEUS4PN6f+dG4+4nn0E0AGtLGPB2j0ZOaVjrov8zopWi5VFM5A==
X-Received: by 2002:a05:600c:104d:: with SMTP id 13mr3400261wmx.50.1582875457410;
        Thu, 27 Feb 2020 23:37:37 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id h2sm11369425wrt.45.2020.02.27.23.37.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 23:37:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/5] io_uring: extract kmsg copy helper
Date:   Fri, 28 Feb 2020 10:36:36 +0300
Message-Id: <ccede93132846d07c91b2663cb641d5024479ae1.1582874853.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582874853.git.asml.silence@gmail.com>
References: <cover.1582874853.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_recvmsg() and io_sendmsg() duplicate nonblock -EAGAIN finilising
part, so add helper for that.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 87dfe397de74..a32a195407ac 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3099,6 +3099,21 @@ static int io_sync_file_range(struct io_kiocb *req, struct io_kiocb **nxt,
 	return 0;
 }
 
+static int io_setup_async_msg(struct io_kiocb *req,
+			      struct io_async_msghdr *kmsg)
+{
+	if (req->io)
+		return -EAGAIN;
+	if (io_alloc_async_ctx(req)) {
+		if (kmsg->iov != kmsg->fast_iov)
+			kfree(kmsg->iov);
+		return -ENOMEM;
+	}
+	req->flags |= REQ_F_NEED_CLEANUP;
+	memcpy(&req->io->msg, kmsg, sizeof(*kmsg));
+	return -EAGAIN;
+}
+
 static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 #if defined(CONFIG_NET)
@@ -3170,18 +3185,8 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 			flags |= MSG_DONTWAIT;
 
 		ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
-		if (force_nonblock && ret == -EAGAIN) {
-			if (req->io)
-				return -EAGAIN;
-			if (io_alloc_async_ctx(req)) {
-				if (kmsg->iov != kmsg->fast_iov)
-					kfree(kmsg->iov);
-				return -ENOMEM;
-			}
-			req->flags |= REQ_F_NEED_CLEANUP;
-			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
-			return -EAGAIN;
-		}
+		if (force_nonblock && ret == -EAGAIN)
+			return io_setup_async_msg(req, kmsg);
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 	}
@@ -3324,18 +3329,8 @@ static int io_recvmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 
 		ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.msg,
 						kmsg->uaddr, flags);
-		if (force_nonblock && ret == -EAGAIN) {
-			if (req->io)
-				return -EAGAIN;
-			if (io_alloc_async_ctx(req)) {
-				if (kmsg->iov != kmsg->fast_iov)
-					kfree(kmsg->iov);
-				return -ENOMEM;
-			}
-			memcpy(&req->io->msg, &io.msg, sizeof(io.msg));
-			req->flags |= REQ_F_NEED_CLEANUP;
-			return -EAGAIN;
-		}
+		if (force_nonblock && ret == -EAGAIN)
+			return io_setup_async_msg(req, kmsg);
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 	}
-- 
2.24.0

