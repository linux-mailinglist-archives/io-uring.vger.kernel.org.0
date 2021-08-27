Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3229B3F97A2
	for <lists+io-uring@lfdr.de>; Fri, 27 Aug 2021 11:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245054AbhH0Jro (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 27 Aug 2021 05:47:44 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:48515 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S245120AbhH0JrR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 27 Aug 2021 05:47:17 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R391e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UmFsqUh_1630057569;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UmFsqUh_1630057569)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 27 Aug 2021 17:46:27 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/2] io_uring: fix failed linkchain code logic
Date:   Fri, 27 Aug 2021 17:46:09 +0800
Message-Id: <20210827094609.36052-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210827094609.36052-1-haoxu@linux.alibaba.com>
References: <20210827094609.36052-1-haoxu@linux.alibaba.com>
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
 - if a linked req's submittion fails, just mark it and the head(if it
   exists) as REQ_F_FAIL. Leverage req->result to indicate whether it
   is failed or cancelled.
 - submit or fail the whole chain when we come to the end of it.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 61 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 47 insertions(+), 14 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3598319b1340..4c83ec227d85 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1175,6 +1175,12 @@ static inline void req_set_fail(struct io_kiocb *req)
 	req->flags |= REQ_F_FAIL;
 }
 
+static inline void req_fail_link_node(struct io_kiocb *req, int res)
+{
+	req_set_fail(req);
+	req->result = res;
+}
+
 static void io_ring_ctx_ref_free(struct percpu_ref *ref)
 {
 	struct io_ring_ctx *ctx = container_of(ref, struct io_ring_ctx, refs);
@@ -1931,11 +1937,16 @@ static void io_fail_links(struct io_kiocb *req)
 
 	req->link = NULL;
 	while (link) {
+		long res = -ECANCELED;
+
+		if (link->flags & REQ_F_FAIL)
+			res = link->result;
+
 		nxt = link->link;
 		link->link = NULL;
 
 		trace_io_uring_fail_link(req, link);
-		io_cqring_fill_event(link->ctx, link->user_data, -ECANCELED, 0);
+		io_cqring_fill_event(link->ctx, link->user_data, res, 0);
 		io_put_req_deferred(link);
 		link = nxt;
 	}
@@ -6519,8 +6530,10 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 	if (unlikely(req->ctx->drain_active) && io_drain_req(req))
 		return;
 
-	if (likely(!(req->flags & REQ_F_FORCE_ASYNC))) {
+	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
 		__io_queue_sqe(req);
+	} else if (req->flags & REQ_F_FAIL) {
+		io_req_complete_failed(req, req->result);
 	} else {
 		int ret = io_req_prep_async(req);
 
@@ -6629,19 +6642,34 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	ret = io_init_req(ctx, req, sqe);
 	if (unlikely(ret)) {
 fail_req:
+		/* fail even hard links since we don't submit */
 		if (link->head) {
-			/* fail even hard links since we don't submit */
-			io_req_complete_failed(link->head, -ECANCELED);
-			link->head = NULL;
+			/*
+			 * we can judge a link req is failed or cancelled by if
+			 * REQ_F_FAIL is set, but the head is an exception since
+			 * it may be set REQ_F_FAIL because of other req's failure
+			 * so let's leverage req->result to distinguish if a head
+			 * is set REQ_F_FAIL because of its failure or other req's
+			 * failure so that we can set the correct ret code for it.
+			 * init result here to avoid affecting the normal path.
+			 */
+			if (!(link->head->flags & REQ_F_FAIL))
+				req_fail_link_node(link->head, -ECANCELED);
+		} else if (!(req->flags & (REQ_F_LINK | REQ_F_HARDLINK))) {
+			/*
+			 * the current req is a normal req, we should return
+			 * error and thus break the submittion loop.
+			 */
+			io_req_complete_failed(req, ret);
+			return ret;
 		}
-		io_req_complete_failed(req, ret);
-		return ret;
+		req_fail_link_node(req, ret);
+	} else {
+		ret = io_req_prep(req, sqe);
+		if (unlikely(ret))
+			goto fail_req;
 	}
 
-	ret = io_req_prep(req, sqe);
-	if (unlikely(ret))
-		goto fail_req;
-
 	/* don't need @sqe from now on */
 	trace_io_uring_submit_sqe(ctx, req, req->opcode, req->user_data,
 				  req->flags, true,
@@ -6657,9 +6685,14 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (link->head) {
 		struct io_kiocb *head = link->head;
 
-		ret = io_req_prep_async(req);
-		if (unlikely(ret))
-			goto fail_req;
+		if (!(req->flags & REQ_F_FAIL)) {
+			ret = io_req_prep_async(req);
+			if (unlikely(ret)) {
+				req_fail_link_node(req, ret);
+				if (!(head->flags & REQ_F_FAIL))
+					req_fail_link_node(head, -ECANCELED);
+			}
+		}
 		trace_io_uring_link(ctx, req, head);
 		link->last->link = req;
 		link->last = req;
-- 
2.24.4

