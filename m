Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55E363D2BF8
	for <lists+io-uring@lfdr.de>; Thu, 22 Jul 2021 20:34:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbhGVRxv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 22 Jul 2021 13:53:51 -0400
Received: from out30-54.freemail.mail.aliyun.com ([115.124.30.54]:50720 "EHLO
        out30-54.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229493AbhGVRxv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 22 Jul 2021 13:53:51 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R461e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=alimailimapcm10staff010182156082;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0Uge-Ry8_1626978850;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0Uge-Ry8_1626978850)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 23 Jul 2021 02:34:24 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: remove double poll wait entry for pure poll
Date:   Fri, 23 Jul 2021 02:34:10 +0800
Message-Id: <20210722183410.72855-1-haoxu@linux.alibaba.com>
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
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fe3d948658ad..11eccba5c0be 100644
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
-- 
2.24.4

