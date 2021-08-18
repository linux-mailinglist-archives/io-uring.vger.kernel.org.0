Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14ABE3F02F5
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 13:43:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235907AbhHRLoD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 07:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235869AbhHRLoA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 07:44:00 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE51C0613D9
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 04:43:25 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id q10so3068069wro.2
        for <io-uring@vger.kernel.org>; Wed, 18 Aug 2021 04:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zTYmot8tVqUefbRQNpT5SqpoP+nzZlmmN4jBB+QttvQ=;
        b=q4uNKwun1pb5w2IoCg2/zwoVS3tMagZujfzd6TXbOk8X++R17JJc9nrCbv4482mFwu
         rv7roMLhAEw+R468FaN+trst/2Xw2TsMFHhxlGBNPABKgP1mSWZ2bLELDjhUfn0QCPOV
         OrdRQrlznqeM+kBpX0/yTl4Iw4fQMYrY5hVYGebWiiVDE1IOxTGZZFeLh+yMPGcDScdn
         PdAzeqBjN4FkP7Pu/qoEgHRHm+gl/UoQ1cSP8HWuuzPXUjEf5rusPj/jyltAt3vADsTh
         oI37IMNlGjDiK/AnDM8lh4iajwLxtQTTAGOmMn+sbKLtNWymEcq+A3c5+wMKCXy5SxIO
         11LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zTYmot8tVqUefbRQNpT5SqpoP+nzZlmmN4jBB+QttvQ=;
        b=mI6O7qe8aKFIZUXg4lokumbyVsVtTGUFGIJ5ziRr4Hbq58goyfQt13nT7EXY/VAKt8
         /DG8vnI3PoR+weDNJr6luaHdwcVhPMZdhNrFxXWHCSliGGKFS778aCorD4LvcScaJo5Y
         uEQnF9bKvKQDLUyruFVPOVT8NdPol8OTwLsFovT8C1d/QxtJMVKpD1bs5kh8+caDS8XN
         4QLhVWbPBKfc1GIh5I4i29X3KHvIJ027gaOZqcv97ZL7iOKY9sJp2AgkG3StdYyg06f4
         37oXD2HR/2UNsHqrARNGA/2VZgQSo9XQmp+bYu6gvF893QOrbB1gxYlXQHulBVN2/0WI
         hiaA==
X-Gm-Message-State: AOAM530zaKH+UInZHdVDw8jLZJkV4C6WjzJq5khLcduCt4x6DaYHNdbx
        Bqi7JLpXHP4cXW3UpBfIPzoqkcZjEU4=
X-Google-Smtp-Source: ABdhPJxyI1L25+T8blo3hF7B8XIcd5cWnvlnyachf0Fs7fOqALE48ECSyAay+d9UO7KZM2wDG6YDyA==
X-Received: by 2002:adf:efce:: with SMTP id i14mr9900341wrp.316.1629287004236;
        Wed, 18 Aug 2021 04:43:24 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.2])
        by smtp.gmail.com with ESMTPSA id c7sm4581918wmq.13.2021.08.18.04.43.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Aug 2021 04:43:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: batch task work locking
Date:   Wed, 18 Aug 2021 12:42:46 +0100
Message-Id: <d6a34e147f2507a2f3e2fa1e38a9c541dcad3929.1629286357.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629286357.git.asml.silence@gmail.com>
References: <cover.1629286357.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Many task_work handlers either grab ->uring_lock, or may benefit from
having it. Move locking logic out of individual handlers to a lazy
approach controlled by tctx_task_work(), so we don't keep doing
tons of mutex lock/unlock.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 89 ++++++++++++++++++++++++++++++---------------------
 1 file changed, 52 insertions(+), 37 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ba087f395507..54c4d8326944 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -775,7 +775,7 @@ struct async_poll {
 	struct io_poll_iocb	*double_poll;
 };
 
