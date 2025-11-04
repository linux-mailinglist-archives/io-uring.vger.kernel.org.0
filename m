Return-Path: <io-uring+bounces-10367-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id A8CA6C320AD
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 17:25:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id DC01E4EDDC1
	for <lists+io-uring@lfdr.de>; Tue,  4 Nov 2025 16:23:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D656B3328FC;
	Tue,  4 Nov 2025 16:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fLezMGNP"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4DF332904
	for <io-uring@vger.kernel.org>; Tue,  4 Nov 2025 16:22:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762273341; cv=none; b=gRlg11ZkmgKDl1bDNi+OcybDp1P+skbnKPkZKrcC8U0T71WU23tC5Ng3QvkCzy3gvqlBM20W0uJgh75XTHc0IptVH6rwF/v3LsyacddNaswqeQD9MbeUGz77WJR/PlpP/oTnKQo+4+EoGX0fJ4BKgdZG2Em4Q/FEUWEVajiffHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762273341; c=relaxed/simple;
	bh=9nX5xjtA9vpeYlJWQZKG6ebvdDJnlTVAvm9dQ4RUdS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JF17YyefBF1Xdpm7/BprH4JIl3q7m9bm5MUaqKZQLeXTAgLc6QJzVnCpRO8HKcmEUZuX2IW9qTZChvlO1vS/V1pAZRSfrStI5/hk7m7Mc10yERbTx/qzYp84VRoNc33ccdQYmQbj/b1kUMOJtcG5PkbTBPU4mwH2F2RVlufCtKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fLezMGNP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762273338;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gU+qzLKXpFRDi6cO0HCCbiXo5koipi4+wzVgM5+NypY=;
	b=fLezMGNP0qiCKISlSMJsrfAmerATYndC6OBUhOS97GzS/uorekjN2WDEneRr48x5TvoRld
	yJ8C4d/gyCvxKzi+c70pIzmGOvXjVilf9XfNiVs35yo5T+GgmykVMsjHGtTgdqF+p2rQoS
	9LUHovPcs7bxDSMU/KHD3M1y8bf792Y=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-317-C9JGyS2qPrWPFFhiM4DuJg-1; Tue,
 04 Nov 2025 11:22:15 -0500
X-MC-Unique: C9JGyS2qPrWPFFhiM4DuJg-1
X-Mimecast-MFC-AGG-ID: C9JGyS2qPrWPFFhiM4DuJg_1762273333
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C6E851954B17;
	Tue,  4 Nov 2025 16:22:13 +0000 (UTC)
Received: from localhost (unknown [10.72.120.7])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 954C61800451;
	Tue,  4 Nov 2025 16:22:12 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Akilesh Kailash <akailash@google.com>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <ast@kernel.org>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 5/5] io_uring: bpf: add io_uring_bpf_req_memcpy() kfunc
Date: Wed,  5 Nov 2025 00:21:20 +0800
Message-ID: <20251104162123.1086035-6-ming.lei@redhat.com>
In-Reply-To: <20251104162123.1086035-1-ming.lei@redhat.com>
References: <20251104162123.1086035-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

Add io_uring_bpf_req_memcpy() kfunc to enable BPF programs to copy
data between buffers associated with IORING_OP_BPF requests.

The kfunc supports copying between:
- Plain user buffers (using import_ubuf())
- Fixed/registered buffers (using io_import_reg_buf())
- Mixed combinations (plain-to-fixed, fixed-to-plain)

This enables BPF programs to implement data transformation and
processing operations directly within io_uring's request context,
avoiding additional userspace copies.

Implementation details:

1. Add issue_flags tracking in struct uring_bpf_data:
   - Replace __pad field with issue_flags (bytes 36-39)
   - Initialized to 0 before ops->prep_fn()
   - Saved from issue_flags parameter before ops->issue_fn()
   - Required by io_import_reg_buf() for proper async handling

2. Add buffer preparation infrastructure:
   - io_bpf_prep_buffers() extracts buffer metadata from SQE
   - Buffer 1: plain (addr/len) or fixed (buf_index/addr/len)
   - Buffer 2: plain only (addr3/optlen)
   - Buffer types encoded in sqe->bpf_op_flags bits 23-18

3. io_uring_bpf_req_memcpy() implementation:
   - Validates buffer IDs (1 or 2) and prevents same-buffer copies
   - Extracts buffer metadata based on buffer ID
   - Sets up iov_iters using import_ubuf() or io_import_reg_buf()
   - Performs page-sized chunked copying via temporary buffer
   - Returns bytes copied or negative error code

Buffer encoding in sqe->bpf_op_flags (32 bits):
  Bits 31-24: BPF operation ID (8 bits)
  Bits 23-21: Buffer 1 type (0=none, 1=plain, 2=fixed)
  Bits 20-18: Buffer 2 type (0=none, 1=plain)
  Bits 17-0:  Custom BPF flags (18 bits)

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/bpf.c       | 187 +++++++++++++++++++++++++++++++++++++++++++
 io_uring/uring_bpf.h |  11 ++-
 2 files changed, 197 insertions(+), 1 deletion(-)

