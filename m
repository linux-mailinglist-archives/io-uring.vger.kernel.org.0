Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7B9B1740F4
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 21:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726063AbgB1UbC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 15:31:02 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:33838 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725730AbgB1UbC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 15:31:02 -0500
Received: by mail-io1-f65.google.com with SMTP id z190so4934102iof.1
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2020 12:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/FGbzdYxKX+8a4H9vVOUivAsc4ll1jD4zat7G/Iqf8E=;
        b=KuPx6C6EWVBUlCuIZGJymxwgaiVMt49Yv27oYWUqZpcxrrecLlofUogqrIrIPI0M9S
         nvjZCwDG5LMTttRStqJhkMuG+E4CfLgj66pQwmP/lLKxauXdALs0CCh8B4oIobl6Esak
         pJ4QXlKI0IrDoc/WkkCYXXVK+ng3fuj846Uy0dHrxYmMTScwhU2bbSR6BDu7K+36e4gR
         P/9686ysO/WYt6Ibyw6NoHgbF9YKjdUrwwsIFz6Xz4ToKNQuKqY89RZ1K7MCUtklngfG
         Cu5iVwnAEp8t9Om+UqhF1yQHrsk5nhO5/YiMJgTIekyGSDVO6X5EeH1+yAWgLSBYAjuR
         Mb5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/FGbzdYxKX+8a4H9vVOUivAsc4ll1jD4zat7G/Iqf8E=;
        b=U48Be0xKeview7OmfnmcnzsREvtsObYIY7bBcvlTUIRmEUAg6J5lDpk9Ut0vUR1WHB
         EbvKEexhCvH0uwiEtZ2QLWSUfXwB/SBoQLyY0FJHgbD+gpJcB74lGCEMFx+VVTAFgoLR
         /sjIWqpwVC/DQKIdYsK3/DdGRu4k3qGjPNOkQqXk2Z1uQAJe0x1HzXSM7mx2yREEZHMb
         KBDAg8gt7btSGrVXJioaao4MLm5sxApxhkock54cVgfdeF0EXDtH58Wl4IY2mZaCR1p/
         gTjSOvL31WRZxFrO1ltUmexLhQDAMNxw/bH/aYRch1m9Lkzf6bCLD8CBaVVkyayTm/1/
         ZUhQ==
X-Gm-Message-State: APjAAAVVoPIyhTu8pEaf5Otkffi5pTIBu7f6NAgjxK3kTOTrRvOiK/K+
        ZCCGLivq+BPFGZmjlm9Szpcw8ez8/E4=
X-Google-Smtp-Source: APXvYqyAW1MhMQNMJb5lY8HGKyIDXAYqMDGVo+b8raJ1/7tcz8gr3cX/5E60mA4WnA7m9c4hbc1JhQ==
X-Received: by 2002:a05:6602:22d7:: with SMTP id e23mr442198ioe.41.1582921859281;
        Fri, 28 Feb 2020 12:30:59 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id t15sm3397611ili.50.2020.02.28.12.30.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 12:30:58 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/6] io_uring: support buffer selection
Date:   Fri, 28 Feb 2020 13:30:50 -0700
Message-Id: <20200228203053.25023-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200228203053.25023-1-axboe@kernel.dk>
References: <20200228203053.25023-1-axboe@kernel.dk>
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

Requests need to support this feature. For now, IORING_OP_READ and
IORING_OP_RECV support it. This is checked on SQE submission, a CQE with
res == -EINVAL will be posted if attempted on unsupported requests.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 190 ++++++++++++++++++++++++++++++----
 include/uapi/linux/io_uring.h |  14 +++
 2 files changed, 183 insertions(+), 21 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d6dc5faf3605..224a452a637f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -395,7 +395,9 @@ struct io_sr_msg {
 		void __user		*buf;
 	};
 	int				msg_flags;
+	int				gid;
 	size_t				len;
