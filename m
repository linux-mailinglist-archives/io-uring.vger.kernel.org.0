Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C84BE41928E
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 12:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233875AbhI0KxR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 06:53:17 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:44474 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233881AbhI0KxL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 06:53:11 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R181e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Upn7J34_1632739883;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Upn7J34_1632739883)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 18:51:32 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 8/8] io_uring: batch completion in prior_task_list
Date:   Mon, 27 Sep 2021 18:51:23 +0800
Message-Id: <20210927105123.169301-9-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210927105123.169301-1-haoxu@linux.alibaba.com>
References: <20210927105123.169301-1-haoxu@linux.alibaba.com>
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
 fs/io_uring.c | 39 +++++++++++++++++++++++++++++++--------
 1 file changed, 31 insertions(+), 8 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 231d0a47025b..4d71179228af 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2156,6 +2156,23 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 	return io_put_kbuf(req, kbuf);
 }
 
+static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ctx *ctx)
+{
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
@@ -2178,31 +2195,37 @@ static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ct
 static void tctx_task_work(struct callback_head *cb)
 {
 	bool locked = false;
-	struct io_ring_ctx *ctx = NULL;
+	struct io_ring_ctx *ctx = NULL, *tw_ctx;
 	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
 						  task_work);
 
 	while (1) {
-		struct io_wq_work_node *node;
-		struct io_wq_work_list *merged_list;
+		struct io_wq_work_node *node1, *node2;
 
 		if (!tctx->prior_task_list.first &&
 		    !tctx->task_list.first && locked)
 			io_submit_flush_completions(ctx);
 
 		spin_lock_irq(&tctx->task_lock);
-		merged_list = wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
-		node = merged_list->first;
+		node1 = tctx->prior_task_list.first;
+		node2 = tctx->task_list.first;
+		tw_ctx = tctx->tw_ctx;
 		INIT_WQ_LIST(&tctx->task_list);
 		INIT_WQ_LIST(&tctx->prior_task_list);
 		tctx->nr = tctx->prior_nr = 0;
-		if (!node)
+		tctx->tw_ctx = NULL;
+		if (!node1 && !node2)
 			tctx->task_running = false;
 		spin_unlock_irq(&tctx->task_lock);
-		if (!node)
+		if (!node1 && !node2)
 			break;
 
-		handle_tw_list(node, &ctx, &locked);
+		if (tw_ctx)
+			handle_prior_tw_list(node1, tw_ctx);
+		else if (node1)
+			handle_tw_list(node1, &ctx, &locked);
+
+		handle_tw_list(node2, &ctx, &locked);
 		cond_resched();
 	}
 
-- 
2.24.4

