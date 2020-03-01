Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E688174E52
	for <lists+io-uring@lfdr.de>; Sun,  1 Mar 2020 17:20:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgCAQTn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 Mar 2020 11:19:43 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:37391 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgCAQTm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 Mar 2020 11:19:42 -0500
Received: by mail-wm1-f65.google.com with SMTP id a141so8351113wme.2;
        Sun, 01 Mar 2020 08:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=eYk36xc4J6T+eBKGfRZypw4jSxWCP7a6OOOKiHm+Jcg=;
        b=KjER1JBNwPqaUPDymFZToSWxsg7ZsR9VvZPIZgO8sVwaqLWcXDTqJO4Q/Gt2BnwX38
         /FjEvKAwS6j3mCJnf3EKR+vbAAG4Nya07IClvApfzTgfZk2eZBdp1J2a93Fw6POY+wdd
         sXPb7AzVfYTFr3DlnLxnHfEuBkpnh8vL1K7n4j/GMURQVzUNZaqo4YfmpmlgJ3W5eKZ9
         P5uiasV/bp++OB9526jtPKw8nV9G+qtbp6Cyi05GfPl9qO/T+mlbsH3GORV6cm4MxsOB
         G+uT7Gtal76BbzLgNlhhxTLxN74SrcLAk341e1Lsp9jY2szhavD0wrXsyer6iYbhFWwA
         NavA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=eYk36xc4J6T+eBKGfRZypw4jSxWCP7a6OOOKiHm+Jcg=;
        b=g0sRJFhlvZKLoWFJc5yw/yBsXbtfoAaxNJbQTljT9SErKopzrc9f37WNXD+zMglf86
         yMn9yzsP2m2DwMZvkWtOyBJCSmauBAlSoloVokp7NUbdApFEo1UuMplH5+/0tBblKVz6
         B8jvcvopwvJ/izRCbd5xmw77Os/H1qcE3bNL70VTK7mJqvUKB2/dZ6vlMzX63RULEp6E
         1XvZ6uTelJEeARX5coB7eCcCNWPmEL7KDXZ8OdJeL1gYrF0+v5fZ8gfboq2Rr1fpiCHa
         g75DpnI98iIED77lRueTbZGby1UbLYy0GHwVQ+EWQ5qxLgUPLZu2/QHesgqf22mpfdYR
         4wtA==
X-Gm-Message-State: APjAAAWPSRppw1eGXpwwcs20u6SwKke+yzcPBSL1PKwBlqf8T7Xt5IJ+
        P/830+F7fXTVii3INoMjfI0=
X-Google-Smtp-Source: APXvYqwfLm1ZUEXSJnpFqpmxJwjf5rYkkGfkaEhSrF7ST5SoGFvo8NRZpU0IsgvzzaZLjs0/Nd1+Kw==
X-Received: by 2002:a7b:cb46:: with SMTP id v6mr8409314wmj.0.1583079580290;
        Sun, 01 Mar 2020 08:19:40 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id q9sm15864741wrn.8.2020.03.01.08.19.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 Mar 2020 08:19:39 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/9] io_uring: get next req on subm ref drop
