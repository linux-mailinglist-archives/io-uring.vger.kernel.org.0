Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B833F5077
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 20:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbhHWShj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 14:37:39 -0400
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:48712 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230149AbhHWShj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 14:37:39 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UlQutiJ_1629743808;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UlQutiJ_1629743808)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 24 Aug 2021 02:36:55 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/2] io_uring: add irq completion work to the head of task_list
Date:   Tue, 24 Aug 2021 02:36:48 +0800
Message-Id: <20210823183648.163361-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210823183648.163361-1-haoxu@linux.alibaba.com>
References: <20210823183648.163361-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now we have a lot of task_work users, some are just to complete a req
and generate a cqe. Let's put the work at the head position of the
task_list, so that it can be handled quickly and thus to reduce
avg req latency. an explanatory case:

origin timeline:
    submit_sqe-->irq-->add completion task_work
    -->run heavy work0~n-->run completion task_work
now timeline:
    submit_sqe-->irq-->add completion task_work
    -->run completion task_work-->run heavy work0~n

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io-wq.h    |  9 +++++++++
 fs/io_uring.c | 21 ++++++++++++---------
 2 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 308af3928424..51b4408fd177 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -41,6 +41,15 @@ static inline void wq_list_add_after(struct io_wq_work_node *node,
 		list->last = node;
 }
 
+static inline void wq_list_add_head(struct io_wq_work_node *node,
+				    struct io_wq_work_list *list)
+{
+	node->next = list->first;
+	list->first = node;
+	if (!node->next)
+		list->last = node;
+}
+
 static inline void wq_list_add_tail(struct io_wq_work_node *node,
 				    struct io_wq_work_list *list)
 {
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8172f5f893ad..954cd8583945 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2050,7 +2050,7 @@ static void tctx_task_work(struct callback_head *cb)
 	ctx_flush_and_put(ctx);
 }
 
-static void io_req_task_work_add(struct io_kiocb *req)
+static void io_req_task_work_add(struct io_kiocb *req, bool emergency)
 {
 	struct task_struct *tsk = req->task;
 	struct io_uring_task *tctx = tsk->io_uring;
@@ -2062,7 +2062,10 @@ static void io_req_task_work_add(struct io_kiocb *req)
 	WARN_ON_ONCE(!tctx);
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
-	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
+	if (emergency)
+		wq_list_add_head(&req->io_task_work.node, &tctx->task_list);
+	else
+		wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
 	running = tctx->task_running;
 	if (!running)
 		tctx->task_running = true;
@@ -2122,19 +2125,19 @@ static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
 	req->result = ret;
 	req->io_task_work.func = io_req_task_cancel;
-	io_req_task_work_add(req);
+	io_req_task_work_add(req, true);
 }
 
 static void io_req_task_queue(struct io_kiocb *req)
 {
 	req->io_task_work.func = io_req_task_submit;
-	io_req_task_work_add(req);
+	io_req_task_work_add(req, false);
 }
 
 static void io_req_task_queue_reissue(struct io_kiocb *req)
 {
 	req->io_task_work.func = io_queue_async_work;
-	io_req_task_work_add(req);
+	io_req_task_work_add(req, false);
 }
 
 static inline void io_queue_next(struct io_kiocb *req)
@@ -2249,7 +2252,7 @@ static inline void io_put_req_deferred(struct io_kiocb *req)
 {
 	if (req_ref_put_and_test(req)) {
 		req->io_task_work.func = io_free_req;
-		io_req_task_work_add(req);
+		io_req_task_work_add(req, false);
 	}
 }
 
@@ -2564,7 +2567,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 		return;
 	req->result = res;
 	req->io_task_work.func = io_req_task_complete;
-	io_req_task_work_add(req);
+	io_req_task_work_add(req, true);
 }
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
@@ -4881,7 +4884,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	 * of executing it. We can't safely execute it anyway, as we may not
 	 * have the needed state needed for it anyway.
 	 */
-	io_req_task_work_add(req);
+	io_req_task_work_add(req, false);
 	return 1;
 }
 
@@ -6430,7 +6433,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
 
 	req->io_task_work.func = io_req_task_link_timeout;
-	io_req_task_work_add(req);
+	io_req_task_work_add(req, false);
 	return HRTIMER_NORESTART;
 }
 
-- 
2.24.4

