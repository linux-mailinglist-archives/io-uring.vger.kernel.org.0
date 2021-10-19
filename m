Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB1F433511
	for <lists+io-uring@lfdr.de>; Tue, 19 Oct 2021 13:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbhJSLww (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 19 Oct 2021 07:52:52 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:45432 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235383AbhJSLww (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 19 Oct 2021 07:52:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UsvUnOV_1634644231;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UsvUnOV_1634644231)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 19 Oct 2021 19:50:38 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH liburing] io_uring: add tests for async hybrid optimization
Date:   Tue, 19 Oct 2021 19:50:31 +0800
Message-Id: <20211019115031.119176-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This test file is to test async hybrid optimization for pollable
requests.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 test/Makefile       |   2 +
 test/async_hybrid.c | 103 ++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+)
 create mode 100644 test/async_hybrid.c

diff --git a/test/Makefile b/test/Makefile
index 1a10a24c26b1..226bc5f0bc49 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -40,6 +40,7 @@ test_targets += \
 	accept-reuse \
 	accept-test \
 	across-fork splice \
+	async_hybrid \
 	b19062a56726-test \
 	b5837bd5311d-test \
 	ce593a6c480a-test \
@@ -192,6 +193,7 @@ test_srcs := \
 	accept-test.c \
 	accept.c \
 	across-fork.c \
+	async_hybrid.c \
 	b19062a56726-test.c \
 	b5837bd5311d-test.c \
 	ce593a6c480a-test.c \
diff --git a/test/async_hybrid.c b/test/async_hybrid.c
new file mode 100644
index 000000000000..2e38e2036c0c
--- /dev/null
+++ b/test/async_hybrid.c
@@ -0,0 +1,103 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: async hybrid tests
+ */
+#include <stdio.h>
+#include <unistd.h>
+#include <fcntl.h>
+
+#include "liburing.h"
+
+int write_pipe(int pipe, char *str)
+{
+    int ret;
+    do {
+        errno = 0;
+        ret = write(pipe, str, 3);
+    } while (ret == -1 && errno == EINTR);
+    return ret;
+}
+
+static int _test(struct io_uring *ring, bool async, bool link, bool drain)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int i, ret, fds[2];
+	char buf[4] = {0};
+	unsigned int flags = 0;
+
+	if (pipe2(fds, O_NONBLOCK)) {
+		perror("pipe");
+		return 1;
+	}
+
+	if (async)
+		flags |= IOSQE_ASYNC;
+	if (link)
+		flags |= IOSQE_IO_LINK;
+	if (drain)
+		flags |= IOSQE_IO_DRAIN;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_read(sqe, fds[0], buf, 3, 0);
+	sqe->flags = flags;
+	sqe->user_data = 1;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_nop(sqe);
+	sqe->flags = flags;
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(ring);
+	if (ret != 2) {
+		fprintf(stderr, "submitted %d\n", ret);
+		return 1;
+	}
+
+	sleep(3);
+	write_pipe(fds[1], "foo");
+
+	for (i = 0; i < 2; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "wait_cqe=%d\n", ret);
+			return 1;
+		}
+		if ((cqe->user_data == 1 && cqe->res != 3) ||
+		    (cqe->user_data == 2 && cqe->res)) {
+			fprintf(stderr, "user_data:%lld, res:%d\n", cqe->user_data, cqe->res);
+			return 1;
+		}
+		if ((link || drain) && !i && cqe->user_data != 1) {
+			fprintf(stderr, "linked sqes, completed in wrong order\n");
+			return 1;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int i, ret;
+	struct io_uring ring;
+
+	ret = io_uring_queue_init(20,  &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		return 1;
+	}
+
+
+	for (i = 0; i < 8; i++) {
+		ret = _test(&ring, i & 1, !!(i & 2), !!(i & 4));
+		if (ret) {
+			fprintf(stderr, "async:%d link:%d drain:%d test failed\n",
+				i & 1, !!(i & 2), !!(i & 4));
+			return 1;
+		}
+	}
+
+	return 0;
+}
-- 
2.24.4

