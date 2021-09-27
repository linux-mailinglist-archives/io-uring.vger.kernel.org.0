Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A4E418EF5
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 08:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbhI0GTI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 02:19:08 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:42641 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232938AbhI0GTH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 02:19:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e01424;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpiKFOp_1632723441;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpiKFOp_1632723441)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 14:17:28 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 4/8] io_uring: add helper for task work execution code
Date:   Mon, 27 Sep 2021 14:17:17 +0800
Message-Id: <20210927061721.180806-5-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210927061721.180806-1-haoxu@linux.alibaba.com>
References: <20210927061721.180806-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a helper for task work execution code. We will use it later.

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9272b2cfcfb7..58ce58e7c65d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2126,6 +2126,25 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
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
@@ -2152,22 +2171,7 @@ static void tctx_task_work(struct callback_head *cb)
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

