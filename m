Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4900B35D8C0
	for <lists+io-uring@lfdr.de>; Tue, 13 Apr 2021 09:21:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238902AbhDMHVN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 13 Apr 2021 03:21:13 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:35007 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229580AbhDMHVM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 13 Apr 2021 03:21:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UVQQ6R5_1618298439;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UVQQ6R5_1618298439)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 13 Apr 2021 15:20:51 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3] io_uring: maintain drain logic for multishot poll requests
Date:   Tue, 13 Apr 2021 15:20:39 +0800
Message-Id: <1618298439-136286-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now that we have multishot poll requests, one SQE can emit multiple
CQEs. given below example:
    sqe0(multishot poll)-->sqe1-->sqe2(drain req)
sqe2 is designed to issue after sqe0 and sqe1 completed, but since sqe0
is a multishot poll request, sqe2 may be issued after sqe0's event
triggered twice before sqe1 completed. This isn't what users leverage
drain requests for.
Here the solution is to wait for multishot poll requests fully
completed.
To achieve this, we should reconsider the req_need_defer equation, the
original one is:

    all_sqes(excluding dropped ones) == all_cqes(including dropped ones)

This means we issue a drain request when all the previous submitted
SQEs have generated their CQEs.
Now we should consider multishot requests, we deduct all the multishot
CQEs except the cancellation one, In this way a multishot poll request
behave like a normal request, so:
    all_sqes == all_cqes - multishot_cqes(except cancellations)

Here we introduce cq_extra for it.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8564c7908126..0ccdeef8cd26 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -424,6 +424,7 @@ struct io_ring_ctx {
 		unsigned		cq_mask;
 		atomic_t		cq_timeouts;
 		unsigned		cq_last_tm_flush;
+		unsigned		cq_extra;
 		unsigned long		cq_check_overflow;
 		struct wait_queue_head	cq_wait;
 		struct fasync_struct	*cq_fasync;
@@ -1190,7 +1191,7 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		return seq != ctx->cached_cq_tail
+		return seq + ctx->cq_extra != ctx->cached_cq_tail
 				+ READ_ONCE(ctx->cached_cq_overflow);
 	}
 
@@ -4911,6 +4912,9 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 		req->poll.done = true;
 		flags = 0;
 	}
+	if (flags & IORING_CQE_F_MORE)
+		ctx->cq_extra++;
+
 	io_commit_cqring(ctx);
 	return !(flags & IORING_CQE_F_MORE);
 }
-- 
1.8.3.1

