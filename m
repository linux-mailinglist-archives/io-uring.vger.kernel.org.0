Return-Path: <io-uring+bounces-2922-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C19A395D06D
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 16:52:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E68271C2194E
	for <lists+io-uring@lfdr.de>; Fri, 23 Aug 2024 14:52:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D8C5188904;
	Fri, 23 Aug 2024 14:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MHCNafF7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08D60188905
	for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 14:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724424705; cv=none; b=uD+bSbMhBVGz/mbChDrjevQXP57SvKuvLaY59OU7+taUn47zpDJ7d9/BQmPJNPSHhWy4/aZth7hGQLqrER2HpcnaRenoEofy9hBSCcNv8FnKaWuPJUjuXjBknsEBwbhpDR3KDjuJcp4ifPBAHJbchdzpn7rVAMOwVS0zxRfxW0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724424705; c=relaxed/simple;
	bh=hHVdx656Bd8yNsMl8p3f57V+hrJjlVPjO18W24wuNwo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdxPZT2Hp68TA8mw7znRy8yw7k4Nd12rJq4J+VWWRn7/rXLNHCTHPWz1iRzxxOyA6Ll1cheLR6korpVFATFe8ies6/rKKVfID+EuNAKwV5y16DEffXk8uBsRglKXtLAgUuWaMQx47qfFHqiiX+jRVQpuc0X5rjZtFDlvz6YOi2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MHCNafF7; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-81f94ce2272so75456139f.2
        for <io-uring@vger.kernel.org>; Fri, 23 Aug 2024 07:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724424702; x=1725029502; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M1+qAgn1bk+II5EU3OfM4dl1ezckLEqK+zE+ySsD5zs=;
        b=MHCNafF7PWMb/SEINlFTcnVqQzpFf9YpVVskMwQZ0Qs5Or5EvElE5CyPkiMtnohuhf
         BpxMQsqllLCVrqq/noprJhOCGVlkxYHh8j/Z5H51qyaOt6zjRUc5eC7OFQk/3kBYqcCs
         TTEv7bgzp5ofTj7JLVyKqBYzoaMmPHcn5LPs764z7d5uW6FEORi1dzAV1aZPexna+dSZ
         gg/sBxW9NzevpxZ4TfH3Hz8YKcrUCc9oMLe6Ng2+/GVwxbN+TxTwDJ+Nps3LId744u7V
         MArK9ytumW1YiNzd6B2KiR0rFRae6U5JXZU8G7U+dpyA+WbMQZkh1P3MVF4zwiJuvV02
         pHSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724424702; x=1725029502;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M1+qAgn1bk+II5EU3OfM4dl1ezckLEqK+zE+ySsD5zs=;
        b=bobMCd+rS32VbjURQc/PijttB/gkHaR3JefLjgKm4wLibaBFPz0L5S2gyqtY4f/J0e
         1ON+8SSfHfx8B0tFyHTPOcF6Pf3+sniRNyxd3vdLMjb4jvGcR8QadQI9i2xHew6b4Ps0
         h9hRAD3ZWnBIemHUTXaFIIP4QYfYUjcvBquJpOSBu5hDC4GRCvehp3ID0QijfCEOe9nw
         uy7PjJ9ZlaU6WeRwPFJuZog/nqeetZ8E+j2h7CLfL132cME8rkCFZpRUxSHcQB9gFN+3
         TfNQNI1R98Rc+JiWSgVTZj/Uy3wR9z4xa6dsXbtQtt5s68UPmxu6nUH+vszpfInT3lY0
         FeXQ==
X-Gm-Message-State: AOJu0YzsZZYvmu0iTTP3zRIJsxyyfcgVG/XfbLinYVoz/3ZOp648L29x
	A8bP+dDw19MXtB8sa75jxm9SKbQSgm3egfVUrKwrPD7U1rD1Il23QrE5gsYH4O2VPiM0hFS6qdn
	9
X-Google-Smtp-Source: AGHT+IH3sOvo/jvSIqLcIFWbrUJyw4tD9qmcP6AeGXa7srfmymsnmubSSH/vYXUIHmQHuL72ooxQFA==
X-Received: by 2002:a05:6602:3fca:b0:81f:94cd:7600 with SMTP id ca18e2360f4ac-8278736ad66mr282786439f.13.1724424701490;
        Fri, 23 Aug 2024 07:51:41 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8253d5aa137sm115039939f.11.2024.08.23.07.51.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Aug 2024 07:51:41 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring/kbuf: add support for incremental buffer consumption
