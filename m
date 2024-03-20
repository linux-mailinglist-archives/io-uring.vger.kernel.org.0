Return-Path: <io-uring+bounces-1168-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E301A8819AE
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 12E1A1C210E0
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B18E886120;
	Wed, 20 Mar 2024 22:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fccc3jvy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703EF85C65
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975489; cv=none; b=PigQiidIOAWj9RzKtYpbPnrHGMXNbeSw/gY5PjvSNamEWP3Nihwsn496mmIgRn5C8k0RJF7TpnJRL4XbzI8snfgY56VvyORoUcS4M9DHhoVnKwhXUufoDjwS6ff8AtG8DnQwJgXdvv+hxzXsGUtVQQPTb+990DC0t1To5NXoHE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975489; c=relaxed/simple;
	bh=caeNFUSSfWAnpz4lcI+eODh8GgEovyM3kf6YT1l0Lt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6ZATwGZP3Uz7Kg2C73omrAGXgJMwx/CwSUKlt8dG+0iYRZkzNuOmR6SLbKIkZ2nX1wmMdnx+c15iAoWCn1x/6RUEnGi2XCDsaFC0LWpicYXnUxCIxL7RZlElt8s9T5maSALzyktYDOF0YgOOstmBeeVZEfIGAWOnj3lLLckkhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fccc3jvy; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7c8e4c0412dso3588639f.1
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975486; x=1711580286; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BpX2WhgS90Wr7HkWYuE7Ck1OBz3+CeOQjZCkZS5G5D0=;
        b=fccc3jvy5JVgm2gsaMMkPqp0uks0LFqBDl4Wo756xIAQsxyz0Q0ADYRxKNIUbzE1as
         lQ3gqGxXI/xE2p8EGN5t8iakWA5mVurAKWOc1b84+fmbxzOM1WH35GKEpP/LwPd9YQAN
         ZIrXC4bRfPYEwMJh3r+4RZsSA9oEVt+2lR74CzSVsvQKiUQTQ4ZRx9thMk1OA1j0vhUA
         nUD0tbVLBFO1OPi5t61zIqShzN2pdLRmykxz/BBXK6JGYPt3FcXiMcrLUkfEcffJVXpk
         3g2pbcJ+kOjC1vZFqioYT2UNk0oNsQVPi45Q7ZanzIeC1pueoX26jurE+DTIJC8nnPpG
         A2lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975486; x=1711580286;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BpX2WhgS90Wr7HkWYuE7Ck1OBz3+CeOQjZCkZS5G5D0=;
        b=N9ORqJsdX4B1Ky5vNc5mXwzLskM0EFwGuhi2AIRhItdhgn39bFcC/Q1l8JzaQqTsU3
         CMn3FmgGusYxgU/5YzPrab9/Iw8dP+VFjMFEKB5irD+l5ec+t2mXtDOVEhgrY4eO32w4
         rA3UFULCyPeB5kvChFvLf84/885tZO5iaf6OmqgUkdXbxR/TPjEcsk7pOgQAkX/VbXP1
         j8NI4YWR52Dr8/TTCjlFEcei7r9mn2yz3+Wtsiz7kW0Z173hDpo1wEVciyIx1XT+9D/x
         0/F8dc8WYHP8oX2xt+WhrlZ2hXWo57BgRmK2BEFfb+SECw+GRsOx4TkV4CtXkz3f7Qfb
         OqxQ==
X-Gm-Message-State: AOJu0YyRjYbJ6naBBkyb3pr4Ah4dp0+Ly01qIjsXK9T8XDVVO8HzEY1i
	jf5+ognfXD2vJXhm2Vip5pUNpeOcDSOnb2lhzMn0l/UhmrwURrsNY8VAlRMbRU8juSznrtXujq8
	M
X-Google-Smtp-Source: AGHT+IHCwHNwb/eSAh6rbZmq5VoOnIhiugIFAhJwo7D4PNfLuJa/BMjZD9C3dXZfYzFjDW8ASC7VjQ==
X-Received: by 2002:a6b:6303:0:b0:7c8:d514:9555 with SMTP id p3-20020a6b6303000000b007c8d5149555mr16278044iog.1.1710975486258;
        Wed, 20 Mar 2024 15:58:06 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:04 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/17] io_uring/net: get rid of ->prep_async() for send side
Date: Wed, 20 Mar 2024 16:55:21 -0600
Message-ID: <20240320225750.1769647-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320225750.1769647-1-axboe@kernel.dk>
References: <20240320225750.1769647-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move the io_async_msghdr out of the issue path and into prep handling,
e it's now done unconditionally and hence does not need to be part
of the issue path. This means we can drop any usage of
io_sendrecv_prep_async() and io_sendmsg_prep_async(), and hence the
forced async setup path is now unified with the normal prep setup.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 162 +++++++++++++++--------------------------------
 io_uring/net.h   |   2 -
 io_uring/opdef.c |   4 --
 3 files changed, 50 insertions(+), 118 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index e438b1ac2420..dc6cda076a93 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -290,50 +290,59 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 	return ret;
 }
 
