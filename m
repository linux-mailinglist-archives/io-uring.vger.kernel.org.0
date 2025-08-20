Return-Path: <io-uring+bounces-9122-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B9B1B2E4E7
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 20:27:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C16541CC249B
	for <lists+io-uring@lfdr.de>; Wed, 20 Aug 2025 18:26:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B45262798F0;
	Wed, 20 Aug 2025 18:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Nan0e78c"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8942727877F
	for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 18:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755714383; cv=none; b=j2+h/iouSaoe+5b6zmiltAegiFnhXvIcYahXmbvQ/OYOx0TNE9jCjGM15r7QOPeNFVVgz7B57+XzKvfBF35674sa5u9OGpPx4uQpmNEPrjH1uROXBCmQyif4mblEbD89QP5HhLSKz0iq7H5rNKBYdOufQEnMAcFU4qaQTvKpzds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755714383; c=relaxed/simple;
	bh=tFyNxVf5qMLdW5Kpoi54Jy0ww5INHYrOeMRqdD4U7f0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggJrRjHC0dWeD244ajcYRyQYLgVvN53a1CekkkMJwOVaC7N/rtHEQhqQJ8NaVAO6kmXYJZDyWbifvoI29X5rOzTYE+OLdRakYkaqSylfcyOqK1Hz/IpLUlLAkxrTuNizu9xf+83sN2L2stDsVrD0NjnSQIg2qr5JhVyKmM/1GW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Nan0e78c; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-30cceb3be82so224137fac.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 11:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755714379; x=1756319179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aNkB1HUfNFXCsSB108FyOSJzytNDLV89P0R3qZmpLys=;
        b=Nan0e78c3jxf/Wz7oECHJCFzqz42H2Gye1cpi9C3M/QVXuzUZKXpQv5y4i2i90VHwq
         KxzqSa0AlRoX/llGVj+ODB2stEu22n9GJqSCyW0r4x+XGnv238bhb2LnvwVjnPlJs0Nu
         45JzCq5HfdWgKlzvTWkImVj/p0k/TYcV2SHQZ1ckFMa4XxZa+KL7dZBrJ8STTrKcBl5H
         ODVFMQzt2Y2oqcIvm7sYLqZ3rYmwcxgZzZF3IrbzRMUc2qQyrQuxzZY7ZANEJ+rYfUpF
         lzOQrwR89BFwJWN+EfdrqePFw/n6LlTSlA3ywDgj8zKG4sVrJW4CBMnsFHbSXF6D9FwD
         Zw4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755714379; x=1756319179;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aNkB1HUfNFXCsSB108FyOSJzytNDLV89P0R3qZmpLys=;
        b=KkpPakO45V3f+mVDIPKZPXoPlUap61ORKuU78ML+Gji1cWaqyzPGNoH0gzatyw6agD
         XCZWBA1DSDsnPBYsppmU2LeLVHBOW4+LCx7bdWk7x2gy1ygLmgSd7m67bDIwfA8Rm3kW
         0Pwa7ztr+wAoRs3wXnBs6SL/BITnOR3WLiftkoCvtZ8bmjneUFFlE+Y0152sbN8COme3
         Sqv0OoEvurBUcrKphRTpFUY0iuv++JPl63v5TMFh/SpfBT99sAFStDx2ijGGZ0Hm9z+D
         dDrsUkWhA6yE5vC7AHGmHIT4g2+sNOk81va9GrcqPXQcwmTdy35EhGs2vFHw9pQmjmxI
         quxw==
X-Gm-Message-State: AOJu0Yy3q4x90XGHAfNVANTPiyIv+alIuTE3zD/jfFMZ8qMip/xnhari
	M40PMXdmQStWxp5UaKBM/N+DI0nmWMCaII6VIuwuV1oALkxnGIykU5+3a+YU84JY8khnxxscLHD
	23QwJ
