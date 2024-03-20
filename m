Return-Path: <io-uring+bounces-1163-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EDEB8819AA
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6A5D4B24D7D
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A72F85C73;
	Wed, 20 Mar 2024 22:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="hxZsoTlu"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94E4381D1
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975480; cv=none; b=E4BUJuXNd9ENO4VkEbPvt63bWy1gsSjRrzyazgPvONJJI5PkxUIvnN37QfHdTr3pQeGjO/ZA6SmNEmGYEprQMocB/IHxanZqLIgwjLJFHm3nz1+rYPy9nT0hjFMlLGIEymijf9gW/4RjHqFh1L3OLJjObry/Q6q1HPjTqUD9IO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975480; c=relaxed/simple;
	bh=eCtxrk4Io0v+A0yq+KNK3HkUPeffwmZjof/ejs96dvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AFy4629oazWhh1C99u2KURwVocI3QfiLLQFus0qHLbAkFGqxiYJhPelOJBOvxrp4cSSGvFPsrMF6D+3D6ZkQeuerHX+SRtRTpR03clRW1R/FPraHPKq4c1cFFoOK2c1AKE552e1OXlriCJBx/qI4x6F/bLDprQjGnTRafv8w8OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=hxZsoTlu; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so2537239f.1
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975475; x=1711580275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xzNkNd4QmdS0zJdufPglHElSH8fOBK4QXS9P0WWmGBg=;
        b=hxZsoTlufu41xvNUWgjlZfAnDOa8hYfQ3H6DL7SdAcQ6Tu8vI9PLRbA74xzOlaP9sA
         c+sl4fUgnLfwjLFjO15FrkWy/HWm7ea/XzQ42YqDALNqqU4Rrg/9YSI2zpQ+M4BymEtt
         XCj6pi/GX7xlT9hl1TCovZhqDmmqdrrrdEwnQpuZDqNramp12Yia+TGi5oiZ35sx13Aq
         IqbO/WyPmGpDahlp9+Yk92npwm5wlt7EytL9dHZaZ3s+WDh12+uNUfF4ci0qtI4chqyb
         7vke7SAoavszXnEBzI4/15277zkKYO+i3LXIFX5ZamdvEkK2BYyekQF5nLh+WbyXeqOP
         r/+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975475; x=1711580275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xzNkNd4QmdS0zJdufPglHElSH8fOBK4QXS9P0WWmGBg=;
        b=c7/lT1BUYbwO+bdzo3GXl6FyLS8WNCAsZYzgsn4tPk4igaSv2X/i6wqvOMj4fDtpd9
         wRZ3ktIY/77Ko7UMVuarGg8VN0w7sboZKSkfMCJTadSRKbHc3arb+qgJunD1qWNVaVK/
         TgZ7Eor8YUhDk865dufWFX+9vRJu+ElxKLUNbh3fYLTDztvl97HsnkLKy8gQMpzFIpw1
         0zPedaIlOTmM4JlwJIlEOqj+1DVCmlDGQ9D75chKvmWr16Z1FIrPu7h7CXudALAXj4r4
         wnxStoR7lgVBB3b3TycRBS0j3IW7WjegXjKpp26p+dgM/3WugluADqfQJnfBVDMxhg5e
         vD4w==
X-Gm-Message-State: AOJu0YwTiFXniVaHkdvCFxQxCyTbGXntzlc+6vp21mM2IeBmeanqyIb/
	E/BHQTi71tw05vApFc9nosJxmhAbOWD92gVk8URQGTY0HOBWBVluW+GlepG0WDopsc4bYj9z6V/
	3
X-Google-Smtp-Source: AGHT+IEBCeNkuy4lgnLYLxgCKlReimMu/KBp0wqMZpAjqtKGlZcShBMjd1mX9z9PxrjXRrx83gRJyA==
X-Received: by 2002:a5e:c10d:0:b0:7cf:28df:79e2 with SMTP id v13-20020a5ec10d000000b007cf28df79e2mr700529iol.1.1710975475411;
        Wed, 20 Mar 2024 15:57:55 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.57.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:57:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/17] io_uring/net: switch io_send() and io_send_zc() to using io_async_msghdr
Date: Wed, 20 Mar 2024 16:55:16 -0600
Message-ID: <20240320225750.1769647-2-axboe@kernel.dk>
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

No functional changes in this patch, just in preparation for carrying
more state then we have now, if necessary. While unifying some of this
code, add a generic send setup prep handler that they can both use.

