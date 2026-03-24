Return-Path: <io-uring+bounces-12832-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +IrkATjAwmnalQQAu9opvQ
	(envelope-from <io-uring+bounces-12832-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:47:52 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A9BB319538
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:47:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 28ADD310C7A2
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 16:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EE803E5EC5;
	Tue, 24 Mar 2026 16:39:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OTQlTudy"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DAE43DDDCD
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 16:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774370340; cv=none; b=tyjmbLdsBkKCtKpoX21OHG1vt2JR/eMwkyvYgFtmZ/iIvRHoY1+lZXFbJOGagYI/NLZS2ly6lzYLQE0rOvT4mJUjAGg8NpNI/+Tu0Wp1BYhpm0e5PJrUMcPLn6G8b8uWYFO/w/Q3MOQSzl78PhMw+nT87/FjoXK/MK6h65sOnlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774370340; c=relaxed/simple;
	bh=QR/11BOB7XidAxtqZVb5rymM/vanBJalh0WNjgy+HU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EF+ro31pm1fOjcf+sjC0HG2KIgwHBW5wp0pK1KhgzUC5+KpSo18AHsNB7v6gCniB356HWDc1xllFbRyjFgSMT/fe6VFichSFf49UQZvADuYg03Vc++PPlpqGg0BrGQZ2+FLpCI3vf0B9gtLWYYbNUSYUgHkRlejE7p4x/gIzzcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OTQlTudy; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774370337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8wTRI3ILggGsnM3N8dW363SNoxZ0/c2S5v7pbzDMDxo=;
	b=OTQlTudynIx299+SKDGzXYpmCAQPQjJe5iFh8cd/CdXfhsrsOHHMNv6bcvk9SL9od8rASS
	haD7dvcDKSo1Oy8gSwWVxkPHSUrig1NRd/pliLOE8S5Vt4eM128tXqRSPJVgct1PKbHv8R
	s0jC/wWRGByxaK4Zv8r+trDMBaMSloI=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-459-y-QiNMhgN6C3zLbJnHU2eQ-1; Tue,
 24 Mar 2026 12:38:54 -0400
X-MC-Unique: y-QiNMhgN6C3zLbJnHU2eQ-1
X-Mimecast-MFC-AGG-ID: y-QiNMhgN6C3zLbJnHU2eQ_1774370333
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id ED2291956056;
	Tue, 24 Mar 2026 16:38:52 +0000 (UTC)
Received: from localhost (unknown [10.72.116.133])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1F8701955D71;
	Tue, 24 Mar 2026 16:38:51 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 12/12] selftests/io_uring: add buffer iterator selftest with BPF arena
Date: Wed, 25 Mar 2026 00:37:33 +0800
Message-ID: <20260324163753.1900977-13-ming.lei@redhat.com>
In-Reply-To: <20260324163753.1900977-1-ming.lei@redhat.com>
References: <20260324163753.1900977-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12832-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 9A9BB319538
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add bpf_ext_memcpy test for per-buffer iterator kfuncs with dynptr.
Tests both read (buffer -> arena) and write (arena -> buffer)
directions across all buffer types (USER, VEC, FIXED, REG_VEC)
with 1MB+ buffers.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 tools/testing/selftests/Makefile              |   3 +-
 .../selftests/io_uring/bpf_ext_memcpy.bpf.c   | 305 +++++++++++
 .../selftests/io_uring/bpf_ext_memcpy.c       | 517 ++++++++++++++++++
 .../io_uring/include/bpf_ext_memcpy_defs.h    |  18 +
 4 files changed, 842 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/io_uring/bpf_ext_memcpy.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/bpf_ext_memcpy.c
 create mode 100644 tools/testing/selftests/io_uring/include/bpf_ext_memcpy_defs.h

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 450f13ba4cca..e8d01d62f1ac 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -45,6 +45,7 @@ TARGETS += futex
 TARGETS += gpio
 TARGETS += hid
 TARGETS += intel_pstate
+TARGETS += io_uring
 TARGETS += iommu
 TARGETS += ipc
 TARGETS += ir
@@ -148,7 +149,7 @@ endif
 # User can optionally provide a TARGETS skiplist. By default we skip
 # targets using BPF since it has cutting edge build time dependencies
 # which require more effort to install.
