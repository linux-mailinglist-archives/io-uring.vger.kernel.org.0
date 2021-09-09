Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA96F40442F
	for <lists+io-uring@lfdr.de>; Thu,  9 Sep 2021 06:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbhIIEGZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Sep 2021 00:06:25 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:53919 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232192AbhIIEGY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Sep 2021 00:06:24 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UnkjDU3_1631160307;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UnkjDU3_1631160307)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 09 Sep 2021 12:05:14 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io-wq: fix memory leak in create_io_worker()
Date:   Thu,  9 Sep 2021 12:05:07 +0800
Message-Id: <20210909040507.82711-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We should free memory the variable worker point to in fail path.

Reported-by: syzbot+65454c239241d3d647da@syzkaller.appspotmail.com
Fixes: 3146cba99aa2 ("io-wq: make worker creation resilient against signals")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index d80e4a735677..382efca4812b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -737,15 +737,8 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	__set_current_state(TASK_RUNNING);
 
 	worker = kzalloc_node(sizeof(*worker), GFP_KERNEL, wqe->node);
-	if (!worker) {
-fail:
-		atomic_dec(&acct->nr_running);
-		raw_spin_lock(&wqe->lock);
-		acct->nr_workers--;
-		raw_spin_unlock(&wqe->lock);
-		io_worker_ref_put(wq);
-		return false;
-	}
+	if (!worker)
+		goto fail;
 
 	refcount_set(&worker->ref, 1);
 	worker->wqe = wqe;
@@ -759,7 +752,14 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	if (!IS_ERR(tsk)) {
 		io_init_new_worker(wqe, worker, tsk);
 	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
-		goto fail;
+		kfree(worker);
+fail:
+		atomic_dec(&acct->nr_running);
+		raw_spin_lock(&wqe->lock);
+		acct->nr_workers--;
+		raw_spin_unlock(&wqe->lock);
+		io_worker_ref_put(wq);
+		return false;
 	} else {
 		INIT_WORK(&worker->work, io_workqueue_create);
 		schedule_work(&worker->work);
-- 
2.24.4

