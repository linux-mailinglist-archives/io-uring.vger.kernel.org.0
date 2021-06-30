Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EC0C3B89ED
	for <lists+io-uring@lfdr.de>; Wed, 30 Jun 2021 22:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233832AbhF3U5B (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Jun 2021 16:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233735AbhF3U5A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Jun 2021 16:57:00 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299CCC061756
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:54:30 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id q18-20020a1ce9120000b02901f259f3a250so2573715wmc.2
        for <io-uring@vger.kernel.org>; Wed, 30 Jun 2021 13:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GyPexbeAjkPl9uXJcvBhLjLvKtBfedTLtrLLPvZOGDM=;
        b=VTjt6hYFL7T24wINVSvvB1q3hrW9ceGB0zAptEUp6jm98zJG+56NvVovy99MheHb+g
         SHfBHfZ0AS69jdTrgqkoQAMLbKef4fZ2Y6CsBSJGHY2mHJCNpKzk0lc2Fxy6jbCysVpE
         aGShBh8xTyVyHmXNOqqs6rfrFKR6569TLw/8wg2vuBFbIt1qR51wuPPdhZ+tyZnezE0K
         rV49BMnCsQ2A0cKFU9tonA38HsYPIPicFMXBWb8V5ON5hliChRCKBzwNV9W4yxk897Nv
         QyAXoieOHyS33G6zYnOtSubzv8HqFB5UyZbvqP2x4YZpOtEohyLTOyJ5iksRbKdMnomX
         1LGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GyPexbeAjkPl9uXJcvBhLjLvKtBfedTLtrLLPvZOGDM=;
        b=iFgObDCCEeJV9ZKwkKOVmHXzoa11ddXZWjFEJYpGsJ4c6GYIu9tz/vw7CudKzykhKI
         t+imwhMZHaoQwwPOP/FwkrjSptA2ElzTvLYutCxJzcEERUGI3QLZlInyoUNVRKKCSqSS
         kpClR1ECnmm8OTcaThACOc/Zn8+heTf77s0r2bWjqoGa9UqSg36sHVnQsvgudTjnAxi1
         yW8Aelg65kXobvkMIjhCK+4TzhiRr15QIjYlZwJ78RHJ2vhPmhaJufgrjVB/moXUf4yL
         O5Yx9584ieqkxtheQndexk3MWjqUQNwMHmgdAjDyro82R3pfwrbK+pZNQDSTnIsUImUQ
         J6MA==
X-Gm-Message-State: AOAM53316isl/kWtN/sMe2bL8maDMyGUqjxGPv8r/welOJkWWi8WPqT2
        wM0UEXkWJhLk013jr/MiyLU=
X-Google-Smtp-Source: ABdhPJzbZOcL2aNbc51UN6soW5gRS98O3Ptt+VCjr0eNs2h2tIdbruHp6qYPTKZsP0GjIJzJO56KEQ==
X-Received: by 2002:a7b:cc8d:: with SMTP id p13mr8404719wma.33.1625086468769;
        Wed, 30 Jun 2021 13:54:28 -0700 (PDT)
Received: from localhost.localdomain ([85.255.237.26])
        by smtp.gmail.com with ESMTPSA id p2sm22099087wro.16.2021.06.30.13.54.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 13:54:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/3] io_uring: simplify task_work func
Date:   Wed, 30 Jun 2021 21:54:04 +0100
Message-Id: <294aa4eddbae929348273186a4945efa243f1aa9.1625086418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1625086418.git.asml.silence@gmail.com>
References: <cover.1625086418.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since we don't really use req->task_work anymore, get rid of it together
with the nasty ->func aliasing between ->io_task_work and ->task_work,
and hide ->fallback_node inside of io_task_work.

Also, as task_work is gone now, replace the callback type from
task_work_func_t to a function taking io_kiocb to avoid casting and
simplify code.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 72 ++++++++++++++++++++-------------------------------
 1 file changed, 28 insertions(+), 44 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 08ca835629ce..5fab427305e3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -808,9 +808,14 @@ struct async_poll {
 	struct io_poll_iocb	*double_poll;
 };
 
+typedef void (*io_req_tw_func_t)(struct io_kiocb *req);
+
 struct io_task_work {
-	struct io_wq_work_node	node;
-	task_work_func_t	func;
+	union {
+		struct io_wq_work_node	node;
+		struct llist_node	fallback_node;
+	};
+	io_req_tw_func_t		func;
 };
 
 enum {
@@ -876,18 +881,13 @@ struct io_kiocb {
 
 	/* used with ctx->iopoll_list with reads/writes */
 	struct list_head		inflight_entry;
-	union {
-		struct io_task_work	io_task_work;
-		struct callback_head	task_work;
-	};
+	struct io_task_work		io_task_work;
 	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
 	struct hlist_node		hash_node;
 	struct async_poll		*apoll;
 	struct io_wq_work		work;
 	const struct cred		*creds;
 
-	struct llist_node		fallback_node;
-
 	/* store used ubuf, so we can prevent reloading */
 	struct io_mapped_ubuf		*imu;
 };
@@ -1964,7 +1964,7 @@ static void tctx_task_work(struct callback_head *cb)
 				ctx = req->ctx;
 				percpu_ref_get(&ctx->refs);
 			}
