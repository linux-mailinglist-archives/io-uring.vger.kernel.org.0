Return-Path: <io-uring+bounces-11413-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 98833CF7BB7
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:16:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id A9465307EA35
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:12:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C910241C63;
	Tue,  6 Jan 2026 10:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZozafcYC"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00870309EF0
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694357; cv=none; b=KrKsyXi8RagQLZqKd7A+snAJYgoZzRkPzdg7jabVOOsE+JpHEz9XDKCktEcQmFLt/YCAhVco7k7x625sqNWZRhZGXBRFzdLckJbwUvWdCjjK4b5sezgrRzP47wcEqGVMJU7V/SsIMPmx4u/djCI+w/5dR/QbSSny/EIUf7qxn0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694357; c=relaxed/simple;
	bh=7eAiDT8M1a1DdLEIsdjQIf7kDxK0C9Lqccq1I5W4M/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kpDsi4D8tcl564mo4mrWoF/t0xMORfY+6FPUuEe6zsDZHzSTvJN4IYTof+Oh9iNq+HFhUXWtNN8k7MpJ5nxQh0UUx3GrTJI/2vmKwJTYUPNJ31/6PGFa420iwBH17Qyqz5UwJcsJkpPqG/hiHZ3pOYG3CSmMXKQ2fb6ARdnfDHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ZozafcYC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694355;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iaIRUyqVvv+GIqBBUNQyXvdzNYH/avsW0xm3KkrfK8U=;
	b=ZozafcYCEqU+L2opkjbdrIiYWgWyfisd2RJcJYDTmS0rZgP3OQ1/uTvvF0+kWBqJ3jGLaK
	Nf+6pJz64wTia3P0u2mgxyiQzRM7i1OfyrVhz7FRbzZClz10f1FM2MCie6BKLJgYG9xM6n
	rSHJVrOg8/2Z9A/NKswH3zLAzvg3yE8=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-448-0Q7SlJRoNziC9A9B9FKxMA-1; Tue,
 06 Jan 2026 05:12:31 -0500
X-MC-Unique: 0Q7SlJRoNziC9A9B9FKxMA-1
X-Mimecast-MFC-AGG-ID: 0Q7SlJRoNziC9A9B9FKxMA_1767694350
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8BF5A1956054;
	Tue,  6 Jan 2026 10:12:30 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 85B771800663;
	Tue,  6 Jan 2026 10:12:28 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 13/13] selftests/io_uring: add copy_user_to_reg_vec() and copy_reg_vec_to_user() bpf_memcpy tests
Date: Tue,  6 Jan 2026 18:11:22 +0800
Message-ID: <20260106101126.4064990-14-ming.lei@redhat.com>
In-Reply-To: <20260106101126.4064990-1-ming.lei@redhat.com>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

Add tests for IO_BPF_BUF_REG_VEC buffer type to verify uring_bpf_memcpy()
kfunc works correctly with registered vectored buffers.

IO_BPF_BUF_REG_VEC combines the vectored buffer layout (iovec array) with
registered buffer optimization - the underlying buffer is registered with
io_uring while the descriptor points to an iovec array for flexible
scatter-gather access.

Changes:
- Add is_registered_buf() helper to check if buffer type needs registration
- Update allocate_buf()/free_buf() to handle IO_BPF_BUF_REG_VEC type
- Update register_fixed_bufs()/unregister_fixed_bufs() to handle REG_VEC
- Update allocate_bufs() to set up REG_VEC descriptors with buf_index
- Add copy_user_to_reg_vec(): Tests USER source to REG_VEC destination
- Add copy_reg_vec_to_user(): Tests REG_VEC source to USER destination

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 tools/testing/selftests/io_uring/bpf_memcpy.c | 57 +++++++++++++++++--
 1 file changed, 52 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/io_uring/bpf_memcpy.c b/tools/testing/selftests/io_uring/bpf_memcpy.c
index 923b9d81b508..a221b84839bd 100644
--- a/tools/testing/selftests/io_uring/bpf_memcpy.c
+++ b/tools/testing/selftests/io_uring/bpf_memcpy.c
@@ -130,6 +130,7 @@ static int allocate_buf(char **buf, size_t size, __u8 buf_type,
 		*buf = p;
 		return 0;
 	case IO_BPF_BUF_VEC:
+	case IO_BPF_BUF_REG_VEC:
 		if (nr_vec <= 0 || nr_vec > MAX_VECS)
 			return -EINVAL;
 		p = aligned_alloc(4096, size);
@@ -156,6 +157,7 @@ static void free_buf(char *buf, __u8 buf_type)
 	case IO_BPF_BUF_USER:
 	case IO_BPF_BUF_VEC:
 	case IO_BPF_BUF_FIXED:
+	case IO_BPF_BUF_REG_VEC:
 		free(buf);
 		break;
 	default:
@@ -163,20 +165,25 @@ static void free_buf(char *buf, __u8 buf_type)
 	}
 }
 