X-Gm-Gg: ASbGncvLhHFHv/znuOEHodB5bS3b+w5PCi3hBHrKQcE5JZpY887NndN9qSQTJygJM7y
	66udVLQJQHMtuaYY7W1QB6zfneq6GMgSdvl1F5bO458rW1bgLet7dhP8RBdeq0J4A02CUQ8Qxc7
	fQQBzM9zGnCRgxO7YL90JHtVsa7WEmgxUNjvui7n8CE0pOQ0uB+qo4fTqnygrHx9Nd8NJXcO5Xe
	trmnClXxzII0TbVM1BenY30Yk4wgqgaSvPHwq81gUG/JytKNlw/WL1bVGNZJL762MwKzL6edsO1
	LXKS0LSy2EpdKH3jSCl8S2c43aQzf5K2JC7N1xY6sS0jD0BasL5ujP2cl4O9AXTdD4QDY2DgZkV
	ECU4V5g==
X-Google-Smtp-Source: AGHT+IFOW8dh5oEJl0h51Njy3bqhR+0mcshy7RXD1g+e5p0zx8g6WtqIC/otTplzeeAvOtG1Yiz5IA==
X-Received: by 2002:a05:6808:4c8d:b0:437:75a1:3502 with SMTP id 5614622812f47-43775b0b37dmr1072717b6e.46.1755714379245;
        Wed, 20 Aug 2025 11:26:19 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c947b3666sm4217951173.24.2025.08.20.11.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 11:26:17 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/9] io_uring/kbuf: switch to storing struct io_buffer_list locally
Date: Wed, 20 Aug 2025 12:22:54 -0600
Message-ID: <20250820182601.442933-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250820182601.442933-1-axboe@kernel.dk>
References: <20250820182601.442933-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently the buffer list is stored in struct io_kiocb. The buffer list
can be of two types:

1) Classic/legacy buffer list. These don't need to get referenced after
   a buffer pick, and hence storing them in struct io_kiocb is perfectly
   fine.

2) Ring provided buffer lists. These DO need to be referenced after the
   initial buffer pick, as they need to get consumed later on. This can
   be either just incrementing the head of the ring, or it can be
   consuming parts of a buffer if incremental buffer consumptions has
   been configured.

For case 2, io_uring needs to be careful not to access the buffer list
after the initial pick-and-execute context. The core does recycling of
these, but it's easy to make a mistake, because it's stored in the
io_kiocb which does persist across multiple execution contexts. Either
because it's a multishot request, or simply because it needed some kind
of async trigger (eg poll) for retry purposes.

Add a struct io_buffer_list to struct io_br_sel, which is always on
stack for the various users of it. This prevents the buffer list from
leaking outside of that execution context, and additionally it enables
kbuf to not even pass back the struct io_buffer_list if the given
context isn't appropriately locked already.

This doesn't fix any bugs, it's simply a defensive measure to prevent
any issues with reuse of a buffer list.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  6 ----
 io_uring/io_uring.c            |  6 ++--
 io_uring/kbuf.c                | 27 ++++++++++--------
 io_uring/kbuf.h                | 16 ++++-------
 io_uring/net.c                 | 50 +++++++++++++---------------------
 io_uring/poll.c                |  6 ++--
 io_uring/rw.c                  | 22 +++++++--------
 7 files changed, 57 insertions(+), 76 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 80a178f3d896..1d33984611bc 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -674,12 +674,6 @@ struct io_kiocb {
 		/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 		struct io_buffer	*kbuf;
 
-		/*
-		 * stores buffer ID for ring provided buffers, valid IFF
-		 * REQ_F_BUFFER_RING is set.
-		 */
-		struct io_buffer_list	*buf_list;
-
 		struct io_rsrc_node	*buf_node;
 	};
 
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 53dcdd13fbf6..37d1f6d28c78 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1007,7 +1007,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	lockdep_assert_held(&req->ctx->uring_lock);
 
 	req_set_fail(req);
-	io_req_set_res(req, res, io_put_kbuf(req, res, req->buf_list, IO_URING_F_UNLOCKED));
+	io_req_set_res(req, res, io_put_kbuf(req, res, NULL, IO_URING_F_UNLOCKED));
 	if (def->fail)
 		def->fail(req);
 	io_req_complete_defer(req);
