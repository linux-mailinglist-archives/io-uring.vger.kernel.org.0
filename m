Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E824F4598F9
	for <lists+io-uring@lfdr.de>; Tue, 23 Nov 2021 01:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhKWALr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Nov 2021 19:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230428AbhKWALp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Nov 2021 19:11:45 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84BE2C061714
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 16:08:38 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id k37-20020a05600c1ca500b00330cb84834fso622669wms.2
        for <io-uring@vger.kernel.org>; Mon, 22 Nov 2021 16:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+ZVcjP0QOeqt4MydnzX75hIx+Vtu8B0/yTPrVTrRJ5k=;
        b=fJJCCjoiccxFkbMP+stvNHlGanmz+HX2xf5XqySIVkt3zq3Ndkt3uCDlPdYfNY3iOx
         A/gC0m39+A7aF1AdjcvrZMHBkTHwN7hOYg3zEUnj3awTG10fD/lQX17FdoF8QTqCVDNL
         5RD2tClfxYkKTpq2VxwV3K5p8pdOiuanSdn/LeFPsyIRl1xwU2+ccoInS8dICBRwmypS
         +hCl1rEIUXOl/lhENR37PpT+SQsc2ZvQpUt80aUtajk+eluFP6WuOo5A3Ybqs2In8d+o
         Tjl9STCZQtH19J3NJ78TCeVWS1YvItXRB6Y/HprQn6b1mC3g+XHTdODBs+rYlfxAnGfW
         TMow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+ZVcjP0QOeqt4MydnzX75hIx+Vtu8B0/yTPrVTrRJ5k=;
        b=SOMSpH3UoH6njSyUMLY9V9oWt4xLbr7slR1gA7T21TMcK6hJ/7eJxtqLIL1LS8k1Mo
         EeQ1Q2kM5NEzGQfOkCfFBJOFt9XcjhVfLycfkEsUcpWCNuknv/c3SelAW3C0MRQhR5hd
         PdWBZdzelcqt1xceJ5ewNMB4VO5fy2lUiC2vwIf5bdZ9CHc8+NDJ7pcaqLg8CSsm5ZsM
         P1oCjBnJy2aW+lmCN4dyq+NT4PJGWTf9SQI8TAW1m1tHlZ34UpMFFAUibyxhmc/PAY7v
         k6137DOp0PbF4TNCBpo6hjJhG2I7cA8syAhnNAuK6CYyB0aZW6yPS72GA8GhSvfiboDO
         KEUw==
X-Gm-Message-State: AOAM531tHbkKvsVDFobEUOlPk4zXd5U3xswvuCRTGED9aTOQCnKoejJX
        myuGkSU0RspqAZAK+YbA4q/EQbJYqgk=
X-Google-Smtp-Source: ABdhPJw+4C2Vw7/Ep3cffAcF7ykFW4aY3L+Xuo21D7BDmhzt9ezKhUn6n/7jhJW0osOagzW0WLouVQ==
X-Received: by 2002:a05:600c:2e46:: with SMTP id q6mr1579755wmf.6.1637626116936;
        Mon, 22 Nov 2021 16:08:36 -0800 (PST)
Received: from 127.0.0.1localhost ([185.69.145.196])
        by smtp.gmail.com with ESMTPSA id r62sm10139409wmr.35.2021.11.22.16.08.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 16:08:36 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 2/4] io_uring: improve send/recv error handling
Date:   Tue, 23 Nov 2021 00:07:47 +0000
Message-Id: <5761545158a12968f3caf30f747eea65ed75dfc1.1637524285.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1637524285.git.asml.silence@gmail.com>
References: <cover.1637524285.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hide all error handling under common if block, removes two extra ifs on
the success path and keeps the handling more condensed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 55 +++++++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e4f3ac35e447..8932c4ce70b9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4788,17 +4788,18 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
 	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
-	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
-		return io_setup_async_msg(req, kmsg);
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
 
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return io_setup_async_msg(req, kmsg);
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail(req);
+	}
 	/* fast path, check for non-NULL to avoid function call */
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < min_ret)
-		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -4834,13 +4835,13 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 
 	msg.msg_flags = flags;
 	ret = sock_sendmsg(sock, &msg);
-	if ((issue_flags & IO_URING_F_NONBLOCK) && ret == -EAGAIN)
-		return -EAGAIN;
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
-
-	if (ret < min_ret)
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return -EAGAIN;
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
 		req_set_fail(req);
+	}
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -5017,10 +5018,15 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
 					kmsg->uaddr, flags);
-	if (force_nonblock && ret == -EAGAIN)
-		return io_setup_async_msg(req, kmsg);
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && force_nonblock)
+			return io_setup_async_msg(req, kmsg);
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail(req);
+	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
+		req_set_fail(req);
+	}
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
@@ -5028,8 +5034,6 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < min_ret || ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
-		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
 }
@@ -5076,15 +5080,18 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
 	ret = sock_recvmsg(sock, &msg, flags);
-	if (force_nonblock && ret == -EAGAIN)
-		return -EAGAIN;
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
 out_free:
+	if (ret < min_ret) {
+		if (ret == -EAGAIN && force_nonblock)
+			return -EAGAIN;
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail(req);
+	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
+		req_set_fail(req);
+	}
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
-	if (ret < min_ret || ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))))
-		req_set_fail(req);
 	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
 }
-- 
2.33.1

