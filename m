Return-Path: <io-uring+bounces-3957-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5FAE59ACFEB
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 18:15:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 810491C216EB
	for <lists+io-uring@lfdr.de>; Wed, 23 Oct 2024 16:15:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 963FD1C876B;
	Wed, 23 Oct 2024 16:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="tXpO1Azf"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C5F1C3045
	for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 16:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729700139; cv=none; b=NKA/Nd/VrEcgO/oIlsnFw6IlwCuag5oXzFbZQhs5Ck63IS0HuOsocZbIR55+jUCgme7vEWb0UE35hqaF69J1BrAvOVD2IzQUIk0gGoBui6UlrMZnpZIuyhcPDkqO4Eq7OmgIx0V4x7RY9ltl3iWr7Tqmi9sZxP8fZzFd12gELk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729700139; c=relaxed/simple;
	bh=ECixvDA0CV9DbzgGfS1vLwyWdlt6qzfwBdUA5lTD+0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YKcIZcxlvQeg6AsooOerHRODx6OfkQGFaB+/lSv4HUZHRoJqekf2Iya98w1YL5ZWJO7Vg1DtpmpuOnjUTsEflUb4ePBeHMHZ2NokZgYG/lJ24G88GJzsbePDVpo4WUoo6+1cnDv72haq54zg+ZdCRJxLFBlpAPNkXUlaZlmmStc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=tXpO1Azf; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-83abe7fc77eso205017139f.0
        for <io-uring@vger.kernel.org>; Wed, 23 Oct 2024 09:15:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729700136; x=1730304936; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kOPdgM0vwRvx2gbkp5/pjZOR3nL5VqvejKEQrCn8qI=;
        b=tXpO1AzfDVI+rtMblfcUPNa9PpdzdZAHnDS+32sIyi+9qDwDm1kXRee95u54cDfgkZ
         VqUYpGUrxNFRRH5DyW5Ir5tsRjZv2EmV13jETgNw0Hwb2w1mHPPzWLRbUaiftL1XNRQH
         I3Yi7qhc5izC5s9kFQtIx/8vvt+81voWrUmCjB58bTWyMRZQF+3BguSorJ5SLf6Lzsao
         diGH+Oh7ic5hGgA8ecYp1J5COXpmp0QJRa5fvVfz9oa4hBFCLSQI2bsaLw0TX1db+rxz
         /f3Hp4UmhAtZ/MvpCsLQbH2dOs/5CoXequsxzKnQKbrJ9Qnw2qcjrPPcAeUFdOZ1e68S
         V1yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729700136; x=1730304936;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4kOPdgM0vwRvx2gbkp5/pjZOR3nL5VqvejKEQrCn8qI=;
        b=unfBI8A8ne9J0zXLHef+lc/kgmA9YKKXlNJ4RhaXs6PIj4sD1qiJqeAo3RpeHEklcS
         onejvkajjp2Gr5S/FbOrNoUyBojGq6FVh9GuVFv6SYR1veVHNGPF2CQE2LwZNdjRdBMb
         TXeObL02CCzApZDVl38QRErJNUKbUubRRGuRAWW38woeS5UHIJaVzPCzuMA1SzdiAeQO
         UeQRiGbOGKpjmcf8erla/6bS+egYyTwSmWxAl+e7uIJOZk5/i+pIkbp1TTHKS6f25wMw
         MyHjbrEHViF/Gej4HgTZV44VHtYfulQW+208Keoh/AkBlAY1loWgbOuA6d/HG729osNs
         oKsg==
X-Gm-Message-State: AOJu0YyhQlRhe3KfWbhymHTAEwQWzDr953Ri595HVH8a0FQikZ2Y/7XB
	y3RLEry47yDbiSOr8xdZu2wJcEVtecSmr21gy2UqVlMywCehU3J38EEWQZp30WwrA+uS+8tGYJn
	V
X-Google-Smtp-Source: AGHT+IFPv8t+UOSRBRrYN44onrF8tB2bt6NJr4qWaJqi2pmkQnFwKoFoF+dsRBAYW4pMcI6S92dyCQ==
X-Received: by 2002:a05:6602:1483:b0:83a:b79c:66b6 with SMTP id ca18e2360f4ac-83af615132bmr358639039f.2.1729700132749;
        Wed, 23 Oct 2024 09:15:32 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc2a556c29sm2138180173.43.2024.10.23.09.15.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2024 09:15:31 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6/7] io_uring/kbuf: add support for mapping type KBUF_MODE_BVEC
