Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADF2315AE8
	for <lists+io-uring@lfdr.de>; Wed, 10 Feb 2021 01:21:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234072AbhBJASn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 19:18:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235045AbhBJAIb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 19:08:31 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52BAFC061788
        for <io-uring@vger.kernel.org>; Tue,  9 Feb 2021 16:07:19 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id u14so323138wmq.4
        for <io-uring@vger.kernel.org>; Tue, 09 Feb 2021 16:07:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9Pwq6Pqe2wDZCsQKp5SHXrI8Ts5Tnzf/+jrzWXhHC84=;
        b=r5vtLsR6Ds76ohbfPbnJ8TtzNkewcSPMISXF/1BDvultxhL9XBeSG+jMwjAuafSvSD
         txmcG8CcUp1KXXzGvXaJM+Sf+tnrobxebCRoKHAcNTmocOTR5HAy8cJzYIZk90s4qyb+
         LlPNt7V0yW9ukMM04PmuZEgS3Ye+tzfV5yVYPB/8b16kOy1PJvrgvVfERlVybDvjYmSt
         I7Z3zXt2Q/0orVlTjr0kdBiUTb63ziJZvJA7DIACLbJ1wJDq+3JqqugS8dlhtKXp8z8w
         B+tnMqqWmHOJrR00DflGm6Ol0acCmelqymTMsf7H1pkHptNj9eqbwWHBr9v1n3DrxnFg
         d3vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Pwq6Pqe2wDZCsQKp5SHXrI8Ts5Tnzf/+jrzWXhHC84=;
        b=ORzz6BSigVDcPxFljq/XC/PSLROLRdnnHHQrj0k9uY3ZcidNtCoQ786e/e95RZquAD
         8V2+wtbZcEwCF0tVcBYZYXieRqvR7Z8pzCZ41HShXQDW1MUtxKT1BqG8rvEP+hr7iUV8
         5SaPYFVV8ninrt7XrvicxfLYG7/cfm4oireBzGlM1aIn+XROsl+5x3Vfmo/V8tZtCHEj
         FYMAI+0tJjMPFnt9+dNAvHB6+QDIR5sVgV6GkuT6rCCk10i3JfYlwIgQMZO/XN02hrS+
         0w1jGN8eFTt2Sqg74focTaWJkWMX6AsJcFXtXFqmh1NYsi9T98kOyFhDZnObPO1BSDAb
         20Sw==
X-Gm-Message-State: AOAM533Y/zebt/LTNNc+N5f39SS45ypIlHoqoIdJKSRQKhq99rgG7k0z
        CwLphvZgwG07Sm2baqPPvoY=
X-Google-Smtp-Source: ABdhPJyB48UjY4Z9qqkQZF+4W3zMjpF84C7HoBHusVRJF2IpiMpi20siCTEp7duFyS1/aFeJrFibEQ==
X-Received: by 2002:a7b:c4ce:: with SMTP id g14mr458701wmk.73.1612915637980;
        Tue, 09 Feb 2021 16:07:17 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.126])
        by smtp.gmail.com with ESMTPSA id n15sm391082wrx.2.2021.02.09.16.07.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Feb 2021 16:07:17 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/17] io_uring: don't propagate io_comp_state
