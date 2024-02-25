Return-Path: <io-uring+bounces-704-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 885A2862896
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 01:39:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id ABC681C20A85
	for <lists+io-uring@lfdr.de>; Sun, 25 Feb 2024 00:39:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D4887FD;
	Sun, 25 Feb 2024 00:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="s7ZbOtBc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B49B10E4
	for <io-uring@vger.kernel.org>; Sun, 25 Feb 2024 00:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708821593; cv=none; b=NskJkk0qfdG0Fwd8dKkZdOSWOQKrZyx6AGZqB2fBVhFg7xRETJTaXGYEM0ihhZ2hQdFnHkMmGCjHAYKb3+1CU5KF48SAIo1naDAVnxcoocIKQXTaNSOptw314S/hz0rXEVtGkF+P0a2uyhlD3Y9sRGxxW67UTV9++DPyZke2bvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708821593; c=relaxed/simple;
	bh=A3OKKfft3DNeQRrP5felkjZSJPYhl3MGmCwrW5AVh74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ngl9Axm30JDRt/gjxNPH+3SJptfME23h0R8xPgQ/lhQFuOUBSKbqQB6Ka+sDjK6RFye08UbH3iwPe10p7E5O0uJs/2pAcX/F3nwoqkSBcr93T9FHsPVrLlHTnnnPrX6PLwzNjUps/JPyVUmsnwmFFrUOc6rXwozuRYno46UEkJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=s7ZbOtBc; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5cfb8126375so727215a12.1
        for <io-uring@vger.kernel.org>; Sat, 24 Feb 2024 16:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708821590; x=1709426390; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YVNqlUfD9EN4SXvPUo1xiT2FLfu9522ZGHPisvqay5M=;
        b=s7ZbOtBcRN7VI/mbIUES2mzQ0sQDSGm35fqfW1LnYH6u23N1tSLFRwYe2PNd/IAWZ8
         X7Psr9UwNf02tElSSS9ghrNPGRsC5DEWUAGAdVawNNR6f1xcA5/uvc2sffvy3VxpLJ0K
         WZSiYz6WClCDapb/2YteXtIq4TpF7CJY2z0/jF1xBqorrzgCWwV6XhG1c4Qja3DORRC6
         KJ0nSuYI26XPrXEmHghw49ONIntdBZdhiGoxETvytiMrnMO+Mp39U0f5CVciKSpe+yn+
         MT9UwiB65VrOCmKXbW0QNdUzKPyTFBHkOLFFgDZvnAD+Nywfc3Xmbf0O/8BuUCnK0Eah
         eAXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708821590; x=1709426390;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YVNqlUfD9EN4SXvPUo1xiT2FLfu9522ZGHPisvqay5M=;
        b=Sda8LTWeds0ZYdoZ3liFNih+SGCbic5/HazToKnFFa40rzrMYCN8sQVNZAxMTNYe/t
         IpsmM287PlckkNOAv7UCu3yS2lYB3UYmVrK3PDEuf3WlWwX+xfk4ZUgWr+anV6tOf0AL
         aXhB0GCeIDJSI3cjcONp+8yPwnr7PuSexLWu7MoJnNYRPZLlRUEdCS6IIPiYEERq9Os3
         Ws4wwu69IN3LPIB0koAD3TpGiE66cOQAwNLUaIde+VVRFqiMHdWzQml4hwUmEqXeCdjj
         7uuModFYvS4rEEF6eOG4kECPOx64zKOAUasgddfIho9anFulAAdu32g4s0vOvnthYDyU
         AC0g==
X-Gm-Message-State: AOJu0YxwTlBc7gqWJRIvnwPebubOoiZKyZ+5ktp1B+xA3CB9vOa17U9e
	2n77A0gjGrUy3pIWVhjtKSVeuuUZoP7ngdWcAq19YgOpPUF8l1/ROB3jUGnjApHiKvSlM1DeadY
	9
X-Google-Smtp-Source: AGHT+IEJNCL4QZ1GEDZC45uKYZSn2CuqU31lflHNwHXd+g7xSqnUZzp7zEgiottDTfTGz+WvXIXPxA==
X-Received: by 2002:a05:6a00:91:b0:6e4:e7c3:f0c6 with SMTP id c17-20020a056a00009100b006e4e7c3f0c6mr4469922pfj.0.1708821590141;
        Sat, 24 Feb 2024 16:39:50 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id u3-20020a62d443000000b006e24991dd5bsm1716170pfl.98.2024.02.24.16.39.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Feb 2024 16:39:48 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/8] io_uring/net: add provided buffer support for IORING_OP_SEND
