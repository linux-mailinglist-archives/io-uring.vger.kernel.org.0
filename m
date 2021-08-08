Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63F93E3AAB
	for <lists+io-uring@lfdr.de>; Sun,  8 Aug 2021 15:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbhHHNzA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Aug 2021 09:55:00 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:41946 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229923AbhHHNzA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Aug 2021 09:55:00 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UiIyDWG_1628430874;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UiIyDWG_1628430874)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 08 Aug 2021 21:54:39 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/2] io-wq: fix IO_WORKER_F_FIXED issue in create_io_worker()
Date:   Sun,  8 Aug 2021 21:54:34 +0800
Message-Id: <20210808135434.68667-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210808135434.68667-1-haoxu@linux.alibaba.com>
References: <20210808135434.68667-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There may be cases like:
        A                                 B
spin_lock(wqe->lock)
nr_workers is 0
nr_workers++
spin_unlock(wqe->lock)
                                     spin_lock(wqe->lock)
                                     nr_wokers is 1
                                     nr_workers++
                                     spin_unlock(wqe->lock)
create_io_worker()
  acct->worker is 1
                                     create_io_worker()
                                       acct->worker is 1

There should be one worker marked IO_WORKER_F_FIXED, but no one is.
Fix this by introduce a new agrument for create_io_worker() to indicate
if it is the first worker.

Fixes: 3d4e4face9c1 ("io-wq: fix no lock protection of acct->nr_worker")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 5536b2a008d1..660625ac02d7 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -129,7 +129,7 @@ struct io_cb_cancel_data {
 	bool cancel_all;
 };
 
-static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index);
+static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index, bool first);
 static void io_wqe_dec_running(struct io_worker *worker);
 
 static bool io_worker_get(struct io_worker *worker)
@@ -248,10 +248,12 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	rcu_read_unlock();
 
 	if (!ret) {
-		bool do_create = false;
+		bool do_create = false, first = false;
 
 		raw_spin_lock_irq(&wqe->lock);
 		if (acct->nr_workers < acct->max_workers) {
+			if (!acct->nr_workers)
+				first = true;
 			acct->nr_workers++;
 			do_create = true;
 		}
@@ -259,7 +261,7 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 		if (do_create) {
 			atomic_inc(&acct->nr_running);
 			atomic_inc(&wqe->wq->worker_refs);
-			create_io_worker(wqe->wq, wqe, acct->index);
+			create_io_worker(wqe->wq, wqe, acct->index, first);
 		}
 	}
 }
@@ -283,7 +285,7 @@ static void create_worker_cb(struct callback_head *cb)
 	struct io_wq *wq;
 	struct io_wqe *wqe;
 	struct io_wqe_acct *acct;
-	bool do_create = false;
+	bool do_create = false, first = false;
 
 	cwd = container_of(cb, struct create_worker_data, work);
 	wqe = cwd->wqe;
@@ -291,12 +293,14 @@ static void create_worker_cb(struct callback_head *cb)
 	acct = &wqe->acct[cwd->index];
 	raw_spin_lock_irq(&wqe->lock);
 	if (acct->nr_workers < acct->max_workers) {
+		if (!acct->nr_workers)
+			first = true;
 		acct->nr_workers++;
 		do_create = true;
 	}
 	raw_spin_unlock_irq(&wqe->lock);
 	if (do_create) {
-		create_io_worker(wq, cwd->wqe, cwd->index);
+		create_io_worker(wq, wqe, cwd->index, first);
 	} else {
 		atomic_dec(&acct->nr_running);
 		io_worker_ref_put(wq);
@@ -638,7 +642,7 @@ void io_wq_worker_sleeping(struct task_struct *tsk)
 	raw_spin_unlock_irq(&worker->wqe->lock);
 }
 
-static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
+static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index, bool first)
 {
 	struct io_wqe_acct *acct = &wqe->acct[index];
 	struct io_worker *worker;
@@ -679,7 +683,7 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	worker->flags |= IO_WORKER_F_FREE;
 	if (index == IO_WQ_ACCT_BOUND)
 		worker->flags |= IO_WORKER_F_BOUND;
-	if ((acct->nr_workers == 1) && (worker->flags & IO_WORKER_F_BOUND))
+	if (first && (worker->flags & IO_WORKER_F_BOUND))
 		worker->flags |= IO_WORKER_F_FIXED;
 	raw_spin_unlock_irq(&wqe->lock);
 	wake_up_new_task(tsk);
-- 
2.24.4

