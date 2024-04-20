Return-Path: <io-uring+bounces-1600-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CCC218ABBBB
	for <lists+io-uring@lfdr.de>; Sat, 20 Apr 2024 15:33:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F296C1C20833
	for <lists+io-uring@lfdr.de>; Sat, 20 Apr 2024 13:33:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77C618C10;
	Sat, 20 Apr 2024 13:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0YjdolPA"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56F852030A
	for <io-uring@vger.kernel.org>; Sat, 20 Apr 2024 13:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713619978; cv=none; b=DAxrfJY4ghAabXhu4TeVMNUYuUax/vEQ07qPd3G8MiY93r6pdVLeRB0e52Ay8L3S5de6dlh8hS6ppaNC+3GcDhyUq+kWZBwrKw/WADlqV8QQMUuSdo1nJHfMwWH1ehGZXwAYug0dlzzsW32Sls4VfjdRszR4Hal9p/vSCXeRX+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713619978; c=relaxed/simple;
	bh=rh9/Yc4BzJju/X1Nc2UlrWMhtpQ0YUYUlogRFwI0T5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rb1Uy2aef418RA/YBRd2hrs0pXc+W+7yhlUu2Hlb/3s4vKOtNRB/aFfwS3BDA4wzZtNmQt3FE3XrLr3TanXXtMOwDp80UQxS7CpX4/myGrguBY4h8+VbK2pEuDznt7MUgAPmOg59ki2UYO5qNciq6pImXSEW7y9F8Q31nhVn5nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0YjdolPA; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2a58d2e5be8so723566a91.0
        for <io-uring@vger.kernel.org>; Sat, 20 Apr 2024 06:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1713619975; x=1714224775; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P/x/G1anmqCIrevrbLW+K8zTuG2c46uBjTz0TJFDREw=;
        b=0YjdolPAuA6rfpt20H+3DefgNhQRn4Nfr5y7d/HMIkEY5HL1HWQi/oWzJov0RX/K22
         0zaVcr0iC5eNEaLwopAAMVDeTwkDaurz9GFLY+YQ0nVIaCkKTz3cY50smuyRpD2aKNtV
         L1rKB4tjaYP0KOmd2pYZP4vrKOPiHArbTQ0CexkwpxwRsHrUBaCIadRo9QcOP7rIGbmK
         P5jlICUIaXV/qVuMjUsSS7mkhZjVD+r7VgoLnoWkcWheinMg4gJFsKY+P8vlGGOc4UYr
         T9R7n44mw02VSwrcCr8bkv63JP1Yk8s0KEeNOxKFr6V+qbITOFePZJ6otNUgY7ABLp3r
         iRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713619975; x=1714224775;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P/x/G1anmqCIrevrbLW+K8zTuG2c46uBjTz0TJFDREw=;
        b=HXfPhJHYhe5jYYh8MELoZHOUYhoB+V6sR/qUZm2pPUA2f4Rc6ej12n3axjNg2tpE+T
         IVAssOYjcuU5g5JK3txIRRVLkETEHstFVeJn4ydJN9hgfo1sr695uXoF9ObiaYFGkw9y
         /ElmFGMptCWIq+4K8qempL2ZfAKKvkP22smW7aufGIPlAsMKyya0TpLsYGjXBzSMDD6x
         FzoTBOJJcXaaAw5xzzCBpHCL8hxTzQ3swaw6osl7GWsjOEOVMXV9WB5UrmgC46eac74V
         Zrf80L7sGvu2ljBItom+0xJlLf2P89NiP+ZZuUSdEQL6bi7eCJZrGFkVHl6wX1lisezf
         gKHg==
X-Gm-Message-State: AOJu0Yzw86n6t9oqw/xEZubwwVf8j6ZTvkgDNTBa0XLDk6QPsOTtIGop
	23rxZkkBrRItsPjysxyz0oTYMiIKVrA+GyatOmJBV8Opzd5IHz82PDgLLPyyQsL054bzFn45w7V
	9