Date:   Wed, 10 Feb 2021 00:03:09 +0000
Message-Id: <275f9bbb7d9a74b1912a51acb1f90c1f1a47594e.1612915326.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1612915326.git.asml.silence@gmail.com>
References: <cover.1612915326.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is no reason to drag io_comp_state into opcode handlers, we just
need a flag and the actual work will be done in __io_queue_sqe().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 146 +++++++++++++++++++++++---------------------------
 1 file changed, 67 insertions(+), 79 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ac233d04ee71..5b95a3f2b978 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -189,6 +189,7 @@ struct io_rings {
 
 enum io_uring_cmd_flags {
 	IO_URING_F_NONBLOCK		= 1,
+	IO_URING_F_COMPLETE_DEFER	= 2,
 };
 
 struct io_mapped_ubuf {
@@ -1018,7 +1019,7 @@ static void init_fixed_file_ref_node(struct io_ring_ctx *ctx,
 				     struct fixed_rsrc_ref_node *ref_node);
 
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
-			     struct io_comp_state *cs);
+			     unsigned int issue_flags);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req, int nr);
@@ -1957,7 +1958,7 @@ static void io_submit_flush_completions(struct io_comp_state *cs)
 }
 
 static void io_req_complete_state(struct io_kiocb *req, long res,
-				  unsigned int cflags, struct io_comp_state *cs)
+				  unsigned int cflags)
 {
 	io_clean_op(req);
 	req->result = res;
@@ -1965,18 +1966,18 @@ static void io_req_complete_state(struct io_kiocb *req, long res,
 	req->flags |= REQ_F_COMPLETE_INLINE;
 }
 
-static inline void __io_req_complete(struct io_kiocb *req, long res,
-				     unsigned cflags, struct io_comp_state *cs)
+static inline void __io_req_complete(struct io_kiocb *req, unsigned issue_flags,
+				     long res, unsigned cflags)
 {
-	if (!cs)
-		io_req_complete_nostate(req, res, cflags);
+	if (issue_flags & IO_URING_F_COMPLETE_DEFER)
+		io_req_complete_state(req, res, cflags);
 	else
-		io_req_complete_state(req, res, cflags, cs);
+		io_req_complete_nostate(req, res, cflags);
 }
 
 static inline void io_req_complete(struct io_kiocb *req, long res)
 {
-	__io_req_complete(req, res, 0, NULL);
+	__io_req_complete(req, 0, res, 0);
 }
 
 static inline bool io_is_fallback_req(struct io_kiocb *req)
@@ -2449,7 +2450,7 @@ static void io_iopoll_queue(struct list_head *again)
 	do {
 		req = list_first_entry(again, struct io_kiocb, inflight_entry);
 		list_del(&req->inflight_entry);
-		__io_complete_rw(req, -EAGAIN, 0, NULL);
+		__io_complete_rw(req, -EAGAIN, 0, 0);
 	} while (!list_empty(again));
 }
 
@@ -2662,7 +2663,7 @@ static void kiocb_end_write(struct io_kiocb *req)
 }
 
 static void io_complete_rw_common(struct kiocb *kiocb, long res,
-				  struct io_comp_state *cs)
+				  unsigned int issue_flags)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 	int cflags = 0;
@@ -2674,7 +2675,7 @@ static void io_complete_rw_common(struct kiocb *kiocb, long res,
 		req_set_fail_links(req);
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_rw_kbuf(req);
-	__io_req_complete(req, res, cflags, cs);
+	__io_req_complete(req, issue_flags, res, cflags);
 }
 
 #ifdef CONFIG_BLOCK
@@ -2741,17 +2742,17 @@ static bool io_rw_reissue(struct io_kiocb *req, long res)
 }
 
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
-			     struct io_comp_state *cs)
+			     unsigned int issue_flags)
 {
 	if (!io_rw_reissue(req, res))
-		io_complete_rw_common(&req->rw.kiocb, res, cs);
+		io_complete_rw_common(&req->rw.kiocb, res, issue_flags);
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 
-	__io_complete_rw(req, res, res2, NULL);
+	__io_complete_rw(req, res, res2, 0);
 }
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
@@ -2970,7 +2971,7 @@ static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 }
 
 static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
-		       struct io_comp_state *cs)
+		       unsigned int issue_flags)
 {
 	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
 	struct io_async_rw *io = req->async_data;
@@ -2986,7 +2987,7 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	if (req->flags & REQ_F_CUR_POS)
 		req->file->f_pos = kiocb->ki_pos;
 	if (ret >= 0 && kiocb->ki_complete == io_complete_rw)
-		__io_complete_rw(req, ret, 0, cs);
+		__io_complete_rw(req, ret, 0, issue_flags);
 	else
 		io_rw_done(kiocb, ret);
 }
