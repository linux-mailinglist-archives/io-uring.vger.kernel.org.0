Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6D43529A4
	for <lists+io-uring@lfdr.de>; Fri,  2 Apr 2021 12:19:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234161AbhDBKTC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Apr 2021 06:19:02 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:36793 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229605AbhDBKS5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Apr 2021 06:18:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUEBZhC_1617358729;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUEBZhC_1617358729)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 02 Apr 2021 18:18:55 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io-wq: simplify code in __io_worker_busy
Date:   Fri,  2 Apr 2021 18:18:49 +0800
Message-Id: <1617358729-36761-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

leverage xor to simplify code in __io_worker_busy

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 7434eb40ca8c..f77e4704d7c7 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -292,16 +292,11 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
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
+		wqe->acct[index^1].nr_workers++;
 		io_wqe_inc_running(worker);
 	 }
 }
-- 
1.8.3.1

