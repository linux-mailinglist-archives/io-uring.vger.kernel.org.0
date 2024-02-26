Return-Path: <io-uring+bounces-763-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 433108680F1
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 20:25:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EB7CF28988C
	for <lists+io-uring@lfdr.de>; Mon, 26 Feb 2024 19:25:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B13712FF88;
	Mon, 26 Feb 2024 19:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="VlC81yeZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7614E12FF7F
	for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 19:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708975522; cv=none; b=eE7YijM1hw4U1Eh2i3U85NL7qS6SWefgC5ro65yPO4v58bH7VzJNYWkCDpVISiqFyTiM2DSoR+jsGDJK/1jp6llhsaL3z1DVwcaKh14SIHiZur+O2ejeDZxCx0kt7mem9ZNFi0nnVT5Le2G54g6aBXBbtAT30PUcU9g3L4UQtqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708975522; c=relaxed/simple;
	bh=RSZ7OAR/cdx1MKHXbpc9WXDFWd/9DySwAtqKqqNeQ2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hiDj0y6mHpGP3Q1OZmadbKP8lMPGiMuIW12SB2ez7oXUcCnaG4LbN6ZvJqjTL/CLr+ou8zRCkOSzmyqS/mF4W/n2FVEAbOsd7HU3hvT71O0UrjYnL9kYDZHZnwR1SlmAfspl33z8gL34O74abeTA6jOcFh+qwJWQcwg8KU/oDjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=VlC81yeZ; arc=none smtp.client-ip=209.85.166.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso63531839f.0
        for <io-uring@vger.kernel.org>; Mon, 26 Feb 2024 11:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708975519; x=1709580319; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vxaakl5xXGXZYuGHWx27xL1pKmhVx1dRDWD4WvDRfjo=;
        b=VlC81yeZXWCQ65/RFtEUFkYZ5U3+p0Gm8xt7DTTY56VX1q+5q8NlrFmhsBv0t3kfbZ
         3gqfFLQb0Pp4KFNTeq/RBXLLmZyQzUyWVS52WYweVHeQsbrqayaDER1qvkWWE0/LJ4h4
         eIyjDRL6gelINmKSbTZKmJ/7cbBB5bcSwS5dK/jymgvLb3yzD9/PXC51dll10wTFqZ5N
         yyucTqNvNf/O5I2/TS1UZsCwU/9GHKgDR3bCNoIN1mgRQMYRHATLRK2Y0Nw7SXxiZGu7
         Ieozq7LPN4MSQNO4EomQ0Lzp5xeKw1dGqiubbsRoEO5S6yx0g8CbS64iEdu5SYYdKFRH
         mG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708975519; x=1709580319;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vxaakl5xXGXZYuGHWx27xL1pKmhVx1dRDWD4WvDRfjo=;
        b=PMD8hNGXhhBLSWq2Nhjc1mdRz67TfNfAZKUK85A9mwxPboxjuKoauGG1MX+hnoKG4U
         KKE/mbXrLuBz0Fw7CgWeoDK8FwlXqPmwS++GZbZbnzzmBiNJjsFX/xKsiIi1uYW9DEwi
         GYTaGY7EzZevJh6MFDIvF1zEJihXLWWiQwcsnkY7VtZb9zOoOb1Ytn50l5K5slDq8JLl
         knRs3dOY64NhUoD+ZYz1LwzqnR2OoeVsr3kJ0kmPNlRYjBakMKlpPpVD4ZgNxHGZ4bl7
         nYOBz+Huc98uL8NsRb529IslXsYMWhH4z3eyEJed5+/kjx3++q+DkkZDSoL3QAQt/07k
         khKw==
X-Gm-Message-State: AOJu0YxybpR5q7c6QRgeJ4ITevIrm38pkLBHkyd2xsLXbMZQcYRMJ7AB
	yWY8nntsBO6RZgSmIyce50/zhLLBeCl0+iBWsVpl6cl8In2EjpSp20QDZhmmajF5eoRlnfC/KXW
	q
X-Google-Smtp-Source: AGHT+IGTXLBIvrXy1bqI1legQ2mLeJvlOi2FUFMsleF1RxJPOF2QDzO9iPpTzT9G2e8/k1/O7rqTUw==
X-Received: by 2002:a6b:6501:0:b0:7c7:7f73:d1a with SMTP id z1-20020a6b6501000000b007c77f730d1amr7442256iob.1.1708975519210;
        Mon, 26 Feb 2024 11:25:19 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eh3-20020a056638298300b0047466fd3b1dsm1370484jab.22.2024.02.26.11.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Feb 2024 11:25:17 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/9] io_uring/net: support multishot for send
Date: Mon, 26 Feb 2024 12:21:20 -0700
Message-ID: <20240226192458.396832-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240226192458.396832-1-axboe@kernel.dk>
References: <20240226192458.396832-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This works very much like the receive side, except for sends. The idea
is that an application can fill outgoing buffers in a provided buffer
group, and then arm a single send that will service them all. For now
this variant just terminates when we are out of buffers to send, and
hence the application needs to re-arm it if IORING_CQE_F_MORE isn't
set, as per usual for multishot requests.

This only enables it for IORING_OP_SEND, IORING_OP_SENDMSG is coming
in a separate patch. However, this patch does do a lot of the prep
work that makes wiring up the sendmsg variant pretty trivial. They
share the prep side.