X-Google-Smtp-Source: AGHT+IEbQRzcHe7HsiWUfL7o1QthQWEVPoddAMVinYDN9KB3woUSvhW1i/M50FYp3RdmEyKYKs2nVw==
X-Received: by 2002:a05:6a21:60a:b0:1ac:ef54:91da with SMTP id ll10-20020a056a21060a00b001acef5491damr1661882pzb.1.1713619974840;
        Sat, 20 Apr 2024 06:32:54 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id k5-20020a6568c5000000b005f7ba54e499sm2926610pgt.87.2024.04.20.06.32.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Apr 2024 06:32:53 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/5] io_uring/kbuf: add helpers for getting/peeking multiple buffers
Date: Sat, 20 Apr 2024 07:29:45 -0600
Message-ID: <20240420133233.500590-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240420133233.500590-2-axboe@kernel.dk>
References: <20240420133233.500590-2-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Our provided buffer interface only allows selection of a single buffer.
Add an API that allows getting/peeking multiple buffers at the same time.

This is only implemented for the ring provided buffers. It could be added
for the legacy provided buffers as well, but since it's strongly
encouraged to use the new interface, let's keep it simpler and just
provide it for the new API. The legacy interface will always just select
a single buffer.

There are two new main functions:

io_buffers_select(), which selects up as many buffers as it can. The
caller supplies the iovec array, and io_buffers_select() may allocate a
bigger array if the 'out_len' being passed in is non-zero and bigger
than what fits in the provided iovec. Buffers grabbed with this helper
are permanently assigned.

io_buffers_peek(), which works like io_buffers_select(), except they can
be recycled, if needed. Callers using either of these functions should
call io_put_kbufs() rather than io_put_kbuf() at completion time. The
peek interface must be called with the ctx locked from peek to
completion.

This add a bit state for the request:

- REQ_F_BUFFERS_COMMIT, which means that the the buffers have been
  peeked and should be committed to the buffer ring head when they are
  put as part of completion. Prior to this, req->buf_list was cleared to
  NULL when committed.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |   3 +
 io_uring/kbuf.c                | 157 ++++++++++++++++++++++++++++++++-
 io_uring/kbuf.h                |  53 +++++++++--
 3 files changed, 201 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c47f412cf18e..7a6b190c7da7 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -472,6 +472,7 @@ enum {
 	REQ_F_CAN_POLL_BIT,
 	REQ_F_BL_EMPTY_BIT,
 	REQ_F_BL_NO_RECYCLE_BIT,
+	REQ_F_BUFFERS_COMMIT_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -550,6 +551,8 @@ enum {
 	REQ_F_BL_EMPTY		= IO_REQ_FLAG(REQ_F_BL_EMPTY_BIT),
 	/* don't recycle provided buffers for this request */
 	REQ_F_BL_NO_RECYCLE	= IO_REQ_FLAG(REQ_F_BL_NO_RECYCLE_BIT),
+	/* buffer ring head needs incrementing on put */
+	REQ_F_BUFFERS_COMMIT	= IO_REQ_FLAG(REQ_F_BUFFERS_COMMIT_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 3846a055df44..d2945c9c812b 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -117,6 +117,27 @@ static void __user *io_provided_buffer_select(struct io_kiocb *req, size_t *len,
 	return NULL;
 }
 
+static int io_provided_buffers_select(struct io_kiocb *req, size_t *len,
+				      struct io_buffer_list *bl,
+				      struct iovec *iov)
+{
+	void __user *buf;
+
+	buf = io_provided_buffer_select(req, len, bl);
+	if (unlikely(!buf))
+		return -ENOBUFS;
+
+	iov[0].iov_base = buf;
+	iov[0].iov_len = *len;
+	return 0;
+}
+
+static struct io_uring_buf *io_ring_head_to_buf(struct io_uring_buf_ring *br,
+						__u16 head, __u16 mask)
+{
+	return &br->bufs[head & mask];
+}
+
 static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 					  struct io_buffer_list *bl,
 					  unsigned int issue_flags)
@@ -132,11 +153,10 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	if (head + 1 == tail)
 		req->flags |= REQ_F_BL_EMPTY;
 
-	head &= bl->mask;
-	buf = &br->bufs[head];
+	buf = io_ring_head_to_buf(br, head, bl->mask);
 	if (*len == 0 || *len > buf->len)
 		*len = buf->len;
-	req->flags |= REQ_F_BUFFER_RING;
+	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
 	req->buf_list = bl;
 	req->buf_index = buf->bid;
 
@@ -151,6 +171,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		 * the transfer completes (or if we get -EAGAIN and must poll of
 		 * retry).
 		 */
+		req->flags &= ~REQ_F_BUFFERS_COMMIT;
 		req->buf_list = NULL;
 		bl->head++;
 	}
@@ -177,6 +198,136 @@ void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	return ret;
 }
 
