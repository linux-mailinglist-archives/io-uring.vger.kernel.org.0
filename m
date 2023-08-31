Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA10678E757
	for <lists+io-uring@lfdr.de>; Thu, 31 Aug 2023 09:45:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243991AbjHaHpP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 31 Aug 2023 03:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233744AbjHaHpO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 31 Aug 2023 03:45:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5261A3
        for <io-uring@vger.kernel.org>; Thu, 31 Aug 2023 00:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693467868;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J0Ea6gTjwYcN9NCwG8KZT5W8gLbv0Xxbbmtj4rhOA8U=;
        b=HCRDq6Ypayieu3ylJADEtTjzDFr1aeHVSukwRE20rHVcVwpJ5zcR1gTFPFKjDw7t1OmJ1I
        EX6Ir3L/uUgKfC0BgVKsuiaHJVbdJMJP/kUi5U22BNP1qSyxVZldCBtyJ2Vfk3fx4uuoVz
        /sVqReIH0pHmJa9fiDwv+FCZ9xYS4g4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-23RzO_v0O2WRjgZrBSBj7w-1; Thu, 31 Aug 2023 03:42:37 -0400
X-MC-Unique: 23RzO_v0O2WRjgZrBSBj7w-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6FD78280D588;
        Thu, 31 Aug 2023 07:42:37 +0000 (UTC)
Received: from localhost (unknown [10.72.120.17])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 84D832166B25;
        Thu, 31 Aug 2023 07:42:36 +0000 (UTC)
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     David Howells <dhowells@redhat.com>,
        Chengming Zhou <zhouchengming@bytedance.com>,
        Ming Lei <ming.lei@redhat.com>
Subject: [PATCH] io_uring: fix IO hang in io_wq_put_and_exit from do_exit()
Date:   Thu, 31 Aug 2023 15:42:21 +0800
Message-Id: <20230831074221.2309565-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_wq_put_and_exit() is called from do_exit(), but all requests in io_wq
aren't cancelled in io_uring_cancel_generic() called from do_exit().
Meantime io_wq IO code path may share resource with normal iopoll code
path.

So if any HIPRI request is pending in io_wq_submit_work(), this request
may not get resouce for moving on, given iopoll isn't possible in
io_wq_put_and_exit().

The issue can be triggered when terminating 't/io_uring -n4 /dev/nullb0'
with default null_blk parameters.

Fix it by always cancelling all requests in io_wq from io_uring_cancel_generic(),
and this way is reasonable because io_wq destroying follows cancelling
requests immediately. Based on one patch from Chengming.

Closes: https://lore.kernel.org/linux-block/3893581.1691785261@warthog.procyon.org.uk/
Reported-by: David Howells <dhowells@redhat.com>
Cc: Chengming Zhou <zhouchengming@bytedance.com>,
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 io_uring/io_uring.c | 40 ++++++++++++++++++++++++++++------------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e7675355048d..18d5ab969c29 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -144,7 +144,7 @@ struct io_defer_entry {
 
 static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 					 struct task_struct *task,
-					 bool cancel_all);
+					 bool cancel_all, bool *wq_cancelled);
 
 static void io_queue_sqe(struct io_kiocb *req);
 
@@ -3049,7 +3049,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
 			io_move_task_work_from_local(ctx);
 
-		while (io_uring_try_cancel_requests(ctx, NULL, true))
+		while (io_uring_try_cancel_requests(ctx, NULL, true, NULL))
 			cond_resched();
 
 		if (ctx->sq_data) {
@@ -3231,12 +3231,13 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
 
 static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 						struct task_struct *task,
-						bool cancel_all)
+						bool cancel_all, bool *wq_cancelled)
 {
-	struct io_task_cancel cancel = { .task = task, .all = cancel_all, };
+	struct io_task_cancel cancel = { .task = task, .all = true, };
 	struct io_uring_task *tctx = task ? task->io_uring : NULL;
 	enum io_wq_cancel cret;
 	bool ret = false;
+	bool wq_active = false;
 
 	/* set it so io_req_local_work_add() would wake us up */
 	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
@@ -3249,7 +3250,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		return false;
 
 	if (!task) {
-		ret |= io_uring_try_cancel_iowq(ctx);
+		wq_active = io_uring_try_cancel_iowq(ctx);
 	} else if (tctx && tctx->io_wq) {
 		/*
 		 * Cancels requests of all rings, not only @ctx, but
@@ -3257,11 +3258,20 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
 		 */
 		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_task_cb,
 				       &cancel, true);
-		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+		wq_active = (cret != IO_WQ_CANCEL_NOTFOUND);
 	}
+	ret |= wq_active;
+	if (wq_cancelled)
+		*wq_cancelled = !wq_active;
 
-	/* SQPOLL thread does its own polling */
-	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
+	/*
+	 * SQPOLL thread does its own polling
+	 *
+	 * io_wq may share IO resources(such as requests) with iopoll, so
+	 * iopoll requests have to be reapped for providing forward
+	 * progress to io_wq cancelling
+	 */
+	if (!(ctx->flags & IORING_SETUP_SQPOLL) ||
 	    (ctx->sq_data && ctx->sq_data->thread == current)) {
 		while (!wq_list_empty(&ctx->iopoll_list)) {
 			io_iopoll_try_reap_events(ctx);
@@ -3313,11 +3323,12 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 	atomic_inc(&tctx->in_cancel);
 	do {
 		bool loop = false;
+		bool wq_cancelled;
 
 		io_uring_drop_tctx_refs(current);
 		/* read completions before cancelations */
 		inflight = tctx_inflight(tctx, !cancel_all);
-		if (!inflight)
+		if (!inflight && !tctx->io_wq)
 			break;
 
 		if (!sqd) {
@@ -3326,20 +3337,25 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
 				if (node->ctx->sq_data)
 					continue;
 				loop |= io_uring_try_cancel_requests(node->ctx,
-							current, cancel_all);
+							current, cancel_all,
+							&wq_cancelled);
 			}
 		} else {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				loop |= io_uring_try_cancel_requests(ctx,
 								     current,
-								     cancel_all);
+								     cancel_all,
+								     &wq_cancelled);
 		}
 
-		if (loop) {
+		if (!wq_cancelled || (inflight && loop)) {
 			cond_resched();
 			continue;
 		}
 
+		if (!inflight)
+			break;
+
 		prepare_to_wait(&tctx->wait, &wait, TASK_INTERRUPTIBLE);
 		io_run_task_work();
 		io_uring_drop_tctx_refs(current);
-- 
2.41.0

