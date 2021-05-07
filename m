Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72FA5376899
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 18:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236705AbhEGQYN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 12:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238113AbhEGQYI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 12:24:08 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2762C061574
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 09:23:07 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id b11-20020a7bc24b0000b0290148da0694ffso7494220wmj.2
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 09:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3LU8N1J5zpu+XyQJ5ixgt0DPPpBjXzX58o/8+oBqOl8=;
        b=aE5njJENBTl7NNb3UqGdEPoQPVVo7nEUhuWmLnBZkA6sL6ESgRJWigi/gUT/9BNZJI
         pplZgLNjxX8GtBiv0Vk4pO2QvTa9GPZDjxglvK7pDWRM904v5slcCuXKhVzYE/IKI0KQ
         LfbftFp2SRPnM4y8/DuMaHli1StgSHQme+lfQXFAJTZ3Ed7tcLgZO4UvjRdPOuhO+eBM
         sp/jAOCLPcKXUhDfyAdE3k51bWVXOePTrfIbjr0rbaomtsqyC2rbdsM73kUV9iDh4snD
         +yMRnV1IAxwTafJBmL7XSm0QiA8N/DVI6NCjUyVsIPmFOLhy9DUZUGEF9SGz6qYMy5BG
         Xx6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3LU8N1J5zpu+XyQJ5ixgt0DPPpBjXzX58o/8+oBqOl8=;
        b=ukIpRXlQCc0UC9C6VkbyPKRBPOJDg8Dtw1inuZyosFc5riy5C1SthiU/LV5aHEYE2Q
         2HyKJ9+oOPDoC1/W+WkfZBCe8N8tQFD25s7jP07clH9vtIg9IcE2zOoU/33+vzEmauyc
         mWDtI/u+//ksXR3irf7IOcPAr9LYCe3vT3nbmiwyTaH3L9E+5rklrgDhNqFPriFxrDo/
         Q2M0u9Rr4mn4VNDzSie12DL0Pv19ts5cztlHCCXLrXZ39Z/F6Ybqg84MFJcWt1p47Z2C
         NZPOaLeo+RyvDH0BFbPqCdw8PjHZqLACe3PNMSsklhTmNJrV/0L/fnPQgpefhoFHfvjF
         1TPA==
X-Gm-Message-State: AOAM533Wb2F1e4gvkUPYqewn7q/i7gzMyKwQFaFCPrN8EWr5XKRa37W1
        lroIHlrpIetWWA66TGUJsOQ=
X-Google-Smtp-Source: ABdhPJzmAwr+uHXC19XPT+vIoTODW7+gnB1YZcXi35+4weod8yp0ghQl3wLoxl/DmOcD3lufMiyuzA==
X-Received: by 2002:a1c:f305:: with SMTP id q5mr21998093wmq.96.1620404586553;
        Fri, 07 May 2021 09:23:06 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id w4sm8765630wrl.5.2021.05.07.09.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 09:23:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/4] tests: add rsrc tags tests
Date:   Fri,  7 May 2021 17:22:49 +0100
Message-Id: <1a90e0446103bfb30848f0ddcec6b4d9cd473d64.1620404433.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1620404433.git.asml.silence@gmail.com>
References: <cover.1620404433.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Test rsrc tagging, updates, new registration opcodes for buffers and
files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/Makefile    |   2 +
 test/rsrc_tags.c | 431 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 433 insertions(+)
 create mode 100644 test/rsrc_tags.c

diff --git a/test/Makefile b/test/Makefile
index 2a1985b..a312409 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -115,6 +115,7 @@ test_targets += \
 	unlink \
 	wakeup-hang \
 	sendmsg_fs_cve \
+	rsrc_tags \
 	# EOL
 
 all_targets += $(test_targets)
@@ -253,6 +254,7 @@ test_srcs := \
 	unlink.c \
 	wakeup-hang.c \
 	sendmsg_fs_cve.c \
+	rsrc_tags.c \
 	# EOL
 
 test_objs := $(patsubst %.c,%.ol,$(patsubst %.cc,%.ol,$(test_srcs)))
