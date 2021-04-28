Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E13836D856
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 15:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231166AbhD1NdW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 09:33:22 -0400
Received: from out30-45.freemail.mail.aliyun.com ([115.124.30.45]:47453 "EHLO
        out30-45.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231297AbhD1NdW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 09:33:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UX4Z1lB_1619616749;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UX4Z1lB_1619616749)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 28 Apr 2021 21:32:36 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH RFC 5.13 2/2] io_uring: submit sqes in the original context when waking up sqthread
Date:   Wed, 28 Apr 2021 21:32:28 +0800
Message-Id: <1619616748-17149-3-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

sqes are submitted by sqthread when it is leveraged, which means there
is IO latency when waking up sqthread. To wipe it out, submit limited
number of sqes in the original task context.
Tests result below:

99th latency:
iops\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
with this patch:
2k      	13	13	12	13	13	12	12	11	11	10.304	11.84
without this patch:
2k      	15	14	15	15	15	14	15	14	14	13	11.84

fio config:
./run_fio.sh
fio \
--ioengine=io_uring --sqthread_poll=1 --hipri=1 --thread=1 --bs=4k \
--direct=1 --rw=randread --time_based=1 --runtime=300 \
--group_reporting=1 --filename=/dev/nvme1n1 --sqthread_poll_cpu=30 \
--randrepeat=0 --cpus_allowed=35 --iodepth=128 --rate_iops=${1} \
--io_sq_thread_idle=${2}

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c                 | 29 +++++++++++++++++++++++------
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1871fad48412..f0a01232671e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1252,7 +1252,12 @@ static void io_queue_async_work(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *link = io_prep_linked_timeout(req);
-	struct io_uring_task *tctx = req->task->io_uring;
+	struct io_uring_task *tctx = NULL;
+
+	if (ctx->sq_data && ctx->sq_data->thread)
+		tctx = ctx->sq_data->thread->io_uring;
+	else
+		tctx = req->task->io_uring;
 
 	BUG_ON(!tctx);
 	BUG_ON(!tctx->io_wq);
@@ -9063,9 +9068,10 @@ static void io_uring_try_cancel(struct files_struct *files)
 	xa_for_each(&tctx->xa, index, node) {
 		struct io_ring_ctx *ctx = node->ctx;
 
-		/* sqpoll task will cancel all its requests */
-		if (!ctx->sq_data)
-			io_uring_try_cancel_requests(ctx, current, files);
+		/*
+		 * for sqpoll ctx, there may be requests in task_works etc.
+		 */
+		io_uring_try_cancel_requests(ctx, current, files);
 	}
 }
 
@@ -9271,7 +9277,8 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
 	io_run_task_work();
 
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
-			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG)))
+			       IORING_ENTER_SQ_WAIT | IORING_ENTER_EXT_ARG |
+			       IORING_ENTER_SQ_DEPUTY)))
 		return -EINVAL;
 
 	f = fdget(fd);
@@ -9304,8 +9311,18 @@ static int io_get_ext_arg(unsigned flags, const void __user *argp, size_t *argsz
 		if (unlikely(ctx->sq_data->thread == NULL)) {
 			goto out;
 		}
-		if (flags & IORING_ENTER_SQ_WAKEUP)
+		if (flags & IORING_ENTER_SQ_WAKEUP) {
 			wake_up(&ctx->sq_data->wait);
+			if ((flags & IORING_ENTER_SQ_DEPUTY) &&
+					!(ctx->flags & IORING_SETUP_IOPOLL)) {
+				ret = io_uring_add_task_file(ctx);
+				if (unlikely(ret))
+					goto out;
+				mutex_lock(&ctx->uring_lock);
+				io_submit_sqes(ctx, min(to_submit, 8U));
+				mutex_unlock(&ctx->uring_lock);
+			}
+		}
 		if (flags & IORING_ENTER_SQ_WAIT) {
 			ret = io_sqpoll_wait_sq(ctx);
 			if (ret)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 311532ff6ce3..b1130fec2b7d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -251,6 +251,7 @@ struct io_cqring_offsets {
 #define IORING_ENTER_SQ_WAKEUP	(1U << 1)
 #define IORING_ENTER_SQ_WAIT	(1U << 2)
 #define IORING_ENTER_EXT_ARG	(1U << 3)
+#define IORING_ENTER_SQ_DEPUTY	(1U << 4)
 
 /*
  * Passed in for io_uring_setup(2). Copied back with updated info on success
-- 
1.8.3.1

