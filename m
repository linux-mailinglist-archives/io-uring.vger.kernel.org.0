Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B587B1ED0D2
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 15:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725859AbgFCNbI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 09:31:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725986AbgFCNbH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 09:31:07 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34F42C08C5C0;
        Wed,  3 Jun 2020 06:31:07 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r15so2072921wmh.5;
        Wed, 03 Jun 2020 06:31:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Ug04v6Jn7KtzsZvcqnMoFN+l9wsT6C3eF7QM3sTdkpI=;
        b=SX7EXBKX815JEwI+NZkYBbCIuAKonRUmnU+LA1P22GDo2EKCW876sdkZZ1GhibAFPp
         IXl73LuD++hONUI1a6W4llkTG5P9kXtrjsri3J+3CsUvpcpKjUmhXkdzDU6uu3NbnFr9
         zo+TWVR9SF6O4RQSYanGUHeQQdsdeficBOPKD5ufdFLaO17vZ/kR1C5PRM1UJEHVNB6R
         BxHaNLrvWPYc12XFbpN75TmKC5XzyT3pyC7vr+MsdR+eUkfGmgiIWA93isV2vVRrOH0n
         ZbxRWushMPvytRBlxQsd0Eu9oL2z5KeDM68NMCquEydv08NGhuOU+4LGCXbEppdckXmz
         SJKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ug04v6Jn7KtzsZvcqnMoFN+l9wsT6C3eF7QM3sTdkpI=;
        b=IQhJ1n0ZhQVgbJEoVUVt2R0wR1k1GVns1Iwwh/G/8M+iS1l9Mfd49v6lYqoHWFuJbV
         SdCqDtmxpCVCO/eEx6FW/P/OAwh2PcfdmrHdJgMQGdMxFIKv6s9Fo3l0RvsBWfSMmrk3
         MJ6i0NDL3B3fNaoDfb5/vDs956l2uNMK/rM5kN95Qcw1jmTL9G5y0mM5NkwfWCVq3MVC
         Ee6LjvCcS1lTYfA+F8lWSbFIfwkGFWWkI8Uxw1XTwmfUpmrCI65ONjEJyUIWmInE/RgC
         egtqsLyUXsZNo0q/me69I6RIntFLU2j/is2NQ0FaDPQVBOMIEqCu0Tzey9HtFdlnUTpJ
         5miA==
X-Gm-Message-State: AOAM532C1Z0vG5NYtqk5c1eLBo0len5VEv5inKFLonNflH5y6b906xax
        xeWwFgjUgTbeAymzK9ejTmg=
X-Google-Smtp-Source: ABdhPJxhU3wtubL0XYgQeuqU3kqyBy4wTGLgcGZvg3MDZC0YU56m3tSAlWR4GNFlvRcJPTq1x2ybNg==
X-Received: by 2002:a05:600c:2153:: with SMTP id v19mr8421505wml.47.1591191065901;
        Wed, 03 Jun 2020 06:31:05 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id a1sm3189716wmd.28.2020.06.03.06.31.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 06:31:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/4] io_uring: move send/recv IOPOLL check into prep
Date:   Wed,  3 Jun 2020 16:29:32 +0300
Message-Id: <9f6728ae45054de27b0434e49ba8bc0ea537d5fc.1591190471.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591190471.git.asml.silence@gmail.com>
References: <cover.1591190471.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Fail recv/send in case of IORING_SETUP_IOPOLL earlier during prep,
so it'd be done only once. Removes duplication as well

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 ++++++------------
 1 file changed, 6 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7d49bcba859c..d63a13d10de0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3555,6 +3555,9 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_async_ctx *io = req->io;
 	int ret;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
@@ -3584,9 +3587,6 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 	struct socket *sock;
 	int ret;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct io_async_ctx io;
@@ -3640,9 +3640,6 @@ static int io_send(struct io_kiocb *req, bool force_nonblock)
 	struct socket *sock;
 	int ret;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct io_sr_msg *sr = &req->sr_msg;
@@ -3795,6 +3792,9 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	struct io_async_ctx *io = req->io;
 	int ret;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
@@ -3823,9 +3823,6 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 	struct socket *sock;
 	int ret, cflags = 0;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct io_buffer *kbuf;
@@ -3887,9 +3884,6 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
 	struct socket *sock;
 	int ret, cflags = 0;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct io_sr_msg *sr = &req->sr_msg;
-- 
2.24.0

