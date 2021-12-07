Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFB546B7A1
	for <lists+io-uring@lfdr.de>; Tue,  7 Dec 2021 10:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229584AbhLGJne (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Dec 2021 04:43:34 -0500
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:57508 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234017AbhLGJnd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Dec 2021 04:43:33 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UzkVFio_1638869991;
Received: from hao-A29R.hz.ali.com(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UzkVFio_1638869991)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 07 Dec 2021 17:40:01 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 5/5] io_uring: batch completion in prior_task_list
Date:   Tue,  7 Dec 2021 17:39:51 +0800
Message-Id: <20211207093951.247840-6-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211207093951.247840-1-haoxu@linux.alibaba.com>
References: <20211207093951.247840-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In previous patches, we have already gathered some tw with
io_req_task_complete() as callback in prior_task_list, let's complete
them in batch while we cannot grab uring lock. In this way, we batch
the req_complete_post path.

Tested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

Hi Pavel,
May I add the above Test-by tag here?

 fs/io_uring.c | 70 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 21738ed7521e..f224f8df77a1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2225,6 +2225,49 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
 	percpu_ref_put(&ctx->refs);
 }
 
+static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
+{
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+}
+
+static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx,
+				 bool *uring_locked, bool *compl_locked)
+{
+	do {
+		struct io_wq_work_node *next = node->next;
+		struct io_kiocb *req = container_of(node, struct io_kiocb,
+						    io_task_work.node);
+
+		if (req->ctx != *ctx) {
+			if (unlikely(*compl_locked)) {
+				ctx_commit_and_unlock(*ctx);
+				*compl_locked = false;
+			}
+			ctx_flush_and_put(*ctx, uring_locked);
+			*ctx = req->ctx;
+			/* if not contended, grab and improve batching */
+			*uring_locked = mutex_trylock(&(*ctx)->uring_lock);
+			percpu_ref_get(&(*ctx)->refs);
+			if (unlikely(!*uring_locked)) {
+				spin_lock(&(*ctx)->completion_lock);
+				*compl_locked = true;
+			}
+		}
+		if (likely(*uring_locked))
+			req->io_task_work.func(req, uring_locked);
+		else
+			__io_req_complete_post(req, req->result, io_put_kbuf(req));
+		node = next;
+	} while (node);
+
+	if (unlikely(*compl_locked)) {
+		ctx_commit_and_unlock(*ctx);
+		*compl_locked = false;
+	}
+}
+
 static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx, bool *locked)
 {
 	do {
@@ -2246,31 +2289,38 @@ static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ct
 
 static void tctx_task_work(struct callback_head *cb)
 {
-	bool locked = false;
+	bool uring_locked = false, compl_locked = false;
 	struct io_ring_ctx *ctx = NULL;
 	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
 						  task_work);
 
 	while (1) {
-		struct io_wq_work_node *node;
+		struct io_wq_work_node *node1, *node2;
 
-		if (!tctx->prior_task_list.first &&
-		    !tctx->task_list.first && locked)
+		if (!tctx->task_list.first &&
+		    !tctx->prior_task_list.first && uring_locked)
 			io_submit_flush_completions(ctx);
 
 		spin_lock_irq(&tctx->task_lock);
-		node= wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
-		if (!node)
+		node1 = tctx->prior_task_list.first;
+		node2 = tctx->task_list.first;
+		INIT_WQ_LIST(&tctx->task_list);
+		INIT_WQ_LIST(&tctx->prior_task_list);
+		if (!node2 && !node1)
 			tctx->task_running = false;
 		spin_unlock_irq(&tctx->task_lock);
-		if (!node)
+		if (!node2 && !node1)
 			break;
 
-		handle_tw_list(node, &ctx, &locked);
+		if (node1)
+			handle_prior_tw_list(node1, &ctx, &uring_locked, &compl_locked);
+
+		if (node2)
+			handle_tw_list(node2, &ctx, &uring_locked);
 		cond_resched();
 	}
 
-	ctx_flush_and_put(ctx, &locked);
+	ctx_flush_and_put(ctx, &uring_locked);
 }
 
 static void io_req_task_work_add(struct io_kiocb *req, bool priority)
@@ -2759,7 +2809,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 		return;
 	req->result = res;
 	req->io_task_work.func = io_req_task_complete;
-	io_req_task_work_add(req, true);
+	io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
 }
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
-- 
2.25.1

