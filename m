Return-Path: <io-uring+bounces-2707-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 58ED594F248
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 18:01:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id B7FB1B259D8
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 16:01:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577C7183CD9;
	Mon, 12 Aug 2024 16:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MmhpRs4y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2400C183CBF
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 16:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478508; cv=none; b=s67ZinGrKY1FnvfhFxYscek2Iod2qbsaShcM/LppaHo1J4JI9I1DDjWVs7QoYSU8Bv9oxO/iFIYHjGt4Wa+zopTPMYYOixAOM5vZ/CstBLxiBpyM5qolSR9tkizKk1N7yZRYw8ligwx9rTvORURaIRx+jzfnmbPcTiN2IuJExOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478508; c=relaxed/simple;
	bh=VJxp3XInp86vph4B6x0kzbzqw6G1N5O6I1CoI1m3xlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcvVL5NxBvfsJHAB1tnowMn7ZpaoXl4tcEdz/1jIdLe2Fk5L46mZRZrpkT6a39obHyzFkM43UA47KIZik4fwivh6iTQHnem0H0aa1oIIm8+4Ud7Y+4nynHBqeB6kHvs4JLobFR47Iav22WE9J7+RFz5mZQRq5arBwB19f+LzjO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MmhpRs4y; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1fc4e010efdso976995ad.3
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 09:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723478505; x=1724083305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CW4VG9CICuJuD43Mhniod5I8ngQbwvx2WAuqcodBOXY=;
        b=MmhpRs4yLEv2+5HvE10hJTcvIouJng/xZIRrPaMOqdNef95RIwx/HFZdh9MpvkWEEA
         vk0/fHlGu6Aom+r6e8Y55Htm8gfibV0OGpclfX4JeTNycrPlaDE8K05/5D9MiWqOYxyj
         pC9u8aeF9l5fa1XIXGTnIkxUnFxxPUmOIARevOrMvbKQycqoThV1pWlMqqNCBqoL2Bb+
         GflLpkNq6kKy73PcWTpMcSUVMASVSRGLOpZtsBi4ofOTe+kOh4Jr+JQXa+/d8rNkDy0+
         /QUBzyj9j+KDw96G9RixbIM9Eb6LBtUEALoy+HZi30R/3Lx6EBxY5tOoaprnDDNeo1+U
         BAZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723478505; x=1724083305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CW4VG9CICuJuD43Mhniod5I8ngQbwvx2WAuqcodBOXY=;
        b=B7aXrCIizqZdjRquLlzo8I8DCOlem76M1Wcsf2VaS9RNB0tTVTZfw6lgZYFZylSAOx
         Msg48r6JFuoxZ8sKMJwzEgw7xSYM6WTZVriUPtwsCm6UJK4LRglEk5S+bmJX1+UBzupm
         6JF7C2hipgn1UQ+dS/1kTZbG8fDQZFhQsi242ziSLOd6Ecxco4qM68RKlGNWAZSiensh
         IZAfXHuTcGa2fNq7RO5NKUamre4NRFQmqrNWOX/hFjsNYiIXESZL8ZiBPCbcCCowsPkE
         6leZ+GeVZuiBjD03wIPWA/3ROG4MVf1R4V5pMiNcvoEh2/EmuTpjvx6FRTJS9O1tjGdn
         V3bA==
X-Gm-Message-State: AOJu0Yx1JOWWGJRtgLYaUXw1FXL3oyx6NtdRoLMhLoSAbI21LyloYIIA
	FtkmHHS93ma26b073ksBYKUI+wdAo5mL0PCGIBaEeJ3n7dzGCILd65JmvsLAAkjUfMOZixv4mFf
	E
X-Google-Smtp-Source: AGHT+IHqjsyFvbXEj1ZZYnYrkSSwNgqYTFWny7pb90mPzqACSUxEvk0N2k8gKS8ONLPHO1B4W6kC9g==
X-Received: by 2002:a17:902:d4cc:b0:1fd:a7b8:edaf with SMTP id d9443c01a7336-201ca1da02cmr4993975ad.8.1723478504784;
        Mon, 12 Aug 2024 09:01:44 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb8f7546sm39749705ad.77.2024.08.12.09.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 09:01:44 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/kbuf: add support for incremental buffer consumption
