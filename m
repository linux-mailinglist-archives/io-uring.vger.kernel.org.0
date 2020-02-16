Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83C0C1603CA
	for <lists+io-uring@lfdr.de>; Sun, 16 Feb 2020 12:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728026AbgBPLPk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 Feb 2020 06:15:40 -0500
Received: from mail-wr1-f42.google.com ([209.85.221.42]:43659 "EHLO
        mail-wr1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728009AbgBPLPj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 Feb 2020 06:15:39 -0500
Received: by mail-wr1-f42.google.com with SMTP id r11so16151814wrq.10
        for <io-uring@vger.kernel.org>; Sun, 16 Feb 2020 03:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1gTtXv0Ou7Ozif9CG3wW02P8umAhUNyzslpCaL1DANM=;
        b=Le1Vf3A6lrX2METdF3KyhhxpxY6+PUwGSUsd5KjHiOzFHNK0msbe3u3VstcdPzTYhk
         vtA2/cGfWffhlNBQOeDT8EIxViSgbwxXlBejhkL76etFrox4sFinS/scKqpiS2vvdhto
         om/bHf22XUCO3sjvDQqaF6YfS5OBKegK4LrGtqnB2WmjI3jf1gZN2uCrHqBxuWSjB0lZ
         WbcT6QBfMhk2ugtSwULV07KDnUkNgG8q5qDn8l34+NQ/KInjQsbXJT78CL38U6sYycH1
         yaTfgRJuzRnCbpQqJj6wKtquTKSPvcKMI1cg3dpDDBOokCrSRDoNCJt8/HsMf96JXF3b
         5fjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1gTtXv0Ou7Ozif9CG3wW02P8umAhUNyzslpCaL1DANM=;
        b=mHsH4GytfjW+U80UJnrUjrY5manEQMVMtJvygyyhPM2Qgyy96A1I0dLEzcY9NQb/Sd
         O76b9twATYaJy4VTp+bZeYvi5IxrylkP8KhH7gm0qB/my2M9BKf1OuRBQVT+VoHIAhnq
         AsRWO649xZF06M0lAgUfSDbP/olBPg5osUkivnHPhfPWziQTb93e0sKAFZjEBRwzgjne
         p+8dY8WdxLQ4Gv+33kSrsY5QcBcBsUR4aR1B0bFauRHxUr6nDj5EAR+U4wNjq6ydxZBE
         fsUuhlDohJgb04z33OJ/y4Ebu17j9YR3GBtufLaTCf69+ltrxAj2UiDq8nVgfD25OCjQ
         YJ2Q==
X-Gm-Message-State: APjAAAWQ6lFbmor2S/qUK4Jn7Uvd15xJAUAAdiZlhL282aYZB+tRNphx
        2yel6deaQlwCQpHed7Ejsqt86CSw
X-Google-Smtp-Source: APXvYqx41jRtoPLn3zy43aOnwmwTDJ+3eKhnIk5q7smojjAYz8wQVsymAtrqxYiWW4wzuQ3ku2Xw6A==
X-Received: by 2002:adf:cd11:: with SMTP id w17mr16271692wrm.66.1581851737562;
        Sun, 16 Feb 2020 03:15:37 -0800 (PST)
Received: from localhost.localdomain ([109.126.140.114])
        by smtp.gmail.com with ESMTPSA id 25sm16232033wmi.32.2020.02.16.03.15.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Feb 2020 03:15:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 2/2] test/splice: add basic splice tests
Date:   Sun, 16 Feb 2020 14:14:41 +0300
Message-Id: <78e2a197848074778814b70d56c8ac611e80c1d9.1581851604.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581851604.git.asml.silence@gmail.com>
References: <cover.1581851604.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile |   4 +-
 test/splice.c | 138 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 140 insertions(+), 2 deletions(-)
 create mode 100644 test/splice.c

diff --git a/test/Makefile b/test/Makefile
index cf91011..94bbd18 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -20,7 +20,7 @@ all_targets += poll poll-cancel ring-leak fsync io_uring_setup io_uring_register
 		connect 7ad0e4b2f83c-test submit-reuse fallocate open-close \
 		file-update statx accept-reuse poll-v-poll fadvise madvise \
 		short-read openat2 probe shared-wq personality eventfd \