diff --git a/io_uring/bpf.c b/io_uring/bpf.c
index e837c3d57b96..ee4c617e3904 100644
--- a/io_uring/bpf.c
+++ b/io_uring/bpf.c
@@ -109,6 +109,8 @@ int io_uring_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (ret)
 		return ret;
 
+	/* ctx->uring_lock is held */
+	data->issue_flags = 0;
 	if (ops->prep_fn)
 		return ops->prep_fn(data, sqe);
 	return -EOPNOTSUPP;
@@ -126,6 +128,9 @@ static int __io_uring_bpf_issue(struct io_kiocb *req)
 
 int io_uring_bpf_issue(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
+
+	data->issue_flags = issue_flags;
 	if (issue_flags & IO_URING_F_UNLOCKED) {
 		int idx, ret;
 
@@ -143,6 +148,8 @@ void io_uring_bpf_fail(struct io_kiocb *req)
 	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
 	struct uring_bpf_ops *ops = uring_bpf_get_ops(data);
 
+	/* ctx->uring_lock is held */
+	data->issue_flags = 0;
 	if (ops->fail_fn)
 		ops->fail_fn(data);
 }
@@ -152,6 +159,8 @@ void io_uring_bpf_cleanup(struct io_kiocb *req)
 	struct uring_bpf_data *data = io_kiocb_to_cmd(req, struct uring_bpf_data);
 	struct uring_bpf_ops *ops = uring_bpf_get_ops(data);
 
+	/* ctx->uring_lock is held */
+	data->issue_flags = 0;
 	if (ops->cleanup_fn)
 		ops->cleanup_fn(data);
 }