Date: Mon, 12 Aug 2024 09:51:14 -0600
Message-ID: <20240812160129.90546-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240812160129.90546-1-axboe@kernel.dk>
References: <20240812160129.90546-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

By default, any recv/read operation that uses provided buffers will
consume at least 1 buffer fully (and maybe more, in case of bundles).
This adds support for incremental consumption, meaning that an
application may add large buffers, and each read/recv will just consume
the part of the buffer that it needs.

For example, let's say an application registers 1MB buffers in a
provided buffer ring, for streaming receives. If it gets a short recv,
then the full 1MB buffer will be consumed and passed back to the
application. With incremental consumption, only the part that was
actually used is consumed, and the buffer remains the current one.

This means that both the application and the kernel needs to keep track
of what the current receive point is. Each recv will still pass back a
buffer ID and the size consumed, the only difference is that before the
next receive would always be the next buffer in the ring. Now the same
buffer ID may return multiple receives, each at an offset into that
buffer from where the previous receive left off. Example:

Application registers a provided buffer ring, and adds two 32K buffers
to the ring.

Buffer1 address: 0x1000000 (buffer ID 0)
Buffer2 address: 0x2000000 (buffer ID 1)

A recv completion is received with the following values:

cqe->res	0x1000	(4k bytes received)
cqe->flags	0x1	(IORING_CQE_F_BUFFER set, buffer ID 0)

and the application now knows that 4096b of data is available at
0x1000000, the start of that buffer. Now the next receive comes in:

cqe->res	0x2000	(8k bytes received)
cqe->flags	0x1	(IORING_CQE_F_BUFFER set, buffer ID 0)

which tells the application that 8k is available where the last
completion left off, at 0x1001000. Next completion is:

cqe->res	0x5000	(20k bytes received)
cqe->flags	0x1	(IORING_CQE_F_BUFFER set, buffer ID 0)

and the application now knows that 20k of data is available at
0x1003000, which is where the previous receive ended. The next
completion is then:

cqe->res	0x1000	(4k bytes received)
cqe->flags	0x10001	(IORING_CQE_F_BUFFER set, buffer ID 1)

which tells the application that buffer ID 1 is now the current one,
hence there's 4k of valid data at 0x2000000. 0x2001000 will be the next
receive point for this buffer ID.

Once a buffer has been fully consumed, the buffer ring head is
incremented and the next receive will indicate the next buffer ID in the
CQE cflags.

An application can request incremental consumption by setting
IOU_PBUF_RING_INC in the provided buffer ring registration. Outside of
that, any provided buffer ring setup and buffer additions is done like
before, no changes there. The only change is in how an application may
see multiple completions for the same buffer ID, hence needing to know
where the next receive will happen.

Light testing done, works with recv, send (w/bundle), read and read
mshot. Don't particularly like the extra argument for the kbuf put
helpers.

