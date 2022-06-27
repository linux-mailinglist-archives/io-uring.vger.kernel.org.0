Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F32F55D7C2
	for <lists+io-uring@lfdr.de>; Tue, 28 Jun 2022 15:18:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235949AbiF0NgP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Jun 2022 09:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234557AbiF0NgP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Jun 2022 09:36:15 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF246362
        for <io-uring@vger.kernel.org>; Mon, 27 Jun 2022 06:36:14 -0700 (PDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656336973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=21GvqUh+eSxTwP7XE55aCv2mhTFoxlA4FnB4sAjQh+s=;
        b=BgPsTRcNrFcEgbyuW29P9KFbgM+a9001rA2WKXtw3rQP8PYr2qWvV5+XBO/VV2pMm9RgKe
        P6U7LMlWSlhnldOMGKnnKtldRinnnWJL6e09PZBqIkl+9Z8A7HPZj1HqzQQATV54ACHNFk
        Rz6+dsjpZhEQw7Wct/pUeQioR09+lyU=
From:   Hao Xu <hao.xu@linux.dev>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 08/11] io-wq: batch the handling of fixed worker private works
Date:   Mon, 27 Jun 2022 21:35:38 +0800
Message-Id: <20220627133541.15223-9-hao.xu@linux.dev>
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

Reduce acct->lock contension by batching the handling of private work
list for fixed_workers.

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 io_uring/io-wq.c | 42 +++++++++++++++++++++++++++++++++---------
 io_uring/io-wq.h |  5 +++++
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index c87ba38f27b1..ce754c78ecac 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -545,8 +545,23 @@ static bool io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
 	return ret;
 }
 
+static inline void conditional_acct_lock(struct io_wqe_acct *acct,
+					 bool needs_lock)
+{
+	if (needs_lock)
+		raw_spin_lock(&acct->lock);
+}
+
+static inline void conditional_acct_unlock(struct io_wqe_acct *acct,
+					   bool needs_lock)
+{
+	if (needs_lock)
+		raw_spin_unlock(&acct->lock);
+}
+
 static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
-					   struct io_worker *worker)
+					   struct io_worker *worker,
+					   bool needs_lock)
 	__must_hold(acct->lock)
 {
 	struct io_wq_work_node *node, *prev;
@@ -554,6 +569,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 	unsigned int stall_hash = -1U;
 	struct io_wqe *wqe = worker->wqe;
 
+	conditional_acct_lock(acct, needs_lock);
 	wq_list_for_each(node, prev, &acct->work_list) {
 		unsigned int hash;
 
@@ -562,6 +578,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
 			wq_list_del(&acct->work_list, node, prev);
+			conditional_acct_unlock(acct, needs_lock);
 			return work;
 		}
 
@@ -573,6 +590,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		if (!test_and_set_bit(hash, &wqe->wq->hash->map)) {
 			wqe->hash_tail[hash] = NULL;
 			wq_list_cut(&acct->work_list, &tail->list, prev);
+			conditional_acct_unlock(acct, needs_lock);
 			return work;
 		}
 		if (stall_hash == -1U)
@@ -589,15 +607,16 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		 * work being added and clearing the stalled bit.
 		 */
 		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
-		raw_spin_unlock(&acct->lock);
+		conditional_acct_unlock(acct, needs_lock);
 		unstalled = io_wait_on_hash(wqe, stall_hash);
-		raw_spin_lock(&acct->lock);
+		conditional_acct_lock(acct, needs_lock);
 		if (unstalled) {
 			clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 			if (wq_has_sleeper(&wqe->wq->hash->wait))
 				wake_up(&wqe->wq->hash->wait);
 		}
 	}
+	conditional_acct_unlock(acct, needs_lock);
 
 	return NULL;
 }
@@ -631,7 +650,7 @@ static void io_assign_current_work(struct io_worker *worker,
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 
 static void io_worker_handle_work(struct io_worker *worker,
-				  struct io_wqe_acct *acct)
+				  struct io_wqe_acct *acct, bool needs_lock)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
@@ -647,9 +666,7 @@ static void io_worker_handle_work(struct io_worker *worker,
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		raw_spin_lock(&acct->lock);
-		work = io_get_next_work(acct, worker);
-		raw_spin_unlock(&acct->lock);
+		work = io_get_next_work(acct, worker, needs_lock);
 		if (work) {
 			__io_worker_busy(wqe, worker);
 
@@ -706,12 +723,19 @@ static void io_worker_handle_work(struct io_worker *worker,
 
 static inline void io_worker_handle_private_work(struct io_worker *worker)
 {
-	io_worker_handle_work(worker, &worker->acct);
+	struct io_wqe_acct acct;
+
+	raw_spin_lock(&worker->acct.lock);
+	acct = worker->acct;
+	wq_list_clean(&worker->acct.work_list);
+	worker->acct.nr_works = 0;
+	raw_spin_unlock(&worker->acct.lock);
+	io_worker_handle_work(worker, &acct, false);
 }
 
 static inline void io_worker_handle_public_work(struct io_worker *worker)
 {
-	io_worker_handle_work(worker, io_wqe_get_acct(worker));
+	io_worker_handle_work(worker, io_wqe_get_acct(worker), true);
 }
 
 static int io_wqe_worker(void *data)
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 10b80ef78bb8..78efbb8c53f0 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -32,6 +32,11 @@ enum io_wq_cancel {
 	(list)->first = NULL;					\
 } while (0)
 
+static inline void wq_list_clean(struct io_wq_work_list *list)
+{
+	list->first = list->last = NULL;
+}
+
 static inline void wq_list_add_after(struct io_wq_work_node *node,
 				     struct io_wq_work_node *pos,
 				     struct io_wq_work_list *list)
-- 
2.25.1