Date: Fri, 23 Aug 2024 08:42:37 -0600
Message-ID: <20240823145104.20600-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240823145104.20600-2-axboe@kernel.dk>
References: <20240823145104.20600-2-axboe@kernel.dk>
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
 include/uapi/linux/io_uring.h | 18 ++++++++++
 io_uring/io_uring.c           |  2 +-
 io_uring/kbuf.c               | 26 ++++++++++-----
 io_uring/kbuf.h               | 63 +++++++++++++++++++++++++----------
 io_uring/net.c                |  8 ++---
 io_uring/rw.c                 |  8 ++---
 6 files changed, 91 insertions(+), 34 deletions(-)

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
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 80bb6e2374e9..1aca501efaf6 100644
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
index 0aa12703bac7..75b69ea85ac1 100644
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
@@ -244,16 +244,21 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 
 	req->buf_index = buf->bid;
 	do {
+		u32 len = buf->len;
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
 
@@ -290,8 +295,11 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		 * committed them, they cannot be put back in the queue.
 		 */
 		if (ret > 0) {
+			if (bl->flags & IOBL_INC)
+				req->flags |= REQ_F_BUFFERS_COMMIT;
+			else
+				bl->head += ret;
 			req->flags |= REQ_F_BL_NO_RECYCLE;
-			bl->head += ret;
 		}
 	} else {
 		ret = io_provided_buffers_select(req, &arg->out_len, bl, arg->iovs);
@@ -675,7 +683,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 
 	if (reg.resv[0] || reg.resv[1] || reg.resv[2])
 		return -EINVAL;
-	if (reg.flags & ~IOU_PBUF_RING_MMAP)
+	if (reg.flags & ~(IOU_PBUF_RING_MMAP | IOU_PBUF_RING_INC))
 		return -EINVAL;
 	if (!(reg.flags & IOU_PBUF_RING_MMAP)) {
 		if (!reg.ring_addr)
@@ -713,6 +721,8 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	if (!ret) {
 		bl->nr_entries = reg.ring_entries;
 		bl->mask = reg.ring_entries - 1;
+		if (reg.flags & IOU_PBUF_RING_INC)
+			bl->flags |= IOBL_INC;
 
 		io_buffer_add_list(ctx, bl, reg.bgid);
 		return 0;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index b7da3ce880bf..6be7f00c87e1 100644
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
@@ -124,31 +127,55 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 /* Mapped buffer ring, return io_uring_buf from head */
 #define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
 
-static inline void io_kbuf_commit(struct io_kiocb *req,
-				  struct io_buffer_list *bl, int nr)
+/* returns false if more completions will be done from the current bid */
+static inline bool io_kbuf_commit(struct io_kiocb *req,
+				 struct io_buffer_list *bl, int len, int nr)
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
 
-static inline void __io_put_kbuf_ring(struct io_kiocb *req, int nr)
+static inline unsigned __io_put_kbuf_ring(struct io_kiocb *req, int len,
+					  int nr)
 {
 	struct io_buffer_list *bl = req->buf_list;
+	unsigned cflags = 0;
 
 	if (bl) {
-		io_kbuf_commit(req, bl, nr);
+		if (!io_kbuf_commit(req, bl, len, nr))
+			cflags |= IORING_CQE_F_BUF_MORE;
 		req->buf_index = bl->bgid;
 	}
 	req->flags &= ~REQ_F_BUFFER_RING;
+	return cflags;
 }
 
 static inline void __io_put_kbuf_list(struct io_kiocb *req,
 				      struct list_head *list)
 {
 	if (req->flags & REQ_F_BUFFER_RING) {
-		__io_put_kbuf_ring(req, 1);
+		__io_put_kbuf_ring(req, 0, 1);
 	} else {
 		req->buf_index = req->kbuf->bgid;
 		list_add(&req->kbuf->list, list);
@@ -166,8 +193,8 @@ static inline void io_kbuf_drop(struct io_kiocb *req)
 	__io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
 }
 
-static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int nbufs,
-					  unsigned issue_flags)
+static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,
+					  int nbufs, unsigned issue_flags)
 {
 	unsigned int ret;
 
@@ -175,22 +202,24 @@ static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int nbufs,
 		return 0;
 
 	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
-	if (req->flags & REQ_F_BUFFER_RING)
-		__io_put_kbuf_ring(req, nbufs);
-	else
+	if (req->flags & REQ_F_BUFFER_RING) {
+		if (!__io_put_kbuf_ring(req, len, nbufs))
+			ret |= IORING_CQE_F_BUF_MORE;
+	} else {
 		__io_put_kbuf(req, issue_flags);
+	}
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
index cc81bcacdc1b..f10f5a22d66a 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -497,11 +497,11 @@ static inline bool io_send_finish(struct io_kiocb *req, int *ret,
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
@@ -842,13 +842,13 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
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


