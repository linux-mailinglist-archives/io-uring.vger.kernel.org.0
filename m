Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2086C2D848F
	for <lists+io-uring@lfdr.de>; Sat, 12 Dec 2020 05:52:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438236AbgLLEvV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Dec 2020 23:51:21 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:46449 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2438229AbgLLEvC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Dec 2020 23:51:02 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UIICc2F_1607748579;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UIICc2F_1607748579)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 12 Dec 2020 12:49:50 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH liburing v2 RESEND] test/timeout-new: test for timeout feature
Date:   Sat, 12 Dec 2020 12:49:39 +0800
Message-Id: <1607748579-92734-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20201211101121.uk5i75uw2fln3zdh@steredhat>
References: <20201211101121.uk5i75uw2fln3zdh@steredhat>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Tests for the new timeout feature. It covers:
    - wake up when timeout, sleeping time calculated as well
    - wake up by a cqe before timeout
    - the above two in sqpoll thread mode
    - multi child-threads wake up by a cqe issuing in main thread before
      timeout

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 .gitignore         |   1 +
 test/Makefile      |   3 +
 test/timeout-new.c | 246 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 250 insertions(+)
 create mode 100644 test/timeout-new.c

diff --git a/.gitignore b/.gitignore
index c85a49ba6a85..360064a25228 100644
--- a/.gitignore
+++ b/.gitignore
@@ -108,6 +108,7 @@
 /test/submit-reuse
 /test/teardowns
 /test/timeout
+/test/timeout-new
 /test/timeout-overflow
 /test/unlink
 /test/wakeup-hang
diff --git a/test/Makefile b/test/Makefile
index dbbb485ded79..6aa1788f486b 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -103,6 +103,7 @@ test_targets += \
 	submit-reuse \
 	teardowns \
 	timeout \
+	timeout-new \
 	timeout-overflow \
 	unlink \
 	wakeup-hang \
@@ -225,6 +226,7 @@ test_srcs := \
 	stdout.c \
 	submit-reuse.c \
 	teardowns.c \
+	timeout-new.c \
 	timeout-overflow.c \
 	timeout.c \
 	unlink.c \
@@ -245,6 +247,7 @@ across-fork: XCFLAGS = -lpthread
 ce593a6c480a-test: XCFLAGS = -lpthread
 wakeup-hang: XCFLAGS = -lpthread
 pipe-eof: XCFLAGS = -lpthread
+timeout-new: XCFLAGS = -lpthread
 
 install: $(test_targets) runtests.sh runtests-loop.sh
 	$(INSTALL) -D -d -m 755 $(datadir)/liburing-test/
