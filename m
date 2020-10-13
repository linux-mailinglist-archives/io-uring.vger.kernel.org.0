Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84F2D28CA7A
	for <lists+io-uring@lfdr.de>; Tue, 13 Oct 2020 10:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403974AbgJMIrC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Oct 2020 04:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403952AbgJMIrC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Oct 2020 04:47:02 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4288CC0613D0
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 01:47:02 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id j136so20889047wmj.2
        for <io-uring@vger.kernel.org>; Tue, 13 Oct 2020 01:47:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=nLnVtBGtghG9xLb2lDbLSlFypZeAvbOQIlZE5JKNGaw=;
        b=aoSBKFFBTSKisJUsouib5vxs1Sf53x9k8nfhw9SLeGyCe65ni4ytGELeO20/syHzUZ
         3D/w304kXlDFJTgSmsEcb2+Lvn8/aOpdcvwCbp4jfZmzvyhdsUeU8gACHh6oOwzZJvko
         Dpq6gEJM856oOlE8qz2qOIDMLP5n0bXP8gVSBNvoejHcIyK0LBpxu1VcuuBQDNB9Y7gE
         7oQL9qL2xwH4H7xfyr7biPZEWD630WYPfW5EH32jI3A6HW7BAhnfeiQEBtufTN2KEGPk
         79g/g9tY84Cy6Up6SgH9SID75CRBQCSBT+pWkS8WW9435Fo8Q+pgRf9Nws83gvYLZAmP
         UiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=nLnVtBGtghG9xLb2lDbLSlFypZeAvbOQIlZE5JKNGaw=;
        b=bjA1ECLnGWtbS26bXABlfNTixD/TxobnUKkHWMj5et32dIm6PglNkpV9q2p3Jvobf6
         LY4PnJMcTq8GB5N1Jbg2cto06YHk7EAyFbZhx508rPJ6ifp20OugS0hgJ7G9QvzYrYfi
         JgcOrkmWYXjYk29iB9bmYd6nQhA/GioSzCXarvfCZNuJGOf/WIkUfw5LZVzjk7J7T7Xe
         GFx0mJa8VRYE6OP//mYoS/+sQjQPYb/t8pKqpPsDbojnj29A03k8mTjDKRGensexkhoc
         uQTte9TGUSXwB9JLiN/D24h5wqQXkSJj3RbSqgBXCpZ0jwZ8JdXqAdFig6dnqij7yz4S
         Fr7w==
X-Gm-Message-State: AOAM531hP7xUe/oy17VeNf9NTIikYB9w1x+N/K29eiyQazSmGzM2gOjC
        M7dZ1BwbZMu9SBalh7T/DbrUMYIoKwM=
X-Google-Smtp-Source: ABdhPJwYmTWmXUqCEnJZihP0U2YpeMcKxwrHcAlSUVqOxC6slSe5zGgc2daoeFIDniLVhQvxSQ41nA==
X-Received: by 2002:a1c:a513:: with SMTP id o19mr14172769wme.130.1602578820958;
        Tue, 13 Oct 2020 01:47:00 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id p67sm26445168wmp.11.2020.10.13.01.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Oct 2020 01:47:00 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/5] io_uring: fix REQ_F_COMP_LOCKED by killing it
Date:   Tue, 13 Oct 2020 09:44:00 +0100
Message-Id: <e391f1e790868e1d883073d09b47304ec981930f.1602577875.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1602577875.git.asml.silence@gmail.com>
References: <cover.1602577875.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

REQ_F_COMP_LOCKED is used and implemented in a buggy way. The problem is
that the flag is set before io_put_req() but not cleared after, and if
that wasn't the final reference, the request will be freed with the flag
set from some other context, which may not hold a spinlock. That means
possible races with removing linked timeouts and unsynchronised
completion (e.g. access to CQ).

