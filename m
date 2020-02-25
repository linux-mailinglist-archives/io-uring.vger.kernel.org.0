Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 875E616EB39
	for <lists+io-uring@lfdr.de>; Tue, 25 Feb 2020 17:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728762AbgBYQVF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 25 Feb 2020 11:21:05 -0500
Received: from mail-io1-f66.google.com ([209.85.166.66]:35677 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728051AbgBYQVF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 25 Feb 2020 11:21:05 -0500
Received: by mail-io1-f66.google.com with SMTP id h8so2025440iob.2
        for <io-uring@vger.kernel.org>; Tue, 25 Feb 2020 08:21:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=q81uZYP1dr2I7ML9cbyRzoj5265hFdFzLvA+Xdaap2I=;
        b=Uikp3HAJVWt49ZM0ACEyYVmBaKzqiCZc0wS83sWwvvHuzaDMerdSsciGqNfv50YdtQ
         vDxM2Wlwdm6/DVTBZIrocvp7H5tcT2KYktTJ75gtXB3H9GhlRFZZJkvOUO3xpIUFDvMu
         DEsBdfxu4G3rA7QtVPv0vtJcQ+lC03oPjnaBbUaSBdS/pXOEHmWl7fM/7WWHC9ACPoVY
         86k7bj5EsY2ywPSAHbs7RSoeexJSbbwHA7hBOsV6Z6BeqsTvVsCmEvPGV4jUdzFO4S29
         aYF2udwjGTsPscgU9psOR9fKIzsuPlwyNAq9GzoR6+YImctGmtDX66CCdrG9VbXEk67R
         51Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=q81uZYP1dr2I7ML9cbyRzoj5265hFdFzLvA+Xdaap2I=;
        b=f0Fvr3RQwXDxlJyL96aeqjoOFeqpQ9vViBPMAEqxVznANTisaU/PAwxSgG3yI06+nj
         K9naCiJdGUaQci+4muvZqxGKHqbDksedvAbMlBftb5RbhB5q6dSaW3I157wwXe+558gG
         yB/cwxU4myuwDdsrkD4VZ5mqE11r8riaKCel7LgAGbM0PPNbzh4XWJMyzoQ3vWFAX3Z1
         q7Gzqplnqei86VGi1DrWmphEURiRcCKxBaGdjhLRQDls02bOnLpSl4xwZjigRKzA5G1l
         3lchKu8r77rzKT+/na56YjVveQ04X3BId+2XL5++ZcHn4nv7FgQkX4PRn+6RAwwjInb5
         LvfA==
X-Gm-Message-State: APjAAAVQpPe72dOreq7SCfvyHavjFIVgkrIKe/JvJuD8WdBigAKgL8nf
        ghi5jERPewO5kuk3BpJivcaEojSCyto=
X-Google-Smtp-Source: APXvYqxmDznYNJu9+wiHGaLRXryAVWw+2K0a3ZGEoIgqcRvn78g9ShnfMgI0noys2cBS7gnGUD7czQ==
X-Received: by 2002:a02:9503:: with SMTP id y3mr49949266jah.14.1582647662383;
        Tue, 25 Feb 2020 08:21:02 -0800 (PST)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y19sm3842417ioc.78.2020.02.25.08.21.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2020 08:21:01 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: support buffer selection
Date:   Tue, 25 Feb 2020 09:20:57 -0700
Message-Id: <20200225162057.11800-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200225162057.11800-1-axboe@kernel.dk>
References: <20200225162057.11800-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a server process has tons of pending socket connections, generally
it uses epoll to wait for activity. When the socket is ready for reading
(or writing), the task can select a buffer and issue a recv/send on the
given fd.

Now that we have fast (non-async thread) support, a task can have tons
of pending reads or writes pending. But that means they need buffers to
back that data, and if the number of connections is high enough, having
them preallocated for all possible connections is unfeasible.

With IORING_OP_PROVIDE_BUFFERS, an application can register buffers to
use for any request. The request then sets IOSQE_BUFFER_SELECT in the
sqe, and a given group ID in sqe->buf_group. When the fd becomes ready,
a free buffer from the specified group is selected. If none are
available, the request is terminated with -ENOBUFS. If successful, the
CQE on completion will contain the buffer ID chosen in the cqe->flags
member, encoded as:

	(buffer_id << IORING_CQE_BUFFER_SHIFT) | IORING_CQE_F_BUFFER;

Once a buffer has been consumed by a request, it is no longer available
and must be registered again with IORING_OP_PROVIDE_BUFFERS.

Requests need to support this feature. For now, IORING_OP_READ,
IORING_OP_WRITE, IORING_OP_RECV, and IORING_OP_SEND supports it. This
is checked on SQE submission, a CQE with res == -EINVAL will be posted
if attempted on unsupported requests.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 203 +++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |  14 +++
 2 files changed, 192 insertions(+), 25 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c4dcb7565a20..ae6be007d426 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -400,7 +400,9 @@ struct io_sr_msg {
 		void __user		*buf;
 	};
 	int				msg_flags;
+	int				gid;
 	size_t				len;
+	void __user			*buf_select;
 };
 
 struct io_open {
@@ -495,6 +497,7 @@ enum {
 	REQ_F_LINK_BIT		= IOSQE_IO_LINK_BIT,
 	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
+	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 
 	REQ_F_LINK_NEXT_BIT,
 	REQ_F_FAIL_LINK_BIT,
@@ -511,6 +514,7 @@ enum {
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_OVERFLOW_BIT,
 	REQ_F_POLLED_BIT,
+	REQ_F_BUFFER_SELECTED_BIT,
 };
 
 enum {
@@ -524,6 +528,8 @@ enum {
 	REQ_F_HARDLINK		= BIT(REQ_F_HARDLINK_BIT),
 	/* IOSQE_ASYNC */
 	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),
+	/* IOSQE_BUFFER_SELECT */
+	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
 
 	/* already grabbed next link */
 	REQ_F_LINK_NEXT		= BIT(REQ_F_LINK_NEXT_BIT),
@@ -555,6 +561,8 @@ enum {
 	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
 	/* already went through poll handler */
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
+	/* buffer already selected */
+	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 };
 
 struct async_poll {
@@ -617,6 +625,7 @@ struct io_kiocb {
 			struct callback_head	task_work;
 			struct hlist_node	hash_node;
 			struct async_poll	*apoll;
+			int			cflags;
 		};
 		struct io_wq_work	work;
 	};
@@ -666,6 +675,8 @@ struct io_op_def {
 	/* set if opcode supports polled "wait" */
 	unsigned		pollin : 1;
 	unsigned		pollout : 1;
+	/* op supports buffer selection */
+	unsigned		buffer_select : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -775,12 +786,14 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
+		.buffer_select		= 1,
 	},
 	[IORING_OP_WRITE] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.buffer_select		= 1,
 	},
 	[IORING_OP_FADVISE] = {
 		.needs_file		= 1,
@@ -793,12 +806,14 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
+		.buffer_select		= 1,
 	},
 	[IORING_OP_RECV] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
+		.buffer_select		= 1,
 	},
 	[IORING_OP_OPENAT2] = {
 		.needs_file		= 1,
@@ -1186,7 +1201,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		if (cqe) {
 			WRITE_ONCE(cqe->user_data, req->user_data);
 			WRITE_ONCE(cqe->res, req->result);
-			WRITE_ONCE(cqe->flags, 0);
+			WRITE_ONCE(cqe->flags, req->flags);
 		} else {
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
@@ -1210,7 +1225,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	return cqe != NULL;
 }
 
-static void io_cqring_fill_event(struct io_kiocb *req, long res)
+static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cqe *cqe;
@@ -1226,7 +1241,7 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 	if (likely(cqe)) {
 		WRITE_ONCE(cqe->user_data, req->user_data);
 		WRITE_ONCE(cqe->res, res);
-		WRITE_ONCE(cqe->flags, 0);
+		WRITE_ONCE(cqe->flags, cflags);
 	} else if (ctx->cq_overflow_flushed) {
 		WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
@@ -1238,23 +1253,34 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 		req->flags |= REQ_F_OVERFLOW;
 		refcount_inc(&req->refs);
 		req->result = res;
+		req->cflags = cflags;
 		list_add_tail(&req->list, &ctx->cq_overflow_list);
 	}
 }
 
-static void io_cqring_add_event(struct io_kiocb *req, long res)
+static void io_cqring_fill_event(struct io_kiocb *req, long res)
+{
+	__io_cqring_fill_event(req, res, 0);
+}
+
+static void __io_cqring_add_event(struct io_kiocb *req, long res, long cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned long flags;
 
 	spin_lock_irqsave(&ctx->completion_lock, flags);
-	io_cqring_fill_event(req, res);
+	__io_cqring_fill_event(req, res, cflags);
 	io_commit_cqring(ctx);
 	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	io_cqring_ev_posted(ctx);
 }
 
+static void io_cqring_add_event(struct io_kiocb *req, long res)
+{
+	__io_cqring_add_event(req, res, 0);
+}
+
 static inline bool io_is_fallback_req(struct io_kiocb *req)
 {
 	return req == (struct io_kiocb *)
@@ -1635,6 +1661,17 @@ static inline bool io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
 	return true;
 }
 
+static int io_rw_common_cflags(struct io_kiocb *req)
+{
+	struct io_buffer *kbuf = (struct io_buffer *) req->rw.addr;
+	int cflags;
+
+	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
+	cflags |= IORING_CQE_F_BUFFER;
+	kfree(kbuf);
+	return cflags;
+}
+
 /*
  * Find and free completed poll iocbs
  */
@@ -1646,10 +1683,15 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
 	rb.to_free = rb.need_iter = 0;
 	while (!list_empty(done)) {
+		int cflags = 0;
+
 		req = list_first_entry(done, struct io_kiocb, list);
 		list_del(&req->list);
 
-		io_cqring_fill_event(req, req->result);
+		if (req->flags & REQ_F_BUFFER_SELECTED)
+			cflags = io_rw_common_cflags(req);
+
+		__io_cqring_fill_event(req, req->result, cflags);
 		(*nr_events)++;
 
 		if (refcount_dec_and_test(&req->refs) &&
@@ -1824,13 +1866,16 @@ static inline void req_set_fail_links(struct io_kiocb *req)
 static void io_complete_rw_common(struct kiocb *kiocb, long res)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
+	int cflags = 0;
 
 	if (kiocb->ki_flags & IOCB_WRITE)
 		kiocb_end_write(req);
 
 	if (res != req->result)
 		req_set_fail_links(req);
-	io_cqring_add_event(req, res);
+	if (req->flags & REQ_F_BUFFER_SELECTED)
+		cflags = io_rw_common_cflags(req);
+	__io_cqring_add_event(req, res, cflags);
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
@@ -2019,7 +2064,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
-	/* we own ->private, reuse it for the buffer index */
+	/* we own ->private, reuse it for the buffer index  / buffer ID */
 	req->rw.kiocb.private = (void *) (unsigned long)
 					READ_ONCE(sqe->buf_index);
 	return 0;
@@ -2132,8 +2177,43 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 	return len;
 }
 
+static struct io_buffer *io_buffer_select(struct io_kiocb *req, int gid,
+					  void __user *buf, bool needs_lock)
+{
+	struct list_head *list;
+	struct io_buffer *kbuf;
+
+	if (req->flags & REQ_F_BUFFER_SELECTED)
+		return (__force struct io_buffer *) buf;
+
+	/*
+	 * "Normal" inline submissions always hold the uring_lock, since we
+	 * grab it from the system call. Same is true for the SQPOLL offload.
+	 * The only exception is when we've detached the request and issue it
+	 * from an async worker thread, grab the lock for that case.
+	 */
+	if (needs_lock)
+		mutex_lock(&req->ctx->uring_lock);
+
+	lockdep_assert_held(&req->ctx->uring_lock);
+
+	list = idr_find(&req->ctx->io_buffer_idr, gid);
+	if (list && !list_empty(list)) {
+		kbuf = list_first_entry(list, struct io_buffer, list);
+		list_del(&kbuf->list);
+	} else {
+		kbuf = ERR_PTR(-ENOBUFS);
+	}
+
+	if (needs_lock)
+		mutex_unlock(&req->ctx->uring_lock);
+
+	return kbuf;
+}
+
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
-			       struct iovec **iovec, struct iov_iter *iter)
+			       struct iovec **iovec, struct iov_iter *iter,
+			       bool needs_lock)
 {
 	void __user *buf = u64_to_user_ptr(req->rw.addr);
 	size_t sqe_len = req->rw.len;
@@ -2145,12 +2225,30 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 		return io_import_fixed(req, rw, iter);
 	}
 
