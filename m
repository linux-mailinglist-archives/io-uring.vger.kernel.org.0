Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 649FE29091B
	for <lists+io-uring@lfdr.de>; Fri, 16 Oct 2020 18:02:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2410466AbgJPQCl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Oct 2020 12:02:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2410536AbgJPQCl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Oct 2020 12:02:41 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5212FC061755
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:40 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id e10so1767685pfj.1
        for <io-uring@vger.kernel.org>; Fri, 16 Oct 2020 09:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zzupnwQvtOX3yjbgJDCVQ/zDxDButVbU6M7sFndX28U=;
        b=Nm7MU9iRUDVMavB2Vz9WHfbptoRjJkvc8eIss2UBbXi53Ar+6+aUoZ+jJgeP1k4/fJ
         rKgd85Spn2lbpvim45zbwIwm1RrV+/HgWkdhFrFMrHVTqTsc+YNwh4wHS/VMBzP0CAse
         vQRKFC1elrk6pMDku5JIEi1LOLCDYPtpTqpSmEeflKhFwzG1aHVE/tRMEUV460NCw00c
         s1RSXo8amOhnNc/PUDyVihrNis9oPX07k4ASViqWQzvJCx6ucr2YDYmV4GKCMB3YoAKD
         Q8mCLQtQOl7bpQB603+CoMUqkTcpKYY/bkIv+RppXq+53k2V2vhLqqLZzx47yQBitgR5
         WzDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zzupnwQvtOX3yjbgJDCVQ/zDxDButVbU6M7sFndX28U=;
        b=pNy+lzzx9Vo9N3FsXLUXiKjBQM6ZBngTuAlhzsnf6JeOeuyqO6saUExQFwDAIZfL1G
         ZjFY5pQzegWpZu3fwg2pTIwwlkakr0psrKiQ+0iTYDRlE4TcKJlZ6V+ljGo/ZlHlMial
         BJ+Iu8sTLPmwtJ4YVjR8BL51xpWx57qu7jRQzsvB3MGKTqzQGJm6J1o2ehVcUUrm0ht9
         V3mkrZcKlRTBGJ7UBzpBk55QCJS4Nt5YHmvngOftoFOlYHs/nNiHU/h4N/kkesCcy27y
         elqzXYEexRYoZAmPS7JZmlCnToNIX62PmgxtPIn2E7ejoICBLSZtMcQqdyKYYa5SeumQ
         9TwQ==
X-Gm-Message-State: AOAM530rdn+iDGGX8eEQg29mLcf/MbJVOUcZpXB+pp+P6xENIfUb2GdP
        mOCI3QbGE8QqRm8Mf6Kkj5F/FSGYzm/7IgXi
X-Google-Smtp-Source: ABdhPJyfUB6uEMDK3L+9Cye7nHnsdjOP1KrSi7t+q3kRz7jWaXQMd2UKsqCn00SBPp9aAe3bJbPssw==
X-Received: by 2002:aa7:864a:0:b029:158:e6ba:5548 with SMTP id a10-20020aa7864a0000b0290158e6ba5548mr4544411pfo.1.1602864158769;
        Fri, 16 Oct 2020 09:02:38 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id t13sm3190109pfc.1.2020.10.16.09.02.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 09:02:38 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/18] io_uring: fix REQ_F_COMP_LOCKED by killing it
Date:   Fri, 16 Oct 2020 10:02:14 -0600
Message-Id: <20201016160224.1575329-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201016160224.1575329-1-axboe@kernel.dk>
References: <20201016160224.1575329-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

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
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 149 +++++++++++++++++++++++---------------------------
 1 file changed, 69 insertions(+), 80 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b76aecb3443d..19deb768ad07 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -574,7 +574,6 @@ enum {
 	REQ_F_NOWAIT_BIT,
 	REQ_F_LINK_TIMEOUT_BIT,
 	REQ_F_ISREG_BIT,
-	REQ_F_COMP_LOCKED_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_POLLED_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
@@ -613,8 +612,6 @@ enum {
 	REQ_F_LINK_TIMEOUT	= BIT(REQ_F_LINK_TIMEOUT_BIT),
 	/* regular file */
 	REQ_F_ISREG		= BIT(REQ_F_ISREG_BIT),
-	/* completion under lock */
-	REQ_F_COMP_LOCKED	= BIT(REQ_F_COMP_LOCKED_BIT),
 	/* needs cleanup */
 	REQ_F_NEED_CLEANUP	= BIT(REQ_F_NEED_CLEANUP_BIT),
 	/* already went through poll handler */
@@ -963,8 +960,8 @@ static void __io_complete_rw(struct io_kiocb *req, long res, long res2,
 			     struct io_comp_state *cs);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
+static void io_put_req_deferred(struct io_kiocb *req, int nr);
 static void io_double_put_req(struct io_kiocb *req);
-static void __io_double_put_req(struct io_kiocb *req);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void __io_queue_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
@@ -1316,9 +1313,8 @@ static void io_kill_timeout(struct io_kiocb *req)
 		atomic_set(&req->ctx->cq_timeouts,
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&req->timeout.list);
-		req->flags |= REQ_F_COMP_LOCKED;
 		io_cqring_fill_event(req, 0);
-		io_put_req(req);
+		io_put_req_deferred(req, 1);
 	}
 }
 
