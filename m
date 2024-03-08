Return-Path: <io-uring+bounces-877-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A98ED876DFF
	for <lists+io-uring@lfdr.de>; Sat,  9 Mar 2024 00:51:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CCB0F1C21F15
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 23:51:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D3E23BBEA;
	Fri,  8 Mar 2024 23:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AG3eVWP0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2113BBEE
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 23:50:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709941862; cv=none; b=KoI3LD8jWSvoCQyzfBkcve4p/fTOJVeukbYy8JpKGnHGbrKeVM6Zstq7J0kRZF9SVKc/LszVfu3wJWoDV2Vam6HcJSbqIv3FpSRn/q086ES2tqxPKdWhVQ+iAbBXjf/UqWgImxPqKKK+I3g1+kJy2R9okZ26DLYcTH1XaiuE8TU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709941862; c=relaxed/simple;
	bh=F0kN9OLv7rL4letscrzSLqAu4z6REgqxKDTFViBhjlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WIK8FCbOvmo1+4k9jxTa/TM4sucfA9XKXdinrPKepiqbNpWNhNZDJjb4mBna3dIQG/dURlpGzQi/uzMS26P3zVVnKMMA2WxHA4QItz5lNg+J6XpUzln8l0hm/BrEt+bxNdJmOU7WCYFYgdqbP9iZjrVKhnBbzN2LzGizGeo2gug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AG3eVWP0; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7c876b9d070so40430739f.0
        for <io-uring@vger.kernel.org>; Fri, 08 Mar 2024 15:50:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709941858; x=1710546658; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EcPGEUioe70jVig95jNwAdxi3Za2g/yEgT5UCyQmVEU=;
        b=AG3eVWP0OI8ioo2201WPb9Vok2dWPkZJQCTXdEtuMgNvF3Gi3x847HMqyyUJ+7cL/E
         hpAncrKmzvXE/QmmcoZWR5qdfWcflWLNjy+EnV/pLm84H0vo4IOzH4gV/NEd8AWV+KbU
         1jqw02pQXe8Z1r53aFYa2uLg/542nmilXUbzRlVcOANNmKBeYQIF+R3P8kMgHQLIPWE3
         cLj4UDPq3+JxJ0TrIZm1BHL3s5Gp3bjk2mvRitLubhmysDJNUUY+H0SOm7K26RqqvocF
         o6CF00scM8LJDLOsV1c4TEepnTeJbc64WtPBY1UQnwdu3Stg1Qszcs9lTJmsGEmC7iVC
         EIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709941858; x=1710546658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EcPGEUioe70jVig95jNwAdxi3Za2g/yEgT5UCyQmVEU=;
        b=pymWFRyvxFlj5quNjpxzVy5AAYnLnQSm8xr4qF1608a+7oaD7QuD6H76E03xYeqUuo
         7vZPelu3c/QINVc90Kpmu4yrAqtwpHWm9n8PW0dQ6YBLGI+b6VKY9LHtvvo0af5l+Bch
         hw3HXaxJOMzuWGKnATqEdqK2hpA9JmlaYyW3giZ3BmRHWPI18kMHe5v/j8i2s1KyNYnE
         DTlu0cFxOvzeV+NMU5nBVWSVB7BDUUuAqe65tWMUWOW7s+2LApis7Kl6H210Jc9Tf5VF
         5QNbMVriBhEIDXH+2lA9eP5BsELKnc3queQmF7ro8MtR8Wk1U4yBXR231PN8DYN9Js71
         9ftw==
X-Gm-Message-State: AOJu0YwL5WkpTBIIuh25jD0lu82vUi9YWE4gAgcCenWkqJgK/zISrr4E
	Gp7hwBIeRkKsQJW0oWULpqkHMbkjV10Lgs3zbZslV3Zsif92hH5yXB7Ww0Az+4mwvD85+WF3A6a
	P