+/* cap it at a reasonable 256, will be one page even for 4K */
+#define PEEK_MAX_IMPORT		256
+
+static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
+				struct io_buffer_list *bl)
+{
+	struct io_uring_buf_ring *br = bl->buf_ring;
+	struct iovec *iov = arg->iovs;
+	int nr_iovs = arg->nr_iovs;
+	__u16 nr_avail, tail, head;
+	struct io_uring_buf *buf;
+
+	tail = smp_load_acquire(&br->tail);
+	head = bl->head;
+	nr_avail = min_t(__u16, tail - head, UIO_MAXIOV);
+	if (unlikely(!nr_avail))
+		return -ENOBUFS;
+
+	buf = io_ring_head_to_buf(br, head, bl->mask);
+	if (arg->max_len) {
+		int needed;
+
+		needed = (arg->max_len + buf->len - 1) / buf->len;
+		needed = min(needed, PEEK_MAX_IMPORT);
+		if (nr_avail > needed)
+			nr_avail = needed;
+	}
+
+	/*
+	 * only alloc a bigger array if we know we have data to map, eg not
+	 * a speculative peek operation.
+	 */
+	if (arg->mode & KBUF_MODE_EXPAND && nr_avail > nr_iovs && arg->max_len) {
+		iov = kmalloc_array(nr_avail, sizeof(struct iovec), GFP_KERNEL);
+		if (unlikely(!iov))
+			return -ENOMEM;
+		if (arg->mode & KBUF_MODE_FREE)
+			kfree(arg->iovs);
+		arg->iovs = iov;
+		nr_iovs = nr_avail;
+	} else if (nr_avail < nr_iovs) {
+		nr_iovs = nr_avail;
+	}
+
+	/* set it to max, if not set, so we can use it unconditionally */
+	if (!arg->max_len)
+		arg->max_len = INT_MAX;
+
+	req->buf_index = buf->bid;
+	do {
+		/* truncate end piece, if needed */
+		if (buf->len > arg->max_len)
+			buf->len = arg->max_len;
+
+		iov->iov_base = u64_to_user_ptr(buf->addr);
+		iov->iov_len = buf->len;
+		iov++;
+
+		arg->out_len += buf->len;
+		arg->max_len -= buf->len;
+		if (!arg->max_len)
+			break;
+
+		buf = io_ring_head_to_buf(br, ++head, bl->mask);
+	} while (--nr_iovs);
+
+	if (head == tail)
+		req->flags |= REQ_F_BL_EMPTY;
+
+	req->flags |= REQ_F_BUFFER_RING;
+	req->buf_list = bl;
+	return iov - arg->iovs;
+}
+
+int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
+		      unsigned int issue_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer_list *bl;
+	int ret = -ENOENT;
+
+	io_ring_submit_lock(ctx, issue_flags);
+	bl = io_buffer_get_list(ctx, req->buf_index);
+	if (unlikely(!bl))
+		goto out_unlock;
+
+	if (bl->is_buf_ring) {
+		ret = io_ring_buffers_peek(req, arg, bl);
+		/*
+		 * Don't recycle these buffers if we need to go through poll.
+		 * Nobody else can use them anyway, and holding on to provided
+		 * buffers for a send/write operation would happen on the app
+		 * side anyway with normal buffers. Besides, we already
+		 * committed them, they cannot be put back in the queue.
+		 */
+		if (ret > 0) {
+			req->flags |= REQ_F_BL_NO_RECYCLE;
+			req->buf_list->head += ret;
+		}
+	} else {
+		ret = io_provided_buffers_select(req, &arg->out_len, bl, arg->iovs);
+	}
+out_unlock:
+	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
+}
+
+int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_buffer_list *bl;
+	int ret;
+
+	lockdep_assert_held(&ctx->uring_lock);
+
+	bl = io_buffer_get_list(ctx, req->buf_index);
+	if (unlikely(!bl))
+		return -ENOENT;
+
+	if (bl->is_buf_ring) {
+		ret = io_ring_buffers_peek(req, arg, bl);
+		if (ret > 0)
+			req->flags |= REQ_F_BUFFERS_COMMIT;
+		return ret;
+	}
+
+	/* don't support multiple buffer selections for legacy */
+	return io_provided_buffers_select(req, &arg->max_len, bl, arg->iovs);
+}
+
 static int __io_remove_buffers(struct io_ring_ctx *ctx,
 			       struct io_buffer_list *bl, unsigned nbufs)
 {
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 5a9635ee0217..b90aca3a57fa 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -41,8 +41,26 @@ struct io_buffer {
 	__u16 bgid;
 };
 
+enum {
+	/* can alloc a bigger vec */
+	KBUF_MODE_EXPAND	= 1,
+	/* if bigger vec allocated, free old one */
+	KBUF_MODE_FREE		= 2,
+};
+
+struct buf_sel_arg {
+	struct iovec *iovs;
+	size_t out_len;
+	size_t max_len;
+	int nr_iovs;
+	int mode;
+};
+
 void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 			      unsigned int issue_flags);