-			req->task_work.func(&req->task_work);
+			req->io_task_work.func(req);
 			node = next;
 		}
 		if (wq_list_empty(&tctx->task_list)) {
@@ -2035,16 +2035,16 @@ static int io_req_task_work_add(struct io_kiocb *req)
 }
 
 static void io_req_task_work_add_fallback(struct io_kiocb *req,
-					  task_work_func_t cb)
+					  io_req_tw_func_t cb)
 {
-	init_task_work(&req->task_work, cb);
-	if (llist_add(&req->fallback_node, &req->ctx->fallback_llist))
+	req->io_task_work.func = cb;
+	if (llist_add(&req->io_task_work.fallback_node,
+		      &req->ctx->fallback_llist))
 		schedule_delayed_work(&req->ctx->fallback_work, 1);
 }
 
-static void io_req_task_cancel(struct callback_head *cb)
+static void io_req_task_cancel(struct io_kiocb *req)
 {
-	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct io_ring_ctx *ctx = req->ctx;
 
 	/* ctx is guaranteed to stay alive while we hold uring_lock */
@@ -2053,7 +2053,7 @@ static void io_req_task_cancel(struct callback_head *cb)
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static void __io_req_task_submit(struct io_kiocb *req)
+static void io_req_task_submit(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -2066,17 +2066,10 @@ static void __io_req_task_submit(struct io_kiocb *req)
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static void io_req_task_submit(struct callback_head *cb)
-{
-	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
-
-	__io_req_task_submit(req);
-}
-
 static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
 	req->result = ret;
-	req->task_work.func = io_req_task_cancel;
+	req->io_task_work.func = io_req_task_cancel;
 
 	if (unlikely(io_req_task_work_add(req)))
 		io_req_task_work_add_fallback(req, io_req_task_cancel);
@@ -2084,7 +2077,7 @@ static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 
 static void io_req_task_queue(struct io_kiocb *req)
 {
-	req->task_work.func = io_req_task_submit;
+	req->io_task_work.func = io_req_task_submit;
 
 	if (unlikely(io_req_task_work_add(req)))
 		io_req_task_queue_fail(req, -ECANCELED);
@@ -2198,18 +2191,11 @@ static inline void io_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
-static void io_put_req_deferred_cb(struct callback_head *cb)
-{
-	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
-
-	io_free_req(req);
-}
-
 static void io_free_req_deferred(struct io_kiocb *req)
 {
-	req->task_work.func = io_put_req_deferred_cb;
+	req->io_task_work.func = io_free_req;
 	if (unlikely(io_req_task_work_add(req)))
-		io_req_task_work_add_fallback(req, io_put_req_deferred_cb);
+		io_req_task_work_add_fallback(req, io_free_req);
 }
 
 static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
@@ -2495,8 +2481,8 @@ static void io_fallback_req_func(struct work_struct *work)
 	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
 	struct io_kiocb *req, *tmp;
 
-	llist_for_each_entry_safe(req, tmp, node, fallback_node)
-		req->task_work.func(&req->task_work);
+	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
+		req->io_task_work.func(req);
 }
 
 static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
@@ -4998,7 +4984,7 @@ struct io_poll_table {
 };
 
 static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
-			   __poll_t mask, task_work_func_t func)
+			   __poll_t mask, io_req_tw_func_t func)
 {
 	int ret;
 
@@ -5011,7 +4997,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	list_del_init(&poll->wait.entry);
 
 	req->result = mask;
-	req->task_work.func = func;
+	req->io_task_work.func = func;
 
 	/*
 	 * If this fails, then the task is exiting. When a task exits, the
@@ -5108,9 +5094,8 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	return !(flags & IORING_CQE_F_MORE);
 }
 
-static void io_poll_task_func(struct callback_head *cb)
+static void io_poll_task_func(struct io_kiocb *req)
 {
-	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *nxt;
 
@@ -5132,7 +5117,7 @@ static void io_poll_task_func(struct callback_head *cb)
 		if (done) {
 			nxt = io_put_req_find_next(req);
 			if (nxt)
-				__io_req_task_submit(nxt);
+				io_req_task_submit(nxt);
 		}
 	}
 }
@@ -5241,9 +5226,8 @@ static void io_async_queue_proc(struct file *file, struct wait_queue_head *head,
 	__io_queue_proc(&apoll->poll, pt, head, &apoll->double_poll);
 }
 
-static void io_async_task_func(struct callback_head *cb)
+static void io_async_task_func(struct io_kiocb *req)
 {
-	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
 	struct async_poll *apoll = req->apoll;
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -5259,7 +5243,7 @@ static void io_async_task_func(struct callback_head *cb)
 	spin_unlock_irq(&ctx->completion_lock);
 
 	if (!READ_ONCE(apoll->poll.canceled))
-		__io_req_task_submit(req);
+		io_req_task_submit(req);
 	else
 		io_req_complete_failed(req, -ECANCELED);
 }
@@ -9006,7 +8990,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	/*
 	 * Some may use context even when all refs and requests have been put,
 	 * and they are free to do so while still holding uring_lock or
-	 * completion_lock, see __io_req_task_submit(). Apart from other work,
+	 * completion_lock, see io_req_task_submit(). Apart from other work,
 	 * this lock/unlock section also waits them to finish.
 	 */
 	mutex_lock(&ctx->uring_lock);
-- 
2.32.0

