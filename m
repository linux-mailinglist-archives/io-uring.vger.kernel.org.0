Return-Path: <io-uring+bounces-2714-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EE5F94F581
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 19:01:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8F92D1F21B1B
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 17:01:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 27B8717C21B;
	Mon, 12 Aug 2024 17:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AAvqTT9b"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21F0C186E3B
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 17:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723482063; cv=none; b=NSr4PO8plfPgJjMH63FBnoVVDKXxtjl0giGoA9jfWfMZuo8dHUrdN+I/rWONbVEjphnH4j8WwNJqWDJ2NVLAHZ6I7PqSS2uQw9lPSOPmMoNn092Lzwqas2xrBTbm5TLOpl1X4j9M/fhVSKGe/8T4VPhpSNzfkXnkMlvs6gbfRy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723482063; c=relaxed/simple;
	bh=w341BamM6UwwBNwzUvYf/Bw+djnxjRdy3qmZgJHKG60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GW0pnnWO+T4UCifYBvHfggv69Z5zIlaBHlQuXwajkHAoM56YwgFnRA4vGeurdAoTrb2DGHGyXz1xTbWNwYGIGr1kGrRK5a7iWytyPNdHgvxxQaIpKhdiexLrzPaTdAZ4EHGjgnF1HBjB0APXCFvggce8I8Y+TQC74hSGtPK5ImU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AAvqTT9b; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-78f86e56b4cso782476a12.3
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 10:01:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723482060; x=1724086860; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NESc3W7wBpHoPLhXz9rZPuRs7hYDx9uq56Y8V2ZMbSo=;
        b=AAvqTT9bpCHsSSPQZjUawEKo5f7srPrsWuj1EYrDeLKia+StgHEJFkCLMuOdcyrb9t
         g1w9gVGV9kmL95FHjFk/RtK7GIPtGISuNSLddQriIfWPR0aOTLLLAi773cZOfkkZFV8B
         sSNIei1nYPYLSlR0Mmt+ckj87xIK4mb1WEFb5epBZQORoJSQRKLndNtsjypmKkNYIkNo
         KrsQVTtMmtJFQvuBZKzIZNy60Ww5N/aK601jjWs1V6GCOYDrqLhT09DWWeS6R/GuWAnu
         VXhO1o0tnwO1uhp6HKT+pUOyUvEH388tQWmJio1UMiALzfdrWqpRnDuXTSgquEmW2gWd
         7J2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723482060; x=1724086860;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NESc3W7wBpHoPLhXz9rZPuRs7hYDx9uq56Y8V2ZMbSo=;
        b=f3eAPacv/dIANvXThHMfsDwlFf45wnVVGMRwKqJoL9QHT475c9iO/eYQ/y9yWdxUM8
         E8M+5lvjZFt/VzBC8QAWudrI+/ypHMdYTFpvG/LKxZNUUt/rOdTQ1CWW7XtwthaN0Q5X
         pZZJGo/anQMBjV/UYOvY9oee8nE8QCM9eDFW4ty7fCqZYe8oTSu0rNvTpVv+4wdURuAG
         ZajmCJiy6Rd8k4kkzL3lUbzMTiV2IrJPMcGz2GZeNNvKIJoWvX7EblcWXF1rkJqAQFas
         pNQHN8wO2W5/R/pB3tdBA0H+jrcsBcnpJRFYigKBOZjEmMZXM7UxXwOdO+sLh5ePXcAV
         5oGQ==
X-Gm-Message-State: AOJu0YzayQFZVx6VbyE3GY7T8l5MR4oVOSxrYRhqvoYSD5kGc9Kk1eB/
	ysjwSg6kfWo/AWkjcVh/nHrvS3+Arx8IfzPbFrqhpq7D7t3/uyUdU9nIL0DhiPrwkDsnAvfHiIU
	J
X-Google-Smtp-Source: AGHT+IHaPcJnev9bJ9d1Y9OMvmNPmptHCK7rJSgbdYEOoBLxwHh39bfcG+LBibiUALZhCKh/AYUVTg==
X-Received: by 2002:a17:902:d4c9:b0:1fc:4377:e6ea with SMTP id d9443c01a7336-201ca1cb2a3mr6165285ad.9.1723482059865;
        Mon, 12 Aug 2024 10:00:59 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb9feaa4sm40212725ad.213.2024.08.12.10.00.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 10:00:58 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring/net: allow coalescing of mapped segments
Date: Mon, 12 Aug 2024 10:55:27 -0600
Message-ID: <20240812170044.93133-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240812170044.93133-1-axboe@kernel.dk>
References: <20240812170044.93133-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For bundles, when multiple buffers are selected, it's not unlikely
that some/all of them will be virtually contigious. If these segments
aren't big, then nice wins can be reaped by coalescing them into
bigger segments. This makes networking copies more efficient, and
reduces the number of iterations that need to be done over an iovec.
Ideally, multiple segments that would've been mapped as an ITER_IOVEC
before can now be mapped into a single ITER_UBUF iterator.