+int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
+		      unsigned int issue_flags);
+int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg);
 void io_destroy_buffers(struct io_ring_ctx *ctx);
 
 int io_remove_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
@@ -75,7 +93,7 @@ static inline bool io_kbuf_recycle_ring(struct io_kiocb *req)
 	 */
 	if (req->buf_list) {
 		req->buf_index = req->buf_list->bgid;
-		req->flags &= ~REQ_F_BUFFER_RING;
+		req->flags &= ~(REQ_F_BUFFER_RING|REQ_F_BUFFERS_COMMIT);
 		return true;
 	}
 	return false;
@@ -99,11 +117,16 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 	return false;
 }
 
-static inline void __io_put_kbuf_ring(struct io_kiocb *req)
+static inline void __io_put_kbuf_ring(struct io_kiocb *req, int nr)
 {
-	if (req->buf_list) {
-		req->buf_index = req->buf_list->bgid;
-		req->buf_list->head++;
+	struct io_buffer_list *bl = req->buf_list;
+
+	if (bl) {
+		if (req->flags & REQ_F_BUFFERS_COMMIT) {
+			bl->head += nr;
+			req->flags &= ~REQ_F_BUFFERS_COMMIT;
+		}
+		req->buf_index = bl->bgid;
 	}
 	req->flags &= ~REQ_F_BUFFER_RING;
 }
@@ -112,7 +135,7 @@ static inline void __io_put_kbuf_list(struct io_kiocb *req,
 				      struct list_head *list)
 {
 	if (req->flags & REQ_F_BUFFER_RING) {
-		__io_put_kbuf_ring(req);
+		__io_put_kbuf_ring(req, 1);
 	} else {
 		req->buf_index = req->kbuf->bgid;
 		list_add(&req->kbuf->list, list);
@@ -130,8 +153,8 @@ static inline void io_kbuf_drop(struct io_kiocb *req)
 	__io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
 }
 
-static inline unsigned int io_put_kbuf(struct io_kiocb *req,
-				       unsigned issue_flags)
+static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int nbufs,
+					  unsigned issue_flags)
 {
 	unsigned int ret;
 
@@ -140,9 +163,21 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 
 	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
 	if (req->flags & REQ_F_BUFFER_RING)
-		__io_put_kbuf_ring(req);
+		__io_put_kbuf_ring(req, nbufs);
 	else
 		__io_put_kbuf(req, issue_flags);
 	return ret;
 }
+
+static inline unsigned int io_put_kbuf(struct io_kiocb *req,
+				       unsigned issue_flags)
+{
+	return __io_put_kbufs(req, 1, issue_flags);
+}
+
+static inline unsigned int io_put_kbufs(struct io_kiocb *req, int nbufs,
+					unsigned issue_flags)
+{
+	return __io_put_kbufs(req, nbufs, issue_flags);
+}
 #endif
-- 
2.43.0