-SKIP_TARGETS ?= bpf sched_ext
+SKIP_TARGETS ?= bpf io_uring sched_ext
 ifneq ($(SKIP_TARGETS),)
 	TMP := $(filter-out $(SKIP_TARGETS), $(TARGETS))
 	override TARGETS := $(TMP)
diff --git a/tools/testing/selftests/io_uring/bpf_ext_memcpy.bpf.c b/tools/testing/selftests/io_uring/bpf_ext_memcpy.bpf.c
new file mode 100644
index 000000000000..451c04f82e93
--- /dev/null
+++ b/tools/testing/selftests/io_uring/bpf_ext_memcpy.bpf.c
@@ -0,0 +1,305 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2025 Red Hat, Inc.
+ * Test for per-buffer iterator kfuncs (KF_ITER pattern) with dynptr.
+ *
+ * Two operations registered as struct_ops:
+ *   op_id=0: copy buffer → arena  (ITER_SOURCE + bpf_dynptr_slice read)
+ *   op_id=1: copy arena → buffer  (ITER_DEST   + bpf_dynptr_data write)
+ *
+ * sqe->addr points to a single io_bpf_buf_desc.
+ * sqe->len = 1.
+ */
+
+#include "vmlinux.h"
+#include <bpf/bpf_helpers.h>
+#include <bpf/bpf_tracing.h>
+#include <asm-generic/errno.h>
+
+char LICENSE[] SEC("license") = "GPL";
+
+#if defined(__BPF_FEATURE_ADDR_SPACE_CAST)
+#define __arena __attribute__((address_space(1)))
+#define cast_kern(ptr) /* nop for bpf prog */
+#define cast_user(ptr) /* nop for bpf prog */
+#else
+#define __arena
+#define cast_kern(ptr) bpf_addr_space_cast(ptr, 0, 1)
+#define cast_user(ptr) bpf_addr_space_cast(ptr, 1, 0)
+#endif
+
+#ifndef PAGE_SIZE
+#define PAGE_SIZE __PAGE_SIZE
+#endif
+
+#include "include/bpf_ext_memcpy_defs.h"
+
+struct {
+	__uint(type, BPF_MAP_TYPE_ARENA);
+	__uint(map_flags, BPF_F_MMAPABLE);
+	__uint(max_entries, 2048);
+#ifdef __TARGET_ARCH_arm64
+	__ulong(map_extra, 0x1ull << 32);
+#else
+	__ulong(map_extra, 0x1ull << 44);
+#endif
+} arena SEC(".maps");
+
+/* Arena buffer — set by userspace, shared by read and write ops */
+unsigned char __arena *arena_buf;
+
+/* PDU layout — shared by both ops */
+struct memcpy_pdu {
+	struct io_bpf_buf_desc desc;
+};
+
+/* kfunc declarations */
+
+extern void uring_bpf_set_result(struct uring_bpf_data *data, int res) __ksym;
+extern int bpf_iter_uring_buf_new(struct bpf_iter_uring_buf *iter,
+				  struct uring_bpf_data *data,
+				  struct io_bpf_buf_desc *desc,
+				  int direction) __ksym;
+extern int *bpf_iter_uring_buf_next(
+				  struct bpf_iter_uring_buf *iter) __ksym;
+extern void bpf_iter_uring_buf_destroy(struct bpf_iter_uring_buf *iter) __ksym;
+extern int bpf_uring_buf_dynptr(struct bpf_iter_uring_buf *it__iter,
+				struct bpf_dynptr *ptr__uninit) __ksym;
+extern int bpf_uring_buf_dynptr_rdwr(struct bpf_iter_uring_buf *it__iter,
+				     struct bpf_dynptr *ptr__uninit) __ksym;
+extern __u64 bpf_dynptr_size(const struct bpf_dynptr *ptr) __ksym;
+extern void *bpf_dynptr_slice(const struct bpf_dynptr *ptr, __u64 offset,
+			      void *buffer, __u64 buffer__szk) __ksym;
+void __arena *bpf_arena_alloc_pages(void *map, void __arena *addr,
+				    __u32 page_cnt, int node_id,
+				    __u64 flags) __ksym __weak;
+
+/* Word-copy helpers (__noinline: verified once by verifier) */
+
+static __noinline int
+copy_to_arena(unsigned char *src, unsigned char __arena *dst, int len)
+{
+	__u64 *s = (__u64 *)src;
+	__u64 *d = (__u64 *)dst;
+	int j;
+
+	for (j = 0; j < len / 8 && j < PAGE_SIZE / 8; j++)
+		d[j] = s[j];
+	return 0;
+}
+
+static __noinline int
+copy_from_arena(unsigned char __arena *src, unsigned char *dst, int len)
+{
+	__u64 *s = (__u64 *)src;
+	__u64 *d = (__u64 *)dst;
+	int j;
+
+	for (j = 0; j < len / 8 && j < PAGE_SIZE / 8; j++)
+		d[j] = s[j];
+	return 0;
+}
+
+/* Shared prep: both ops read the same descriptor */
+
+SEC("struct_ops/common_prep")
+int BPF_PROG(common_prep, struct uring_bpf_data *data,
+	     const struct io_uring_sqe *sqe)
+{
+	struct memcpy_pdu *pdu = (struct memcpy_pdu *)data->pdu;
+	struct io_bpf_buf_desc desc;
+	int ret;
+
+	if (sqe->len != 1)
+		return -EINVAL;
+
+	ret = bpf_probe_read_user(&desc, sizeof(desc), (void *)sqe->addr);
+	if (ret)
+		return ret;
+
+	__builtin_memcpy(&pdu->desc, &desc, sizeof(desc));
+	return 0;
+}
+
+/* Read: buffer -> arena (ITER_SOURCE) */
+
+struct iter_ctx {
+	struct bpf_iter_uring_buf *it;
+	unsigned char __arena *arena;
+	int total;
+};
+
+static int read_one_page(u32 idx, struct iter_ctx *ctx)
+{
+	struct bpf_dynptr dynptr;
+	unsigned char *p;
+	int copied = 0;
+	int *avail_ptr;
+	int avail, i;
+
+	avail_ptr = bpf_iter_uring_buf_next(ctx->it);
+	if (!avail_ptr)
+		return 1;
+	avail = *avail_ptr;
+
+	if (bpf_uring_buf_dynptr(ctx->it, &dynptr))
+		return 1;
+
+	/* Fast path: full page */
+	if (avail >= PAGE_SIZE) {
+		p = bpf_dynptr_slice(&dynptr, 0, NULL, PAGE_SIZE);
+		if (p) {
+			copy_to_arena(p, ctx->arena + ctx->total, PAGE_SIZE);
+			ctx->total += PAGE_SIZE;
+			return 0;
+		}
+	}
+
+	/* Slow path: CHUNK_SIZE slices */
+	for (i = 0; i < PAGE_SIZE / CHUNK_SIZE; i++) {
+		p = bpf_dynptr_slice(&dynptr, copied, NULL, CHUNK_SIZE);
+		if (!p)
+			break;
+		copy_to_arena(p, ctx->arena + ctx->total + copied, CHUNK_SIZE);
+		copied += CHUNK_SIZE;
+	}
+
+	ctx->total += copied;
+	return copied ? 0 : 1;
+}
+
+SEC("struct_ops/copy_to_arena_issue")
+int BPF_PROG(copy_to_arena_issue, struct uring_bpf_data *data)
+{
+	struct memcpy_pdu *pdu = (struct memcpy_pdu *)data->pdu;
+	struct io_bpf_buf_desc desc;
+	struct bpf_iter_uring_buf it;
+	unsigned char __arena *ptr = arena_buf;
+	int total = 0;
+
+	desc = pdu->desc;
+	bpf_arena_alloc_pages(&arena, NULL, 0, 0, 0);
+
+	if (!ptr) {
+		uring_bpf_set_result(data, -ENOMEM);
+		return 0;
+	}
+	cast_kern(ptr);
+
+	bpf_iter_uring_buf_new(&it, data, &desc, 1 /* ITER_SOURCE */);
+	{
+		struct iter_ctx ctx = { .it = &it, .arena = ptr };
+
+		bpf_loop(TEST_BUF_SIZE / PAGE_SIZE + 16, read_one_page,
+			 &ctx, 0);
+		total = ctx.total;
+	}
+	bpf_iter_uring_buf_destroy(&it);
+
+	uring_bpf_set_result(data, total);
+	return 0;
+}
+
+/* Write: arena -> buffer (ITER_DEST) */
+
+static int write_one_page(u32 idx, struct iter_ctx *ctx)
+{
+	struct bpf_dynptr dynptr;
+	unsigned char *p;
+	int copied = 0;
+	int *avail_ptr;
+	int avail, i;
+
+	avail_ptr = bpf_iter_uring_buf_next(ctx->it);
+	if (!avail_ptr)
+		return 1;
+	avail = *avail_ptr;
+
+	if (bpf_uring_buf_dynptr_rdwr(ctx->it, &dynptr))
+		return 1;
+
+	/* Fast path: full page */
+	if (avail >= PAGE_SIZE) {
+		p = bpf_dynptr_data(&dynptr, 0, PAGE_SIZE);
+		if (p) {
+			copy_from_arena(ctx->arena + ctx->total, p, PAGE_SIZE);
+			ctx->total += PAGE_SIZE;
+			return 0;
+		}
+	}
+
+	/* Slow path: CHUNK_SIZE blocks */
+	for (i = 0; i < PAGE_SIZE / CHUNK_SIZE; i++) {
+		p = bpf_dynptr_data(&dynptr, copied, CHUNK_SIZE);
+		if (!p)
+			break;
+		copy_from_arena(ctx->arena + ctx->total + copied, p,
+				CHUNK_SIZE);
+		copied += CHUNK_SIZE;
+	}
+
+	ctx->total += copied;
+	return copied ? 0 : 1;
+}
+
+SEC("struct_ops/copy_from_arena_issue")
+int BPF_PROG(copy_from_arena_issue, struct uring_bpf_data *data)
+{
+	struct memcpy_pdu *pdu = (struct memcpy_pdu *)data->pdu;
+	struct io_bpf_buf_desc desc;
+	struct bpf_iter_uring_buf it;
+	unsigned char __arena *ptr = arena_buf;
+	int total = 0;
+
+	desc = pdu->desc;
+	bpf_arena_alloc_pages(&arena, NULL, 0, 0, 0);
+
+	if (!ptr) {
+		uring_bpf_set_result(data, -ENOMEM);
+		return 0;
+	}
+	cast_kern(ptr);
+
+	bpf_iter_uring_buf_new(&it, data, &desc, 0 /* ITER_DEST */);
+	{
+		struct iter_ctx ctx = { .it = &it, .arena = ptr };
+
+		bpf_loop(TEST_BUF_SIZE / PAGE_SIZE + 16, write_one_page,
+			 &ctx, 0);
+		total = ctx.total;
+	}
+	bpf_iter_uring_buf_destroy(&it);
+
+	uring_bpf_set_result(data, total);
+	return 0;
+}
+
+/* Shared no-op callbacks */
+
+SEC("struct_ops/nop_fail")
+void BPF_PROG(nop_fail, struct uring_bpf_data *data)
+{
+}
+
+SEC("struct_ops/nop_cleanup")
+void BPF_PROG(nop_cleanup, struct uring_bpf_data *data)
+{
+}
+
+/* Struct ops registration */
+
+SEC(".struct_ops.link")
+struct uring_bpf_ops bpf_copy_to_arena_ops = {
+	.prep_fn	= (void *)common_prep,
+	.issue_fn	= (void *)copy_to_arena_issue,
+	.fail_fn	= (void *)nop_fail,
+	.cleanup_fn	= (void *)nop_cleanup,
+};
+
+SEC(".struct_ops.link")
+struct uring_bpf_ops bpf_copy_from_arena_ops = {
+	.prep_fn	= (void *)common_prep,
+	.issue_fn	= (void *)copy_from_arena_issue,
+	.fail_fn	= (void *)nop_fail,
+	.cleanup_fn	= (void *)nop_cleanup,
+};
diff --git a/tools/testing/selftests/io_uring/bpf_ext_memcpy.c b/tools/testing/selftests/io_uring/bpf_ext_memcpy.c
new file mode 100644
index 000000000000..c589eda27aae
--- /dev/null
+++ b/tools/testing/selftests/io_uring/bpf_ext_memcpy.c
@@ -0,0 +1,517 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * Copyright (c) 2025 Red Hat, Inc.
+ * Test for buffer iterator kfuncs - userspace part.
+ *
+ * Copies each supported source buffer type to BPF arena via
+ * direct byte access in the BPF program. Verifies arena contents.
+ */
+#include <bpf/bpf.h>
+#include <bpf/libbpf.h>
+#include <errno.h>
+#include <linux/io_uring.h>
+#include <sys/mman.h>
+#include <sys/uio.h>
+#include <io_uring/mini_liburing.h>
+
+#include "iou_test.h"
+#include "bpf_ext_memcpy.bpf.skel.h"
+
+#include "include/bpf_ext_memcpy_defs.h"
+#define TEST_PATTERN		0xAB
+#define MAX_VECS		32
+
+struct test_ctx {
+	struct bpf_ext_memcpy *skel;
+	struct bpf_link *link_read;	/* copy_to_arena ops (op_id=0) */
+	struct bpf_link *link_write;	/* copy_from_arena ops (op_id=1) */
+	void *arena_base;
+	size_t arena_sz;
+	struct io_uring ring;
+
+	/* Buffer under test */
+	struct io_bpf_buf_desc desc;
+	char *buf;
+	size_t buf_size;
+	__u8 buf_type;
+	const char *test_desc;
+
+	/* Vectored buffer support */
+	struct iovec vecs[MAX_VECS];
+	int nr_vec;
+
+	/* Fixed buffer support */
+	__u16 buf_index;
+};
+
+static enum iou_test_status bpf_setup(struct test_ctx *ctx)
+{
+	int arena_fd;
+	__u64 map_extra;
+	int ret;
+
+	ctx->skel = bpf_ext_memcpy__open();
+	if (!ctx->skel) {
+		IOU_ERR("Failed to open BPF skeleton");
+		return IOU_TEST_FAIL;
+	}
+
+	/* op_id 0 = copy_to_arena, op_id 1 = copy_from_arena */
+	ctx->skel->struct_ops.bpf_copy_to_arena_ops->ring_fd = ctx->ring.ring_fd;
+	ctx->skel->struct_ops.bpf_copy_to_arena_ops->id = 0;
+	ctx->skel->struct_ops.bpf_copy_from_arena_ops->ring_fd = ctx->ring.ring_fd;
+	ctx->skel->struct_ops.bpf_copy_from_arena_ops->id = 1;
+
+	ret = bpf_ext_memcpy__load(ctx->skel);
+	if (ret) {
+		IOU_ERR("Failed to load BPF skeleton: %d", ret);
+		bpf_ext_memcpy__destroy(ctx->skel);
+		ctx->skel = NULL;
+		return IOU_TEST_FAIL;
+	}
+
+	/* Pre-allocate arena pages from userspace */
+	arena_fd = bpf_map__fd(ctx->skel->maps.arena);
+	map_extra = bpf_map__map_extra(ctx->skel->maps.arena);
+	ctx->arena_sz = bpf_map__max_entries(ctx->skel->maps.arena)
+			* getpagesize();
+
+	ctx->arena_base = mmap(map_extra ? (void *)map_extra : NULL,
+			       ctx->arena_sz, PROT_READ | PROT_WRITE,
+			       MAP_SHARED | (map_extra ? MAP_FIXED : 0),
+			       arena_fd, 0);
+	if (ctx->arena_base == MAP_FAILED) {
+		IOU_ERR("Failed to mmap arena: %s", strerror(errno));
+		bpf_ext_memcpy__destroy(ctx->skel);
+		ctx->skel = NULL;
+		return IOU_TEST_FAIL;
+	}
+	memset(ctx->arena_base, 0, ctx->arena_sz);
+	ctx->skel->bss->arena_buf = ctx->arena_base;
+
+	ctx->link_read = bpf_map__attach_struct_ops(
+				ctx->skel->maps.bpf_copy_to_arena_ops);
+	if (!ctx->link_read) {
+		IOU_ERR("Failed to attach copy_to_arena struct_ops");
+		goto err;
+	}
+
+	ctx->link_write = bpf_map__attach_struct_ops(
+				ctx->skel->maps.bpf_copy_from_arena_ops);
+	if (!ctx->link_write) {
+		IOU_ERR("Failed to attach copy_from_arena struct_ops");
+		goto err;
+	}
+
+	return IOU_TEST_PASS;
+err:
+	bpf_ext_memcpy__destroy(ctx->skel);
+	ctx->skel = NULL;
+	return IOU_TEST_FAIL;
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
+	memset(&p, 0, sizeof(p));
+	p.flags = IORING_SETUP_BPF_EXT | IORING_SETUP_NO_SQARRAY;
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
+static int allocate_buf(struct test_ctx *ctx)
+{
+	char *p;
+	int i;
+
+	switch (ctx->buf_type) {
+	case IO_BPF_BUF_USER:
+	case IO_BPF_BUF_FIXED:
+		p = aligned_alloc(4096, ctx->buf_size);
+		if (!p)
+			return -ENOMEM;
+		ctx->buf = p;
+		return 0;
+	case IO_BPF_BUF_VEC:
+	case IO_BPF_BUF_REG_VEC:
+		if (ctx->nr_vec <= 0 || ctx->nr_vec > MAX_VECS)
+			return -EINVAL;
+		p = aligned_alloc(4096, ctx->buf_size);
+		if (!p)
+			return -ENOMEM;
+		ctx->buf = p;
+		for (i = 0; i < ctx->nr_vec; i++) {
+			size_t chunk = ctx->buf_size / ctx->nr_vec;
+
+			ctx->vecs[i].iov_base = p + i * chunk;
+			ctx->vecs[i].iov_len = chunk;
+		}
+		ctx->vecs[ctx->nr_vec - 1].iov_len +=
+			ctx->buf_size % ctx->nr_vec;
+		return 0;
+	default:
+		return -EINVAL;
+	}
+}
+
+static enum iou_test_status register_fixed(struct test_ctx *ctx)
+{
+	struct iovec iov;
+	int ret;
+
+	if (ctx->buf_type != IO_BPF_BUF_FIXED &&
+	    ctx->buf_type != IO_BPF_BUF_REG_VEC)
+		return IOU_TEST_PASS;
+
+	ctx->buf_index = 0;
+	iov.iov_base = ctx->buf;
+	iov.iov_len = ctx->buf_size;
+
+	ret = io_uring_register_buffers(&ctx->ring, &iov, 1);
+	if (ret) {
+		IOU_ERR("Failed to register buffers: %d", ret);
+		return IOU_TEST_FAIL;
+	}
+
+	return IOU_TEST_PASS;
+}
+
+static void build_desc(struct test_ctx *ctx)
+{
+	memset(&ctx->desc, 0, sizeof(ctx->desc));
+	ctx->desc.type = ctx->buf_type;
+
+	switch (ctx->buf_type) {
+	case IO_BPF_BUF_VEC:
+		ctx->desc.addr = (__u64)(uintptr_t)ctx->vecs;
+		ctx->desc.len = ctx->nr_vec;
+		break;
+	case IO_BPF_BUF_FIXED:
+		ctx->desc.addr = (__u64)(uintptr_t)ctx->buf;
+		ctx->desc.len = ctx->buf_size;
+		ctx->desc.buf_index = ctx->buf_index;
+		break;
+	case IO_BPF_BUF_REG_VEC:
+		ctx->desc.addr = (__u64)(uintptr_t)ctx->vecs;
+		ctx->desc.len = ctx->nr_vec;
+		ctx->desc.buf_index = ctx->buf_index;
+		break;
+	default: /* USER */
+		ctx->desc.addr = (__u64)(uintptr_t)ctx->buf;
+		ctx->desc.len = ctx->buf_size;
+		break;
+	}
+}
+
+/* Submit a BPF op and wait for completion.  op_id selects the struct_ops. */
+static enum iou_test_status submit_op(struct test_ctx *ctx, int op_id)
+{
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	int ret;
+
+	sqe = io_uring_get_sqe(&ctx->ring);
+	if (!sqe) {
+		IOU_ERR("Failed to get SQE");
+		return IOU_TEST_FAIL;
+	}
+
+	memset(sqe, 0, sizeof(*sqe));
+	sqe->opcode = IORING_OP_BPF;
+	sqe->fd = -1;
+	sqe->bpf_op_flags = (op_id << IORING_BPF_OP_SHIFT);
+	sqe->addr = (__u64)(uintptr_t)&ctx->desc;
+	sqe->len = 1;
+	sqe->user_data = 0xCAFEBABE;
+
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
+	if (cqe->user_data != 0xCAFEBABE) {
+		IOU_ERR("CQE user_data mismatch: 0x%llx", cqe->user_data);
+		return IOU_TEST_FAIL;
+	}
+
+	if (cqe->res != (int)ctx->buf_size) {
+		IOU_ERR("CQE result mismatch: %d (expected %zu)",
+			cqe->res, ctx->buf_size);
+		if (cqe->res < 0)
+			IOU_ERR("Error: %s", strerror(-cqe->res));
+		return IOU_TEST_FAIL;
+	}
+
+	io_uring_cqe_seen(&ctx->ring);
+	return IOU_TEST_PASS;
+}
+
+static enum iou_test_status verify_arena(struct test_ctx *ctx, __u8 pattern)
+{
+	unsigned char *arena_data = ctx->skel->bss->arena_buf;
+
+	if (!arena_data) {
+		IOU_ERR("arena_buf pointer is NULL");
+		return IOU_TEST_FAIL;
+	}
+
+	for (size_t i = 0; i < ctx->buf_size; i++) {
+		if (arena_data[i] != pattern) {
+			IOU_ERR("Arena mismatch at offset %zu: 0x%02x (expected 0x%02x)",
+				i, arena_data[i], pattern);
+			return IOU_TEST_FAIL;
+		}
+	}
+	return IOU_TEST_PASS;
+}
+
+static enum iou_test_status verify_buf(struct test_ctx *ctx, __u8 pattern)
+{
+	for (size_t i = 0; i < ctx->buf_size; i++) {
+		if ((unsigned char)ctx->buf[i] != pattern) {
+			IOU_ERR("Buf mismatch at offset %zu: 0x%02x (expected 0x%02x)",
+				i, (unsigned char)ctx->buf[i], pattern);
+			return IOU_TEST_FAIL;
+		}
+	}
+	return IOU_TEST_PASS;
+}
+
+/* Read test: buf -> arena (op_id=0, ITER_SOURCE) */
+static enum iou_test_status test_read(struct test_ctx *ctx)
+{
+	enum iou_test_status status;
+
+	if (allocate_buf(ctx))
+		return IOU_TEST_FAIL;
+
+	memset(ctx->buf, TEST_PATTERN, ctx->buf_size);
+
+	status = register_fixed(ctx);
+	if (status != IOU_TEST_PASS)
+		goto out;
+
+	build_desc(ctx);
+	status = submit_op(ctx, 0);
+	if (status == IOU_TEST_PASS)
+		status = verify_arena(ctx, TEST_PATTERN);
+
+	if (ctx->buf_type == IO_BPF_BUF_FIXED ||
+	    ctx->buf_type == IO_BPF_BUF_REG_VEC)
+		io_uring_unregister_buffers(&ctx->ring);
+
+out:
+	free(ctx->buf);
+	ctx->buf = NULL;
+
+	if (status == IOU_TEST_PASS)
+		IOU_INFO("%s: %zu bytes", ctx->test_desc, ctx->buf_size);
+	return status;
+}
+
+/* Write test: arena -> buf (op_id=1, ITER_DEST) */
+static enum iou_test_status test_write(struct test_ctx *ctx)
+{
+	enum iou_test_status status;
+	unsigned char *arena_data;
+
+	if (allocate_buf(ctx))
+		return IOU_TEST_FAIL;
+
+	/* Clear destination buffer, fill arena with pattern */
+	memset(ctx->buf, 0, ctx->buf_size);
+	arena_data = ctx->skel->bss->arena_buf;
+	if (!arena_data) {
+		free(ctx->buf);
+		ctx->buf = NULL;
+		return IOU_TEST_FAIL;
+	}
+	memset(arena_data, TEST_PATTERN, ctx->buf_size);
+
+	status = register_fixed(ctx);
+	if (status != IOU_TEST_PASS)
+		goto out;
+
+	build_desc(ctx);
+	status = submit_op(ctx, 1);
+	if (status == IOU_TEST_PASS)
+		status = verify_buf(ctx, TEST_PATTERN);
+
+	if (ctx->buf_type == IO_BPF_BUF_FIXED ||
+	    ctx->buf_type == IO_BPF_BUF_REG_VEC)
+		io_uring_unregister_buffers(&ctx->ring);
+
+out:
+	free(ctx->buf);
+	ctx->buf = NULL;
+
+	if (status == IOU_TEST_PASS)
+		IOU_INFO("%s: %zu bytes", ctx->test_desc, ctx->buf_size);
+	return status;
+}
+
+static enum iou_test_status read_user(struct test_ctx *ctx)
+{
+	ctx->buf_type = IO_BPF_BUF_USER;
+	ctx->buf_size = TEST_BUF_SIZE;
+	ctx->test_desc = "USER -> arena";
+	return test_read(ctx);
+}
+
+static enum iou_test_status read_vec(struct test_ctx *ctx)
+{
+	ctx->buf_type = IO_BPF_BUF_VEC;
+	ctx->buf_size = TEST_BUF_SIZE;
+	ctx->nr_vec = 5;
+	ctx->test_desc = "VEC -> arena";
+	return test_read(ctx);
+}
+
+static enum iou_test_status read_fixed(struct test_ctx *ctx)
+{
+	ctx->buf_type = IO_BPF_BUF_FIXED;
+	ctx->buf_size = TEST_BUF_SIZE;
+	ctx->test_desc = "FIXED -> arena";
+	return test_read(ctx);
+}
+
+static enum iou_test_status read_reg_vec(struct test_ctx *ctx)
+{
+	ctx->buf_type = IO_BPF_BUF_REG_VEC;
+	ctx->buf_size = TEST_BUF_SIZE;
+	ctx->nr_vec = 5;
+	ctx->test_desc = "REG_VEC -> arena";
+	return test_read(ctx);
+}
+
+static enum iou_test_status write_user(struct test_ctx *ctx)
+{
+	ctx->buf_type = IO_BPF_BUF_USER;
+	ctx->buf_size = TEST_BUF_SIZE;
+	ctx->test_desc = "arena -> USER";
+	return test_write(ctx);
+}
+
+static enum iou_test_status write_vec(struct test_ctx *ctx)
+{
+	ctx->buf_type = IO_BPF_BUF_VEC;
+	ctx->buf_size = TEST_BUF_SIZE;
+	ctx->nr_vec = 5;
+	ctx->test_desc = "arena -> VEC";
+	return test_write(ctx);
+}
+
+static enum iou_test_status write_fixed(struct test_ctx *ctx)
+{
+	ctx->buf_type = IO_BPF_BUF_FIXED;
+	ctx->buf_size = TEST_BUF_SIZE;
+	ctx->test_desc = "arena -> FIXED";
+	return test_write(ctx);
+}
+
+static enum iou_test_status write_reg_vec(struct test_ctx *ctx)
+{
+	ctx->buf_type = IO_BPF_BUF_REG_VEC;
+	ctx->buf_size = TEST_BUF_SIZE;
+	ctx->nr_vec = 5;
+	ctx->test_desc = "arena -> REG_VEC";
+	return test_write(ctx);
+}
+
+static enum iou_test_status run(void *ctx_ptr)
+{
+	struct test_ctx *ctx = ctx_ptr;
+	enum iou_test_status status;
+
+	/* Read tests: buffer -> arena */
+	status = read_user(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
+	status = read_vec(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
+	status = read_fixed(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
+	status = read_reg_vec(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
+	/* Write tests: arena -> buffer */
+	status = write_user(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
+	status = write_vec(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
+	status = write_fixed(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
+	status = write_reg_vec(ctx);
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
+	if (ctx->link_write)
+		bpf_link__destroy(ctx->link_write);
+	if (ctx->link_read)
+		bpf_link__destroy(ctx->link_read);
+	if (ctx->skel)
+		bpf_ext_memcpy__destroy(ctx->skel);
+	io_uring_queue_exit(&ctx->ring);
+	free(ctx);
+}
+
+struct iou_test bpf_ext_memcpy_test = {
+	.name = "bpf_ext_memcpy",
+	.description = "Test buffer iterator direct read to BPF arena",
+	.setup = setup,
+	.run = run,
+	.cleanup = cleanup,
+};
+REGISTER_IOU_TEST(bpf_ext_memcpy_test)
diff --git a/tools/testing/selftests/io_uring/include/bpf_ext_memcpy_defs.h b/tools/testing/selftests/io_uring/include/bpf_ext_memcpy_defs.h
new file mode 100644
index 000000000000..f924ca834865
--- /dev/null
+++ b/tools/testing/selftests/io_uring/include/bpf_ext_memcpy_defs.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef BPF_MEMCPY_DEFS_H
+#define BPF_MEMCPY_DEFS_H
+
+/*
+ * Shared definitions between bpf_memcpy.bpf.c (BPF program) and
+ * bpf_memcpy.c (userspace test).
+ *
+ * Buffer size must be CHUNK_SIZE-aligned so every dynptr slice is a
+ * clean multiple of CHUNK_SIZE with no partial tail.
+ */
+#define CHUNK_SIZE	512
+/* Must be divisible by CHUNK_SIZE and nr_vecs (5).
+ * 512 * 2050 = 1049600, 1049600 / 5 = 209920 = 512 * 410.
+ */
+#define TEST_BUF_SIZE	(CHUNK_SIZE * 2050)		/* ~1MB */
+
+#endif /* BPF_MEMCPY_DEFS_H */
-- 
2.53.0