diff --git a/test/rsrc_tags.c b/test/rsrc_tags.c
new file mode 100644
index 0000000..7192873
--- /dev/null
+++ b/test/rsrc_tags.c
@@ -0,0 +1,431 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: run various file registration tests
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <assert.h>
+
+#include "../src/syscall.h"
+#include "helpers.h"
+#include "liburing.h"
+
+static int pipes[2];
+
+static bool check_cq_empty(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe = NULL;
+	int ret;
+
+	sleep(1); /* doesn't happen immediately, so wait */
+	ret = io_uring_peek_cqe(ring, &cqe); /* nothing should be there */
+	return ret == -EAGAIN;
+}
+
+static int register_rsrc(struct io_uring *ring, int type, int nr,
+			  const void *arg, const __u64 *tags)
+{
+	struct io_uring_rsrc_register reg;
+	int ret;
+
+	memset(&reg, 0, sizeof(reg));
+	reg.type = type;
+	reg.nr = nr;
+	reg.data = (__u64)arg;
+	reg.tags = (__u64)tags;
+
+	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_RSRC,
+					&reg, sizeof(reg));
+	return ret ? -errno : 0;
+}
+
+static int update_rsrc(struct io_uring *ring, int type, int nr, int off,
+			const void *arg, const __u64 *tags)
+{
+	struct io_uring_rsrc_update2 up;
+	int ret;
+
+	memset(&up, 0, sizeof(up));
+	up.offset = off;
+	up.data = (__u64)arg;
+	up.tags = (__u64)tags;
+	up.type = type;
+	up.nr = nr;
+
+	ret = __sys_io_uring_register(ring->ring_fd, IORING_REGISTER_RSRC_UPDATE,
+				      &up, sizeof(up));
+	return ret < 0 ? -errno : ret;
+}
+
+static bool has_rsrc_update(void)
+{
+	struct io_uring ring;
+	char buf[1024];
+	struct iovec vec = {.iov_base = buf, .iov_len = sizeof(buf), };
+	int ret;
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret)
+		return false;
+
+	ret = register_rsrc(&ring, IORING_RSRC_BUFFER, 1, &vec, NULL);
+	io_uring_queue_exit(&ring);
+	return ret != -EINVAL;
+}
+
+static int test_tags_generic(int nr, int type, void *rsrc, int ring_flags)
+{
+	struct io_uring_cqe *cqe = NULL;
+	struct io_uring ring;
+	int i, ret;
+	__u64 *tags;
+
+	tags = malloc(nr * sizeof(*tags));
+	if (!tags)
+		return 1;
+	for (i = 0; i < nr; i++)
+		tags[i] = i + 1;
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret) {
+		printf("ring setup failed\n");
+		return 1;
+	}
+
+	ret = register_rsrc(&ring, type, nr, rsrc, tags);
+	if (ret) {
+		fprintf(stderr, "rsrc register failed %i\n", ret);
+		return 1;
+	}
+
+	/* test that tags are set */
+	tags[0] = 666;
+	ret = update_rsrc(&ring, type, 1, 0, rsrc, &tags[0]);
+	assert(ret == 1);
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	assert(!ret && cqe->user_data == 1);
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* test that tags are updated */
+	tags[0] = 0;
+	ret = update_rsrc(&ring, type, 1, 0, rsrc, &tags[0]);
+	assert(ret == 1);
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	assert(!ret && cqe->user_data == 666);
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* test tag=0 doesn't emit CQE */
+	tags[0] = 1;
+	ret = update_rsrc(&ring, type, 1, 0, rsrc, &tags[0]);
+	assert(ret == 1);
+	assert(check_cq_empty(&ring));
+
+	free(tags);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+static int test_buffers_update(void)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe = NULL;
+	struct io_uring ring;
+	const int nr = 5;
+	int buf_idx = 1, i, ret;
+	int pipes[2];
+	char tmp_buf[1024];
+	char tmp_buf2[1024];
+	struct iovec vecs[nr];
+	__u64 tags[nr];
+
+	for (i = 0; i < nr; i++) {
+		vecs[i].iov_base = tmp_buf;
+		vecs[i].iov_len = 1024;
+		tags[i] = i + 1;
+	}
+
+	ret = test_tags_generic(nr, IORING_RSRC_BUFFER, vecs, 0);
+	if (ret)
+		return 1;
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret) {
+		printf("ring setup failed\n");
+		return 1;
+	}
+	if (pipe(pipes) < 0) {
+		perror("pipe");
+		return 1;
+	}
+	ret = register_rsrc(&ring, IORING_RSRC_BUFFER, nr, vecs, tags);
+	if (ret) {
+		fprintf(stderr, "rsrc register failed %i\n", ret);
+		return 1;
+	}
+
+	/* test that CQE is not emmited before we're done with a buffer */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_read_fixed(sqe, pipes[0], tmp_buf, 10, 0, 0);
+	sqe->user_data = 100;
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+		return 1;
+	}
+	ret = io_uring_peek_cqe(&ring, &cqe);
+	assert(ret == -EAGAIN);
+
+	vecs[buf_idx].iov_base = tmp_buf2;
+	ret = update_rsrc(&ring, IORING_RSRC_BUFFER, 1, buf_idx,
+			  &vecs[buf_idx], &tags[buf_idx]);
+	if (ret != 1) {
+		fprintf(stderr, "rsrc update failed %i %i\n", ret, errno);
+		return 1;
+	}
+
+	ret = io_uring_peek_cqe(&ring, &cqe); /* nothing should be there */
+	assert(ret == -EAGAIN);
+	close(pipes[0]);
+	close(pipes[1]);
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	assert(!ret && cqe->user_data == 100);
+	io_uring_cqe_seen(&ring, cqe);
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	assert(!ret && cqe->user_data == buf_idx + 1);
+	io_uring_cqe_seen(&ring, cqe);
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+static int test_buffers_empty_buffers(void)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe = NULL;
+	struct io_uring ring;
+	const int nr = 5;
+	int ret, i;
+	char tmp_buf[1024];
+	struct iovec vecs[nr];
+
+	for (i = 0; i < nr; i++) {
+		vecs[i].iov_base = 0;
+		vecs[i].iov_len = 0;
+	}
+	vecs[0].iov_base = tmp_buf;
+	vecs[0].iov_len = 10;
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret) {
+		printf("ring setup failed\n");
+		return 1;
+	}
+
+	ret = register_rsrc(&ring, IORING_RSRC_BUFFER, nr, vecs, NULL);
+	if (ret) {
+		fprintf(stderr, "rsrc register failed %i\n", ret);
+		return 1;
+	}
+
+	/* empty to buffer */
+	vecs[1].iov_base = tmp_buf;
+	vecs[1].iov_len = 10;
+	ret = update_rsrc(&ring, IORING_RSRC_BUFFER, 1, 1, &vecs[1], NULL);
+	if (ret != 1) {
+		fprintf(stderr, "rsrc update failed %i %i\n", ret, errno);
+		return 1;
+	}
+
+	/* buffer to empty */
+	vecs[0].iov_base = 0;
+	vecs[0].iov_len = 0;
+	ret = update_rsrc(&ring, IORING_RSRC_BUFFER, 1, 0, &vecs[0], NULL);
+	if (ret != 1) {
+		fprintf(stderr, "rsrc update failed %i %i\n", ret, errno);
+		return 1;
+	}
+
+	/* zero to zero is ok */
+	ret = update_rsrc(&ring, IORING_RSRC_BUFFER, 1, 2, &vecs[2], NULL);
+	if (ret != 1) {
+		fprintf(stderr, "rsrc update failed %i %i\n", ret, errno);
+		return 1;
+	}
+
+	/* empty buf with non-zero len fails */
+	vecs[3].iov_base = 0;
+	vecs[3].iov_len = 1;
+	ret = update_rsrc(&ring, IORING_RSRC_BUFFER, 1, 3, &vecs[3], NULL);
+	if (ret >= 0) {
+		fprintf(stderr, "rsrc update failed %i %i\n", ret, errno);
+		return 1;
+	}
+
+	/* test rw on empty ubuf is failed */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_read_fixed(sqe, pipes[0], tmp_buf, 10, 0, 2);
+	sqe->user_data = 100;
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+		return 1;
+	}
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	assert(!ret && cqe->user_data == 100);
+	assert(cqe->res);
+	io_uring_cqe_seen(&ring, cqe);
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_read_fixed(sqe, pipes[0], tmp_buf, 0, 0, 2);
+	sqe->user_data = 100;
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+		return 1;
+	}
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	assert(!ret && cqe->user_data == 100);
+	assert(cqe->res);
+	io_uring_cqe_seen(&ring, cqe);
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+
+static int test_files(int ring_flags)
+{
+	struct io_uring_cqe *cqe = NULL;
+	struct io_uring ring;
+	const int nr = 50;
+	int off = 5, i, ret, fd;
+	int files[nr];
+	__u64 tags[nr], tag;
+
+	for (i = 0; i < nr; ++i) {
+		files[i] = pipes[0];
+		tags[i] = i + 1;
+	}
+
+	ret = test_tags_generic(nr, IORING_RSRC_FILE, files, ring_flags);
+	if (ret)
+		return 1;
+
+	ret = io_uring_queue_init(1, &ring, ring_flags);
+	if (ret) {
+		printf("ring setup failed\n");
+		return 1;
+	}
+	ret = register_rsrc(&ring, IORING_RSRC_FILE, nr, files, tags);
+	if (ret) {
+		fprintf(stderr, "rsrc register failed %i\n", ret);
+		return 1;
+	}
+
+	/* check update did update tag */
+	fd = -1;
+	ret = io_uring_register_files_update(&ring, off, &fd, 1);
+	assert(ret == 1);
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	assert(!ret && cqe->user_data == tags[off]);
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* remove removed file, shouldn't emit old tag */
+	ret = io_uring_register_files_update(&ring, off, &fd, 1);
+	assert(ret <= 1);
+	assert(check_cq_empty(&ring));
+
+	/* non-zero tag with remove update is disallowed */
+	tag = 1;
+	fd = -1;
+	ret = update_rsrc(&ring, IORING_RSRC_FILE, 1, off + 1, &fd, &tag);
+	assert(ret);
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+static int test_notag(void)
+{
+	struct io_uring_cqe *cqe = NULL;
+	struct io_uring ring;
+	int i, ret, fd;
+	const int nr = 50;
+	int files[nr];
+
+	ret = io_uring_queue_init(1, &ring, 0);
+	if (ret) {
+		printf("ring setup failed\n");
+		return 1;
+	}
+	for (i = 0; i < nr; ++i)
+		files[i] = pipes[0];
+
+	ret = io_uring_register_files(&ring, files, nr);
+	assert(!ret);
+
+	/* default register, update shouldn't emit CQE */
+	fd = -1;
+	ret = io_uring_register_files_update(&ring, 0, &fd, 1);
+	assert(ret == 1);
+	assert(check_cq_empty(&ring));
+
+	ret = io_uring_unregister_files(&ring);
+	assert(!ret);
+	ret = io_uring_peek_cqe(&ring, &cqe); /* nothing should be there */
+	assert(ret);
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int ring_flags[] = {0, IORING_SETUP_IOPOLL, IORING_SETUP_SQPOLL};
+	int i, ret;
+
+	if (argc > 1)
+		return 0;
+	if (!has_rsrc_update()) {
+		fprintf(stderr, "doesn't support rsrc tags, skip\n");
+		return 0;
+	}
+
+	if (pipe(pipes) < 0) {
+		perror("pipe");
+		return 1;
+	}
+
+	ret = test_notag();
+	if (ret) {
+		printf("test_notag failed\n");
+		return ret;
+	}
+
+	for (i = 0; i < sizeof(ring_flags) / sizeof(ring_flags[0]); i++) {
+		ret = test_files(ring_flags[i]);
+		if (ret) {
+			printf("test_tag failed, type %i\n", i);
+			return ret;
+		}
+	}
+
+	ret = test_buffers_update();
+	if (ret) {
+		printf("test_buffers_update failed\n");
+		return ret;
+	}
+
+	ret = test_buffers_empty_buffers();
+	if (ret) {
+		printf("test_buffers_empty_buffers failed\n");
+		return ret;
+	}
+
+	return 0;
+}
-- 
2.31.1

