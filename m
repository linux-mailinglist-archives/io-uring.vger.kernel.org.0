Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3683B0416
	for <lists+io-uring@lfdr.de>; Tue, 22 Jun 2021 14:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbhFVMT5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Jun 2021 08:19:57 -0400
Received: from cloud48395.mywhc.ca ([173.209.37.211]:34348 "EHLO
        cloud48395.mywhc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230422AbhFVMT5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Jun 2021 08:19:57 -0400
Received: from [173.237.58.148] (port=33324 helo=localhost)
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <olivier@trillion01.com>)
        id 1lvfLY-0003l2-O3; Tue, 22 Jun 2021 08:17:40 -0400
Date:   Tue, 22 Jun 2021 05:17:39 -0700
From:   Olivier Langlois <olivier@trillion01.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Olivier Langlois <olivier@trillion01.com>
Message-Id: <9e8441419bb1b8f3c3fcc607b2713efecdef2136.1624364038.git.olivier@trillion01.com>
Subject: [PATCH v4] io_uring: reduce latency by reissueing the operation
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

Performance improvement testing has been performed with:
Single thread, 1 TCP connection receiving a 5 Mbps stream, no sqpoll.

4 measurements have been taken:
1. The time it takes to process a read request when data is already available
2. The time it takes to process by calling twice io_issue_sqe() after vfs_poll() indicated that data was available
3. The time it takes to execute io_queue_async_work()
4. The time it takes to complete a read request asynchronously

2.25% of all the read operations did use the new path.

ready data (baseline)
avg	3657.94182918628
min	580
max	20098
stddev	1213.15975908162

reissue	completion
average	7882.67567567568
min	2316
max	28811
stddev	1982.79172973284

insert io-wq time
average	8983.82276995305
min	3324
max	87816
stddev	2551.60056552038

async time completion
average	24670.4758861127
min	10758
max	102612
stddev	3483.92416873804

Conclusion:
On average reissuing the sqe with the patch code is 1.1uSec faster and
in the worse case scenario 59uSec faster than placing the request on
io-wq

On average completion time by reissuing the sqe with the patch code is
16.79uSec faster and in the worse case scenario 73.8uSec faster than
async completion.

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

