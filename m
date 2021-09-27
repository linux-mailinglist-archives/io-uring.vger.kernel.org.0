Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E95D41928F
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 12:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhI0KxV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 06:53:21 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:41724 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233881AbhI0KxV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 06:53:21 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R801e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Upn7J34_1632739883;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Upn7J34_1632739883)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 18:51:32 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 7/8] io_uring: add tw_ctx for io_uring_task
Date:   Mon, 27 Sep 2021 18:51:22 +0800
Message-Id: <20210927105123.169301-8-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210927105123.169301-1-haoxu@linux.alibaba.com>
References: <20210927105123.169301-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add tw_ctx to represent whether there is only one ctx in
prior_task_list or not, this is useful in the next patch

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7f7b77a458d0..231d0a47025b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -477,6 +477,7 @@ struct io_uring_task {
 	struct io_wq_work_list	task_list;
 	struct callback_head	task_work;
 	struct io_wq_work_list	prior_task_list;
+	struct io_ring_ctx	*tw_ctx;
 	unsigned int		nr;
 	unsigned int		prior_nr;
 	bool			task_running;
@@ -2224,6 +2225,10 @@ static void io_req_task_work_add(struct io_kiocb *req, bool emergency)
 	if (emergency && tctx->prior_nr * MAX_EMERGENCY_TW_RATIO < tctx->nr) {
 		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
 		tctx->prior_nr++;
+		if (tctx->prior_nr == 1)
+			tctx->tw_ctx = req->ctx;
+		else if (tctx->tw_ctx && req->ctx != tctx->tw_ctx)
+			tctx->tw_ctx = NULL;
 	} else {
 		wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
 	}
@@ -2252,6 +2257,7 @@ static void io_req_task_work_add(struct io_kiocb *req, bool emergency)
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	tctx->nr = tctx->prior_nr = 0;
+	tctx->tw_ctx = NULL;
 	tctx->task_running = false;
 	merged_list = wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
 	node = merged_list->first;
-- 
2.24.4