diff --git a/test/timeout-new.c b/test/timeout-new.c
new file mode 100644
index 000000000000..45b9a149ae11
--- /dev/null
+++ b/test/timeout-new.c
@@ -0,0 +1,246 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: tests for getevents timeout
+ *
+ */
+#include <stdio.h>
+#include <sys/time.h>
+#include <unistd.h>
+#include <pthread.h>
+#include "liburing.h"
+
+#define TIMEOUT_MSEC	200
+#define TIMEOUT_SEC	10
+
+int thread_ret0, thread_ret1;
+int cnt = 0;
+pthread_mutex_t mutex;
+
+static void msec_to_ts(struct __kernel_timespec *ts, unsigned int msec)
+{
+	ts->tv_sec = msec / 1000;
+	ts->tv_nsec = (msec % 1000) * 1000000;
+}
+
+static unsigned long long mtime_since(const struct timeval *s,
+				      const struct timeval *e)
+{
+	long long sec, usec;
+
+	sec = e->tv_sec - s->tv_sec;
+	usec = (e->tv_usec - s->tv_usec);
+	if (sec > 0 && usec < 0) {
+		sec--;
+		usec += 1000000;
+	}
+
+	sec *= 1000;
+	usec /= 1000;
+	return sec + usec;
+}
+
+static unsigned long long mtime_since_now(struct timeval *tv)
+{
+	struct timeval end;
+
+	gettimeofday(&end, NULL);
+	return mtime_since(tv, &end);
+}
+
+
+static int test_return_before_timeout(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+	struct __kernel_timespec ts;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+		return 1;
+	}
+
+	io_uring_prep_nop(sqe);
+
+	ret = io_uring_submit(ring);
+	if (ret <= 0) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	msec_to_ts(&ts, TIMEOUT_MSEC);
+	ret = io_uring_wait_cqe_timeout(ring, &cqe, &ts);
+	if (ret < 0) {
+		fprintf(stderr, "%s: timeout error: %d\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	io_uring_cqe_seen(ring, cqe);
+	return 0;
+}
+
+static int test_return_after_timeout(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	int ret;
+	struct __kernel_timespec ts;
+	struct timeval tv;
+	unsigned long long exp;
+
+	msec_to_ts(&ts, TIMEOUT_MSEC);
+	gettimeofday(&tv, NULL);
+	ret = io_uring_wait_cqe_timeout(ring, &cqe, &ts);
+	exp = mtime_since_now(&tv);
+	if (ret != -ETIME) {
+		fprintf(stderr, "%s: timeout error: %d\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	if (exp < TIMEOUT_MSEC / 2 || exp > (TIMEOUT_MSEC  * 3) / 2) {
+		fprintf(stderr, "%s: Timeout seems wonky (got %llu)\n", __FUNCTION__, exp);
+		return 1;
+	}
+
+	return 0;
+}
+
+int __reap_thread_fn(void *data) {
+	struct io_uring *ring = (struct io_uring *)data;
+	struct io_uring_cqe *cqe;
+	struct __kernel_timespec ts;
+
+	msec_to_ts(&ts, TIMEOUT_SEC);
+	pthread_mutex_lock(&mutex);
+	cnt++;
+	pthread_mutex_unlock(&mutex);
+	return io_uring_wait_cqe_timeout(ring, &cqe, &ts);
+}
+
+void *reap_thread_fn0(void *data) {
+	thread_ret0 = __reap_thread_fn(data);
+	return NULL;
+}
+
+void *reap_thread_fn1(void *data) {
+	thread_ret1 = __reap_thread_fn(data);
+	return NULL;
+}
+
+/*
+ * This is to test issuing a sqe in main thread and reaping it in two child-thread
+ * at the same time. To see if timeout feature works or not.
+ */
+int test_multi_threads_timeout() {
+	struct io_uring ring;
+	int ret;
+	bool both_wait = false;
+	pthread_t reap_thread0, reap_thread1;
+	struct io_uring_sqe *sqe;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "%s: ring setup failed: %d\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	pthread_create(&reap_thread0, NULL, reap_thread_fn0, &ring);
+	pthread_create(&reap_thread1, NULL, reap_thread_fn1, &ring);
+
+	/*
+	 * make two threads both enter io_uring_wait_cqe_timeout() before issuing the sqe
+	 * as possible as we can. So that there are two threads in the ctx->wait queue.
+	 * In this way, we can test if a cqe wakes up two threads at the same time.
+	 */
+	while(!both_wait) {
+		pthread_mutex_lock(&mutex);
+		if (cnt == 2)
+			both_wait = true;
+		pthread_mutex_unlock(&mutex);
+		sleep(1);
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+		goto err;
+	}
+
+	io_uring_prep_nop(sqe);
+
+	ret = io_uring_submit(&ring);
+	if (ret <= 0) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	pthread_join(reap_thread0, NULL);
+	pthread_join(reap_thread1, NULL);
+
+	if ((thread_ret0 && thread_ret0 != -ETIME) || (thread_ret1 && thread_ret1 != -ETIME)) {
+		fprintf(stderr, "%s: thread wait cqe timeout failed: %d %d\n",
+				__FUNCTION__, thread_ret0, thread_ret1);
+		goto err;
+	}
+
+	return 0;
+err:
+	return 1;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring_normal, ring_sq;
+	int ret;
+
+	if (argc > 1)
+		return 0;
+
+	ret = io_uring_queue_init(8, &ring_normal, 0);
+	if (ret) {
+		fprintf(stderr, "ring_normal setup failed: %d\n", ret);
+		return 1;
+	}
+	if (!(ring_normal.features & IORING_FEAT_EXT_ARG)) {
+		fprintf(stderr, "feature IORING_FEAT_EXT_ARG not supported.\n");
+		return 1;
+	}
+
+	ret = test_return_before_timeout(&ring_normal);
+	if (ret) {
+		fprintf(stderr, "ring_normal: test_return_before_timeout failed\n");
+		return ret;
+	}
+
+	ret = test_return_after_timeout(&ring_normal);
+	if (ret) {
+		fprintf(stderr, "ring_normal: test_return_after_timeout failed\n");
+		return ret;
+	}
+
+	ret = io_uring_queue_init(8, &ring_sq, IORING_SETUP_SQPOLL);
+	if (ret) {
+		fprintf(stderr, "ring_sq setup failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = test_return_before_timeout(&ring_sq);
+	if (ret) {
+		fprintf(stderr, "ring_sq: test_return_before_timeout failed\n");
+		return ret;
+	}
+
+	ret = test_return_after_timeout(&ring_sq);
+	if (ret) {
+		fprintf(stderr, "ring_sq: test_return_after_timeout failed\n");
+		return ret;
+	}
+
+	ret = test_multi_threads_timeout();
+	if (ret) {
+		fprintf(stderr, "test_multi_threads_timeout failed\n");
+		return ret;
+	}
+
+	return 0;
+}
-- 
1.8.3.1