@@ -1369,8 +1365,7 @@ static void __io_queue_deferred(struct io_ring_ctx *ctx)
 		if (link) {
 			__io_queue_linked_timeout(link);
 			/* drop submission reference */
-			link->flags |= REQ_F_COMP_LOCKED;
-			io_put_req(link);
+			io_put_req_deferred(link, 1);
 		}
 		kfree(de);
 	} while (!list_empty(&ctx->defer_list));
@@ -1597,13 +1592,19 @@ static void io_submit_flush_completions(struct io_comp_state *cs)
 		req = list_first_entry(&cs->list, struct io_kiocb, compl.list);
 		list_del(&req->compl.list);
 		__io_cqring_fill_event(req, req->result, req->compl.cflags);
-		if (!(req->flags & REQ_F_LINK_HEAD)) {
-			req->flags |= REQ_F_COMP_LOCKED;
-			io_put_req(req);
-		} else {
+
+		/*
+		 * io_free_req() doesn't care about completion_lock unless one
+		 * of these flags is set. REQ_F_WORK_INITIALIZED is in the list
+		 * because of a potential deadlock with req->work.fs->lock
+		 */
+		if (req->flags & (REQ_F_FAIL_LINK|REQ_F_LINK_TIMEOUT
+				 |REQ_F_WORK_INITIALIZED)) {
 			spin_unlock_irq(&ctx->completion_lock);
 			io_put_req(req);
 			spin_lock_irq(&ctx->completion_lock);
+		} else {
+			io_put_req(req);
 		}
 	}
 	io_commit_cqring(ctx);
@@ -1702,10 +1703,14 @@ static void io_dismantle_req(struct io_kiocb *req)
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
@@ -1719,33 +1724,6 @@ static void __io_free_req_finish(struct io_kiocb *req)
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
@@ -1754,11 +1732,10 @@ static bool io_link_cancel_timeout(struct io_kiocb *req)
 
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
 
@@ -1785,17 +1762,12 @@ static bool __io_kill_linked_timeout(struct io_kiocb *req)
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
@@ -1835,27 +1807,29 @@ static void __io_fail_links(struct io_kiocb *req)
 		trace_io_uring_fail_link(req, link);
 
 		io_cqring_fill_event(link, -ECANCELED);
-		link->flags |= REQ_F_COMP_LOCKED;
-		__io_double_put_req(link);
+
+		/*
+		 * It's ok to free under spinlock as they're not linked anymore,
+		 * but avoid REQ_F_WORK_INITIALIZED because it may deadlock on
+		 * work.fs->lock.
+		 */
+		if (link->flags & REQ_F_WORK_INITIALIZED)
+			io_put_req_deferred(link, 2);
+		else
+			io_double_put_req(link);
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
@@ -2069,6 +2043,34 @@ static void io_put_req(struct io_kiocb *req)
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
@@ -2085,17 +2087,6 @@ static struct io_wq_work *io_steal_work(struct io_kiocb *req)
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
@@ -5120,9 +5111,8 @@ static bool io_poll_remove_one(struct io_kiocb *req)
 	if (do_complete) {
 		io_cqring_fill_event(req, -ECANCELED);
 		io_commit_cqring(req->ctx);
-		req->flags |= REQ_F_COMP_LOCKED;
 		req_set_fail_links(req);
-		io_put_req(req);
+		io_put_req_deferred(req, 1);
 	}
 
 	return do_complete;
@@ -5304,9 +5294,8 @@ static int __io_timeout_cancel(struct io_kiocb *req)
 	list_del_init(&req->timeout.list);
 
 	req_set_fail_links(req);
-	req->flags |= REQ_F_COMP_LOCKED;
 	io_cqring_fill_event(req, -ECANCELED);
-	io_put_req(req);
+	io_put_req_deferred(req, 1);
 	return 0;
 }
 
-- 
2.28.0