Instead of fixing REQ_F_COMP_LOCKED, kill the flag and use
task_work_add() to move such requests to a fresh context to free from
it, as was done with __io_free_req_finish().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 129 ++++++++++++++++++++------------------------------
 1 file changed, 51 insertions(+), 78 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d5baa5bba895..cb2640f6fdb2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -581,7 +581,6 @@ enum {
 	REQ_F_NOWAIT_BIT,
 	REQ_F_LINK_TIMEOUT_BIT,
 	REQ_F_ISREG_BIT,
-	REQ_F_COMP_LOCKED_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
@@ -620,8 +619,6 @@ enum {
 	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
-	/* completion under lock */
-	REQ_F_COMP_LOCKED	= BIT(REQ_F_COMP_LOCKED_BIT),
 	/* needs cleanup */
 	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
 	/* already went through poll handler */
@@ -972,8 +969,8 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 			     struct io_comp_state *cs);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
+static void io_put_req_deferred(struct io_kiocb *req, int nr);
 static void io_double_put_req(struct io_kiocb *req);
-static void __io_double_put_req(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void __io_queue_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
@@ -1325,9 +1322,8 @@ static void io_kill_timeout(struct io_kiocb *req)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, 0);
-		io_put_req(req);
+		io_put_req_deferred(req, 1);
 	}
 }
 
@@ -1378,8 +1374,7 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 		if (link) {
 			__io_queue_linked_timeout(link);
 			/* drop submission reference */
-			link->flags |= REQ_F_COMP_LOCKED;
-			io_put_req(link);
+			io_put_req_deferred(link, 1);
 		}
 		kfree(de);
 	} while (!list_empty(&ctx->defer_list));
@@ -1607,8 +1602,7 @@ static void io_submit_flush_completions(struct io_comp_state *cs)
 		list_del(&req->compl.list);
 		__io_cqring_fill_event(req, req->result, req->compl.cflags);
 		if (!(req->flags & REQ_F_LINK_HEAD)) {
-			req->flags |= REQ_F_COMP_LOCKED;
-			io_put_req(req);
+			io_put_req_deferred(req, 1);
 		} else {
 			spin_unlock_irq(&ctx->completion_lock);
 			io_put_req(req);
@@ -1711,10 +1705,14 @@ static void io_dismantle_req(struct io_kiocb *req)
 	io_req_clean_work(req);
 }
 
-static void __io_free_req_finish(struct io_kiocb *req)
+static void __io_free_req(struct io_kiocb *req)
 {
-	struct io_uring_task *tctx = req->task->io_uring;
-	struct io_ring_ctx *ctx = req->ctx;
+	struct io_uring_task *tctx;
+	struct io_ring_ctx *ctx;
+
+	io_dismantle_req(req);
+	tctx = req->task->io_uring;
+	ctx = req->ctx;
 
 	atomic_long_inc(&tctx->req_complete);
 	if (tctx->in_idle)
@@ -1728,33 +1726,6 @@ static void __io_free_req_finish(struct io_kiocb *req)
 	percpu_ref_put(&ctx->refs);
 }
 
-static void io_req_task_file_table_put(struct callback_head *cb)
-{
-	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
-
-	io_dismantle_req(req);
-	__io_free_req_finish(req);
-}
-
-static void __io_free_req(struct io_kiocb *req)
-{
-	if (!(req->flags & REQ_F_COMP_LOCKED)) {
-		io_dismantle_req(req);
-		__io_free_req_finish(req);
-	} else {
-		int ret;
-
-		init_task_work(&req->task_work, io_req_task_file_table_put);
-		ret = task_work_add(req->task, &req->task_work, TWA_RESUME);
-		if (unlikely(ret)) {
-			struct task_struct *tsk;
-
-			tsk = io_wq_get_task(req->ctx->io_wq);
-			task_work_add(tsk, &req->task_work, 0);
-		}
-	}
-}
-
 static bool io_link_cancel_timeout(struct io_kiocb *req)
 {
 	struct io_timeout_data *io = req->async_data;
@@ -1763,11 +1734,10 @@ static bool io_link_cancel_timeout(struct io_kiocb *req)
 
 	ret = hrtimer_try_to_cancel(&io->timer);
 	if (ret != -1) {
-		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(ctx);
 		req->flags &= ~REQ_F_LINK_HEAD;
-		io_put_req(req);
+		io_put_req_deferred(req, 1);
 		return true;
 	}
 
@@ -1794,17 +1764,12 @@ static bool __io_kill_linked_timeout(struct io_kiocb *req)
 static void io_kill_linked_timeout(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	unsigned long flags;
 	bool wake_ev;
 
-	if (!(req->flags & REQ_F_COMP_LOCKED)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&ctx->completion_lock, flags);
-		wake_ev = __io_kill_linked_timeout(req);
-		spin_unlock_irqrestore(&ctx->completion_lock, flags);
-	} else {
-		wake_ev = __io_kill_linked_timeout(req);
-	}
+	spin_lock_irqsave(&ctx->completion_lock, flags);
+	wake_ev = __io_kill_linked_timeout(req);
+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	if (wake_ev)
 		io_cqring_ev_posted(ctx);
@@ -1844,27 +1809,20 @@ static void __io_fail_links(struct io_kiocb *req)
 		trace_io_uring_fail_link(req, link);
 
 		io_cqring_fill_event(link, -ECANCELED);
-		link->flags |= REQ_F_COMP_LOCKED;
-		__io_double_put_req(link);
+		io_put_req_deferred(link, 2);
 	}
 
 	io_commit_cqring(ctx);
