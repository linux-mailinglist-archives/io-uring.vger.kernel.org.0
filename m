Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A3593E3AAE
	for <lists+io-uring@lfdr.de>; Sun,  8 Aug 2021 15:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231679AbhHHNzK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 8 Aug 2021 09:55:10 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:37354 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229923AbhHHNzJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 8 Aug 2021 09:55:09 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R841e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UiIyDWG_1628430874;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UiIyDWG_1628430874)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sun, 08 Aug 2021 21:54:39 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/2] io-wq: fix bug of creating io-wokers unconditionally
Date:   Sun,  8 Aug 2021 21:54:33 +0800
Message-Id: <20210808135434.68667-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210808135434.68667-1-haoxu@linux.alibaba.com>
References: <20210808135434.68667-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The former patch to add check between nr_workers and max_workers has a
bug, which will cause unconditionally creating io-workers. That's
because the result of the check doesn't affect the call of
create_io_worker(), fix it by bringing in a boolean value for it.

Fixes: 21698274da5b ("io-wq: fix lack of acct->nr_workers < acct->max_workers judgement")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 12fc19353bb0..5536b2a008d1 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -252,14 +252,15 @@ static void io_wqe_wake_worker(struct io_wqe *wqe, struct io_wqe_acct *acct)
 
 		raw_spin_lock_irq(&wqe->lock);
 		if (acct->nr_workers < acct->max_workers) {
-			atomic_inc(&acct->nr_running);
-			atomic_inc(&wqe->wq->worker_refs);
 			acct->nr_workers++;
 			do_create = true;
 		}
 		raw_spin_unlock_irq(&wqe->lock);
-		if (do_create)
+		if (do_create) {
+			atomic_inc(&acct->nr_running);
+			atomic_inc(&wqe->wq->worker_refs);
 			create_io_worker(wqe->wq, wqe, acct->index);
+		}
 	}
 }
 
@@ -282,16 +283,24 @@ static void create_worker_cb(struct callback_head *cb)
 	struct io_wq *wq;
 	struct io_wqe *wqe;
 	struct io_wqe_acct *acct;
+	bool do_create = false;
 
 	cwd = container_of(cb, struct create_worker_data, work);
 	wqe = cwd->wqe;
 	wq = wqe->wq;
 	acct = &wqe->acct[cwd->index];
 	raw_spin_lock_irq(&wqe->lock);
-	if (acct->nr_workers < acct->max_workers)
+	if (acct->nr_workers < acct->max_workers) {
 		acct->nr_workers++;
+		do_create = true;
+	}
 	raw_spin_unlock_irq(&wqe->lock);
-	create_io_worker(wq, cwd->wqe, cwd->index);
+	if (do_create) {
+		create_io_worker(wq, cwd->wqe, cwd->index);
+	} else {
+		atomic_dec(&acct->nr_running);
+		io_worker_ref_put(wq);
+	}
 	kfree(cwd);
 }
 
-- 
2.24.4

