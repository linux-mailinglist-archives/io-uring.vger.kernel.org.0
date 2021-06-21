Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A923AF603
	for <lists+io-uring@lfdr.de>; Mon, 21 Jun 2021 21:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhFUTYc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Jun 2021 15:24:32 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:46960 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230061AbhFUTYb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Jun 2021 15:24:31 -0400
Received: from [173.237.58.148] (port=33322 helo=localhost)
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lvPUt-0006Dz-Lh; Mon, 21 Jun 2021 15:22:15 -0400
Date:   Mon, 21 Jun 2021 12:22:13 -0700
Message-Id: <4deda7761d61c189f4e2581828f852c8a1acb723.1624303174.git.olivier@trillion01.com>
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Olivier Langlois <olivier@trillion01.com>
Subject: [PATCH v3] io_uring: reduce latency by reissueing the operation
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

It is quite frequent that when an operation fails and returns EAGAIN,
the data becomes available between that failure and the call to
vfs_poll() done by io_arm_poll_handler().

Detecting the situation and reissuing the operation is much faster
than going ahead and push the operation to the io-wq.

Signed-off-by: Olivier Langlois <olivier@trillion01.com>
---
 fs/io_uring.c | 31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fc8637f591a6..5efa67c2f974 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5152,7 +5152,13 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 	return mask;
 }
 
-static bool io_arm_poll_handler(struct io_kiocb *req)
+enum {
+	IO_APOLL_OK,
+	IO_APOLL_ABORTED,
+	IO_APOLL_READY
+};
+
+static int io_arm_poll_handler(struct io_kiocb *req)
 {
 	const struct io_op_def *def = &io_op_defs[req->opcode];
 	struct io_ring_ctx *ctx = req->ctx;
@@ -5162,22 +5168,22 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	int rw;
 
 	if (!req->file || !file_can_poll(req->file))
-		return false;
+		return IO_APOLL_ABORTED;
 	if (req->flags & REQ_F_POLLED)
-		return false;
+		return IO_APOLL_ABORTED;
 	if (def->pollin)
 		rw = READ;
 	else if (def->pollout)
 		rw = WRITE;
 	else
-		return false;
+		return IO_APOLL_ABORTED;
 	/* if we can't nonblock try, then no point in arming a poll handler */
 	if (!io_file_supports_async(req, rw))
-		return false;
+		return IO_APOLL_ABORTED;
 
 	apoll = kmalloc(sizeof(*apoll), GFP_ATOMIC);
 	if (unlikely(!apoll))
-		return false;
+		return IO_APOLL_ABORTED;
 	apoll->double_poll = NULL;
 
 	req->flags |= REQ_F_POLLED;
@@ -5203,12 +5209,14 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	if (ret || ipt.error) {
 		io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
-		return false;
+		if (ret)
+			return IO_APOLL_READY;
+		return IO_APOLL_ABORTED;
 	}
 	spin_unlock_irq(&ctx->completion_lock);
 	trace_io_uring_poll_arm(ctx, req, req->opcode, req->user_data,
 				mask, apoll->poll.events);
-	return true;
+	return IO_APOLL_OK;
 }
 
 static bool __io_poll_remove_one(struct io_kiocb *req,
@@ -6437,6 +6445,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 	struct io_kiocb *linked_timeout = io_prep_linked_timeout(req);
 	int ret;
 
+issue_sqe:
 	ret = io_issue_sqe(req, IO_URING_F_NONBLOCK|IO_URING_F_COMPLETE_DEFER);
 
 	/*
@@ -6456,12 +6465,16 @@ static void __io_queue_sqe(struct io_kiocb *req)
 			io_put_req(req);
 		}
 	} else if (ret == -EAGAIN && !(req->flags & REQ_F_NOWAIT)) {
-		if (!io_arm_poll_handler(req)) {
+		switch (io_arm_poll_handler(req)) {
+		case IO_APOLL_READY:
+			goto issue_sqe;
+		case IO_APOLL_ABORTED:
 			/*
 			 * Queued up for async execution, worker will release
 			 * submit reference when the iocb is actually submitted.
 			 */
 			io_queue_async_work(req);
+			break;
 		}
 	} else {
 		io_req_complete_failed(req, ret);
-- 
2.32.0

