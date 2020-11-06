Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DDF32A96A1
	for <lists+io-uring@lfdr.de>; Fri,  6 Nov 2020 14:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727351AbgKFNDs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 Nov 2020 08:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727345AbgKFNDs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 Nov 2020 08:03:48 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C83C1C0613CF
        for <io-uring@vger.kernel.org>; Fri,  6 Nov 2020 05:03:47 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id w1so1251619wrm.4
        for <io-uring@vger.kernel.org>; Fri, 06 Nov 2020 05:03:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=pd8NHZqCX1Ko7mkwWtNRfcNp48zDaPxNvYyTCF64Zdo=;
        b=QxVSW3lApfIJ0x4X3SoHdZcijuYfB8WJx3HiHxGuSkhUxxgIaZVG6MpyuQhcpdaux5
         dScqcxB5EaUsE1CmaRfvoRsX0uLWFdI4jZKFpkpQtQipGXcigwwBeZfC19DmVc4efp15
         GciBIPaBLbrdUV3wuRXwpHnVJclhVbGTNXndwVqFRpN4Ehgk69rbnuCZWoIgji6YfY2A
         hYAuVY1sStmdByRaZ3XtmMUZc1shcpfH9XMB5ulOcCkn2wTKpXJt0/JOhT8uxHnniQFt
         tO1qaawSWF0WcexvzliVb/73UO0zexZVn0IzyMTbu5EUCX92239/22GEdSE2+qDpxQ5J
         Sh3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=pd8NHZqCX1Ko7mkwWtNRfcNp48zDaPxNvYyTCF64Zdo=;
        b=b98HdXinSFasuFESafas9GkdNppaBsz3qQbgqsOHTtNFsgKAvzsz29XGiJwRP86y0w
         TfddgiuysdmN4tWO1BxD/WIZjSbvKl6AevTWgK00QSmnhT01JyKIV3W70fgq4mXOFpCs
         xjRGaq5LbIbIDLLiVRo5kc16p+BNSK6jCGUxx6DOIviZli+Yu02qenoaa4tyJtnzuPjq
         /jvJ2IBn8AVt0VIZgpwWKnRsqRJ9mvdKOKZiehV4LXXWHC3Kz4PH0+ZkykNzm6JiyxZ6
         7ab30xSxGmsj6J3F5AhPiCAZhcsbVrhPNp3/G8HOZfRYeWz5UBEfntYKWQogp1T+PCM1
         e8Iw==
X-Gm-Message-State: AOAM5310sD6ljxpVuq09wrOkUdsCKIwqwT3n3ENa8f8JWlQsOz1dTvFm
        gKrmf4290aiASY+WFxI0+600kP7EK+0=
X-Google-Smtp-Source: ABdhPJzocEWKcA91qaRabWtLStLD95CC4mpzqnQ6OvT/fMnqdsMUcTNkEmub5XcnGDJUSy6eqhzHTQ==
X-Received: by 2002:a5d:4e10:: with SMTP id p16mr2638978wrt.191.1604667826457;
        Fri, 06 Nov 2020 05:03:46 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-228.range109-152.btcentralplus.com. [109.152.100.228])
        by smtp.gmail.com with ESMTPSA id e5sm1931839wrw.93.2020.11.06.05.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 05:03:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 6/6] io_uring: always batch cancel in *cancel_files()
Date:   Fri,  6 Nov 2020 13:00:26 +0000
Message-Id: <0b3e36b099576602432c6f8ad84b2abf73cd1660.1604667122.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1604667122.git.asml.silence@gmail.com>
References: <cover.1604667122.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Instead of iterating over each request and cancelling it individually in
io_uring_cancel_files(), try to cancel all matching requests and use
->inflight_list only to check if there anything left.

In many cases it should be faster, and we can reuse a lot of code from
task cancellation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io-wq.c    |  10 ----
 fs/io-wq.h    |   1 -
 fs/io_uring.c | 135 ++++++++------------------------------------------
 3 files changed, 21 insertions(+), 125 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b53c055bea6a..f72d53848dcb 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -1078,16 +1078,6 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 	return IO_WQ_CANCEL_NOTFOUND;
 }
 
-static bool io_wq_io_cb_cancel_data(struct io_wq_work *work, void *data)
-{
-	return work == data;
-}
-
-enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork)
-{
-	return io_wq_cancel_cb(wq, io_wq_io_cb_cancel_data, (void *)cwork, false);
-}
-
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 {
 	int ret = -ENOMEM, node;
diff --git a/fs/io-wq.h b/fs/io-wq.h
index cba36f03c355..069496c6d4f9 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -129,7 +129,6 @@ static inline bool io_wq_is_hashed(struct io_wq_work *work)
 }
 
 void io_wq_cancel_all(struct io_wq *wq);
-enum io_wq_cancel io_wq_cancel_work(struct io_wq *wq, struct io_wq_work *cwork);
 
 typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
 
diff --git a/fs/io_uring.c b/fs/io_uring.c
index c93060149087..a4146b1f50ef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1576,15 +1576,6 @@ static void io_kill_timeout(struct io_kiocb *req)
 	}
 }
 
-static bool io_task_match(struct io_kiocb *req, struct task_struct *tsk)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (!tsk || req->task == tsk)
-		return true;
-	return (ctx->flags & IORING_SETUP_SQPOLL);
-}
-
 /*
  * Returns true if we found and killed one or more timeouts
  */
@@ -8656,108 +8647,31 @@ static int io_uring_release(struct inode *inode, struct file *file)
 	return 0;
 }
 
