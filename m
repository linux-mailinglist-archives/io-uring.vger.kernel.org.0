Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A86DB43CB77
	for <lists+io-uring@lfdr.de>; Wed, 27 Oct 2021 16:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242362AbhJ0OFh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Oct 2021 10:05:37 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:42746 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242334AbhJ0OFg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Oct 2021 10:05:36 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UtuRLZW_1635343336;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UtuRLZW_1635343336)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 27 Oct 2021 22:02:23 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 3/8] io_uring: add helper for task work execution code
Date:   Wed, 27 Oct 2021 22:02:11 +0800
Message-Id: <20211027140216.20008-4-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20211027140216.20008-1-haoxu@linux.alibaba.com>
References: <20211027140216.20008-1-haoxu@linux.alibaba.com>
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
index 9fdac3b9a560..98abf94b2015 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2139,6 +2139,25 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
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
@@ -2165,22 +2184,7 @@ static void tctx_task_work(struct callback_head *cb)
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