-		send_recv eventfd-ring across-fork
+		send_recv eventfd-ring across-fork splice
 
 include ../Makefile.quiet
 
@@ -47,7 +47,7 @@ test_srcs := poll.c poll-cancel.c ring-leak.c fsync.c io_uring_setup.c \
 	7ad0e4b2f83c-test.c submit-reuse.c fallocate.c open-close.c \
 	file-update.c statx.c accept-reuse.c poll-v-poll.c fadvise.c \
 	madvise.c short-read.c openat2.c probe.c shared-wq.c \
-	personality.c eventfd.c eventfd-ring.c across-fork.c
+	personality.c eventfd.c eventfd-ring.c across-fork.c splice.c
 
 test_objs := $(patsubst %.c,%.ol,$(test_srcs))
 
diff --git a/test/splice.c b/test/splice.c
new file mode 100644
index 0000000..92b3195
--- /dev/null
+++ b/test/splice.c
@@ -0,0 +1,138 @@
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
+static int copy_single(struct io_uring *ring,
+			int fd_in, loff_t off_in,
+			int fd_out, loff_t off_out,
+			unsigned int len,
+			unsigned flags1, unsigned flags2)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret, i, err = -1;
+	int pipe_fds[2] = {-1, -1};
+
+	if (pipe(pipe_fds) < 0)
+		goto exit;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		goto exit;
+	}
+	io_uring_prep_splice(sqe, fd_in, off_in, pipe_fds[1], -1,
+			     len, flags1);
+	sqe->user_data = 1;
+	sqe->flags = IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		goto exit;
+	}
+	io_uring_prep_splice(sqe, pipe_fds[0], -1, fd_out, off_out,
+			     len, flags2);
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(ring);
+	if (ret <= 0) {
+		printf("sqe submit failed: %d\n", ret);
+		goto exit;
+	}
+
+	for (i = 0; i < 2; i++) {
+		ret = io_uring_wait_cqe(ring, &cqe);
+		if (ret < 0 || cqe->res != len) {
+			printf("wait completion %d\n", cqe->res);
+			goto exit;
+		}
+		io_uring_cqe_seen(ring, cqe);
+	}
+	err = 0;
+exit:
+	if (pipe_fds[0] >= 0) {
+		close(pipe_fds[0]);
+		close(pipe_fds[1]);
+	}
+	return err;
+}
+
+static int test_splice(struct io_uring *ring)
+{
+	int ret, err = 1;
+	int len = 4 * 4096;
+	int fd_out = -1, fd_in = -1;
+	int fd_in_idx;
+
+	fd_in = open("/dev/urandom", O_RDONLY);
+	if (fd_in < 0)
+		goto exit;
+	fd_out = memfd_create("splice_test_out_file", 0);
+	if (fd_out < 0)
+		goto exit;
+	if (ftruncate(fd_out, len) == -1)
+		goto exit;
+
+	ret = copy_single(ring, fd_in, -1, fd_out, -1, len,
+			  SPLICE_F_MOVE | SPLICE_F_MORE, 0);
+	if (ret) {
+		printf("basic splice-copy failed\n");
+		goto exit;
+	}
+
+	ret = copy_single(ring, fd_in, 0, fd_out, 0, len,
+			  0, SPLICE_F_MOVE | SPLICE_F_MORE);
+	if (ret) {
+		printf("basic splice with offset failed\n");
+		goto exit;
+	}
+
+	fd_in_idx = 0;
+	ret = io_uring_register_files(ring, &fd_in, 1);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		goto exit;
+	}
+
+	ret = copy_single(ring, fd_in_idx, 0, fd_out, 0, len,
+			  SPLICE_F_FD_IN_FIXED, 0);
+	if (ret) {
+		printf("basic splice with reg files failed\n");
+		goto exit;
+	}
+
+	err = 0;
+exit:
+	if (fd_out >= 0)
+		close(fd_out);
+	if (fd_in >= 0)
+		close(fd_in);
+	return err;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int ret;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		printf("ring setup failed\n");
+		return 1;
+	}
+
+	ret = test_splice(&ring);
+	if (ret) {
+		printf("test_splice failed %i %i\n", ret, errno);
+		return ret;
+	}
+
+	return 0;
+}
-- 
2.24.0

