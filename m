Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E692B33EA
	for <lists+io-uring@lfdr.de>; Sun, 15 Nov 2020 11:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727083AbgKOKjq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 05:39:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727096AbgKOKjO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 05:39:14 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA05C061A47
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:39:06 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id k2so15527806wrx.2
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=6m8g9vTTSxoLU2HH+QdMzoaH1+jYGOCcwkS3JvdWQ2A=;
        b=FZKfXPNKcEdf07QHHdcH3UFhx0McC7nLpa6spIMYsHeolkLtmwWCk8O+XgAx9cf3gM
         qZtGM8pnkzh55Dwn86HF105lQqhIqjqwwc6jDWSTVlqLJqFTkXz5V5YHzw4yg9zw5vaA
         Swenw1TvSNithFJHzHrZL+3Ph5v2WONNS8PAhA6FHudbIgIlFakR8kZUaSlwjKuRCwJg
         0+BynWLe3HSoJekeTM5S3txbgIyPTDdeiB4v9iJUM2vI2Oi4m6Zu0+OUGJCyfyngI3sc
         8D6m2SuKKDrU8D8YVhOiSjzF+LmdfMAwIXiaZyOw0aadYp40T79fH0kX/NtVb9fCStxG
         HrJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6m8g9vTTSxoLU2HH+QdMzoaH1+jYGOCcwkS3JvdWQ2A=;
        b=Lsc5Iw2GwUirF57Bmu8ljMaCK/8/f0LlmyK9sQ1u+pl72z/IgBg24KrqDsVP6AfB+h
         aj4mNvKZrriauxaEqGI48HlhqRLOhV98QUSfz2GEm6DivEv6hHEsXmzJNvwngGnS7uNg
         uqA/rJ0rY0sNhI8qibrKM1/DOtxdlp4NOB6U7/b4M9MJIZaadp4ItT9uqU20SunK1fBE
         fQ0ODW/oRyMpZBL/dd4iuDlqfPLP9WWvLMEV06OWq4zJOAxg5dHybSyklLYaGXj6yCxY
         LOc1+jdlqzrfgXo5WxkyyAWF3gebirWzE/lVMMR/9Zt00VYoCIVwDu2jlSylSlqLEueu
         rIAA==
X-Gm-Message-State: AOAM530ddgir7kaqlkHIalAKWi6XrKrQUySSceKi0OZOib7uMs/pXZjM
        5jqoirbToMjDzMyRhEPZ2Kc=
X-Google-Smtp-Source: ABdhPJyDliFcAGQ1iucjmAH4sigyUOEsM0Qk4W27nAu+3yq52ed2JxYL+VyTl3wQ7ID65lcmojsk9Q==
X-Received: by 2002:adf:eb4c:: with SMTP id u12mr14420495wrn.73.1605436744843;
        Sun, 15 Nov 2020 02:39:04 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id b14sm17790900wrs.46.2020.11.15.02.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 02:39:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        v@nametag.social
Subject: [PATCH 5/5] io_uring: sendmsg/recvmsg with registered buffers
Date:   Sun, 15 Nov 2020 10:35:44 +0000
Message-Id: <1dc2ae3bed97ed2a4153e21bccb486c9534615c9.1605435507.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1605435507.git.asml.silence@gmail.com>
References: <cover.1605435507.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support of registered buffers to sendmsg() and recvmsg(). As with
previous one, it uses IO_MSG_FIXED, last bit of flags, which is cleared
before going into net stack.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 390495170fb0..7b13dafc84ab 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4488,7 +4488,7 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
 	async_msg->msg.msg_name = &async_msg->addr;
 	/* if iov is not set, it uses fast_iov */
-	if (!async_msg->iov)
+	if (!async_msg->iov && !(req->sr_msg.msg_flags & IO_MSG_FIXED))
 		async_msg->msg.msg_iter.iov = async_msg->fast_iov;
 	return -EAGAIN;
 }
@@ -4508,7 +4508,8 @@ static int __io_msg_copy_hdr(struct io_kiocb *req,
 	if (ret)
 		return ret;
 
-	if (req->flags & REQ_F_BUFFER_SELECT) {
+	if ((req->flags & REQ_F_BUFFER_SELECT) ||
+	    (sr->msg_flags & IO_MSG_FIXED)) {
 		if (iov_len > 1)
 			return -EINVAL;
 		if (copy_from_user(iomsg->iov, uiov, sizeof(*uiov)))
@@ -4548,7 +4549,8 @@ static int __io_compat_msg_copy_hdr(struct io_kiocb *req,
 		return ret;
 
 	uiov = compat_ptr(ptr);
-	if (req->flags & REQ_F_BUFFER_SELECT) {
+	if ((req->flags & REQ_F_BUFFER_SELECT) ||
+	    (sr->msg_flags & IO_MSG_FIXED)) {
 		compat_ssize_t clen;
 
 		if (len > 1)
@@ -4591,6 +4593,7 @@ static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
 static int io_import_msg(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 			 int rw)
 {
+	struct io_sr_msg *sr = &req->sr_msg;
 	struct io_buffer *kbuf;
 	int ret;
 
@@ -4606,7 +4609,7 @@ static int io_import_msg(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 		return ret;
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		if (rw != READ)
+		if (rw != READ || (sr->msg_flags & IO_MSG_FIXED))
 			return -EINVAL;
 		/* init is always done with uring_lock held */
 		kbuf = io_recv_buffer_select(req, false);
@@ -4614,7 +4617,14 @@ static int io_import_msg(struct io_kiocb *req, struct io_async_msghdr *iomsg,
 			return PTR_ERR(kbuf);
 		iomsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
 		iov_iter_init(&iomsg->msg.msg_iter, READ, iomsg->fast_iov, 1,
-			      req->sr_msg.len);
+			      sr->len);
+	} else if (sr->msg_flags & IO_MSG_FIXED) {
+		struct iovec *iov = &iomsg->fast_iov[0];
+
+		ret = io_import_fixed(req, rw, (u64)iov->iov_base, iov->iov_len,
+				      &iomsg->msg.msg_iter);
+		if (ret < 0)
+			return ret;
 	}
 	return 0;
 }
@@ -4631,6 +4641,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
+	req->buf_index = READ_ONCE(sqe->buf_index);
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -4665,7 +4676,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 		kmsg = &iomsg;
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags & ~IO_MSG_FIXED;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4754,6 +4765,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 	sr->bgid = READ_ONCE(sqe->buf_group);
+	req->buf_index = READ_ONCE(sqe->buf_index);
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -4788,7 +4800,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 		kmsg = &iomsg;
 	}
 
-	flags = req->sr_msg.msg_flags;
+	flags = req->sr_msg.msg_flags & ~IO_MSG_FIXED;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
-- 
2.24.0

