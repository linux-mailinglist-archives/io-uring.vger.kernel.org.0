Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC56645FFDA
	for <lists+io-uring@lfdr.de>; Sat, 27 Nov 2021 16:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbhK0P3f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 27 Nov 2021 10:29:35 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:39065 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233438AbhK0P1e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 27 Nov 2021 10:27:34 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R191e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UyTnBGh_1638026652;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyTnBGh_1638026652)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 27 Nov 2021 23:24:18 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v7] io_uring: batch completion in prior_task_list
Date:   Sat, 27 Nov 2021 23:24:12 +0800
Message-Id: <20211127152412.232005-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211126133749.65516-1-haoxu@linux.alibaba.com>
References: <20211126133749.65516-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In previous patches, we have already gathered some tw with
io_req_task_complete() as callback in prior_task_list, let's complete
them in batch while we cannot grab uring lock. In this way, we batch
the req_complete_post path.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

v6->v7
- use function pointer to reduce the if check everytime running a task
work in handle_prior_tw_list()

 fs/io_uring.c | 68 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 61 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e9c67f19d585..2c0ff1fc6974 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2223,6 +2223,53 @@ static inline unsigned int io_put_rw_kbuf(struct io_kiocb *req)
 	return io_put_kbuf(req, req->kbuf);
 }
 
+static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
+{
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
+}
+
+static inline void io_req_complete_inline(struct io_kiocb *req, s32 res,
+					  u32 cflags)
+{
+		io_req_complete_state(req, res, cflags);
+		io_req_add_compl_list(req);
+}
+
+static void handle_prior_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx,
+				 bool *locked)
+{
+	void (*io_req_complete_func)(struct io_kiocb *, s32, u32);
+
+	do {
+		struct io_wq_work_node *next = node->next;
+		struct io_kiocb *req = container_of(node, struct io_kiocb,
+						    io_task_work.node);
+
+		if (req->ctx != *ctx) {
+			if (unlikely(!*locked) && *ctx)
+				ctx_commit_and_unlock(*ctx);
+			ctx_flush_and_put(*ctx, locked);
+			*ctx = req->ctx;
+			/* if not contended, grab and improve batching */
+			*locked = mutex_trylock(&(*ctx)->uring_lock);
+			percpu_ref_get(&(*ctx)->refs);
+			if (unlikely(!*locked)) {
+				spin_lock(&(*ctx)->completion_lock);
+				io_req_complete_func = __io_req_complete_post;
+			} else {
+				io_req_complete_func = io_req_complete_inline;
+			}
+		}
+		io_req_complete_func(req, req->result, io_put_rw_kbuf(req));
+		node = next;
+	} while (node);
+
+	if (unlikely(!*locked) && *ctx)
+		ctx_commit_and_unlock(*ctx);
+}
+
 static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx, bool *locked)
 {
 	do {
@@ -2250,21 +2297,28 @@ static void tctx_task_work(struct callback_head *cb)
 						  task_work);
 
 	while (1) {
-		struct io_wq_work_node *node;
+		struct io_wq_work_node *node1, *node2;
 
-		if (!tctx->prior_task_list.first &&
-		    !tctx->task_list.first && locked)
+		if (!tctx->task_list.first &&
+		    !tctx->prior_task_list.first && locked)
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
+			handle_prior_tw_list(node1, &ctx, &locked);
+
+		if (node2)
+			handle_tw_list(node2, &ctx, &locked);
 		cond_resched();
 	}
 
-- 
2.24.4