Date: Wed, 23 Oct 2024 10:07:39 -0600
Message-ID: <20241023161522.1126423-7-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241023161522.1126423-1-axboe@kernel.dk>
References: <20241023161522.1126423-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The provided buffer helpers always map to iovecs. Add a new mode,
KBUF_MODE_BVEC, which instead maps it to a bio_vec array instead. For
use with zero-copy scenarios, where the caller would want to turn it
into a bio_vec anyway, and this avoids first iterating and filling out
and iovec array, only for the caller to then iterate it again and turn
it into a bio_vec array.

Since it's now managing both iovecs and bvecs, change the naming of
buf_sel_arg->nr_iovs member to nr_vecs instead.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 170 +++++++++++++++++++++++++++++++++++++++++++-----
 io_uring/kbuf.h |   9 ++-
 io_uring/net.c  |  10 +--
 3 files changed, 165 insertions(+), 24 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 42579525c4bd..10a3a7a27e9a 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -16,6 +16,7 @@
 #include "opdef.h"
 #include "kbuf.h"
 #include "memmap.h"
+#include "rsrc.h"
 
 /* BIDs are addressed by a 16-bit field in a CQE */
 #define MAX_BIDS_PER_BGID (1 << 16)
@@ -117,20 +118,135 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 	return NULL;
 }
 
+static struct io_mapped_ubuf *io_ubuf_from_buf(struct io_ring_ctx *ctx,
+					       u64 addr, unsigned int *offset)
+{
+	struct io_mapped_ubuf *imu;
+	u16 idx;
+
+	/*
+	 * Get registered buffer index and offset, encoded into the
+	 * addr base value.
+	 */
+	idx = addr & ((1ULL << IOU_BUF_REGBUF_BITS) - 1);
+	addr >>= IOU_BUF_REGBUF_BITS;
+	*offset = addr  & ((1ULL << IOU_BUF_OFFSET_BITS) - 1);
+
+	if (unlikely(idx >= ctx->nr_user_bufs))
+		return ERR_PTR(-EFAULT);
+
+	idx = array_index_nospec(idx, ctx->nr_user_bufs);
+	imu = READ_ONCE(ctx->user_bufs[idx]);
+	if (unlikely(*offset >= imu->len))
+		return ERR_PTR(-EFAULT);
+
+	return imu;
+}
+
+static bool io_expand_bvecs(struct buf_sel_arg *arg)
+{
+	int nvecs = arg->nr_vecs + 8;
+	struct bio_vec *bv;
+
+	if (!(arg->mode & KBUF_MODE_EXPAND))
+		return false;
+
+	bv = kmalloc_array(nvecs, sizeof(struct bio_vec), GFP_KERNEL);
+	if (unlikely(!bv))
+		return false;
+	memcpy(bv, arg->bvecs, arg->nr_vecs * sizeof(*bv));
+	if (arg->mode & KBUF_MODE_FREE)
+		kfree(arg->bvecs);
+	arg->bvecs = bv;
+	arg->nr_vecs = nvecs;
+	arg->mode |= KBUF_MODE_FREE;
+	return true;
+}
+
+static int io_fill_bvecs(struct io_ring_ctx *ctx, u64 addr,
+			 struct buf_sel_arg *arg, unsigned int len,
+			 int *vec_off)
+{
+	struct bio_vec *src, *src_prv = NULL;
+	struct io_mapped_ubuf *imu;
+	unsigned int llen = len;
+	unsigned int offset;
+
+	imu = io_ubuf_from_buf(ctx, addr, &offset);
+	if (unlikely(IS_ERR(imu)))
+		return PTR_ERR(imu);
+
+	if (unlikely(offset >= imu->len || len > imu->len))
+		return -EOVERFLOW;
+	if (unlikely(offset > imu->len - len))
+		return -EOVERFLOW;
+
+	src = imu->bvec;
+	if (offset > src->bv_len) {
+		unsigned long seg_skip;
+
+		offset -= src->bv_len;
+		seg_skip = 1 + (offset >> imu->folio_shift);
+		offset &= ((1UL << imu->folio_shift) - 1);
+		src += seg_skip;
+	}
+
+	do {
+		unsigned int this_len = len;
+
+		if (this_len + offset > src->bv_len)
+			this_len = src->bv_len - offset;
+
+		/*
+		 * If contig with previous bio_vec, merge it to minimize the
+		 * number of segments needed. If not, then add a new segment,
+		 * expanding the number of available slots, if needed.
+		 */
+		if (src_prv &&
+		    page_folio(src_prv->bv_page) == page_folio(src->bv_page) &&
+		    src_prv->bv_page + 1 == src->bv_page) {
+			arg->bvecs[*vec_off - 1].bv_len += this_len;
+		} else {
+			struct bio_vec *dst;
+
+			if (*vec_off == arg->nr_vecs && !io_expand_bvecs(arg))
+				break;
+
+			dst = &arg->bvecs[*vec_off];
+			dst->bv_page = src->bv_page;
+			dst->bv_len = this_len;
+			dst->bv_offset = offset;
+			(*vec_off)++;
+		}
+		offset = 0;
+		len -= this_len;
+		src_prv = src++;
+	} while (len);
+
+	return llen - len;
+}
+
 static int io_provided_buffers_select(struct io_kiocb *req,
 				      struct buf_sel_arg *arg,
 				      struct io_buffer_list *bl, size_t *len)
 {
-	struct iovec *iov = arg->iovs;
 	void __user *buf;
+	int ret;
 
 	buf = io_provided_buffer_select(req, len, bl);
 	if (unlikely(!buf))
 		return -ENOBUFS;
 
-	iov[0].iov_base = buf;
-	iov[0].iov_len = *len;
-	return 1;
+	if (arg->mode & KBUF_MODE_BVEC) {
+		u64 addr = (unsigned long)(uintptr_t) buf;
+
+		*len = io_fill_bvecs(req->ctx, addr, arg, *len, &ret);
+	} else {
+		arg->iovs[0].iov_base = buf;
+		arg->iovs[0].iov_len = *len;
+		ret = 1;
+	}
+	return ret;
 }
 
 static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
