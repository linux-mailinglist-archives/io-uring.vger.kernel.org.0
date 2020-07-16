Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64B47222CD1
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:32:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgGPUaG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:30:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPUaF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:30:05 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 502B0C061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:05 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id z2so8501058wrp.2
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PXhPRnsfCen0U8aKMg6abcxj5BQ3PywAqwC5xIVltvk=;
        b=NtQHDsX8I5GgtURJQ+dyODBEgJJRF8GZt/ozz2ImH6vOzsEUDqhRunHOpMGahp1bvF
         myEpomL59H8jkG01XyrfNB4cu5Gg/EB7EqRj+vIXhBDttKsdqvrJFXXFcvQ25lgrogF6
         7PD4s0HARXAvXOiKKKhSevbcxlnHAqTWBrTi3e+8xCVPoPq/Zw+Sm6GEmsQ6OZ78zhXC
         fdcI4cpO201rtIYom678GEGV0V7d9gVAQV7VYbvLhgzDXpS/SWF5znwgGs97gUf/xbeF
         bMA5MXGEVowxKrSKJCoMDOFKtQJ2Bvbft0o4pYJsI2R8DE+ydAkogWBN6S8hBZJcn+jm
         F0zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PXhPRnsfCen0U8aKMg6abcxj5BQ3PywAqwC5xIVltvk=;
        b=BMWhduHS0WCmaU9GmWY/iL42NXDf6XzpVqxc35PCLKjTN/mnmDBcZO4t15SgsiNH0R
         u36jbziZRCu3cL0VOhgU9PN9ySyw75GsynfWZZYupeNjQ2vAvY1uZdH+JzztER0MIv9Y
         T3j5xSgj8+8jZ+lmYqY727fX9/dbKgxt+nA8TXZBe8pnIDx2SOKmrvukf7QqFnZsfRsi
         nIcyqgbhnnhSJAlX8IM4I4kahUskSOpJz2DokZH16LuE5hCvY/rYLToYvtmkj/G7elsE
         SKojZgLr8sCQjzYsnfK3ivQy9wDpwYmPGVGbzEolMXHZPfQWSzZQGlWKNv4dqFp96rkQ
         jO3w==
X-Gm-Message-State: AOAM5304qVtRR2RC0IR06qen4Xc7Vf/cOq3icyKllAWmtisfM2IQ1+Zf
        MOOUwRzcy3i3a+6LYCrnDO0=
X-Google-Smtp-Source: ABdhPJzpzqg6bYaxZm+HVPIKE4ufuzvCQaFZ7gEfDws6MPDwwn8XL1amNrbdqflbzUOHO6K11/wDBg==
X-Received: by 2002:a5d:6386:: with SMTP id p6mr6509078wru.417.1594931404023;
        Thu, 16 Jul 2020 13:30:04 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id v5sm9939823wmh.12.2020.07.16.13.30.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:30:03 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/7] io_uring: remove extra checks in send/recv
Date:   Thu, 16 Jul 2020 23:28:00 +0300
Message-Id: <239b75b2614ef48f3e292e725fe617de46e9145d.1594930020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594930020.git.asml.silence@gmail.com>
References: <cover.1594930020.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With the return on a bad socket, kmsg is always non-null by the end
of the function, prune left extra checks and initialisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ae857e16aa6d..3d5c7f3feec4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3919,7 +3919,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 		      struct io_comp_state *cs)
 {
-	struct io_async_msghdr iomsg, *kmsg = NULL;
+	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
 	unsigned flags;
 	int ret;
@@ -3954,7 +3954,7 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
-	if (kmsg && kmsg->iov != kmsg->fast_iov)
+	if (kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
@@ -4150,7 +4150,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 		      struct io_comp_state *cs)
 {
-	struct io_async_msghdr iomsg, *kmsg = NULL;
+	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
 	struct io_buffer *kbuf;
 	unsigned flags;
@@ -4202,7 +4202,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	if (kbuf)
 		kfree(kbuf);
 
-	if (kmsg && kmsg->iov != kmsg->fast_iov)
+	if (kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 
@@ -4215,7 +4215,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 static int io_recv(struct io_kiocb *req, bool force_nonblock,
 		   struct io_comp_state *cs)
 {
-	struct io_buffer *kbuf = NULL;
+	struct io_buffer *kbuf;
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct msghdr msg;
 	void __user *buf = sr->buf;
-- 
2.24.0

