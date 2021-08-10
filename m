Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9D383E59A0
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 14:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240276AbhHJMG7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 08:06:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238600AbhHJMG6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 08:06:58 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83B4C0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 05:06:36 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id u15so12874307wmj.1
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 05:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9boVtjXZaD4dN3Z5/BnMxfwwpw+RnrX0QUmxVpOD6+w=;
        b=PAwxxUvlg5UzXs3tXfOPODi5mUofmTDG3xd28I+V7uAZC4b6ytQ0/oY1frWchMtjgM
         Shx/W2CJ/Ewrm0XTF0ZF+MKsIflY4aNHRx2yn4dO6sd7xj4adeDUxxhvEydSj8L4SVj6
         0RcnsafBJQ5Ykp2CMIGPZnGV8+BdufJBuu879oBSzn/urL4bCAKrZiB1jBS39ObuZuec
         uWWnmOAZz7YRLG5HmBJmvyVvATnXP9Xpvo1GcDxLKs5xiofBGpuuNA2JqozZFX9pxtBI
         E+Py8dmLjdsIaztU4LXIAmVj7z477USnmvd14Jw98NnMOqZv6tWe0LYPfR/PJCi0dzOw
         Ys3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9boVtjXZaD4dN3Z5/BnMxfwwpw+RnrX0QUmxVpOD6+w=;
        b=OSi8NYTNDL+x0IbI8OeECsOb4aW2ICqf8OXCXog1+moa5xOHKIZO/5cNDXQl7Rknl+
         S70aLQvp02/gewoLMGBbpDCRly2vWMuU5ef7K9WCqN0JMG6328lZ3xpVJBkJEDWZrTju
         ei471aSOU1pZCsINidtLRzISZ8QA2chH6y97G5RyWTaI3AB5Mzr5CSZd9t45cK/LIc+p
         PdAAJ2YRCFGRmRhIDYDId1Ownd+O0pqDvPpSSNvPfq2uUvEhdt86Z7/fFbcW0Fyf0f7Y
         /1reeu3XesFQAZNJw19rfaxrtyr6S3hWP8ZDyM3Gh+ZL6wt14My7VqLo4Xryr/YamMds
         7CrQ==
X-Gm-Message-State: AOAM532d8f1Q8X7dvpqePSxuKVIqATMHfg3K24AUeJxUJ7SsQ4Cng26t
        cooBYV/HrXKW78S9SJ5tGsA=
X-Google-Smtp-Source: ABdhPJyKc0eDRv+7O8zFLLTyumTKCPL3rvO/nu0TvKJR99aZmVnF6YkbrRbDsm6EC2S/czO5LtGgFw==
X-Received: by 2002:a7b:cb53:: with SMTP id v19mr21566739wmj.127.1628597194415;
        Tue, 10 Aug 2021 05:06:34 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id d15sm24954362wri.96.2021.08.10.05.06.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:06:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/5] io_uring: request refcounting skipping
Date:   Tue, 10 Aug 2021 13:05:54 +0100
Message-Id: <e0fcda22da389d2cbc1068f857fb01d68c9ddfb7.1628595748.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628595748.git.asml.silence@gmail.com>
References: <cover.1628595748.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The intention here is to skip request refcounting in most hot cases,
and use only when it's really needed. So, it should save 2 refcount
atomics per request for IOPOLL and IRQ completions, and 1 atomic per
req for inline completions.

There are cases, however, where the refcounting is enabled back:
- Polling, including apoll. Because double poll entries takes a ref.
  Might get relaxed in the near future.
- Link timeouts, for both, the timeout and the request it's bound to,
  because they work in-parallel and we need to synchronise to cancel one
  of them on completion.
- When in io-wq, because it doesn't hold uring_lock, so the guarantees
  described below doesn't work, and there is also io_wq_free_work().

TL;DR;
Requests were always given with two references. One is called completion
and is generally put at the moment I/O is completed. The second is
submission reference, which is usually put during submission, e.g. by
__io_queue_sqe(). It was needed, because the code actually issuing a
request (e.g. fs, the block layer, etc.), may punt it for async
execution, but still access associated memory while unwinding back to
io_uring.

First, let's notice that now all requests are returned back into the
request cache and not actually kfreed(). Also, we take requests out of
it only under ->uring_lock. So, if I/O submission is also protected by
the mutex, and even if io_issue_sqe() completes a request deep down the
stack, the memory is not going to be freed and the request won't be
re-allocated until the submission stack unwinds back and we unlock
the mutex. If it's not protected by the mutex, we're in io-wq, which
takes a reference anyway resembling submission referencing.

Same with other parts that may get accessed on the way back,
->async_data deallocation is delayed up to io_alloc_req(), and
rsrc deallocation is also now protected by the mutex.

