Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E313115D809
	for <lists+io-uring@lfdr.de>; Fri, 14 Feb 2020 14:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729252AbgBNNLp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Feb 2020 08:11:45 -0500
Received: from out4436.biz.mail.alibaba.com ([47.88.44.36]:28531 "EHLO
        out4436.biz.mail.alibaba.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728336AbgBNNLp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Feb 2020 08:11:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01f04428;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0Tpz-n5I_1581685891;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0Tpz-n5I_1581685891)
          by smtp.aliyun-inc.com(127.0.0.1);
          Fri, 14 Feb 2020 21:11:43 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: fix poll_list race for SETUP_IOPOLL|SETUP_SQPOLL
Date:   Fri, 14 Feb 2020 21:11:25 +0800
Message-Id: <20200214131125.3391-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After making ext4 support iopoll method:
  let ext4_file_operations's iopoll method be iomap_dio_iopoll(),
we found fio can easily hang in fio_ioring_getevents() with below fio
job:
    rm -f testfile; sync;
    sudo fio -name=fiotest -filename=testfile -iodepth=128 -thread
-rw=write -ioengine=io_uring  -hipri=1 -sqthread_poll=1 -direct=1
-bs=4k -size=10G -numjobs=8 -runtime=2000 -group_reporting
with IORING_SETUP_SQPOLL and IORING_SETUP_IOPOLL enabled.

There are two issues that results in this hang, one reason is that
when IORING_SETUP_SQPOLL and IORING_SETUP_IOPOLL are enabled, fio
does not use io_uring_enter to get completed events, it relies on
kernel io_sq_thread to poll for completed events.

Another reason is that there is a race: when io_submit_sqes() in
io_sq_thread() submits a batch of sqes, variable 'inflight' will
record the number of submitted reqs, then io_sq_thread will poll for
reqs which have been added to poll_list. But note, if some previous
reqs have been punted to io worker, these reqs will won't be in
poll_list timely. io_sq_thread() will only poll for a part of previous
submitted reqs, and then find poll_list is empty, reset variable
'inflight' to be zero. If app just waits these deferred reqs and does
not wake up io_sq_thread again, then hang happens.

For app that entirely relies on io_sq_thread to poll completed requests,
let io_iopoll_req_issued() wake up io_sq_thread properly when adding new
element to poll_list.

Fixes: 2b2ed9750fc9 ("io_uring: fix bad inflight accounting for SETUP_IOPOLL|SETUP_SQTHREAD")
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 63 +++++++++++++++++++++++++--------------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 77f22c3da30f..fe1fa2d00606 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1793,6 +1793,9 @@ static void io_iopoll_req_issued(struct io_kiocb *req)
 		list_add(&req->list, &ctx->poll_list);
 	else
 		list_add_tail(&req->list, &ctx->poll_list);
+
+	if (ctx->flags & IORING_SETUP_SQPOLL && wq_has_sleeper(&ctx->sqo_wait))
+		wake_up(&ctx->sqo_wait);
 }
 
 static void io_file_put(struct io_submit_state *state)
@@ -5011,9 +5014,9 @@ static int io_sq_thread(void *data)
 	const struct cred *old_cred;
 	mm_segment_t old_fs;
 	DEFINE_WAIT(wait);
-	unsigned inflight;
 	unsigned long timeout;
-	int ret;
+	int ret = 0;
+	bool iopoll = false;
 
 	complete(&ctx->completions[1]);
 
@@ -5021,39 +5024,21 @@ static int io_sq_thread(void *data)
 	set_fs(USER_DS);
 	old_cred = override_creds(ctx->creds);
 
-	ret = timeout = inflight = 0;
+	if (ctx->flags & IORING_SETUP_IOPOLL)
+		iopoll = true;
+	timeout = jiffies + ctx->sq_thread_idle;
 	while (!kthread_should_park()) {
 		unsigned int to_submit;
 
-		if (inflight) {
+		if (!list_empty(&ctx->poll_list)) {
 			unsigned nr_events = 0;
 
-			if (ctx->flags & IORING_SETUP_IOPOLL) {
-				/*
-				 * inflight is the count of the maximum possible
-				 * entries we submitted, but it can be smaller
-				 * if we dropped some of them. If we don't have
-				 * poll entries available, then we know that we
-				 * have nothing left to poll for. Reset the
-				 * inflight count to zero in that case.
-				 */
-				mutex_lock(&ctx->uring_lock);
-				if (!list_empty(&ctx->poll_list))
-					__io_iopoll_check(ctx, &nr_events, 0);
-				else
-					inflight = 0;
-				mutex_unlock(&ctx->uring_lock);
-			} else {
-				/*
-				 * Normal IO, just pretend everything completed.
-				 * We don't have to poll completions for that.
-				 */
-				nr_events = inflight;
-			}
-
-			inflight -= nr_events;
-			if (!inflight)
+			mutex_lock(&ctx->uring_lock);
+			if (!list_empty(&ctx->poll_list))
+				__io_iopoll_check(ctx, &nr_events, 0);
+			if (list_empty(&ctx->poll_list))
 				timeout = jiffies + ctx->sq_thread_idle;
+			mutex_unlock(&ctx->uring_lock);
 		}
 
 		to_submit = io_sqring_entries(ctx);
@@ -5070,7 +5055,7 @@ static int io_sq_thread(void *data)
 			 * more IO, we should wait for the application to
 			 * reap events and wake us up.
 			 */
-			if (inflight ||
+			if (!list_empty(&ctx->poll_list) ||
 			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
 			    !percpu_ref_is_dying(&ctx->refs))) {
 				cond_resched();
@@ -5089,6 +5074,15 @@ static int io_sq_thread(void *data)
 				cur_mm = NULL;
 			}
 
+			if (iopoll) {
+				mutex_lock(&ctx->uring_lock);
+				if (!list_empty(&ctx->poll_list)) {
+					mutex_unlock(&ctx->uring_lock);
+					cond_resched();
+					continue;
+				}
+			}
+
 			prepare_to_wait(&ctx->sqo_wait, &wait,
 						TASK_INTERRUPTIBLE);
 
@@ -5101,16 +5095,22 @@ static int io_sq_thread(void *data)
 			if (!to_submit || ret == -EBUSY) {
 				if (kthread_should_park()) {
 					finish_wait(&ctx->sqo_wait, &wait);
+					if (iopoll)
+						mutex_unlock(&ctx->uring_lock);
 					break;
 				}
 				if (signal_pending(current))
 					flush_signals(current);
+				if (iopoll)
+					mutex_unlock(&ctx->uring_lock);
 				schedule();
 				finish_wait(&ctx->sqo_wait, &wait);
 
 				ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
 				continue;
 			}
+			if (iopoll)
+				mutex_unlock(&ctx->uring_lock);
 			finish_wait(&ctx->sqo_wait, &wait);
 
 			ctx->rings->sq_flags &= ~IORING_SQ_NEED_WAKEUP;
@@ -5119,8 +5119,7 @@ static int io_sq_thread(void *data)
 		mutex_lock(&ctx->uring_lock);
 		ret = io_submit_sqes(ctx, to_submit, NULL, -1, &cur_mm, true);
 		mutex_unlock(&ctx->uring_lock);
-		if (ret > 0)
-			inflight += ret;
+		timeout = jiffies + ctx->sq_thread_idle;
 	}
 
 	set_fs(old_fs);
-- 
2.17.2

