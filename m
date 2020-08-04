Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A6523B79D
	for <lists+io-uring@lfdr.de>; Tue,  4 Aug 2020 11:22:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729294AbgHDJWE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 4 Aug 2020 05:22:04 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:43095 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729570AbgHDJWE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 4 Aug 2020 05:22:04 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04427;MF=jiufei.xue@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U4jIx70_1596532920;
Received: from localhost(mailfrom:jiufei.xue@linux.alibaba.com fp:SMTPD_---0U4jIx70_1596532920)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 04 Aug 2020 17:22:00 +0800
From:   Jiufei Xue <jiufei.xue@linux.alibaba.com>
To:     axboe@kernel.dk
Cc:     io-uring@vger.kernel.org, metze@samba.org,
        Jiufei Xue <jiufei.xue@linux.alibaba.com>
Subject: [PATCH liburing v2 2/2] test/timeout: add testcase for new timeout feature
Date:   Tue,  4 Aug 2020 17:21:53 +0800
Message-Id: <1596532913-70757-3-git-send-email-jiufei.xue@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1596532913-70757-1-git-send-email-jiufei.xue@linux.alibaba.com>
References: <1596532913-70757-1-git-send-email-jiufei.xue@linux.alibaba.com>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 test/Makefile  |  1 +
 test/timeout.c | 97 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 98 insertions(+)

diff --git a/test/Makefile b/test/Makefile
index a693d6f..8892ee9 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -89,6 +89,7 @@ submit-reuse: XCFLAGS = -lpthread
 poll-v-poll: XCFLAGS = -lpthread
 across-fork: XCFLAGS = -lpthread
 ce593a6c480a-test: XCFLAGS = -lpthread
+timeout: XCFLAGS = -lpthread
 
 install: $(all_targets) runtests.sh runtests-loop.sh
 	$(INSTALL) -D -d -m 755 $(datadir)/liburing-test/
diff --git a/test/timeout.c b/test/timeout.c
index 7e9f11d..008acc5 100644
--- a/test/timeout.c
+++ b/test/timeout.c
@@ -10,6 +10,7 @@
 #include <string.h>
 #include <fcntl.h>
 #include <sys/time.h>
+#include <pthread.h>
 
 #include "liburing.h"
 #include "../src/syscall.h"
@@ -18,6 +19,11 @@
 static int not_supported;
 static int no_modify;
 
+struct thread_data {
+	struct io_uring *ring;
+	volatile int do_exit;
+};
+
 static void msec_to_ts(struct __kernel_timespec *ts, unsigned int msec)
 {
 	ts->tv_sec = msec / 1000;
@@ -232,6 +238,91 @@ err:
 	return 1;
 }
 
+static void *test_reap_thread_fn(void *__data)
+{
+	struct thread_data *data = __data;
+	struct io_uring *ring = (struct io_uring *)data->ring;
+	struct io_uring_cqe *cqe;
+	struct __kernel_timespec ts;
+	int ret, i = 0;
+
+	msec_to_ts(&ts, TIMEOUT_MSEC);
+	while (!data->do_exit) {
+		ret = io_uring_wait_cqes(ring, &cqe, 2, &ts, NULL);
+		if (ret == -ETIME) {
+			if (i == 2)
+				break;
+			else
+				continue;
+		} else if (ret < 0) {
+			fprintf(stderr, "%s: wait timeout failed: %d\n", __FUNCTION__, ret);
+			goto err;
+		}
+		ret = cqe->res;
+		if (ret < 0) {
+			fprintf(stderr, "res: %d\n", ret);
+			goto err;
+		}
+
+		io_uring_cqe_seen(ring, cqe);
+		i++;
+	}
+
+	if (i != 2) {
+		fprintf(stderr, "got %d completions\n", i);
+		ret = 1;
+		goto err;
+	}
+	return NULL;
+
+err:
+	return (void *)(intptr_t)ret;
+}
+
+static int test_single_timeout_wait_new(struct io_uring *ring)
+{
+	struct thread_data data;
+	struct io_uring_sqe *sqe;
+	pthread_t reap_thread;
+	int ret;
+	void *retval;
+
+	if (!(ring->features & IORING_FEAT_GETEVENTS_TIMEOUT)) {
+		fprintf(stdout, "feature IORING_FEAT_GETEVENTS_TIMEOUT not supported.\n");
+		return 0;
+	}
+	if (io_uring_set_cqwait_timeout(ring)) {
+		fprintf(stdout, "o_uring_set_cqwait_timeout failed.\n");
+		return 1;
+	}
+
+	data.ring = ring;
+	data.do_exit = 0;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_nop(sqe);
+	io_uring_sqe_set_data(sqe, (void *) 1);
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_nop(sqe);
+	io_uring_sqe_set_data(sqe, (void *) 1);
+
+	pthread_create(&reap_thread, NULL, test_reap_thread_fn, &data);
+
+	ret = io_uring_submit(ring);
+	if (ret <= 0) {
+		fprintf(stderr, "%s: sqe submit failed: %d\n", __FUNCTION__, ret);
+		goto err;
+	}
+
+	sleep(1);
+	data.do_exit = 1;
+	pthread_join(reap_thread, &retval);
+	return (int)(intptr_t)retval;
+err:
+	return 1;
+}
+
 /*
  * Test single timeout waking us up
  */
@@ -1054,6 +1145,12 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_single_timeout_wait_new(&ring);
+	if (ret) {
+		fprintf(stderr, "test_single_timeout_wait_new failed\n");
+		return ret;
+	}
+
 	/*
 	 * this test must go last, it kills the ring
 	 */
-- 
1.8.3.1

