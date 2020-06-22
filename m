Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42502202F95
	for <lists+io-uring@lfdr.de>; Mon, 22 Jun 2020 07:50:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731092AbgFVFuU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Jun 2020 01:50:20 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:43793 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729114AbgFVFuU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Jun 2020 01:50:20 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R381e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04357;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0U0IEvy2_1592805015;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0U0IEvy2_1592805015)
          by smtp.aliyun-inc.com(127.0.0.1);
          Mon, 22 Jun 2020 13:50:15 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     io-uring <io-uring@vger.kernel.org>
Cc:     "axboe@kernel.dk" <axboe@kernel.dk>, Dust.li@linux.alibaba.com
Subject: [PATCH] io_uring: fix io_sq_thread no schedule when busy
Date:   Mon, 22 Jun 2020 13:50:15 +0800
Message-Id: <a932f437e5337cbfb42db660473fa55fa7aff9f6.1592805001.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When the user consumes and generates sqe at a fast rate,
io_sqring_entries can always get sqe, and ret will not be equal to -EBUSY,
so that io_sq_thread will never call cond_resched or schedule, and then
we will get the following system error prompt:

rcu: INFO: rcu_sched self-detected stall on CPU
or
watchdog: BUG: soft lockup-CPU#23 stuck for 112s! [io_uring-sq:1863]

This patch adds a check after io_submit_sqes. If io_sq_thread does not call
cond_resched or schedule for more than HZ/2, it will call them.

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
---
 fs/io_uring.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a78201b..de92363 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5983,7 +5983,7 @@ static int io_sq_thread(void *data)
 	struct io_ring_ctx *ctx = data;
 	const struct cred *old_cred;
 	DEFINE_WAIT(wait);
-	unsigned long timeout;
+	unsigned long timeout, timeout_busy;
 	int ret = 0;
 
 	complete(&ctx->sq_thread_comp);
@@ -5991,6 +5991,7 @@ static int io_sq_thread(void *data)
 	old_cred = override_creds(ctx->creds);
 
 	timeout = jiffies + ctx->sq_thread_idle;
+	timeout_busy = jiffies + HZ/2;
 	while (!kthread_should_park()) {
 		unsigned int to_submit;
 
@@ -6012,6 +6013,7 @@ static int io_sq_thread(void *data)
 		 * to enter the kernel to reap and flush events.
 		 */
 		if (!to_submit || ret == -EBUSY) {
+sched:
 			/*
 			 * Drop cur_mm before scheduling, we can't hold it for
 			 * long periods (or over schedule()). Do this before
@@ -6033,6 +6035,7 @@ static int io_sq_thread(void *data)
 				if (current->task_works)
 					task_work_run();
 				cond_resched();
+				timeout_busy = jiffies + HZ/2;
 				continue;
 			}
 
@@ -6073,6 +6076,8 @@ static int io_sq_thread(void *data)
 				schedule();
 				finish_wait(&ctx->sqo_wait, &wait);
 
+				timeout_busy = jiffies + HZ/2;
+
 				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
 				ret = 0;
 				continue;
@@ -6087,6 +6092,9 @@ static int io_sq_thread(void *data)
 			ret = io_submit_sqes(ctx, to_submit, NULL, -1);
 		mutex_unlock(&ctx->uring_lock);
 		timeout = jiffies + ctx->sq_thread_idle;
+
+		if (time_after(jiffies, timeout_busy))
+			goto sched;
 	}
 
 	if (current->task_works)
-- 
1.8.3.1