X-Google-Smtp-Source: AGHT+IE33YvToEKI3YIx7yp2F1KiPVf+JCBuNlrcvJntJa3kxrmFzmn90NQJSzEsp5pmiKntFc9DTg==
X-Received: by 2002:a5d:970e:0:b0:7c8:9e3c:783 with SMTP id h14-20020a5d970e000000b007c89e3c0783mr515707iol.0.1709941858516;
        Fri, 08 Mar 2024 15:50:58 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a056602208d00b007c870de3183sm94159ioa.49.2024.03.08.15.50.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 15:50:56 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/7] io_uring/net: switch io_send() and io_send_zc() to using io_async_msghdr
Date: Fri,  8 Mar 2024 16:34:09 -0700
Message-ID: <20240308235045.1014125-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240308235045.1014125-1-axboe@kernel.dk>
References: <20240308235045.1014125-1-axboe@kernel.dk>
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
 io_uring/net.c   | 208 ++++++++++++++++++++++++-----------------------
 io_uring/opdef.c |   1 +
 2 files changed, 109 insertions(+), 100 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 566ef401f976..66318fbba805 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -332,33 +332,23 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 
 int io_send_prep_async(struct io_kiocb *req)
 {
-	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *io;
 	int ret;
 
-	if (!zc->addr || req_has_async_data(req))
+	if (req_has_async_data(req))
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
+	memset(&io->msg, 0, sizeof(io->msg));
 
-	if (!sr->addr || req_has_async_data(req))
-		return -EAGAIN;
-	io = io_msg_alloc_async(req, issue_flags);
-	if (!io)
-		return -ENOMEM;
-	memcpy(&io->addr, addr_storage, sizeof(io->addr));
-	return -EAGAIN;
+	ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &io->msg.msg_iter);
+	if (unlikely(ret))
+		return ret;
+	if (sr->addr)
+		return move_addr_to_kernel(sr->addr, sr->addr_len, &io->addr);
+	return 0;
 }
 
 int io_sendmsg_prep_async(struct io_kiocb *req)
@@ -480,46 +470,72 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-int io_send(struct io_kiocb *req, unsigned int issue_flags)
+static struct io_async_msghdr *io_send_setup(struct io_kiocb *req,
+					     struct io_async_msghdr *stack_msg,
+					     unsigned int issue_flags)
 {
-	struct sockaddr_storage __address;
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	size_t len = sr->len;
-	struct socket *sock;
-	unsigned int cflags;
-	struct msghdr msg;
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
+	unsigned int cflags;
+	unsigned flags;
+	int min_ret = 0;
+	int ret;
 
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
+	kmsg = io_send_setup(req, &iomsg, issue_flags);
+	if (IS_ERR(kmsg))
+		return PTR_ERR(kmsg);
+
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
 
@@ -528,31 +544,29 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			return -ENOBUFS;
 		sr->buf = buf;
 		sr->len = len;
-	}
 
-	ret = import_ubuf(ITER_SOURCE, sr->buf, len, &msg.msg_iter);
-	if (unlikely(ret))
-		return ret;
+		ret = import_ubuf(ITER_SOURCE, sr->buf, len, &kmsg->msg.msg_iter);
+		if (unlikely(ret))
+			return ret;
+	}
 
 	flags = sr->msg_flags;
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
@@ -562,6 +576,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
+	io_req_msg_cleanup(req, kmsg, issue_flags);
 	cflags = io_put_kbuf(req, issue_flags);
 	io_req_set_res(req, ret, cflags);
 	return IOU_OK;
@@ -1165,11 +1180,35 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
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
@@ -1180,67 +1219,35 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
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
+	kmsg = io_send_setup(req, &iomsg, issue_flags);
+	if (IS_ERR(kmsg))
+		return PTR_ERR(kmsg);
 
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
-
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
@@ -1258,6 +1265,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!(issue_flags & IO_URING_F_UNLOCKED)) {
 		io_notif_flush(zc->notif);
+		io_netmsg_recycle(req, issue_flags);
 		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
 	io_req_set_res(req, ret, IORING_CQE_F_MORE);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 88fbe5cfd379..dd932d1058f6 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -603,6 +603,7 @@ const struct io_cold_def io_cold_defs[] = {
 		.name			= "SEND",
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
+		.cleanup		= io_sendmsg_recvmsg_cleanup,
 		.fail			= io_sendrecv_fail,
 		.prep_async		= io_send_prep_async,
 #endif
-- 
2.43.0


