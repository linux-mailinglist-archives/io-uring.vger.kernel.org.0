Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 844A8124EF3
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbfLRRSy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:54 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:40406 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:54 -0500
Received: by mail-io1-f65.google.com with SMTP id x1so2772968iop.7
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mOTsl64kS0GoAPd5KE7DbdtsnbQ7M0h7DZKd1Rj01Cg=;
        b=2TZ9yKAUL27Ze5t1IFKPUhgAAhH9dkTgRX21WQD4MxHgeQQmVmTXYzs63GJT9Glcmf
         gpY0v3Pho7Fu9o5CueTudGt9ZYKprwfyN1aG3H0pmzCvlCBzkHrB5qiRlldG+FwYl0xP
         qI7u3gErTtW8DDx9oWXsYdKTSPFntNPNL6V+L+lw2qHBWz8qTfxrO7HxlMvuNRsyGtpw
         JKQPqHZAXJUDNprosmWzsVDCrdus4CPb4rzop2Vd4VHF45QSISFRTd9DPC+NRWGMQ9Fa
         yVV3UUEZe4iAbX2o6JaQ21WTLbgX0YTBULQWyiBoHwirGMDMuVEsrHJlXbToH9voBnw7
         tBgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mOTsl64kS0GoAPd5KE7DbdtsnbQ7M0h7DZKd1Rj01Cg=;
        b=X/pgTSakd4ZmVLldxs8//erG7HsqfSH4RM4dK71ZDP+tny22TeeWjEuePsVCsEXLMA
         zCiPuqtB8swbzglZ9U2skTOGqSVruD5jqZDZY2WVsQhOHnGA2ge19t7iJFYquPm5pRHN
         30ySD5iSk3YviK1JMoqfGbLdQVQ+P5PC34YWVOOlHN9qlYmUzV8Pxt35WMUQ6bofTtAI
         o4LzgppMbf7so6vr6y9nlCqG+gTnJGCKOsK1hU7ZNH/mEzGiohJftNAIQWR1FoWTbuRf
         bwwynH67ZdSLnJjCL5HozuYLUt4e15B1SLmWeHLboeEm51+BAX9mTZOtiYnfH+i52wgX
         +9HQ==
X-Gm-Message-State: APjAAAWfjDJhiEzTJwhFgyorg0w+GQePYCvobS1OhcqhhLY79cBb0KIb
        87h/wEhIUy6rO34lcaS2VBFukxczClTMwA==
X-Google-Smtp-Source: APXvYqwJkuPwb+h+NQMVXVqM2BzbIFXOLoXCLpyWGUodNCgNtkv2vX+8z9XB7s6tR/7rrFhpjFiN/A==
X-Received: by 2002:a5e:940e:: with SMTP id q14mr2332223ioj.247.1576689532881;
        Wed, 18 Dec 2019 09:18:52 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:52 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/13] io_uring: read opcode and user_data from SQE exactly once
Date:   Wed, 18 Dec 2019 10:18:33 -0700
Message-Id: <20191218171835.13315-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218171835.13315-1-axboe@kernel.dk>
References: <20191218171835.13315-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we defer a request, we can't be reading the opcode again. Ensure that
the user_data and opcode fields are stable. For the user_data we already
have a place for it, for the opcode we can fill a one byte hold and store
that as well. For both of them, assign them when we originally read the
SQE in io_get_sqring(). Any code that uses sqe->opcode or sqe->user_data
is switched to req->opcode and req->user_data.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 45 ++++++++++++++++++++-------------------------
 1 file changed, 20 insertions(+), 25 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c269229e45ef..9f10f5a9da8d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -384,6 +384,7 @@ struct io_kiocb {
 	bool				has_user;
 	bool				in_async;
 	bool				needs_fixed_file;
+	u8				opcode;
 
 	struct io_ring_ctx	*ctx;
 	union {
@@ -597,12 +598,10 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
 	}
 }
 
