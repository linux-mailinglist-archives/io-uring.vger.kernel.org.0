Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 853681A54A5
	for <lists+io-uring@lfdr.de>; Sun, 12 Apr 2020 01:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727296AbgDKXGZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Apr 2020 19:06:25 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54601 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgDKXGY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Apr 2020 19:06:24 -0400
Received: by mail-wm1-f65.google.com with SMTP id h2so5968026wmb.4;
        Sat, 11 Apr 2020 16:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hzqK+SI1g1DiPgUbeXNICnK2Y3grd5OZcA1bbrAzQy0=;
        b=EIP5I5qjwusmpZsLSJYCpSqReJvKdiUOoopTnZRQ1E1mwDqSlrPGhFzhHTDAkK448c
         2rjwUKAlY3c3J8FwkXNosUPhZ8mOisnZqDq3v1neh0zpmKFT7VV2hXgaPCDHK7sEx4f1
         IZD6jb9t+TPUJFSOcDs0+2jYzge6ViOFahprESMFAj0fQI3E4lQHwlFN8TByx4CmcGtB
         +jAXBwhMQhYXnM+xO1Ee/KkDEuhrvzQfQIDNyuC1Oz/ioMkDd8c08SjSrammkt2Ignai
         ABlLRcJ5aZHqFykFDTSCyZcuFFZOKv4GXOVXgf7jfdwo7Xyg3yIdMOKVw9pqfT4uU/kq
         wG+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hzqK+SI1g1DiPgUbeXNICnK2Y3grd5OZcA1bbrAzQy0=;
        b=WOz786AjIQfpQzTo6mMq61zVR5YGe5Ef2Jh4BDPF+ih8rybK1Oey1seflA9oMG8hSM
         i7Ly91HRiAu5xwHABqaWQutWs/BBQbSfcHnBcaKY4WwlCYOplirsiIPEZjQf37dGcuOo
         JkS2Q4j7Bu+8Dj9hlAIULTygvuyCULEEMw7Cm1U9iv8B1jahP0ztqvQgezFIqqHDxkbs
         lxFjkecvfdYvhTwUdmYOP6LRDiUQPkfFsfywM9FnkKExyIGSAH6WpksVstLOUvj1/Pyh
         YsVeCk93iukAR2Sv9q8KwCZQ2n8OsjRIdRUoZ1kcHhTB1uoex9E3Oy9XSdCDbIJ2kKoF
         dPaQ==
X-Gm-Message-State: AGi0Pubjzxg9kdtgiWCJ44OmZlSihHlm+D/DlKWyvtYhmm7MKYHeOULE
        KDrEQwAUXoKH+rBR8trfxnM=
X-Google-Smtp-Source: APiQypLB26qNkI5+PyvL5Jhf9reuG5n1nsrMylag7uIbwz0iZKHVwE9GsCRKLF74yQF2aFXsrRAWOg==
X-Received: by 2002:a1c:bb08:: with SMTP id l8mr12621315wmf.168.1586646383014;
        Sat, 11 Apr 2020 16:06:23 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id k133sm8992741wma.0.2020.04.11.16.06.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2020 16:06:22 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] io_uring: move all request init code in one place
Date:   Sun, 12 Apr 2020 02:05:05 +0300
Message-Id: <7c1f30a035acaae3f61ac9b0e25bb179f2d3b0f6.1586645520.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1586645520.git.asml.silence@gmail.com>
References: <cover.1586645520.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Requests initialisation is scattered across several functions, namely
io_init_req(), io_submit_sqes(), io_submit_sqe(). Put it
in io_init_req() for better data locality and code clarity.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 104 +++++++++++++++++++++++++-------------------------
 1 file changed, 52 insertions(+), 52 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9118a0210e0a..f593a37665f3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5605,44 +5605,11 @@ static inline void io_queue_link_head(struct io_kiocb *req)
 		io_queue_sqe(req, NULL);
 }
 
-#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
-				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
-				IOSQE_BUFFER_SELECT)
-
 static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 			  struct io_submit_state *state, struct io_kiocb **link)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned int sqe_flags;
-	int ret, id, fd;
-
-	sqe_flags = READ_ONCE(sqe->flags);
-
-	/* enforce forwards compatibility on users */
-	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
-		return -EINVAL;
-
-	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
-	    !io_op_defs[req->opcode].buffer_select)
-		return -EOPNOTSUPP;
-
-	id = READ_ONCE(sqe->personality);
-	if (id) {
-		req->work.creds = idr_find(&ctx->personality_idr, id);
-		if (unlikely(!req->work.creds))
-			return -EINVAL;
-		get_cred(req->work.creds);
-	}
-
-	/* same numerical values with corresponding REQ_F_*, safe to copy */
-	req->flags |= sqe_flags & (IOSQE_IO_DRAIN | IOSQE_IO_HARDLINK |
-					IOSQE_ASYNC | IOSQE_FIXED_FILE |
-					IOSQE_BUFFER_SELECT | IOSQE_IO_LINK);
-
-	fd = READ_ONCE(sqe->fd);
-	ret = io_req_set_file(state, req, fd, sqe_flags);
-	if (unlikely(ret))
-		return ret;
+	int ret;
 
 	/*
 	 * If we already have a head request, queue this one for async
@@ -5661,7 +5628,7 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		 * next after the link request. The last one is done via
 		 * drain_next flag to persist the effect across calls.
 		 */
