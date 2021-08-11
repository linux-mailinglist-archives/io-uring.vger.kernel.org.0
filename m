Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD27E3E97A5
	for <lists+io-uring@lfdr.de>; Wed, 11 Aug 2021 20:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhHKS3g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Aug 2021 14:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbhHKS3g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Aug 2021 14:29:36 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE9AC061765
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 11:29:12 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id k38-20020a05600c1ca6b029025af5e0f38bso5082699wms.5
        for <io-uring@vger.kernel.org>; Wed, 11 Aug 2021 11:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=74ouj1ln5E2KdceXQIdCiGETqRMH5e5DUG2usbnprbg=;
        b=XFRWy087UcWt8JqLx0e7AQ0l7N5byWye6WIgQ7QNPj35z4Q9WQiHkIvYR/W7jB91Tj
         jsEqq1jj12Pvb9S+ROMUiIycf1eTl57W1QtmYNN5ypabtXxu3svPb8wdj1KXQ8/pMRIy
         SIuPlL26otezsNKVxOCW9VnRZs0h/25++A8uPwUlgNQuAl4SEgVIQeWXCPJZlhTCaUuJ
         hNw4/+txbte6aMQuaotlpLE0G9kazZhFL2pieZ5TuIdv74PwOeYY4TVTH/XKk9KrxxRR
         DKOGWl3TPnViWQm7IcZ/hJ+kDR9Of2V60qhe4YqMM7b74VSLknCLju9oUpfn+QQIhFTm
         9uPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=74ouj1ln5E2KdceXQIdCiGETqRMH5e5DUG2usbnprbg=;
        b=ukXjEMrWN3fLeUF2PsTZIv2jlTcG9NTfZWjQxdcejsa99+kPESdVZUd6hSy/SvQVVa
         g4JP8WA7mEOLb/TyA1HSbwnDTEVrqjo4Kp/yf2k/ez57BttQRFxqSojILo7Ks0liyJPn
         I4bCUmHVHqedjr2+kR2YAB2HOZXhmiloMe8hTH5NkpyIyN81X/cH1v10tGI8deHBKiBM
         cptmVij0RID8b0NBww6xGuWLzS8TvuLtsD4K+p3VjnwALi9N0Rg33jTImVNsjE7hQLoG
         3IO6JWvbq7R28uGDTfRryOQwx0Y83ULIipfaMjIkfiFJWTUoxkoeldf+wApT89IqP+Jf
         /opQ==
X-Gm-Message-State: AOAM5311QY2Wy3xjAk/32Uaes4ee9FSK2akvLoWih/cs8F1lRa6TVmG1
        jRVfqLv0O3aGLvm9julOcOakTWLB2Wc=
X-Google-Smtp-Source: ABdhPJzJzxSRL0mOdEEJIFViE0buALkH3Sqvi9Zu0kqZB4SrcTUMz9cArL1L+6AeHJCI+rTN8VNvGA==
X-Received: by 2002:a1c:7203:: with SMTP id n3mr11668472wmc.45.1628706550960;
        Wed, 11 Aug 2021 11:29:10 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id 129sm867wmz.26.2021.08.11.11.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Aug 2021 11:29:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 3/5] io_uring: remove submission references
Date:   Wed, 11 Aug 2021 19:28:29 +0100
Message-Id: <6b68f1c763229a590f2a27148aee77767a8d7750.1628705069.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628705069.git.asml.silence@gmail.com>
References: <cover.1628705069.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Requests are by default given with two references, submission and
completion. Completion references are straightforward, they represent
request ownership and are put when a request is completed or so.
Submission references are a bit more trickier. They're needed when
io_issue_sqe() followed deep into the submission stack (e.g. in fs,
block, drivers, etc.), request may have given away for concurrent
execution or already completed, and the code unwinding back to
io_issue_sqe() may be accessing some pieces of our requests, e.g.
file or iov.

Now, we prevent such async/in-depth completions by pushing requests
through task_work. Punting to io-wq is also done through task_works,
apart from a couple of cases with a pretty well known context. So,
there're two cases:
1) io_issue_sqe() from the task context and protected by ->uring_lock.
Either requests return back to io_uring or handed to task_work, which
won't be executed because we're currently controlling that task. So,
we can be sure that requests are staying alive all the time and we don't
need submission references to pin them.

2) io_issue_sqe() from io-wq, which doesn't hold the mutex. The role of
submission reference is played by io-wq reference, which is put by
io_wq_submit_work(). Hence, it should be fine.

Considering that, we can carefully kill the submission reference.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 37 ++++++++++++++-----------------------
 1 file changed, 14 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f2aa26ba34f7..9529dae2c46e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1699,7 +1699,6 @@ static inline void io_req_complete(struct io_kiocb *req, long res)
 static void io_req_complete_failed(struct io_kiocb *req, long res)
 {
 	req_set_fail(req);
-	io_put_req(req);
 	io_req_complete_post(req, res, 0);
 }
 
