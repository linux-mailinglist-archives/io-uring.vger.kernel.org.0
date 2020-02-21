Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6199168216
	for <lists+io-uring@lfdr.de>; Fri, 21 Feb 2020 16:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729167AbgBUPoH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Feb 2020 10:44:07 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:20831 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729120AbgBUPoH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Feb 2020 10:44:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582299845;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=au5w5k7HxBHqjH5cZQKFsvOJIbXWXe9r1KGkl1Ke4uY=;
        b=W901IntcAt51t/z4q6CrVKFAuDaBT1M/TxItx7c6HugoHX2626H9SgwHY7+HfylYIVRV3/
        Kw+3r8MOJhDcX3i+Pa34GbJlhGOERXtQPOj3zEIGzriqNazD9y1vG/Gr+ki5DCSXKoe9W0
        dBEQ5RUMzED8wap9x06ICdAKDjXcakI=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-391-3fnPA-khNp6AP8bYnHvG8g-1; Fri, 21 Feb 2020 10:44:04 -0500
X-MC-Unique: 3fnPA-khNp6AP8bYnHvG8g-1
Received: by mail-wm1-f70.google.com with SMTP id k21so734940wmi.2
        for <io-uring@vger.kernel.org>; Fri, 21 Feb 2020 07:44:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=au5w5k7HxBHqjH5cZQKFsvOJIbXWXe9r1KGkl1Ke4uY=;
        b=iAOOupWW1JOLnf+FNKqJKBjYv4IEkbJBoL5trm8o1bBcqffpWikXLTrfSwwsNlmk8X
         iBQSd2DsuVZtcYdr/vq+niLUG173XVw4qT4m+wXeCFd3NlIXiYwMq11W2Wd8mSpHrwyG
         XvCsm2WEUquhnT9pwUweU08hGg+7iqpXKLfMIcIP2sN6koBhpwMppQR+5RvsEVCHg1tH
         y/50d3cs/QWiGUKofNe3gYtZutskqR+U1I9dwvbmtpRSsSTv5KaCTXhoRGVLEwkD6Wye
         bMCG/daqy1TVY6Z6ga5zL2PtvDWdO+iuDEyUtbLmrwg3gvDRjSupxOgRo+mDC6HwMUM5
         /dqQ==
X-Gm-Message-State: APjAAAWhIpXNvBEKmQwDQIvCnApgKQ02xgGNXqNQuKANUg/AtYjGEFMw
        Pz6puiivzYivtzYT7U/QA1oSoP8+ylbbgikHJWeNVx9lmBxQgVa6Bh4jcymyViFB2YEc/KSmIxN
        8l5poMCiFxukR3ZQlIj0=
X-Received: by 2002:adf:cd92:: with SMTP id q18mr48502654wrj.261.1582299842704;
        Fri, 21 Feb 2020 07:44:02 -0800 (PST)
X-Google-Smtp-Source: APXvYqzFbR8YpdMkB2LZ7XzQfd990NVbaWIbX6cjjg8jokRX93gXdIpYyctYMtN2MnduFH2I7b1DNw==
X-Received: by 2002:adf:cd92:: with SMTP id q18mr48502636wrj.261.1582299842449;
        Fri, 21 Feb 2020 07:44:02 -0800 (PST)
Received: from steredhat.redhat.com (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id s1sm4297072wro.66.2020.02.21.07.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Feb 2020 07:44:01 -0800 (PST)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH liburing] test: add sq-poll-kthread test case
Date:   Fri, 21 Feb 2020 16:44:00 +0100
Message-Id: <20200221154400.207213-1-sgarzare@redhat.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

sq-poll-kthread tests if the 'io_uring-sq' kthread is stopped
when the userspace process ended with or without closing the
io_uring fd.

Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 .gitignore             |   1 +
 test/Makefile          |   4 +-
 test/sq-poll-kthread.c | 165 +++++++++++++++++++++++++++++++++++++++++
 3 files changed, 168 insertions(+), 2 deletions(-)
 create mode 100644 test/sq-poll-kthread.c

diff --git a/.gitignore b/.gitignore
index 1ab4075..9f85a5f 100644
--- a/.gitignore
+++ b/.gitignore
@@ -75,6 +75,7 @@
 /test/short-read
 /test/socket-rw
 /test/sq-full
+/test/sq-poll-kthread
 /test/sq-space_left
 /test/statx
 /test/stdout
diff --git a/test/Makefile b/test/Makefile
index cf91011..09c7aa2 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -20,7 +20,7 @@ all_targets += poll poll-cancel ring-leak fsync io_uring_setup io_uring_register
 		connect 7ad0e4b2f83c-test submit-reuse fallocate open-close \
 		file-update statx accept-reuse poll-v-poll fadvise madvise \
 		short-read openat2 probe shared-wq personality eventfd \
-		send_recv eventfd-ring across-fork
+		send_recv eventfd-ring across-fork sq-poll-kthread
 
 include ../Makefile.quiet
 
@@ -47,7 +47,7 @@ test_srcs := poll.c poll-cancel.c ring-leak.c fsync.c io_uring_setup.c \
 	7ad0e4b2f83c-test.c submit-reuse.c fallocate.c open-close.c \
 	file-update.c statx.c accept-reuse.c poll-v-poll.c fadvise.c \
 	madvise.c short-read.c openat2.c probe.c shared-wq.c \