-/*
- * Returns true if 'preq' is the link parent of 'req'
- */
-static bool io_match_link(struct io_kiocb *preq, struct io_kiocb *req)
-{
-	struct io_kiocb *link;
-
-	io_for_each_link(link, preq->link) {
-		if (link == req)
-			return true;
-	}
-	return false;
-}
-
-/*
- * We're looking to cancel 'req' because it's holding on to our files, but
- * 'req' could be a link to another request. See if it is, and cancel that
- * parent request if so.
- */
-static bool io_poll_remove_link(struct io_ring_ctx *ctx, struct io_kiocb *req)
-{
-	struct hlist_node *tmp;
-	struct io_kiocb *preq;
-	bool found = false;
-	int i;
-
-	spin_lock_irq(&ctx->completion_lock);
-	for (i = 0; i < (1U << ctx->cancel_hash_bits); i++) {
-		struct hlist_head *list;
-
-		list = &ctx->cancel_hash[i];
-		hlist_for_each_entry_safe(preq, tmp, list, hash_node) {
-			found = io_match_link(preq, req);
-			if (found) {
-				io_poll_remove_one(preq);
-				break;
-			}
-		}
-	}
-	spin_unlock_irq(&ctx->completion_lock);
-	return found;
-}
-
-static bool io_timeout_remove_link(struct io_ring_ctx *ctx,
-				   struct io_kiocb *req)
-{
-	struct io_kiocb *preq;
-	bool found = false;
-
-	spin_lock_irq(&ctx->completion_lock);
-	list_for_each_entry(preq, &ctx->timeout_list, timeout.list) {
-		found = io_match_link(preq, req);
-		if (found) {
-			__io_timeout_cancel(preq);
-			break;
-		}
-	}
-	spin_unlock_irq(&ctx->completion_lock);
-	return found;
-}
+struct io_task_cancel {
+	struct task_struct *task;
+	struct files_struct *files;
+};
 
-static bool io_cancel_link_cb(struct io_wq_work *work, void *data)
+static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
 {
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
+	struct io_task_cancel *cancel = data;
 	bool ret;
 
-	if (req->flags & REQ_F_LINK_TIMEOUT) {
+	if (cancel->files && (req->flags & REQ_F_LINK_TIMEOUT)) {
 		unsigned long flags;
 		struct io_ring_ctx *ctx = req->ctx;
 
 		/* protect against races with linked timeouts */
 		spin_lock_irqsave(&ctx->completion_lock, flags);
-		ret = io_match_link(req, data);
+		ret = io_match_task(req, cancel->task, cancel->files);
 		spin_unlock_irqrestore(&ctx->completion_lock, flags);
 	} else {
-		ret = io_match_link(req, data);
+		ret = io_match_task(req, cancel->task, cancel->files);
 	}
 	return ret;
 }
 
-static void io_attempt_cancel(struct io_ring_ctx *ctx, struct io_kiocb *req)
-{
-	enum io_wq_cancel cret;
-
-	/* cancel this particular work, if it's running */
-	cret = io_wq_cancel_work(ctx->io_wq, &req->work);
-	if (cret != IO_WQ_CANCEL_NOTFOUND)
-		return;
-
-	/* find links that hold this pending, cancel those */
-	cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_link_cb, req, true);
-	if (cret != IO_WQ_CANCEL_NOTFOUND)
-		return;
-
-	/* if we have a poll link holding this pending, cancel that */
-	if (io_poll_remove_link(ctx, req))
-		return;
-
-	/* final option, timeout link is holding this req pending */
-	io_timeout_remove_link(ctx, req);
-}
-
 static void io_cancel_defer_files(struct io_ring_ctx *ctx,
 				  struct task_struct *task,
 				  struct files_struct *files)
@@ -8789,8 +8703,10 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				  struct files_struct *files)
 {
 	while (!list_empty_careful(&ctx->inflight_list)) {
-		struct io_kiocb *cancel_req = NULL, *req;
+		struct io_task_cancel cancel = { .task = task, .files = NULL, };
+		struct io_kiocb *req;
 		DEFINE_WAIT(wait);
+		bool found = false;
 
 		spin_lock_irq(&ctx->inflight_lock);
 		list_for_each_entry(req, &ctx->inflight_list, inflight_entry) {
@@ -8798,23 +8714,21 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 			    (req->work.flags & IO_WQ_WORK_FILES) &&
 			    req->work.identity->files != files)
 				continue;
-			/* req is being completed, ignore */
-			if (!refcount_inc_not_zero(&req->refs))
-				continue;
-			cancel_req = req;
+			found = true;
 			break;
 		}
-		if (cancel_req)
+		if (found)
 			prepare_to_wait(&ctx->inflight_wait, &wait,
 						TASK_UNINTERRUPTIBLE);
 		spin_unlock_irq(&ctx->inflight_lock);
 
 		/* We need to keep going until we don't find a matching req */
-		if (!cancel_req)
+		if (!found)
 			break;
-		/* cancel this request, or head link requests */
-		io_attempt_cancel(ctx, cancel_req);
-		io_put_req(cancel_req);
+
+		io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
+		io_poll_remove_all(ctx, task, files);
+		io_kill_timeouts(ctx, task, files);
 		/* cancellations _may_ trigger task work */
 		io_run_task_work();
 		schedule();
@@ -8822,22 +8736,15 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 	}
 }
 
-static bool io_cancel_task_cb(struct io_wq_work *work, void *data)
-{
-	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
-	struct task_struct *task = data;
-
-	return io_task_match(req, task);
-}
-
 static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 					    struct task_struct *task)
 {
 	while (1) {
+		struct io_task_cancel cancel = { .task = task, .files = NULL, };
 		enum io_wq_cancel cret;
 		bool ret = false;
 
-		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, task, true);
+		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
 		if (cret != IO_WQ_CANCEL_NOTFOUND)
 			ret = true;
 
-- 
2.24.0

