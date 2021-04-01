Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5336351834
	for <lists+io-uring@lfdr.de>; Thu,  1 Apr 2021 19:48:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236295AbhDARoS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Apr 2021 13:44:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234704AbhDARjT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Apr 2021 13:39:19 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901E5C00458E
        for <io-uring@vger.kernel.org>; Thu,  1 Apr 2021 07:48:39 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id d191so1188359wmd.2
        for <io-uring@vger.kernel.org>; Thu, 01 Apr 2021 07:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=itZ/RAj1BPSOz0XcumJSi5nzW4jq8qKIoeUit2TeL2k=;
        b=gy1d/pcZIt9gd7errUieDUD5gIOHCCKDFLCvV1fYdB1540y7z4RBr1Et3fWu8vwxb2
         Q8wjd+ickhriOIH5PdpL5iZXN2Awz0wOWNM4zgYN/H8Moa7YyunK2pTtNfweCKsCUzVf
         ewjNamBcU7AG2u9Fv5b+e3kiPi6GlcoSQgKpjk3S6B6aglfI19RjFBsfKR8o+HNcSV7M
         nGxjprKG5+HWm4wnXZZAbWRpzngN65+EzIziEMCZM+ojm02Uo+xLX9R1pZtsjER607pY
         wVvWDzA15mAGOk0SFlqT+Pme5QJwwDRFkbE0bk8g0C3atzwe0ArhUIqdv5KrOBbdXwST
         RO4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=itZ/RAj1BPSOz0XcumJSi5nzW4jq8qKIoeUit2TeL2k=;
        b=P2e6SGOU5jqea3wEdy0xTdSoJZroSeDHY+tRyRiFMXxF1MVam+oJd3Elhy6Z4ZzQ0N
         hwPgIIGAH04Nkmna5ihvaotdL9XIOQyhr65h2rx8uETjDF19r/HWyZkxr6ESl3iWCDzi
         Wz5zlw3NzDa6YKrtYT87fZIGAFRi8UC6yf8pjBavAqAst1O4aUMte0iZPiIPF9+WBwHn
         c+rz6zlSwMkjz4WTaX6PNOsoj1CWXeqYFNsu4xK2CeyVSo1uZhU5DDt04oBSbPISbZBq
         ZuEMQAPt4iJRbfq5J9VDK0gE25xNJ2qAilHGj0fUqUcAoEy78R1p/hvPbwGElveeqwNE
         7aRg==
X-Gm-Message-State: AOAM530+YA/9DQcIQEC3jJsaCoLS+ZdQFMhUrRjqtyM0BtIEuZSE4t1Z
        CS0Py8b+1wV1ZisiIC50hSc=
X-Google-Smtp-Source: ABdhPJwl8br/m2VZVMaAjZJ1N+S9CeKh5GXj618qIISdr+pvTT+F551smCiKu6r+bmaU9NgEKgnTxg==
X-Received: by 2002:a05:600c:2197:: with SMTP id e23mr8276935wme.39.1617288518394;
        Thu, 01 Apr 2021 07:48:38 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.152])
        by smtp.gmail.com with ESMTPSA id x13sm8183948wmp.39.2021.04.01.07.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Apr 2021 07:48:38 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 21/26] io_uring: deduplicate NOSIGNAL setting
Date:   Thu,  1 Apr 2021 15:44:00 +0100
Message-Id: <e1133a3ed1c0e192975b7341ea4b0bf91f63b132.1617287883.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1617287883.git.asml.silence@gmail.com>
References: <cover.1617287883.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Set MSG_NOSIGNAL and REQ_F_NOWAIT in send/recv prep routines and don't
duplicate it in all four send/recv handlers.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dcd2f206e058..421e9d7d02fd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4303,9 +4303,11 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
+	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	if (sr->msg_flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -4334,12 +4336,9 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		kmsg = &iomsg;
 	}
 
-	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
-	if (flags & MSG_DONTWAIT)
-		req->flags |= REQ_F_NOWAIT;
-	else if (issue_flags & IO_URING_F_NONBLOCK)
+	flags = req->sr_msg.msg_flags;
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
-
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
@@ -4382,12 +4381,9 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
 
-	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
-	if (flags & MSG_DONTWAIT)
-		req->flags |= REQ_F_NOWAIT;
-	else if (issue_flags & IO_URING_F_NONBLOCK)
+	flags = req->sr_msg.msg_flags;
+	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
-
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
@@ -4530,10 +4526,12 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 	sr->bgid = READ_ONCE(sqe->buf_group);
+	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
+	if (sr->msg_flags & MSG_DONTWAIT)
+		req->flags |= REQ_F_NOWAIT;
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -4574,12 +4572,9 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 				1, req->sr_msg.len);
 	}
 
-	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
-	if (flags & MSG_DONTWAIT)
-		req->flags |= REQ_F_NOWAIT;
-	else if (force_nonblock)
+	flags = req->sr_msg.msg_flags;
+	if (force_nonblock)
 		flags |= MSG_DONTWAIT;
-
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
@@ -4637,12 +4632,9 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_iocb = NULL;
 	msg.msg_flags = 0;
 
-	flags = req->sr_msg.msg_flags | MSG_NOSIGNAL;
-	if (flags & MSG_DONTWAIT)
-		req->flags |= REQ_F_NOWAIT;
-	else if (force_nonblock)
+	flags = req->sr_msg.msg_flags;
+	if (force_nonblock)
 		flags |= MSG_DONTWAIT;
-
 	if (flags & MSG_WAITALL)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
-- 
2.24.0

