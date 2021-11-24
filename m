Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1217C45B3A2
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 05:47:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230132AbhKXEuJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 23:50:09 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:43486 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229714AbhKXEuI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 23:50:08 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uy45oE2_1637729208;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uy45oE2_1637729208)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 12:46:58 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 8/9] io-wq: batch the handling of fixed worker private works
Date:   Wed, 24 Nov 2021 12:46:47 +0800
Message-Id: <20211124044648.142416-9-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211124044648.142416-1-haoxu@linux.alibaba.com>
References: <20211124044648.142416-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Let's reduce acct->lock contension by batching the handling of private
work list for fixed_workers.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 42 ++++++++++++++++++++++++++++++++----------
 fs/io-wq.h |  5 +++++
 2 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b53019d4691d..097ea598bfe5 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -479,7 +479,7 @@ static void io_wait_on_hash(struct io_wqe_acct *acct, unsigned int hash)
 }
 
 static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
-					   struct io_worker *worker)
+					   struct io_worker *worker, bool needs_lock)
 	__must_hold(acct->lock)
 {
 	struct io_wq_work_node *node, *prev;
@@ -487,14 +487,23 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 	unsigned int stall_hash = -1U;
 	struct io_wqe *wqe = worker->wqe;
 
+	if (needs_lock)
+		raw_spin_lock(&acct->lock);
 	wq_list_for_each(node, prev, &acct->work_list) {
 		unsigned int hash;
 
 		work = container_of(node, struct io_wq_work, list);
 
+		/* hash optimization doesn't work for fixed_workers for now */
+		if (!needs_lock) {
+			wq_list_del(&acct->work_list, node, prev);
+			return work;
+		}
+
 		/* not hashed, can run anytime */
 		if (!io_wq_is_hashed(work)) {
 			wq_list_del(&acct->work_list, node, prev);
+			raw_spin_unlock(&acct->lock);
 			return work;
 		}
 
@@ -506,6 +515,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		if (!test_and_set_bit(hash, &wqe->wq->hash->map)) {
 			wqe->hash_tail[hash] = NULL;
 			wq_list_cut(&acct->work_list, &tail->list, prev);
+			raw_spin_unlock(&acct->lock);
 			return work;
 		}
 		if (stall_hash == -1U)
@@ -515,15 +525,21 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 	}
 
 	if (stall_hash != -1U) {
+		if (!needs_lock)
+			acct = &worker->acct;
 		/*
 		 * Set this before dropping the lock to avoid racing with new
 		 * work being added and clearing the stalled bit.
 		 */
 		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
-		raw_spin_unlock(&acct->lock);
+		if (needs_lock)
+			raw_spin_unlock(&acct->lock);
 		io_wait_on_hash(acct, stall_hash);
-		raw_spin_lock(&acct->lock);
+		if (needs_lock)
+			raw_spin_lock(&acct->lock);
 	}
+	if (needs_lock)
+		raw_spin_unlock(&acct->lock);
 
 	return NULL;
 }
@@ -553,7 +569,8 @@ static void io_assign_current_work(struct io_worker *worker,
 
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work);
 
-static void io_worker_handle_work(struct io_worker *worker, struct io_wqe_acct *acct)
+static void io_worker_handle_work(struct io_worker *worker, struct io_wqe_acct *acct,
+				  bool needs_lock)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wq *wq = wqe->wq;
@@ -569,9 +586,7 @@ static void io_worker_handle_work(struct io_worker *worker, struct io_wqe_acct *
 		 * can't make progress, any work completion or insertion will
 		 * clear the stalled flag.
 		 */
-		raw_spin_lock(&acct->lock);
-		work = io_get_next_work(acct, worker);
-		raw_spin_unlock(&acct->lock);
+		work = io_get_next_work(acct, worker, needs_lock);
 		if (work) {
 			raw_spin_lock(&wqe->lock);
 			__io_worker_busy(wqe, worker, work);
@@ -604,7 +619,7 @@ static void io_worker_handle_work(struct io_worker *worker, struct io_wqe_acct *
 			if (linked)
 				io_wqe_enqueue(wqe, linked);
 
-			if (hash != -1U && !next_hashed) {
+			if (needs_lock && hash != -1U && !next_hashed) {
 				clear_bit(hash, &wq->hash->map);
 				clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 				if (wq_has_sleeper(&wq->hash->wait))
@@ -618,12 +633,19 @@ static void io_worker_handle_work(struct io_worker *worker, struct io_wqe_acct *
 
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
diff --git a/fs/io-wq.h b/fs/io-wq.h
index 41bf37674a49..7c330264172b 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -40,6 +40,11 @@ struct io_wq_work_list {
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
2.24.4

