Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B03431750
	for <lists+io-uring@lfdr.de>; Mon, 18 Oct 2021 13:29:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbhJRLbm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Oct 2021 07:31:42 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:45823 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230494AbhJRLbm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Oct 2021 07:31:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Usdq2Cm_1634556563;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Usdq2Cm_1634556563)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 18 Oct 2021 19:29:29 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/2] io_uring: implement async hybrid mode for pollable requests
Date:   Mon, 18 Oct 2021 19:29:23 +0800
Message-Id: <20211018112923.16874-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211018112923.16874-1-haoxu@linux.alibaba.com>
References: <20211018112923.16874-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The current logic of requests with IOSQE_ASYNC is first queueing it to
io-worker, then execute it in a synchronous way. For unbound works like
pollable requests(e.g. read/write a socketfd), the io-worker may stuck
there waiting for events for a long time. And thus other works wait in
the list for a long time too.
Let's introduce a new way for unbound works (currently pollable
requests), with this a request will first be queued to io-worker, then
executed in a nonblock try rather than a synchronous way. Failure of
that leads it to arm poll stuff and then the worker can begin to handle
other works.
The detail process of this kind of requests is:

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

This works much better than the old IOSQE_ASYNC logic in cases where
unbound max_worker is relatively small. In this case, number of
io-worker eazily increments to max_worker, new worker cannot be created
and running workers stuck there handling old works in IOSQE_ASYNC mode.

In my 64-core machine, set unbound max_worker to 20, run echo-server,
turns out:
(arguments: register_file, connetion number is 1000, message size is 12
Byte)
original IOSQE_ASYNC: 76664.151 tps
after this patch: 166934.985 tps

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c                 | 39 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  4 +++-
 2 files changed, 40 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 727cad6c36fc..a3247a5dafc9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3497,7 +3497,8 @@ static int io_read(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
 		/* IOPOLL retry should happen for io-wq threads */
-		if (in_worker && !(req->ctx->flags & IORING_SETUP_IOPOLL))
+		if (in_worker && !force_nonblock &&
+		    !(req->ctx->flags & IORING_SETUP_IOPOLL))
 			goto done;
 		/* no retry on NONBLOCK nor RWF_NOWAIT */
 		if (req->flags & REQ_F_NOWAIT)
@@ -6749,8 +6750,18 @@ static void io_wq_submit_work(struct io_wq_work *work)
 		ret = -ECANCELED;
 
 	if (!ret) {
+		bool needs_poll = false;
+		unsigned int issue_flags = IO_URING_F_UNLOCKED;
+
+		if (req->flags & REQ_F_FORCE_ASYNC) {
+			needs_poll = req->file && file_can_poll(req->file);
+			if (needs_poll)
+				issue_flags |= IO_URING_F_NONBLOCK;
+		}
+
 		do {
-			ret = io_issue_sqe(req, IO_URING_F_UNLOCKED);
+issue_sqe:
+			ret = io_issue_sqe(req, issue_flags);
 			/*
 			 * We can get EAGAIN for polled IO even though we're
 			 * forcing a sync submission from here, since we can't
@@ -6758,6 +6769,30 @@ static void io_wq_submit_work(struct io_wq_work *work)
 			 */
 			if (ret != -EAGAIN)
 				break;
+			if (needs_poll) {
+				bool armed = false;
+
+				ret = 0;
+				needs_poll = false;
+				issue_flags &= ~IO_URING_F_NONBLOCK;
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
+			}
 			cond_resched();
 		} while (1);
 	}
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index c45b5e9a9387..3e49a7dbe636 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -70,6 +70,7 @@ enum {
 	IOSQE_IO_HARDLINK_BIT,
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
+	IOSQE_ASYNC_HYBRID_BIT,
 };
 
 /*
@@ -87,7 +88,8 @@ enum {
 #define IOSQE_ASYNC		(1U << IOSQE_ASYNC_BIT)
 /* select buffer from sqe->buf_group */
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
-
+/* first force async then arm poll */
+#define IOSQE_ASYNC_HYBRID	(1U << IOSQE_ASYNC_HYBRID_BIT)
 /*
  * io_uring_setup() flags
  */
-- 
2.24.4

