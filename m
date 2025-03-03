Return-Path: <io-uring+bounces-6907-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B5B30A4C5A6
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 16:50:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CEFBA1693DC
	for <lists+io-uring@lfdr.de>; Mon,  3 Mar 2025 15:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B626213E67;
	Mon,  3 Mar 2025 15:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LFhjakTT"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9565214A6C
	for <io-uring@vger.kernel.org>; Mon,  3 Mar 2025 15:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741017007; cv=none; b=Ej7e5jT3U/D5hwjDxKp2S7LmGypb3ljdW/5Y1jiiNnArWnJMz1YV9cjG3X+NyWsggQZkIGaRxzRkPx3gJeiAh+SYB9ESGndEnAL8tvtAb7Y+SIpiCMS4ASqSzlbcUQE3hNKQcgA+8HOsAHjj3xYxmw2V1CugQKmbrrhCHjSDlaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741017007; c=relaxed/simple;
	bh=b/+M6EYHNbSHsVgKpBR+If1LLwtdyB8f0ukymqfRDmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XtQYFd+ldtzG/Gf/n52VimO8Dqf4mPeaF1r49u8PAR0eTN9y0PMEsqt5rx/YX4DKmY38e/EbbgDURkcOjQQPR5PMgUDZQYXcR0kj6SEg6NzWxiKwEYsuMch6w3lZsVmfJ1ckLToLpcWGppg5zVj/JQYAxMC4/3Oz3I2qj6hvoO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LFhjakTT; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5e4ad1d67bdso7236149a12.2
        for <io-uring@vger.kernel.org>; Mon, 03 Mar 2025 07:50:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741017003; x=1741621803; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IlMfiIq/U2rZ1pw2Rwc3/yXfiAFA292UD6WiVz5J0yI=;
        b=LFhjakTTs0tWaUd80GATqFvCgDIx54PR2wDY86jabBdUWIUV1TIYuby8ZVQErK2OMI
         Z8ytrAcs3tIHO2daLtnTYJGWIx73jqR9NN68ziVqIKsZjLUD1++b5t71lE+iM1bO1e6G
         oCUVSRyWwj3jhdHUJW1p3RUUrDFnYxBTwsVz+n9f6qZmLC6bdEjWj4I+K5xAjJvDT3Dd
         bjv2T7a9LFC16RmGJZgpFKOChtVrnlDXG4OZTwFVjlUV9y5KBGMnE0BMNp71X9CpD6Dj
         3qtT35rqatUkq6v5eX1niRaVpIBelohu/SgqWhreVus+W1FGmGM4sevs2iP6bvsx/2io
         0lZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741017003; x=1741621803;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IlMfiIq/U2rZ1pw2Rwc3/yXfiAFA292UD6WiVz5J0yI=;
        b=T9gpj6Y2r5cpGqMYliv2oz67bV2/p5Ao5R9ky94CH/g4MZ+vEePx6eUB4l7EmJDX80
         X9ezi0/43pz2qHJ0oBmH68SF7Kb9x7sdenDGG56q9sIQx566wQL4uxkxwPVwGFHr+TwX
         qNiFfTK9hWkNalXmPrYg8UGLUjjoQH3rffrgdNeEWz4tf7ylTTzbo6sv1D1jDVXR36fZ
         Mp4md/t/Ay5SDrf7veZt6PFSxNSsqb/SycqTe1ypIDU4DNczWu89ysLxH3g8FewOIgqJ
         pcTM3W5bWtzawiTyElUTDCt/W6zxffq2dPinvA2Mr1JYjsZboBgmuCK0KO2SM9WDqoPi
         ECng==
X-Gm-Message-State: AOJu0Yw8AeUNAeqADrkorQR5NI1uo4NkR9plvqTSiaEvbbCoNebnNU5o
	Er6atKOHu87dEwa1s6CQ4p639+NSQT30CT/FrUxlENRx9PRPYOfPCFRdpw==
X-Gm-Gg: ASbGncvVKpsGV7wvWzqyUJ9re9z+o7CXm/KQ9/nNE0Mzkdjz35hpB339F6m5nVNDwI5
	UsZhO5IqQQCtsWz3wGYD4MvY6z/cZ7NViH0nr35rBv39tep4t7NR6ai5ogr5DaIS3VuZVp8PWwj
	lNc24y3TLS4GgWQyqb6OMBJ8D+IhvcPMSZEf7VGmgp7SN3K9/NE4EZA7w2AlaqWCnpxWsPN3mSC
	OwZW8f/FxoyiQhmr2ogej2lVoULLYf8PG70jLbvY4eChSY+aNL4WI/Oj5wK4krWLWLD06czJ9J5
	kx2+yuyKebiKINui/ID62BSidg++
