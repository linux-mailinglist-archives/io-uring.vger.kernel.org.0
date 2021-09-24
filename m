Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 842FC416ACC
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 06:22:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhIXEYA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 00:24:00 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:51288 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232553AbhIXEX7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 00:23:59 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UpOMtn6_1632457345;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UpOMtn6_1632457345)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 24 Sep 2021 12:22:25 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [PATCH v2 1/2] io_uring: reduce frequent add_wait_queue() overhead for multi-shot poll request
Date:   Fri, 24 Sep 2021 12:22:23 +0800
Message-Id: <20210924042224.8061-2-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210924042224.8061-1-xiaoguang.wang@linux.alibaba.com>
References: <20210924042224.8061-1-xiaoguang.wang@linux.alibaba.com>
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
 fs/io_uring.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7bfd2d00d4fc..7fc52a7f6f05 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -488,6 +488,7 @@ struct io_poll_iocb {
 	__poll_t			events;
 	bool				done;
 	bool				canceled;
+	bool				active;
 	struct wait_queue_entry		wait;
 };
 
@@ -5248,8 +5249,6 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 
 	trace_io_uring_task_add(req->ctx, req->opcode, req->user_data, mask);
 
-	list_del_init(&poll->wait.entry);
-
 	req->result = mask;
 	req->io_task_work.func = func;
 
@@ -5280,7 +5279,10 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 
 	spin_lock(&ctx->completion_lock);
 	if (!req->result && !READ_ONCE(poll->canceled)) {
-		add_wait_queue(poll->head, &poll->wait);
+		if (req->opcode == IORING_OP_POLL_ADD)
+			WRITE_ONCE(req->poll.active, true);
+		else
+			add_wait_queue(poll->head, &poll->wait);
 		return true;
 	}
 
@@ -5356,6 +5358,9 @@ static inline bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	return done;
 }
 
+static bool __io_poll_remove_one(struct io_kiocb *req,
+				 struct io_poll_iocb *poll, bool do_cancel);
+
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5369,10 +5374,11 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
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
@@ -5427,6 +5433,7 @@ static void io_init_poll_iocb(struct io_poll_iocb *poll, __poll_t events,
 	poll->head = NULL;
 	poll->done = false;
 	poll->canceled = false;
+	poll->active = true;
 #define IO_POLL_UNMASK	(EPOLLERR|EPOLLHUP|EPOLLNVAL|EPOLLRDHUP)
 	/* mask in events that we always want/need */
 	poll->events = events | IO_POLL_UNMASK;
@@ -5524,6 +5531,7 @@ static int io_async_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 	trace_io_uring_poll_wake(req->ctx, req->opcode, req->user_data,
 					key_to_poll(key));
 
+	list_del_init(&poll->wait.entry);
 	return __io_async_wake(req, poll, key_to_poll(key), io_async_task_func);
 }
 
@@ -5792,6 +5800,10 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
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

