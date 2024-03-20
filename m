Return-Path: <io-uring+bounces-1150-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 51886880906
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CC0C01F24504
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09860748E;
	Wed, 20 Mar 2024 01:23:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hGZMddGl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6BAF7464
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897790; cv=none; b=A5SSkFp6AYNDiD+kWmQYOP1O2++X67un76+uJhNDZnmtyfA1OIwfyLpal/V2qy/1VZ92C30/apo8xP7517ltzKKzHNpnlD5ZmsY5LS+pu6SKUPyvAKcCP1m2jCVpicH/OPVApHoSJZykw1Ov0srFY89fx63E8ZSm+HfuJceERiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897790; c=relaxed/simple;
	bh=TZQoeqSK3zMxlu7nCyBtUQb2tl9lGeNBurGesffu8kU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yk9bDaRp1d9WWaJpKPl/FDaqBX4aDYAiK51S9pB8+ME8hLuXs/tykv/mHhGVx0qWiGd6P7niN4VagUekevuvL01iPCkEc/SDvxtz29CZl9RAftvE7wGfXmBLv0n2bUF62KGBm/QlWaRTlPzBxUX+vlLz2ho3cdirD3cnASSguSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hGZMddGl; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6e6a40a15c5so294995a34.0
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:23:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897787; x=1711502587; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Klt+7YCKJK205MhC8Z3ij0luEyfDTMzh6WojoGKZ0xE=;
        b=hGZMddGlT4+q9sHeKzS4U3QXegBrPQaFDm/JdQ/hparC1uvKE2O22F8+TjvSlY6fu7
         TFp6K2yfXjCaNvcn47A72UuejuNSZkyS2CYbagqa6//SLNjBbuEyEyePkC1XCA4ksMlC
         A4I85OWx2GitlIP1nIMORnQmxQOH4wuQGFvyoK1Cz6VMabGCBC578y/4OvFbFYhkaqNs
         AD0oJBWe4sUTIKKZHortLmwyn1VW9Se4sSRG6QbCysIyvvm47lSdgoerIDE/WzTyJnFB
         CelxwiOZFpGmxmAGh3kDDTF8OpNXu82Os4U+4R9lhOhPucrJ5CHq959VxyFdWtbDV+Yj
         IZtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897787; x=1711502587;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Klt+7YCKJK205MhC8Z3ij0luEyfDTMzh6WojoGKZ0xE=;
        b=B58TBKXeJvFEsDwD8KPwiLpBihwkO6hB2c8WT4XpvUIbhJFBvgsFNl129q2Y77AU+q
         TB5tPtn9q0xHMeEttmD6hPkEFvg9HlrRx9y/QK493VMmfj7gx8mnt2wD5jbGbfkz4Psh
         +jauwnhjGnoEoC7lBXYi+AaVilQgSKvtqL8GZlsnx+1WRx7NTDO48f5n8C1ZHpVxR1i7
         48ech88ZNVxnMfehCfAME7Wg/P8zP4jgvfng7uM1DOL018oRLPbEAs7G5Ekhueh+IAxf
         7By9l9OmdONG5qiXtlJOOXhjv6MKRg+kZdNTWYJIVnf9iKI1NQ2p3NnMhQWacHBAHoGA
         toqg==
X-Gm-Message-State: AOJu0YwRJ0FR0LIiYiPyFavW/sTBGzdtT1KJwkiFZ886Y2F/CHaHNIFV
	6pWWiJsNza3xijBHS0TcTePR/OcgzAr9IuLQ1Js1xM8oZfLMN9q7Zd1EYo+x/kz6MN5J9/fldBw
	v
X-Google-Smtp-Source: AGHT+IHkBYMlCfLy27NEkOSNlI60wAg32L3VltnzedUDPhZoiYqU3OKPmmwqf1nKl9QJrl7fNypYJA==
X-Received: by 2002:a05:6820:d0a:b0:5a4:6ac7:de6d with SMTP id ej10-20020a0568200d0a00b005a46ac7de6dmr11558565oob.1.1710897787333;
        Tue, 19 Mar 2024 18:23:07 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:23:06 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 06/15] io_uring/net: get rid of ->prep_async() for send side