-int io_sendrecv_prep_async(struct io_kiocb *req)
+void io_sendmsg_recvmsg_cleanup(struct io_kiocb *req)
+{
+	struct io_async_msghdr *io = req->async_data;
+
+	kfree(io->free_iov);
+}
+
+static int io_send_setup(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *io;
+	struct io_async_msghdr *kmsg = req->async_data;
 	int ret;
 
-	if (req_has_async_data(req))
-		return 0;
-	sr->done_io = 0;
-	if (!sr->addr)
-		return 0;
-	io = io_msg_alloc_async_prep(req);
-	if (!io)
-		return -ENOMEM;
-	memset(&io->msg, 0, sizeof(io->msg));
-	ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &io->msg.msg_iter);
-	if (unlikely(ret))
-		return ret;
-	io->msg.msg_name = &io->addr;
-	io->msg.msg_namelen = sr->addr_len;
-	return move_addr_to_kernel(sr->addr, sr->addr_len, &io->addr);
+	kmsg->msg.msg_name = NULL;
+	kmsg->msg.msg_namelen = 0;
+	kmsg->msg.msg_control = NULL;
+	kmsg->msg.msg_controllen = 0;
+	kmsg->msg.msg_ubuf = NULL;
+
+	if (sr->addr) {
+		ret = move_addr_to_kernel(sr->addr, sr->addr_len, &kmsg->addr);
+		if (unlikely(ret < 0))
+			return ret;
+		kmsg->msg.msg_name = &kmsg->addr;
+		kmsg->msg.msg_namelen = sr->addr_len;
+	}
+	if (!io_do_buffer_select(req)) {
+		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
+				  &kmsg->msg.msg_iter);
+		if (unlikely(ret < 0))
+			return ret;
+	}
+
+	return 0;
 }
 
-int io_sendmsg_prep_async(struct io_kiocb *req)
+static int io_sendmsg_prep_setup(struct io_kiocb *req, int is_msg)
 {
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_async_msghdr *kmsg;
 	int ret;
 
-	sr->done_io = 0;
-	if (!io_msg_alloc_async_prep(req))
+	/* always locked for prep */
+	kmsg = io_msg_alloc_async(req, 0);
+	if (unlikely(!kmsg))
 		return -ENOMEM;
-	ret = io_sendmsg_copy_hdr(req, req->async_data);
+	if (!is_msg)
+		return io_send_setup(req);
+	ret = io_sendmsg_copy_hdr(req, kmsg);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
 }
 
