Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AE501600E3
	for <lists+io-uring@lfdr.de>; Sat, 15 Feb 2020 23:08:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgBOWIi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 15 Feb 2020 17:08:38 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:35365 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726254AbgBOWIi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 15 Feb 2020 17:08:38 -0500
Received: by mail-wm1-f67.google.com with SMTP id b17so14595106wmb.0;
        Sat, 15 Feb 2020 14:08:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=1gTtXv0Ou7Ozif9CG3wW02P8umAhUNyzslpCaL1DANM=;
        b=BTcI4YdstRKPwKcNj0JRxGMZYQxtWFgtOTcXlnRskSGjkIJfUdORIEcwoG6y+DA5W8
         Q/NDGJm4wNj+uGfT3Ey/2DktN+a43t1DzwoVycQlC7llGkAbIpicHtzQRKmdJyegI5JB
         bMrvhiJACzpw0omFBeXBsXdKBiyLP0DaZSg2k4mLfjXxJPjLu5BrQ/kFxmRagSyyO/eE
         cnH18dHOpXSyiZnrlyBfqzxjO9v3omygUs7ZMxBjwb42pumbyD/xsFEvE9TksQZ0ETVZ
         jf+0eYwKMK0mKT9fgz6z8pWakVSozt9KFSQEV4gPfD506qGXlCa3ZOUvjEZQOGSzu9Ye
         DRAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1gTtXv0Ou7Ozif9CG3wW02P8umAhUNyzslpCaL1DANM=;
        b=WdU11sdFac26AqTuPfVnmJTkajY4EZZfSHiICdvIRaMBZmZ8pUP1dYRxsjsieLnYOz
         /6m3PltNZnV/E4mzWZ72XVLDKbJA/Z43YMjwfAkG8CLDbY4xZba6bxbu53MdpIc6S208
         xOBfxZMJ1z9lHNtE/9AobqaJCTWdChHWgw1OTXM5cW22uDCPHQ/NHCQ3c62nBzUVAqlk
         S3MB1KJwCN6CKfM1MVms4ca/QhHSGSW5tjimpQYvtKsxXsgSNtCUZG6xIvkEMt1TsSIA
         GLUDlAgdV+asNUuVdE7x95fa9MDp7/+cSkq45SRgZ6Tzl1AH5bBviOJhye6eozH126Jr
         fVQQ==
X-Gm-Message-State: APjAAAU7jh0gpgkad0lj/JnZkCXRM/oyfdy1DtZYINiyOsuoYrpl0kax
        QdtZdy+N1Gim0ipw4zr1ekk=
X-Google-Smtp-Source: APXvYqyH9IHBGy5FZh2TF/QeMKxxvW4NOBOFzjkVvNXFamJyAQxE3YmwMUdJwXzp8f5GuKPwYcZzdg==
X-Received: by 2002:a1c:e28a:: with SMTP id z132mr12022299wmg.157.1581804514920;
        Sat, 15 Feb 2020 14:08:34 -0800 (PST)
Received: from localhost.localdomain ([109.126.146.5])
        by smtp.gmail.com with ESMTPSA id h71sm14539719wme.26.2020.02.15.14.08.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 14:08:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH liburing 2/2] test/splice: add basic splice tests
Date:   Sun, 16 Feb 2020 01:07:36 +0300
Message-Id: <36f4ef4d1ef17258aee2f5413cb5bb1819b13693.1581803684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1581803684.git.asml.silence@gmail.com>
References: <cover.1581803684.git.asml.silence@gmail.com>
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