Date: Tue, 19 Mar 2024 19:17:34 -0600
Message-ID: <20240320012251.1120361-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320012251.1120361-1-axboe@kernel.dk>
References: <20240320012251.1120361-1-axboe@kernel.dk>
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
 io_uring/net.c   | 169 +++++++++++++++--------------------------------
 io_uring/net.h   |   2 -
 io_uring/opdef.c |   4 --
 3 files changed, 54 insertions(+), 121 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 50758442188b..94767d6c1946 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -290,50 +290,64 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
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
-	if (sr->addr)
-		return move_addr_to_kernel(sr->addr, sr->addr_len, &io->addr);
+	if (sr->addr) {
+		ret = move_addr_to_kernel(sr->addr, sr->addr_len, &kmsg->addr);
+		if (unlikely(ret < 0))
+			return ret;
+	}
+
+	if (!io_do_buffer_select(req)) {
+		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
+				  &kmsg->msg.msg_iter);
+		if (unlikely(ret))
+			return ret;
+	}
+
+	if (sr->addr) {
+		kmsg->msg.msg_name = &kmsg->addr;
+		kmsg->msg.msg_namelen = sr->addr_len;
+	} else {
+		kmsg->msg.msg_name = NULL;
+		kmsg->msg.msg_namelen = 0;
+	}
+	kmsg->msg.msg_control = NULL;
+	kmsg->msg.msg_controllen = 0;
+	kmsg->msg.msg_ubuf = NULL;
 	return 0;
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
+
+	if (!is_msg)
+		return io_send_setup(req);
+
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
@@ -362,7 +376,7 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
-	return 0;
+	return io_sendmsg_prep_setup(req, req->opcode == IORING_OP_SENDMSG);
 }
 
 static void io_req_msg_cleanup(struct io_kiocb *req,
@@ -379,7 +393,7 @@ static void io_req_msg_cleanup(struct io_kiocb *req,
 int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg;
+	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
 	unsigned flags;
 	int min_ret = 0;
@@ -389,18 +403,6 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -436,58 +438,10 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
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
-		if (!kmsg)
-			return ERR_PTR(-ENOMEM);
-
-		if (sr->addr) {
-			ret = move_addr_to_kernel(sr->addr, sr->addr_len,
-						  &kmsg->addr);
-			if (unlikely(ret < 0))
-				return ERR_PTR(ret);
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
-	if (sr->addr) {
-		kmsg->msg.msg_name = &kmsg->addr;
-		kmsg->msg.msg_namelen = sr->addr_len;
-	} else {
-		kmsg->msg.msg_name = NULL;
-		kmsg->msg.msg_namelen = 0;
-	}
-	kmsg->msg.msg_control = NULL;
-	kmsg->msg.msg_controllen = 0;
-	kmsg->msg.msg_ubuf = NULL;
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
@@ -497,13 +451,9 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -1085,7 +1035,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		zc->msg_flags |= MSG_CMSG_COMPAT;
 #endif
-	return 0;
+	return io_sendmsg_prep_setup(req, req->opcode == IORING_OP_SENDMSG_ZC);
 }
 
 static int io_sg_from_iter_iovec(struct sock *sk, struct sk_buff *skb,
@@ -1174,7 +1124,7 @@ static int io_send_zc_import(struct io_kiocb *req, struct io_async_msghdr *kmsg)
 int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg;
+	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
 	unsigned msg_flags;
 	int ret, min_ret = 0;
@@ -1185,9 +1135,9 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -1241,7 +1191,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg;
+	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -1254,17 +1204,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
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
index 654324739346..2713dc90fdd4 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -33,13 +33,11 @@ struct io_async_connect {
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


