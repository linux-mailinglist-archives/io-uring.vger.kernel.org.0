Return-Path: <io-uring+bounces-8636-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 0976EAFF316
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 22:34:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 6FB697A4329
	for <lists+io-uring@lfdr.de>; Wed,  9 Jul 2025 20:33:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E7DF242914;
	Wed,  9 Jul 2025 20:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="1LXZ4tCI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88C2521ADA2
	for <io-uring@vger.kernel.org>; Wed,  9 Jul 2025 20:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752093269; cv=none; b=fiO1RU95VYhD8L85hbHjYQIdyWEfABurp+8jydmIvktXDhMDaKOo9+xkBRItWp5Gkxty6iv4nQChv+OI3dIr3Rv98ZiwKqElJIPCU3YUuUneNIpYpMRqY86KK28dc/KAZ/Rhcvgex9kywrPwCoIfKszKvG0ZK92qM/CjH80AUYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752093269; c=relaxed/simple;
	bh=3AfWmm42yBYsSyeof0BQB302/o0ejzMiS1V/U1Lcuic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNtF8+hmY+6yA5Z1QgY+lLCmwmcWr0II/xC/EOUMz+tw2EI3copmCpC6G08wjahC6dylSDdQfOLzZyov8N0VULDb1D0yvh8q1+L0AOGyjJLHmOb3fEqhsX0HGsCbBl6xKY7AiMzoBy5eMejTO+Ri2jFVvFdDshY6jl9ZBU5p0Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=1LXZ4tCI; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3e05bb6efe0so2433545ab.3
        for <io-uring@vger.kernel.org>; Wed, 09 Jul 2025 13:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1752093264; x=1752698064; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=25+ByVuSnqoQ0ZOqOlkRjZn3eaun1iNxu9J3gD6Qo+c=;
        b=1LXZ4tCINqlLu5s/HDM3wXPGojc80e+QdO08Ejlxwm3/4NYhI/nNzDTynMczQbb6Ys
         Jk5xAtt31QVp/9KI4nFaRDmgzzaTmebM9t2J+cJREGnj/VmXEjBwvRzmOqBIH2guw9uJ
         D4q80WiMfZ6VHLiJqbkyhatlkhw33mQxZmZU+plazwvIvCP3IK/zzAPL0+k4dlEsY4f1
         2gGKzOVd08X1QHkLVQiqWz94JD/SYV/ze+c6ehahbWlq52fWPtmdRQsALJsldXkfpN2O
         DCWjSAGV0XGXADDzYPYSmZMTVAZj4TQGjoWlD2qnEZcucU4vcfcE0hePiUnik1VJr2qy
         MORQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752093264; x=1752698064;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=25+ByVuSnqoQ0ZOqOlkRjZn3eaun1iNxu9J3gD6Qo+c=;
        b=b0Au8+e7JXe6Yw1X/1OCiC7mKgPO9uzxTA5lWWSZEgcg035Q0+z7/A56686gV6YCTB
         seIFomNdl38XpZBUxyxgkbzHDYSbgmn9Rd44xU8hmoQ2s2gRGqj12jmifoiGZ2TU+EuD
         fFl5ZMjdo7+KETACy7vT1eT8FcVAoLd5K+H8OMvPlGfT+1DxNouzoQfsJFkLJYRkmnGa
         vKv3z9krqvx17mZGOUaPZMp2p8s7iFrXTGufx+MM4GL2J3XlU7OpihdYh2dZOK2HxNeE
         10BkyU8ZfrrbysgGkom/8SMba3V2+JXixUUIv7SkVCbfC0vo1hYaJRR66jXn+jL9BnzO
         mK+Q==
X-Gm-Message-State: AOJu0Yw5DNUH66Adykh1VB3qXOvfakeu/q9KgC467EckZ+nfxEJ2dci+
	0k0eVBm3TmiXQZUy71M4UMyO/0z7xOswzcWtDJZVFPSWroSNok/0Zeh7P7jvgMZEtdpMWvf5Pss
	9jxYw
X-Gm-Gg: ASbGnctiPymj/NPjMkLSBOIH3DNIV0MnWoAulzwRa7g4lP5g8yAKwPgLmRFqEc9dc2u
	dUzLX0h/BtK3R6fF2bWonxD6TFaPWdMKQvp2Zalk/LsQGHF1kytJGiJLNu0Z14k7oVbjJEOIzr5
	MS456yQ7e+SuXNDetoAtxDR4fz7neLRHBFvbWNv+IZ5r8OMb5HDqYqJTtAO+x17DfrqL/iQDIUS
	qexVSNVN+iTRQ4rWco9m2xGcXkLA92qMNOzMSdCEI5Tl+/sq8yp7F1SU4gzUGxkxkCIKvkjJ59M
	cvFs9JNj5yVH9pUxPq9MVNd35CXIy6CMi9H2tjQt7s3D
