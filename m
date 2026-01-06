Return-Path: <io-uring+bounces-11411-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EAFA4CF7B4E
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:13:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id EBD13304F67E
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:12:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2CEF730F951;
	Tue,  6 Jan 2026 10:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UgEgJosI"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3C9B309EF0
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694350; cv=none; b=F4fTE2i/sh2hAPrLFyNfap7vRdCmlB1FNBwzzE+o0AAyqQbIuOYjOwNS4ZJQZo2+kR66HBre9ZPwcnZ1zWzYg0fpjDXZ73Tqg7rDYycDR5GS70ndGjx1LWQZNEvfxXuzEs1ZU+WTRSFRtfx5bA+nj5aGx7XsQj3fIH/sNiCVUTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694350; c=relaxed/simple;
	bh=fP/tV0oGrLLg1xYjSyQve8N7z96VFRel6sLWRTxpMes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LP2+Ft42kR1/xKGtz05NWviQeoziVxnV1dIq4QIp7pIcyNpcWbqYJW7jRi78lrFAU/m5Kocr/8aBaNNTfXOLrJ+566jiBDNFDKEOfz6LneiFLal8ooajadLXk090Jm4QIeOG8AvW8oBFsLw0LNCTTnMNkA6dzcBSDM/J+djqaQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UgEgJosI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694346;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+R1m11LRJ3ZWNzkJ/kWHjpfmPq41guWVgzXp44wx5UI=;
	b=UgEgJosI8bcIUYVIpQatG/Q/aHECvOVslMrP+tCPnbwoKaIptVj9eT3KCMHJUqBMy7Wh6b
	ofCNoHswZrvytQox2lCjtZ8tNA5AGE7qRJ/Ke/toBWg0HRAuN5k/RN6BFagP+aq92IfVAP
	Hh2k9aMblMaNIGn4ci30n1PMkB5myGQ=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-39-yR1ldSjFPZ6ZvzvfRyXP1g-1; Tue,
 06 Jan 2026 05:12:23 -0500
X-MC-Unique: yR1ldSjFPZ6ZvzvfRyXP1g-1
X-Mimecast-MFC-AGG-ID: yR1ldSjFPZ6ZvzvfRyXP1g_1767694342
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7CCE9195DE48;
	Tue,  6 Jan 2026 10:12:22 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 6F0D619560AB;
	Tue,  6 Jan 2026 10:12:20 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 11/13] selftests/io_uring: add bpf_memcpy selftest for uring_bpf_memcpy() kfunc
Date: Tue,  6 Jan 2026 18:11:20 +0800
Message-ID: <20260106101126.4064990-12-ming.lei@redhat.com>
In-Reply-To: <20260106101126.4064990-1-ming.lei@redhat.com>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Add a selftest to verify the uring_bpf_memcpy() kfunc works correctly
with different buffer types. The test uses BPF struct_ops to implement
prep/issue/fail/cleanup operations for the IORING_OP_BPF opcode.

Three test cases are included:
- copy_user_to_user(): Tests IO_BPF_BUF_USER buffer type (flat userspace
  buffer) for both source and destination
- copy_vec_to_vec(): Tests IO_BPF_BUF_VEC buffer type (iovec array split
  into multiple chunks) for both source and destination
- copy_user_to_vec(): Tests mixed buffer types with USER source and VEC
  destination

All tests allocate source/destination buffers, fill the source with a
pattern, invoke uring_bpf_memcpy() via io_uring submission, and verify
the copy succeeded by checking CQE result and destination buffer contents.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 tools/testing/selftests/io_uring/Makefile     |   1 +
 .../selftests/io_uring/bpf_memcpy.bpf.c       |  98 +++++
 tools/testing/selftests/io_uring/bpf_memcpy.c | 374 ++++++++++++++++++
 3 files changed, 473 insertions(+)
 create mode 100644 tools/testing/selftests/io_uring/bpf_memcpy.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/bpf_memcpy.c