-void io_sendmsg_recvmsg_cleanup(struct io_kiocb *req)
-{
-	struct io_async_msghdr *io = req->async_data;
-
-	kfree(io->free_iov);
-}
-
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -362,7 +371,7 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
-	return 0;
+	return io_sendmsg_prep_setup(req, req->opcode == IORING_OP_SENDMSG);
 }
 
 static void io_req_msg_cleanup(struct io_kiocb *req,
@@ -379,7 +388,7 @@ static void io_req_msg_cleanup(struct io_kiocb *req,
 int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg;
+	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
 	unsigned flags;
 	int min_ret = 0;
@@ -389,18 +398,6 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	if (req_has_async_data(req)) {
-		kmsg = req->async_data;
-		kmsg->msg.msg_control_user = sr->msg_control;
-	} else {
-		kmsg = io_msg_alloc_async(req, issue_flags);
-		if (unlikely(!kmsg))
-			return -ENOMEM;
-		ret = io_sendmsg_copy_hdr(req, kmsg);
-		if (ret)
-			return ret;
-	}
-
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
@@ -436,54 +433,10 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-static struct io_async_msghdr *io_send_setup(struct io_kiocb *req,
-					     unsigned int issue_flags)
-{
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg;
-	int ret;
-
-	if (req_has_async_data(req)) {
-		kmsg = req->async_data;
-	} else {
-		kmsg = io_msg_alloc_async(req, issue_flags);
-		if (unlikely(!kmsg))
-			return ERR_PTR(-ENOMEM);
-		kmsg->msg.msg_name = NULL;
-		kmsg->msg.msg_namelen = 0;
-		kmsg->msg.msg_control = NULL;
-		kmsg->msg.msg_controllen = 0;
-		kmsg->msg.msg_ubuf = NULL;
-
-		if (sr->addr) {
-			ret = move_addr_to_kernel(sr->addr, sr->addr_len,
-						  &kmsg->addr);
-			if (unlikely(ret < 0))
-				return ERR_PTR(ret);
-			kmsg->msg.msg_name = &kmsg->addr;
-			kmsg->msg.msg_namelen = sr->addr_len;
-		}
-
-		if (!io_do_buffer_select(req)) {
-			ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
-					  &kmsg->msg.msg_iter);
-			if (unlikely(ret))
-				return ERR_PTR(ret);
-		}
-	}
-
-	if (!(req->flags & REQ_F_POLLED) &&
-	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return ERR_PTR(-EAGAIN);
-
-	return kmsg;
-}
-
 int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg;
-	size_t len = sr->len;
+	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
 	unsigned flags;
 	int min_ret = 0;
@@ -493,13 +446,9 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	kmsg = io_send_setup(req, issue_flags);
-	if (IS_ERR(kmsg))
-		return PTR_ERR(kmsg);
-
-	ret = import_ubuf(ITER_SOURCE, sr->buf, len, &kmsg->msg.msg_iter);
-	if (unlikely(ret))
-		return ret;
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
+		return -EAGAIN;
 
 	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -1085,7 +1034,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		zc->msg_flags |= MSG_CMSG_COMPAT;
 #endif
-	return 0;
+	return io_sendmsg_prep_setup(req, req->opcode == IORING_OP_SENDMSG_ZC);
 }
 
 static int io_sg_from_iter_iovec(struct sock *sk, struct sk_buff *skb,
@@ -1174,7 +1123,7 @@ static int io_send_zc_import(struct io_kiocb *req, struct io_async_msghdr *kmsg)
 int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg;
+	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
 	unsigned msg_flags;
 	int ret, min_ret = 0;
@@ -1185,9 +1134,9 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	if (!test_bit(SOCK_SUPPORT_ZC, &sock->flags))
 		return -EOPNOTSUPP;
 
-	kmsg = io_send_setup(req, issue_flags);
-	if (IS_ERR(kmsg))
-		return PTR_ERR(kmsg);
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
+		return -EAGAIN;
 
 	if (!zc->done_io) {
 		ret = io_send_zc_import(req, kmsg);
@@ -1243,7 +1192,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg;
+	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -1256,17 +1205,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	if (!test_bit(SOCK_SUPPORT_ZC, &sock->flags))
 		return -EOPNOTSUPP;
 
-	if (req_has_async_data(req)) {
-		kmsg = req->async_data;
-	} else {
-		kmsg = io_msg_alloc_async(req, issue_flags);
-		if (unlikely(!kmsg))
-			return -ENOMEM;
-		ret = io_sendmsg_copy_hdr(req, kmsg);
-		if (ret)
-			return ret;
-	}
-
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
diff --git a/io_uring/net.h b/io_uring/net.h
index 4b4fd9b1b7b4..f99ebb9dc0bb 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -34,13 +34,11 @@ struct io_async_connect {
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_shutdown(struct io_kiocb *req, unsigned int issue_flags);
 
-int io_sendmsg_prep_async(struct io_kiocb *req);
 void io_sendmsg_recvmsg_cleanup(struct io_kiocb *req);
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_send(struct io_kiocb *req, unsigned int issue_flags);
-int io_sendrecv_prep_async(struct io_kiocb *req);
 
 int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 1368193edc57..dd4a1e1425e1 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -527,7 +527,6 @@ const struct io_cold_def io_cold_defs[] = {
 		.name			= "SENDMSG",
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
-		.prep_async		= io_sendmsg_prep_async,
 		.cleanup		= io_sendmsg_recvmsg_cleanup,
 		.fail			= io_sendrecv_fail,
 #endif
@@ -603,7 +602,6 @@ const struct io_cold_def io_cold_defs[] = {
 		.async_size		= sizeof(struct io_async_msghdr),
 		.cleanup		= io_sendmsg_recvmsg_cleanup,
 		.fail			= io_sendrecv_fail,
-		.prep_async		= io_sendrecv_prep_async,
 #endif
 	},
 	[IORING_OP_RECV] = {
@@ -688,7 +686,6 @@ const struct io_cold_def io_cold_defs[] = {
 		.name			= "SEND_ZC",
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
-		.prep_async		= io_sendrecv_prep_async,
 		.cleanup		= io_send_zc_cleanup,
 		.fail			= io_sendrecv_fail,
 #endif
@@ -697,7 +694,6 @@ const struct io_cold_def io_cold_defs[] = {
 		.name			= "SENDMSG_ZC",
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
-		.prep_async		= io_sendmsg_prep_async,
 		.cleanup		= io_send_zc_cleanup,
 		.fail			= io_sendrecv_fail,
 #endif
-- 
2.43.0


