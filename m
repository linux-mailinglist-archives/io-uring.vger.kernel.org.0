Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56DBB1F0738
	for <lists+io-uring@lfdr.de>; Sat,  6 Jun 2020 17:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726089AbgFFPNJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Jun 2020 11:13:09 -0400
Received: from out30-44.freemail.mail.aliyun.com ([115.124.30.44]:54640 "EHLO
        out30-44.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728614AbgFFPNH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Jun 2020 11:13:07 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04394;MF=xiaoguang.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0U-kT4Fu_1591456374;
Received: from localhost(mailfrom:xiaoguang.wang@linux.alibaba.com fp:SMTPD_---0U-kT4Fu_1591456374)
          by smtp.aliyun-inc.com(127.0.0.1);
          Sat, 06 Jun 2020 23:13:01 +0800
From:   Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
To:     io-uring@vger.kernel.org
Cc:     axboe@kernel.dk, asml.silence@gmail.com,
        joseph.qi@linux.alibaba.com,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Subject: [PATCH] io_uring: execute task_work_run() before dropping mm
Date:   Sat,  6 Jun 2020 23:12:48 +0800
Message-Id: <20200606151248.17663-1-xiaoguang.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.17.2
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While testing io_uring in our internal kernel, note it's not upstream
kernel, we see below panic:
[  872.498723] x29: ffff00002d553cf0 x28: 0000000000000000
[  872.508973] x27: ffff807ef691a0e0 x26: 0000000000000000
[  872.519116] x25: 0000000000000000 x24: ffff0000090a7980
[  872.529184] x23: ffff000009272060 x22: 0000000100022b11
[  872.539144] x21: 0000000046aa5668 x20: ffff80bee8562b18
[  872.549000] x19: ffff80bee8562080 x18: 0000000000000000
[  872.558876] x17: 0000000000000000 x16: 0000000000000000
[  872.568976] x15: 0000000000000000 x14: 0000000000000000
[  872.578762] x13: 0000000000000000 x12: 0000000000000000
[  872.588474] x11: 0000000000000000 x10: 0000000000000c40
[  872.598324] x9 : ffff000008100c00 x8 : 000000007ffff000
[  872.608014] x7 : ffff80bee8562080 x6 : ffff80beea862d30
[  872.617709] x5 : 0000000000000000 x4 : ffff80beea862d48
[  872.627399] x3 : ffff80bee8562b18 x2 : 0000000000000000
[  872.637044] x1 : ffff0000090a7000 x0 : 0000000000208040
[  872.646575] Call trace:
[  872.653139]  task_numa_work+0x4c/0x310
[  872.660916]  task_work_run+0xb0/0xe0
[  872.668400]  io_sq_thread+0x164/0x388
[  872.675829]  kthread+0x108/0x138

The reason is that once io_sq_thread has a valid mm, schedule subsystem
may call task_tick_numa() adding a task_numa_work() callback, which will
visit mm, then above panic will happen.

To fix this bug, only call task_work_run() before dropping mm.

Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
---
 fs/io_uring.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6391a00ff8b7..32381984b2a6 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6134,6 +6134,13 @@ static int io_sq_thread(void *data)
 		 * to enter the kernel to reap and flush events.
 		 */
 		if (!to_submit || ret == -EBUSY) {
+			/*
+			 * Current task context may already have valid mm, that
+			 * means some works that visit mm may have been queued,
+			 * so we must execute the works before dropping mm.
+			 */
+			if (current->task_works)
+				task_work_run();
 			/*
 			 * Drop cur_mm before scheduling, we can't hold it for
 			 * long periods (or over schedule()). Do this before
@@ -6152,8 +6159,6 @@ static int io_sq_thread(void *data)
 			if (!list_empty(&ctx->poll_list) ||
 			    (!time_after(jiffies, timeout) && ret != -EBUSY &&
 			    !percpu_ref_is_dying(&ctx->refs))) {
-				if (current->task_works)
-					task_work_run();
 				cond_resched();
 				continue;
 			}
@@ -6185,11 +6190,7 @@ static int io_sq_thread(void *data)
 					finish_wait(&ctx->sqo_wait, &wait);
 					break;
 				}
-				if (current->task_works) {
-					task_work_run();
-					finish_wait(&ctx->sqo_wait, &wait);
-					continue;
-				}
+
 				if (signal_pending(current))
 					flush_signals(current);
 				schedule();
-- 
2.17.2

