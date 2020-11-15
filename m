Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505522B33C1
	for <lists+io-uring@lfdr.de>; Sun, 15 Nov 2020 11:41:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727061AbgKOKjQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 05:39:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbgKOKjD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 05:39:03 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0865C0613D2
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:39:02 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id a65so20993408wme.1
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=mkmZ6PjDuAZm2gJTJZcjv7CpqH0dKGh730A+nn7eHiU=;
        b=I/bHNPXKz/WRJVrr/yEI02IMGaoEyq+0IvdCItiis+twg3PP9QADieZMMNeD4CWao4
         lMNDpdfc+HVGDV9Hgq0poWqcxCYIkqqEykhPfhQwkmvc36mPNW2rVP45iq8QnyKYgV8o
         ElU5tBwWhAEiyrVaA0kZIwbRnWWWu7tzKHNlfpfhY7oZsBPxF3iTM2kCtc5vfWjKgXI+
         Nt4m6KdVJjmezgKMoXxLsxBOBWOuFQjfQ1+sy1PmCOBWC+uYgLZ7eiOdEppB0BbcSGZA
         PnccirGrsUYeI4LbbsQrRTXAkU3bDLaIXCZTUtUcf7YXJUarfXaGq4gViaDC4tL6wWyj
         2x9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mkmZ6PjDuAZm2gJTJZcjv7CpqH0dKGh730A+nn7eHiU=;
        b=BCwi/0INJFr/JgbMDtzXeWYcxKxd4HNLsJPNKZ+ifhoM0+1mCSzj722nE8KcUbxbIs
         spmF0NYYfqF/bfhWFcwxAzGoKrnoGhin/E2ZhGgktcUi4fif5Uul1lUMaOMLk9gQQ3iw
         5mlbBIDCq1ZDHvW+Pw+duKcxZG2pdnJzENdQlVNscg/mzMDr8jwbpGvu7U2N68laxIfX
         x/Nyd3fPg6VMLVlztLlFZytMWXsDLBX97Gq8FUsPB6zsZ9tn3MEKwApxfF+QX3QOXxrw
         yxhJT7G6W5bYJc9pLIDJLuimyNFcuO+zVFpNqh+DCrShw2lc5JA1FHfyDu1eX6EEVGzh
         Li+Q==
X-Gm-Message-State: AOAM530zO3o0qXzzkm4DvF7X8S+NI6163+58/2qUOjSW3LK4neXIYc7/
        yurkf1ZqiJCyBUO42Pxs76FZvzw/RhI=
X-Google-Smtp-Source: ABdhPJyv9TTpC5cRXplP2K7vtb3jDuXkjPrUYYxTVliAztWynygycFqQuwYKvywgohm3GE28uH8hJA==
X-Received: by 2002:a1c:2b03:: with SMTP id r3mr9987551wmr.184.1605436741612;
        Sun, 15 Nov 2020 02:39:01 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id b14sm17790900wrs.46.2020.11.15.02.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 02:39:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        v@nametag.social
Subject: [PATCH 1/5] io_uring: move io_recvmsg_copy_hdr()
Date:   Sun, 15 Nov 2020 10:35:40 +0000
Message-Id: <68847b7e994a1ea94492d0ab83657fa1881c824a.1605435507.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1605435507.git.asml.silence@gmail.com>
References: <cover.1605435507.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move io_recvmsg_copy_hdr() for it to be reused in later patches.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 238 +++++++++++++++++++++++++-------------------------
 1 file changed, 119 insertions(+), 119 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aafdcf94be9d..bcd6f63af711 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4494,125 +4494,6 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	return -EAGAIN;
 }
 
-static int io_sendmsg_copy_hdr(struct io_kiocb *req,
-			       struct io_async_msghdr *iomsg)
-{
-	iomsg->iov = iomsg->fast_iov;
-	iomsg->msg.msg_name = &iomsg->addr;
-	return sendmsg_copy_msghdr(&iomsg->msg, req->sr_msg.umsg,
-				   req->sr_msg.msg_flags, &iomsg->iov);
-}
-
-static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-{
-	struct io_async_msghdr *async_msg = req->async_data;
-	struct io_sr_msg *sr = &req->sr_msg;
-	int ret;
-
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
-	sr->msg_flags = READ_ONCE(sqe->msg_flags);
-	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
-	sr->len = READ_ONCE(sqe->len);
-
-#ifdef CONFIG_COMPAT
-	if (req->ctx->compat)
-		sr->msg_flags |= MSG_CMSG_COMPAT;
-#endif
-
-	if (!async_msg || !io_op_defs[req->opcode].needs_async_data)
-		return 0;
-	ret = io_sendmsg_copy_hdr(req, async_msg);
-	if (!ret)
-		req->flags |= REQ_F_NEED_CLEANUP;
-	return ret;
-}
-
-static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
-		      struct io_comp_state *cs)
-{
-	struct io_async_msghdr iomsg, *kmsg;
-	struct socket *sock;
-	unsigned flags;
-	int ret;
-
-	sock = sock_from_file(req->file, &ret);
-	if (unlikely(!sock))
-		return ret;
-
-	kmsg = req->async_data;
-	if (!kmsg) {
-		ret = io_sendmsg_copy_hdr(req, &iomsg);
-		if (ret)
-			return ret;
-		kmsg = &iomsg;
-	}
-
-	flags = req->sr_msg.msg_flags;
-	if (flags & MSG_DONTWAIT)
-		req->flags |= REQ_F_NOWAIT;
-	else if (force_nonblock)
-		flags |= MSG_DONTWAIT;
-
-	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
-	if (force_nonblock && ret == -EAGAIN)
-		return io_setup_async_msg(req, kmsg);
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
-
-	/* it's reportedly faster to check for null here */
-	if (kmsg->iov)
-		kfree(kmsg->iov);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	if (ret < 0)
-		req_set_fail_links(req);
-	__io_req_complete(req, ret, 0, cs);
-	return 0;
-}
-
-static int io_send(struct io_kiocb *req, bool force_nonblock,
-		   struct io_comp_state *cs)
-{
-	struct io_sr_msg *sr = &req->sr_msg;
-	struct msghdr msg;
-	struct iovec iov;
-	struct socket *sock;
-	unsigned flags;
-	int ret;
-
-	sock = sock_from_file(req->file, &ret);
-	if (unlikely(!sock))
-		return ret;
-
-	ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
-	if (unlikely(ret))
-		return ret;
-
-	msg.msg_name = NULL;
-	msg.msg_control = NULL;
-	msg.msg_controllen = 0;
-	msg.msg_namelen = 0;
-
-	flags = req->sr_msg.msg_flags;
-	if (flags & MSG_DONTWAIT)
-		req->flags |= REQ_F_NOWAIT;
-	else if (force_nonblock)
-		flags |= MSG_DONTWAIT;
-
-	msg.msg_flags = flags;
-	ret = sock_sendmsg(sock, &msg);
-	if (force_nonblock && ret == -EAGAIN)
-		return -EAGAIN;
-	if (ret == -ERESTARTSYS)
-		ret = -EINTR;
-
-	if (ret < 0)
-		req_set_fail_links(req);
-	__io_req_complete(req, ret, 0, cs);
-	return 0;
-}
-
 static int __io_recvmsg_copy_hdr(struct io_kiocb *req,
 				 struct io_async_msghdr *iomsg)
 {
@@ -4733,6 +4614,125 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 	return 0;
 }
 
