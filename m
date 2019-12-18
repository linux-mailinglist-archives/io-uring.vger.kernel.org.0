Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFC56123DF1
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 04:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726463AbfLRD2P (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 17 Dec 2019 22:28:15 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36884 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbfLRD2P (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 17 Dec 2019 22:28:15 -0500
Received: by mail-pf1-f195.google.com with SMTP id p14so409297pfn.4
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2019 19:28:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lioPE6FoRJbrwE2alLJXJhQBEaxOfYEKJhjL5AJxI0Y=;
        b=0rOfs5pYrkLDPtNtDTO8m1CrY2/27ifTilsyFQd3OrXjADE72r4R+PoODYss/0Uc+A
         G8LHccNKcAZGc1HAQxh0aBdW5n39rVD6H8hQCK7NcqAVHfP568q43/kVcGTsXiw9FOaJ
         YTgNjfHZG7egmqnXdY57+vwCj5LBmhSVdEiy/yeRX1t/3HBvWyrX8CO0wi/yy6RyKHXh
         kISAjv05ns+1wMoB6tiBSuXZobvdzDiRBDCHVDbaSHAc2qzVdsKzJqe+BXqaWhGfOi4R
         Obm6rZakkVTujhYOmQWdvQ+h/mAHhuzyV2QuF7mY4eHtyfSFLXiw5ws+wi9gZPSIM/Bc
         6oaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lioPE6FoRJbrwE2alLJXJhQBEaxOfYEKJhjL5AJxI0Y=;
        b=alkU5QGHFSEdAdBnS9AJXMDw69aeLRTpsgREg3pdxEEL7cya3RdwzgWrqKCEu3rFB1
         6+AulkK3+/zRxJo27RKo/hI4ImYMnnuWn8MX3oa2CvyJN40YWAmaP9UXsXFY+133sfJH
         LaEQpCKmNL4egwid4dEZa+xBLlt2ftlNPBVgcB7ylz0Aj4lZ2jSuv9+GihMAXCmn1Rr0
         sROfjmp6fkj616oAkilXoRBVk4ksHb3UHPHxg8ZEQwLNSfAvQ5sxMXFgnDSQRGmJeTfP
         QUGp1MEehikFpBoIahD1Ib6rmPtiU5I/++FX2L5Iy8KeH1cub78hQiBxq1yZ5vCYYfCX
         TEHQ==
X-Gm-Message-State: APjAAAXO2S0EtNYxn80bVJkEv30sQl46lMxWRyJvw9OIZXZCGmTPhRHK
        nTX92v6A9lViC902Y3s+Fdxz088uJzZE0Q==
X-Google-Smtp-Source: APXvYqy0Je4UTFwvgT7SNbvaBo+O/FyMGWAXM/o90nvD4VgTcn0e9GoRgmKZJeV3kTqR5SCPJFCMJg==
X-Received: by 2002:a63:ea4b:: with SMTP id l11mr317238pgk.357.1576639694099;
        Tue, 17 Dec 2019 19:28:14 -0800 (PST)
Received: from x1.thefacebook.com ([66.219.217.145])
        by smtp.gmail.com with ESMTPSA id g17sm596323pfb.180.2019.12.17.19.28.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 19:28:13 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/11] io_uring: read opcode and user_data from SQE exactly once
Date:   Tue, 17 Dec 2019 20:27:58 -0700
Message-Id: <20191218032759.13587-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218032759.13587-1-axboe@kernel.dk>
References: <20191218032759.13587-1-axboe@kernel.dk>
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
 fs/io_uring.c | 43 +++++++++++++++++++------------------------
 1 file changed, 19 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 45d2090484a7..5dabe0a59221 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -385,6 +385,7 @@ struct io_kiocb {
 	bool				has_user;
 	bool				in_async;
 	bool				needs_fixed_file;
+	u8				opcode;
 
 	struct io_ring_ctx	*ctx;
 	union {
@@ -598,12 +599,10 @@ static void __io_commit_cqring(struct io_ring_ctx *ctx)
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
@@ -612,7 +611,7 @@ static inline bool io_prep_async_work(struct io_kiocb *req,
 	bool do_hashed = false;
 
 	if (req->sqe) {
-		switch (req->sqe->opcode) {
+		switch (req->opcode) {
 		case IORING_OP_WRITEV:
 		case IORING_OP_WRITE_FIXED:
 			/* only regular files should be hashed for writes */
@@ -635,7 +634,7 @@ static inline bool io_prep_async_work(struct io_kiocb *req,
 				req->work.flags |= IO_WQ_WORK_UNBOUND;
 			break;
 		}
-		if (io_sqe_needs_user(req->sqe))
+		if (io_req_needs_user(req))
 			req->work.flags |= IO_WQ_WORK_NEEDS_USER;
 	}
 
@@ -1009,7 +1008,7 @@ static void io_fail_links(struct io_kiocb *req)
 		trace_io_uring_fail_link(req, link);
 
 		if ((req->flags & REQ_F_LINK_TIMEOUT) &&
-		    link->sqe->opcode == IORING_OP_LINK_TIMEOUT) {
+		    link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_link_cancel_timeout(link);
 		} else {
 			io_cqring_fill_event(link, -ECANCELED);
@@ -1652,7 +1651,7 @@ static ssize_t io_import_iovec(int rw, struct io_kiocb *req,
 	 * for that purpose and instead let the caller pass in the read/write
 	 * flag.
 	 */
-	opcode = READ_ONCE(sqe->opcode);
+	opcode = req->opcode;
 	if (opcode == IORING_OP_READ_FIXED || opcode == IORING_OP_WRITE_FIXED) {
 		*iovec = NULL;
 		return io_import_fixed(req->ctx, rw, sqe, iter);
@@ -3176,11 +3175,10 @@ __attribute__((nonnull))
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
@@ -3317,11 +3315,9 @@ static bool io_req_op_valid(int op)
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
@@ -3330,7 +3326,7 @@ static int io_op_needs_file(const struct io_uring_sqe *sqe)
 	case IORING_OP_LINK_TIMEOUT:
 		return 0;
 	default:
-		if (io_req_op_valid(op))
+		if (io_req_op_valid(req->opcode))
 			return 1;
 		return -EINVAL;
 	}
@@ -3357,7 +3353,7 @@ static int io_req_set_file(struct io_submit_state *state, struct io_kiocb *req)
 	if (flags & IOSQE_IO_DRAIN)
 		req->flags |= REQ_F_IO_DRAIN;
 
-	ret = io_op_needs_file(req->sqe);
+	ret = io_req_needs_file(req);
 	if (ret <= 0)
 		return ret;
 
@@ -3477,7 +3473,7 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 
 	nxt = list_first_entry_or_null(&req->link_list, struct io_kiocb,
 					link_list);
-	if (!nxt || nxt->sqe->opcode != IORING_OP_LINK_TIMEOUT)
+	if (!nxt || nxt->opcode != IORING_OP_LINK_TIMEOUT)
 		return NULL;
 
 	req->flags |= REQ_F_LINK_TIMEOUT;
@@ -3579,8 +3575,6 @@ static bool io_submit_sqe(struct io_kiocb *req, struct io_submit_state *state,
 	struct io_ring_ctx *ctx = req->ctx;
 	int ret;
 
-	req->user_data = req->sqe->user_data;
-
 	/* enforce forwards compatibility on users */
 	if (unlikely(req->sqe->flags & ~SQE_VALID_FLAGS)) {
 		ret = -EINVAL;
@@ -3712,6 +3706,8 @@ static bool io_get_sqring(struct io_ring_ctx *ctx, struct io_kiocb *req)
 		 */
 		req->sequence = ctx->cached_sq_head;
 		req->sqe = &ctx->sq_sqes[head];
+		req->opcode = READ_ONCE(req->sqe->opcode);
+		req->user_data = READ_ONCE(req->sqe->user_data);
 		ctx->cached_sq_head++;
 		return true;
 	}
@@ -3757,7 +3753,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 			break;
 		}
 
-		if (io_sqe_needs_user(req->sqe) && !*mm) {
+		if (io_req_needs_user(req) && !*mm) {
 			mm_fault = mm_fault || !mmget_not_zero(ctx->sqo_mm);
 			if (!mm_fault) {
 				use_mm(ctx->sqo_mm);
@@ -3773,8 +3769,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
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

