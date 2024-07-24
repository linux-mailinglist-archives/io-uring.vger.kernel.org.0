Return-Path: <io-uring+bounces-2559-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F5A893B01D
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 13:10:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C23E7B21085
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 11:10:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABC956BFD2;
	Wed, 24 Jul 2024 11:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aHLmj/y0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE1D92595
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 11:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721819397; cv=none; b=Fx9avWMgpkVLyN+MDzJaXOwBtUQuZBBlWsc55H97doSaZEOULxAtKNcVa31ND69KOCUj5iwWxzfs28Te/8K3SRHbEV29ZcoKqOV0lTs50jgT7Hnuvija+B2CHGne0xUoi0poT7kcBiF+qGlGZRi82smqnuiWD0cRKBHwjGrpoTE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721819397; c=relaxed/simple;
	bh=rsWlcRm66cJhn6xUTJ/9SKwLqu2ViuPk8Q4arCuE6+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YtQmff3CXkTdfOWY3cqaXwvH+6GUg7rgY4CP5fUNEoZp8kJ8cFultVFSeAnzrOnAFuUz47q1CHuFOxh7gin9afBuoELXia2CtghNFGZNZCQgeQcKyCkEYU5lseQhzBZE5RnMlXVAcoMe79zlXRhFoxnjA1QjeXgsDgkxTbL9Qyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aHLmj/y0; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a7a9cc666b1so186785866b.2
        for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 04:09:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721819394; x=1722424194; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=HtqcPrJrtXBwLi62z0zx02dCXxcv15ek8WladmSr6BM=;
        b=aHLmj/y0R2Jb0lyw4gD+UXGLMgPgCWyGhB08RN4+DZf8nT83q7bTOs3rBmfMAsdUtg
         gFxknQACSsEQcHGeWOQW6yi77F20rupinQ/k75v4V1duIqjimvX6oGjMXbRIbzKyfabi
         ejhKFeSLgYbKfXm0YZUTb0JOY6vtU4WxmfIAGJQtiP69n0I4cQuzrOqjPSR6GpeYI1ne
         jFar14bXxRZk/MxifRfk2mHusNjIzVVSh/FADdmzCjRmUaBRDN48zEN4sxAk6BiLtwsy
         u2WCePtFZ9OKhZrfPDllyzzMbwXUKidFhehmJbGrax2QXfJv00XiJzmpD8PqZ6gBqGD6
         hnnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721819394; x=1722424194;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HtqcPrJrtXBwLi62z0zx02dCXxcv15ek8WladmSr6BM=;
        b=kY0werrivu+dg+zjd/vQQJ2H+uZanhg0eRfSsRMFLG7xdaFg6hTzX4mQ1n6JUbHrxm
         knTzIa476+padrp3rfRgPtom+REu5ZKAoqyy94vpXNn1ox9yIx0vDMkZhshU6CGSndc8
         eQhLdXaPyJsl1OPBQTJwBjcgOuCZ7sC9WU1hI/M+LxPQ6ST8U+LWaAPEGBpqpBS8rDlm
         v+3BBbAsBMA7uRLjQ9dcpChVRYs/EHVRGn0TYDSzClIaIjGajrClDGd3AX+XXYfZGrM5
         TyxG1Hg3AmwwFHcdWp9xT2Mw/PMMy+a2JbZBMm4fxPhZksV+kay8nlCEFgqxbIOdkdzF
         SOYw==
X-Gm-Message-State: AOJu0Ywyr1UavcDBH/lqy5RwSyaVegHI+wzOFaPBkI9hgj0EKKlJSNmy
	HVfUTRKEDYw6GH7qsmTnh22R3gpbPhZWQiRVfY39EgkijH740eNbredChA==
X-Google-Smtp-Source: AGHT+IHI/O9WhJ9mBKroQNQAaOTiMog2HVjqs3aD9hY83AbXBmkdNtafXwWo2sJ8kXC6uprxvUWz/g==
X-Received: by 2002:a17:906:6a06:b0:a77:cc6f:e791 with SMTP id a640c23a62f3a-a7ab0e143efmr132228766b.38.1721819393226;
        Wed, 24 Jul 2024 04:09:53 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7aa36af2ccsm128963466b.95.2024.07.24.04.09.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jul 2024 04:09:52 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 1/1] tests/sockopt: {g,s}etsockopt with io-wq
Date: Wed, 24 Jul 2024 12:10:17 +0100
Message-ID: <e8c3ed425b98c5924f746cc6d51c9bdbd90cd948.1721790611.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Test that {g,s}etsockopt interacts well with io-wq.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/socket-getsetsock-cmd.c | 58 +++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 20 deletions(-)