+static int io_sendmsg_copy_hdr(struct io_kiocb *req,
+			       struct io_async_msghdr *iomsg)
+{
+	iomsg->iov = iomsg->fast_iov;
+	iomsg->msg.msg_name = &iomsg->addr;
+	return sendmsg_copy_msghdr(&iomsg->msg, req->sr_msg.umsg,
+				   req->sr_msg.msg_flags, &iomsg->iov);
+}
+
+static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_async_msghdr *async_msg = req->async_data;
+	struct io_sr_msg *sr = &req->sr_msg;
+	int ret;
+
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
+	sr->msg_flags = READ_ONCE(sqe->msg_flags);
+	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	sr->len = READ_ONCE(sqe->len);
+
+#ifdef CONFIG_COMPAT
+	if (req->ctx->compat)
+		sr->msg_flags |= MSG_CMSG_COMPAT;
+#endif
+
+	if (!async_msg || !io_op_defs[req->opcode].needs_async_data)
+		return 0;
+	ret = io_sendmsg_copy_hdr(req, async_msg);
+	if (!ret)
+		req->flags |= REQ_F_NEED_CLEANUP;
+	return ret;
+}
+
+static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
+		      struct io_comp_state *cs)
+{
+	struct io_async_msghdr iomsg, *kmsg;
+	struct socket *sock;
+	unsigned flags;
+	int ret;
+
+	sock = sock_from_file(req->file, &ret);
+	if (unlikely(!sock))
+		return ret;
+
+	kmsg = req->async_data;
+	if (!kmsg) {
+		ret = io_sendmsg_copy_hdr(req, &iomsg);
+		if (ret)
+			return ret;
+		kmsg = &iomsg;
+	}
+
+	flags = req->sr_msg.msg_flags;
+	if (flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
+	else if (force_nonblock)
+		flags |= MSG_DONTWAIT;
+
+	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
+	if (force_nonblock && ret == -EAGAIN)
+		return io_setup_async_msg(req, kmsg);
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
+
+	/* it's reportedly faster to check for null here */
+	if (kmsg->iov)
+		kfree(kmsg->iov);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret < 0)
+		req_set_fail_links(req);
+	__io_req_complete(req, ret, 0, cs);
+	return 0;
+}
+
+static int io_send(struct io_kiocb *req, bool force_nonblock,
+		   struct io_comp_state *cs)
+{
+	struct io_sr_msg *sr = &req->sr_msg;
+	struct msghdr msg;
+	struct iovec iov;
+	struct socket *sock;
+	unsigned flags;
+	int ret;
+
+	sock = sock_from_file(req->file, &ret);
+	if (unlikely(!sock))
+		return ret;
+
+	ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
+	if (unlikely(ret))
+		return ret;
+
+	msg.msg_name = NULL;
+	msg.msg_control = NULL;
+	msg.msg_controllen = 0;
+	msg.msg_namelen = 0;
+
+	flags = req->sr_msg.msg_flags;
+	if (flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
+	else if (force_nonblock)
+		flags |= MSG_DONTWAIT;
+
+	msg.msg_flags = flags;
+	ret = sock_sendmsg(sock, &msg);
+	if (force_nonblock && ret == -EAGAIN)
+		return -EAGAIN;
+	if (ret == -ERESTARTSYS)
+		ret = -EINTR;
+
+	if (ret < 0)
+		req_set_fail_links(req);
+	__io_req_complete(req, ret, 0, cs);
+	return 0;
+}
+
 static inline unsigned int io_put_recv_kbuf(struct io_kiocb *req)
 {
 	return io_put_kbuf(req, req->sr_msg.kbuf);
-- 
2.24.0

