Return-Path: <io-uring+bounces-1148-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 022E4880905
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 66D01B2393C
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E0521364;
	Wed, 20 Mar 2024 01:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Ra5t1b3N"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2911779CB
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897787; cv=none; b=Q8qnOSrEHqNHy1oRhqCzzYmsTv5dCrs1p0L1bA0U0Cqh7UJL4JQTC3ceJGB5WXw8SCsQSgokn9YKKavbuzMLHtSlB2zmDDYluFx/ucX1xKGfI6nQluol4n6eMsUyWEjk6MVLz4OXCF07tYYtaOWR2E3EOU+LfMbhzKMng7gBzW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897787; c=relaxed/simple;
	bh=tivHDBEL+WtYymt0cZGSjZSqi4yCY7Ied12bwk+0D2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k7bp8XMQtBLy6YlpmID+Zd0O4Bfns3wTbEConRbssQgfKFVYL8ZOk/ZmfrODETrSDTC4+69A/x8h+bMHq+C7gg9QfKAXGk3pTHGq234Y81u5bnjYuc+oda83Calz3DZYS6s9jcjKByC7keWpTtoZaIT5dHbiA92qYpmiV/ZBa6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Ra5t1b3N; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6e677ec9508so776624a34.1
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897784; x=1711502584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PVIzvL86EshOfsNRSGCowXS0RPvzEb/Uc/uFMq6Rfiw=;
        b=Ra5t1b3Ne4Qf8jQskrJZ4lrkoybwARc6uVxm4fAaZVjsiYr1vdy8cpRo2XUurvupnL
         XramJhvkPCJ6S3oE+yYtqbnppyMf+NQjyyH/GzyamkgNWkMXbkklZFyes1OQk7xZxASE
         OfwPZz/PQGa4X8Dg4ADXrdMglLBnrMGNdObL37z0oHfTbU1rkkesrGguGUSlUSsma8ZH
         8KREe/YQCcAHyGfveJL0c6PLnRDu7/ctcvhrSWAg66qIZI30tC0gV/ETCXbYOBQhz7VV
         ukE1adw4Hmykru/ECJi9DdlHUgKPuQus2z5Jy/c0xX+Dy8b0sXWjlPuicbWlhWQ/mT1f
         RACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897784; x=1711502584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PVIzvL86EshOfsNRSGCowXS0RPvzEb/Uc/uFMq6Rfiw=;
        b=KoQ2pQxKTaN5OBVS3E0IWd5ce7RbTSTTMnd6a9+ahHQmJMS2gyXhfTHHMX8DyHTwnY
         dai8GKA82tDPUTm/w/kjGhn9IjsUEtHhpjFjtX3RsP3cXmSjPQBZv8U8CnED4ZriqfLX
         OvFLM/yODloNMeZY1fdaLf9wyMBiyMyWd95QZE/rwdZvcMNyuP1b1126S6NZyrFy6uti
         BSPtpRR9n3AqTYSzkGuJY63F8WUmZWPbmmqLI+tNRNb7dGl0t0hRciepMK+X0zWpkcXJ
         rBYEuKWaAWYm8H6/naxfoj8S3gmFl352xeMpJZNAHDbPk0QVf8/PVnwC/tc0wd3H0Ub/
         CIXg==
X-Gm-Message-State: AOJu0Yw6NAfn3iY2PAC6KU0G0/1kI0jf+K43RF+L0M3hp/HT/otcP5GS
	4doVoKwtq576HWr+0p+4uZTV7c4fMHIC00wxJHjPZFWQV0+/xjP6IjQ4czrv0RauVSLS9DmTLe3
	X
X-Google-Smtp-Source: AGHT+IHPcTWabU47Un5Tvlb/fjYvkMt/T083TkXvvRFMcqIPY2rC8vAM966fg32UvHqTuuhDpFPixQ==
X-Received: by 2002:a05:6358:7211:b0:17f:1d24:1432 with SMTP id h17-20020a056358721100b0017f1d241432mr843751rwa.3.1710897783573;
        Tue, 19 Mar 2024 18:23:03 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:23:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/15] io_uring/net: always setup an io_async_msghdr
Date: Tue, 19 Mar 2024 19:17:32 -0600
Message-ID: <20240320012251.1120361-5-axboe@kernel.dk>
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

Rather than use an on-stack one and then need to allocate and copy if
we have to go async, always grab one upfront. This should be very
cheap, and potentially even have cache hotness benefits for back-to-back
send/recv requests.

For any recv type of request, this is probably a good choice in general,
as it's expected that no data is available initially. For send this is
not necessarily the case, as we expect space to be available. However,
getting a cached io_async_msghdr is very cheap, and as it should be
cache hot, probably the difference here is neglible, if any.