-	/* buffer index only valid with fixed read/write */
-	if (req->rw.kiocb.private)
+	/* buffer index only valid with fixed read/write, or buffer select  */
+	if (req->rw.kiocb.private && !(req->flags & REQ_F_BUFFER_SELECT))
 		return -EINVAL;
 
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
 		ssize_t ret;
+
+		if (req->flags & REQ_F_BUFFER_SELECT) {
+			struct io_buffer *kbuf;
+			int gid;
+
+			gid = (int) (unsigned long) req->rw.kiocb.private;
+			kbuf = io_buffer_select(req, gid, buf, needs_lock);
+			if (IS_ERR(kbuf)) {
+				*iovec = NULL;
+				return PTR_ERR(kbuf);
+			}
+			req->rw.addr = (u64) kbuf;
+			if (sqe_len > kbuf->len)
+				sqe_len = kbuf->len;
+			req->flags |= REQ_F_BUFFER_SELECTED;
+			buf = u64_to_user_ptr(kbuf->addr);
+		}
+
 		ret = import_single_range(rw, buf, sqe_len, *iovec, iter);
 		*iovec = NULL;
 		return ret;
@@ -2293,7 +2391,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	io = req->io;
 	io->rw.iov = io->rw.fast_iov;
 	req->io = NULL;
