Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139987299FB
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 14:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240446AbjFIM3g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 08:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238775AbjFIM3d (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 08:29:33 -0400
Received: from out-20.mta0.migadu.com (out-20.mta0.migadu.com [IPv6:2001:41d0:1004:224b::14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1618A3C15
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 05:28:54 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686313253;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gOeA1+BEjODR6KaxqgAFNYJEiEtPFnsNFz55d6FhHLQ=;
        b=HR+C9pO9iZ1f5ZPg9Xqy3mkfRvANR+P+ERMBkjxDEj5ZBf+wH+rm8NVWcvcQY7Bs27+09c
        wsCDfcg1VDG13xC3lGdadketFdmBUdQhVbc34ZmyKgIkKrITRineesP6Z2627gvkwAYzi1
        qeJU5GMSH95jDI7OooeKk1Aew4ztZmI=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 05/11] io-wq: add a new parameter for creating a new fixed worker
Date:   Fri,  9 Jun 2023 20:20:25 +0800
Message-Id: <20230609122031.183730-6-hao.xu@linux.dev>
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

Add a new parameter when creating new workers to indicate if users
want a normal or fixed worker.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 33 ++++++++++++++++++++-------------
 1 file changed, 20 insertions(+), 13 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index bf9e9af8d9ca..048856eef4d4 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -137,7 +137,7 @@ struct io_cb_cancel_data {
 	bool cancel_all;
 };
 
-static bool create_io_worker(struct io_wq *wq, int index);
+static bool create_io_worker(struct io_wq *wq, int index, bool fixed);
 static void io_wq_dec_running(struct io_worker *worker);
 static bool io_acct_cancel_pending_work(struct io_wq *wq,
 					struct io_wq_acct *acct,
@@ -284,7 +284,8 @@ static bool io_wq_activate_free_worker(struct io_wq *wq,
  * We need a worker. If we find a free one, we're good. If not, and we're
  * below the max number of workers, create one.
  */
-static bool io_wq_create_worker(struct io_wq *wq, struct io_wq_acct *acct)
+static bool io_wq_create_worker(struct io_wq *wq, struct io_wq_acct *acct,
+				bool fixed)
 {
 	/*
 	 * Most likely an attempt to queue unbounded work on an io_wq that
@@ -302,7 +303,7 @@ static bool io_wq_create_worker(struct io_wq *wq, struct io_wq_acct *acct)
 	raw_spin_unlock(&wq->lock);
 	atomic_inc(&acct->nr_running);
 	atomic_inc(&wq->worker_refs);
-	return create_io_worker(wq, acct->index);
+	return create_io_worker(wq, acct->index, fixed);
 }
 
 static void io_wq_inc_running(struct io_worker *worker)
@@ -312,6 +313,11 @@ static void io_wq_inc_running(struct io_worker *worker)
 	atomic_inc(&acct->nr_running);
 }
 
+static bool is_fixed_worker(struct io_worker *worker)
+{
+	return worker->flags & IO_WORKER_F_FIXED;
+}
+
 static void create_worker_cb(struct callback_head *cb)
 {
 	struct io_worker *worker;
@@ -331,7 +337,7 @@ static void create_worker_cb(struct callback_head *cb)
 	}
 	raw_spin_unlock(&wq->lock);
 	if (do_create) {
-		create_io_worker(wq, worker->create_index);
+		create_io_worker(wq, worker->create_index, is_fixed_worker(worker));
 	} else {
 		atomic_dec(&acct->nr_running);
 		io_worker_ref_put(wq);
@@ -398,6 +404,8 @@ static void io_wq_dec_running(struct io_worker *worker)
 		return;
 	if (!io_acct_run_queue(acct))
 		return;
+	if (is_fixed_worker(worker))
+		return;
 
 	atomic_inc(&acct->nr_running);
 	atomic_inc(&wq->worker_refs);
@@ -601,11 +609,6 @@ static bool is_worker_exiting(struct io_worker *worker)
 	return worker->flags & IO_WORKER_F_EXIT;
 }
 
-static bool is_fixed_worker(struct io_worker *worker)
-{
-	return worker->flags & IO_WORKER_F_FIXED;
-}
-
 static int io_wq_worker(void *data)
 {
 	struct io_worker *worker = data;
@@ -806,7 +809,7 @@ static void io_workqueue_create(struct work_struct *work)
 		kfree(worker);
 }
 
-static bool create_io_worker(struct io_wq *wq, int index)
+static bool create_io_worker(struct io_wq *wq, int index, bool fixed)
 {
 	struct io_wq_acct *acct = &wq->acct[index];
 	struct io_worker *worker;
@@ -833,10 +836,14 @@ static bool create_io_worker(struct io_wq *wq, int index)
 	if (index == IO_WQ_ACCT_BOUND)
 		worker->flags |= IO_WORKER_F_BOUND;
 
+	if (fixed)
+		worker->flags |= IO_WORKER_F_FIXED;
+
 	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
-		io_init_new_worker(wq, worker, tsk);
-	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+		if (!fixed)
+			io_init_new_worker(wq, worker, tsk);
+	} else if (fixed || !io_should_retry_thread(PTR_ERR(tsk))) {
 		kfree(worker);
 		goto fail;
 	} else {
@@ -947,7 +954,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 	    !atomic_read(&acct->nr_running))) {
 		bool did_create;
 
-		did_create = io_wq_create_worker(wq, acct);
+		did_create = io_wq_create_worker(wq, acct, false);
 		if (likely(did_create))
 			return;
 
-- 
2.25.1