@@ -3481,8 +3482,7 @@ static int io_iter_do_read(struct io_kiocb *req, struct iov_iter *iter)
 		return -EINVAL;
 }
 
-static int io_read(struct io_kiocb *req, unsigned int issue_flags,
-		   struct io_comp_state *cs)
+static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -3572,7 +3572,7 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags,
 		/* we got some bytes, but not all. retry. */
 	} while (ret > 0 && ret < io_size);
 done:
-	kiocb_done(kiocb, ret, cs);
+	kiocb_done(kiocb, ret, issue_flags);
 	return 0;
 }
 
@@ -3593,8 +3593,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return io_rw_prep_async(req, WRITE);
 }
 
-static int io_write(struct io_kiocb *req, unsigned int issue_flags,
-		    struct io_comp_state *cs)
+static int io_write(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct iovec inline_vecs[UIO_FASTIOV], *iovec = inline_vecs;
 	struct kiocb *kiocb = &req->rw.kiocb;
@@ -3668,7 +3667,7 @@ static int io_write(struct io_kiocb *req, unsigned int issue_flags,
 		if ((req->ctx->flags & IORING_SETUP_IOPOLL) && ret2 == -EAGAIN)
 			goto copy_iov;
 done:
-		kiocb_done(kiocb, ret2, cs);
+		kiocb_done(kiocb, ret2, issue_flags);
 	} else {
 copy_iov:
 		/* some cases will consume bytes even on error returns */
@@ -3917,15 +3916,14 @@ static int io_splice(struct io_kiocb *req, unsigned int issue_flags)
 /*
  * IORING_OP_NOP just posts a completion event, nothing else.
  */
-static int io_nop(struct io_kiocb *req, unsigned int issue_flags,
-		  struct io_comp_state *cs)
+static int io_nop(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
 	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 
-	__io_req_complete(req, 0, 0, cs);
+	__io_req_complete(req, issue_flags, 0, 0);
 	return 0;
 }
 
@@ -4166,8 +4164,7 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx, struct io_buffer *buf,
 	return i;
 }
 
-static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags,
-			     struct io_comp_state *cs)
+static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_provide_buf *p = &req->pbuf;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -4188,11 +4185,11 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags,
 
 	/* need to hold the lock to complete IOPOLL requests */
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		__io_req_complete(req, ret, 0, cs);
+		__io_req_complete(req, issue_flags, ret, 0);
 		io_ring_submit_unlock(ctx, !force_nonblock);
 	} else {
 		io_ring_submit_unlock(ctx, !force_nonblock);
-		__io_req_complete(req, ret, 0, cs);
+		__io_req_complete(req, issue_flags, ret, 0);
 	}
 	return 0;
 }
@@ -4251,8 +4248,7 @@ static int io_add_buffers(struct io_provide_buf *pbuf, struct io_buffer **head)
 	return i ? i : -ENOMEM;
 }
 
-static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags,
-			      struct io_comp_state *cs)
+static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_provide_buf *p = &req->pbuf;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -4284,11 +4280,11 @@ static int io_provide_buffers(struct io_kiocb *req, unsigned int issue_flags,
 
 	/* need to hold the lock to complete IOPOLL requests */
 	if (ctx->flags & IORING_SETUP_IOPOLL) {
-		__io_req_complete(req, ret, 0, cs);
+		__io_req_complete(req, issue_flags, ret, 0);
 		io_ring_submit_unlock(ctx, !force_nonblock);
 	} else {
 		io_ring_submit_unlock(ctx, !force_nonblock);
-		__io_req_complete(req, ret, 0, cs);
+		__io_req_complete(req, issue_flags, ret, 0);
 	}
 	return 0;
 }
@@ -4320,8 +4316,7 @@ static int io_epoll_ctl_prep(struct io_kiocb *req,
 #endif
 }
 