With all that we can kill off submission references. And next, in most
cases we have only one reference travelling along the execution path,
so we can replace it with a flag allowing to enable refcounting when
needed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 58 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 36 insertions(+), 22 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5a08cc967199..d65621247709 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -712,6 +712,7 @@ enum {
 	REQ_F_REISSUE_BIT,
 	REQ_F_DONT_REISSUE_BIT,
 	REQ_F_CREDS_BIT,
+	REQ_F_REFCOUNT_BIT,
 	/* keep async read/write and isreg together and in order */
 	REQ_F_NOWAIT_READ_BIT,
 	REQ_F_NOWAIT_WRITE_BIT,
@@ -767,6 +768,8 @@ enum {
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
 	/* has creds assigned */
 	REQ_F_CREDS		= BIT(REQ_F_CREDS_BIT),
+	/* skip refcounting if not set */
+	REQ_F_REFCOUNT		= BIT(REQ_F_REFCOUNT_BIT),
 };
 
 struct async_poll {
@@ -1090,26 +1093,40 @@ EXPORT_SYMBOL(io_uring_get_socket);
 
 static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
 {
+	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
 	return atomic_inc_not_zero(&req->refs);
 }
 
 static inline bool req_ref_put_and_test(struct io_kiocb *req)
 {
+	if (likely(!(req->flags & REQ_F_REFCOUNT)))
+		return true;
+
 	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
 	return atomic_dec_and_test(&req->refs);
 }
 
 static inline void req_ref_put(struct io_kiocb *req)
 {
+	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
 	WARN_ON_ONCE(req_ref_put_and_test(req));
 }
 
 static inline void req_ref_get(struct io_kiocb *req)
 {
+	WARN_ON_ONCE(!(req->flags & REQ_F_REFCOUNT));
 	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
 	atomic_inc(&req->refs);
 }
 
+static inline void io_req_refcount(struct io_kiocb *req)
+{
+	if (!(req->flags & REQ_F_REFCOUNT)) {
+		req->flags |= REQ_F_REFCOUNT;
+		atomic_set(&req->refs, 1);
+	}
+}
+
 static inline void io_req_set_rsrc_node(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -1706,7 +1723,6 @@ static inline void io_req_complete(struct io_kiocb *req, long res)
 static void io_req_complete_failed(struct io_kiocb *req, long res)
 {
 	req_set_fail(req);
-	io_put_req(req);
 	io_req_complete_post(req, res, 0);
 }
 
@@ -1761,7 +1777,14 @@ static bool io_flush_cached_reqs(struct io_ring_ctx *ctx)
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
@@ -1883,8 +1906,6 @@ static void io_fail_links(struct io_kiocb *req)
 
 		trace_io_uring_fail_link(req, link);
 		io_cqring_fill_event(link->ctx, link->user_data, -ECANCELED, 0);
-
-		io_put_req(link);
 		io_put_req_deferred(link);
 		link = nxt;
 	}
@@ -2166,8 +2187,6 @@ static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 	for (i = 0; i < nr; i++) {
 		struct io_kiocb *req = state->compl_reqs[i];
 
-		/* submission and completion refs */
-		io_put_req(req);
 		if (req_ref_put_and_test(req))
 			io_req_free_batch(&rb, req, &ctx->submit_state);
 	}
@@ -2272,7 +2291,6 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 		if (READ_ONCE(req->result) == -EAGAIN && resubmit &&
 		    !(req->flags & REQ_F_DONT_REISSUE)) {
 			req->iopoll_completed = 0;
-			req_ref_get(req);
 			io_req_task_queue_reissue(req);
 			continue;
 		}
@@ -2787,7 +2805,6 @@ static void kiocb_done(struct kiocb *kiocb, ssize_t ret,
 	if (check_reissue && (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req)) {
-			req_ref_get(req);
 			io_req_task_queue_reissue(req);
 		} else {
 			int cflags = 0;
@@ -3213,9 +3230,6 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 
 	req->rw.kiocb.ki_flags &= ~IOCB_WAITQ;
 	list_del_init(&wait->entry);
-
-	/* submit ref gets dropped, acquire a new one */
-	req_ref_get(req);
 	io_req_task_queue(req);
 	return 1;
 }
@@ -5220,6 +5234,7 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	req->apoll = apoll;
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
+	io_req_refcount(req);
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
@@ -5267,10 +5282,6 @@ static bool io_poll_remove_one(struct io_kiocb *req)
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
@@ -5414,6 +5425,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	if (flags & ~IORING_POLL_ADD_MULTI)
 		return -EINVAL;
 
+	io_req_refcount(req);
 	poll->events = io_poll_parse_events(sqe, flags);
 	return 0;
 }
@@ -6290,6 +6302,10 @@ static void io_wq_submit_work(struct io_wq_work *work)
 	struct io_kiocb *timeout;
 	int ret = 0;
 
+	io_req_refcount(req);
+	/* will be dropped by ->io_free_work() after returning to io-wq */
+	req_ref_get(req);
+
 	timeout = io_prep_linked_timeout(req);
 	if (timeout)
 		io_queue_linked_timeout(timeout);
@@ -6312,11 +6328,8 @@ static void io_wq_submit_work(struct io_wq_work *work)
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
@@ -6450,6 +6463,11 @@ static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req)
 	    nxt->opcode != IORING_OP_LINK_TIMEOUT)
 		return NULL;
 
+	/* linked timeouts should have two refs once prep'ed */
+	io_req_refcount(req);
+	io_req_refcount(nxt);
+	req_ref_get(nxt);
+
 	nxt->timeout.head = req;
 	nxt->flags |= REQ_F_LTIMEOUT_ACTIVE;
 	req->flags |= REQ_F_LINK_TIMEOUT;
@@ -6478,8 +6496,6 @@ static void __io_queue_sqe(struct io_kiocb *req)
 			state->compl_reqs[state->compl_nr++] = req;
 			if (state->compl_nr == ARRAY_SIZE(state->compl_reqs))
 				io_submit_flush_completions(ctx);
-		} else {
-			io_put_req(req);
 		}
 	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
 		switch (io_arm_poll_handler(req)) {
@@ -6559,8 +6575,6 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->user_data = READ_ONCE(sqe->user_data);
 	req->file = NULL;
 	req->fixed_rsrc_refs = NULL;
-	/* one is dropped after submission, the other at completion */
-	atomic_set(&req->refs, 2);
 	req->task = current;
 
 	/* enforce forwards compatibility on users */
-- 
2.32.0

