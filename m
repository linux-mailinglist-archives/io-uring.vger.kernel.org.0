Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54C9845EB13
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 11:09:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238689AbhKZKNC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 05:13:02 -0500
Received: from out30-130.freemail.mail.aliyun.com ([115.124.30.130]:53922 "EHLO
        out30-130.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1376612AbhKZKLB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 05:11:01 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UyM4V-6_1637921260;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UyM4V-6_1637921260)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 26 Nov 2021 18:07:47 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 3/6] io_uring: add helper for task work execution code
Date:   Fri, 26 Nov 2021 18:07:37 +0800
Message-Id: <20211126100740.196550-4-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211126100740.196550-1-haoxu@linux.alibaba.com>
References: <20211126100740.196550-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper for task work execution code. We will use it later.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 821aa0f8c643..c00363d761f4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2197,6 +2197,25 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
 	percpu_ref_put(&ctx->refs);
 }
 
+static void handle_tw_list(struct io_wq_work_node *node, struct io_ring_ctx **ctx, bool *locked)
+{
+	do {
+		struct io_wq_work_node *next = node->next;
+		struct io_kiocb *req = container_of(node, struct io_kiocb,
+						    io_task_work.node);
+
+		if (req->ctx != *ctx) {
+			ctx_flush_and_put(*ctx, locked);
+			*ctx = req->ctx;
+			/* if not contended, grab and improve batching */
+			*locked = mutex_trylock(&(*ctx)->uring_lock);
+			percpu_ref_get(&(*ctx)->refs);
+		}
+		req->io_task_work.func(req, locked);
+		node = next;
+	} while (node);
+}
+
 static void tctx_task_work(struct callback_head *cb)
 {
 	bool locked = false;
@@ -2219,22 +2238,7 @@ static void tctx_task_work(struct callback_head *cb)
 		if (!node)
 			break;
 
-		do {
-			struct io_wq_work_node *next = node->next;
-			struct io_kiocb *req = container_of(node, struct io_kiocb,
-							    io_task_work.node);
-
-			if (req->ctx != ctx) {
-				ctx_flush_and_put(ctx, &locked);
-				ctx = req->ctx;
-				/* if not contended, grab and improve batching */
-				locked = mutex_trylock(&ctx->uring_lock);
-				percpu_ref_get(&ctx->refs);
-			}
-			req->io_task_work.func(req, &locked);
-			node = next;
-		} while (node);
-
+		handle_tw_list(node, &ctx, &locked);
 		cond_resched();
 	}
 
-- 
2.24.4