Example from an io_uring network backend receiving data, with various
transfer sizes, over a 100G network link.

recv size    coalesce    threads    bw          cpu usage    bw diff
=====================================================================
64             0           1       23GB/sec       100%
64             1           1       46GB/sec        79%        +100%
64             0           4       81GB/sec       370%
64             1           4       96GB/sec       160%        + 20%
256            0           1       44GB/sec        90%
256            1           1       47GB/sec        48%        +  7%
256            0           4       90GB/sec       190%
256            1           4       96GB/sec       120%        +  7%
1024           0           1       49GB/sec        60%
1024           1           1       50GB/sec        53%        +  2%
1024           0           4       94GB/sec       140%
1024           1           4       96GB/sec       120%        +  2%

where obviously small buffer sizes benefit the most, but where an
efficiency gain is seen even at higher buffer sizes as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.c | 61 +++++++++++++++++++++++++++++++++++++++++++++----
 io_uring/kbuf.h |  3 +++
 io_uring/net.c  | 48 ++++++++++++++++----------------------
 io_uring/net.h  |  1 +
 4 files changed, 80 insertions(+), 33 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 794a687d8589..76eade5a5567 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -129,6 +129,7 @@ static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
 
 	arg->iovs[0].iov_base = buf;
 	arg->iovs[0].iov_len = *len;
+	arg->nsegs = 1;
 	return 0;
 }
 
@@ -194,11 +195,16 @@ void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 /* cap it at a reasonable 256, will be one page even for 4K */
 #define PEEK_MAX_IMPORT		256
 
+/*
+ * Returns how many iovecs were used to fill the range. arg->nsegs contains
+ * the number of buffers mapped, which may be less than the return value if
+ * segments were coalesced.
+ */
 static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 				struct io_buffer_list *bl)
 {
 	struct io_uring_buf_ring *br = bl->buf_ring;
-	struct iovec *iov = arg->iovs;
+	struct iovec *prev_iov, *iov = arg->iovs;
 	int nr_iovs = arg->nr_iovs;
 	__u16 nr_avail, tail, head;
 	struct io_uring_buf *buf;
@@ -239,9 +245,11 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 	if (!arg->max_len)
 		arg->max_len = INT_MAX;
 
+	prev_iov = NULL;
 	req->buf_index = buf->bid;
 	do {
 		int len = buf->len;
+		void __user *ubuf;
 
 		/* truncate end piece, if needed */
 		if (len > arg->max_len) {
@@ -250,10 +258,20 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 				buf->len = len;
 		}
 
-		iov->iov_base = u64_to_user_ptr(buf->addr);
-		iov->iov_len = len;
-		iov++;
+		ubuf = u64_to_user_ptr(buf->addr);
+		if (prev_iov &&
+		    prev_iov->iov_base + prev_iov->iov_len == ubuf &&
+		    prev_iov->iov_len + len <= INT_MAX) {
+			prev_iov->iov_len += len;
+		} else {
+			iov->iov_base = ubuf;
+			iov->iov_len = len;
+			if (arg->coalesce)
+				prev_iov = iov;
+			iov++;
+		}
 
+		arg->nsegs++;
 		arg->out_len += len;
 		arg->max_len -= len;
 		if (!arg->max_len)
@@ -266,7 +284,8 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		req->flags |= REQ_F_BL_EMPTY;
 
 	req->flags |= REQ_F_BUFFER_RING;
-	req->buf_list = bl;
+	if (arg->coalesce)
+		req->buf_list = bl;
 	return iov - arg->iovs;
 }
 
@@ -326,6 +345,38 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
 	return io_provided_buffers_select(req, &arg->max_len, bl, arg);
 }
 
+int io_buffer_segments(struct io_kiocb *req, int nbytes)
+{
+	struct io_uring_buf_ring *br;
+	struct io_buffer_list *bl;
+	int nbufs = 0;
+	unsigned bid;
+
+	/*
+	 * Safe to use ->buf_list here, as coalescing can only have happened
+	 * if we remained lock throughout the operation. Unlocked usage must
+	 * not have buf_sel_arg->coalesce set to true
+	 */
+	bl = req->buf_list;
+	if (unlikely(!bl || !(bl->flags & IOBL_BUF_RING)))
+		return 1;
+
+	bid = req->buf_index;
+	br = bl->buf_ring;
+	do {
+		struct io_uring_buf *buf;
+		int this_len;
+
+		buf = io_ring_head_to_buf(br, bid, bl->mask);
+		this_len = min_t(int, buf->len, nbytes);
+		nbufs++;
+		bid++;
+		nbytes -= this_len;
+	} while (nbytes);
+
+	return nbufs;
+}
+
 static int __io_remove_buffers(struct io_ring_ctx *ctx,
 			       struct io_buffer_list *bl, unsigned nbufs)
 {
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 5625ff0e349d..d6d5f936fe6f 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -61,8 +61,11 @@ struct buf_sel_arg {
 	size_t max_len;
 	unsigned short nr_iovs;
 	unsigned short mode;
+	unsigned short nsegs;
+	bool coalesce;
 };
 
+int io_buffer_segments(struct io_kiocb *req, int nbytes);
 void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 			      unsigned int issue_flags);
 int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