-typedef void (*io_req_tw_func_t)(struct io_kiocb *req);
+typedef void (*io_req_tw_func_t)(struct io_kiocb *req, bool *locked);
 
 struct io_task_work {
 	union {
@@ -1080,6 +1080,14 @@ struct sock *io_uring_get_socket(struct file *file)
 }
 EXPORT_SYMBOL(io_uring_get_socket);
 
+static inline void io_tw_lock(struct io_ring_ctx *ctx, bool *locked)
+{
+	if (!*locked) {
+		mutex_lock(&ctx->uring_lock);
+		*locked = true;
+	}
+}
+
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
@@ -1193,16 +1201,19 @@ static void io_fallback_req_func(struct work_struct *work)
 						fallback_work.work);
 	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
 	struct io_kiocb *req, *tmp;
+	bool locked = false;
 
 	percpu_ref_get(&ctx->refs);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
-		req->io_task_work.func(req);
+		req->io_task_work.func(req, &locked);
 
-	mutex_lock(&ctx->uring_lock);
-	if (ctx->submit_state.compl_nr)
-		io_submit_flush_completions(ctx);
-	mutex_unlock(&ctx->uring_lock);
+	if (locked) {
+		if (ctx->submit_state.compl_nr)
+			io_submit_flush_completions(ctx);
+		mutex_unlock(&ctx->uring_lock);
+	}
 	percpu_ref_put(&ctx->refs);
+
 }
 
 static struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
@@ -1386,12 +1397,15 @@ static void io_prep_async_link(struct io_kiocb *req)
 	}
 }
 
-static void io_queue_async_work(struct io_kiocb *req)
+static void io_queue_async_work(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->task->io_uring;
 
+	/* must not take the lock, NULL it as a precaution */
+	locked = NULL;
+
 	BUG_ON(!tctx);
 	BUG_ON(!tctx->io_wq);
 
@@ -2002,14 +2016,15 @@ static inline struct io_kiocb *io_req_find_next(struct io_kiocb *req)
 	return __io_req_find_next(req);
 }
 
-static void ctx_flush_and_put(struct io_ring_ctx *ctx)
+static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
 {
 	if (!ctx)
 		return;
-	if (ctx->submit_state.compl_nr) {
-		mutex_lock(&ctx->uring_lock);
-		io_submit_flush_completions(ctx);
+	if (*locked) {
+		if (ctx->submit_state.compl_nr)
+			io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
+		*locked = false;
 	}
 }
 
@@ -2021,6 +2036,7 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
  */
 static void tctx_task_work(struct callback_head *cb)
 {
+	bool locked = false;
 	struct io_ring_ctx *ctx = NULL;
 	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
 						  task_work);
@@ -2043,17 +2059,17 @@ static void tctx_task_work(struct callback_head *cb)
 							    io_task_work.node);
 
 			if (req->ctx != ctx) {
-				ctx_flush_and_put(ctx);
+				ctx_flush_and_put(ctx, &locked);
 				ctx = req->ctx;
 			}
-			req->io_task_work.func(req);
+			req->io_task_work.func(req, &locked);
 			node = next;
 		} while (node);
 
 		cond_resched();
 	}
 
-	ctx_flush_and_put(ctx);
+	ctx_flush_and_put(ctx, &locked);
 }
 
 static void io_req_task_work_add(struct io_kiocb *req)
@@ -2105,27 +2121,21 @@ static void io_req_task_work_add(struct io_kiocb *req)
 	}
 }
 
-static void io_req_task_cancel(struct io_kiocb *req)
+static void io_req_task_cancel(struct io_kiocb *req, bool *locked)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
-	/* ctx is guaranteed to stay alive while we hold uring_lock */
-	mutex_lock(&ctx->uring_lock);
+	io_tw_lock(req->ctx, locked);
 	io_req_complete_failed(req, req->result);
-	mutex_unlock(&ctx->uring_lock);
 }
 
-static void io_req_task_submit(struct io_kiocb *req)
+static void io_req_task_submit(struct io_kiocb *req, bool *locked)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
 	/* ctx stays valid until unlock, even if we drop all ours ctx->refs */
