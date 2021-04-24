Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B224436A085
	for <lists+io-uring@lfdr.de>; Sat, 24 Apr 2021 11:26:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbhDXJ1I (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 24 Apr 2021 05:27:08 -0400
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:47938 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231490AbhDXJ1I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 24 Apr 2021 05:27:08 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R161e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UWaDAcA_1619256380;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UWaDAcA_1619256380)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 24 Apr 2021 17:26:26 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: update sq_thread_idle after ctx deleted
Date:   Sat, 24 Apr 2021 17:26:20 +0800
Message-Id: <1619256380-236460-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

we shall update sq_thread_idle anytime we do ctx deletion from ctx_list

Fixes:734551df6f9b ("io_uring: fix shared sqpoll cancellation hangs")
Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 40f38256499c..15f204274761 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8867,6 +8867,7 @@ static void io_sqpoll_cancel_cb(struct callback_head *cb)
 	if (sqd->thread)
 		io_uring_cancel_sqpoll(sqd);
 	list_del_init(&work->ctx->sqd_list);
+	io_sqd_update_thread_idle(sqd);
 	complete(&work->completion);
 }
 
@@ -8877,7 +8878,6 @@ static void io_sqpoll_cancel_sync(struct io_ring_ctx *ctx)
 	struct task_struct *task;
 
 	io_sq_thread_park(sqd);
-	io_sqd_update_thread_idle(sqd);
 	task = sqd->thread;
 	if (task) {
 		init_completion(&work.completion);
@@ -8886,6 +8886,7 @@ static void io_sqpoll_cancel_sync(struct io_ring_ctx *ctx)
 		wake_up_process(task);
 	} else {
 		list_del_init(&ctx->sqd_list);
+		io_sqd_update_thread_idle(sqd);
 	}
 	io_sq_thread_unpark(sqd);
 
-- 
1.8.3.1

