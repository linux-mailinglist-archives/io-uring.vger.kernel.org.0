Return-Path: <io-uring+bounces-11412-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2198BCF7B51
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id E5AA83046120
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:12:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A68930E830;
	Tue,  6 Jan 2026 10:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UVqy44VA"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B568C41C63
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694354; cv=none; b=kJI2xgr9gFTIyMXOWkCpc7RigWtXeOBxWelsklojOnMAjrMje0n+tznmxpuNSY53ltiOZd+GRhiY4465ytsyfn0IRF881yeQ5jIEEsSrQlcx2RBklKw4ntf04DQ1h3ho5ioa8ccm6g4ucoU9FIyf6MHfbz4pb5zVDEGTnw7oSmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694354; c=relaxed/simple;
	bh=A0m2HlWXatUUi+dgH3mWK87UANdfW9zLmJKgLmhBk2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cB3ZIpkWsyDBORcpMfAi6kCcaX/pFSe4MxK8/NQMqrjQ1ni49P6vFmHI3S3UUQaYb1Q4WSqI/TY4tSgSwcq+/JbytIZZaXy+sDPLQdheE9N1bq0uebLJIBAUqcsQJNwM8FC38QTlMCeb2bD47qFdYhlEG4B6h3Q0Mo7X3DEv0bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UVqy44VA; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694350;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tWA93G9P4NMrO74Apx1lIdf/31Riuha/H/x+sLU8JlE=;
	b=UVqy44VAgqN+MuzIF1vb7/xyQuMmTyUSjxfWkzsC0lyf2dM0sDEOMVsTJLJwE0YYWFY6YP
	6y7XEM/mnaF+k96PX2HBxp13nNMcVyjNfIKW+ryVulVUYXoful07OIVEBvVxZrdN1/cMdk
	+pvTl9m1A8PujTG6V07UreWPRFtfPt8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-215-Dt5faav4MqqoNJtxNAoODw-1; Tue,
 06 Jan 2026 05:12:27 -0500
X-MC-Unique: Dt5faav4MqqoNJtxNAoODw-1
X-Mimecast-MFC-AGG-ID: Dt5faav4MqqoNJtxNAoODw_1767694346
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6448018011FB;
	Tue,  6 Jan 2026 10:12:26 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 8BA49180044F;
	Tue,  6 Jan 2026 10:12:25 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 12/13] selftests/io_uring: add copy_user_to_fixed() and copy_fixed_to_user() bpf_memcpy tests
Date: Tue,  6 Jan 2026 18:11:21 +0800
Message-ID: <20260106101126.4064990-13-ming.lei@redhat.com>
In-Reply-To: <20260106101126.4064990-1-ming.lei@redhat.com>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Add tests for IO_BPF_BUF_FIXED buffer type to verify uring_bpf_memcpy()
kfunc works correctly with registered fixed buffers.

Changes:
- Add io_uring_unregister_buffers() to mini_liburing.h
- Add fixed buffer index tracking (src_buf_index/dst_buf_index) to test_ctx
- Add register_fixed_bufs()/unregister_fixed_bufs() helpers to manage
  buffer registration with the io_uring ring
- Update allocate_buf()/free_buf() to handle IO_BPF_BUF_FIXED type
- Add copy_user_to_fixed(): Tests USER source to FIXED destination
- Add copy_fixed_to_user(): Tests FIXED source to USER destination

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 tools/testing/selftests/io_uring/bpf_memcpy.c | 98 ++++++++++++++++++-
 1 file changed, 97 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/io_uring/bpf_memcpy.c b/tools/testing/selftests/io_uring/bpf_memcpy.c
index 0fad6d0583c3..923b9d81b508 100644
--- a/tools/testing/selftests/io_uring/bpf_memcpy.c
+++ b/tools/testing/selftests/io_uring/bpf_memcpy.c
@@ -37,6 +37,10 @@ struct test_ctx {
 	struct iovec dst_vec[MAX_VECS];
 	int src_nr_vec;
 	int dst_nr_vec;
+
+	/* Fixed buffer support */
+	__u16 src_buf_index;
+	__u16 dst_buf_index;
 };
 
 static enum iou_test_status bpf_setup(struct test_ctx *ctx)
