Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C263231C87
	for <lists+io-uring@lfdr.de>; Wed, 29 Jul 2020 12:10:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725851AbgG2KK2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jul 2020 06:10:28 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:53779 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726365AbgG2KK2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jul 2020 06:10:28 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01422;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U48y1QH_1596017418;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U48y1QH_1596017418)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 29 Jul 2020 18:10:18 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, Jiufei Xue <jiufei.xue@linux.alibaba.com>
Subject: [PATCH liburing 1/2] io_uring_enter: add timeout support
Date:   Wed, 29 Jul 2020 18:10:14 +0800
Message-Id: <1596017415-39101-2-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596017415-39101-1-git-send-email-jiufei.xue@linux.alibaba.com>
References: <1596017415-39101-1-git-send-email-jiufei.xue@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Kernel can handle timeout when feature IORING_FEAT_GETEVENTS_TIMEOUT
supported. Add two new interfaces: io_uring_wait_cqes2(),
io_uring_wait_cqe_timeout2() for applications to use this feature.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 src/include/liburing.h          | 11 ++++--
 src/include/liburing/io_uring.h |  2 ++
 src/liburing.map                |  3 ++
 src/queue.c                     | 75 ++++++++++++++++++++++++++++++++++++++---
 src/setup.c                     |  1 +
 src/syscall.c                   |  4 +--
 src/syscall.h                   |  2 +-
 7 files changed, 88 insertions(+), 10 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 0505a4f..6176a63 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -56,6 +56,7 @@ struct io_uring {
 	struct io_uring_sq sq;
 	struct io_uring_cq cq;
 	unsigned flags;
+	unsigned features;
 	int ring_fd;
 };
 
@@ -93,6 +94,11 @@ extern int io_uring_wait_cqes(struct io_uring *ring,
 	struct __kernel_timespec *ts, sigset_t *sigmask);
 extern int io_uring_wait_cqe_timeout(struct io_uring *ring,
 	struct io_uring_cqe **cqe_ptr, struct __kernel_timespec *ts);
+extern int io_uring_wait_cqes2(struct io_uring *ring,
+	struct io_uring_cqe **cqe_ptr, unsigned wait_nr,
+	struct __kernel_timespec *ts, sigset_t *sigmask);
+extern int io_uring_wait_cqe_timeout2(struct io_uring *ring,
+	struct io_uring_cqe **cqe_ptr, struct __kernel_timespec *ts);
 extern int io_uring_submit(struct io_uring *ring);
 extern int io_uring_submit_and_wait(struct io_uring *ring, unsigned wait_nr);
 extern struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring);
@@ -120,7 +126,8 @@ extern int io_uring_unregister_personality(struct io_uring *ring, int id);
  */
 extern int __io_uring_get_cqe(struct io_uring *ring,
 			      struct io_uring_cqe **cqe_ptr, unsigned submit,
-			      unsigned wait_nr, sigset_t *sigmask);
+			      unsigned wait_nr, struct __kernel_timespec *ts,
+			      sigset_t *sigmask);
 
 #define LIBURING_UDATA_TIMEOUT	((__u64) -1)
 
@@ -491,7 +498,7 @@ static inline int io_uring_wait_cqe_nr(struct io_uring *ring,
 				      struct io_uring_cqe **cqe_ptr,
 				      unsigned wait_nr)
 {
-	return __io_uring_get_cqe(ring, cqe_ptr, 0, wait_nr, NULL);
+	return __io_uring_get_cqe(ring, cqe_ptr, 0, wait_nr, NULL, NULL);
 }
 
 /*
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index d39b45f..28f81e2 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -228,6 +228,7 @@ struct io_cqring_offsets {
  */
 #define IORING_ENTER_GETEVENTS	(1U << 0)
 #define IORING_ENTER_SQ_WAKEUP	(1U << 1)
