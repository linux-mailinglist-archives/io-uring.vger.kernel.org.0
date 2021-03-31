Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC4934FC0E
	for <lists+io-uring@lfdr.de>; Wed, 31 Mar 2021 11:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234086AbhCaJB2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 31 Mar 2021 05:01:28 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:59037 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231156AbhCaJBO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 31 Mar 2021 05:01:14 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R761e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UTx3vM-_1617181262;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UTx3vM-_1617181262)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 31 Mar 2021 17:01:11 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH for-5.13] io_uring: maintain drain requests' logic
Date:   Wed, 31 Mar 2021 17:01:02 +0800
Message-Id: <1617181262-66724-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
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
drain requests  won't wait those request to be done.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 513096759445..cd6d44cf5940 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -455,6 +455,7 @@ struct io_ring_ctx {
 	struct callback_head		*exit_task_work;
 
 	struct wait_queue_head		hash_wait;
+	unsigned                        multishot_cqes;
 
 	/* Keep this last, we don't need it for the fast path */
 	struct work_struct		exit_work;
@@ -1181,8 +1182,8 @@ static bool req_need_defer(struct io_kiocb *req, u32 seq)
 	if (unlikely(req->flags & REQ_F_IO_DRAIN)) {
 		struct io_ring_ctx *ctx = req->ctx;
 
-		return seq != ctx->cached_cq_tail
-				+ READ_ONCE(ctx->cached_cq_overflow);
+		return seq + ctx->multishot_cqes != ctx->cached_cq_tail
+			+ READ_ONCE(ctx->cached_cq_overflow);
 	}
 
 	return false;
@@ -4897,6 +4898,7 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	unsigned flags = IORING_CQE_F_MORE;
+	bool multishot_poll = !(req->poll.events & EPOLLONESHOT);
 
 	if (!error && req->poll.canceled) {
 		error = -ECANCELED;
@@ -4911,6 +4913,9 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 		req->poll.done = true;
 		flags = 0;
 	}
+	if (multishot_poll)
+		ctx->multishot_cqes++;
+
 	io_commit_cqring(ctx);
 	return !(flags & IORING_CQE_F_MORE);
 }
-- 
1.8.3.1

