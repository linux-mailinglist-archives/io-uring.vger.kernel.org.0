Return-Path: <io-uring+bounces-1167-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B02AB8819AD
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB2BA1C211F6
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 787FC85C74;
	Wed, 20 Mar 2024 22:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="v8CGqNEq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7399785C48
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975487; cv=none; b=sTzUKzCcgR06l1rHL/sjUq97MnJrk+FSY79gxxzwdfCcwvUfb8p9CRFzW/P3KxzARqFpbMZIsUmgboIeryGk6/4qNrO376UwshyIWh6myG1DL38KlvOwGk82IW3JrNTsca+x82tusDbSKM0z2OMO/gYXS2CVjP+NiulZGGOU2+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975487; c=relaxed/simple;
	bh=XqMqcyuqekdt834sGtCRWAzM8r53ZNfzjfCh7hnp80I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPgQ5AZPMQL9WlS5t66H9WLMGz9vzQ/76sHCcvlFpUkbtJV3SXa2GqjfOEqRqz6ujRxUzoH5DNYRUClBD0/nCNA4+oq9nid8G1LXToNZatbb6Xa0n1ejebG7LHC5lQbmitPL5eYPfUV+Y4hFUtM27rbFxCkIFfAyA4GtmYpxh7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=v8CGqNEq; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7cc5e664d52so6265439f.0
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975484; x=1711580284; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0yqRqSadDrLycgB7gWD/2gAacwJUJVYMH2PNZjdZcSg=;
        b=v8CGqNEqHqos12ZisjuVK8E5bhxTPRxvaakG6mmSZfmxKa2YOKspD+Rpi3ol7QtZFd
         ieQusYOvgIB2kE01k8P61kGbElXZ1sK1htnEm14e2b2zjIaOgFcK6lRb+IZIbJSf2904
         kEmyvC4nUIhpx+rEVAo2TUo1KEMoKdb/U03QNGzvmC3kRDODIfR8JrdLiqbROw3CIb1b
         2prKH+wRQrxzkrG8V7MbC+o430OZLVymVFDygj5z4fcwc0JFfKRwN40hamRmeM2U54tG
         clTwTf5gWbr49niqEOfJGS00+MD5e+NihhAgFl43iacDEauM3GrvTGpS31q59PE7vs0B
         fMiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975484; x=1711580284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0yqRqSadDrLycgB7gWD/2gAacwJUJVYMH2PNZjdZcSg=;
        b=qTk1B88p5dQL7G4SJTZ1B4IBI81exASF5PRijBz3RWJWwwyl3MBMIx9BK29lRQPGOs
         9MoyKMDS51Jn8MVTqdTndau0JjBak8iOofOHIVhjoATGFo56yflZVO9o3QUXvDVHx4Y4
         Ii1Z+KzQlZydyBhAIz0/fc5vYKHmFPfBmBGPF0O2LtX6fc0yeRNP0gTELEhBh1EUJmwM
         4ZSnijA9TQfM5XaRQkCIglf0vZMSTrV6pEi0iPWzknlXbI6n5M3nhLLVX0sEee7+QYZ2
         pTR2ZYVyMKG2s4A+rX9frr0Hnj2GFw+VIxqtKwm0NJ3oH8qt1kT/yvWT+GGPDqDYHHW7
         fW+A==
X-Gm-Message-State: AOJu0YzTZwqC+/vnC/8sP1E+6qILY0mHtmsELnuFsKJ00EsOjRhOLf8I
	3ZOsOFo78jyScOtlRibKzwmf7xMkZa3RJdhv+AHiboq9h/ydhYub+p/d95LTz5N8nj3hjxiFF4G
	v
X-Google-Smtp-Source: AGHT+IEH0KJnHk7/b/mCXlm++UHWiQFNvqhzjTNLCpevwtjnAYYYOsp88neya7Rk5cYmy83HTcttvA==
X-Received: by 2002:a6b:5108:0:b0:7ce:f407:1edf with SMTP id f8-20020a6b5108000000b007cef4071edfmr6851307iob.0.1710975484215;
        Wed, 20 Mar 2024 15:58:04 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.58.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:02 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 05/17] io_uring/net: get rid of ->prep_async() for receive side
Date: Wed, 20 Mar 2024 16:55:20 -0600
Message-ID: <20240320225750.1769647-6-axboe@kernel.dk>
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
index 14491fab6d59..e438b1ac2420 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -596,17 +596,36 @@ static int io_recvmsg_copy_hdr(struct io_kiocb *req,
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
@@ -657,7 +676,7 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
 	sr->nr_multishot_loops = 0;
-	return 0;
+	return io_recvmsg_prep_setup(req);
 }
 
 static inline void io_recv_prep_retry(struct io_kiocb *req,
@@ -815,7 +834,7 @@ static int io_recvmsg_multishot(struct socket *sock, struct io_sr_msg *io,
 int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct io_async_msghdr *kmsg;
+	struct io_async_msghdr *kmsg = req->async_data;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -826,17 +845,6 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -915,36 +923,13 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
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
index 5c1230f1aaf9..4b4fd9b1b7b4 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -42,7 +42,6 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags);
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


