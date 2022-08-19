Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CF80599E2A
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349079AbiHSP3z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349600AbiHSP3y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:29:54 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 446BCE68EB
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:29:53 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660922991;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=17APm0cBylBacEAcxH6uZOaQSgVlLXSxL+VAr75MkP4=;
        b=Zvid4+WBBkzBlnKJPVqj5XIwqlbhDzGQmrsJmLuKX8YGvi5xk9rMilCElOftKG8QOyZeWI
        ChZo8KYxy04BbOc8Umhx7cAHPy6MOTsgX9pTUopNmNVKkSgPPCx7yMblCJQ76jN/TzUedf
        v1f/NvXrmxp+KhYax9dLbGBbwMFSbMM=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 10/19] io_uring: add io_submit_sqes_let()
Date:   Fri, 19 Aug 2022 23:27:29 +0800
Message-Id: <20220819152738.1111255-11-hao.xu@linux.dev>
In-Reply-To: <20220819152738.1111255-1-hao.xu@linux.dev>
References: <20220819152738.1111255-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add io_submit_sqes_let() for submitting sqes in uringlet mode, and
update logic in schedule time and the io-wq init time.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c    |  1 +
 io_uring/io_uring.c | 55 +++++++++++++++++++++++++++++++++++++++++++++
 io_uring/io_uring.h |  2 ++
 io_uring/tctx.c     |  8 ++++---
 4 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index fe4faff79cf8..00a1cdefb787 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -399,6 +399,7 @@ static void io_wqe_dec_running(struct io_worker *worker)
 		if (!io_worker_test_submit(worker))
 			return;
 
+		io_uringlet_end(wq->private);
 		io_worker_set_scheduled(worker);
 		raw_spin_lock(&wqe->lock);
 		rcu_read_lock();
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 554041705e96..a5fb6fa02ded 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2054,6 +2054,12 @@ static void io_commit_sqring(struct io_ring_ctx *ctx)
 	smp_store_release(&rings->sq.head, ctx->cached_sq_head);
 }
 
+void io_uringlet_end(struct io_ring_ctx *ctx)
+{
+	io_submit_state_end(ctx);
+	io_commit_sqring(ctx);
+}
+
 /*
  * Fetch an sqe, if one is available. Note this returns a pointer to memory
  * that is mapped by userspace. This means that care needs to be taken to
@@ -2141,6 +2147,55 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	io_commit_sqring(ctx);
 	return ret;
 }
+int io_submit_sqes_let(struct io_wq_work *work)
+{
+	struct io_ring_ctx *ctx = (struct io_ring_ctx *)work;
+	unsigned int entries;
+	bool scheduled = false;
+	void *worker = current->worker_private;
+
+	entries = io_sqring_entries(ctx);
+	if (!entries)
+		return IO_URINGLET_EMPTY;
+
+	io_get_task_refs(entries);
+	io_submit_state_start(&ctx->submit_state, entries);
+	do {
+		const struct io_uring_sqe *sqe;
+		struct io_kiocb *req;
+
+		if (unlikely(!io_alloc_req_refill(ctx)))
+			break;
+		req = io_alloc_req(ctx);
+		sqe = io_get_sqe(ctx);
+		if (unlikely(!sqe)) {
+			io_req_add_to_cache(req, ctx);
+			break;
+		}
+
+		if (unlikely(io_submit_sqe(ctx, req, sqe)))
+			break;
+		/*  TODO this one breaks encapsulation */
+		scheduled = io_worker_test_scheduled(worker);
+		if (unlikely(scheduled)) {
+			entries--;
+			break;
+		}
+	} while (--entries);
+
+	/* TODO do this at the schedule time too */
+	if (unlikely(entries))
+		current->io_uring->cached_refs += entries;
+
+	 /* Commit SQ ring head once we've consumed and submitted all SQEs */
+
+	if (scheduled)
+		return IO_URINGLET_SCHEDULED;
+
+	io_uringlet_end(ctx);
+	return IO_URINGLET_INLINE;
+}
+
 
 struct io_wait_queue {
 	struct wait_queue_entry wq;
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index b20d2506a60f..b95d92619607 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -64,9 +64,11 @@ int io_uring_alloc_task_context(struct task_struct *task,
 
 int io_poll_issue(struct io_kiocb *req, bool *locked);
 int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr);
+int io_submit_sqes_let(struct io_wq_work *work);
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin);
 void io_free_batch_list(struct io_ring_ctx *ctx, struct io_wq_work_node *node);
 int io_req_prep_async(struct io_kiocb *req);
+void io_uringlet_end(struct io_ring_ctx *ctx);
 
 struct io_wq_work *io_wq_free_work(struct io_wq_work *work);
 int io_wq_submit_work(struct io_wq_work *work);
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 09c91cd7b5bf..0c15fb8b9a2e 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -37,12 +37,14 @@ struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 	/* for uringlet, wq->task is the iouring instance creator */
 	data.task = task;
 	data.free_work = io_wq_free_work;
-	data.do_work = io_wq_submit_work;
 	/* distinguish normal iowq and uringlet by wq->private for now */
-	if (ctx->flags & IORING_SETUP_URINGLET)
+	if (ctx->flags & IORING_SETUP_URINGLET) {
 		data.private = ctx;
-	else
+		data.do_work = io_submit_sqes_let;
+	} else {
 		data.private = NULL;
+		data.do_work = io_wq_submit_work;
+	}
 
 	/* Do QD, or 4 * CPUS, whatever is smallest */
 	concurrency = min(ctx->sq_entries, 4 * num_online_cpus());
-- 
2.25.1

