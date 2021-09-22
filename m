Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0344148FE
	for <lists+io-uring@lfdr.de>; Wed, 22 Sep 2021 14:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235781AbhIVMf4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Sep 2021 08:35:56 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:46147 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235335AbhIVMfz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Sep 2021 08:35:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpEjUHm_1632314064;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UpEjUHm_1632314064)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 22 Sep 2021 20:34:24 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [RFC 1/3] io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request
Date:   Wed, 22 Sep 2021 20:34:15 +0800
Message-Id: <20210922123417.2844-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210922123417.2844-1-xiaoguang.wang@linux.alibaba.com>
References: <20210922123417.2844-1-xiaoguang.wang@linux.alibaba.com>
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

With this patch, a pure echo_server(1000 connections, packet is 16 bytes)
shows about 1.6% reqs improvement.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1294b1ef4acb..ca4464a75c7b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -487,6 +487,7 @@ struct io_poll_iocb {
 	__poll_t			events;
 	bool				done;
 	bool				canceled;
+	bool				active;
 	struct wait_queue_entry		wait;
 };
 
@@ -5025,8 +5026,6 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 
 	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
 
-	list_del_init(&poll->wait.entry);
-
 	req->result = mask;
 	req->io_task_work.func = func;
 
@@ -5057,7 +5056,10 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 
 	spin_lock(&ctx->completion_lock);
 	if (!req->result && !READ_ONCE(poll->canceled)) {
-		add_wait_queue(poll->head, &poll->wait);
+		if (req->opcode == IORING_OP_POLL_ADD)
+			WRITE_ONCE(req->poll.active, true);
+		else
+			add_wait_queue(poll->head, &poll->wait);
 		return true;
 	}
 
@@ -5133,6 +5135,9 @@ static inline bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	return done;
 }
 
+static bool __io_poll_remove_one(struct io_kiocb *req,
+				 struct io_poll_iocb *poll, bool do_cancel);
+
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5146,10 +5151,11 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 		done = __io_poll_complete(req, req->result);
 		if (done) {
 			io_poll_remove_double(req);
+			__io_poll_remove_one(req, io_poll_get_single(req), true);
 			hash_del(&req->hash_node);
 		} else {
 			req->result = 0;
-			add_wait_queue(req->poll.head, &req->poll.wait);
+			WRITE_ONCE(req->poll.active, true);
 		}
 		io_commit_cqring(ctx);
 		spin_unlock(&ctx->completion_lock);
@@ -5204,6 +5210,7 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 	poll->head = NULL;
 	poll->done = false;
 	poll->canceled = false;
+	poll->active = true;
 #define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
 	/* mask in events that we always want/need */
 	poll->events = events | IO_POLL_UNMASK;
@@ -5301,6 +5308,7 @@ static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	trace_io_uring_poll_wake(req->ctx, req->opcode, req->user_data,
 					key_to_poll(key));
 
+	list_del_init(&poll->wait.entry);
 	return __io_async_wake(req, poll, key_to_poll(key), io_async_task_func);
 }
 
@@ -5569,6 +5577,10 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	struct io_kiocb *req = wait->private;
 	struct io_poll_iocb *poll = &req->poll;
 
+	if (!READ_ONCE(poll->active))
+		return 0;
+
+	WRITE_ONCE(poll->active, false);
 	return __io_async_wake(req, poll, key_to_poll(key), io_poll_task_func);
 }
 
-- 
2.14.4.44.g2045bb6

