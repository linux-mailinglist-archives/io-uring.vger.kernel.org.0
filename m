Return-Path: <io-uring+bounces-1166-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 210708819AF
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 8B732B24EBD
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6048285C59;
	Wed, 20 Mar 2024 22:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="dqn3xYOS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF0385C65
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975486; cv=none; b=hHTQm7I4hA7DRiIFMjHxZrvHIjnSLbokWa5rZb+AIdFn/XZmLAw2LGmTtYCbLF6Wlc1Ox1oxUPCOX4CKzgj5rCImtFrym1WCl5CyvDKma39aA5RS65G0YZZQkP6Wi5rxY9+pd240rYK58AlxVU3et5qflEUaj33J4s329LdDrAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975486; c=relaxed/simple;
	bh=HwbhZHPeos+lFR/ZyqIYdS0mIbBpKLUmTtkyrXBeJ6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdL4eU+hy2hJpZvI9mhPUvAy99P7Ge6ma+c5FPwfid24Vk5LDJH/WX8a6m5LAZKBpEXJBhBt9sOTw1wuDu2ld594zOQY2TXQGS3EiUPnO6j4OU3uj4e9iP43kBOn7SMkEXI+tLjrXSLODg5PE5RDaonNt5S28NZDkn+yBxgZ1ag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=dqn3xYOS; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-367c7daa395so273115ab.1
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975482; x=1711580282; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7YrHWAoNOnRsYzp8SwgXG4DXgNTDASp6CZ/nb6mbJro=;
        b=dqn3xYOSsPtydSCCVqioWp8oDEO6SG5Zzx/XmWNJoes1RZ57X+gdBSqULriL/tqm7l
         m4E6YBQWwJVa0IB9ij3SGz2npcW6LFNkqZiSA1PABU2F4rSV65TgbCnR37n5z3HgJK5t
         oGOt0WFzF9ypszEG2lPnyejsmQSw2FxCPCW/dgG7m6Utz3IZaklhABbh8yOQIAz7sToJ
         o2JZlgLUQXPG4uykCtyFLzo8FxlIBYihCE15kLSU7Nuersb9zQ6Ps6IppwvxFhslFMzY
         pkbSZGRlc5TzwxI3dpyNm+B3nQnA7nGeIQ+/dXyozXpS6exaxoQ+21pcK1AJAJe45cJX
         WqZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975482; x=1711580282;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7YrHWAoNOnRsYzp8SwgXG4DXgNTDASp6CZ/nb6mbJro=;
        b=hgafr8UCy3bRGu5F/BLs+1kXNyq+Nw9EPLASGGOPZR6Eb8KVjlrcVjV/GKMzWge7aE
         VG3cksvGQUJTpiPe3+gI6UzSyajP2j/LmctXa2mG+GJxF9g3cTJUfHuUUihNG/oUnxhC
         C09GSzYy2x6L09GorSjaxyr5wKOZGTBbcNGyAagXQ6mRZlzCi3JG6X60pUyVbpqbdEJN
         R1y+YC3LV2BwhKuVzUDRvqZmfxP6R3En78VzhtpLLdA7gcuQRy8okmJQRToBG2av+jG+
         Kj3KSx6ZX9HLJpa7qjcdew8y0sAW2iy3muQBe1yS4YmjIF2bG6il5PPH0LAnrzIrobuY
         hVNA==
X-Gm-Message-State: AOJu0Yyaun6l9YFVHfkrDIWvnxOBOhIvmrN1gqiRBBic9Qb8UBCp2s8g
	ZcT5L8khbFmI8XpCS8Cd/oqihjcKPlpqTSQGTFvHdfL3GqhZTzamUNS2SK4xoDXIeYwMCBaLDhb
	T
X-Google-Smtp-Source: AGHT+IEwTcG97u/QpWvP8cmfVpjqt8CFWI7T82GrFzx1ZKQD3zs9oqKZSbi80ivVesC0FTBSA8oRUQ==
X-Received: by 2002:a05:6602:5c2:b0:7ce:f921:6a42 with SMTP id w2-20020a05660205c200b007cef9216a42mr6207869iox.0.1710975482095;
        Wed, 20 Mar 2024 15:58:02 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.57.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:00 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 04/17] io_uring/net: always setup an io_async_msghdr
Date: Wed, 20 Mar 2024 16:55:19 -0600
Message-ID: <20240320225750.1769647-5-axboe@kernel.dk>
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
index 2df59fb19a15..14491fab6d59 100644
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
+		if (unlikely(!kmsg))
+			return ERR_PTR(-ENOMEM);
 		kmsg->msg.msg_name = NULL;
 		kmsg->msg.msg_namelen = 0;
 		kmsg->msg.msg_control = NULL;
@@ -502,7 +474,7 @@ static struct io_async_msghdr *io_send_setup(struct io_kiocb *req,
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return ERR_PTR(io_setup_async_msg(req, kmsg, issue_flags));
+		return ERR_PTR(-EAGAIN);
 
 	return kmsg;
 }
@@ -510,7 +482,7 @@ static struct io_async_msghdr *io_send_setup(struct io_kiocb *req,
 int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr iomsg, *kmsg;
+	struct io_async_msghdr *kmsg;
 	size_t len = sr->len;
 	struct socket *sock;
 	unsigned flags;
@@ -521,7 +493,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	kmsg = io_send_setup(req, &iomsg, issue_flags);
+	kmsg = io_send_setup(req, issue_flags);
 	if (IS_ERR(kmsg))
 		return PTR_ERR(kmsg);
 
@@ -540,14 +512,14 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	ret = sock_sendmsg(sock, &kmsg->msg);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -738,9 +710,10 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
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
 
@@ -842,7 +815,7 @@ static int io_recvmsg_multishot(struct socket *sock, struct io_sr_msg *io,
 int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr iomsg, *kmsg;
+	struct io_async_msghdr *kmsg;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -856,15 +829,17 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -906,17 +881,16 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
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
@@ -941,7 +915,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr iomsg, *kmsg;
+	struct io_async_msghdr *kmsg;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -951,7 +925,9 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -971,7 +947,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return io_setup_async_msg(req, kmsg, issue_flags);
+		return -EAGAIN;
 
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
@@ -1005,8 +981,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
 			sr->buf += ret;
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
 
@@ -1248,14 +1223,14 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (unlikely(ret < min_ret)) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 
 		if (ret > 0 && io_net_retry(sock, kmsg->msg.msg_flags)) {
 			zc->len -= ret;
 			zc->buf += ret;
 			zc->done_io += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return io_setup_async_msg(req, kmsg, issue_flags);
+			return -EAGAIN;
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1283,7 +1258,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr iomsg, *kmsg;
+	struct io_async_msghdr *kmsg;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -1299,15 +1274,17 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -1321,12 +1298,12 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 
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


