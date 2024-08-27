Return-Path: <io-uring+bounces-2961-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A4769611F9
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 17:25:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9DA621C23809
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 15:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E85C1BC073;
	Tue, 27 Aug 2024 15:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="f7Lw+Dtq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38AF81C5793
	for <io-uring@vger.kernel.org>; Tue, 27 Aug 2024 15:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772311; cv=none; b=tCQ1Qe1tW+uVT8ibBAQrmN+ZpNAH9MWh4f395LLeccaisPk59cRjrxv15vjdOTBHHiX76hQoZvW5YBuaUgMTzS7ldFXvWIKh0Mw3SKB3nNAK6PyEVqA2IdypMSTcfu41DxR5OLKUYs+Xdej809JGC+c+RqT74LnCbL/JO7I30nM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772311; c=relaxed/simple;
	bh=P3O4IqiNqoh+amtFW3VfS+BQlDuyp+6Fy+8B1w7cizc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KtP9Dz9e2yJMxDZvIDwtW0qJwloZTLxZejz3RhJHNnys7UT9xJZsONqcN6WlHFh47RLnibz5PwjaApPHFT8Ub7xjhygMHj67bpio8r0YZp6J2Tz1/ifcLXbHg47n/I00qiR1ZV08zPzwHv4zo5CegFjmTsTRPrpRwfw+XDm0eIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=f7Lw+Dtq; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-39d26a8f9dbso19001775ab.1
        for <io-uring@vger.kernel.org>; Tue, 27 Aug 2024 08:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724772308; x=1725377108; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8ns9wHSpwlcuQs+dKy4aVfidYTrkb+k6Wj9gTDn2rE4=;
        b=f7Lw+Dtq3FsQwuOAAzrPDSJZdWMJrmHGYqw0mKYuEpO54Lo+pA002wfo/PwRdTo4wi
         TZPdIkPvIzGZ9tQJCKltkmiM1/kMnl+K+e+8nPaMBiItOxdNhsJ8eBG4DGlP4aT2xciA
         GjCk8NZv0XHa37T5WdR5PYe+IXluM0znyymxdZCwwkMhKcLD/BJ8+2FfRyL/Cat5hubQ
         CCYgwYlqH0sT0yZgbyKoz1GUgfddacvKaYFXv25d7UdBKLiqD59IdDc9nPvSkjzga4Y4
         JmptvVKroCg/u81MCw+09NuLrAAvKbW2Bmo9fDQze32ZdqSBdyGGvlOZWslFXetIRB3K
         5SHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724772308; x=1725377108;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8ns9wHSpwlcuQs+dKy4aVfidYTrkb+k6Wj9gTDn2rE4=;
        b=BiMVL4FXuhsNmwX6mZXx7OsOT4PgdiJ08EFM0dO5T2R4lbqWhihUl6qYxzkCWGkMJ6
         a0jM9aH+02johwMklkWqh+X75ecMcZJyR8ZMBfu60MxB2HM+jj/oxys7KoRTsoTFlDvq
         2MxBOH5W4/tG6OrmxjECsxNUlpOCknNY8XcwTBexUTEBkTRezmPGgpoG4WEkJ07wSx+1
         NY5d2VQhSVP2Quumg3goxuU89o49vUAed6H8zBuf4SpUKZe6HC9Vx9cFWMpTYIELcNFN
         L5snzsbZYa/sIzHiIfjKizYpJUA2M1LxYbg7zOZtTbL0rzBY34YI5NH6br3Ot2y0uTg5
         6MkA==
X-Gm-Message-State: AOJu0Yx8FiPB15zkp26ML6Xt5hmqI/kwBYnY+JDAFYvV8J+Cnm4MKO77
	j7NRc0ArOGv87iAS3pyjpiMM+prnSFJxSXNwNDBO/y29Sbo+1cbZ82qtqq/2oQGb5e5iUFP31Yh
	I
X-Google-Smtp-Source: AGHT+IH+K6el7+WaoYVhrhPZ4XyMxtSbekS5mh8y6DLqQQgCpO0SbVMTb+l3KNHg9uXiUuT+fFIHkg==
X-Received: by 2002:a05:6e02:16c6:b0:39b:20d8:601e with SMTP id e9e14a558f8ab-39e63dd8cbamr39610795ab.3.1724772307730;
        Tue, 27 Aug 2024 08:25:07 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ce7106a4a9sm2678580173.106.2024.08.27.08.25.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 08:25:07 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring/kbuf: add support for incremental buffer consumption
