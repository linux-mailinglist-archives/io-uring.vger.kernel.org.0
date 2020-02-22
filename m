Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A419168CF8
	for <lists+io-uring@lfdr.de>; Sat, 22 Feb 2020 07:46:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726917AbgBVGqS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 22 Feb 2020 01:46:18 -0500
Received: from out30-131.freemail.mail.aliyun.com ([115.124.30.131]:58507 "EHLO
        out30-131.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726832AbgBVGqS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 22 Feb 2020 01:46:18 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R901e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TqaAKPa_1582353966;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TqaAKPa_1582353966)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 22 Feb 2020 14:46:12 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: fix __io_iopoll_check deadlock in io_sq_thread
Date:   Sat, 22 Feb 2020 14:46:05 +0800
Message-Id: <20200222064605.2571-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Since commit a3a0e43fd770 ("io_uring: don't enter poll loop if we have
CQEs pending"), if we already events pending, we won't enter poll loop.
In case SETUP_IOPOLL and SETUP_SQPOLL are both enabled, if app has
been terminated and don't reap pengding events which are already in cq
ring, and there are some reqs in poll_list, io_sq_thread will enter
__io_iopoll_check(), and find pending events, then return, this loop
will never have a chance to exit.

I have seem this issue in fio stress tests, to fix this issue, let
io_sq_thread call io_iopoll_getevents() with argument 'min' being zero,
and remove __io_iopoll_check().

Fixes: a3a0e43fd770 ("io_uring: don't enter poll loop if we have CQEs pending")
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 77f22c3da30f..c69870b0c0ca 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1635,11 +1635,17 @@ static void io_iopoll_reap_events(struct io_ring_ctx *ctx)
 	mutex_unlock(&ctx->uring_lock);
 }
 
-static int __io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
-			    long min)
+static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
+			   long min)
 {
 	int iters = 0, ret = 0;
 
+	/*
+	 * We disallow the app entering submit/complete with polling, but we
+	 * still need to lock the ring to prevent racing with polled issue
+	 * that got punted to a workqueue.
+	 */
+	mutex_lock(&ctx->uring_lock);
 	do {
 		int tmin = 0;
 
@@ -1675,21 +1681,6 @@ static int __io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
 		ret = 0;
 	} while (min && !*nr_events && !need_resched());
 
-	return ret;
-}
-
-static int io_iopoll_check(struct io_ring_ctx *ctx, unsigned *nr_events,
-			   long min)
-{
-	int ret;
-
-	/*
-	 * We disallow the app entering submit/complete with polling, but we
-	 * still need to lock the ring to prevent racing with polled issue
-	 * that got punted to a workqueue.
-	 */
-	mutex_lock(&ctx->uring_lock);
-	ret = __io_iopoll_check(ctx, nr_events, min);
 	mutex_unlock(&ctx->uring_lock);
 	return ret;
 }
@@ -5039,7 +5030,7 @@ static int io_sq_thread(void *data)
 				 */
 				mutex_lock(&ctx->uring_lock);
 				if (!list_empty(&ctx->poll_list))
-					__io_iopoll_check(ctx, &nr_events, 0);
+					io_iopoll_getevents(ctx, &nr_events, 0);
 				else
 					inflight = 0;
 				mutex_unlock(&ctx->uring_lock);
-- 
2.17.2

