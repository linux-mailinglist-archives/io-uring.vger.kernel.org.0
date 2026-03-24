Return-Path: <io-uring+bounces-12828-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +GxkLMrAwmmjlQQAu9opvQ
	(envelope-from <io-uring+bounces-12828-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:50:18 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 6858B319648
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 17:50:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9A00530FDA9B
	for <lists+io-uring@lfdr.de>; Tue, 24 Mar 2026 16:38:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 550F03FB7FF;
	Tue, 24 Mar 2026 16:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HZ+Y+hhJ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639873FBEC0
	for <io-uring@vger.kernel.org>; Tue, 24 Mar 2026 16:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774370324; cv=none; b=GH7XiIVaji2lplwAgdQrECJ6IpNGZWn4Q5qRAsX21m4m6INFUE9e1gazKEY0oAkz6+++0WCsmvyJgQvLg1iJJDTeYNDCbGeq3WFWbimmcqWoNbmII9i/OdgBEanFWLiNXGdPhdgduYt1G8ssLmP71weH3c+BNf0JgufG0MPOiYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774370324; c=relaxed/simple;
	bh=u6nyqOdzce4NzrTplGhPI2JDc3sd4b2k3/YPmFRq1WY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S61Zrgh2R9vMNxW20ULQnAfeptB3CElYmvF8t4TkAzi9Jj1BfL8RFFynB1EhFcLpPkKRBR+GCbDvZMG+OLNeC983mAORGuShEjpMNsBX9CK3Yb8bkNaJypvVa/H/5Ryvf+6a9eHcWk70I+O5eLObUSU4a7P01EVR8POw1PUls/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HZ+Y+hhJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774370321;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QFdT/3rS1U0E5hTBWWZMO7QrFAmNc22eIwcc35nO3ok=;
	b=HZ+Y+hhJ7oQMsiVzDoTNHK4ljfnkc0QXUZdhybgwFqNHsYdaRfZ809RqJ/Td5Uu/KlQJyA
	2eW/8/7wPka/2LRc/rJ1E/WcQ3wMhx/QFFE4WujCJ+ILJaTgnYVta7R3CeF9EZKovuPJI7
	s71bvhLZrEGceu6VX8SPKK3393mcC6Q=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-17-5OJc2uE9NL2rYV9_ZkqX3A-1; Tue,
 24 Mar 2026 12:38:40 -0400
X-MC-Unique: 5OJc2uE9NL2rYV9_ZkqX3A-1
X-Mimecast-MFC-AGG-ID: 5OJc2uE9NL2rYV9_ZkqX3A_1774370318
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CB1541800365;
	Tue, 24 Mar 2026 16:38:38 +0000 (UTC)
Received: from localhost (unknown [10.72.116.133])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1A6EC180035F;
	Tue, 24 Mar 2026 16:38:36 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Xiao Ni <xni@redhat.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V3 08/12] io_uring: bpf: add per-buffer iterator kfuncs
