Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEBB24075AF
	for <lists+io-uring@lfdr.de>; Sat, 11 Sep 2021 11:02:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbhIKJD5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 11 Sep 2021 05:03:57 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:19029 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235334AbhIKJD5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 11 Sep 2021 05:03:57 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.54])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4H669D3yYNzblpt;
        Sat, 11 Sep 2021 16:58:40 +0800 (CST)
Received: from dggpemm500004.china.huawei.com (7.185.36.219) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Sat, 11 Sep 2021 17:02:43 +0800
Received: from huawei.com (10.174.28.241) by dggpemm500004.china.huawei.com
 (7.185.36.219) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Sat, 11 Sep
 2021 17:02:43 +0800
From:   Bixuan Cui <cuibixuan@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>
CC:     <axboe@kernel.dk>, <asml.silence@gmail.com>
Subject: [PATCH -next] io-wq: Remove duplicate code in io_workqueue_create()
Date:   Sat, 11 Sep 2021 16:58:47 +0800
Message-ID: <20210911085847.34849-1-cuibixuan@huawei.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.174.28.241]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500004.china.huawei.com (7.185.36.219)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While task_work_add() in io_workqueue_create() is true,
then duplicate code is executed:

  -> clear_bit_unlock(0, &worker->create_state);
  -> io_worker_release(worker);
  -> atomic_dec(&acct->nr_running);
  -> io_worker_ref_put(wq);
  -> return false;

  -> clear_bit_unlock(0, &worker->create_state); // back to io_workqueue_create()
  -> io_worker_release(worker);
  -> kfree(worker);

The io_worker_release() and clear_bit_unlock() are executed twice.

Fixes: 3146cba99aa2 ("io-wq: make worker creation resilient against signals")
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
---
 fs/io-wq.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 6c55362c1f99..95d0eaed7c00 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -329,8 +329,10 @@ static bool io_queue_worker_create(struct io_worker *worker,
 
 	init_task_work(&worker->create_work, func);
 	worker->create_index = acct->index;
-	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL))
+	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL)) {
+		clear_bit_unlock(0, &worker->create_state);
 		return true;
+	}
 	clear_bit_unlock(0, &worker->create_state);
 fail_release:
 	io_worker_release(worker);
@@ -723,11 +725,8 @@ static void io_workqueue_create(struct work_struct *work)
 	struct io_worker *worker = container_of(work, struct io_worker, work);
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 
-	if (!io_queue_worker_create(worker, acct, create_worker_cont)) {
-		clear_bit_unlock(0, &worker->create_state);
-		io_worker_release(worker);
+	if (!io_queue_worker_create(worker, acct, create_worker_cont))
 		kfree(worker);
-	}
 }
 
 static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
-- 
2.17.1

