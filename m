Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80ED9356B0E
	for <lists+io-uring@lfdr.de>; Wed,  7 Apr 2021 13:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbhDGLX5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 7 Apr 2021 07:23:57 -0400
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:37867 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234767AbhDGLXm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 7 Apr 2021 07:23:42 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UUnhk8L_1617794605;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UUnhk8L_1617794605)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 07 Apr 2021 19:23:31 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/3] io_uring: maintain drain logic for multishot requests
Date:   Wed,  7 Apr 2021 19:23:24 +0800
Message-Id: <1617794605-35748-3-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
References: <1617794605-35748-1-git-send-email-haoxu@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now that we have multishot poll requests, one sqe can emit multiple
cqes. given below example:
    sqe0(multishot poll)-->sqe1-->sqe2(drain req)
sqe2 is designed to issue after sqe0 and sqe1 completed, but since sqe0
is a multishot poll request, sqe2 may be issued after sqe0's event
triggered twice before sqe1 completed. This isn't what users leverage
drain requests for.
Here a simple solution is to ignore all multishot poll cqes, which means
drain requests won't wait those request to be done.
To achieve this, we should reconsider the req_need_defer equation, the
original one is:

    all_sqes(excluding dropped ones) == all_cqes(including dropped ones)

this means we issue a drain request when all the previous submitted
sqes have generated their cqes.
Now we should ignore multishot requests, so:
    all_sqes - multishot_sqes == all_cqes - multishot_cqes ==>
    all_sqes + multishot_cqes - multishot_cqes == all_cqes

Thus we have to track the submittion of a multishot request and the cqes
generation of it, including the ECANCELLED cqes. Here we introduce
cq_extra = multishot_cqes - multishot_cqes for it.

There are other solutions like:
  - just track multishot (non-ECNCELLED)cqes, don't track multishot sqes.
      this way we include multishot sqes in the left end of the equation
      this means we have to see multishot sqes as normal ones, then we
      have to keep right one cqe for each multishot sqe. It's hard to do
      this since there may be some multishot sqes which triggered
      several events and then was cancelled, meanwhile other multishot
      sqes just triggered events but wasn't cancelled. We still need to
      track number of multishot sqes that haven't been cancelled, which
      make things complicated

For implementations, just do the submittion tracking in
io_submit_sqe() --> io_init_req() to make things simple. Otherwise if
we do it in per opcode issue place, then we need to carefully consider
each caller of io_req_complete_failed() because trick cases like cancel
multishot reqs in link.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 192463bb977a..a7bd223ce2cc 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -423,6 +423,7 @@ struct io_ring_ctx {
 		unsigned		cq_mask;
 		atomic_t		cq_timeouts;
 		unsigned		cq_last_tm_flush;
+		unsigned		cq_extra;
 		unsigned long		cq_check_overflow;
 		struct wait_queue_head	cq_wait;
 		struct fasync_struct	*cq_fasync;
@@ -879,6 +880,8 @@ struct io_op_def {
 	unsigned		needs_async_setup : 1;
 	/* should block plug */
 	unsigned		plug : 1;
+	/* set if opcode may generate multiple cqes */
+	unsigned		multi_cqes : 1;
 	/* size of async data needed, if any */
 	unsigned short		async_size;
 };
@@ -924,6 +927,7 @@ struct io_op_def {
 	[IORING_OP_POLL_ADD] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.multi_cqes		= 1,
 	},
 	[IORING_OP_POLL_REMOVE] = {},
 	[IORING_OP_SYNC_FILE_RANGE] = {
@@ -1186,7 +1190,7 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		return seq != ctx->cached_cq_tail
+		return seq + ctx->cq_extra != ctx->cached_cq_tail
 				+ READ_ONCE(ctx->cached_cq_overflow);
 	}
 
@@ -1516,6 +1520,9 @@ static bool __io_cqring_fill_event(struct io_kiocb *req, long res,
 
 	trace_io_uring_complete(ctx, req->user_data, res, cflags);
 
+	if (req->flags & REQ_F_MULTI_CQES)
+		req->ctx->cq_extra++;
+
 	/*
 	 * If we can't get a cq entry, userspace overflowed the
 	 * submission (by quite a lot). Increment the overflow count in
@@ -6504,6 +6511,13 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->result = 0;
 	req->work.creds = NULL;
 
+	if (sqe_flags & IOSQE_MULTI_CQES) {
+		ctx->cq_extra--;
+		if (!io_op_defs[req->opcode].multi_cqes) {
+			return -EOPNOTSUPP;
+		}
+	}
+
 	/* enforce forwards compatibility on users */
 	if (unlikely(sqe_flags & ~SQE_VALID_FLAGS)) {
 		req->flags = 0;
-- 
1.8.3.1

