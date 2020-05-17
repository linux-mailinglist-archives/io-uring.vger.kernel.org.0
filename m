Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 228341D67B0
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:25:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgEQLZR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727858AbgEQLZR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:25:17 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F518C061A0C;
        Sun, 17 May 2020 04:25:16 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id h26so5517916lfg.6;
        Sun, 17 May 2020 04:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hDuVoGlEJ3byMFevuSj5Hp+A+z3YiyvFVW8rB5YEisM=;
        b=XCDRDY8GUjdkpcNLaRMnZdXnXLZAjukXCyXB52aPob7eBkSLvc2q26Op8KoIT16ZUf
         vKNVRi4VbO/jlw0aWynQL6WRUFgKLC+0Jpj83mBvA/LLCZEijTzu3BBWWBtSOLmmzNEx
         A3M8TiDHEcTYoqL3CmFnKvzu8gE4IP6Eoaq4TsINoYUK5IJqbJ4241nZQBrMo9WccfZI
         F4ghaObzkSMdSWJc7guG7/N4Aawwd5Z2sEHOAU9uYy3Q1gTqeQwPHIWnivjlyuCu0dsi
         wnGWXHQP97nGbQKoyV7ZcB2UXAUZlcUnlooKlIFZE6dzCsQ51DXZ1nEwHpEAPgKucYip
         T9qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hDuVoGlEJ3byMFevuSj5Hp+A+z3YiyvFVW8rB5YEisM=;
        b=RdzNY9mrYUloDE+4Ln0fB5uOHRw+RkdcKVY/I9Q62Vgkt6OXynuFuAmS4RpkGu3gDP
         TMAMZUm0EC6veVG6r0CB42IRgeWYEMj0Zna0wzp6ZoxEE+UUt52Xx3XSYZjSKPGVvz/D
         U5EmlKslxqlU53R6ztv2LchCvM88slgrcAtLuzX/DOgKlT5NhXDML9auZEWfuOCwLGBN
         Bb1vUOFTGfnIyEsq3KtvXsDjg+keJAKKkghW2VWz+cntYjZone6ppOJx/qaVo4JgqwQk
         wnqqkiEIatMbm/zZNl9ONoaIDIQ23CY+iqeRsNgykADYawKrPiFFrOFLdBWDWK+SFrBb
         FGbQ==
X-Gm-Message-State: AOAM532+jWSbJ+yP41ncogIEDrwJ6uwluEcSApCodocqoAcgylUB/U1p
        hKI86ozsNMK7DOmlI+/+hzM=
X-Google-Smtp-Source: ABdhPJzM3QXJDFL0QpvdkFpMa3vSd+92HPc7Ctn9L1rjQ/54qy6VRnxRXZIskAZsWZ1Pe4XHvBHvPQ==
X-Received: by 2002:a19:d52:: with SMTP id 79mr7288539lfn.125.1589714715014;
        Sun, 17 May 2020 04:25:15 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id c78sm5639828lfd.63.2020.05.17.04.25.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:25:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH liburing 1/4] splice/test: improve splice tests
Date:   Sun, 17 May 2020 14:23:44 +0300
Message-Id: <d48b2ea822ad22b31738cc76c446a3e026048fd1.1589714504.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1589714504.git.asml.silence@gmail.com>
References: <cover.1589714504.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Split and test functionality separately, better cover registered files
cases, and validate file\pipe actual data.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/splice.c | 393 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 300 insertions(+), 93 deletions(-)

diff --git a/test/splice.c b/test/splice.c
index b7ef537..1c27c8e 100644
--- a/test/splice.c
+++ b/test/splice.c
@@ -8,133 +8,305 @@
 
 #include "liburing.h"
 
