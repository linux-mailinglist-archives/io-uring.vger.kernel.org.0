Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A165145B3AA
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 05:47:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhKXEuo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Nov 2021 23:50:44 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:56601 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231463AbhKXEum (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Nov 2021 23:50:42 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R211e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uy45oE2_1637729208;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uy45oE2_1637729208)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 12:46:58 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 9/9] io-wq: small optimization for __io_worker_busy()
Date:   Wed, 24 Nov 2021 12:46:48 +0800
Message-Id: <20211124044648.142416-10-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211124044648.142416-1-haoxu@linux.alibaba.com>
References: <20211124044648.142416-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Let's change the worker state between free/running only when it's
necessary. This can reduce some lock contension.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 097ea598bfe5..377c3e42a491 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -434,12 +434,11 @@ static void io_wqe_dec_running(struct io_worker *worker)
  */
 static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
 			     struct io_wq_work *work)
-	__must_hold(wqe->lock)
 {
-	if (worker->flags & IO_WORKER_F_FREE) {
-		worker->flags &= ~IO_WORKER_F_FREE;
-		hlist_nulls_del_init_rcu(&worker->nulls_node);
-	}
+	raw_spin_lock(&wqe->lock);
+	worker->flags &= ~IO_WORKER_F_FREE;
+	hlist_nulls_del_init_rcu(&worker->nulls_node);
+	raw_spin_unlock(&wqe->lock);
 }
 
 /*
@@ -587,13 +586,10 @@ static void io_worker_handle_work(struct io_worker *worker, struct io_wqe_acct *
 		 * clear the stalled flag.
 		 */
 		work = io_get_next_work(acct, worker, needs_lock);
-		if (work) {
-			raw_spin_lock(&wqe->lock);
+		if (work && (worker->flags & IO_WORKER_F_FREE))
 			__io_worker_busy(wqe, worker, work);
-			raw_spin_unlock(&wqe->lock);
-		} else {
+		else if (!work)
 			break;
-		}
 		io_assign_current_work(worker, work);
 		__set_current_state(TASK_RUNNING);
 
-- 
2.24.4