@@ -2025,11 +2025,11 @@ static void io_queue_async(struct io_kiocb *req, unsigned int issue_flags, int r
 
 	switch (io_arm_poll_handler(req, 0)) {
 	case IO_APOLL_READY:
-		io_kbuf_recycle(req, req->buf_list, 0);
+		io_kbuf_recycle(req, NULL, 0);
 		io_req_task_queue(req);
 		break;
 	case IO_APOLL_ABORTED:
-		io_kbuf_recycle(req, req->buf_list, 0);
+		io_kbuf_recycle(req, NULL, 0);
 		io_queue_iowq(req);
 		break;
 	case IO_APOLL_OK:
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 21c12c437ab9..3e9aab21af9d 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -171,8 +171,8 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 	if (*len == 0 || *len > buf->len)
 		*len = buf->len;
 	req->flags |= REQ_F_BUFFER_RING | REQ_F_BUFFERS_COMMIT;
-	req->buf_list = bl;
 	req->buf_index = buf->bid;
+	sel.buf_list = bl;
 	sel.addr = u64_to_user_ptr(buf->addr);
 
 	if (issue_flags & IO_URING_F_UNLOCKED || !io_file_can_poll(req)) {
@@ -186,8 +186,8 @@ static struct io_br_sel io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		 * the transfer completes (or if we get -EAGAIN and must poll of
 		 * retry).
 		 */
-		io_kbuf_commit(req, bl, *len, 1);
-		req->buf_list = NULL;
+		io_kbuf_commit(req, sel.buf_list, *len, 1);
+		sel.buf_list = NULL;
 	}
 	return sel;
 }
@@ -294,7 +294,6 @@ static int io_ring_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		req->flags |= REQ_F_BL_EMPTY;
 
 	req->flags |= REQ_F_BUFFER_RING;
-	req->buf_list = bl;
 	return iov - arg->iovs;
 }
 
@@ -302,16 +301,15 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		      struct io_br_sel *sel, unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	struct io_buffer_list *bl;
 	int ret = -ENOENT;
 
 	io_ring_submit_lock(ctx, issue_flags);
-	bl = io_buffer_get_list(ctx, arg->buf_group);
-	if (unlikely(!bl))
+	sel->buf_list = io_buffer_get_list(ctx, arg->buf_group);
+	if (unlikely(!sel->buf_list))
 		goto out_unlock;
 
-	if (bl->flags & IOBL_BUF_RING) {
-		ret = io_ring_buffers_peek(req, arg, bl);
+	if (sel->buf_list->flags & IOBL_BUF_RING) {
+		ret = io_ring_buffers_peek(req, arg, sel->buf_list);
 		/*
 		 * Don't recycle these buffers if we need to go through poll.
 		 * Nobody else can use them anyway, and holding on to provided
@@ -321,13 +319,16 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		 */
 		if (ret > 0) {
 			req->flags |= REQ_F_BUFFERS_COMMIT | REQ_F_BL_NO_RECYCLE;
-			io_kbuf_commit(req, bl, arg->out_len, ret);
+			io_kbuf_commit(req, sel->buf_list, arg->out_len, ret);
 		}
 	} else {
-		ret = io_provided_buffers_select(req, &arg->out_len, bl, arg->iovs);
+		ret = io_provided_buffers_select(req, &arg->out_len, sel->buf_list, arg->iovs);
 	}
 out_unlock:
-	io_ring_submit_unlock(ctx, issue_flags);
+	if (issue_flags & IO_URING_F_UNLOCKED) {
+		sel->buf_list = NULL;
+		mutex_unlock(&ctx->uring_lock);
+	}
 	return ret;
 }
 
@@ -348,10 +349,12 @@ int io_buffers_peek(struct io_kiocb *req, struct buf_sel_arg *arg,
 		ret = io_ring_buffers_peek(req, arg, bl);
 		if (ret > 0)
 			req->flags |= REQ_F_BUFFERS_COMMIT;
+		sel->buf_list = bl;
 		return ret;
 	}
 
 	/* don't support multiple buffer selections for legacy */
