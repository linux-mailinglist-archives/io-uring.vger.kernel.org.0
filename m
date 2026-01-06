Return-Path: <io-uring+bounces-11408-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D87A2CF7B45
	for <lists+io-uring@lfdr.de>; Tue, 06 Jan 2026 11:12:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 214E830205EB
	for <lists+io-uring@lfdr.de>; Tue,  6 Jan 2026 10:12:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA8631AAAA;
	Tue,  6 Jan 2026 10:12:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zzy6np0d"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4D03161BA
	for <io-uring@vger.kernel.org>; Tue,  6 Jan 2026 10:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694342; cv=none; b=Fmf2lh9F5GERIxLaEiNYhnn2QeLTBoSDtVBVGk8L1+MFvbK+2KEtV8M5CePqtPEND1l2h9EyEwWE58Wfm3h+688/GlrT0IESpfx8swE4vi0t5VTnVsHI+XLD/i0MTavtidALUUvunTCNDc/wZyZyPsVw8pd4J/8fcUXo4dumAEw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694342; c=relaxed/simple;
	bh=l4avHik+xbgU6/yiPPYDse2suCpD6IjyDV7sCAYyoTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXp1kWEp+X4SQ5vQdEmJA+nY/LNe2xhxVYEJrYiUL/lSMk+xvYrZPTtKN/c2ZlWf33gQnMR/O8G3BOe6WSEkGf5M8dRK4qsX+PLur26L0/inlmnEt59ohem6JQy7K6NAayu1VAzBCa/uEOaou+Fo8eUZZD36yiyIsxtwyjSajPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zzy6np0d; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767694336;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lIuRgZIqOXcaliaRTL96gFLo0Q/XQaXw8zZIiq2eSes=;
	b=Zzy6np0d/cZMyB1NFV3Swl7+3DzHutJrsRwrSxg9W+MVjCtNyNRefYN7IDUnjBopD6S0tz
	mcXgh1ey3nMnZW7zvzo+odJZoldXVOPJngTX73/17nauXUKIhPvzgCXxealhUwIaW10WbN
	LP545IrFmrIkvfhZEuWrcyt05CmRd20=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-558-uDx3Qd4kMKOmy4r5SdEoKA-1; Tue,
 06 Jan 2026 05:12:11 -0500
X-MC-Unique: uDx3Qd4kMKOmy4r5SdEoKA-1
X-Mimecast-MFC-AGG-ID: uDx3Qd4kMKOmy4r5SdEoKA_1767694330
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 177FA1956080;
	Tue,  6 Jan 2026 10:12:10 +0000 (UTC)
Received: from localhost (unknown [10.72.116.130])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3A7BF30001A7;
	Tue,  6 Jan 2026 10:12:08 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Stefan Metzmacher <metze@samba.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 08/13] io_uring: bpf: add uring_bpf_memcpy() kfunc
Date: Tue,  6 Jan 2026 18:11:17 +0800
Message-ID: <20260106101126.4064990-9-ming.lei@redhat.com>
In-Reply-To: <20260106101126.4064990-1-ming.lei@redhat.com>
References: <20260106101126.4064990-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Add uring_bpf_memcpy() kfunc that copies data between io_uring BPF
buffers. This kfunc supports all 5 buffer types defined in
io_bpf_buf_desc:

- IO_BPF_BUF_USER: plain userspace buffer
- IO_BPF_BUF_FIXED: fixed buffer (absolute address within buffer)
- IO_BPF_BUF_VEC: vectored userspace buffer (iovec array)
- IO_BPF_BUF_KFIXED: kernel fixed buffer (offset-based addressing)
- IO_BPF_BUF_KVEC: kernel vectored buffer

Add helper functions for buffer import:
- io_bpf_import_fixed_buf(): handles FIXED/KFIXED types with proper
  node reference counting
- io_bpf_import_kvec_buf(): handles KVEC using __io_prep_reg_iovec()
  and __io_import_reg_vec()
- io_bpf_import_buffer(): unified dispatcher for all buffer types
- io_bpf_copy_iters(): page-based copy between iov_iters

