Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B138426AF3
	for <lists+io-uring@lfdr.de>; Fri,  8 Oct 2021 14:36:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241532AbhJHMir (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 8 Oct 2021 08:38:47 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:57261 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241597AbhJHMiq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 8 Oct 2021 08:38:46 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Ur.V7Wc_1633696602;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Ur.V7Wc_1633696602)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 08 Oct 2021 20:36:49 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/2] io_uring: implementation of IOSQE_ASYNC_HYBRID logic
Date:   Fri,  8 Oct 2021 20:36:42 +0800
Message-Id: <20211008123642.229338-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211008123642.229338-1-haoxu@linux.alibaba.com>
References: <20211008123642.229338-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The process of this kind of requests is:

step1: original context:
           queue it to io-worker
step2: io-worker context:
           nonblock try(the old logic is a synchronous try here)
               |
               |--fail--> arm poll
                            |
                            |--(fail/ready)-->synchronous issue
                            |
                            |--(succeed)-->worker finish it's job, tw
                                           take over the req

This works much better than IOSQE_ASYNC in cases where cpu resources
are scarce or unbound max_worker is small. In these cases, number of
io-worker eazily increments to max_worker, new worker cannot be created
and running workers stuck there handling old works in IOSQE_ASYNC mode.

In my machine, set unbound max_worker to 20, run echo-server, turns out:
(arguments: register_file, connetion number is 1000, message size is 12
Byte)
IOSQE_ASYNC: 76664.151 tps
IOSQE_ASYNC_HYBRID: 166934.985 tps

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 42 ++++++++++++++++++++++++++++++++++++++----
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a99f7f46e6d4..024cef09bc12 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1409,7 +1409,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 
 	req->work.list.next = NULL;
 	req->work.flags = 0;
-	if (req->flags & REQ_F_FORCE_ASYNC)
+	if (req->flags & (REQ_F_FORCE_ASYNC | REQ_F_ASYNC_HYBRID))
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
 	if (req->flags & REQ_F_ISREG) {
@@ -5575,7 +5575,13 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	req->apoll = apoll;
 	req->flags |= REQ_F_POLLED;
 	ipt.pt._qproc = io_async_queue_proc;
-	io_req_set_refcount(req);
+	/*
+	 * REQ_F_REFCOUNT set indicate we are in io-worker context, where we
+	 * already explicitly set the submittion and completion ref. So no
+	 * need to set refcount here if that is the case.
+	 */
+	if (!(req->flags & REQ_F_REFCOUNT))
+		io_req_set_refcount(req);
 
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
@@ -6704,8 +6710,11 @@ static void io_wq_submit_work(struct io_wq_work *work)
 		ret = -ECANCELED;
 
 	if (!ret) {
+		bool need_poll = req->flags & REQ_F_ASYNC_HYBRID;
+
 		do {
-			ret = io_issue_sqe(req, 0);
+issue_sqe:
+			ret = io_issue_sqe(req, need_poll ? IO_URING_F_NONBLOCK : 0);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -6713,6 +6722,30 @@ static void io_wq_submit_work(struct io_wq_work *work)
 			 */
 			if (ret != -EAGAIN)
 				break;
+			if (need_poll) {
+				bool armed = false;
+
+				ret = 0;
+				need_poll = false;
+
+				switch (io_arm_poll_handler(req)) {
+				case IO_APOLL_READY:
+					goto issue_sqe;
+				case IO_APOLL_ABORTED:
+					/*
+					 * somehow we failed to arm the poll infra,
+					 * fallback it to a normal async worker try.
+					 */
+					break;
+				case IO_APOLL_OK:
+					armed = true;
+					break;
+				}
+
+				if (armed)
+					break;
+
+			}
 			cond_resched();
 		} while (1);
 	}
@@ -6928,7 +6961,8 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 static inline void io_queue_sqe(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
-	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL))))
+	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_ASYNC_HYBRID |
+				   REQ_F_FAIL))))
 		__io_queue_sqe(req);
 	else
 		io_queue_sqe_fallback(req);
-- 
2.24.4

