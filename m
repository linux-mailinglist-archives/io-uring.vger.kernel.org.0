Return-Path: <io-uring+bounces-9145-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BE00B2EB1C
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 04:08:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 19C721CC2751
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 02:09:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983B92D8781;
	Thu, 21 Aug 2025 02:08:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Nh2X4NtL"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8495C2D8DD1
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 02:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755742129; cv=none; b=fanDbgZgIuQTFsYt5GbY2Za6O3IgfjKcvce9iQZwsm2L8dEsqnf5yj1SHmbwYb3cQE+pIYj7FFlGT6jWv9xCiwCcZ46r2Y9HMXiwom/pasl5dsYhev207xUIIA/KJWcaeMgMojMXjGqPbofig6qq4JD4ZORBh0QYLJeSwJhCRZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755742129; c=relaxed/simple;
	bh=gL95uaAo07B92yXQc4OvAu8Z84+1pdC711gKtMsJSNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZ22ApbVTh31gysNyaiDBYAfeWP1U7XIok8TztlPtje9IMUAHveNdsqM9U+pCS3et23xQVhYnwoM/ALIL3ru2MWCti5CFkiTcSX5uLsQZgEeOm+nDnc/ZT3xuEh+nTEOkd88kqA8tW3v7GABlD+nLrTuCQrHrmYyxA09KGF2Ao8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Nh2X4NtL; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-32326e20aadso651045a91.2
        for <io-uring@vger.kernel.org>; Wed, 20 Aug 2025 19:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755742126; x=1756346926; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0ZpiMNjwM9FXPEi2XCsSQorpikebLxZGgxaaX+oXFC8=;
        b=Nh2X4NtLZhZbvmrHzMB7o/7wtQ4XSNKPOAJ1hFGS/3MZrIGzjA1mlK3VYNi1ekS7FN
         LaYRCcwJMgOjXyzXw4Qr/XdF+yYgegetQGROG1Ta7Pw/H0RaLXZcylqL3TKeSfb56J6B
         W5TX9AouorEFxlLRmcuPWJYjb9E0deWU4fH1YWeplXaEY/fidAI2iBvgPeW4Z55TYHqq
         ZXlKd0LqEavxlDmZW6yO5aRV6wFHoPK7ZjNqkb9u6ghv715ONn4byFcsEnZafCjyDeS1
         MrrOtmN858aUNEAutjyTUQVnRZZcILtuv9tr1nWpQszQviymmlxnJfZZQnEtm/MFewGE
         umAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755742126; x=1756346926;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0ZpiMNjwM9FXPEi2XCsSQorpikebLxZGgxaaX+oXFC8=;
        b=odJctvKFzBSrHkG7IYpSzmduFARfaBlQ60bZixe4jRYP8341YdkBhAHIisF+9VIHoD
         8PXWozncijLTDkiKrnVIDv2XyihhV2iqA2QE9Phq4BoFZU/ojN6EG3iN4XQB0BEt+ezx
         txhxwJz6q9bmPrxf/7JTVnB3b9qRj0rJPv13ZILnhSyaR+RS6XcrDRSumbKuTCn9JplE
         E0W60Kf0kfb8gihN/ha1VnAi81TKNgQyqywbqmO62Bszhn0sQZ498xQAxW6XRnUaZZJS
         9Q2YdFy6C70Seo5kVGjl2twcKM9sa337wD+FvPnkDPCOYP0CyLRcVRHYyAGPibVHf3p9
         t8Og==
X-Gm-Message-State: AOJu0Yw6PgcQs48Ds2wP3tOgzLA3vSGZBf/njDM6aTuiJryu7OP8ef3n
	ZZLcIZupt37JuETgNzhXgXD4RGCOHXc89AH0yKsT874DfGq8l+Gy4Vg5C4vG4K9wQFRA6SgabCZ
	3tYoG
X-Gm-Gg: ASbGnctYsZtIo/NowCRuz+4Tt8xqEeIgCzrBvTT1xr1hqpy2XdjioJvxW8QVRMeuJig
	b6lDufOrFAkxSHXnfotnTmJTQPTxP6ru76olnuhcNa3tmo8ChnBe59WYxqFy6Pdek+dJKlM25JX
	kz7wWgXhLKyYM8QnfQB20bWGq8MocZwFEbMwgSuEHre+8IjQa8N5fsr+Qs8Zmsk0iHU7qgSPUfN
	QyfXQGJ2uf4WoeOm6xGyiyU8VuwxnkBupPO/8AdHFk64XwC2NURdHGAi9v+/goiZ7+1n+NX2oY0
	CVQFGT2xrkypvWTcRulP7OQn2+a2HJzhlfRT/z+MPG7wqJNfYk6e4jmlVNcxOoU1E1tCpEdsOh7
	sseNh1Qk=
