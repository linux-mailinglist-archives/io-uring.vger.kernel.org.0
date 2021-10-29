Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4B7643FC41
	for <lists+io-uring@lfdr.de>; Fri, 29 Oct 2021 14:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbhJ2MZT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Oct 2021 08:25:19 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:50793 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231572AbhJ2MZQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Oct 2021 08:25:16 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uu9pzWg_1635510157;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uu9pzWg_1635510157)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 29 Oct 2021 20:22:47 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 6/6] io_uring: batch completion in prior_task_list
Date:   Fri, 29 Oct 2021 20:22:37 +0800
Message-Id: <20211029122237.164312-7-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211029122237.164312-1-haoxu@linux.alibaba.com>
References: <20211029122237.164312-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In previous patches, we have already gathered some tw with
io_req_task_complete() as callback in prior_task_list, let's complete
them in batch regardless uring lock. For instance, we are doing simple
direct read, most task work will be io_req_task_complete(), with this
patch we don't need to hold uring lock there for long time.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 52 ++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 694195c086f3..565cd0b34f18 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2166,6 +2166,37 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 	return io_put_kbuf(req, req->kbuf);
 }
 
+static void handle_prior_tw_list(struct io_wq_work_node *node)
+{
+	struct io_ring_ctx *ctx = NULL;
+
+	do {
+		struct io_wq_work_node *next = node->next;
+		struct io_kiocb *req = container_of(node, struct io_kiocb,
+						    io_task_work.node);
+		if (req->ctx != ctx) {
+			if (ctx) {
+				io_commit_cqring(ctx);
+				spin_unlock(&ctx->completion_lock);
+				io_cqring_ev_posted(ctx);
+				percpu_ref_put(&ctx->refs);
+			}
+			ctx = req->ctx;
+			percpu_ref_get(&ctx->refs);
+			spin_lock(&ctx->completion_lock);
+		}
+		__io_req_complete_post(req, req->result, io_put_rw_kbuf(req));
+		node = next;
+	} while (node);
+
+	if (ctx) {
+		io_commit_cqring(ctx);
+		spin_unlock(&ctx->completion_lock);
+		io_cqring_ev_posted(ctx);
+		percpu_ref_put(&ctx->refs);
+	}
+}
+
 static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx, bool *locked)
 {
 	do {
@@ -2193,25 +2224,28 @@ static void tctx_task_work(struct callback_head *cb)
 						  task_work);
 
 	while (1) {
-		struct io_wq_work_node *node;
-		struct io_wq_work_list *merged_list;
+		struct io_wq_work_node *node1, *node2;
 
-		if (!tctx->prior_task_list.first &&
-		    !tctx->task_list.first && locked)
+		if (!tctx->task_list.first &&
+		    !tctx->prior_task_list.first && locked)
 			io_submit_flush_completions(ctx);
 
 		spin_lock_irq(&tctx->task_lock);
-		merged_list = wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
-		node = merged_list->first;
+		node1 = tctx->prior_task_list.first;
+		node2 = tctx->task_list.first;
 		INIT_WQ_LIST(&tctx->task_list);
 		INIT_WQ_LIST(&tctx->prior_task_list);
-		if (!node)
+		if (!node2 && !node1)
 			tctx->task_running = false;
 		spin_unlock_irq(&tctx->task_lock);
-		if (!node)
+		if (!node2 && !node1)
 			break;
 
-		handle_tw_list(node, &ctx, &locked);
+		if (node1)
+			handle_prior_tw_list(node1);
+
+		if (node2)
+			handle_tw_list(node2, &ctx, &locked);
 		cond_resched();
 	}
 
-- 
2.24.4

