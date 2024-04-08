Return-Path: <io-uring+bounces-1456-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F67C89B516
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 03:05:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26411281427
	for <lists+io-uring@lfdr.de>; Mon,  8 Apr 2024 01:05:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 50EDF7F8;
	Mon,  8 Apr 2024 01:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YlT1TIoq"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E62B7FE
	for <io-uring@vger.kernel.org>; Mon,  8 Apr 2024 01:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712538338; cv=none; b=jUrnDpiVCfxNamUTRavqtx82VwsSiGtnJWhnxcsCsogjVFWbst2GGtHOYGtrIRk/myd0j0SSTwgjstrIu7d5LSGZgC5a7TZqdmEaEIU3pXpd7FrsJe1P200O3XJDGDw3gL9SzvOhYlQ+5skZfE8g8T92LEIdXJ6wzS4Hlzlkm6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712538338; c=relaxed/simple;
	bh=+FI9rCcRMO9FRe0PZDi0wWo54+iVj3+d/f6zQWUW80Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRH+apuj/yzntRWquMLXVgJEeetlO4ih4Vtrb0lNC/ImY+jVGCUqJCKw+jGS7k4idrgQsEsBypl2e6lm6mKyzEEgj2Cezbve46raaflN5kgFix3kRd34sGkHaszKvxeggZ2hDZpN7Mq01WTO3KCKB8TVSlhZLJhGWFL8xTVEGnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YlT1TIoq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1712538335;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fk7Og0+9kQFsceT+wSVT+18TGLYiV9J02JZHLxr0aUI=;
	b=YlT1TIoq+6hUC0Zt3veXAITocCfs9CcMAip8k+PoJyLQcZ8G45TeACyMJIXj7Frf7sca7V
	h84uH+HNpxkdXeTMDJeRWlff1/KvMf5ZnDGdCd1TdwUQClWxMrLMUqYaxlPPFdLHFa2xhZ
	eY0bZ+EuobiXgev3J8635TIrYWfecKs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-662-RN62w8-aPn2hL5hS2n8D7Q-1; Sun, 07 Apr 2024 21:05:30 -0400
X-MC-Unique: RN62w8-aPn2hL5hS2n8D7Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BA4F6811000;
	Mon,  8 Apr 2024 01:05:29 +0000 (UTC)
Received: from localhost (unknown [10.72.116.148])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 0A8B447F;
	Mon,  8 Apr 2024 01:05:28 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Kevin Wolf <kwolf@redhat.com>,
	Ming Lei <tom.leiming@gmail.com>
Subject: [RFC PATCH 9/9] liburing: support sqe ext_flags & sqe group
Date: Mon,  8 Apr 2024 09:03:22 +0800
Message-ID: <20240408010322.4104395-10-ming.lei@redhat.com>
In-Reply-To: <20240408010322.4104395-1-ming.lei@redhat.com>
References: <20240408010322.4104395-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.1

From: Ming Lei <tom.leiming@gmail.com>

Provide helper to set sqe ext_flags.

Add one test case to cover sqe group feature by applying sqe group for
copying one part of source file into multiple destinations via single
syscall.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 src/include/liburing.h          |  15 ++
 src/include/liburing/io_uring.h |  20 +++
 test/Makefile                   |   1 +
 test/group_cp.c                 | 260 ++++++++++++++++++++++++++++++++
 4 files changed, 296 insertions(+)
 create mode 100644 test/group_cp.c

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 3e47298..5379d53 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -368,6 +368,21 @@ IOURINGINLINE void io_uring_sqe_set_flags(struct io_uring_sqe *sqe,
 	sqe->flags = (__u8) flags;
 }
 