diff --git a/io_uring/net.c b/io_uring/net.c
index a6268e62b348..f15671f5b118 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -462,33 +462,16 @@ static void io_req_msg_cleanup(struct io_kiocb *req,
 static int io_bundle_nbufs(struct io_kiocb *req, int ret)
 {
 	struct io_async_msghdr *kmsg = req->async_data;
-	struct iovec *iov;
-	int nbufs;
 
-	/* no data is always zero segments, and a ubuf is always 1 segment */
+	/* no data is always zero segments */
 	if (ret <= 0)
 		return 0;
-	if (iter_is_ubuf(&kmsg->msg.msg_iter))
-		return 1;
-
-	iov = kmsg->free_iov;
-	if (!iov)
-		iov = &kmsg->fast_iov;
-
-	/* if all data was transferred, it's basic pointer math */
+	/* if all data was transferred, we already know the number of buffers */
 	if (!iov_iter_count(&kmsg->msg.msg_iter))
-		return iter_iov(&kmsg->msg.msg_iter) - iov;
-
-	/* short transfer, count segments */
-	nbufs = 0;
-	do {
-		int this_len = min_t(int, iov[nbufs].iov_len, ret);
-
-		nbufs++;
-		ret -= this_len;
-	} while (ret);
+		return kmsg->nbufs;
 
-	return nbufs;
+	/* short transfer, iterate buffers to find number of segments */
+	return io_buffer_segments(req, ret);
 }
 
 static inline bool io_send_finish(struct io_kiocb *req, int *ret,
@@ -602,6 +585,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			.iovs = &kmsg->fast_iov,
 			.max_len = INT_MAX,
 			.nr_iovs = 1,
+			.coalesce = !(issue_flags & IO_URING_F_UNLOCKED),
 		};
 
 		if (kmsg->free_iov) {
@@ -625,6 +609,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			req->flags |= REQ_F_NEED_CLEANUP;
 		}
 		sr->len = arg.out_len;
+		kmsg->nbufs = arg.nsegs;
 
 		if (ret == 1) {
 			sr->buf = arg.iovs[0].iov_base;
@@ -1080,6 +1065,7 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 			.iovs = &kmsg->fast_iov,
 			.nr_iovs = 1,
 			.mode = KBUF_MODE_EXPAND,
+			.coalesce = true,
 		};
 
 		if (kmsg->free_iov) {
@@ -1095,7 +1081,18 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		if (unlikely(ret < 0))
 			return ret;
 
-		/* special case 1 vec, can be a fast path */
+		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
+			kmsg->free_iov_nr = arg.nsegs;
+			kmsg->free_iov = arg.iovs;
+			req->flags |= REQ_F_NEED_CLEANUP;
+		}
+		kmsg->nbufs = arg.nsegs;
+
+		/*
+		 * Special case 1 vec, can be a fast path. Note that multiple
+		 * contig buffers may get mapped to a single vec, but we can
+		 * still use ITER_UBUF for those.
+		 */
 		if (ret == 1) {
 			sr->buf = arg.iovs[0].iov_base;
 			sr->len = arg.iovs[0].iov_len;
@@ -1103,11 +1100,6 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 		}
 		iov_iter_init(&kmsg->msg.msg_iter, ITER_DEST, arg.iovs, ret,
 				arg.out_len);
-		if (arg.iovs != &kmsg->fast_iov && arg.iovs != kmsg->free_iov) {
-			kmsg->free_iov_nr = ret;
-			kmsg->free_iov = arg.iovs;
-			req->flags |= REQ_F_NEED_CLEANUP;
-		}
 	} else {
 		void __user *buf;
 
diff --git a/io_uring/net.h b/io_uring/net.h
index 52bfee05f06a..b9a453da4a0f 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -9,6 +9,7 @@ struct io_async_msghdr {
 	/* points to an allocated iov, if NULL we use fast_iov instead */
 	struct iovec			*free_iov;
 	int				free_iov_nr;
+	int				nbufs;
 	int				namelen;
 	__kernel_size_t			controllen;
 	__kernel_size_t			payloadlen;
-- 
2.43.0


