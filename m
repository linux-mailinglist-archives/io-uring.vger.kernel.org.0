Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A17F321FFD5
	for <lists+io-uring@lfdr.de>; Tue, 14 Jul 2020 23:17:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGNVQK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jul 2020 17:16:10 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:45505 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728275AbgGNVQJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jul 2020 17:16:09 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id 9C5B71C0003;
        Tue, 14 Jul 2020 21:16:06 +0000 (UTC)
Date:   Tue, 14 Jul 2020 14:16:03 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org
Subject: [WIP PATCH] liburing: Support IORING_OP_OPENAT2_FIXED_FILE
Message-ID: <005a29a0450038dc79e92aa6fb73ed94a579bc8f.1594761075.git.josh@joshtriplett.org>
References: <5e04f8fc6b0a2e218ace517bc9acf0d44530c430.1594759879.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bp/iNruPH9dso1Pn"
Content-Disposition: inline
In-Reply-To: <5e04f8fc6b0a2e218ace517bc9acf0d44530c430.1594759879.git.josh@joshtriplett.org>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--bp/iNruPH9dso1Pn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Update io_uring.h to match the corresponding kernel changes.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---

I've tested this, and it works. The test I'd propose is "open two files,
read bytes from both files, test if they have the expected values", to
make sure each operation operates on the right file. I've attached a
draft of that test that submits the read operations in a separate batch,
which passes.

 src/include/liburing.h          | 10 ++++++++++
 src/include/liburing/io_uring.h |  6 +++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 0505a4f..0352837 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -412,6 +412,16 @@ static inline void io_uring_prep_openat2(struct io_uring_sqe *sqe, int dfd,
 				(uint64_t) (uintptr_t) how);
 }
 
+static inline void io_uring_prep_openat2_fixed_file(struct io_uring_sqe *sqe,
+                                                    int dfd, const char *path,
+                                                    struct open_how *how,
+                                                    uint32_t index)
+{
+        io_uring_prep_rw(IORING_OP_OPENAT2_FIXED_FILE, sqe, dfd, path,
+                                sizeof(*how), (uint64_t) (uintptr_t) how);
+        sqe->open_fixed_idx = index;
+}
+
 struct epoll_event;
 static inline void io_uring_prep_epoll_ctl(struct io_uring_sqe *sqe, int epfd,
 					   int fd, int op,
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index d39b45f..0d2c41b 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -59,7 +59,10 @@ struct io_uring_sqe {
 			} __attribute__((packed));
 			/* personality to use, if used */
 			__u16	personality;
-			__s32	splice_fd_in;
+			union {
+				__s32	splice_fd_in;
+				__s32	open_fixed_idx;
+			};
 		};
 		__u64	__pad2[3];
 	};
@@ -135,6 +138,7 @@ enum {
 	IORING_OP_PROVIDE_BUFFERS,
 	IORING_OP_REMOVE_BUFFERS,
 	IORING_OP_TEE,
+	IORING_OP_OPENAT2_FIXED_FILE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.28.0.rc0


--bp/iNruPH9dso1Pn
Content-Type: text/x-csrc; charset=us-ascii
Content-Disposition: attachment; filename="open-fixed-file.c"

/* SPDX-License-Identifier: MIT */
/*
 * Description: test open with fixed-file support
 *
 */
#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>

#include "liburing.h"

static int create_file(const char *file, size_t size, int byte)
{
	ssize_t ret;
	char *buf;
	int fd;

	buf = malloc(size);
	memset(buf, byte, size);

	fd = open(file, O_WRONLY | O_CREAT, 0644);
	if (fd < 0) {
		perror("open file");
		return 1;
	}
	ret = write(fd, buf, size);
	close(fd);
	return ret != size;
}

static int test_openat2_fixed_file(struct io_uring *ring, const char *path1, const char *path2)
{
	struct io_uring_cqe *cqe;
	struct io_uring_sqe *sqe;
	struct open_how how = { .flags = O_RDONLY };
	int ret;
	int fds[2] = { -1, -1 };
	unsigned char byte1 = 0, byte2 = 0;
	int i;

	ret = io_uring_register_files(ring, fds, 2);

	sqe = io_uring_get_sqe(ring);
	io_uring_prep_openat2_fixed_file(sqe, -1, path1, &how, 0);
	sqe->flags |= IOSQE_IO_LINK;

	sqe = io_uring_get_sqe(ring);
	io_uring_prep_openat2_fixed_file(sqe, -1, path2, &how, 1);
	sqe->flags |= IOSQE_IO_LINK;

	ret = io_uring_submit(ring);
	if (ret != 2) {
		fprintf(stderr, "sqe submit failed: %d\n", ret);
		goto err;
	}

	for (i = 0; i < 2; i++) {
		ret = io_uring_wait_cqe(ring, &cqe);
		if (ret < 0) {
			fprintf(stderr, "wait completion %d\n", ret);
			goto err;
		}

		ret = cqe->res;
		if (ret < 0) {
			fprintf(stderr, "operation %d failed: %d\n", i, ret);
			goto err;
		}
		io_uring_cqe_seen(ring, cqe);
	}

	sqe = io_uring_get_sqe(ring);
	io_uring_prep_read(sqe, 0, &byte1, 1, 0);
	sqe->flags |= IOSQE_FIXED_FILE;

	sqe = io_uring_get_sqe(ring);
	io_uring_prep_read(sqe, 1, &byte2, 1, 0);
	sqe->flags |= IOSQE_FIXED_FILE;

	ret = io_uring_submit(ring);
	if (ret != 2) {
		fprintf(stderr, "sqe submit failed: %d\n", ret);
		goto err;
	}

	for (i = 0; i < 2; i++) {
		ret = io_uring_wait_cqe(ring, &cqe);
		if (ret < 0) {
			fprintf(stderr, "wait completion %d\n", ret);
			goto err;
		}

		ret = cqe->res;
		if (ret < 0) {
			fprintf(stderr, "operation %d failed: %d\n", i, ret);
			goto err;
		}
		io_uring_cqe_seen(ring, cqe);
	}

	if (byte1 != 0x11 || byte2 != 0x22) {
		fprintf(stderr, "bytes did not have expected values: %x %x\n",
			(unsigned)byte1, (unsigned)byte2);
		ret = -1;
		goto err;
	}

err:
	return ret;
}

int main(int argc, char *argv[])
{
	struct io_uring ring;
	const char *path1, *path2;
	int ret;

	ret = io_uring_queue_init(8, &ring, 0);
	if (ret) {
		fprintf(stderr, "ring setup failed\n");
		return 1;
	}

	path1 = "/tmp/.open.close.1";
	path2 = "/tmp/.open.close.2";

	if (create_file(path1, 4096, 0x11) || create_file(path2, 4096, 0x22)) {
		fprintf(stderr, "file create failed\n");
		return 1;
	}

	ret = test_openat2_fixed_file(&ring, path1, path2);
	if (ret < 0) {
		if (ret == -EINVAL) {
			fprintf(stdout, "openat2 not supported, skipping\n");
			goto done;
		}
		fprintf(stderr, "test_openat2 failed: %d\n", ret);
		goto err;
	}

done:
	unlink(path1);
	unlink(path2);
	return 0;
err:
	unlink(path1);
	unlink(path2);
	return 1;
}


--bp/iNruPH9dso1Pn--
