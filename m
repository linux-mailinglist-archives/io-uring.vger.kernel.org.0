Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8A923C3D3
	for <lists+io-uring@lfdr.de>; Wed,  5 Aug 2020 05:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgHEDEv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Aug 2020 23:04:51 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:46075 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726027AbgHEDEv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Aug 2020 23:04:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U4mvJ53_1596596683;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U4mvJ53_1596596683)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 05 Aug 2020 11:04:43 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, metze@samba.org,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
Subject: [PATCH liburing v3 1/2] io_uring_enter: add timeout support
Date:   Wed,  5 Aug 2020 11:04:39 +0800
Message-Id: <1596596680-116411-2-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596596680-116411-1-git-send-email-jiufei.xue@linux.alibaba.com>
References: <1596596680-116411-1-git-send-email-jiufei.xue@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Kernel can handle timeout when feature IORING_FEAT_GETEVENTS_TIMEOUT
supported. Applications should use io_uring_set_cqwait_timeout()
explicitly to asked for the new feature.

In addition in this commit we add two new members to io_uring and some
pads for future flexibility which breaks the API. So we have bumped the
version to 2.0.7.  Applications have to re-compile against the lib for
the next release.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 src/Makefile                    |  2 +-
 src/include/liburing.h          | 12 +++++-
 src/include/liburing/io_uring.h |  7 ++++
 src/liburing.map                |  2 +
 src/queue.c                     | 88 ++++++++++++++++++++++++++++++-----------
 src/setup.c                     |  1 +
 src/syscall.c                   |  4 +-
 src/syscall.h                   |  2 +-
 8 files changed, 89 insertions(+), 29 deletions(-)

diff --git a/src/Makefile b/src/Makefile
index 44a95ad..90f757f 100644
--- a/src/Makefile
+++ b/src/Makefile
@@ -12,7 +12,7 @@ LINK_FLAGS=
 LINK_FLAGS+=$(LDFLAGS)
 ENABLE_SHARED ?= 1
 
-soname=liburing.so.1
+soname=liburing.so.2
 minor=0
 micro=7
 libname=$(soname).$(minor).$(micro)
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 0505a4f..82c2980 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -56,6 +56,9 @@ struct io_uring {
 	struct io_uring_sq sq;
 	struct io_uring_cq cq;
 	unsigned flags;
+	unsigned flags_internal;
+	unsigned features;
+	unsigned pad[4];
 	int ring_fd;
 };
 
@@ -93,6 +96,7 @@ extern int io_uring_wait_cqes(struct io_uring *ring,
 	struct __kernel_timespec *ts, sigset_t *sigmask);
 extern int io_uring_wait_cqe_timeout(struct io_uring *ring,
 	struct io_uring_cqe **cqe_ptr, struct __kernel_timespec *ts);
+extern int io_uring_set_cqwait_timeout(struct io_uring *ring);
 extern int io_uring_submit(struct io_uring *ring);
 extern int io_uring_submit_and_wait(struct io_uring *ring, unsigned wait_nr);
 extern struct io_uring_sqe *io_uring_get_sqe(struct io_uring *ring);
@@ -120,10 +124,14 @@ extern int io_uring_unregister_personality(struct io_uring *ring, int id);
  */
 extern int __io_uring_get_cqe(struct io_uring *ring,
 			      struct io_uring_cqe **cqe_ptr, unsigned submit,
-			      unsigned wait_nr, sigset_t *sigmask);
+			      unsigned wait_nr, struct __kernel_timespec *ts,
+			      sigset_t *sigmask);
 
 #define LIBURING_UDATA_TIMEOUT	((__u64) -1)
 