+	sel->buf_list = NULL;
 	return io_provided_buffers_select(req, &arg->max_len, bl, arg->iovs);
 }
 
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 86542ae759f4..b91b1c2bb42a 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -63,11 +63,14 @@ struct buf_sel_arg {
 };
 
 /*
- * Return value from io_buffer_list selection. Just returns the error or
- * user address for now, will be extended to return the buffer list in the
- * future.
+ * Return value from io_buffer_list selection, to avoid stashing it in
+ * struct io_kiocb. For legacy/classic provided buffers, keeping a reference
+ * across execution contexts are fine. But for ring provided buffers, the
+ * list may go away as soon as ->uring_lock is dropped. As the io_kiocb
+ * persists, it's better to just keep the buffer local for those cases.
  */
 struct io_br_sel {
+	struct io_buffer_list *buf_list;
 	/*
 	 * Some selection parts return the user address, others return an error.
 	 */
@@ -107,13 +110,6 @@ struct io_mapped_region *io_pbuf_get_region(struct io_ring_ctx *ctx,
 static inline bool io_kbuf_recycle_ring(struct io_kiocb *req,
 					struct io_buffer_list *bl)
 {
-	/*
-	 * We don't need to recycle for REQ_F_BUFFER_RING, we can just clear
-	 * the flag and hence ensure that bl->head doesn't get incremented.
-	 * If the tail has already been incremented, hang on to it.
-	 * The exception is partial io, that case we should increment bl->head
-	 * to monopolize the buffer.
-	 */
 	if (bl) {
 		req->flags &= ~(REQ_F_BUFFER_RING|REQ_F_BUFFERS_COMMIT);
 		return true;
diff --git a/io_uring/net.c b/io_uring/net.c
index 432235f27587..90dad9eb32bb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -433,7 +433,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		if (req->opcode == IORING_OP_SENDMSG)
 			return -EINVAL;
 		sr->msg_flags |= MSG_WAITALL;
-		req->buf_list = NULL;
 		req->flags |= REQ_F_MULTISHOT;
 	}
 
@@ -505,18 +504,18 @@ static int io_net_kbuf_recyle(struct io_kiocb *req, struct io_buffer_list *bl,
 
 static inline bool io_send_finish(struct io_kiocb *req, int *ret,
 				  struct io_async_msghdr *kmsg,
-				  unsigned issue_flags)
+				  struct io_br_sel *sel, unsigned issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	bool bundle_finished = *ret <= 0;
 	unsigned int cflags;
 
 	if (!(sr->flags & IORING_RECVSEND_BUNDLE)) {
-		cflags = io_put_kbuf(req, *ret, req->buf_list, issue_flags);
+		cflags = io_put_kbuf(req, *ret, sel->buf_list, issue_flags);
 		goto finish;
 	}
 
-	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret), req->buf_list, issue_flags);
+	cflags = io_put_kbufs(req, *ret, io_bundle_nbufs(kmsg, *ret), sel->buf_list, issue_flags);
 
 	if (bundle_finished || req->flags & REQ_F_BL_EMPTY)
 		goto finish;
@@ -657,6 +656,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 		flags |= MSG_DONTWAIT;
 
 retry_bundle:
+	sel.buf_list = NULL;
 	if (io_do_buffer_select(req)) {
 		ret = io_send_select_buffer(req, issue_flags, &sel, kmsg);
 		if (ret)
@@ -682,7 +682,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, req->buf_list, kmsg, ret);
+			return io_net_kbuf_recyle(req, sel.buf_list, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -693,7 +693,7 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	else if (sr->done_io)
 		ret = sr->done_io;
 
-	if (!io_send_finish(req, &ret, kmsg, issue_flags))
+	if (!io_send_finish(req, &ret, kmsg, &sel, issue_flags))
 		goto retry_bundle;
 
 	io_req_msg_cleanup(req, issue_flags);
@@ -794,18 +794,8 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->flags |= REQ_F_NOWAIT;
 	if (sr->msg_flags & MSG_ERRQUEUE)
 		req->flags |= REQ_F_CLEAR_POLLIN;
-	if (req->flags & REQ_F_BUFFER_SELECT) {
-		/*
-		 * Store the buffer group for this multishot receive separately,
-		 * as if we end up doing an io-wq based issue that selects a
-		 * buffer, it has to be committed immediately and that will
-		 * clear ->buf_list. This means we lose the link to the buffer
-		 * list, and the eventual buffer put on completion then cannot
-		 * restore it.
-		 */
+	if (req->flags & REQ_F_BUFFER_SELECT)
 		sr->buf_group = req->buf_index;
-		req->buf_list = NULL;
-	}
 	sr->mshot_total_len = sr->mshot_len = 0;
 	if (sr->flags & IORING_RECV_MULTISHOT) {
 		if (!(req->flags & REQ_F_BUFFER_SELECT))
@@ -874,7 +864,7 @@ static inline bool io_recv_finish(struct io_kiocb *req,
 		size_t this_ret = sel->val - sr->done_io;
 
 		cflags |= io_put_kbufs(req, this_ret, io_bundle_nbufs(kmsg, this_ret),
-				      req->buf_list, issue_flags);
+				      sel->buf_list, issue_flags);
 		if (sr->flags & IORING_RECV_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		if (sr->mshot_len && sel->val >= sr->mshot_len)
@@ -896,7 +886,7 @@ static inline bool io_recv_finish(struct io_kiocb *req,
 			return false;
 		}
 	} else {
-		cflags |= io_put_kbuf(req, sel->val, req->buf_list, issue_flags);
+		cflags |= io_put_kbuf(req, sel->val, sel->buf_list, issue_flags);
 	}
 
 	/*
@@ -1038,6 +1028,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		flags |= MSG_DONTWAIT;
 
 retry_multishot:
+	sel.buf_list = NULL;
 	if (io_do_buffer_select(req)) {
 		size_t len = sr->len;
 
@@ -1048,7 +1039,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		if (req->flags & REQ_F_APOLL_MULTISHOT) {
 			ret = io_recvmsg_prep_multishot(kmsg, sr, &sel.addr, &len);
 			if (ret) {
-				io_kbuf_recycle(req, req->buf_list, issue_flags);
+				io_kbuf_recycle(req, sel.buf_list, issue_flags);
 				return ret;
 			}
 		}
@@ -1072,14 +1063,12 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
-			if (issue_flags & IO_URING_F_MULTISHOT)
-				io_kbuf_recycle(req, req->buf_list, issue_flags);
-
+			io_kbuf_recycle(req, sel.buf_list, issue_flags);
 			return IOU_RETRY;
 		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, req->buf_list, kmsg, ret);
+			return io_net_kbuf_recyle(req, sel.buf_list, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1093,7 +1082,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	else if (sr->done_io)
 		ret = sr->done_io;
 	else
-		io_kbuf_recycle(req, req->buf_list, issue_flags);
+		io_kbuf_recycle(req, sel.buf_list, issue_flags);
 
 	sel.val = ret;
 	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags))
@@ -1178,7 +1167,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *kmsg = req->async_data;
-	struct io_br_sel sel = { };
+	struct io_br_sel sel;
 	struct socket *sock;
 	unsigned flags;
 	int ret, min_ret = 0;
@@ -1198,6 +1187,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		flags |= MSG_DONTWAIT;
 
 retry_multishot:
+	sel.buf_list = NULL;
 	if (io_do_buffer_select(req)) {
 		sel.val = sr->len;
 		ret = io_recv_buf_select(req, kmsg, &sel, issue_flags);
@@ -1217,16 +1207,14 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	ret = sock_recvmsg(sock, &kmsg->msg, flags);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
-			if (issue_flags & IO_URING_F_MULTISHOT)
-				io_kbuf_recycle(req, req->buf_list, issue_flags);
-
+			io_kbuf_recycle(req, sel.buf_list, issue_flags);
 			return IOU_RETRY;
 		}
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
-			return io_net_kbuf_recyle(req, req->buf_list, kmsg, ret);
+			return io_net_kbuf_recyle(req, sel.buf_list, kmsg, ret);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
@@ -1242,7 +1230,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	else if (sr->done_io)
 		ret = sr->done_io;
 	else
-		io_kbuf_recycle(req, req->buf_list, issue_flags);
+		io_kbuf_recycle(req, sel.buf_list, issue_flags);
 
 	sel.val = ret;
 	if (!io_recv_finish(req, kmsg, &sel, mshot_finished, issue_flags))
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 07ab22380c78..f3852bf7627b 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -316,10 +316,10 @@ void io_poll_task_func(struct io_kiocb *req, io_tw_token_t tw)
 
 	ret = io_poll_check_events(req, tw);
 	if (ret == IOU_POLL_NO_ACTION) {
-		io_kbuf_recycle(req, req->buf_list, 0);
+		io_kbuf_recycle(req, NULL, 0);
 		return;
 	} else if (ret == IOU_POLL_REQUEUE) {
-		io_kbuf_recycle(req, req->buf_list, 0);
+		io_kbuf_recycle(req, NULL, 0);
 		__io_poll_execute(req, 0);
 		return;
 	}
@@ -686,7 +686,7 @@ int io_arm_apoll(struct io_kiocb *req, unsigned issue_flags, __poll_t mask)
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
 
-	io_kbuf_recycle(req, req->buf_list, issue_flags);
+	io_kbuf_recycle(req, NULL, issue_flags);
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask, issue_flags);
 	if (ret)
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0c04209dc25e..44a850cdf6ab 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -579,7 +579,7 @@ void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw)
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
-		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, req->buf_list, 0);
+		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, NULL, 0);
 
 	io_req_rw_cleanup(req, 0);
 	io_req_task_complete(req, tw);
@@ -648,7 +648,7 @@ static inline void io_rw_done(struct io_kiocb *req, ssize_t ret)
 }
 
 static int kiocb_done(struct io_kiocb *req, ssize_t ret,
-		       unsigned int issue_flags)
+		      struct io_br_sel *sel, unsigned int issue_flags)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 	unsigned final_ret = io_fixup_rw_res(req, ret);
@@ -662,7 +662,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 		 * from the submission path.
 		 */
 		io_req_io_end(req);
-		io_req_set_res(req, final_ret, io_put_kbuf(req, ret, req->buf_list, issue_flags));
+		io_req_set_res(req, final_ret, io_put_kbuf(req, ret, sel->buf_list, issue_flags));
 		io_req_rw_cleanup(req, issue_flags);
 		return IOU_COMPLETE;
 	} else {
@@ -1024,10 +1024,10 @@ int io_read(struct io_kiocb *req, unsigned int issue_flags)
 
 	ret = __io_read(req, &sel, issue_flags);
 	if (ret >= 0)
-		return kiocb_done(req, ret, issue_flags);
+		return kiocb_done(req, ret, &sel, issue_flags);
 
 	if (req->flags & REQ_F_BUFFERS_COMMIT)
-		io_kbuf_recycle(req, req->buf_list, issue_flags);
+		io_kbuf_recycle(req, sel.buf_list, issue_flags);
 	return ret;
 }
 
@@ -1057,15 +1057,15 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		 * Reset rw->len to 0 again to avoid clamping future mshot
 		 * reads, in case the buffer size varies.
 		 */
-		if (io_kbuf_recycle(req, req->buf_list, issue_flags))
+		if (io_kbuf_recycle(req, sel.buf_list, issue_flags))
 			rw->len = 0;
 		return IOU_RETRY;
 	} else if (ret <= 0) {
-		io_kbuf_recycle(req, req->buf_list, issue_flags);
+		io_kbuf_recycle(req, sel.buf_list, issue_flags);
 		if (ret < 0)
 			req_set_fail(req);
 	} else if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
-		cflags = io_put_kbuf(req, ret, req->buf_list, issue_flags);
+		cflags = io_put_kbuf(req, ret, sel.buf_list, issue_flags);
 	} else {
 		/*
 		 * Any successful return value will keep the multishot read
@@ -1073,7 +1073,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		 * we fail to post a CQE, or multishot is no longer set, then
 		 * jump to the termination path. This request is then done.
 		 */
-		cflags = io_put_kbuf(req, ret, req->buf_list, issue_flags);
+		cflags = io_put_kbuf(req, ret, sel.buf_list, issue_flags);
 		rw->len = 0; /* similarly to above, reset len to 0 */
 
 		if (io_req_post_cqe(req, ret, cflags | IORING_CQE_F_MORE)) {
@@ -1202,7 +1202,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		}
 done:
-		return kiocb_done(req, ret2, issue_flags);
+		return kiocb_done(req, ret2, NULL, issue_flags);
 	} else {
 ret_eagain:
 		iov_iter_restore(&io->iter, &io->iter_state);
@@ -1370,7 +1370,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
 		nr_events++;
-		req->cqe.flags = io_put_kbuf(req, req->cqe.res, req->buf_list, 0);
+		req->cqe.flags = io_put_kbuf(req, req->cqe.res, NULL, 0);
 		if (req->opcode != IORING_OP_URING_CMD)
 			io_req_rw_cleanup(req, 0);
 	}
-- 
2.50.1