+IOURINGINLINE void io_uring_sqe_set_ext_flags(struct io_uring_sqe *sqe,
+					  unsigned flags)
+{
+	sqe->ext_flags = (__u8) flags;
+	sqe->flags |= IOSQE_HAS_EXT_FLAGS;
+}
+
+IOURINGINLINE void io_uring_cmd_set_ext_flags(struct io_uring_sqe *sqe,
+					  unsigned flags)
+{
+	sqe->uring_cmd_flags &= ~IORING_URING_CMD_EXT_MASK;
+	sqe->uring_cmd_flags |= ((__u8) flags) << 16;
+	sqe->flags |= IOSQE_HAS_EXT_FLAGS;
+}
+
 IOURINGINLINE void __io_uring_set_target_fixed_file(struct io_uring_sqe *sqe,
 						    unsigned int file_index)
 {
diff --git a/src/include/liburing/io_uring.h b/src/include/liburing/io_uring.h
index bde1199..b0a0318 100644
--- a/src/include/liburing/io_uring.h
+++ b/src/include/liburing/io_uring.h
@@ -98,6 +98,10 @@ struct io_uring_sqe {
 			__u64	__pad2[1];
 		};
 		__u64	optval;
+		struct {
+			__u8	__pad4[15];
+			__u8	ext_flags;
+		};
 		/*
 		 * If the ring is initialized with IORING_SETUP_SQE128, then
 		 * this field is used for 80 bytes of arbitrary command data
@@ -123,6 +127,9 @@ enum {
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
 	IOSQE_CQE_SKIP_SUCCESS_BIT,
+	IOSQE_HAS_EXT_FLAGS_BIT,
+
+	IOSQE_EXT_SQE_GROUP_BIT = 0,
 };
 
 /*
@@ -142,6 +149,13 @@ enum {
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 /* don't post CQE if request succeeded */
 #define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
+/*
+ * sqe ext flags carried in the last byte, or bit23~bit16 of
+ * sqe->uring_cmd_flags for IORING_URING_CMD.
+ */
+#define IOSQE_HAS_EXT_FLAGS	(1U << IOSQE_HAS_EXT_FLAGS_BIT)
+/* defines sqe group */
+#define IOSQE_EXT_SQE_GROUP	(1U << IOSQE_EXT_SQE_GROUP_BIT)
 
 /*
  * io_uring_setup() flags
@@ -265,8 +279,14 @@ enum io_uring_op {
  * sqe->uring_cmd_flags
  * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
  *				along with setting sqe->buf_index.
+ * IORING_PROVIDE_GROUP_KBUF	this command provides group kernel buffer
+ *				for member requests which can retrieve
+ *				any sub-buffer with offset(sqe->addr) and
+ *				len(sqe->len)
  */
 #define IORING_URING_CMD_FIXED	(1U << 0)
+#define IORING_PROVIDE_GROUP_KBUF	(1U << 1)
+#define IORING_URING_CMD_EXT_MASK	0x00ff0000
 
 
 /*
diff --git a/test/Makefile b/test/Makefile
index 32848ec..dd3b394 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -207,6 +207,7 @@ test_srcs := \
 	wakeup-hang.c \
 	wq-aff.c \
 	xattr.c \
+	group_cp.c \
 	# EOL
 
 all_targets :=
diff --git a/test/group_cp.c b/test/group_cp.c
new file mode 100644
index 0000000..4ac5cdb
--- /dev/null
+++ b/test/group_cp.c
@@ -0,0 +1,260 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Test SQE group feature
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <sys/types.h>
+#include <assert.h>
+#include <sys/stat.h>
+#include <linux/fs.h>
+
+#include "liburing.h"
+#include "helpers.h"
+
+#define BUF_SIZE    8192
+#define BUFFERS     6
+
+
+struct test_data {
+	const char *src_file;
+	struct iovec iov[BUFFERS];
+	int fd_in, fd_out1, fd_out2;
+};
+
+static void set_sqe_group(struct io_uring_sqe *sqe)
+{
+	io_uring_sqe_set_ext_flags(sqe, IOSQE_EXT_SQE_GROUP);
+}
+
+static int check_cqe(struct io_uring *ring, unsigned int nr)
+{
+	int i, ret;
+
+        for (i = 0; i < nr; ++i) {
+		struct io_uring_cqe *cqe;
+                int res;
+
+                ret = io_uring_peek_cqe(ring, &cqe);
+                res = cqe->res;
+                if (ret) {
+                        fprintf(stderr, "peek failed: %d\n", ret);
+                        return ret;
+                }
+                io_uring_cqe_seen(ring, cqe);
+                if (res != BUF_SIZE)
+                        fprintf(stderr, "bad result %d, user_data %llx\n",
+					res, cqe->user_data);
+		//printf("cqe %lld res %d\n", cqe->user_data, cqe->res);
+        }
+
+	return 0;
+}
+
+static int prep_test(struct io_uring *ring, struct test_data *data)
+{
+	int ret, i;
+
+	data->fd_in = open(data->src_file, O_RDONLY | O_DIRECT, 0644);
+	if (data->fd_in < 0) {
+		perror("open in");
+		return 1;
+	}
+
+	data->fd_out1 = open(".test_group_cp1", O_RDWR | O_CREAT | O_DIRECT, 0644);
+	unlink(".test_group_cp1");
+
+	data->fd_out2 = open(".test_group_cp2", O_RDWR | O_CREAT| O_DIRECT, 0644);
+	unlink(".test_group_cp2");
+
+	if (data->fd_out1 < 0 || data->fd_out2 < 0) {
+		perror("open out");
+		return 1;
+	}
+
+	for (i = 0; i < BUFFERS; i++) {
+		void *buf;
+
+		assert(!posix_memalign(&buf, 4096, BUF_SIZE));
+		data->iov[i].iov_base = buf;
+		data->iov[i].iov_len = BUF_SIZE;
+		memset(data->iov[i].iov_base, 0, BUF_SIZE);
+	}
+
+	ret = io_uring_register_buffers(ring, data->iov, BUFFERS);
+	if (ret) {
+		fprintf(stderr, "Error registering buffers: %s",
+				strerror(-ret));
+		return 1;
+	}
+
+	return 0;
+}
+
+static void unprep_test(struct io_uring *ring, struct test_data *d)
+{
+	io_uring_unregister_buffers(ring);
+	close(d->fd_in);
+	close(d->fd_out1);
+	close(d->fd_out2);
+}
+
+static unsigned build_group_sqes(struct io_uring *ring, struct test_data *d,
+	off_t off, int buf_idx, __u8 lead_flags, __u8 mem_flags)
+{
+	struct io_uring_sqe *sqe, *sqe2, *sqe1;
+
+	sqe = io_uring_get_sqe(ring);
+	sqe1 = io_uring_get_sqe(ring);
+	sqe2 = io_uring_get_sqe(ring);
+	assert(sqe && sqe1 && sqe2);
+
+	io_uring_prep_read_fixed(sqe, d->fd_in, d->iov[buf_idx].iov_base,
+			BUF_SIZE, 0, buf_idx);
+	set_sqe_group(sqe);
+	sqe->user_data = buf_idx + 1;
+	sqe->flags |= lead_flags;
+
+	io_uring_prep_write_fixed(sqe1, d->fd_out1, d->iov[buf_idx].iov_base,
+			BUF_SIZE, off, buf_idx);
+	set_sqe_group(sqe1);
+	sqe1->user_data = buf_idx + 2;
+	sqe1->flags |= mem_flags;
+
+	io_uring_prep_write_fixed(sqe2, d->fd_out2, d->iov[buf_idx].iov_base,
+			BUF_SIZE, off, buf_idx);
+	sqe2->user_data = buf_idx + 3;
+	sqe2->flags |= mem_flags;
+
+	return 3;
+}
+
+static int verify_cp(struct io_uring *ring, struct test_data *d, off_t off,
+		unsigned int buf_idx)
+{
+	struct io_uring_sqe *sqe2, *sqe1;
+	int ret;
+
+	sqe1 = io_uring_get_sqe(ring);
+	sqe2 = io_uring_get_sqe(ring);
+	assert(sqe1 && sqe2);
+
+	io_uring_prep_read_fixed(sqe1, d->fd_out1, d->iov[buf_idx + 1].iov_base,
+			BUF_SIZE, off, buf_idx + 1);
+	sqe1->user_data = buf_idx + 7;
+	io_uring_prep_read_fixed(sqe2, d->fd_out2, d->iov[buf_idx + 2].iov_base,
+			BUF_SIZE, off, buf_idx + 2);
+	sqe1->user_data = buf_idx + 8;
+	ret = io_uring_submit_and_wait(ring, 2);
+	if (ret < 0) {
+                fprintf(stderr, "submit failed: %d\n", ret);
+                return 1;
+        }
+
+	ret = check_cqe(ring, 2);
+	if (ret)
+		return ret;
+
+	if (memcmp(d->iov[buf_idx].iov_base, d->iov[buf_idx + 1].iov_base, BUF_SIZE)) {
+		fprintf(stderr, "data not match for destination 1\n");
+		return 1;
+	}
+
+	if (memcmp(d->iov[buf_idx].iov_base, d->iov[buf_idx + 2].iov_base, BUF_SIZE)) {
+		fprintf(stderr, "data not match for destination 2\n");
+		return 1;
+	}
+	return 0;
+}
+
+static int test(struct io_uring *ring, struct test_data *d,
+		__u8 lead_flags, __u8 mem_flags)
+{
+	unsigned test_link = lead_flags & IOSQE_IO_LINK;
+	unsigned nr;
+	int ret;
+
+	if (!test_link) {
+		nr = build_group_sqes(ring, d, 0, 0, lead_flags, mem_flags);
+	} else {
+		/* two groups linked together */
+		nr = build_group_sqes(ring, d, 0, 0, lead_flags, mem_flags);
+		nr += build_group_sqes(ring, d, BUF_SIZE, 3, lead_flags,
+				mem_flags);
+	}
+
+	ret = io_uring_submit_and_wait(ring, nr);
+	if (ret < 0) {
+                fprintf(stderr, "submit failed: %d\n", ret);
+                return 1;
+        }
+
+	if (check_cqe(ring, nr))
+                return 1;
+
+	ret = verify_cp(ring, d, 0, 0);
+	if (ret)
+		return ret;
+	if (test_link)
+		return verify_cp(ring, d, BUF_SIZE, 3);
+	return 0;
+}
+
+static int run_test(struct io_uring *ring, struct test_data *d,
+		__u8 lead_flags, __u8 mem_flags)
+{
+	int ret = test(ring, d, lead_flags, mem_flags);
+	if (ret) {
+		fprintf(stderr, "Test failed lead flags %x mem flags %x\n",
+				lead_flags, mem_flags);
+		return T_EXIT_FAIL;
+	}
+
+	exit(0);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	struct test_data data = {
+		.src_file = argv[0],
+	};
+	int ret;
+	int g_link, g_async, m_async;
+
+	if (argc > 1)
+		return T_EXIT_SKIP;
+
+	ret = t_create_ring(16, &ring, 0);
+	if (ret == T_SETUP_SKIP)
+		return T_EXIT_SKIP;
+	else if (ret < 0)
+		return T_EXIT_FAIL;
+
+	ret = prep_test(&ring, &data);
+	if (ret) {
+		fprintf(stderr, "Prepare Test failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	for (g_async = 0; g_async < 2; g_async += 1)
+		for (g_link = 0; g_link < 2; g_link += 1)
+			for (m_async = 0; m_async < 2; m_async += 1) {
+				__u8 g_flags = (g_async ? IOSQE_ASYNC : 0) |
+					(g_link ? IOSQE_IO_LINK : 0);
+				__u8 m_flags = (g_async ? IOSQE_ASYNC : 0);
+
+				if (run_test(&ring, &data, g_flags, m_flags))
+					return T_EXIT_FAIL;
+			}
+	unprep_test(&ring, &data);
+
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+}
-- 
2.41.0


