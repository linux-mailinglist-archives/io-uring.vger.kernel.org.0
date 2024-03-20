Return-Path: <io-uring+bounces-1146-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 42F8F880901
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id D3877B238B2
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD8307489;
	Wed, 20 Mar 2024 01:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DEKD0TP+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68881523D
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897782; cv=none; b=P5/S/Ks30nQ+bsGq9mNGTBaDzjqNRVmJ1Z3EfCqB89xexG7Ck72ZxtnTF/oos+WVljheZnrLhntGGrZy59KqWjgQUxkEJE9VI4S3noXT6IBN91CeVldixv8hNcbEYr6K4oKVE3DP4Cy6mc+MZDY3W2OmJbUkkD2+T1pUmrV/kdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897782; c=relaxed/simple;
	bh=+SQErtN0ghCoyRkAkCTpTxBxeXSRJLYOkbX9sdNg8Cg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=phpKG1niWysSpQ1HCPSveu8EqDKYBO1dGAHN0d1K0mkZNOqHXmZ9HTCef4ziIEd0Ng9PeiiZPx69GawE43q+hW3qMIBGlIwedWpLpLi/iBEomPpNXLbj0OGOD7OF7srssY4DDE/sedBfEbyPthBjGUuMWEjiX49hwOORSEQ3uxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DEKD0TP+; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6e6c38be762so941715b3a.1
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897779; x=1711502579; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m0ERWSADulJ+IP6ADJvW4gJHm8zTlL+F/+4A6drzXvo=;
        b=DEKD0TP+4k3PsyZXOxoWhaRvKacnLtDa3W/XArWf0ZSxfib2g6tRYUFII4AJrCpROY
         q+tINusqLOsWhLRkWo64mt9TT6Q5/JIEx3UCuoIfaA2XGOIq7V0642jS7nswl4Zz8P7w
         W5WAv/07eJtBfT43rsX10bUgbjKC5eeMOPESq0cYoMf6JUKdoFi8uoMUsk06/FPeEs4/
         jn5allnv7vVJcbAnks6QVjTg3pcUAq4dtikFB1G7TnMk2CSj3kfe0U4D6L08tWx6DzBC
         XjtZuw2Op0y25fEn68CpiWaUBerPrG7asSULamv6lUgxIdqNq/Z5N7lnpktJgfKKXBBZ
         /LIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897779; x=1711502579;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m0ERWSADulJ+IP6ADJvW4gJHm8zTlL+F/+4A6drzXvo=;
        b=lgPNHM4ZiyWU6PpAgQwYFQq8CeL3DLCD3hUJWkiE9y8F0P4eeWDvCjeOdn0zwnVFq5
         YRv/HjhQRlW/PoxGrNhB0aCfoGlDVFBChIDhcY4vPknYF8MTURLBEZJGvWJpVQYqTdAc
         fJWMRnoY+Y6DaSEHMOMPqY6MESpwTQJfkeiV/AAYwXIWrhwqEsyD9GAsWCdJtIEOtV5G
         06jiAO3zgyF6Qxg44duTR0SEJGVWkilKn4LJ9fuotMq5PqHTZ86SejkM1rpTGzNvtkAl
         hluMOGYGy5EXRROsCMdGKAX1NtjltV10GTflcuVOuBt0hrGT5gNlRyIvKWkc/ciQFpIE
         d1oQ==
X-Gm-Message-State: AOJu0Yw3N6uoKPsKqQCZuV/ajirHCsSGk3Q/t+B7dkwSxIFDPtO6jILE
	yFe3oEz9YXEdcjg/Ghfwr5L2RuwMQRMY3nkiVRWTq7YRpzcVDuGaoUm9GhQuNDaazV9VVk+3IFE
	Z
X-Google-Smtp-Source: AGHT+IH0wxU1MeXp3H9GBKASvgbuec99hZxtOU+oymhAP/wWhBKBsjTyB2M5Se+XiBPlvhUHE+VGBQ==
X-Received: by 2002:a05:6a00:9382:b0:6e6:864d:767 with SMTP id ka2-20020a056a00938200b006e6864d0767mr4278500pfb.3.1710897779040;
        Tue, 19 Mar 2024 18:22:59 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:22:57 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/15] io_uring/net: switch io_recv() to using io_async_msghdr
Date: Tue, 19 Mar 2024 19:17:30 -0600
Message-ID: <20240320012251.1120361-3-axboe@kernel.dk>
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
more state then we have now, if necessary.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 77 +++++++++++++++++++++++++++++-------------------
 io_uring/net.h   |  2 +-
 io_uring/opdef.c |  7 +++--
 3 files changed, 53 insertions(+), 33 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 7912a4fb2d0b..ff22f6cc859e 100644
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
@@ -707,13 +707,13 @@ static inline void io_recv_prep_retry(struct io_kiocb *req)
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
@@ -727,7 +727,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 
 		io_recv_prep_retry(req);
 		/* Known not-empty or unknown state, retry */
-		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || msg->msg_inq < 0) {
+		if (cflags & IORING_CQE_F_SOCK_NONEMPTY || kmsg->msg.msg_inq < 0) {
 			if (sr->nr_multishot_loops++ < MULTISHOT_MAX_RETRY)
 				return false;
 			/* mshot retries exceeded, force a requeue */
@@ -928,7 +928,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		io_kbuf_recycle(req, issue_flags);
 
-	if (!io_recv_finish(req, &ret, &kmsg->msg, mshot_finished, issue_flags))
+	if (!io_recv_finish(req, &ret, kmsg, mshot_finished, issue_flags))
 		goto retry_multishot;
 
 	if (mshot_finished)
@@ -942,29 +942,42 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -978,22 +991,23 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -1001,16 +1015,14 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -1022,9 +1034,14 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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
index 9d7962f65f26..281afef670a6 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -39,7 +39,7 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
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