This gets rid of some manual msghdr and sockaddr on the stack, and makes
it look a bit more like the sendmsg/recvmsg variants. We can probably
unify a bit more on top of this going forward.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 196 ++++++++++++++++++++++++-----------------------
 io_uring/opdef.c |   1 +
 2 files changed, 103 insertions(+), 94 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index ed798e185bbf..a16838c0c837 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -322,36 +322,25 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 
 int io_send_prep_async(struct io_kiocb *req)
 {
-	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *io;
 	int ret;
 
 	if (req_has_async_data(req))
 		return 0;
-	zc->done_io = 0;
-	if (!zc->addr)
+	sr->done_io = 0;
+	if (!sr->addr)
 		return 0;
 	io = io_msg_alloc_async_prep(req);
 	if (!io)
 		return -ENOMEM;
-	ret = move_addr_to_kernel(zc->addr, zc->addr_len, &io->addr);
-	return ret;
-}
-
-static int io_setup_async_addr(struct io_kiocb *req,
-			      struct sockaddr_storage *addr_storage,
-			      unsigned int issue_flags)
-{
-	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *io;
-
-	if (!sr->addr || req_has_async_data(req))
-		return -EAGAIN;
-	io = io_msg_alloc_async(req, issue_flags);
-	if (!io)
-		return -ENOMEM;
-	memcpy(&io->addr, addr_storage, sizeof(io->addr));
-	return -EAGAIN;
+	memset(&io->msg, 0, sizeof(io->msg));
+	ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &io->msg.msg_iter);
+	if (unlikely(ret))
+		return ret;
+	io->msg.msg_name = &io->addr;
+	io->msg.msg_namelen = sr->addr_len;
+	return move_addr_to_kernel(sr->addr, sr->addr_len, &io->addr);
 }
 
 int io_sendmsg_prep_async(struct io_kiocb *req)
@@ -475,45 +464,68 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-int io_send(struct io_kiocb *req, unsigned int issue_flags)
+static struct io_async_msghdr *io_send_setup(struct io_kiocb *req,
+					     struct io_async_msghdr *stack_msg,
+					     unsigned int issue_flags)
 {
-	struct sockaddr_storage __address;
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct msghdr msg;
-	struct socket *sock;
-	unsigned flags;
-	int min_ret = 0;
+	struct io_async_msghdr *kmsg;
 	int ret;
 
-	msg.msg_name = NULL;
-	msg.msg_control = NULL;
-	msg.msg_controllen = 0;
-	msg.msg_namelen = 0;
-	msg.msg_ubuf = NULL;
-
-	if (sr->addr) {
-		if (req_has_async_data(req)) {
-			struct io_async_msghdr *io = req->async_data;
-
-			msg.msg_name = &io->addr;
-		} else {
-			ret = move_addr_to_kernel(sr->addr, sr->addr_len, &__address);
+	if (req_has_async_data(req)) {
+		kmsg = req->async_data;
+	} else {
+		kmsg = stack_msg;
+		kmsg->free_iov = NULL;
+		kmsg->msg.msg_name = NULL;
+		kmsg->msg.msg_namelen = 0;
+		kmsg->msg.msg_control = NULL;
+		kmsg->msg.msg_controllen = 0;
+		kmsg->msg.msg_ubuf = NULL;
+
+		if (sr->addr) {
+			ret = move_addr_to_kernel(sr->addr, sr->addr_len,
+						  &kmsg->addr);
 			if (unlikely(ret < 0))
-				return ret;
-			msg.msg_name = (struct sockaddr *)&__address;
+				return ERR_PTR(ret);
+			kmsg->msg.msg_name = &kmsg->addr;
+			kmsg->msg.msg_namelen = sr->addr_len;
+		}
+
+		if (!io_do_buffer_select(req)) {
+			ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len,
+					  &kmsg->msg.msg_iter);
+			if (unlikely(ret))
+				return ERR_PTR(ret);
 		}
-		msg.msg_namelen = sr->addr_len;
 	}
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return io_setup_async_addr(req, &__address, issue_flags);
+		return ERR_PTR(io_setup_async_msg(req, kmsg, issue_flags));
+
+	return kmsg;
+}
+
+int io_send(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_async_msghdr iomsg, *kmsg;
+	size_t len = sr->len;
+	struct socket *sock;
+	unsigned flags;
+	int min_ret = 0;
+	int ret;
 
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &msg.msg_iter);
+	kmsg = io_send_setup(req, &iomsg, issue_flags);
+	if (IS_ERR(kmsg))
+		return PTR_ERR(kmsg);
+
+	ret = import_ubuf(ITER_SOURCE, sr->buf, len, &kmsg->msg.msg_iter);
 	if (unlikely(ret))
 		return ret;
 
@@ -521,21 +533,21 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		flags |= MSG_DONTWAIT;
 	if (flags & MSG_WAITALL)
-		min_ret = iov_iter_count(&msg.msg_iter);
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
 	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
-	msg.msg_flags = flags;
-	ret = sock_sendmsg(sock, &msg);
+	kmsg->msg.msg_flags = flags;
+	ret = sock_sendmsg(sock, &kmsg->msg);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_addr(req, &__address, issue_flags);
+			return io_setup_async_msg(req, kmsg, issue_flags);
 
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return io_setup_async_addr(req, &__address, issue_flags);
+			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -545,6 +557,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
+	io_req_msg_cleanup(req, kmsg, issue_flags);
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
@@ -1158,11 +1171,35 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 	return ret;
 }
 
