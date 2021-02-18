Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8B931EBA6
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 16:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232545AbhBRPkv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 10:40:51 -0500
Received: from hmm.wantstofly.org ([213.239.204.108]:57188 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbhBRM35 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 07:29:57 -0500
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id 6966B7F4C0; Thu, 18 Feb 2021 14:28:42 +0200 (EET)
Date:   Thu, 18 Feb 2021 14:28:42 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] IORING_OP_GETDENTS: add opcode, prep function,
 test, man page section
Message-ID: <20210218122842.GD334506@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Lennert Buytenhek <buytenh@wantstofly.org>
---
 man/io_uring_enter.2            |  26 +++++
 src/include/liburing.h          |   7 ++
 src/include/liburing/io_uring.h |   1 +
 test/Makefile                   |   1 +
 test/getdents.c                 | 180 ++++++++++++++++++++++++++++++++
 5 files changed, 215 insertions(+)
 create mode 100644 test/getdents.c

diff --git a/man/io_uring_enter.2 b/man/io_uring_enter.2
index 086207d..e0bd638 100644
--- a/man/io_uring_enter.2
+++ b/man/io_uring_enter.2
@@ -759,6 +759,32 @@ being passed in to
 .BR unlinkat(2).
 Available since 5.11.
 
+.TP
+.B IORING_OP_GETDENTS
+Issue the equivalent of an
+.BR lseek(2)
+system call plus a
+.BR getdents64(2)
+system call.
+.I fd
+should be set to the fd of the directory being operated on,
+.I off
+should be set to the offset in the directory to start reading from,
+.I addr
+should be set to the
+.I dirp,
+and
+.I len
+should be set to the
+.I count.
+
+.B IORING_OP_GETDENTS
+may or may not change the specified directory's file offset, and the
+file offset should not be relied upon having any particular value during
+or after an
+.B IORING_OP_GETDENTS
+operation.
+
 .PP
 The
 .I flags
diff --git a/src/include/liburing.h b/src/include/liburing.h
index 5b96e02..1769cda 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -535,6 +535,13 @@ static inline void io_uring_prep_sync_file_range(struct io_uring_sqe *sqe,
 	sqe->sync_range_flags = flags;
 }
 
+static inline void io_uring_prep_getdents(struct io_uring_sqe *sqe, int fd,
+					  void *buf, unsigned int count,
+					  uint64_t off)
+{
+	io_uring_prep_rw(IORING_OP_GETDENTS, sqe, fd, buf, count, off);
+}
+
 /*
  * Returns number of unconsumed (if SQPOLL) or unsubmitted entries exist in
  * the SQ ring
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index 1d47389..8abc0af 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -142,6 +142,7 @@ enum {
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
 	IORING_OP_MKDIRAT,
+	IORING_OP_GETDENTS,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/test/Makefile b/test/Makefile
index 7751eff..c76987a 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -55,6 +55,7 @@ test_targets += \
 	files-exit-hang-timeout \
 	fixed-link \
 	fsync \
+	getdents \
 	io-cancel \
 	io_uring_enter \
 	io_uring_register \
diff --git a/test/getdents.c b/test/getdents.c
new file mode 100644
index 0000000..3ca7b05
--- /dev/null
+++ b/test/getdents.c
@@ -0,0 +1,180 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: run various getdents tests
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+
+#include "liburing.h"
+
+/*
+ * This struct isn't exported via include/uapi/ , so we define it by hand.
+ */
+struct linux_dirent64 {
+	uint64_t	d_ino;
+	int64_t		d_off;
+	uint16_t	d_reclen;
+	uint8_t		d_type;
+	char		d_name[];
+};
+
+#define BUFSZ		65536
+
+static int dirfd;
+
+static int test_getdents(struct io_uring *ring, void *buf,
+			 unsigned int count, uint64_t off)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "get sqe failed\n");
+		goto err;
+	}
+	io_uring_prep_getdents(sqe, dirfd, buf, count, off);
+
+	ret = io_uring_submit(ring);
+	if (ret <= 0) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+		goto err;
+	}
+
+	ret = cqe->res;
+
+	io_uring_cqe_seen(ring, cqe);
+
+	return ret;
+
+err:
+	return -1;
+}
+
+static void dump_dents(const uint8_t *buf, int len)
+{
+	const uint8_t *end;
+
+	fprintf(stderr, "inode offset type path\n");
+
+	end = buf + len;
+	while (buf < end) {
+		struct linux_dirent64 *dent;
+
+		dent = (struct linux_dirent64 *)buf;
+
+		fprintf(stderr, "%" PRId64 " %" PRId64 " %d %s\n", dent->d_ino,
+			dent->d_off, dent->d_type, dent->d_name);
+
+		buf += dent->d_reclen;
+	}
+
+	fprintf(stderr, "\n");
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int ret;
+	uint8_t buf[BUFSZ];
+	bool found_dot;
+	bool found_dotdot;
+	uint8_t *bufp;
+	uint8_t *end;
+
+	if (argc > 1)
+		return 0;
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	dirfd = open(".", O_DIRECTORY);
+	if (dirfd < 0) {
+		fprintf(stderr, "opening \".\" failed: %s\n", strerror(errno));
+		return 1;
+	}
+
+	memset(buf, 0, sizeof(buf));
+
+	ret = test_getdents(&ring, buf, sizeof(buf), 0);
+	if (ret < 0) {
+		if (ret == -EINVAL) {
+			fprintf(stdout, "getdents not supported, skipping\n");
+			return 0;
+		}
+		fprintf(stderr, "getdents: %s\n", strerror(-ret));
+		return 1;
+	}
+
+	found_dot = false;
+	found_dotdot = false;
+
+	bufp = buf;
+	end = bufp + ret;
+
+	while (bufp < end) {
+		struct linux_dirent64 *dent;
+		uint8_t buf2[BUFSZ];
+
+		dent = (struct linux_dirent64 *)bufp;
+
+		if (!found_dot && !strcmp(dent->d_name, "."))
+			found_dot = true;
+		else if (!found_dotdot && !strcmp(dent->d_name, ".."))
+			found_dotdot = true;
+
+		bufp += dent->d_reclen;
+
+		/*
+		 * Now try to read the directory starting from the given
+		 * offset, and make sure we end up with the same data.
+		 */
+		memset(buf2, 0, sizeof(buf2));
+
+		ret = test_getdents(&ring, buf2, sizeof(buf2), dent->d_off);
+		if (ret < 0) {
+			fprintf(stderr, "getdents: %s\n", strerror(-ret));
+			return 1;
+		}
+
+		if (ret != end - bufp || memcmp(bufp, buf2, ret)) {
+			fprintf(stderr, "getdents: read from offset "
+					"%" PRId64 " returned unexpected "
+					"data\n\n", (uint64_t)dent->d_off);
+
+			fprintf(stderr, "read from offset zero:\n");
+			dump_dents(bufp, end - bufp);
+
+			fprintf(stderr, "offsetted read:\n");
+			dump_dents(buf2, ret);
+
+			return 1;
+		}
+	}
+
+	if (!found_dot)
+		fprintf(stderr, "getdents didn't return \".\" entry\n");
+
+	if (!found_dotdot)
+		fprintf(stderr, "getdents didn't return \"..\" entry\n");
+
+	if (!found_dot || !found_dotdot)
+		return 1;
+
+	return 0;
+}
-- 
2.29.2
