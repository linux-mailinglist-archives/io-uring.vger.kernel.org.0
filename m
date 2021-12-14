Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9147F473CD1
	for <lists+io-uring@lfdr.de>; Tue, 14 Dec 2021 06:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbhLNF5p (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Dec 2021 00:57:45 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:35777 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhLNF5o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Dec 2021 00:57:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V-b..w5_1639461454;
Received: from localhost.localdomain(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V-b..w5_1639461454)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 Dec 2021 13:57:42 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 3/3] io_uring: implement logic of IOSQE_GRAPH request
Date:   Tue, 14 Dec 2021 13:57:34 +0800
Message-Id: <20211214055734.61702-4-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211214055734.61702-1-haoxu@linux.alibaba.com>
References: <20211214055734.61702-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After we build a graph, we need to fill the sqe nodes to it. Introduce
a new flag for graph node sqes. The whole graph will be issued when all
the sqes it needs are ready.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c                 | 71 +++++++++++++++++++++++++++++++++--
 include/uapi/linux/io_uring.h |  3 ++
 2 files changed, 71 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 53309eaef69d..fbe1ab029c4b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -109,7 +109,8 @@
 			  IOSQE_IO_HARDLINK | IOSQE_ASYNC)
 
 #define SQE_VALID_FLAGS	(SQE_COMMON_FLAGS | IOSQE_BUFFER_SELECT | \
-			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS)
+			IOSQE_IO_DRAIN | IOSQE_CQE_SKIP_SUCCESS | \
+			IOSQE_GRAPH)
 
 #define IO_REQ_CLEAN_FLAGS (REQ_F_BUFFER_SELECTED | REQ_F_NEED_CLEANUP | \
 				REQ_F_POLLED | REQ_F_INFLIGHT | REQ_F_CREDS | \
