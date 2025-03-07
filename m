Return-Path: <io-uring+bounces-6984-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 650C1A56C85
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 16:48:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AE58E1890A48
	for <lists+io-uring@lfdr.de>; Fri,  7 Mar 2025 15:48:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 895DB21CFF6;
	Fri,  7 Mar 2025 15:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JBSWF2ww"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916F0DF71
	for <io-uring@vger.kernel.org>; Fri,  7 Mar 2025 15:48:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741362496; cv=none; b=VYy1uUm1c3muAchS4qelkClMmmjtmZTKsHmg063UCedD8PSKEaajcgH/wHX2OcmXjveCbDUHdWMlTGYCxnn33ZZkNtHyEatn3e+9X6EvB6m93ImcmO+L7WpaaRBmvFsN7q0ODL2LlqqYVXuMoBG2hpd4EgbrRvIq1omZftmP8uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741362496; c=relaxed/simple;
	bh=+R+is5ZIjZWSMpaQwhdZechILV8Q6KDGIXuR4qpgbSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CWOsmNC21//IWC3vcNDTEOqfGm5uJ/ckakF84kb2aoXY33OyStEB6nr1XR/I9HmdbXWaIh1qz0oqgZ4GkduQ1f8rH2KNiQ964KjIBkMN18RGV7uE34VWStv3Vt+auPMx6f7hbiyDlMqzwrxlKcZcE4VbEGa7v4Z/SpJIKQNHepA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JBSWF2ww; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5e5e22e6ed2so1772167a12.3
        for <io-uring@vger.kernel.org>; Fri, 07 Mar 2025 07:48:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741362492; x=1741967292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ERi6eo1GFgBzJUmgrKyeNKQEukSFbVEJOWBSsBRX7ZQ=;
        b=JBSWF2wwsYXVWzwH0gTF5tCiN4Uyu+hvSQuAiW0IA8sYG17eOzk4eL0+8taTn1InVm
         lnqKWd33JCWBxnaaTXZGyyMqiZ66qUMu/8+MZKS1bzBLbo99FuvtgP8pgTga/yGrgMVO
         b5CeB2anKEqXHGo/XsBwkHFLiIrrUmLl+1ZJRDucpcfyQuJ5DChjOkqm8iMfek/+VnyH
         4aioWWOLlosnQ7JRV8EhyK02zpIon3DKIiCFyvAG6+nM/clu881mSsI3nvpotFpZcLM6
         MPRkvsaRq34zRNGGga4ZqqZ/GxGwQ2pwnAFdrv6MpzNOCcwfG7K0jZRmXpz4txmzfDtD
         q4DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741362492; x=1741967292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ERi6eo1GFgBzJUmgrKyeNKQEukSFbVEJOWBSsBRX7ZQ=;
        b=RPQqWzss/Pd4bVUYIpKfVr2FVaMhFeM44XHc7yNNNErebBUShxJxfDKrIEWxFJUsQ2
         J+3vB412vtrd1zLf6+Fu6rlpyaSHEPXTYvj2TXF7/az93jNAr9rd4jg0VOda9nGBsWaG
         2P5rXxyMXDI/DJ1pSUjThIBNFt0mEBZRZzGl4ImbE+69Ca8MV2w9biCroWzIGhicJlhF
         voix77vATZip+N9Jlz9/cK76TFPFVdoC2OyFOFWlaU5wE+JTQDvO4ty7yL3gxhJNliAV
         P8xc3ftC7WSnUdC7oNYX208yJQyrwOjAbnr7B4ZjgVDB4PtLvyG1dWInFMVjvmZACkI9
         u00w==
X-Gm-Message-State: AOJu0YybZdRY3QCbrgIuAUCitgmUmxSN+B/6nokCOr+sf9L6Tvm/4ZeS
	yTa89l1QmteZkG1qJn7fPAdvxd3Knt42gqD1eFtoNK/gVlNRIcAntavXag==
X-Gm-Gg: ASbGncthIMPA3O5RsYNOxy4/WiftIffEuQ4Js1cZ8v5EJVsn+14wohOQRnj9iS2LZy8
	5THeHLtIOBpgEfHH2BRUiXgV4ZKyHfcoqne8eOHQPU3KrxzIxjyEYgv9mmwCGJ+0KQ0w2WEATXe
	Mk7ttYCZXG+3B/0jlW42UY6qv07nj0Nf1JIGefFd45yHUJZ2CJExMnDg9zfKyK0ebNciLvre9VD
	ttbKD6njndqOYAHkhVZ1IRZuF1gi4SO5eyD5a9MnMU26UKx1CtDmKQ72WbWzKrMKERJbaWBj2Lu
	LWLX4tCCmYpYJxpiO12vhLVN41mi
X-Google-Smtp-Source: AGHT+IHyrhyxhw4WMheV+3vPBRqx9UznAD3HsIojBS+FTli+iTKLT84MG263QT2J/W7foOAHDyANrA==
X-Received: by 2002:a05:6402:3553:b0:5e4:d4d3:569d with SMTP id 4fb4d7f45d1cf-5e5e24bbaa6mr3671901a12.22.1741362492079;
        Fri, 07 Mar 2025 07:48:12 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:1422])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5e5c766a033sm2665591a12.56.2025.03.07.07.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Mar 2025 07:48:10 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 2/9] io_uring: add infra for importing vectored reg buffers
Date: Fri,  7 Mar 2025 15:49:03 +0000
Message-ID: <67b7ff6530ae2b44a8e69704302601d40a694da4.1741361926.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741361926.git.asml.silence@gmail.com>
References: <cover.1741361926.git.asml.silence@gmail.com>
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
index bac509f85c80..8327c0ffca68 100644
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
+		u64 buf_addr = (u64)iovec[iov_idx].iov_base;
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
index ff78ead6bc75..f1496f7d844f 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -62,6 +62,10 @@ struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
 			unsigned issue_flags);
+int io_import_reg_vec(int ddir, struct iov_iter *iter,
+			struct io_kiocb *req, struct iou_vec *vec,
+			unsigned nr_iovs, unsigned iovec_off,
+			unsigned issue_flags);
 
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
@@ -147,6 +151,7 @@ static inline void __io_unaccount_mem(struct user_struct *user,
 }
 
 void io_vec_free(struct iou_vec *iv);
+int io_vec_realloc(struct iou_vec *iv, unsigned nr_entries);
 
 static inline void io_vec_reset_iovec(struct iou_vec *iv,
 				      struct iovec *iovec, unsigned nr)
-- 
2.48.1