+#define IORING_ENTER_GETEVENTS_TIMEOUT	(1U << 2)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
@@ -255,6 +256,7 @@ struct io_uring_params {
 #define IORING_FEAT_CUR_PERSONALITY	(1U << 4)
 #define IORING_FEAT_FAST_POLL		(1U << 5)
 #define IORING_FEAT_POLL_32BITS 	(1U << 6)
+#define IORING_FEAT_GETEVENTS_TIMEOUT	(1U << 7)
 
 /*
  * io_uring_register(2) opcodes and arguments
diff --git a/src/liburing.map b/src/liburing.map
index 38bd558..15c5f9d 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -56,4 +56,7 @@ LIBURING_0.6 {
 } LIBURING_0.5;
 
 LIBURING_0.7 {
+	global:
+		io_uring_wait_cqe_timeout2;
+		io_uring_wait_cqes2;
 } LIBURING_0.6;
diff --git a/src/queue.c b/src/queue.c
index be80d7a..cdd6a15 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -65,11 +65,16 @@ static int __io_uring_peek_cqe(struct io_uring *ring,
 }
 
 int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
-		       unsigned submit, unsigned wait_nr, sigset_t *sigmask)
+		       unsigned submit, unsigned wait_nr, struct __kernel_timespec *ts,
+		       sigset_t *sigmask)
 {
 	struct io_uring_cqe *cqe = NULL;
 	const int to_wait = wait_nr;
 	int ret = 0, err;
+	struct {
+		sigset_t *sigmask;
+		struct __kernel_timespec *ts;
+	} arg, *argp;
 
 	do {
 		bool cq_overflow_flush = false;
@@ -87,13 +92,26 @@ int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 		}
 		if (wait_nr && cqe)
 			wait_nr--;
-		if (wait_nr || cq_overflow_flush)
+		if (wait_nr || cq_overflow_flush) {
 			flags = IORING_ENTER_GETEVENTS;
+			if (ring->features & IORING_FEAT_GETEVENTS_TIMEOUT)
+				flags |= IORING_ENTER_GETEVENTS_TIMEOUT;
+		}
 		if (submit)
 			sq_ring_needs_enter(ring, submit, &flags);
-		if (wait_nr || submit || cq_overflow_flush)
+		if (wait_nr || submit || cq_overflow_flush) {
+			if (ring->features & IORING_FEAT_GETEVENTS_TIMEOUT) {
+				argp = &arg;
+				memset(argp, 0, sizeof(arg));
+				if (sigmask)
+					argp->sigmask = sigmask;
+				if (ts)
+					argp->ts = ts;
+			} else
+				argp = (void *)sigmask;
 			ret = __sys_io_uring_enter(ring->ring_fd, submit,
-						   wait_nr, flags, sigmask);
+						   wait_nr, flags, (void *)argp);
+		}
 		if (ret < 0) {
 			err = -errno;
 		} else if (ret == (int)submit) {
@@ -230,7 +248,7 @@ int io_uring_wait_cqes(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 		to_submit = __io_uring_flush_sq(ring);
 	}
 
-	return __io_uring_get_cqe(ring, cqe_ptr, to_submit, wait_nr, sigmask);
+	return __io_uring_get_cqe(ring, cqe_ptr, to_submit, wait_nr, ts, sigmask);
 }
 
 /*
@@ -245,6 +263,53 @@ int io_uring_wait_cqe_timeout(struct io_uring *ring,
 }
 
 /*
+ * If feature IORING_FEAT_GETEVENTS_TIMEOUT supported, this interface is
+ * safe for applications that split SQ and CQ handling in two threads.
+ * Applications need to call io_uring_submit() to submit the requests
+ * first.
+ */
+int io_uring_wait_cqes2(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
+			unsigned wait_nr, struct __kernel_timespec *ts,
+			sigset_t *sigmask)
+{
+	unsigned to_submit = 0;
+
+	if (ts && !(ring->features & IORING_FEAT_GETEVENTS_TIMEOUT)) {
+		struct io_uring_sqe *sqe;
+		int ret;
+
+		/*
+		 * If the SQ ring is full, we may need to submit IO first
+		 */
+		sqe = io_uring_get_sqe(ring);
+		if (!sqe) {
+			ret = io_uring_submit(ring);
+			if (ret < 0)
+				return ret;
+			sqe = io_uring_get_sqe(ring);
+			if (!sqe)
+				return -EAGAIN;
+		}
+		io_uring_prep_timeout(sqe, ts, wait_nr, 0);
+		sqe->user_data = LIBURING_UDATA_TIMEOUT;
+		to_submit = __io_uring_flush_sq(ring);
+	}
+
+	return __io_uring_get_cqe(ring, cqe_ptr, to_submit, wait_nr, ts, sigmask);
+}
+
+/*
+ * See io_uring_wait_cqes2() - this function is the same, it just always uses
+ * '1' as the wait_nr.
+ */
+int io_uring_wait_cqe_timeout2(struct io_uring *ring,
+			       struct io_uring_cqe **cqe_ptr,
+			       struct __kernel_timespec *ts)
+{
+       return io_uring_wait_cqes2(ring, cqe_ptr, 1, ts, NULL);
+}
+
+/*
  * Submit sqes acquired from io_uring_get_sqe() to the kernel.
  *
  * Returns number of sqes submitted
diff --git a/src/setup.c b/src/setup.c
index 2b17b94..b258cf1 100644
--- a/src/setup.c
+++ b/src/setup.c
@@ -96,6 +96,7 @@ int io_uring_queue_mmap(int fd, struct io_uring_params *p, struct io_uring *ring
 	if (!ret) {
 		ring->flags = p->flags;
 		ring->ring_fd = fd;
+		ring->features = p->features;
 	}
 	return ret;
 }
diff --git a/src/syscall.c b/src/syscall.c
index c41e099..926700b 100644
--- a/src/syscall.c
+++ b/src/syscall.c
@@ -48,8 +48,8 @@ int __sys_io_uring_setup(unsigned entries, struct io_uring_params *p)
 }
 
 int __sys_io_uring_enter(int fd, unsigned to_submit, unsigned min_complete,
-			 unsigned flags, sigset_t *sig)
+			 unsigned flags, void *argp)
 {
 	return syscall(__NR_io_uring_enter, fd, to_submit, min_complete,
-			flags, sig, _NSIG / 8);
+			flags, argp, _NSIG / 8);
 }
diff --git a/src/syscall.h b/src/syscall.h
index 7e299d4..b135d42 100644
--- a/src/syscall.h
+++ b/src/syscall.h
@@ -7,7 +7,7 @@
  */
 extern int __sys_io_uring_setup(unsigned entries, struct io_uring_params *p);
 extern int __sys_io_uring_enter(int fd, unsigned to_submit,
-	unsigned min_complete, unsigned flags, sigset_t *sig);
+	unsigned min_complete, unsigned flags, void *argp);
 extern int __sys_io_uring_register(int fd, unsigned int opcode, const void *arg,
 	unsigned int nr_args);
 
-- 
1.8.3.1