The kfunc properly manages buffer node references and submit lock
for registered buffer access.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/bpf_op.c | 320 +++++++++++++++++++++++++++++++++++++++++++++-
 io_uring/bpf_op.h |   3 +-
 2 files changed, 321 insertions(+), 2 deletions(-)

diff --git a/io_uring/bpf_op.c b/io_uring/bpf_op.c
index d6f146abe304..3c577aa3dfc4 100644
--- a/io_uring/bpf_op.c
+++ b/io_uring/bpf_op.c
@@ -10,9 +10,11 @@
 #include <linux/btf.h>
 #include <linux/btf_ids.h>
 #include <linux/filter.h>
+#include <linux/uio.h>
 #include <uapi/linux/io_uring.h>
 #include "io_uring.h"
 #include "register.h"
+#include "rsrc.h"
 #include "bpf_op.h"
 
 static inline unsigned char uring_bpf_get_op(u32 op_flags)
@@ -47,6 +49,7 @@ int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	data->opf = opf;
 	data->ops = ops;
+	data->issue_flags = 0;
 	ret = ops->prep_fn(data, sqe);
 	if (!ret) {
 		/* Only increment refcount on success (uring_lock already held) */
@@ -74,7 +77,13 @@ static int __io_uring_bpf_issue(struct io_kiocb *req)
 
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
@@ -291,6 +300,235 @@ static struct bpf_struct_ops bpf_uring_bpf_ops = {
 	.owner = THIS_MODULE,
 };
 
+/*
+ * Helper to copy data between two iov_iters using page extraction.
+ * Extracts pages from source iterator and copies them to destination.
+ * Returns number of bytes copied or negative error code.
+ */
+static ssize_t io_bpf_copy_iters(struct iov_iter *src, struct iov_iter *dst,
+				 size_t len)
+{
+#define MAX_PAGES_PER_LOOP 32
+	struct page *pages[MAX_PAGES_PER_LOOP];
+	size_t total_copied = 0;
+	bool need_unpin;
+
+	need_unpin = iov_iter_extract_will_pin(src);
+
+	while (len > 0) {
+		struct page **page_array = pages;
+		size_t offset, copied = 0;
+		ssize_t extracted;
+		unsigned int nr_pages;
+		size_t chunk_len;
+		int i;
+
+		chunk_len = min_t(size_t, len, MAX_PAGES_PER_LOOP * PAGE_SIZE);
+		extracted = iov_iter_extract_pages(src, &page_array, chunk_len,
+						   MAX_PAGES_PER_LOOP, 0, &offset);
+		if (extracted <= 0) {
+			if (total_copied > 0)
+				break;
+			return extracted < 0 ? extracted : -EFAULT;
+		}
+
+		nr_pages = DIV_ROUND_UP(offset + extracted, PAGE_SIZE);
+
+		for (i = 0; i < nr_pages && copied < extracted; i++) {
+			size_t page_offset = (i == 0) ? offset : 0;
+			size_t page_len = min_t(size_t, extracted - copied,
+						PAGE_SIZE - page_offset);
+			size_t n;
+
+			n = copy_page_to_iter(page_array[i], page_offset, page_len, dst);
+			copied += n;
+			if (n < page_len)
+				break;
+		}
+
+		if (need_unpin)
+			unpin_user_pages(page_array, nr_pages);
+
+		total_copied += copied;
+		len -= copied;
+
+		if (copied < extracted)
+			break;
+	}
+
+	return total_copied;
+#undef MAX_PAGES_PER_LOOP
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
+ * Helper to import registered vectored buffer (KVEC).
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
+				  desc->len, ctx->compat, NULL);
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
+			      nr_vecs, iov, ctx->compat);
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
+ * Supports all 5 buffer types: USER, FIXED, VEC, KFIXED, KVEC.
+ * Must be called with submit lock held for FIXED/KFIXED/KVEC types.
+ *
+ * @ctx: ring context
+ * @iter: output iterator
+ * @desc: buffer descriptor
+ * @ddir: direction (ITER_SOURCE for source, ITER_DEST for destination)
+ * @vec: iou_vec for VEC/KVEC types (caller must call io_vec_free after use)
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
@@ -300,10 +538,90 @@ __bpf_kfunc void uring_bpf_set_result(struct uring_bpf_data *data, int res)
 		req_set_fail(req);
 	io_req_set_res(req, res, 0);
 }
