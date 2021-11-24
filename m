Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5059E45B3A0
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 05:47:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230075AbhKXEuI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 23:50:08 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:47531 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229840AbhKXEuH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 23:50:07 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uy45oE2_1637729208;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uy45oE2_1637729208)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 12:46:56 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 5/9] io-wq: move hash wait entry to io_wqe_acct
Date:   Wed, 24 Nov 2021 12:46:44 +0800
Message-Id: <20211124044648.142416-6-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211124044648.142416-1-haoxu@linux.alibaba.com>
References: <20211124044648.142416-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move wait entry to struct io_wqe_acct since we are going to add private
work list for io_worker in the next patch. This is preparation for the
fixed io-worker feature.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 45 ++++++++++++++++++++++++---------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index dce365013bd5..44c3e344c5d6 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -77,6 +77,8 @@ struct io_wqe_acct {
 	raw_spinlock_t lock;
 	struct io_wq_work_list work_list;
 	unsigned long flags;
+	struct wait_queue_entry wait;
+	struct io_wqe *wqe;
 };
 
 enum {
@@ -97,8 +99,6 @@ struct io_wqe {
 	struct hlist_nulls_head free_list;
 	struct list_head all_list;
 
-	struct wait_queue_entry wait;
-
 	struct io_wq *wq;
 	struct io_wq_work *hash_tail[IO_WQ_NR_HASH_BUCKETS];
 
@@ -431,16 +431,16 @@ static inline unsigned int io_get_work_hash(struct io_wq_work *work)
 	return work->flags >> IO_WQ_HASH_SHIFT;
 }
 
-static void io_wait_on_hash(struct io_wqe *wqe, unsigned int hash)
+static void io_wait_on_hash(struct io_wqe_acct *acct, unsigned int hash)
 {
-	struct io_wq *wq = wqe->wq;
+	struct io_wq *wq = acct->wqe->wq;
 
 	spin_lock_irq(&wq->hash->wait.lock);
-	if (list_empty(&wqe->wait.entry)) {
-		__add_wait_queue(&wq->hash->wait, &wqe->wait);
+	if (list_empty(&acct->wait.entry)) {
+		__add_wait_queue(&wq->hash->wait, &acct->wait);
 		if (!test_bit(hash, &wq->hash->map)) {
 			__set_current_state(TASK_RUNNING);
-			list_del_init(&wqe->wait.entry);
+			list_del_init(&acct->wait.entry);
 		}
 	}
 	spin_unlock_irq(&wq->hash->wait.lock);
@@ -489,7 +489,7 @@ static struct io_wq_work *io_get_next_work(struct io_wqe_acct *acct,
 		 */
 		set_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 		raw_spin_unlock(&acct->lock);
-		io_wait_on_hash(wqe, stall_hash);
+		io_wait_on_hash(acct, stall_hash);
 		raw_spin_lock(&acct->lock);
 	}
 
@@ -1076,19 +1076,17 @@ enum io_wq_cancel io_wq_cancel_cb(struct io_wq *wq, work_cancel_fn *cancel,
 static int io_wqe_hash_wake(struct wait_queue_entry *wait, unsigned mode,
 			    int sync, void *key)
 {
-	struct io_wqe *wqe = container_of(wait, struct io_wqe, wait);
-	int i;
+	struct io_wqe_acct *acct = container_of(wait, struct io_wqe_acct, wait);
+	bool ret;
 
 	list_del_init(&wait->entry);
-
-	rcu_read_lock();
-	for (i = 0; i < IO_WQ_ACCT_NR; i++) {
-		struct io_wqe_acct *acct = &wqe->acct[i];
-
-		if (test_and_clear_bit(IO_ACCT_STALLED_BIT, &acct->flags))
-			io_wqe_activate_free_worker(wqe, acct);
+	ret = test_and_clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
+	if (ret) {
+		rcu_read_lock();
+		io_wqe_activate_free_worker(acct->wqe, acct);
+		rcu_read_unlock();
 	}
-	rcu_read_unlock();
+
 	return 1;
 }
 
@@ -1132,8 +1130,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 		wqe->acct[IO_WQ_ACCT_BOUND].max_workers = bounded;
 		wqe->acct[IO_WQ_ACCT_UNBOUND].max_workers =
 					task_rlimit(current, RLIMIT_NPROC);
-		INIT_LIST_HEAD(&wqe->wait.entry);
-		wqe->wait.func = io_wqe_hash_wake;
+
 		for (i = 0; i < IO_WQ_ACCT_NR; i++) {
 			struct io_wqe_acct *acct = &wqe->acct[i];
 
@@ -1141,6 +1138,9 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 			atomic_set(&acct->nr_running, 0);
 			INIT_WQ_LIST(&acct->work_list);
 			raw_spin_lock_init(&acct->lock);
+			INIT_LIST_HEAD(&acct->wait.entry);
+			acct->wait.func = io_wqe_hash_wake;
+			acct->wqe = wqe;
 		}
 		wqe->wq = wq;
 		raw_spin_lock_init(&wqe->lock);
@@ -1207,8 +1207,11 @@ static void io_wq_exit_workers(struct io_wq *wq)
 	wait_for_completion(&wq->worker_done);
 
 	for_each_node(node) {
+		int i;
+
 		spin_lock_irq(&wq->hash->wait.lock);
-		list_del_init(&wq->wqes[node]->wait.entry);
+		for (i = 0; i < IO_WQ_ACCT_NR; i++)
+			list_del_init(&wq->wqes[node]->acct[i].wait.entry);
 		spin_unlock_irq(&wq->hash->wait.lock);
 	}
 	put_task_struct(wq->task);
-- 
2.24.4

