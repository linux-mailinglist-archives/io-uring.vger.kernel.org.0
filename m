Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94873B9197
	for <lists+io-uring@lfdr.de>; Thu,  1 Jul 2021 14:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236412AbhGAM3A (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Jul 2021 08:29:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236425AbhGAM27 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Jul 2021 08:28:59 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F54C0617AE
        for <io-uring@vger.kernel.org>; Thu,  1 Jul 2021 05:26:28 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id u6so7974728wrs.5
        for <io-uring@vger.kernel.org>; Thu, 01 Jul 2021 05:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Zj+aPb7GVc9+UxpKKUrEewy9eDGvBwr0vosBMcRPx8=;
        b=K0Oim2OfJSWIfSjpx25MZzM6LmUBy6kDg/TreXXnaVHWj9v1KTLbypMTvGwuO/nh6L
         5vChdxYPXMD0goGdGNKfx1IU6zOd1g0J0gjIORPYvGxUzXhtMskj33KRgclPHejA2Jh+
         5h0+Z6ww1Pqj43ezyt9rVsxQ5g7cu+o2x5mXzNGnVctKISAjCK0pnIL8igWDXz7dSUcx
         +1zZfT3cxOK7JeT3OyhKlgeUU6LtWpeKa90KegaKz7wl36oebE3GKwgwYJi6sGY3ctRs
         SKDvBDUqChn32dUEe64h6Hv+NttMKiZZi/5Y+L1Nw6Tx48XLZTBBU+fwq40igdyyy+QE
         Uf0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3Zj+aPb7GVc9+UxpKKUrEewy9eDGvBwr0vosBMcRPx8=;
        b=LfzvoV38VXxwiLX7sPKV7DRQAknlFGPGIPLCcUeJPCSjgiZ5Ya7WY1+FX9vmEJmk6O
         Fm/9J2o0++4o279LRVL+PQlRp8taHuIDMET+znqHzIkqylwMihX7C5cF2U/bTYJdQi95
         QETp7lVqgOoagkcRu/9fWFvopPBwD4KfnzM15YzXFe5de/cZPQlMowhShLwV7i7Yv5V8
         RtJI5msVbfYUmG4RBtw1ITXUdwTqJ/IY6d0jO4+R6669HhZJIY+2EfsfVZwuxH5MQir7
         ttsDs+Wt5rwwv+QUSyFlL8PhccGJ84WEO2mmMIiZlYPty9MZMLzVYd28DvOIt7Zm4DPv
         ghRQ==
X-Gm-Message-State: AOAM5324vK0XMTLYwI76jUnFjaLyxkErDYN1LHUPtMxdijDO4i82a4Yg
        z7hns0IwjpatkmjpdusBtbFpKJ8j2dIO3KFM
X-Google-Smtp-Source: ABdhPJw13PkFAEG/ZFSiLbZHWy/Lg1kjRmL+dvTNUhrd3ChUq87D83QOwLC2i1WIJIGXlmH9T95Z1Q==
X-Received: by 2002:adf:a446:: with SMTP id e6mr28346793wra.187.1625142387497;
        Thu, 01 Jul 2021 05:26:27 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.185])
        by smtp.gmail.com with ESMTPSA id c10sm16550002wmb.40.2021.07.01.05.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Jul 2021 05:26:27 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: fix exiting io_req_task_work_add leaks
Date:   Thu,  1 Jul 2021 13:26:05 +0100
Message-Id: <060002f19f1fdbd130ba24aef818ea4d3080819b.1625142209.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If one entered io_req_task_work_add() not seeing PF_EXITING, it will set
a ->task_state bit and try task_work_add(), which may fail by that
moment. If that happens the function would try to cancel the request.

However, in a meanwhile there might come other io_req_task_work_add()
callers, which will see the bit set and leave their requests in the
list, which will never be executed.

Don't propagate an error, but clear the bit first and then fallback
all requests that we can splice from the list. The callback functions
have to be able to deal with PF_EXITING, so poll and apoll was modified
via changing io_poll_rewait().

Reported-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Jens, can you try if it helps with the leak you meantioned? I can't
see it. As with previous, would need to remove the PF_EXITING check,
and should be in theory safe to do.

 fs/io_uring.c | 70 ++++++++++++++++++---------------------------------
 1 file changed, 24 insertions(+), 46 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5b840bb1e8ec..881856088990 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1952,17 +1952,13 @@ static void tctx_task_work(struct callback_head *cb)
 	ctx_flush_and_put(ctx);
 }
 
