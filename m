Return-Path: <io-uring+bounces-6936-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 41EDBA4E4F7
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 17:07:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9482119C6811
	for <lists+io-uring@lfdr.de>; Tue,  4 Mar 2025 15:58:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44E9D2BF3CF;
	Tue,  4 Mar 2025 15:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S9THVGdl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49623255220
	for <io-uring@vger.kernel.org>; Tue,  4 Mar 2025 15:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741102778; cv=none; b=foBS3XpyiQbaoY4NmDq4jG7r63sHCXwkVl7WzGKAz3Lx5zbEqMB49sBOhNzHcIJfckZEV9YXzMUEqp+mDQ8EJ+NOIrr9h0hYCm6MoYVExJzmbZjS1F9y6ntwalEiknh6VrxbH9bX+F2ZOPjs856BSBu5/r61R+sUUvGNKhvGjmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741102778; c=relaxed/simple;
	bh=BvSYcKZjJx2mcN6MisvhcNvhByGtN1LJqFZE5JCFyus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoiF41TIMIvwxudKgNCiHRXOKBfkMnMqrWtD/0cMgWsKA2ZGcclZOeEPAR4Zfn7wFDqvo3nlQYw1Rz1LldgiUnswUuvEQfq+dNLobg+dalb3V5djSDiBmjGTTDl+r36FZdG/tepjzOrFrWFW9q/3mjJvsh46DIg0mnT8owBSxk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=S9THVGdl; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ab744d5e567so980242366b.1
        for <io-uring@vger.kernel.org>; Tue, 04 Mar 2025 07:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741102774; x=1741707574; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/qLKGOdBl3cLNSyd8QE3mj2clAx9J3/j7tRp1rR5kGA=;
        b=S9THVGdlCOXkZwCuEVo5FskGBUqFBN1Tcgpk0siIptGlRdgA67O5nQN3yPg9C07C5p
         kggV5aHav5AjfD8Ga04bPkGTFO/vyQmZvcLDI+fgGK0tifA8reNCg9/wUKx/Hp+IWoHs
         kfYPsE3Xp2k7txCialtPp95jwpIt6vGYtHCu3xPxdqgQfN43huP7T3JgTygjiROcIpXl
         zLM/9w1HGiwoLqmy5ZT6FRclglGc0KQgOoBlsLzDhFShMqGk6J0nnHtm4DdCwlB7qpVQ
         GqvIQBpFsFJkYqAIDFSgjS+SUeSfPfNbdBA97M7G0S391+ZB2V8/jRnNq/h7wY2FKOWm
         AKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741102774; x=1741707574;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/qLKGOdBl3cLNSyd8QE3mj2clAx9J3/j7tRp1rR5kGA=;
        b=QuyoAed2O+E5cgtZ//tcHkwxcRJVeaIjwy1tT3kKZl9umPv9X4W9ErHk/FyxnPesyc
         Mqe44ly3PXOOcYCL7hJ8ZoyG24Ml38rCv7Q5jfaUQ9DkOaao4EkrCGL18Dkj/jfMDDE7
         ueirTZoQEn1Wbi89TComNaYo20fRLWwT4W0HJINs7LlK2MnpyxhkUQyzGKK0+Lv+NW5A
         ln0QQVIQINX1Cm4Ta41XwRA2ILahUgJIq1IncR6WNbTlhhmtGtgPiUQaSLZyDxP/ukwb
         jeoLlF+HY/oiduPjKSuGTwzegmHICjaLS5/E8ktVou+6GSH/Wlz9VpYtSVpfL+473Qqw
         lecQ==
X-Gm-Message-State: AOJu0YyuPFuAtlx65TfbUNKoZfFEVPtLqQKKKQWNHIqh5aHm+s/0b88J
	HDfRGoGv/Jsp7b+gT5KLgghjw6UqH05/R+4MmX5E72lH7N+NXXKNqnhAEw==
X-Gm-Gg: ASbGncteidr7XIjXu0QYqtc6+aNgXOlVPyXIxFZRC5rDt5HJ/gaYc0NXsvm8Nm6H65z
	KQ4e0diTkD2S5f+KRkoNmr3bOlPja2wmSE+lU1x2KeRRm+12Ph/9BqBL9L2KOAl/Xn2PKgsCBY1
	6fR+pApR6idSe92R/NwWGc8YrbPSteOLiX+z7UNnVMIH85Q3N+ZHaeFMJC3VbfxlOzYM8F450zv
	iPNvKgpgjMoGTLhdmW1kD7akXmcgS9GuHWznvHxaDn2kY3BRarkwEPiFSoQBRvPpxGFSrE4ugOp
	WpHGmDHZKYxwHwn2ug7SJBlLr+u0
X-Google-Smtp-Source: AGHT+IFnSvS5AA6q3trOnwz01vkMEsxJkG3SHhEHr6Is9agUdriICyt+uPbb+V13o8bhS2hswzCbAA==
X-Received: by 2002:a17:907:d24:b0:ac0:4364:407e with SMTP id a640c23a62f3a-ac1f0eb69d1mr396984366b.4.1741102774029;
        Tue, 04 Mar 2025 07:39:34 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:3bd7])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac1ecafa17fsm168420966b.162.2025.03.04.07.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Mar 2025 07:39:33 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH v2 2/9] io_uring: add infra for importing vectored reg buffers
Date: Tue,  4 Mar 2025 15:40:23 +0000
Message-ID: <b054a88092767f7767f8447e7a5bdab15fcc0759.1741102644.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741102644.git.asml.silence@gmail.com>
References: <cover.1741102644.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add io_import_reg_vec(), which will be responsible for importing
vectored registered buffers. iovecs are overlapped with the resulting
bvec in memory, which is why the iovec is expected to be padded in
iou_vec.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/linux/io_uring_types.h |   5 +-
 io_uring/rsrc.c                | 122 +++++++++++++++++++++++++++++++++
 io_uring/rsrc.h                |   5 ++
 3 files changed, 131 insertions(+), 1 deletion(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 9101f12d21ef..b770a2b12da6 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -111,7 +111,10 @@ struct io_uring_task {
 };
 
 struct iou_vec {
-	struct iovec		*iovec;
+	union {
+		struct iovec	*iovec;
+		struct bio_vec	*bvec;
+	};
 	unsigned		nr;
 };
 
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 9b05e614819e..38743886bbf4 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1267,9 +1267,131 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 
 void io_vec_free(struct iou_vec *iv)
 {
+	BUILD_BUG_ON(sizeof(struct bio_vec) > sizeof(struct iovec));
+
 	if (!iv->iovec)
 		return;
 	kfree(iv->iovec);
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


