Return-Path: <io-uring+bounces-6994-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 33923A56CEA
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 17:01:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 941ED17B150
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:00:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9872221571;
	Fri,  7 Mar 2025 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eMtPEhCL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D990922156E
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741363190; cv=none; b=mDYCE3xMCSpkqbKzGOmdNB+0is3+pneDPjlvrIOGIGCIdZNAVKXnbM2abP2hZTW9EQpTl0bSiJp3X3AqPv6OiGUDcAY74vUCAqH/sRu0xkI6nH0pLY79Mo5YJl8raEdym1MgxZbp378WrNwGVhsJP5lsUnf/YQcOjcu0Jvd2k4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741363190; c=relaxed/simple;
	bh=U0p9sJ78MOBEr0imh6uZmRYspNOFe/F09i9T6gAkJRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q8BPvNX+n721LMa16Pfe5Q5uvtVU7qRV+juG6mnglS/yz+Xkv6smu+wGl0e+FIQgvDs31wKfshDTkoeSggngTxMxDjMnHXvYO9ELDIRboJq7nxYy4jJp9qHzZVVJhXdAtKYW8W6eS/JzGpuIgyLy64Y1KJluscpaw9oKcU2zJ3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eMtPEhCL; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5dca468c5e4so3647368a12.1
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741363186; x=1741967986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2v5a/ERJ2E7F2f+gymnI/P8uV1lIMDW+iluW2JhkoQ4=;
        b=eMtPEhCL9UTtaQ/OAhZDPe7kG/cQPSceRxFgrsU0uZ4AMTDRtQYd/gwAB2pSVW+doH
         2RBBex9jmsohcJiRvkjNmzNj5tRTkfTUoFId2Sdqh/loXEZs7qh7gqkReKk0cYYwdD5V
         td4JtYsj1rjv4XvxTzBuNLmmQp8O8iZD8DZAbzmTiejPyXv/geTNb/r/ae/jsLCO3RgA
         kffzyWf4LGW/hfqYg2zK/VPhjWDYJaeAvweFTrintVGlB5ysI9PpJ4IoYekqb9fe3Lz+
         uDNxFZh+d4e9Z9+IFkVkw2djkz5/78sGW7A+guaQIsqflH3GfZRb1Trr586gVzZWauKW
         Zvkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741363186; x=1741967986;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2v5a/ERJ2E7F2f+gymnI/P8uV1lIMDW+iluW2JhkoQ4=;
        b=cYRMyK7XCblxVzHJSOl/3ZILlJD0iFvVNF8wqjyJyNJ0Eh92EZ+pGKWoIvvmjv3rEM
         o0j+ri6Apj0Hk2sXqXyCfIELxWUiz5jnRFmuFP31xX49ao/Fz6ISNqHXA+E5vxPYy82B
         WTNb8L517pS6IekvMBr7FdN+bx3Hxpc3lcpPstF53bbZNQOt7EL8kz3ZE56Pp6sQ1nI7
         rYQ421L2JOSmtDv54Nh3zdwmPKwi4Bv9keTOTczczpzaY9JpUfyTQrdAk0Z631BEC09S
         w5wYH/mNo65q23BytUHmm3ayY2R17TFzoal0cVpYr92PAbO+RDhGQTMVRBKs3VebbtM8
         LfhA==
X-Gm-Message-State: AOJu0Yx6/NtlBdN7MufuUZ8afQtiR9a+JaFbTnifGPMRQrBlQto4OmZQ
	+K4gdPWdjH6tY5X6PsGvYP9RXK0yr88zD4yvYxQZ+Zcc+NvWr/FZb0ZkWA==
X-Gm-Gg: ASbGncvIGiG8EXezglM+3keYvZ8a3te5WvCxcbbXRxeNWfg9mlBN66KeQrczw8/5iaB
	16ctAJ2QpLUgfHM8g6K431Bcjz0ljOVY9xlWlBnMFQuyd3vLHHWqNJPWs5/0Z0K6NaIwjU+msRy
	XL5YCPvf7QQMJYcCY2pztZbkobNdB2OnXdwfC95p8iJlOu3McE2+ZAGEkk8mJf/oid5YjVzKMBs
	oMZlxOiYeDnZvnq/FVkdLhh2uM1pIyRGGYl68fLDH/sRpswIxpGFTZqTulTK8bv9PAdInfS4i+g
	+v2bgZ0M72STR5vMO4fLwmEwqKY2
