Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 522E63D85FE
	for <lists+io-uring@lfdr.de>; Wed, 28 Jul 2021 05:03:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233519AbhG1DDc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Jul 2021 23:03:32 -0400
Received: from out30-42.freemail.mail.aliyun.com ([115.124.30.42]:53207 "EHLO
        out30-42.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233223AbhG1DDc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Jul 2021 23:03:32 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R371e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UhCdWWI_1627441402;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UhCdWWI_1627441402)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 28 Jul 2021 11:03:29 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH v3] io_uring: fix poll requests leaking second poll entries
Date:   Wed, 28 Jul 2021 11:03:22 +0800
Message-Id: <20210728030322.12307-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For pure poll requests, it doesn't remove the second poll wait entry
when it's done, neither after vfs_poll() or in the poll completion
handler. We should remove the second poll wait entry.
And we use io_poll_remove_double() rather than io_poll_remove_waitqs()
since the latter has some redundant logic.

Fixes: 88e41cf928a6 ("io_uring: add multishot mode for IORING_OP_POLL_ADD")
Cc: stable@vger.kernel.org # 5.13+
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

v1-->v2
  delete redundant io_poll_remove_double()

v2-->v3
  update commit message to make it clearer

 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 83f67d33bf67..bf548af0426c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4939,7 +4939,6 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
 	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
-		io_poll_remove_waitqs(req);
 		req->poll.done = true;
 		flags = 0;
 	}
@@ -4962,6 +4961,7 @@ static void io_poll_task_func(struct io_kiocb *req)
 
 		done = io_poll_complete(req, req->result);
 		if (done) {
+			io_poll_remove_double(req);
 			hash_del(&req->hash_node);
 		} else {
 			req->result = 0;
@@ -5149,7 +5149,7 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 		ipt->error = -EINVAL;
 
 	spin_lock_irq(&ctx->completion_lock);
-	if (ipt->error)
+	if (ipt->error || (mask && (poll->events & EPOLLONESHOT)))
 		io_poll_remove_double(req);
 	if (likely(poll->head)) {
 		spin_lock(&poll->head->lock);
@@ -5221,7 +5221,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
 	if (ret || ipt.error) {
-		io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
 		if (ret)
 			return IO_APOLL_READY;
-- 
2.24.4

