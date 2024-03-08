Return-Path: <io-uring+bounces-879-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 16049876E01
	for <lists+io-uring@lfdr.de>; Sat,  9 Mar 2024 00:51:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 391741C21D8C
	for <lists+io-uring@lfdr.de>; Fri,  8 Mar 2024 23:51:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F2863BBCA;
	Fri,  8 Mar 2024 23:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="u5sEDg+w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AC323BBDF
	for <io-uring@vger.kernel.org>; Fri,  8 Mar 2024 23:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709941865; cv=none; b=RSgNpuK3lu4uX2fRVmCPuSGinrRNDLZ/GUphGqoW80KWtWo3bYNN50hIeSIKox7buhpYVVEkzwqPcfT8kVE7P2l2HdncN8ilS1RNqG5jIXJ1PKf43G3xr8EGFL6vY0dKXPzAfneFphU8nE9FGKr/kzzjwhCTaqYpSFqaIzuSd0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709941865; c=relaxed/simple;
	bh=9UW8qBwf9UAc88RLcTIsCUBA3dLwCJS6ZsATmHYT4UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZHjLOUCF1E+NQ3fxrtRer8yy7zotI5690Dqz3PkP8AeYuYBu8eUcKP1A4Ynx1PlbitPXSVg9QWrljUySXl7BwC8sd7+GIKaITDN2h5PeZljTLlLUSY+Kx2HbthXFWqJvkIctFzP2nTtzJE2rXAb3DbG1IRMx4xSOS/TyQOzHb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=u5sEDg+w; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-365c0dfc769so2589495ab.1
        for <io-uring@vger.kernel.org>; Fri, 08 Mar 2024 15:51:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709941862; x=1710546662; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LnfRfMCVXzTKxTqnhLkiRrq9TkSQydBtlMBGU1s1kPc=;
        b=u5sEDg+wEyE0s3YUM8DFzPJkUnUoooGPXVHaI1eIILaxXKeqdS+JhAynce0/d7XNAs
         j8hJP21ruBt8ud4oVc3zZ0gKZIv9KECHY+HLr2nnNIwCSJpm0ZdJE/L6ybHjvMvf5rJk
         w3OmZvbcHo613JxquLdAAe4mKzZZtYLSz/YkWc8zuH0djhDSjb1rtDeVjB/Npi0QtQ5V
         JV2UBAvW7yfsEu9Oj4Pw+/NV7+pastMU2wcwNUe1awZZSNEgBlu73u7jKLQ2X25vKZb6
         0Ymd6sfJY59UJq81ALmWTw3H4KylrmlBVg5wFAJL3gmb2Ad71Q3xxHzoCMV+NOzLauke
         kAQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709941862; x=1710546662;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LnfRfMCVXzTKxTqnhLkiRrq9TkSQydBtlMBGU1s1kPc=;
        b=bF8o3/5AkSlus3niAJK72IVRL1hcB7YizpWovDBUCzBPSUXS6BLJW/7qkGgTTj/3oA
         CcsrTtSV8a8DUoYb+fiiBzgTarfzXN84yBURVpR24OZVk8US+7dSr3rloR23nSfGQXjU
         K+iEUiG2pUBkdCOhVsDhPfSLarr/Z+RN7+OnlW80lNN6G8vjUi2A3RICqKvflcg5h/ts
         ud3tYklM6OE6+dp9iNbAQfrvLZbKLuHNkq+asa+hxAKgyZqAkHrTZFEUK0Gvlo+vJZYp
         l5yMWbQQ7m1RmonmYxOjL1i9WKc5JSqhdWI0g+EES4HoPHdm/MBZOfvltrEkUq8e6U38
         4iJw==
X-Gm-Message-State: AOJu0Yy7qbpeNGctJ1heMgTsHW6bY0KTsjPd1KoeNaVSqlGOxhueafSN
	AczxzWJCL5aChbBpgL7JVwnIu5IUdhdYmyCK9xlFD4/nlt515MGzYGuVnRTMF/fn3evi5j2rHwF
	h
X-Google-Smtp-Source: AGHT+IEEPLmBz/fgtIui8x1nnD6juOEWau6rusl6cTNFec3qIb/Nknteti5lRysDbD4OIGpLitOlyA==
X-Received: by 2002:a6b:6514:0:b0:7c8:9f0c:bd92 with SMTP id z20-20020a6b6514000000b007c89f0cbd92mr349523iob.2.1709941862362;
        Fri, 08 Mar 2024 15:51:02 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a056602208d00b007c870de3183sm94159ioa.49.2024.03.08.15.51.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Mar 2024 15:51:00 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	dyudaken@gmail.com,
	dw@davidwei.uk,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/7] io_uring/net: switch io_recv() to using io_async_msghdr
Date: Fri,  8 Mar 2024 16:34:11 -0700
Message-ID: <20240308235045.1014125-7-axboe@kernel.dk>
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
more state then we have now, if necessary.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 78 +++++++++++++++++++++++++++++-------------------
 io_uring/net.h   |  2 +-
 io_uring/opdef.c |  7 +++--
 3 files changed, 54 insertions(+), 33 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 0c4273005a68..07831e764068 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -330,7 +330,7 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 	return ret;
 }
 
-int io_send_prep_async(struct io_kiocb *req)
+int io_sendrecv_prep_async(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *io;
@@ -815,13 +815,13 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
@@ -836,7 +836,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 
 		io_mshot_prep_retry(req);
 		/* Known not-empty or unknown state, retry */
-		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq < 0) {
+		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || kmsg->msg.msg_inq < 0) {
 			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
 				return false;
 			/* mshot retries exceeded, force a requeue */
@@ -1037,7 +1037,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		io_kbuf_recycle(req, issue_flags);
 
-	if (!io_recv_finish(req, &ret, &kmsg->msg, mshot_finished, issue_flags))
+	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
 		goto retry_multishot;
 
 	if (mshot_finished)
@@ -1051,29 +1051,42 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -1087,22 +1100,23 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -1110,16 +1124,14 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
-			sr->len -= ret;
-			sr->buf += ret;
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
@@ -1131,9 +1143,15 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		io_kbuf_recycle(req, issue_flags);
 
-	if (!io_recv_finish(req, &ret, &msg, ret <= 0, issue_flags))
+	if (!io_recv_finish(req, &ret, kmsg, ret <= 0, issue_flags)) {
+		if (kmsg->free_iov) {
+			kfree(kmsg->free_iov);
+			kmsg->free_iov = NULL;
+		}
 		goto retry_multishot;
+	}
 
+	io_req_msg_cleanup(req, kmsg, issue_flags);
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
index dd932d1058f6..352f743d6a69 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -605,13 +605,16 @@ const struct io_cold_def io_cold_defs[] = {
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
@@ -688,7 +691,7 @@ const struct io_cold_def io_cold_defs[] = {
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


