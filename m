Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E957299FE
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 14:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240524AbjFIM3g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 08:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240531AbjFIM3d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 08:29:33 -0400
Received: from out-28.mta0.migadu.com (out-28.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D91473C14
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 05:28:54 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686313270;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CbfluvVmDKK5YgTgobgtoj9vZ7mG0cgUcWql500V/a8=;
        b=Ne6l0UK0g9XrDmTYsKwrL+MyUfHCmdsY0TU31AneYWW7+maZ4wfM/aM3oAxUzHZh4clgMF
        QDR3aSzxMqYOVGKrOZrzSGsnCmyl2v31HAyg820hgwYAoVBGUURAxcthv7b0qaYStOMxqX
        05x+fJzy+h5Yg0do6qyPiVeqB4t/SWU=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 11/11] io_uring: add IORING_SETUP_FIXED_WORKER_ONLY and its friend
Date:   Fri,  9 Jun 2023 20:20:31 +0800
Message-Id: <20230609122031.183730-12-hao.xu@linux.dev>
In-Reply-To: <20230609122031.183730-1-hao.xu@linux.dev>
References: <20230609122031.183730-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add a new setup flag to indicate that the uring instance only use fixed
workers as async offload threads. Add a work flag and its code logic as
well.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 include/uapi/linux/io_uring.h | 10 +++++++++-
 io_uring/io-wq.c              | 18 +++++++++++++-----
 io_uring/io-wq.h              |  1 +
 io_uring/io_uring.c           | 24 +++++++++++++++++++-----
 4 files changed, 42 insertions(+), 11 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index b0a6e3106b42..900fedaa5692 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -185,6 +185,11 @@ enum {
  */
 #define IORING_SETUP_REGISTERED_FD_ONLY	(1U << 15)
 
+/*
+ * this ring instance only use fixed worker for async offload.
+ */
+#define IORING_SETUP_FIXED_WORKER_ONLY	(1U << 16)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
@@ -721,9 +726,12 @@ struct io_uring_recvmsg_out {
 	__u32 flags;
 };
 
+#define IORING_FIXED_WORKER_F_ONLY (1U << 0)
+#define IORING_FIXED_WORKER_F_VALID (IORING_FIXED_WORKER_F_ONLY)
+
 struct io_uring_fixed_worker_arg {
 	__u32	nr_workers;
-	__u32	resv;
+	__u32	flags;
 	__u64	resv2[3];
 };
 
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 7a9e5fa19b81..98a16abb2944 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -272,7 +272,7 @@ static inline bool io_acct_run_queue(struct io_wq_acct *acct)
  * caller must create one.
  */
 static bool io_wq_activate_free_worker(struct io_wq *wq,
-					struct io_wq_acct *acct)
+					struct io_wq_acct *acct, bool fixed)
 	__must_hold(RCU)
 {
 	struct hlist_nulls_node *n;
@@ -286,7 +286,8 @@ static bool io_wq_activate_free_worker(struct io_wq *wq,
 	hlist_nulls_for_each_entry_rcu(worker, n, &wq->free_list, nulls_node) {
 		if (!io_worker_get(worker))
 			continue;
-		if (io_wq_get_acct(worker) != acct) {
+		if (io_wq_get_acct(worker) != acct ||
+		    (fixed && !is_fixed_worker(worker))) {
 			io_worker_release(worker);
 			continue;
 		}
@@ -492,6 +493,9 @@ static struct io_wq_work *io_get_next_work(struct io_wq_acct *acct,
 
 		work = container_of(node, struct io_wq_work, list);
 
+		if ((work->flags & IO_WQ_WORK_FIXED) && !is_fixed_worker(worker))
+			continue;
+
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
 			wq_list_del(&acct->work_list, node, prev);
@@ -946,7 +950,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 	struct io_wq_acct *acct = io_work_get_acct(wq, work);
 	struct io_cb_cancel_data match;
 	unsigned work_flags = work->flags;
-	bool do_create;
+	bool do_create, fixed = work_flags & IO_WQ_WORK_FIXED;
 
 	/*
 	 * If io-wq is exiting for this task, or if the request has explicitly
@@ -965,11 +969,14 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 
 	raw_spin_lock(&wq->lock);
 	rcu_read_lock();
-	do_create = !io_wq_activate_free_worker(wq, acct);
+	do_create = !io_wq_activate_free_worker(wq, acct, fixed);
 	rcu_read_unlock();
 
 	raw_spin_unlock(&wq->lock);
 
+	if (fixed)
+		return;
+
 	if (do_create && ((work_flags & IO_WQ_WORK_CONCURRENT) ||
 	    !atomic_read(&acct->nr_running))) {
 		bool did_create;
@@ -1155,7 +1162,7 @@ static int io_wq_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 		struct io_wq_acct *acct = &wq->acct[i];
 
 		if (test_and_clear_bit(IO_ACCT_STALLED_BIT, &acct->flags))
-			io_wq_activate_free_worker(wq, acct);
+			io_wq_activate_free_worker(wq, acct, false);
 	}
 	rcu_read_unlock();
 	return 1;
@@ -1477,6 +1484,7 @@ int io_wq_fixed_workers(struct io_wq *wq, struct io_uring_fixed_worker_arg *coun
 
 	if (ret)
 		goto err;
+
 	return 0;
 
 err:
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 15e93af36511..d81d5f9aa602 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -11,6 +11,7 @@ enum {
 	IO_WQ_WORK_HASHED	= 2,
 	IO_WQ_WORK_UNBOUND	= 4,
 	IO_WQ_WORK_CONCURRENT	= 16,
+	IO_WQ_WORK_FIXED	= 32,
 
 	IO_WQ_HASH_SHIFT	= 24,	/* upper 8 bits are used for hash key */
 };
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b37224cc1d05..bf8232906605 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -479,6 +479,9 @@ void io_queue_iowq(struct io_kiocb *req, struct io_tw_state *ts_dont_use)
 	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
 		req->work.flags |= IO_WQ_WORK_CANCEL;
 
+	if (req->ctx->flags & IORING_SETUP_FIXED_WORKER_ONLY)
+		req->work.flags |= IO_WQ_WORK_FIXED;
+
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
 	if (link)
@@ -1971,7 +1974,12 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 
 	req = io_put_req_find_next(req);
-	return req ? &req->work : NULL;
+	if (req) {
+		req->work.flags |= IO_WQ_WORK_FIXED;
+		return &req->work;
+	}
+
+	return NULL;
 }
 
 void io_wq_submit_work(struct io_wq_work *work)
@@ -4364,7 +4372,7 @@ static __cold int io_register_iowq_fixed_workers(struct io_ring_ctx *ctx,
 	struct io_uring_fixed_worker_arg *res;
 	size_t size;
 	int i, ret;
-	bool zero = true;
+	bool zero = true, fixed_only = false;
 
 	size = array_size(nr_args, sizeof(*res));
 	if (size == SIZE_MAX)
@@ -4375,15 +4383,20 @@ static __cold int io_register_iowq_fixed_workers(struct io_ring_ctx *ctx,
 		return PTR_ERR(res);
 
 	for (i = 0; i < nr_args; i++) {
-		if (res[i].nr_workers) {
+		if (res[i].flags & ~IORING_FIXED_WORKER_F_VALID)
+			return -EINVAL;
+		if (res[i].flags & IORING_FIXED_WORKER_F_ONLY)
+			fixed_only = true;
+		if (res[i].nr_workers)
 			zero = false;
-			break;
-		}
 	}
 
 	if (zero)
 		return 0;
 
+	if (fixed_only)
+		ctx->flags |= IORING_SETUP_FIXED_WORKER_ONLY;
+
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		sqd = ctx->sq_data;
 		if (sqd) {
@@ -4423,6 +4436,7 @@ static __cold int io_unregister_iowq_fixed_workers(struct io_ring_ctx *ctx)
 	struct io_sq_data *sqd = NULL;
 	int ret;
 
+	ctx->flags &= ~IORING_SETUP_FIXED_WORKER_ONLY;
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		sqd = ctx->sq_data;
 		if (sqd) {
-- 
2.25.1

