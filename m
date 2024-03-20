Return-Path: <io-uring+bounces-1149-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7275E880904
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:13 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 910F91C226F6
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B2EF6FC7;
	Wed, 20 Mar 2024 01:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="wHRwsol8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27B96AB9
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897789; cv=none; b=smhIoASikonefZe3tUwSeqwWMAf/RjpTUgZPHH4PZI/MMD4I5xz4bkZEQjnwcYOKHnmajmWjgfEzXZ+r0GjvA7ESZtEqOL5uacZLUA2xMzo3ZQUr86YLDPsJhzVnalXDPFBW/qR6hxevWoxONcuYbMdznL3jhOlI9Ey8eVTEcZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897789; c=relaxed/simple;
	bh=kxp/f1iNAZs2D1AJZXzi1lJ0/2cNaq9CLp8NEOxtxIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Azwmejf53uVcvaRqHYDJwgkcm4H0f7a3LaG9u5QRoiLRTZC/4KvRdNG5bSbq5qlLMuUUmMVXy3jTb7MAO9tfosn9tledQ/O+uPb/AUaQ9hvuvlXEZPxns1839mGIi5rp6KE9TZXo6wwka8raq3iCtpjdGC7SWSn1XR6WmFrnOvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=wHRwsol8; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-5a48320f0f3so250384eaf.1
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897786; x=1711502586; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jh76wYFgOXm2vo5NRb3e0I5NUVtMiDvkSEJhtoXmii8=;
        b=wHRwsol8BkHk2eoLbR+SYvI6B6afo7YMRrPixZTOH9MLI9AthiAFHvq5/GksVzzcD4
         v1k3BpxRvfOMkKgykdiLfhq74gvnuxREZBo2RRlrNbN0tYUbYLqn/3C/YuGKhdvxJhw6
         ecSqBdUOP9H+KpRl5UeRtuM90NmCMOWdnr9sgqnd5IEkmPwZrULC/K56+Ne4gkhI3lnm
         pZgrA9astc/teV+PwHZvUHsG+HNh5/Z1a8aJEAnrKO9nekqpMj7BgYy6lPEbwEhIAZLX
         +IrWZcgAh6X9+aHrAdzTFgC7OeW5adF3lyFkjRh3EEkQJPLeZu8wOjbTsanuIVbKlOnQ
         nyBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897786; x=1711502586;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jh76wYFgOXm2vo5NRb3e0I5NUVtMiDvkSEJhtoXmii8=;
        b=fPMoAaM+eAf05usTMncQ1bleed6pySEMWBwjXgryazCM2IuSday88IXgLN1ddMSC0q
         syXA3PYkoSNsfsg9YBkAJnnQNzd7OWMBckSpBQ9k4FhnihqgsXfzAFhlFrDoPraYuvDr
         MGefXFk0R5o8c7EHTsPSPOcbDygheSKCCUQoEKGRWFHyf67CjvAjRD67tEZ/WXQQ79uw
         YgKHahEmOh8jdtVxIILwZ/uCm5tHQn17zWBN4cuDxhcNQQyqIV6VFg2TgFIqtVuo1kGT
         UOvTRhUCjJ13VfemfHlCObw4e+/tkzho/ld+OS/kmnhuOsZKtNiRoDmY2G3FtJBjZTy6
         CBAA==
X-Gm-Message-State: AOJu0YwHZ/moua1ZyJmB4d3nPU122wFoqDJ/SQ9Zu5IlhVbSdE7ziPKj
	UZpqa1ceEAdUJLh0JNysDFlmbPnMje1yWxny1yQs4FGsvCA/M+1mKuURl1/BvEhk3EOBDLw8l4G
	V
X-Google-Smtp-Source: AGHT+IEycmslRdmFZQHmmq6a810nnmvW+wW3TKznqhy2X4QFTnKNoEXAGOWSd1U0C6KhtasbQOSk6A==
X-Received: by 2002:a05:6358:5409:b0:17e:bbaf:4063 with SMTP id u9-20020a056358540900b0017ebbaf4063mr3740684rwe.2.1710897785679;
        Tue, 19 Mar 2024 18:23:05 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:23:04 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/15] io_uring/net: get rid of ->prep_async() for receive side
