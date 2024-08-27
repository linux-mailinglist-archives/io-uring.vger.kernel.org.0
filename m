Return-Path: <io-uring+bounces-2960-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CA0039611FA
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 17:25:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 25468B28C03
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 15:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B57461BDA93;
	Tue, 27 Aug 2024 15:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IQ034/Lg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89AE1C4EEA
	for <io-uring@vger.kernel.org>; Tue, 27 Aug 2024 15:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772310; cv=none; b=PZvZq7+5nKfOWEJ++OU/E0UnOvEht+wGM1HbFcVGva8mLu1GyEfv2g8RLDySHwKz+fHdscgDFFVBXpuFCQggWPjSHhYkYq4I7peIBluGi0wm46KiAAylYZhpatyK/aMSVQkFVi9zz5hBHYmJGQFMNOlDe2ci/gR0uNRK2Igv+lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772310; c=relaxed/simple;
	bh=GW8LwMzQagLv1BPw7rcgHZJWtj1ESgMqxug57BA9OxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6aBIWoWBaKubc3kc/yOXfnp4oSKVm9ceuww1TQXcG7OJ4CqTXfQpqF4ySoiqQWhBTT2xryuj3R5kFmOcNNW4qhsFP8SHnZqEyG6+Dycp0RSXqc3bEaj6pkQjwzrGdAmdR1+PgRTnGyD0jMATMDP4XwW+W1sKfagHEsUPy6Ub/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IQ034/Lg; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-81fe38c7255so362648839f.1
        for <io-uring@vger.kernel.org>; Tue, 27 Aug 2024 08:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724772307; x=1725377107; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lc6n0lhFH9Y4btH72TiHY9bc+2TXbO2T78USv1wL81w=;
        b=IQ034/LgOZaWH14tY49G184CvRm9orVhkNBLs4RdnKf5vWVa6euL4pN6KCWaqNcHNR
         M3MaDKmv1ROJhbNvInhqRkRi7iQ5j8rq8Z9gEMmVYmJVMSeEZ5smc6tTEwQkvyBAYkLH
         pd9Hk+BJ+tkT0jm3l1E8gOs3RvWQ5gxlhsdlrXfwU0LttYsa+QxUanIcpFc1dXHOhQbO
         VKSxCVyqxC1A7sjXOkSPw6dRUzUoLPqhLAlpXRKO41yH4YXG58cl5WdJWVB8vsCESJLB
         TwAtNY7hGLNBxbsXvfKjjNLcmtMcWyjrKGECqSz4j3L78JVEcSeoKn0x71Z+RwJDXm/G
         f8PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724772307; x=1725377107;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lc6n0lhFH9Y4btH72TiHY9bc+2TXbO2T78USv1wL81w=;
        b=MWw4AKecc0/aoZ+uU16d6ZImUxzFTcZ7KoFeT645M+yiqxwLTfKeMOFnCZnN0wNaWz
         mLzCk3fXxg242TSIbCZNvouny522keTjSHRxXMLrs8Y/yiIGJnf2h7bvxWrB8v1bJCsQ
         mieSRevj1ZQAQZuh1ksDTVQwjIQ3A8pOt2uBbdp3OiJmrYTEXhbN1hAS/AZ2KQckPKHv
         HuYfAf4HCfYk8q1cIq1z9GonVn6lG7399poswz/q5rEwEOgmv3lHPsSOl506gh6SDEde
         FV/i7hQDEAiTVTB5I7bvlh5E5ioXnmw8rBZ7s/E/y+g01cRGAZW6J8ss5n972tOYypDt
         ou2g==
X-Gm-Message-State: AOJu0Yx0VPbSMtIsBthmkH3K3c+DZi6xQO+nsgHZAhMuekGwZhDG5F8u
	Xv4SRH2rz8t+TgWEjgdk9300HOUpavWdP2vVGupiXo5JSlUjqh+aWZQHutU5MvN7fknTppyeNs/
	1
X-Google-Smtp-Source: AGHT+IF9iuInm1JxmO0PNZCaSoz1rO31b9vCJIZrkGAYjZgN5gejY6nonj5XHQO9P6wLJHNiUkIxWg==
X-Received: by 2002:a05:6602:2d8e:b0:825:20ed:c3f5 with SMTP id ca18e2360f4ac-829f1147b8emr445140139f.0.1724772306869;
        Tue, 27 Aug 2024 08:25:06 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ce7106a4a9sm2678580173.106.2024.08.27.08.25.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 08:25:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring/kbuf: pass in 'len' argument for buffer commit
Date: Tue, 27 Aug 2024 09:23:08 -0600
Message-ID: <20240827152500.295643-5-axboe@kernel.dk>
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

