Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB3C43CB78
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 16:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242365AbhJ0OFj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Oct 2021 10:05:39 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:47791 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242334AbhJ0OFj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Oct 2021 10:05:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UtuRLZW_1635343336;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UtuRLZW_1635343336)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 22:02:24 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 8/8] io_uring: add limited number of TWs to priority task list
Date:   Wed, 27 Oct 2021 22:02:16 +0800
Message-Id: <20211027140216.20008-9-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211027140216.20008-1-haoxu@linux.alibaba.com>
References: <20211027140216.20008-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

One thing to watch out is sometimes irq completion TWs comes
overwhelmingly, which makes the new tw list grows fast, and TWs in
the old list are starved. So we have to limit the length of the new
tw list. A practical value is 1/3:
    len of new tw list < 1/3 * (len of new + old tw list)

In this way, the new tw list has a limited length and normal task get
there chance to run.
Say MAX_PRIORITY_TW_RATIO is k, the number of TWs in priority list is
x, in non-priority list in is y. Then a TW can be inserted to the
priority list in the condition:
            x <= 1/k * (x + y)
          =>k * x <= x + y
          =>(1 - k) * x + y >= 0

So we just need a variable z = (1 - k) * x + y. Everytime a new TW
comes,
    if z >= 0, we add it to prio list, and z += (1 - k)
    if z < 0, we add it to non-prio list, and z++

So we just one extra operation, and we can simplify the check to:
       if (priority && k >= 0) add to prio list;

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf1b730df158..0099decac71d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -471,6 +471,7 @@ struct io_uring_task {
 	struct callback_head	task_work;
 	bool			task_running;
 	unsigned int		nr_ctx;
+	int			factor;
 };
 
 /*
@@ -2225,6 +2226,7 @@ static void tctx_task_work(struct callback_head *cb)
 		node2 = tctx->task_list.first;
 		INIT_WQ_LIST(&tctx->task_list);
 		INIT_WQ_LIST(&tctx->prior_task_list);
+		tctx->factor = 0;
 		nr_ctx = tctx->nr_ctx;
 		if (!node1 && !node2)
 			tctx->task_running = false;
@@ -2247,6 +2249,7 @@ static void tctx_task_work(struct callback_head *cb)
 	ctx_flush_and_put(ctx, &locked);
 }
 
+#define MAX_PRIORITY_TW_RATIO 3
 static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 {
 	struct task_struct *tsk = req->task;
@@ -2260,10 +2263,13 @@ static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 	WARN_ON_ONCE(!tctx);
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
-	if (priority)
+	if (priority && tctx->factor >= 0) {
 		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
-	else
+		tctx->factor += (1 - MAX_PRIORITY_TW_RATIO);
+	} else {
 		wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
+		tctx->factor++;
+	}
 	running = tctx->task_running;
 	if (!running)
 		tctx->task_running = true;
-- 
2.24.4

