Return-Path: <io-uring+bounces-2949-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D280F95DEC3
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 17:49:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3DB41C20E4D
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 15:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDBC129CEB;
	Sat, 24 Aug 2024 15:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="XedUTUe6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B7F33997
	for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 15:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724514580; cv=none; b=PDWBBSz6DkeXGuVu8RaOVpdc1AJvVh0ZQjK8qNIA4/r3/NvMElERvL5H0JZ9zEMZ6MVsWzHzToM8vSFC/9YykLwYfvI7eGYorh39RlPtsCl8j/rsGHBfwr0BGCxfyQJb/1iF68DzHiNWt9kRs1YAMg7EI4U1SN4nTwg+oN7Qk58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724514580; c=relaxed/simple;
	bh=a8AEBnyI8HVyZARw3vmEeQBmPpjGfki8hC8yZFcTHmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pk+l3xfNIHVQso0RU5DJ1CKOLjwLF1CYOfUpvkNmOiDEHcOYpKoFGdBW4Fcco2rE3SpCabcE9mmTBFcJ/+HNmLJUFsJhNZmZPhximBWB9GLeApdiVux6qA8M2DY79RM8iVY8tRaQ6BuW+DR7/JbrNQ7wqi/oqxNFfYJA0ztm1x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=XedUTUe6; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7141b04e7b5so1801112b3a.2
        for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 08:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724514578; x=1725119378; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iAeRAXFupLVom4BMrDo2dVEoXFIU00zLkGGzhsJFOhs=;
        b=XedUTUe6R2YtVVpu76bfauTp489J3rShdgIMKj8vLVRiPsvmhrGNO57C9lafuw1sMM
         BXrECAhflPclMdJHOPlisUo+qEKlUUVk3MlH2etkz+kEgkikfyBg+tdLAkyZnZNBjTSA
         yp0eH6442Ot6b9VKn2uPOFNehr347ReeCN7mYOHxpcpgf6sPlJC2KDiAuYxgybCaj7xE
         23Xrn4CZkWLKk/2g8JF21maTJOFu7YzJn4rNTUoLWE6x2Ejqjh4h9sa8N9Jn6lAMlEHy
         vtRFsCjbbkLniz9HMDC3kAHY4ToPPsLvjmkW5/IHx8/CQfuJx2jBMZW7mp/9Ql3prnvm
         tn6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724514578; x=1725119378;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iAeRAXFupLVom4BMrDo2dVEoXFIU00zLkGGzhsJFOhs=;
        b=KoV8v6Vwot1/p89hZJFKUS/YXQIhU3AE1p573mJIuU4JQcOo3lvGga1prR2pTp4dSb
         Euek7ocvpOS0AJgX/1MhtChlrDh7Y7VSWpL2wlplyrzyqxx5TgzXX5FaJgfXJDL404hE
         Bg0as4CCjwmOYldLFWftiIsdjzcN/5a/6jPSWzkbAnviiD2sDMaTDXIAt82D3jDxpIeo
         fhtPMKlbiDnOmMO0ndeT7ITum8EU8IKV8vZcZdT1LyqOwyiNuUXLppM5YCbVB/y5MapB
         tSnewC0Xa/4s6aksjpZUmzXXPRWgLFH6MKEP4m5nREgAJA/rSUfgSpDfHaK1V+cO73j1
         v7rQ==
X-Gm-Message-State: AOJu0YxsPOwQ098Vyv4vJUqbvrL99U+MryTzhC/Xb34j8tb/lL5dDNOb
	bK9IKPFp6i4fTc+OU1EQCPtkp7LYG/G8s8gzI/TUCLVzYyqimnv3C73ZC9cD99HmXsgxE7gU8rZ
	6
X-Google-Smtp-Source: AGHT+IGnfc6hl36B3f5GogSLp7PnqfzRvWkbm7HKpslXU+RbCK++8sayYRW1ZXBGkAfQcWxuhXCQcg==
X-Received: by 2002:a05:6a21:150d:b0:1c6:fa87:774b with SMTP id adf61e73a8af0-1cc89fdd9eemr6276010637.39.1724514577630;
        Sat, 24 Aug 2024 08:49:37 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-714342e09c3sm4633925b3a.122.2024.08.24.08.49.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 08:49:36 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/net: allow coalescing of mapped segments
Date: Sat, 24 Aug 2024 09:47:00 -0600
Message-ID: <20240824154924.110619-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240824154924.110619-1-axboe@kernel.dk>
References: <20240824154924.110619-1-axboe@kernel.dk>
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
index e3330ff9bfdf..83a9ec08d146 100644
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
@@ -253,9 +259,11 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 	if (!arg->max_len)
 		arg->max_len = INT_MAX;
 
+	prev_iov = NULL;
 	req->buf_index = buf->bid;
 	do {
 		u32 len = buf->len;
+		void __user *ubuf;
 
 		/* truncate end piece, if needed, for non partial buffers */
 		if (len > arg->max_len) {
@@ -264,10 +272,20 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
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
@@ -280,7 +298,8 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		req->flags |= REQ_F_BL_EMPTY;
 
 	req->flags |= REQ_F_BUFFER_RING;
-	req->buf_list = bl;
+	if (arg->coalesce)
+		req->buf_list = bl;
 	return iov - arg->iovs;
 }
 
@@ -340,6 +359,38 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
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
index a8fbe2e3b73a..fe2f174b33cf 100644
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
index 14dd60bed676..4553465805f7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -460,33 +460,16 @@ static void io_req_msg_cleanup(struct io_kiocb *req,
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
@@ -600,6 +583,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			.iovs = &kmsg->fast_iov,
 			.max_len = min_not_zero(sr->len, INT_MAX),
 			.nr_iovs = 1,
+			.coalesce = !(issue_flags & IO_URING_F_UNLOCKED),
 		};
 
 		if (kmsg->free_iov) {
@@ -623,6 +607,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			req->flags |= REQ_F_NEED_CLEANUP;
 		}
 		sr->len = arg.out_len;
+		kmsg->nbufs = arg.nsegs;
 
 		if (ret == 1) {
 			sr->buf = arg.iovs[0].iov_base;
@@ -1078,6 +1063,7 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
 			.iovs = &kmsg->fast_iov,
 			.nr_iovs = 1,
 			.mode = KBUF_MODE_EXPAND,
+			.coalesce = true,
 		};
 
 		if (kmsg->free_iov) {
@@ -1093,7 +1079,18 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
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
@@ -1101,11 +1098,6 @@ static int io_recv_buf_select(struct io_kiocb *req, struct io_async_msghdr *kmsg
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


