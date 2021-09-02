Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96853FEFB0
	for <lists+io-uring@lfdr.de>; Thu,  2 Sep 2021 16:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbhIBOtv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 2 Sep 2021 10:49:51 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:42645 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229941AbhIBOtt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 2 Sep 2021 10:49:49 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Un0kbdz_1630594129;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Un0kbdz_1630594129)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 02 Sep 2021 22:48:49 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [RFC] io_uring: fix possible poll event lost in multi shot mode
Date:   Thu,  2 Sep 2021 22:48:43 +0800
Message-Id: <20210902144843.2668-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

IIUC, IORING_POLL_ADD_MULTI is similar to epoll's edge-triggered mode,
that means once one pure poll request returns one event(cqe), we'll
need to read or write continually until EAGAIN is returned, then I think
there is a possible poll event lost race in multi shot mode:

t1  poll request add |                         |
t2                   |                         |
t3  event happens    |                         |
t4  task work add    |                         |
t5                   | task work run           |
t6                   |   commit one cqe        |
t7                   |                         | user app handles cqe
t8                   |   new event happen      |
t9                   |   add back to waitqueue |
t10                  |

After t6 but before t9, if new event happens, there'll be no wakeup
operation, and if user app has picked up this cqe in t7, read or write
until EAGAIN is returned. In t8, new event happens and will be lost,
though this race window maybe small.

To fix this possible race, add poll request back to waitqueue before
committing cqe.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2bde732a1183..27608bad2276 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5098,7 +5098,7 @@ static void io_poll_remove_double(struct io_kiocb *req)
 	}
 }
 
-static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
+static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	__must_hold(&req->ctx->completion_lock)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5120,10 +5120,19 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	if (flags & IORING_CQE_F_MORE)
 		ctx->cq_extra++;
 
-	io_commit_cqring(ctx);
 	return !(flags & IORING_CQE_F_MORE);
 }
 
+static inline bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
+	__must_hold(&req->ctx->completion_lock)
+{
+	bool done;
+
+	done = __io_poll_complete(req, mask);
+	io_commit_cqring(req->ctx);
+	return done;
+}
+
 static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 {
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5134,7 +5143,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 	} else {
 		bool done;
 
-		done = io_poll_complete(req, req->result);
+		done = __io_poll_complete(req, req->result);
 		if (done) {
 			io_poll_remove_double(req);
 			hash_del(&req->hash_node);
@@ -5142,6 +5151,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 			req->result = 0;
 			add_wait_queue(req->poll.head, &req->poll.wait);
 		}
+		io_commit_cqring(ctx);
 		spin_unlock(&ctx->completion_lock);
 		io_cqring_ev_posted(ctx);
 
-- 
2.14.4.44.g2045bb6

