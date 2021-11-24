Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D205B45BCBB
	for <lists+io-uring@lfdr.de>; Wed, 24 Nov 2021 13:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244296AbhKXMcE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Nov 2021 07:32:04 -0500
Received: from out30-56.freemail.mail.aliyun.com ([115.124.30.56]:55043 "EHLO
        out30-56.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242932AbhKXMZU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Nov 2021 07:25:20 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R951e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uy7GZoS_1637756522;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uy7GZoS_1637756522)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 24 Nov 2021 20:22:09 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/6] io_uring: add a priority tw list for irq completion work
Date:   Wed, 24 Nov 2021 20:21:58 +0800
Message-Id: <20211124122202.218756-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211124122202.218756-1-haoxu@linux.alibaba.com>
References: <20211124122202.218756-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now we have a lot of task_work users, some are just to complete a req
and generate a cqe. Let's put the work to a new tw list which has a
higher priority, so that it can be handled quickly and thus to reduce
avg req latency and users can issue next round of sqes earlier.
An explanatory case:

origin timeline:
    submit_sqe-->irq-->add completion task_work
    -->run heavy work0~n-->run completion task_work
now timeline:
    submit_sqe-->irq-->add completion task_work
    -->run completion task_work-->run heavy work0~n

Limitation: this optimization is only for those that submission and
reaping process are in different threads. Otherwise anyhow we have to
submit new sqes after returning to userspace, then the order of TWs
doesn't matter.

Tested this patch(and the following ones) by manually replace
__io_queue_sqe() in io_queue_sqe() by io_req_task_queue() to construct
'heavy' task works. Then test with fio:

ioengine=io_uring
sqpoll=1
thread=1
bs=4k
direct=1
rw=randread
time_based=1
runtime=600
randrepeat=0
group_reporting=1
filename=/dev/nvme0n1

Tried various iodepth.
The peak IOPS for this patch is 710K, while the old one is 665K.
For avg latency, difference shows when iodepth grow:
depth and avg latency(usec):
	depth      new          old
	 1        7.05         7.10
	 2        8.47         8.60
	 4        10.42        10.42
	 8        13.78        13.22
	 16       27.41        24.33
	 32       49.40        53.08
	 64       102.53       103.36
	 128      196.98       205.61
	 256      372.99       414.88
         512      747.23       791.30
         1024     1472.59      1538.72
         2048     3153.49      3329.01
         4096     6387.86      6682.54
         8192     12150.25     12774.14
         16384    23085.58     26044.71

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 34 +++++++++++++++++++---------------
 1 file changed, 19 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c887e4e19e9e..aca68c4a7964 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -467,6 +467,7 @@ struct io_uring_task {
 
 	spinlock_t		task_lock;
 	struct io_wq_work_list	task_list;
+	struct io_wq_work_list	prior_task_list;
 	struct callback_head	task_work;
 	bool			task_running;
 };
@@ -2148,12 +2149,12 @@ static void tctx_task_work(struct callback_head *cb)
 	while (1) {
 		struct io_wq_work_node *node;
 
-		if (!tctx->task_list.first && locked)
+		if (!tctx->prior_task_list.first &&
+		    !tctx->task_list.first && locked)
 			io_submit_flush_completions(ctx);
 
 		spin_lock_irq(&tctx->task_lock);
-		node = tctx->task_list.first;
-		INIT_WQ_LIST(&tctx->task_list);
+		node= wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
 		if (!node)
 			tctx->task_running = false;
 		spin_unlock_irq(&tctx->task_lock);
@@ -2182,7 +2183,7 @@ static void tctx_task_work(struct callback_head *cb)
 	ctx_flush_and_put(ctx, &locked);
 }
 
-static void io_req_task_work_add(struct io_kiocb *req)
+static void io_req_task_work_add(struct io_kiocb *req, bool priority)
 {
 	struct task_struct *tsk = req->task;
 	struct io_uring_task *tctx = tsk->io_uring;
@@ -2194,7 +2195,10 @@ static void io_req_task_work_add(struct io_kiocb *req)
 	WARN_ON_ONCE(!tctx);
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
-	wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
+	if (priority)
+		wq_list_add_tail(&req->io_task_work.node, &tctx->prior_task_list);
+	else
+		wq_list_add_tail(&req->io_task_work.node, &tctx->task_list);
 	running = tctx->task_running;
 	if (!running)
 		tctx->task_running = true;
@@ -2219,8 +2223,7 @@ static void io_req_task_work_add(struct io_kiocb *req)
 
 	spin_lock_irqsave(&tctx->task_lock, flags);
 	tctx->task_running = false;
-	node = tctx->task_list.first;
-	INIT_WQ_LIST(&tctx->task_list);
+	node = wq_list_merge(&tctx->prior_task_list, &tctx->task_list);
 	spin_unlock_irqrestore(&tctx->task_lock, flags);
 
 	while (node) {
@@ -2257,19 +2260,19 @@ static void io_req_task_queue_fail(struct io_kiocb *req, int ret)
 {
 	req->result = ret;
 	req->io_task_work.func = io_req_task_cancel;
-	io_req_task_work_add(req);
+	io_req_task_work_add(req, false);
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
@@ -2374,7 +2377,7 @@ static inline void io_put_req_deferred(struct io_kiocb *req)
 {
 	if (req_ref_put_and_test(req)) {
 		req->io_task_work.func = io_free_req_work;
-		io_req_task_work_add(req);
+		io_req_task_work_add(req, false);
 	}
 }
 
@@ -2677,7 +2680,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 		return;
 	req->result = res;
 	req->io_task_work.func = io_req_task_complete;
-	io_req_task_work_add(req);
+	io_req_task_work_add(req, !!(req->ctx->flags & IORING_SETUP_SQPOLL));
 }
 
 static void io_complete_rw_iopoll(struct kiocb *kiocb, long res, long res2)
@@ -5248,7 +5251,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 	 * of executing it. We can't safely execute it anyway, as we may not
 	 * have the needed state needed for it anyway.
 	 */
-	io_req_task_work_add(req);
+	io_req_task_work_add(req, false);
 	return 1;
 }
 
@@ -5914,7 +5917,7 @@ static enum hrtimer_restart io_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
 
 	req->io_task_work.func = io_req_task_timeout;
-	io_req_task_work_add(req);
+	io_req_task_work_add(req, false);
 	return HRTIMER_NORESTART;
 }
 
@@ -6880,7 +6883,7 @@ static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer)
 	spin_unlock_irqrestore(&ctx->timeout_lock, flags);
 
 	req->io_task_work.func = io_req_task_link_timeout;
-	io_req_task_work_add(req);
+	io_req_task_work_add(req, false);
 	return HRTIMER_NORESTART;
 }
 
@@ -8584,6 +8587,7 @@ static __cold int io_uring_alloc_task_context(struct task_struct *task,
 	task->io_uring = tctx;
 	spin_lock_init(&tctx->task_lock);
 	INIT_WQ_LIST(&tctx->task_list);
+	INIT_WQ_LIST(&tctx->prior_task_list);
 	init_task_work(&tctx->task_work, tctx_task_work);
 	return 0;
 }
-- 
2.24.4

