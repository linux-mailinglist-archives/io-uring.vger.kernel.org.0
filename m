Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B101A1EBBC5
	for <lists+io-uring@lfdr.de>; Tue,  2 Jun 2020 14:36:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgFBMfg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 2 Jun 2020 08:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726809AbgFBMfg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Jun 2020 08:35:36 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D574C061A0E;
        Tue,  2 Jun 2020 05:35:35 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g10so2753986wmh.4;
        Tue, 02 Jun 2020 05:35:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=FxnUS8ZObVKVCSq2Jz4F/IAJ47190qwak0yst9dgjek=;
        b=KKMkyn6dSKONhsmKfb/g7H5S06IGP0LiuotpsBG3RZG8j1OH1XW2AiGHS6xvqjobj/
         F3Yz19uXKE2j1BYDaMl1XThBWBEy3r4NXlJz/4LLJwXg44/HTMtfm6KO2ZCSdC3JyPCZ
         +P0dagaATwA8Tei6ElsffnwwrlkwmWiXFNvhY9ciYfwYpXMGpoojHItJyPzWn/5Mnlj4
         6TcLG8IL9rJPFtkDMUP9zBf9jsFsjXn6/bJwp6hS6BSmq7ZxGMsrH5ymlTxHywcqOMfV
         eUpgDQCxwO5xfBE5uqGWDKYHUAo7HmK9nBEE4ZU3xJLmAqKdHcVnYhvM8zDKVYKmkMkT
         eKnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FxnUS8ZObVKVCSq2Jz4F/IAJ47190qwak0yst9dgjek=;
        b=cCYmidSquHMlfNimUdB5T+rjmnIrdC8z4G3WYCPfyvLL3KGBpE9j3T88HBV6+/htFj
         zm2z1YTOsuEAuePy9J8DUu0tD5QOYRD+01ALgIV3yrJCpKD7dMmQAeJYeY1ELhz8PSaQ
         OJ8Hk0Zi3/UOWODxfh0dkjTyGrzYXt4pPsFqLR5DePw75mEsKkuYFgjkqIRhqHf9c/aU
         yo9xZ8Zg4kNuEPpmVy39Rzg1VkQoO08xOWlr8okloW7+YANYQgwkQ8m0wgAoYLrP5xrX
         gZdEjKO9XJP2KEpIbT6FPumgr6CDgMDMFMyZT7cmz+X5hfqirjpcotzYX8/78aiET1cq
         YXMQ==
X-Gm-Message-State: AOAM531IlkKD1yGGKdp5ls8M+0rjDBqyPkwo0Tf0BwV+3inEJZXHfHUd
        i+CkFuAEcRdZtS3NMiGMGH4s6PJq
X-Google-Smtp-Source: ABdhPJyHKsheIJ7IJ3//UFjMBmpBibvQKnq4u92O1ULGy2w7YRhhlT0zWlKQ/o+3EMUl8LGh8SB7kg==
X-Received: by 2002:a1c:3c08:: with SMTP id j8mr3792272wma.23.1591101334323;
        Tue, 02 Jun 2020 05:35:34 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id z22sm3347711wmf.9.2020.06.02.05.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Jun 2020 05:35:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] io_uring: move send/recv IOPOLL check into prep
Date:   Tue,  2 Jun 2020 15:34:04 +0300
Message-Id: <1d888939d1d9ea8fd3022c866b9fe7639b3b94b9.1591100205.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591100205.git.asml.silence@gmail.com>
References: <cover.1591100205.git.asml.silence@gmail.com>
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
index 9fe90a66a31e..d7e9090a6be7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3541,6 +3541,9 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_async_ctx *io = req->io;
 	int ret;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
@@ -3570,9 +3573,6 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock)
 	struct socket *sock;
 	int ret;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct io_async_ctx io;
@@ -3626,9 +3626,6 @@ static int io_send(struct io_kiocb *req, bool force_nonblock)
 	struct socket *sock;
 	int ret;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct io_sr_msg *sr = &req->sr_msg;
@@ -3781,6 +3778,9 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	struct io_async_ctx *io = req->io;
 	int ret;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
@@ -3809,9 +3809,6 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock)
 	struct socket *sock;
 	int ret, cflags = 0;
 
-	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct io_buffer *kbuf;
@@ -3873,9 +3870,6 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock)
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

