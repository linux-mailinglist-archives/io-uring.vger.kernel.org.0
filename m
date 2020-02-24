Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E44AA169C74
	for <lists+io-uring@lfdr.de>; Mon, 24 Feb 2020 03:56:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgBXC4R (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 23 Feb 2020 21:56:17 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32846 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgBXC4R (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 23 Feb 2020 21:56:17 -0500
Received: by mail-pg1-f194.google.com with SMTP id 6so4372936pgk.0
        for <io-uring@vger.kernel.org>; Sun, 23 Feb 2020 18:56:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uypaeJUpFEcgBe9n7mFvotcVLr/QjOfeHYPfqrr8NNg=;
        b=0slPQ8ua5w/gYiliYri2rDDGjoYxO7qHtmJObR+Js+395Sel88JkaDzVVWKr/pO2Ka
         CRRnXfuWwaA8V22ed1nqb6mlEKccqWMYqBFHBlaxfsKhnece0+drOAIhwr6xLP7byt0i
         HY5Gklm8IcT7MPuv+LInAU8fJqhevCge3us3HWFNQL3KgbnTm4yqZ4Zcx1z+TH8cix1q
         vcAZMFR9w/z4Z72w0pLb62Ypo/fYCPTWUbOFxEH8azWHAaLgwB4odpqXzD4pfTtWtbU7
         8asUXUPdpSs7GzIxpJwhw+EcT6FrSjrq87KkrrXRjGatDJiFQLp35mz9bYDlecQiXbbG
         L6WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uypaeJUpFEcgBe9n7mFvotcVLr/QjOfeHYPfqrr8NNg=;
        b=Jf2Lf7kfsBmBiRY9+N7izeJD92VkSs8Ewf/2Sy4nMNyqglgtsQuWRM8PRGTIB86Zc2
         OFCnZ9cppVYfA1eL5AYDhmJDjZrFTecFrWIBszrqVl621qvBncVOBQP7kBbo+47bUfIQ
         mTVZU1i230+5h/rN55A1KhSlgHjpuW4hwNUP1kOCDFzX2+k9MJOguP/+LcC48dHKkzoH
         fiTzwKLqPeabUWwaA46az+wADfEfZno2QoLqJG1v4Dh2KXnV4Zx7QwkDQcbDjq6NKCaf
         NBRl9fj6WlF47JuGlRlA8jRoNyiLC71uYuoIqySPKFqY88eP6Kl7C8OWd2K7SsE1lg2U
         ZlEg==
X-Gm-Message-State: APjAAAU7QNJJgb6Z2nxYvhYJbva/b8zkOK/7YJxYsRAZEEie4p7L/0Yf
        QyoJyJs+NuQAUA9+UEeBFQ8uZriVvB8=
X-Google-Smtp-Source: APXvYqx72N2b5Sk+fx6fjwVnw1SXjvmlinK5KRzUSw8t2CfX8pH1mJNBMEjpSJ3HaU4LSYQzQWpelA==
X-Received: by 2002:a63:7216:: with SMTP id n22mr19413918pgc.103.1582512975911;
        Sun, 23 Feb 2020 18:56:15 -0800 (PST)
Received: from x1.localdomain ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id z5sm10859169pfq.3.2020.02.23.18.56.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Feb 2020 18:56:15 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     andres@anarazel.de, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring: support buffer selection
Date:   Sun, 23 Feb 2020 19:56:07 -0700
Message-Id: <20200224025607.22244-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200224025607.22244-1-axboe@kernel.dk>
References: <20200224025607.22244-1-axboe@kernel.dk>
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

With IORING_OP_PROVIDE_BUFFER, an application can register buffers to
use for any request. The request then sets IOSQE_BUFFER_SELECT in the
sqe, and a given group ID in sqe->buf_group. When the fd becomes ready,
a free buffer from the specified group is selected. If none are
available, the request is terminated with -ENOBUFS. If successful, the
CQE on completion will contain the buffer ID chosen in the cqe->flags
member, encoded as:

	(buffer_id << IORING_CQE_BUFFER_SHIFT) | IORING_CQE_F_BUFFER;

Once a buffer has been consumed by a request, it is no longer available
and must be registered again with IORING_OP_PROVIDE_BUFFER.

Requests need to support this feature. For now, IORING_OP_READ,
IORING_OP_WRITE, IORING_OP_RECV, and IORING_OP_SEND supports it. This
is checked on SQE submission, a CQE with res == -EINVAL will be posted
if attempted on unsupported requests.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 169 ++++++++++++++++++++++++++++++----
 include/uapi/linux/io_uring.h |  22 ++++-
 2 files changed, 171 insertions(+), 20 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8b7c5ab69658..1b96b88485d8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -399,7 +399,9 @@ struct io_sr_msg {
 		void __user		*buf;
 	};
 	int				msg_flags;
+	int				gid;
 	size_t				len;
+	struct io_buffer		*kbuf;
 };
 
 struct io_open {
@@ -484,6 +486,7 @@ enum {
 	REQ_F_LINK_BIT		= IOSQE_IO_LINK_BIT,
 	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
+	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 
 	REQ_F_LINK_NEXT_BIT,
 	REQ_F_FAIL_LINK_BIT,
@@ -500,6 +503,7 @@ enum {
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_OVERFLOW_BIT,
 	REQ_F_POLLED_BIT,
+	REQ_F_BUFFER_SELECTED_BIT,
 };
 
 enum {
@@ -513,6 +517,8 @@ enum {
 	REQ_F_HARDLINK		= BIT(REQ_F_HARDLINK_BIT),
 	/* IOSQE_ASYNC */
 	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),
+	/* IOSQE_BUFFER_SELECT */
+	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
 
 	/* already grabbed next link */
 	REQ_F_LINK_NEXT		= BIT(REQ_F_LINK_NEXT_BIT),
@@ -544,6 +550,8 @@ enum {
 	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
 	/* already went through poll handler */
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
+	/* buffer already selected */
+	REQ_F_BUFFER_SELECTED	= BIT(REQ_F_BUFFER_SELECTED_BIT),
 };
 
 struct async_poll {
@@ -606,6 +614,7 @@ struct io_kiocb {
 			struct callback_head	task_work;
 			struct hlist_node	hash_node;
 			struct async_poll	*apoll;
+			int			cflags;
 		};
 		struct io_wq_work	work;
 	};
@@ -655,6 +664,8 @@ struct io_op_def {
 	/* set if opcode supports polled "wait" */
 	unsigned		pollin : 1;
 	unsigned		pollout : 1;
+	/* op supports buffer selection */
+	unsigned		buffer_select : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -764,12 +775,14 @@ static const struct io_op_def io_op_defs[] = {
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
@@ -782,12 +795,14 @@ static const struct io_op_def io_op_defs[] = {
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
@@ -1157,7 +1172,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 		if (cqe) {
 			WRITE_ONCE(cqe->user_data, req->user_data);
 			WRITE_ONCE(cqe->res, req->result);
-			WRITE_ONCE(cqe->flags, 0);
+			WRITE_ONCE(cqe->flags, req->flags);
 		} else {
 			WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
@@ -1181,7 +1196,7 @@ static bool io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 	return cqe != NULL;
 }
 
-static void io_cqring_fill_event(struct io_kiocb *req, long res)
+static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cqe *cqe;
@@ -1197,7 +1212,7 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
 	if (likely(cqe)) {
 		WRITE_ONCE(cqe->user_data, req->user_data);
 		WRITE_ONCE(cqe->res, res);
-		WRITE_ONCE(cqe->flags, 0);
+		WRITE_ONCE(cqe->flags, cflags);
 	} else if (ctx->cq_overflow_flushed) {
 		WRITE_ONCE(ctx->rings->cq_overflow,
 				atomic_inc_return(&ctx->cached_cq_overflow));
@@ -1209,23 +1224,34 @@ static void io_cqring_fill_event(struct io_kiocb *req, long res)
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
@@ -1603,6 +1629,17 @@ static inline bool io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
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
@@ -1614,10 +1651,15 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 
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
@@ -1792,13 +1834,16 @@ static inline void req_set_fail_links(struct io_kiocb *req)
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
@@ -1983,7 +2028,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
-	/* we own ->private, reuse it for the buffer index */
+	/* we own ->private, reuse it for the buffer index  / buffer ID */
 	req->rw.kiocb.private = (void *) (unsigned long)
 					READ_ONCE(sqe->buf_index);
 	return 0;
@@ -2097,6 +2142,24 @@ static ssize_t io_import_fixed(struct io_kiocb *req, int rw,
 	return len;
 }
 
+static struct io_buffer *io_buffer_select(struct io_kiocb *req, int gid,
+					  void *buf)
+{
+	struct list_head *list;
+	struct io_buffer *kbuf;
+
+	if (req->flags & REQ_F_BUFFER_SELECTED)
+		return buf;
+
+	list = idr_find(&req->ctx->io_buffer_idr, gid);
+	if (!list || list_empty(list))
+		return ERR_PTR(-ENOBUFS);
+
+	kbuf = list_first_entry(list, struct io_buffer, list);
+	list_del(&kbuf->list);
+	return kbuf;
+}
+
 static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 			       struct iovec **iovec, struct iov_iter *iter)
 {
@@ -2110,12 +2173,30 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
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
+			kbuf = io_buffer_select(req, gid, buf);
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
@@ -3112,6 +3193,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
+	sr->gid = READ_ONCE(sqe->buf_group);
 
 	if (!io || req->opcode == IORING_OP_SEND)
 		return 0;
@@ -3202,12 +3284,36 @@ static int io_sendmsg(struct io_kiocb *req, struct io_kiocb **nxt,
 #endif
 }
 
+static struct io_buffer *io_send_recv_buffer_select(struct io_kiocb *req,
+						    struct io_buffer **kbuf,
+						    int *cflags)
+{
+	struct io_sr_msg *sr = &req->sr_msg;
+
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
+		return req->sr_msg.buf;
+
+	*kbuf = io_buffer_select(req, sr->gid, sr->kbuf);
+	if (IS_ERR(*kbuf))
+		return *kbuf;
+
+	sr->kbuf = *kbuf;
+	if (sr->len > (*kbuf)->len)
+		sr->len = (*kbuf)->len;
+	req->flags |= REQ_F_BUFFER_SELECTED;
+
+	*cflags = (*kbuf)->bid << IORING_CQE_BUFFER_SHIFT;
+	*cflags |= IORING_CQE_F_BUFFER;
+	return u64_to_user_ptr((*kbuf)->addr);
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
@@ -3217,9 +3323,16 @@ static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
 		struct io_sr_msg *sr = &req->sr_msg;
 		struct msghdr msg;
 		struct iovec iov;
+		void __user *buf;
 		unsigned flags;
 
-		ret = import_single_range(WRITE, sr->buf, sr->len, &iov,
+		buf = io_send_recv_buffer_select(req, &kbuf, &cflags);
+		if (IS_ERR(buf)) {
+			ret = PTR_ERR(buf);
+			goto out;
+		}
+
+		ret = import_single_range(WRITE, buf, sr->len, &iov,
 						&msg.msg_iter);
 		if (ret)
 			return ret;
@@ -3243,7 +3356,9 @@ static int io_send(struct io_kiocb *req, struct io_kiocb **nxt,
 			ret = -EINTR;
 	}
 
-	io_cqring_add_event(req, ret);
+	kfree(kbuf);
+out:
+	__io_cqring_add_event(req, ret, cflags);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
@@ -3264,6 +3379,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	sr->msg_flags = READ_ONCE(sqe->msg_flags);
 	sr->msg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
+	sr->gid = READ_ONCE(sqe->buf_group);
 
 	if (!io || req->opcode == IORING_OP_RECV)
 		return 0;
@@ -3360,8 +3476,9 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 		   bool force_nonblock)
 {
 #if defined(CONFIG_NET)
+	struct io_buffer *kbuf = NULL;
 	struct socket *sock;
-	int ret;
+	int ret, cflags = 0;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
@@ -3371,9 +3488,16 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 		struct io_sr_msg *sr = &req->sr_msg;
 		struct msghdr msg;
 		struct iovec iov;
+		void __user *buf;
 		unsigned flags;
 
-		ret = import_single_range(READ, sr->buf, sr->len, &iov,
+		buf = io_send_recv_buffer_select(req, &kbuf, &cflags);
+		if (IS_ERR(buf)) {
+			ret = PTR_ERR(buf);
+			goto out;
+		}
+
+		ret = import_single_range(READ, buf, sr->len, &iov,
 						&msg.msg_iter);
 		if (ret)
 			return ret;
@@ -3398,7 +3522,9 @@ static int io_recv(struct io_kiocb *req, struct io_kiocb **nxt,
 			ret = -EINTR;
 	}
 
-	io_cqring_add_event(req, ret);
+	kfree(kbuf);
+out:
+	__io_cqring_add_event(req, ret, cflags);
 	if (ret < 0)
 		req_set_fail_links(req);
 	io_put_req_find_next(req, nxt);
@@ -5006,7 +5132,8 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 }
 
 #define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
-				IOSQE_IO_HARDLINK | IOSQE_ASYNC)
+				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
+				IOSQE_BUFFER_SELECT)
 
 static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			  struct io_submit_state *state, struct io_kiocb **link)
@@ -5023,6 +5150,12 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
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
@@ -5035,7 +5168,7 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 	/* same numerical values with corresponding REQ_F_*, safe to copy */
 	req->flags |= sqe_flags & (IOSQE_IO_DRAIN|IOSQE_IO_HARDLINK|
-					IOSQE_ASYNC);
+					IOSQE_ASYNC|IOSQE_BUFFER_SELECT);
 
 	ret = io_req_set_file(state, req, sqe);
 	if (unlikely(ret)) {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 21915ada9507..d46fd80af913 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -41,8 +41,12 @@ struct io_uring_sqe {
 	__u64	user_data;	/* data to be passed back at completion time */
 	union {
 		struct {
-			/* index into fixed buffers, if used */
-			__u16	buf_index;
+			union {
+				/* index into fixed buffers, if used */
+				__u16	buf_index;
+				/* for grouped buffer selection */
+				__u16	buf_group;
+			};
 			/* personality to use, if used */
 			__u16	personality;
 		};
@@ -56,6 +60,7 @@ enum {
 	IOSQE_IO_LINK_BIT,
 	IOSQE_IO_HARDLINK_BIT,
 	IOSQE_ASYNC_BIT,
+	IOSQE_BUFFER_SELECT_BIT,
 };
 
 /*
@@ -71,6 +76,8 @@ enum {
 #define IOSQE_IO_HARDLINK	(1U << IOSQE_IO_HARDLINK_BIT)
 /* always go async */
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
+/* select buffer from sqe->buf_group */
+#define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 
 /*
  * io_uring_setup() flags
@@ -138,6 +145,17 @@ struct io_uring_cqe {
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