-static int no_splice = 0;
-
-static int copy_single(struct io_uring *ring,
-			int fd_in, loff_t off_in,
-			int fd_out, loff_t off_out,
-			int pipe_fds[2],
-			unsigned int len,
-			unsigned flags1, unsigned flags2)
+#define BUF_SIZE (16 * 4096)
+
+struct test_ctx {
+	int real_pipe1[2];
+	int real_pipe2[2];
+	int real_fd_in;
+	int real_fd_out;
+
+	/* fds or for registered files */
+	int pipe1[2];
+	int pipe2[2];
+	int fd_in;
+	int fd_out;
+
+	void *buf_in;
+	void *buf_out;
+};
+
+static unsigned int splice_flags = 0;
+static unsigned int sqe_flags = 0;
+static int has_splice = 0;
+
+static int read_buf(int fd, void *buf, int len)
 {
-	struct io_uring_cqe *cqe;
-	struct io_uring_sqe *sqe;
-	int i, ret = -1;
+	int ret;
+
+	while (len) {
+		ret = read(fd, buf, len);
+		if (ret < 0)
+			return ret;
+		len -= ret;
+		buf += ret;
+	}
+	return 0;
+}
+
+static int write_buf(int fd, const void *buf, int len)
+{
+	int ret;
+
+	while (len) {
+		ret = write(fd, buf, len);
+		if (ret < 0)
+			return ret;
+		len -= ret;
+		buf += ret;
+	}
+	return 0;
+}
+
+static int check_content(int fd, void *buf, int len, const void *src)
+{
+	int ret;
+
+	ret = read_buf(fd, buf, len);
+	if (ret)
+		return ret;
+
+	ret = memcmp(buf, src, len);
+	return (ret != 0) ? -1 : 0;
+}
+
+static int create_file(const char *filename)
+{
+	int fd, save_errno;
+
+	fd = open(filename, O_RDWR | O_CREAT, 0644);
+	save_errno = errno;
+	unlink(filename);
+	errno = save_errno;
+	return fd;
+}
+
+static int init_splice_ctx(struct test_ctx *ctx)
+{
+	int ret, rnd_fd;
 
-	sqe = io_uring_get_sqe(ring);
-	if (!sqe) {
-		fprintf(stderr, "get sqe failed\n");
-		return -1;
+	ctx->buf_in = calloc(BUF_SIZE, 1);
+	if (!ctx->buf_in)
+		return 1;
+	ctx->buf_out = calloc(BUF_SIZE, 1);
+	if (!ctx->buf_out)
+		return 1;
+
+	ctx->fd_in = create_file(".splice-test-in");
+	if (ctx->fd_in < 0) {
+		perror("file open");
+		return 1;
 	}
-	io_uring_prep_splice(sqe, fd_in, off_in, pipe_fds[1], -1,
-			     len, flags1);
-	sqe->flags = IOSQE_IO_LINK;
-
-	sqe = io_uring_get_sqe(ring);
-	if (!sqe) {
-		fprintf(stderr, "get sqe failed\n");
-		return -1;
+
+	ctx->fd_out = create_file(".splice-test-out");
+	if (ctx->fd_out < 0) {
+		perror("file open");
+		return 1;
 	}
-	io_uring_prep_splice(sqe, pipe_fds[0], -1, fd_out, off_out,
-			     len, flags2);
-
-	ret = io_uring_submit(ring);
-	if (ret < 2) {
-		/* submitted just one, kernel likely doesn't support splice */
-		if (!io_uring_peek_cqe(ring, &cqe) &&
-		    cqe->res == -EINVAL) {
-			no_splice = 1;
+
+	/* get random data */
+	rnd_fd = open("/dev/urandom", O_RDONLY);
+	if (rnd_fd < 0)
+		return 1;
+
+	ret = read_buf(rnd_fd, ctx->buf_in, BUF_SIZE);
+	if (ret != 0)
+		return 1;
+	close(rnd_fd);
+
+	/* populate file */
+	ret = write_buf(ctx->fd_in, ctx->buf_in, BUF_SIZE);
+	if (ret)
+		return ret;
+
+	if (pipe(ctx->pipe1) < 0)
+		return 1;
+	if (pipe(ctx->pipe2) < 0)
+		return 1;
+
+	ctx->real_pipe1[0] = ctx->pipe1[0];
+	ctx->real_pipe1[1] = ctx->pipe1[1];
+	ctx->real_pipe2[0] = ctx->pipe2[0];
+	ctx->real_pipe2[1] = ctx->pipe2[1];
+	ctx->real_fd_in = ctx->fd_in;
+	ctx->real_fd_out = ctx->fd_out;
+	return 0;
+}
+
+static int do_splice(struct io_uring *ring,
+			   int fd_in, loff_t off_in,
+			   int fd_out, loff_t off_out,
+			   unsigned int len)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret = -1;
+
+	while (len) {
+		sqe = io_uring_get_sqe(ring);
+		if (!sqe) {
+			fprintf(stderr, "get sqe failed\n");
 			return -1;
 		}
-		fprintf(stderr, "sqe submit failed: %d\n", ret);
-		return -1;
-	}
+		io_uring_prep_splice(sqe, fd_in, off_in, fd_out, off_out,
+				     len, splice_flags);
+		sqe->flags |= sqe_flags;
+		sqe->user_data = 42;
+
+		ret = io_uring_submit(ring);
+		if (ret != 1) {
+			fprintf(stderr, "sqe submit failed: %d\n", ret);
+			return ret;
+		}
 
-	for (i = 0; i < 2; i++) {
 		ret = io_uring_wait_cqe(ring, &cqe);
 		if (ret < 0) {
 			fprintf(stderr, "wait completion %d\n", cqe->res);
 			return ret;
 		}
 
-		ret = cqe->res;
-		if (ret != len) {
-			fprintf(stderr, "splice: returned %i, expected %i\n",
-				cqe->res, len);
-			return ret < 0 ? ret : -1;
+		if (cqe->res <= 0) {
+			io_uring_cqe_seen(ring, cqe);
+			return cqe->res;
 		}
+
+		len -= cqe->res;
+		if (off_in != -1)
+			off_in += cqe->res;
+		if (off_out != -1)
+			off_out += cqe->res;
 		io_uring_cqe_seen(ring, cqe);
 	}
+
 	return 0;
 }
 
-static int test_splice(struct io_uring *ring)
+static void check_splice_support(struct io_uring *ring, struct test_ctx *ctx)
 {
-	int ret = -1, len = 4 * 4096;
-	int fd_out = -1, fd_in = -1;
-	int pipe_fds[2] = {-1, -1};
-
-	if (pipe(pipe_fds) < 0)
-		goto exit;
-	fd_in = open("/dev/urandom", O_RDONLY);
-	if (fd_in < 0)
-		goto exit;
-	fd_out = open(".splice_fd_out", O_CREAT | O_WRONLY, 0644);
-	if (fd_out < 0)
-		goto exit;
-	if (ftruncate(fd_out, len) == -1)
-		goto exit;
-
-	ret = copy_single(ring, fd_in, -1, fd_out, -1, pipe_fds,
-			  len, SPLICE_F_MOVE | SPLICE_F_MORE, 0);
-	if (ret == -EINVAL) {
-		no_splice = 1;
-		goto exit;
-	}
-	if (ret) {
-		fprintf(stderr, "basic splice-copy failed\n");
-		goto exit;
-	}
+	int ret;
 
-	ret = copy_single(ring, fd_in, 0, fd_out, 0, pipe_fds,
-			  len, 0, SPLICE_F_MOVE | SPLICE_F_MORE);
+	ret = do_splice(ring, -1, 0, -1, 0, BUF_SIZE);
+	has_splice = (ret == -EBADF);
+}
+
+static int splice_to_pipe(struct io_uring *ring, struct test_ctx *ctx)
+{
+	int ret;
+
+	ret = lseek(ctx->real_fd_in, 0, SEEK_SET);
+	if (ret)
+		return ret;
+
+	/* implicit file offset */
+	ret = do_splice(ring, ctx->fd_in, -1, ctx->pipe1[1], -1, BUF_SIZE);
+	if (ret)
+		return ret;
+
+	ret = check_content(ctx->real_pipe1[0], ctx->buf_out, BUF_SIZE,
+			     ctx->buf_in);
+	if (ret)
+		return ret;
+
+	/* explicit file offset */
+	ret = do_splice(ring, ctx->fd_in, 0, ctx->pipe1[1], -1, BUF_SIZE);
+	if (ret)
+		return ret;
+
+	return check_content(ctx->real_pipe1[0], ctx->buf_out, BUF_SIZE,
+			     ctx->buf_in);
+}
+
+static int splice_from_pipe(struct io_uring *ring, struct test_ctx *ctx)
+{
+	int ret;
+
+	ret = write_buf(ctx->real_pipe1[1], ctx->buf_in, BUF_SIZE);
+	if (ret)
+		return ret;
+	ret = do_splice(ring, ctx->pipe1[0], -1, ctx->fd_out, 0, BUF_SIZE);
+	if (ret)
+		return ret;
+	ret = check_content(ctx->real_fd_out, ctx->buf_out, BUF_SIZE,
+			     ctx->buf_in);
+	if (ret)
+		return ret;
+
+	ret = ftruncate(ctx->real_fd_out, 0);
+	if (ret)
+		return ret;
+	return lseek(ctx->real_fd_out, 0, SEEK_SET);
+}
+
+static int splice_pipe_to_pipe(struct io_uring *ring, struct test_ctx *ctx)
+{
+	int ret;
+
+	ret = do_splice(ring, ctx->fd_in, 0, ctx->pipe1[1], -1, BUF_SIZE);
+	if (ret)
+		return ret;
+	ret = do_splice(ring, ctx->pipe1[0], -1, ctx->pipe2[1], -1, BUF_SIZE);
+	if (ret)
+		return ret;
+
+	return check_content(ctx->real_pipe2[0], ctx->buf_out, BUF_SIZE,
+				ctx->buf_in);
+}
+
+static int fail_splice_pipe_offset(struct io_uring *ring, struct test_ctx *ctx)
+{
+	int ret;
+
+	ret = do_splice(ring, ctx->fd_in, 0, ctx->pipe1[1], 0, BUF_SIZE);
+	if (ret != -ESPIPE && ret != -EINVAL)
+		return ret;
+
+	ret = do_splice(ring, ctx->pipe1[0], 0, ctx->fd_out, 0, BUF_SIZE);
+	if (ret != -ESPIPE && ret != -EINVAL)
+		return ret;
+
+	return 0;
+}
+
+static int test_splice(struct io_uring *ring, struct test_ctx *ctx)
+{
+	int ret;
+
+	ret = splice_to_pipe(ring, ctx);
 	if (ret) {
-		fprintf(stderr, "basic splice with offset failed\n");
-		goto exit;
+		fprintf(stderr, "splice_to_pipe failed %i %i\n",
+			ret, errno);
+		return ret;
 	}
 
-	ret = io_uring_register_files(ring, &fd_in, 1);
+	ret = splice_from_pipe(ring, ctx);
 	if (ret) {
-		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
-		goto exit;
+		fprintf(stderr, "splice_from_pipe failed %i %i\n",
+			ret, errno);
+		return ret;
 	}
 
-	ret = copy_single(ring, 0, 0, fd_out, 0, pipe_fds,
-			  len, SPLICE_F_FD_IN_FIXED, 0);
+	ret = splice_pipe_to_pipe(ring, ctx);
 	if (ret) {
-		fprintf(stderr, "basic splice with reg files failed\n");
-		goto exit;
+		fprintf(stderr, "splice_pipe_to_pipe failed %i %i\n",
+			ret, errno);
+		return ret;
 	}
 
-	ret = 0;
-exit:
-	if (fd_out >= 0) {
-		unlink(".splice_fd_out");
-		close(fd_out);
-	}
-	if (fd_in >= 0)
-		close(fd_in);
-	if (pipe_fds[0] >= 0) {
-		close(pipe_fds[0]);
-		close(pipe_fds[1]);
+	ret = fail_splice_pipe_offset(ring, ctx);
+	if (ret) {
+		fprintf(stderr, "fail_splice_pipe_offset failed %i %i\n",
+			ret, errno);
+		return ret;
 	}
-	return ret;
+	return 0;
 }
 
 int main(int argc, char *argv[])
 {
 	struct io_uring ring;
+	struct test_ctx ctx;
 	int ret;
+	int reg_fds[6];
 
 	ret = io_uring_queue_init(8, &ring, 0);
 	if (ret) {
@@ -142,15 +314,50 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	ret = test_splice(&ring);
-	if (ret && no_splice) {
+	ret = init_splice_ctx(&ctx);
+	if (ret) {
+		fprintf(stderr, "init failed %i %i\n", ret, errno);
+		return 1;
+	}
+
+	check_splice_support(&ring, &ctx);
+	if (!has_splice) {
 		fprintf(stdout, "skip, doesn't support splice()\n");
 		return 0;
 	}
+
+	ret = test_splice(&ring, &ctx);
 	if (ret) {
-		fprintf(stderr, "test_splice failed %i %i\n", ret, errno);
+		fprintf(stderr, "basic splice tests failed\n");
 		return ret;
 	}
 
+	reg_fds[0] = ctx.real_pipe1[0];
+	reg_fds[1] = ctx.real_pipe1[1];
+	reg_fds[2] = ctx.real_pipe2[0];
+	reg_fds[3] = ctx.real_pipe2[1];
+	reg_fds[4] = ctx.real_fd_in;
+	reg_fds[5] = ctx.real_fd_out;
+	ret = io_uring_register_files(&ring, reg_fds, 6);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	/* remap fds to registered */
+	ctx.pipe1[0] = 0;
+	ctx.pipe1[1] = 1;
+	ctx.pipe2[0] = 2;
+	ctx.pipe2[1] = 3;
+	ctx.fd_in = 4;
+	ctx.fd_out = 5;
+
+	splice_flags = SPLICE_F_FD_IN_FIXED;
+	sqe_flags = IOSQE_FIXED_FILE;
+	ret = test_splice(&ring, &ctx);
+	if (ret) {
+		fprintf(stderr, "registered fds splice tests failed\n");
+		return ret;
+	}
 	return 0;
 }
-- 
2.24.0