-	mutex_lock(&ctx->uring_lock);
+	io_tw_lock(req->ctx, locked);
+
 	if (likely(!(req->task->flags & PF_EXITING)))
 		__io_queue_sqe(req);
 	else
 		io_req_complete_failed(req, -EFAULT);
-	mutex_unlock(&ctx->uring_lock);
 }
 
 static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
@@ -2161,6 +2171,11 @@ static void io_free_req(struct io_kiocb *req)
 	__io_free_req(req);
 }
 
+static void io_free_req_work(struct io_kiocb *req, bool *locked)
+{
+	io_free_req(req);
+}
+
 struct req_batch {
 	struct task_struct	*task;
 	int			task_refs;
@@ -2260,7 +2275,7 @@ static inline void io_put_req(struct io_kiocb *req)
 static inline void io_put_req_deferred(struct io_kiocb *req)
 {
 	if (req_ref_put_and_test(req)) {
-		req->io_task_work.func = io_free_req;
+		req->io_task_work.func = io_free_req_work;
 		io_req_task_work_add(req);
 	}
 }
@@ -2555,7 +2570,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	return false;
 }
 
-static void io_req_task_complete(struct io_kiocb *req)
+static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 {
 	__io_req_complete(req, 0, req->result, io_put_rw_kbuf(req));
 }
@@ -2565,7 +2580,7 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 {
 	if (__io_complete_rw_common(req, res))
 		return;
-	io_req_task_complete(req);
+	__io_req_complete(req, 0, req->result, io_put_rw_kbuf(req));
 }
 
 static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
@@ -4980,7 +4995,7 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	return !(flags & IORING_CQE_F_MORE);
 }
 
-static void io_poll_task_func(struct io_kiocb *req)
+static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *nxt;
@@ -5004,7 +5019,7 @@ static void io_poll_task_func(struct io_kiocb *req)
 		if (done) {
 			nxt = io_put_req_find_next(req);
 			if (nxt)
-				io_req_task_submit(nxt);
+				io_req_task_submit(nxt, locked);
 		}
 	}
 }
@@ -5116,7 +5131,7 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
 }
 
-static void io_async_task_func(struct io_kiocb *req)
+static void io_async_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct async_poll *apoll = req->apoll;
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5133,7 +5148,7 @@ static void io_async_task_func(struct io_kiocb *req)
 	spin_unlock(&ctx->completion_lock);
 
 	if (!READ_ONCE(apoll->poll.canceled))
-		io_req_task_submit(req);
+		io_req_task_submit(req, locked);
 	else
 		io_req_complete_failed(req, -ECANCELED);
 }
@@ -5532,7 +5547,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
-static void io_req_task_timeout(struct io_kiocb *req)
+static void io_req_task_timeout(struct io_kiocb *req, bool *locked)
 {
 	req_set_fail(req);
 	io_req_complete_post(req, -ETIME, 0);
@@ -6087,7 +6102,7 @@ static bool io_drain_req(struct io_kiocb *req)
 	if (!req_need_defer(req, seq) && list_empty(&ctx->defer_list)) {
 		spin_unlock(&ctx->completion_lock);
 		kfree(de);
-		io_queue_async_work(req);
+		io_queue_async_work(req, NULL);
 		return true;
 	}
 
@@ -6409,7 +6424,7 @@ static inline struct file *io_file_get(struct io_ring_ctx *ctx,
 		return io_file_get_normal(ctx, req, fd);
 }
 
-static void io_req_task_link_timeout(struct io_kiocb *req)
+static void io_req_task_link_timeout(struct io_kiocb *req, bool *locked)
 {
 	struct io_kiocb *prev = req->timeout.prev;
 	int ret;
@@ -6513,7 +6528,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 			 * Queued up for async execution, worker will release
 			 * submit reference when the iocb is actually submitted.
 			 */
-			io_queue_async_work(req);
+			io_queue_async_work(req, NULL);
 			break;
 		}
 
@@ -6538,7 +6553,7 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 		if (unlikely(ret))
 			io_req_complete_failed(req, ret);
 		else
-			io_queue_async_work(req);
+			io_queue_async_work(req, NULL);
 	}
 }
 
-- 
2.32.0

