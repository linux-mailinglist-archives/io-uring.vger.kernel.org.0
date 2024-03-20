Return-Path: <io-uring+bounces-1145-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D98E880900
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 70D591C22861
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 79FAC6FC3;
	Wed, 20 Mar 2024 01:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RxSc9OB/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682797489
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897781; cv=none; b=ma1NbhewZHA5bX+iSoVRUg1+mu4rkrGa+jzC4DBMSh8NEssTEMkyvw8lVa1lE7srRTP56/IWyOrXoKyiTo9Le1oTbWOoT5hFSZZv5MG2EUv9NoQoLDDbAEQ6lW0F14JGtlLxVaUlRFR3fwTZJGJxvCMw3zjZuev7OSQbXY/eWuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897781; c=relaxed/simple;
	bh=7vMskN9crckJXLTbyOoQ5AdBSdpzGmEiV9oSGPK7AoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AN1zT31rRpdMessxVzsMktXhZombpaD4E01dZYDthfnuQ3Qj1bmoLrWu5oHbGENl+ESLHCt5CfHOE3BOHnOd0q7UAs837iM6ao8TNK5wZiGFqAYTUZHWY/eUu3IP46UIxPKyAQBwht0+sus0KzmAEOPgwDI6ECnHaiiUndx+Ouk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RxSc9OB/; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-29c572d4b84so2010482a91.1
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897777; x=1711502577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UxL9SCcDmri6r5vo+Fn+IFDVaE2HKUZtNpPNcBwdPK4=;
        b=RxSc9OB/qwh6V6rNSWc+lSxa5w0WXJNgveWIVhfd4/pWyhhytmjsXVS9nH6BVuF7pS
         DJK8sEmoKSoC1+t4ra253lph9ny/XU8Uv63CHiB884q/hz0f4AZRF6J0afXFIVrzWsxG
         TI2zE1zmzRyvVz5BFstFW3psUFc++1DejMD7mGXPHEeuoeZxrwSRYmn89FIfsApL15J6
         EGfbK0B6i88XZodXYW4C8cirLPBn2xPy+QdvLlIxlHLsRWYeZCMmNMHTLzDLih8tdQ02
         LD5BBWANVqsnF+XLbR2vzrIKaaxgMWnPgKpXvmzi2agstU1xaCsDLLUWOXVAjaaFwo05
         ylVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897777; x=1711502577;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UxL9SCcDmri6r5vo+Fn+IFDVaE2HKUZtNpPNcBwdPK4=;
        b=mpZbYcwk3GoCWuQ+uzIXAFmZyxIqaK9Og3E1hYlz7jZeetIPwu3e4Deo9n/ojDk175
         zjxL/GNznFdmS+ZC31gRfzlJpTDpm6xEStJ1b2Vt5mS3CNn7qBSqinwcLzs5FlnIQDX0
         8dO8bX5YOuXNgIhZ+mCZCzRljXxOkQx99O8GDE2flj71BgA5u7dpAuZ64CRUtV1/ohfC
         N0XaVmcSxbmebDCWsSLJtSUxoAr9uD7OWWN1/+AbXSCqrI97vudmVBcb0Ecw4+wJ7/X1
         hCxw31OChn4pYvikNcYDrlYbXPu0yLkcRraljhGe9p9YUHwe1lsUlh15sLlI7vdLHpi+
         QV1g==
X-Gm-Message-State: AOJu0Yw9mzcCjWvmrdxwCzmLIuvxN7rvTz+fxMMgoLYV6Q4oqFAePKdG
	KsSP5cCJk4MOZurCuLfs/PgZbMOFRWbms1cWTBkTWgmoDtaMVxm40RyRaf6xSTcBftVaH6H6taM
	g
X-Google-Smtp-Source: AGHT+IFk82h/TvNkThEhppFtuBH/+7EM97pBHvp/qGIB8GUHn5yUdbOwOqKD+I/6tBXTUyx+fsZHfg==
X-Received: by 2002:a05:6a21:32a7:b0:1a3:622b:c405 with SMTP id yt39-20020a056a2132a700b001a3622bc405mr4611140pzb.3.1710897777157;
        Tue, 19 Mar 2024 18:22:57 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.22.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:22:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/15] io_uring/net: switch io_send() and io_send_zc() to using io_async_msghdr
Date: Tue, 19 Mar 2024 19:17:29 -0600
Message-ID: <20240320012251.1120361-2-axboe@kernel.dk>
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

No functional changes in this patch, just in preparation for carrying
more state then we have now, if necessary. While unifying some of this
code, add a generic send setup prep handler that they can both use.

This gets rid of some manual msghdr and sockaddr on the stack, and makes
it look a bit more like the sendmsg/recvmsg variants. We can probably
unify a bit more on top of this going forward.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 202 ++++++++++++++++++++++++-----------------------
 io_uring/opdef.c |   1 +
 2 files changed, 106 insertions(+), 97 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index ed798e185bbf..7912a4fb2d0b 100644
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
+	if (sr->addr)
+		return move_addr_to_kernel(sr->addr, sr->addr_len, &io->addr);
+	return 0;
 }
 
 int io_sendmsg_prep_async(struct io_kiocb *req)
@@ -475,45 +464,72 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
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
+	if (req_has_async_data(req)) {
+		kmsg = req->async_data;
+	} else {
+		kmsg = stack_msg;
+		kmsg->free_iov = NULL;
 
-			msg.msg_name = &io->addr;
-		} else {
-			ret = move_addr_to_kernel(sr->addr, sr->addr_len, &__address);
+		if (sr->addr) {
+			ret = move_addr_to_kernel(sr->addr, sr->addr_len,
+						  &kmsg->addr);
 			if (unlikely(ret < 0))
-				return ret;
-			msg.msg_name = (struct sockaddr *)&__address;
+				return ERR_PTR(ret);
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
+
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
 
@@ -521,21 +537,19 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
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
-			sr->len -= ret;
-			sr->buf += ret;
 			sr->done_io += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return io_setup_async_addr(req, &__address, issue_flags);
+			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -545,6 +559,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
+	io_req_msg_cleanup(req, kmsg, issue_flags);
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
@@ -1158,11 +1173,35 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
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
@@ -1173,67 +1212,35 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
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
-			zc->len -= ret;
-			zc->buf += ret;
+		if (ret > 0 && io_net_retry(sock, kmsg->msg.msg_flags)) {
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