-static int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags,
-			struct io_comp_state *cs)
+static int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags)
 {
 #if defined(CONFIG_EPOLL)
 	struct io_epoll *ie = &req->epoll;
@@ -4334,7 +4329,7 @@ static int io_epoll_ctl(struct io_kiocb *req, unsigned int issue_flags,
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, 0, cs);
+	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 #else
 	return -EOPNOTSUPP;
@@ -4466,8 +4461,7 @@ static int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_close(struct io_kiocb *req, unsigned int issue_flags,
-		    struct io_comp_state *cs)
+static int io_close(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct files_struct *files = current->files;
 	struct io_close *close = &req->close;
@@ -4516,7 +4510,7 @@ static int io_close(struct io_kiocb *req, unsigned int issue_flags,
 		req_set_fail_links(req);
 	if (file)
 		fput(file);
-	__io_req_complete(req, ret, 0, cs);
+	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
 
@@ -4612,8 +4606,7 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return ret;
 }
 
-static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags,
-		      struct io_comp_state *cs)
+static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
@@ -4650,12 +4643,11 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags,
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, 0, cs);
+	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
 
-static int io_send(struct io_kiocb *req, unsigned int issue_flags,
-		   struct io_comp_state *cs)
+static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct msghdr msg;
@@ -4692,7 +4684,7 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags,
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, 0, cs);
+	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
 
@@ -4833,8 +4825,7 @@ static int io_recvmsg_prep(struct io_kiocb *req,
 	return ret;
 }
 
-static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags,
-		      struct io_comp_state *cs)
+static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
@@ -4886,12 +4877,11 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags,
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, cflags, cs);
+	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
 }
 
-static int io_recv(struct io_kiocb *req, unsigned int issue_flags,
-		   struct io_comp_state *cs)
+static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_buffer *kbuf;
 	struct io_sr_msg *sr = &req->sr_msg;
@@ -4941,7 +4931,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags,
 		cflags = io_put_recv_kbuf(req);
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, cflags, cs);
+	__io_req_complete(req, issue_flags, ret, cflags);
 	return 0;
 }
 
@@ -4961,8 +4951,7 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static int io_accept(struct io_kiocb *req, unsigned int issue_flags,
-		     struct io_comp_state *cs)
+static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_accept *accept = &req->accept;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
@@ -4982,7 +4971,7 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags,
 			ret = -EINTR;
 		req_set_fail_links(req);
 	}
-	__io_req_complete(req, ret, 0, cs);
+	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
 
@@ -5006,8 +4995,7 @@ static int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 					&io->address);
 }
 
-static int io_connect(struct io_kiocb *req, unsigned int issue_flags,
-		      struct io_comp_state *cs)
+static int io_connect(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_connect __io, *io;
 	unsigned file_flags;
@@ -5045,7 +5033,7 @@ static int io_connect(struct io_kiocb *req, unsigned int issue_flags,
 out:
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, 0, cs);
+	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
 #else /* !CONFIG_NET */
@@ -5978,8 +5966,7 @@ static int io_rsrc_update_prep(struct io_kiocb *req,
 	return 0;
 }
 
-static int io_files_update(struct io_kiocb *req, unsigned int issue_flags,
-			   struct io_comp_state *cs)
+static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_rsrc_update up;
@@ -5997,7 +5984,7 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags,
 
 	if (ret < 0)
 		req_set_fail_links(req);
-	__io_req_complete(req, ret, 0, cs);
+	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
 
@@ -6204,25 +6191,24 @@ static void __io_clean_op(struct io_kiocb *req)
 	}
 }
 
