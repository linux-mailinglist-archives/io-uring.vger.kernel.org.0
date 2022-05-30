Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C3F5386D0
	for <lists+io-uring@lfdr.de>; Mon, 30 May 2022 19:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232244AbiE3RgL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 30 May 2022 13:36:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiE3RgJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 30 May 2022 13:36:09 -0400
Received: from out30-43.freemail.mail.aliyun.com (out30-43.freemail.mail.aliyun.com [115.124.30.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B9A26898D
        for <io-uring@vger.kernel.org>; Mon, 30 May 2022 10:36:06 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VEqzI3Q_1653932164;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0VEqzI3Q_1653932164)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 31 May 2022 01:36:04 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [LIBURING PATCH v2] Let IORING_OP_FILES_UPDATE support to choose fixed file slots
Date:   Tue, 31 May 2022 01:36:04 +0800
Message-Id: <20220530173604.38000-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.14.4.44.g2045bb6
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Allocate available direct descriptors instead of having the
application pass free fixed file slots. To use it, pass
IORING_FILE_INDEX_ALLOC to io_uring_prep_files_update(), then
io_uring in kernel will store picked fixed file slots in fd
array and let cqe return the number of slots allocated.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
V2:
  Update io_uring_prep_close(3) and io_uring_prep_files_update(3)'s man.
  Skip test in case old kernel does not support IORING_FILE_INDEX_ALLOC.
---
 man/io_uring_prep_close.3        |  10 +++
 man/io_uring_prep_files_update.3 |  10 +++
 src/include/liburing.h           |   8 +++
 src/include/liburing/io_uring.h  |   6 ++
 test/Makefile                    |   1 +
 test/file-update-index-alloc.c   | 139 +++++++++++++++++++++++++++++++++++++++
 6 files changed, 174 insertions(+)
 create mode 100644 test/file-update-index-alloc.c

diff --git a/man/io_uring_prep_close.3 b/man/io_uring_prep_close.3
index 055e824..9e924a1 100644
--- a/man/io_uring_prep_close.3
+++ b/man/io_uring_prep_close.3
@@ -15,6 +15,9 @@ io_uring_prep_close  - prepare a file descriptor close request
 .BI "
 .BI "void io_uring_prep_close_direct(struct io_uring_sqe *" sqe ","
 .BI "                                unsigned " file_index ");"
+.BI "
+.BI "void io_uring_prep_close_all(struct io_uring_sqe *" sqe ","
+.BI "                             int " fd ", unsigned " file_index ");"
 .PP
 .SH DESCRIPTION
 .PP
@@ -32,6 +35,13 @@ argument instead of the
 This is identical to unregistering the direct descriptor, and is provided as
 a convenience.
 
+For a close request which also has a direct descriptor, the
+.BR io_uring_prep_close_all(3)
+function is identical to close file descriptor indicated by
+.I fd
+and unregister the direct descriptor specified by the
+.I file_index.
+
 This function prepares an async
 .BR close (2)
 request. See that man page for details.
diff --git a/man/io_uring_prep_files_update.3 b/man/io_uring_prep_files_update.3
index c9b88b8..95c6c4f 100644
--- a/man/io_uring_prep_files_update.3
+++ b/man/io_uring_prep_files_update.3
@@ -35,6 +35,16 @@ entry is updated and then removed from the table. This operation is equivalent t
 first unregistering that entry and then inserting a new one, just bundled into
 one combined operation.
 
+If
+.I offset
+is specified as IORING_FILE_INDEX_ALLOC, io_uring will allocate free direct
+descriptors instead of having the application to pass, and store allocated
+direct descriptors into
+.I fds
+array,
+.I cqe->res
+will return the number of direct descriptors allocated.
+
 .SH RETURN VALUE
 None
 .SH ERRORS
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 6429dff..bc82d99 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -614,6 +614,14 @@ static inline void io_uring_prep_close_direct(struct io_uring_sqe *sqe,
 	__io_uring_set_target_fixed_file(sqe, file_index);
 }
 
+static inline void io_uring_prep_close_all(struct io_uring_sqe *sqe,
+					   int fd, unsigned file_index)
+{
+	io_uring_prep_close(sqe, fd);
+	__io_uring_set_target_fixed_file(sqe, file_index);
+	sqe->close_flags = IORING_CLOSE_FD_AND_FILE_SLOT;
+}
+
 static inline void io_uring_prep_read(struct io_uring_sqe *sqe, int fd,
 				      void *buf, unsigned nbytes, __u64 offset)
 {
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 2f391c9..15d9fbd 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -50,6 +50,7 @@ struct io_uring_sqe {
 		__u32		unlink_flags;
 		__u32		hardlink_flags;
 		__u32		xattr_flags;
+		__u32		close_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -78,6 +79,11 @@ struct io_uring_sqe {
  */
 #define IORING_FILE_INDEX_ALLOC		(~0U)
 
+/*
+ * close flags, store in sqe->close_flags.
+ */
+#define IORING_CLOSE_FD_AND_FILE_SLOT	(1U << 0)
+
 enum {
 	IOSQE_FIXED_FILE_BIT,
 	IOSQE_IO_DRAIN_BIT,
diff --git a/test/Makefile b/test/Makefile
index 51c35a9..ab031e0 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -79,6 +79,7 @@ test_srcs := \
 	files-exit-hang-poll.c \
 	files-exit-hang-timeout.c \
 	file-update.c \
+	file-update-index-alloc.c \
 	file-verify.c \
 	fixed-buf-iter.c \
 	fixed-link.c \
diff --git a/test/file-update-index-alloc.c b/test/file-update-index-alloc.c
new file mode 100644
index 0000000..e4bc73c
--- /dev/null
+++ b/test/file-update-index-alloc.c
@@ -0,0 +1,139 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test IORING_OP_FILES_UPDATE can support io_uring
+ * allocates an available direct descriptor instead of having the
+ * application pass one.
+ */
+
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/uio.h>
+
+#include "helpers.h"
+#include "liburing.h"
+
+int main(int argc, char *argv[])
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	char wbuf[1] = { 0xef }, rbuf[1] = {0x0};
+	struct io_uring ring;
+	int i, ret, pipe_fds[2], fds[2] = { -1, -1};
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		return -1;
+	}
+
+	ret = io_uring_register_files(&ring, fds, 2);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __func__, ret);
+		return -1;
+	}
+
+	if (pipe2(pipe_fds, O_NONBLOCK)) {
+		fprintf(stderr, "pipe() failed\n");
+		return -1;
+	}
+
+	/*
+	 * Pass IORING_FILE_INDEX_ALLOC, so io_uring in kernel will allocate
+	 * available direct descriptors.
+	 */
+	fds[0] = pipe_fds[0];
+	fds[1] = pipe_fds[1];
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_files_update(sqe, fds, 2, IORING_FILE_INDEX_ALLOC);
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		return -1;
+	}
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "wait files update completion failed: %d\n", ret);
+		return ret;
+	}
+
+	if (cqe->res < 0) {
+		if (cqe->res == -EINVAL) {
+			fprintf(stdout, "files update(IORING_FILE_INDEX_ALLOC) not "
+				"supported, skipping\n");
+			return 0;
+		}
+		fprintf(stderr, "files update(IORING_FILE_INDEX_ALLOC) failed: %d\n", ret);
+		return ret;
+	}
+	ret = cqe->res;
+	if (ret != 2) {
+		fprintf(stderr, "should allocate 2 direct descriptors, but get:%d\n", ret);
+		return -1;
+	}
+	if (fds[0] != 0 || fds[1] != 1) {
+		fprintf(stderr, "allocate wrong direct descriptors:%d %d\n",
+			fds[0], fds[1]);
+		return -1;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_write(sqe, fds[1], wbuf, sizeof(wbuf), 0);
+	sqe->flags |= IOSQE_FIXED_FILE;
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		return -1;
+	}
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret < 0 || cqe->res < 0) {
+		fprintf(stderr, "write failed %d\n", ret);
+		return ret;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_read(sqe, fds[0], rbuf, sizeof(rbuf), 0);
+	sqe->flags |= IOSQE_FIXED_FILE;
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		return -1;
+	}
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret < 0 || cqe->res < 0) {
+		fprintf(stderr, "read failed %d\n", ret);
+		return ret;
+	}
+	if (rbuf[0] != (char)0xef) {
+		fprintf(stderr, "read wrong data %x\n", rbuf[0]);
+		return ret;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_close_all(sqe, pipe_fds[0], fds[0]);
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_close_all(sqe, pipe_fds[1], fds[1]);
+	ret = io_uring_submit(&ring);
+	if (ret != 2) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		return -1;
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret < 0 || cqe->res < 0) {
+			fprintf(stderr, "wait close completion %d\n", ret);
+			return ret;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
-- 
2.14.4.44.g2045bb6

