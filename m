Return-Path: <io-uring+bounces-3638-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A69599BBC9
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 22:45:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C46C4281789
	for <lists+io-uring@lfdr.de>; Sun, 13 Oct 2024 20:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0A9E13D52C;
	Sun, 13 Oct 2024 20:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cd7VSf9/"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BFBF14EC4B
	for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 20:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728852326; cv=none; b=X8NK6ZYQHSBVpfs+ZAMnADMmEGIBd+/ybXo1XgRx+XUls9yn3+/KDYUxTR2zW+eCdasP00JlT0nPQXPqxAUNy8ixn3gBjImnuwwShp0TK6rk4cqBe2Lkj+/dU/eVvz0kyBuq2xTn7ZyI3HCp2H989QuA2ynVmGtybnnLkQUnW10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728852326; c=relaxed/simple;
	bh=imLekR43HMRhU5H4My08P33i9mOb71GJ5hzxhwXulw8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLiMZio9mOw+L6z+KB/FoyDSQCn8IDilJr0/A+fujcDfoG3Tq1/zGtKmY1P6ZABuS0VJ/aSahGudo5qvul3NpnasMq7lqCqsyViYLJtCXg3YQsvM35//AbsvijtUzsvAB3SsjoURwDHeaVa6HHojv80nNRjPkttDJ9ezmlKkS3c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Cd7VSf9/; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-37d58377339so2410715f8f.1
        for <io-uring@vger.kernel.org>; Sun, 13 Oct 2024 13:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1728852323; x=1729457123; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QRTyUDVCzMrA5F/WLPTK2W5lykgzHuT4WRXwN8fNmqs=;
        b=Cd7VSf9/LSESExGuLQz5353IXTFBWZ1rNy5/TpFdf22E6g9gtssfBXcD8CNksPknrI
         k/f2byOVOprRB2Dmyb3356357s/oWgtl7CxHW3ZLp3P2+BLzTiCmPONzWI6DjRFi2/yh
         1vyJXalvt4MDBVscAqN5jPgSDcBNqOFuwKq7h76Hy5v0FAe6lnqcw75c6BibRD/GJlPp
         JkWG2GQrLC5Tsa3Oh90rcNAMW9Hgg3C/I8x+NeZmsLupvQxRq/YKJrbH/ztxSMUqxIco
         O0RJlFH4ubzZS6ZFci/9L5SU7RXvI8NrIfHcK0pa2ustyacc19oyxdJPiwQgHFBEpjBE
         H2tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728852323; x=1729457123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QRTyUDVCzMrA5F/WLPTK2W5lykgzHuT4WRXwN8fNmqs=;
        b=klHU+aGGerkET7SZEXblB/G97B9+Q0J9sFLPabSMvOhOjoRiFx9S+vaeJVxXIT7+L6
         0xnQaUsU26Ji/vg3x2C6MZ3PD7uN0C2mTNfvY2jGPI4gtv2PTUQ3fu/j6sIQqnrsrJOe
         ycoaAHaFIehOmAjJoHptbxpJwuLMRD3jQ7G8HzjuiQeLoeJgIwGQoLEOU5dUxvHR1yJF
         nb/asHC8xqo4LT/tKLy0SJifwmCd5hDacXJ0ZOEE/0HffDBDOTV4hr9lU/NJSGzHjxMU
         +4poy+52EbkENvW73lODhgh/NqxveDsaHZsD0q0h7qpl6uA55u8RGZVzHydbELEydBpS
         qnCw==
X-Gm-Message-State: AOJu0Yzr27OC3j4jVglIIltqxVfPeQXuh9yd4sYWBAO2L63ncxOAD4rW
	OgqeDRuFOtVFwORNDLds7McwHcuztduufSYlEkXYur7U/PjrU6DmNLKfPg==
X-Google-Smtp-Source: AGHT+IE/98d03MKnCLQv0FZlsNw3rdMc9IPPkcU1SK5U3SjcvTgWOPzMjh7oCoq1KbUd+gDuUgT1Tg==
X-Received: by 2002:a5d:64ec:0:b0:37d:37c6:7af0 with SMTP id ffacd0b85a97d-37d5ff2678fmr7079531f8f.6.1728852322396;
        Sun, 13 Oct 2024 13:45:22 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.233.136])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a99f86b689dsm186078166b.181.2024.10.13.13.45.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Oct 2024 13:45:21 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com
