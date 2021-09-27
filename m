Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91DF141945E
	for <lists+io-uring@lfdr.de>; Mon, 27 Sep 2021 14:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234261AbhI0Mhs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 27 Sep 2021 08:37:48 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:57091 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234285AbhI0Mhr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 27 Sep 2021 08:37:47 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpooWsS_1632746160;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpooWsS_1632746160)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 27 Sep 2021 20:36:08 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 2/2] io_uring: fix tw list mess-up by adding tw while it's already in tw list
Date:   Mon, 27 Sep 2021 20:36:00 +0800
Message-Id: <20210927123600.234405-3-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210927123600.234405-1-haoxu@linux.alibaba.com>
References: <20210927123600.234405-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For multishot mode, there may be cases like:
io_poll_task_func()
-> add_wait_queue()
                            async_wake()
                            ->io_req_task_work_add()
                            this one mess up the running task_work list
                            since req->io_task_work.node is in use.

similar situation for req->io_task_work.fallback_node.
Fix it by set node->next = NULL before we run the tw, so that when we
add req back to the wait queue in middle of tw running, we can safely
re-add it to the tw list.

Fixes: 7cbf1722d5fc ("io_uring: provide FIFO ordering for task_work")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d0b358b9b589..f667d6286438 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1250,13 +1250,17 @@ static void io_fallback_req_func(struct work_struct *work)
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx,
 						fallback_work.work);
 	struct llist_node *node = llist_del_all(&ctx->fallback_llist);
-	struct io_kiocb *req, *tmp;
+	struct io_kiocb *req;
 	bool locked = false;
 
 	percpu_ref_get(&ctx->refs);
-	llist_for_each_entry_safe(req, tmp, node, io_task_work.fallback_node)
+	req = llist_entry(node, struct io_kiocb, io_task_work.fallback_node);
+	while (member_address_is_nonnull(req, io_task_work.fallback_node)) {
+		node = req->io_task_work.fallback_node.next;
+		req->io_task_work.fallback_node.next = NULL;
 		req->io_task_work.func(req, &locked);
-
+		req = llist_entry(node, struct io_kiocb, io_task_work.fallback_node);
+	}
 	if (locked) {
 		io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
@@ -2156,6 +2160,7 @@ static void tctx_task_work(struct callback_head *cb)
 				locked = mutex_trylock(&ctx->uring_lock);
 				percpu_ref_get(&ctx->refs);
 			}
+			node->next = NULL;
 			req->io_task_work.func(req, &locked);
 			node = next;
 		} while (node);
-- 
2.24.4