@@ -324,6 +333,104 @@ static struct bpf_struct_ops bpf_uring_bpf_ops = {
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
+	/* Determine if we'll need to unpin pages later */
+	need_unpin = user_backed_iter(src);
+
+	/* Process pages in chunks */
+	while (len > 0) {
+		struct page **page_array = pages;
+		size_t offset, copied = 0;
+		ssize_t extracted;
+		unsigned int nr_pages;
+		size_t chunk_len;
+		int i;
+
+		/* Extract up to MAX_PAGES_PER_LOOP pages */
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
+		/* Copy pages to destination iterator */
+		for (i = 0; i < nr_pages && copied < extracted; i++) {
+			size_t page_offset = (i == 0) ? offset : 0;
+			size_t page_len = min_t(size_t, extracted - copied,
+						PAGE_SIZE - page_offset);
+			size_t n;
+
+			n = copy_page_to_iter(pages[i], page_offset, page_len, dst);
+			copied += n;
+			if (n < page_len)
+				break;
+		}
+
+		/* Clean up extracted pages */
+		if (need_unpin)
+			unpin_user_pages(pages, nr_pages);
+
+		total_copied += copied;
+		len -= copied;
+
+		/* Stop if we didn't copy all extracted data */
+		if (copied < extracted)
+			break;
+	}
+
+	return total_copied;
+#undef MAX_PAGES_PER_LOOP
+}
+
+/*
+ * Helper to import a buffer into an iov_iter for BPF memcpy operations.
+ * Handles both plain user buffers and fixed/registered buffers.
+ *
+ * @req: io_kiocb request
+ * @iter: output iterator
+ * @buf_type: buffer type (plain or fixed)
+ * @addr: buffer address
+ * @offset: offset into buffer
+ * @len: length from offset
+ * @direction: ITER_SOURCE for source buffer, ITER_DEST for destination
+ * @issue_flags: io_uring issue flags
+ *
+ * Returns 0 on success, negative error code on failure.
+ */
+static int io_bpf_import_buffer(struct io_kiocb *req, struct iov_iter *iter,
+				u8 buf_type, u64 addr, unsigned int offset,
+				u32 len, int direction, unsigned int issue_flags)
+{
+	if (buf_type == IORING_BPF_BUF_TYPE_PLAIN) {
+		/* Plain user buffer */
+		return import_ubuf(direction, (void __user *)(addr + offset),
+				   len - offset, iter);
+	} else if (buf_type == IORING_BPF_BUF_TYPE_FIXED) {
+		/* Fixed buffer */
+		return io_import_reg_buf(req, iter, addr + offset,
+					 len - offset, direction, issue_flags);
+	}
+
+	return -EINVAL;
+}
+
 __bpf_kfunc_start_defs();
 __bpf_kfunc void uring_bpf_set_result(struct uring_bpf_data *data, int res)
 {
@@ -339,11 +446,91 @@ __bpf_kfunc struct io_kiocb *uring_bpf_data_to_req(struct uring_bpf_data *data)
 {
 	return cmd_to_io_kiocb(data);
 }
+
+/**
+ * io_uring_bpf_req_memcpy - Copy data between io_uring BPF request buffers
+ * @data: BPF request data containing buffer metadata
+ * @dest: Destination buffer descriptor (with buf_id and offset)
+ * @src: Source buffer descriptor (with buf_id and offset)
+ * @len: Number of bytes to copy
+ *
+ * Copies data between two different io_uring BPF request buffers (buf_id 1 and 2).
+ * Supports: plain-to-plain, fixed-to-plain, and plain-to-fixed.
+ * Does not support copying within the same buffer (src and dest must be different).
+ *
+ * Returns: Number of bytes copied on success, negative error code on failure
+ */
+__bpf_kfunc int io_uring_bpf_req_memcpy(struct uring_bpf_data *data,
+					struct bpf_req_mem_desc *dest,
+					struct bpf_req_mem_desc *src,
+					unsigned int len)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(data);
+	struct iov_iter dst_iter, src_iter;
+	u8 dst_type, src_type;
+	u64 dst_addr, src_addr;
+	u32 dst_len, src_len;
+	int ret;
+
+	/* Validate buffer IDs */
+	if (dest->buf_id < 1 || dest->buf_id > 2 ||
+	    src->buf_id < 1 || src->buf_id > 2)
+		return -EINVAL;
+
+	/* Don't allow copying within the same buffer */
+	if (src->buf_id == dest->buf_id)
+		return -EINVAL;
+
+	/* Extract source buffer metadata */
+	if (src->buf_id == 1) {
+		src_type = IORING_BPF_BUF1_TYPE(data->opf);
+		src_addr = data->buf1_addr;
+		src_len = data->buf1_len;
+	} else {
+		src_type = IORING_BPF_BUF2_TYPE(data->opf);
+		src_addr = data->buf2_addr;
+		src_len = data->buf2_len;
+	}
+
+	/* Extract destination buffer metadata */
+	if (dest->buf_id == 1) {
+		dst_type = IORING_BPF_BUF1_TYPE(data->opf);
+		dst_addr = data->buf1_addr;
+		dst_len = data->buf1_len;
+	} else {
+		dst_type = IORING_BPF_BUF2_TYPE(data->opf);
+		dst_addr = data->buf2_addr;
+		dst_len = data->buf2_len;
+	}
+
+	/* Validate offsets and lengths */
+	if (src->offset + len > src_len || dest->offset + len > dst_len)
+		return -EINVAL;
+
+	/* Initialize source iterator */
+	ret = io_bpf_import_buffer(req, &src_iter, src_type,
+				   src_addr, src->offset, src_len,
+				   ITER_SOURCE, data->issue_flags);
+	if (ret)
+		return ret;
+
+	/* Initialize destination iterator */
+	ret = io_bpf_import_buffer(req, &dst_iter, dst_type,
+				   dst_addr, dest->offset, dst_len,
+				   ITER_DEST, data->issue_flags);
+	if (ret)
+		return ret;
+
+	/* Extract pages from source iterator and copy to destination */
+	return io_bpf_copy_iters(&src_iter, &dst_iter, len);
+}
+
 __bpf_kfunc_end_defs();
 
 BTF_KFUNCS_START(uring_bpf_kfuncs)
 BTF_ID_FLAGS(func, uring_bpf_set_result)
 BTF_ID_FLAGS(func, uring_bpf_data_to_req)
+BTF_ID_FLAGS(func, io_uring_bpf_req_memcpy)
 BTF_KFUNCS_END(uring_bpf_kfuncs)
 
 static const struct btf_kfunc_id_set uring_kfunc_set = {
diff --git a/io_uring/uring_bpf.h b/io_uring/uring_bpf.h
index c919931cb4b0..d6e0d6dff82e 100644
--- a/io_uring/uring_bpf.h
+++ b/io_uring/uring_bpf.h
@@ -14,13 +14,22 @@ struct uring_bpf_data {
 	/* Buffer 2 metadata - readable for bpf prog (plain only) */
 	u64		buf2_addr;		/* buffer 2 address, bytes 24-31 */
 	u32		buf2_len;		/* buffer 2 length, bytes 32-35 */
-	u32		__pad;			/* padding, bytes 36-39 */
+	u32		issue_flags;		/* issue_flags from io_uring, bytes 36-39 */
 
 	/* writeable for bpf prog */
 	u8              pdu[64 - sizeof(struct file *) - 4 * sizeof(u32) -
 		2 * sizeof(u64)];
 };
 
+/*
+ * Descriptor for io_uring BPF request buffer.
+ * Used by io_uring_bpf_req_memcpy() to identify which buffer to copy from/to.
+ */
+struct bpf_req_mem_desc {
+	u8		buf_id;		/* Buffer ID: 1 or 2 */
+	unsigned int	offset;		/* Offset into buffer */
+};
+
 typedef int (*uring_io_prep_t)(struct uring_bpf_data *data,
 			       const struct io_uring_sqe *sqe);
 typedef int (*uring_io_issue_t)(struct uring_bpf_data *data);
-- 
2.47.0