diff --git a/tools/testing/selftests/io_uring/Makefile b/tools/testing/selftests/io_uring/Makefile
index f88a6a749484..e1fa77b0a000 100644
--- a/tools/testing/selftests/io_uring/Makefile
+++ b/tools/testing/selftests/io_uring/Makefile
@@ -150,6 +150,7 @@ all_test_bpfprogs := $(foreach prog,$(wildcard *.bpf.c),$(INCLUDE_DIR)/$(patsubs
 
 auto-test-targets :=			\
 	basic_bpf_ops			\
+	bpf_memcpy			\
 
 testcase-targets := $(addsuffix .o,$(addprefix $(IOUOBJ_DIR)/,$(auto-test-targets)))
 
diff --git a/tools/testing/selftests/io_uring/bpf_memcpy.bpf.c b/tools/testing/selftests/io_uring/bpf_memcpy.bpf.c
new file mode 100644
index 000000000000..d8056de639c1
--- /dev/null
+++ b/tools/testing/selftests/io_uring/bpf_memcpy.bpf.c
@@ -0,0 +1,98 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2025 Red Hat, Inc.
+ * Test for uring_bpf_memcpy() kfunc.
+ *
+ * This tests the uring_bpf_memcpy() kfunc with USER buffer type,
+ * copying data between two userspace buffers.
+ *
+ * Buffer descriptors are passed via sqe->addr as an array of two
+ * io_bpf_buf_desc structures:
+ *   [0] = source buffer descriptor
+ *   [1] = destination buffer descriptor
+ * sqe->len contains the number of descriptors (2).
+ */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <asm-generic/errno.h>
+
+char LICENSE[] SEC("license") = "GPL";
+
+/* PDU layout for storing buffer descriptors between prep and issue */
+struct memcpy_pdu {
+	struct io_bpf_buf_desc descs[2];  /* [0]=src, [1]=dst */
+};
+
+/* kfunc declarations */
+extern void uring_bpf_set_result(struct uring_bpf_data *data, int res) __ksym;
+extern int uring_bpf_read_buf_descs(struct io_bpf_buf_desc *descs,
+				    __u64 user_addr, int nr_descs) __ksym;
+extern __s64 uring_bpf_memcpy(const struct uring_bpf_data *data,
+			      struct io_bpf_buf_desc *dst,
+			      struct io_bpf_buf_desc *src) __ksym;
+
+SEC("struct_ops/memcpy_prep")
+int BPF_PROG(memcpy_prep, struct uring_bpf_data *data,
+	     const struct io_uring_sqe *sqe)
+{
+	struct memcpy_pdu *pdu = (struct memcpy_pdu *)data->pdu;
+	struct io_bpf_buf_desc descs[2];
+	int ret;
+
+	/* Validate descriptor count */
+	if (sqe->len != 2)
+		return -EINVAL;
+
+	ret = bpf_probe_read_user(descs, sizeof(descs), (void *)sqe->addr);
+	if (ret) {
+		bpf_printk("memcpy_prep: uring_bpf_read_buf_descs failed: %d", ret);
+		return ret;
+	}
+
+	__builtin_memcpy(&pdu->descs, &descs, sizeof(descs));
+	bpf_printk("memcpy_prep: src=0x%llx dst=0x%llx len=%u",
+		   pdu->descs[0].addr, pdu->descs[1].addr, pdu->descs[0].len);
+	return 0;
+}
+
+SEC("struct_ops/memcpy_issue")
+int BPF_PROG(memcpy_issue, struct uring_bpf_data *data)
+{
+	struct memcpy_pdu *pdu = (struct memcpy_pdu *)data->pdu;
+	struct io_bpf_buf_desc dst_desc, src_desc;
+	__s64 ret;
+
+	/* Copy descriptors to stack to satisfy verifier type checking */
+	src_desc = pdu->descs[0];
+	dst_desc = pdu->descs[1];
+
+	/* Call uring_bpf_memcpy() kfunc using stack-based descriptors */
+	ret = uring_bpf_memcpy(data, &dst_desc, &src_desc);
+
+	bpf_printk("memcpy_issue: uring_bpf_memcpy returned %lld", ret);
+
+	uring_bpf_set_result(data, (int)ret);
+	return 0;
+}
+
+SEC("struct_ops/memcpy_fail")
+void BPF_PROG(memcpy_fail, struct uring_bpf_data *data)
+{
+	bpf_printk("memcpy_fail: invoked");
+}
+
+SEC("struct_ops/memcpy_cleanup")
+void BPF_PROG(memcpy_cleanup, struct uring_bpf_data *data)
+{
+	bpf_printk("memcpy_cleanup: invoked");
+}
+
+SEC(".struct_ops.link")
+struct uring_bpf_ops bpf_memcpy_ops = {
+	.prep_fn	= (void *)memcpy_prep,
+	.issue_fn	= (void *)memcpy_issue,
+	.fail_fn	= (void *)memcpy_fail,
+	.cleanup_fn	= (void *)memcpy_cleanup,
+};
diff --git a/tools/testing/selftests/io_uring/bpf_memcpy.c b/tools/testing/selftests/io_uring/bpf_memcpy.c
new file mode 100644
index 000000000000..0fad6d0583c3
--- /dev/null
+++ b/tools/testing/selftests/io_uring/bpf_memcpy.c
@@ -0,0 +1,374 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2025 Red Hat, Inc.
+ * Test for uring_bpf_memcpy() kfunc - userspace part.
+ */
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <errno.h>
+#include <linux/io_uring.h>
+#include <sys/uio.h>
+#include <io_uring/mini_liburing.h>
+
+#include "iou_test.h"
+#include "bpf_memcpy.bpf.skel.h"
+
+#define TEST_BUF_SIZE		(4096 * 4 + 1024 + 511)
+#define TEST_PATTERN		0xAB
+#define MAX_VECS		32
+
+struct test_ctx {
+	struct bpf_memcpy *skel;
+	struct bpf_link *link;
+	struct io_uring ring;
+
+	/* Buffer descriptors and buffers */
+	struct io_bpf_buf_desc descs[2];
+	char *src_buf;
+	char *dst_buf;
+	size_t src_buf_size;
+	size_t dst_buf_size;
+	__u8 src_type;
+	__u8 dst_type;
+	const char *desc;
+
+	/* Vectored buffer support */
+	struct iovec src_vec[MAX_VECS];
+	struct iovec dst_vec[MAX_VECS];
+	int src_nr_vec;
+	int dst_nr_vec;
+};
+
+static enum iou_test_status bpf_setup(struct test_ctx *ctx)
+{
+	int ret;
+
+	/* Load BPF skeleton */
+	ctx->skel = bpf_memcpy__open();
+	if (!ctx->skel) {
+		IOU_ERR("Failed to open BPF skeleton");
+		return IOU_TEST_FAIL;
+	}
+
+	/* Set ring_fd in struct_ops before loading */
+	ctx->skel->struct_ops.bpf_memcpy_ops->ring_fd = ctx->ring.ring_fd;
+	ctx->skel->struct_ops.bpf_memcpy_ops->id = 0;
+
+	ret = bpf_memcpy__load(ctx->skel);
+	if (ret) {
+		IOU_ERR("Failed to load BPF skeleton: %d", ret);
+		bpf_memcpy__destroy(ctx->skel);
+		ctx->skel = NULL;
+		return IOU_TEST_FAIL;
+	}
+
+	/* Attach struct_ops */
+	ctx->link = bpf_map__attach_struct_ops(ctx->skel->maps.bpf_memcpy_ops);
+	if (!ctx->link) {
+		IOU_ERR("Failed to attach struct_ops");
+		bpf_memcpy__destroy(ctx->skel);
+		ctx->skel = NULL;
+		return IOU_TEST_FAIL;
+	}
+
+	return IOU_TEST_PASS;
+}
+
+static enum iou_test_status setup(void **ctx_out)
+{
+	struct io_uring_params p;
+	struct test_ctx *ctx;
+	enum iou_test_status status;
+	int ret;
+
+	ctx = calloc(1, sizeof(*ctx));
+	if (!ctx) {
+		IOU_ERR("Failed to allocate context");
+		return IOU_TEST_FAIL;
+	}
+
+	/* Setup io_uring ring with BPF_OP flag */
+	memset(&p, 0, sizeof(p));
+	p.flags = IORING_SETUP_BPF_OP | IORING_SETUP_NO_SQARRAY;
+
+	ret = io_uring_queue_init_params(8, &ctx->ring, &p);
+	if (ret < 0) {
+		IOU_ERR("io_uring_queue_init_params failed: %s (flags=0x%x)",
+			strerror(-ret), p.flags);
+		free(ctx);
+		return IOU_TEST_SKIP;
+	}
+
+	status = bpf_setup(ctx);
+	if (status != IOU_TEST_PASS) {
+		io_uring_queue_exit(&ctx->ring);
+		free(ctx);
+		return status;
+	}
+
+	*ctx_out = ctx;
+	return IOU_TEST_PASS;
+}
+
+static int allocate_buf(char **buf, size_t size, __u8 buf_type,
+			struct iovec *vec, int nr_vec)
+{
+	char *p;
+	size_t chunk_size;
+	int i;
+
+	switch (buf_type) {
+	case IO_BPF_BUF_USER:
+		p = aligned_alloc(4096, size);
+		if (!p)
+			return -ENOMEM;
+		*buf = p;
+		return 0;
+	case IO_BPF_BUF_VEC:
+		if (nr_vec <= 0 || nr_vec > MAX_VECS)
+			return -EINVAL;
+		p = aligned_alloc(4096, size);
+		if (!p)
+			return -ENOMEM;
+		*buf = p;
+		/* Split buffer into nr_vec pieces */
+		chunk_size = size / nr_vec;
+		for (i = 0; i < nr_vec; i++) {
+			vec[i].iov_base = p + i * chunk_size;
+			vec[i].iov_len = chunk_size;
+		}
+		/* Last chunk gets remainder */
+		vec[nr_vec - 1].iov_len += size % nr_vec;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static void free_buf(char *buf, __u8 buf_type)
+{
+	switch (buf_type) {
+	case IO_BPF_BUF_USER:
+	case IO_BPF_BUF_VEC:
+		free(buf);
+		break;
+	default:
+		break;
+	}
+}
+
+static enum iou_test_status allocate_bufs(struct test_ctx *ctx)
+{
+	int ret;
+
+	ret = allocate_buf(&ctx->src_buf, ctx->src_buf_size, ctx->src_type,
+			   ctx->src_vec, ctx->src_nr_vec);
+	if (ret) {
+		IOU_ERR("Failed to allocate source buffer: %d", ret);
+		return IOU_TEST_FAIL;
+	}
+
+	ret = allocate_buf(&ctx->dst_buf, ctx->dst_buf_size, ctx->dst_type,
+			   ctx->dst_vec, ctx->dst_nr_vec);
+	if (ret) {
+		IOU_ERR("Failed to allocate destination buffer: %d", ret);
+		free_buf(ctx->src_buf, ctx->src_type);
+		ctx->src_buf = NULL;
+		return IOU_TEST_FAIL;
+	}
+
+	/* Initialize source buffer with pattern, destination with zeros */
+	memset(ctx->src_buf, TEST_PATTERN, ctx->src_buf_size);
+	memset(ctx->dst_buf, 0, ctx->dst_buf_size);
+
+	/* Build buffer descriptors */
+	memset(ctx->descs, 0, sizeof(ctx->descs));
+	ctx->descs[0].type = ctx->src_type;
+	ctx->descs[1].type = ctx->dst_type;
+
+	if (ctx->src_type == IO_BPF_BUF_VEC) {
+		ctx->descs[0].addr = (__u64)(uintptr_t)ctx->src_vec;
+		ctx->descs[0].len = ctx->src_nr_vec;
+	} else {
+		ctx->descs[0].addr = (__u64)(uintptr_t)ctx->src_buf;
+		ctx->descs[0].len = ctx->src_buf_size;
+	}
+
+	if (ctx->dst_type == IO_BPF_BUF_VEC) {
+		ctx->descs[1].addr = (__u64)(uintptr_t)ctx->dst_vec;
+		ctx->descs[1].len = ctx->dst_nr_vec;
+	} else {
+		ctx->descs[1].addr = (__u64)(uintptr_t)ctx->dst_buf;
+		ctx->descs[1].len = ctx->dst_buf_size;
+	}
+
+	return IOU_TEST_PASS;
+}
+
+static void free_bufs(struct test_ctx *ctx)
+{
+	if (ctx->src_buf) {
+		free_buf(ctx->src_buf, ctx->src_type);
+		ctx->src_buf = NULL;
+	}
+	if (ctx->dst_buf) {
+		free_buf(ctx->dst_buf, ctx->dst_type);
+		ctx->dst_buf = NULL;
+	}
+}
+
+static enum iou_test_status submit_and_wait(struct test_ctx *ctx)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	/* Get an SQE and prepare BPF op request */
+	sqe = io_uring_get_sqe(&ctx->ring);
+	if (!sqe) {
+		IOU_ERR("Failed to get SQE");
+		return IOU_TEST_FAIL;
+	}
+
+	memset(sqe, 0, sizeof(*sqe));
+	sqe->opcode = IORING_OP_BPF;
+	sqe->fd = -1;
+	sqe->bpf_op_flags = (0 << IORING_BPF_OP_SHIFT); /* BPF op id = 0 */
+	sqe->addr = (__u64)(uintptr_t)ctx->descs;
+	sqe->len = 2;  /* number of descriptors */
+	sqe->user_data = 0xCAFEBABE;
+
+	/* Submit and wait for completion */
+	ret = io_uring_submit(&ctx->ring);
+	if (ret < 0) {
+		IOU_ERR("io_uring_submit failed: %d", ret);
+		return IOU_TEST_FAIL;
+	}
+
+	ret = io_uring_wait_cqe(&ctx->ring, &cqe);
+	if (ret < 0) {
+		IOU_ERR("io_uring_wait_cqe failed: %d", ret);
+		return IOU_TEST_FAIL;
+	}
+
+	/* Verify CQE */
+	if (cqe->user_data != 0xCAFEBABE) {
+		IOU_ERR("CQE user_data mismatch: 0x%llx", cqe->user_data);
+		return IOU_TEST_FAIL;
+	}
+
+	if (cqe->res != (int)ctx->src_buf_size) {
+		IOU_ERR("CQE result mismatch: %d (expected %zu)",
+			cqe->res, ctx->src_buf_size);
+		if (cqe->res < 0)
+			IOU_ERR("Error from uring_bpf_memcpy: %s", strerror(-cqe->res));
+		return IOU_TEST_FAIL;
+	}
+
+	io_uring_cqe_seen(&ctx->ring);
+
+	/* Verify destination buffer contains the pattern */
+	for (size_t i = 0; i < ctx->dst_buf_size; i++) {
+		if ((unsigned char)ctx->dst_buf[i] != TEST_PATTERN) {
+			IOU_ERR("Data mismatch at offset %zu: 0x%02x (expected 0x%02x)",
+				i, (unsigned char)ctx->dst_buf[i], TEST_PATTERN);
+			return IOU_TEST_FAIL;
+		}
+	}
+
+	return IOU_TEST_PASS;
+}
+
+static enum iou_test_status test_copy(struct test_ctx *ctx)
+{
+	enum iou_test_status status;
+
+	status = allocate_bufs(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
+	status = submit_and_wait(ctx);
+	free_bufs(ctx);
+
+	if (status == IOU_TEST_PASS)
+		IOU_INFO("%s: copied %zu bytes", ctx->desc, ctx->src_buf_size);
+
+	return status;
+}
+
+static enum iou_test_status copy_user_to_user(struct test_ctx *ctx)
+{
+	ctx->src_type = IO_BPF_BUF_USER;
+	ctx->dst_type = IO_BPF_BUF_USER;
+	ctx->src_buf_size = TEST_BUF_SIZE;
+	ctx->dst_buf_size = TEST_BUF_SIZE;
+	ctx->desc = "USER -> USER";
+
+	return test_copy(ctx);
+}
+
+static enum iou_test_status copy_vec_to_vec(struct test_ctx *ctx)
+{
+	ctx->src_type = IO_BPF_BUF_VEC;
+	ctx->dst_type = IO_BPF_BUF_VEC;
+	ctx->src_buf_size = TEST_BUF_SIZE;
+	ctx->dst_buf_size = TEST_BUF_SIZE;
+	ctx->src_nr_vec = 4;
+	ctx->dst_nr_vec = 4;
+	ctx->desc = "VEC -> VEC";
+
+	return test_copy(ctx);
+}
+
+static enum iou_test_status copy_user_to_vec(struct test_ctx *ctx)
+{
+	ctx->src_type = IO_BPF_BUF_USER;
+	ctx->dst_type = IO_BPF_BUF_VEC;
+	ctx->src_buf_size = TEST_BUF_SIZE;
+	ctx->dst_buf_size = TEST_BUF_SIZE;
+	ctx->dst_nr_vec = 4;
+	ctx->desc = "USER -> VEC";
+
+	return test_copy(ctx);
+}
+
+static enum iou_test_status run(void *ctx_ptr)
+{
+	struct test_ctx *ctx = ctx_ptr;
+	enum iou_test_status status;
+
+	status = copy_user_to_user(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
+	status = copy_vec_to_vec(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
+	status = copy_user_to_vec(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
+	return IOU_TEST_PASS;
+}
+
+static void cleanup(void *ctx_ptr)
+{
+	struct test_ctx *ctx = ctx_ptr;
+
+	if (ctx->link)
+		bpf_link__destroy(ctx->link);
+	if (ctx->skel)
+		bpf_memcpy__destroy(ctx->skel);
+	io_uring_queue_exit(&ctx->ring);
+	free(ctx);
+}
+
+struct iou_test bpf_memcpy_test = {
+	.name = "bpf_memcpy",
+	.description = "Test uring_bpf_memcpy() kfunc with USER, VEC, and mixed buffer types",
+	.setup = setup,
+	.run = run,
+	.cleanup = cleanup,
+};
+REGISTER_IOU_TEST(bpf_memcpy_test)
-- 
2.47.0


