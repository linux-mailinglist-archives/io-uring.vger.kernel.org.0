Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FFD2729A07
	for <lists+io-uring@lfdr.de>; Fri,  9 Jun 2023 14:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231612AbjFIMas (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 9 Jun 2023 08:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239082AbjFIMar (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 9 Jun 2023 08:30:47 -0400
Received: from out-28.mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B3E4273D
        for <io-uring@vger.kernel.org>; Fri,  9 Jun 2023 05:30:08 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1686313265;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GUYNkZQUX2Qc9IRW4xhjXCnw3AmWpQKAecn+j1go0VI=;
        b=NtanpO1rfJFF0k53nnSadLV7httda9WdZlyRG6wglgjI+29LrKDznS1Xvz5MN0++5ih4Wq
        ANKU8/ER8g0ZuHsS3oMeNlVixE1HH7oTdya8qKNLESFg8rHTuYvGy0CzGu/qeYkzUFYCUC
        XAW7AJm0xHWd6BWTxjd43DsyfzFG7rM=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH 09/11] io-wq: add strutures to allow to wait fixed workers exit
Date:   Fri,  9 Jun 2023 20:20:29 +0800
Message-Id: <20230609122031.183730-10-hao.xu@linux.dev>
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

When unregister fixed workers, there should be a way to allow us to wait
all the fixed workers exit.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 72 ++++++++++++++++++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 20 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index f39e6b931d17..61cf6da2c72f 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -108,6 +108,10 @@ struct io_wq {
 	atomic_t worker_refs;
 	struct completion worker_done;
 
+	atomic_t fixed_worker_refs;
+	struct completion fixed_worker_done;
+	bool fixed_comp_init;
+
 	struct hlist_node cpuhp_node;
 
 	struct task_struct *task;
@@ -172,10 +176,25 @@ static inline struct io_wq_acct *io_wq_get_acct(struct io_worker *worker)
 	return io_get_acct(worker->wq, worker->flags & IO_WORKER_F_BOUND);
 }
 
-static void io_worker_ref_put(struct io_wq *wq)
+static void io_worker_ref_get(struct io_wq *wq, bool fixed)
+{
+	atomic_inc(&wq->worker_refs);
+	if (fixed)
+		atomic_inc(&wq->fixed_worker_refs);
+}
+
+static void io_worker_ref_put(struct io_wq *wq, bool fixed)
 {
 	if (atomic_dec_and_test(&wq->worker_refs))
 		complete(&wq->worker_done);
+
+	if (fixed && atomic_dec_and_test(&wq->fixed_worker_refs))
+		complete(&wq->fixed_worker_done);
+}
+
+static bool is_fixed_worker(struct io_worker *worker)
+{
+	return worker->flags & IO_WORKER_F_FIXED;
 }
 
 static void io_worker_cancel_cb(struct io_worker *worker)
@@ -187,7 +206,7 @@ static void io_worker_cancel_cb(struct io_worker *worker)
 	raw_spin_lock(&wq->lock);
 	acct->nr_workers--;
 	raw_spin_unlock(&wq->lock);
-	io_worker_ref_put(wq);
+	io_worker_ref_put(wq, is_fixed_worker(worker));
 	clear_bit_unlock(0, &worker->create_state);
 	io_worker_release(worker);
 }
@@ -205,6 +224,7 @@ static bool io_task_worker_match(struct callback_head *cb, void *data)
 static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wq *wq = worker->wq;
+	bool fixed = is_fixed_worker(worker);
 
 	while (1) {
 		struct callback_head *cb = task_work_cancel_match(wq->task,
@@ -230,7 +250,7 @@ static void io_worker_exit(struct io_worker *worker)
 	preempt_enable();
 
 	kfree_rcu(worker, rcu);
-	io_worker_ref_put(wq);
+	io_worker_ref_put(wq, fixed);
 	do_exit(0);
 }
 
@@ -302,7 +322,7 @@ static struct io_worker *io_wq_create_worker(struct io_wq *wq,
 	acct->nr_workers++;
 	raw_spin_unlock(&wq->lock);
 	atomic_inc(&acct->nr_running);
-	atomic_inc(&wq->worker_refs);
+	io_worker_ref_get(wq, fixed);
 	return create_io_worker(wq, acct->index, fixed);
 }
 
@@ -313,11 +333,6 @@ static void io_wq_inc_running(struct io_worker *worker)
 	atomic_inc(&acct->nr_running);
 }
 
-static bool is_fixed_worker(struct io_worker *worker)
-{
-	return worker->flags & IO_WORKER_F_FIXED;
-}
-
 static void create_worker_cb(struct callback_head *cb)
 {
 	struct io_worker *worker;
@@ -325,8 +340,10 @@ static void create_worker_cb(struct callback_head *cb)
 
 	struct io_wq_acct *acct;
 	bool do_create = false;
+	bool fixed;
 
 	worker = container_of(cb, struct io_worker, create_work);
+	fixed = is_fixed_worker(worker);
 	wq = worker->wq;
 	acct = &wq->acct[worker->create_index];
 	raw_spin_lock(&wq->lock);
@@ -337,10 +354,10 @@ static void create_worker_cb(struct callback_head *cb)
 	}
 	raw_spin_unlock(&wq->lock);
 	if (do_create) {
-		create_io_worker(wq, worker->create_index, is_fixed_worker(worker));
+		create_io_worker(wq, worker->create_index, fixed);
 	} else {
 		atomic_dec(&acct->nr_running);
-		io_worker_ref_put(wq);
+		io_worker_ref_put(wq, fixed);
 	}
 	clear_bit_unlock(0, &worker->create_state);
 	io_worker_release(worker);