Date: Sat, 24 Feb 2024 17:35:49 -0700
Message-ID: <20240225003941.129030-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240225003941.129030-1-axboe@kernel.dk>
References: <20240225003941.129030-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

It's pretty trivial to wire up provided buffer support for the send
side, just like we do on the receive side. This enables setting up
a buffer ring that an application can use to push pending sends to,
and then have a send pick a buffer from that ring.

One of the challenges with async IO and networking sends is that you
can get into reordering conditions if you have more than one inflight
at the same time. Consider the following scenario where everything is
fine:

1) App queues sendA for socket1
2) App queues sendB for socket1
3) App does io_uring_submit()
4) sendA is issued, completes successfully, posts CQE
5) sendB is issued, completes successfully, posts CQE

All is fine. Requests are always issued in-order, and both complete
inline as most sends do.

However, if we're flooding socket1 with sends, the following could
also result from the same sequence:

1) App queues sendA for socket1
2) App queues sendB for socket1
3) App does io_uring_submit()
4) sendA is issued, socket1 is full, poll is armed for retry
5) Space frees up in socket1, this triggers sendA retry via task_work
6) sendB is issued, completes successfully, posts CQE
7) sendA is retried, completes successfully, posts CQE

Now we've sent sendB before sendA, which can make things unhappy. If
both sendA and sendB had been using provided buffers, then it would look
as follows instead:

1) App queues dataA for sendA, queues sendA for socket1
2) App queues dataB for sendB queues sendB for socket1
3) App does io_uring_submit()
4) sendA is issued, socket1 is full, poll is armed for retry
5) Space frees up in socket1, this triggers sendA retry via task_work
6) sendB is issued, picks first buffer (dataA), completes successfully,
   posts CQE (which says "I sent dataA")
7) sendA is retried, picks first buffer (dataB), completes successfully,
   posts CQE (which says "I sent dataB")

Now we've sent the data in order, and everybody is happy.

It's worth noting that this also opens the door for supporting multishot
sends, as provided buffers would be a prerequisite for that. Those can
trigger either when new buffers are added to the outgoing ring, or (if
stalled due to lack of space) when space frees up in the socket.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/io_uring.c           |  3 ++-
 io_uring/net.c                | 19 ++++++++++++++++---
 io_uring/opdef.c              |  1 +
 4 files changed, 20 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7bd10201a02b..74c3afac9c63 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -522,6 +522,7 @@ struct io_uring_params {
 #define IORING_FEAT_CQE_SKIP		(1U << 11)
 #define IORING_FEAT_LINKED_FILE		(1U << 12)
 #define IORING_FEAT_REG_REG_RING	(1U << 13)
+#define IORING_FEAT_SEND_BUFS		(1U << 14)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cf2f514b7cc0..f6332fc56bed 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3962,7 +3962,8 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
 			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP |
-			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING;
+			IORING_FEAT_LINKED_FILE | IORING_FEAT_REG_REG_RING |
+			IORING_FEAT_SEND_BUFS;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/io_uring/net.c b/io_uring/net.c
index fcbaeb7cc045..10b6d8caf4da 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -489,7 +489,8 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 		ret += sr->done_io;
 	else if (sr->done_io)
 		ret = sr->done_io;
-	io_req_set_res(req, ret, 0);
+	cflags = io_put_kbuf(req, issue_flags);
+	io_req_set_res(req, ret, cflags);
 	return IOU_OK;
 }
 
@@ -497,8 +498,10 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct sockaddr_storage __address;
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	struct msghdr msg;
+	size_t len = sr->len;
+	unsigned int cflags;
 	struct socket *sock;
+	struct msghdr msg;
 	unsigned flags;
 	int min_ret = 0;
 	int ret;
@@ -531,7 +534,17 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	ret = import_ubuf(ITER_SOURCE, sr->buf, sr->len, &msg.msg_iter);
+	if (io_do_buffer_select(req)) {
+		void __user *buf;
+
+		buf = io_buffer_select(req, &len, issue_flags);
+		if (!buf)
+			return -ENOBUFS;
+		sr->buf = buf;
+		sr->len = len;
+	}
+
+	ret = import_ubuf(ITER_SOURCE, sr->buf, len, &msg.msg_iter);
 	if (unlikely(ret))
 		return ret;
 
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 9c080aadc5a6..88fbe5cfd379 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -273,6 +273,7 @@ const struct io_issue_def io_issue_defs[] = {
 		.audit_skip		= 1,
 		.ioprio			= 1,
 		.manual_alloc		= 1,
+		.buffer_select		= 1,
 #if defined(CONFIG_NET)
 		.prep			= io_sendmsg_prep,
 		.issue			= io_send,
-- 
2.43.0