A nice side benefit is that we can kill io_setup_async_msg completely,
which has some nasty iovec manipulation code.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 117 ++++++++++++++++++++-----------------------------
 1 file changed, 47 insertions(+), 70 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 2389bb1cc050..776ebfea8742 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -161,36 +161,6 @@ static inline struct io_async_msghdr *io_msg_alloc_async_prep(struct io_kiocb *r
 	return io_msg_alloc_async(req, 0);
 }
 
-static int io_setup_async_msg(struct io_kiocb *req,
-			      struct io_async_msghdr *kmsg,
-			      unsigned int issue_flags)
-{
-	struct io_async_msghdr *async_msg;
-
-	if (req_has_async_data(req))
-		return -EAGAIN;
-	async_msg = io_msg_alloc_async(req, issue_flags);
-	if (!async_msg) {
-		kfree(kmsg->free_iov);
-		return -ENOMEM;
-	}
-	req->flags |= REQ_F_NEED_CLEANUP;
-	memcpy(async_msg, kmsg, sizeof(*kmsg));
-	if (async_msg->msg.msg_name)
-		async_msg->msg.msg_name = &async_msg->addr;
-
-	if ((req->flags & REQ_F_BUFFER_SELECT) && !async_msg->msg.msg_iter.nr_segs)
-		return -EAGAIN;
-
-	/* if were using fast_iov, set it to the new one */
-	if (iter_is_iovec(&kmsg->msg.msg_iter) && !kmsg->free_iov) {
-		size_t fast_idx = iter_iov(&kmsg->msg.msg_iter) - kmsg->fast_iov;
-		async_msg->msg.msg_iter.__iov = &async_msg->fast_iov[fast_idx];
-	}
-
-	return -EAGAIN;
-}
-
 #ifdef CONFIG_COMPAT
 static int io_compat_msg_copy_hdr(struct io_kiocb *req,
 				  struct io_async_msghdr *iomsg,
@@ -409,7 +379,7 @@ static void io_req_msg_cleanup(struct io_kiocb *req,
 int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr iomsg, *kmsg;
+	struct io_async_msghdr *kmsg;
 	struct socket *sock;
 	unsigned flags;
 	int min_ret = 0;
@@ -423,15 +393,17 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		kmsg = req->async_data;
 		kmsg->msg.msg_control_user = sr->msg_control;
 	} else {
-		ret = io_sendmsg_copy_hdr(req, &iomsg);
+		kmsg = io_msg_alloc_async(req, issue_flags);
+		if (unlikely(!kmsg))
+			return -ENOMEM;
+		ret = io_sendmsg_copy_hdr(req, kmsg);
 		if (ret)
 			return ret;
-		kmsg = &iomsg;
 	}
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return io_setup_async_msg(req, kmsg, issue_flags);
+		return -EAGAIN;
 
 	flags = sr->msg_flags;
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -443,13 +415,13 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			kmsg->msg.msg_controllen = 0;
 			kmsg->msg.msg_control = NULL;
 			sr->done_io += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -465,7 +437,6 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 }
 
 static struct io_async_msghdr *io_send_setup(struct io_kiocb *req,
-					     struct io_async_msghdr *stack_msg,
 					     unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -475,8 +446,9 @@ static struct io_async_msghdr *io_send_setup(struct io_kiocb *req,
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
 	} else {
-		kmsg = stack_msg;
-		kmsg->free_iov = NULL;
+		kmsg = io_msg_alloc_async(req, issue_flags);
+		if (!kmsg)
+			return ERR_PTR(-ENOMEM);
 
 		if (sr->addr) {
 			ret = move_addr_to_kernel(sr->addr, sr->addr_len,
@@ -506,7 +478,7 @@ static struct io_async_msghdr *io_send_setup(struct io_kiocb *req,
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return ERR_PTR(io_setup_async_msg(req, kmsg, issue_flags));
+		return ERR_PTR(-EAGAIN);
 
 	return kmsg;
 }
@@ -514,7 +486,7 @@ static struct io_async_msghdr *io_send_setup(struct io_kiocb *req,
 int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr iomsg, *kmsg;
+	struct io_async_msghdr *kmsg;
 	size_t len = sr->len;
 	struct socket *sock;
 	unsigned flags;
@@ -525,7 +497,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	kmsg = io_send_setup(req, &iomsg, issue_flags);
+	kmsg = io_send_setup(req, issue_flags);
 	if (IS_ERR(kmsg))
 		return PTR_ERR(kmsg);
 
@@ -544,12 +516,12 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	ret = sock_sendmsg(sock, &kmsg->msg);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -740,9 +712,10 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 			sr->nr_multishot_loops = 0;
 			mshot_retry_ret = IOU_REQUEUE;
 		}
-		*ret = io_setup_async_msg(req, kmsg, issue_flags);
-		if (*ret == -EAGAIN && issue_flags & IO_URING_F_MULTISHOT)
+		if (issue_flags & IO_URING_F_MULTISHOT)
 			*ret = mshot_retry_ret;
+		else
+			*ret = -EAGAIN;
 		return true;
 	}
 
@@ -844,7 +817,7 @@ static int io_recvmsg_multishot(struct socket *sock, struct io_sr_msg *io,
 int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr iomsg, *kmsg;
+	struct io_async_msghdr *kmsg;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -858,15 +831,17 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
 	} else {
-		ret = io_recvmsg_copy_hdr(req, &iomsg);
+		kmsg = io_msg_alloc_async(req, issue_flags);
+		if (unlikely(!kmsg))
+			return -ENOMEM;
+		ret = io_recvmsg_copy_hdr(req, kmsg);
 		if (ret)
 			return ret;
-		kmsg = &iomsg;
 	}
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return io_setup_async_msg(req, kmsg, issue_flags);
+		return -EAGAIN;
 
 	flags = sr->msg_flags;
 	if (force_nonblock)
@@ -908,17 +883,16 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
-			ret = io_setup_async_msg(req, kmsg, issue_flags);
-			if (ret == -EAGAIN && (issue_flags & IO_URING_F_MULTISHOT)) {
+			if (issue_flags & IO_URING_F_MULTISHOT) {
 				io_kbuf_recycle(req, issue_flags);
 				return IOU_ISSUE_SKIP_COMPLETE;
 			}
-			return ret;
+			return -EAGAIN;
 		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -943,7 +917,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr iomsg, *kmsg;
+	struct io_async_msghdr *kmsg;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -953,7 +927,9 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
 	} else {
-		kmsg = &iomsg;
+		kmsg = io_msg_alloc_async(req, issue_flags);
+		if (unlikely(!kmsg))
+			return -ENOMEM;
 		kmsg->free_iov = NULL;
 		kmsg->msg.msg_name = NULL;
 		kmsg->msg.msg_namelen = 0;
@@ -973,7 +949,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return io_setup_async_msg(req, kmsg, issue_flags);
+		return -EAGAIN;
 
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
@@ -1007,8 +983,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	ret = sock_recvmsg(sock, &kmsg->msg, flags);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
-			ret = io_setup_async_msg(req, kmsg, issue_flags);
-			if (ret == -EAGAIN && issue_flags & IO_URING_F_MULTISHOT) {
+			if (issue_flags & IO_URING_F_MULTISHOT) {
 				io_kbuf_recycle(req, issue_flags);
 				return IOU_ISSUE_SKIP_COMPLETE;
 			}
@@ -1018,7 +993,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1214,7 +1189,7 @@ static int io_send_zc_import(struct io_kiocb *req, struct io_async_msghdr *kmsg)
 int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr iomsg, *kmsg;
+	struct io_async_msghdr *kmsg;
 	struct socket *sock;
 	unsigned msg_flags;
 	int ret, min_ret = 0;
@@ -1225,7 +1200,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	if (!test_bit(SOCK_SUPPORT_ZC, &sock->flags))
 		return -EOPNOTSUPP;
 
-	kmsg = io_send_setup(req, &iomsg, issue_flags);
+	kmsg = io_send_setup(req, issue_flags);
 	if (IS_ERR(kmsg))
 		return PTR_ERR(kmsg);
 
@@ -1248,12 +1223,12 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (unlikely(ret < min_ret)) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 
 		if (ret > 0 && io_net_retry(sock, kmsg->msg.msg_flags)) {
 			zc->done_io += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1281,7 +1256,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr iomsg, *kmsg;
+	struct io_async_msghdr *kmsg;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -1297,15 +1272,17 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	if (req_has_async_data(req)) {
 		kmsg = req->async_data;
 	} else {
-		ret = io_sendmsg_copy_hdr(req, &iomsg);
+		kmsg = io_msg_alloc_async(req, issue_flags);
+		if (unlikely(!kmsg))
+			return -ENOMEM;
+		ret = io_sendmsg_copy_hdr(req, kmsg);
 		if (ret)
 			return ret;
-		kmsg = &iomsg;
 	}
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return io_setup_async_msg(req, kmsg, issue_flags);
+		return -EAGAIN;
 
 	flags = sr->msg_flags | MSG_ZEROCOPY;
 	if (issue_flags & IO_URING_F_NONBLOCK)
@@ -1319,12 +1296,12 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (unlikely(ret < min_ret)) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
-- 
2.43.0


