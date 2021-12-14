Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4747E473CD0
	for <lists+io-uring@lfdr.de>; Tue, 14 Dec 2021 06:57:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhLNF5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Dec 2021 00:57:44 -0500
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:52779 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230098AbhLNF5o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Dec 2021 00:57:44 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R781e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V-b..w5_1639461454;
Received: from localhost.localdomain(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V-b..w5_1639461454)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 Dec 2021 13:57:42 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/3] io_uring: implement new sqe opcode to build graph like links
Date:   Tue, 14 Dec 2021 13:57:33 +0800
Message-Id: <20211214055734.61702-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211214055734.61702-1-haoxu@linux.alibaba.com>
References: <20211214055734.61702-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a new opcode IORING_OP_BUILD_GRAPH to build graph dependency between
sqes. The format is：
sqe->fd: number of nodes in graph
sqe->len: number of edges in graph
sqe->addr: array of edges, each element is in <a, b> format which
           represents an edge from a to b. graph sqes are indexed from 1
           to sqe->fd.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c                 | 140 +++++++++++++++++++++++++++++++++-
 include/uapi/linux/io_uring.h |   6 ++
 2 files changed, 145 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e96d38d268a8..53309eaef69d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -709,6 +709,13 @@ struct io_hardlink {
 	int				flags;
 };
 
+struct io_graph {
+	struct file			*file;
+	int				nr_nodes;
+	int				nr_edges;
+	u64				edges;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -783,7 +790,6 @@ enum {
 	REQ_F_BUFFER_SELECT	= BIT(REQ_F_BUFFER_SELECT_BIT),
 	/* IOSQE_CQE_SKIP_SUCCESS */
 	REQ_F_CQE_SKIP		= BIT(REQ_F_CQE_SKIP_BIT),
-
 	/* fail rest of links */
 	REQ_F_FAIL		= BIT(REQ_F_FAIL_BIT),
 	/* on inflight list, should be cancelled and waited on exit reliably */
@@ -874,6 +880,7 @@ struct io_kiocb {
 		struct io_mkdir		mkdir;
 		struct io_symlink	symlink;
 		struct io_hardlink	hardlink;
+		struct io_graph		graph;
 	};
 
 	u8				opcode;
@@ -1123,6 +1130,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_MKDIRAT] = {},
 	[IORING_OP_SYMLINKAT] = {},
 	[IORING_OP_LINKAT] = {},
+	[IORING_OP_BUILD_GRAPH] = {},
 };
 
 /* requests with any of those set should undergo io_disarm_next() */
@@ -5300,6 +5308,131 @@ IO_NETOP_FN(send);
 IO_NETOP_FN(recv);
 #endif /* CONFIG_NET */
 