@@ -196,13 +312,16 @@ void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 #define PEEK_MAX_IMPORT		256
 
 static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
-				struct io_buffer_list *bl)
+				struct io_buffer_list *bl, int *nbufs)
 {
 	struct io_uring_buf_ring *br = bl->buf_ring;
 	struct iovec *iov = arg->iovs;
-	int nr_iovs = arg->nr_iovs;
+	int nr_iovs = arg->nr_vecs;
 	__u16 nr_avail, tail, head;
 	struct io_uring_buf *buf;
+	int vec_off;
+
+	BUILD_BUG_ON(sizeof(struct iovec) > sizeof(struct bio_vec));
 
 	tail = smp_load_acquire(&br->tail);
 	head = bl->head;
@@ -236,10 +355,12 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
 	/*
 	 * only alloc a bigger array if we know we have data to map, eg not
-	 * a speculative peek operation.
+	 * a speculative peek operation. Note that struct bio_vec and
+	 * struct iovec are the same size, so we can use them interchangably
+	 * here as it's just for sizing purposes.
 	 */
 	if (arg->mode & KBUF_MODE_EXPAND && nr_avail > nr_iovs && arg->max_len) {
-		iov = kmalloc_array(nr_avail, sizeof(struct iovec), GFP_KERNEL);
+		iov = kmalloc_array(nr_avail, sizeof(struct bio_vec), GFP_KERNEL);
 		if (unlikely(!iov))
 			return -ENOMEM;
 		if (arg->mode & KBUF_MODE_FREE)
@@ -255,6 +376,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 	if (!arg->max_len)
 		arg->max_len = INT_MAX;
 
+	vec_off = 0;
 	req->buf_index = buf->bid;
 	do {
 		u32 len = buf->len;
@@ -266,15 +388,25 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 				buf->len = len;
 		}
 
-		iov->iov_base = u64_to_user_ptr(buf->addr);
-		iov->iov_len = len;
-		iov++;
+		if (arg->mode & KBUF_MODE_BVEC) {
+			int ret;
+
+			ret = io_fill_bvecs(req->ctx, buf->addr, arg, len, &vec_off);
+			if (unlikely(ret < 0))
+				return ret;
+			len = ret;
+		} else {
+			iov->iov_base = u64_to_user_ptr(buf->addr);
+			iov->iov_len = len;
+			iov++;
+			vec_off++;
+		}
 
 		arg->out_len += len;
 		arg->max_len -= len;
+		(*nbufs)++;
 		if (!arg->max_len)
 			break;
-
 		buf = io_ring_head_to_buf(br, ++head, bl->mask);
 	} while (--nr_iovs);
 
@@ -283,7 +415,7 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
 	req->flags |= REQ_F_BUFFER_RING;
 	req->buf_list = bl;
-	return iov - arg->iovs;
+	return vec_off;
 }
 
 int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
