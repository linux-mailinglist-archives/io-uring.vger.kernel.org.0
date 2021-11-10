Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AA5344C4A0
	for <lists+io-uring@lfdr.de>; Wed, 10 Nov 2021 16:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhKJPwc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Nov 2021 10:52:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbhKJPwb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Nov 2021 10:52:31 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E01C061764
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 07:49:43 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id z200so2635367wmc.1
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 07:49:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=97XJfVnjZ+2R7rFV2GGiGe9G5lkjQBiU/hpgqD+T1HY=;
        b=Aj4rnK3LziiTMR+r1N/iHJaH7aDOr4bReZbZ5Q99OitgBwKe+GFSfsNl64w7p7n+/L
         /FDdrpkQlV9X3Q2bWkMyxNUYwQ2XN+R0RuSA1iUIN7FxlTR737wWFRTaxQvFXRVPAnSQ
         knz4xR/u4gxZOLOQ0/OH8D94Rk6CjL1Mhz7drvZPy9HtDBIELeiZSgg3aiU1w0QJq4bg
         YpS+O2H7N6QvfQGbY6j/zrxNLkivnkCtrS9YhjEOe8OGd61ocSP0mrQqUYoqB+bHYNtS
         F3wFPPMGCOwebfvYZxNufgoNtLh1pcGlZU+FtTKdHtj+VIWZ3yvKBQ9NByjcY9O7V2U9
         UQqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=97XJfVnjZ+2R7rFV2GGiGe9G5lkjQBiU/hpgqD+T1HY=;
        b=8ApPWI08kFEQ/Xc5R/EmkwyU3mIZqKKSN/xMDnJQd4ws0ie5YgfCjE63fphNCc4VPY
         YVqcOqwbBKC7BVrGgGGAEvj0fQk8H66k2oVMCHxo1wNeLNkDDMHJuolHT76mwepDj4xb
         zw3mtcMKxTW8m1794NA4ll//Jl8Bob5zQvT6rFjNM264WG2Us+AN1dFGRPqU6S13wILt
         itFYzWKXP7Qgsw4pdBsqvUNLhTjXCk3NEiMjXByM6e6XXW3Kq/6pWAkhw+UIsQUTYe+X
         VfxtmYlaIjOJ6fmJyvEW9zYtoF151/+AmHf30pQnrJTfbnPhv14udhg2rSvcGRVSkg4e
         RYRg==
X-Gm-Message-State: AOAM530wofUxB7giR/uZDKK8zBE4gDqAcnFG2fcMw7ngCA9fZRAfDqyq
        QaVI5wDHQh1FjpU1s1mU8YzUPXr0Mhk=
X-Google-Smtp-Source: ABdhPJxZ16XA4vCdPSENgA/dMKqDUO+ZXhDtqr+GijywiJo1tBBnpo6vAOKN9SCoDJITDf9jqAj00g==
X-Received: by 2002:a1c:ed1a:: with SMTP id l26mr17936620wmh.19.1636559381996;
        Wed, 10 Nov 2021 07:49:41 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.183])
        by smtp.gmail.com with ESMTPSA id l15sm108820wme.47.2021.11.10.07.49.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 07:49:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 2/4] io_uring: add option to skip CQE posting
Date:   Wed, 10 Nov 2021 15:49:32 +0000
Message-Id: <0220fbe06f7cf99e6fc71b4297bb1cb6c0e89c2c.1636559119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636559119.git.asml.silence@gmail.com>
References: <cover.1636559119.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Emitting a CQE is expensive from the kernel perspective. Often, it's
also not convenient for the userspace, spends some cycles on processing
and just complicates the logic. A similar problems goes for linked
requests, where we post an CQE for each request in the link.

Introduce a new flags, IOSQE_CQE_SKIP_SUCCESS, trying to help with it.
When set and a request completed successfully, it won't generate a CQE.
When fails, it produces an CQE, but all following linked requests will
be CQE-less, regardless whether they have IOSQE_CQE_SKIP_SUCCESS or not.
The notion of "fail" is the same as for link failing-cancellation, where
it's opcode dependent, and _usually_ result >= 0 is a success, but not
always.

