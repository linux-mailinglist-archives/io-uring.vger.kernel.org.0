Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B77A438EF3
	for <lists+io-uring@lfdr.de>; Mon, 25 Oct 2021 07:39:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230102AbhJYFlP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Oct 2021 01:41:15 -0400
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:57404 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230085AbhJYFlO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Oct 2021 01:41:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UtW3ddi_1635140330;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UtW3ddi_1635140330)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 25 Oct 2021 13:38:51 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [PATCH v3 2/3] io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request
Date:   Mon, 25 Oct 2021 13:38:48 +0800
Message-Id: <20211025053849.3139-3-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
References: <20211025053849.3139-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Run echo_server to evaluate io_uring's multi-shot poll performance, perf
shows that add_wait_queue() has obvious overhead. Intruduce a new state
'active' in io_poll_iocb to indicate whether io_poll_wake() should queue
a task_work. This new state will be set to true initially, be set to false
when starting to queue a task work, and be set to true again when a poll
cqe has been committed. One concern is that this method may lost waken-up
event, but seems it's ok.

  io_poll_wake                io_poll_task_func
t1                       |
t2                       |    WRITE_ONCE(req->poll.active, true);
t3                       |
t4                       |    io_commit_cqring(ctx);
t5                       |
t6                       |

If waken-up events happens before or at t4, it's ok, user app will always
see a cqe. If waken-up events happens after t4 and IIUC, io_poll_wake()
will see the new req->poll.active value by using READ_ONCE().

Echo_server codes can be cloned from:
https://codeup.openanolis.cn/codeup/storage/io_uring-echo-server.git,
branch is xiaoguangwang/io_uring_multishot.

Without this patch, the tps in our test environment is 284116, with
this patch, the tps is 287832, about 1.3% reqs improvement, which
is indeed in accord with the saved add_wait_queue() cost.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 57 +++++++++++++++++++++++++++++++++------------------------
 1 file changed, 33 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 18af9bb9a4bc..e4c779dac953 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -481,6 +481,7 @@ struct io_poll_iocb {
 	__poll_t			events;
 	bool				done;
 	bool				canceled;
+	bool				active;
 	struct wait_queue_entry		wait;
 };
 
@@ -5233,8 +5234,6 @@ static inline int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *pol
 {
 	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
 
-	list_del_init(&poll->wait.entry);
-
 	req->result = mask;
 	req->io_task_work.func = func;
 
@@ -5265,7 +5264,10 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 
 	spin_lock(&ctx->completion_lock);
 	if (!req->result && !READ_ONCE(poll->canceled)) {
-		add_wait_queue(poll->head, &poll->wait);
+		if (req->opcode == IORING_OP_POLL_ADD)
+			WRITE_ONCE(poll->active, true);
+		else
+			add_wait_queue(poll->head, &poll->wait);
 		return true;
 	}
 
@@ -5331,6 +5333,26 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	return !(flags & IORING_CQE_F_MORE);
 }
 
+static bool __io_poll_remove_one(struct io_kiocb *req,
+				 struct io_poll_iocb *poll, bool do_cancel)
+	__must_hold(&req->ctx->completion_lock)
+{
+	bool do_complete = false;
+
+	if (!poll->head)
+		return false;
+	spin_lock_irq(&poll->head->lock);
+	if (do_cancel)
+		WRITE_ONCE(poll->canceled, true);
+	if (!list_empty(&poll->wait.entry)) {
+		list_del_init(&poll->wait.entry);
+		do_complete = true;
+	}
+	spin_unlock_irq(&poll->head->lock);
+	hash_del(&req->hash_node);
+	return do_complete;
+}
+
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5348,11 +5370,12 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 		done = __io_poll_complete(req, req->result);
 		if (done) {
 			io_poll_remove_double(req);
+			__io_poll_remove_one(req, io_poll_get_single(req), true);
 			hash_del(&req->hash_node);
 			req->poll.done = true;
 		} else {
 			req->result = 0;
-			add_wait_queue(req->poll.head, &req->poll.wait);
+			WRITE_ONCE(req->poll.active, true);
 		}
 		io_commit_cqring(ctx);
 		spin_unlock(&ctx->completion_lock);
@@ -5407,6 +5430,7 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 	poll->head = NULL;
 	poll->done = false;
 	poll->canceled = false;
+	poll->active = true;
 #define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
 	/* mask in events that we always want/need */
 	poll->events = events | IO_POLL_UNMASK;
@@ -5513,6 +5537,7 @@ static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	if (mask && !(mask & poll->events))
 		return 0;
 
+	list_del_init(&poll->wait.entry);
 	return __io_async_wake(req, poll, mask, io_async_task_func);
 }
 
@@ -5623,26 +5648,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	return IO_APOLL_OK;
 }
 
-static bool __io_poll_remove_one(struct io_kiocb *req,
-				 struct io_poll_iocb *poll, bool do_cancel)
-	__must_hold(&req->ctx->completion_lock)
-{
-	bool do_complete = false;
-
-	if (!poll->head)
-		return false;
-	spin_lock_irq(&poll->head->lock);
-	if (do_cancel)
-		WRITE_ONCE(poll->canceled, true);
-	if (!list_empty(&poll->wait.entry)) {
-		list_del_init(&poll->wait.entry);
-		do_complete = true;
-	}
-	spin_unlock_irq(&poll->head->lock);
-	hash_del(&req->hash_node);
-	return do_complete;
-}
-
 static bool io_poll_remove_one(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
@@ -5779,6 +5784,10 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	if (mask && !(mask & poll->events))
 		return 0;
 
+	if (!READ_ONCE(poll->active))
+		return 0;
+	WRITE_ONCE(poll->active, false);
+
 	return __io_async_wake(req, poll, mask, io_poll_task_func);
 }
 
-- 
2.14.4.44.g2045bb6