@@ -351,6 +368,7 @@ static bool io_queue_worker_create(struct io_worker *worker,
 				   task_work_func_t func)
 {
 	struct io_wq *wq = worker->wq;
+	bool fixed = is_fixed_worker(worker);
 
 	/* raced with exit, just ignore create call */
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
@@ -367,7 +385,7 @@ static bool io_queue_worker_create(struct io_worker *worker,
 	    test_and_set_bit_lock(0, &worker->create_state))
 		goto fail_release;
 
-	atomic_inc(&wq->worker_refs);
+	io_worker_ref_get(wq, fixed);
 	init_task_work(&worker->create_work, func);
 	worker->create_index = acct->index;
 	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL)) {
@@ -379,16 +397,16 @@ static bool io_queue_worker_create(struct io_worker *worker,
 		 */
 		if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
 			io_wq_cancel_tw_create(wq);
-		io_worker_ref_put(wq);
+		io_worker_ref_put(wq, fixed);
 		return true;
 	}
-	io_worker_ref_put(wq);
+	io_worker_ref_put(wq, fixed);
 	clear_bit_unlock(0, &worker->create_state);
 fail_release:
 	io_worker_release(worker);
 fail:
 	atomic_dec(&acct->nr_running);
-	io_worker_ref_put(wq);
+	io_worker_ref_put(wq, fixed);
 	return false;
 }
 
@@ -408,7 +426,7 @@ static void io_wq_dec_running(struct io_worker *worker)
 		return;
 
 	atomic_inc(&acct->nr_running);
-	atomic_inc(&wq->worker_refs);
+	io_worker_ref_get(wq, false);
 	io_queue_worker_create(worker, acct, create_worker_cb);
 }
 
@@ -790,7 +808,7 @@ static void create_worker_cont(struct callback_head *cb)
 		} else {
 			raw_spin_unlock(&wq->lock);
 		}
-		io_worker_ref_put(wq);
+		io_worker_ref_put(wq, is_fixed_worker(worker));
 		kfree(worker);
 		return;
 	}
@@ -824,7 +842,7 @@ static struct io_worker *create_io_worker(struct io_wq *wq, int index, bool fixe
 		raw_spin_lock(&wq->lock);
 		acct->nr_workers--;
 		raw_spin_unlock(&wq->lock);
-		io_worker_ref_put(wq);
+		io_worker_ref_put(wq, fixed);
 		return tsk ? (struct io_worker *)tsk : ERR_PTR(-ENOMEM);
 	}
 
@@ -1243,7 +1261,7 @@ static void io_wq_exit_workers(struct io_wq *wq)
 	rcu_read_lock();
 	io_wq_for_each_worker(wq, io_wq_worker_wake, NULL);
 	rcu_read_unlock();
-	io_worker_ref_put(wq);
+	io_worker_ref_put(wq, false);
 	wait_for_completion(&wq->worker_done);
 
 	spin_lock_irq(&wq->hash->wait.lock);
@@ -1390,6 +1408,7 @@ static void io_wq_clean_fixed_workers(struct io_wq *wq)
 		}
 		kfree(workers);
 	}
+	wait_for_completion(&wq->fixed_worker_done);
 }
 
 /*
@@ -1421,6 +1440,13 @@ int io_wq_fixed_workers(struct io_wq *wq, struct io_uring_fixed_worker_arg *coun
 
 	rcu_read_lock();
 
+	atomic_set(&wq->fixed_worker_refs, 1);
+	if (wq->fixed_comp_init) {
+		reinit_completion(&wq->fixed_worker_done);
+	} else {
+		init_completion(&wq->fixed_worker_done);
+		wq->fixed_comp_init = true;
+	}
 	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 		unsigned int nr = count[i].nr_workers;
 
@@ -1495,12 +1521,18 @@ int io_wq_destroy_fixed_workers(struct io_wq *wq)
 			workers[j]->flags |= IO_WORKER_F_EXIT;
 			wake_up_process(worker->task);
 		}
-		// wait for all workers exit
 		kfree(workers);
 	}
 	raw_spin_unlock(&wq->lock);
 	rcu_read_unlock();
 
+	// decrement the init reference
+	if (atomic_dec_and_test(&wq->fixed_worker_refs))
+		complete(&wq->fixed_worker_done);
+
+	wait_for_completion(&wq->fixed_worker_done);
+	wq->fixed_comp_init = false;
+
 	return 0;
 }
 
-- 
2.25.1