X-Google-Smtp-Source: AGHT+IG1fD3RwWVT4bh0ERRyyWRUNqEP5Wdj1ZVVL9yBjA3FqcLpT6EWujKzkk0EL5bNPKK6vCr1Eg==
X-Received: by 2002:a17:90b:3f0e:b0:321:1a89:f692 with SMTP id 98e67ed59e1d1-324ed07d795mr1211622a91.8.1755742125927;
        Wed, 20 Aug 2025 19:08:45 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-324f381812asm104827a91.0.2025.08.20.19.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Aug 2025 19:08:44 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/12] io_uring/kbuf: switch to storing struct io_buffer_list locally
Date: Wed, 20 Aug 2025 20:03:39 -0600
Message-ID: <20250821020750.598432-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821020750.598432-2-axboe@kernel.dk>
References: <20250821020750.598432-2-axboe@kernel.dk>
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
 include/linux/io_uring_types.h |  6 -----
 io_uring/io_uring.c            |  6 ++---
 io_uring/kbuf.c                | 27 +++++++++++---------
 io_uring/kbuf.h                | 16 +++++-------
 io_uring/net.c                 | 46 +++++++++++++---------------------
 io_uring/poll.c                |  6 ++---
 io_uring/rw.c                  | 22 ++++++++--------
 7 files changed, 55 insertions(+), 74 deletions(-)

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
index 052e80c02d7a..3c25b75dee9d 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1007,7 +1007,7 @@ void io_req_defer_failed(struct io_kiocb *req, s32 res)
 	lockdep_assert_held(&req->ctx->uring_lock);
 
 	req_set_fail(req);
-	io_req_set_res(req, res, io_put_kbuf(req, res, req->buf_list));
+	io_req_set_res(req, res, io_put_kbuf(req, res, NULL));
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
index b1723c2620da..1a539969fc9c 100644
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
index 4eb208d24169..b00cd2f59091 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -433,7 +433,6 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		if (req->opcode == IORING_OP_SENDMSG)
 			return -EINVAL;
 		sr->msg_flags |= MSG_WAITALL;
-		req->buf_list = NULL;
 		req->flags |= REQ_F_MULTISHOT;
 	}
 
@@ -512,11 +511,11 @@ static inline bool io_send_finish(struct io_kiocb *req,
 	unsigned int cflags;
 
 	if (!(sr->flags & IORING_RECVSEND_BUNDLE)) {
-		cflags = io_put_kbuf(req, sel->val, req->buf_list);
+		cflags = io_put_kbuf(req, sel->val, sel->buf_list);
 		goto finish;
 	}
 
-	cflags = io_put_kbufs(req, sel->val, req->buf_list, io_bundle_nbufs(kmsg, sel->val));
+	cflags = io_put_kbufs(req, sel->val, sel->buf_list, io_bundle_nbufs(kmsg, sel->val));
 
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
@@ -795,18 +795,8 @@ int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
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
 	if (sr->flags & IORING_RECVSEND_BUNDLE) {
 		size_t this_ret = sel->val - sr->done_io;
 
-		cflags |= io_put_kbufs(req, this_ret, req->buf_list, io_bundle_nbufs(kmsg, this_ret));
+		cflags |= io_put_kbufs(req, this_ret, sel->buf_list, io_bundle_nbufs(kmsg, this_ret));
 		if (sr->flags & IORING_RECV_RETRY)
 			cflags = req->cqe.flags | (cflags & CQE_F_MASK);
 		if (sr->mshot_len && sel->val >= sr->mshot_len)
@@ -896,7 +886,7 @@ static inline bool io_recv_finish(struct io_kiocb *req,
 			return false;
 		}
 	} else {
-		cflags |= io_put_kbuf(req, sel->val, req->buf_list);
+		cflags |= io_put_kbuf(req, sel->val, sel->buf_list);
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
index 2b106f644383..906e869d330a 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -579,7 +579,7 @@ void io_req_rw_complete(struct io_kiocb *req, io_tw_token_t tw)
 	io_req_io_end(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
-		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, req->buf_list);
+		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, NULL);
 
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
-		io_req_set_res(req, final_ret, io_put_kbuf(req, ret, req->buf_list));
+		io_req_set_res(req, final_ret, io_put_kbuf(req, ret, sel->buf_list));
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
-		cflags = io_put_kbuf(req, ret, req->buf_list);
+		cflags = io_put_kbuf(req, ret, sel.buf_list);
 	} else {
 		/*
 		 * Any successful return value will keep the multishot read
@@ -1073,7 +1073,7 @@ int io_read_mshot(struct io_kiocb *req, unsigned int issue_flags)
 		 * we fail to post a CQE, or multishot is no longer set, then
 		 * jump to the termination path. This request is then done.
 		 */
-		cflags = io_put_kbuf(req, ret, req->buf_list);
+		cflags = io_put_kbuf(req, ret, sel.buf_list);
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
-		req->cqe.flags = io_put_kbuf(req, req->cqe.res, req->buf_list);
+		req->cqe.flags = io_put_kbuf(req, req->cqe.res, NULL);
 		if (req->opcode != IORING_OP_URING_CMD)
 			io_req_rw_cleanup(req, 0);
 	}
-- 
2.50.1