-static int io_req_task_work_add(struct io_kiocb *req)
+static void io_req_task_work_add(struct io_kiocb *req)
 {
 	struct task_struct *tsk = req->task;
 	struct io_uring_task *tctx = tsk->io_uring;
 	enum task_work_notify_mode notify;
-	struct io_wq_work_node *node, *prev;
+	struct io_wq_work_node *node;
 	unsigned long flags;
-	int ret = 0;
-
-	if (unlikely(tsk->flags & PF_EXITING))
-		return -ESRCH;
 
 	WARN_ON_ONCE(!tctx);
 
@@ -1973,7 +1969,9 @@ static int io_req_task_work_add(struct io_kiocb *req)
 	/* task_work already pending, we're done */
 	if (test_bit(0, &tctx->task_state) ||
 	    test_and_set_bit(0, &tctx->task_state))
-		return 0;
+		return;
+	if (unlikely(tsk->flags & PF_EXITING))
+		goto fail;
 
 	/*
 	 * SQPOLL kernel thread doesn't need notification, just a wakeup. For
@@ -1982,36 +1980,24 @@ static int io_req_task_work_add(struct io_kiocb *req)
 	 * will do the job.
 	 */
 	notify = (req->ctx->flags & IORING_SETUP_SQPOLL) ? TWA_NONE : TWA_SIGNAL;
-
 	if (!task_work_add(tsk, &tctx->task_work, notify)) {
 		wake_up_process(tsk);
-		return 0;
+		return;
 	}
-
-	/*
-	 * Slow path - we failed, find and delete work. if the work is not
-	 * in the list, it got run and we're fine.
-	 */
+fail:
+	clear_bit(0, &tctx->task_state);
 	spin_lock_irqsave(&tctx->task_lock, flags);
-	wq_list_for_each(node, prev, &tctx->task_list) {
-		if (&req->io_task_work.node == node) {
-			wq_list_del(&tctx->task_list, node, prev);
-			ret = 1;
-			break;
-		}
-	}
+	node = tctx->task_list.first;
+	INIT_WQ_LIST(&tctx->task_list);
 	spin_unlock_irqrestore(&tctx->task_lock, flags);
-	clear_bit(0, &tctx->task_state);
-	return ret;
-}
 
-static void io_req_task_work_add_fallback(struct io_kiocb *req,
-					  io_req_tw_func_t cb)
-{
-	req->io_task_work.func = cb;
-	if (llist_add(&req->io_task_work.fallback_node,
-		      &req->ctx->fallback_llist))
-		schedule_delayed_work(&req->ctx->fallback_work, 1);
+	while (node) {
+		req = container_of(node, struct io_kiocb, io_task_work.node);
+		node = node->next;
+		if (llist_add(&req->io_task_work.fallback_node,
+			      &req->ctx->fallback_llist))
+			schedule_delayed_work(&req->ctx->fallback_work, 1);
+	}
 }
 
 static void io_req_task_cancel(struct io_kiocb *req)
@@ -2041,17 +2027,13 @@ static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
 	req->result = ret;
 	req->io_task_work.func = io_req_task_cancel;
-
-	if (unlikely(io_req_task_work_add(req)))
-		io_req_task_work_add_fallback(req, io_req_task_cancel);
+	io_req_task_work_add(req);
 }
 
 static void io_req_task_queue(struct io_kiocb *req)
 {
 	req->io_task_work.func = io_req_task_submit;
-
-	if (unlikely(io_req_task_work_add(req)))
-		io_req_task_queue_fail(req, -ECANCELED);
+	io_req_task_work_add(req);
 }
 
 static inline void io_queue_next(struct io_kiocb *req)
@@ -2165,8 +2147,7 @@ static inline void io_put_req(struct io_kiocb *req)
 static void io_free_req_deferred(struct io_kiocb *req)
 {
 	req->io_task_work.func = io_free_req;
-	if (unlikely(io_req_task_work_add(req)))
-		io_req_task_work_add_fallback(req, io_free_req);
+	io_req_task_work_add(req);
 }
 
 static inline void io_put_req_deferred(struct io_kiocb *req, int refs)
@@ -4823,8 +4804,6 @@ struct io_poll_table {
 static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 			   __poll_t mask, io_req_tw_func_t func)
 {
-	int ret;
-
 	/* for instances that support it check for an event match first: */
 	if (mask && !(mask & poll->events))
 		return 0;
@@ -4842,11 +4821,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	 * of executing it. We can't safely execute it anyway, as we may not
 	 * have the needed state needed for it anyway.
 	 */
-	ret = io_req_task_work_add(req);
-	if (unlikely(ret)) {
-		WRITE_ONCE(poll->canceled, true);
-		io_req_task_work_add_fallback(req, func);
-	}
+	io_req_task_work_add(req);
 	return 1;
 }
 
@@ -4855,6 +4830,9 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (unlikely(req->task->flags & PF_EXITING))
+		WRITE_ONCE(poll->canceled, true);
+
 	if (!req->result && !READ_ONCE(poll->canceled)) {
 		struct poll_table_struct pt = { ._key = poll->events };
 
-- 
2.32.0

