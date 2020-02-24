Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF9CB16AE31
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 18:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgBXRz6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 12:55:58 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:44966 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727730AbgBXRz6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 12:55:58 -0500
Received: by mail-wr1-f66.google.com with SMTP id m16so11444489wrx.11
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 09:55:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+59YpGyv9ZC1ZdoiceiERy3YjJtuL2VvcOWJQzMIjC4=;
        b=hFyL9LdsEk9wdnx7+WJ3kb582PL+1OFzkx3pm2IX84QqDjflBHpegL6IIQfYE+HwSO
         A4b43UUmqTZN00lOw6f9/tiw7o+0GmgHcKg0Ixmo97nsq13zudWT2D8RTZQOQ2Ce6Rrj
         xyUg3bY4AnACQvuChYUVYKT/P7oivrvxQaj/DRsDz111Qwny6i2XtWnQG6MBQn7O4qRg
         7Ngsgm2pffjy8jOZsffthIeku2LWHcuipphpFULcDFkqHqrCKoL/PiFrErFARjHDpjhs
         f9FcfWd3PUDsg3cwsTCXRjXZouSzLWZuq6PmWXukhKfy+e6QrwKrnj8DXSU27xnnpQvC
         13Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+59YpGyv9ZC1ZdoiceiERy3YjJtuL2VvcOWJQzMIjC4=;
        b=rtLZfM2/f1cjQNyWEUY3E8bl6Omz93FwsqIvcVwDtaDu+jFap1JtxPsXUA3RwxxvvL
         nRKQ/zWQzRBzNMDfmFlTlZvoaiy/E/XzBPMaRko0l5jkoIfNAZzviQdG5iJIF63t3frK
         emS59ewB7S3nJ/DiMXj18/1YPoB/cjztxzgFXt9XrFIhM8I9N5izTBDWWyTHrKQfPKyb
         oYjkT4+zL1aTMPJWjivYtQX5+xQLIAu1EnX3Sdx9QcjOYdcXgZiWJg4UxzOWAlVLmhMv
         w+RJwtWvfd4YIVQ3+YGI7XZGIBG0On11/J0OH1cV+5JCMmJHTUXGFXTXecZigJGYabaY
         A7Yg==
X-Gm-Message-State: APjAAAWsZIhebTaSXDv7PS9UdnCmaiV+Jquo6nFz8Am/HqNPqRG7e5A1
        AHkhqAet/jmQMsmr3mtQ9Nw=
X-Google-Smtp-Source: APXvYqyXjtgd0VOqPffvtIm9U/DA+xE29lX7IRTXTFNjkNzWiG7Ejkc465D91PHesZQ2HMK8k++ouQ==
X-Received: by 2002:adf:e50f:: with SMTP id j15mr68533852wrm.356.1582566956085;
        Mon, 24 Feb 2020 09:55:56 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id 61sm4001687wrf.65.2020.02.24.09.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 09:55:55 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing v5 2/2] test/splice: add basic splice tests
Date:   Mon, 24 Feb 2020 20:55:01 +0300
Message-Id: <aa79d4a192bd1a8e68beddfb177618c1cdacf381.1582566728.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582566728.git.asml.silence@gmail.com>
References: <cover.1582566728.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile |   5 +-
 test/splice.c | 148 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 151 insertions(+), 2 deletions(-)
 create mode 100644 test/splice.c

diff --git a/test/Makefile b/test/Makefile
index 09c7aa2..8437f31 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -20,7 +20,7 @@ all_targets += poll poll-cancel ring-leak fsync io_uring_setup io_uring_register
 		connect 7ad0e4b2f83c-test submit-reuse fallocate open-close \
 		file-update statx accept-reuse poll-v-poll fadvise madvise \
 		short-read openat2 probe shared-wq personality eventfd \
-		send_recv eventfd-ring across-fork sq-poll-kthread
+		send_recv eventfd-ring across-fork sq-poll-kthread splice
 
 include ../Makefile.quiet
 
@@ -47,7 +47,8 @@ test_srcs := poll.c poll-cancel.c ring-leak.c fsync.c io_uring_setup.c \
 	7ad0e4b2f83c-test.c submit-reuse.c fallocate.c open-close.c \
 	file-update.c statx.c accept-reuse.c poll-v-poll.c fadvise.c \
 	madvise.c short-read.c openat2.c probe.c shared-wq.c \