-static inline bool io_sqe_needs_user(const struct io_uring_sqe *sqe)
+static inline bool io_req_needs_user(struct io_kiocb *req)
 {
-	u8 opcode = READ_ONCE(sqe->opcode);
-
-	return !(opcode == IORING_OP_READ_FIXED ||
-		 opcode == IORING_OP_WRITE_FIXED);
+	return !(req->opcode == IORING_OP_READ_FIXED ||
+		 req->opcode == IORING_OP_WRITE_FIXED);
 }
 
 static inline bool io_prep_async_work(struct io_kiocb *req,
@@ -611,7 +610,7 @@ static inline bool io_prep_async_work(struct io_kiocb *req,
 	bool do_hashed = false;
 
 	if (req->sqe) {
-		switch (req->sqe->opcode) {
+		switch (req->opcode) {
 		case IORING_OP_WRITEV:
 		case IORING_OP_WRITE_FIXED:
 			/* only regular files should be hashed for writes */
@@ -634,7 +633,7 @@ static inline bool io_prep_async_work(struct io_kiocb *req,
 				req->work.flags |= IO_WQ_WORK_UNBOUND;
 			break;
 		}
-		if (io_sqe_needs_user(req->sqe))
+		if (io_req_needs_user(req))
 			req->work.flags |= IO_WQ_WORK_NEEDS_USER;
 	}
 
@@ -1005,7 +1004,7 @@ static void io_fail_links(struct io_kiocb *req)
 		trace_io_uring_fail_link(req, link);
 
 		if ((req->flags & REQ_F_LINK_TIMEOUT) &&
-		    link->sqe->opcode == IORING_OP_LINK_TIMEOUT) {
+		    link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_link_cancel_timeout(link);
 		} else {
 			io_cqring_fill_event(link, -ECANCELED);
@@ -1648,7 +1647,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	 * for that purpose and instead let the caller pass in the read/write
 	 * flag.
 	 */
-	opcode = READ_ONCE(sqe->opcode);
+	opcode = req->opcode;
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
 		*iovec = NULL;
 		return io_import_fixed(req->ctx, rw, sqe, iter);
@@ -3080,7 +3079,7 @@ static int io_req_defer_prep(struct io_kiocb *req)
 	struct iov_iter iter;
 	ssize_t ret;
 
-	switch (io->sqe.opcode) {
+	switch (req->opcode) {
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 		/* ensure prep does right import */
@@ -3179,11 +3178,10 @@ __attribute__((nonnull))
 static int io_issue_sqe(struct io_kiocb *req, struct io_kiocb **nxt,
 			bool force_nonblock)
 {
-	int ret, opcode;
 	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
 
-	opcode = READ_ONCE(req->sqe->opcode);
-	switch (opcode) {
+	switch (req->opcode) {
 	case IORING_OP_NOP:
 		ret = io_nop(req);
 		break;
@@ -3320,11 +3318,9 @@ static bool io_req_op_valid(int op)
 	return op >= IORING_OP_NOP && op < IORING_OP_LAST;
 }
 
-static int io_op_needs_file(const struct io_uring_sqe *sqe)
+static int io_req_needs_file(struct io_kiocb *req)
 {
-	int op = READ_ONCE(sqe->opcode);
-
-	switch (op) {
+	switch (req->opcode) {
 	case IORING_OP_NOP:
 	case IORING_OP_POLL_REMOVE:
 	case IORING_OP_TIMEOUT:
@@ -3333,7 +3329,7 @@ static int io_op_needs_file(const struct io_uring_sqe *sqe)
 	case IORING_OP_LINK_TIMEOUT:
 		return 0;
 	default:
-		if (io_req_op_valid(op))
+		if (io_req_op_valid(req->opcode))
 			return 1;
 		return -EINVAL;
 	}
@@ -3360,7 +3356,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
 	if (flags & IOSQE_IO_DRAIN)
 		req->flags |= REQ_F_IO_DRAIN;
 
-	ret = io_op_needs_file(req->sqe);
+	ret = io_req_needs_file(req);
 	if (ret <= 0)
 		return ret;
 
@@ -3480,7 +3476,7 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 
 	nxt = list_first_entry_or_null(&req->link_list, struct io_kiocb,
 					link_list);
-	if (!nxt || nxt->sqe->opcode != IORING_OP_LINK_TIMEOUT)
+	if (!nxt || nxt->opcode != IORING_OP_LINK_TIMEOUT)
 		return NULL;
 
 	req->flags |= REQ_F_LINK_TIMEOUT;
@@ -3582,8 +3578,6 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	req->user_data = req->sqe->user_data;
-
 	/* enforce forwards compatibility on users */
 	if (unlikely(req->sqe->flags & ~SQE_VALID_FLAGS)) {
 		ret = -EINVAL;
@@ -3715,6 +3709,8 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req)
 		 */
 		req->sequence = ctx->cached_sq_head;
 		req->sqe = &ctx->sq_sqes[head];
+		req->opcode = READ_ONCE(req->sqe->opcode);
+		req->user_data = READ_ONCE(req->sqe->user_data);
 		ctx->cached_sq_head++;
 		return true;
 	}
@@ -3760,7 +3756,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			break;
 		}
 
-		if (io_sqe_needs_user(req->sqe) && !*mm) {
+		if (io_req_needs_user(req) && !*mm) {
 			mm_fault = mm_fault || !mmget_not_zero(ctx->sqo_mm);
 			if (!mm_fault) {
 				use_mm(ctx->sqo_mm);
@@ -3776,8 +3772,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		req->has_user = *mm != NULL;
 		req->in_async = async;
 		req->needs_fixed_file = async;
-		trace_io_uring_submit_sqe(ctx, req->sqe->user_data,
-					  true, async);
+		trace_io_uring_submit_sqe(ctx, req->user_data, true, async);
 		if (!io_submit_sqe(req, statep, &link))
 			break;
 		/*
-- 
2.24.1