+#define MAX_GRAPH_NODES 1000
+
+static int io_buildgraph_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	int *nr_nodes = &req->graph.nr_nodes;
+
+	if (req->ctx->graph_info.graph_array)
+		return -EBUSY;
+
+	*nr_nodes = READ_ONCE(sqe->fd);
+	if (*nr_nodes <= 0 || *nr_nodes > MAX_GRAPH_NODES)
+		return -EINVAL;
+
+	req->graph.nr_edges = READ_ONCE(sqe->len);
+	req->graph.edges = READ_ONCE(sqe->addr);
+	return 0;
+}
+
+static int io_add_edge(struct io_graph_node *from, struct io_graph_node *to)
+{
+	struct io_graph_child_node *head = from->children;
+	struct io_graph_child_node *new_edge =
+		kzalloc(sizeof(struct io_graph_child_node), GFP_KERNEL);
+
+	if (!new_edge)
+		return -ENOMEM;
+
+	new_edge->to = to;
+	new_edge->next = head;
+	from->children = new_edge;
+
+	return 0;
+}
+static void io_remove_edges(struct io_graph_node *node)
+{
+	struct io_graph_child_node *next, *edge_node = node->children;
+
+	while (edge_node) {
+		next = edge_node->next;
+		kfree(edge_node);
+		edge_node = next;
+	}
+}
+
+static int __io_buildgraph(struct io_graph_node **graph_array, struct io_graph_edge *io_edges,
+			   int nr_edges, int nr_nodes)
+{
+	int i, ret;
+
+	for (i = 0; i < nr_edges; i++) {
+		int from = io_edges[i].from, to = io_edges[i].to;
+
+		ret = io_add_edge(graph_array[from], graph_array[to]);
+		if (ret)
+			goto fail;
+		atomic_inc(&graph_array[to]->refs);
+	}
+	for (i = 1; i <= nr_nodes; i++) {
+		if (atomic_read(&graph_array[i]->refs))
+			continue;
+
+		ret = io_add_edge(graph_array[0], graph_array[i]);
+		if (ret)
+			goto fail;
+		atomic_set(&graph_array[i]->refs, 1);
+	}
+
+	return 0;
+
+fail:
+	for (i = 0; i <= nr_nodes; i++)
+		io_remove_edges(graph_array[i]);
+	return ret;
+}
+
+static int io_check_graph(struct io_graph_edge *io_edges, int nr_edges, int nr_nodes)
+{
+	return 0;
+}
+
+static int io_buildgraph(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_graph_info *gi = &req->ctx->graph_info;
+	struct io_graph_edge __user *edges, *io_edges = NULL;
+	int i, n = req->graph.nr_nodes, m = req->graph.nr_edges;
+	int ret = -ENOMEM;
+
+	edges = u64_to_user_ptr(req->graph.edges);
+	io_edges = kvmalloc_array(m, sizeof(struct io_graph_edge), GFP_KERNEL);
+	if (!io_edges)
+		goto fail;
+
+	ret = -EFAULT;
+	if (copy_from_user(io_edges, edges, sizeof(struct io_graph_edge) * m))
+		goto fail;
+	ret = io_check_graph(io_edges, m, n);
+	if (ret)
+		goto fail;
+
+	gi->nr_nodes = n;
+	gi->pos = 0;
+	ret = -ENOMEM;
+	gi->graph_array = kmalloc(sizeof(struct io_graph_node *) * (n + 1),  GFP_KERNEL);
+	if (!gi->graph_array)
+		goto fail;
+	for (i = 0; i <= n; i++) {
+		gi->graph_array[i] = kzalloc(sizeof(struct io_graph_node), GFP_KERNEL);
+		if (!gi->graph_array[i])
+			goto fail;
+		atomic_set(&gi->graph_array[i]->refs, 0);
+	}
+	ret = __io_buildgraph(gi->graph_array, io_edges, m, n);
+
+	if (ret) {
+fail:
+		kvfree(io_edges);
+		for (i = 0; i <= n; i++)
+			kfree(gi->graph_array[i]);
+		kfree(gi->graph_array);
+	}
+
+	__io_req_complete(req, issue_flags, ret, 0);
+	return 0;
+}
+
 struct io_poll_table {
 	struct poll_table_struct pt;
 	struct io_kiocb *req;
@@ -6493,6 +6626,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_symlinkat_prep(req, sqe);
 	case IORING_OP_LINKAT:
 		return io_linkat_prep(req, sqe);
+	case IORING_OP_BUILD_GRAPH:
+		return io_buildgraph_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6776,6 +6911,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_LINKAT:
 		ret = io_linkat(req, issue_flags);
 		break;
+	case IORING_OP_BUILD_GRAPH:
+		ret = io_buildgraph(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 787f491f0d2a..7ffbd9c4afd9 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -143,6 +143,7 @@ enum {
 	IORING_OP_MKDIRAT,
 	IORING_OP_SYMLINKAT,
 	IORING_OP_LINKAT,
+	IORING_OP_BUILD_GRAPH,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
@@ -422,4 +423,9 @@ struct io_uring_getevents_arg {
 	__u64	ts;
 };
 
+struct io_graph_edge {
+	int from;
+	int to;
+};
+
 #endif
-- 
2.25.1

