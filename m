Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 202FB42148D
	for <lists+io-uring@lfdr.de>; Mon,  4 Oct 2021 18:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236888AbhJDQ6j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Oct 2021 12:58:39 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:42204 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237820AbhJDQ6j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Oct 2021 12:58:39 -0400
Received: from modemcable064.203-130-66.mc.videotron.ca ([66.130.203.64]:54140 helo=localhost)
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1mXRGj-00056w-PH; Mon, 04 Oct 2021 12:56:49 -0400
Date:   Mon, 04 Oct 2021 12:56:49 -0400
Message-Id: <1bbde6755535cb7b0bdfc0846254e7c06faf04e0.1633366467.git.olivier@trillion01.com>
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org
Subject: [PATCH v2] liburing: Add io_uring_submit_and_wait_timeout function in API
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

before commit 0ea4ccd1c0e4 ("src/queue: don't flush SQ ring for new wait interface"),
io_uring_wait_cqes() was serving the purpose of submit sqe and wait for cqe up to a certain timeout value.

Since the commit, a new function is needed to fill this gap.

Fixes: https://github.com/axboe/liburing/issues/440
Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 src/include/liburing.h |  5 +++
 src/liburing.map       |  5 +++
 src/queue.c            | 79 ++++++++++++++++++++++++++++++++----------
 3 files changed, 71 insertions(+), 18 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 0c2c5c2..fe8bfbe 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -122,6 +122,11 @@ int io_uring_wait_cqe_timeout(struct io_uring *ring,
 			      struct __kernel_timespec *ts);
 int io_uring_submit(struct io_uring *ring);
 int io_uring_submit_and_wait(struct io_uring *ring, unsigned wait_nr);
+int io_uring_submit_and_wait_timout(struct io_uring *ring,
+				    struct io_uring_cqe **cqe_ptr,
+				    unsigned wait_nr,
+				    struct __kernel_timespec *ts,
+				    sigset_t *sigmask);
 struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring);
 
 int io_uring_register_buffers(struct io_uring *ring, const struct iovec *iovecs,
diff --git a/src/liburing.map b/src/liburing.map
index 6692a3b..09f4275 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -44,3 +44,8 @@ LIBURING_2.1 {
 		io_uring_unregister_iowq_aff;
 		io_uring_register_iowq_max_workers;
 } LIBURING_2.0;
+
+LIBURING_2.2 {
+	global:
+		io_uring_submit_and_wait_timout;
+} LIBURING_2.1;
diff --git a/src/queue.c b/src/queue.c
index 31aa17c..074ea12 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -271,36 +271,79 @@ static int io_uring_wait_cqes_new(struct io_uring *ring,
  * hence this function is safe to use for applications that split SQ and CQ
  * handling between two threads.
  */
+
+static int __io_uring_submit_timeout(struct io_uring *ring, unsigned wait_nr,
+				     struct __kernel_timespec *ts)
+{
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	/*
+	 * If the SQ ring is full, we may need to submit IO first
+	 */
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		ret = io_uring_submit(ring);
+		if (ret < 0)
+			return ret;
+		sqe = io_uring_get_sqe(ring);
+		if (!sqe)
+			return -EAGAIN;
+	}
+	io_uring_prep_timeout(sqe, ts, wait_nr, 0);
+	sqe->user_data = LIBURING_UDATA_TIMEOUT;
+	return __io_uring_flush_sq(ring);
+}
+
 int io_uring_wait_cqes(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 		       unsigned wait_nr, struct __kernel_timespec *ts,
 		       sigset_t *sigmask)
 {
-	unsigned to_submit = 0;
+	int to_submit = 0;
 
 	if (ts) {
-		struct io_uring_sqe *sqe;
-		int ret;
-
 		if (ring->features & IORING_FEAT_EXT_ARG)
 			return io_uring_wait_cqes_new(ring, cqe_ptr, wait_nr,
 							ts, sigmask);
+		to_submit = __io_uring_submit_timeout(ring, wait_nr, ts);
+		if (to_submit < 0)
+			return to_submit;
+	}
 
-		/*
-		 * If the SQ ring is full, we may need to submit IO first
-		 */
-		sqe = io_uring_get_sqe(ring);
-		if (!sqe) {
-			ret = io_uring_submit(ring);
-			if (ret < 0)
-				return ret;
-			sqe = io_uring_get_sqe(ring);
-			if (!sqe)
-				return -EAGAIN;
+	return __io_uring_get_cqe(ring, cqe_ptr, to_submit, wait_nr, sigmask);
+}
+
+int io_uring_submit_and_wait_timout(struct io_uring *ring,
+				    struct io_uring_cqe **cqe_ptr,
+				    unsigned wait_nr,
+				    struct __kernel_timespec *ts,
+				    sigset_t *sigmask)
+{
+	int to_submit;
+
+	if (ts) {
+		if (ring->features & IORING_FEAT_EXT_ARG) {
+			struct io_uring_getevents_arg arg = {
+				.sigmask	= (unsigned long) sigmask,
+				.sigmask_sz	= _NSIG / 8,
+				.ts		= (unsigned long) ts
+			};
+			struct get_data data = {
+				.submit		= __io_uring_flush_sq(ring),
+				.wait_nr	= wait_nr,
+				.get_flags	= IORING_ENTER_EXT_ARG,
+				.sz		= sizeof(arg),
+				.arg		= &arg
+			};
+
+			return _io_uring_get_cqe(ring, cqe_ptr, &data);
 		}
-		io_uring_prep_timeout(sqe, ts, wait_nr, 0);
-		sqe->user_data = LIBURING_UDATA_TIMEOUT;
-		to_submit = __io_uring_flush_sq(ring);
+		to_submit = __io_uring_submit_timeout(ring, wait_nr, ts);
+		if (to_submit < 0)
+			return to_submit;
 	}
+	else
+		to_submit = __io_uring_flush_sq(ring);
 
 	return __io_uring_get_cqe(ring, cqe_ptr, to_submit, wait_nr, sigmask);
 }
-- 
2.33.0