@@ -750,6 +751,7 @@ enum {
 	REQ_F_FORCE_ASYNC_BIT	= IOSQE_ASYNC_BIT,
 	REQ_F_BUFFER_SELECT_BIT	= IOSQE_BUFFER_SELECT_BIT,
 	REQ_F_CQE_SKIP_BIT	= IOSQE_CQE_SKIP_SUCCESS_BIT,
+	REQ_F_GRAPH_BIT		= IOSQE_GRAPH_BIT,
 
 	/* first byte is taken by user flags, shift it to not overlap */
 	REQ_F_FAIL_BIT		= 8,
@@ -790,6 +792,8 @@ enum {
 	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
 	/* IOSQE_CQE_SKIP_SUCCESS */
 	REQ_F_CQE_SKIP		= BIT(REQ_F_CQE_SKIP_BIT),
+	/* IOSQE_GRAPH */
+	REQ_F_GRAPH		= BIT(REQ_F_GRAPH_BIT),
 	/* fail rest of links */
 	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
 	/* on inflight list, should be cancelled and waited on exit reliably */
@@ -916,6 +920,8 @@ struct io_kiocb {
 	const struct cred		*creds;
 	/* stores selected buf, valid IFF REQ_F_BUFFER_SELECTED is set */
 	struct io_buffer		*kbuf;
+	/* reverse link to the io_graph_node which points to it */
+	struct io_graph_node            *graph_node;
 };
 
 struct io_tctx_node {
@@ -1916,6 +1922,8 @@ static noinline bool io_fill_cqe_aux(struct io_ring_ctx *ctx, u64 user_data,
 	return __io_fill_cqe(ctx, user_data, res, cflags);
 }
 
+static inline void io_graph_queue_children(struct io_kiocb *req);
+
 static void io_req_complete_post(struct io_kiocb *req, s32 res,
 				 u32 cflags)
 {
@@ -1937,6 +1945,7 @@ static void io_req_complete_post(struct io_kiocb *req, s32 res,
 				req->link = NULL;
 			}
 		}
+		io_graph_queue_children(req);
 		io_req_put_rsrc(req, ctx);
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
@@ -2100,6 +2109,10 @@ static __cold void __io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 
+	/*
+	 * not a proper place to put this, but..
+	 */
+	io_graph_queue_children(req);
 	io_req_put_rsrc(req, ctx);
 	io_dismantle_req(req);
 	io_put_task(req->task, 1);
@@ -2414,6 +2427,7 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 
 		io_req_put_rsrc_locked(req, ctx);
 		io_queue_next(req);
+		io_graph_queue_children(req);
 		io_dismantle_req(req);
 
 		if (req->task != task) {
@@ -5341,6 +5355,7 @@ static int io_add_edge(struct io_graph_node *from, struct io_graph_node *to)
 
 	return 0;
 }
+
 static void io_remove_edges(struct io_graph_node *node)
 {
 	struct io_graph_child_node *next, *edge_node = node->children;
@@ -5352,6 +5367,31 @@ static void io_remove_edges(struct io_graph_node *node)
 	}
 }
 
+static void free_graph_node(struct io_graph_node *gn)
+{
+	io_remove_edges(gn);
+	kfree(gn);
+}
+
+static inline void io_graph_queue_children(struct io_kiocb *req)
+{
+	struct io_graph_node *gn;
+	struct io_graph_child_node *node;
+
+	if (!(req->flags & REQ_F_GRAPH))
+		return;
+
+	gn = req->graph_node;
+	node = gn->children;
+	while (node) {
+		gn = node->to;
+		if (atomic_dec_and_test(&gn->refs))
+			io_req_task_queue(gn->req);
+		node = node->next;
+	}
+	free_graph_node(req->graph_node);
+}
+
 static int __io_buildgraph(struct io_graph_node **graph_array, struct io_graph_edge *io_edges,
 			   int nr_edges, int nr_nodes)
 {
@@ -7185,20 +7225,36 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 		io_req_complete_fail_submit(req);
 	} else if (unlikely(req->ctx->drain_active)) {
 		io_drain_req(req);
-	} else {
+	} else if (req->flags & REQ_F_FORCE_ASYNC) {
 		int ret = io_req_prep_async(req);
 
 		if (unlikely(ret))
 			io_req_complete_failed(req, ret);
 		else
 			io_queue_async_work(req, NULL);
+	} else {
+		struct io_ring_ctx *ctx = req->ctx;
+		struct io_graph_node **ga = ctx->graph_info.graph_array;
+		struct io_graph_child_node *node;
+
+		if (ctx->graph_info.pos != ctx->graph_info.nr_nodes)
+			return;
+
+		node = ga[0]->children;
+		while (node) {
+			__io_queue_sqe(node->to->req);
+			node = node->next;
+		}
+		free_graph_node(ga[0]);
+		kfree(ctx->graph_info.graph_array);
+		memset(&ctx->graph_info, 0, sizeof(ctx->graph_info));
 	}
 }
 
 static inline void io_queue_sqe(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
-	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL))))
+	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL | REQ_F_GRAPH))))
 		__io_queue_sqe(req);
 	else
 		io_queue_sqe_fallback(req);
@@ -7281,6 +7337,15 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 				return -EOPNOTSUPP;
 			io_init_req_drain(req);
 		}
+		if (sqe_flags & IOSQE_GRAPH) {
+			struct io_graph_node **ga = ctx->graph_info.graph_array;
+
+			if (!ga)
+				return -EINVAL;
+
+			ga[++(ctx->graph_info.pos)]->req = req;
+			req->graph_node = ga[ctx->graph_info.pos];
+		}
 	}
 	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
 		if (ctx->restricted && !io_check_restriction(ctx, req, sqe_flags))
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 7ffbd9c4afd9..a29503060640 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -71,6 +71,7 @@ enum {
 	IOSQE_ASYNC_BIT,
 	IOSQE_BUFFER_SELECT_BIT,
 	IOSQE_CQE_SKIP_SUCCESS_BIT,
+	IOSQE_GRAPH_BIT,
 };
 
 /*
@@ -90,6 +91,8 @@ enum {
 #define IOSQE_BUFFER_SELECT	(1U << IOSQE_BUFFER_SELECT_BIT)
 /* don't post CQE if request succeeded */
 #define IOSQE_CQE_SKIP_SUCCESS	(1U << IOSQE_CQE_SKIP_SUCCESS_BIT)
+/* sqes that in a graph dependency relationship */
+#define IOSQE_GRAPH		(1U << IOSQE_GRAPH_BIT)
 
 /*
  * io_uring_setup() flags
-- 
2.25.1

