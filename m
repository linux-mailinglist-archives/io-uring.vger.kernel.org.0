Return-Path: <io-uring+bounces-1164-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B0558819AB
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D9AE7B24C7B
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A1341E87E;
	Wed, 20 Mar 2024 22:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="a6zILMlw"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 034C385C65
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975481; cv=none; b=ac24oapZAPjI59O0ImqSUvE29IBecp7iRl+vfibQ/+XQV5mSo/RU4B6k/6wXKkFvoRAm7v/AclcVxgOtXE9mlAdMhjPmnAOCertINZYZNarHlYao5LLwWN609EI1IZkUBNxTmHHs6sf/4afYJv0JhUDs+cvS+Q/beLUplRyvwPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975481; c=relaxed/simple;
	bh=0f6ZTCzHPr6SQVQhy1T+kZAfEPLk1THPHDAADumiOoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DCSaNiS0qq/Nt/wTJ3Zt2G16wtrwmZ1pzGdi7o1DwpULfPg5gwNzipxKy9yvOS6v7vAT56oqPhtMXmtb7XwT0aRKkMYrVf5c7hbvQmurPX9Y6GE6D0dssDG+41nRv6+2gUnh40rL87EJHLuHKtB0VGJMtk/c22FtmXTI0xjY0uI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=a6zILMlw; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so2537539f.1
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:57:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975477; x=1711580277; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3D9t78d3dIlx2g5fA/D2tgVcusYA1i2fkeNzecTe30c=;
        b=a6zILMlwkYBa82BJP18s06uPpJYWb4n7htmAueN+7/pnw8X20OHTU0hWr7srfN3hyr
         T6OhvDS5SWWUXhadRsfyv/Mk030NlfSUZz+v2rAoe3i/XKLwlNypO/DVD+VPqPEybDa4
         k4BrLOn8fH4Hfo3oJINnmFuOv9SE5S4N1QQkMmP3A362QMXpWg4RNLWZKS9Jx7sxWjjS
         WH9aWH6Fv0aqIwosFxkKlNprqxItM1wF2FPD1zUxmMYp2FeZVU/LwbMjTFZFUFm31bFb
         g+Ge3n+Kr+KuEze3rDJqnlVanaYyZDVs5LuhoNUmzpAvuQzkzjY1Kb1Hevcp7/y+2pOi
         9Csw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975477; x=1711580277;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3D9t78d3dIlx2g5fA/D2tgVcusYA1i2fkeNzecTe30c=;
        b=l4Fa5pVd96LjBqCEDlOPuVmAj4qL6394EvhMbC1ywjk+pFJHCdaJPK9EHSPUMGJRpR
         z/C803bsVz3Qs3rhH46qZnr2C0xg+nSnxZsT/26Gphz+5U3uruiiXwGu+T5IeCNUuXP0
         tX3jN37LYSPf30pComRIE8K4pwgS+pi+3pBBG7w8QgfRje+MxCz/Pb8mNrk3Bd4UP9UI
         8mxeQi8fADPAjqjdza1HJcSXYberhjfyHS7DZwcNdP4kSZVDmJuCK4A39cmFGK9POVFC
         iJHymdpBPY38C6xNpD4kHgT9/0Tw6t2PHqgHMHdeVyumV49qCiRg/UJqIFqqnZ2SpmAU
         wX1A==
X-Gm-Message-State: AOJu0YysKh3tGbpB4w7AteXO4n4cjF9x40DB76z9wBgH0fVyIzfzzL+T
	BjZbjOzjF7HuyWySUKx1D+j5eS/Nxrz0+f4iO2F9ekZYIiaJP50ODnKu9X2MT9H8ZPNyoBhZLhd
	9
X-Google-Smtp-Source: AGHT+IEiHOSOXosNqaOtQoJC+jhJGdNlUPli/Evog8iwLXbxFVFz8thImsXYyZAV7YUTjSz0CvIhNA==
X-Received: by 2002:a5e:c10d:0:b0:7cf:28df:79e2 with SMTP id v13-20020a5ec10d000000b007cf28df79e2mr700581iol.1.1710975477464;
        Wed, 20 Mar 2024 15:57:57 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:57:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/17] io_uring/net: switch io_recv() to using io_async_msghdr
Date: Wed, 20 Mar 2024 16:55:17 -0600
Message-ID: <20240320225750.1769647-3-axboe@kernel.dk>
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
more state then we have now, if necessary.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 75 ++++++++++++++++++++++++++++++------------------
 io_uring/net.h   |  2 +-
 io_uring/opdef.c |  7 +++--
 3 files changed, 53 insertions(+), 31 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index a16838c0c837..d571115f4909 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -320,7 +320,7 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 	return ret;
 }
 