+static inline bool is_registered_buf(__u8 type)
+{
+	return type == IO_BPF_BUF_FIXED || type == IO_BPF_BUF_REG_VEC;
+}
+
 static enum iou_test_status register_fixed_bufs(struct test_ctx *ctx)
 {
 	struct iovec iovecs[2];
 	int nr_iovecs = 0;
 	int ret;
 
-	if (ctx->src_type == IO_BPF_BUF_FIXED) {
+	if (is_registered_buf(ctx->src_type)) {
 		ctx->src_buf_index = nr_iovecs;
 		iovecs[nr_iovecs].iov_base = ctx->src_buf;
 		iovecs[nr_iovecs].iov_len = ctx->src_buf_size;
 		nr_iovecs++;
 	}
 
-	if (ctx->dst_type == IO_BPF_BUF_FIXED) {
+	if (is_registered_buf(ctx->dst_type)) {
 		ctx->dst_buf_index = nr_iovecs;
 		iovecs[nr_iovecs].iov_base = ctx->dst_buf;
 		iovecs[nr_iovecs].iov_len = ctx->dst_buf_size;
@@ -197,8 +204,8 @@ static enum iou_test_status register_fixed_bufs(struct test_ctx *ctx)
 
 static void unregister_fixed_bufs(struct test_ctx *ctx)
 {
-	if (ctx->src_type == IO_BPF_BUF_FIXED ||
-	    ctx->dst_type == IO_BPF_BUF_FIXED)
+	if (is_registered_buf(ctx->src_type) ||
+	    is_registered_buf(ctx->dst_type))
 		io_uring_unregister_buffers(&ctx->ring);
 }
 
@@ -249,6 +256,10 @@ static enum iou_test_status allocate_bufs(struct test_ctx *ctx)
 		ctx->descs[0].addr = (__u64)(uintptr_t)ctx->src_buf;
 		ctx->descs[0].len = ctx->src_buf_size;
 		ctx->descs[0].buf_index = ctx->src_buf_index;
+	} else if (ctx->src_type == IO_BPF_BUF_REG_VEC) {
+		ctx->descs[0].addr = (__u64)(uintptr_t)ctx->src_vec;
+		ctx->descs[0].len = ctx->src_nr_vec;
+		ctx->descs[0].buf_index = ctx->src_buf_index;
 	} else {
 		ctx->descs[0].addr = (__u64)(uintptr_t)ctx->src_buf;
 		ctx->descs[0].len = ctx->src_buf_size;
@@ -261,6 +272,10 @@ static enum iou_test_status allocate_bufs(struct test_ctx *ctx)
 		ctx->descs[1].addr = (__u64)(uintptr_t)ctx->dst_buf;
 		ctx->descs[1].len = ctx->dst_buf_size;
 		ctx->descs[1].buf_index = ctx->dst_buf_index;
+	} else if (ctx->dst_type == IO_BPF_BUF_REG_VEC) {
+		ctx->descs[1].addr = (__u64)(uintptr_t)ctx->dst_vec;
+		ctx->descs[1].len = ctx->dst_nr_vec;
+		ctx->descs[1].buf_index = ctx->dst_buf_index;
 	} else {
 		ctx->descs[1].addr = (__u64)(uintptr_t)ctx->dst_buf;
 		ctx->descs[1].len = ctx->dst_buf_size;
@@ -420,6 +435,30 @@ static enum iou_test_status copy_fixed_to_user(struct test_ctx *ctx)
 	return test_copy(ctx);
 }
 
+static enum iou_test_status copy_user_to_reg_vec(struct test_ctx *ctx)
+{
+	ctx->src_type = IO_BPF_BUF_USER;
+	ctx->dst_type = IO_BPF_BUF_REG_VEC;
+	ctx->src_buf_size = TEST_BUF_SIZE;
+	ctx->dst_buf_size = TEST_BUF_SIZE;
+	ctx->dst_nr_vec = 4;
+	ctx->desc = "USER -> REG_VEC";
+
+	return test_copy(ctx);
+}
+
+static enum iou_test_status copy_reg_vec_to_user(struct test_ctx *ctx)
+{
+	ctx->src_type = IO_BPF_BUF_REG_VEC;
+	ctx->dst_type = IO_BPF_BUF_USER;
+	ctx->src_buf_size = TEST_BUF_SIZE;
+	ctx->dst_buf_size = TEST_BUF_SIZE;
+	ctx->src_nr_vec = 4;
+	ctx->desc = "REG_VEC -> USER";
+
+	return test_copy(ctx);
+}
+
 static enum iou_test_status run(void *ctx_ptr)
 {
 	struct test_ctx *ctx = ctx_ptr;
@@ -445,6 +484,14 @@ static enum iou_test_status run(void *ctx_ptr)
 	if (status != IOU_TEST_PASS)
 		return status;
 
+	status = copy_user_to_reg_vec(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
+	status = copy_reg_vec_to_user(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
 	return IOU_TEST_PASS;
 }
 
@@ -462,7 +509,7 @@ static void cleanup(void *ctx_ptr)
 
 struct iou_test bpf_memcpy_test = {
 	.name = "bpf_memcpy",
-	.description = "Test uring_bpf_memcpy() kfunc with USER, VEC, FIXED buffer types",
+	.description = "Test uring_bpf_memcpy() kfunc with USER, VEC, FIXED, REG_VEC buffer types",
 	.setup = setup,
 	.run = run,
 	.cleanup = cleanup,
-- 
2.47.0