diff --git a/test/socket-getsetsock-cmd.c b/test/socket-getsetsock-cmd.c
index 5345b59..53f04d1 100644
--- a/test/socket-getsetsock-cmd.c
+++ b/test/socket-getsetsock-cmd.c
@@ -53,7 +53,8 @@ static struct io_uring create_ring(void)
 
 static int submit_cmd_sqe(struct io_uring *ring, int32_t fd,
 			  int op, int level, int optname,
-			  void *optval, int optlen)
+			  void *optval, int optlen,
+			  bool async)
 {
 	struct io_uring_sqe *sqe;
 	int err;
@@ -65,6 +66,8 @@ static int submit_cmd_sqe(struct io_uring *ring, int32_t fd,
 
 	io_uring_prep_cmd_sock(sqe, op, fd, level, optname, optval, optlen);
 	sqe->user_data = USERDATA;
+	if (async)
+		sqe->flags |= IOSQE_ASYNC;
 
 	/* Submitting SQE */
 	err = io_uring_submit_and_wait(ring, 1);
@@ -92,7 +95,7 @@ static int receive_cqe(struct io_uring *ring)
  * Run getsock operation using SO_RCVBUF using io_uring cmd operation and
  * getsockopt(2) and compare the results.
  */
-static int run_get_rcvbuf(struct io_uring *ring, struct fds *sockfds)
+static int run_get_rcvbuf(struct io_uring *ring, struct fds *sockfds, bool async)
 {
 	int sval, uval, ulen, err;
 	unsigned int slen;
@@ -104,7 +107,7 @@ static int run_get_rcvbuf(struct io_uring *ring, struct fds *sockfds)
 
 	/* get through io_uring cmd */
 	err = submit_cmd_sqe(ring, sockfds->rx, SOCKET_URING_OP_GETSOCKOPT,
-			     SOL_SOCKET, SO_RCVBUF, &uval, ulen);
+			     SOL_SOCKET, SO_RCVBUF, &uval, ulen, async);
 	assert(err == 1);
 
 	/* Wait for the CQE */
@@ -133,7 +136,7 @@ static int run_get_rcvbuf(struct io_uring *ring, struct fds *sockfds)
  * Run getsock operation using SO_PEERNAME using io_uring cmd operation
  * and getsockopt(2) and compare the results.
  */
-static int run_get_peername(struct io_uring *ring, struct fds *sockfds)
+static int run_get_peername(struct io_uring *ring, struct fds *sockfds, bool async)
 {
 	struct sockaddr sval, uval = {};
 	socklen_t slen = sizeof(sval);
@@ -146,7 +149,7 @@ static int run_get_peername(struct io_uring *ring, struct fds *sockfds)
 
 	/* Getting SO_PEERNAME */
 	err = submit_cmd_sqe(ring, sockfds->rx, SOCKET_URING_OP_GETSOCKOPT,
-			     SOL_SOCKET, SO_PEERNAME, &uval, ulen);
+			     SOL_SOCKET, SO_PEERNAME, &uval, ulen, async);
 	assert(err == 1);
 
 	/* Wait for the CQE */
@@ -178,18 +181,27 @@ static int run_getsockopt_test(struct io_uring *ring, struct fds *sockfds)
 {
 	int err;
 
-	err = run_get_peername(ring, sockfds);
+	err = run_get_peername(ring, sockfds, false);
 	if (err)
 		return err;
 
-	return run_get_rcvbuf(ring, sockfds);
+	err = run_get_peername(ring, sockfds, true);
+	if (err)
+		return err;
+
+	err = run_get_rcvbuf(ring, sockfds, false);
+	if (err)
+		return err;
+
+	return run_get_rcvbuf(ring, sockfds, true);
 }
 
 /*
  * Given a `val` value, set it in SO_REUSEPORT using io_uring cmd, and read using
  * getsockopt(2), and make sure they match.
  */
-static int run_setsockopt_reuseport(struct io_uring *ring, struct fds *sockfds, int val)
+static int run_setsockopt_reuseport(struct io_uring *ring, struct fds *sockfds,
+				    int val, bool async)
 {
 	unsigned int slen, ulen;
 	int sval, uval = val;
@@ -200,7 +212,7 @@ static int run_setsockopt_reuseport(struct io_uring *ring, struct fds *sockfds,
 
 	/* Setting SO_REUSEPORT */
 	err = submit_cmd_sqe(ring, sockfds->rx, SOCKET_URING_OP_SETSOCKOPT,
-			     SOL_SOCKET, SO_REUSEPORT, &uval, ulen);
+			     SOL_SOCKET, SO_REUSEPORT, &uval, ulen, async);
 	assert(err == 1);
 
 	err = receive_cqe(ring);
@@ -222,7 +234,8 @@ static int run_setsockopt_reuseport(struct io_uring *ring, struct fds *sockfds,
  * Given a `val` value, set the TCP_USER_TIMEOUT using io_uring and read using
  * getsockopt(2). Make sure they match
  */
-static int run_setsockopt_usertimeout(struct io_uring *ring, struct fds *sockfds, int val)
+static int run_setsockopt_usertimeout(struct io_uring *ring, struct fds *sockfds,
+				      int val, bool async)
 {
 	int optname = TCP_USER_TIMEOUT;
 	int level = IPPROTO_TCP;
@@ -236,7 +249,7 @@ static int run_setsockopt_usertimeout(struct io_uring *ring, struct fds *sockfds
 
 	/* Setting timeout */
 	err = submit_cmd_sqe(ring, sockfds->rx, SOCKET_URING_OP_SETSOCKOPT,
-			     level, optname, &uval, ulen);
+			     level, optname, &uval, ulen, async);
 	assert(err == 1);
 
 	err = receive_cqe(ring);
@@ -259,17 +272,22 @@ static int run_setsockopt_usertimeout(struct io_uring *ring, struct fds *sockfds
 static int run_setsockopt_test(struct io_uring *ring, struct fds *sockfds)
 {
 	int err, i;
+	int j;
 
-	for (i = 0; i <= 1; i++) {
-		err = run_setsockopt_reuseport(ring, sockfds, i);
-		if (err)
-			return err;
-	}
+	for (j = 0; j < 2; j++) {
+		bool async = j & 1;
 
-	for (i = 1; i <= 10; i++) {
-		err = run_setsockopt_usertimeout(ring, sockfds, i);
-		if (err)
-			return err;
+		for (i = 0; i <= 1; i++) {
+			err = run_setsockopt_reuseport(ring, sockfds, i, async);
+			if (err)
+				return err;
+		}
+
+		for (i = 1; i <= 10; i++) {
+			err = run_setsockopt_usertimeout(ring, sockfds, i, async);
+			if (err)
+				return err;
+		}
 	}
 
 	return err;
-- 
2.44.0