+
+/**
+ * uring_bpf_memcpy - Copy data between io_uring BPF buffers
+ * @data: BPF request data containing request context
+ * @dst: Destination buffer descriptor
+ * @src: Source buffer descriptor
+ *
+ * Copies data from source buffer to destination buffer.
+ * Supports all 5 buffer types: USER, FIXED, VEC, KFIXED, REG_VEC.
+ * The copy length is min of actual buffer sizes (for VEC types,
+ * total bytes across all vectors, not nr_vecs).
+ *
+ * Returns: Number of bytes copied on success, negative error code on failure
+ */
+__bpf_kfunc ssize_t uring_bpf_memcpy(const struct uring_bpf_data *data,
+				     struct io_bpf_buf_desc *dst,
+				     struct io_bpf_buf_desc *src)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb((void *)data);
+	struct io_ring_ctx *ctx = req->ctx;
+	unsigned int issue_flags = data->issue_flags;
+	struct io_rsrc_node *src_node, *dst_node;
+	struct iov_iter src_iter, dst_iter;
+	struct iou_vec src_vec = {};
+	struct iou_vec dst_vec = {};
+	ssize_t ret;
+	size_t len;
+
+	/* Validate buffer types */
+	if (src->type > IO_BPF_BUF_REG_VEC || dst->type > IO_BPF_BUF_REG_VEC)
+		return -EINVAL;
+
+	io_ring_submit_lock(ctx, issue_flags);
+
+	/* Import source buffer */
+	src_node = io_bpf_import_buffer(ctx, &src_iter, src, ITER_SOURCE,
+					&src_vec);
+	if (IS_ERR(src_node)) {
+		ret = PTR_ERR(src_node);
+		goto unlock;
+	}
+
+	/* Import destination buffer */
+	dst_node = io_bpf_import_buffer(ctx, &dst_iter, dst, ITER_DEST,
+					&dst_vec);
+	if (IS_ERR(dst_node)) {
+		ret = PTR_ERR(dst_node);
+		goto put_src;
+	}
+
+	/*
+	 * Calculate copy length from actual iterator sizes.
+	 * For VEC types, desc->len is nr_vecs, not total bytes.
+	 */
+	len = min(iov_iter_count(&src_iter), iov_iter_count(&dst_iter));
+	if (!len) {
+		ret = 0;
+		goto put_dst;
+	}
+	if (len > MAX_RW_COUNT) {
+		ret = -EINVAL;
+		goto put_dst;
+	}
+
+	/* Copy data between iterators */
+	ret = io_bpf_copy_iters(&src_iter, &dst_iter, len);
+
+put_dst:
+	io_vec_free(&dst_vec);
+	if (dst_node)
+		io_put_rsrc_node(ctx, dst_node);
+put_src:
+	io_vec_free(&src_vec);
+	if (src_node)
+		io_put_rsrc_node(ctx, src_node);
+unlock:
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(uring_bpf_kfuncs)
 BTF_ID_FLAGS(func, uring_bpf_set_result)
+BTF_ID_FLAGS(func, uring_bpf_memcpy)
 BTF_KFUNCS_END(uring_bpf_kfuncs)
 
 static const struct btf_kfunc_id_set uring_kfunc_set = {
diff --git a/io_uring/bpf_op.h b/io_uring/bpf_op.h
index 9de0606f5d25..6004fb906983 100644
--- a/io_uring/bpf_op.h
+++ b/io_uring/bpf_op.h
@@ -13,10 +13,11 @@ struct uring_bpf_data {
 	void				*req_data;  /* not for bpf prog */
 	const struct uring_bpf_ops	*ops;
 	u32				opf;
+	u32				issue_flags; /* io_uring issue flags */
 
 	/* writeable for bpf prog */
 	u8              pdu[64 - sizeof(void *) -
-		sizeof(struct uring_bpf_ops *) - sizeof(u32)];
+		sizeof(struct uring_bpf_ops *) - 2 * sizeof(u32)];
 };
 
 typedef int (*uring_bpf_prep_t)(struct uring_bpf_data *data,
-- 
2.47.0