-	personality.c eventfd.c eventfd-ring.c across-fork.c
+	personality.c eventfd.c eventfd-ring.c across-fork.c sq-poll-kthread.c
 
 test_objs := $(patsubst %.c,%.ol,$(test_srcs))
 
diff --git a/test/sq-poll-kthread.c b/test/sq-poll-kthread.c
new file mode 100644
index 0000000..d53605c
--- /dev/null
+++ b/test/sq-poll-kthread.c
@@ -0,0 +1,165 @@
+/*
+ * Description: test if io_uring SQ poll kthread is stopped when the userspace
+ *              process ended with or without closing the io_uring fd
+ *
+ */
+#include <errno.h>
+#include <fcntl.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <pthread.h>
+#include <stdbool.h>
+#include <stdlib.h>
+#include <string.h>
+#include <signal.h>
+#include <sys/poll.h>
+#include <sys/wait.h>
+#include <sys/epoll.h>
+
+#include "liburing.h"
+
+#define SQ_THREAD_IDLE  2000
+#define BUF_SIZE        128
+#define KTHREAD_NAME    "io_uring-sq"
+
+enum {
+	TEST_OK = 0,
+	TEST_SKIPPED = 1,
+	TEST_FAILED = 2,
+};
+
+static int do_test_sq_poll_kthread_stopped(bool do_exit)
+{
+	int ret = 0, pipe1[2];
+	struct io_uring_params param;
+	struct io_uring ring;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	uint8_t buf[BUF_SIZE];
+	struct iovec iov;
+
+	if (geteuid()) {
+		fprintf(stderr, "sqpoll requires root!\n");
+		return TEST_SKIPPED;
+	}
+
+	if (pipe(pipe1) != 0) {
+		perror("pipe");
+		return TEST_FAILED;
+	}
+
+	memset(&param, 0, sizeof(param));
+
+	param.flags |= IORING_SETUP_SQPOLL;
+	param.sq_thread_idle = SQ_THREAD_IDLE;
+
+	ret = io_uring_queue_init_params(16, &ring, &param);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		ret = TEST_FAILED;
+		goto err_pipe;
+	}
+
+	ret = io_uring_register_files(&ring, &pipe1[1], 1);
+	if (ret) {
+		fprintf(stderr, "file reg failed: %d\n", ret);
+		ret = TEST_FAILED;
+		goto err_uring;
+	}
+
+	iov.iov_base = buf;
+	iov.iov_len = BUF_SIZE;
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		fprintf(stderr, "io_uring_get_sqe failed\n");
+		ret = TEST_FAILED;
+		goto err_uring;
+	}
+
+	io_uring_prep_writev(sqe, 0, &iov, 1, 0);
+	sqe->flags |= IOSQE_FIXED_FILE;
+
+	ret = io_uring_submit(&ring);
+	if (ret < 0) {
+		fprintf(stderr, "io_uring_submit failed - ret: %d\n",
+			ret);
+		ret = TEST_FAILED;
+		goto err_uring;
+	}
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "io_uring_wait_cqe - ret: %d\n",
+			ret);
+		ret = TEST_FAILED;
+		goto err_uring;
+	}
+
+	if (cqe->res != BUF_SIZE) {
+		fprintf(stderr, "unexpected cqe->res %d [expected %d]\n",
+			cqe->res, BUF_SIZE);
+		ret = TEST_FAILED;
+		goto err_uring;
+
+	}
+
+	io_uring_cqe_seen(&ring, cqe);
+
+	ret = TEST_OK;
+
+err_uring:
+	if (do_exit)
+		io_uring_queue_exit(&ring);
+err_pipe:
+	close(pipe1[0]);
+	close(pipe1[1]);
+
+	return ret;
+}
+
+int test_sq_poll_kthread_stopped(bool do_exit) {
+	pid_t pid;
+	int status = 0;
+
+	pid = fork();
+
+	if (pid == 0) {
+		int ret = do_test_sq_poll_kthread_stopped(do_exit);
+		exit(ret);
+	}
+
+	pid = wait(&status);
+	if (status != 0)
+		return WEXITSTATUS(status);
+
+	if (system("ps --ppid 2 | grep " KTHREAD_NAME) == 0) {
+		fprintf(stderr, "%s kthread still running!\n", KTHREAD_NAME);
+		return TEST_FAILED;
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	ret = test_sq_poll_kthread_stopped(true);
+	if (ret == TEST_SKIPPED) {
+		printf("test_sq_poll_kthread_stopped_exit: skipped\n");
+	} else if (ret == TEST_FAILED) {
+		fprintf(stderr, "test_sq_poll_kthread_stopped_exit failed\n");
+		return ret;
+	}
+
+	ret = test_sq_poll_kthread_stopped(false);
+	if (ret == TEST_SKIPPED) {
+		printf("test_sq_poll_kthread_stopped_noexit: skipped\n");
+	} else if (ret == TEST_FAILED) {
+		fprintf(stderr, "test_sq_poll_kthread_stopped_noexit failed\n");
+		return ret;
+	}
+
+	return 0;
+}
-- 
2.24.1