Enabling multishot for sends is, again, identical to the receive side.
The app sets IORING_SEND_MULTISHOT in sqe->ioprio. This flag is also
the same as IORING_RECV_MULTISHOT.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  8 ++++
 io_uring/net.c                | 90 ++++++++++++++++++++++++++++++-----
 2 files changed, 86 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 061147cdfbb0..feacc64c90a0 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -351,9 +351,17 @@ enum io_uring_op {
  *				0 is reported if zerocopy was actually possible.
  *				IORING_NOTIF_USAGE_ZC_COPIED if data was copied
  *				(at least partially).
+ *
+ * IORING_SEND_MULTISHOT	Multishot send. Like the recv equivalent, must
+ *				be used with provided buffers. Keeps sending
+ *				from the given buffer group ID until it is
+ *				empty. Sets IORING_CQE_F_MORE if more
+ *				completions should be expected on behalf of
+ *				the same SQE.
  */
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 #define IORING_RECV_MULTISHOT		(1U << 1)
+#define IORING_SEND_MULTISHOT		IORING_RECV_MULTISHOT
 #define IORING_RECVSEND_FIXED_BUF	(1U << 2)
 #define IORING_SEND_ZC_REPORT_USAGE	(1U << 3)
 
diff --git a/io_uring/net.c b/io_uring/net.c
index 9ef11883a34a..0b990df04ac7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -411,6 +411,8 @@ void io_sendmsg_recvmsg_cleanup(struct io_kiocb *req)
 	kfree(io->free_iov);
 }
 
+#define SENDMSG_FLAGS (IORING_RECVSEND_POLL_FIRST | IORING_SEND_MULTISHOT)
+
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -427,11 +429,17 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
 	sr->flags = READ_ONCE(sqe->ioprio);
-	if (sr->flags & ~IORING_RECVSEND_POLL_FIRST)
+	if (sr->flags & ~SENDMSG_FLAGS)
 		return -EINVAL;
 	sr->msg_flags = READ_ONCE(sqe->msg_flags) | MSG_NOSIGNAL;
 	if (sr->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
+	if (sr->flags & IORING_SEND_MULTISHOT) {
+		if (!(req->flags & REQ_F_BUFFER_SELECT))
+			return -EINVAL;
+		req->flags |= REQ_F_APOLL_MULTISHOT;
+		sr->buf_group = req->buf_index;
+	}
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -441,6 +449,44 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
+static inline bool io_send_finish(struct io_kiocb *req, int *ret,
+				  struct msghdr *msg, unsigned issue_flags)
+{
+	bool mshot_finished = *ret <= 0;
+	unsigned int cflags;
+
+	cflags = io_put_kbuf(req, issue_flags);
+
+	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
+		io_req_set_res(req, *ret, cflags);
+		*ret = IOU_OK;
+		return true;
+	}
+
+	if (mshot_finished || req->flags & REQ_F_BL_EMPTY)
+		goto finish;
+
+	/*
+	 * Fill CQE for this receive and see if we should keep trying to
+	 * receive from this socket.
+	 */
+	if (io_fill_cqe_req_aux(req, issue_flags & IO_URING_F_COMPLETE_DEFER,
+				*ret, cflags | IORING_CQE_F_MORE)) {
+		io_mshot_prep_retry(req);
+		*ret = IOU_ISSUE_SKIP_COMPLETE;
+		return false;
+	}
+
+	/* Otherwise stop multishot but use the current result. */
+finish:
+	io_req_set_res(req, *ret, cflags);
+	if (issue_flags & IO_URING_F_MULTISHOT)
+		*ret = IOU_STOP_MULTISHOT;
+	else
+		*ret = IOU_OK;
+	return true;
+}
+
 int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -523,7 +569,6 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	size_t len = sr->len;
 	struct socket *sock;
 	struct msghdr msg;
-	unsigned int cflags;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -552,10 +597,18 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return io_setup_async_addr(req, &__address, issue_flags);
 
+	if (!io_check_multishot(req, issue_flags))
+		return -EAGAIN;
+
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
+	flags = sr->msg_flags;
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+
+retry_multishot:
 	if (io_do_buffer_select(req)) {
 		void __user *buf;
 
@@ -570,19 +623,28 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	flags = sr->msg_flags;
-	if (issue_flags & IO_URING_F_NONBLOCK)
-		flags |= MSG_DONTWAIT;
-	if (flags & MSG_WAITALL)
+	/*
+	 * If MSG_WAITALL is set, or this is a multishot send, then we need
+	 * the full amount. If just multishot is set, if we do a short send
+	 * then we complete the multishot sequence rather than continue on.
+	 */
+	if (flags & MSG_WAITALL || req->flags & REQ_F_APOLL_MULTISHOT)
 		min_ret = iov_iter_count(&msg.msg_iter);
 
 	flags &= ~MSG_INTERNAL_SENDMSG_FLAGS;
 	msg.msg_flags = flags;
 	ret = sock_sendmsg(sock, &msg);
 	if (ret < min_ret) {
-		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return io_setup_async_addr(req, &__address, issue_flags);
-
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK)) {
+			ret = io_setup_async_addr(req, &__address, issue_flags);
+			if (ret != -EAGAIN)
+				return ret;
+			if (issue_flags & IO_URING_F_MULTISHOT) {
+				io_kbuf_recycle(req, issue_flags);
+				return IOU_ISSUE_SKIP_COMPLETE;
+			}
+			return -EAGAIN;
+		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->len -= ret;
 			sr->buf += ret;
@@ -598,9 +660,13 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
-	cflags = io_put_kbuf(req, issue_flags);
-	io_req_set_res(req, ret, cflags);
-	return IOU_OK;
+	else
+		io_kbuf_recycle(req, issue_flags);
+
+	if (!io_send_finish(req, &ret, &msg, issue_flags))
+		goto retry_multishot;
+
+	return ret;
 }
 
 int io_recvmsg_prep_async(struct io_kiocb *req)
-- 
2.43.0


