Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855F1353C30
	for <lists+io-uring@lfdr.de>; Mon,  5 Apr 2021 09:36:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231697AbhDEHgl (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 5 Apr 2021 03:36:41 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:50411 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231523AbhDEHgl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 5 Apr 2021 03:36:41 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R751e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUW--Sf_1617608182;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUW--Sf_1617608182)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 05 Apr 2021 15:36:33 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v2] io-wq: simplify code in __io_worker_busy
Date:   Mon,  5 Apr 2021 15:36:22 +0800
Message-Id: <1617608182-202901-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <91175ea9-950a-868b-bddf-dfe4c0184225@gmail.com>
References: <91175ea9-950a-868b-bddf-dfe4c0184225@gmail.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

leverage xor to simplify code in __io_worker_busy

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

I thought about [IO_WQ_ACCT_UNBOUND + IO_WQ_ACCT_BOUND - index], but it
is not antithetical, so I finally choose to calculate two indexes
respectively.

 fs/io-wq.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 433c4d3c3c1c..7ec2948838ca 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -292,16 +292,12 @@ static void __io_worker_busy(struct io_wqe *wqe, struct io_worker *worker,
 	worker_bound = (worker->flags & IO_WORKER_F_BOUND) != 0;
 	work_bound = (work->flags & IO_WQ_WORK_UNBOUND) == 0;
 	if (worker_bound != work_bound) {
+		int index0 = work_bound ? IO_WQ_ACCT_UNBOUND : IO_WQ_ACCT_BOUND;
+		int index1 = work_bound ? IO_WQ_ACCT_BOUND : IO_WQ_ACCT_UNBOUND;
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
+		wqe->acct[index0].nr_workers--;
+		wqe->acct[index1].nr_workers++;
 		io_wqe_inc_running(worker);
 	 }
 }
-- 
1.8.3.1