X-Google-Smtp-Source: AGHT+IFyBk1iPEsq948u7GMSZJTJp5zsg/C/dEwEzsQhr2fbFgt9wUKMWEBMUzcPKpDz5i9dcBxWUQ==
X-Received: by 2002:a17:907:97c6:b0:abf:4c82:22b1 with SMTP id a640c23a62f3a-ac252738126mr428833566b.32.1741363186309;
        Fri, 07 Mar 2025 07:59:46 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:a068])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac2399d7a17sm297369166b.179.2025.03.07.07.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:59:45 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v4 2/9] io_uring: add infra for importing vectored reg buffers
Date: Fri,  7 Mar 2025 16:00:30 +0000
Message-ID: <60bd246b1249476a6996407c1dbc38ef6febad14.1741362889.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741362889.git.asml.silence@gmail.com>
References: <cover.1741362889.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add io_import_reg_vec(), which will be responsible for importing
vectored registered buffers. The function might reallocate the vector,
but it'd try to do the conversion in place first, which is why it's
required of the user to pad the iovec to the right border of the cache.

Overlapping also depends on struct iovec being larger than bvec, which
is not the case on e.g. 32 bit architectures. Don't try to complicate
this case and make sure vectors never overlap, it'll be improved later.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |   7 +-
 io_uring/rsrc.c                | 128 +++++++++++++++++++++++++++++++++
 io_uring/rsrc.h                |   5 ++
 3 files changed, 138 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 9101f12d21ef..cc84f6e5a64c 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -111,8 +111,11 @@ struct io_uring_task {
 };
 
 struct iou_vec {
-	struct iovec		*iovec;
-	unsigned		nr;
+	union {
+		struct iovec	*iovec;
+		struct bio_vec	*bvec;
+	};
+	unsigned		nr; /* number of struct iovec it can hold */
 };
 
 struct io_uring {
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index bac509f85c80..71fe47facd4c 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1269,3 +1269,131 @@ void io_vec_free(struct iou_vec *iv)
 	iv->iovec = NULL;
 	iv->nr = 0;
 }