-static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags,
-			struct io_comp_state *cs)
+static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
 	switch (req->opcode) {
 	case IORING_OP_NOP:
-		ret = io_nop(req, issue_flags, cs);
+		ret = io_nop(req, issue_flags);
 		break;
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 	case IORING_OP_READ:
-		ret = io_read(req, issue_flags, cs);
+		ret = io_read(req, issue_flags);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
-		ret = io_write(req, issue_flags, cs);
+		ret = io_write(req, issue_flags);
 		break;
 	case IORING_OP_FSYNC:
 		ret = io_fsync(req, issue_flags);
@@ -6237,16 +6223,16 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags,
 		ret = io_sync_file_range(req, issue_flags);
 		break;
 	case IORING_OP_SENDMSG:
-		ret = io_sendmsg(req, issue_flags, cs);
+		ret = io_sendmsg(req, issue_flags);
 		break;
 	case IORING_OP_SEND:
-		ret = io_send(req, issue_flags, cs);
+		ret = io_send(req, issue_flags);
 		break;
 	case IORING_OP_RECVMSG:
-		ret = io_recvmsg(req, issue_flags, cs);
+		ret = io_recvmsg(req, issue_flags);
 		break;
 	case IORING_OP_RECV:
-		ret = io_recv(req, issue_flags, cs);
+		ret = io_recv(req, issue_flags);
 		break;
 	case IORING_OP_TIMEOUT:
 		ret = io_timeout(req, issue_flags);
@@ -6255,10 +6241,10 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags,
 		ret = io_timeout_remove(req, issue_flags);
 		break;
 	case IORING_OP_ACCEPT:
-		ret = io_accept(req, issue_flags, cs);
+		ret = io_accept(req, issue_flags);
 		break;
 	case IORING_OP_CONNECT:
-		ret = io_connect(req, issue_flags, cs);
+		ret = io_connect(req, issue_flags);
 		break;
 	case IORING_OP_ASYNC_CANCEL:
 		ret = io_async_cancel(req, issue_flags);
@@ -6270,10 +6256,10 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags,
 		ret = io_openat(req, issue_flags);
 		break;
 	case IORING_OP_CLOSE:
-		ret = io_close(req, issue_flags, cs);
+		ret = io_close(req, issue_flags);
 		break;
 	case IORING_OP_FILES_UPDATE:
-		ret = io_files_update(req, issue_flags, cs);
+		ret = io_files_update(req, issue_flags);
 		break;
 	case IORING_OP_STATX:
 		ret = io_statx(req, issue_flags);
@@ -6288,16 +6274,16 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags,
 		ret = io_openat2(req, issue_flags);
 		break;
 	case IORING_OP_EPOLL_CTL:
-		ret = io_epoll_ctl(req, issue_flags, cs);
+		ret = io_epoll_ctl(req, issue_flags);
 		break;
 	case IORING_OP_SPLICE:
 		ret = io_splice(req, issue_flags);
 		break;
 	case IORING_OP_PROVIDE_BUFFERS:
-		ret = io_provide_buffers(req, issue_flags, cs);
+		ret = io_provide_buffers(req, issue_flags);
 		break;
 	case IORING_OP_REMOVE_BUFFERS:
-		ret = io_remove_buffers(req, issue_flags, cs);
+		ret = io_remove_buffers(req, issue_flags);
 		break;
 	case IORING_OP_TEE:
 		ret = io_tee(req, issue_flags);
@@ -6351,7 +6337,7 @@ static void io_wq_submit_work(struct io_wq_work *work)
 
 	if (!ret) {
 		do {
-			ret = io_issue_sqe(req, 0, NULL);
+			ret = io_issue_sqe(req, 0);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -6498,8 +6484,10 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 {
 	struct io_kiocb *linked_timeout;
 	const struct cred *old_creds = NULL;
-	int ret;
+	int ret, issue_flags = IO_URING_F_NONBLOCK;
 
+	if (cs)
+		issue_flags |= IO_URING_F_COMPLETE_DEFER;
 again:
 	linked_timeout = io_prep_linked_timeout(req);
 
@@ -6514,7 +6502,7 @@ static void __io_queue_sqe(struct io_kiocb *req, struct io_comp_state *cs)
 			old_creds = override_creds(req->work.identity->creds);
 	}
 
-	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK, cs);
+	ret = io_issue_sqe(req, issue_flags);
 
 	/*
 	 * We async punt it if the file wasn't marked NOWAIT, or if the file
-- 
2.24.0

