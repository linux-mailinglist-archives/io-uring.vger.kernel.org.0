Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03A2322AFC1
	for <lists+io-uring@lfdr.de>; Thu, 23 Jul 2020 14:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbgGWM5v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 23 Jul 2020 08:57:51 -0400
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:49785 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726521AbgGWM5u (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 23 Jul 2020 08:57:50 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0U3aMJSq_1595509048;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U3aMJSq_1595509048)
          by smtp.aliyun-inc.com(127.0.0.1);
          Thu, 23 Jul 2020 20:57:28 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: clear IORING_SQ_NEED_WAKEUP after executing task works
Date:   Thu, 23 Jul 2020 20:57:24 +0800
Message-Id: <20200723125724.1938-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In io_sq_thread(), if there are task works to handle, current codes
will skip schedule() and go on polling sq again, but forget to clear
IORING_SQ_NEED_WAKEUP flag, fix this issue. Also add two helpers to
set and clear IORING_SQ_NEED_WAKEUP flag,

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index cda729de4ea3..a4a0a5feabfd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6334,6 +6334,21 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 	return submitted;
 }
 
+static inline void io_ring_set_wakeup_flag(struct io_ring_ctx *ctx)
+{
+	/* Tell userspace we may need a wakeup call */
+	spin_lock_irq(&ctx->completion_lock);
+	ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
+	spin_unlock_irq(&ctx->completion_lock);
+}
+
+static inline void io_ring_clear_wakeup_flag(struct io_ring_ctx *ctx)
+{
+	spin_lock_irq(&ctx->completion_lock);
+	ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
+	spin_unlock_irq(&ctx->completion_lock);
+}
+
 static int io_sq_thread(void *data)
 {
 	struct io_ring_ctx *ctx = data;
@@ -6407,10 +6422,7 @@ static int io_sq_thread(void *data)
 				continue;
 			}
 
-			/* Tell userspace we may need a wakeup call */
-			spin_lock_irq(&ctx->completion_lock);
-			ctx->rings->sq_flags |= IORING_SQ_NEED_WAKEUP;
-			spin_unlock_irq(&ctx->completion_lock);
+			io_ring_set_wakeup_flag(ctx);
 
 			to_submit = io_sqring_entries(ctx);
 			if (!to_submit || ret == -EBUSY) {
@@ -6420,6 +6432,7 @@ static int io_sq_thread(void *data)
 				}
 				if (io_run_task_work()) {
 					finish_wait(&ctx->sqo_wait, &wait);
+					io_ring_clear_wakeup_flag(ctx);
 					continue;
 				}
 				if (signal_pending(current))
@@ -6427,17 +6440,13 @@ static int io_sq_thread(void *data)
 				schedule();
 				finish_wait(&ctx->sqo_wait, &wait);
 
-				spin_lock_irq(&ctx->completion_lock);
-				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
-				spin_unlock_irq(&ctx->completion_lock);
+				io_ring_clear_wakeup_flag(ctx);
 				ret = 0;
 				continue;
 			}
 			finish_wait(&ctx->sqo_wait, &wait);
 
-			spin_lock_irq(&ctx->completion_lock);
-			ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
-			spin_unlock_irq(&ctx->completion_lock);
+			io_ring_clear_wakeup_flag(ctx);
 		}
 
 		mutex_lock(&ctx->uring_lock);
-- 
2.17.2

