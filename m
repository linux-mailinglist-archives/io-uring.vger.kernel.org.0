Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D256353C3F
	for <lists+io-uring@lfdr.de>; Mon,  5 Apr 2021 09:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232435AbhDEHxn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 03:53:43 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:22466 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232187AbhDEHxn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Apr 2021 03:53:43 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUUnvtY_1617609210;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUUnvtY_1617609210)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 05 Apr 2021 15:53:36 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3] io-wq: simplify code in __io_worker_busy
Date:   Mon,  5 Apr 2021 15:53:30 +0800
Message-Id: <1617609210-227185-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <7f078f30-d60f-2b19-7933-f1ccba8e7282@kernel.dk>
References: <7f078f30-d60f-2b19-7933-f1ccba8e7282@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

leverage xor to simplify code in __io_worker_busy

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 433c4d3c3c1c..8d8324eba2ec 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -276,10 +276,12 @@ static void io_wqe_dec_running(struct io_worker *worker)
  */
 static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
 			     struct io_wq_work *work)
-	__must_hold(wqe->lock)
+	__must_hold(w qe->lock)
 {
 	bool worker_bound, work_bound;
 
+	BUILD_BUG_ON((IO_WQ_ACCT_UNBOUND ^ IO_WQ_ACCT_BOUND) != 1);
+
 	if (worker->flags & IO_WORKER_F_FREE) {
 		worker->flags &= ~IO_WORKER_F_FREE;
 		hlist_nulls_del_init_rcu(&worker->nulls_node);
@@ -292,16 +294,11 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
 	worker_bound = (worker->flags & IO_WORKER_F_BOUND) != 0;
 	work_bound = (work->flags & IO_WQ_WORK_UNBOUND) == 0;
 	if (worker_bound != work_bound) {
+		int index = work_bound ? IO_WQ_ACCT_UNBOUND : IO_WQ_ACCT_BOUND;
 		io_wqe_dec_running(worker);
-		if (work_bound) {
-			worker->flags |= IO_WORKER_F_BOUND;
-			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers--;
-			wqe->acct[IO_WQ_ACCT_BOUND].nr_workers++;
-		} else {
-			worker->flags &= ~IO_WORKER_F_BOUND;
-			wqe->acct[IO_WQ_ACCT_UNBOUND].nr_workers++;
-			wqe->acct[IO_WQ_ACCT_BOUND].nr_workers--;
-		}
+		worker->flags ^= IO_WORKER_F_BOUND;
+		wqe->acct[index].nr_workers--;
+		wqe->acct[index ^ 1].nr_workers++;
 		io_wqe_inc_running(worker);
 	 }
 }
-- 
1.8.3.1

