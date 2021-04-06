Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222C8354B1D
	for <lists+io-uring@lfdr.de>; Tue,  6 Apr 2021 05:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233048AbhDFDJC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 23:09:02 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:39369 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231620AbhDFDJB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Apr 2021 23:09:01 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R551e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUeSHnl_1617678526;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUeSHnl_1617678526)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 06 Apr 2021 11:08:51 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v4] io-wq: simplify code in __io_worker_busy
Date:   Tue,  6 Apr 2021 11:08:45 +0800
Message-Id: <1617678525-3129-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <c1f66f6e-64b1-4c65-3b0c-e87d705adb26@kernel.dk>
References: <c1f66f6e-64b1-4c65-3b0c-e87d705adb26@kernel.dk>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

leverage xor to simplify code in __io_worker_busy

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

Sorry, typo by mistake...

 fs/io-wq.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 2dd2d4b1e538..fa2383cb4d50 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -329,6 +329,8 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
 {
 	bool worker_bound, work_bound;
 
+	BUILD_BUG_ON((IO_WQ_ACCT_UNBOUND ^ IO_WQ_ACCT_BOUND) != 1);
+
 	if (worker->flags & IO_WORKER_F_FREE) {
 		worker->flags &= ~IO_WORKER_F_FREE;
 		hlist_nulls_del_init_rcu(&worker->nulls_node);
@@ -341,16 +343,11 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
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