Date:   Sun,  1 Mar 2020 19:18:22 +0300
Message-Id: <d5e0c69a5b0fdf7e72a8137949818dc59465d40f.1583078091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1583078091.git.asml.silence@gmail.com>
References: <cover.1583078091.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Get next request when dropping the submission reference. However, if
there is an asynchronous counterpart (i.e. read/write, timeout, etc),
that would be dangerous to do, so ignore them using new
REQ_F_DONT_STEAL_NEXT flag.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 121 ++++++++++++++++++++++++++------------------------
 1 file changed, 62 insertions(+), 59 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index daf7c2095523..d456b0ff6835 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -488,6 +488,7 @@ enum {
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_OVERFLOW_BIT,
 	REQ_F_POLLED_BIT,
+	REQ_F_DONT_STEAL_NEXT_BIT,
 };
 
 enum {
@@ -532,6 +533,8 @@ enum {
 	REQ_F_OVERFLOW		= BIT(REQ_F_OVERFLOW_BIT),
 	/* already went through poll handler */
 	REQ_F_POLLED		= BIT(REQ_F_POLLED_BIT),
+	/* don't try to get next req, it's async and racy */
+	REQ_F_DONT_STEAL_NEXT	= BIT(REQ_F_DONT_STEAL_NEXT_BIT),
 };
 
 struct async_poll {
@@ -1218,6 +1221,27 @@ static void io_cqring_add_event(struct io_kiocb *req, long res)
 	io_cqring_ev_posted(ctx);
 }
 
+static void io_link_work_cb(struct io_wq_work **workptr)
+{
+	struct io_wq_work *work = *workptr;
+	struct io_kiocb *link = work->data;
+
+	io_queue_linked_timeout(link);
+	io_wq_submit_work(workptr);
+}
+
+static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
+{
+	struct io_kiocb *link;
+
+	*workptr = &nxt->work;
+	link = io_prep_linked_timeout(nxt);
+	if (link) {
+		nxt->work.func = io_link_work_cb;
+		nxt->work.data = link;
+	}
+}
+
 static inline bool io_is_fallback_req(struct io_kiocb *req)
 {
 	return req == (struct io_kiocb *)
@@ -1518,17 +1542,28 @@ static void io_free_req(struct io_kiocb *req)
 		io_queue_async_work(nxt);
 }
 
-/*
- * Drop reference to request, return next in chain (if there is one) if this
- * was the last reference to this request.
- */
-__attribute__((nonnull))
-static void io_put_req_find_next(struct io_kiocb *req, struct io_kiocb **nxtptr)
+__attribute__((warn_unused_result))
+static struct io_kiocb *io_put_req_submission(struct io_kiocb *req)
 {
-	if (refcount_dec_and_test(&req->refs)) {
-		io_req_find_next(req, nxtptr);
+	bool last_ref = refcount_dec_and_test(&req->refs);
+	struct io_kiocb *nxt = NULL;
+
+	if (!(req->flags & REQ_F_DONT_STEAL_NEXT) || last_ref)
+		io_req_find_next(req, &nxt);
+	if (last_ref)
 		__io_free_req(req);
-	}
+
+	return nxt;
+}
+
+static void io_put_req_async_submission(struct io_kiocb *req,
+					struct io_wq_work **workptr)
+{
+	static struct io_kiocb *nxt;
+
+	nxt = io_put_req_submission(req);
+	if (nxt)
+		io_wq_assign_next(workptr, nxt);
 }
 
 static void io_put_req(struct io_kiocb *req)
@@ -1979,8 +2014,11 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 
 static inline void io_rw_done(struct kiocb *kiocb, ssize_t ret)
 {
+	struct io_kiocb *req = container_of(kiocb, struct io_kiocb, rw.kiocb);
+
 	switch (ret) {
 	case -EIOCBQUEUED:
+		req->flags |= REQ_F_DONT_STEAL_NEXT;
 		break;
 	case -ERESTARTSYS:
 	case -ERESTARTNOINTR:
@@ -2526,6 +2564,7 @@ static int io_prep_fsync(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (unlikely(req->sync.flags & ~IORING_FSYNC_DATASYNC))
 		return -EINVAL;
 
+	req->flags |= REQ_F_DONT_STEAL_NEXT;
 	req->sync.off = READ_ONCE(sqe->off);
 	req->sync.len = READ_ONCE(sqe->len);
 	return 0;
@@ -2543,27 +2582,6 @@ static bool io_req_cancelled(struct io_kiocb *req)
 	return false;
 }
 
-static void io_link_work_cb(struct io_wq_work **workptr)
-{
-	struct io_wq_work *work = *workptr;
-	struct io_kiocb *link = work->data;
-
-	io_queue_linked_timeout(link);
-	io_wq_submit_work(workptr);
-}
-
-static void io_wq_assign_next(struct io_wq_work **workptr, struct io_kiocb *nxt)
-{
-	struct io_kiocb *link;
-
-	*workptr = &nxt->work;
-	link = io_prep_linked_timeout(nxt);
-	if (link) {
-		nxt->work.func = io_link_work_cb;
-		nxt->work.data = link;
-	}
-}
-
 static void __io_fsync(struct io_kiocb *req)
 {
 	loff_t end = req->sync.off + req->sync.len;
@@ -2581,14 +2599,11 @@ static void __io_fsync(struct io_kiocb *req)
 static void io_fsync_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
 	__io_fsync(req);
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_submission(req, workptr);
 }
 
 static int io_fsync(struct io_kiocb *req, bool force_nonblock)
@@ -2617,14 +2632,11 @@ static void __io_fallocate(struct io_kiocb *req)
 static void io_fallocate_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
 	__io_fallocate(req);
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_submission(req, workptr);
 }
 
 static int io_fallocate_prep(struct io_kiocb *req,
@@ -2988,13 +3000,10 @@ static void __io_close_finish(struct io_kiocb *req)
 static void io_close_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	/* not cancellable, don't do io_req_cancelled() */
 	__io_close_finish(req);
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_submission(req, workptr);
 }
 
 static int io_close(struct io_kiocb *req, bool force_nonblock)
@@ -3016,6 +3025,7 @@ static int io_close(struct io_kiocb *req, bool force_nonblock)
 		 */
 		io_queue_async_work(req);
 		/* submission ref will be dropped, take it for async */
+		req->flags |= REQ_F_DONT_STEAL_NEXT;
 		refcount_inc_not_zero(&req->refs);
 		return 0;
 	}
@@ -3062,14 +3072,11 @@ static void __io_sync_file_range(struct io_kiocb *req)
 static void io_sync_file_range_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
 	__io_sync_file_range(req);
-	io_put_req(req); /* put submission ref */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_submission(req, workptr);
 }
 
 static int io_sync_file_range(struct io_kiocb *req, bool force_nonblock)
