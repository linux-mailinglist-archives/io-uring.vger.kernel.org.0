Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29D93E11EC
	for <lists+io-uring@lfdr.de>; Thu,  5 Aug 2021 12:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240105AbhHEKGD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 5 Aug 2021 06:06:03 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:48222 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239957AbhHEKGB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 5 Aug 2021 06:06:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Ui1e.zi_1628157938;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Ui1e.zi_1628157938)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 05 Aug 2021 18:05:45 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/3] io-wq: fix no lock protection of acct->nr_worker
Date:   Thu,  5 Aug 2021 18:05:37 +0800
Message-Id: <20210805100538.127891-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210805100538.127891-1-haoxu@linux.alibaba.com>
References: <20210805100538.127891-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is an acct->nr_worker visit without lock protection. Think about
the case: two callers call io_wqe_wake_worker(), one is the original
context and the other one is an io-worker(by calling
io_wqe_enqueue(wqe, linked)), on two cpus paralelly, this may cause
nr_worker to be larger than max_worker.
Let's fix it by adding lock for it, and let's do nr_workers++ before
create_io_worker. There may be a edge cause that the first caller fails
to create an io-worker, but the second caller doesn't know it and then
quit creating io-worker as well:

say nr_worker = max_worker - 1
        cpu 0                        cpu 1
   io_wqe_wake_worker()          io_wqe_wake_worker()
      nr_worker < max_worker
      nr_worker++
      create_io_worker()         nr_worker == max_worker
         failed                  return
      return

But the chance of this case is very slim.

Fixes: 685fe7feedb9 ("io-wq: eliminate the need for a manager thread")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index cd4fd4d6268f..88d0ba7be1fb 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -247,9 +247,14 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 	ret = io_wqe_activate_free_worker(wqe);
 	rcu_read_unlock();
 
-	if (!ret && acct->nr_workers < acct->max_workers) {
-		atomic_inc(&acct->nr_running);
-		atomic_inc(&wqe->wq->worker_refs);
+	if (!ret) {
+		raw_spin_lock_irq(&wqe->lock);
+		if (acct->nr_workers < acct->max_workers) {
+			atomic_inc(&acct->nr_running);
+			atomic_inc(&wqe->wq->worker_refs);
+			acct->nr_workers++;
+		}
+		raw_spin_unlock_irq(&wqe->lock);
 		create_io_worker(wqe->wq, wqe, acct->index);
 	}
 }
@@ -632,6 +637,9 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 		kfree(worker);
 fail:
 		atomic_dec(&acct->nr_running);
+		raw_spin_lock_irq(&wqe->lock);
+		acct->nr_workers--;
+		raw_spin_unlock_irq(&wqe->lock);
 		io_worker_ref_put(wq);
 		return;
 	}
@@ -647,9 +655,8 @@ static void create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	worker->flags |= IO_WORKER_F_FREE;
 	if (index == IO_WQ_ACCT_BOUND)
 		worker->flags |= IO_WORKER_F_BOUND;
-	if (!acct->nr_workers && (worker->flags & IO_WORKER_F_BOUND))
+	if ((acct->nr_workers == 1) && (worker->flags & IO_WORKER_F_BOUND))
 		worker->flags |= IO_WORKER_F_FIXED;
-	acct->nr_workers++;
 	raw_spin_unlock_irq(&wqe->lock);
 	wake_up_new_task(tsk);
 }
-- 
2.24.4