@@ -299,7 +431,9 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		goto out_unlock;
 
 	if (bl->flags & IOBL_BUF_RING) {
-		ret = io_ring_buffers_peek(req, arg, bl);
+		int nbufs = 0;
+
+		ret = io_ring_buffers_peek(req, arg, bl, &nbufs);
 		/*
 		 * Don't recycle these buffers if we need to go through poll.
 		 * Nobody else can use them anyway, and holding on to provided
@@ -307,9 +441,9 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		 * side anyway with normal buffers. Besides, we already
 		 * committed them, they cannot be put back in the queue.
 		 */
-		if (ret > 0) {
+		if (nbufs) {
 			req->flags |= REQ_F_BUFFERS_COMMIT | REQ_F_BL_NO_RECYCLE;
-			io_kbuf_commit(req, bl, arg->out_len, ret);
+			io_kbuf_commit(req, bl, arg->out_len, nbufs);
 		}
 	} else {
 		ret = io_provided_buffers_select(req, arg, bl, &arg->out_len);
@@ -332,7 +466,9 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
 		return -ENOENT;
 
 	if (bl->flags & IOBL_BUF_RING) {
-		ret = io_ring_buffers_peek(req, arg, bl);
+		int nbufs = 0;
+
+		ret = io_ring_buffers_peek(req, arg, bl, &nbufs);
 		if (ret > 0)
 			req->flags |= REQ_F_BUFFERS_COMMIT;
 		return ret;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 36aadfe5ac00..7c56ba994f21 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -53,13 +53,18 @@ enum {
 	KBUF_MODE_EXPAND	= 1,
 	/* if bigger vec allocated, free old one */
 	KBUF_MODE_FREE		= 2,
+	/* turn into bio_vecs, not iovecs */
+	KBUF_MODE_BVEC		= 4,
 };
 
 struct buf_sel_arg {
-	struct iovec *iovs;
+	union {
+		struct iovec *iovs;
+		struct bio_vec *bvecs;
+	};
 	size_t out_len;
 	size_t max_len;
-	unsigned short nr_iovs;
+	unsigned short nr_vecs;
 	unsigned short mode;
 };
 
diff --git a/io_uring/net.c b/io_uring/net.c
index dbef14aa50f9..154756762a46 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -643,17 +643,17 @@ static int io_send_import(struct io_kiocb *req, unsigned int issue_flags)
 		struct buf_sel_arg arg = {
 			.iovs = &kmsg->fast_iov,
 			.max_len = min_not_zero(sr->len, INT_MAX),
-			.nr_iovs = 1,
+			.nr_vecs = 1,
 		};
 
 		if (kmsg->free_iov) {
-			arg.nr_iovs = kmsg->free_iov_nr;
+			arg.nr_vecs = kmsg->free_iov_nr;
 			arg.iovs = kmsg->free_iov;
 			arg.mode = KBUF_MODE_FREE;
 		}
 
 		if (!(sr->flags & IORING_RECVSEND_BUNDLE))
-			arg.nr_iovs = 1;
+			arg.nr_vecs = 1;
 		else
 			arg.mode |= KBUF_MODE_EXPAND;
 
@@ -1140,12 +1140,12 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 	    sr->flags & IORING_RECVSEND_BUNDLE) {
 		struct buf_sel_arg arg = {
 			.iovs = &kmsg->fast_iov,
-			.nr_iovs = 1,
+			.nr_vecs = 1,
 			.mode = KBUF_MODE_EXPAND,
 		};
 
 		if (kmsg->free_iov) {
-			arg.nr_iovs = kmsg->free_iov_nr;
+			arg.nr_vecs = kmsg->free_iov_nr;
 			arg.iovs = kmsg->free_iov;
 			arg.mode |= KBUF_MODE_FREE;
 		}
-- 
2.45.2


