Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 757962B335C
	for <lists+io-uring@lfdr.de>; Sun, 15 Nov 2020 11:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgKOKUg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 05:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgKOKUf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 05:20:35 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FEB7C0613D1
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:20:35 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id h21so176076wmb.2
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=JCMn+ro68Jqn5dvx/7sXkBfDAhSUJw518U2ThD6HAAM=;
        b=SA/HCNcz8gEZ/Srw8MG7e9oEV4ySmIwMfRihjtXPH6RF6biLFd/8NuJcj6w6PbXJ3/
         uX5dlyBD6ps18yVelclwZp6BpBbkh+kbZMU7fsM+zjDdmPULPNVIXLjf/33X2+yAlbtZ
         IOOGH+CdAVjxl5Ta8tLVBGFujalH4bw8tIA0ZKeNAWwTY7qwXQBkY2aR2UHCKDj/X9a9
         T0l371ySnDSP4BPDex9MlRKNkc9PVutPZV3b4J2vr4xn71n9W7G6nOPErsREd9wxTCFY
         aKhqnkpK1390lhc/lvrSOmwstP92A4HH1A9DP2aS+SWjJtvYFgxPNcecuSLuYd3JBbnm
         m0gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=JCMn+ro68Jqn5dvx/7sXkBfDAhSUJw518U2ThD6HAAM=;
        b=geADyXxKCM8mR75IzPW4ZAk0WCZjipvl7qyNVsYZGjwS8mH5WWdEVp+Day4mbAeF/s
         Oy9VJrCMXYhzoGlnXrF/3WD62eWxhQKKiH/6tU0O2p/ohFgIUTUB68zt7bi4KEESLVJA
         snU1ha8vQLSFgdO1ttfVuNcW9KD1wbmBT9NlfRUpZW2N09cHn5nc7MXdmiQgtB3iksgx
         VkXr1wJQny9OeBXpaFctXPuhCDdiUtzv8ejwFYhCyAqZPcLqfAqDRCYFvgyVXRrVt5VZ
         F7Ri6Gntj/FLuDOyeNdZDF3H4jyb+Kbr4isMICMI1rmHZ4y6BqEWB0nFzwyZ8OKPBs8A
         0D6Q==
X-Gm-Message-State: AOAM531kU6Xm+AC7nB6h3ycPUwTnlQRwqJea+gHwebqQIn+IpTwDXyiY
        vAYW2QruN+oM4vPzQA/6+jU=
X-Google-Smtp-Source: ABdhPJyszqBSodIpjVAFgXYpEFigMiS+c66FkYEEjwMoy/TVbC6VrBCIRUrUgC0ieWTFsjkgPdLgeA==
X-Received: by 2002:a7b:c2f7:: with SMTP id e23mr10419683wmk.100.1605435634263;
        Sun, 15 Nov 2020 02:20:34 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id b14sm17746961wrs.46.2020.11.15.02.20.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 02:20:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/2] io_uring: setup iter for recv BUFFER_SELECT once
Date:   Sun, 15 Nov 2020 10:17:18 +0000
Message-Id: <daee149a3305d0a6a018a92cd6ed0f0f3f6cbf12.1605434816.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1605434816.git.asml.silence@gmail.com>
References: <cover.1605434816.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of initialising msg.msg_iter with a selected buffer in
io_recv_msg() every time, do it once in io_recvmsg_copy_hdr(). Further
it may be copied into another msg but that's fine as
io_setup_async_msg() handles iovs copy.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 53 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 02811c90f711..aafdcf94be9d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4689,20 +4689,6 @@ static int __io_compat_recvmsg_copy_hdr(struct io_kiocb *req,
 }
 #endif
 
-static int io_recvmsg_copy_hdr(struct io_kiocb *req,
-			       struct io_async_msghdr *iomsg)
-{
-	iomsg->msg.msg_name = &iomsg->addr;
-	iomsg->iov = iomsg->fast_iov;
-
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
-		return __io_compat_recvmsg_copy_hdr(req, iomsg);
-#endif
-
-	return __io_recvmsg_copy_hdr(req, iomsg);
-}
-
 static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
 					       bool needs_lock)
 {
@@ -4718,6 +4704,35 @@ static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
 	return kbuf;
 }
 
+static int io_recvmsg_copy_hdr(struct io_kiocb *req,
+			       struct io_async_msghdr *iomsg)
+{
+	struct io_buffer *kbuf;
+	int ret;
+
+	iomsg->msg.msg_name = &iomsg->addr;
+	iomsg->iov = iomsg->fast_iov;
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		ret = __io_compat_recvmsg_copy_hdr(req, iomsg);
+	else
+#endif
+		ret = __io_recvmsg_copy_hdr(req, iomsg);
+	if (ret < 0)
+		return ret;
+
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		/* init is always done with uring_lock held */
+		kbuf = io_recv_buffer_select(req, false);
+		if (IS_ERR(kbuf))
+			return PTR_ERR(kbuf);
+		iomsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
+		iov_iter_init(&iomsg->msg.msg_iter, READ, iomsg->fast_iov, 1,
+			      req->sr_msg.len);
+	}
+	return 0;
+}
+
 static inline unsigned int io_put_recv_kbuf(struct io_kiocb *req)
 {
 	return io_put_kbuf(req, req->sr_msg.kbuf);
@@ -4756,7 +4771,6 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 {
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
-	struct io_buffer *kbuf;
 	unsigned flags;
 	int ret, cflags = 0;
 
@@ -4772,15 +4786,6 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 		kmsg = &iomsg;
 	}
 
-	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_recv_buffer_select(req, !force_nonblock);
-		if (IS_ERR(kbuf))
-			return PTR_ERR(kbuf);
-		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
-		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov,
-				1, req->sr_msg.len);
-	}
-
 	flags = req->sr_msg.msg_flags;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
-- 
2.24.0

