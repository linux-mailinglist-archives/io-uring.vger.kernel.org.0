Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D645755D9ED
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 15:22:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235629AbiF0NgC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jun 2022 09:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiF0NgC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jun 2022 09:36:02 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C76F6362
        for <io-uring@vger.kernel.org>; Mon, 27 Jun 2022 06:36:01 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656336959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=H0JYJ8IO2S6E5ZdsH649EidNbXdzvlMspRSyF8OEuE4=;
        b=h1eUMLt0ZkF8JsyVRkQuD2NIp0yZ/OfZrYt8oR4/lZ8Z4fgfy3wf79999BTdoPdYJXqw9u
        1IOaPIdn3+bL41DVIlaZZx0dJorjTTjH0u7t9rb2+UefuDemhS7plT98YJWDApB2nzdPS7
        ra0flMxH6Wh1pCWhRcXoPen9gvoxgto=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 03/11] io-wq: add infra data structure for fixed workers
Date:   Mon, 27 Jun 2022 21:35:33 +0800
Message-Id: <20220627133541.15223-4-hao.xu@linux.dev>
In-Reply-To: <20220627133541.15223-1-hao.xu@linux.dev>
References: <20220627133541.15223-1-hao.xu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Hao Xu <howeyxu@tencent.com>

Add data sttructure and basic initialization for fixed worker.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 103 ++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 92 insertions(+), 11 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 35ce622f77ba..d9b3aeea2c6a 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -26,6 +26,7 @@ enum {
 	IO_WORKER_F_RUNNING	= 2,	/* account as running */
 	IO_WORKER_F_FREE	= 4,	/* worker on free list */
 	IO_WORKER_F_BOUND	= 8,	/* is doing bounded work */
+	IO_WORKER_F_FIXED	= 16,	/* is a fixed worker */
 	IO_WORKER_F_EXIT	= 32,	/* worker is exiting */
 };
 
@@ -37,6 +38,66 @@ enum {
 	IO_ACCT_STALLED_BIT	= 0,	/* stalled on hash */
 };
 
+struct io_wqe_acct {
+/*
+ *	union {
+ *		// (1) for wqe->acct (normal worker)
+ *		struct {
+ *			unsigned nr_workers;
+ *			unsigned max_workers;
+ *			struct io_wq_work_list work_list;
+ *		};
+ *		// (2) for wqe->fixed_acct (fixed worker)
+ *		struct {
+ *			unsigned nr_workers;
+ *			unsigned max_workers;
+ *			unsigned nr_fixed;
+ *			unsigned max_works;
+ *			struct io_worker **fixed_workers;
+ *		};
+ *		// (3) for fixed worker's private acct
+ *		struct {
+ *			unsigned nr_works;
+ *			unsigned max_works;
+ *			struct io_wq_work_list work_list;
+ *		};
+ *	};
+ */
+	union {
+		struct {
+			unsigned nr_workers;
+			unsigned max_workers;
+		};
+		unsigned nr_works;
+	};
+	unsigned max_works;
+	union {
+		struct io_wq_work_list work_list;
+		struct {
+			unsigned nr_fixed;
+			struct io_worker **fixed_workers;
+		};
+	};
+
+	/*
+	 * nr_running is not meaningful for fixed worker
+	 * but still keep the same logic for it for the
+	 * convinence for now. So do nr_workers and
+	 * max_workers.
+	 */
+	atomic_t nr_running;
+	/*
+	 * For 1), it protects the work_list, the other two member nr_workers
+	 * and max_workers are protected by wqe->lock.
+	 * For 2), it protects nr_fixed, max_works, fixed_workers
+	 * For 3), it protects nr_works, max_works and work_list.
+	 */
+	raw_spinlock_t lock;
+	int index;
+	unsigned long flags;
+	bool fixed_worker_registered;
+};
+
 /*
  * One for each thread in a wqe pool
  */
@@ -62,6 +123,8 @@ struct io_worker {
 		struct rcu_head rcu;
 		struct work_struct work;
 	};
+	int index;
+	struct io_wqe_acct acct;
 };
 
 #if BITS_PER_LONG == 64
@@ -72,16 +135,6 @@ struct io_worker {
 
 #define IO_WQ_NR_HASH_BUCKETS	(1u << IO_WQ_HASH_ORDER)
 
-struct io_wqe_acct {
-	unsigned nr_workers;
-	unsigned max_workers;
-	int index;
-	atomic_t nr_running;
-	raw_spinlock_t lock;
-	struct io_wq_work_list work_list;
-	unsigned long flags;
-};
-
 enum {
 	IO_WQ_ACCT_BOUND,
 	IO_WQ_ACCT_UNBOUND,
@@ -94,6 +147,7 @@ enum {
 struct io_wqe {
 	raw_spinlock_t lock;
 	struct io_wqe_acct acct[IO_WQ_ACCT_NR];
+	struct io_wqe_acct fixed_acct[IO_WQ_ACCT_NR];
 
 	int node;
 
@@ -1205,6 +1259,31 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 			atomic_set(&acct->nr_running, 0);
 			INIT_WQ_LIST(&acct->work_list);
 			raw_spin_lock_init(&acct->lock);
+
+			acct = &wqe->fixed_acct[i];
+			acct->index = i;
+			INIT_WQ_LIST(&acct->work_list);
+			raw_spin_lock_init(&acct->lock);
+			/*
+			 * nr_running for a fixed worker is meaningless
+			 * for now, init it to 1 to wround around the
+			 * io_wqe_dec_running logic
+			 */
+			atomic_set(&acct->nr_running, 1);
+			/*
+			 * max_workers for a fixed worker is meaningless
+			 * for now, init it so since number of fixed workers
+			 * should be controlled by users.
+			 */
+			acct->max_workers = task_rlimit(current, RLIMIT_NPROC);
+			raw_spin_lock_init(&acct->lock);
+			/*
+			 * For fixed worker, not necessary
+			 * but do it explicitly for clearity
+			 */
+			acct->nr_fixed = 0;
+			acct->max_works = 0;
+			acct->fixed_workers = NULL;
 		}
 		wqe->wq = wq;
 		raw_spin_lock_init(&wqe->lock);
@@ -1287,7 +1366,7 @@ static void io_wq_exit_workers(struct io_wq *wq)
 
 static void io_wq_destroy(struct io_wq *wq)
 {
-	int node;
+	int i, node;
 
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
 
@@ -1299,6 +1378,8 @@ static void io_wq_destroy(struct io_wq *wq)
 		};
 		io_wqe_cancel_pending_work(wqe, &match);
 		free_cpumask_var(wqe->cpu_mask);
+		for (i = 0; i < IO_WQ_ACCT_NR; i++)
+			kfree(wqe->fixed_acct[i].fixed_workers);
 		kfree(wqe);
 	}
 	io_wq_put_hash(wq->hash);
-- 
2.25.1