Subject: [PATCH liburing 2/3] test: add discard cmd tests
Date: Sun, 13 Oct 2024 21:45:45 +0100
Message-ID: <ecdc137d5afc1b8ad8f287d12ea3d60a6dc223e2.1728851862.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <cover.1728851862.git.asml.silence@gmail.com>
References: <cover.1728851862.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile      |   1 +
 test/cmd-discard.c | 402 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 403 insertions(+)
 create mode 100644 test/cmd-discard.c

diff --git a/test/Makefile b/test/Makefile
index de5f98d..b22c3f1 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -65,6 +65,7 @@ test_srcs := \
 	connect.c \
 	connect-rep.c \
 	coredump.c \
+	cmd-discard.c \
 	cq-full.c \
 	cq-overflow.c \
 	cq-peek-batch.c \
diff --git a/test/cmd-discard.c b/test/cmd-discard.c
new file mode 100644
index 0000000..4d7f91e
--- /dev/null
+++ b/test/cmd-discard.c
@@ -0,0 +1,402 @@
+/* SPDX-License-Identifier: MIT */
+
+#include <stdio.h>
+#include <assert.h>
+#include <string.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <sys/ioctl.h>
+#include <linux/fs.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+#define MAX_TEST_LBAS		1024
+
+static const char *filename;
+static int opcodes[] = {
+	BLOCK_URING_CMD_DISCARD,
+};
+
+static int lba_size;
+static uint64_t bdev_size;
+static uint64_t bdev_size_lbas;
+static char *buffer;
+
+#define TEST_BLOCK_URING_CMD_MAX		3
+
+static void prep_blk_cmd(struct io_uring_sqe *sqe, int fd,
+			 uint64_t from, uint64_t len,
+			 int cmd_op)
+{
+	assert(cmd_op == BLOCK_URING_CMD_DISCARD);
+
+	io_uring_prep_cmd_discard(sqe, fd, from, len);
+}
+
+static int queue_cmd_range(struct io_uring *ring, int bdev_fd,
+			   uint64_t from, uint64_t len, int cmd_op)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int err;
+
+	sqe = io_uring_get_sqe(ring);
+	assert(sqe != NULL);
+	prep_blk_cmd(sqe, bdev_fd, from, len, cmd_op);
+
+	err = io_uring_submit_and_wait(ring, 1);
+	if (err != 1) {
+		fprintf(stderr, "io_uring_submit_and_wait failed %d\n", err);
+		exit(1);
+	}
+
+	err = io_uring_wait_cqe(ring, &cqe);
+	if (err) {
+		fprintf(stderr, "io_uring_wait_cqe failed %d (op %i)\n",
+				err, cmd_op);
+		exit(1);
+	}
+
+	err = cqe->res;
+	io_uring_cqe_seen(ring, cqe);
+	return err;
+}
+
+static int queue_cmd_lba(struct io_uring *ring, int bdev_fd,
+			 uint64_t from, uint64_t nr_lba, int cmd_op)
+{
+	return queue_cmd_range(ring, bdev_fd, from * lba_size,
+				nr_lba * lba_size, cmd_op);
+}
+
+static int queue_discard_lba(struct io_uring *ring, int bdev_fd,
+			     uint64_t from, uint64_t nr_lba)
+{
+	return queue_cmd_lba(ring, bdev_fd, from, nr_lba,
+				BLOCK_URING_CMD_DISCARD);
+}
+
+static int test_parallel(struct io_uring *ring, int fd, int cmd_op)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int inflight = 0;
+	int max_inflight = 16;
+	int left = 1000;
+	int ret;
+
+	while (left || inflight) {
+		int queued = 0;
+		unsigned head, nr_cqes = 0;
+		int lba_len = 8;
+
+		while (inflight < max_inflight && left) {
+			int off = rand() % (MAX_TEST_LBAS - lba_len);
+			sqe = io_uring_get_sqe(ring);
+			assert(sqe != NULL);
+
+			prep_blk_cmd(sqe, fd, off * lba_size,
+				     lba_len * lba_size, cmd_op);
+			if (rand() & 1)
+				sqe->flags |= IOSQE_ASYNC;
+
+			queued++;
+			left--;
+			inflight++;
+		}
+		if (queued) {
+			ret = io_uring_submit(ring);
+			if (ret != queued) {
+				fprintf(stderr, "io_uring_submit failed %d\n", ret);
+				return T_EXIT_FAIL;
+			}
+		}
+
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "io_uring_wait_cqe failed %d\n", ret);
+			exit(1);
+		}
+
+		io_uring_for_each_cqe(ring, head, cqe) {
+			nr_cqes++;
+			inflight--;
+			if (cqe->res != 0) {
+				fprintf(stderr, "cmd %i failed %i\n", cmd_op,
+						cqe->res);
+				return T_EXIT_FAIL;
+			}
+		}
+		io_uring_cq_advance(ring, nr_cqes);
+	}
+
+	return 0;
+}
+
+static int cmd_issue_verify(struct io_uring *ring, int fd, int lba, int len,
+			    int cmd_op)
+{
+	int verify = (cmd_op != BLOCK_URING_CMD_DISCARD);
+	int ret, i;
+	ssize_t res;
+
+	if (verify) {
+		for (i = 0; i < len; i++) {
+			size_t off = (i + lba) * lba_size;
+
+			res = pwrite(fd, buffer, lba_size, off);
+			if (res == -1) {
+				fprintf(stderr, "pwrite failed\n");
+				return T_EXIT_FAIL;
+			}
+		}
+	}
+
+	ret = queue_cmd_lba(ring, fd, lba, len, cmd_op);
+	if (ret) {
+		if (ret == -EINVAL || ret == -EOPNOTSUPP)
+			return T_EXIT_SKIP;
+
+		fprintf(stderr, "cmd_issue_verify %i fail lba %i len %i  ret %i\n",
+				cmd_op, lba, len, ret);
+		return T_EXIT_FAIL;
+	}
+
+	if (verify) {
+		for (i = 0; i < len; i++) {
+			size_t off = (i + lba) * lba_size;
+
+			res = pread(fd, buffer, lba_size, off);
+			if (res == -1) {
+				fprintf(stderr, "pread failed\n");
+				return T_EXIT_FAIL;
+			}
+			if (!memchr(buffer, 0, lba_size)) {
+				fprintf(stderr, "mem cmp failed, lba %i\n", lba + i);
+				return T_EXIT_FAIL;
+			}
+		}
+	}
+	return 0;
+}
+
+static int basic_cmd_test(struct io_uring *ring, int cmd_op)
+{
+	int ret, fd;
+
+	fd = open(filename, O_DIRECT | O_RDWR | O_EXCL);
+	if (fd < 0) {
+		fprintf(stderr, "open failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+
+	ret = cmd_issue_verify(ring, fd, 0, 1, cmd_op);
+	if (ret == T_EXIT_SKIP) {
+		printf("cmd %i not supported, skip\n", cmd_op);
+		close(fd);
+		return T_EXIT_SKIP;
+	} else if (ret) {
+		fprintf(stderr, "cmd %i fail 0 1\n", cmd_op);
+		return T_EXIT_FAIL;
+	}
+
+	ret = cmd_issue_verify(ring, fd, 7, 15, cmd_op);
+	if (ret) {
+		fprintf(stderr, "cmd %i fail 7 15 %i\n", cmd_op, ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = cmd_issue_verify(ring, fd, 1, MAX_TEST_LBAS - 1, cmd_op);
+	if (ret) {
+		fprintf(stderr, "large cmd %i failed %i\n", cmd_op, ret);
+		return T_EXIT_FAIL;
+	}
+
+	ret = test_parallel(ring, fd, cmd_op);
+	if (ret) {
+		fprintf(stderr, "test_parallel() %i failed %i\n", cmd_op, ret);
+		return T_EXIT_FAIL;
+	}
+
+	close(fd);
+	return 0;
+}
+
+static int test_fail_edge_cases(struct io_uring *ring, int cmd_op)
+{
+	int ret, fd;
+
+	fd = open(filename, O_DIRECT | O_RDWR | O_EXCL);
+	if (fd < 0) {
+		fprintf(stderr, "open failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+
+	ret = queue_cmd_lba(ring, fd, bdev_size_lbas, 1, cmd_op);
+	if (ret >= 0) {
+		fprintf(stderr, "cmd %i beyond capacity %i\n",
+				cmd_op, ret);
+		return 1;
+	}
+
+	ret = queue_cmd_lba(ring, fd, bdev_size_lbas - 1, 2, cmd_op);
+	if (ret >= 0) {
+		fprintf(stderr, "cmd %i beyond capacity with overlap %i\n",
+				cmd_op, ret);
+		return 1;
+	}
+
+	ret = queue_cmd_range(ring, fd, (uint64_t)-lba_size, lba_size + 2,
+			      cmd_op);
+	if (ret >= 0) {
+		fprintf(stderr, "cmd %i range overflow %i\n",
+				cmd_op, ret);
+		return 1;
+	}
+
+	ret = queue_cmd_range(ring, fd, lba_size / 2, lba_size, cmd_op);
+	if (ret >= 0) {
+		fprintf(stderr, "cmd %i unaligned offset %i\n",
+				cmd_op, ret);
+		return 1;
+	}
+
+	ret = queue_cmd_range(ring, fd, 0, lba_size / 2, cmd_op);
+	if (ret >= 0) {
+		fprintf(stderr, "cmd %i unaligned size %i\n",
+				cmd_op, ret);
+		return 1;
+	}
+
+	close(fd);
+	return 0;
+}
+
+static int test_rdonly(struct io_uring *ring, int cmd_op)
+{
+	int ret, fd;
+	int ro;
+
+	fd = open(filename, O_DIRECT | O_RDONLY | O_EXCL);
+	if (fd < 0) {
+		fprintf(stderr, "open failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+
+	ret = queue_discard_lba(ring, fd, 0, 1);
+	if (ret >= 0) {
+		fprintf(stderr, "discarded with O_RDONLY %i\n", ret);
+		return 1;
+	}
+	close(fd);
+
+	fd = open(filename, O_DIRECT | O_RDWR | O_EXCL);
+	if (fd < 0) {
+		fprintf(stderr, "open failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+
+	ro = 1;
+	ret = ioctl(fd, BLKROSET, &ro);
+	if (ret) {
+		fprintf(stderr, "BLKROSET 1 failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+
+	ret = queue_discard_lba(ring, fd, 0, 1);
+	if (ret >= 0) {
+		fprintf(stderr, "discarded with O_RDONLY %i\n", ret);
+		return 1;
+	}
+
+	ro = 0;
+	ret = ioctl(fd, BLKROSET, &ro);
+	if (ret) {
+		fprintf(stderr, "BLKROSET 0 failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+	close(fd);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int fd, ret, i;
+	int cmd_op;
+
+	if (argc != 2)
+		return T_SETUP_SKIP;
+	filename = argv[1];
+
+	fd = open(filename, O_DIRECT | O_RDONLY | O_EXCL);
+	if (fd < 0) {
+		fprintf(stderr, "open failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+
+	ret = ioctl(fd, BLKGETSIZE64, &bdev_size);
+	if (ret < 0) {
+		fprintf(stderr, "BLKGETSIZE64 failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+	ret = ioctl(fd, BLKSSZGET, &lba_size);
+	if (ret < 0) {
+		fprintf(stderr, "BLKSSZGET failed %i\n", errno);
+		return T_EXIT_FAIL;
+	}
+	assert(bdev_size % lba_size == 0);
+	bdev_size_lbas = bdev_size / lba_size;
+	close(fd);
+
+	buffer = aligned_alloc(lba_size, lba_size);
+	if (!buffer) {
+		fprintf(stderr, "aligned_alloc failed\n");
+		return T_EXIT_FAIL;
+	}
+	for (i = 0; i < lba_size; i++)
+		buffer[i] = i ^ 0xA7;
+
+	if (bdev_size_lbas < MAX_TEST_LBAS) {
+		fprintf(stderr, "the device is too small, skip\n");
+		return T_EXIT_SKIP;
+	}
+
+	ret = io_uring_queue_init(16, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "queue init failed: %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+
+	for (cmd_op = 0; cmd_op < TEST_BLOCK_URING_CMD_MAX; cmd_op++) {
+		ret = basic_cmd_test(&ring, opcodes[cmd_op]);
+		if (ret) {
+			if (ret == T_EXIT_SKIP)
+				continue;
+
+			fprintf(stderr, "basic_cmd_test() failed, cmd %i\n",
+					cmd_op);
+			return T_EXIT_FAIL;
+		}
+
+		ret = test_rdonly(&ring, opcodes[cmd_op]);
+		if (ret) {
+			fprintf(stderr, "test_rdonly() failed, cmd %i\n",
+					cmd_op);
+			return T_EXIT_FAIL;
+		}
+
+		ret = test_fail_edge_cases(&ring, opcodes[cmd_op]);
+		if (ret) {
+			fprintf(stderr, "test_fail_edge_cases() failed, cmd %i\n",
+					cmd_op);
+			return T_EXIT_FAIL;
+		}
+	}
+
+	io_uring_queue_exit(&ring);
+	free(buffer);
+	return 0;
+}
-- 
2.46.0