-	personality.c eventfd.c eventfd-ring.c across-fork.c sq-poll-kthread.c
+	personality.c eventfd.c eventfd-ring.c across-fork.c sq-poll-kthread.c \
+	splice.c
 
 test_objs := $(patsubst %.c,%.ol,$(test_srcs))
 
diff --git a/test/splice.c b/test/splice.c
new file mode 100644
index 0000000..1eaa788
--- /dev/null
+++ b/test/splice.c
@@ -0,0 +1,148 @@
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/mman.h>
+
+#include "liburing.h"
+
+static int no_splice = 0;
+
+static int copy_single(struct io_uring *ring,
+			int fd_in, loff_t off_in,
+			int fd_out, loff_t off_out,
+			int pipe_fds[2],
+			unsigned int len,
+			unsigned flags1, unsigned flags2)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int i, ret = -1;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "get sqe failed\n");
+		return -1;
+	}
+	io_uring_prep_splice(sqe, fd_in, off_in, pipe_fds[1], -1,
+			     len, flags1);
+	sqe->flags = IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "get sqe failed\n");
+		return -1;
+	}
+	io_uring_prep_splice(sqe, pipe_fds[0], -1, fd_out, off_out,
+			     len, flags2);
+
+	ret = io_uring_submit(ring);
+	if (ret <= 1) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		return -1;
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "wait completion %d\n", cqe->res);
+			return ret;
+		}
+
+		ret = cqe->res;
+		if (ret != len) {
+			fprintf(stderr, "splice: returned %i, expected %i\n",
+				cqe->res, len);
+			return ret < 0 ? ret : -1;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+	return 0;
+}
+
+static int test_splice(struct io_uring *ring)
+{
+	int ret = -1, len = 4 * 4096;
+	int fd_out = -1, fd_in = -1;
+	int pipe_fds[2] = {-1, -1};
+
+	if (pipe(pipe_fds) < 0)
+		goto exit;
+	fd_in = open("/dev/urandom", O_RDONLY);
+	if (fd_in < 0)
+		goto exit;
+	fd_out = memfd_create("splice_test_out_file", 0);
+	if (fd_out < 0)
+		goto exit;
+	if (ftruncate(fd_out, len) == -1)
+		goto exit;
+
+	ret = copy_single(ring, fd_in, -1, fd_out, -1, pipe_fds,
+			  len, SPLICE_F_MOVE | SPLICE_F_MORE, 0);
+	if (ret == -EINVAL) {
+		no_splice = 1;
+		goto exit;
+	}
+	if (ret) {
+		fprintf(stderr, "basic splice-copy failed\n");
+		goto exit;
+	}
+
+	ret = copy_single(ring, fd_in, 0, fd_out, 0, pipe_fds,
+			  len, 0, SPLICE_F_MOVE | SPLICE_F_MORE);
+	if (ret) {
+		fprintf(stderr, "basic splice with offset failed\n");
+		goto exit;
+	}
+
+	ret = io_uring_register_files(ring, &fd_in, 1);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto exit;
+	}
+
+	ret = copy_single(ring, 0, 0, fd_out, 0, pipe_fds,
+			  len, SPLICE_F_FD_IN_FIXED, 0);
+	if (ret) {
+		fprintf(stderr, "basic splice with reg files failed\n");
+		goto exit;
+	}
+
+	ret = 0;
+exit:
+	if (fd_out >= 0)
+		close(fd_out);
+	if (fd_in >= 0)
+		close(fd_in);
+	if (pipe_fds[0] >= 0) {
+		close(pipe_fds[0]);
+		close(pipe_fds[1]);
+	}
+	return ret;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int ret;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		return 1;
+	}
+
+	ret = test_splice(&ring);
+	if (ret && no_splice) {
+		fprintf(stderr, "skip, doesn't support splice()\n");
+		return 0;
+	}
+	if (ret) {
+		fprintf(stderr, "test_splice failed %i %i\n", ret, errno);
+		return ret;
+	}
+
+	return 0;
+}
-- 
2.24.0