Note that like existing provided buffer rings, this should not be used
with IOSQE_ASYNC, as both really require the ring to remain locked over
the duration of the buffer selection and the operation completion. It
will consume a buffer otherwise regardless of the size of the IO done.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  8 +++++++
 io_uring/io_uring.c           |  2 +-
 io_uring/kbuf.c               | 21 +++++++++++------
 io_uring/kbuf.h               | 43 ++++++++++++++++++++++++-----------
 io_uring/net.c                |  8 +++----
 io_uring/rw.c                 |  8 +++----
 6 files changed, 61 insertions(+), 29 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2aaf7ee256ac..aae91d10e412 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -707,9 +707,17 @@ struct io_uring_buf_ring {
  *			mmap(2) with the offset set as:
  *			IORING_OFF_PBUF_RING | (bgid << IORING_OFF_PBUF_SHIFT)
  *			to get a virtual mapping for the ring.
+ * IOU_PBUF_RING_INC:	If set, buffers consumed from this buffer ring can be
+ *			consumed incrementally. Normally one (or more) buffers
+ *			are fully consumed. With incremental consumptions, it's
+ *			feasible to register big ranges of buffers, and each
+ *			use of it will consume only as much as it needs. This
+ *			requires that both the kernel and application keep
+ *			track of where the current read/recv index is at.
  */
 enum io_uring_register_pbuf_ring_flags {
 	IOU_PBUF_RING_MMAP	= 1,
+	IOU_PBUF_RING_INC	= 2,
 };
 
 /* argument for IORING_(UN)REGISTER_PBUF_RING */
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3942db160f18..390d44cbfce8 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -904,7 +904,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	lockdep_assert_held(&req->ctx->uring_lock);
 
 	req_set_fail(req);
-	io_req_set_res(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
+	io_req_set_res(req, res, io_put_kbuf(req, res, IO_URING_F_UNLOCKED));
 	if (def->fail)
 		def->fail(req);
 	io_req_complete_defer(req);
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 64f5bb91a28b..793b2454acca 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -165,7 +165,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		 * the transfer completes (or if we get -EAGAIN and must poll of
 		 * retry).
 		 */
-		io_kbuf_commit(req, bl, 1);
+		io_kbuf_commit(req, bl, *len, 1);
 		req->buf_list = NULL;
 	}
 	return u64_to_user_ptr(buf->addr);
@@ -241,16 +241,21 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
 	req->buf_index = buf->bid;
 	do {
+		int len = buf->len;
+
 		/* truncate end piece, if needed */
-		if (buf->len > arg->max_len)
-			buf->len = arg->max_len;
+		if (len > arg->max_len) {
+			len = arg->max_len;
+			if (!(bl->flags & IOBL_INC))
+				buf->len = len;
+		}
 
 		iov->iov_base = u64_to_user_ptr(buf->addr);
-		iov->iov_len = buf->len;
+		iov->iov_len = len;
 		iov++;
 
-		arg->out_len += buf->len;
-		arg->max_len -= buf->len;
+		arg->out_len += len;
+		arg->max_len -= len;
 		if (!arg->max_len)
 			break;
 
@@ -672,7 +677,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 
 	if (reg.resv[0] || reg.resv[1] || reg.resv[2])
 		return -EINVAL;
-	if (reg.flags & ~IOU_PBUF_RING_MMAP)
+	if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
 		return -EINVAL;
 	if (!(reg.flags & IOU_PBUF_RING_MMAP)) {
 		if (!reg.ring_addr)
@@ -710,6 +715,8 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (!ret) {
 		bl->nr_entries = reg.ring_entries;
 		bl->mask = reg.ring_entries - 1;
+		if (reg.flags & IOU_PBUF_RING_INC)
+			bl->flags |= IOBL_INC;
 
 		io_buffer_add_list(ctx, bl, reg.bgid);
 		return 0;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index b7da3ce880bf..1d56092d9286 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -9,6 +9,9 @@ enum {
 	IOBL_BUF_RING	= 1,
 	/* ring mapped provided buffers, but mmap'ed by application */
 	IOBL_MMAP	= 2,
+	/* buffers are consumed incrementally rather than always fully */
+	IOBL_INC	= 4,
+
 };
 
 struct io_buffer_list {
@@ -125,20 +128,34 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 #define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
 
 static inline void io_kbuf_commit(struct io_kiocb *req,
-				  struct io_buffer_list *bl, int nr)
+				  struct io_buffer_list *bl, int len, int nr)
 {
 	if (unlikely(!(req->flags & REQ_F_BUFFERS_COMMIT)))
 		return;
-	bl->head += nr;
+	if (bl->flags & IOBL_INC) {
+		struct io_uring_buf *buf;
+
+		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
+		WARN_ON_ONCE(len > buf->len);
+		WARN_ON_ONCE(len < 0);
+		if (len > 0) {
+			buf->addr += len;
+			buf->len -= len;
+			if (!buf->len)
+				bl->head++;
+		}
+	} else {
+		bl->head += nr;
+	}
 	req->flags &= ~REQ_F_BUFFERS_COMMIT;
 }
 
-static inline void __io_put_kbuf_ring(struct io_kiocb *req, int nr)
+static inline void __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
 {
 	struct io_buffer_list *bl = req->buf_list;
 
 	if (bl) {
-		io_kbuf_commit(req, bl, nr);
+		io_kbuf_commit(req, bl, len, nr);
 		req->buf_index = bl->bgid;
 	}
 	req->flags &= ~REQ_F_BUFFER_RING;
@@ -148,7 +165,7 @@ static inline void __io_put_kbuf_list(struct io_kiocb *req,
 				      struct list_head *list)
 {
 	if (req->flags & REQ_F_BUFFER_RING) {
-		__io_put_kbuf_ring(req, 1);
+		__io_put_kbuf_ring(req, 0, 1);
 	} else {
 		req->buf_index = req->kbuf->bgid;
 		list_add(&req->kbuf->list, list);
@@ -166,8 +183,8 @@ static inline void io_kbuf_drop(struct io_kiocb *req)
 	__io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
 }
 
-static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int nbufs,
-					  unsigned issue_flags)
+static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,
+					  int nbufs, unsigned issue_flags)
 {
 	unsigned int ret;
 
@@ -176,21 +193,21 @@ static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int nbufs,
 
 	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
 	if (req->flags & REQ_F_BUFFER_RING)
-		__io_put_kbuf_ring(req, nbufs);
+		__io_put_kbuf_ring(req, len, nbufs);
 	else
 		__io_put_kbuf(req, issue_flags);
 	return ret;
 }
 
-static inline unsigned int io_put_kbuf(struct io_kiocb *req,
+static inline unsigned int io_put_kbuf(struct io_kiocb *req, int len,
 				       unsigned issue_flags)
 {
-	return __io_put_kbufs(req, 1, issue_flags);
+	return __io_put_kbufs(req, len, 1, issue_flags);
 }
 
-static inline unsigned int io_put_kbufs(struct io_kiocb *req, int nbufs,
-					unsigned issue_flags)
+static inline unsigned int io_put_kbufs(struct io_kiocb *req, int len,
+					int nbufs, unsigned issue_flags)
 {
-	return __io_put_kbufs(req, nbufs, issue_flags);
+	return __io_put_kbufs(req, len, nbufs, issue_flags);
 }
 #endif
diff --git a/io_uring/net.c b/io_uring/net.c
index dc83a35b8af4..e312fc1ed7de 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -499,11 +499,11 @@ static inline bool io_send_finish(struct io_kiocb *req, int *ret,
 	unsigned int cflags;
 
 	if (!(sr->flags & IORING_RECVSEND_BUNDLE)) {
-		cflags = io_put_kbuf(req, issue_flags);
+		cflags = io_put_kbuf(req, *ret, issue_flags);
 		goto finish;
 	}
 
-	cflags = io_put_kbufs(req, io_bundle_nbufs(kmsg, *ret), issue_flags);
+	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret), issue_flags);
 
 	if (bundle_finished || req->flags & REQ_F_BL_EMPTY)
 		goto finish;
@@ -844,13 +844,13 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
-		cflags |= io_put_kbufs(req, io_bundle_nbufs(kmsg, *ret),
+		cflags |= io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret),
 				      issue_flags);
 		/* bundle with no more immediate buffers, we're done */
 		if (req->flags & REQ_F_BL_EMPTY)
 			goto finish;
 	} else {
-		cflags |= io_put_kbuf(req, issue_flags);
+		cflags |= io_put_kbuf(req, *ret, issue_flags);
 	}
 
 	/*
diff --git a/io_uring/rw.c b/io_uring/rw.c
index c004d21e2f12..f5e0694538b9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -511,7 +511,7 @@ void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
-		req->cqe.flags |= io_put_kbuf(req, 0);
+		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, 0);
 
 	io_req_rw_cleanup(req, 0);
 	io_req_task_complete(req, ts);
@@ -593,7 +593,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 			 */
 			io_req_io_end(req);
 			io_req_set_res(req, final_ret,
-				       io_put_kbuf(req, issue_flags));
+				       io_put_kbuf(req, ret, issue_flags));
 			io_req_rw_cleanup(req, issue_flags);
 			return IOU_OK;
 		}
@@ -975,7 +975,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		 * Put our buffer and post a CQE. If we fail to post a CQE, then
 		 * jump to the termination path. This request is then done.
 		 */
-		cflags = io_put_kbuf(req, issue_flags);
+		cflags = io_put_kbuf(req, ret, issue_flags);
 		rw->len = 0; /* similarly to above, reset len to 0 */
 
 		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
@@ -1167,7 +1167,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
 		nr_events++;
-		req->cqe.flags = io_put_kbuf(req, 0);
+		req->cqe.flags = io_put_kbuf(req, req->cqe.res, 0);
 		if (req->opcode != IORING_OP_URING_CMD)
 			io_req_rw_cleanup(req, 0);
 	}
-- 
2.43.0


