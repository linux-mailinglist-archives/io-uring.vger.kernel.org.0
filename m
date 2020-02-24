Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4979C16AAB1
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 17:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726806AbgBXQEt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Feb 2020 11:04:49 -0500
Received: from mail-wr1-f66.google.com ([209.85.221.66]:36799 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727681AbgBXQEs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Feb 2020 11:04:48 -0500
Received: by mail-wr1-f66.google.com with SMTP id z3so11032769wru.3
        for <io-uring@vger.kernel.org>; Mon, 24 Feb 2020 08:04:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=WHKia8bIY8P1sd2G1pzFXPxmNtZOjnz7fDtCCl1I0Ic=;
        b=DOFPoGhdfbxh8SA6zFI+3vFNimAjgJzyjFSkCv5DOLTb8x1MhRGqwWScmVOBmPjfGR
         j3AOL/4H2vvgBcS2CTzhNuFBhAG2xbPPuV02Q3wb43VUeLZ0icSrGQn9SSj84FErptyy
         lWtO8j5I7uruxTCg+Ebsojzah32lLCZkyJQe6Ta7gCXpuPfGHAYLn7jfLA1Rl/okrDY5
         RoQzXqeHEzcT/v0ntVt1rCTiliKWn33pCvmkJ1vn59TCf/H9A0KtUgsBWXxQgsVatgVi
         LYQ/46e0lVh4RarF4hJB3U9Ex+byywHu3FTUdFkkDOBzBIaPBRLxqU45gWd9WFOiF6Ie
         3jig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=WHKia8bIY8P1sd2G1pzFXPxmNtZOjnz7fDtCCl1I0Ic=;
        b=HUVotP8cMaaRptA6mL2t9YKyeFvNH3QMWlS2W2ZpErbMEQ1Zyq5NGVWufgLhKNT/0f
         IIhvx6acztz0478LVxNklAUVh1e0XK18qlSw4Yh/q40vi7Tf6nlJ2zniGui9XvY+VdUn
         0xIRTRqqLaR7ZK8Vg/GcIbu40lDlW9OCBgEXWwFLWkk09YKfhwodOMANL3dh2xFFCS4H
         doBQY+uoHjyZt31C7NKwtQxb1YZODwG3arFe1MNnz+0JGZXbpR1EhHbyZVNDSN1W6fYG
         mw1N20dMgk51wkGU0JkNGwwkn4x6tY/rrdWj+vhWXAAYKNqAl62i1sH0iCDS3TPvtS/t
         OFFQ==
X-Gm-Message-State: APjAAAWZWlH5x5h/CN1SRivMFnSn7HfFcrTtO5JpdDv0vX3uCauu5AoY
        utsZ5beJbnRQrQIO4J0Lwilj2EEm
X-Google-Smtp-Source: APXvYqwuJxbZ4aS1CnjzOwLzX+2inRnJCIQBk7b9G8/DOCfCc2OyBnc7Z97TU586jpKDhoGeirWHmg==
X-Received: by 2002:a5d:474b:: with SMTP id o11mr70327321wrs.255.1582560285904;
        Mon, 24 Feb 2020 08:04:45 -0800 (PST)
Received: from localhost.localdomain ([109.126.137.65])
        by smtp.gmail.com with ESMTPSA id e11sm8600608wrm.80.2020.02.24.08.04.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 08:04:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 2/2] test/splice: add basic splice tests
Date:   Mon, 24 Feb 2020 19:03:50 +0300
Message-Id: <b4a11a08d6c6fe7c3292eac3d1eb9fb9f8f9d7dd.1582560081.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582560081.git.asml.silence@gmail.com>
References: <cover.1582560081.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile |   5 +-
 test/splice.c | 138 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 141 insertions(+), 2 deletions(-)
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