@@ -119,6 +123,7 @@ static int allocate_buf(char **buf, size_t size, __u8 buf_type,
 
 	switch (buf_type) {
 	case IO_BPF_BUF_USER:
+	case IO_BPF_BUF_FIXED:
 		p = aligned_alloc(4096, size);
 		if (!p)
 			return -ENOMEM;
@@ -150,6 +155,7 @@ static void free_buf(char *buf, __u8 buf_type)
 	switch (buf_type) {
 	case IO_BPF_BUF_USER:
 	case IO_BPF_BUF_VEC:
+	case IO_BPF_BUF_FIXED:
 		free(buf);
 		break;
 	default:
@@ -157,8 +163,48 @@ static void free_buf(char *buf, __u8 buf_type)
 	}
 }
 
+static enum iou_test_status register_fixed_bufs(struct test_ctx *ctx)
+{
+	struct iovec iovecs[2];
+	int nr_iovecs = 0;
+	int ret;
+
+	if (ctx->src_type == IO_BPF_BUF_FIXED) {
+		ctx->src_buf_index = nr_iovecs;
+		iovecs[nr_iovecs].iov_base = ctx->src_buf;
+		iovecs[nr_iovecs].iov_len = ctx->src_buf_size;
+		nr_iovecs++;
+	}
+
+	if (ctx->dst_type == IO_BPF_BUF_FIXED) {
+		ctx->dst_buf_index = nr_iovecs;
+		iovecs[nr_iovecs].iov_base = ctx->dst_buf;
+		iovecs[nr_iovecs].iov_len = ctx->dst_buf_size;
+		nr_iovecs++;
+	}
+
+	if (nr_iovecs == 0)
+		return IOU_TEST_PASS;
+
+	ret = io_uring_register_buffers(&ctx->ring, iovecs, nr_iovecs);
+	if (ret) {
+		IOU_ERR("Failed to register buffers: %d", ret);
+		return IOU_TEST_FAIL;
+	}
+
+	return IOU_TEST_PASS;
+}
+
+static void unregister_fixed_bufs(struct test_ctx *ctx)
+{
+	if (ctx->src_type == IO_BPF_BUF_FIXED ||
+	    ctx->dst_type == IO_BPF_BUF_FIXED)
+		io_uring_unregister_buffers(&ctx->ring);
+}
+
 static enum iou_test_status allocate_bufs(struct test_ctx *ctx)
 {
+	enum iou_test_status status;
 	int ret;
 
 	ret = allocate_buf(&ctx->src_buf, ctx->src_buf_size, ctx->src_type,
@@ -181,6 +227,16 @@ static enum iou_test_status allocate_bufs(struct test_ctx *ctx)
 	memset(ctx->src_buf, TEST_PATTERN, ctx->src_buf_size);
 	memset(ctx->dst_buf, 0, ctx->dst_buf_size);
 
+	/* Register fixed buffers if needed */
+	status = register_fixed_bufs(ctx);
+	if (status != IOU_TEST_PASS) {
+		free_buf(ctx->dst_buf, ctx->dst_type);
+		ctx->dst_buf = NULL;
+		free_buf(ctx->src_buf, ctx->src_type);
+		ctx->src_buf = NULL;
+		return status;
+	}
+
 	/* Build buffer descriptors */
 	memset(ctx->descs, 0, sizeof(ctx->descs));
 	ctx->descs[0].type = ctx->src_type;
@@ -189,6 +245,10 @@ static enum iou_test_status allocate_bufs(struct test_ctx *ctx)
 	if (ctx->src_type == IO_BPF_BUF_VEC) {
 		ctx->descs[0].addr = (__u64)(uintptr_t)ctx->src_vec;
 		ctx->descs[0].len = ctx->src_nr_vec;
+	} else if (ctx->src_type == IO_BPF_BUF_FIXED) {
+		ctx->descs[0].addr = (__u64)(uintptr_t)ctx->src_buf;
+		ctx->descs[0].len = ctx->src_buf_size;
+		ctx->descs[0].buf_index = ctx->src_buf_index;
 	} else {
 		ctx->descs[0].addr = (__u64)(uintptr_t)ctx->src_buf;
 		ctx->descs[0].len = ctx->src_buf_size;
@@ -197,6 +257,10 @@ static enum iou_test_status allocate_bufs(struct test_ctx *ctx)
 	if (ctx->dst_type == IO_BPF_BUF_VEC) {
 		ctx->descs[1].addr = (__u64)(uintptr_t)ctx->dst_vec;
 		ctx->descs[1].len = ctx->dst_nr_vec;
+	} else if (ctx->dst_type == IO_BPF_BUF_FIXED) {
+		ctx->descs[1].addr = (__u64)(uintptr_t)ctx->dst_buf;
+		ctx->descs[1].len = ctx->dst_buf_size;
+		ctx->descs[1].buf_index = ctx->dst_buf_index;
 	} else {
 		ctx->descs[1].addr = (__u64)(uintptr_t)ctx->dst_buf;
 		ctx->descs[1].len = ctx->dst_buf_size;
@@ -207,6 +271,8 @@ static enum iou_test_status allocate_bufs(struct test_ctx *ctx)
 
 static void free_bufs(struct test_ctx *ctx)
 {
+	unregister_fixed_bufs(ctx);
+
 	if (ctx->src_buf) {
 		free_buf(ctx->src_buf, ctx->src_type);
 		ctx->src_buf = NULL;
@@ -332,6 +398,28 @@ static enum iou_test_status copy_user_to_vec(struct test_ctx *ctx)
 	return test_copy(ctx);
 }
 
+static enum iou_test_status copy_user_to_fixed(struct test_ctx *ctx)
+{
+	ctx->src_type = IO_BPF_BUF_USER;
+	ctx->dst_type = IO_BPF_BUF_FIXED;
+	ctx->src_buf_size = TEST_BUF_SIZE;
+	ctx->dst_buf_size = TEST_BUF_SIZE;
+	ctx->desc = "USER -> FIXED";
+
+	return test_copy(ctx);
+}
+
+static enum iou_test_status copy_fixed_to_user(struct test_ctx *ctx)
+{
+	ctx->src_type = IO_BPF_BUF_FIXED;
+	ctx->dst_type = IO_BPF_BUF_USER;
+	ctx->src_buf_size = TEST_BUF_SIZE;
+	ctx->dst_buf_size = TEST_BUF_SIZE;
+	ctx->desc = "FIXED -> USER";
+
+	return test_copy(ctx);
+}
+
 static enum iou_test_status run(void *ctx_ptr)
 {
 	struct test_ctx *ctx = ctx_ptr;
@@ -349,6 +437,14 @@ static enum iou_test_status run(void *ctx_ptr)
 	if (status != IOU_TEST_PASS)
 		return status;
 
+	status = copy_user_to_fixed(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
+	status = copy_fixed_to_user(ctx);
+	if (status != IOU_TEST_PASS)
+		return status;
+
 	return IOU_TEST_PASS;
 }
 
@@ -366,7 +462,7 @@ static void cleanup(void *ctx_ptr)
 
 struct iou_test bpf_memcpy_test = {
 	.name = "bpf_memcpy",
-	.description = "Test uring_bpf_memcpy() kfunc with USER, VEC, and mixed buffer types",
+	.description = "Test uring_bpf_memcpy() kfunc with USER, VEC, FIXED buffer types",
 	.setup = setup,
 	.run = run,
 	.cleanup = cleanup,
-- 
2.47.0