-	ret = io_import_iovec(READ, req, &io->rw.iov, &iter);
+	ret = io_import_iovec(READ, req, &io->rw.iov, &iter, !force_nonblock);
 	req->io = io;
 	if (ret < 0)
 		return ret;
@@ -2311,7 +2409,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 	size_t iov_count;
 	ssize_t io_size, ret;
 
-	ret = io_import_iovec(READ, req, &iovec, &iter);
+	ret = io_import_iovec(READ, req, &iovec, &iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
 
@@ -2383,7 +2481,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	io = req->io;
 	io->rw.iov = io->rw.fast_iov;
 	req->io = NULL;
-	ret = io_import_iovec(WRITE, req, &io->rw.iov, &iter);
+	ret = io_import_iovec(WRITE, req, &io->rw.iov, &iter, !force_nonblock);
 	req->io = io;
 	if (ret < 0)
 		return ret;
@@ -2401,7 +2499,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 	size_t iov_count;
 	ssize_t ret, io_size;
 
-	ret = io_import_iovec(WRITE, req, &iovec, &iter);
+	ret = io_import_iovec(WRITE, req, &iovec, &iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
 
@@ -3254,6 +3352,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
+	sr->gid = READ_ONCE(sqe->buf_group);
 
 	if (!io || req->opcode == IORING_OP_SEND)
 		return 0;
@@ -3344,12 +3443,38 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 #endif
 }
 
+static void __user *io_send_recv_buffer_select(struct io_kiocb *req,
+					       struct io_buffer **kbuf,
+					       int *cflags, bool needs_lock)
+{
+	struct io_sr_msg *sr = &req->sr_msg;
+	void __user *buf;
+
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
+		return req->sr_msg.buf;
+
+	buf = io_buffer_select(req, sr->gid, sr->buf_select, needs_lock);
+	if (IS_ERR(buf))
+		return (__force void __user *) buf;
+
+	*kbuf = buf;
+	sr->buf_select = u64_to_user_ptr((*kbuf)->addr);
+	if (sr->len > (*kbuf)->len)
+		sr->len = (*kbuf)->len;
+	req->flags |= REQ_F_BUFFER_SELECTED;
+
+	*cflags = (*kbuf)->bid << IORING_CQE_BUFFER_SHIFT;
+	*cflags |= IORING_CQE_F_BUFFER;
+	return sr->buf_select;
+}
+
 static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
 		   bool force_nonblock)
 {
 #if defined(CONFIG_NET)
+	struct io_buffer *kbuf = NULL;
 	struct socket *sock;
-	int ret;
+	int ret, cflags = 0;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -3359,12 +3484,20 @@ static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
 		struct io_sr_msg *sr = &req->sr_msg;
 		struct msghdr msg;
 		struct iovec iov;
+		void __user *buf;
 		unsigned flags;
 
-		ret = import_single_range(WRITE, sr->buf, sr->len, &iov,
+		buf = io_send_recv_buffer_select(req, &kbuf, &cflags,
+							!force_nonblock);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
+
+		ret = import_single_range(WRITE, buf, sr->len, &iov,
 						&msg.msg_iter);
-		if (ret)
+		if (ret) {
+			kfree(kbuf);
 			return ret;
+		}
 
 		msg.msg_name = NULL;
 		msg.msg_control = NULL;
@@ -3385,7 +3518,8 @@ static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
 			ret = -EINTR;
 	}
 
-	io_cqring_add_event(req, ret);
+	kfree(kbuf);
+	__io_cqring_add_event(req, ret, cflags);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
@@ -3406,6 +3540,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
+	sr->gid = READ_ONCE(sqe->buf_group);
 
 	if (!io || req->opcode == IORING_OP_RECV)
 		return 0;
@@ -3502,8 +3637,9 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 		   bool force_nonblock)
 {
 #if defined(CONFIG_NET)
+	struct io_buffer *kbuf = NULL;
 	struct socket *sock;
-	int ret;
+	int ret, cflags = 0;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -3513,12 +3649,20 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 		struct io_sr_msg *sr = &req->sr_msg;
 		struct msghdr msg;
 		struct iovec iov;
+		void __user *buf;
 		unsigned flags;
 
-		ret = import_single_range(READ, sr->buf, sr->len, &iov,
+		buf = io_send_recv_buffer_select(req, &kbuf, &cflags,
+							!force_nonblock);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
+
+		ret = import_single_range(READ, buf, sr->len, &iov,
 						&msg.msg_iter);
-		if (ret)
+		if (ret) {
+			kfree(kbuf);
 			return ret;
+		}
 
 		msg.msg_name = NULL;
 		msg.msg_control = NULL;
@@ -3540,7 +3684,8 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 			ret = -EINTR;
 	}
 
-	io_cqring_add_event(req, ret);
+	kfree(kbuf);
+	__io_cqring_add_event(req, ret, cflags);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
@@ -5176,7 +5321,8 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 }
 
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
-				IOSQE_IO_HARDLINK | IOSQE_ASYNC)
+				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
+				IOSQE_BUFFER_SELECT)
 
 static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			  struct io_submit_state *state, struct io_kiocb **link)
