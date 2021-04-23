Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF3003689BB
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 02:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239892AbhDWAXB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Apr 2021 20:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236896AbhDWAXA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Apr 2021 20:23:00 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B697AC061574
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:22:23 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id d200-20020a1c1dd10000b02901384767d4a5so257831wmd.3
        for <io-uring@vger.kernel.org>; Thu, 22 Apr 2021 17:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=42vYmq2/x9eFGCCaSfqlJkUYi9/GcGXd7JviZ4Z6AJE=;
        b=T4pWelpxlIEdg8/ycjWYbOXjruJB6QSVhAkmWe9gj+JHZfwdzhzed/QwKBwkZ/1izg
         FMmQV0goc7ge6oNLvnIZjR/tLlSCBmmlmn/OP5x0QJk2sVkM0jI5dU1y2P4foxvzB9KV
         nLMbgLwbguFRhSj6/kBpgLtt+6UMd0YMsIQ35JDl1gSovDRR6pE8l1g1X7WSELG7afA7
         q22/ztH843t6U3FRmZKPZbpk9ZC6mwY5KSJAe3gY9JiCS2ltvstadO8mcq3qPeXINFaR
         j0pMqBnNQrseo9RjeZONyzsYnBHQJfuPiQv47E4uSyOYDrpPJl6DsST/60VW2ma7nlGt
         lS/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=42vYmq2/x9eFGCCaSfqlJkUYi9/GcGXd7JviZ4Z6AJE=;
        b=pGeLF3lJW1a6uUxYstQ6HTaufvRPDSG5UBAknYM+AOB3TeeeRMwcJe5VKZdbi0XGAj
         4LGk7//qRrlcNDeoWohWNdSsF0VxOMMpW03wFvHhFG2J46pKH3Ov/XFkVnN91USBeWOc
         oYNBJzsSBKXjBfW3kxZMlWivYsrr5awj7EHH5wRxmDCu+Yc1zutKuE4DJk+9lyWgw9ZU
         qAbIGzi0eIaHZ5IUGKblu9o2CBCtl9T9zx75K70BFHFcxp9jIIBLbQj1CtdTeOx0XlJy
         ds33HiwNIGYzLoU6eE0kg7rOWm0bzIZnEp3w9p7QDqDE3gpQ3j96fVnFfZEfXz5qyuFZ
         ODjg==
X-Gm-Message-State: AOAM531opBq8lUrmlDSYsZ3nawEMbfniYAiqsZhHD11chgeb/wadS3c/
        lo9kcaTOdb5Dykt4aviUa8N517WAjmM=
X-Google-Smtp-Source: ABdhPJxS/5TGMDof/EgRgSLXMP+/C4K2n+UAqFTWGn1efpDkpZyt9lDlbwUzCHlEkgYjBwsSpbGf3w==
X-Received: by 2002:a1c:3845:: with SMTP id f66mr2606880wma.60.1619137342367;
        Thu, 22 Apr 2021 17:22:22 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id o17sm6767670wrg.80.2021.04.22.17.22.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 17:22:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC liburing 1/1] tests: add rsrc tags tests
Date:   Fri, 23 Apr 2021 01:22:12 +0100
Message-Id: <0cd1df470a524de72298a41bce93bfea056758ed.1619137291.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Test rsrc tagging, updates, new registration opcodes for buffers and
files.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Not final but working, just for reference.

 test/Makefile    |   2 +
 test/rsrc_tags.c | 335 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 337 insertions(+)
 create mode 100644 test/rsrc_tags.c

diff --git a/test/Makefile b/test/Makefile
index 4572564..f62e4f3 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -114,6 +114,7 @@ test_targets += \
 	unlink \
 	wakeup-hang \
 	sendmsg_fs_cve \
+	rsrc_tags \
 	# EOL
 
 all_targets += $(test_targets)
@@ -251,6 +252,7 @@ test_srcs := \
 	unlink.c \
 	wakeup-hang.c \
 	sendmsg_fs_cve.c \
+	rsrc_tags.c \
 	# EOL
 
 test_objs := $(patsubst %.c,%.ol,$(patsubst %.cc,%.ol,$(test_srcs)))
diff --git a/test/rsrc_tags.c b/test/rsrc_tags.c
new file mode 100644
index 0000000..1fd2628
--- /dev/null
+++ b/test/rsrc_tags.c
@@ -0,0 +1,335 @@
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
+struct io_uring_rsrc_update2 {
+	__u32 offset;
+	__u32 resv;
+	__aligned_u64 data;
+	__aligned_u64 tags;
+	__u32 type;
+	__u32 nr;
+};
+
+struct io_uring_rsrc_register {
+	__u32 type;
+	__u32 nr;
+	__aligned_u64 data;
+	__aligned_u64 tags;
+};
+
+enum {
+	IORING_RSRC_FILE		= 0,
+	IORING_RSRC_BUFFER		= 1,
+};
+
+enum {
+	IORING_REGISTER_RSRC			= 13,
+	IORING_REGISTER_RSRC_UPDATE		= 14,
+};
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
+	int ring_flags[] = {0, IORING_SETUP_IOPOLL};
+	int i, ret;
+
+	if (argc > 1)
+		return 0;
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
+	return 0;
+}
-- 
2.31.1