Linked timeouts are a bit special. When the requests it's linked to was
not attempted to be executed, e.g. failing linked requests, it follows
the description above. Otherwise, whether a linked timeout will post a
completion or not solely depends on IOSQE_CQE_SKIP_SUCCESS of that
linked timeout request. Linked timeout never "fail" during execution, so
for them it's unconditional. It's expected for users to not really care
about the result of it but rely solely on the result of the master
request. Another reason for such a treatment is that it's racy, and the
timeout callback may be running awhile the master request posts its
completion.

use case 1:
If one doesn't care about results of some requests, e.g. normal
timeouts, just set IOSQE_CQE_SKIP_SUCCESS. Error result will still be
posted and need to be handled.

use case 2:
Set IOSQE_CQE_SKIP_SUCCESS for all requests of a link but the last,
and it'll post a completion only for the last one if everything goes
right, otherwise there will be one only one CQE for the first failed
request.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 42 +++++++++++++++++++++++++++--------
 include/uapi/linux/io_uring.h |  4 ++++
 2 files changed, 37 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e624f3f850bd..22572cfd6864 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -106,7 +106,8 @@
 #define IORING_MAX_REG_BUFFERS	(1U << 14)
 
 #define SQE_COMMON_FLAGS (IOSQE_FIXED_FILE | IOSQE_IO_LINK | \
-			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
+			  IOSQE_IO_HARDLINK | IOSQE_ASYNC | \
+			  IOSQE_CQE_SKIP_SUCCESS)
 
 #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS|IOSQE_BUFFER_SELECT|IOSQE_IO_DRAIN)
 