@@ -3435,14 +3442,11 @@ static int __io_accept(struct io_kiocb *req, bool force_nonblock)
 static void io_accept_finish(struct io_wq_work **workptr)
 {
 	struct io_kiocb *req = container_of(*workptr, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 
 	if (io_req_cancelled(req))
 		return;
 	__io_accept(req, false);
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_submission(req, workptr);
 }
 #endif
 
@@ -3859,9 +3863,10 @@ static void io_poll_task_handler(struct io_kiocb *req, struct io_kiocb **nxt)
 	hash_del(&req->hash_node);
 	io_poll_complete(req, req->result, 0);
 	req->flags |= REQ_F_COMP_LOCKED;
-	io_put_req_find_next(req, nxt);
 	spin_unlock_irq(&ctx->completion_lock);
 
+	req->flags &= ~REQ_F_DONT_STEAL_NEXT;
+	*nxt = io_put_req_submission(req);
 	io_cqring_ev_posted(ctx);
 }
 
@@ -3944,6 +3949,8 @@ static int io_poll_add(struct io_kiocb *req)
 		io_cqring_ev_posted(ctx);
 		io_put_req(req);
 	}
+
+	req->flags |= REQ_F_DONT_STEAL_NEXT;
 	return ipt.error;
 }
 
@@ -4066,6 +4073,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (flags & ~IORING_TIMEOUT_ABS)
 		return -EINVAL;
 
+	req->flags |= REQ_F_DONT_STEAL_NEXT;
 	req->timeout.count = READ_ONCE(sqe->off);
 
 	if (!req->io && io_alloc_async_ctx(req))
@@ -4680,7 +4688,6 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 {
 	struct io_wq_work *work = *workptr;
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct io_kiocb *nxt = NULL;
 	int ret = 0;
 
 	/* if NO_CANCEL is set, we must still run the work */
@@ -4709,9 +4716,7 @@ static void io_wq_submit_work(struct io_wq_work **workptr)
 		io_put_req(req);
 	}
 
-	io_put_req(req); /* drop submission reference */
-	if (nxt)
-		io_wq_assign_next(workptr, nxt);
+	io_put_req_async_submission(req, workptr);
 }
 
 static int io_req_needs_file(struct io_kiocb *req, int fd)
@@ -4935,10 +4940,6 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	}
 
 err:
-	nxt = NULL;
-	/* drop submission reference */
-	io_put_req_find_next(req, &nxt);
-
 	if (linked_timeout) {
 		if (!ret)
 			io_queue_linked_timeout(linked_timeout);
@@ -4952,6 +4953,8 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req_set_fail_links(req);
 		io_put_req(req);
 	}
+
+	nxt = io_put_req_submission(req);
 	if (nxt) {
 		req = nxt;
 
-- 
2.24.0

