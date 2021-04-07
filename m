Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63F3A356B29
	for <lists+io-uring@lfdr.de>; Wed,  7 Apr 2021 13:27:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243162AbhDGL1D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 07:27:03 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:52811 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242121AbhDGL1D (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 07:27:03 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUnhkjz_1617794806;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUnhkjz_1617794806)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 07 Apr 2021 19:26:52 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH liburing] add tests for drain io with multishot requests
Date:   Wed,  7 Apr 2021 19:26:46 +0800
Message-Id: <1617794806-37199-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

add new tests to test drain io with multishot requests

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 src/include/liburing/io_uring.h |  13 ++++
 test/Makefile                   |   2 +
 test/multicqes_drain.c          | 129 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 144 insertions(+)
 create mode 100644 test/multicqes_drain.c

diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index d3d166e57be8..0fb4ed864b3d 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -74,6 +74,7 @@ enum {
 	IOSQE_IO_HARDLINK_BIT,
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
+	IOSQE_MULTI_CQES_BIT,
 };
 
 /*
@@ -91,6 +92,8 @@ enum {
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
 /* select buffer from sqe->buf_group */
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
+/* may generate multiple cqes */
+#define IOSQE_MULTI_CQES	(1U << IOSQE_MULTI_CQES_BIT)
 
 /*
  * io_uring_setup() flags
@@ -165,6 +168,16 @@ enum {
 #define SPLICE_F_FD_IN_FIXED	(1U << 31) /* the last bit of __u32 */
 
 /*
+ * POLL_ADD flags. Note that since sqe->poll_events is the flag space, the
+ * command flags for POLL_ADD are stored in sqe->len.
+ *
+ * IORING_POLL_UPDATE           Update existing poll request, matching
+ *                              sqe->addr as the old user_data field.
+ */
+#define IORING_POLL_UPDATE_EVENTS       (1U << 1)
+#define IORING_POLL_UPDATE_USER_DATA    (1U << 2)
+
+/*
  * IO completion data structure (Completion Queue Entry)
  */
 struct io_uring_cqe {
diff --git a/test/Makefile b/test/Makefile
index 210571c22b40..8d2067c33b96 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -115,6 +115,7 @@ test_targets += \
 	unlink \
 	wakeup-hang \
 	sendmsg_fs_cve \
+	multicqes_drain
 	# EOL
 
 all_targets += $(test_targets)
@@ -253,6 +254,7 @@ test_srcs := \
 	unlink.c \
 	wakeup-hang.c \
 	sendmsg_fs_cve.c \
+	multicqes_drain.c
 	# EOL
 
 test_objs := $(patsubst %.c,%.ol,$(patsubst %.cc,%.ol,$(test_srcs)))
diff --git a/test/multicqes_drain.c b/test/multicqes_drain.c
new file mode 100644
index 000000000000..e0f45fd13d85
--- /dev/null
+++ b/test/multicqes_drain.c
@@ -0,0 +1,129 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test io_uring drain io with multishot requests
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/poll.h>
+
+#include "liburing.h"
+
+int write_pipe(int pipe, char *str)
+{
+	int ret;
+	do {
+		errno = 0;
+		ret = write(pipe, str, 3);
+	} while (ret == -1 && errno == EINTR);
+	return ret;
+}
+
+void read_pipe(int pipe)
+{
+	char str[4] = {0};
+
+	read(pipe, &str, 3);
+}
+
+static int test_multipoll_drain(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe[3];
+	int i, ret;
+	char data[4] = {0};
+	char expect[4] = {0, 0, 1, 2};
+	int pipe1[2], pipe2[2];
+
+	if (pipe(pipe1) != 0 || pipe(pipe2) != 0) {
+		perror("pipe");
+		return 1;
+	}
+
+	for (i = 0; i < 3; i++) {
+		sqe[i] = io_uring_get_sqe(ring);
+		if (!sqe[i]) {
+			printf("get sqe failed\n");
+			goto err;
+		}
+	}
+
+	io_uring_prep_poll_add(sqe[0], pipe1[0], POLLIN);
+	sqe[0]->flags |= IOSQE_MULTI_CQES;
+	sqe[0]->user_data = 0;
+	io_uring_prep_poll_add(sqe[1], pipe2[0], POLLIN);
+	sqe[1]->user_data = 1;
+	io_uring_prep_nop(sqe[2]);
+	sqe[2]->flags |= IOSQE_IO_DRAIN;
+	sqe[2]->user_data = 2;
+
+	ret = io_uring_submit(ring);
+	if (ret < 0) {
+		printf("sqe submit failed\n");
+		goto err;
+	} else if (ret < 3) {
+		printf("Submitted only %d\n", ret);
+		goto err;
+	}
+
+	if (write_pipe(pipe1[1], "foo") != 3) {
+		fprintf(stderr, "bad write return %d\n", ret);
+		return 1;
+	}
+	read_pipe(pipe1[0]);
+	if (write_pipe(pipe1[1], "foo") != 3) {
+		fprintf(stderr, "bad write return %d\n", ret);
+		return 1;
+	}
+	sleep(1);
+	if (write_pipe(pipe2[1], "foo") != 3) {
+		fprintf(stderr, "bad write return %d\n", ret);
+		return 1;
+	}
+
+	for (i = 0; i < 4; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0) {
+			printf("wait completion %d\n", ret);
+			goto err;
+		}
+
+		data[i] = cqe->user_data;
+		io_uring_cqe_seen(ring, cqe);
+	}
+
+	if (memcmp(data, expect, 4) != 0)
+		goto err;
+
+	return 0;
+err:
+	return 1;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int i, ret;
+
+	if (argc > 1)
+		return 0;
+
+	ret = io_uring_queue_init(20, &ring, 0);
+	if (ret) {
+		printf("ring setup failed\n");
+		return 1;
+	}
+
+	for (i = 0; i < 10; i++) {
+		ret = test_multipoll_drain(&ring);
+		if (ret) {
+			fprintf(stderr, "test_multipoll_drain failed\n");
+			break;
+		}
+	}
+
+	return ret;
+}
-- 
1.8.3.1

