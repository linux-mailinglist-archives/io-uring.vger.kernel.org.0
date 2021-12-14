Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE9DF473CCF
	for <lists+io-uring@lfdr.de>; Tue, 14 Dec 2021 06:57:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbhLNF5o (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Dec 2021 00:57:44 -0500
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:58155 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230114AbhLNF5n (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Dec 2021 00:57:43 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0V-b..w5_1639461454;
Received: from localhost.localdomain(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0V-b..w5_1639461454)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 14 Dec 2021 13:57:41 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/3] io_uring: add data structure for graph sqe feature
Date:   Tue, 14 Dec 2021 13:57:32 +0800
Message-Id: <20211214055734.61702-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211214055734.61702-1-haoxu@linux.alibaba.com>
References: <20211214055734.61702-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add basic data structure for graph sqe feature.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d86372664f9f..e96d38d268a8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -326,8 +326,25 @@ struct io_submit_state {
 	struct blk_plug		plug;
 };
 
+struct io_graph_child_node {
+	struct io_graph_node		*to;
+	struct io_graph_child_node	*next;
+};
+
+struct io_graph_node {
+	struct io_kiocb			*req;
+	struct io_graph_child_node	*children;
+	atomic_t			refs;
+};
+
+struct io_graph_info {
+	int				nr_nodes;
+	int				pos;
+	struct io_graph_node		**graph_array;
+};
+
 struct io_ring_ctx {
-	/* const or read-mostly hot data */
+	/* cons t or read-mostly hot data */
 	struct {
 		struct percpu_ref	refs;
 
@@ -459,6 +476,7 @@ struct io_ring_ctx {
 		u32				iowq_limits[2];
 		bool				iowq_limits_set;
 	};
+	struct io_graph_info			graph_info;
 };
 
 struct io_uring_task {
-- 
2.25.1