-	io_cqring_ev_posted(ctx);
 }
 
 static void io_fail_links(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	unsigned long flags;
 
-	if (!(req->flags & REQ_F_COMP_LOCKED)) {
-		unsigned long flags;
-
-		spin_lock_irqsave(&ctx->completion_lock, flags);
-		__io_fail_links(req);
-		spin_unlock_irqrestore(&ctx->completion_lock, flags);
-	} else {
-		__io_fail_links(req);
-	}
+	spin_lock_irqsave(&ctx->completion_lock, flags);
+	__io_fail_links(req);
+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
 
 	io_cqring_ev_posted(ctx);
 }
@@ -2078,6 +2036,34 @@ static void io_put_req(struct io_kiocb *req)
 		io_free_req(req);
 }
 
+static void io_put_req_deferred_cb(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+
+	io_free_req(req);
+}
+
+static void io_free_req_deferred(struct io_kiocb *req)
+{
+	int ret;
+
+	init_task_work(&req->task_work, io_put_req_deferred_cb);
+	ret = io_req_task_work_add(req, true);
+	if (unlikely(ret)) {
+		struct task_struct *tsk;
+
+		tsk = io_wq_get_task(req->ctx->io_wq);
+		task_work_add(tsk, &req->task_work, 0);
+		wake_up_process(tsk);
+	}
+}
+
+static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
+{
+	if (refcount_sub_and_test(refs, &req->refs))
+		io_free_req_deferred(req);
+}
+
 static struct io_wq_work *io_steal_work(struct io_kiocb *req)
 {
 	struct io_kiocb *nxt;
@@ -2094,17 +2080,6 @@ static struct io_wq_work *io_steal_work(struct io_kiocb *req)
 	return nxt ? &nxt->work : NULL;
 }
 
-/*
- * Must only be used if we don't need to care about links, usually from
- * within the completion handling itself.
- */
-static void __io_double_put_req(struct io_kiocb *req)
-{
-	/* drop both submit and complete references */
-	if (refcount_sub_and_test(2, &req->refs))
-		__io_free_req(req);
-}
-
 static void io_double_put_req(struct io_kiocb *req)
 {
 	/* drop both submit and complete references */
@@ -5134,9 +5109,8 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 	if (do_complete) {
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(req->ctx);
-		req->flags |= REQ_F_COMP_LOCKED;
 		req_set_fail_links(req);
-		io_put_req(req);
+		io_put_req_deferred(req, 1);
 	}
 
 	return do_complete;
@@ -5318,9 +5292,8 @@ static int __io_timeout_cancel(struct io_kiocb *req)
 	list_del_init(&req->timeout.list);
 
 	req_set_fail_links(req);
-	req->flags |= REQ_F_COMP_LOCKED;
 	io_cqring_fill_event(req, -ECANCELED);
-	io_put_req(req);
+	io_put_req_deferred(req, 1);
 	return 0;
 }
 
-- 
2.24.0