Date: Tue, 19 Mar 2024 19:17:33 -0600
Message-ID: <20240320012251.1120361-6-axboe@kernel.dk>
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
since it's now done unconditionally and hence does not need to be part
of the issue path. This reduces the footprint of the multishot fast
path of multiple invocations of ->issue() per prep, and also means that
we can drop using ->prep_async() for recvmsg as we now do this setup on
the prep side.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c   | 71 +++++++++++++++++++-----------------------------
 io_uring/net.h   |  1 -
 io_uring/opdef.c |  2 --
 3 files changed, 28 insertions(+), 46 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 776ebfea8742..50758442188b 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -598,17 +598,36 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
 					msg.msg_controllen);
 }
 
-int io_recvmsg_prep_async(struct io_kiocb *req)
+static int io_recvmsg_prep_setup(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *iomsg;
+	struct io_async_msghdr *kmsg;
 	int ret;
 
-	sr->done_io = 0;
-	if (!io_msg_alloc_async_prep(req))
+	/* always locked for prep */
+	kmsg = io_msg_alloc_async(req, 0);
+	if (unlikely(!kmsg))
 		return -ENOMEM;
-	iomsg = req->async_data;
-	ret = io_recvmsg_copy_hdr(req, iomsg);
+
+	if (req->opcode == IORING_OP_RECV) {
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
+		return 0;
+	}
+
+	ret = io_recvmsg_copy_hdr(req, kmsg);
 	if (!ret)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	return ret;
@@ -659,7 +678,7 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
 	sr->nr_multishot_loops = 0;
-	return 0;
+	return io_recvmsg_prep_setup(req);
 }
 
 static inline void io_recv_prep_retry(struct io_kiocb *req,
@@ -817,7 +836,7 @@ static int io_recvmsg_multishot(struct socket *sock, struct io_sr_msg *io,
 int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg;
+	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -828,17 +847,6 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	if (req_has_async_data(req)) {
-		kmsg = req->async_data;
-	} else {
-		kmsg = io_msg_alloc_async(req, issue_flags);
-		if (unlikely(!kmsg))
-			return -ENOMEM;
-		ret = io_recvmsg_copy_hdr(req, kmsg);
-		if (ret)
-			return ret;
-	}
-
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
@@ -917,36 +925,13 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg;
+	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	size_t len = sr->len;
 
-	if (req_has_async_data(req)) {
-		kmsg = req->async_data;
-	} else {
-		kmsg = io_msg_alloc_async(req, issue_flags);
-		if (unlikely(!kmsg))
-			return -ENOMEM;
-		kmsg->free_iov = NULL;
-		kmsg->msg.msg_name = NULL;
-		kmsg->msg.msg_namelen = 0;
-		kmsg->msg.msg_control = NULL;
-		kmsg->msg.msg_get_inq = 1;
-		kmsg->msg.msg_controllen = 0;
-		kmsg->msg.msg_iocb = NULL;
-		kmsg->msg.msg_ubuf = NULL;
-
-		if (!io_do_buffer_select(req)) {
-			ret = import_ubuf(ITER_DEST, sr->buf, sr->len,
-					  &kmsg->msg.msg_iter);
-			if (unlikely(ret))
-				return ret;
-		}
-	}
-
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
 		return -EAGAIN;
diff --git a/io_uring/net.h b/io_uring/net.h
index 281afef670a6..654324739346 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -41,7 +41,6 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags);
 int io_send(struct io_kiocb *req, unsigned int issue_flags);
 int io_sendrecv_prep_async(struct io_kiocb *req);
 
-int io_recvmsg_prep_async(struct io_kiocb *req);
 int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags);
 int io_recv(struct io_kiocb *req, unsigned int issue_flags);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 77131826d603..1368193edc57 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -536,7 +536,6 @@ const struct io_cold_def io_cold_defs[] = {
 		.name			= "RECVMSG",
 #if defined(CONFIG_NET)
 		.async_size		= sizeof(struct io_async_msghdr),
-		.prep_async		= io_recvmsg_prep_async,
 		.cleanup		= io_sendmsg_recvmsg_cleanup,
 		.fail			= io_sendrecv_fail,
 #endif
@@ -613,7 +612,6 @@ const struct io_cold_def io_cold_defs[] = {
 		.async_size		= sizeof(struct io_async_msghdr),
 		.cleanup		= io_sendmsg_recvmsg_cleanup,
 		.fail			= io_sendrecv_fail,
-		.prep_async		= io_sendrecv_prep_async,
 #endif
 	},
 	[IORING_OP_OPENAT2] = {
-- 
2.43.0