-		if (sqe_flags & IOSQE_IO_DRAIN) {
+		if (req->flags & REQ_F_IO_DRAIN) {
 			head->flags |= REQ_F_IO_DRAIN;
 			ctx->drain_next = 1;
 		}
@@ -5678,16 +5645,16 @@ static int io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		list_add_tail(&req->link_list, &head->link_list);
 
 		/* last request of a link, enqueue the link */
-		if (!(sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK))) {
+		if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
 			io_queue_link_head(head);
 			*link = NULL;
 		}
 	} else {
 		if (unlikely(ctx->drain_next)) {
 			req->flags |= REQ_F_IO_DRAIN;
-			req->ctx->drain_next = 0;
+			ctx->drain_next = 0;
 		}
-		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
+		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
 			req->flags |= REQ_F_LINK_HEAD;
 			INIT_LIST_HEAD(&req->link_list);
 
@@ -5777,9 +5744,17 @@ static inline void io_consume_sqe(struct io_ring_ctx *ctx)
 	ctx->cached_sq_head++;
 }
 
-static void io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
-			const struct io_uring_sqe *sqe)
+#define SQE_VALID_FLAGS	(IOSQE_FIXED_FILE|IOSQE_IO_DRAIN|IOSQE_IO_LINK|	\
+				IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
+				IOSQE_BUFFER_SELECT)
+
+static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
+		       const struct io_uring_sqe *sqe,
+		       struct io_submit_state *state, bool async)
 {
+	unsigned int sqe_flags;
+	int id, fd;
+
 	/*
 	 * All io need record the previous position, if LINK vs DARIN,
 	 * it can be used to mark the position of the first IO in the
@@ -5796,7 +5771,42 @@ static void io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	refcount_set(&req->refs, 2);
 	req->task = NULL;
 	req->result = 0;
+	req->needs_fixed_file = async;
 	INIT_IO_WORK(&req->work, io_wq_submit_work);
+
+	if (unlikely(req->opcode >= IORING_OP_LAST))
+		return -EINVAL;
+
+	if (io_op_defs[req->opcode].needs_mm && !current->mm) {
+		if (unlikely(!mmget_not_zero(ctx->sqo_mm)))
+			return -EFAULT;
+		use_mm(ctx->sqo_mm);
+	}
+
+	sqe_flags = READ_ONCE(sqe->flags);
+	/* enforce forwards compatibility on users */
+	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS))
+		return -EINVAL;
+
+	if ((sqe_flags & IOSQE_BUFFER_SELECT) &&
+	    !io_op_defs[req->opcode].buffer_select)
+		return -EOPNOTSUPP;
+
+	id = READ_ONCE(sqe->personality);
+	if (id) {
+		req->work.creds = idr_find(&ctx->personality_idr, id);
+		if (unlikely(!req->work.creds))
+			return -EINVAL;
+		get_cred(req->work.creds);
+	}
+
+	/* same numerical values with corresponding REQ_F_*, safe to copy */
+	req->flags |= sqe_flags & (IOSQE_IO_DRAIN | IOSQE_IO_HARDLINK |
+					IOSQE_ASYNC | IOSQE_FIXED_FILE |
+					IOSQE_BUFFER_SELECT | IOSQE_IO_LINK);
+
+	fd = READ_ONCE(sqe->fd);
+	return io_req_set_file(state, req, fd, sqe_flags);
 }
 
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
@@ -5844,28 +5854,18 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			break;
 		}
 
-		io_init_req(ctx, req, sqe);
+		err = io_init_req(ctx, req, sqe, statep, async);
 		io_consume_sqe(ctx);
 		/* will complete beyond this point, count as submitted */
 		submitted++;
 
-		if (unlikely(req->opcode >= IORING_OP_LAST)) {
-			err = -EINVAL;
+		if (unlikely(err)) {
 fail_req:
 			io_cqring_add_event(req, err);
 			io_double_put_req(req);
 			break;
 		}
 
-		if (io_op_defs[req->opcode].needs_mm && !current->mm) {
-			if (unlikely(!mmget_not_zero(ctx->sqo_mm))) {
-				err = -EFAULT;
-				goto fail_req;
-			}
-			use_mm(ctx->sqo_mm);
-		}
-
-		req->needs_fixed_file = async;
 		trace_io_uring_submit_sqe(ctx, req->opcode, req->user_data,
 						true, async);
 		err = io_submit_sqe(req, sqe, statep, &link);
-- 
2.24.0