Date: Tue, 27 Aug 2024 09:23:09 -0600
Message-ID: <20240827152500.295643-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240827152500.295643-1-axboe@kernel.dk>
References: <20240827152500.295643-1-axboe@kernel.dk>
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
cqe->flags	0x11	(CQE_F_BUFFER|CQE_F_BUF_MORE set, buffer ID 0)

and the application now knows that 4096b of data is available at
0x1000000, the start of that buffer, and that more data from this buffer
will be coming. Now the next receive comes in:

cqe->res	0x2010	(8k bytes received)
cqe->flags	0x11	(CQE_F_BUFFER|CQE_F_BUF_MORE set, buffer ID 0)

which tells the application that 8k is available where the last
completion left off, at 0x1001000. Next completion is:

cqe->res	0x5000	(20k bytes received)
cqe->flags	0x1	(CQE_F_BUFFER set, buffer ID 0)

and the application now knows that 20k of data is available at
0x1003000, which is where the previous receive ended. CQE_F_BUF_MORE
isn't set, as no more data is available in this buffer ID. The next
completion is then:

cqe->res	0x1000	(4k bytes received)
cqe->flags	0x10001	(CQE_F_BUFFER|CQE_F_BUF_MORE set, buffer ID 1)

which tells the application that buffer ID 1 is now the current one,
hence there's 4k of valid data at 0x2000000. 0x2001000 will be the next
receive point for this buffer ID.

When a buffer will be reused by future CQE completions,
IORING_CQE_BUF_MORE will be set in cqe->flags. This tells the application
that the kernel isn't done with the buffer yet, and that it should expect
more completions for this buffer ID. Will only be set by provided buffer
rings setup with IOU_PBUF_RING INC, as that's the only type of buffer
that will see multiple consecutive completions for the same buffer ID.
For any other provided buffer type, any completion that passes back
a buffer to the application is final.

Once a buffer has been fully consumed, the buffer ring head is
incremented and the next receive will indicate the next buffer ID in the
CQE cflags.

On the send side, the application can manage how much data is sent from
an existing buffer by setting sqe->len to the desired send length.

An application can request incremental consumption by setting
IOU_PBUF_RING_INC in the provided buffer ring registration. Outside of
that, any provided buffer ring setup and buffer additions is done like
before, no changes there. The only change is in how an application may
see multiple completions for the same buffer ID, hence needing to know
where the next receive will happen.