@@ -5193,6 +5339,12 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		goto err_req;
 	}
 
+	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
+	    !io_op_defs[req->opcode].buffer_select) {
+		ret = -EINVAL;
+		goto err_req;
+	}
+
 	id = READ_ONCE(sqe->personality);
 	if (id) {
 		req->work.creds = idr_find(&ctx->personality_idr, id);
@@ -5205,7 +5357,8 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags |= sqe_flags & (IOSQE_IO_DRAIN | IOSQE_IO_HARDLINK |
-					IOSQE_ASYNC | IOSQE_FIXED_FILE);
+					IOSQE_ASYNC | IOSQE_FIXED_FILE |
+					IOSQE_BUFFER_SELECT);
 
 	ret = io_req_set_file(state, req, sqe);
 	if (unlikely(ret)) {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1de1f683cc3c..36ecd1f8d5d3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -65,6 +65,7 @@ enum {
 	IOSQE_IO_LINK_BIT,
 	IOSQE_IO_HARDLINK_BIT,
 	IOSQE_ASYNC_BIT,
+	IOSQE_BUFFER_SELECT_BIT,
 };
 
 /*
@@ -80,6 +81,8 @@ enum {
 #define IOSQE_IO_HARDLINK	(1U << IOSQE_IO_HARDLINK_BIT)
 /* always go async */
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
+/* select buffer from sqe->buf_group */
+#define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 
 /*
  * io_uring_setup() flags
@@ -154,6 +157,17 @@ struct io_uring_cqe {
 	__u32	flags;
 };
 
+/*
+ * cqe->flags
+ *
+ * IORING_CQE_F_BUFFER	If set, the upper 16 bits are the buffer ID
+ */
+#define IORING_CQE_F_BUFFER		(1U << 0)
+
+enum {
+	IORING_CQE_BUFFER_SHIFT		= 16,
+};
+
 /*
  * Magic offsets for the application to mmap the data it needs
  */
-- 
2.25.1