X-Google-Smtp-Source: AGHT+IE43N9jJYr6j3HuDd77e3s7s/590LS4lAxa/rElsYSAakBDkpg3e9EcN3thTDs2HWzbesLULg==
X-Received: by 2002:a17:906:da88:b0:ab7:851d:4718 with SMTP id a640c23a62f3a-abf265a306emr1857174166b.36.1741017003255;
        Mon, 03 Mar 2025 07:50:03 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:299a])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-abf4e50c80esm492335266b.61.2025.03.03.07.50.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Mar 2025 07:50:02 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Andres Freund <andres@anarazel.de>
Subject: [PATCH 2/8] io_uring: add infra for importing vectored reg buffers
Date: Mon,  3 Mar 2025 15:50:57 +0000
Message-ID: <841b4d5b039b9db84aa1e1415a6d249ea57646f6.1741014186.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1741014186.git.asml.silence@gmail.com>
References: <cover.1741014186.git.asml.silence@gmail.com>
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
 io_uring/rsrc.c                | 124 +++++++++++++++++++++++++++++++++
 io_uring/rsrc.h                |   5 ++
 3 files changed, 133 insertions(+), 1 deletion(-)

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
index 9b05e614819e..1ec1f5b3e385 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1267,9 +1267,133 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 
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
+	struct iovec *iov;
+
+	WARN_ON_ONCE(nr_entries <= 0);
+
+	iov = kmalloc_array(nr_entries, sizeof(iov[0]), GFP_KERNEL);
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
+				struct iovec *iovec, int nr_iovs,
+				struct iou_vec *vec)
+{
+	unsigned long folio_size = (1 << imu->folio_shift);
+	unsigned long folio_mask = folio_size - 1;
+	struct bio_vec *res_bvec = vec->bvec;
+	size_t total_len = 0;
+	int bvec_idx = 0;
+	int iov_idx;
+
+	for (iov_idx = 0; iov_idx < nr_iovs; iov_idx++) {
+		size_t iov_len = iovec[iov_idx].iov_len;
+		u64 buf_addr = (u64)iovec[iov_idx].iov_base;
+		u64 folio_addr = imu->ubuf & ~folio_mask;
+		struct bio_vec *src_bvec;
+		size_t offset;
+		u64 buf_end;
+
+		if (unlikely(check_add_overflow(buf_addr, (u64)iov_len, &buf_end)))
+			return -EFAULT;
+		if (unlikely(buf_addr < imu->ubuf || buf_end > (imu->ubuf + imu->len)))
+			return -EFAULT;
+
+		total_len += iov_len;
+		/* by using folio address it also accounts for bvec offset */
+		offset = buf_addr - folio_addr;
+		src_bvec = imu->bvec + (offset >> imu->folio_shift);
+		offset &= folio_mask;
+
+		for (; iov_len; offset = 0, bvec_idx++, src_bvec++) {
+			size_t seg_size = min_t(size_t, iov_len,
+						folio_size - offset);
+
+			res_bvec[bvec_idx].bv_page = src_bvec->bv_page;
+			res_bvec[bvec_idx].bv_offset = offset;
+			res_bvec[bvec_idx].bv_len = seg_size;
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
+			int nr_iovs, unsigned iovec_off,
+			unsigned issue_flags)
+{
+	struct io_rsrc_node *node;
+	struct io_mapped_ubuf *imu;
+	unsigned cache_nr;
+	struct iovec *iov;
+	unsigned nr_segs;
+	int ret;
+
+	node = io_find_buf_node(req, issue_flags);
+	if (!node)
+		return -EFAULT;
+	imu = node->buf;
+	if (imu->is_kbuf)
+		return -EOPNOTSUPP;
+
+	iov = vec->iovec + iovec_off;
+	ret = io_estimate_bvec_size(iov, nr_iovs, imu);
+	if (ret < 0)
+		return ret;
+	nr_segs = ret;
+	cache_nr = vec->nr;
+
+	if (WARN_ON_ONCE(iovec_off + nr_iovs != cache_nr) ||
+	    nr_segs > cache_nr) {
+		struct iou_vec tmp_vec = {};
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
index e3f1cfb2ff7b..769ef5d76a4b 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -61,6 +61,10 @@ struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
 			unsigned issue_flags);
+int io_import_reg_vec(int ddir, struct iov_iter *iter,
+			struct io_kiocb *req, struct iou_vec *vec,
+			int nr_iovs, unsigned iovec_off,
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