Note that like existing provided buffer rings, this should not be used
with IOSQE_ASYNC, as both really require the ring to remain locked over
the duration of the buffer selection and the operation completion. It
will consume a buffer otherwise regardless of the size of the IO done.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h | 18 +++++++++++++++
 io_uring/kbuf.c               | 42 +++++++++++++++++++++++++----------
 io_uring/kbuf.h               | 42 ++++++++++++++++++++++++++++-------
 3 files changed, 82 insertions(+), 20 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 042eab793e26..a275f91d2ac0 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -440,11 +440,21 @@ struct io_uring_cqe {
  * IORING_CQE_F_SOCK_NONEMPTY	If set, more data to read after socket recv
  * IORING_CQE_F_NOTIF	Set for notification CQEs. Can be used to distinct
  * 			them from sends.
+ * IORING_CQE_F_BUF_MORE If set, the buffer ID set in the completion will get
+ *			more completions. In other words, the buffer is being
+ *			partially consumed, and will be used by the kernel for
+ *			more completions. This is only set for buffers used via
+ *			the incremental buffer consumption, as provided by
+ *			a ring buffer setup with IOU_PBUF_RING_INC. For any
+ *			other provided buffer type, all completions with a
+ *			buffer passed back is automatically returned to the
+ *			application.
  */
 #define IORING_CQE_F_BUFFER		(1U << 0)
 #define IORING_CQE_F_MORE		(1U << 1)
 #define IORING_CQE_F_SOCK_NONEMPTY	(1U << 2)
 #define IORING_CQE_F_NOTIF		(1U << 3)
+#define IORING_CQE_F_BUF_MORE		(1U << 4)
 
 #define IORING_CQE_BUFFER_SHIFT		16
 
@@ -716,9 +726,17 @@ struct io_uring_buf_ring {
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
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 55d01861d8c5..1f503bcc9c9f 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -212,14 +212,25 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 	buf = io_ring_head_to_buf(br, head, bl->mask);
 	if (arg->max_len) {
 		u32 len = READ_ONCE(buf->len);
-		size_t needed;
 
 		if (unlikely(!len))
 			return -ENOBUFS;
-		needed = (arg->max_len + len - 1) / len;
-		needed = min_not_zero(needed, (size_t) PEEK_MAX_IMPORT);
-		if (nr_avail > needed)
-			nr_avail = needed;
+		/*
+		 * Limit incremental buffers to 1 segment. No point trying
+		 * to peek ahead and map more than we need, when the buffers
+		 * themselves should be large when setup with
+		 * IOU_PBUF_RING_INC.
+		 */
+		if (bl->flags & IOBL_INC) {
+			nr_avail = 1;
+		} else {
+			size_t needed;
+
+			needed = (arg->max_len + len - 1) / len;
+			needed = min_not_zero(needed, (size_t) PEEK_MAX_IMPORT);
+			if (nr_avail > needed)
+				nr_avail = needed;
+		}
 	}
 
 	/*
@@ -244,16 +255,21 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
 	req->buf_index = buf->bid;
 	do {
-		/* truncate end piece, if needed */
-		if (buf->len > arg->max_len)
-			buf->len = arg->max_len;
+		u32 len = buf->len;
+
+		/* truncate end piece, if needed, for non partial buffers */
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
 
@@ -675,7 +691,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 
 	if (reg.resv[0] || reg.resv[1] || reg.resv[2])
 		return -EINVAL;
-	if (reg.flags & ~IOU_PBUF_RING_MMAP)
+	if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
 		return -EINVAL;
 	if (!(reg.flags & IOU_PBUF_RING_MMAP)) {
 		if (!reg.ring_addr)
@@ -713,6 +729,8 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (!ret) {
 		bl->nr_entries = reg.ring_entries;
 		bl->mask = reg.ring_entries - 1;
+		if (reg.flags & IOU_PBUF_RING_INC)
+			bl->flags |= IOBL_INC;
 
 		io_buffer_add_list(ctx, bl, reg.bgid);
 		return 0;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index b41e2a0a0505..36aadfe5ac00 100644
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
@@ -124,24 +127,45 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 /* Mapped buffer ring, return io_uring_buf from head */
 #define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
 
-static inline void io_kbuf_commit(struct io_kiocb *req,
+static inline bool io_kbuf_commit(struct io_kiocb *req,
 				  struct io_buffer_list *bl, int len, int nr)
 {
 	if (unlikely(!(req->flags & REQ_F_BUFFERS_COMMIT)))
-		return;
-	bl->head += nr;
+		return true;
+
 	req->flags &= ~REQ_F_BUFFERS_COMMIT;
+
+	if (unlikely(len < 0))
+		return true;
+
+	if (bl->flags & IOBL_INC) {
+		struct io_uring_buf *buf;
+
+		buf = io_ring_head_to_buf(bl->buf_ring, bl->head, bl->mask);
+		if (WARN_ON_ONCE(len > buf->len))
+			len = buf->len;
+		buf->len -= len;
+		if (buf->len) {
+			buf->addr += len;
+			return false;
+		}
+	}
+
+	bl->head += nr;
+	return true;
 }
 
-static inline void __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
+static inline bool __io_put_kbuf_ring(struct io_kiocb *req, int len, int nr)
 {
 	struct io_buffer_list *bl = req->buf_list;
+	bool ret = true;
 
 	if (bl) {
-		io_kbuf_commit(req, bl, len, nr);
+		ret = io_kbuf_commit(req, bl, len, nr);
 		req->buf_index = bl->bgid;
 	}
 	req->flags &= ~REQ_F_BUFFER_RING;
+	return ret;
 }
 
 static inline void __io_put_kbuf_list(struct io_kiocb *req, int len,
@@ -176,10 +200,12 @@ static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,
 		return 0;
 
 	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
-	if (req->flags & REQ_F_BUFFER_RING)
-		__io_put_kbuf_ring(req, len, nbufs);
-	else
+	if (req->flags & REQ_F_BUFFER_RING) {
+		if (!__io_put_kbuf_ring(req, len, nbufs))
+			ret |= IORING_CQE_F_BUF_MORE;
+	} else {
 		__io_put_kbuf(req, len, issue_flags);
+	}
 	return ret;
 }
 
-- 
2.45.2