+static int io_send_zc_import(struct io_kiocb *req, struct io_async_msghdr *kmsg)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	int ret;
+
+	if (sr->flags & IORING_RECVSEND_FIXED_BUF) {
+		ret = io_import_fixed(ITER_SOURCE, &kmsg->msg.msg_iter, req->imu,
+					(u64)(uintptr_t)sr->buf, sr->len);
+		if (unlikely(ret))
+			return ret;
+		kmsg->msg.sg_from_iter = io_sg_from_iter;
+	} else {
+		io_notif_set_extended(sr->notif);
+		ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &kmsg->msg.msg_iter);
+		if (unlikely(ret))
+			return ret;
+		ret = io_notif_account_mem(sr->notif, sr->len);
+		if (unlikely(ret))
+			return ret;
+		kmsg->msg.sg_from_iter = io_sg_from_iter_iovec;
+	}
+
+	return ret;
+}
+
 int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct sockaddr_storage __address;
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct msghdr msg;
+	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
 	unsigned msg_flags;
 	int ret, min_ret = 0;
@@ -1173,67 +1210,37 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	if (!test_bit(SOCK_SUPPORT_ZC, &sock->flags))
 		return -EOPNOTSUPP;
 
-	msg.msg_name = NULL;
-	msg.msg_control = NULL;
-	msg.msg_controllen = 0;
-	msg.msg_namelen = 0;
-
-	if (zc->addr) {
-		if (req_has_async_data(req)) {
-			struct io_async_msghdr *io = req->async_data;
-
-			msg.msg_name = &io->addr;
-		} else {
-			ret = move_addr_to_kernel(zc->addr, zc->addr_len, &__address);
-			if (unlikely(ret < 0))
-				return ret;
-			msg.msg_name = (struct sockaddr *)&__address;
-		}
-		msg.msg_namelen = zc->addr_len;
-	}
-
-	if (!(req->flags & REQ_F_POLLED) &&
-	    (zc->flags & IORING_RECVSEND_POLL_FIRST))
-		return io_setup_async_addr(req, &__address, issue_flags);
+	kmsg = io_send_setup(req, &iomsg, issue_flags);
+	if (IS_ERR(kmsg))
+		return PTR_ERR(kmsg);
 
-	if (zc->flags & IORING_RECVSEND_FIXED_BUF) {
-		ret = io_import_fixed(ITER_SOURCE, &msg.msg_iter, req->imu,
-					(u64)(uintptr_t)zc->buf, zc->len);
-		if (unlikely(ret))
-			return ret;
-		msg.sg_from_iter = io_sg_from_iter;
-	} else {
-		io_notif_set_extended(zc->notif);
-		ret = import_ubuf(ITER_SOURCE, zc->buf, zc->len, &msg.msg_iter);
+	if (!zc->done_io) {
+		ret = io_send_zc_import(req, kmsg);
 		if (unlikely(ret))
 			return ret;
-		ret = io_notif_account_mem(zc->notif, zc->len);
-		if (unlikely(ret))
-			return ret;
-		msg.sg_from_iter = io_sg_from_iter_iovec;
 	}
 
 	msg_flags = zc->msg_flags | MSG_ZEROCOPY;
 	if (issue_flags & IO_URING_F_NONBLOCK)
 		msg_flags |= MSG_DONTWAIT;
 	if (msg_flags & MSG_WAITALL)
-		min_ret = iov_iter_count(&msg.msg_iter);
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 	msg_flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
 
-	msg.msg_flags = msg_flags;
-	msg.msg_ubuf = &io_notif_to_data(zc->notif)->uarg;
-	ret = sock_sendmsg(sock, &msg);
+	kmsg->msg.msg_flags = msg_flags;
+	kmsg->msg.msg_ubuf = &io_notif_to_data(zc->notif)->uarg;
+	ret = sock_sendmsg(sock, &kmsg->msg);
 
 	if (unlikely(ret < min_ret)) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_addr(req, &__address, issue_flags);
+			return io_setup_async_msg(req, kmsg, issue_flags);
 
-		if (ret > 0 && io_net_retry(sock, msg.msg_flags)) {
+		if (ret > 0 && io_net_retry(sock, kmsg->msg.msg_flags)) {
 			zc->len -= ret;
 			zc->buf += ret;
 			zc->done_io += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return io_setup_async_addr(req, &__address, issue_flags);
+			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1251,6 +1258,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_notif_flush(zc->notif);
+		io_netmsg_recycle(req, issue_flags);
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 9c080aadc5a6..b0a990c6bbff 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -602,6 +602,7 @@ const struct io_cold_def io_cold_defs[] = {
 		.name			= "SEND",
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
+		.cleanup		= io_sendmsg_recvmsg_cleanup,
 		.fail			= io_sendrecv_fail,
 		.prep_async		= io_send_prep_async,
 #endif
-- 
2.43.0


