Return-Path: <io-uring+bounces-7237-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10F19A70305
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 15:00:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B0E761881FE2
	for <lists+io-uring@lfdr.de>; Tue, 25 Mar 2025 13:52:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF0D81DB13E;
	Tue, 25 Mar 2025 13:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P/+ugtTb"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40AB9256C75
	for <io-uring@vger.kernel.org>; Tue, 25 Mar 2025 13:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742910754; cv=none; b=XEMK29fv0fnR8n6MEwWUd6s2NVY/xN/GrDgnaOgu+coHiTlysZVdaR6aiaBIZkh9RpvZnsWqMVyVfGhyor3DQAJ/KOOzO4EIZrH5lt7YlEc3qkjOgh3XYiyu8tXKD+PjPyFDUjFdMxuYPVEoa8CdfvQb0wWUb/3e5zVAUkh3jIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742910754; c=relaxed/simple;
	bh=xC5jHNKqqEiRST7J4W7wXXcX3FjSXb2UBy0qCybYSC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBoop+kx4zUxNr/egoo1QfGcr2f8mihWLH4QyHspDzjUQ3rarVmFX2ll5LovwCxtxUXivWr6YdAA54YRwtIIfj7sTIlADIuzFApUsT7yW9ESLj86LeKHO0kMdSJbCI9rtzVhy1q12h1VhQQFneRrLipnP063Aj4F/6rX9svpykA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P/+ugtTb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1742910751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FSKH4e2Fb33UlC0fmIIAjWv0Vd+y7es6lWS9fQAoc/8=;
	b=P/+ugtTbLYqZxZEakF9ZTl4W1xWIC7v1GPjC1thzXpmKIoScViMiiLj+95evk1+p3vWxeR
	4moofKGfyJoN6VuUTa+Yo75F9qgw8v1BerdHy+oiaME+hWgHzQ6K8fv9z5j2RdYpRdZd0e
	dy503X/MBMZgY1/kiHqR//YDAZzaudg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-524-A5g7ZeirPQWmwTIFj9YBlw-1; Tue,
 25 Mar 2025 09:52:26 -0400
X-MC-Unique: A5g7ZeirPQWmwTIFj9YBlw-1
X-Mimecast-MFC-AGG-ID: A5g7ZeirPQWmwTIFj9YBlw_1742910745
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 39ABE180AF4E;
	Tue, 25 Mar 2025 13:52:25 +0000 (UTC)
Received: from localhost (unknown [10.72.120.3])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1AF2C3001D11;
	Tue, 25 Mar 2025 13:52:23 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	io-uring@vger.kernel.org,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 3/4] io_uring: support vectored kernel fixed buffer
Date: Tue, 25 Mar 2025 21:51:52 +0800
Message-ID: <20250325135155.935398-4-ming.lei@redhat.com>
In-Reply-To: <20250325135155.935398-1-ming.lei@redhat.com>
References: <20250325135155.935398-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

io_uring has supported fixed kernel buffer via io_buffer_register_bvec()
and io_buffer_unregister_bvec().

The vectored fixed buffer has been ready, so it is natural to support
fixed kernel buffer, one use case is ublk.

Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/rsrc.c | 91 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 88 insertions(+), 3 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 52e7492e863e..82a7c2fcf58f 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1361,6 +1361,82 @@ static int io_estimate_bvec_size(struct iovec *iov, unsigned nr_iovs,
 	return max_segs;
 }
 
+static int io_vec_fill_kern_bvec(int ddir, struct iov_iter *iter,
+				 struct io_mapped_ubuf *imu,
+				 struct iovec *iovec, unsigned nr_iovs,
+				 struct iou_vec *vec)
+{
+	const struct bio_vec *src_bvec = imu->bvec;
+	struct bio_vec *res_bvec = vec->bvec;
+	unsigned res_idx = 0;
+	size_t total_len = 0;
+	unsigned iov_idx;
+
+	for (iov_idx = 0; iov_idx < nr_iovs; iov_idx++) {
+		size_t offset = (size_t)(uintptr_t)iovec[iov_idx].iov_base;
+		size_t iov_len = iovec[iov_idx].iov_len;
+		struct bvec_iter bi = {
+			.bi_size        = offset + iov_len,
+		};
+		struct bio_vec bv;
+
+		bvec_iter_advance(src_bvec, &bi, offset);
+		for_each_mp_bvec(bv, src_bvec, bi, bi)
+			res_bvec[res_idx++] = bv;
+		total_len += iov_len;
+	}
+	iov_iter_bvec(iter, ddir, res_bvec, res_idx, total_len);
+	return 0;
+}
+
+static int iov_kern_bvec_size(const struct iovec *iov,
+			      const struct io_mapped_ubuf *imu,
+			      unsigned int *nr_seg)
+{
+	size_t offset = (size_t)(uintptr_t)iov->iov_base;
+	const struct bio_vec *bvec = imu->bvec;
+	int start = 0, i = 0;
+	size_t off = 0;
+	int ret;
+
+	ret = validate_fixed_range(offset, iov->iov_len, imu);
+	if (unlikely(ret))
+		return ret;
+
+	for (i = 0; off < offset + iov->iov_len && i < imu->nr_bvecs;
+			off += bvec[i].bv_len, i++) {
+		if (offset >= off && offset < off + bvec[i].bv_len)
+			start = i;
+	}
+	*nr_seg = i - start;
+	return 0;
+}
+
+static int io_kern_bvec_size(struct iovec *iov, unsigned nr_iovs,
+			     struct io_mapped_ubuf *imu, unsigned *nr_segs)
+{
+	unsigned max_segs = 0;
+	size_t total_len = 0;
+	unsigned i;
+	int ret;
+
+	*nr_segs = 0;
+	for (i = 0; i < nr_iovs; i++) {
+		if (unlikely(!iov[i].iov_len))
+			return -EFAULT;
+		if (unlikely(check_add_overflow(total_len, iov[i].iov_len,
+						&total_len)))
+			return -EOVERFLOW;
+		ret = iov_kern_bvec_size(&iov[i], imu, &max_segs);
+		if (unlikely(ret))
+			return ret;
+		*nr_segs += max_segs;
+	}
+	if (total_len > MAX_RW_COUNT)
+		return -EINVAL;
+	return 0;
+}
+
 int io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
 			unsigned nr_iovs, unsigned issue_flags)
@@ -1375,14 +1451,20 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 	if (!node)
 		return -EFAULT;
 	imu = node->buf;
-	if (imu->is_kbuf)
-		return -EOPNOTSUPP;
 	if (!(imu->dir & (1 << ddir)))
 		return -EFAULT;
 
 	iovec_off = vec->nr - nr_iovs;
 	iov = vec->iovec + iovec_off;
-	nr_segs = io_estimate_bvec_size(iov, nr_iovs, imu);
+
+	if (imu->is_kbuf) {
+		int ret = io_kern_bvec_size(iov, nr_iovs, imu, &nr_segs);
+
+		if (unlikely(ret))
+			return ret;
+	} else {
+		nr_segs = io_estimate_bvec_size(iov, nr_iovs, imu);
+	}
 
 	if (sizeof(struct bio_vec) > sizeof(struct iovec)) {
 		size_t bvec_bytes;
@@ -1409,6 +1491,9 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 
+	if (imu->is_kbuf)
+		return io_vec_fill_kern_bvec(ddir, iter, imu, iov, nr_iovs, vec);
+
 	return io_vec_fill_bvec(ddir, iter, imu, iov, nr_iovs, vec);
 }
 
-- 
2.47.0