+/* io_uring->flags_internal */
+#define IORING_FLAGS_GETEVENTS_TIMEOUT  (1U << 0) 	/* use the feature FEAT_GETEVENTS_TIMEOUT */
+
 #define io_uring_for_each_cqe(ring, head, cqe)				\
 	/*								\
 	 * io_uring_smp_load_acquire() enforces the order of tail	\
@@ -491,7 +499,7 @@ static inline int io_uring_wait_cqe_nr(struct io_uring *ring,
 				      struct io_uring_cqe **cqe_ptr,
 				      unsigned wait_nr)
 {
-	return __io_uring_get_cqe(ring, cqe_ptr, 0, wait_nr, NULL);
+	return __io_uring_get_cqe(ring, cqe_ptr, 0, wait_nr, NULL, NULL);
 }
 
 /*
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index d39b45f..3af67f6 100644
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
@@ -294,6 +296,11 @@ struct io_uring_probe {
 	struct io_uring_probe_op ops[0];
 };
 
+struct io_uring_getevents_arg {
+	sigset_t *sigmask;
+	struct __kernel_timespec *ts;
+};
+
 #ifdef __cplusplus
 }
 #endif
diff --git a/src/liburing.map b/src/liburing.map
index 38bd558..457da19 100644
--- a/src/liburing.map
+++ b/src/liburing.map
@@ -56,4 +56,6 @@ LIBURING_0.6 {
 } LIBURING_0.5;
 
 LIBURING_0.7 {
+	global:
+		io_uring_set_cqwait_timeout;
 } LIBURING_0.6;
diff --git a/src/queue.c b/src/queue.c
index be80d7a..5ee6e90 100644
--- a/src/queue.c
+++ b/src/queue.c
@@ -65,11 +65,13 @@ static int __io_uring_peek_cqe(struct io_uring *ring,
 }
 
 int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
-		       unsigned submit, unsigned wait_nr, sigset_t *sigmask)
+		       unsigned submit, unsigned wait_nr, struct __kernel_timespec *ts,
+		       sigset_t *sigmask)
 {
 	struct io_uring_cqe *cqe = NULL;
 	const int to_wait = wait_nr;
 	int ret = 0, err;
+	struct io_uring_getevents_arg arg = {0}, *argp;
 
 	do {
 		bool cq_overflow_flush = false;
@@ -87,13 +89,25 @@ int __io_uring_get_cqe(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
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
@@ -194,14 +208,26 @@ out:
 
 /*
  * Like io_uring_wait_cqe(), except it accepts a timeout value as well. Note
- * that an sqe is used internally to handle the timeout. Applications using
+ * that an sqe is used internally to handle the timeout when the feature
+ * IORING_FEAT_GETEVENTS_TIMEOUT is not supported. Applications using
  * this function must never set sqe->user_data to LIBURING_UDATA_TIMEOUT!
  *
- * If 'ts' is specified, the application need not call io_uring_submit() before
+ * If 'ts' is specified and application hasn't told us to use the
+ * FEAT_GETEVENTS_TIMEOUT, there are two cases here:
+ * 1) kernel is not supported, an sqe is used internally to handle the
+ * timeout.  Applications using this function must never set
+ * sqe->user_data to LIBURING_UDATA_TIMEOUT!
+ * 2) kernel is supported, we just flush existing submissions and use
+ * the feature FEAT_GETEVENTS_TIMEOUT.
+ *
+ * In the above cases, application needn't call io_uring_submit() before
  * calling this function, as we will do that on its behalf. From this it also
  * follows that this function isn't safe to use for applications that split SQ
  * and CQ handling between two threads and expect that to work without
  * synchronization, as this function manipulates both the SQ and CQ side.
+ *
+ * If the applications explicitly asked for the new feature, and the kernel
+ * is supported, this function will not manipulate the SQ side.
  */
 int io_uring_wait_cqes(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 		       unsigned wait_nr, struct __kernel_timespec *ts,
@@ -209,28 +235,34 @@ int io_uring_wait_cqes(struct io_uring *ring, struct io_uring_cqe **cqe_ptr,
 {
 	unsigned to_submit = 0;
 
-	if (ts) {
-		struct io_uring_sqe *sqe;
-		int ret;
-
-		/*
-		 * If the SQ ring is full, we may need to submit IO first
-		 */
-		sqe = io_uring_get_sqe(ring);
-		if (!sqe) {
-			ret = io_uring_submit(ring);
-			if (ret < 0)
-				return ret;
+	if (ts && (!(ring->flags_internal & IORING_FLAGS_GETEVENTS_TIMEOUT))) {
+		if (!(ring->features & IORING_FEAT_GETEVENTS_TIMEOUT)) {
+			/*
+			 * prepare a timeout sqe internally when
+			 * FEAT_GETEVENTS_TIMEOUT not supported.
+			 */
+			struct io_uring_sqe *sqe;
+			int ret;
+
+			/*
+			 * If the SQ ring is full, we may need to submit IO first
+			 */
 			sqe = io_uring_get_sqe(ring);
-			if (!sqe)
-				return -EAGAIN;
+			if (!sqe) {
+				ret = io_uring_submit(ring);
+				if (ret < 0)
+					return ret;
+				sqe = io_uring_get_sqe(ring);
+				if (!sqe)
+					return -EAGAIN;
+			}
+			io_uring_prep_timeout(sqe, ts, wait_nr, 0);
+			sqe->user_data = LIBURING_UDATA_TIMEOUT;
 		}
-		io_uring_prep_timeout(sqe, ts, wait_nr, 0);
-		sqe->user_data = LIBURING_UDATA_TIMEOUT;
 		to_submit = __io_uring_flush_sq(ring);
 	}
 
-	return __io_uring_get_cqe(ring, cqe_ptr, to_submit, wait_nr, sigmask);
+	return __io_uring_get_cqe(ring, cqe_ptr, to_submit, wait_nr, ts, sigmask);
 }
 
 /*
@@ -244,6 +276,16 @@ int io_uring_wait_cqe_timeout(struct io_uring *ring,
 	return io_uring_wait_cqes(ring, cqe_ptr, 1, ts, NULL);
 }
 
+int io_uring_set_cqwait_timeout(struct io_uring *ring)
+{
+	/* Applications should aware of the feature */
+	if (!(ring->features & IORING_FEAT_GETEVENTS_TIMEOUT))
+		return -EINVAL;
+
+	ring->flags_internal |= IORING_FLAGS_GETEVENTS_TIMEOUT;
+	return 0;
+}
+
 /*
  * Submit sqes acquired from io_uring_get_sqe() to the kernel.
  *
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