@@ -721,6 +722,7 @@ enum {
 	REQ_F_HARDLINK_BIT	= IOSQE_IO_HARDLINK_BIT,
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
+	REQ_F_CQE_SKIP_BIT	= IOSQE_CQE_SKIP_SUCCESS_BIT,
 
 	/* first byte is taken by user flags, shift it to not overlap */
 	REQ_F_FAIL_BIT		= 8,
@@ -737,6 +739,7 @@ enum {
 	REQ_F_REFCOUNT_BIT,
 	REQ_F_ARM_LTIMEOUT_BIT,
 	REQ_F_ASYNC_DATA_BIT,
+	REQ_F_SKIP_LINK_CQES_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
@@ -758,6 +761,8 @@ enum {
 	REQ_F_FORCE_ASYNC	= BIT(REQ_F_FORCE_ASYNC_BIT),
 	/* IOSQE_BUFFER_SELECT */
 	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
+	/* IOSQE_CQE_SKIP_SUCCESS */
+	REQ_F_CQE_SKIP		= BIT(REQ_F_CQE_SKIP_BIT),
 
 	/* fail rest of links */
 	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
@@ -791,6 +796,8 @@ enum {
 	REQ_F_ARM_LTIMEOUT	= BIT(REQ_F_ARM_LTIMEOUT_BIT),
 	/* ->async_data allocated */
 	REQ_F_ASYNC_DATA	= BIT(REQ_F_ASYNC_DATA_BIT),
+	/* don't post CQEs while failing linked requests */
+	REQ_F_SKIP_LINK_CQES	= BIT(REQ_F_SKIP_LINK_CQES_BIT),
 };
 
 struct async_poll {
@@ -1301,6 +1308,10 @@ static inline bool req_has_async_data(struct io_kiocb *req)
 static inline void req_set_fail(struct io_kiocb *req)
 {
 	req->flags |= REQ_F_FAIL;
+	if (req->flags & REQ_F_CQE_SKIP) {
+		req->flags &= ~REQ_F_CQE_SKIP;
+		req->flags |= REQ_F_SKIP_LINK_CQES;
+	}
 }
 
 static inline void req_fail_link_node(struct io_kiocb *req, int res)
@@ -1843,7 +1854,8 @@ static inline bool __io_fill_cqe(struct io_ring_ctx *ctx, u64 user_data,
 
 static noinline void io_fill_cqe_req(struct io_kiocb *req, s32 res, u32 cflags)
 {
-	__io_fill_cqe(req->ctx, req->user_data, res, cflags);
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		__io_fill_cqe(req->ctx, req->user_data, res, cflags);
 }
 
 static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
@@ -1859,7 +1871,8 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res,
 	struct io_ring_ctx *ctx = req->ctx;
 
 	spin_lock(&ctx->completion_lock);
-	__io_fill_cqe(ctx, req->user_data, res, cflags);
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		__io_fill_cqe(ctx, req->user_data, res, cflags);
 	/*
 	 * If we're the last reference to this request, add to our locked
 	 * free_list cache.
@@ -2067,6 +2080,7 @@ static bool io_kill_linked_timeout(struct io_kiocb *req)
 		link->timeout.head = NULL;
 		if (hrtimer_try_to_cancel(&io->timer) != -1) {
 			list_del(&link->timeout.list);
+			/* leave REQ_F_CQE_SKIP to io_fill_cqe_req */
 			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			return true;
@@ -2079,6 +2093,7 @@ static void io_fail_links(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
 	struct io_kiocb *nxt, *link = req->link;
+	bool ignore_cqes = req->flags & REQ_F_SKIP_LINK_CQES;
 
 	req->link = NULL;
 	while (link) {
@@ -2091,7 +2106,10 @@ static void io_fail_links(struct io_kiocb *req)
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
-		io_fill_cqe_req(link, res, 0);
+		if (!ignore_cqes) {
+			link->flags &= ~REQ_F_CQE_SKIP;
+			io_fill_cqe_req(link, res, 0);
+		}
 		io_put_req_deferred(link);
 		link = nxt;
 	}
@@ -2108,6 +2126,7 @@ static bool io_disarm_next(struct io_kiocb *req)
 		req->flags &= ~REQ_F_ARM_LTIMEOUT;
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
+			/* leave REQ_F_CQE_SKIP to io_fill_cqe_req */
 			io_fill_cqe_req(link, -ECANCELED, 0);
 			io_put_req_deferred(link);
 			posted = true;
@@ -2372,8 +2391,9 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 		struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
 
-		__io_fill_cqe(ctx, req->user_data, req->result,
-			      req->cflags);
+		if (!(req->flags & REQ_F_CQE_SKIP))
+			__io_fill_cqe(ctx, req->user_data, req->result,
+				      req->cflags);
 	}
 	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
@@ -2503,12 +2523,14 @@ static int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	prev = start;
 	wq_list_for_each_resume(pos, prev) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
+		u32 cflags;
 
 		/* order with io_complete_rw_iopoll(), e.g. ->result updates */
 		if (!smp_load_acquire(&req->iopoll_completed))
 			break;
-		__io_fill_cqe(ctx, req->user_data, req->result,
-			      io_put_rw_kbuf(req));
+		cflags = io_put_rw_kbuf(req);
+		if (!(req->flags & REQ_F_CQE_SKIP))
+			__io_fill_cqe(ctx, req->user_data, req->result, cflags);
 		nr_events++;
 	}
 
@@ -5828,6 +5850,8 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	flags = READ_ONCE(sqe->len);
 	if (flags & ~IORING_POLL_ADD_MULTI)
 		return -EINVAL;
+	if ((flags & IORING_POLL_ADD_MULTI) && (req->flags & REQ_F_CQE_SKIP))
+		return -EINVAL;
 
 	io_req_set_refcount(req);
 	poll->events = io_poll_parse_events(sqe, flags);
@@ -10438,7 +10462,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 			IORING_FEAT_CUR_PERSONALITY | IORING_FEAT_FAST_POLL |
 			IORING_FEAT_POLL_32BITS | IORING_FEAT_SQPOLL_NONFIXED |
 			IORING_FEAT_EXT_ARG | IORING_FEAT_NATIVE_WORKERS |
-			IORING_FEAT_RSRC_TAGS;
+			IORING_FEAT_RSRC_TAGS | IORING_FEAT_CQE_SKIP;
 
 	if (copy_to_user(params, p, sizeof(*p))) {
 		ret = -EFAULT;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index c45b5e9a9387..787f491f0d2a 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -70,6 +70,7 @@ enum {
 	IOSQE_IO_HARDLINK_BIT,
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
+	IOSQE_CQE_SKIP_SUCCESS_BIT,
 };
 
 /*
@@ -87,6 +88,8 @@ enum {
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
 /* select buffer from sqe->buf_group */
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
+/* don't post CQE if request succeeded */
+#define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
 
 /*
  * io_uring_setup() flags
@@ -289,6 +292,7 @@ struct io_uring_params {
 #define IORING_FEAT_EXT_ARG		(1U << 8)
 #define IORING_FEAT_NATIVE_WORKERS	(1U << 9)
 #define IORING_FEAT_RSRC_TAGS		(1U << 10)
+#define IORING_FEAT_CQE_SKIP		(1U << 11)
 
 /*
  * io_uring_register(2) opcodes and arguments
-- 
2.33.1

