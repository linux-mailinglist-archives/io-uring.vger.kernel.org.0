Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD29743CB7A
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 16:03:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242372AbhJ0OFs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Oct 2021 10:05:48 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:28477 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242367AbhJ0OFr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Oct 2021 10:05:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UtuRLZW_1635343336;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UtuRLZW_1635343336)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 22:02:24 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 7/8] io_uring: batch completion in prior_task_list
Date:   Wed, 27 Oct 2021 22:02:15 +0800
Message-Id: <20211027140216.20008-8-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211027140216.20008-1-haoxu@linux.alibaba.com>
References: <20211027140216.20008-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In previous patches, we have already gathered some tw with
io_req_task_complete() as callback in prior_task_list, let's complete
them in batch. This is better than before in cases where !locked.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 43 ++++++++++++++++++++++++++++++++++++-------
 1 file changed, 36 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7c6d90d693b8..bf1b730df158 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2166,6 +2166,26 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 	return io_put_kbuf(req, req->kbuf);
 }
 
+static void handle_prior_tw_list(struct io_wq_work_node *node)
+{
+	struct io_kiocb *req = container_of(node, struct io_kiocb, io_task_work.node);
+	struct io_ring_ctx *ctx = req->ctx;
+
+	spin_lock(&ctx->completion_lock);
+	do {
+		struct io_wq_work_node *next = node->next;
+		struct io_kiocb *req = container_of(node, struct io_kiocb,
+						    io_task_work.node);
+
+		__io_req_complete_post(req, req->result, io_put_rw_kbuf(req));
+		node = next;
+	} while (node);
+
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+}
+
 static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx, bool *locked)
 {
 	do {
@@ -2193,25 +2213,34 @@ static void tctx_task_work(struct callback_head *cb)
 						  task_work);
 
 	while (1) {
-		struct io_wq_work_node *node;
-		struct io_wq_work_list *merged_list;
+		unsigned int nr_ctx;
+		struct io_wq_work_node *node1, *node2;
 
 		if (!tctx->prior_task_list.first &&
 		    !tctx->task_list.first && locked)
 			io_submit_flush_completions(ctx);
 
 		spin_lock_irq(&tctx->task_lock);
-		merged_list = wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
-		node = merged_list->first;
+		node1 = tctx->prior_task_list.first;
+		node2 = tctx->task_list.first;
 		INIT_WQ_LIST(&tctx->task_list);
 		INIT_WQ_LIST(&tctx->prior_task_list);
-		if (!node)
+		nr_ctx = tctx->nr_ctx;
+		if (!node1 && !node2)
 			tctx->task_running = false;
 		spin_unlock_irq(&tctx->task_lock);
-		if (!node)
+		if (!node1 && !node2)
 			break;
 
-		handle_tw_list(node, &ctx, &locked);
+		if (node1) {
+			if (nr_ctx == 1)
+				handle_prior_tw_list(node1);
+			else
+				handle_tw_list(node1, &ctx, &locked);
+		}
+
+		if (node2)
+			handle_tw_list(node2, &ctx, &locked);
 		cond_resched();
 	}
 
-- 
2.24.4