Date: Wed, 25 Mar 2026 00:37:29 +0800
Message-ID: <20260324163753.1900977-9-ming.lei@redhat.com>
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
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111
X-Spamd-Result: default: False [-1.16 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12828-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RECEIVED_HELO_LOCALHOST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	MISSING_XM_UA(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ming.lei@redhat.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[8];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6858B319648
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Add per-buffer KF_ITER kfuncs for page-level access from BPF programs.
Each buffer gets its own iterator on the BPF stack, and the BPF program
coordinates multiple iterators for multi-buffer operations. The verifier
enforces proper iterator lifecycle via KF_ITER_NEW/NEXT/DESTROY.

kfunc API:
- bpf_iter_uring_buf_new(iter, data, desc, direction): import one buffer,
  take submit lock (refcounted via data->lock_depth). Supports all 5
  buffer types (USER, FIXED, VEC, KFIXED, REG_VEC) and both directions
  (ITER_SOURCE for reading, ITER_DEST for writing).
- bpf_iter_uring_buf_next(iter): extract the next page, kmap it, return
  int * pointing to the avail byte count (non-NULL = more data, NULL =
  done). The actual page data is accessed via bpf_uring_buf_dynptr() or
  bpf_uring_buf_dynptr_rdwr().
- bpf_iter_uring_buf_destroy(iter): unmap page, free resources, release
  submit lock when lock_depth reaches zero.
- bpf_uring_buf_dynptr(it__iter, ptr__uninit): populate a read-only LOCAL
  dynptr bounded to avail bytes, preventing data leaks beyond valid data.
- bpf_uring_buf_dynptr_rdwr(it__iter, ptr__uninit): populate a writable
  LOCAL dynptr, requires direction == ITER_DEST (checked via
  iter.data_source).

The dynptr approach replaces the old uring_buf_page_t typedef which
exposed PAGE_SIZE bytes to BPF programs even when only avail bytes
contained valid data.

Note: bpf_dynptr_slice() requires a compile-time constant size, so BPF
programs typically process pages in fixed-size chunks (e.g. 512 bytes).
Buffer addresses and lengths should be at least 512-byte aligned for
efficient access.

Add helper functions for buffer import:
- io_bpf_import_fixed_buf(): handles FIXED/KFIXED types
- io_bpf_import_reg_vec(): handles REG_VEC type
- io_bpf_import_vec_buf(): handles VEC type
- io_bpf_import_buffer(): unified dispatcher for all buffer types

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/bpf_ext.c | 413 ++++++++++++++++++++++++++++++++++++++++++++-
 io_uring/bpf_ext.h |  16 +-
 2 files changed, 421 insertions(+), 8 deletions(-)

diff --git a/io_uring/bpf_ext.c b/io_uring/bpf_ext.c
index 96c77a6d6cc0..c9787ee64b55 100644
--- a/io_uring/bpf_ext.c
+++ b/io_uring/bpf_ext.c
@@ -10,9 +10,12 @@
 #include <linux/btf.h>
 #include <linux/btf_ids.h>
 #include <linux/filter.h>
+#include <linux/uio.h>
+#include <linux/highmem.h>
 #include <uapi/linux/io_uring.h>
 #include "io_uring.h"
 #include "register.h"
+#include "rsrc.h"
 #include "bpf_ext.h"
 
 static inline unsigned char uring_bpf_get_op(u32 op_flags)
@@ -20,11 +23,6 @@ static inline unsigned char uring_bpf_get_op(u32 op_flags)
 	return (unsigned char)(op_flags >> IORING_BPF_OP_SHIFT);
 }
 
-static inline unsigned int uring_bpf_get_flags(u32 op_flags)
-{
-	return op_flags & ((1U << IORING_BPF_OP_SHIFT) - 1);
-}
-
 int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
@@ -47,6 +45,8 @@ int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	data->opf = opf;
 	data->ops = ops;
+	data->issue_flags = 0;
+	data->lock_depth = 0;
 	ret = ops->prep_fn(data, sqe);
 	if (!ret) {
 		/* Only increment refcount on success (uring_lock already held) */
@@ -74,7 +74,13 @@ static int __io_uring_bpf_issue(struct io_kiocb *req)
 
 int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
-	return __io_uring_bpf_issue(req);
+	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
+	int ret;
+
+	data->issue_flags = issue_flags;
+	ret = __io_uring_bpf_issue(req);
+	data->issue_flags = 0;
+	return ret;
 }
 
 void io_uring_bpf_fail(struct io_kiocb *req)
@@ -291,6 +297,206 @@ static struct bpf_struct_ops bpf_uring_bpf_ops = {
 	.owner = THIS_MODULE,
 };
 
+/*
+ * Per-buffer iterator kernel state (heap-allocated, one per buffer).
+ */
+struct bpf_iter_uring_buf_kern {
+	struct uring_bpf_data	*data;
+	struct iov_iter		iter;
+	struct iou_vec		vec;
+	struct io_rsrc_node	*node;
+	struct page		*page;		/* current extracted page */
+	void			*kmap_base;	/* kmap_local_page() + offset */
+	int			avail;		/* valid bytes in current page */
+};
+
+static inline struct bpf_iter_uring_buf_kern *
+iter_kern(const struct bpf_iter_uring_buf *iter)
+{
+	return (struct bpf_iter_uring_buf_kern *)&iter->__opaque[0];
+}
+
+static void iter_unmap_page(struct bpf_iter_uring_buf_kern *kern)
+{
+	if (kern->kmap_base) {
+		kunmap_local(kern->kmap_base);
+		kern->kmap_base = NULL;
+	}
+	if (kern->page && iov_iter_extract_will_pin(&kern->iter)) {
+		unpin_user_page(kern->page);
+		kern->page = NULL;
+	}
+}
+
+/*
+ * Helper to import fixed buffer (FIXED or KFIXED).
+ * Must be called with submit lock held.
+ *
+ * FIXED: addr is absolute userspace address within buffer
+ * KFIXED: addr is offset from buffer start
+ *
+ * Returns node with incremented refcount on success, ERR_PTR on failure.
+ */
+static struct io_rsrc_node *io_bpf_import_fixed_buf(struct io_ring_ctx *ctx,
+						    struct iov_iter *iter,
+						    const struct io_bpf_buf_desc *desc,
+						    int ddir)
+{
+	struct io_rsrc_node *node;
+	struct io_mapped_ubuf *imu;
+	int ret;
+
+	node = io_rsrc_node_lookup(&ctx->buf_table, desc->buf_index);
+	if (!node)
+		return ERR_PTR(-EFAULT);
+
+	imu = node->buf;
+	if (!(imu->dir & (1 << ddir)))
+		return ERR_PTR(-EFAULT);
+
+	node->refs++;
+
+	ret = io_import_fixed(ddir, iter, imu, desc->addr, desc->len);
+	if (ret) {
+		node->refs--;
+		return ERR_PTR(ret);
+	}
+
+	return node;
+}
+
+/*
+ * Helper to import registered vectored buffer (REG_VEC).
+ * Must be called with submit lock held.
+ *
+ * addr: userspace iovec pointer
+ * len: number of iovecs
+ * buf_index: registered buffer index
+ *
+ * Returns node with incremented refcount on success, ERR_PTR on failure.
+ * Caller must call io_vec_free(vec) after use.
+ */
+static struct io_rsrc_node *io_bpf_import_reg_vec(struct io_ring_ctx *ctx,
+						   struct iov_iter *iter,
+						   const struct io_bpf_buf_desc *desc,
+						   int ddir, struct iou_vec *vec)
+{
+	struct io_rsrc_node *node;
+	struct io_mapped_ubuf *imu;
+	int ret;
+
+	node = io_rsrc_node_lookup(&ctx->buf_table, desc->buf_index);
+	if (!node)
+		return ERR_PTR(-EFAULT);
+
+	imu = node->buf;
+	if (!(imu->dir & (1 << ddir)))
+		return ERR_PTR(-EFAULT);
+
+	node->refs++;
+
+	/* Prepare iovec from userspace */
+	ret = __io_prep_reg_iovec(vec, u64_to_user_ptr(desc->addr),
+				  desc->len, io_is_compat(ctx), NULL);
+	if (ret)
+		goto err;
+
+	/* Import vectored buffer from registered buffer */
+	ret = __io_import_reg_vec(ddir, iter, imu, vec, desc->len, NULL);
+	if (ret)
+		goto err;
+
+	return node;
+err:
+	node->refs--;
+	return ERR_PTR(ret);
+}
+
+/*
+ * Helper to import a vectored user buffer (VEC) into iou_vec.
+ * Allocates space in vec and copies iovec from userspace.
+ *
+ * Returns 0 on success, negative error code on failure.
+ * Caller must call io_vec_free(vec) after use.
+ */
+static int io_bpf_import_vec_buf(struct io_ring_ctx *ctx,
+				 struct iov_iter *iter,
+				 const struct io_bpf_buf_desc *desc,
+				 int ddir, struct iou_vec *vec)
+{
+	unsigned nr_vecs = desc->len;
+	struct iovec *iov;
+	size_t total_len = 0;
+	void *res;
+	int ret, i;
+
+	if (nr_vecs > vec->nr) {
+		ret = io_vec_realloc(vec, nr_vecs);
+		if (ret)
+			return ret;
+	}
+
+	iov = vec->iovec;
+	res = iovec_from_user(u64_to_user_ptr(desc->addr), nr_vecs,
+			      nr_vecs, iov, io_is_compat(ctx));
+	if (IS_ERR(res))
+		return PTR_ERR(res);
+
+	for (i = 0; i < nr_vecs; i++)
+		total_len += iov[i].iov_len;
+
+	iov_iter_init(iter, ddir, iov, nr_vecs, total_len);
+	return 0;
+}
+
+/*
+ * Helper to import a buffer into an iov_iter based on io_bpf_buf_desc.
+ * Supports all 5 buffer types: USER, FIXED, VEC, KFIXED, REG_VEC.
+ * Must be called with submit lock held for FIXED/KFIXED/REG_VEC types.
+ *
+ * @ctx: ring context
+ * @iter: output iterator
+ * @desc: buffer descriptor
+ * @ddir: direction (ITER_SOURCE for source, ITER_DEST for destination)
+ * @vec: iou_vec for VEC/REG_VEC types (caller must call io_vec_free after use)
+ *
+ * Returns node pointer (may be NULL for USER/VEC), or ERR_PTR on failure.
+ * Caller must drop node reference when done if non-NULL.
+ */
+static struct io_rsrc_node *io_bpf_import_buffer(struct io_ring_ctx *ctx,
+						 struct iov_iter *iter,
+						 const struct io_bpf_buf_desc *desc,
+						 int ddir, struct iou_vec *vec)
+{
+	int ret;
+
+	switch (desc->type) {
+	case IO_BPF_BUF_USER:
+		/* Plain user buffer */
+		ret = import_ubuf(ddir, u64_to_user_ptr(desc->addr),
+				  desc->len, iter);
+		return ret ? ERR_PTR(ret) : NULL;
+
+	case IO_BPF_BUF_FIXED:
+	case IO_BPF_BUF_KFIXED:
+		/* FIXED: addr is absolute address within buffer */
+		/* KFIXED: addr is offset from buffer start */
+		return io_bpf_import_fixed_buf(ctx, iter, desc, ddir);
+
+	case IO_BPF_BUF_VEC:
+		/* Vectored user buffer - addr is iovec ptr, len is nr_vecs */
+		ret = io_bpf_import_vec_buf(ctx, iter, desc, ddir, vec);
+		return ret ? ERR_PTR(ret) : NULL;
+
+	case IO_BPF_BUF_REG_VEC:
+		/* Registered vectored buffer */
+		return io_bpf_import_reg_vec(ctx, iter, desc, ddir, vec);
+
+	default:
+		return ERR_PTR(-EINVAL);
+	}
+}
+
 __bpf_kfunc_start_defs();
 __bpf_kfunc void uring_bpf_set_result(struct uring_bpf_data *data, int res)
 {
@@ -300,10 +506,205 @@ __bpf_kfunc void uring_bpf_set_result(struct uring_bpf_data *data, int res)
 		req_set_fail(req);
 	io_req_set_res(req, res, 0);
 }
+
+/**
+ * bpf_iter_uring_buf_new - Initialize per-buffer iterator (KF_ITER_NEW)
+ * @iter: BPF-visible iterator state (on BPF stack)
+ * @data: BPF request data containing request context
+ * @desc: Single buffer descriptor
+ * @direction: ITER_SOURCE (read from buffer) or ITER_DEST (write to buffer)
+ *
+ * Takes the submit lock (refcounted via data->lock_depth, first caller
+ * acquires, last _destroy releases).
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+__bpf_kfunc int bpf_iter_uring_buf_new(struct bpf_iter_uring_buf *iter,
+					struct uring_bpf_data *data,
+					struct io_bpf_buf_desc *desc,
+					int direction)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(data);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct bpf_iter_uring_buf_kern *kern = iter_kern(iter);
+	struct io_rsrc_node *node;
+
+	BUILD_BUG_ON(sizeof(struct bpf_iter_uring_buf_kern) >
+		     sizeof(struct bpf_iter_uring_buf));
+	BUILD_BUG_ON(__alignof__(struct bpf_iter_uring_buf_kern) !=
+		     __alignof__(struct bpf_iter_uring_buf));
+
+	memset(kern, 0, sizeof(*kern));
+
+	if (desc->type > IO_BPF_BUF_REG_VEC)
+		return -EINVAL;
+	if (direction != ITER_SOURCE && direction != ITER_DEST)
+		return -EINVAL;
+
+	kern->data = data;
+
+	if (data->lock_depth++ == 0)
+		io_ring_submit_lock(ctx, data->issue_flags);
+
+	node = io_bpf_import_buffer(ctx, &kern->iter, desc,
+				    direction, &kern->vec);
+	if (IS_ERR(node)) {
+		if (--data->lock_depth == 0)
+			io_ring_submit_unlock(ctx, data->issue_flags);
+		kern->data = NULL;
+		return PTR_ERR(node);
+	}
+
+	kern->node = node;
+	return 0;
+}
+
+/**
+ * bpf_iter_uring_buf_next - Get next page chunk (KF_ITER_NEXT)
+ * @iter: BPF-visible iterator state
+ *
+ * Unmaps the previous page and extracts the next one.
+ *
+ * Returns a non-NULL pointer when data is available, NULL when done.
+ * The returned pointer is to the avail count (int); the actual page data
+ * must be obtained via bpf_uring_buf_dynptr().
+ *
+ * Note: bpf_dynptr_slice() requires a compile-time constant size, so BPF
+ * programs typically process pages in fixed-size chunks (e.g. 512 bytes).
+ * If the page offset or extracted length is not aligned to the chunk size,
+ * the trailing bytes cannot be accessed via bpf_dynptr_slice() and are
+ * silently dropped.  For best efficiency, callers should ensure buffer
+ * addresses and lengths are at least 512-byte aligned.
+ */
+__bpf_kfunc int *
+bpf_iter_uring_buf_next(struct bpf_iter_uring_buf *iter)
+{
+	struct bpf_iter_uring_buf_kern *kern = iter_kern(iter);
+	struct page *pages[1];
+	struct page **pp = pages;
+	size_t offset;
+	ssize_t extracted;
+
+	if (!kern->data)
+		return NULL;
+
+	/* Unmap and release previous page */
+	iter_unmap_page(kern);
+	kern->avail = 0;
+
+	if (iov_iter_count(&kern->iter) == 0)
+		return NULL;
+
+	/* Extract next page */
+	extracted = iov_iter_extract_pages(&kern->iter, &pp,
+					   PAGE_SIZE, 1, 0, &offset);
+	if (extracted <= 0)
+		return NULL;
+
+	kern->page = pp[0];
+	kern->kmap_base = kmap_local_page(kern->page) + offset;
+	kern->avail = extracted;
+
+	return &kern->avail;
+}
+
+/**
+ * bpf_uring_buf_dynptr - Get dynptr for current page data
+ * @it__iter: Buffer iterator (must have a current page from _next())
+ * @ptr__uninit: Dynptr to initialize (LOCAL type, read-only)
+ *
+ * Initializes @ptr__uninit as a read-only LOCAL dynptr whose size equals
+ * the valid byte count in the current page chunk.  This prevents reads
+ * beyond the actual buffer data, unlike the old uring_buf_page_t approach
+ * which exposed a full PAGE_SIZE pointer.
+ *
+ * Returns 0 on success, -EINVAL if no current page is available.
+ */
+__bpf_kfunc int bpf_uring_buf_dynptr(struct bpf_iter_uring_buf *it__iter,
+				     struct bpf_dynptr *ptr__uninit)
+{
+	struct bpf_dynptr_kern *dynptr = (struct bpf_dynptr_kern *)ptr__uninit;
+	struct bpf_iter_uring_buf_kern *kern = iter_kern(it__iter);
+
+	if (!kern->kmap_base || kern->avail <= 0) {
+		bpf_dynptr_set_null(dynptr);
+		return -EINVAL;
+	}
+
+	bpf_dynptr_init(dynptr, kern->kmap_base,
+			BPF_DYNPTR_TYPE_LOCAL, 0, kern->avail);
+	bpf_dynptr_set_rdonly(dynptr);
+	return 0;
+}
+
+/**
+ * bpf_uring_buf_dynptr_rdwr - Get writable dynptr for current page data
+ * @it__iter: Buffer iterator (must have a current page from _next())
+ * @ptr__uninit: Dynptr to initialize (LOCAL type, read-write)
+ *
+ * Like bpf_uring_buf_dynptr() but returns a writable dynptr.  The iterator
+ * must have been created with direction == ITER_DEST; otherwise returns
+ * -EPERM.  This allows writing data into user buffers (e.g. copying from
+ * BPF arena to a user-provided destination buffer).
+ *
+ * Returns 0 on success, -EINVAL if no current page, -EPERM if not ITER_DEST.
+ */
+__bpf_kfunc int bpf_uring_buf_dynptr_rdwr(struct bpf_iter_uring_buf *it__iter,
+					   struct bpf_dynptr *ptr__uninit)
+{
+	struct bpf_dynptr_kern *dynptr = (struct bpf_dynptr_kern *)ptr__uninit;
+	struct bpf_iter_uring_buf_kern *kern = iter_kern(it__iter);
+
+	if (!kern->kmap_base || kern->avail <= 0) {
+		bpf_dynptr_set_null(dynptr);
+		return -EINVAL;
+	}
+
+	if (kern->iter.data_source) {  /* ITER_SOURCE — read-only buffer */
+		bpf_dynptr_set_null(dynptr);
+		return -EPERM;
+	}
+
+	bpf_dynptr_init(dynptr, kern->kmap_base,
+			BPF_DYNPTR_TYPE_LOCAL, 0, kern->avail);
+	return 0;
+}
+
+/**
+ * bpf_iter_uring_buf_destroy - Destroy per-buffer iterator (KF_ITER_DESTROY)
+ * @iter: BPF-visible iterator state
+ *
+ * Unmaps page, frees resources, releases submit lock if this
+ * iterator owns it.
+ */
+__bpf_kfunc void bpf_iter_uring_buf_destroy(struct bpf_iter_uring_buf *iter)
+{
+	struct bpf_iter_uring_buf_kern *kern = iter_kern(iter);
+	struct io_ring_ctx *ctx;
+
+	if (!kern->data)
+		return;
+
+	ctx = cmd_to_io_kiocb(kern->data)->ctx;
+
+	iter_unmap_page(kern);
+	io_vec_free(&kern->vec);
+	if (kern->node)
+		io_put_rsrc_node(ctx, kern->node);
+	if (--kern->data->lock_depth == 0)
+		io_ring_submit_unlock(ctx, kern->data->issue_flags);
+	kern->data = NULL;
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(uring_bpf_kfuncs)
 BTF_ID_FLAGS(func, uring_bpf_set_result)
+BTF_ID_FLAGS(func, bpf_iter_uring_buf_new, KF_ITER_NEW)
+BTF_ID_FLAGS(func, bpf_iter_uring_buf_next, KF_ITER_NEXT | KF_RET_NULL)
+BTF_ID_FLAGS(func, bpf_iter_uring_buf_destroy, KF_ITER_DESTROY)
+BTF_ID_FLAGS(func, bpf_uring_buf_dynptr)
+BTF_ID_FLAGS(func, bpf_uring_buf_dynptr_rdwr)
 BTF_KFUNCS_END(uring_bpf_kfuncs)
 
 static const struct btf_kfunc_id_set uring_kfunc_set = {
diff --git a/io_uring/bpf_ext.h b/io_uring/bpf_ext.h
index a568ea31a51a..b0ead4b19293 100644
--- a/io_uring/bpf_ext.h
+++ b/io_uring/bpf_ext.h
@@ -13,10 +13,13 @@ struct uring_bpf_data {
 	void				*req_data;  /* not for bpf prog */
 	const struct uring_bpf_ops	*ops;
 	u32				opf;
+	u32				issue_flags; /* io_uring issue flags */
+	unsigned int			lock_depth; /* not for bpf prog */
 
 	/* writeable for bpf prog */
 	u8              pdu[64 - sizeof(void *) -
-		sizeof(struct uring_bpf_ops *) - sizeof(u32)];
+		sizeof(struct uring_bpf_ops *) - 2 * sizeof(u32) -
+		sizeof(unsigned int)];
 };
 
 typedef int (*uring_bpf_prep_t)(struct uring_bpf_data *data,
@@ -37,8 +40,17 @@ struct uring_bpf_ops {
 /* TODO: manage it via `io_rsrc_node` */
 struct uring_bpf_ops_kern {
 	const struct uring_bpf_ops *ops;
-	int refcount;
+	int refcount;	/* Protected by ctx->uring_lock */
 };
+
+/*
+ * Per-buffer BPF iterator state (lives on BPF stack).
+ * Uses bpf_iter_ prefix for KF_ITER verifier enforcement.
+ * Kernel-internal state is stored inline in the __opaque[] array.
+ */
+struct bpf_iter_uring_buf {
+	__u64 __opaque[12];
+} __aligned(8);
 #ifdef CONFIG_IO_URING_BPF_EXT
 int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-- 
2.53.0


