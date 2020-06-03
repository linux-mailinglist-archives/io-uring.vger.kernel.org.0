Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 146BE1ED2F3
	for <lists+io-uring@lfdr.de>; Wed,  3 Jun 2020 17:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726212AbgFCPFH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Jun 2020 11:05:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgFCPFG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Jun 2020 11:05:06 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B3EDC08C5C0;
        Wed,  3 Jun 2020 08:05:06 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e1so2752385wrt.5;
        Wed, 03 Jun 2020 08:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=n1vwhhoWoAgilsvuaKtoP7CANOpwmRtRmwiwhQPOHdY=;
        b=LFMH8mW1d5R1QBO7eOYfxHkVzBVnOcpswBEemAhV6eNMI2cvgxoORHLllHGOqM8kZ1
         CgrwL+a66IT7O/m7G8U8yBPL7jGXV7oq2QIRDYTazZSU3na28fHOcqySGHYibcg6x0DW
         nGk91xgjydo/anCd1o243Of9mdGI/ZqplvipsKXcZfb9dKq8NLcUcRlXW8mSG75sNJPY
         YayKlo/IUOCHuWxkJUecEV1ywziLFfFxtV0oqMbkoDQ1tWXEmRsB/Ayt7xm2sctAsemG
         iPArTdO3y3m+n177EHvYY3Er7uU58ZB5HLVVZ42eadtIZj3p29x+kQG0wBBEeyNb2oAw
         Ty5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n1vwhhoWoAgilsvuaKtoP7CANOpwmRtRmwiwhQPOHdY=;
        b=l8AAb3tKaSg7WoHmT7XcQqO7QxtazrIl9amh+IO4lYi2tXBdLuUkTM1f1kEVCu4BZP
         xGaNUvTAg3eX0/4NKxE/GYh3uD/SuWWozEXJBPzmjxh+h32nbD0c+KQhxI+9b8RgoAck
         4f7wQrxnB0kME71IRRmbKfRqM3p8K58Xjlua7gEaYu+8VZkgY7N08V05nwBb+1bbuDHV
         LRnMEtaVCcrmnLx18zxZlvEoyHfLxSue3o00840FrXHHiw06xZaOl4iyaGp9ig/jBaID
         AsSsPnPsQbXKs2KAVnqZsVahjvuqOv6KTeEWyRleJ0jQvVcrnAE1Nxy9zYCnFFC7VB9u
         nhxQ==
X-Gm-Message-State: AOAM531X4PmU2twp5PNj5SIcjEM6CN+AiREStllU92szDZ4VObTDJcHq
        cBX8R7mEmCiI4v63rNZT3bRxYjVr
X-Google-Smtp-Source: ABdhPJxDCHSw5F6Hcm/GXEjl6B6abuULjoADltR5iqezecMl0PLBPgmyPMv+CFZyFDtsS12W4XemNQ==
X-Received: by 2002:adf:e7ce:: with SMTP id e14mr33810515wrn.217.1591196705267;
        Wed, 03 Jun 2020 08:05:05 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id f71sm3074808wmf.22.2020.06.03.08.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2020 08:05:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/4] io_uring: move send/recv IOPOLL check into prep
Date:   Wed,  3 Jun 2020 18:03:25 +0300
Message-Id: <7a733381a405c8f510a82313a7ba1359e8f0128e.1591196426.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1591196426.git.asml.silence@gmail.com>
References: <cover.1591196426.git.asml.silence@gmail.com>
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
index 134627cbe86b..dee59c34acb3 100644
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