+	struct io_buffer		*kbuf;
 };
 
 struct io_open {
@@ -490,6 +492,7 @@ enum {
 	REQ_F_LINK_BIT		= IOSQE_IO_LINK_BIT,
 	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
+	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 
 	REQ_F_LINK_NEXT_BIT,
 	REQ_F_FAIL_LINK_BIT,
@@ -506,6 +509,7 @@ enum {
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_OVERFLOW_BIT,
 	REQ_F_POLLED_BIT,
+	REQ_F_BUFFER_SELECTED_BIT,
 };
 
 enum {
@@ -519,6 +523,8 @@ enum {
 	REQ_F_HARDLINK		= BIT(REQ_F_HARDLINK_BIT),
 	/* IOSQE_ASYNC */
 	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),
+	/* IOSQE_BUFFER_SELECT */
+	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
 
 	/* already grabbed next link */
 	REQ_F_LINK_NEXT		= BIT(REQ_F_LINK_NEXT_BIT),
@@ -550,6 +556,8 @@ enum {
 	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
 	/* already went through poll handler */
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
+	/* buffer already selected */
+	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 };
 
 struct async_poll {
@@ -612,6 +620,7 @@ struct io_kiocb {
 			struct callback_head	task_work;
 			struct hlist_node	hash_node;
 			struct async_poll	*apoll;
+			int			cflags;
 		};
 		struct io_wq_work	work;
 	};
@@ -661,6 +670,8 @@ struct io_op_def {
 	/* set if opcode supports polled "wait" */
 	unsigned		pollin : 1;
 	unsigned		pollout : 1;
+	/* op supports buffer selection */
+	unsigned		buffer_select : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -770,6 +781,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
+		.buffer_select		= 1,
 	},
 	[IORING_OP_WRITE] = {
 		.needs_mm		= 1,
@@ -794,6 +806,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
+		.buffer_select		= 1,
 	},
 	[IORING_OP_OPENAT2] = {
 		.needs_file		= 1,
@@ -1181,7 +1194,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		if (cqe) {
 			WRITE_ONCE(cqe->user_data, req->user_data);
 			WRITE_ONCE(cqe->res, req->result);
-			WRITE_ONCE(cqe->flags, 0);
+			WRITE_ONCE(cqe->flags, req->flags);
 		} else {
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
@@ -1205,7 +1218,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	return cqe != NULL;
 }
 
-static void io_cqring_fill_event(struct io_kiocb *req, long res)
+static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cqe *cqe;
@@ -1221,7 +1234,7 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 	if (likely(cqe)) {
 		WRITE_ONCE(cqe->user_data, req->user_data);
 		WRITE_ONCE(cqe->res, res);
-		WRITE_ONCE(cqe->flags, 0);
+		WRITE_ONCE(cqe->flags, cflags);
 	} else if (ctx->cq_overflow_flushed) {
 		WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
@@ -1233,23 +1246,34 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
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
@@ -1630,6 +1654,18 @@ static inline bool io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
 	return true;
 }
 
+static int io_rw_common_cflags(struct io_kiocb *req)
+{
+	struct io_buffer *kbuf = (struct io_buffer *) req->rw.addr;
+	int cflags;
+
+	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
+	cflags |= IORING_CQE_F_BUFFER;
+	req->rw.addr = 0;
+	kfree(kbuf);
+	return cflags;
+}
+
 /*
  * Find and free completed poll iocbs
  */
@@ -1641,10 +1677,15 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
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
@@ -1819,13 +1860,16 @@ static inline void req_set_fail_links(struct io_kiocb *req)
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
@@ -2014,7 +2058,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
-	/* we own ->private, reuse it for the buffer index */
+	/* we own ->private, reuse it for the buffer index  / buffer ID */
 	req->rw.kiocb.private = (void *) (unsigned long)
 					READ_ONCE(sqe->buf_index);
 	return 0;
@@ -2127,8 +2171,43 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 	return len;
 }
 
+static struct io_buffer *io_buffer_select(struct io_kiocb *req, int gid,
+					  struct io_buffer *kbuf,
+					  bool needs_lock)
+{
+	struct list_head *list;
+
+	if (req->flags & REQ_F_BUFFER_SELECTED)
+		return kbuf;
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
@@ -2140,12 +2219,30 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
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
+			struct io_buffer *kbuf = (struct io_buffer *) req->rw.addr;
+			int gid;
+
+			gid = (int) (unsigned long) req->rw.kiocb.private;
+			kbuf = io_buffer_select(req, gid, kbuf, needs_lock);
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
 		return ret < 0 ? ret : sqe_len;
@@ -2288,7 +2385,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	io = req->io;
 	io->rw.iov = io->rw.fast_iov;
 	req->io = NULL;
-	ret = io_import_iovec(READ, req, &io->rw.iov, &iter);
+	ret = io_import_iovec(READ, req, &io->rw.iov, &iter, !force_nonblock);
 	req->io = io;
 	if (ret < 0)
 		return ret;
@@ -2306,7 +2403,7 @@ static int io_read(struct io_kiocb *req, struct io_kiocb **nxt,
 	size_t iov_count;
 	ssize_t io_size, ret;
 
-	ret = io_import_iovec(READ, req, &iovec, &iter);
+	ret = io_import_iovec(READ, req, &iovec, &iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
 
@@ -2378,7 +2475,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	io = req->io;
 	io->rw.iov = io->rw.fast_iov;
 	req->io = NULL;
-	ret = io_import_iovec(WRITE, req, &io->rw.iov, &iter);
+	ret = io_import_iovec(WRITE, req, &io->rw.iov, &iter, !force_nonblock);
 	req->io = io;
 	if (ret < 0)
 		return ret;
@@ -2396,7 +2493,7 @@ static int io_write(struct io_kiocb *req, struct io_kiocb **nxt,
 	size_t iov_count;
 	ssize_t ret, io_size;
 
-	ret = io_import_iovec(WRITE, req, &iovec, &iter);
+	ret = io_import_iovec(WRITE, req, &iovec, &iter, !force_nonblock);
 	if (ret < 0)
 		return ret;
 
@@ -3403,6 +3500,29 @@ static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
 #endif
 }
 
+static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
+					       int *cflags, bool needs_lock)
+{
+	struct io_sr_msg *sr = &req->sr_msg;
+	struct io_buffer *kbuf;
+
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
+		return NULL;
+
+	kbuf = io_buffer_select(req, sr->gid, sr->kbuf, needs_lock);
+	if (IS_ERR(kbuf))
+		return kbuf;
+
+	sr->kbuf = kbuf;
+	if (sr->len > kbuf->len)
+		sr->len = kbuf->len;
+	req->flags |= REQ_F_BUFFER_SELECTED;
+
+	*cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
+	*cflags |= IORING_CQE_F_BUFFER;
+	return kbuf;
+}
+
 static int io_recvmsg_prep(struct io_kiocb *req,
 			   const struct io_uring_sqe *sqe)
 {
@@ -3414,6 +3534,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
+	sr->gid = READ_ONCE(sqe->buf_group);
 
 #ifdef CONFIG_COMPAT
 	if (req->ctx->compat)
@@ -3505,8 +3626,9 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 		   bool force_nonblock)
 {
 #if defined(CONFIG_NET)
+	struct io_buffer *kbuf = NULL;
 	struct socket *sock;
-	int ret;
+	int ret, cflags = 0;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -3514,15 +3636,25 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 	sock = sock_from_file(req->file, &ret);
 	if (sock) {
 		struct io_sr_msg *sr = &req->sr_msg;
+		void __user *buf = sr->buf;
 		struct msghdr msg;
 		struct iovec iov;
 		unsigned flags;
 
-		ret = import_single_range(READ, sr->buf, sr->len, &iov,
+		kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
+		if (IS_ERR(kbuf))
+			return PTR_ERR(kbuf);
+		else if (kbuf)
+			buf = u64_to_user_ptr(kbuf->addr);
+
+		ret = import_single_range(READ, buf, sr->len, &iov,
 						&msg.msg_iter);
-		if (ret)
+		if (ret) {
+			kfree(kbuf);
 			return ret;
+		}
 
+		req->flags |= REQ_F_NEED_CLEANUP;
 		msg.msg_name = NULL;
 		msg.msg_control = NULL;
 		msg.msg_controllen = 0;
@@ -3543,7 +3675,9 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 			ret = -EINTR;
 	}
 
-	io_cqring_add_event(req, ret);
+	kfree(kbuf);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	__io_cqring_add_event(req, ret, cflags);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
@@ -4585,6 +4719,8 @@ static void io_cleanup_req(struct io_kiocb *req)
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
+		if (req->flags & REQ_F_BUFFER_SELECTED)
+			kfree((void *)req->rw.addr);
 		if (io->rw.iov != io->rw.fast_iov)
 			kfree(io->rw.iov);
 		break;
@@ -4593,6 +4729,10 @@ static void io_cleanup_req(struct io_kiocb *req)
 		if (io->msg.iov != io->msg.fast_iov)
 			kfree(io->msg.iov);
 		break;
+	case IORING_OP_RECV:
+		if (req->flags & REQ_F_BUFFER_SELECTED)
+			kfree(req->sr_msg.kbuf);
+		break;
 	case IORING_OP_OPENAT:
 	case IORING_OP_OPENAT2:
 	case IORING_OP_STATX:
@@ -5177,7 +5317,8 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 }
 
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
-				IOSQE_IO_HARDLINK | IOSQE_ASYNC)
+				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
+				IOSQE_BUFFER_SELECT)
 
 static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			  struct io_submit_state *state, struct io_kiocb **link)
@@ -5194,6 +5335,12 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -5206,7 +5353,8 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
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

