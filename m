Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12C88366EF0
	for <lists+io-uring@lfdr.de>; Wed, 21 Apr 2021 17:19:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhDUPTx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Apr 2021 11:19:53 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:49106 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234573AbhDUPTw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Apr 2021 11:19:52 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R641e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04400;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UWJQea-_1619018351;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UWJQea-_1619018351)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 21 Apr 2021 23:19:18 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH] io_uring: check sqring and iopoll_list before shedule
Date:   Wed, 21 Apr 2021 23:19:11 +0800
Message-Id: <1619018351-75883-1-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

do this to avoid race below:

         userspace                         kernel

                               |  check sqring and iopoll_list
submit sqe                     |
check IORING_SQ_NEED_WAKEUP    |
(which is not set)    |        |
                               |  set IORING_SQ_NEED_WAKEUP
wait cqe                       |  schedule(never wakeup again)

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---

Hi all,
I'm doing some work to reduce cpu usage in low IO pression, and I
removed timeout logic in io_sq_thread() to do some test with fio-3.26,
I found that fio hangs in getevents, inifinitely trying to get a cqe,
While sq-thread is sleeping. It seems there is race situation, and it
is still there even after I fix the issue described above in the commit
message. I doubt it is something to do with memory barrier logic
between userspace and kernel, I'm trying to address it, not many clues
for now.
I'll send the fio config and kernel modification I did for test in
following mail soon.

Thanks,
Hao

 fs/io_uring.c | 36 +++++++++++++++++++-----------------
 1 file changed, 19 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dff34975d86b..042f1149db51 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6802,27 +6802,29 @@ static int io_sq_thread(void *data)
 			continue;
 		}
 
-		needs_sched = true;
 		prepare_to_wait(&sqd->wait, &wait, TASK_INTERRUPTIBLE);
-		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-			if ((ctx->flags & IORING_SETUP_IOPOLL) &&
-			    !list_empty_careful(&ctx->iopoll_list)) {
-				needs_sched = false;
-				break;
-			}
-			if (io_sqring_entries(ctx)) {
-				needs_sched = false;
-				break;
-			}
-		}
-
-		if (needs_sched && !test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
+		if (!test_bit(IO_SQ_THREAD_SHOULD_PARK, &sqd->state)) {
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_set_wakeup_flag(ctx);
 
-			mutex_unlock(&sqd->lock);
-			schedule();
-			mutex_lock(&sqd->lock);
+			needs_sched = true;
+			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+				if ((ctx->flags & IORING_SETUP_IOPOLL) &&
+				    !list_empty_careful(&ctx->iopoll_list)) {
+					needs_sched = false;
+					break;
+				}
+				if (io_sqring_entries(ctx)) {
+					needs_sched = false;
+					break;
+				}
+			}
+
+			if (needs_sched) {
+				mutex_unlock(&sqd->lock);
+				schedule();
+				mutex_lock(&sqd->lock);
+			}
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				io_ring_clear_wakeup_flag(ctx);
 		}
-- 
1.8.3.1

