Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74D424145E3
	for <lists+io-uring@lfdr.de>; Wed, 22 Sep 2021 12:13:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234762AbhIVKOc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Sep 2021 06:14:32 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:36632 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234795AbhIVKOQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Sep 2021 06:14:16 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04426;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UpDsdJl_1632305558;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UpDsdJl_1632305558)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 22 Sep 2021 18:12:46 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH 1/3] io_uring: fix race between poll completion and cancel_hash insertion
Date:   Wed, 22 Sep 2021 18:12:36 +0800
Message-Id: <20210922101238.7177-2-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 2.24.4
In-Reply-To: <20210922101238.7177-1-haoxu@linux.alibaba.com>
References: <20210922101238.7177-1-haoxu@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If poll arming and poll completion runs parallelly, there maybe races.
For instance, run io_poll_add in iowq and io_poll_task_func in original
context, then:
             iowq                          original context
  io_poll_add
    vfs_poll
     (interruption happens
      tw queued to original
      context)                              io_poll_task_func
                                              generate cqe
                                              del from cancel_hash[]
    if !poll.done
      insert to cancel_hash[]

The entry left in cancel_hash[], similar case for fast poll.
Fix it by set poll.done = true when del from cancel_hash[].

Fixes: 5082620fb2ca ("io_uring: terminate multishot poll for CQ ring overflow")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 91e4c89abf78..4b0a40ad28b0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5340,10 +5340,8 @@ static bool __io_poll_complete(struct io_kiocb *req, __poll_t mask)
 	}
 	if (req->poll.events & EPOLLONESHOT)
 		flags = 0;
-	if (!io_cqring_fill_event(ctx, req->user_data, error, flags)) {
-		req->poll.done = true;
+	if (!io_cqring_fill_event(ctx, req->user_data, error, flags))
 		flags = 0;
-	}
 	if (flags & IORING_CQE_F_MORE)
 		ctx->cq_extra++;
 
@@ -5374,6 +5372,7 @@ static void io_poll_task_func(struct io_kiocb *req, bool *locked)
 		if (done) {
 			io_poll_remove_double(req);
 			hash_del(&req->hash_node);
+			req->poll.done = true;
 		} else {
 			req->result = 0;
 			add_wait_queue(req->poll.head, &req->poll.wait);
@@ -5511,6 +5510,7 @@ static void io_async_task_func(struct io_kiocb *req, bool *locked)
 
 	hash_del(&req->hash_node);
 	io_poll_remove_double(req);
+	apoll->poll.done = true;
 	spin_unlock(&ctx->completion_lock);
 
 	if (!READ_ONCE(apoll->poll.canceled))
-- 
2.24.4

