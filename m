Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AA6B1D12E5
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 14:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731649AbgEMMiz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 08:38:55 -0400
Received: from out30-57.freemail.mail.aliyun.com ([115.124.30.57]:39341 "EHLO
        out30-57.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728887AbgEMMiz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 08:38:55 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R831e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04407;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0TyRVuGz_1589373521;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0TyRVuGz_1589373521)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 13 May 2020 20:38:49 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [RFC PATCH] io_uring: don't submit sqes when ctx->refs is dying
Date:   Wed, 13 May 2020 20:37:54 +0800
Message-Id: <20200513123754.25189-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When IORING_SETUP_SQPOLL is enabled, io_ring_ctx_wait_and_kill() will wait
for sq thread to idle by busy loop:
    while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
        cond_resched();
Above codes are not friendly, indeed I think this busy loop will introduce a
cpu burst in current cpu, though it maybe short.

In this patch, if ctx->refs is dying, we forbids sq_thread from submitting
sqes anymore, just discard leftover sqes.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ec0aa6957882..6e51140a5722 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5980,7 +5980,8 @@ static int io_sq_thread(void *data)
 		 * If submit got -EBUSY, flag us as needing the application
 		 * to enter the kernel to reap and flush events.
 		 */
-		if (!to_submit || ret == -EBUSY) {
+		if (!to_submit || ret == -EBUSY ||
+		    percpu_ref_is_dying(&ctx->refs)) {
 			/*
 			 * Drop cur_mm before scheduling, we can't hold it for
 			 * long periods (or over schedule()). Do this before
@@ -6027,7 +6028,8 @@ static int io_sq_thread(void *data)
 			smp_mb();
 
 			to_submit = io_sqring_entries(ctx);
-			if (!to_submit || ret == -EBUSY) {
+			if (!to_submit || ret == -EBUSY ||
+			    percpu_ref_is_dying(&ctx->refs)) {
 				if (kthread_should_park()) {
 					finish_wait(&ctx->sqo_wait, &wait);
 					break;
@@ -6051,7 +6053,8 @@ static int io_sq_thread(void *data)
 		}
 
 		mutex_lock(&ctx->uring_lock);
-		ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
+		if (likely(!percpu_ref_is_dying(&ctx->refs)))
+			ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
 		mutex_unlock(&ctx->uring_lock);
 		timeout = jiffies + ctx->sq_thread_idle;
 	}
@@ -7323,16 +7326,6 @@ static void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 	percpu_ref_kill(&ctx->refs);
 	mutex_unlock(&ctx->uring_lock);
 
-	/*
-	 * Wait for sq thread to idle, if we have one. It won't spin on new
-	 * work after we've killed the ctx ref above. This is important to do
-	 * before we cancel existing commands, as the thread could otherwise
-	 * be queueing new work post that. If that's work we need to cancel,
-	 * it could cause shutdown to hang.
-	 */
-	while (ctx->sqo_thread && !wq_has_sleeper(&ctx->sqo_wait))
-		cond_resched();
-
 	io_kill_timeouts(ctx);
 	io_poll_remove_all(ctx);
 
-- 
2.17.2

