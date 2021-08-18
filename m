Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1A353EFE03
	for <lists+io-uring@lfdr.de>; Wed, 18 Aug 2021 09:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238014AbhHRHn6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Aug 2021 03:43:58 -0400
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:43603 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238342AbhHRHn5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Aug 2021 03:43:57 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UjeejBw_1629272596;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UjeejBw_1629272596)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 Aug 2021 15:43:21 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/3] io_uring: fix failed linkchain code logic
Date:   Wed, 18 Aug 2021 15:43:15 +0800
Message-Id: <20210818074316.22347-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210818074316.22347-1-haoxu@linux.alibaba.com>
References: <20210818074316.22347-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Given a linkchain like this:
req0(link_flag)-->req1(link_flag)-->...-->reqn(no link_flag)

There is a problem:
 - if some intermediate linked req like req1 's submittion fails, reqs
   after it won't be cancelled.

   - sqpoll disabled: maybe it's ok since users can get the error info
     of req1 and stop submitting the following sqes.

   - sqpoll enabled: definitely a problem, the following sqes will be
     submitted in the next round.

The solution is to refactor the code logic to:
 - link a linked req to the chain first, no matter its submittion fails
   or not.
 - if a linked req's submittion fails, just mark head as
   failed. leverage req->result to indicate whether the req is a failed
   one or cancelled one.
 - submit or fail the whole chain

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 86 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 58 insertions(+), 28 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c0b841506869..383668e07417 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1920,11 +1920,13 @@ static void io_fail_links(struct io_kiocb *req)
 
 	req->link = NULL;
 	while (link) {
+		int res = link->result ? link->result : -ECANCELED;
+
 		nxt = link->link;
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
-		io_cqring_fill_event(link->ctx, link->user_data, -ECANCELED, 0);
+		io_cqring_fill_event(link->ctx, link->user_data, res, 0);
 		io_put_req_deferred(link);
 		link = nxt;
 	}
@@ -5698,7 +5700,7 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	if (is_timeout_link) {
 		struct io_submit_link *link = &req->ctx->submit_state.link;
 
-		if (!link->head)
+		if (!link->head || link->head == req)
 			return -EINVAL;
 		if (link->last->opcode == IORING_OP_LINK_TIMEOUT)
 			return -EINVAL;
@@ -6622,17 +6624,38 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	__must_hold(&ctx->uring_lock)
 {
 	struct io_submit_link *link = &ctx->submit_state.link;
+	bool is_link = sqe->flags & (IOSQE_IO_LINK | IOSQE_IO_HARDLINK);
+	struct io_kiocb *head;
 	int ret;
 
+	/*
+	 * we don't update link->last until we've done io_req_prep()
+	 * since linked timeout uses old link->last
+	 */
+	if (link->head)
+		link->last->link = req;
+	else if (is_link)
+		link->head = req;
+	head = link->head;
+
 	ret = io_init_req(ctx, req, sqe);
 	if (unlikely(ret)) {
 fail_req:
-		if (link->head) {
-			/* fail even hard links since we don't submit */
-			io_req_complete_failed(link->head, -ECANCELED);
-			link->head = NULL;
+		req->result = ret;
+		if (head) {
+			link->last = req;
+			if (is_link) {
+				req_set_fail(head);
+			} else {
+				int res = head->result ? head->result : -ECANCELED;
+
+				link->head = NULL;
+				/* fail even hard links since we don't submit */
+				io_req_complete_failed(head, res);
+			}
+		} else {
+			io_req_complete_failed(req, ret);
 		}
-		io_req_complete_failed(req, ret);
 		return ret;
 	}
 
@@ -6652,28 +6675,26 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	 * submitted sync once the chain is complete. If none of those
 	 * conditions are true (normal request), then just queue it.
 	 */
-	if (link->head) {
-		struct io_kiocb *head = link->head;
-
-		ret = io_req_prep_async(req);
-		if (unlikely(ret))
-			goto fail_req;
+	if (head) {
+		if (req != head) {
+			ret = io_req_prep_async(req);
+			if (unlikely(ret))
+				goto fail_req;
+		}
 		trace_io_uring_link(ctx, req, head);
-		link->last->link = req;
-		link->last = req;
 
+		link->last = req;
 		/* last request of a link, enqueue the link */
-		if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
-			link->head = NULL;
-			io_queue_sqe(head);
+		if (!is_link) {
+			if (head->flags & REQ_F_FAIL) {
+				goto fail_req;
+			} else {
+				link->head = NULL;
+				io_queue_sqe(head);
+			}
 		}
 	} else {
-		if (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) {
-			link->head = req;
-			link->last = req;
-		} else {
-			io_queue_sqe(req);
-		}
+		io_queue_sqe(req);
 	}
 
 	return 0;
@@ -6685,8 +6706,17 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 static void io_submit_state_end(struct io_submit_state *state,
 				struct io_ring_ctx *ctx)
 {
-	if (state->link.head)
-		io_queue_sqe(state->link.head);
+	struct io_kiocb *head = state->link.head;
+
+	if (head) {
+		if (head->flags & REQ_F_FAIL) {
+			int res = head->result ? head->result : -ECANCELED;
+
+			io_req_complete_failed(head, res);
+		} else {
+			io_queue_sqe(head);
+		}
+	}
 	if (state->compl_nr)
 		io_submit_flush_completions(ctx);
 	if (state->plug_started)
@@ -6701,8 +6731,8 @@ static void io_submit_state_start(struct io_submit_state *state,
 {
 	state->plug_started = false;
 	state->ios_left = max_ios;
-	/* set only head, no need to init link_last in advance */
 	state->link.head = NULL;
+	state->link.last = NULL;
 }
 
 static void io_commit_sqring(struct io_ring_ctx *ctx)
@@ -6788,7 +6818,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		}
 		/* will complete beyond this point, count as submitted */
 		submitted++;
-		if (io_submit_sqe(ctx, req, sqe))
+		if (io_submit_sqe(ctx, req, sqe) && !(ctx->flags & IORING_SETUP_SQPOLL))
 			break;
 	}
 
-- 
2.24.4