X-Google-Smtp-Source: AGHT+IFn8uRs286RoweMbN+UpSR+lnOU6AoMiloN83OlIwTW2Nt4tXjkYcDZLtJOzK8+YrQKFo7zUg==
X-Received: by 2002:a05:6e02:260e:b0:3dc:79e5:e696 with SMTP id e9e14a558f8ab-3e1670d1c63mr45569915ab.11.1752093264369;
        Wed, 09 Jul 2025 13:34:24 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e246229f5fsm125965ab.50.2025.07.09.13.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jul 2025 13:34:23 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/3] io_uring/net: move io_sr_msg->retry_flags to io_sr_msg->flags
Date: Wed,  9 Jul 2025 14:32:40 -0600
Message-ID: <20250709203420.1321689-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250709203420.1321689-1-axboe@kernel.dk>
References: <20250709203420.1321689-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There's plenty of space left, as sr->flags is a 16-bit type. The UAPI
bits are the lower 8 bits, as that's all that sqe->ioprio can carry in
the SQE anyway. Use a few of the upper 8 bits for internal uses, rather
than have two separate flags entries.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 43a43522f406..d422c7fb2d14 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -75,15 +75,21 @@ struct io_sr_msg {
 	u16				flags;
 	/* initialised and used only by !msg send variants */
 	u16				buf_group;
-	unsigned short			retry_flags;
 	void __user			*msg_control;
 	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
 };
 
+/*
+ * The UAPI flags are the lower 8 bits, as that's all sqe->ioprio will hold
+ * anyway. Use the upper 8 bits for internal uses.
+ */
 enum sr_retry_flags {
-	IO_SR_MSG_RETRY		= 1,
-	IO_SR_MSG_PARTIAL_MAP	= 2,
+	IORING_RECV_RETRY	= (1U << 15),
+	IORING_RECV_PARTIAL_MAP	= (1U << 14),
+
+	IORING_RECV_RETRY_CLEAR	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP,
+	IORING_RECV_INTERNAL	= IORING_RECV_RETRY | IORING_RECV_PARTIAL_MAP,
 };
 
 /*
@@ -192,7 +198,7 @@ static inline void io_mshot_prep_retry(struct io_kiocb *req,
 
 	req->flags &= ~REQ_F_BL_EMPTY;
 	sr->done_io = 0;
-	sr->retry_flags = 0;
+	sr->flags &= ~IORING_RECV_RETRY_CLEAR;
 	sr->len = 0; /* get from the provided buffer */
 }
 
@@ -402,7 +408,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
-	sr->retry_flags = 0;
 	sr->len = READ_ONCE(sqe->len);
 	sr->flags = READ_ONCE(sqe->ioprio);
 	if (sr->flags & ~SENDMSG_FLAGS)
@@ -756,7 +761,6 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
 	sr->done_io = 0;
-	sr->retry_flags = 0;
 
 	if (unlikely(sqe->file_index || sqe->addr2))
 		return -EINVAL;
@@ -828,7 +832,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 
 		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret),
 				      issue_flags);
-		if (sr->retry_flags & IO_SR_MSG_RETRY)
+		if (sr->flags & IORING_RECV_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
@@ -837,12 +841,13 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		 * If more is available AND it was a full transfer, retry and
 		 * append to this one
 		 */
-		if (!sr->retry_flags && kmsg->msg.msg_inq > 1 && this_ret > 0 &&
+		if (!(sr->flags & IORING_RECV_INTERNAL) &&
+		    kmsg->msg.msg_inq > 1 && this_ret > 0 &&
 		    !iov_iter_count(&kmsg->msg.msg_iter)) {
 			req->cqe.flags = cflags & ~CQE_F_MASK;
 			sr->len = kmsg->msg.msg_inq;
 			sr->done_io += this_ret;
-			sr->retry_flags |= IO_SR_MSG_RETRY;
+			sr->flags |= IORING_RECV_RETRY;
 			return false;
 		}
 	} else {
@@ -1088,7 +1093,7 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 			req->flags |= REQ_F_NEED_CLEANUP;
 		}
 		if (arg.partial_map)
-			sr->retry_flags |= IO_SR_MSG_PARTIAL_MAP;
+			sr->flags |= IORING_RECV_PARTIAL_MAP;
 
 		/* special case 1 vec, can be a fast path */
 		if (ret == 1) {
@@ -1283,7 +1288,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	int ret;
 
 	zc->done_io = 0;
-	zc->retry_flags = 0;
 
 	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;
-- 
2.50.0


