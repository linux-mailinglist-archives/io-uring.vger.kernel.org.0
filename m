Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 921D9407A52
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 21:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233567AbhIKTnA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 15:43:00 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:36420 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232353AbhIKTnA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 15:43:00 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uo.lhDo_1631389252;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uo.lhDo_1631389252)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 12 Sep 2021 03:40:59 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 4/4] io-wq: fix potential race of acct->nr_workers
Date:   Sun, 12 Sep 2021 03:40:52 +0800
Message-Id: <20210911194052.28063-5-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210911194052.28063-1-haoxu@linux.alibaba.com>
References: <20210911194052.28063-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Given max_worker is 1, and we currently have 1 running and it is
exiting. There may be race like:
 io_wqe_enqueue                   worker1
                               no work there and timeout
                               unlock(wqe->lock)
 ->insert work
                               -->io_worker_exit
 lock(wqe->lock)
 ->if(!nr_workers) //it's still 1
 unlock(wqe->lock)
    goto run_cancel
                                  lock(wqe->lock)
                                  nr_workers--
                                  ->dec_running
                                    ->worker creation fails
                                  unlock(wqe->lock)

We enqueued one work but there is no workers, causes hung.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 75e79571bdfd..b84dc8df6c68 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -176,7 +176,6 @@ static void io_worker_ref_put(struct io_wq *wq)
 static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
-	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 
 	if (refcount_dec_and_test(&worker->ref))
 		complete(&worker->ref_done);
@@ -186,7 +185,6 @@ static void io_worker_exit(struct io_worker *worker)
 	if (worker->flags & IO_WORKER_F_FREE)
 		hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
-	acct->nr_workers--;
 	preempt_disable();
 	refcount_set(&worker->ref, 1);
 	io_wqe_dec_running(worker);
@@ -571,6 +569,7 @@ static int io_wqe_worker(void *data)
 		}
 		/* timed out, exit unless we're the last worker */
 		if (last_timeout && acct->nr_workers > 1) {
+			acct->nr_workers--;
 			raw_spin_unlock(&wqe->lock);
 			__set_current_state(TASK_RUNNING);
 			break;
-- 
2.24.4