+
+int io_vec_realloc(struct iou_vec *iv, unsigned nr_entries)
+{
+	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
+	struct iovec *iov;
+
+	iov = kmalloc_array(nr_entries, sizeof(iov[0]), gfp);
+	if (!iov)
+		return -ENOMEM;
+
+	io_vec_free(iv);
+	iv->iovec = iov;
+	iv->nr = nr_entries;
+	return 0;
+}
+
+static int io_vec_fill_bvec(int ddir, struct iov_iter *iter,
+				struct io_mapped_ubuf *imu,
+				struct iovec *iovec, unsigned nr_iovs,
+				struct iou_vec *vec)
+{
+	unsigned long folio_size = 1 << imu->folio_shift;
+	unsigned long folio_mask = folio_size - 1;
+	u64 folio_addr = imu->ubuf & ~folio_mask;
+	struct bio_vec *res_bvec = vec->bvec;
+	size_t total_len = 0;
+	unsigned bvec_idx = 0;
+	unsigned iov_idx;
+
+	for (iov_idx = 0; iov_idx < nr_iovs; iov_idx++) {
+		size_t iov_len = iovec[iov_idx].iov_len;
+		u64 buf_addr = (u64)(uintptr_t)iovec[iov_idx].iov_base;
+		struct bio_vec *src_bvec;
+		size_t offset;
+		u64 buf_end;
+
+		if (unlikely(check_add_overflow(buf_addr, (u64)iov_len, &buf_end)))
+			return -EFAULT;
+		if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
+			return -EFAULT;
+		if (unlikely(!iov_len))
+			return -EFAULT;
+		if (unlikely(check_add_overflow(total_len, iov_len, &total_len)))
+			return -EOVERFLOW;
+
+		/* by using folio address it also accounts for bvec offset */
+		offset = buf_addr - folio_addr;
+		src_bvec = imu->bvec + (offset >> imu->folio_shift);
+		offset &= folio_mask;
+
+		for (; iov_len; offset = 0, bvec_idx++, src_bvec++) {
+			size_t seg_size = min_t(size_t, iov_len,
+						folio_size - offset);
+
+			bvec_set_page(&res_bvec[bvec_idx],
+				      src_bvec->bv_page, seg_size, offset);
+			iov_len -= seg_size;
+		}
+	}
+	if (total_len > MAX_RW_COUNT)
+		return -EINVAL;
+
+	iov_iter_bvec(iter, ddir, res_bvec, bvec_idx, total_len);
+	return 0;
+}
+
+static int io_estimate_bvec_size(struct iovec *iov, unsigned nr_iovs,
+				 struct io_mapped_ubuf *imu)
+{
+	unsigned shift = imu->folio_shift;
+	size_t max_segs = 0;
+	unsigned i;
+
+	for (i = 0; i < nr_iovs; i++)
+		max_segs += (iov[i].iov_len >> shift) + 2;
+	return max_segs;
+}
+
+int io_import_reg_vec(int ddir, struct iov_iter *iter,
+			struct io_kiocb *req, struct iou_vec *vec,
+			unsigned nr_iovs, unsigned iovec_off,
+			unsigned issue_flags)
+{
+	struct io_rsrc_node *node;
+	struct io_mapped_ubuf *imu;
+	struct iovec *iov;
+	unsigned nr_segs;
+
+	node = io_find_buf_node(req, issue_flags);
+	if (!node)
+		return -EFAULT;
+	imu = node->buf;
+	if (imu->is_kbuf)
+		return -EOPNOTSUPP;
+	if (!(imu->dir & (1 << ddir)))
+		return -EFAULT;
+
+	iov = vec->iovec + iovec_off;
+	nr_segs = io_estimate_bvec_size(iov, nr_iovs, imu);
+
+	if (sizeof(struct bio_vec) > sizeof(struct iovec)) {
+		size_t bvec_bytes;
+
+		bvec_bytes = nr_segs * sizeof(struct bio_vec);
+		nr_segs = (bvec_bytes + sizeof(*iov) - 1) / sizeof(*iov);
+		nr_segs += nr_iovs;
+	}
+
+	if (WARN_ON_ONCE(iovec_off + nr_iovs != vec->nr) ||
+	    nr_segs > vec->nr) {
+		struct iou_vec tmp_vec = {};
+		int ret;
+
+		ret = io_vec_realloc(&tmp_vec, nr_segs);
+		if (ret)
+			return ret;
+
+		iovec_off = tmp_vec.nr - nr_iovs;
+		memcpy(tmp_vec.iovec + iovec_off, iov, sizeof(*iov) * nr_iovs);
+		io_vec_free(vec);
+
+		*vec = tmp_vec;
+		iov = vec->iovec + iovec_off;
+		req->flags |= REQ_F_NEED_CLEANUP;
+	}
+
+	return io_vec_fill_bvec(ddir, iter, imu, iov, nr_iovs, vec);
+}
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f35e1a07619a..0d5c18296130 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -61,6 +61,10 @@ struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
 			unsigned issue_flags);
+int io_import_reg_vec(int ddir, struct iov_iter *iter,
+			struct io_kiocb *req, struct iou_vec *vec,
+			unsigned nr_iovs, unsigned iovec_off,
+			unsigned issue_flags);
 
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
@@ -146,6 +150,7 @@ static inline void __io_unaccount_mem(struct user_struct *user,
 }
 
 void io_vec_free(struct iou_vec *iv);
+int io_vec_realloc(struct iou_vec *iv, unsigned nr_entries);
 
 static inline void io_vec_reset_iovec(struct iou_vec *iv,
 				      struct iovec *iovec, unsigned nr)
-- 
2.48.1