In preparation for needing the consumed length, pass in the length being
completed. Unused right now, but will be used when it is possible to
partially consume a buffer.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c |  2 +-
 io_uring/kbuf.c     | 10 +++++-----
 io_uring/kbuf.h     | 33 +++++++++++++++++----------------
 io_uring/net.c      |  8 ++++----
 io_uring/rw.c       |  8 ++++----
 5 files changed, 31 insertions(+), 30 deletions(-)

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
index 297c1d2c3c27..55d01861d8c5 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -70,7 +70,7 @@ bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags)
 	return true;
 }
 
-void __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags)
+void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags)
 {
 	/*
 	 * We can add this buffer back to two lists:
@@ -88,12 +88,12 @@ void __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags)
 		struct io_ring_ctx *ctx = req->ctx;
 
 		spin_lock(&ctx->completion_lock);
-		__io_put_kbuf_list(req, &ctx->io_buffers_comp);
+		__io_put_kbuf_list(req, len, &ctx->io_buffers_comp);
 		spin_unlock(&ctx->completion_lock);
 	} else {
 		lockdep_assert_held(&req->ctx->uring_lock);
 
-		__io_put_kbuf_list(req, &req->ctx->io_buffers_cache);
+		__io_put_kbuf_list(req, len, &req->ctx->io_buffers_cache);
 	}
 }
 
@@ -165,7 +165,7 @@ static void __user *io_ring_buffer_select(struct io_kiocb *req, size_t *len,
 		 * the transfer completes (or if we get -EAGAIN and must poll of
 		 * retry).
 		 */
-		io_kbuf_commit(req, bl, 1);
+		io_kbuf_commit(req, bl, *len, 1);
 		req->buf_list = NULL;
 	}
 	return u64_to_user_ptr(buf->addr);
@@ -291,7 +291,7 @@ int io_buffers_select(struct io_kiocb *req, struct buf_sel_arg *arg,
 		 */
 		if (ret > 0) {
 			req->flags |= REQ_F_BUFFERS_COMMIT | REQ_F_BL_NO_RECYCLE;
-			io_kbuf_commit(req, bl, ret);
+			io_kbuf_commit(req, bl, arg->out_len, ret);
 		}
 	} else {
 		ret = io_provided_buffers_select(req, &arg->out_len, bl, arg->iovs);
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 4c34ff3144b9..b41e2a0a0505 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -77,7 +77,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
-void __io_put_kbuf(struct io_kiocb *req, unsigned issue_flags);
+void __io_put_kbuf(struct io_kiocb *req, int len, unsigned issue_flags);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
 
@@ -125,7 +125,7 @@ static inline bool io_kbuf_recycle(struct io_kiocb *req, unsigned issue_flags)
 #define io_ring_head_to_buf(br, head, mask)	&(br)->bufs[(head) & (mask)]
 
 static inline void io_kbuf_commit(struct io_kiocb *req,
-				  struct io_buffer_list *bl, int nr)
+				  struct io_buffer_list *bl, int len, int nr)
 {
 	if (unlikely(!(req->flags & REQ_F_BUFFERS_COMMIT)))
 		return;
@@ -133,22 +133,22 @@ static inline void io_kbuf_commit(struct io_kiocb *req,
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
 }
 
-static inline void __io_put_kbuf_list(struct io_kiocb *req,
+static inline void __io_put_kbuf_list(struct io_kiocb *req, int len,
 				      struct list_head *list)
 {
 	if (req->flags & REQ_F_BUFFER_RING) {
-		__io_put_kbuf_ring(req, 1);
+		__io_put_kbuf_ring(req, len, 1);
 	} else {
 		req->buf_index = req->kbuf->bgid;
 		list_add(&req->kbuf->list, list);
@@ -163,11 +163,12 @@ static inline void io_kbuf_drop(struct io_kiocb *req)
 	if (!(req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)))
 		return;
 
-	__io_put_kbuf_list(req, &req->ctx->io_buffers_comp);
+	/* len == 0 is fine here, non-ring will always drop all of it */
+	__io_put_kbuf_list(req, 0, &req->ctx->io_buffers_comp);
 }
 
-static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int nbufs,
-					  unsigned issue_flags)
+static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int len,
+					  int nbufs, unsigned issue_flags)
 {
 	unsigned int ret;
 
@@ -176,21 +177,21 @@ static inline unsigned int __io_put_kbufs(struct io_kiocb *req, int nbufs,
 
 	ret = IORING_CQE_F_BUFFER | (req->buf_index << IORING_CQE_BUFFER_SHIFT);
 	if (req->flags & REQ_F_BUFFER_RING)
-		__io_put_kbuf_ring(req, nbufs);
+		__io_put_kbuf_ring(req, len, nbufs);
 	else
-		__io_put_kbuf(req, issue_flags);
+		__io_put_kbuf(req, len, issue_flags);
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
2.45.2


