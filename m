Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B089F3D37A0
	for <lists+io-uring@lfdr.de>; Fri, 23 Jul 2021 11:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbhGWImM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jul 2021 04:42:12 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:42959 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230397AbhGWImM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jul 2021 04:42:12 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UghXYHc_1627032147;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UghXYHc_1627032147)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 23 Jul 2021 17:22:35 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH io_uring-5.14 v2] io_uring: remove double poll wait entry for pure poll
Date:   Fri, 23 Jul 2021 17:22:27 +0800
Message-Id: <20210723092227.137526-1-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

For pure poll requests, we should remove the double poll wait entry.
And io_poll_remove_double() is good enough for it compared with
io_poll_remove_waitqs().

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

v1-->v2
  delete redundant io_poll_remove_double()

 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f2fe4eca150b..c5fe8b9e26b4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4903,7 +4903,6 @@ static bool io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
 	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
-		io_poll_remove_waitqs(req);
 		req->poll.done = true;
 		flags = 0;
 	}
@@ -4926,6 +4925,7 @@ static void io_poll_task_func(struct io_kiocb *req)
 
 		done = io_poll_complete(req, req->result);
 		if (done) {
+			io_poll_remove_double(req);
 			hash_del(&req->hash_node);
 		} else {
 			req->result = 0;
@@ -5113,7 +5113,7 @@ static __poll_t __io_arm_poll_handler(struct io_kiocb *req,
 		ipt->error = -EINVAL;
 
 	spin_lock_irq(&ctx->completion_lock);
-	if (ipt->error)
+	if (ipt->error || (mask && (poll->events & EPOLLONESHOT)))
 		io_poll_remove_double(req);
 	if (likely(poll->head)) {
 		spin_lock(&poll->head->lock);
@@ -5185,7 +5185,6 @@ static int io_arm_poll_handler(struct io_kiocb *req)
 	ret = __io_arm_poll_handler(req, &apoll->poll, &ipt, mask,
 					io_async_wake);
 	if (ret || ipt.error) {
-		io_poll_remove_double(req);
 		spin_unlock_irq(&ctx->completion_lock);
 		if (ret)
 			return IO_APOLL_READY;
-- 
2.24.4

