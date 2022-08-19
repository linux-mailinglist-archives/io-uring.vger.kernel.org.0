Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A117599E49
	for <lists+io-uring@lfdr.de>; Fri, 19 Aug 2022 17:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349602AbiHSP23 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Aug 2022 11:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349752AbiHSP2Z (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Aug 2022 11:28:25 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40B279FE6
        for <io-uring@vger.kernel.org>; Fri, 19 Aug 2022 08:28:21 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1660922899;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=WD7SoHYymjSTTeE3AJHxzP2Cwryq4jimi6cQjT+wM8Q=;
        b=KidFq+2U4P5iyOSXqi4Icv4Wj6t3RweY4GvFnyeE8yewJuRaDaNVS2eXeGCeU52k9ygE0h
        Tdbw0bFJHdC+oJaDOuNOUhYF6ByLYm/Nxbgepz5oPT8pyIglzNNTCcGdeiVIUeTkwV/P60
        JG1I0vOU1gOTbur+MGQpMnSkEVQqICU=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Wanpeng Li <wanpengli@tencent.com>
Subject: [PATCH 03/19] io_uring: make worker pool per ctx for uringlet mode
Date:   Fri, 19 Aug 2022 23:27:22 +0800
Message-Id: <20220819152738.1111255-4-hao.xu@linux.dev>
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

For uringlet mode, make worker pool per ctx. This is much easier for
implementation. We can make it better later if it's necessary. In
uringlet mode, we need to find the specific ctx in a worker. Add a
member private for this. We set wq->task to NULL for uringlet as
a mark that this is a uringler io-wq.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 include/linux/io_uring_types.h |  1 +
 io_uring/io-wq.c               | 11 ++++++++++-
 io_uring/io-wq.h               |  4 ++++
 io_uring/io_uring.c            |  9 +++++++++
 io_uring/tctx.c                |  8 +++++++-
 5 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 677a25d44d7f..c8093e733a35 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -356,6 +356,7 @@ struct io_ring_ctx {
 	unsigned			sq_thread_idle;
 	/* protected by ->completion_lock */
 	unsigned			evfd_last_cq_tail;
+	struct io_wq			*let;
 };
 
 enum {
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index f631acbd50df..aaa58cbacf60 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -127,6 +127,8 @@ struct io_wq {
 
 	struct task_struct *task;
 
+	void *private;
+
 	struct io_wqe *wqes[];
 };
 
@@ -392,6 +394,11 @@ static bool io_queue_worker_create(struct io_worker *worker,
 	return false;
 }
 
+static inline bool io_wq_is_uringlet(struct io_wq *wq)
+{
+	return wq->private;
+}
+
 static void io_wqe_dec_running(struct io_worker *worker)
 {
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
@@ -1153,6 +1160,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	wq->hash = data->hash;
 	wq->free_work = data->free_work;
 	wq->do_work = data->do_work;
+	wq->private = data->private;
 
 	ret = -ENOMEM;
 	for_each_node(node) {
@@ -1188,7 +1196,8 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		INIT_LIST_HEAD(&wqe->all_list);
 	}
 
-	wq->task = get_task_struct(data->task);
+	if (data->task)
+		wq->task = get_task_struct(data->task);
 	atomic_set(&wq->worker_refs, 1);
 	init_completion(&wq->worker_done);
 	return wq;
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 31228426d192..b9f5ce4493e0 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -41,6 +41,7 @@ struct io_wq_data {
 	struct task_struct *task;
 	io_wq_work_fn *do_work;
 	free_work_fn *free_work;
+	void *private;
 };
 
 struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data);
@@ -80,4 +81,7 @@ static inline bool io_wq_current_is_worker(void)
 	return in_task() && (current->flags & PF_IO_WORKER) &&
 		current->worker_private;
 }
+
+extern struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
+					struct task_struct *task);
 #endif
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 5e4f5b1684dd..cb011a04653b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3318,6 +3318,15 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ret = io_sq_offload_create(ctx, p);
 	if (ret)
 		goto err;
+
+	if (ctx->flags & IORING_SETUP_URINGLET) {
+		ctx->let = io_init_wq_offload(ctx, current);
+		if (IS_ERR(ctx->let)) {
+			ret = PTR_ERR(ctx->let);
+			goto err;
+		}
+	}
+
 	/* always set a rsrc node */
 	ret = io_rsrc_node_switch_start(ctx);
 	if (ret)
diff --git a/io_uring/tctx.c b/io_uring/tctx.c
index 7f97d97fef0a..09c91cd7b5bf 100644
--- a/io_uring/tctx.c
+++ b/io_uring/tctx.c
@@ -12,7 +12,7 @@
 #include "io_uring.h"
 #include "tctx.h"
 
-static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
+struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 					struct task_struct *task)
 {
 	struct io_wq_hash *hash;
@@ -34,9 +34,15 @@ static struct io_wq *io_init_wq_offload(struct io_ring_ctx *ctx,
 	mutex_unlock(&ctx->uring_lock);
 
 	data.hash = hash;
+	/* for uringlet, wq->task is the iouring instance creator */
 	data.task = task;
 	data.free_work = io_wq_free_work;
 	data.do_work = io_wq_submit_work;
+	/* distinguish normal iowq and uringlet by wq->private for now */
+	if (ctx->flags & IORING_SETUP_URINGLET)
+		data.private = ctx;
+	else
+		data.private = NULL;
 
 	/* Do QD, or 4 * CPUS, whatever is smallest */
 	concurrency = min(ctx->sq_entries, 4 * num_online_cpus());
-- 
2.25.1