@@ -1754,7 +1753,14 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
 	return nr != 0;
 }
 
+/*
+ * A request might get retired back into the request caches even before opcode
+ * handlers and io_issue_sqe() are done with it, e.g. inline completion path.
+ * Because of that, io_alloc_req() should be called only under ->uring_lock
+ * and with extra caution to not get a request that is still worked on.
+ */
 static struct io_kiocb *io_alloc_req(struct io_ring_ctx *ctx)
+	__must_hold(&req->ctx->uring_lock)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
@@ -1869,8 +1875,6 @@ static void io_fail_links(struct io_kiocb *req)
 
 		trace_io_uring_fail_link(req, link);
 		io_cqring_fill_event(link->ctx, link->user_data, -ECANCELED, 0);
-
-		io_put_req(link);
 		io_put_req_deferred(link);
 		link = nxt;
 	}
@@ -2151,8 +2155,6 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 	for (i = 0; i < nr; i++) {
 		struct io_kiocb *req = state->compl_reqs[i];
 
-		/* submission and completion refs */
-		io_put_req(req);
 		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
@@ -2257,7 +2259,6 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (READ_ONCE(req->result) == -EAGAIN && resubmit &&
 		    !(req->flags & REQ_F_DONT_REISSUE)) {
 			req->iopoll_completed = 0;
-			req_ref_get(req);
 			io_req_task_queue_reissue(req);
 			continue;
 		}
@@ -2755,7 +2756,6 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	if (check_reissue && (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req)) {
-			req_ref_get(req);
 			io_req_task_queue_reissue(req);
 		} else {
 			int cflags = 0;
@@ -3181,9 +3181,6 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 
 	req->rw.kiocb.ki_flags &= ~IOCB_WAITQ;
 	list_del_init(&wait->entry);
-
-	/* submit ref gets dropped, acquire a new one */
-	req_ref_get(req);
 	io_req_task_queue(req);
 	return 1;
 }
@@ -5235,10 +5232,6 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0);
 		io_commit_cqring(req->ctx);
 		req_set_fail(req);
-
-		/* non-poll requests have submit ref still */
-		if (req->opcode != IORING_OP_POLL_ADD)
-			io_put_req(req);
 		io_put_req_deferred(req);
 	}
 	return do_complete;
@@ -6273,6 +6266,9 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	struct io_kiocb *timeout;
 	int ret = 0;
 
+	/* will be dropped by ->io_free_work() after returning to io-wq */
+	req_ref_get(req);
+
 	timeout = io_prep_linked_timeout(req);
 	if (timeout)
 		io_queue_linked_timeout(timeout);
@@ -6295,11 +6291,8 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	}
 
 	/* avoid locking problems by failing it from a clean context */
-	if (ret) {
-		/* io-wq is going to take one down */
-		req_ref_get(req);
+	if (ret)
 		io_req_task_queue_fail(req, ret);
-	}
 }
 
 static inline struct io_fixed_file *io_fixed_file_slot(struct io_file_table *table,
@@ -6441,6 +6434,8 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 	    nxt->opcode != IORING_OP_LINK_TIMEOUT)
 		return NULL;
 
+	/* linked timeouts should have two refs once prep'ed */
+	req_ref_get(nxt);
 	nxt->timeout.head = req;
 	nxt->flags |= REQ_F_LTIMEOUT_ACTIVE;
 	req->flags |= REQ_F_LINK_TIMEOUT;
@@ -6461,7 +6456,6 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	 * doesn't support non-blocking read/write attempts
 	 */
 	if (likely(!ret)) {
-		/* drop submission reference */
 		if (req->flags & REQ_F_COMPLETE_INLINE) {
 			struct io_ring_ctx *ctx = req->ctx;
 			struct io_submit_state *state = &ctx->submit_state;
@@ -6469,8 +6463,6 @@ static void __io_queue_sqe(struct io_kiocb *req)
 			state->compl_reqs[state->compl_nr++] = req;
 			if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
 				io_submit_flush_completions(ctx);
-		} else {
-			io_put_req(req);
 		}
 	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
 		switch (io_arm_poll_handler(req)) {
@@ -6550,8 +6542,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->user_data = READ_ONCE(sqe->user_data);
 	req->file = NULL;
 	req->fixed_rsrc_refs = NULL;
-	/* one is dropped after submission, the other at completion */
-	atomic_set(&req->refs, 2);
+	atomic_set(&req->refs, 1);
 	req->task = current;
 
 	/* enforce forwards compatibility on users */
-- 
2.32.0

