Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0735416ACD
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 06:22:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237144AbhIXEYB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 00:24:01 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:7031 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232553AbhIXEYA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 00:24:00 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R481e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0UpOPY2R_1632457346;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0UpOPY2R_1632457346)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 24 Sep 2021 12:22:26 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com
Subject: [PATCH v2 2/2] io_uring: don't get completion_lock in io_poll_rewait()
Date:   Fri, 24 Sep 2021 12:22:24 +0800
Message-Id: <20210924042224.8061-3-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20210924042224.8061-1-xiaoguang.wang@linux.alibaba.com>
References: <20210924042224.8061-1-xiaoguang.wang@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In current implementation, if there are not available events,
io_poll_rewait() just gets completion_lock, and unlocks it in
io_poll_task_func() or io_async_task_func(), which isn't necessary.

Change this logic to let io_poll_task_func() or io_async_task_func()
get the completion_lock lock, this is also a preparation for
later patch, which will batch poll request completion.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 50 ++++++++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7fc52a7f6f05..1cf0aaaa086e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5263,10 +5263,7 @@ static int __io_async_wake(struct io_kiocb *req, struct io_poll_iocb *poll,
 }
 
 static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
-	__acquires(&req->ctx->completion_lock)
 {
-	struct io_ring_ctx *ctx = req->ctx;
-
 	/* req->task == current here, checking PF_EXITING is safe */
 	if (unlikely(req->task->flags & PF_EXITING))
 		WRITE_ONCE(poll->canceled, true);
@@ -5277,7 +5274,6 @@ static bool io_poll_rewait(struct io_kiocb *req, struct io_poll_iocb *poll)
 		req->result = vfs_poll(req->file, &pt) & poll->events;
 	}
 
-	spin_lock(&ctx->completion_lock);
 	if (!req->result && !READ_ONCE(poll->canceled)) {
 		if (req->opcode == IORING_OP_POLL_ADD)
 			WRITE_ONCE(req->poll.active, true);
@@ -5365,30 +5361,29 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *nxt;
+	bool done;
 
-	if (io_poll_rewait(req, &req->poll)) {
-		spin_unlock(&ctx->completion_lock);
-	} else {
-		bool done;
+	if (io_poll_rewait(req, &req->poll))
+		return;
 
-		done = __io_poll_complete(req, req->result);
-		if (done) {
-			io_poll_remove_double(req);
-			__io_poll_remove_one(req, io_poll_get_single(req), true);
-			hash_del(&req->hash_node);
-		} else {
-			req->result = 0;
-			WRITE_ONCE(req->poll.active, true);
-		}
-		io_commit_cqring(ctx);
-		spin_unlock(&ctx->completion_lock);
-		io_cqring_ev_posted(ctx);
+	spin_lock(&ctx->completion_lock);
+	done = __io_poll_complete(req, req->result);
+	if (done) {
+		io_poll_remove_double(req);
+		__io_poll_remove_one(req, io_poll_get_single(req), true);
+		hash_del(&req->hash_node);
+	} else {
+		req->result = 0;
+		WRITE_ONCE(req->poll.active, true);
+	}
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
+	io_cqring_ev_posted(ctx);
 
-		if (done) {
-			nxt = io_put_req_find_next(req);
-			if (nxt)
-				io_req_task_submit(nxt, locked);
-		}
+	if (done) {
+		nxt = io_put_req_find_next(req);
+		if (nxt)
+			io_req_task_submit(nxt, locked);
 	}
 }
 
@@ -5507,11 +5502,10 @@ static void io_async_task_func(struct io_kiocb *req, bool *locked)
 
 	trace_io_uring_task_run(req->ctx, req, req->opcode, req->user_data);
 
-	if (io_poll_rewait(req, &apoll->poll)) {
-		spin_unlock(&ctx->completion_lock);
+	if (io_poll_rewait(req, &apoll->poll))
 		return;
-	}
 
+	spin_lock(&ctx->completion_lock);
 	hash_del(&req->hash_node);
 	io_poll_remove_double(req);
 	spin_unlock(&ctx->completion_lock);
-- 
2.14.4.44.g2045bb6