-int io_send_prep_async(struct io_kiocb *req)
+int io_sendrecv_prep_async(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *io;
@@ -705,13 +705,13 @@ static inline void io_recv_prep_retry(struct io_kiocb *req)
  * again (for multishot).
  */
 static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
-				  struct msghdr *msg, bool mshot_finished,
-				  unsigned issue_flags)
+				  struct io_async_msghdr *kmsg,
+				  bool mshot_finished, unsigned issue_flags)
 {
 	unsigned int cflags;
 
 	cflags = io_put_kbuf(req, issue_flags);
-	if (msg->msg_inq > 0)
+	if (kmsg->msg.msg_inq > 0)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	/*
@@ -725,7 +725,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 
 		io_recv_prep_retry(req);
 		/* Known not-empty or unknown state, retry */
-		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq < 0) {
+		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || kmsg->msg.msg_inq < 0) {
 			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
 				return false;
 			/* mshot retries exceeded, force a requeue */
@@ -926,7 +926,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		io_kbuf_recycle(req, issue_flags);
 
-	if (!io_recv_finish(req, &ret, &kmsg->msg, mshot_finished, issue_flags))
+	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
 		goto retry_multishot;
 
 	if (mshot_finished)
@@ -940,29 +940,42 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct msghdr msg;
+	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	size_t len = sr->len;
 
+	if (req_has_async_data(req)) {
+		kmsg = req->async_data;
+	} else {
+		kmsg = &iomsg;
+		kmsg->free_iov = NULL;
+		kmsg->msg.msg_name = NULL;
+		kmsg->msg.msg_namelen = 0;
+		kmsg->msg.msg_control = NULL;
+		kmsg->msg.msg_get_inq = 1;
+		kmsg->msg.msg_controllen = 0;
+		kmsg->msg.msg_iocb = NULL;
+		kmsg->msg.msg_ubuf = NULL;
+
+		if (!io_do_buffer_select(req)) {
+			ret = import_ubuf(ITER_DEST, sr->buf, sr->len,
+					  &kmsg->msg.msg_iter);
+			if (unlikely(ret))
+				return ret;
+		}
+	}
+
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return -EAGAIN;
+		return io_setup_async_msg(req, kmsg, issue_flags);
 
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	msg.msg_name = NULL;
-	msg.msg_namelen = 0;
-	msg.msg_control = NULL;
-	msg.msg_get_inq = 1;
-	msg.msg_controllen = 0;
-	msg.msg_iocb = NULL;
-	msg.msg_ubuf = NULL;
-
 	flags = sr->msg_flags;
 	if (force_nonblock)
 		flags |= MSG_DONTWAIT;
@@ -976,22 +989,23 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			return -ENOBUFS;
 		sr->buf = buf;
 		sr->len = len;
+		ret = import_ubuf(ITER_DEST, sr->buf, sr->len,
+				  &kmsg->msg.msg_iter);
+		if (unlikely(ret))
+			goto out_free;
 	}
 
-	ret = import_ubuf(ITER_DEST, sr->buf, len, &msg.msg_iter);
-	if (unlikely(ret))
-		goto out_free;
-
-	msg.msg_inq = -1;
-	msg.msg_flags = 0;
+	kmsg->msg.msg_inq = -1;
+	kmsg->msg.msg_flags = 0;
 
 	if (flags & MSG_WAITALL)
-		min_ret = iov_iter_count(&msg.msg_iter);
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
 
-	ret = sock_recvmsg(sock, &msg, flags);
+	ret = sock_recvmsg(sock, &kmsg->msg, flags);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
-			if (issue_flags & IO_URING_F_MULTISHOT) {
+			ret = io_setup_async_msg(req, kmsg, issue_flags);
+			if (ret == -EAGAIN && issue_flags & IO_URING_F_MULTISHOT) {
 				io_kbuf_recycle(req, issue_flags);
 				return IOU_ISSUE_SKIP_COMPLETE;
 			}
@@ -1003,12 +1017,12 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			sr->buf += ret;
 			sr->done_io += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			return -EAGAIN;
+			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
-	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
+	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 out_free:
 		req_set_fail(req);
 	}
@@ -1020,9 +1034,14 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		io_kbuf_recycle(req, issue_flags);
 
-	if (!io_recv_finish(req, &ret, &msg, ret <= 0, issue_flags))
+	if (!io_recv_finish(req, &ret, kmsg, ret <= 0, issue_flags))
 		goto retry_multishot;
 
+	if (ret == -EAGAIN)
+		return io_setup_async_msg(req, kmsg, issue_flags);
+	else if (ret != IOU_OK && ret != IOU_STOP_MULTISHOT)
+		io_req_msg_cleanup(req, kmsg, issue_flags);
+
 	return ret;
 }
 
diff --git a/io_uring/net.h b/io_uring/net.h
index 191009979bcb..5c1230f1aaf9 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -40,7 +40,7 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_send(struct io_kiocb *req, unsigned int issue_flags);
-int io_send_prep_async(struct io_kiocb *req);
+int io_sendrecv_prep_async(struct io_kiocb *req);
 
 int io_recvmsg_prep_async(struct io_kiocb *req);
 int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index b0a990c6bbff..77131826d603 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -604,13 +604,16 @@ const struct io_cold_def io_cold_defs[] = {
 		.async_size		= sizeof(struct io_async_msghdr),
 		.cleanup		= io_sendmsg_recvmsg_cleanup,
 		.fail			= io_sendrecv_fail,
-		.prep_async		= io_send_prep_async,
+		.prep_async		= io_sendrecv_prep_async,
 #endif
 	},
 	[IORING_OP_RECV] = {
 		.name			= "RECV",
 #if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
+		.cleanup		= io_sendmsg_recvmsg_cleanup,
 		.fail			= io_sendrecv_fail,
+		.prep_async		= io_sendrecv_prep_async,
 #endif
 	},
 	[IORING_OP_OPENAT2] = {
@@ -687,7 +690,7 @@ const struct io_cold_def io_cold_defs[] = {
 		.name			= "SEND_ZC",
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
-		.prep_async		= io_send_prep_async,
+		.prep_async		= io_sendrecv_prep_async,
 		.cleanup		= io_send_zc_cleanup,
 		.fail			= io_sendrecv_fail,
 #endif
-- 
2.43.0


